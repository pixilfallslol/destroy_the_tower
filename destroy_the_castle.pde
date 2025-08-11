import processing.sound.*;

SoundFile[] sfx;

int W_W = 1280;
int W_H = 720;

color SKY_COLOR = color(132, 178, 250);

PImage[] castleImgs;
int CASTLE_SIZE = 400;
int hitCount = 0;
int CASTLE_HIT_COUNT_LIM = 10;
int CASTLE_IMG_COUNT = 4;
int thisS = 0;
boolean castleClicked = false;
int toStretch = 0;
boolean castleCanBeClicked = false;
PImage curImg;
boolean castleDestroyed = false;

int score = 0;

PFont font;

PImage weed;
float weedManStretch = 0;
boolean showWeedMan = false;
boolean weedManClicked = false;
boolean canBeClicked = true;
int xStretch = 0;
int SHOP_IMAGE_COUNT = 4;
PImage[] shopImgs = new PImage[SHOP_IMAGE_COUNT];
int SPEED = 3; // higher = slower

int frames = 0;

String[] sentences = {"Hi","Im Weed Man im gonna help you learn the ropes","Over there is the tower","You have to destroy that tower","'How?' you ask well with this very weapon","Your mouse should now be the sword","Try to click the castle!","See easy now do it again!","See how your score goes up as you click","Try clicking a few more times!","You broke the tower!","You should know what to do from here!","You did it!","You're score should be 30","You can use that to buy more weapons!","Click the shop icon!","There you have a hammer lets go to the next level!"};
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

PImage sword;
float swordAnimProgress = 0;

boolean showContinueBtn = true;

boolean drawShop = false;
PImage shopIcon;
PImage shopBg;
boolean bought = false;

boolean showArrow = false;
PImage arrow;

PImage hammer;
boolean isHammer = true;

void setup(){
  castleImgs = new PImage[CASTLE_IMG_COUNT];
  font = createFont("OpenSans-Cond.ttf",48);
  weed = loadImage("WEEDMAN.png");
  bg = loadImage("bg.png");
  bg.resize(1280,720);
  logo = loadImage("logo.png");
  sword = loadImage("items/sword.png");
  sfx = new SoundFile[soundFileNames.length];
  for(int s = 0; s < soundFileNames.length; s++){
    sfx[s] = new SoundFile(this, soundFileNames[s]);
  }
  for(int i = 0; i < CASTLE_IMG_COUNT; i++){
    castleImgs[i] = loadImage("towers/castle/imgs/"+i+".png");
  }
  for(int i = 0; i < SHOP_IMAGE_COUNT; i++){
    shopImgs[i] = loadImage("anims/shop/"+i+".png");
    shopImgs[i].resize(400,450);
  }
  shopIcon = loadImage("shopico.png");
  shopBg = loadImage("aleey.jpg");
  hammer = loadImage("items/hammer.png");
  arrow = loadImage("arrow.png");
  hammer.resize(100,100);
  shopBg.resize(1280,720);
  arrow.resize(100,100);
  frameRate(60);
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
  drawSwordIntro();
  drawSword();
  drawHammer();
  drawPointer();
  if(drawShop){
    drawShop();
  }
  /*fill(255,0,0,cosInter(0,255,frames/frameRate));
  rect(width/2,height/2,50,50);*/
  println("FPS: "+int(frameRate));
}

void drawCastle(){
  if(castleDestroyed){
    curImg = castleImgs[3];
  }else{
    curImg = castleImgs[0];
    if(score >= CASTLE_HIT_COUNT_LIM){
      curImg = castleImgs[1];
      if(sentenceIndex < 10){
        sentenceIndex = 10;
        curSentence = sentences[sentenceIndex];
      }
    }
    if(score >= CASTLE_HIT_COUNT_LIM+10){
      curImg = castleImgs[2];
    }
    if(score >= CASTLE_HIT_COUNT_LIM+20){
      curImg = castleImgs[3];
      castleDestroyed = true;
      castleCanBeClicked = false;
      if(sentenceIndex <= 12){
        sentenceIndex = 12;
        curSentence = sentences[sentenceIndex];
      }
      showContinueBtn = true;
      showWeedMan = true;
    }
  }
  if(score == 1){
    if(sentenceIndex < 7){
      sentenceIndex = 7;
      curSentence = sentences[sentenceIndex];
    }
  }
  if(score == 2){
    if(sentenceIndex < 8){
      sentenceIndex = 8;
      curSentence = sentences[sentenceIndex];
    }
  }
  if(score == 3){
    if(sentenceIndex < 9){
      sentenceIndex = 9;
      curSentence = sentences[sentenceIndex];
      showContinueBtn = false;
    }
  }
  if(sentenceIndex == 10){
    showContinueBtn = true;
  }
  if(score == 11){
    if(sentenceIndex < 11){
      sentenceIndex = 11;
      curSentence = sentences[sentenceIndex];
      showContinueBtn = false;
    }
  }
  if(score == 12){
    showWeedMan = false;
  }
  if(sentenceIndex >= 15){
    showArrow = true;
    showContinueBtn = false;
  }
  if(bought){
    showArrow = false;
    score = 0;
    sentenceIndex = 16;
    curSentence = sentences[sentenceIndex];
    showContinueBtn = true;
  }
  toStretch *= 0.9;
  imageMode(CENTER);
  image(curImg,W_W/2,W_H/2,CASTLE_SIZE+toStretch,CASTLE_SIZE);
}

void drawBackground(){
  textFont(font);
  noStroke();
  rectMode(CENTER);
  fill(50, 168, 82);
  rect(W_W/2,W_H+150,W_W,W_H);
  fill(0);
  text("Score: "+score,22,100);
  fill(255);
  text("Score: "+score,20,100);
  image(shopIcon,1200,100,100,90);
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
  if(showContinueBtn){
    fill(0);
    text("Space to continue",1002,670);
    fill(255);
    text("Space to continue",1000,670);
  }
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
  if(castleCanBeClicked){
    if(dist(mouseX,mouseY,W_W/2,W_H/2) < 100){
       castleClicked = true;
       toStretch += 35;
       println("Clicked");
       sfx[0].play();
       hitCount += 1;
       score += 1;
    }
  }
  if(dist(mouseX,mouseY,1200,100) < 100){
    drawShop = true;
    drawShop();
    println("Clicked");
  }
  if(dist(mouseX,mouseY,960,170) < 100 && score >= 30){
    println("bought!");
    bought = true;
  }else{
    println("gotta get more bud");
  }
}

void mouseReleased(){
  weedManClicked = false;
  castleClicked = false;
}

void keyPressed(){
  if(key == 'a'){
    startIntro = false;
    showWeedMan = true;
    canBeClicked = false;
  }
  if(key == 'q'){
    drawShop = false;
  }
}

void drawSwordIntro(){
  // This is so stupid i had to find a whole other way to get this anim to work.
  if(sentenceIndex == 4){
    swordAnimProgress += 0.01;
    swordAnimProgress = constrain(swordAnimProgress,0,1);
    float x = cosInter(-1,500,swordAnimProgress);
    thisS += 6;
    float toBob = 100*sin(radians(thisS*-1.5))*0.1;
    image(sword,900,x,200+toBob,200+toBob);
  }else{
    swordAnimProgress = 0;
  }
}

void drawSword(){
  if(!bought && sentenceIndex >= 5 && score < CASTLE_HIT_COUNT_LIM+20){
    image(sword,mouseX,mouseY,200,200);
    castleCanBeClicked = true;
  }else{
    castleCanBeClicked = false;
  }
}

void drawShop(){
  if(drawShop){
    image(shopBg,width/2,height/2);
    int currentIndex = (frames/SPEED)%SHOP_IMAGE_COUNT;
    imageMode(CENTER);
    image(shopImgs[currentIndex],300,500);
    fill(0);
    text("Score: "+score,22,100);
    fill(255);
    text("Score: "+score,20,100);
    fill(0);
    text("Hammer",902,250);
    fill(255);
    text("Hammer",900,250);
    image(hammer,960,170);
  }
}

void drawHammer(){
  if(bought){
    isHammer = true;
    image(hammer,mouseX,mouseY);
  }
}

void drawPointer(){
  if(showArrow){
    weedManStretch += 6;
    float toBob = 100*sin(radians(weedManStretch*-1.5))*0.1;
    image(arrow,1200,200+toBob);
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
