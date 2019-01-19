Figure figure;

int STARTINGPOINTS = 20;
float XSCALE = 10;
float YSCALE = 10;
float CENTERX = 540;
float CENTERY = 540;
float MIN_NEIGHBOR_DISTANCE = 2;
float REPEL_DISTANCE = 25;
int FRAMESKIP = 1;
int INSERTAMOUNT = 2;
boolean DRAWHISTORY = false;
boolean DRAWPOINTS = false;
boolean DRAWLINES = true;
boolean PROPORTIONAL_GROWTH = false;
float GROWTH_FACTOR = 1;

void setup() {
  size(1080, 1080);
  reset();
  background(20);
}

void draw() {
  if(!DRAWHISTORY)background(20);
  
  figure.update();
  figure.draw2();
  
  //saveFrame("frames/####.png");
}

void reset() {
  figure = new Figure(CENTERX, CENTERY, XSCALE, YSCALE, STARTINGPOINTS);
}

void mouseClicked() {
   reset();
}