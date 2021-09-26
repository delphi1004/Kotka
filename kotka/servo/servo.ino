#include <Servo.h>

Servo servoWaveDir;
Servo servoWaveHeight;

int waveDir = 0;
int waveHeight = 0;

void setup() {
  Serial.begin(9600);
  servoWaveDir.attach(9);
  servoWaveHeight.attach(10);
}

void loop() {
  if(Serial.available() > 0)
  {
    int tempWaveDir = Serial.parseInt();
    int tempWaveHeight = Serial.parseInt();

    moveWaveDir(tempWaveDir);
    moveWaveHeight(tempWaveHeight);
    
    Serial.print(waveDir);
    Serial.print(",");
    Serial.print(waveHeight);
    Serial.print(",");
    Serial.print("!");
  }
}

void moveWaveDir(int target)
{
  if(target >= waveDir)
  {
    for(int i=waveDir;i<=target;i++)
    {
      servoWaveDir.write(i);
      delay(40);
    }
   
  }else{
    for(int i=waveDir;i>=target;i--)
    {
      servoWaveDir.write(i);
      delay(40);
    }    
  }
  waveDir = target;
}

void moveWaveHeight(int target)
{
  if(target >= waveHeight)
  {
    for(int i=waveHeight;i<=target;i++)
    {
      servoWaveHeight.write(i);
      delay(40);
    }
   
  }else{
    for(int i=waveHeight;i>=target;i--)
    {
      servoWaveHeight.write(i);
      delay(40);
    }    
  }
  waveHeight = target;
}
