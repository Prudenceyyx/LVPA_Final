void state1() {
  background(0); //black background
  pushMatrix();
  smooth();
  noFill();

  randomSeed(actRandomSeed);

  //stroke(255);
  strokeCap(ROUND);
  for (int gridY=0; gridY<tileHeight; gridY++) {
    for (int gridX=0; gridX<tileWidth; gridX++) {
      stroke(map(kickSize, minFontSize, maxFontSize, 200, 255));
      int posX = int(RWidth/tileWidth)*gridX;
      int posY = int(RHeight/tileHeight)*gridY;

      int toggle = (int) random(0, 2);

      if (toggle == 0) {

        strokeWeight(kickSize);
        line(posX, posY, posX+RWidth/tileWidth, posY+RHeight/tileHeight);
      }
      if (toggle == 1) {
        stroke(map(hatSize, minFontSize, maxFontSize, 100, 255));
        strokeWeight(hatSize);
        line(posX, posY+RWidth/tileWidth, posX+RHeight/tileHeight, posY);
      }
    }
  }

  popMatrix();
}