import netP5.*;
import oscP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;


void setup()
{
  size(500, 500);

  oscP5 = new OscP5(this, 12000);
}

void oscEvent(OscMessage theOscMessage) {
  float x=0;
  float y=0;
  float h=0;
  if (theOscMessage.checkAddrPattern("/xyh")==true)
  {
    x = theOscMessage.get(0).floatValue();
    y = theOscMessage.get(1).floatValue();
    h = theOscMessage.get(2).floatValue();
  }
  
  println("### received an osc ",x+ " "+y+" "+h);
}


void draw()
{
  ;
}
