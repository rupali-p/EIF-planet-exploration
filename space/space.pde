///////////////////////////////////////////////////////////////////////////
PVector[][] globe;
int total;
float phase = 0;
float colorMutator = 0.04;
float speed = 0.004;

int rowCount;

int lasti;

boolean dataSetup = false;

int daysPassed; 
int count;
//int framerate; 

//PLANETS
FPlanet planet1;
FPlanet planet2;
FPlanet planet3;
FPlanet planet4;

//TEMPS
Table tempTable;
FloatList temps;
FloatList monthtemps1;
FloatList monthtemps2;
FloatList monthtemps3;
FloatList monthtemps4;
float lastTemp;
float thisTemp;
float tempRange;
float totalTemp;
float avgTemp;
float tempDayCount;
float maxTempValue = 0;
float minTempValue = 1000;

//RAIN
Table rainTable;
FloatList rains;
FloatList monthrains1;
FloatList monthrains2;
FloatList monthrains3;
FloatList monthrains4;
float lastRain;
float thisRain;
float rainRange;
float totalRain;
float avgRain;
float rainDayCount;
float maxRainValue = 0;
float minRainValue = 1000;

//SOLAR RADIATION
Table solarTable;
FloatList solars;
FloatList monthsolars1;
FloatList monthsolars2;
FloatList monthsolars3;
FloatList monthsolars4;
float lastSolar;
float thisSolar;
float solarRange;
float totalSolar;
float avgSolar;
float solarDayCount;
float maxSolarValue = 0;
float minSolarValue = 1000;
//SOLAR RADITION - https://eif-research.feit.uts.edu.au/graph/?rFromDate=2021-01-01T00%3A00&rToDate=2021-12-31T23%3A59%3A59&rFamily=weather&rSensor=SR

///////////////////////////////////////////////////////////////////////////

import controlP5.*;
ControlP5 cp5;

import peasy.*;
PeasyCam cam;
boolean isCamActive = false;

import processing.sound.*;
SoundFile sound;
float volume = 0.5;

Planet sun;
float speedOrbit = 0.005;
PImage sunImage;
PImage[] planetImages;
PImage backgroundImg;

void setup() {
 // frameRate(120);
  size(1074, 647, P3D);
  backgroundImg = loadImage("space3.jpg");
  image(backgroundImg, 0, 0);
  sunImage = loadImage("sun.jpg");

  ///////////////////////////////////////////////////////////////////////////
  colorMode(HSB, 255);

  planet1 = new FPlanet();
  planet2 = new FPlanet();
  planet3 = new FPlanet();
  planet4 = new FPlanet();

  //frameRate(20);
  //TEMPERATURE DATA SET UP
  temps = new FloatList();
  monthtemps1 = new FloatList();
  monthtemps2 = new FloatList();
  monthtemps3 = new FloatList();
  monthtemps4 = new FloatList();

  //RAIN DATA SETUP
  rains = new FloatList();
  monthrains1 = new FloatList();
  monthrains2 = new FloatList();
  monthrains3 = new FloatList();
  monthrains4 = new FloatList();

  //SOLAR DATA SETUP
  solars = new FloatList();
  monthsolars1 = new FloatList();
  monthsolars2 = new FloatList();
  monthsolars3 = new FloatList();
  monthsolars4 = new FloatList();
  ///////////////////////////////////////////////////////////////////////////

  sound = new SoundFile(this, "music1.mp3");
  sound.amp(volume);
  sound.loop();

  cam = new PeasyCam(this, 500);
  cam.setMinimumDistance(5);
  cam.setMaximumDistance(1000);

  //slider for the volume of the sound
  cp5 = new ControlP5(this);
  cp5.addSlider("volume")
    .setPosition(100, 30)
    .setSize(300, 20)
    .setRange(0, 1)
    .setValue(0.5)
    ;

  //slider for controlling the speed of the planets
  cp5.addSlider("speedOrbit")
    .setPosition(100, 70)
    .setSize(300, 20)
    .setRange(0, 0.01)
    .setDecimalPrecision(3)
    .setValue(0.005);

  //toggle cam
  cp5.addToggle("ToggleCam")
    .setPosition(100, 110)
    .setSize(80, 20)
    .setValue(isCamActive);

  cp5.setAutoDraw(false);

  // the surface images for 4 planets
  planetImages = new PImage[4];
  planetImages[0] = loadImage("earth.jpg");
  planetImages[1] = loadImage("jupiter.jpg");
  planetImages[2] = loadImage("mars.jpg");
  planetImages[3] = loadImage("neptune.jpg");

  //create a new planet called sun
  sun = new Planet(100, 0, 0, 0, sunImage);
  //sun.childrenPlanets(4); //sun has 4 children planets
}
////////////////////////////////////////////////////
float xoff = 0;
////////////////////////////////////////////////////

void draw() {
  background(backgroundImg);
  ////////////////////////////////////////////////////
  if (!dataSetup) {
    CompleteDataSetup();
    dataSetup = true;
  }
  ////////////////////////////////////////////////////

  pushMatrix();
  //translate(width/2, height/2);
  sun.display();
  sun.orbit();
  rotateY(phase);
  translate(200, 0, 200);
  planet1.CreatePlanetMain(monthtemps1, monthsolars1, phase, avgTemp, daysPassed);
  planet1.CreatePlanetAtmosphere(monthrains1, phase, daysPassed);
  popMatrix();

  ////////////////////////////////////////////////////

  //sphere(100);
  //    rotateY(phase * 2);
  //     translate(200, 0, 0);
  //planet1.CreatePlanetMain(monthtemps1, monthsolars1, phase, avgTemp);
  pushMatrix();
  rotateY(phase);
  translate(-100, 0, -100);
  planet2.CreatePlanetMain(monthtemps2, monthsolars2, phase, avgTemp, daysPassed);
    planet2.CreatePlanetAtmosphere(monthrains1, phase, daysPassed);
  popMatrix();
  
  pushMatrix();
  rotateY(phase);
  translate(200, -100, 0);
  planet3.CreatePlanetMain(monthtemps3, monthsolars3, phase, avgTemp, daysPassed);
    planet3.CreatePlanetAtmosphere(monthrains1, phase, daysPassed);
  popMatrix();
  pushMatrix();
  rotateY(phase);
  translate(-200, 100, 0);
  planet4.CreatePlanetMain(monthtemps4, monthsolars4, phase, avgTemp, daysPassed);
    planet4.CreatePlanetAtmosphere(monthrains1, phase, daysPassed);
  popMatrix();
  //phase += sun.planets[0].orbitSpeed;
  phase += speed;
  count++;
  if(count % 40 == 0 && count != 0){
    daysPassed++;
    if(daysPassed >= 91){
      daysPassed = 0;
    }
    println(daysPassed);
  }
  ////////////////////////////////////////////////////

  if (isCamActive) {
    cam.setActive(true);
  } else {
    cam.setActive(false);
  }

  gui();
}

void ToggleCam(boolean val) {
  isCamActive = val;
}

void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void volume(float vol) {
  volume = vol;
  sound.amp(volume);
}

void speedOrbit(float s) {
  speedOrbit = s;
  sun.orbitSpeed = s;
  for (Planet p : sun.planets) {
    if (p != null) p.orbitSpeed = s;
  }
}

///////////////////////////////////////////////////////////////////////////
void CompleteDataSetup() {
  tempTable = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2022-01-01T00%3A00&rToDate=2022-12-31T23%3A59%3A59&rFamily=weather&rSensor=AT", "csv");
  rowCount = tempTable.getRowCount();
  int currentRowCountTest = rowCount/365;
  int lastRowCountTest = 0;
  float thisTotalDayTemp = 0;
  for (int i = 0; i < 365; i++) {
    for (int j = lastRowCountTest; j < currentRowCountTest; j++) {
      thisTotalDayTemp += tempTable.getFloat(j, 1);
    }
    temps.append(thisTotalDayTemp / (rowCount/365));
    lastRowCountTest = currentRowCountTest;
    currentRowCountTest = lastRowCountTest + rowCount/365;
    thisTotalDayTemp = 0;
  }
  for (int i = 0; i < temps.size() - 1; i++) {
    println("Day " + i + "'s avg: " + temps.get(i));
  }

  int currentTempCountTest = temps.size() / 4;
  int lastTempCount = 0;
  for (int i = 0; i < 4; i++) {
    for (int j = lastTempCount; j < currentTempCountTest; j++) {
      float thisTemp = temps.get(j);
      totalTemp += thisTemp;
      if (thisTemp < minTempValue) minTempValue = thisTemp;
      if (thisTemp > maxTempValue) maxTempValue = thisTemp;
      if (i == 0) {
        monthtemps1.append(thisTemp);
      } else if (i == 1) {
        monthtemps2.append(thisTemp);
      } else if (i == 2) {
        monthtemps3.append(thisTemp);
      } else {
        monthtemps4.append(thisTemp);
      }
      tempDayCount++;
    }
    lastTempCount = currentTempCountTest;
    currentTempCountTest = lastTempCount + (temps.size() / 4);
  }
  avgTemp = totalTemp / tempDayCount;
  tempRange = maxTempValue - minTempValue;

  //RAIN DATA SET UP
  rains = new FloatList();
  monthrains1 = new FloatList();
  monthrains2 = new FloatList();
  monthrains3 = new FloatList();
  monthrains4 = new FloatList();

  rainTable = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2022-01-28T00%3A00&rToDate=2022-12-31T23%3A59%3A59&rFamily=weather&rSensor=RT", "csv");
  rowCount = rainTable.getRowCount();
  currentRowCountTest = rowCount/365;
  lastRowCountTest = 0;
  float thisTotalDayRain = 0;
  for (int i = 0; i < 365; i++) {
    for (int j = lastRowCountTest; j < currentRowCountTest; j++) {
      thisTotalDayRain += rainTable.getFloat(j, 1);
    }
    rains.append(thisTotalDayRain / (rowCount/365));
    lastRowCountTest = currentRowCountTest;
    currentRowCountTest = lastRowCountTest + rowCount/365;
    thisTotalDayRain = 0;
  }
  for (int i = 0; i < rains.size() - 1; i++) {
    println("Day " + i + "'s avg: " + rains.get(i));
  }

  int currentRainCountTest = rains.size() / 4;
  int lastRainCount = 0;
  for (int i = 0; i < 4; i++) {
    for (int j = lastRainCount; j < currentRainCountTest; j++) {
      float thisRain = rains.get(j);
      totalRain += thisRain;
      if (thisRain < minRainValue) minRainValue = thisRain;
      if (thisTemp > maxRainValue) maxRainValue = thisRain;
      if (i == 0) {
        monthrains1.append(thisRain);
      } else if (i == 1) {
        monthrains2.append(thisRain);
      } else if (i == 2) {
        monthrains3.append(thisRain);
      } else {
        monthrains4.append(thisRain);
      }
      rainDayCount++;
    }
    lastRainCount = currentRainCountTest;
    currentRainCountTest = lastRainCount + (rains.size() / 4);
  }
  avgRain = totalRain / rainDayCount;
  rainRange = maxRainValue - minRainValue;

  solarTable = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2022-01-01T00%3A00&rToDate=2022-12-31T23%3A59%3A59&rFamily=weather&rSensor=SR", "csv");
  rowCount = solarTable.getRowCount();
  currentRowCountTest = rowCount/365;
  lastRowCountTest = 0;
  float thisTotalDaySolar = 0;
  for (int i = 0; i < 365; i++) {
    for (int j = lastRowCountTest; j < currentRowCountTest; j++) {
      thisTotalDaySolar += solarTable.getFloat(j, 1);
    }
    solars.append(thisTotalDaySolar / (rowCount/365));
    lastRowCountTest = currentRowCountTest;
    currentRowCountTest = lastRowCountTest + rowCount/365;
    thisTotalDaySolar = 0;
  }
  for (int i = 0; i < solars.size() - 1; i++) {
    println("Day " + i + "'s avg: " + solars.get(i));
  }

  int currentSolarCountTest = solars.size() / 4;
  int lastSolarCount = 0;
  for (int i = 0; i < 4; i++) {
    for (int j = lastSolarCount; j < currentSolarCountTest; j++) {
      float thisSolar = solars.get(j);
      totalSolar += thisSolar;
      if (thisSolar < minSolarValue) minSolarValue = thisSolar;
      if (thisSolar > maxSolarValue) maxSolarValue = thisSolar;
      if (i == 0) {
        monthsolars1.append(thisSolar);
      } else if (i == 1) {
        monthsolars2.append(thisSolar);
      } else if (i == 2) {
        monthsolars3.append(thisSolar);
      } else {
        monthsolars4.append(thisSolar);
      }
      solarDayCount++;
    }
    lastSolarCount = currentSolarCountTest;
    currentSolarCountTest = lastSolarCount + (solars.size() / 4);
  }
  avgSolar = totalSolar / solarDayCount;
  solarRange = maxSolarValue - minSolarValue;

  total = monthtemps4.size();
  globe = new PVector[total+1][total+1];
 // zzprintln(frameRate);
}
///////////////////////////////////////////////////////////////////////////
