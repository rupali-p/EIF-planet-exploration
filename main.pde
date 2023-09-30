import controlP5.*;
import processing.core.PImage;
import processing.core.PVector;
import java.util.HashMap;

PImage img;
float zoomFactor = 1.0;
PVector zoomCenter;
ControlP5 cp5;
Button myButton;
Slider mySlider;
int HEIGHTFIFTH;
int WIDTHFIFTH;
boolean pan = false;
PGraphics mask;
HashMap<String, String> textMap; // Map to store dynamic texts

void setup() {
  size(900, 600);
  img = loadImage("moonwalk.jpg");
  img.resize(width, height);
  zoomCenter = new PVector(width / 2, height / 2);

  HEIGHTFIFTH = height / 5;
  WIDTHFIFTH = width / 5;

  cp5 = new ControlP5(this);
  myButton = cp5.addButton("Button")
    .setPosition(HEIGHTFIFTH, 4 * HEIGHTFIFTH + (HEIGHTFIFTH / 3))
    .setSize(200, 40)
    .setCaptionLabel("Click to Pan");

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
}

void draw() {
  PImage spacebg = loadImage("space.jpg");
  spacebg.resize(width, height);
  background(spacebg);
  panLabeling();
  float aspectRatio = (float) img.width / img.height;
  float adjustedWidth = width * zoomFactor;
  float adjustedHeight = adjustedWidth / aspectRatio;

  float imgX = 0;
  float imgY = 0;

  float offsetX = (width / 2 - zoomCenter.x) * (1 - zoomFactor);
  float offsetY = (height / 2 - zoomCenter.y) * (1 - zoomFactor);

  // Apply zoom and pan
  image(img, imgX + offsetX, imgY + offsetY, adjustedWidth, adjustedHeight);
  pov();
  fill(150);
  rect(0, 4 * HEIGHTFIFTH, width, HEIGHTFIFTH);
  rect(4 * WIDTHFIFTH, 0, WIDTHFIFTH, height);

  // Display dynamic text in the right column
  fill(0);
  textAlign(LEFT);
  textSize(16);

  // Determine the appropriate text based on zoomFactor and pan state
  String currentTextKey = "";
  if (pan) {
    if (zoomFactor >= 1.3) {
      currentTextKey = "PanEnabledThresholdCrossed";
    } else {
      currentTextKey = "PanEnabled";
    }
  } else {
    if (zoomFactor >= 1.3) {
      currentTextKey = "PanDisabledThresholdCrossed";
    } else {
      currentTextKey = "PanDisabled";
    }
  }
  String currentText = textMap.get(currentTextKey);
  if (currentText != null) {
    text(currentText, 4 * WIDTHFIFTH + 10, HEIGHTFIFTH);
  }

  cp5.update();
}

void panLabeling() {
  if (pan) {
    myButton.getCaptionLabel().setText("Click to Disable Pan");
  } else {
    myButton.getCaptionLabel().setText("Click to Pan");
  }
}

void pov() {
  if (zoomFactor >= 1.3) {
    // Update the mask position to follow the mouse
    mask.beginDraw();
    mask.background(255); // Clear the mask
    mask.noStroke();
    mask.fill(0, 0, 0, 255); // Transparent black fill

    if (pan) {
      // Draw an inverted semi-circle in the mask when panning
      mask.arc(map(mouseX, 0, width, 1.7 *  HEIGHTFIFTH, width - 2.7 * WIDTHFIFTH), (height / 2) + height/4.2, width/1.5, 1.4 * height, PI, TWO_PI);
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
}
