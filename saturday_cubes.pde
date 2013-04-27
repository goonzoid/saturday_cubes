float depth = 0;
float zSpeed = 5;
int boxRotateXSpeed = 3;
int boxRotataYSpeed = 1;
int spacing = 250;
int centreRectWidth = 126;
int centreRectHeight = 70;
int boxSize, maxBoxSize = 600;

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

void centreRectangleAndLines() {
  fill(255);
  int rectX = width/2 - centreRectWidth/2;
  int rectY = height/2 - centreRectHeight/2;
  rect(rectX, rectY, centreRectWidth, centreRectHeight);
  lines(rectX, rectY);
}

void lines(int x, int y) {
  line(0, 0, x, y);
  line(0, height, x, y + centreRectHeight);
  line(width, 0, x, y + centreRectHeight);
  line(width, height, x + centreRectWidth, y + centreRectHeight);
}

void movingRectangles() {
  noFill();
  for (int i = 0; i < 50; i++) {
    pushMatrix();
    translate(0, 0, -i * spacing - depth);
    rect(0, 0, width, height);
    popMatrix();
  }
}

void theBox() {
  pushMatrix();
  translate(width * 0.5, height * 0.5);
  rotateY(radians(frameCount * boxRotateXSpeed));
  rotateX(radians(frameCount * boxRotataYSpeed));
  fill(0, 0, 0);
  box(boxSize);
  boxSize -= 2;
  if (boxSize <= 0) {
    boxSize = maxBoxSize;
  }
  popMatrix();
}

void draw() {
  background(0);
  changeDepth();
  centreRectangleAndLines();
  movingRectangles();
  theBox();
}

