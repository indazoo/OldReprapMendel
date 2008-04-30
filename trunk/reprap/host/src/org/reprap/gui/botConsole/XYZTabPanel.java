/*
 * 
 * !!!!!
 * NOTE: PLEASE ONLY EDIT THIS USING THE NETBEANS IDE 6.0.1 OR HIGHER!!!!
 * !!!!!
 * 
 * ... an .xml file is associated with this class. Cheers.
 * 
 * XYZTabPanel.java
 *
 * Created on 27 March 2008, 14:52
 */

package org.reprap.gui.botConsole;

import java.io.IOException;
import javax.swing.JOptionPane;
import org.reprap.Preferences;

/**
 *
 * @author  en0es
 */
public class XYZTabPanel extends javax.swing.JPanel {
    
    private int XYfastSpeed;
    private int ZfastSpeed;
    
    /** Creates new form XYZTabPanel */
    public XYZTabPanel() {
   
        initComponents(); 
        bedPanel1.setDimensions();
        
        try {
            setPrefs(); 
        }
        catch (Exception e) {
            System.out.println("Failure trying to initialise preferences: " + e);
            JOptionPane.showMessageDialog(null, e.getMessage());
            return;
        }
        
        setMotorSpeeds();
        setNudgeSize(Double.parseDouble(nudgeSizeRB1.getText()));
    }
    
    public void setMotorSpeeds() {
        
        genericStepperPositionPanel1.setSpeed();
        genericStepperPositionPanel2.setSpeed();
        genericStepperPositionPanel3.setSpeed();
        
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        buttonGroup1 = new javax.swing.ButtonGroup();
        jSlider1 = new javax.swing.JSlider();
        jSlider2 = new javax.swing.JSlider();
        jPanel2 = new javax.swing.JPanel();
        nudgeSizeRB1 = new javax.swing.JRadioButton();
        nudgeSizeRB2 = new javax.swing.JRadioButton();
        nudgeSizeRB3 = new javax.swing.JRadioButton();
        jPanel3 = new javax.swing.JPanel();
        goButton = new javax.swing.JButton();
        plotCheck = new javax.swing.JCheckBox();
        extruderToPlot = new javax.swing.JTextField();
        genericStepperPositionPanel1 = new org.reprap.gui.botConsole.GenericStepperPositionPanel();
        genericStepperPositionPanel2 = new org.reprap.gui.botConsole.GenericStepperPositionPanel();
        genericStepperPositionPanel3 = new org.reprap.gui.botConsole.GenericStepperPositionPanel();
        goButton1 = new javax.swing.JButton();
        jSlider3 = new javax.swing.JSlider();
        jLabel1 = new javax.swing.JLabel();
        jPanel4 = new javax.swing.JPanel();
        jLabel2 = new javax.swing.JLabel();
        xySpeedField = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        zSpeedField = new javax.swing.JTextField();
        bedPanel1 = new org.reprap.gui.botConsole.bedPanel();

        setPreferredSize(new java.awt.Dimension(750, 310));

        jSlider1.setOrientation(javax.swing.JSlider.VERTICAL);

        jSlider2.setValue(25);
        jSlider2.setValueIsAdjusting(true);

        jPanel2.setBorder(javax.swing.BorderFactory.createTitledBorder("Nudge size (mm)"));

        buttonGroup1.add(nudgeSizeRB1);
        nudgeSizeRB1.setSelected(true);
        nudgeSizeRB1.setText("0.1");
        nudgeSizeRB1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                nudgeSizeRB1ActionPerformed(evt);
            }
        });

        buttonGroup1.add(nudgeSizeRB2);
        nudgeSizeRB2.setText("1.0");
        nudgeSizeRB2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                nudgeSizeRB2ActionPerformed(evt);
            }
        });

        buttonGroup1.add(nudgeSizeRB3);
        nudgeSizeRB3.setText("10.0");
        nudgeSizeRB3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                nudgeSizeRB3ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(nudgeSizeRB1)
                .addGap(18, 18, 18)
                .addComponent(nudgeSizeRB2)
                .addGap(18, 18, 18)
                .addComponent(nudgeSizeRB3)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addContainerGap(16, Short.MAX_VALUE)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(nudgeSizeRB1)
                    .addComponent(nudgeSizeRB2)
                    .addComponent(nudgeSizeRB3)))
        );

        jPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder("Axes position"));

        goButton.setText("GO");
        goButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                goButtonActionPerformed(evt);
            }
        });

        plotCheck.setText("Plot using Extruder #");

        extruderToPlot.setColumns(1);
        extruderToPlot.setText("0");

        goButton1.setText("Home all");
        goButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                goButton1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(genericStepperPositionPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(genericStepperPositionPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(plotCheck)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(extruderToPlot, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(goButton1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(goButton))
                    .addComponent(genericStepperPositionPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addComponent(genericStepperPositionPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(genericStepperPositionPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(genericStepperPositionPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 13, Short.MAX_VALUE)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(plotCheck)
                    .addComponent(extruderToPlot, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(goButton)
                    .addComponent(goButton1))
                .addContainerGap())
        );

        jSlider3.setOrientation(javax.swing.JSlider.VERTICAL);
        jSlider3.setValue(0);
        jSlider3.setInverted(true);

        jLabel1.setFont(jLabel1.getFont().deriveFont((float)12));
        jLabel1.setText("Z");

        jPanel4.setBorder(javax.swing.BorderFactory.createTitledBorder("Axis speeds (mm/min)"));

        jLabel2.setFont(new java.awt.Font("Tahoma", 0, 12));
        jLabel2.setText("X & Y");

        xySpeedField.setColumns(4);
        xySpeedField.setFont(new java.awt.Font("Tahoma", 0, 12));
        xySpeedField.setText("0000");

        jLabel3.setFont(new java.awt.Font("Tahoma", 0, 12));
        jLabel3.setText("Z");

        zSpeedField.setColumns(4);
        zSpeedField.setFont(new java.awt.Font("Tahoma", 0, 12));
        zSpeedField.setText("0000");

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addComponent(jLabel2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(xySpeedField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jLabel3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(zSpeedField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(163, Short.MAX_VALUE))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                .addComponent(jLabel2)
                .addComponent(xySpeedField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addComponent(jLabel3)
                .addComponent(zSpeedField, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );

        bedPanel1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                bedPanel1MousePressed(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                bedPanel1MouseReleased(evt);
            }
        });
        bedPanel1.addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                bedPanel1MouseDragged(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jSlider1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(bedPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jSlider2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(15, 15, 15)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jPanel4, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel3, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel2, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jSlider3, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel1))
                .addContainerGap(90, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(bedPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jSlider2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jSlider1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel1)
                        .addGap(4, 4, 4)
                        .addComponent(jSlider3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void setPrefs() throws IOException {
        
        XYfastSpeed = Preferences.loadGlobalInt("FastSpeed(0..255)");
        ZfastSpeed = Preferences.loadGlobalInt("MovementSpeedZ(0..255)");
        
        xySpeedField.setText(String.valueOf(XYfastSpeed));
        zSpeedField.setText(String.valueOf(ZfastSpeed));
    }
    
    private void nudgeSizeRB1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_nudgeSizeRB1ActionPerformed
        setNudgeSize(Double.parseDouble(nudgeSizeRB1.getText()));
}//GEN-LAST:event_nudgeSizeRB1ActionPerformed

    private void nudgeSizeRB2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_nudgeSizeRB2ActionPerformed
        setNudgeSize(Double.parseDouble(nudgeSizeRB2.getText()));
}//GEN-LAST:event_nudgeSizeRB2ActionPerformed

    private void nudgeSizeRB3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_nudgeSizeRB3ActionPerformed
        setNudgeSize(Double.parseDouble(nudgeSizeRB3.getText()));
}//GEN-LAST:event_nudgeSizeRB3ActionPerformed

    private void goButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_goButtonActionPerformed
        
        // Check all motors have been homed first
        if( genericStepperPositionPanel1.hasAxisBeenHomed() && genericStepperPositionPanel2.hasAxisBeenHomed() && genericStepperPositionPanel3.hasAxisBeenHomed() ) 
        {
                // Refresh speeds
                setMotorSpeeds();

                // Move axes, Z separately to avoid power overload
                genericStepperPositionPanel3.moveToTargetBlocking();
                genericStepperPositionPanel1.moveToTarget();
                genericStepperPositionPanel2.moveToTarget();
        }
        else {
            JOptionPane.showMessageDialog(null, "You must home all axes first!");
        }        

    }//GEN-LAST:event_goButtonActionPerformed

    private void goButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_goButton1ActionPerformed
        genericStepperPositionPanel1.homeAxis();
        genericStepperPositionPanel2.homeAxis();
        genericStepperPositionPanel3.homeAxis();
    }//GEN-LAST:event_goButton1ActionPerformed

    private void bedPanel1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bedPanel1MousePressed
        bedPanel1.mousePressed();
    }//GEN-LAST:event_bedPanel1MousePressed

    private void bedPanel1MouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bedPanel1MouseReleased
//      TODO: Activate this code when the Java3D parameters allow a small enough working volume. Currently I get a black screen.
//      axisLengthX = Preferences.loadGlobalDouble("WorkingX(mm)");
//      axisLengthY = Preferences.loadGlobalDouble("WorkingY(mm)");
        
        int axisLengthX = 160;
        int axisLengthY = 160;
        
        double ratioX = evt.getX()*1.0/bedPanel1.getWidth();
        double ratioY = evt.getY()*1.0/bedPanel1.getWidth();
        
        int bedX = (int)(ratioX*axisLengthX);
        int bedY = (int)(axisLengthY-ratioY*axisLengthY);
        
//        System.out.println(bedX + ", " + bedY);
        
        genericStepperPositionPanel1.setTargetPositionField(bedX);
        genericStepperPositionPanel2.setTargetPositionField(bedY);
        
        bedPanel1.updateCrossHair(evt.getX(), evt.getY());
    }//GEN-LAST:event_bedPanel1MouseReleased

    private void bedPanel1MouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bedPanel1MouseDragged
        bedPanel1.dragCrossHair(evt.getX(), evt.getY());
    }//GEN-LAST:event_bedPanel1MouseDragged
    
    public void checkNudgeSize() {
        if (nudgeSize == 0) {
            nudgeSizeRB1.setSelected(true);
            nudgeSize = Double.parseDouble(nudgeSizeRB1.getText());
        }
    }
    
    public void setNudgeSize(Double size) {
        
        nudgeSize = size;
        
        genericStepperPositionPanel3.setNudgeSize(nudgeSize);
        genericStepperPositionPanel1.setNudgeSize(nudgeSize);
        genericStepperPositionPanel2.setNudgeSize(nudgeSize);
    }
    
    public void setBedPanelDimensions() {
        bedPanel1.setDimensions();
    }
    
    private static double nudgeSize = 0;
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private org.reprap.gui.botConsole.bedPanel bedPanel1;
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.JTextField extruderToPlot;
    private org.reprap.gui.botConsole.GenericStepperPositionPanel genericStepperPositionPanel1;
    private org.reprap.gui.botConsole.GenericStepperPositionPanel genericStepperPositionPanel2;
    private org.reprap.gui.botConsole.GenericStepperPositionPanel genericStepperPositionPanel3;
    private javax.swing.JButton goButton;
    private javax.swing.JButton goButton1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JSlider jSlider1;
    private javax.swing.JSlider jSlider2;
    private javax.swing.JSlider jSlider3;
    private javax.swing.JRadioButton nudgeSizeRB1;
    private javax.swing.JRadioButton nudgeSizeRB2;
    private javax.swing.JRadioButton nudgeSizeRB3;
    private javax.swing.JCheckBox plotCheck;
    public static javax.swing.JTextField xySpeedField;
    public static javax.swing.JTextField zSpeedField;
    // End of variables declaration//GEN-END:variables
    
}
