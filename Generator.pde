class Generator {

  //Drawing drawing;

  //object settings
  PVector dimensions = new PVector(120, 120, 110);
  float objectHeight = 100;
  float layerHeight = .2;
  float twist = .5;
  float filamentThickness = 3;
  float wallThickness = .4;
  float nozzleDiameter = .4;

  Generator(Drawing d) {
    drawing = d;
  }
  
  void drawSlice(float f) {
    Drawing layer = getLayerWithEffects(f);
    layer.draw();
  }

  Drawing getLayerWithEffects(float f) {
    Drawing layer = drawing.clone();
    layer.rotateAroundLocalCenter(f * twist * TWO_PI);
    layer.scale(abs(sin(f*TWO_PI))*.5+.5);
    return layer;
  }

  ArrayList<String> getGCode() {
    ArrayList<String> gcode = new ArrayList();
    int numLayers = int(objectHeight / layerHeight);
    float extrusion = 0;
    float flow = .5;

    for (int i=0; i<numLayers; i++) {
      float f = float(i)/numLayers;
      float z = i*layerHeight;
      Drawing layer = getLayerWithEffects(f);
      layer.rotate(PI); //rotate 180
      layer.translate(generator.dimensions.x/2, generator.dimensions.y/2);

      gcode.add("G0 Z" + z + " F12000"); //fast z move on new layer

      for (Shape shape : layer) {
        if (shape.size()==0) continue;
        PVector prev = (PVector)shape.get(0);
        for (PVector to : shape) {
          float filamentSurfaceArea = pow((filamentThickness / 2), 2) * PI;
          float lineSurfaceArea = nozzleDiameter * layerHeight;
          float nozzleToFilamentRatio = lineSurfaceArea / filamentSurfaceArea;
          float lineLength = prev.dist(to);
          float flowRate = 1;
          extrusion += nozzleToFilamentRatio * lineLength * flowRate;
          //extrusion += wallThickness * layerHeight / filamentThickness) * flow;
          gcode.add("G1 X" + to.x + " Y" + to.y + " Z" + z + " E" + extrusion + " F4500");
          prev.set(to);
        }
      }
    }
    return gcode;
  }
}
