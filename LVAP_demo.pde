//import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
FFT fft;

import java.util.Calendar;
int STATE=2;
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
  size(1024, 768, P3D);

  minim = new Minim(this);
  song = minim.loadFile("marcus_kellis_theme.mp3", 1024);
  song.play();

  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(300);

  fft = new FFT(song.bufferSize(), song.sampleRate());
  kickSize = snareSize = hatSize = minFontSize;
newShapeSize=int(kickSize);
  bl = new BeatListener(beat, song);  
  //textFont(createFont("Helvetica", 16));
  //textAlign(CENTER);

  gifExport = new GifMaker(this, "export.gif");
  gifExport.setRepeat(0); // make it an "endless" animation

  tileHeight=int(tileWidth*0.75);
  state4setup();
  state5setup();
  currentShape = loadShape("module_1.svg");
}

void draw()
{
  scale(2);
  background(255);
  fft.forward(song.mix);
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
  if ( beat.isKick() ) {
    kickSize = maxFontSize;
  }
  if ( beat.isSnare() ) snareSize = maxFontSize;


  run(STATE);


  kickSize = constrain(kickSize * 0.93, minFontSize, maxFontSize);
  snareSize = constrain(snareSize * 0.93, minFontSize, maxFontSize);
  hatSize = constrain(hatSize * 0.93, minFontSize, maxFontSize);

  handleSerial();
  saveGIF(saveGIF);
}

void run(int STATE) {
  if (STATE==1) state1();
  else if (STATE==2) state2();
  else if (STATE==3) state3();
  else if (STATE==4) state4();
  else if (STATE==5) {
    state5();
    camera();
  }
  else if (STATE==0) state0();
}

void state0() {
  background(0);
}


void handleSerial() {
  //println("kickSize: "+kickSize+", hatSize: "+hatSize);
}


void saveGIF(boolean saveGIF) {
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

  int a=int(key);
  if (a>47 & a<58) {//if key is a number from 0 to 9, assign the STATE
    a -= 48;
    STATE=a;
  }
}


// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}