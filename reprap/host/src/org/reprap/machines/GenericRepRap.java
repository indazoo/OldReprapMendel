package org.reprap.machines;

import java.io.IOException;

import javax.media.j3d.BranchGroup;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JFrame;

import org.reprap.Attributes;
import org.reprap.CartesianPrinter;
import org.reprap.Preferences;
import org.reprap.ReprapException;
import org.reprap.devices.NullExtruder;
import org.reprap.devices.GenericExtruder;
import org.reprap.devices.GenericStepperMotor;
import org.reprap.devices.NullStepperMotor;
import org.reprap.geometry.LayerRules;
import org.reprap.gui.ContinuationMesage;
import org.reprap.gui.Previewer;
import org.reprap.gui.StatusMessage;
import org.reprap.Extruder;
import org.reprap.utilities.Debug;
import org.reprap.utilities.Timer;

public abstract class GenericRepRap implements CartesianPrinter
{
	protected boolean stlLoaded = false;
	protected boolean gcodeLoaded = false;
	
	/**
	 * 
	 */
	protected StatusMessage statusWindow;
	
	/**
	 * 
	 */
	protected JCheckBoxMenuItem layerPauseCheckbox = null, segmentPauseCheckbox = null;
	
	/**
	 * This is our previewer window
	 */
	protected Previewer previewer = null;

	/**
	 * How far have we moved, in mm.
	 */
	protected double totalDistanceMoved = 0.0;
	
	/**
	 * What distnace did we extrude, in mm.
	 */
	protected double totalDistanceExtruded = 0.0;
	
	/**
	 * Rezero X and y every...
	 */
	double xYReZeroInterval = -1;
	
	/**
	 * Distance since last zero
	 */

	double distanceFromLastZero = 0;
	
	/**
	 * Distance at last call of maybeZero
	 */
	double distanceAtLastCall = 0;
	
	
	/**
	 * Scale for each axis in steps/mm.
	 */
	protected double scaleX, scaleY, scaleZ;
	
	/**
	 * Current X, Y and Z position of the extruder 
	 */
	protected double currentX, currentY, currentZ;
	
	/**
	 * Maximum feedrate for X, Y, and Z axes
	 */
	protected double maxFeedrateX, maxFeedrateY, maxFeedrateZ;
	
	/**
	* Current feedrate for the machine.
	*/
	protected double currentFeedrate;
	
	/**
	* Feedrate for fast XY moves on the machine.
	*/
	protected double fastFeedrateXY;
	
	/**
	* Feedrate for fast Z moves on the machine.
	*/
	protected double fastFeedrateZ;
	
	/**
	 * Number of extruders on the 3D printer
	 */
	protected int extruderCount;
	
	/**
	 * Array containing the extruders on the 3D printer
	 */
	protected Extruder extruders[];

	/**
	 * Current extruder?
	 */
	protected int extruder;
	
	/**
	 * When did we start printing?
	 */
	protected long startTime;
	
	protected double startCooling;
	
	/**
	 * Do we idle the z axis?
	 */
	protected boolean idleZ;
	
	/**
	* Do we include the z axis?
	*/
	protected boolean excludeZ = false;
	
	private int foundationLayers = 0;

	
	/**
	 * Stepper motors for the 3 axis 
	 */
	public GenericStepperMotor motorX;
	public GenericStepperMotor motorY;
	public GenericStepperMotor motorZ;
	
	public GenericRepRap() throws Exception
	{
		startTime = System.currentTimeMillis();
		
		statusWindow = new StatusMessage(new JFrame());
		
		//load extruder prefs
		extruderCount = Preferences.loadGlobalInt("NumberOfExtruders");
		if (extruderCount < 1)
			throw new Exception("A Reprap printer must contain at least one extruder");

		//load our actual extruders.
		extruders = new GenericExtruder[extruderCount];
		loadExtruders();
		loadMotors();
		
		//load our prefs
		refreshPreferences();

		//init our stuff.
		currentX = 0;
		currentY = 0;
		currentZ = 0;
	}
	
	public void refreshPreferences()
	{
		try
		{
			//load axis prefs
			int axes = Preferences.loadGlobalInt("AxisCount");
			if (axes != 3)
				throw new Exception("A Cartesian Bot must contain 3 axes");
			
			xYReZeroInterval =  Preferences.loadGlobalDouble("XYReZeroInterval(mm)");

			// TODO This should be from calibration
			scaleX = Preferences.loadGlobalDouble("XAxisScale(steps/mm)");
			scaleY = Preferences.loadGlobalDouble("YAxisScale(steps/mm)");
			scaleZ = Preferences.loadGlobalDouble("ZAxisScale(steps/mm)");

			// Load our maximum feedrate variables
			maxFeedrateX = Preferences.loadGlobalDouble("MaximumFeedrateX(mm/minute)");
			maxFeedrateY = Preferences.loadGlobalDouble("MaximumFeedrateY(mm/minute)");
			maxFeedrateZ = Preferences.loadGlobalDouble("MaximumFeedrateZ(mm/minute)");
			
			//set our standard feedrates.
			setFastFeedrateXY(Math.min(maxFeedrateX, maxFeedrateY));
			setFastFeedrateZ(maxFeedrateZ);
			
			idleZ = Preferences.loadGlobalBool("IdleZAxis");
			
			foundationLayers = Preferences.loadGlobalInt("FoundationLayers");
		}
		catch (Exception ex)
		{
			System.err.println("Refresh Reprap preferences: " + ex.toString());
		}
		
		for(int i = 0; i < extruderCount; i++)
			extruders[i].refreshPreferences();
		
		Debug.refreshPreferences();
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#startRun()
	 */
	public void startRun() throws Exception
	{
		if (previewer != null)
			previewer.reset();
				
		Debug.d("Selecting material 0");
		selectExtruder(0);
		
		Debug.d("Homing machine");
		home();

		Debug.d("Setting temperature");
		getExtruder().heatOn();
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#calibrate()
	 */
	public void calibrate() {
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#calibrate()
	 */
	public void dispose()
	{
		for(int i = 0; i < extruderCount; i++)
			extruders[i].dispose();
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#terminate()
	 */
	public void terminate() throws Exception
	{
		extruders[extruder].setMotor(false);
		extruders[extruder].setValve(false);
		extruders[extruder].setTemperature(0);
	}
	
	public void loadMotors()
	{
		motorX = new NullStepperMotor('X');
		motorY = new NullStepperMotor('Y');
		motorZ = new NullStepperMotor('Z');
	}
	
	public void loadExtruders()
	{
		for(int i = 0; i < extruderCount; i++)
		{
			extruders[i] = extruderFactory(i);
			extruders[i].setPrinter(this);
		}
		
		extruder = 0;
	}
	
	public Extruder extruderFactory(int count)
	{
		return new NullExtruder(count);
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#selectMaterial(int)
	 */
	public void selectExtruder(int materialIndex)
	{
		if (isCancelled())
			return;

		if(materialIndex < 0 || materialIndex >= extruderCount)
			System.err.println("Selected material (" + materialIndex + ") is out of range.");
		else
			extruder = materialIndex;

		//todo: move back to cartesian snap
		//layerPrinter.changeExtruder(extruders[extruder]);

//		if (previewer != null)
//			previewer.setExtruder(extruders[extruder]);

		if (isCancelled())
			return;
		// TODO Select new material
		// TODO Load new x/y/z offsets for the new extruder
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#selectMaterial(int)
	 */
	public void selectExtruder(Attributes att) {
		for(int i = 0; i < extruderCount; i++)
		{
			if(att.getMaterial().equals(extruders[i].getMaterial()))
			{
				selectExtruder(i);
				return;
			}
		}
		System.err.println("selectExtruder() - extruder not found for: " + att.getMaterial());
	}
	
	/**
	 * FIXME: Why don't these use round()? - AB.
	 * @param n
	 * @return
	 */
	protected int convertToStepX(double n) {
		return (int)((n + extruders[extruder].getOffsetX()) * scaleX);
	}

	/**
	 * @param n
	 * @return
	 */
	protected int convertToStepY(double n) {
		return (int)((n + extruders[extruder].getOffsetY()) * scaleY);
	}

	/**
	 * @param n
	 * @return
	 */
	protected int convertToStepZ(double n) {
		return (int)((n + extruders[extruder].getOffsetZ()) * scaleZ);
	}

	/**
	 * @param n
	 * @return
	 */
	protected double convertToPositionX(int n) {
		return n / scaleX - extruders[extruder].getOffsetX();
	}

	/**
	 * @param n
	 * @return
	 */
	protected double convertToPositionY(int n) {
		return n / scaleY - extruders[extruder].getOffsetY();
	}

	/**
	 * @param n
	 * @return
	 */
	protected double convertToPositionZ(int n) {
		return n / scaleZ - extruders[extruder].getOffsetZ();
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getX()
	 */
	public double getX() {
		return currentX;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#getY()
	 */
	public double getY() {
		return currentY;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#getZ()
	 */
	public double getZ() {
		return currentZ;
	}
	
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getTotalDistanceMoved()
	 */
	public double getTotalDistanceMoved() {
		return totalDistanceMoved;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#getTotalDistanceExtruded()
	 */
	public double getTotalDistanceExtruded() {
		return totalDistanceExtruded;
	}
	
	/**
	 * @param x
	 * @param y
	 * @return segment length in millimeters
	 */
	public double segmentLength(double x, double y) {
		return Math.sqrt(x*x + y*y);
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getTotalElapsedTime()
	 */
	public double getTotalElapsedTime() {
		long now = System.currentTimeMillis();
		return (now - startTime) / 1000.0;
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getExtruder(String)
	 */
	public Extruder getExtruder(String name)
	{
		for(int i = 0; i < extruderCount; i++)
			if(name.equals(extruders[i].toString()))
				return extruders[i];
		return null;
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getExtruder()
	 */
	public Extruder getExtruder()
	{
		//System.out.println("getExtruder(), extruder: " + extruder);
		return extruders[extruder];
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#getExtruder()
	 */
	public Extruder[] getExtruders()
	{
		return extruders;
	}
	
//	public void delay(long millis)
//	{
//		if(millis <= 0)
//			return;
//		try {
//			Thread.sleep(millis);
//		} catch (Exception e) {}
//	}
	
	/**
	 * Extrude for the given time in milliseconds, so that polymer is flowing
	 * before we try to move the extruder.
	 */
	public void printStartDelay(boolean firstOneInLayer) 
	{
		// Extrude motor and valve delays (ms)
		
		long eDelay, vDelay;
		
		if(firstOneInLayer)
		{
			eDelay = (long)extruders[extruder].getExtrusionDelayForLayer();
			vDelay = (long)extruders[extruder].getValveDelayForLayer();
		} else
		{
			eDelay = (long)extruders[extruder].getExtrusionDelayForPolygon();
			vDelay = (long)extruders[extruder].getValveDelayForPolygon();			
		}
		
		try
		{
			if(eDelay >= vDelay)
			{
				extruders[extruder].setMotor(true);
				machineWait(eDelay - vDelay);
				extruders[extruder].setValve(true);
				machineWait(vDelay);
			} else
			{
				extruders[extruder].setValve(true);
				machineWait(vDelay - eDelay);
				extruders[extruder].setMotor(true);
				machineWait(eDelay);
			}
			//extruders[extruder].setMotor(false);  // What's this for?  - AB
		} catch(Exception e)
		{
			// If anything goes wrong, we'll let someone else catch it.
		}
	}
	
	/**
	 * @param startX
	 * @param startY
	 * @param startZ
	 * @param endX
	 * @param endY
	 * @param endZ
	 * @throws ReprapException
	 * @throws IOException
	 */
//	public void printSegment(double startX, double startY, double startZ, 
//			double endX, double endY, double endZ, boolean turnOff) throws ReprapException, IOException {
//		moveTo(startX, startY, startZ, true, true);
//		printTo(endX, endY, endZ, turnOff);
//	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#moveTo(double, double, double, boolean, boolean)
	 */
	public void moveTo(double x, double y, double z, boolean startUp, boolean endUp) throws ReprapException, IOException
	{
		if (isCancelled()) return;

		totalDistanceMoved += segmentLength(x - currentX, y - currentY);
		
		//TODO - next bit needs to take account of startUp and endUp
		if (z != currentZ)
			totalDistanceMoved += Math.abs(currentZ - z);

		currentX = x;
		currentY = y;
		currentZ = z;
	}
	
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#printTo(double, double, double)
	 */
//	public void printTo(double x, double y, double z, boolean turnOff) throws ReprapException, IOException
//	{		
//		System.err.println("printing");
//		if (previewer != null)
//			previewer.addSegment(currentX, currentY, currentZ, x, y, z);
//		else
//			System.err.println("previewer null!");
//		
//		if (isCancelled())
//			return;
//
//		double distance = segmentLength(x - currentX, y - currentY);
//		if (z != currentZ)
//			distance += Math.abs(currentZ - z);
//			
//		totalDistanceExtruded += distance;
//		totalDistanceMoved += distance;
//		
//		currentX = x;
//		currentY = y;
//		currentZ = z;
//	}
	
	/**
	 * Occasionally re-zero X and Y if that option is selected (i.e. xYReZeroInterval > 0)
	 * @throws ReprapException
	 * @throws IOException
	 */
	protected void maybeReZero() throws ReprapException, IOException
	{
		if(xYReZeroInterval <= 0)
			return;
		distanceFromLastZero += totalDistanceMoved - distanceAtLastCall;
		distanceAtLastCall = totalDistanceMoved;
		if(distanceFromLastZero < xYReZeroInterval)
			return;
		distanceFromLastZero = 0;

		double oldFeedrate = getFeedrate();

		extruders[extruder].setValve(false);
		extruders[extruder].setMotor(false);
		if (!excludeZ)
		{
			double liftedZ = currentZ + (extruders[extruder].getMinLiftedZ());

			setFeedrate(getFastFeedrateZ());
			moveTo(currentX, currentY, liftedZ, false, false);
		}
		
		double oldX = currentX;
		double oldY = currentY;
		homeToZeroX();
		homeToZeroY();
		
		setFeedrate(getFastFeedrateXY());
		moveTo(oldX, oldY, currentZ, false, false);
		
		if (!excludeZ)
		{
			double liftedZ = currentZ - (extruders[extruder].getMinLiftedZ());

			setFeedrate(getFastFeedrateZ());
			moveTo(currentX, currentY, liftedZ, false, false);
		}

		setFeedrate(oldFeedrate);
		printStartDelay(false);		
	}
	
	/**
	 * @param enable
	 * @throws IOException
	 */
	public void setCooling(boolean enable) throws IOException {
		extruders[extruder].setCooler(enable);
	}
		
	/* (non-Javadoc)
	 * @see org.reprap.Printer#setLowerShell(javax.media.j3d.Shape3D)
	 */
	public void setLowerShell(BranchGroup ls)
	{
		if (previewer != null)
			previewer.setLowerShell(ls);
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#setPreviewer(org.reprap.gui.Previewer)
	 */
	public void setPreviewer(Previewer previewer) {
		this.previewer = previewer;
	}
	
	public void setFeedrate(double feedrate)
	{
		currentFeedrate = feedrate;
	}
		
	public double getFeedrate()
	{
		return currentFeedrate;
	}

	public void setFastFeedrateXY(double feedrate)
	{
		fastFeedrateXY = feedrate;
	}
	
	public double getFastFeedrateXY()
	{
		return fastFeedrateXY;
	}

	public void setFastFeedrateZ(double feedrate)
	{
		fastFeedrateZ = feedrate;
	}

	public double getFastFeedrateZ()
	{
		return fastFeedrateZ;
	}
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#setZManual()
	 */
	public void setZManual() throws IOException {
		setZManual(0.0);
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#setZManual(double)
	 */
	public void setZManual(double zeroPoint) throws IOException
	{
	}	
	
	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroX()
	 */
	public void homeToZeroX() throws ReprapException, IOException{
		currentX = 0.0;
	}

	/* (non-Javadoc)
	 * @see org.reprap.Printer#homeToZeroY()
	 */
	public void homeToZeroY() throws ReprapException, IOException {
		currentY = 0.0;
	}
	
	public void homeToZeroZ() throws ReprapException, IOException {
		currentZ = 0.0;
	}
	
	public void home(){
		currentX = currentY = currentZ = 0.0;
	}
	
	public double getMaxFeedrateX()
	{
		return maxFeedrateX;
	}

	public double getMaxFeedrateY()
	{
		return maxFeedrateY;
	}

	public double getMaxFeedrateZ()
	{
		return maxFeedrateZ;
	}
	
	/**
	 * Just finished a layer
	 * @param layerNumber
	 */
	public void finishedLayer(LayerRules lc) throws Exception
	{
		double datumX = getExtruder().getNozzleWipeDatumX();
		double datumY = getExtruder().getNozzleWipeDatumY();
//		double strokeX = getExtruder().getNozzleWipeStrokeX();
//		double strokeY = getExtruder().getNozzleWipeStrokeY();
		double coolTime = getExtruder().getCoolingPeriod();
		
		startCooling = -1;
		
		if(coolTime > 0 && (lc.getMachineLayer() != 0)) {
			getExtruder().setCooler(true);
			Debug.d("Start of cooling period");
			//setSpeed(getFastSpeed());
			setFeedrate(getFastFeedrateXY());
			
			// Go home. Seek (0,0) then callibrate X first
			homeToZeroX();
			homeToZeroY();
			startCooling = Timer.elapsed();
		}
		
		// If wiping, nudge the clearer blade
		if (getExtruder().getNozzleWipeEnabled())
		{

			// Now hunt down the wiper.
			moveTo(datumX, datumY, currentZ, false, false);

			
			//setSpeed(getExtruder().getXYSpeed());
			//setFeedrate(getExtruder().getXYFeedrate());
			
			//moveTo(datumX + strokeX, datumY+strokeY, currentZ, false, false);
			//moveTo(datumX, datumY, currentZ, false, false);
		}
	}
	
	/**
	 * Deals with all the actions that need to be done between one layer
	 * and the next.
	 */
	public void betweenLayers(LayerRules lc) throws Exception
	{
//		double clearTime = getExtruder().getNozzleClearTime();
				
		// Do half the extrusion between layers now
		
//		if (getExtruder().getNozzleWipeEnabled())
//		{
//			if(clearTime > 0)
//			{
//				getExtruder().setValve(true);
//				getExtruder().setMotor(true);
//				machineWait(500*clearTime);
//				getExtruder().setMotor(false);
//				getExtruder().setValve(false);
//			}
//		}
		
		// Now is a good time to garbage collect
		
		System.gc();
	}
	
	/**
	 * Just about to start the next layer
	 * @param layerNumber
	 */
	public void startingLayer(LayerRules lc) throws Exception
	{
		double datumX = getExtruder().getNozzleWipeDatumX();
		double datumY = getExtruder().getNozzleWipeDatumY();
		double strokeY = getExtruder().getNozzleWipeStrokeY();
		double clearTime = getExtruder().getNozzleClearTime();
		double waitTime = getExtruder().getNozzleWaitTime();
		double coolTime = getExtruder().getCoolingPeriod();
		
		if (layerPauseCheckbox != null && layerPauseCheckbox.isSelected())
			layerPause();
		
		if(isCancelled())
		{
			getExtruder().setCooler(false);
			return;
		}
		// Cooling period
		
		// How long has the fan been on?
		
		double cool = Timer.elapsed();
		if(startCooling >= 0)
			cool = cool - startCooling;
		else
			cool = 0;
		
		// Wait the remainder of the cooling period
		
		if(coolTime > cool && (lc.getMachineLayer() != 0))
		{	
			cool = coolTime - cool;
			machineWait(1000*cool);
		}
		// Fan off
		
		getExtruder().setCooler(false);
		
		// If we were cooling, wait for warm-up
		
		if(coolTime > 0 && (lc.getMachineLayer() != 0))
		{
			machineWait(200 * coolTime);			
			Debug.d("End of cooling period");			
		}
		
		// Do the clearing extrude then
		// Wipe the nozzle on the doctor blade

		if (getExtruder().getNozzleWipeEnabled())
		{
			if(clearTime > 0)
			{
				getExtruder().setValve(true);
				getExtruder().setMotor(true);
				machineWait(1000*clearTime);
				getExtruder().setMotor(false);
				getExtruder().setValve(false);
				machineWait(1000*waitTime);
			}
			//setSpeed(LinePrinter.speedFix(getExtruder().getXYSpeed(), 
			//		getExtruder().getOutlineSpeed(lc)));
			//setFeedrate(getExtruder().getOutlineFeedrate());
			moveTo(datumX, datumY + strokeY, currentZ, false, false);
		}
		
		setFeedrate(getFastFeedrateXY());
		//setSpeed(getFastSpeed());
	}

	

	
	/**
	 * Display a message indicating a segment is about to be
	 * printed and wait for the user to acknowledge
	 */
	protected void segmentPause() {
		try
		{
			extruders[extruder].setValve(false);
			extruders[extruder].setMotor(false);
		} catch (Exception ex) {}
		ContinuationMesage msg =
			new ContinuationMesage(null, "A new segment is about to be produced");
					//,segmentPauseCheckbox, layerPauseCheckbox);
		msg.setVisible(true);
		try {
			synchronized(msg) {
				msg.wait();
			}
		} catch (Exception ex) {
		}
		if (msg.getResult() == false)
			setCancelled(true);
		else
		{
			try
			{
				extruders[extruder].setExtrusion(extruders[extruder].getExtruderSpeed());
				extruders[extruder].setValve(false);
			} catch (Exception ex) {}
		}
		msg.dispose();
	}

	/**
	 * Display a message indicating a layer is about to be
	 * printed and wait for the user to acknowledge
	 */
	protected void layerPause() {
		ContinuationMesage msg =
			new ContinuationMesage(null, "A new layer is about to be produced");
					//,segmentPauseCheckbox, layerPauseCheckbox);
		msg.setVisible(true);
		try {
			synchronized(msg) {
				msg.wait();
			}
		} catch (Exception ex) {
		}
		if (msg.getResult() == false)
			setCancelled(true);
		msg.dispose();
	}

	/**
	 * Set the source checkbox used to determine if there should
	 * be a pause between segments.
	 * 
	 * @param segmentPause The source checkbox used to determine
	 * if there should be a pause.  This is a checkbox rather than
	 * a boolean so it can be changed on the fly. 
	 */
	public void setSegmentPause(JCheckBoxMenuItem segmentPause) {
		segmentPauseCheckbox = segmentPause;
	}

	/**
	 * Set the source checkbox used to determine if there should
	 * be a pause between layers.
	 * 
	 * @param layerPause The source checkbox used to determine
	 * if there should be a pause.  This is a checkbox rather than
	 * a boolean so it can be changed on the fly.
	 */
	public void setLayerPause(JCheckBoxMenuItem layerPause) {
		layerPauseCheckbox = layerPause;
	}

	public void setMessage(String message) {
		if (message == null)
			statusWindow.setVisible(false);
		else {
			statusWindow.setMessage(message);
			statusWindow.setVisible(true);
		}
	}
	
	public boolean isCancelled() {
		return statusWindow.isCancelled();
	}

	public void setCancelled(boolean isCancelled) {
		statusWindow.setCancelled(isCancelled);
	}
	
	/**
	 * @return the X stepper
	 */
	public GenericStepperMotor getXMotor()
	{
		return motorX;
	}
	
	/**
	 * @return the Y stepper
	 */
	public GenericStepperMotor getYMotor()
	{
		return motorY;
	}
	
	/**
	 * @return the Z stepper
	 */	
	public GenericStepperMotor getZMotor()
	{
		return motorZ;
	}
	
	public int getFoundationLayers()
	{
		return foundationLayers;
	}
	
	//TODO: MAKE THIS WORK!
	// Works for me! - AB
	public int convertFeedrateToSpeedXY(double feedrate)
	{
		//Debug.d("feedrate: " + feedrate);
		
		//pretty straightforward
		double stepsPerMinute = feedrate * scaleX;
		//Debug.d("steps/min: " + stepsPerMinute);
		
		//ticks per minute divided by the steps we need to take.
		double ticksBetweenSteps = 60000000.0 / (256.0 * stepsPerMinute);
		//Debug.d("ticks between steps: " + ticksBetweenSteps);

		int picTimer = 256 - (int)Math.round(ticksBetweenSteps);
		//Debug.d("pic timer: " + picTimer);
		
		//bounds checking.
		picTimer = Math.min(255, picTimer);
		picTimer = Math.max(0, picTimer);
		
		return picTimer;
	}

	
	//TODO: MAKE THIS WORK!
	public int convertFeedrateToSpeedZ(double feedrate)
	{
		//pretty straightforward
		double stepsPerMinute = feedrate * scaleZ;
		
		//ticks per minute divided by the steps we need to take.
//		long ticksBetweenSteps = Math.round(60000000 / 256 / stepsPerMinute);
//		int picTimer = (256 - (int)ticksBetweenSteps);
		double ticksBetweenSteps = 60000000.0 / (256.0 * stepsPerMinute);
		//Debug.d("ticks between steps: " + ticksBetweenSteps);
		
		//System.out.println("Z ticksBetweenSteps = " + ticksBetweenSteps);

		int picTimer = 256 - (int)Math.round(ticksBetweenSteps);
		
		//bounds checking.
		picTimer = Math.min(255, picTimer);
		picTimer = Math.max(0, picTimer);

		return picTimer;
	}
	
	public double getXStepsPerMM()
	{
		return scaleX;
	}
	public double getYStepsPerMM()
	{
		return scaleY;
	}
	public double getZStepsPerMM()
	{
		return scaleZ;
	}
	
	/**
	 * Load an STL file to be made.
	 * @return the name of the file
	 */
	public String addSTLFileForMaking()
	{
		gcodeLoaded = false;		
		stlLoaded = true;
		return org.reprap.Main.gui.onOpen();
	}

	/**
	 * Load a GCode file to be made.
	 * @return the name of the file
	 */
	public String loadGCodeFileForMaking()
	{
		if(stlLoaded)
			org.reprap.Main.gui.deleteAllSTLs();
		stlLoaded = false;
		gcodeLoaded = true;
		return null;
	}
	
	/**
	 * Stop the printer building.
	 * This _shouldn't_ also stop it being controlled interactively.
	 */
	public void pause()
	{
	}
	
	/**
	 * Resume building.
	 *
	 */
	public void resume()
	{
	}
}