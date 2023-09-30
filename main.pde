import controlP5.*;
import processing.core.PImage;
import processing.core.PVector;

PImage img;
float zoomFactor = 1.0;
PVector zoomCenter;
ControlP5 cp5;
Button myButton;
Slider mySlider;
int SCREENFIFTH;
int WIDTHFIFTH;
boolean pan = false;
PGraphics mask;

void setup() {
  size(900, 600);
  img = loadImage("moonwalk.jpg");
  img.resize(width, height);
  zoomCenter = new PVector(width / 2, height / 2);

  SCREENFIFTH = height / 5;
  WIDTHFIFTH = width / 5;
 
  cp5 = new ControlP5(this);
  myButton = cp5.addButton("Button")
    .setPosition(SCREENFIFTH, 4 * SCREENFIFTH + (SCREENFIFTH / 3))
    .setSize(200, 40)
    .setCaptionLabel("Click to Pan");
    
  mySlider = cp5.addSlider("Zoom")
    .setPosition(2 * SCREENFIFTH + 220, 4 * SCREENFIFTH + (SCREENFIFTH / 3))
    .setSize(200, 40)
    .setRange(0, 100)
    .setValue(0);
    
  mask = createGraphics(width, height);
  mask.beginDraw();
  mask.background(255); // Set the initial mask background to white
  mask.noStroke();
  mask.fill(0, 0, 0, 255); // Transparent black fill
  mask.endDraw();
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
  rect(0, 4 * SCREENFIFTH, width, SCREENFIFTH);
  rect(4 * WIDTHFIFTH, 0, WIDTHFIFTH, height);
  cp5.update();
}

void panLabeling(){
  if (pan) {
    myButton.getCaptionLabel().setText("Click to Disable Pan");
  } else {
    myButton.getCaptionLabel().setText("Click to Pan");
  }
}

void pov(){
  if (zoomFactor >= 1.3) {
    // Update the mask position to follow the mouse
    mask.beginDraw();
    mask.background(255); // Clear the mask
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
  if (mouseX >= SCREENFIFTH && mouseX <= SCREENFIFTH + 200 &&
      mouseY >= 4 * SCREENFIFTH + (SCREENFIFTH / 3) && mouseY <= 4 * SCREENFIFTH + (SCREENFIFTH / 3) + 40) {
    if (pan) {
      println("Pan mode disabled.");
      pan = false;
    } else {
      println("Pan mode enabled.");
      pan = true;
    }
  }
}
