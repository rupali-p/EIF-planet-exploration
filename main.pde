import controlP5.*;

PImage img;
float zoomFactor = 1.0;
PVector zoomCenter;
ControlP5 cp5;
Button myButton;
Slider mySlider;
int SCREENFIFTH;

void setup() {
  size(900, 600);
  img = loadImage("https://upload.wikimedia.org/wikipedia/en/7/7d/Lenna_%28test_image%29.png");
  zoomCenter = new PVector(width / 2, height / 2);

  SCREENFIFTH = height / 5; // Calculate one-fifth of the screen's height

  cp5 = new ControlP5(this);

  myButton = cp5.addButton("Button")
    .setPosition(SCREENFIFTH, 4 * SCREENFIFTH + (SCREENFIFTH / 3))
    .setSize(200, 40)
    .setCaptionLabel("Click to pan");

  mySlider = cp5.addSlider("Zoom")
    .setPosition(2 * SCREENFIFTH + 220, 4 * SCREENFIFTH + (SCREENFIFTH / 3))
    .setSize(200, 40)
    .setRange(0, 100)
    .setValue(50);
}

void draw() {
  background(255);

  // Calculate the adjusted image size based on zoomFactor and aspect ratio
  float aspectRatio = (float) img.width / img.height;
  float adjustedWidth = width * zoomFactor;
  float adjustedHeight = adjustedWidth / aspectRatio;

  // Calculate the position to center the image on the top 4/5ths of the screen
  float imgX = 0;
  float imgY = 0;

  // Calculate the image position based on zoomCenter
  float offsetX = (width / 2 - zoomCenter.x) * (1 - zoomFactor);
  float offsetY = (height / 2 - zoomCenter.y) * (1 - zoomFactor);

  // Draw the image with the calculated size and position
  image(img, imgX + offsetX, imgY + offsetY, adjustedWidth, adjustedHeight);

  // Draw a block at the bottom one-fifth of the screen
  fill(150);
  rect(0, 4 * SCREENFIFTH, width, SCREENFIFTH);

  // Update ControlP5
  cp5.update();
}

void Zoom(float theValue) {
  // Handle slider value change event
  // Calculate the zoom factor based on the slider value
  zoomFactor = map(theValue, 0, 100, 0.5, 2.0);

  // Center the zoom around the middle of the image
  zoomCenter.set(width / 2, height / 2);
}

void mousePressed() {
  // If the mouse is pressed inside the button area, toggle pan mode
  if (mouseX >= SCREENFIFTH && mouseX <= SCREENFIFTH + 200 &&
      mouseY >= 4 * SCREENFIFTH + (SCREENFIFTH / 3) && mouseY <= 4 * SCREENFIFTH + (SCREENFIFTH / 3) + 40) {
    println("Pan mode enabled.");
  }
}

