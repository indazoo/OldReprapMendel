package org.reprap.artofillusion;

import org.cheffo.jeplite.JEP;

public class MetaCADContext {

  public JEP jep = new JEP();

  // Evaluates an Expression like 3*x+sin(a) and returns the value of it or 0 if
  // any error occurred
  double evaluateExpression(String expr) throws Exception {
    try {
      this.jep.parseExpression(expr);
      return this.jep.getValue();
    } catch (Exception ex) {
      // FIXME: Message?
//      showMessage("Error while evaluating Expression: \"" + expr
//          + "\" Syntax Error or unknown variable?");
      throw (ex);
      // return 0;
    }
  }
  
  // Evaluates Expressions like x=2*radius and assigns the value to the given
  // variable
  void evaluateAssignment(String curLine) throws Exception {
    try {
      int mark = curLine.indexOf("=");

      String name = curLine.substring(0, mark).trim();
      String formula = curLine.substring(mark + 1);
      this.jep.parseExpression(formula);
      double value = this.jep.getValue();
      // System.out.println(value);
      this.jep.addVariable(name, value);
    } catch (Exception ex) {
      throw (ex);
    }
  }
  
}

