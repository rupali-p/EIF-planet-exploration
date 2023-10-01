import controlP5.*;
ControlP5 cp5;

import processing.sound.*;
SoundFile sound;
float volume = 0.5;

Planet sun;
float speed = 0.005;
PImage sunImage;
PImage[] planetImages;
PImage backgroundImg;


float zoomFactor = 0.75;
float ZOOMTHRESHOLD = 1.0;
PVector zoomCenter;
Button panButton;
Button button1;
Button button2;
Button button3;
Slider mySlider;
int HEIGHTFIFTH;
int WIDTHFIFTH;
boolean pan = false;
boolean displayPlanets = true;
PGraphics mask;
HashMap<String, String> textMap; // Map to store dynamic texts
boolean button1Clicked = false;
boolean button2Clicked = false;
boolean button3Clicked = false;

PVector[][] globe;
int total;
float phase = 0;
float colorMutator = 0.04;
//float speed = 0.03;

int rowCount;

int lasti;

boolean dataSetup = false;


//PLANETS
Planet planet1;
Planet planet2;
Planet planet3;
Planet planet4;

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


void setup(){
  //frameRate(20);
  size(900, 600, P3D);
  backgroundImg = loadImage("space3.jpg");
  backgroundImg.resize(width, height);
  image(backgroundImg, 0, 0);
  
  sound = new SoundFile(this, "music1.mp3");
  sound.amp(volume);
  sound.loop();
  
  //slider for the volume of the sound
  cp5 = new ControlP5(this);
  cp5.addSlider("volume")
     .setPosition(100, 30)
     .setSize(300, 20)
     .setRange(0, 1)
     .setValue(0.5)
     ;
     
  //slider for controlling the speed of the planets   
  cp5.addSlider("speed")
     .setPosition(100, 70)
     .setSize(300, 20)
     .setRange(0, 0.01)
     .setDecimalPrecision(3)
     .setValue(0.005);

  zoomCenter = new PVector(width / 2, height / 2);

  HEIGHTFIFTH = height / 5;
  WIDTHFIFTH = width / 5;
  hint(DISABLE_DEPTH_TEST);
  panButton = cp5.addButton("PanButton")
    .setPosition(HEIGHTFIFTH, 4 * HEIGHTFIFTH + (HEIGHTFIFTH / 3))
    .setSize(200, 40)
    .setCaptionLabel("Click to Pan");

  button1 = cp5.addButton("Button1")
    .setPosition(4 * WIDTHFIFTH + 20, HEIGHTFIFTH + 40)
    .setSize(40, 40)
    .setCaptionLabel("Button 1");

  button2 = cp5.addButton("Button2")
    .setPosition(4 * WIDTHFIFTH + 70, HEIGHTFIFTH + 40)
    .setSize(40, 40)
    .setCaptionLabel("Button 2");

  button3 = cp5.addButton("Button3")
    .setPosition(4 * WIDTHFIFTH + 120, HEIGHTFIFTH + 40)
    .setSize(40, 40)
    .setCaptionLabel("Button 3");

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

  textMap = new HashMap<String, String>();
  textMap.put("PanEnabledThresholdCrossed", "Pan is enabled.\nThreshold crossed.");
  textMap.put("PanEnabledThresholdNotCrossed", "Pan is enabled.\nThreshold not crossed.");
  textMap.put("PanDisabledThresholdCrossed", "Pan is disabled.\nThreshold crossed.");
  textMap.put("PanDisabledThresholdNotCrossed", "Pan is disabled.\nThreshold not crossed.");
  textMap.put("PanEnabled", "Pan is enabled.");
  textMap.put("PanDisabled", "Pan is disabled.");
  hint(ENABLE_DEPTH_TEST);
  
  
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
}

float xoff = 0;

void draw(){
    if (!dataSetup) {
    CompleteDataSetup();
    dataSetup = true;
  }
  background(backgroundImg);
  panLabeling();
  
  pushMatrix();
  
  translate(2 * WIDTHFIFTH, 2 * HEIGHTFIFTH);
  if (displayPlanets){
    sun.display();
    sun.orbit();
  }
  float cameraZ = 300 / tan(PI/6); // Fixed camera distance for zoom
  Zoom(mySlider.getValue());
  if (zoomFactor >= ZOOMTHRESHOLD){
    pov();
  }else{
    displayPlanets = true;
    perspective(PI/3.0, float(width) / float(height), cameraZ/10.0, cameraZ*10.0);
    translate(width / 2, height / 2);
    scale(zoomFactor);
  
    lights();
    fill(0); // White sphere
    noStroke();
    sphere(100);
    hint(DISABLE_DEPTH_TEST);
    fill(150);
    rect(0, 4 * HEIGHTFIFTH, width, HEIGHTFIFTH);
    //rect(4 * WIDTHFIFTH, 0, WIDTHFIFTH, height);
    hint(ENABLE_DEPTH_TEST);
  }
  popMatrix();
  pov();
  
  hint(DISABLE_DEPTH_TEST);
  fill(150);
  rect(0, 4 * HEIGHTFIFTH, width, HEIGHTFIFTH);
  rect(4 * WIDTHFIFTH, 0, WIDTHFIFTH, height);
  displayText();
  hint(ENABLE_DEPTH_TEST);
}

void volume(float vol){
  volume = vol;
  sound.amp(volume);
}

void speed(float s){
  if(sun != null){
  speed = s;
  sun.orbitSpeed = s;
  for (Planet p: sun.planets){
    if (p != null) p.orbitSpeed = s;
    }
  }
}

void panLabeling() {
  if (pan) {
    panButton.getCaptionLabel().setText("Click to Disable Pan");
  } else {
    panButton.getCaptionLabel().setText("Click to Pan");
  }
     // println(pan);
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
      mask.arc((width / 2) - width / 10, (height / 2) + height/4.2 , width/1.5, 1.4 * height, PI, TWO_PI);
    }

    blend(mask, 0, 0, width, height, 0, 0, width, height, SCREEN);
    mask.endDraw();
  }
}

void Zoom(float theValue) {
  zoomFactor = map(theValue, 0, 100, 0.5, 2.0);
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
  if (mouseX >= 4 * WIDTHFIFTH + 20 && mouseX <= 4 * WIDTHFIFTH + 60 &&
      mouseY >= HEIGHTFIFTH + 40 && mouseY <= HEIGHTFIFTH + 80) {
    button1Clicked = !button1Clicked;
  }
  if (mouseX >= 4 * WIDTHFIFTH + 70 && mouseX <= 4 * WIDTHFIFTH + 110 &&
      mouseY >= HEIGHTFIFTH + 40 && mouseY <= HEIGHTFIFTH + 80) {
    button2Clicked = !button2Clicked;
  }
  if (mouseX >= 4 * WIDTHFIFTH + 120 && mouseX <= 4 * WIDTHFIFTH + 160 &&
      mouseY >= HEIGHTFIFTH + 40 && mouseY <= HEIGHTFIFTH + 80) {
    button3Clicked = !button3Clicked;
  }
  
  // Print which buttons have been clicked
  switchButtons();
}


void switchButtons() {
  println("Button 1 clicked: " + button1Clicked);
  println("Button 2 clicked: " + button2Clicked);
  println("Button 3 clicked: " + button3Clicked);
}

void displayText(){
   //Display dynamic text in the right column
  fill(0);
  textAlign(LEFT);
  textSize(16);

  // Determine the appropriate text based on zoomFactor and pan state
  String currentTextKey = "";
  if (pan) {
    if (zoomFactor >= ZOOMTHRESHOLD) {
      currentTextKey = "PanEnabledThresholdCrossed";
    } else {
      currentTextKey = "PanEnabled";
    }
  } else {
    if (zoomFactor >= ZOOMTHRESHOLD) {
      currentTextKey = "PanDisabledThresholdCrossed";
    } else {
      currentTextKey = "PanDisabled";
    }
  }
  String currentText = textMap.get(currentTextKey);
  if (currentText != null) {
    text(currentText, 4 * WIDTHFIFTH + 10, HEIGHTFIFTH);
  }
}

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
    sun = new Planet(100, 0, 0, 0, monthrains1, monthrains1);
  sun.childrenPlanets(4);
      
}
