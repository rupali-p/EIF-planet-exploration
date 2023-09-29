PVector[][] globe;
int total;
float phase = 0;
float colorMutator = 0.04;
float speed = 0.03;
Table xy;
int rowCount;
float maxTempValue = 0;
float minTempValue = 1000;
int lasti;
float lastTemp;
float thisTemp;
float tempRange;
Planet planet1;
Planet planet2;

FloatList temps;
FloatList monthtemps1;
FloatList monthtemps2;
FloatList monthtemps3;
FloatList monthtemps4;

float totalTemp; 
float avgTemp;
float tempDayCount;


//SOLAR RADITION - https://eif-research.feit.uts.edu.au/graph/?rFromDate=2021-01-01T00%3A00&rToDate=2021-12-31T23%3A59%3A59&rFamily=weather&rSensor=SR


void setup() {
  size(600, 600, P3D);
  colorMode(HSB, 255);
  frameRate(20);
  planet1 = new Planet();
  planet2 = new Planet();
  temps = new FloatList();
  monthtemps1 = new FloatList();
  monthtemps2 = new FloatList();
  monthtemps3 = new FloatList();
  monthtemps4 = new FloatList();

  xy = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2022-01-01T00%3A00&rToDate=2022-12-31T23%3A59%3A59&rFamily=weather&rSensor=AT", "csv");
  rowCount = xy.getRowCount();
  int currentRowCountTest = rowCount/365;
  int lastRowCountTest = 0;
  float thisTotalDayTemp = 0;
  for (int i = 0; i < 365; i++) {
    for (int j = lastRowCountTest; j < currentRowCountTest; j++) {
      thisTotalDayTemp += xy.getFloat(j, 1);
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
      if(thisTemp < minTempValue) minTempValue = thisTemp; 
      if(thisTemp > maxTempValue) maxTempValue = thisTemp;
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
  println(minTempValue);
  println(maxTempValue);
  println(tempRange);
  println(avgTemp);
  println(avgTemp/3);
  println(avgTemp/3 + avgTemp/3);
  total = monthtemps4.size();
  globe = new PVector[total+1][total+1];
}

float xoff = 0;

void draw() {
  background(0);
  noStroke();
  translate(100, 300, 0);

  planet1.CreatePlanetMain(monthtemps4, monthtemps4, phase, avgTemp);
  //planet1.CreatePlanetAtmosphere(monthtemps4, phase);
  
  
    translate(400, 0, 0);
  planet2.CreatePlanetMain(monthtemps3, monthtemps3, phase, avgTemp);
    //planet2.CreatePlanetAtmosphere(monthtemps1, phase);
  
  phase += speed;
}
