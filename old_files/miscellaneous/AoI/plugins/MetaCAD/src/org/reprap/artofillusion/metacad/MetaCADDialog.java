/*
 *  This program is free software; you can redistribute it and/or modify it under the
 *  terms of the GNU General Public License as published by the Free Software
 *  Foundation; either version 2 of the License, or (at your option) any later version.
 *  This program is distributed in the hope that it will be useful, but WITHOUT ANY
 *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 *  PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 */
package org.reprap.artofillusion.metacad;

import java.awt.Insets;
import java.awt.Rectangle;

import javax.swing.SwingUtilities;

import artofillusion.LayoutWindow;
import artofillusion.ui.Translate;
import buoy.event.CommandEvent;
import buoy.event.KeyPressedEvent;
import buoy.event.WindowClosingEvent;
import buoy.widget.BButton;
import buoy.widget.BDialog;
import buoy.widget.BLabel;
import buoy.widget.BScrollPane;
import buoy.widget.BSeparator;
import buoy.widget.BTabbedPane;
import buoy.widget.BTextArea;
import buoy.widget.BorderContainer;
import buoy.widget.FormContainer;
import buoy.widget.GridContainer;
import buoy.widget.LayoutInfo;

/**
 * MetaCAD dialog
 */
class MetaCADDialog extends BDialog implements TextChangedListener
{
  protected  MetaCADEngine engine;
  protected LayoutWindow window;
  protected String[] primfunctions = new String [] {
      "cube", "cylinder", "sphere",
      "regular", "star", "roll",
      "file"
  };
  protected String[] cadfunctions = new String [] {
      "union", "intersection", "difference",
      "move", "rotate", "scale",
      "trans", "group", "loop",
      "joincurves", "inset", "mesh", 
      "extrude", "lathe", null,
      "extractmacro", "inlinemacro"
  };
  
  protected BTextArea paramtab;
  
  public MetaCADDialog(LayoutWindow window)
  {
    super(window, Translate.text("MetaCAD:name"), false); // Modeless
    this.window = window;
    this.setResizable(true);
    
    this.engine = new MetaCADEngine(window);

    BorderContainer bc = new BorderContainer();
    bc.setDefaultLayout(new LayoutInfo(LayoutInfo.CENTER, LayoutInfo.BOTH));
    this.setContent(bc);

    String versionstr = MetaCADPlugin.getVersion();
    bc.add(new BLabel(Translate.text("MetaCAD:title", versionstr)), BorderContainer.NORTH, 
           new LayoutInfo(LayoutInfo.NORTH, LayoutInfo.NONE, new Insets(5,5,5,5), null));


    // Tab widget
    BTabbedPane tabcontainer = new BTabbedPane();
    tabcontainer.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
    bc.add(tabcontainer, BorderContainer.CENTER, new LayoutInfo(LayoutInfo.CENTER, LayoutInfo.BOTH));

    //  Primitives tab
    FormContainer operationstab = new FormContainer(3, 3);
    tabcontainer.add(operationstab, "Primitives");

    for (int i = 0; i < this.primfunctions.length; i++) {
      BButton button = new BButton(Translate.text("MetaCAD:"+this.primfunctions[i]));
      operationstab.add(button, i%3, i/3, new LayoutInfo(LayoutInfo.WEST, LayoutInfo.HORIZONTAL, new Insets(2, 0, 2, 0), null));
      button.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
      button.addEventLink(CommandEvent.class, this.engine, this.primfunctions[i]);
    }
    
    // CAD tab
    FormContainer cadfuncs = new FormContainer(3, this.cadfunctions.length+1);
    tabcontainer.add(cadfuncs, "CAD");
    for (int i = 0; i < this.cadfunctions.length; i++) {
      if (this.cadfunctions[i] != null) {
        BButton button = new BButton(Translate.text("MetaCAD:"+this.cadfunctions[i]));
        cadfuncs.add(button, i%3, i/3, new LayoutInfo(LayoutInfo.WEST, LayoutInfo.HORIZONTAL, new Insets(2, 0, 2, 0), null));
        button.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
        button.addEventLink(CommandEvent.class, this.engine, this.cadfunctions[i]);
      }
    }

    // Parameters tab
    this.paramtab=new BTextArea(this.engine.getParameters(), 10, 20) {
      @Override
      protected void textChanged() {
        super.textChanged();
        MetaCADDialog.this.engine.setParameters(this.getText());
      }
    };
    this.engine.addParameterChangedListener(this);
    
    BScrollPane scrollpane = new BScrollPane(this.paramtab);
    tabcontainer.add(scrollpane, "Parameters");

    // Evaluate & Devaluate
    GridContainer bottomgc = new GridContainer(4,1);
    bottomgc.setDefaultLayout(new LayoutInfo(LayoutInfo.CENTER, LayoutInfo.NONE));
    bc.add(bottomgc, BorderContainer.SOUTH, new LayoutInfo(LayoutInfo.CENTER, LayoutInfo.NONE, new Insets(5,5,5,5), null));
    
    BButton button = new BButton(Translate.text("MetaCAD:evaluate"));
    button.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
    button.addEventLink(CommandEvent.class, this.engine, "evaluate");
    bottomgc.add(button, 0, 0, new LayoutInfo(LayoutInfo.WEST, LayoutInfo.NONE));    
    button = new BButton(Translate.text("MetaCAD:devaluate"));
    button.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
    button.addEventLink(CommandEvent.class, this.engine, "devaluate");
    bottomgc.add(button, 1, 0, new LayoutInfo(LayoutInfo.WEST, LayoutInfo.NONE));
    
    bottomgc.add(new BSeparator(BSeparator.HORIZONTAL), 2, 0, 
                 new LayoutInfo(LayoutInfo.CENTER, LayoutInfo.HORIZONTAL));

    // Close button
    BButton closeButton;
    bottomgc.add(closeButton = Translate.button("close", this, "closeWindow"), 3, 0, new LayoutInfo(LayoutInfo.EAST, LayoutInfo.NONE));
//    closeButton.addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
    addEventLink(KeyPressedEvent.class, this, "keyPressed"); // For Esc support
    // FIXME: Other events (most noticeably Cmd-Z (undo)) are consumed and won't reach our
    // parent window.
    setDefaultButton(closeButton);

    addEventLink(WindowClosingEvent.class, this, "closeWindow");
    pack();

    // Move dialog to lower left corner
    Rectangle r1 = window.getBounds(), r2 = this.getBounds();
    int x = r1.x;
    int y = r1.y+r1.height-r2.height;
    if (x < 0) x = 0;
    if (y < 0) y = 0;
    this.setBounds(new Rectangle(x, y, r2.width, r2.height));

    setVisible(true);
  }

  /** Pressing Escape are equivalent to clicking close */
  public void keyPressed(KeyPressedEvent ev)
  {
    if (ev.getKeyCode() == KeyPressedEvent.VK_ESCAPE ||
        ev.getKeyCode() == KeyPressedEvent.VK_M) closeWindow();
  }

  public void closeWindow()
  {
    dispose();
  }

  public void textChanged(Object source) {
    final String newText = this.engine.getParameters();
    if (!newText.equals(this.paramtab.getText()))
    {
      SwingUtilities.invokeLater(new Runnable()
      {
        public void run()
        {
          MetaCADDialog.this.paramtab.setText(newText);
        }
      });
      
    }
  }
}