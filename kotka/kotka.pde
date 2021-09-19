import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup()
{ 
  size(500, 500);
  background(255);
  openOSC();
}

void openOSC()
{
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000); //port 3107

  println("its working");
}

void setPosition(PVector pos)
{
  OscMessage myMessage = new OscMessage("/xyh");
  myMessage.add(pos.x);
  myMessage.add(pos.y);
  myMessage.add(pos.z);
  oscP5.send(myMessage, myRemoteLocation);   
}

void draw() {
  
  setPosition(new PVector(100,200,300));
}
