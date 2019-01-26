class Shape extends ArrayList<PVector> {

  void vertex(float x, float y) {
    super.add(new PVector(x, y));
  }

  void draw() {
    app.beginShape();
    for (PVector v : this) {
      app.vertex(v.x, v.y);
    }
    app.endShape();
  }

  void translate(float x, float y) {
    for (PVector v : this) v.add(x, y);
  }

  void scale(float sc) {
    for (PVector v : this) v.mult(sc);
  }

  void rotate(float a) {
    for (PVector v : this) {
      float x = cos(a) * v.x - sin(a) * v.y;
      float y = sin(a) * v.x + cos(a) * v.y;
      v.x = x;
      v.y = y;
    }
  }

  void rotateAround(float a, float x, float y) {
    translate(-x, -y);
    rotate(a);
    translate(x, y);
  }

  void rotateAroundLocalCenter(float a) {
    PVector c = getCenter();
    rotateAround(a, c.x, c.y);
  }

  void scaleFromLocalCenter(float s) {
    PVector c = getCenter();
    translate(-c.x, -c.y);
    scale(s);
    translate(c.x, c.y);

    //rotateAround(a, c.x, c.y);
  }

  PVector getCenter() {
    PVector avg = new PVector();
    for (PVector v : this) avg.add(v);
    avg.div(size());
    return avg;
  }

  void simplify(int iterations, float distance) {
    for (int iteration=0; iteration<iterations; iteration++) {
      if (size()<3) continue; //min points
      for (int i=0; i<size()-2; i++) {
        PVector a = (PVector)get(i);
        PVector b = (PVector)get(i+1);
        if (a.dist(b)<distance) {
          a.set(a.add(b).div(2));
          remove(i+1);
        }
      }
    }
  }

}
