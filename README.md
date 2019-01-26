# Welcome!

Since a 3D-printer is 'just' a simple robot controlled by even simpler commands you can be totally in charge of how the printer moves and when and how much plastic it extrudes when you write your own code to control it.

During the workshop you will learn to write your own code in Processing to steer one of the eight Ultimaker 2go 3D-printers available during the day. 

By writing your own code you can print things not possible with regular 3D-printing software. 

Whether you want to create generative 3D-designs, use it as a live 3D-sketching tool or something completely different... is up to you.

Enjoy!

![](https://user-images.githubusercontent.com/156066/51444802-d6a53b80-1cfc-11e9-8a65-77f44da3b255.png)


# code
```
PApplet app = this;
Printer printer;
float extrusion;
Shape shape = new Shape();

void setup() {
  size(500, 500);
  //printer = new Printer(this, "/dev/tty.usbmodem14101", 250000);
  //printer.send("G28");
  //printer.beep();
  //printer.sendFile("start.gcode");

  noFill();

  shape.vertex(0, 0);
  shape.vertex(100, 0);
  shape.vertex(100, 100);
  shape.vertex(0, 100);
  shape.vertex(0, 0);

  generateGCode(shape);
}

void generateGCode(Shape shape) {
  float filamentThickness = 3;
  float layerHeight = .2;
  float nozzleDiameter = .4;
  float filamentSurfaceArea = pow((filamentThickness / 2), 2) * PI;
  float lineSurfaceArea = nozzleDiameter * layerHeight;
  float nozzleToFilamentRatio = lineSurfaceArea / filamentSurfaceArea;
  float flowRate = 1;
  
  if (shape.size()==0) return;
  PVector prev = (PVector)shape.get(0);

  for (PVector v : shape) {
    float lineLength = prev.dist(v) / 5;

    extrusion += nozzleToFilamentRatio * lineLength * flowRate;
    
    println(
      "G1 X" + v.x/5 + 
      " Y" + v.y/5 + 
      " Z0.2 " + 
      " E" + extrusion + 
      " F5000");
    }


}

void draw() {
  shape.draw();
}

void keyPressed() {
  if (key=='q') {
    printer.stop();
    printer.sendFile("end.gcode");
  }
}
``` 
