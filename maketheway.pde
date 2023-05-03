float bandHeight;//height of the bands
float frogXpos;//green ball's x position
float frogYpos;//green ball's y position
float frogSize;//green ball's diameter
float offset; //moves hazards
float move = 0.0006;
final int RED_BALL = 0;//type for red hazard
final int BLACK_SQUARE = 1;//type for black hazard
final int WHITE_CIRCLE = 2; //type for white hazard
int level = 1;//initial level variable


void setup ()
{
  size (900, 600) ;//canvas size
  bandHeight = height/ (level+4) ;//height of the bands depends on the width size and value of level
  frogXpos = width/2;//the frog starts at this x position
  frogYpos = height - (bandHeight/2) ;//the frog starts at this y position
  frogSize = bandHeight/2; //this is the frog's diameter
}
void draw() {
  drawWorld(); //calling this function here

  drawFrog(frogXpos, frogYpos, frogSize);//calling this function here
  if (! drawHazards()) //runs when the frog does not hit the hazards
  {
    displayMessage("Level"+level);
    if (detectWin()) {
      level++;
      frogSize = bandHeight/2;
      frogXpos = width/2;
      frogYpos= height - (bandHeight/2);
      bandHeight = height / (level+4) ;
    }
  } else { //runs when the frog hits the hazards
    displayMessage ("Ooops...Try Again");
    noLoop();
  }
}
void drawWorld() { //draws the base of the frogger

  for (int i=0; i<=level+4; i++) { //runs until the number of bands
    if (i == 0 || i >= (level +4)- 1) {
      fill (#319ED3); //different colour for the top and bottom band
    } else {
      fill (#EDA537); //different colour for the centre bands
    }
    noStroke();//prevent the lines of every band to show up
    rect (0, i*bandHeight, width, bandHeight) ;//draws the bands
  }
}
void drawFrog (float x, float y, float diam) { //draws the green circle/the frog
  fill(#295A24); //colour for the frog
  stroke(3);
  circle(x, y, diam); //frog (circle)
}
void moveFrog(float xChange, float yChange) {
  if (objectInCanvas (frogXpos + xChange, frogYpos + yChange, frogSize)) {
    frogXpos += xChange; //updated x position of the frog when it moves left or right
    frogYpos += yChange; //updated y position of the frog when it moves up or down
  }
}

void keyPressed() {
  if (key =='w'|| key == 'i' || key =='W' || key == 'I') { 
    moveFrog(0, -bandHeight); //when these buttons are pressed the frog moves up
  }
  if (key =='d' || key =='l' || key == 'D' || key == 'L') {
    moveFrog (frogSize, 0); //when these buttons are pressed the frog moves right
  }
  if (key =='s' || key== 'k' || key == 'S' || key == 'K') {
    moveFrog (0, bandHeight); //when these buttons are pressed the frog moves down
  }
  if (key =='a' || key =='j' || key == 'A' || key == 'J') {
    moveFrog (-frogSize, 0); //when these buttons are pressed the frog moves left
  }
}


boolean objectInCanvas (float x, float y, float diam) { //PHASE 2
  return x + diam/2 >= 0 && x - diam/2 <= width && y >= 0 && y <= height; //makes sure everything remains inside the canvas
}
boolean drawHazard (int type, float x, float y, float size) { //PHASE 3
  if (type == RED_BALL) {
    fill (#FF0000) ;
    circle(x, y, size) ; //draws the red ball hazard
  } else if (type == BLACK_SQUARE) {
    fill(0) ;
    rect (x, y-size/2, size, size) ; //draws the black square hazard
  } else if (type == WHITE_CIRCLE) {
    fill(#FFFFFF) ;
    circle(x, y, size) ; //draws the white circle hazard
  }
  return objectsOverlap(x, y, frogXpos, frogYpos, size, frogSize); //returns the function here
}

boolean drawHazards() { //using nested loops
  float xPos;
  float yPos;
  boolean overLap = false;
  for (int i=0; i<level+2; i++) {

    float hazard = width/ ((i+3) *bandHeight);
    for (float j = - ((i+3) *bandHeight); j<=hazard+1; j++) {
      if (i%2 == 0) {
        xPos = j* (i+3) *bandHeight + (i+3) *offset; //moves right
      } else {
        xPos = j* (i+3) *bandHeight - (i+3) *offset; //moves left
      }
      yPos = height - ((i+1) *bandHeight) - bandHeight/2; //gives enough space for frog to make a jump
      if (!overLap) {
        overLap = drawHazard (i%3, xPos, yPos, bandHeight/1.5);
      } else {
        drawHazard (i%3, xPos, yPos, bandHeight/1.5) ;
      }
      offset = (offset + move) %bandHeight; //enables them to move right
    }
  }
  return overLap; //returing its value
}

void displayMessage (String m) {
  fill (0) ;//black font
  textSize(bandHeight/2) ;//font size
  text (m, width/2 - textWidth(m)/2, bandHeight/2 + textDescent ()) ; // size of the message depends on the bandHeight every time the frog reaches next level
}

boolean detectWin() { 
  return frogYpos<=bandHeight+frogSize/2;//everytime when frog touches the first band
}

boolean objectsOverlap(float x1, float y1, float x2, float y2, float size1, float size2) {

  float distance = sqrt( sq( ( x1+size1/2 ) - ( x2+size2/2 ) ) + sq( ( y1+size1/2 )- ( y2+size2/2 ) ) ); //when the frog touches any of the hazards
  return distance < size1/2; //returns if the value is true/overlapped
}
