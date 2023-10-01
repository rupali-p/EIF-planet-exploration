class Planet {
  public float radius;
  float angle;
  float distance;
  float orbitSpeed;
  Planet planets[];
  //PVector[][] globe;
  PShape thisPlanet;
  PVector v;

  Planet(float r, float d, float angle, float orbitSpeed, FloatList colour, FloatList shape) {
    //v = PVector.random3D();
    v = new PVector(1, -0.2, 0);
    radius = r;
    distance = d;
    v.mult(distance);
    this.angle = angle;
    this.orbitSpeed = orbitSpeed;
    noStroke();
    noFill();

    thisPlanet = CreatePlanetMain(colour, shape);
    println(thisPlanet.isVisible());

    println("Planet should be created");
    //globe.setTexture(image);
  }

  void childrenPlanets(int num) {
    this.planets = new Planet[num];
    for (int i = 0; i < planets.length; i++) {
      float r = radius*0.35;
      float d = random(200, 250);
      float angle = random(TWO_PI);
      if (i == 0) planets[i] = new Planet(r, d, angle, speed, monthtemps1, monthsolars1);
      else if (i == 1) planets[i] = new Planet(r, d, angle, speed, monthtemps2, monthsolars2);
      else if (i == 2) planets[i] = new Planet(r, d, angle, speed, monthtemps3, monthsolars3);
      else planets[i] = new Planet(r, d, angle, speed, monthtemps4, monthsolars4);
    }
  }

  void orbit() {
    angle += this.orbitSpeed;
    if (planets != null) {
      for (int i = 0; i < planets.length; i++) {
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
    shape(thisPlanet);



    if (planets != null) {
      for (int i = 0; i < planets.length; i++) {
        scale(zoomFactor);
        planets[i].display();
      }
    }
    popMatrix();
  }

  PShape CreatePlanetMain(FloatList colour, FloatList shape) {
    PShape thisShape = createShape();

    pushMatrix();
        beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < total + 1; i++) {
      float lat = map(i, 0, total, 0, PI);


      for (int j = 0; j < total + 1; j++) {
        float lon = map(j, 0, total, 0, TWO_PI);

        if (i < total) {
          thisTemp = shape.get(i);
        }
        float xoff = map(sin(lat)*cos(lon), 0, 1, 0, thisTemp);
        float yoff = map(sin(lat) * sin(lon), 0, 1, 0, thisTemp);
        float zoff = map(cos(lat), -1, 1, 0, thisTemp);
        float pNoise = noise(xoff, yoff, zoff);
        float thisRadius = map(pNoise, 0, 1, radius, radius + 20); //MAKE THIS ADJUSTABLE

        float x = thisRadius * sin(lat) * cos(lon);
        float y = thisRadius * sin(lat) * sin(lon);
        float z = thisRadius * cos(lat);
        globe[i][j] = new PVector(x, y, z);

        if (i!=0) {
          PVector v1 = globe[i-1][j];
          PVector v2 = globe[i][j];

          if (i < total) {
            float thisTemp = colour.get(i);
            float cNoise = noise(phase + thisTemp + colorMutator * v1.x, phase + thisTemp + colorMutator * v1.y, phase + thisTemp + colorMutator * v1.z);
            float hu = map(cNoise, 0, 1, 0, 255);

            if (thisTemp > maxTempValue - tempRange/3) {
              thisShape.setFill(color(255, 255, hu));
            } else if (thisTemp < minTempValue + tempRange/3) {
              thisShape.setFill(color(hu, 255, 255));
            } else {
              thisShape.setFill(color(255, hu, 255));
            }
          }
          vertex(v1.x, v1.y, v1.z);
          vertex(v2.x, v2.y, v2.z);
        }
      }
      endShape();
    }
    popMatrix();
    return thisShape;
  }
}
