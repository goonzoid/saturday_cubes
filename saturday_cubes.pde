import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;

float vol;
float depth = 0;
float zSpeed = 5;
int boxRotateXSpeed = 3;
int boxRotataYSpeed = 1;
int spacing = 250;
int centreRectWidth = 130;
int centreRectHeight = 74;
int boxSize = 200;
int maxBoxSize = 700;
boolean movingBox = false;
float boxFactor1 = 10;
float boxFactor2 = 5;
float boxFactor3 = 0.5;

void setup() {
  size(1280, 720, P3D);
  smooth();
  stroke(255);
  strokeWeight(2);

  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512);
}

void changeDepth() {
  depth -= zSpeed;
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
  rotateY(radians(frameCount * boxRotateXSpeed));
  rotateX(radians(frameCount * boxRotataYSpeed));
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
}

void keyTyped() {
  switch (int(key)) {
    case 49: boxSize = 50;
             break;
    case 50: boxSize = 75;
             break;
    case 51: boxSize = 125;
             break;
    case 52: boxSize = 175;
             break;
    case 53: boxSize = 250;
             break;
    case 54: boxSize = 325;
             break;
    case 55: boxSize = 400;
             break;
    case 56: boxSize = 500;
             break;
    case 57: boxSize = 600;
             break;
    case 48: movingBox = !movingBox;
             break;
    default: println(int(key));
             break;
  }
}

void stop() {
  in.close();
  minim.stop();
  super.stop();
}

