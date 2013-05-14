import codeanticode.syphon.*;
import themidibus.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

SyphonServer syphonServer;
MidiBus midi;
Minim minim;
AudioInput in;

// midi channels are zero indexed!
int midiChannel = 0;
float vol;

float depth = 0;
float tunnelSpeed = 5;
int spacing = 250;
int centreRectWidth = 138;
int centreRectHeight = 78;

int boxSize = 200;
int maxBoxSize = 700;
float boxRotateXSpeed = 0.3;
float boxRotateYSpeed = 0.1;
float boxRotateZSpeed = 0.1;
float boxFactor1 = 10;
float boxFactor2 = 5;
float boxFactor3 = 0.5;
boolean movingBox = false;

void setup() {
  size(1280, 720, P3D);
  smooth();
  stroke(255);
  strokeWeight(2);
  syphonServer = new SyphonServer(this, "Processing frame server");
  midi = new MidiBus(this, "MPK mini", -1);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
}

void changeDepth() {
  depth -= tunnelSpeed;
  if (depth <= -1000) {
    depth = 0;
  }
}

void linesToCentreRect() {
  int x = width/2 - centreRectWidth/2;
  int y = height/2 - centreRectHeight/2;
  line(0, 0, x, y);
  line(0, height, x, y + centreRectHeight);
  line(width, 0, x + centreRectWidth, y);
  line(width, height, x + centreRectWidth, y + centreRectHeight);
}

void movingRectangles() {
  noFill();
  for (int i = 0; i < 25; i++) {
    pushMatrix();
    translate(0, 0, -i * spacing - depth);
    rect(0, 0, width, height);
    popMatrix();
  }
}

void theBox() {
  pushMatrix();
  translate(width * 0.5, height * 0.5, 100);
  rotateX(radians(frameCount * boxRotateXSpeed));
  rotateY(radians(frameCount * boxRotateYSpeed));
  rotateZ(radians(frameCount * boxRotateZSpeed));
  fill(vol/boxFactor1, vol/boxFactor2, vol/boxFactor3);
  box(boxSize);
  if (movingBox) {
    boxSize -= 2;
    if (boxSize <= 0) {
      boxSize = maxBoxSize;
    }
  }
  popMatrix();
}

void setStrokeWeightFromVolume() {
  vol = 0;
  for (int i = 0; i < in.bufferSize(); i++) {
    vol += abs(in.mix.get(i));
  }
  strokeWeight(max(1, vol/10));
}

void draw() {
  background(0);
  setStrokeWeightFromVolume();
  changeDepth();
  linesToCentreRect();
  movingRectangles();
  theBox();
  syphonServer.sendImage(g);
}

void keyTyped() {
  switch (int(key)) {
    case 48: movingBox = !movingBox;
             break;
    default: println(int(key));
             break;
  }
}

void controllerChange(int channel, int number, int value) {
  if (channel != midiChannel) return;
  switch (number) {
    case 1: boxSize = value * 2;
            break;
    case 2: tunnelSpeed = value;
            break;
    default: break;
  }
}

void stop() {
  midi.stop();
  in.close();
  minim.stop();
  super.stop();
}

