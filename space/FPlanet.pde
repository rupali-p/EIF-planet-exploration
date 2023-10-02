class FPlanet {

  float orbitSpeed;
  void CreatePlanetMain(FloatList colour, FloatList shape, float phase, float avgTemp, int dayCount, float size, float range, float orbitSpeed) {

    this.orbitSpeed = orbitSpeed;

    push();
     // rotateX(phase/2);
    rotateY(phase/2);
   // rotateZ(phase/2);
    for (int i = 0; i < total + 1; i++) {
      float lat = map(i, 0, total, 0, PI);

      beginShape(TRIANGLE_STRIP);
      for (int j = 0; j < total + 1; j++) {
        float lon = map(j, 0, total, 0, TWO_PI);

        if (i < total) {
          thisTemp = shape.get(dayCount);
        }
        float xoff = map(sin(lat)*cos(lon), 0, 1, 0, thisTemp);
        float yoff = map(sin(lat) * sin(lon), 0, 1, 0, thisTemp);
        float zoff = map(cos(lat), -1, 1, 0, thisTemp);
        float pNoise = noise(xoff, yoff, zoff);
        float r = map(pNoise, 0, 1, size, size + range);

        float x = r * sin(lat) * cos(lon);
        float y = r * sin(lat) * sin(lon);
        float z = r * cos(lat);
        globe[i][j] = new PVector(x, y, z);

        if (i!=0) {
          PVector v1 = globe[i-1][j];
          PVector v2 = globe[i][j];

          if (i < total) {
            float thisTemp = colour.get(dayCount);
            float cNoise = noise(phase + thisTemp + colorMutator * v1.x, phase + thisTemp + colorMutator * v1.y, phase + thisTemp + colorMutator * v1.z);
            float hu = map(cNoise, 0, 1, 0, 255);

            if (thisTemp > maxTempValue - tempRange/3) {
              fill(255, 255, hu);
            } else if (thisTemp < minTempValue + tempRange/3) {
              fill(hu, 255, 255);
            } else {
              fill(255, hu, 255);
            }
          }
          vertex(v1.x, v1.y, v1.z);
          vertex(v2.x, v2.y, v2.z);
        }
      }
      endShape();
    }
    pop();
  }

  void CreatePlanetAtmosphere(FloatList atmoData, float phase, int dayCount, float size, float roughness, float alphaDiv) {
    push();
      
    // Add some rotation
    rotateX(phase/2);
    rotateY(phase/2);
    rotateZ(phase/2);

    for (int i = 0; i < total + 1; i++) {
      float lat = map(i, 0, total, 0, PI);

      beginShape(TRIANGLE_STRIP);
      for (int j = 0; j < total + 1; j++) {
        float lon = map(j, 0, total, 0, TWO_PI);

        if (i < total) {
          thisTemp = atmoData.get(dayCount);
        }
        float xoff = map(sin(lat)*cos(lon), 0, 1, 0, thisTemp);
        float yoff = map(sin(lat) * sin(lon), 0, 1, 0, thisTemp);
        float zoff = map(cos(lat), -1, 1, 0, thisTemp);
        float pNoise = noise(xoff, yoff, zoff);
        float r = map(pNoise, 0, 1, size + roughness/2, size + roughness/1.5);


        float x = r * sin(lat) * cos(lon);
        float y = r * sin(lat) * sin(lon);
        float z = r * cos(lat);
        globe[i][j] = new PVector(x, y, z);

        if (i!=0) {
          PVector v1 = globe[i-1][j];
          PVector v2 = globe[i][j];

          if (i < total) {
            float thisTemp = atmoData.get(dayCount);
            float cNoise = noise(phase + thisTemp + colorMutator * v1.x, phase + thisTemp + colorMutator * v1.y, phase + thisTemp + colorMutator * v1.z);
            float hu = map(cNoise, 0, 1, 0, 255);
            noFill();
            fill(255, hu/alphaDiv);
          }
          vertex(v1.x, v1.y, v1.z);
          vertex(v2.x, v2.y, v2.z);
        }
      }
      endShape();
    }
    pop();
  }
 void orbit(float orbitSpeed){
    this.orbitSpeed = orbitSpeed;
  }
}
