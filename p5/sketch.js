let W_W = 1280;
let W_H = 720;

let SKY_COLOR;

let castleImgs = [];
let CASTLE_SIZE = 400;
let hitCount = 0;
let CASTLE_HIT_COUNT_LIM = 10;
let CASTLE_IMG_COUNT = 4;
let thisS = 0;
let castleClicked = false;
let toStretch = 0;
let castleCanBeClicked = false;
let curImg;
let castleDestroyed = false;

let score = 0;

let font;

let weed;
let weedManStretch = 0;
let showWeedMan = false;
let weedManClicked = false;
let canBeClicked = true;
let xStretch = 0;
let SHOP_IMAGE_COUNT = 4;
let shopImgs = [];
let SPEED = 3; // higher = slower

let frames = 0;

let sentences = ["Hi","Im Weed Man im gonna help you learn the ropes","Over there is the tower","You have to destroy that tower","'How?' you ask well with this very weapon","Your mouse should now be the sword","Try to click the castle!","See easy now do it again!","See how your score goes up as you click","Try clicking a few more times!","You broke the tower!","You should know what to do from here!","You did it!","You're score should be 30","You can use that to buy more weapons!","Click the shop icon!","There you have a hammer lets go to the next level!"];
let sentenceIndex = 0;
let curSentence = sentences[0];
let nextSentece = false;

let boxW = 0;

let characs = ["Weed Man"];

let startIntro = true;
let startPlaying = false;

let bg;

let logo;

let soundFileNames = ["squeak.mp3"];
let sfx = [];

let sword;
let swordAnimProgress = 0;

let showContinueBtn = true;

let showShop = false;
let shopIcon;
let shopBg;
let bought = false;

let showArrow = false;
let arrow;

let hammer;
let isHammer = true;

function preload(){
  font = loadFont('OpenSans-Cond.ttf');
  weed = loadImage("WEEDMAN.png");
  bg = loadImage("bg.png");
  logo = loadImage("logo.png");
  sword = loadImage("items/sword.png");
  shopIcon = loadImage("shopico.png");
  shopBg = loadImage("aleey.jpg");
  hammer = loadImage("items/hammer.png");
  arrow = loadImage("arrow.png");

  for(let i = 0; i < CASTLE_IMG_COUNT; i++){
    castleImgs[i] = loadImage("towers/castle/imgs/"+i+".png");
  }

  for(let i = 0; i < SHOP_IMAGE_COUNT; i++){
    shopImgs[i] = loadImage("anims/shop/"+i+".png");
  }

  for(let s = 0; s < soundFileNames.length; s++){
    sfx[s] = loadSound(soundFileNames[s]);
  }
}

function setup(){
  createCanvas(W_W,W_H);
  SKY_COLOR = color(132, 178, 250);

  textFont(font || 'Arial', 48);
  
  bg.resize(W_W,W_H);
  shopBg.resize(W_W,W_H);
  hammer.resize(100,100);
  arrow.resize(100,100);

  for(let i = 0; i < SHOP_IMAGE_COUNT; i++){
    shopImgs[i].resize(400,450);
  }
}

function draw(){
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
  if(showShop){
    drawShop();
  }
  console.log("FPS: "+int(frameRate()));
}

function drawCastle(){
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

function drawBackground(){
  textFont(font || 'Arial',48);
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

function drawShopKeeper(){
  if(showWeedMan){
    weedManStretch += 6;
    let toBob = 100*sin(radians(weedManStretch*-1.5))*0.1;
    image(weed,200,580+toBob,550+toBob,450);
  }
}

function drawText(){
  if(showWeedMan){
    textFont(font || 'Arial',48);
    fill(0);
  
    let boxX = 530;
    let boxY = 670;
    let MARGIN = 40;
  
    let textW = textWidth(curSentence);
    boxW = int(textW+MARGIN*2);
  
    rectMode(CENTER);
    fill(0);
    rect(boxX,boxY,boxW,100);
  
    fill(255);
    textAlign(LEFT,CENTER);
    text(characs[0],boxX-boxW/2+20+MARGIN,boxY-70);
    text(curSentence,boxX-boxW/2+MARGIN,boxY-5);
    if(keyIsPressed && key === ' '){
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

function showIntro(){
  if(startIntro){
    if(bg) imageMode(CORNER);
            image(bg, 0, 0, width, height);
    weedManStretch += 6;
    let toBob = 100*sin(radians(weedManStretch*-1.5))*0.1;
    let goTo = cosInter(1000,570,frames/frameRate());
    image(weed,200,goTo+toBob,550+toBob+xStretch,450);
    xStretch *= 0.9;
    image(logo,800,cosInter(0,200,frames/frameRate()),350+toBob,350+toBob);
    fill(0);
    text("Press a to play lol",cosInter(1000,702,frames/frameRate()),700+toBob);
    fill(255);
    text("Press a to play lol",cosInter(1000,700,frames/frameRate()),700+toBob);
  }
}

function mousePressed(){
  if(canBeClicked){
    if(dist(mouseX,mouseY,200,570) < 100){
      weedManClicked = true;
      xStretch += 35;
      console.log("Clicked");
      if(sfx[0]) sfx[0].play();
    }
  }
  if(castleCanBeClicked){
    if(dist(mouseX,mouseY,W_W/2,W_H/2) < 100){
       castleClicked = true;
       toStretch += 35;
       console.log("Clicked");
       if(sfx[0]) sfx[0].play();
       hitCount += 1;
       score += 1;
    }
  }
  if(dist(mouseX,mouseY,1200,100) < 100){
    showShop = true;
    console.log("Clicked");
  }
  if(dist(mouseX,mouseY,960,170) < 100 && score >= 30){
    console.log("bought!");
    bought = true;
  }else{
    console.log("gotta get more bud");
  }
}

function mouseReleased(){
  weedManClicked = false;
  castleClicked = false;
}

function keyPressed(){
  if(key === 'a'){
    startIntro = false;
    showWeedMan = true;
    canBeClicked = false;
  }
  if(key === 'q'){
    showShop = false;
  }
}

function drawSwordIntro(){
  if(sentenceIndex === 4){
    swordAnimProgress += 0.01;
    swordAnimProgress = constrain(swordAnimProgress,0,1);
    let x = cosInter(-1,500,swordAnimProgress);
    thisS += 6;
    let toBob = 100*sin(radians(thisS*-1.5))*0.1;
    image(sword,900,x,200+toBob,200+toBob);
  }else{
    swordAnimProgress = 0;
  }
}

function drawSword(){
  if(!bought && sentenceIndex >= 5 && score < CASTLE_HIT_COUNT_LIM+20){
    image(sword,mouseX,mouseY,200,200);
    castleCanBeClicked = true;
  }else{
    castleCanBeClicked = false;
  }
}

function drawShop(){
  if(showShop){
    image(shopBg,width/2,height/2);
    let currentIndex = floor(frames/SPEED)%SHOP_IMAGE_COUNT;
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

function drawHammer(){
  if(bought){
    isHammer = true;
    image(hammer,mouseX,mouseY);
  }
}

function drawPointer(){
  if(showArrow){
    weedManStretch += 6;
    let toBob = 100*sin(radians(weedManStretch*-1.5))*0.1;
    image(arrow,1200,200+toBob);
  }
}

function cosInter(a,b,x) {
  let xProg = 0;
  if (x < 0) {
    xProg = 0;
  } else if (x >= 1) {
    xProg = 1;
  } else {
    xProg = 0.5-0.5*cos(x*PI);
  }
  return a+(b-a)*xProg;
}
