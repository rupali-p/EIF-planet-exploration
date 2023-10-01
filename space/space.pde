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

void setup(){
  size(900, 600, P3D);
  backgroundImg = loadImage("space3.jpg");
  backgroundImg.resize(width, height);
  image(backgroundImg, 0, 0);
  sunImage = loadImage("sun.jpg");
  
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
  
  planetImages = new PImage[4];
  planetImages[0] = loadImage("earth.jpg");
  planetImages[1] = loadImage("jupiter.jpg");
  planetImages[2] = loadImage("mars.jpg");
  planetImages[3] = loadImage("neptune.jpg");
  
  sun = new Planet(100, 0, 0, 0, sunImage);
  sun.childrenPlanets(4);
      
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
}

void draw(){
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
  speed = s;
  sun.orbitSpeed = s;
  for (Planet p: sun.planets){
    if (p != null) p.orbitSpeed = s;
  }
}

void panLabeling() {
  if (pan) {
    panButton.getCaptionLabel().setText("Click to Disable Pan");
  } else {
    panButton.getCaptionLabel().setText("Click to Pan");
  }
      println(pan);
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