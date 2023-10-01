float[] angles = {radians(0), radians(90), radians(180), radians(270)};

class Planet{
  float radius;
  float angle;
  float distance;
  float orbitSpeed;
  Planet planets[];
  PShape globe;
  PVector v;
  
  Planet(float r, float d, float angle, float orbitSpeed, PImage image){
    //v = PVector.random3D();
    v = new PVector(1, -0.2, 0);
    radius = r;
    distance = d;
    v.mult(distance);
    this.angle = angle;
    this.orbitSpeed = orbitSpeed;
    noStroke();
    noFill();
    globe = createShape(SPHERE, radius);
    globe.setTexture(image);
  }
  
  void childrenPlanets(int num){
    
    this.planets = new Planet[num];
    for(int i = 0; i < planets.length; i++){
      float r = radius*0.35;
      float d = random(200, 250);
      float angle = angles[i];
      planets[i] = new Planet(r, d, angle, speed, planetImages[i]);
      println(d);
    }
  }
  
  void orbit(){
    angle += this.orbitSpeed;
    if(planets != null){
      for(int i = 0; i < planets.length; i++){
        planets[i].orbit();
      }
    }
  }
  
  void display() {
    pushMatrix();
    fill(255);
    noStroke();
    
    PVector v2 = new PVector(1, 0, 1);
    PVector perpen = v.cross(v2);
    rotate(angle, perpen.x, perpen.y, perpen.z);
    translate(v.x, v.y, v.z);
    shape(globe);
    
    
    
    if(planets != null) {
      for(int i = 0; i < planets.length; i++){
        planets[i].display();
      }
    }
    popMatrix();
  }
}
