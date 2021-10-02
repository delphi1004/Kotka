import netP5.*;
import oscP5.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import processing.video.*;
import processing.serial.*;
import gab.opencv.*;
import java.awt.Rectangle;

JSONArray values;
Serial arduino;
Kinect kinect;
OscP5 oscP5;
OpenCV opencv;
NetAddress myRemoteLocation;

int interval = 5000;
int time = millis();
int waveIndex = 0;
float []waveDir;
float []waveHeight;
boolean isKinectLive = false;
boolean sendOnce = true;
ArrayList<Contour> contours;
ArrayList<Contour> polygons;
PImage depthImg;
int minDepth =  60;
int maxDepth = 900;

void setup()
{ 
  size(800, 600);
  background(255);

  openKinect();
  openOpenCv();
  openArduino();
  openWaveData();
  openOSC();
}

void openOpenCv()
{
  opencv = new OpenCV(this, 640, 480);
  opencv.startBackgroundSubtraction(5, 3, 0.5);
  depthImg = new PImage(kinect.width, kinect.height);
  println("OpenCV has started");
}

void openWaveData()
{
  String[] lines = loadStrings("wave_dir.txt");
  String []waveString = split(lines[0], ',');

  waveDir = new float[waveString.length];

  for (int i=0; i<waveString.length; i++)
  {
    waveDir[i] = float(waveString[i]);
  }

  lines = loadStrings("wave_height.txt");
  waveString = split(lines[0], ',');

  waveHeight = new float[waveString.length];

  for (int i=0; i<waveString.length; i++)
  {
    waveHeight[i] = float(waveString[i]);
  }

  println(waveDir[0], waveDir.length);
  println(waveHeight[0], waveHeight.length);
  println("---------------------");
}

void openArduino()
{
  println(Serial.list());
  arduino = new Serial(this, "COM3", 9600);
  arduino.write("0,0");
}

void openKinect()
{
  kinect = new Kinect(this);

  if (kinect.numDevices() > 0)
  {
    kinect.initDepth();
    kinect.enableIR(true);  
    kinect.enableMirror(true);
    isKinectLive = true;
    println("Kinect is working");
  } else
  {
    println("Can't found kinect sensor");
  }
}

void openOSC()
{
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000); //port 3107

  println("osc is working");
}

void setPosition(PVector pos)
{
  OscMessage myMessage = new OscMessage("/xyh");
  myMessage.add(pos.x);
  myMessage.add(pos.y);
  myMessage.add(pos.z);

  if (oscP5 != null)
  {
    oscP5.send(myMessage, myRemoteLocation);
  }
}

void traceMovement()
{
  int[] rawDepth;
  Rectangle box;
  float area;
  rawDepth = kinect.getRawDepth();

  for (int i=0; i < rawDepth.length; i++) {
    if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
      depthImg.pixels[i] = color(255);
    } else {
      depthImg.pixels[i] = color(0);
    }
  }

  opencv.loadImage(depthImg);  
  contours = opencv.findContours();

  noFill();
  strokeWeight(3);

  for (Contour contour : contours) 
  {
    box = contour.getBoundingBox();
    area = contour.area();
    if(area > 1000)
    {
      rect(box.x,box.y,box.width,box.height);
      text(area,box.x,box.y);
      setPosition(new PVector(box.x,box.y,box.height));
    }
  }
}

void draw() {
  
  background(0);
  stroke(255);
  
  if (isKinectLive) {
    traceMovement();
  }

  if (millis() - time >= interval && sendOnce) {
    sendWaveData();
    time = millis();
    sendOnce = false;
  }
}

void serialEvent(Serial p) { 
  String str = p.readString();
  print(str);

  if (str.equals("!")) {
    sendWaveData();
  }
} 

void sendWaveData()
{
  int tempWaveDir = (int)map(waveDir[waveIndex], 0, 360, 0, 180);
  int tempWaveHeight = (int)map(waveHeight[waveIndex], 0, 2.9, 0, 180);

  if (arduino != null)
  {
    arduino.write(tempWaveDir+","+tempWaveHeight);

    println("data sent :"+" "+tempWaveDir+","+tempWaveHeight);

    waveIndex++;

    if (waveIndex >= waveDir.length)
    {
      waveIndex = 0;
    }
  }
}

void mousePressed()
{
  int wave1 = (int)random(0, 180);
  int wave2 = (int)random(0, 180);

  arduino.write(wave1+","+wave2);
}
