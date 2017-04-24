import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;

import processing.pdf.*;
import java.util.Calendar;

boolean saveGIF = false;

int tileCount = 15;
int actRandomSeed = 0;

int actStrokeCap = ROUND;

float kickSize, snareSize, hatSize;
int Owidth=512;
int Oheight=200;


int maxFontSize=350/tileCount;
int minFontSize=maxFontSize-20;

import gifAnimation.*;
import processing.opengl.*;
GifMaker gifExport;


void setup()
{
  frameRate(30);
  size(600, 800, OPENGL);

  minim = new Minim(this);

  song = minim.loadFile("marcus_kellis_theme.mp3", 1024);
  song.play();
  // a beat detection object that is FREQ_ENERGY mode that 
  // expects buffers the length of song's buffer size
  // and samples captured at songs's sample rate
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  // set the sensitivity to 300 milliseconds
  // After a beat has been detected, the algorithm will wait for 300 milliseconds 
  // before allowing another beat to be reported. You can use this to dampen the 
  // algorithm if it is giving too many false-positives. The default value is 10, 
  // which is essentially no damping. If you try to set the sensitivity to a negative value, 
  // an error will be reported and it will be set to 10 instead. 
  // note that what sensitivity you choose will depend a lot on what kind of audio 
  // you are analyzing. in this example, we use the same BeatDetect object for 
  // detecting kick, snare, and hat, but that this sensitivity is not especially great
  // for detecting snare reliably (though it's also possible that the range of frequencies
  // used by the isSnare method are not appropriate for the song).
  beat.setSensitivity(300);  
  kickSize = snareSize = hatSize = minFontSize;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);  
  textFont(createFont("Helvetica", 16));
  textAlign(CENTER);

  gifExport = new GifMaker(this, "export.gif");
  gifExport.setRepeat(0); // make it an "endless" animation
}

void draw()
{

  background(255);
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

  smooth();
  noFill();
  strokeCap(actStrokeCap);
  randomSeed(actRandomSeed);

  if ( beat.isKick() ) {
    kickSize = maxFontSize;
  }
  if ( beat.isSnare() ) snareSize = maxFontSize;
  if ( beat.isHat() ) {
    hatSize = maxFontSize;
  }

  for (int gridY=0; gridY<tileCount; gridY++) {
    for (int gridX=0; gridX<tileCount; gridX++) {

      int posX = width/tileCount*gridX;
      int posY = (height-Oheight)/tileCount*gridY;

      int toggle = (int) random(0, 2);

      if (toggle == 0) {
        strokeWeight(kickSize);
        line(posX, posY, posX+width/tileCount, posY+(height-Oheight)/tileCount);
      }
      if (toggle == 1) {
        strokeWeight(hatSize);
        line(posX, posY+width/tileCount, posX+(height-Oheight)/tileCount, posY);
      }
    }
  }




  translate(0, height-Oheight);

  fill(0);
  rect(0, 0, width, Oheight);
  fill(255);

  textSize(kickSize);
  text("KICK", width/4, Oheight/2);

  textSize(snareSize);
  text("SNARE", width/2, Oheight/2);

  textSize(hatSize);
  text("HAT", 3*width/4, Oheight/2);

  kickSize = constrain(kickSize * 0.93, minFontSize, maxFontSize);
  snareSize = constrain(snareSize * 0.93, minFontSize, maxFontSize);
  hatSize = constrain(hatSize * 0.95, minFontSize, maxFontSize);

  if (saveGIF) {
    gifExport.setDelay(1);
    gifExport.addFrame();
    if(frameCount%30==0) println(second());
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

  if (key == '1') {
    actStrokeCap = ROUND;
  }
  if (key == '2') {
    actStrokeCap = SQUARE;
  }
  if (key == '3') {
    actStrokeCap = PROJECT;
  }
}


// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}