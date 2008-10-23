/*
 * PrintTabFrame.java
 *
 * Created on June 30, 2008, 1:45 PM
 */

package org.reprap.gui.botConsole;

import java.util.*;
import java.text.SimpleDateFormat;
import java.net.URI;
//import java.awt.Desktop; //***AB
//import java.io.IOException;
import javax.swing.JOptionPane;
//import org.reprap.Main;
import org.reprap.Preferences;
import org.reprap.Printer;
import org.reprap.machines.SNAPReprap;

/**
 *
 * @author  ensab
 */
public class PrintTabFrame extends javax.swing.JInternalFrame {
	
	private BotConsoleFrame parentBotConsoleFrame = null;
	private XYZTabPanel xYZTabPanel = null;
    private Printer printer;
    private boolean paused = false;
    private boolean seenSNAP = false;
    private boolean seenGCode = false;
    private long startTime = -1;
    private int oldLayer = -1;
    private String loadedFiles = "";
    private boolean loadedFilesLong = false;
    private boolean stlLoaded = false;
    private boolean gcodeLoaded = false;
    
    /** Creates new form PrintTabFrame */
    public PrintTabFrame() {
        initComponents();
    	String machine = "simulator";
    	simulateRadioButton.setSelected(false);
    	toSNAPRepRapRadioButton.setSelected(false);
    	toGCodeRepRapRadioButton.setSelected(false);
    	gCodeToFileRadioButton.setSelected(false);
    	try
    	{
    		machine = org.reprap.Preferences.loadGlobalString("RepRap_Machine");

    		if(machine.equalsIgnoreCase("simulator"))
    		{
    			simulateRadioButton.setSelected(true);
    		} else if(machine.equalsIgnoreCase("SNAPRepRap"))
    		{
    			toSNAPRepRapRadioButton.setSelected(true);
    			seenSNAP = true;
    		} else if(machine.equalsIgnoreCase("GCodeRepRap"))
    		{
    			if(org.reprap.Preferences.loadGlobalBool("GCodeUseSerial"))
    				toGCodeRepRapRadioButton.setSelected(true);
    			else
    				gCodeToFileRadioButton.setSelected(true);
    			seenGCode = true;
    		} 
    	} catch (Exception e)
    	{
            System.err.println("Failure trying to load 'RepRap_Machine' preference: " + e);
            return;
        }
        
        try {
            interLayerCoolingCheck.setSelected(Preferences.loadGlobalBool("InterLayerCooling"));
        } catch (Exception ex) {
            System.err.println("Warning: could not load InterLayerCooling flag for check box");
            return;
        }
        printer = org.reprap.Main.gui.getPrinter();
    }
    
    public void updateProgress()
    {
    	int layers = org.reprap.Main.gui.getLayers();
    	if(layers <= 0)
    		return;
    	
    	int layer = org.reprap.Main.gui.getLayer();
    	
    	// Only bother if the layer has just changed
    	
    	if(layer == oldLayer)
    		return;
    	
    	oldLayer = layer;

    	currentLayerOutOfN.setText("" + layer + "/" + layers);
 
    	progressBar.setMinimum(0);
    	progressBar.setMaximum(layers);
    	progressBar.setValue(layer);
    	
    	GregorianCalendar cal = new GregorianCalendar();
    	SimpleDateFormat dateFormat = new SimpleDateFormat("EE HH:mm");
    	Date d = cal.getTime();
		long e = d.getTime() + cal.getTimeZone().getOffset(d.getTime());
    	if(startTime < 0)
    	{
    		startTime = e;
    		return;
    	}
    	
    	if(layer <= 0)
    		return;
    	
    	long f = (layers*(e - startTime))/(layer);
    	int h = (int)(f/60000)/60;
    	int m = (int)(f/60000)%60;
    	
    	// No idea why this next bit doesn't work...
    	//if(cal.getTimeZone().inDaylightTime(d))
    	//{
    		//f = f + 3600000;
    		//System.out.println("DST");
    	//}
    	if(m > 9)
    		expectedBuildTime.setText("" + h + ":" + m);
    	else
    		expectedBuildTime.setText("" + h + ":0" + m);
    	expectedFinishTime.setText(dateFormat.format(new Date(startTime + f)));
    }
    
    /**
     * So the BotConsoleFrame can let us know who it is
     * @param b
     */
    public void setFrames(BotConsoleFrame b, XYZTabPanel xyz)
    {
    	parentBotConsoleFrame = b;
    	xYZTabPanel = xyz;
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        buttonGroup1 = new javax.swing.ButtonGroup();
        printButton = new java.awt.Button();
        pauseButton = new java.awt.Button();
        stopButton = new java.awt.Button();
        exitButton = new java.awt.Button();
        layerPauseCheck = new javax.swing.JCheckBox();
        toSNAPRepRapRadioButton = new javax.swing.JRadioButton();
        simulateRadioButton = new javax.swing.JRadioButton();
        interLayerCoolingCheck = new javax.swing.JCheckBox();
        getWebPage = new javax.swing.JButton();
        expectedBuildTimeLabel = new javax.swing.JLabel();
        hoursMinutesLabel1 = new javax.swing.JLabel();
        expectedBuildTime = new javax.swing.JLabel();
        expectedFinishTimeLabel = new javax.swing.JLabel();
        expectedFinishTime = new javax.swing.JLabel();
        progressLabel = new javax.swing.JLabel();
        currentLayerOutOfN = new javax.swing.JLabel();
        progressBar = new javax.swing.JProgressBar();
        loadSTL = new java.awt.Button();
        loadGCode = new java.awt.Button();
        gCodeToFileRadioButton = new javax.swing.JRadioButton();
        loadRFO = new java.awt.Button();
        toGCodeRepRapRadioButton = new javax.swing.JRadioButton();
        fileNameBox = new javax.swing.JLabel();
        preferencesButton = new java.awt.Button();

        printButton.setBackground(new java.awt.Color(51, 204, 0));
        printButton.setFont(printButton.getFont());
        printButton.setLabel("Print"); // NOI18N
        printButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                printButtonActionPerformed(evt);
            }
        });

        pauseButton.setBackground(new java.awt.Color(255, 204, 0));
        pauseButton.setLabel("Pause"); // NOI18N
        pauseButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                pauseButtonActionPerformed(evt);
            }
        });

        stopButton.setBackground(new java.awt.Color(255, 0, 0));
        stopButton.setFont(new java.awt.Font("Dialog", 1, 12));
        stopButton.setLabel("STOP !"); // NOI18N
        stopButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                stopButtonActionPerformed(evt);
            }
        });

        exitButton.setLabel("Exit");
        exitButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                exitButtonActionPerformed(evt);
            }
        });

        layerPauseCheck.setText("Pause at end of layer"); // NOI18N
        layerPauseCheck.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                layerPauseCheckActionPerformed(evt);
            }
        });

        buttonGroup1.add(toSNAPRepRapRadioButton);
        toSNAPRepRapRadioButton.setText("Print on SNAP RepRap");
        toSNAPRepRapRadioButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                selectorRadioButtonMousePressed(evt);
            }
        });

        buttonGroup1.add(simulateRadioButton);
        simulateRadioButton.setText("Simulate");
        simulateRadioButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                selectorRadioButtonMousePressed(evt);
            }
        });

        interLayerCoolingCheck.setSelected(true);
        interLayerCoolingCheck.setText("Inter-layer cooling");
        interLayerCoolingCheck.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                interLayerCoolingCheckMouseClicked(evt);
            }
        });

        getWebPage.setIcon(new javax.swing.ImageIcon(getClass().getResource("/org/reprap/gui/botConsole/rr-logo-green-url.png"))); // NOI18N
        getWebPage.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                getWebPageActionPerformed(evt);
            }
        });

        expectedBuildTimeLabel.setFont(new java.awt.Font("Tahoma", 0, 12));
        expectedBuildTimeLabel.setText("Expected build time:"); // NOI18N

        hoursMinutesLabel1.setFont(new java.awt.Font("Tahoma", 0, 12));
        hoursMinutesLabel1.setText("(h:m)"); // NOI18N

        expectedBuildTime.setFont(new java.awt.Font("Tahoma", 0, 12));
        expectedBuildTime.setText("00:00"); // NOI18N

        expectedFinishTimeLabel.setFont(new java.awt.Font("Tahoma", 0, 12));
        expectedFinishTimeLabel.setText("Expected to finsh at:"); // NOI18N

        expectedFinishTime.setFont(new java.awt.Font("Tahoma", 0, 12));
        expectedFinishTime.setText("    -"); // NOI18N

        progressLabel.setFont(new java.awt.Font("Tahoma", 0, 12));
        progressLabel.setText("Layer progress:"); // NOI18N

        currentLayerOutOfN.setFont(new java.awt.Font("Tahoma", 0, 12));
        currentLayerOutOfN.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        currentLayerOutOfN.setText("000/000"); // NOI18N

        loadSTL.setActionCommand("loadSTL");
        loadSTL.setBackground(new java.awt.Color(0, 204, 255));
        loadSTL.setLabel("Load STL"); // NOI18N
        loadSTL.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                loadSTL(evt);
            }
        });

        loadGCode.setActionCommand("loadGCode");
        loadGCode.setBackground(new java.awt.Color(0, 204, 255));
        loadGCode.setLabel("Load GCode"); // NOI18N
        loadGCode.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                LoadGCode(evt);
            }
        });

        buttonGroup1.add(gCodeToFileRadioButton);
        gCodeToFileRadioButton.setText("Send GCodes to file");
        gCodeToFileRadioButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                selectorRadioButtonMousePressed(evt);
            }
        });

        loadRFO.setActionCommand("loadRFO");
        loadRFO.setBackground(new java.awt.Color(153, 153, 153));
        loadRFO.setLabel("Load RFO"); // NOI18N
        loadRFO.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                loadRFO(evt);
            }
        });

        buttonGroup1.add(toGCodeRepRapRadioButton);
        toGCodeRepRapRadioButton.setText("Print on G-Code RepRap");
        toGCodeRepRapRadioButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                selectorRadioButtonMousePressed(evt);
            }
        });

        fileNameBox.setFont(new java.awt.Font("Tahoma", 0, 12));
        fileNameBox.setText(" - ");

        preferencesButton.setActionCommand("preferences");
        preferencesButton.setBackground(new java.awt.Color(255, 102, 255));
        preferencesButton.setLabel("Preferences"); // NOI18N
        preferencesButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                preferences(evt);
            }
        });

        org.jdesktop.layout.GroupLayout layout = new org.jdesktop.layout.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(layout.createSequentialGroup()
                .addContainerGap()
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                    .add(layout.createSequentialGroup()
                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                            .add(loadGCode, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 100, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                            .add(loadRFO, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 100, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                            .add(loadSTL, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 100, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                            .add(toSNAPRepRapRadioButton)
                            .add(gCodeToFileRadioButton)
                            .add(simulateRadioButton)
                            .add(toGCodeRepRapRadioButton))
                        .add(22, 22, 22)
                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                            .add(layout.createSequentialGroup()
                                .add(printButton, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 72, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                                .add(pauseButton, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 61, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                                .add(stopButton, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 75, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                                .add(exitButton, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 62, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                            .add(layout.createSequentialGroup()
                                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                                    .add(layerPauseCheck)
                                    .add(interLayerCoolingCheck)
                                    .add(preferencesButton, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                                .add(getWebPage, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 190, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))))
                    .add(layout.createSequentialGroup()
                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                            .add(expectedBuildTimeLabel)
                            .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.TRAILING)
                                .add(progressLabel)
                                .add(expectedFinishTimeLabel)))
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING, false)
                            .add(layout.createSequentialGroup()
                                .add(expectedBuildTime)
                                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                                .add(hoursMinutesLabel1)
                                .addPreferredGap(org.jdesktop.layout.LayoutStyle.UNRELATED)
                                .add(fileNameBox, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                            .add(expectedFinishTime)
                            .add(layout.createSequentialGroup()
                                .add(currentLayerOutOfN)
                                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                                .add(progressBar, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 430, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)))))
                .addContainerGap(24, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(layout.createSequentialGroup()
                .addContainerGap()
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                    .add(org.jdesktop.layout.GroupLayout.TRAILING, layout.createSequentialGroup()
                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
                            .add(layout.createSequentialGroup()
                                .add(layerPauseCheck)
                                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                                .add(interLayerCoolingCheck)
                                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                                .add(preferencesButton, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                            .add(getWebPage, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 72, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING, false)
                            .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.TRAILING)
                                .add(exitButton, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 39, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                                .add(stopButton, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 39, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))
                            .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.TRAILING)
                                .add(pauseButton, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 39, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                                .add(printButton, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 39, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE))))
                    .add(layout.createSequentialGroup()
                        .add(toSNAPRepRapRadioButton)
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(toGCodeRepRapRadioButton)
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(gCodeToFileRadioButton)
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(simulateRadioButton))
                    .add(layout.createSequentialGroup()
                        .add(loadSTL, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 41, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(loadGCode, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 41, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(loadRFO, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, 41, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)))
                .add(18, 18, 18)
                .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.TRAILING)
                    .add(layout.createSequentialGroup()
                        .add(expectedBuildTimeLabel)
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(expectedFinishTimeLabel)
                        .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                        .add(progressLabel))
                    .add(layout.createSequentialGroup()
                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.BASELINE)
                            .add(expectedBuildTime)
                            .add(hoursMinutesLabel1)
                            .add(fileNameBox))
                        .add(layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING, false)
                            .add(layout.createSequentialGroup()
                                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                                .add(expectedFinishTime)
                                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED)
                                .add(currentLayerOutOfN))
                            .add(org.jdesktop.layout.GroupLayout.TRAILING, layout.createSequentialGroup()
                                .addPreferredGap(org.jdesktop.layout.LayoutStyle.RELATED, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .add(progressBar, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, org.jdesktop.layout.GroupLayout.PREFERRED_SIZE)
                                .add(9, 9, 9)))))
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

private void printButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_printButtonActionPerformed
    parentBotConsoleFrame.suspendPolling();
    org.reprap.Main.gui.onProduceB();
}//GEN-LAST:event_printButtonActionPerformed

public void pauseAction()
{
    paused = !paused;
    if(paused)
    {
    	pauseButton.setLabel("Pausing...");
    	org.reprap.Main.gui.pause();
        pauseButton.setLabel("Resume");
        parentBotConsoleFrame.resumePolling();
    } else
    {
    	org.reprap.Main.gui.resume();
        pauseButton.setLabel("Pause");
        parentBotConsoleFrame.suspendPolling();
    }   
}

private void pauseButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_pauseButtonActionPerformed
    pauseAction();
}//GEN-LAST:event_pauseButtonActionPerformed

private void stopButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_stopButtonActionPerformed
org.reprap.Main.gui.clickCancel();
}//GEN-LAST:event_stopButtonActionPerformed

private void exitButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_exitButtonActionPerformed
	printer.dispose();
	System.exit(0);
}//GEN-LAST:event_exitButtonActionPerformed

private void layerPauseCheckActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_layerPauseCheckActionPerformed
org.reprap.Main.gui.setLayerPause(layerPauseCheck.isSelected());
}//GEN-LAST:event_layerPauseCheckActionPerformed

private void selectorRadioButtonMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_selectorRadioButtonMousePressed
	
	String machine = "simulator";
	boolean closeMessage = false;
	try
	{
		machine = org.reprap.Preferences.loadGlobalString("RepRap_Machine");


		if(evt.getSource() == simulateRadioButton)
		{
			org.reprap.Preferences.setGlobalString("RepRap_Machine", "simulator");
		} else if(evt.getSource() == toSNAPRepRapRadioButton)
		{
			org.reprap.Preferences.setGlobalString("RepRap_Machine", "SNAPRepRap");
			if(seenGCode)
				closeMessage = true;
			seenSNAP = true;
		} else if(evt.getSource() == toGCodeRepRapRadioButton)
		{
			org.reprap.Preferences.setGlobalString("RepRap_Machine", "GCodeRepRap");
			org.reprap.Preferences.setGlobalString("GCodeUseSerial", "true");
			if(seenSNAP)
				closeMessage = true;
			seenGCode = true;
		} else if(evt.getSource() == gCodeToFileRadioButton)
		{
			org.reprap.Preferences.setGlobalString("RepRap_Machine", "GCodeRepRap");
			org.reprap.Preferences.setGlobalString("GCodeUseSerial", "false");
			if(seenSNAP)
				closeMessage = true;
			seenGCode = true;
		}
		org.reprap.Preferences.saveGlobal();
		printer.refreshPreferences();
		if(!closeMessage)
			return;
		JOptionPane.showMessageDialog(null, "As you have changed the type of RepRap machine you are using,\nyou will have to exit this program and run it again.");
	} catch (Exception ex)
	{
		JOptionPane.showMessageDialog(null, "Could not get preference 'RepRap_Machine'");
	}
}//GEN-LAST:event_selectorRadioButtonMousePressed

private void interLayerCoolingCheckMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_interLayerCoolingCheckMouseClicked
try {
        org.reprap.Preferences.setGlobalBool("InterLayerCooling", interLayerCoolingCheck.isSelected());
//        System.out.println(Preferences.loadGlobalBool("InterLayerCooling"));
    }
    catch (Exception e) {
        JOptionPane.showMessageDialog(null, "Could not set 'InterLayerCooling' preference flag");
    }
}//GEN-LAST:event_interLayerCoolingCheckMouseClicked

private void getWebPageActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_getWebPageActionPerformed
try {
            URI url = new URI("http://reprap.org");
            //Desktop.getDesktop().browse(url);//***AB
        } catch(Exception e) {
            e.printStackTrace();
        }
}//GEN-LAST:event_getWebPageActionPerformed

private void loadSTL(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_loadSTL
	if(gcodeLoaded)
	{
		JOptionPane.showMessageDialog(null, "This will cancel the G Code file you loaded.");
		loadedFiles = "";
	}
	String fn = printer.addSTLFileForMaking();
	
	if(loadedFilesLong)
		return;
	if(loadedFiles.length() > 50)
	{
		loadedFiles += "...";
		loadedFilesLong = true;
	} else
		loadedFiles += fn + " ";
	
	fileNameBox.setText(loadedFiles);
	stlLoaded = true;
	gcodeLoaded = false;
}//GEN-LAST:event_loadSTL

private void LoadGCode(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_LoadGCode
	if(seenSNAP)
	{
		JOptionPane.showMessageDialog(null, "Sorry.  Sending G Codes to SNAP RepRap machines is not yet implemented.");
		return;
	}
	try
	{
		if(!org.reprap.Preferences.loadGlobalBool("GCodeUseSerial"))
		{
			JOptionPane.showMessageDialog(null, "There is no point in sending a G Code file to a G Code file.");
			return;
		}
	} catch (Exception e)
	{
		System.err.println("Preference GCodeUseSerial not found in preferences file.");
		return;
	}
	if(stlLoaded)
	{
		JOptionPane.showMessageDialog(null, "This will cancel the STL file(s) you loaded.");
		org.reprap.Main.gui.deleteAllSTLs();
		loadedFiles = "";
	}
	if(gcodeLoaded)
	{
		JOptionPane.showMessageDialog(null, "This will cancel the previous G Code file you loaded.");
		loadedFiles = "";
	}
	loadedFiles = printer.loadGCodeFileForMaking();
	fileNameBox.setText(loadedFiles);
	gcodeLoaded = true;
	stlLoaded = false;
}//GEN-LAST:event_LoadGCode

private void loadRFO(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_loadRFO
	//fileNameBox.setText("-");
	JOptionPane.showMessageDialog(null, "RFO files not yet supported.  But see http://reprap.org/bin/view/Main/MultipleMaterialsFiles");
}//GEN-LAST:event_loadRFO

private void preferences(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_preferences
	org.reprap.gui.Preferences prefs = new org.reprap.gui.Preferences();
	prefs.setVisible(true);	// prefs.show();
}//GEN-LAST:event_preferences


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.JLabel currentLayerOutOfN;
    private java.awt.Button exitButton;
    private javax.swing.JLabel expectedBuildTime;
    private javax.swing.JLabel expectedBuildTimeLabel;
    private javax.swing.JLabel expectedFinishTime;
    private javax.swing.JLabel expectedFinishTimeLabel;
    private javax.swing.JLabel fileNameBox;
    private javax.swing.JRadioButton gCodeToFileRadioButton;
    private javax.swing.JButton getWebPage;
    private javax.swing.JLabel hoursMinutesLabel1;
    private javax.swing.JCheckBox interLayerCoolingCheck;
    private javax.swing.JCheckBox layerPauseCheck;
    private java.awt.Button loadGCode;
    private java.awt.Button loadRFO;
    private java.awt.Button loadSTL;
    private java.awt.Button pauseButton;
    private java.awt.Button preferencesButton;
    private java.awt.Button printButton;
    private javax.swing.JProgressBar progressBar;
    private javax.swing.JLabel progressLabel;
    private javax.swing.JRadioButton simulateRadioButton;
    private java.awt.Button stopButton;
    private javax.swing.JRadioButton toGCodeRepRapRadioButton;
    private javax.swing.JRadioButton toSNAPRepRapRadioButton;
    // End of variables declaration//GEN-END:variables

}
