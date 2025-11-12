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
int toStretchY = 0;
boolean castleCanBeClicked = false;
PImage curImg;
boolean castleDestroyed = false;
boolean showCastle = true;
float idleS = 0;

PImage[] pyramidImgs;
int PYRAMID_SIZE = 400;
int PYRAMID_HIT_COUNT_LIM = 20;
int PYRAMID_IMG_COUNT = 4;
int pyramidHitCount = 0;
int thisSS = 0;
boolean pyramidClicked = false;
int toStretch2 = 0;
boolean pyramidCanBeClicked = false;
PImage curImg2;
boolean pyramidDestroyed = false;
boolean showPyramid = true;
boolean isPyramid = false;

int score = 0;
int scoreD = 0;

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
int m = 0;
PImage[] emotionImgs;
int EMOTION_IMG_COUNT = 4;
int uS = 0;

int frames = 0;

String[] sentences = {"Hi","Im Weed Man im gonna help you learn the ropes","Over there is the tower","You have to destroy that tower","'How?' you ask well with this very weapon","Your mouse should now be the sword","Try to click the castle!","See easy now do it again!","See how your score goes up as you click","Try clicking a few more times!","You broke the tower!","You should know what to do from here!","You did it!","You're score should be 30","You can use that to buy more weapons!","Click the shop icon!","There you have a hammer lets go to the next level!","Well you should know what to do"};
int sentenceIndex = 0;
String curSentence = sentences[0];
boolean nextSentece = false;

int boxW = 0;

String[] characs = {"Weed Man"};

boolean startIntro = true;
boolean startPlaying = false;
boolean startClicked = false;

PImage bg;

PImage logo;

String[] soundFileNames = {"squeak.mp3","date.mp3","shop.mp3","Anticipation.mp3"};

PImage sword;
float swordAnimProgress = 0;
PImage hammer;
boolean isHammer = true;
int weaponDmg = 10;

boolean showContinueBtn = true;

boolean drawShop = false;
PImage shopIcon;
PImage shopBg;
boolean bought = false;
String shopText = "Choose a weapon";

boolean showArrow = false;
PImage arrow;

PGraphics fade;
boolean showFade = false;
float fadeProgress = 0;
float fadeDuration = 2.0;
float fadeStartTime = 0;
int dragFade = 0;
boolean fadingOut = false;
boolean fadingIn = false;
float fadeHoldDuration = 2.0;
float fadeHoldStart = 0;

PImage loading;

boolean showDemoScreen = false;

PImage textBox;

PFont font2;

int curLevel = 1;

PImage grad;
int enlarge = 0;
boolean mouseOverLevel = false;
boolean castleLevClicked = false;
int enlarge2 = 0;
boolean mouseOverLevel2 = false;
boolean pyramidLevClicked = false;
boolean showSelect = false;
boolean locked = false;
PImage icoLev;

final int LEVEL_CASTLE = 1;
final int LEVEL_PYRAMID = 2;

boolean doneWithIntro = false;

PImage play;

String[] funFacts = {"did u know this game was made in a week","do u like the game?","subscribe to pixilfalls"};

String currentFact;

boolean canContinue = true;

int counter = 0;

boolean bossMode = false;

int scoreMult = 0;
boolean showUpgradesBtn = false;
PImage uIco;
boolean showUpgradesScreen = false;
int count = 0;

void setup(){
  castleImgs = new PImage[CASTLE_IMG_COUNT];
  pyramidImgs = new PImage[PYRAMID_IMG_COUNT];
  emotionImgs = new PImage[EMOTION_IMG_COUNT];
  play = loadImage("play.png");
  font = createFont("OpenSans-Cond.ttf",48);
  font2 = loadFont("Helvetica-96.vlw");
  weed = loadImage("WEEDMAN.png");
  bg = loadImage("bg.png");
  bg.resize(1500,1080);
  logo = loadImage("logo.png");
  sword = loadImage("items/sword.png");
  textBox = loadImage("box.png");
  grad = loadImage("grad.png");
  icoLev = loadImage("icolevel.png");
  sfx = new SoundFile[soundFileNames.length];
  for(int s = 0; s < soundFileNames.length; s++){
    sfx[s] = new SoundFile(this, soundFileNames[s]);
  }
  for(int i = 0; i < CASTLE_IMG_COUNT; i++){
    castleImgs[i] = loadImage("towers/castle/imgs/"+i+".png");
  }
  for(int i = 0; i < PYRAMID_IMG_COUNT; i++){
    pyramidImgs[i] = loadImage("towers/pyramid/"+i+".png");
  }
  for(int i = 0; i < SHOP_IMAGE_COUNT; i++){
    shopImgs[i] = loadImage("anims/shop/"+i+".png");
    shopImgs[i].resize(400,450);
  }
  for(int i = 0; i < EMOTION_IMG_COUNT; i++){
    emotionImgs[i] = loadImage("emotions/"+i+".png");
  }
  shopIcon = loadImage("shopico.png");
  shopBg = loadImage("aleey.jpg");
  hammer = loadImage("items/hammer.png");
  arrow = loadImage("arrow.png");
  loading = loadImage("hight.png");
  uIco = loadImage("upgrades.png");
  hammer.resize(100,100);
  shopBg.resize(1280,720);
  arrow.resize(100,100);
  fade = createGraphics(width,height);
  handleMusic();
  currentFact = funFacts[int(random(funFacts.length))];
  frameRate(9999);
  size(1280,720);
}

void draw(){
  background(SKY_COLOR);
  frames++;
  drawBackground();
  drawCastle();
  drawPyramid();
  drawLevelSelect();
  drawUpgradesScreen();
  drawShopKeeper();
  drawText();
  showIntro();
  drawSwordIntro();
  drawSword();
  drawHammer();
  drawPointer();
  drawIntroFade();
  if(drawShop){
    drawShop();
  }
  println("FPS: "+int(frameRate));
}

void drawCastle(){
  if(showCastle && curLevel == 1){
    switch(score){
      case 1:
        if(sentenceIndex < 7){
          sentenceIndex = 7;
          curSentence = sentences[sentenceIndex];
      }
      break;
      
      case 2:
        if(sentenceIndex < 8){
          sentenceIndex = 8;
          curSentence = sentences[sentenceIndex];
      }
      break;
      
      case 3:
        if(sentenceIndex < 9){
          sentenceIndex = 9;
          curSentence = sentences[sentenceIndex];
          showContinueBtn = false;
      }
      break;
      
      case 11:
        if(sentenceIndex < 11){
          sentenceIndex = 11;
          curSentence = sentences[sentenceIndex];
          showContinueBtn = false;
      }
      break;
      
      case 12:
        showWeedMan = false;
        break;
    }
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
      if(score >= weaponDmg+10){
        curImg = castleImgs[2];
      }
      if(score >= weaponDmg+20){
        curImg = castleImgs[3];
        castleDestroyed = true;
        if(!doneWithIntro){
          castleCanBeClicked = false;
          if(sentenceIndex <= 12){
            sentenceIndex = 12;
            curSentence = sentences[sentenceIndex];
          }
          showContinueBtn = true;
          showWeedMan = true;
        }
      }
    }
    if(sentenceIndex == 10){
      showContinueBtn = true;
    }
    if(sentenceIndex >= 15 && !bought){
      showArrow = true;
      showContinueBtn = false;
    }
    if(bought && sentenceIndex < 17){
      showArrow = false;
      score = 0;
      sentenceIndex = 16;
      curSentence = sentences[sentenceIndex];
      showContinueBtn = true;
    }
    if(sentenceIndex == 6 || sentenceIndex == 7){
      showContinueBtn = false;
    }else{
      showContinueBtn = true;
    }
    toStretch *= 0.9;
    toStretchY *= 0.9;
    idleS = sin(frameCount * 0.05) * 10;
    imageMode(CENTER);
    image(curImg,W_W/2,W_H/2,idleS+CASTLE_SIZE+toStretch,idleS-CASTLE_SIZE);
  }
}

void drawPyramid(){
  if(showPyramid && curLevel == 2){
    isPyramid = true;
    if(pyramidDestroyed){
      curImg2 = pyramidImgs[3];
    }else{
      curImg2 = pyramidImgs[0];
      if(score >= weaponDmg){
        curImg2 = pyramidImgs[1];
      }
      if(score >= weaponDmg+10){
        curImg2 = pyramidImgs[2];
      }
      if(score >= weaponDmg+20){
        curImg2 = pyramidImgs[3];
        pyramidDestroyed = true;
        showContinueBtn = false;
        showWeedMan = false;
      }
    }
    if(score >= 1 && curLevel == 2){
      showWeedMan = false;
      showContinueBtn = false;
    }
    toStretch2 *= 0.9;
    imageMode(CENTER);
    image(curImg2,W_W/2,W_H/2,PYRAMID_SIZE+toStretch2,PYRAMID_SIZE);
  }
}

void drawCastleBoss(){
  
}

void drawBackground(){
  textFont(font);
  noStroke();
  rectMode(CENTER);
  fill(50, 168, 82);
  rect(W_W/2,W_H+150,W_W,W_H);
  fill(0);
  scoreD *= 0.9;
  text("Score: "+score,22,100+scoreD);
  fill(255);
  text("Score: "+score,20,100+scoreD);
  image(shopIcon,1200,100,100,90);
}

void drawShopKeeper(){
  if(showWeedMan){
    float toBob = sin(frameCount * 0.05) * 6;
    image(weed,200,580+toBob,toBob+550,450);
  }
}

void drawText(){
  if(showWeedMan){
    textFont(font);
    textSize(40);
    textAlign(CENTER,CENTER);
    fill(0);
    float toBob = sin(frameCount * 0.05) * 6;
    text(characs[0],200,toBob+350);
    typewriteText(curSentence,1,600,670);
    if(keyPressed && key == ' ' && canContinue){
      if(!nextSentece){
        sentenceIndex = (sentenceIndex+1)%sentences.length;
        curSentence = sentences[sentenceIndex];
        nextSentece = true;
        counter = 0;
      }
    }else{
      nextSentece = false;
    }
    /*textFont(font);
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
    if(keyPressed && key == ' ' && canContinue){
      if(!nextSentece){
        sentenceIndex = (sentenceIndex+1)%sentences.length;
        curSentence = sentences[sentenceIndex];
        nextSentece = true;
      }
    }else{
      nextSentece = false;
    }*/
  }
  if(showContinueBtn && canContinue){
    textAlign(CENTER,CENTER);
    fill(0);
    text("Space to continue",1102,690);
    fill(255);
    text("Space to continue",1100,690);
  }
  if(sentenceIndex == 6 || sentenceIndex == 7 || sentenceIndex == 9 || sentenceIndex == 15 || sentenceIndex == 17){
    canContinue = false;
  }else{
    canContinue = true;
  }
  if(sentenceIndex == 11){
    canContinue = false;
  }
  textAlign(LEFT,CENTER);
}

void typewriteText(String t, int SPEED, int x, int y){
  if(frames%SPEED == 0 && counter < t.length()){
    counter++;
  }
  int endIndex = min(counter,t.length());
  fill(0);
  text(t.substring(0,endIndex),x+2,y,width,height);
  fill(255);
  text(t.substring(0,endIndex),x,y,width,height);
}

void showIntro(){
  if(startIntro && !startClicked){
    float toBob = sin(frameCount * 0.05) * 0.1;
    weedManStretch += 6;
    float toBob2 = 100*sin(radians(weedManStretch*-1.5))*0.1;
    float toBob3 = 40*sin(radians(weedManStretch*-1.5))*0.1;
    xStretch *= 0.9;
    image(bg,width/2,height/2);
    pushMatrix();
    translate(width/2,200);
    rotate(toBob);
    imageMode(CENTER);
    image(logo,0,0,350+toBob2,350+toBob2);
    popMatrix();
    image(play,width/2,500,300+xStretch,200+xStretch);
    if(dist(mouseX,mouseY,width/2,500) < 100){
      xStretch += 6;
    }
    textAlign(CENTER);
    textSize(50+toBob3-20);
    fill(0);
    text(currentFact,width/2+2,300);
    fill(255);
    text(currentFact,width/2,300);
  }
}

void mousePressed(){
  if(curLevel == LEVEL_CASTLE && castleCanBeClicked){
    if(dist(mouseX,mouseY,W_W/2,W_H/2) < 100){
       castleClicked = true;
       toStretch = 100-(toStretch/3);
       toStretchY = 100-(toStretchY/3);
       println("Clicked");
       sfx[0].play();
       hitCount += 1;
       score += 1+scoreMult;
       scoreD = 20-(scoreD/3);
    }
  }
  if(curLevel == LEVEL_PYRAMID && pyramidCanBeClicked){
    if(dist(mouseX,mouseY,W_W/2,W_H/2) < 100){
       pyramidClicked = true;
       toStretch2 = 100-(toStretch2/3);
       println("Clicked");
       sfx[0].play();
       hitCount += 1;
       score += 1+scoreMult;
       scoreD = 20-(scoreD/3);
       pyramidHitCount += 1;
    }
  }
  if(dist(mouseX,mouseY,1200,100) < 50){
    drawShop = true;
    drawShop();
    println("Clicked");
  }
  if(dist(mouseX,mouseY,1200,200) < 50){
    showSelect = true;
  }
  if(dist(mouseX,mouseY,207,222) < 50){
    showSelect = false;
    loadLevel(LEVEL_CASTLE);
  }
  if(dist(mouseX,mouseY,1200,300) < 50){
    showUpgradesScreen = true;
  }
  if(showUpgradesScreen && dist(mouseX,mouseY,width/2-400,height/2+100) < 100){
    uS = 100-(uS/3);
    count += 1;
  }
  if(dist(mouseX,mouseY,500,222) < 100){
    showSelect = false;
    loadLevel(LEVEL_PYRAMID);
  }
  if(dist(mouseX,mouseY,960,170) < 100 && score >= 30 && drawShop){
    println("bought!");
    bought = true;
    weaponDmg = weaponDmg+20;
  }else{
    println("gotta get more bud");
  }
  if(dist(mouseX,mouseY,width/2,500) < 100 && startIntro && !startClicked){
    startIntro = false;
    showWeedMan = true;
    canBeClicked = false;
    sfx[1].stop();
    sfx[3].play();
    sfx[3].loop();
    startClicked = true;
  }
}

void mouseReleased(){
  weedManClicked = false;
  castleClicked = false;
  pyramidClicked = false;
}

void keyPressed(){
  if(key == 'q' && drawShop){
    drawShop = false;
    sfx[2].stop();
  }
  if(key == ' ' && sentenceIndex == 16){
    loadLevel(LEVEL_PYRAMID);
    drawShop = false;
    doneWithIntro = true;
  }
  if(key == 'l'){
    showSelect = false;
  }
  if(key == 'q' && showUpgradesScreen){
    showUpgradesScreen = false;
  }
  if(key == 'q' && showSelect){
    showSelect = false;
  }
}

void drawSwordIntro(){
  // This is so stupid i had to find a whole other way to get this anim to work.
  if(sentenceIndex == 4){
    swordAnimProgress += 0.01;
    swordAnimProgress = constrain(swordAnimProgress,0,1);
    float x = cosInter(-1,500,swordAnimProgress);
    thisS = 100-(thisS/3);
    float toBob = sin(frameCount * 0.05) * 6;
    image(sword,900,x,200+toBob,200+toBob);
  }else{
    swordAnimProgress = 0;
  }
}

void drawSword(){
  if(!bought && sentenceIndex >= 5 && score < CASTLE_HIT_COUNT_LIM+20){
    image(sword,mouseX,mouseY,200,200);
    castleCanBeClicked = true;
    if(sentenceIndex == 8){
      castleCanBeClicked = false;
     }else{
      castleCanBeClicked = true;
    }
  }
}

void drawShop(){
  if(drawShop){
    float toBob = sin(frameCount * 0.05) * 0.1;
    image(shopBg,width/2,height/2);
    fill(0,110);
    rect(1500,300,1280,1000000);
    int currentIndex = (frames/SPEED)%SHOP_IMAGE_COUNT;
    imageMode(CENTER);
    image(shopImgs[currentIndex],300,500);
    fill(0);
    text("Money: "+score+"$",22,100);
    fill(255);
    text("Money: "+score+"$",20,100);
    fill(0);
    text("Hammer 30$",902,250);
    fill(255);
    text("Hammer 30$",900,250);
    image(hammer,960,170);
    pushMatrix();
    fill(255);
    translate(1052,40);
    rotate(toBob);
    textAlign(CENTER,CENTER);
    text(shopText,0,0);
    translate(1050,40);
    rotate(toBob);
    textAlign(CENTER,CENTER);
    text(shopText,0,0);
    popMatrix();
    if(dist(mouseX,mouseY,960,170) < 100){
      shopText = "Hammer";
    }else{
      shopText = "Choose a weapon";
    }
    fill(0);
    text("(q to get out btw)",402,20);
    fill(255);
    text("(q to get out btw)",400,40);
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
    float toBob = sin(frameCount * 0.1) * 6;
    image(arrow,1200,200+toBob);
  }
}

void drawIntroFade(){
  fade.beginDraw();
  fade.background(255,cosInter(255,0,frames/frameRate));
  fade.endDraw();
  image(fade,width/2,height/2);
}

void startFade(){
  fadeStartTime = millis()/1000.0;
  fadeProgress = 0;
  showFade = true;
  fadingOut = true;
  fadingIn = false;
  fadeHoldStart = 0;
  dragFade = 0;
}

void handleMusic(){
  if(startIntro){
    sfx[1].play();
    sfx[1].loop();
  }else{
    sfx[1].stop();
  }
  if(drawShop){
    if(!sfx[2].isPlaying()){
      sfx[2].play();
    }else{
      sfx[2].stop();
    }
  }
}

void drawDemoScreen(){
  if(showDemoScreen){
    background(0);
    fill(255);
    textAlign(CENTER);
    text("Sorry this is the end of the demo TwT",width/2,height/2);
    sfx[3].stop();
  }
}

void handleLevels(){
  if(curLevel != 1){
    showCastle = false;
    showWeedMan = false;
  }
}

void drawLevelSelect(){
  if(!startIntro){
    image(icoLev,1200,200,100,90);
    image(icoLev,1200,200,100,100);
  }
  if(showSelect){
    strokeWeight(4);
    fill(138, 91, 22);
    stroke(0);
    rect(width/2,height/2,1138,707);
    image(grad,207,222,212+enlarge,260+enlarge);
    image(castleImgs[0],207,222,212+enlarge,233+enlarge);
    image(grad,500,222,212+enlarge2,260+enlarge2);
    image(pyramidImgs[0],500,222,212+enlarge2,233+enlarge2);
    enlarge *= 0.9;
    enlarge2 *= 0.9;
    if(dist(mouseX,mouseY,207,222) < 100){
      enlarge += 6;
      mouseOverLevel = true;
    }else{
      mouseOverLevel = false;
    }
    if(dist(mouseX,mouseY,500,222) < 100){
      enlarge2 += 6;
      mouseOverLevel2 = true;
    }else{
      mouseOverLevel2 = false;
    }
    fill(0);
    text("Castle",162,400+enlarge);
    fill(255);
    text("Castle",160,400+enlarge);
    
    fill(0);
    text("Pyramid",442,400+enlarge2);
    fill(255);
    text("Pyramid",440,400+enlarge2);
    fill(0);
    
    text("Level Select",width/2,60);
    fill(255);
    text("Level Select",width/2,60);
  }
}

void loadLevel(int level){
  curLevel = level;
  score = 0;
  hitCount = 0;
  pyramidHitCount = 0;
  castleDestroyed = false;
  pyramidDestroyed = false;
  if(level == LEVEL_CASTLE){
    castleCanBeClicked = true;
    pyramidCanBeClicked = false;
  }else if(level == LEVEL_PYRAMID){
    castleCanBeClicked = false;
    pyramidCanBeClicked = bought;
  }
}

void drawUpgradesScreen(){
  curImg = emotionImgs[0];
  uS *= 0.9;
  int theY = height/2+100;
  float idleS = sin(frameCount * 0.05) * 6;
  if(curLevel == LEVEL_PYRAMID){
    showUpgradesBtn = true;
  }
  if(showUpgradesBtn){
    image(uIco,1200,300,100,90);
  }
  if(showUpgradesScreen){
    if(count >= 1){
      curImg = emotionImgs[1];
    }
    if(count >= 2){
      curImg = emotionImgs[2];
    }
    if(count >= 3){
      curImg = emotionImgs[3];
    }
    String t = "Upgrades";
    image(curImg,width/2-400,theY,uS-500+idleS,uS+530-idleS);
    float toBob = sin(frameCount * 0.05) * 0.1;
    fill(0,110);
    rect(1200,300,1400,1000000);
    imageMode(CENTER);
    pushMatrix();
    fill(255);
    translate(width/2+300,40);
    rotate(toBob);
    textAlign(CENTER,CENTER);
    text(t,0,0);
    translate(1050,40);
    rotate(toBob);
    textAlign(CENTER,CENTER);
    text(t,0,0);
    popMatrix();
    if(dist(mouseX,mouseY,960,170) < 100){
      t = "Hammer";
    }else{
      t = "Upgrades";
    }
    textAlign(CENTER,CENTER);
    fill(0);
    text("(q to get out btw)",402,40);
    fill(255);
    text("(q to get out btw)",400,40);
  }
  textAlign(BASELINE);
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
