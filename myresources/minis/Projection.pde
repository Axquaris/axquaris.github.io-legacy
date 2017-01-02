ArrayList<Line> lines;

int NUM_DIMS = 4;
float START_TURN = PI/4;
float FRAME_TURN = PI/512;

void setup() {
  size(800, 800);
  frameRate(30);
  
  newCube(4);
  
  for (Line l: lines) {
    for (int a = 0; a < NUM_DIMS-1; a++) {
      for (int b = a+1; b < NUM_DIMS; b++) {
        l.rotate(a, b, START_TURN);
      }
    }
  }
}

void newCube(int d) {
  NUM_DIMS = d;
  lines = new ArrayList<Line>();
  lines.addAll(buildCube(NUM_DIMS));
}

void draw() {
  background(255);
  
  pushMatrix();
  translate(width/2, height/2);
  scale(150);
  strokeWeight(.01);
  
  for (Line l: lines) {
    l.draw();
    
    for (int a = 0; a < NUM_DIMS-1; a++) {
      for (int b = a+1; b < NUM_DIMS; b++) {
        l.rotate(a, b, FRAME_TURN);
      }
    }
  }
  popMatrix();
  
  //println(lines.size());
}

ArrayList<Line> buildCube(int dims) {
  ArrayList<Line> cubeLines = new ArrayList<Line>();
  
  if (dims > 2) {
    ArrayList<Line> squareLines = buildCube(dims-1);
    
    float[] base = new float[dims];
    for (int i = 0; i < base.length; i++)
      base[i] = -1;
    
    //Expand
    for (int i = 0; i < dims; i++) {

      cubeLines.add(new Line(expandP(squareLines.get(0).p1, 0, 1), expandP(squareLines.get(0).p1, i, -1)));
      for (Line l: squareLines) {
        cubeLines.add(expandL(l, i, -1));
      }
    }
    
    /*/Remove dupes
    for (int i = 0; i < cubeLines.size()-1; i++) {
      for (int j = i+1; j < cubeLines.size(); j++) {
        if (cubeLines.get(i).equals(cubeLines.get(j)))
          cubeLines.remove(j);
      }
    }*/
  }
  else if (dims == 2) {
    float[] v1 = {1, 1};
    float[] v2 = {1, -1};
    float[] v3 = {-1, 1};
    float[] v4 = {-1, -1};
    
    cubeLines.add(new Line(v1, v2));
    cubeLines.add(new Line(v1, v3));
    cubeLines.add(new Line(v4, v2));
    cubeLines.add(new Line(v4, v3));
  }
  else {
    print("BAD CUBE REQUEST");
  }
  
  return cubeLines;
}

// EXAMPLE:   0 X 1 X 2 X 3
Line expandL(Line l, int pos, int x) {
  float[] v1 = new float[l.p1.n+1];
  float[] v2 = new float[l.p2.n+1];
  
  for (int i = 0; i < v1.length; i++) {
    if (i < pos) {
      v1[i] = l.p1.vN[i];
      v2[i] = l.p2.vN[i];
    }
    else if (pos < i) {
      v1[i] = l.p1.vN[i-1];
      v2[i] = l.p2.vN[i-1];
    }
    else {
      v1[i] = x;
      v2[i] = x;
    }
  }
  
  return new Line(v1, v2);
}

Point expandP(Point p, int pos, int x) {
  float[] e = new float[p.n+1];
  
  for (int i = 0; i < e.length; i++) {
    if (i < pos) {
      e[i] = p.vN[i];
    }
    else if (pos < i) {
      e[i] = p.vN[i-1];
    }
    else {
      e[i] = x;
    }
  }
  
  return new Point(e);
}

float[] expandV(float[] v, int pos, int x) {
  float[] e = new float[v.length+1];
  
  for (int i = 0; i < v.length; i++) {
    if (i < pos) {
      e[i] = v[i];
    }
    else if (pos < i) {
      e[i] = v[i-1];
    }
    else {
      e[i] = x;
    }
  }
  
  return e;
}

void print(float[] a) {
  for (float f: a)
    print(f+" ");
  println();
}

void keyPressed() {
  if (key == '2') newCube(2);
  if (key == '3') newCube(3);
  if (key == '4') newCube(4);
  if (key == '5') newCube(5);
  if (key == '6') newCube(6);
  //if (key == '7') newCube(7); //Too many lines
}

class Line {
  Point p1;
  Point p2;
  
  Line(float[] v1, float[] v2) {
    p1 = new Point(v1);
    p2 = new Point(v2);
  }
  
  Line(Point ip1, Point ip2) {
     p1 = ip1;
     p2 = ip2;
  }
  
  void rotate(int a1, int a2, float angleD) {
    p1.rotate(a1, a2, angleD);
    p2.rotate(a1, a2, angleD);
  }
  
  void draw() {
    //print(p1.v2);
    //print(p2.v2);
    line(p1.v2[0], p1.v2[1], p2.v2[0], p2.v2[1]);
  }
  
  boolean equals(Line o) {
    return p1.equals(o.p1) && p2.equals(o.p2);
  }
}
class Point {
  int n;
  float[] vN;
  float[] v2;
  
  public Point(float[] inD) {
    vN = inD;
    n = vN.length;
    
    updateV2();
  }
  
  void updateV2() {
    if (vN.length == 2) {
      v2 = vN;
      return;
    }
    
    float[] vX = new float[n];
    float[] vY = new float[n];
    
    vX[0] = 1;
    vX[1] = 0;
    vY[0] = 0;
    vY[1] = 1;
    
    float cX = dot(vN, vX) / dot(vX, vX);
    float cY = dot(vN, vY) / dot(vY, vY);
    
    v2 = new float[2];
    v2[0] = cX;
    v2[1] = cY;
  }
  
  // ROTATES ABOUT THE ORIGIN a1 => X, a2 => Y
  void rotate(int a1, int a2, float angleD) {
    float angle = atan2(vN[a2], vN[a1]);
    float magnitude = sqrt(vN[a1]*vN[a1] + vN[a2]*vN[a2]);
    
    vN[a1] = magnitude*cos(angle+angleD);
    vN[a2] = magnitude*sin(angle+angleD);
    
    updateV2();
  }
  
  float dot(float[] a, float[] b) {
    float sum = 0;
    
    for (int i = 0; i < a.length; i++) {
      sum += a[i] * b[i];
    }
    
    return sum;
  }
  boolean equals(Point o) {
    for (int i = 0; i < vN.length; i++) {
      if (vN[i] != o.vN[i])
        return false;
    }
    return true;
  }
}