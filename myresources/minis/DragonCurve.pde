import java.util.*;

static final float SQRT3D6 = (float)sqrt(3)/6;

int numSteps;
public ArrayList<Line> lines;
public ArrayList<Line> tempLines;
public ArrayList<PVector> cacheKey;
public ArrayList<PVector[]> cache;
public int currentPhase = 0;
public int stepSize = 1;
int i;
int lastI;

void setup() {
  size(800, 600);
  
  lines = new ArrayList<Line>();
  lines.add(new Line());
  cacheKey = new ArrayList<PVector>();
  cache = new ArrayList<PVector[]>();
  tempLines = new ArrayList<Line>();
  
  i = 0;
  lastI = 0;
  numSteps = 0;
  noLoop();
}

void draw() {
  background(28);
  textSize(30);
  fill(255,153,0);
  stroke(255,153,0);
  text("Step #: "+numSteps, 20, 40);
  
  for (Drawable l: lines) {
    l.draw();
  }
  
  for (Line l: tempLines) {
    l.draw();
  }
  
  if (i < lastI) {
    for (int j = 0; j < stepSize && i < lastI; j++) {
      lines.get(i).split();
      lines.set(i, new Line(new PVector(0,0), new PVector(0,0)));
      i++;
    }
  }
}

//Progresses to next phase in fractal
void step() {
  if (i >= lastI) {
    if (numSteps > 0) {
      lines = tempLines;
      tempLines = new ArrayList<Line>();
      cacheKey = new ArrayList<PVector>();
      cache = new ArrayList<PVector[]>();
    }
      
    i = 0;
    lastI = lines.size();
    stepSize = (int) pow(lastI/64, 1.2) + 1;

    numSteps++;
  }
}

class Drawable {
  
  Drawable() {
    
  }
  
  void draw() {
  
  }
}

class Line extends Drawable{
  PVector p1;
  PVector p2;
  PVector v;
  
  Line(PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
    v = PVector.sub(p2, p1);
  }
  
  Line() {
    this(new PVector(width*4/16, height*12/16), new PVector(width*12/16, height*12/16));
  }
  
  void split() {
    //Crown Curve this(new PVector(width*5/16, height*10/16), new PVector(width*11/16, height*10/16));
    PVector[] vectors;
    if (cacheKey.contains(v)) {
      vectors = cache.get(cacheKey.indexOf(v));
    }
    else {
      PVector x = clone(v);
      PVector y = new PVector(v.y, -v.x);
      vectors = new PVector[1];
      
      vectors[0] = PVector.mult(y, .5);
      vectors[0].add(PVector.mult(x, .5));
      
      cacheKey.add(v);
      cache.add(vectors);
    }
    
    PVector a = PVector.add(p1, clone(vectors[0]));
    tempLines.add(new Line(clone(p1), a));
    tempLines.add(new Line(a, clone(p2)));
    
    //Demonic Curve this(new PVector(width*3/16, height*11/16), new PVector(width*13/16, height*11/16));
    /*PVector[] vectors;
    if (cacheKey.contains(v)) {
      vectors = cache.get(cacheKey.indexOf(v));
    }
    else {
      PVector x = clone(v);
      PVector y = new PVector(v.y, -v.x);
      vectors = new PVector[3];
      
      PVector t = PVector.mult(y, .25);
      vectors[0] = t;
      vectors[1] = PVector.mult(x, .5);
      vectors[1].add(PVector.mult(y, -.1));
      vectors[2] = x;
      vectors[2].add(t);
      
      cacheKey.add(v);
      cache.add(vectors);
    }
    
    tempLines.add(new Line(clone(p1), PVector.add(p1, clone(vectors[0])) ));
    tempLines.add(new Line(PVector.add(p1, clone(vectors[0])), PVector.add(p1, clone(vectors[1])) ));
    tempLines.add(new Line(PVector.add(p1, clone(vectors[1])), PVector.add(p1, clone(vectors[2])) ));
    tempLines.add(new Line(PVector.add(p1, clone(vectors[2])), clone(p2)));*/
    
    //Koch Snowflake this(new PVector(width*1/32, height*31/32), new PVector(width*31/32, height*31/32));
    /*PVector[] vectors;
    if (cacheKey.contains(v)) {
      vectors = cache.get(cacheKey.indexOf(v));
    }
    else {
      PVector x = clone(v);
      PVector y = new PVector(v.y, -v.x);
      vectors = new PVector[3];
      
      vectors[0] = PVector.mult(x, 1f/3);
      vectors[1] = PVector.mult(x, .5);
      vectors[1].add(PVector.mult(y, SQRT3D6));
      vectors[2] = PVector.mult(x, 2f/3);

      
      cacheKey.add(v);
      cache.add(vectors);
    }
    
    tempLines.add(new Line(clone(p1), PVector.add(p1, clone(vectors[0])) ));
    tempLines.add(new Line(PVector.add(p1, clone(vectors[0])), PVector.add(p1, clone(vectors[1])) ));
    tempLines.add(new Line(PVector.add(p1, clone(vectors[1])), PVector.add(p1, clone(vectors[2])) ));
    tempLines.add(new Line(PVector.add(p1, clone(vectors[2])), clone(p2)));*/
  }
  
  void draw() {
    line(p1.x, p1.y, p2.x, p2.y);
  }
  
  //HELPER METHOD
  public PVector clone(PVector p) {
    return new PVector(p.x, p.y);
  }
}