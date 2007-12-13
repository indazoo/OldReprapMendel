package org.reprap.geometry;

import javax.media.j3d.*;
import org.reprap.Preferences;
import org.reprap.Printer;
import org.reprap.geometry.polygons.*;
import org.reprap.gui.PreviewPanel;
import org.reprap.gui.RepRapBuild;
import org.reprap.machines.MachineFactory;
import org.reprap.machines.NullCartesianMachine;
import org.reprap.utilities.Debug;

public class Producer {
	
	/**
	 * 
	 */
	protected Printer reprap;
	
	/**
	 * 
	 */
	protected RrHalfPlane oddHatchDirection;
	
	/**
	 * 
	 */
	protected RrHalfPlane evenHatchDirection;
	
	/**
	 * 
	 */
	protected RepRapBuild bld;
	
	/**
	 * @param preview
	 * @param builder
	 * @throws Exception
	 */
	public Producer(PreviewPanel preview, RepRapBuild builder) throws Exception {
		
		reprap = MachineFactory.create();
		reprap.setPreviewer(preview);
		preview.setMachine(reprap);
		bld = builder;

		//		Original hatch vectors
		oddHatchDirection = new RrHalfPlane(new Rr2Point(0.0, 0.0), new Rr2Point(1.0, 1.0));
		evenHatchDirection = new RrHalfPlane(new Rr2Point(0.0, 1.0), new Rr2Point(1.0, 0.0));
		
//		//		Vertical hatch vector
//		oddHatchDirection = new RrHalfPlane(new Rr2Point(0.0, 0.0), new Rr2Point(0.0, 1.0));
//		evenHatchDirection = new RrHalfPlane(new Rr2Point(0.0, 1.0), new Rr2Point(0.0, 0.0));
	
//		//		Horizontal hatch vector
//		oddHatchDirection = new RrHalfPlane(new Rr2Point(0.0, 0.0), new Rr2Point(1.0, 0.0));
//		evenHatchDirection = new RrHalfPlane(new Rr2Point(1.0, 0.0), new Rr2Point(0.0, 0.0));
		

	}
	
//	/**
//	 * @return simple polygon object that represents a 2D square
//	 */
//	public RrPolygon square()
//	{
//		RrPolygon a = new RrPolygon();
//		Rr2Point p1 = new Rr2Point(10, 10);
//		Rr2Point p2 = new Rr2Point(20, 10);
//		Rr2Point p3 = new Rr2Point(20, 20);
//		Rr2Point p4 = new Rr2Point(10, 20);
//		a.add(p1, 1);
//		a.add(p2, 1);
//		a.add(p3, 1);
//		a.add(p4, 1);
//		return a;
//	}
	
//	/**
//	 * @return hexagonal object
//	 */
//	public RrCSGPolygon hex()
//	{
//		double hexSize = 20;
//		double hexX = 15, hexY = 15;
//		
//		RrCSG r = RrCSG.universe();
//		Rr2Point pold = new Rr2Point(hexX + hexSize/2, hexY);
//		Rr2Point p;
//		double theta = 0; 
//		for(int i = 0; i < 6; i++)
//		{
//			theta += Math.PI * 60. / 180.0;
//			p = new Rr2Point(hexX + Math.cos(theta)*hexSize/2, hexY + Math.sin(theta)*hexSize/2);
//			r = RrCSG.intersection(r, new RrCSG(new RrHalfPlane(p, pold)));
//			pold = p;
//		}
//		
//		// Horrid hacks in multipliers next...
//		return new RrCSGPolygon(r, new RrBox(new Rr2Point(hexX - hexSize*0.57, hexY - hexSize*0.61), 
//				new Rr2Point(hexX + hexSize*0.537, hexY + hexSize*0.623)));
//	}
	
//	/**
//	 * @return Adrian's testshape; a 3D object
//	 */
//	public RrCSGPolygon adriansTestShape()
//	{
//		Rr2Point p = new Rr2Point(3, 5);
//		Rr2Point q = new Rr2Point(7, 27);
//		Rr2Point r = new Rr2Point(32, 30);
//		Rr2Point s = new Rr2Point(31, 1);
//		
//		Rr2Point pp = new Rr2Point(12, 21);
//		Rr2Point qq = new Rr2Point(18, 32);
//		Rr2Point rr = new Rr2Point(15, 17);    
//		
//		RrHalfPlane ph = new RrHalfPlane(p, q);
//		RrHalfPlane qh = new RrHalfPlane(q, r);
//		RrHalfPlane rh = new RrHalfPlane(r, s);
//		RrHalfPlane sh = new RrHalfPlane(s, p);
//		
//		RrHalfPlane pph = new RrHalfPlane(pp, qq);
//		RrHalfPlane qqh = new RrHalfPlane(qq, rr);
//		RrHalfPlane rrh = new RrHalfPlane(rr, pp);
//		
//		RrCSG pc = new RrCSG(ph);
//		RrCSG qc = new RrCSG(qh);
//		RrCSG rc = new RrCSG(rh);
//		RrCSG sc = new RrCSG(sh);
//		
//		pc = RrCSG.intersection(pc, qc);
//		rc = RrCSG.intersection(sc, rc);		
//		pc = RrCSG.intersection(pc, rc);
//		
//		RrCSG ppc = new RrCSG(pph);
//		RrCSG qqc = new RrCSG(qqh);
//		RrCSG rrc = new RrCSG(rrh);
//		
//		ppc = RrCSG.intersection(ppc, qqc);
//		ppc = RrCSG.intersection(ppc, rrc);
//		ppc = RrCSG.difference(pc, ppc);
//		
//		pc = ppc.offset(-5);
//		ppc = RrCSG.difference(ppc, pc);
//		
//		RrCSGPolygon result = new RrCSGPolygon(ppc, new 
//				RrBox(new Rr2Point(0,0), new Rr2Point(110,110)));
////		result.divide(1.0e-6, 1);
////		new RrGraphics(result, true);
//		return result;
//	}
	
	/**
	 * @throws Exception
	 */
//	public void produce(boolean testPiece) throws Exception {
	public void produce() throws Exception {

        // Fallback defaults
		//int extrusionSpeed = 200;
		//int extrusionTemp = 40;
		//int movementSpeedXY = 230;
		//int fastSpeedXY = 230;
		int movementSpeedZ = 212;
		
		//int coolingPeriod = Preferences.loadGlobalInt("CoolingPeriod");
		boolean subtractive = Preferences.loadGlobalBool("Subtractive");
		
		try {
//			extrusionSpeed = Preferences.loadGlobalInt("ExtrusionSpeed");
//			extrusionTemp = Preferences.loadGlobalInt("ExtrusionTemp");
//			movementSpeedXY = Preferences.loadGlobalInt("MovementSpeed");
//			fastSpeedXY = Preferences.loadGlobalInt("FastSpeed");
			movementSpeedZ = Preferences.loadGlobalInt("MovementSpeedZ(0..255)");
		} catch (Exception ex) {
			System.out.println("Warning: could not load ExtrusionSpeed/MovementSpeed, using defaults");
		}
		

//		reprap.setSpeed(movementSpeedXY);
//		reprap.setFastSpeed(fastSpeedXY);
		reprap.setSpeedZ(movementSpeedZ);
		Debug.d("Intialising reprap");
		reprap.initialise();
		Debug.d("Selecting material 0");
		reprap.selectExtruder(0);
		//reprap.setExtruderSpeed(extrusionSpeed);
		Debug.d("Setting temperature");
		reprap.getExtruder().heatOn();
		
		// A "warmup" segment to get things in working order
		if (!subtractive) {
			
			Debug.d("Printing warmup segments, moving to (5,5)");
			reprap.setSpeed(reprap.getExtruder().getXYSpeed());
			reprap.moveTo(5, 5, 0, false, false);
			Debug.d("Printing warmup segments, printing to (5,50)");
			reprap.printTo(5, 50, 0, false);
			Debug.d("Printing warmup segments, printing to (7,50)");
			reprap.printTo(7, 50, 0, false);
			Debug.d("Printing warmup segments, printing to (7,5)");
			reprap.printTo(7, 5, 0, true);
			Debug.d("Warmup complete");
			reprap.setSpeed(reprap.getFastSpeed());
			
		}
		
		// This should now split off layers one at a time
		// and pass them to the LayerProducer.  
		
		boolean isEvenLayer = true;
		STLSlice stlc;
		double zMax;
//		if(testPiece)
//		{
//			stlc = null;
//			zMax = 5;
//		} else
//		{
			bld.mouseToWorld();
			stlc = new STLSlice(bld.getSTLs());
			zMax = stlc.maxZ();
			// zMax = 1.6;  // For testing.
//		}
		
		double startZ;
		double endZ;
		double stepZ;
		if (subtractive) {
			// Subtractive construction works from the top, downwards
			startZ = zMax;
			endZ = 0;
			stepZ = -reprap.getExtruder().getExtrusionHeight();
			reprap.setZManual(startZ);
		} else {
			// Normal constructive fabrication, start at the bottom and work up.
			
			// Note that we start extruding one layer off the baseboard...
			// startZ = reprap.getExtruder().getExtrusionHeight();
			
			startZ = 0;
			endZ = zMax;
			
			stepZ = reprap.getExtruder().getExtrusionHeight();
		
		}
		
		for(double z = startZ; subtractive ? z > endZ : z < endZ; z += stepZ) {
			
			if (reprap.isCancelled())
				break;
			Debug.d("Commencing layer at " + z);

			// Change Z height
			reprap.moveTo(reprap.getX(), reprap.getY(), z, false, false);

			// Layer cooling phase - after we've just raised the head.
			//Only if we're not a null device.
			if ((z != startZ && reprap.getExtruder().getCoolingPeriod() > 0)&&!(reprap instanceof NullCartesianMachine)) {
				Debug.d("Starting a cooling period");
				// Save where we are. We'll come back after we've cooled off.
				double storedX=reprap.getX();
				double storedY=reprap.getY();
				reprap.getExtruder().setCooler(true);	// On with the fan.
				//reprap.homeToZeroX();		// Seek (0,0)
				//reprap.homeToZeroY();
				reprap.setSpeed(reprap.getFastSpeed());
				reprap.moveTo(0, 0, z, true, true);
				Thread.sleep(1000 * reprap.getExtruder().getCoolingPeriod());
				reprap.getExtruder().setCooler(false);
				Debug.d("Brief delay for head to warm up.");
				Thread.sleep(200 * reprap.getExtruder().getCoolingPeriod());
				Debug.d("End of cooling period");
				// TODO: BUG! Strangely, this only restores Y axis!
				//System.out.println("stored X and Y: " + storedX + "   " + storedY);
				
				// The next layer will go where it wants to.
				
				//reprap.moveTo(storedX, storedY, z, true, true);
				//reprap.setSpeed(reprap.getExtruder().getXYSpeed());
				//reprap.moveTo(storedX, reprap.getY(), z, true, true);
			}
			
			if (reprap.isCancelled())
				break;

			Preferences prefs;
			
			Debug.d("Attempting to wiping nozzle");
			reprap.wipeNozzle(); // Wipes current active extruder, if wipe function enabled
					
			
			LayerProducer layer;
//			if(testPiece)
//			{
//				layer = new LayerProducer(reprap, z, hex(), null,
//						isEvenLayer?evenHatchDirection:oddHatchDirection);
//			} else
//			{
				RrCSGPolygonList slice = stlc.slice(z+reprap.getExtruder().getExtrusionHeight()*0.5, 
						LayerProducer.solidMaterial(), LayerProducer.gapMaterial());
				BranchGroup lowerShell = stlc.getBelow();
				if(slice.size() > 0)
					layer = new LayerProducer(reprap, z, slice, lowerShell,
						isEvenLayer?evenHatchDirection:oddHatchDirection);
				else
					layer = null;

//			}
			
			if(layer != null)
				layer.plot();
		
			isEvenLayer = !isEvenLayer;
		}

		if (subtractive)
			reprap.moveTo(0, 0, startZ, true, true);
		else
			reprap.moveTo(0, 0, reprap.getZ(), true, true);
		
		reprap.terminate();

	}

	/**
	 * The total distance moved is the total distance extruded plus 
	 * plus additional movements of the extruder when no materials 
	 * was deposited
	 * 
	 * @return total distance the extruder has moved 
	 */
	public double getTotalDistanceMoved() {
		return reprap.getTotalDistanceMoved();
	}
	
	/**
	 * @return total distance that has been extruded in millimeters
	 */
	public double getTotalDistanceExtruded() {
		return reprap.getTotalDistanceExtruded();
	}
	
	/**
	 * TODO: This figure needs to get added up as we go along to allow for different extruders
	 * @return total volume that has been extruded
	 */
	public double getTotalVolumeExtruded() {
		return reprap.getTotalDistanceExtruded() * reprap.getExtruder().getExtrusionHeight() * 
		reprap.getExtruder().getExtrusionSize();
	}
	
	/**
	 * 
	 */
	public void dispose() {
		reprap.dispose();
	}

	/**
	 * @return total elapsed time in seconds between start and end of building the 3D object
	 */
	public double getTotalElapsedTime() {
		return reprap.getTotalElapsedTime();
	}
	
}
