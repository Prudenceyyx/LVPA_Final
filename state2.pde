PShape currentShape;

float shapeSize = 80;
float newShapeSize = shapeSize;
float shapeAngle = 0;
float maxDist;

color shapeColor = color(0, 130, 164);
int fillMode = 0;
int sizeMode = 0;

void state2() {

  for (int gridY=0; gridY<tileHeight; gridY++) {
    for (int gridX=0; gridX<tileWidth; gridX++) {

      float posX = RWidth/tileWidth*gridX + RWidth/tileWidth/2;
      float posY = RHeight/tileHeight*gridY + RHeight/tileHeight/2;

      float angle = atan2(mouseY/2-posY, mouseX/2-posX) + radians(0);


      if (sizeMode == 0) newShapeSize = shapeSize;

      //if (fillMode == 0) currentShape.enableStyle();

      newShapeSize=kickSize;

      pushMatrix();
      translate(posX, posY);
      rotate (angle);
      shapeMode (CENTER);

      shape(currentShape, 0, 0, newShapeSize, newShapeSize);
      popMatrix();
    }
  }
}