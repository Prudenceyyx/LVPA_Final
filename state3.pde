
void state3() {
  translate(RWidth/tileWidth/2, RHeight/tileHeight/2);

  background(0);
  smooth();
  noFill();

  stroke(circleColor, circleAlpha);
  strokeWeight(kickSize);

  for (int gridY=0; gridY<tileHeight; gridY++) {
    for (int gridX=0; gridX<tileWidth; gridX++) {

      float posX = RWidth/tileWidth * gridX;
      float posY = RHeight/tileHeight * gridY;

      float shiftX = random(-kickSize*20, kickSize*20)/20;
      float shiftY = random(-kickSize*20, kickSize*20)/20;

      ellipse(posX+shiftX, posY+shiftY, kickSize/2/15, hatSize/2/15);
    }
  }
}