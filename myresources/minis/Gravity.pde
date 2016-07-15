import javax.swing.JOptionPane;

//Simulation Vars
public ArrayList<Comet> comets;
private PVector startPos;
public ArrayList<CTail> particles;

public Star sun;

void setup() {
  size(800, 800);
  colorMode(RGB, 255);
  textSize(32);
  frameRate(30);
  
  //Simulation Vars
  comets = new ArrayList<Comet>();
  startPos = new PVector(0,0);
  particles = new ArrayList<CTail>();
  
  //sun = new Star(width/2, height/2);
  noLoop();
}

void draw() {
  background(28);
  update();
  render();
}

void mousePressed() {
  startPos.x = mouseX;
  startPos.y = mouseY;
}

void mouseReleased() {
  comets.add(new Comet(mouseX, mouseY, new PVector(startPos.x, startPos.y)));
}

void update() {
  
  for (int c = 0; c < comets.size(); c++) {
    if (comets.get(c).update()) comets.remove(c);
  }
  
  for (int c = 0; c < particles.size(); c++) {
    if (particles.get(c).update()) particles.remove(c);
  }
}

void render() {
  fill(249, 49, 82);
  
  noStroke();
  for (int c = 0; c < particles.size(); c++) particles.get(c).render();
  fill(68, 185, 194);
  for (int c = 0; c < comets.size(); c++) comets.get(c).render();
  fill(255, 217, 0);
  //sun.render();
}

class CTail {
  PVector position;
  float oRadius;
  float radius;
  
  CTail(PVector position, float radius) {
    this.position = new PVector(position.x, position.y);
    oRadius = radius*0.75;
    this.radius = radius;
  }
  
  boolean update() {
    radius -= 0.2;
    if (radius < 1) return true;
    return false;
  }
  
  void render() {
    float whiteout = 1+0.31*(radius/oRadius);
    fill(68*whiteout, 185*whiteout, 194*whiteout, 200*radius/oRadius);
    ellipse(position.x, position.y, radius, radius);
  }
}

class Comet {
  PVector position;
  PVector velocity;
  final static float GFACTOR = 1.0;
  
  float mass;
  float radius;
  
  Comet (int mx, int my, PVector startPos){
    velocity = new PVector((mx-startPos.x)/40, (my-startPos.y)/40);
    velocity.mult(1);
    
    position = startPos;
    
    radius = 10;
    mass = PI*pow(radius, 2);
  }
  
  boolean interact(Comet comet) {
    if (!this.equals(comet)) {
      float xdif = position.x-comet.position.x;
      float ydif = position.y-comet.position.y;
      float distance2 = xdif*xdif + ydif*ydif;
      PVector direction = new PVector(comet.position.x-position.x, comet.position.y-position.y);
      float collideDist = radius+comet.radius;
      if (distance2 >= collideDist*collideDist) {
        direction.setMag(comet.G()*this.G()/distance2);
        velocity.mult(this.G());
        velocity.add(direction);
        velocity.div(this.G());
      }
      else {
        direction.setMag(collideDist/2);
        comet.absorb(this, direction);
        return true;
      }
    }
    return false;
  }
  
  void absorb(Comet comet, PVector move) {
    float newMass = mass + comet.mass;
    
    velocity.mult(mass/newMass);
    comet.velocity.mult(comet.mass/newMass);
    
    velocity.add(comet.velocity);
    move.mult(comet.mass/newMass);
    position.sub(move);
    
    mass += comet.mass*.9;
    radius = sqrt(mass/PI);
  }

  boolean update() {
    mass = pow(radius, 2)*PI;
    //if (position.x < 0 || position.x > width) return true;
    //else if (position.y < 0 || position.y > width) return true;
    //else if (position.x == width/2 && position.y == height/2) return true;
    
    //Sun Gravity
    // float xdif = width/2-position.x;
    // float ydif = height/2-position.y;
    // float distance2 = xdif*xdif + ydif*ydif;
    // float touchdist = sun.radius-radius;
    // if (distance2 <= touchdist*touchdist*.9)
    //   return true;
    // PVector dir = new PVector(xdif, ydif);
    // dir.setMag(sun.G()*this.G()/distance2);
    // velocity.mult(this.G());
    // velocity.add(dir);
    // velocity.div(this.G());
    
    for (int c = 0; c < comets.size(); c++) {
      if(interact(comets.get(c))) return true;
    }
    
    position.add(velocity);
    particles.add(new CTail(position, radius));
    
    return false;
  }
  
  void render() {
    ellipse(position.x, position.y, radius, radius);
  }
  
  float G() {
    return GFACTOR*mass;
  }
}

class Star {
  PVector position;
  final static float GFACTOR = 1;
  
  float radius;
  float mass;
  
  Star (int x, int y){
    position = new PVector(x, y);
    
    radius = 60;
    mass = PI*pow(radius, 2);
  }
  
  void render() {
    ellipse(position.x, position.y, radius, radius);
  }
  
  float G() {
    return GFACTOR*mass;
  }
}