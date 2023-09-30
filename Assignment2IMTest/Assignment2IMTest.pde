PVector[][] globe;
int total;
float phase = 0;
float colorMutator = 0.04;
float speed = 0.03;

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


//SOLAR RADITION - https://eif-research.feit.uts.edu.au/graph/?rFromDate=2021-01-01T00%3A00&rToDate=2021-12-31T23%3A59%3A59&rFamily=weather&rSensor=SR


void setup() {

  size(600, 600, P3D);
  colorMode(HSB, 255);
  frameRate(20);


  //INSTANTIATE PLANETS
  planet1 = new Planet();
  planet2 = new Planet();
  planet3 = new Planet();
  planet4 = new Planet();

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

void draw() {
  if (!dataSetup) {
    CompleteDataSetup();
    dataSetup = true;
  }

  background(0);
  noStroke();
  translate(100, 300, 0);
  


  planet1.CreatePlanetMain(monthtemps4, monthsolars4, phase, avgTemp);
  planet1.CreatePlanetAtmosphere(monthrains4, phase);


  translate(400, 0, 0);
  planet2.CreatePlanetMain(monthtemps1, monthsolars1, phase, avgTemp);
  planet2.CreatePlanetAtmosphere(monthrains1, phase);

  phase += speed;
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
}
