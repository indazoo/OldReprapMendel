import processing.serial.*;


// The serial port
Serial myPort;
String serialLine = "";

boolean started = false;
boolean finished = false;
boolean commandComplete = true;
int commandCount = 0;

String temperature = "?";

String gcode[] = {
};
int gcodeIndex = 0;

PFont font;

void setup()
{
  //init stuff
  size(1024, 600);
  //smooth();

  // List all the available serial ports
  println(Serial.list());
  //open the first port...
  myPort = new Serial(this, Serial.list()[0], 19200);

  //load our gcode lines
  gcode = loadStrings("job.gcode");
  //println(gcode);

  font = loadFont("ArialMT-48.vlw"); 
}

void draw()
{
  background(20, 20, 20);

  while (myPort.available() > 0)
  {
    int inByte = myPort.read();

    if (inByte == '\n')
    {
      println("Got: " + serialLine);

      String m[] = match(serialLine, "^T:([0-9]+)");
      ;
      if (m != null)
        temperature = m[0];

      if (match(serialLine, "^start") != null)
        started = true;

      if (match(serialLine, "^ok") != null)
      {
        commandComplete = true;

        if (gcodeIndex == gcode.length)
          println("Job's done!");
      }

      serialLine = "";
    }
    else if (inByte > 0)
    {
      serialLine += (char)inByte;
    }
  }

  if (started)
  {
    if (commandComplete)
    {
      String cmd = getNextCommand();
      commandComplete = false;

      if (gcodeIndex == gcode.length)
      {
        finished = true;
      }
      
      if (cmd != null)
      {
        println("Sent: " +cmd);
        myPort.write(cmd);
      }
    }
  }
  
  if (started && finished)
  {
    println("Job's done!");
    started = false;
    finished = false;
  }

  
  textFont(font, 16);
  String temp = "Temperature: " + temperature + "C";
  text(temp, 10, 20);
}

String getNextCommand()
{
  if (gcodeIndex < gcode.length)
  {

    String c = gcode[gcodeIndex];
    gcodeIndex++;

    /*
  if (match(c, "^...") != null)
     {
     String comment = "Comment: " + c;
     println(comment); 
     }
     */

    if (match(c, "^[A-Z]{1}") == null)
      c = getNextCommand();

    return c;
  }
  else
    return null;
}
