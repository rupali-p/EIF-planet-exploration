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
    v = new PVector(1, -0.5, 0);
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
      float r = random(radius*0.25, radius*0.35);
      float d = random(200, 250);
      float angle = random(TWO_PI);
      float orbitS = random(0.005, 0.01);
      planets[i] = new Planet(r, d, angle, orbitS, planetImages[i]);
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
    //sphere(radius);
    //ellipse(0, 0, radius*2, radius*2);
    if(planets != null) {
      for(int i = 0; i < planets.length; i++){
        planets[i].display();
      }
    }
    popMatrix();
  }
}
