package org.reprap.comms;

import javax.swing.JFileChooser;
import javax.swing.filechooser.FileFilter;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.OutputStream;
import java.io.PrintStream;

import gnu.io.CommPortIdentifier;
import gnu.io.NoSuchPortException;
import gnu.io.PortInUseException;
import gnu.io.SerialPort;
import gnu.io.UnsupportedCommOperationException;

import org.reprap.utilities.Debug;
import org.reprap.utilities.ExtensionFileFilter;
import org.reprap.Preferences;

public class GCodeReaderAndWriter
{
	
	/**
	 * The name of the port talking to the RepRap machine
	 */
	String portName;
	
	/**
	* this is if we need to talk over serial
	*/
	private SerialPort port;
	
	/**
	 * Flag to tell it we've finished
	 */
	private boolean exhaustBuffer = false;
	
	/**
	* this is for doing easy serial writes
	*/
	private PrintStream serialOutStream = null;
	
	/**
	 * this is our read handle on the serial port
	 */
	private InputStream serialInStream = null;
	
	/**
	 * This is used for file input
	 */
	private BufferedReader fileInStream = null;
	
	/**
	 * This is for file output
	 */
	private PrintStream fileOutStream = null;
	
	/**
	 * The ring buffer that stores the commands for direct
	 * transmission to the RepRap machine.
	 */
	private int head, tail;
	private static final int buflen = 10; // Too long and pause doesn't work well
	private String[] ringBuffer;
	
	/**
	 * The transmission to the RepRap machine is handled by
	 * a separate thread.  These control that.
	 */
	private boolean threadLock = false;
	private Thread bufferThread;
	private int myPriority;
	
	/**
	 * Some commands (at the moment just M105 - get temperature) generate
	 * a response.  Return that as a string.
	 */
	private int responsesExpected = 0;
	private boolean responseAvailable = false;
	private String response;
	
	//private boolean sendFileToMachine = false;
		
	public GCodeReaderAndWriter()
	{

		ringBuffer = new String[buflen];
		head = 0;
		tail = 0;
		threadLock = false;
		exhaustBuffer = false;
		responsesExpected = 0;
		responseAvailable = false;
		response = "0000";
		try
		{
			portName = Preferences.loadGlobalString("Port(name)");
		} catch (Exception ex)
		{
			System.err.println("Cannot load preference Port(name).");
			portName = "stdout";
		}

		openSerialConnection(portName);

		myPriority = Thread.currentThread().getPriority();

		bufferThread = null;
		
		if(serialOutStream != null)
		{
			bufferThread = new Thread() 
			{
				public void run() 
				{
					Thread.currentThread().setName("GCodeWriter() Buffer Thread");
					bufferDeQueue();
				}
			};

			bufferThread.start();
		}
	}

	
	public boolean buildingFromFile()
	{
		return fileInStream != null;
	}
	
	public boolean savingToFile()
	{
		return fileOutStream != null;
	}

	
	/**
	 * Start the production run
	 * (as opposed to driving the machine interactively).
	 */
	public void startRun()
	{
		if(fileOutStream != null)
		{
			// Exhause buffer before we start.
			if(bufferThread != null)
			{
				exhaustBuffer = true;
				while(exhaustBuffer) sleep(200);
			}
		}	
	}
	
	/**
	 * Send a GCode file to the machine
	 *
	 */
	public void playFile()
	{
		if(fileInStream == null)
		{
			System.err.println("GCodeWriter: attempt to read from non-existent file.");
			return;
		}
		
		if(bufferThread == null)
		{
			System.err.println("GCodeWriter: attempt to write to non-existent buffer.");
			return;
		}			
		
		String line;
		try 
		{
	        while ((line = fileInStream.readLine()) != null) 
	        {
	        	bufferQueue(line);
	        }
	        fileInStream.close();
	    } catch (IOException e) 
	    {  }
	}
	
	/**
	 * Wrapper for Thread.sleep()
	 * @param millis
	 */
	public void sleep(int millis)
	{
		try
		{
			Thread.sleep(millis);
		} catch (Exception ex)
		{}		
	}
	
	/**
	 * All done.
	 *
	 */
	public void finish()
	{
		Debug.c("disposing of gcodewriter.");
		
		// Wait for the ring buffer to be exhausted
		if(fileOutStream == null && bufferThread != null)
		{
			exhaustBuffer = true;
			while(exhaustBuffer) sleep(200);
		}
		
		try
		{
			if (serialInStream != null)
				serialInStream.close();

			if (serialOutStream != null)
				serialOutStream.close();
			
			if (fileInStream != null)
				fileInStream.close();
			
			if (fileOutStream != null)
				fileOutStream.close();
		} catch (Exception e) {}
	}
	
	/**
	 * Anything in the buffer?  (NB this still works if we aren't
	 * using the buffer as then head == tail == 0 always).
	 * @return
	 */
	public boolean bufferEmpty()
	{
		return head == tail;
	}
	
	/**
	 * Between layers othing will be queued.  Use the next two
	 * functions to stop and start the buffer spinning.
	 *
	 */
	public void slowBufferThread()
	{
		if(bufferThread != null)
			bufferThread.setPriority(1);
	}
	
	public void speedBufferThread()
	{
		if(bufferThread != null)		
			bufferThread.setPriority(myPriority);
	}	
	
	/**
	 * Queue a command into the ring buffer.  Note the use of prime time periods
	 * in the following code.  That's probably just superstition, but it feels more robust...
	 * @param cmd
	 */
	private void bufferQueue(String cmd)
	{
		// Are we locked out by the transmit thread?
		while(threadLock) sleep(211);
		// Lock out the transmit thread
		threadLock = true;
		// Next location in the ring
		head++;
		if(head >= buflen) head = 0;
		// Have we collided with the tail (i.e. is the ring full)?
		while(head == tail-1 || (tail == 0 && head == buflen-1))
		{
			// Release the lock so the transmit thread can get rid of stuff
			threadLock = false;
			sleep(223);
		}
		// Record the command in the buffer
		ringBuffer[head] = cmd;
		threadLock = false;
		Debug.c("G-code: " + cmd + " queued");
	}
	
	/**
	 * Loop getting the next thing in the buffer and transmitting it 
	 * (or waiting for something to send if there's nothing there).
	 *
	 */
	private void bufferDeQueue()
	{
		for(;;)
		{
			// Are we locked out by the queuing thread?
			while(threadLock) sleep(29);
			// Wait for something to be there to send
			while(head == tail)
			{
				// If nothing more is ever coming, finish
				if(exhaustBuffer)
				{
					exhaustBuffer = false;
					return;
				}
				sleep(211);
			}
			// Lock out the queuing thread
			threadLock = true;
			// Pick up the next command in the buffer
			tail++;
			if(tail >= buflen) tail = 0;
			// Strip any comment and send the command to the machine
			String cmd = ringBuffer[tail];
			int com = cmd.indexOf(';');
			if(com > 0)
				cmd = cmd.substring(0, com);
			if(com != 0)
			{
				cmd = cmd.trim();
				serialOutStream.print(cmd + "\n");
				// Message has effectively gone to the machine, so we can release the queuing thread
				threadLock = false;				
				serialOutStream.flush();
				Debug.c("G-code: " + cmd + " dequeued and sent");
				// Wait for the machine to respond before we send the next command
				waitForOK();
			} else
				Debug.c("G-code: " + ringBuffer[tail] + " not sent");
			// Just for safety
			threadLock = false;
			// We are running at high priority - give others a look in
			//sleep(7);
		}
	}

	/**
	 * Wait for the GCode interpreter in the RepRap machine to send back "ok\n".
	 *
	 */
	private void waitForOK()
	{
		int i, count;
		String resp = "";
		count = 0;
		
		for(;;)
		{
			try
			{
				i = serialInStream.read();
			} catch (Exception e)
			{
				i = -1;
			}

			//anything found?
			if (i >= 0)
			{
				char c = (char)i;

				//is it at the end of the line?
				if (c == '\n' || c == '\r')
				{
					if (resp.startsWith("ok"))
					{
						Debug.c("GCode acknowledged");
						return;
					} else if (resp.startsWith("T:"))
					{
						Debug.c("GCodeWriter.waitForOK() - temperature reading: " + resp);
						if(responsesExpected > 0)
						{
							response = resp;
							responseAvailable = true;
						} else
							System.err.println("GCodeWriter.waitForOK(): temperature response returned when none expected.");
					} 
					else if (resp.startsWith("start") || resp.contentEquals(""))
					{	
						// That was the reset string from the machine or a null line; ignore it.
					}else
					{
						//Gone wrong.  Start again.
						Debug.c("GCodeWriter.waitForOK() dud response: " + resp);
						count++;
						if(count >= 3)
						{
							System.err.println("GCodeWriter.waitForOK(): try count exceeded.  Last line received was: " + resp);
							return;
						}
					}
					// If we get here we need a new string
					resp = "";
				} else
					resp += c;
				// We are running at high priority; give others a look in
				//sleep(5);
			}
		}
	}
	
	/**
	 * Send a G-code command to the machine or into a file.
	 * @param cmd
	 */
	public void queue(String cmd)
	{
		//trim it and cleanup.
		cmd = cmd.trim();
		cmd = cmd.replaceAll("  ", " ");
		
		//add to list.
		//commands.add(cmd);
		
		if(fileOutStream != null)
		{
			fileOutStream.println(cmd);
			Debug.c("G-code: " + cmd + " written to file");
		} else
			bufferQueue(cmd);
	}
	
	/**
	 * Send a G-code command to the machine and return
	 * a response.
	 * @param cmd
	 */
	public String queueRespond(String cmd)
	{
		//trim it and cleanup.
		cmd = cmd.trim();
		cmd = cmd.replaceAll("  ", " ");
		
		if (fileOutStream != null)
		{
			System.err.println("GCodeWriter.queueRespond() called when file being created.");
			return "0000"; // Safest compromise
		}
		responsesExpected++;
		bufferQueue(cmd);
		if(responsesExpected <= 0)
		{
			System.err.println("GCodeWriter.getResponse() called when no response expected.");
			responsesExpected = 0;
			responseAvailable = false;
			return "0000";
		}
		while(!responseAvailable) sleep(31);
		responseAvailable = false;
		responsesExpected--;
		return response;		
	}
	

	private void openSerialConnection(String portName)
	{
		
		int baudRate = 19200;
		serialInStream = null;
		serialOutStream = null;
		
		//open our port.
		Debug.c("GCode opening port " + portName);
		try 
		{
			CommPortIdentifier commId = CommPortIdentifier.getPortIdentifier(portName);
			port = (SerialPort)commId.open(portName, 30000);
		} catch (NoSuchPortException e) {
			System.err.println("Error opening port: " + portName);
			return;
		}
		catch (PortInUseException e){
			System.err.println("Port '" + portName + "' is already in use.");
			return;			
		}
		
		//get our baudrate
		try {
			baudRate = Preferences.loadGlobalInt("BaudRate");
		}
		catch (IOException e){}
		
		// Workround for javax.comm bug.
		// See http://forum.java.sun.com/thread.jspa?threadID=673793
		// FIXME: jvandewiel: is this workaround also needed when using the RXTX library?
		try {
			port.setSerialPortParams(baudRate,
					SerialPort.DATABITS_8,
					SerialPort.STOPBITS_1,
					SerialPort.PARITY_NONE);
		}
		catch (UnsupportedCommOperationException e) {
			Debug.c("An unsupported comms operation was encountered.");
			return;		
		}

/*			 
		port.setSerialPortParams(baudRate,
				SerialPort.DATABITS_8,
				SerialPort.STOPBITS_1,
				SerialPort.PARITY_NONE);
*/		
		// End of workround
		
		try {
			port.setFlowControlMode(SerialPort.FLOWCONTROL_NONE);
		} catch (Exception e) {
			// Um, Linux USB ports don't do this. What can I do about it?
		}
		
		try {
			port.enableReceiveTimeout(1);
		} catch (UnsupportedCommOperationException e) {
			Debug.c("Read timeouts unsupported on this platform");
		}

		//create our steams
		try {
			OutputStream writeStream = port.getOutputStream();
			serialInStream = port.getInputStream();
			serialOutStream = new PrintStream(writeStream);
		} catch (IOException e) {
			System.err.println("GCodeWriter: Error opening serial port stream.");
			serialInStream = null;
			serialOutStream = null;
			return;		
		}

		//arduino bootloader skip.
		Debug.c("Attempting to initialize Arduino");
        try {Thread.sleep(1000);} catch (Exception e) {}
        for(int i = 0; i < 10; i++)
                serialOutStream.write('0');
        try {Thread.sleep(1000);} catch (Exception e) {}
        
        return;
	}
	
	private String setGCodeFileForOutput()
	{
		JFileChooser chooser = new JFileChooser();
		FileFilter filter;
		filter = new ExtensionFileFilter("G Code file to write to", new String[] { "gcode" });
		chooser.setFileFilter(filter);
		chooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
		//chooser.setCurrentDirectory();

		int result = chooser.showSaveDialog(null);
		if (result == JFileChooser.APPROVE_OPTION)
		{
			String name = chooser.getSelectedFile().getAbsolutePath();

			try
			{
				Debug.c("opening: " + name);
				FileOutputStream fileStream = new FileOutputStream(name);
				fileOutStream = new PrintStream(fileStream);
			} catch (FileNotFoundException e) {
				System.err.println("Can't write to file '" + name);
				fileOutStream = null;
				return null;
			}
		}
		else
		{
			fileOutStream = null;
			return null;
		}
		return chooser.getName();
	}
	
	public String loadGCodeFileForMaking()
	{
		JFileChooser chooser = new JFileChooser();
        FileFilter filter;
        filter = new ExtensionFileFilter("G Code file to be read", new String[] { "gcode" });
        chooser.setFileFilter(filter);
		chooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
		//chooser.setCurrentDirectory();

		int result = chooser.showOpenDialog(null);
		if (result == JFileChooser.APPROVE_OPTION)
		{
			String name = chooser.getSelectedFile().getAbsolutePath();
			try
			{
				Debug.c("opening: " + name);
				fileInStream = new BufferedReader(new FileReader(name));
			} catch (FileNotFoundException e) 
			{
				System.err.println("Can't read file " + name);
				fileInStream = null;
				return null;
			}
		} else
		{
			Debug.c("Can't write to file.");
			fileInStream = null;
			return null;
		}

		return chooser.getName();
	}
}