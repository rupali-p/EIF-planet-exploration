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

void setup(){
  size(1074, 647, P3D);
  backgroundImg = loadImage("space3.jpg");
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
      
}

void draw(){
  background(backgroundImg);
  
  pushMatrix();
  translate(width/2, height/2);
  sun.display();
  sun.orbit();
  popMatrix(); 
  
  
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
