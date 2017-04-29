//import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;

import java.util.Calendar;

boolean saveGIF = false;

int tileWidth = 8; //
int tileHeight = 6;// actual grid in height=tileCount*0.75
//int tileCount = 16; //actual grid in width
//1024/16=768/12
int actRandomSeed = 0;

int actStrokeCap = ROUND;

float kickSize, snareSize, hatSize;
//int Owidth=512;
//int Oheight=200;


int maxFontSize=37;
int minFontSize=3;

import gifAnimation.*;
import processing.opengl.*;
GifMaker gifExport;

color circleColor = color(255);
int circleAlpha = 180;

int RHeight=384;//768/2
int RWidth=524;//1024/2


void setup()
{
  frameRate(30);
  size(1024, 768, OPENGL);

  minim = new Minim(this);

  song = minim.loadFile("marcus_kellis_theme.mp3", 1024);
  song.play();

  beat = new BeatDetect(song.bufferSize(), song.sampleRate());

  beat.setSensitivity(300);
  
  kickSize = snareSize = hatSize = minFontSize;

  bl = new BeatListener(beat, song);  
  //textFont(createFont("Helvetica", 16));
  //textAlign(CENTER);

  gifExport = new GifMaker(this, "export.gif");
  gifExport.setRepeat(0); // make it an "endless" animation
 
  tileHeight=int(tileWidth*0.75);
  
}

void draw()
{

  background(0); //black background
  // draw a green rectangle for every detect band
  // that had an onset this frame
  //float rectW = width / beat.detectSize();
  //for(int i = 0; i < beat.detectSize(); ++i)
  //{
  //  // test one frequency band for an onset
  //  if ( beat.isOnset(i) )
  //  {
  //    fill(0,200,0);
  //    rect( i*rectW, 0, rectW, Oheight);
  //  }
  //}

  // draw an orange rectangle over the bands in 
  // the range we are querying
  //int lowBand = 5;
  //int highBand = 15;
  //// at least this many bands must have an onset 
  //// for isRange to return true
  //int numberOfOnsetsThreshold = 4;
  //if ( beat.isRange(lowBand, highBand, numberOfOnsetsThreshold) )
  //{
  //  fill(232,179,2,200);
  //  rect(rectW*lowBand, 0, (highBand-lowBand)*rectW, Oheight);
  //}

  
  if ( beat.isHat() ) {
    hatSize = maxFontSize;
  }
  else if ( beat.isKick() ) {
    kickSize = maxFontSize;
  }
  //if ( beat.isSnare() ) snareSize = maxFontSize;


  //translate(width/tileCount/2, height/tileCount/2);

  //background(0);
  //smooth();
  //noFill();


  //stroke(circleColor, circleAlpha);
  //strokeWeight(kickSize);

  //for (int gridY=0; gridY<tileCount; gridY++) {
  //  for (int gridX=0; gridX<tileCount; gridX++) {

  //    float posX = 600/tileCount * gridX;
  //    float posY = 600/tileCount * gridY;

  //    float shiftX = random(-kickSize*20, kickSize*20)/20;
  //    float shiftY = random(-kickSize*20, kickSize*20)/20;

  //    ellipse(posX+shiftX, posY+shiftY, kickSize/2/15, hatSize/2/15);
  //  }
  //}
  pushMatrix();
  smooth();
  noFill();
  
  
  randomSeed(actRandomSeed);
  scale(2);
  //stroke(255);
  strokeCap(ROUND);
  for (int gridY=0; gridY<tileHeight; gridY++) {
    for (int gridX=0; gridX<tileWidth; gridX++) {
stroke(map(kickSize,minFontSize,maxFontSize,200,255));
      int posX = int(RWidth/tileWidth)*gridX;
      int posY = int(RHeight/tileHeight)*gridY;

      int toggle = (int) random(0, 2);

      if (toggle == 0) {

        strokeWeight(kickSize);
        line(posX, posY, posX+RWidth/tileWidth, posY+RHeight/tileHeight);
      }
      if (toggle == 1) {
stroke(map(hatSize,minFontSize,maxFontSize,100,255));
        strokeWeight(hatSize);
        line(posX, posY+RWidth/tileWidth, posX+RHeight/tileHeight, posY);
      }
    }
  }
scale(2);

  popMatrix();
  

  kickSize = constrain(kickSize * 0.93, minFontSize, maxFontSize);
  snareSize = constrain(snareSize * 0.93, minFontSize, maxFontSize);
  hatSize = constrain(hatSize * 0.93, minFontSize, maxFontSize);
  
  handleSerial();
  save(saveGIF);

  
}


void handleSerial(){
  println("kickSize: "+kickSize+", hatSize: "+hatSize);
  
  
}

void save(boolean saveGIF){
  if (saveGIF) {
    gifExport.setDelay(1);
    gifExport.addFrame();
    if (frameCount%30==0) println(second());
  }
}




void mousePressed() {
  actRandomSeed = (int) random(100000);
}

void keyReleased() {
  if (key == 's' || key == 'S') saveFrame(timestamp()+"_##.png");
  if (key == 'g' || key == 'G') {
    saveGIF = !saveGIF;
    if (!saveGIF) {//false
      gifExport.finish();
    }
    println("GIF: "+saveGIF);
  }

}


// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}