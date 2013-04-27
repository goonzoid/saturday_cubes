float depth = 0;
float zSpeed = 5;
int spacing = 250;
int centreRectWidth = 126;
int centreRectHeight = 70;

void setup() {
  size(1280, 720, P3D);
  smooth();
  stroke(255);
  strokeWeight(2);
}

void changeDepth() {
  depth -= zSpeed;
  if (depth <= -1000) {
    depth = 0;
  }
}

void centreRectangle() {
  fill(255);
  int rectX = width/2 - centreRectWidth/2;
  int rectY = height/2 - centreRectHeight/2;
  rect(rectX, rectY, centreRectWidth, centreRectHeight);
}

void movingRectangles() {
  noFill();
  for (int i = 0; i < 100; i++) {
    pushMatrix();
    translate(0, 0, -i * spacing - depth);
    rect(0, 0, width, height);
    popMatrix();
  }
}

void draw() {
  background(0);
  changeDepth();
  centreRectangle();
  movingRectangles();
}
