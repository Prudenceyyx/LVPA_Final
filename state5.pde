//EspiralCubs
//(CreativeCommons-Some rights reserved)By DimaVJ ---Albert Callejo 2008---  www.dima-vj.com

cubGira CS;

float fase;
float rot;
int amp, MAXamp, alf;

//Per moviments smooth desprï¿½s de mouseX mouseY
float x, y;
float inercia =.125;
float deltaX;
float deltaY;



void state5setup() {

  //noCursor();

  CS = new cubGira();

  //smooth();

  fase=0.0;
  MAXamp=100;
  amp=5;
  alf=100;
}



void state5() {
  strokeWeight(1);
  scale(0.5);
  background(0);
  //Calcul inercia aplicada a camera  
  deltaX=(pmouseX/2-x);
  deltaY=(pmouseY/2-y);
  deltaX*=inercia;
  deltaY*=inercia;
  x+=deltaX;
  y+=deltaY;


  stroke(80+y, 80+y, 30);
  rot=x/y+1 ;
  camera(6*y, 700.0-y, x+y*2, 2*x+y, -y+240, height-x-200, -10, 0, 0.0);

  pushMatrix();
  for (int a=0; a<60; a++) {
    translate(20, 5, 90);
    rotateX(fase);

    CS.draw(fase, int(x), a);
  }

  popMatrix();
  //if(beat.isKick())fase=fase+0.005%TWO_PI;
  //else{
  fase=fase+0.001%TWO_PI;
  //}
}//endDraw-----------------------




//------------------------------------CUB-------------------
class cubGira {
  public cubGira() {
  }
  public void draw(float fase, int amp, int tamany) {
    pushMatrix();

    fill(90+x/3, y/2.3, 100);
    //fill(map(kickSize,3,37,150,255));
    translate(-y, float(amp), -x);
    if(beat.isHat()) rotateY(y);
    tamany=int(tamany*kickSize/10);
    box(tamany); 
    popMatrix();
  }
}