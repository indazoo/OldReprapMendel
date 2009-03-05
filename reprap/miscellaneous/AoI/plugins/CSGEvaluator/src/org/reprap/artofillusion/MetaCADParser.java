package org.reprap.artofillusion;


public class MetaCADParser {
	public Boolean parseError;
	public String name;
	public String[] parameters;

	public MetaCADParser(String myExpr, String split) {
		int posOpenBracket = myExpr.indexOf("(");
		int posCloseBracket = myExpr.lastIndexOf(")");

		if (posOpenBracket > 0 && posCloseBracket >= 0) {
			name = myExpr.substring(0, posOpenBracket).trim();
			String pars = myExpr.substring(posOpenBracket + 1, posCloseBracket).trim();
			parameters = pars.split(split);
			parseError = false;
		} else {
			parseError = true;
		}
	}
}
