class Drawing extends ArrayList<Shape> {

  Shape shape; //current shape

  void beginDraw() {
    shape = new Shape();
    super.add(shape);
  }

  void vertex(float x, float y) {
    shape.vertex(x, y);
  }

  void endDraw() {
    //
  }

  void clear() {
    super.clear();
    shape = null;
  }

  Drawing clone() {
    Drawing clone = new Drawing();
    for (Shape s : this) {
      clone.beginDraw();
      for (PVector v : s) {
        clone.vertex(v.x, v.y);
      }
    }
    clone.endDraw();
    return clone;
  }

  void translate(float x, float y) {
    for (Shape s : this) s.translate(x, y);
  }

  void rotate(float a) {
    for (Shape s : this) s.rotate(a);
  }

  void scale(float sc) {
    for (Shape s : this) s.scale(sc);
  }

  void rotateAround(float a, float x, float y) {
    for (Shape s : this) s.rotateAround(a, x, y);
  }

  void rotateAround(float a, PVector p) {
    for (Shape s : this) s.rotateAround(a, p.x, p.y);
  }

  void rotateAroundCenter(float a) {
    rotateAround(a, getCenter());
  }

  void rotateAroundLocalCenter(float a) {
    for (Shape s : this) s.rotateAroundLocalCenter(a);
  }

  void scaleFromLocalCenter(float sc) {
    for (Shape s : this) s.scaleFromLocalCenter(sc);
  }

  PVector getCenter() {
    PVector avg = new PVector();
    for (Shape s : this) {
      avg.add(s.getCenter());
    }
    avg.div(size());
    return avg;
  }

  void draw() {
    for (Shape s : this)
      s.draw();
  }
} 
