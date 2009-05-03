package org.reprap.artofillusion;

import java.util.List;

import artofillusion.object.CSGObject;
import artofillusion.object.ObjectInfo;

public class UnionObj extends BooleanObj {

  public ObjectInfo evaluateObject(MetaCADContext ctx) throws Exception {
    
    CSGHelper helper = new CSGHelper(CSGObject.UNION);
    List<ObjectInfo> children = evaluateChildren(ctx);
    helper.addAll(children.iterator());
    
    return helper.GetObjectInfo();
  }
}
