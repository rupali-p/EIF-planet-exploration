import controlP5.*; //<>// //<>//
ControlP5 cp5;

import peasy.*;
PeasyCam cam;
boolean isCamActive = false;

import processing.sound.*;
SoundFile sound;
float volume = 0.5;

Planet sun;

float speedOrbit = 0.005;

//float speed = 0.005;

PImage sunImage;
PImage[] planetImages;
PImage backgroundImg;

float zoomFactor = 0.75;
float ZOOMTHRESHOLD = 1.5;
PVector zoomCenter;
Button panButton;
Button button1;
Button button2;
Button button3;
Button button4;
Slider mySlider;
int HEIGHTFIFTH;
int WIDTHFIFTH;
boolean pan = false;
boolean displayPlanets = true;
PGraphics mask;
boolean button1Clicked = false;
boolean button2Clicked = false;
boolean button3Clicked = false;
boolean button4Clicked = false;

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

int planet1Size = 20;
int planet1SizeRange = 3;

int planet2Size = 20;
int planet2SizeRange = 3;

int planet3Size = 20;
int planet3SizeRange = 3;

int planet4Size = 20;
int planet4SizeRange = 3;

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

///////////////////////////////////////////////////////////////////////////

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
  //create a new planet called sun
  sun = new Planet(100, 0, 0, 0, sunImage);
  //sun.childrenPlanets(4); //sun has 4 children planets

  zoomCenter = new PVector(width / 2, height / 2);

  HEIGHTFIFTH = height / 5;
  WIDTHFIFTH = width / 5;
  hint(DISABLE_DEPTH_TEST);
  panButton = cp5.addButton("PanButton")
    .setPosition(HEIGHTFIFTH, 4 * HEIGHTFIFTH + (HEIGHTFIFTH / 3))
    .setSize(200, 40)
    .setCaptionLabel("Click to Pan");

  button1 = cp5.addButton("Button1")
    .setPosition(4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 40)
    .setSize(40, 40)
    .setCaptionLabel("Planet 1");

  button2 = cp5.addButton("Button2")
    .setPosition(4 * WIDTHFIFTH + 60, HEIGHTFIFTH + 40)
    .setSize(40, 40)
    .setCaptionLabel("Planet 2");

  button3 = cp5.addButton("Button3")
    .setPosition(4 * WIDTHFIFTH + 110, HEIGHTFIFTH + 40)
    .setSize(40, 40)
    .setCaptionLabel("Planet 3");

  button4 = cp5.addButton("Button4")
    .setPosition(4 * WIDTHFIFTH + 160, HEIGHTFIFTH + 40)
    .setSize(40, 40)
    .setCaptionLabel("Planet 4");

  mySlider = cp5.addSlider("Zoom")
    .setPosition(2 * HEIGHTFIFTH + 220, 4 * HEIGHTFIFTH + (HEIGHTFIFTH / 3))
    .setSize(200, 40)
    .setRange(0, 100)
    .setValue(0);

  mask = createGraphics(width, height);
  mask.beginDraw();
  mask.background(255); // Set the initial mask background to white
  mask.noStroke();
  mask.fill(0, 0, 0, 255); // Transparent black fill
  mask.endDraw();
  hint(ENABLE_DEPTH_TEST);
  //gui();
  // the surface images for 4 planets
  
    CreatePlanetSliders();

}

////////////////////////////////////////////////////
float xoff = 0;
////////////////////////////////////////////////////

void draw() {
  if (!dataSetup) {
    CompleteDataSetup();
    dataSetup = true;
  }
  background(backgroundImg);
  panLabeling();
  if (isCamActive) {
    cam.setActive(true);
  } else {
    cam.setActive(false);
  }
  //gui();
  ////////////////////////////////////////////////////

  ////////////////////////////////////////////////////

  println("cam active: " + isCamActive);
  if (displayPlanets) {
    scale(zoomFactor);
    translate(-100, 0, 0);
    pushMatrix();
    sun.display();
    sun.orbit();
    pushMatrix();
    rotateY(phase);
    translate(200, 0, 200);

    planet1.CreatePlanetMain(monthtemps1, monthsolars1, phase, avgTemp, daysPassed, cp5.getController("Planet1Size").getValue(), cp5.getController("Planet1Roughness").getValue(), speedOrbit);
    planet1.CreatePlanetAtmosphere(monthrains1, phase, daysPassed, cp5.getController("Planet1Size").getValue(), cp5.getController("Planet1Roughness").getValue(), cp5.getController("Atmosphere1AlphaDiv").getValue());

    popMatrix();
    pushMatrix();
    rotateY(phase);
    translate(-100, 0, -100);

    planet2.CreatePlanetMain(monthtemps2, monthsolars2, phase, avgTemp, daysPassed, cp5.getController("Planet2Size").getValue(), cp5.getController("Planet2Roughness").getValue(), speedOrbit);
    planet2.CreatePlanetAtmosphere(monthrains1, phase, daysPassed, cp5.getController("Planet2Size").getValue(), cp5.getController("Planet2Roughness").getValue(), cp5.getController("Atmosphere2AlphaDiv").getValue());

    popMatrix();
    pushMatrix();
    rotateY(phase);
    translate(200, -100, 0);

    planet3.CreatePlanetMain(monthtemps3, monthsolars3, phase, avgTemp, daysPassed, cp5.getController("Planet3Size").getValue(), cp5.getController("Planet3Roughness").getValue(), speedOrbit);
    planet3.CreatePlanetAtmosphere(monthrains1, phase, daysPassed, cp5.getController("Planet3Size").getValue(), cp5.getController("Planet3Roughness").getValue(), cp5.getController("Atmosphere3AlphaDiv").getValue());

    popMatrix();
    pushMatrix();
    rotateY(phase);
    translate(-200, 100, 0);

    planet4.CreatePlanetMain(monthtemps4, monthsolars4, phase, avgTemp, daysPassed, cp5.getController("Planet4Size").getValue(), cp5.getController("Planet4Roughness").getValue(), speedOrbit);
    planet4.CreatePlanetAtmosphere(monthrains1, phase, daysPassed, cp5.getController("Planet4Size").getValue(), cp5.getController("Planet4Roughness").getValue(), cp5.getController("Atmosphere4AlphaDiv").getValue());
    popMatrix();
    gui();
    popMatrix();


    //float speedOrbitValue = speedOrbit.getValue(); // Declare as float, not int
    float speedValue = cp5.getController("speedOrbit").getValue();

    planet1.orbit(speedValue);
    planet2.orbit(speedValue);
    planet3.orbit(speedValue);
    planet4.orbit(speedValue);

  }
  ////////////////////////////////////////////////////



  float cameraZ = 300 / tan(PI/6);
  Zoom(mySlider.getValue());

  if (zoomFactor >= ZOOMTHRESHOLD) {
    pov();
    scale(zoomFactor);
  } else {
    displayPlanets = true;
    //   perspective(PI/3.0, float(width) / float(height), cameraZ/10.0, cameraZ/10.0);
    translate(width / 2, height / 2);
    scale(zoomFactor);
    lights();
    hint(DISABLE_DEPTH_TEST);
  }
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  fill(150);
  rect(0, 4 * HEIGHTFIFTH, width, HEIGHTFIFTH + 10);
  rect(4 * WIDTHFIFTH, 0, WIDTHFIFTH + 10, height);
  displayText();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
  gui();


  //phase += sun.planets[0].orbitSpeed;
  phase += speed;
  count++;
  if (count % 40 == 0 && count != 0) {
    daysPassed++;
    if (daysPassed >= 91) {
      daysPassed = 0;
    }
    println(daysPassed);
  }
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


//void speedOrbit(float s) {
//  speedOrbit = s;
//  sun.orbitSpeed = s;
//  if (sun.planets != null){
//    for (Planet p : sun.planets) {
//      if (p != null) p.orbitSpeed = s;
//    }
//  }
//}

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

void panLabeling() {
  if (pan) {
    panButton.getCaptionLabel().setText("Click to Disable Pan");
  } else {
    panButton.getCaptionLabel().setText("Click to Pan");
  }
  println("pan: " + pan);
}

void pov() {
  if (zoomFactor >= ZOOMTHRESHOLD) {
    displayPlanets = false;
    mask.beginDraw();
    mask.background(155); // Clear the mask
    mask.noStroke();
    mask.fill(0, 0, 0, 255); // Transparent black fill

    if (pan) {
      // Draw an inverted semi-circle in the mask when panning
      mask.arc(map(mouseX, 0, width, 1.7 *  WIDTHFIFTH, width - 2.7 * WIDTHFIFTH), (height / 2) + height/4.2, width/1.5, 1.4 * height, PI, TWO_PI);
    } else {
      // Draw a semi-circle in the mask when not panning
      mask.arc((width / 2) - width / 10, (height / 2) + height/4.2, width/1.5, 1.4 * height, PI, TWO_PI);
    }

    blend(mask, 0, 0, width, height, 0, 0, width, height, SCREEN);
    mask.endDraw();
  }
}

void Zoom(float theValue) {
  zoomFactor = map(theValue, 0, 100, 0.75, 2.0);
  zoomCenter.set(width / 2, height / 2);
}

void mousePressed() {
  if (mouseX >= HEIGHTFIFTH && mouseX <= HEIGHTFIFTH + 200 &&
    mouseY >= 4 * HEIGHTFIFTH + (HEIGHTFIFTH / 3) && mouseY <= 4 * HEIGHTFIFTH + (HEIGHTFIFTH / 3) + 40) {
    if (pan) {
      println("Pan mode disabled.");
      pan = false;
    } else {
      println("Pan mode enabled.");
      pan = true;
    }
  }

  // Check if any of the additional buttons were clicked
  if (mouseX >= 4 * WIDTHFIFTH + 10 && mouseX <= 4 * WIDTHFIFTH + 50 &&
    mouseY >= HEIGHTFIFTH + 40 && mouseY <= HEIGHTFIFTH + 80) {
    button1Clicked = !button1Clicked;
    button2Clicked = false;
    button3Clicked = false;
    button4Clicked = false;
  }
  if (mouseX >= 4 * WIDTHFIFTH + 60 && mouseX <= 4 * WIDTHFIFTH + 100 &&
    mouseY >= HEIGHTFIFTH + 40 && mouseY <= HEIGHTFIFTH + 80) {
    button2Clicked = !button2Clicked;
    button1Clicked = false;
    button3Clicked = false;
    button4Clicked = false;
  }
  if (mouseX >= 4 * WIDTHFIFTH + 110 && mouseX <= 4 * WIDTHFIFTH + 150 &&
    mouseY >= HEIGHTFIFTH + 40 && mouseY <= HEIGHTFIFTH + 80) {
    button3Clicked = !button3Clicked;
    button2Clicked = false;
    button1Clicked = false;
    button4Clicked = false;
  }

  if (mouseX >= 4 * WIDTHFIFTH + 160 && mouseX <= 4 * WIDTHFIFTH + 200 &&
    mouseY >= HEIGHTFIFTH + 40 && mouseY <= HEIGHTFIFTH + 80) {
    button4Clicked = !button4Clicked;
    button2Clicked = false;
    button3Clicked = false;
    button1Clicked = false;
  }

  // Print which buttons have been clicked
  switchButtons();
}


void switchButtons() {
  println("Button 1 clicked: " + button1Clicked);
  println("Button 2 clicked: " + button2Clicked);
  println("Button 3 clicked: " + button3Clicked);
}

void displayText() {
  //Display dynamic text in the right column
  fill(0);
  textAlign(LEFT);
  textSize(16);
  String panStatus = "Disabled";
  String thresholdStatus = "Not ";
  if (pan) {
    panStatus = "Enabled";
  }
  if (zoomFactor >= ZOOMTHRESHOLD) {
    thresholdStatus = "";
  }
  text("Pan is " + panStatus + "\nThreshold " + thresholdStatus + "Crossed" + "\nZoom Factor: " + String.valueOf(zoomFactor), 4 * WIDTHFIFTH + 10, HEIGHTFIFTH - 10);
  text("Day " + daysPassed, 4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 100);
  FloatList thisTempList = monthtemps1;
  FloatList thisSolarList = monthsolars1;
  FloatList thisRainList = monthrains1;
  if (button1Clicked) {
    thisTempList = monthtemps1;
    thisSolarList = monthsolars1;
    thisRainList = monthrains1;
    cp5.getController("Planet1Size").setVisible(true);
    cp5.getController("Planet2Size").setVisible(false);
    cp5.getController("Planet3Size").setVisible(false);
    cp5.getController("Planet4Size").setVisible(false);

    cp5.getController("Planet1Roughness").setVisible(true);
    cp5.getController("Planet2Roughness").setVisible(false);
    cp5.getController("Planet3Roughness").setVisible(false);
    cp5.getController("Planet4Roughness").setVisible(false);

    cp5.getController("Atmosphere1AlphaDiv").setVisible(true);
    cp5.getController("Atmosphere2AlphaDiv").setVisible(false);
    cp5.getController("Atmosphere3AlphaDiv").setVisible(false);
    cp5.getController("Atmosphere4AlphaDiv").setVisible(false);
    
  } else if (button2Clicked) {
    thisTempList = monthtemps2;
    thisSolarList = monthsolars2;
    thisRainList = monthrains2;
    
    cp5.getController("Planet1Size").setVisible(false);
    cp5.getController("Planet2Size").setVisible(true);
    cp5.getController("Planet3Size").setVisible(false);
    cp5.getController("Planet4Size").setVisible(false);

    cp5.getController("Planet1Roughness").setVisible(false);
    cp5.getController("Planet2Roughness").setVisible(true);
    cp5.getController("Planet3Roughness").setVisible(false);
    cp5.getController("Planet4Roughness").setVisible(false);

    cp5.getController("Atmosphere1AlphaDiv").setVisible(false);
    cp5.getController("Atmosphere2AlphaDiv").setVisible(true);
    cp5.getController("Atmosphere3AlphaDiv").setVisible(false);
    cp5.getController("Atmosphere4AlphaDiv").setVisible(false);
    
  } else if (button3Clicked) {
    thisTempList = monthtemps3;
    thisSolarList = monthsolars3;
    thisRainList = monthrains3;
    
    cp5.getController("Planet1Size").setVisible(false);
    cp5.getController("Planet2Size").setVisible(false);
    cp5.getController("Planet3Size").setVisible(true);
    cp5.getController("Planet4Size").setVisible(false);

    cp5.getController("Planet1Roughness").setVisible(false);
    cp5.getController("Planet2Roughness").setVisible(false);
    cp5.getController("Planet3Roughness").setVisible(true);
    cp5.getController("Planet4Roughness").setVisible(false);

    cp5.getController("Atmosphere1AlphaDiv").setVisible(false);
    cp5.getController("Atmosphere2AlphaDiv").setVisible(false);
    cp5.getController("Atmosphere3AlphaDiv").setVisible(true);
    cp5.getController("Atmosphere4AlphaDiv").setVisible(false);
    
  } else if (button4Clicked) {
    thisTempList = monthtemps4;
    thisSolarList = monthsolars4;
    thisRainList = monthrains4;
    
    cp5.getController("Planet1Size").setVisible(false);
    cp5.getController("Planet2Size").setVisible(false);
    cp5.getController("Planet3Size").setVisible(false);
    cp5.getController("Planet4Size").setVisible(true);

    cp5.getController("Planet1Roughness").setVisible(false);
    cp5.getController("Planet2Roughness").setVisible(false);
    cp5.getController("Planet3Roughness").setVisible(false);
    cp5.getController("Planet4Roughness").setVisible(true);

    cp5.getController("Atmosphere1AlphaDiv").setVisible(false);
    cp5.getController("Atmosphere2AlphaDiv").setVisible(false);
    cp5.getController("Atmosphere3AlphaDiv").setVisible(false);
    cp5.getController("Atmosphere4AlphaDiv").setVisible(true);
  }

  if (button1Clicked || button2Clicked || button3Clicked || button4Clicked) {
    text("Temperature (Colour) : ", 4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 120);
    text(nf(thisTempList.get(daysPassed), 0, 2), 4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 140);
    text("Solar Radiation (Texture) : ", 4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 160);
    text(nf(thisSolarList.get(daysPassed), 0, 2), 4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 180);
    text("Rainfall (Atmosphere): ", 4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 200);
    text(nf(thisRainList.get(daysPassed), 0, 2), 4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 220);
   // cp5.getController("Planet Size").setVisible(false);
  }
}

void CreatePlanetSliders() {
  cp5.addSlider("Planet1Size")
    .setPosition(4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 240)
    .setSize(100, 20)
    .setRange(5, 100)
    .setValue(20);
  cp5.getController("Planet1Size").setVisible(false);

  cp5.addSlider("Planet2Size")
    .setPosition(4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 240)
    .setSize(100, 20)
    .setRange(5, 100)
    .setValue(20);
  cp5.getController("Planet2Size").setVisible(false);

  cp5.addSlider("Planet3Size")
    .setPosition(4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 240)
    .setSize(100, 20)
    .setRange(5, 100)
    .setValue(20);
  cp5.getController("Planet3Size").setVisible(false);

  cp5.addSlider("Planet4Size")
    .setPosition(4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 240)
    .setSize(100, 20)
    .setRange(5, 100)
    .setValue(20);
  cp5.getController("Planet4Size").setVisible(false);

  cp5.addSlider("Planet1Roughness")
    .setPosition(4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 270)
    .setSize(100, 20)
    .setRange(0, 50)
    .setValue(3);
  cp5.getController("Planet1Roughness").setVisible(false);

  cp5.addSlider("Planet2Roughness")
    .setPosition(4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 270)
    .setSize(100, 20)
    .setRange(0, 50)
    .setValue(3);
  cp5.getController("Planet2Roughness").setVisible(false);

  cp5.addSlider("Planet3Roughness")
    .setPosition(4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 270)
    .setSize(100, 20)
    .setRange(0, 50)
    .setValue(3);
  cp5.getController("Planet3Roughness").setVisible(false);

  cp5.addSlider("Planet4Roughness")
    .setPosition(4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 270)
    .setSize(100, 20)
    .setRange(0, 50)
    .setValue(3);
  cp5.getController("Planet4Roughness").setVisible(false);

  cp5.addSlider("Atmosphere1AlphaDiv")
    .setPosition(4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 300)
    .setSize(100, 20)
    .setRange(1, 10)
    .setValue(2);
  cp5.getController("Atmosphere1AlphaDiv").setVisible(false);

  cp5.addSlider("Atmosphere2AlphaDiv")
    .setPosition(4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 300)
    .setSize(100, 20)
    .setRange(1, 10)
    .setValue(2);
  cp5.getController("Atmosphere2AlphaDiv").setVisible(false);

  cp5.addSlider("Atmosphere3AlphaDiv")
    .setPosition(4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 300)
    .setSize(100, 20)
    .setRange(1, 10)
    .setValue(2);
  cp5.getController("Atmosphere3AlphaDiv").setVisible(false);

  cp5.addSlider("Atmosphere4AlphaDiv")
    .setPosition(4 * WIDTHFIFTH + 10, HEIGHTFIFTH + 300)
    .setSize(100, 20)
    .setRange(1, 10)
    .setValue(2);
  cp5.getController("Atmosphere4AlphaDiv").setVisible(false);
}
