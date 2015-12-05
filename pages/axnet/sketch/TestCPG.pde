import de.bezier.guido.*;

//UI Stuff
  UiSlider weightA;
  UiSlider weightB;
  UiSlider weightC;
  UiSlider weightD;
  UiSlider biasA;
  UiSlider biasB;
  UiGrapherIII graph;
  int frame;
  
  //Tester Program
  Neuron n1;
  Neuron n2;

void setup() {
  size(600, 400);
  Interactive.make(this);
  
  n1 = new Neuron(2);
  n2 = new Neuron(2);
  n1.addInput(n1, 1);
  n1.addInput(n2, 1);
  n2.addInput(n2, 1);
  n2.addInput(n1, 1);
  n1.setBias(1);
  n2.setBias(1);
  
  
  //UI
  setupUi();
  frame = 0;
  noLoop();
}

void draw() { 
  background(89, 123, 150);
  
  updateVars();
  if (frame % 2 == 0) {
    n1.process();
    n2.process();
  }
  graph.plotA(n1.getOutputJS());
  graph.plotB(n2.getOutputJS());
  graph.plotC(n1.getOutputJS()+n2.getOutputJS());
  
  //UI
  graph.render();
  strokeWeight(1);
  stroke(0);
  line(0, 85, width, 85);
  line(0, 125, width, 125);
  textSize( 20 );
  textAlign( CENTER, CENTER );
  fill(0);
  text("W", width/2+1, 48);
  text("B", width/2, 106);
  frame++;
}

void updateVars() {
  n1.setWeightJS(weightB.getValue(), 0);
  n1.setWeightJS(weightA.getValue(), 1);
  n2.setWeightJS(weightC.getValue(), 0);
  n2.setWeightJS(-weightA.getValue(), 1);
  n1.setBias(biasA.getValue());
  n2.setBias(biasB.getValue());
}

void setupUi() {
  weightA = new UiSlider(10, 10, 580, 30, -1.5, 1.5, 1);
  weightA.button = color(83, 81, 84);
  
  weightB = new UiSlider(10, 50, 280, 30, -1.5, 1.5, 1);
  weightB.button = color(218, 124, 48);
  weightC = new UiSlider(310, 50, 280, 30, -1.5, 1.5, 1);
  weightC.button = color(57, 106, 177);
  
  biasA = new UiSlider(10, 90, 280, 30, -1.5, 1.5, .1);
  biasA.button = color(218, 124, 48);
  biasB = new UiSlider(310, 90, 280, 30, -1.5, 1.5, .1);
  biasB.button = color(57, 106, 177);
  
  graph = new UiGrapherIII(10, height-270, 580, 260, "Outputs");
}

public class Buffer {
  protected float output;
  
  public Buffer() {
    output = 0;
  }
  
  public void setOutput(float f) {
    output = f;
  }
  
  public float getOutputJS() {
    return output;
  }
  
  public float getOutput(int n) {
    return output;
  }
}

public class Neuron extends Buffer {
  private final float E = 2.71828183f;
  
  private Buffer[] inputs;
  private float[] weights;
  private float bias;
  
  private float lastOutput;
  private int timesFired;
  
  public Neuron(int numInputs) {
    inputs = new Buffer[numInputs];
    weights = new float[numInputs];
    
    for (int i = 0; i < numInputs; i++)
      inputs[i] = null;
    for (int i = 0; i < numInputs; i++)
      weights[i] = 1;
    bias = 0;
    
    timesFired = 0;
  }
  
  public void process() {
    //Activation Function
    float activation = 0;
    for (int i = 0; i < inputs.length; i++) {
      activation += inputs[i].getOutput(timesFired) * weights[i];
    }
    activation += bias;
    
    //Transfer Function
    lastOutput = output;
    output = 2 / (1 + pow(E, -2*activation)) - 1;
    timesFired++;
  }
  
  //Mutator Methods
  public int addInputJS(Buffer n) { //adds self to inputs of given neuron
    for(int i = 0; i < inputs.length; i++) {
      if(inputs[i] == null) {
        inputs[i] = n;
        return i;
      }
    }
    return -1;
  }
  
  public int addInput(Buffer n, float weight) {
    int i = addInputJS(n);
    if (i != -1)
      weights[i] = weight;
    return i;
  }
  
  public void setWeightJS(float w ,int i) {
    weights[i] = w;
  }
  
  public void setWeight(float w ,Buffer f) {
    for (int i = 0; i < inputs.length; i++) {
      if (inputs[i] == f)
        setWeightJS(w, i);
    }
  }
  
  public void setBias(float b) {
    bias = b;
  }
  
  //Acessor Methods
  public float getWeightJS(int i) {
    return weights[i];
  }
  
  public float getWeight(Buffer f) {
    for (int i = 0; i < inputs.length; i++) {
      if (inputs[i] == f)
        return getWeightJS(i);
    }
    System.err.println("ERROR AT NEURON "+this+".getWeight(Buffer f)");
    return 0;
  }
  
  public float getBias() {
    return bias;
  }
  
  public float getOutput(int otherTimesFired) {
    if (timesFired > otherTimesFired)
      return lastOutput;
    return output;
  }
}


public class UiGrapherIII{
  int x, y, w, h;
  String title;
  
  float[] pointsA, pointsB, pointsC;
  int pNA, pNB, pNC; //Number of points ready for plotting
  float max, min;
  
  //Layout Vars
  int edge = 25;
  int titleEdge = 30;
  int numberEdge = 30;
  
  UiGrapherIII(int x, int y, int w, int h, String title) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.title = title;
    
    pointsA = new float[w - edge - numberEdge];
    pNA = 0;
    pointsB = new float[w - edge - numberEdge];
    pNB = 0;
    pointsC = new float[w - edge - numberEdge];
    pNC = 0;
    max = 1;
    min = 0;
  }
  
  void plotA (float p){
    for (int i = pointsA.length-1; i > 0; i--) {
      pointsA[i] = pointsA[i-1];
    }
    pointsA[0] = p;
    if (p > max) max = p;
    if (p < min) min = p;
    
    if (pNA < pointsA.length){
      pNA++;
    }
  }
  
  void plotB (float p){
    for (int i = pointsB.length-1; i > 0; i--) {
      pointsB[i] = pointsB[i-1];
    }
    pointsB[0] = p;
    if (p > max) max = p;
    if (p < min) min = p;
    
    if (pNB < pointsB.length){
      pNB++;
    }
  }
  
  void plotC (float p){
    for (int i = pointsC.length-1; i > 0; i--) {
      pointsC[i] = pointsC[i-1];
    }
    pointsC[0] = p;
    if (p > max) max = p;
    if (p < min) min = p;
    
    if (pNB < pointsC.length){
      pNC++;
    }
  }
  
  void render(){
    
    fill(200);
    rect(x, y, w, h);
    strokeWeight(1);
    line(x+numberEdge, y+map(0, min, max, h-edge, titleEdge), x+w-numberEdge, y+map(0, min, max, h-edge, titleEdge));
    
    strokeWeight(3);
    pushMatrix();
    strokeCap(ROUND);
    //Draws graphs
    stroke(83, 81, 84);
    for (int i = 0; i < pNC-1; i++) {
      line(x+numberEdge+i, getPosC(i), x+numberEdge+(i), getPosC(i+1));
    }
    stroke(57, 106, 177);
    for (int i = 0; i < pNB-1; i++) {
      line(x+numberEdge+i, getPosB(i), x+numberEdge+(i), getPosB(i+1));
    }
    stroke(218, 124, 48);
    for (int i = 0; i < pNA-1; i++) {
      line(x+numberEdge+i, getPosA(i), x+numberEdge+(i), getPosA(i+1));
    }
    popMatrix();
    
    stroke(0);
    strokeWeight(1);
    line(x+numberEdge, y+titleEdge, x+numberEdge, y+h-edge);
    line(x+numberEdge, y+h-edge, x+w-edge, y+h-edge);
    
    
    fill(0);
    textSize( 20 );
    textAlign( CENTER, CENTER );
    text(title, x+w/2, y+titleEdge/2);
    textSize( 15 );
    text(round(max), x+numberEdge/2, y+titleEdge);
    if (min != 0)
      text("0", x+numberEdge/2, y+map(0, min, max, h-edge, titleEdge));
    text(round(min), x+numberEdge/2, y+h-edge);
    
  }
    
  int getPosA(int i) {
    float n = map(pointsA[i], min, max, 0, h-edge-titleEdge);
    n *= -1;
    n += y + h - edge;
    
    return round(n);
  }
    
  int getPosB(int i) {
    float n = map(pointsB[i], min, max, 0, h-edge-titleEdge);
    n *= -1;
    n += y + h - edge;
    
    return round(n);
  }
  
  int getPosC(int i) {
    float n = map(pointsC[i], min, max, 0, h-edge-titleEdge);
    n *= -1;
    n += y + h - edge;
    
    return round(n);
  }
  
  void reset() {
    pointsA = new float[w - edge - numberEdge];
    pNA = 0;
    pointsB = new float[w - edge - numberEdge];
    pNB = 0;
    pointsC = new float[w - edge - numberEdge];
    pNC = 0;
    max = 0;
    min = 0; 
  }
}
public class UiSlider
{
  float x, y, width, height;
  float valueX, value;
  float min, max;
  color bar;
  color button;
  float buttonW;
  
  public UiSlider ( float xx, float yy, float ww, float hh, float min, float max, float value) 
  {
    x = xx; 
    y = yy; 
    width = ww; 
    height = hh;
    
    this.min = min;
    this.max = max;
    this.value = value;
    
    buttonW = height*2.5;
    
    valueX  = map(value, min, max, x, x+width-buttonW);
    
    // register it
    Interactive.add( this );
    
    bar = color(128);
    button = color(190);
    
  }
  
  //Called by manager
  void mouseDragged (float mx, float my) { update(mx, my); }
  void mousePressed (float mx, float my) { update(mx, my); }
  
  //Called when mouse clicked or dragged
  void update (float mx, float my) {
    valueX = mx - buttonW/2;
    
    if (valueX < x) valueX = x;
    if (valueX > x+width-buttonW) valueX = x+width-buttonW;
    
    value = getValue();
  }
  
  public void draw () 
  {
    float f = 0.75; //How much smaller rail bar is
    stroke(0);
    fill(bar);
    strokeWeight(1);
    rect(x, y + (1-f)*height/2, width, height*f);
    
    stroke(0);
    fill(button);
    rect(valueX, y, buttonW , height);
    
    textSize( 20 );
    textAlign( CENTER, CENTER );
    fill(0);
    text(value+"", valueX+buttonW/2, y+height/2);
  }
  
  //Specific cases
  float getValue() {
    float v = map( valueX, x, x+width-buttonW, min, max );
    return round(pow(v, 3)*10000)/10000f;
  }
}

