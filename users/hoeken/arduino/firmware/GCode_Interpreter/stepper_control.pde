void dwell(int time)
{
   delay(time); 
}

void move(int steppin, int dirpin, int distance, int dir, int speed)
{
  digitalWrite(dirpin, dir);
  for (int i=0; i<distance; i++)
  {
    digitalWrite(steppin, HIGH);
    delayMicroseconds(2);
    digitalWrite(steppin, LOW);
    delayMicroseconds(speed);        
  }
}

//TODO: look into interupts for moving multiple axis
void moveXYZ(int distanceX, int distanceY, int distanceZ, int speed)
{
  int dirX; int dirY; int dirZ;
  
  (distanceX < 0)?(dirX=0):(dirX=1);
  (distanceY < 0)?(dirY=0):(dirY=1);
  (distanceZ < 0)?(dirZ=0):(dirZ=1);  
  
  distanceX = abs(distanceX);
  distanceY = abs(distanceY);
  distanceZ = abs(distanceZ);
  
  int slopeX = distanceX;
  int slopeY = distanceY;
  int slopeZ = distanceZ;  //TODO: add z slope

  for (int i = slopeX * slopeY; i > 1; i--)
  {
    if ((slopeX % i == 0) && (slopeY % i == 0))
    {
       slopeX /= i;
       slopeY /= i;
    }
  }

  while (distanceX > 0 | distanceY > 0 | distanceZ > 0)
  {
    move(stepPinX, dirPinX, slopeX, dirX, speed);
    move(stepPinY, dirPinY, slopeY, dirY, speed);
    move(stepPinZ, dirPinZ, slopeZ, dirZ, speed);
    distanceX -= slopeX;
    distanceY -= slopeY;
    distanceZ -= slopeZ;
  } 
}
