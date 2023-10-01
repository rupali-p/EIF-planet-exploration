Planet sun;
PImage sunImage;
PImage[] planetImages;
PImage backgroundImg;

void setup(){
  size(1074, 647, P3D);
  backgroundImg = loadImage("space3.jpg");
  image(backgroundImg, 0, 0);
  sunImage = loadImage("sun.jpg");
  
  planetImages = new PImage[4];
  planetImages[0] = loadImage("earth.jpg");
  planetImages[1] = loadImage("jupiter.jpg");
  planetImages[2] = loadImage("mars.jpg");
  planetImages[3] = loadImage("neptune.jpg");
  
  sun = new Planet(100, 0, 0, 0, sunImage);
  sun.childrenPlanets(4);
}

void draw(){
  background(backgroundImg);
  
  pushMatrix();
  translate(width/2, height/2);
  sun.display();
  sun.orbit();
  popMatrix();
}
