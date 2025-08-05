import processing.sound.*;

SoundFile[] sfx;

int W_W = 1280;
int W_H = 720;

color SKY_COLOR = color(132, 178, 250);

PImage[] castleImgs;
int CASTLE_SIZE = 400;
int hitCount = 0;
int CASTLE_HIT_COUNT_LIM = 10;
int CASTLE_IMG_COUNT = 2;
int thisS = 0;

int score = 0;

PFont font;

PImage weed;
float weedManStretch = 0;
boolean showWeedMan = false;
boolean weedManClicked = false;
boolean canBeClicked = true;
int xStretch = 0;

int frames = 0;

String[] sentences = {"Hi","Im Weed Man im gonna help you learn the ropes","Over there is the tower","You have to destroy that tower","'How?' you ask well with this very weapon"};
int sentenceIndex = 0;
String curSentence = sentences[0];
boolean nextSentece = false;

int boxW = 0;

String[] characs = {"Weed Man"};

boolean startIntro = true;
boolean startPlaying = false;

PImage bg;

PImage logo;

String[] soundFileNames = {"squeak.mp3"};

void setup(){
  castleImgs = new PImage[CASTLE_IMG_COUNT];
  font = createFont("OpenSans-Cond.ttf",48);
  weed = loadImage("WEEDMAN.png");
  bg = loadImage("bg.png");
  bg.resize(1280,720);
  logo = loadImage("logo.png");
  sfx = new SoundFile[soundFileNames.length];
  for(int s = 0; s < soundFileNames.length; s++){
    sfx[s] = new SoundFile(this, soundFileNames[s]);
  }
  for(int i = 0; i < CASTLE_IMG_COUNT; i++){
    castleImgs[i] = loadImage("towers/castle/imgs/"+i+".png");
  }
  frameRate(9999);
  size(1280,720);
}

void draw(){
  background(SKY_COLOR);
  frames++;
  drawBackground();
  drawCastle();
  drawShopKeeper();
  drawText();
  showIntro();
  println("FPS: "+int(frameRate));
}

void drawCastle(){
  thisS += 6;
  float toBob = 100*sin(radians(thisS*-1.5))*0.1;
  imageMode(CENTER);
  image(castleImgs[0],W_W/2,W_H/2,CASTLE_SIZE+toBob,CASTLE_SIZE+toBob);
}

void drawBackground(){
  textFont(font);
  noStroke();
  rectMode(CENTER);
  fill(50, 168, 82);
  rect(W_W/2,W_H+150,W_W,W_H);
  fill(0);
  text("Score: "+score,20,100);
}

void drawShopKeeper(){
  if(showWeedMan){
    weedManStretch += 6;
    float toBob = 100*sin(radians(weedManStretch*-1.5))*0.1;
    image(weed,200,580+toBob,550+toBob,450);
  }
}

void drawText(){
  if(showWeedMan){
    textFont(font);
    fill(0);
  
    int boxX = 530;
    int boxY = 670;
    int MARGIN = 40;
  
    float textW = textWidth(curSentence);
    boxW = int(textW+MARGIN*2);
  
    rectMode(CENTER);
    fill(0);
    rect(boxX,boxY,boxW,100);
  
    fill(255);
    textAlign(LEFT,CENTER);
    text(characs[0],boxX-boxW/2+20+MARGIN,boxY-70);
    text(curSentence,boxX-boxW/2+MARGIN,boxY-5);
    if(keyPressed && key == ' '){
      if(!nextSentece){
        sentenceIndex = (sentenceIndex+1)%sentences.length;
        curSentence = sentences[sentenceIndex];
        nextSentece = true;
      }
    }else{
      nextSentece = false;
    }
  }
  fill(0);
  text("Space to continue",1002,670);
  fill(255);
  text("Space to continue",1000,670);
}

void showIntro(){
  if(startIntro){
    background(bg);
    weedManStretch += 6;
    float toBob = 100*sin(radians(weedManStretch*-1.5))*0.1;
    float goTo = cosInter(1000,570,frames/frameRate);
    image(weed,200,goTo+toBob,550+toBob+xStretch,450);
    xStretch *= 0.9;
    image(logo,800,cosInter(0,200,frames/frameRate),350+toBob,350+toBob);
    fill(0);
    text("Press a to play lol",cosInter(1000,702,frames/frameRate),700+toBob);
    fill(255);
    text("Press a to play lol",cosInter(1000,700,frames/frameRate),700+toBob);
  }
}

void mousePressed(){
  if(canBeClicked){
    if(dist(mouseX,mouseY,200,570) < 100){
      weedManClicked = true;
      xStretch += 35;
      println("Clicked");
      sfx[0].play();
    }
  }
}

void mouseReleased(){
  weedManClicked = false;
}

void keyPressed(){
  if(key == 'a'){
    startIntro = false;
    showWeedMan = true;
    canBeClicked = false;
  }
}

float cosInter(float a, float b, float x) {
  float xProg = 0;
  if (x < 0) {
    xProg = 0;
  } else if (x >= 1) {
    xProg = 1;
  } else {
    xProg = 0.5-0.5*cos(x*PI);
  }
  return a+(b-a)*xProg;
}
