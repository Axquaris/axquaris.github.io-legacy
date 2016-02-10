float mult = 0;
int mod = 200;
//int hue = 0;

void setup()
{
  size(800,800);
  //colorMode(HSB, 1000);
  frameRate(30);
  strokeWeight(0.6);
}

void draw(){
  background(100);
  //stroke(hue, 1000, 1000);
  for (int i=0; i<=mod; i++) {
    float a = 2*PI*i/mod;
    float temp = i*mult;
    while (temp>=mod) temp-=mod;
    float b = 2*PI*temp/mod;
    line(400+400*cos(a), 400+400*sin(a), 400+400*cos(b), 400+400*sin(b));
  }
  mult+=0.05;
  //hue++;
}