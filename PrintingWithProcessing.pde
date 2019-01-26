Printer printer;
Drawing drawing = new Drawing();
Drawing copy;
PApplet app = this;
Generator generator = new Generator(drawing);
boolean editMode = true;
float effect, toEffect;
float xRot, zRot;
float mm2px = 5; //100mm = 500px

void setup() {
  size(500, 500, P3D);
  //printer = new Printer(this, "/dev/tty.usbmodem14201", 250000);
  //printer.setBrightness(0);
  resetDrawing();
}

void resetDrawing() {
  drawing.clear();
  drawing.beginDraw();
  for (int i=0,n=10; i<=n; i++) {
    float f = float(i)/n % 1;
    float r = 25;
    drawing.vertex(sin(f*TWO_PI)*r, cos(f*TWO_PI)*r);
  }
  drawing.endDraw();
  PVector c = drawing.shape.getCenter();
  drawing.shape.translate(-c.x, -c.y);
}

void mousePressed() {
  if (editMode) drawing.beginDraw();
}

void mouseDragged() {
  if (editMode) {
    drawing.vertex((mouseX-width/2)/mm2px, (mouseY-height/2)/mm2px);
  } else {
    xRot -= (mouseY-pmouseY)*.01;
    zRot -= (mouseX-pmouseX)*.01;
  }
}

void mouseReleased() {
  if (editMode) {
    drawing.endDraw();
    drawing.shape.simplify(5,1);
  }
}

void draw() {
  background(0);
  translate(width/2, height/2);
  noFill();
  stroke(255);
  //scale(2);
  scale(mm2px);
  strokeWeight(2/mm2px);

  effect = lerp(effect, toEffect, .1);

  translate(0, effect*.25*height/mm2px);    
  rotateX(HALF_PI*.9*effect);
  rotateX(xRot*effect);
  rotateZ(zRot*effect);
  scale(1-.5*effect);

  fill(100);
  box(generator.dimensions.x, generator.dimensions.y, 1);
  noFill();
  translate(0, 0, 1);

  if (effect<.2) {
    stroke(255, 255, 0);
    //generator.drawSlice(0);
    drawing.draw();
  } else {
    stroke(255, 255, 0, 50);
    //int n = int(map(effect,.2,1,0,100));

    int n = int(generator.objectHeight/generator.layerHeight / 3);
    for (int i=0; i<n; i++) {
      float g = float(i)/n;
      pushMatrix();
      translate(0, 0, g*map(effect, .2, 1, 0, generator.objectHeight));
      generator.drawSlice(g);
      popMatrix();
    }
  }
}

void keyPressed() {
  if (key=='e') {
    editMode=!editMode;
    toEffect = editMode ? 0 : 1;
  }

  if (key=='h') generator.objectHeight++;
  if (key=='H') generator.objectHeight--;
  if (key=='q') { 
    printer.stop();
    for (String s : loadStrings("end.gcode")) printer.send(s);
  }

  if (key=='i') println(drawing.shape.size());

  if (key=='g') {
    for (String s : loadStrings("start.gcode")) println(s);
    for (String s : generator.getGCode()) println(s);
    for (String s : loadStrings("end.gcode")) println(s);
  }

  if (key=='p') {
    for (String s : loadStrings("start.gcode")) printer.send(s);
    for (String s : generator.getGCode()) printer.send(s);
    for (String s : loadStrings("end.gcode")) printer.send(s);
  }
  
  if (key=='o') {
    for (Shape s: drawing) {
      s.simplify(5,1); //try 5 times to realize min distance between points of 1mm
    }
  }

  if (key=='x') printer.setBrightness(mouseX);
  if (key=='y') printer.sendFile("happybirthday_01.nc");
  if (key=='c') drawing.clear();   //resetDrawing();
 

  if (key=='r') drawing.rotateAroundLocalCenter(.1);
  if (key=='R') drawing.rotateAroundCenter(.1);
  if (key=='t') generator.twist+=.02;
  if (key=='T') generator.twist-=.02;
  if (keyCode==RIGHT) drawing.translate(5, 0);
  if (keyCode==LEFT) drawing.translate(-5, 0);
}

float smoothstep(float x, float min, float max) {   
  float t = constrain((x - min) / (max - min), 0.0, 1.0);
  return t * t * (3.0 - 2.0 * t);
}
