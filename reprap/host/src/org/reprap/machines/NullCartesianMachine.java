package org.reprap.machines;

import java.io.IOException;
import java.util.Properties;

import org.reprap.CartesianPrinter;
import org.reprap.ReprapException;
import org.reprap.gui.Previewer;

public class NullCartesianMachine implements CartesianPrinter {
	
	private Previewer previewer = null;

	double totalDistanceMoved = 0.0;
	double totalDistanceExtruded = 0.0;
	
	double currentX, currentY, currentZ;
	
	public NullCartesianMachine(Properties config) {
		currentX = 0;
		currentY = 0;
		currentZ = 0;
	}
	
	public void calibrate() {
	}

	public void printSegment(double startX, double startY, double startZ, double endX, double endY, double endZ) throws ReprapException, IOException {
		moveTo(startX, startY, startZ);
		printTo(endX, endY, endZ);
	}

	public void moveTo(double x, double y, double z) throws ReprapException, IOException {
		if (isCancelled()) return;

		currentX = x;
		currentY = y;
		currentZ = z;
	}

	public void printTo(double x, double y, double z) throws ReprapException, IOException {
		if (previewer != null)
			previewer.addSegment(currentX, currentY, currentZ, x, y, z);
		if (isCancelled()) return;

		currentX = x;
		currentY = y;
		currentZ = z;
	}

	public void selectMaterial(int materialIndex) {
		if (isCancelled()) return;
		if (previewer != null)
			previewer.setMaterial(materialIndex);
	}

	public void terminate() throws IOException {
	}

	public int getSpeed() {
		return 200;
	}

	public void setSpeed(int speed) {
	}

	public int getExtruderSpeed() {
		return 200;
	}

	public void setExtruderSpeed(int speed) {
	}

	public void setPreviewer(Previewer previewer) {
		this.previewer = previewer;
	}

	public void setTemperature(int temperature) {
	}

	public void dispose() {
	}

	public boolean isCancelled() {
		return previewer.isCancelled();
	}

	public void initialise() {
		previewer.reset();
	}

	public double getX() {
		return currentX;
	}

	public double getY() {
		return currentY;
	}

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

}
