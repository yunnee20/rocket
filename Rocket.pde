/*
this is a space rocket escape game, that the rocket will need to
fly without colliding with the stones
See how far you can get
*/

//colour palette
color yellow = color(255, 255, 0);
color orange = color(255, 100, 0);
color red = color(255, 0, 0);
color window = color(90, 180, 130);
color wing = color(0, 150, 205);

//Making Shapes
PShape cloud, c1, c2, c3, c4; //preset cloud shape
PShape rocket, rfire1, rfire2, rbody, rhead, rtip, rwindow,rengine, rwingR, rwingL; //preset rocket shape
PShape stone, sbody, hole1, hole2; //preset stone (obstacles)

//Initialize Variables
int rocketxpos, rocketypos; //rocket position
int score; //record score

float stonexpos = 450, stoneypos; //stone position
float stonerand;
float speed = 10;
float cloudxpos, cloudypos =-10, cloudrand; //Cloud position
float stonegap; //for spawning stones

PFont f; //for font

boolean spawnCloud, crandom, gameEnd, pause, stoneloop;

//making stone class for spawning
class Stoneclass{
  float stonexpos;
  float stoneypos;
  
  Stoneclass(){
  }
  
  //to show/spawn stone
  void display(){
     /*----create stone shape---*/
    stone = createShape(GROUP);
    //creating shapes
    fill(100);
    sbody = createShape(ELLIPSE, stonexpos, stoneypos, 100,100);
    fill(200);
    hole1 = createShape(ELLIPSE, stonexpos-20, stoneypos-3, 50, 55);
    hole2 = createShape(ELLIPSE, stonexpos+30, stoneypos+10, 30, 35);
    //assemble them into childs
    stone.addChild(sbody); stone.addChild(hole1); stone.addChild(hole2);
    /*--end of stone shape*/
    
    shape(stone); //draw the stone shape
    
  }
  //loop spawn
  boolean checkLoop(){ 
    if(stoneypos > height+30){ //check if stone is out of scene
      score ++;
      stoneypos = -10; //reset back up
      stoneloop = true;
    }
    
    if(stoneloop){ //if yes, then create a random number for new pos
      stonerand = random(0, width);
      stonexpos = stonerand;
      stoneloop = false; //stop random number generating
    }
    return false;
  }
  
  //check if collision happens
  boolean check(){
    if(rocketypos-stoneypos <=140 && stoneypos < rocketypos){
      if(rocketxpos > stonexpos && rocketxpos - stonexpos <=50){
        gameEnd = true;
      }else if(rocketxpos < stonexpos && stonexpos - rocketxpos <=50){
        gameEnd = true;
      }
    }
    return false;
  }
}

//create instance for stones
Stoneclass stone1 = new Stoneclass(); //1st stone
Stoneclass stone2 = new Stoneclass(); //2nd stone
Stoneclass stone3 = new Stoneclass(); //3rd stone
Stoneclass stone4 = new Stoneclass(); //4th stone

//Start Code Here
void setup(){
  noStroke();
  size(1200, 800); //window size
  /*preset first location of stones*/
  stone1.stonexpos = 120;
  stone2.stoneypos = -300; 
  stone2.stonexpos = 70;
  stone3.stoneypos = -180;
  stone3.stonexpos = 300;
  stone4.stoneypos = -500;
  stone4.stonexpos = 500;
  
  f = createFont("Arial Black", 120); //add font
}

void draw(){
  background(0, 200, 255);
  if(!pause){
    rocketxpos = mouseX; //set rocket follows cursor
    rocketypos = height-200; //y pos dont move
  }
  
  /*--create cloud shape--*/
  translate(0, 0, -1);
  fill(255);
  cloud = createShape(GROUP); //make all shapes into a group
  //creating shapes
  c1 = createShape(ELLIPSE, cloudxpos, cloudypos, 220, 200);
  c2 = createShape(ELLIPSE, cloudxpos -130, cloudypos+20, 160, 150);
  c3 = createShape(ELLIPSE, cloudxpos +130, cloudypos+30, 130, 120);
  c4 = createShape(ELLIPSE, cloudxpos -220, cloudypos+40, 100, 90);
  //assemble them into childs
  cloud.addChild(c1); cloud.addChild(c2); cloud.addChild(c3); cloud.addChild(c4);
  /*--end of cloud shape--*/
  pushMatrix();
  translate(0, cloudypos+=speed);
  
  //for clouds
  shape(cloud); //first cloud
  shape(cloud, cloudrand +10, -340); //second cloud
  if(cloudypos > height+60){ //when cloud is out of screen
    cloudypos = -10; //reset back up
    crandom = true; //to generate random number
    cloudxpos = cloudrand; //put the random number to xpos
  }
  
  if(crandom){ //to create a random number
    cloudrand= random(0, width);
    //stonegap = random(3, 500);
    crandom = false; //to only send once
  }
  popMatrix();
  
  /*--create rocket shape--*/
  rocket = createShape(GROUP); //make rocket group
  //creating shapes
  fill(yellow);
  rfire1 = createShape(ELLIPSE, rocketxpos, rocketypos+100, 45, 80);
  fill(orange);
  rfire2 = createShape(ELLIPSE, rocketxpos, rocketypos+100, 20, 50);
  fill(wing);
  rwingR = createShape(TRIANGLE, rocketxpos, rocketypos-40, rocketxpos-80, rocketypos+80, rocketxpos, rocketypos+60);
  rwingL = createShape(TRIANGLE, rocketxpos, rocketypos-40, rocketxpos+80, rocketypos+80, rocketxpos, rocketypos+60);
  fill(255);
  rbody = createShape(ELLIPSE, rocketxpos, rocketypos, 80, 180); //rocket body
  fill(red);
  rhead = createShape(ARC, rocketxpos, rocketypos-30, 80, 140, PI, TWO_PI, CHORD); //head
  rtip = createShape(TRIANGLE, rocketxpos, rocketypos-60-60, rocketxpos+30, rocketypos+30-107, rocketxpos-30, rocketypos+30-107);
  fill(window);
  rwindow = createShape(ELLIPSE, rocketxpos, rocketypos, 40, 40); //create window
  rectMode(CENTER);
  rengine = createShape(RECT, rocketxpos, rocketypos+80, 50, 20); //for the fire part

  //assemble them into childs
  rocket.addChild(rfire1); rocket.addChild(rfire2);
  rocket.addChild(rwingR);  rocket.addChild(rwingL);
  rocket.addChild(rbody); rocket.addChild(rhead); rocket.addChild(rtip); rocket.addChild(rwindow);
  rocket.addChild(rengine); 
  /*--end of rocket shape--*/
  //draw rocket
  shape(rocket);
  
  //spawning stones instance
  //stone1
  stone1.stoneypos+= speed;
  stone1.display(); //draw
  stone1.check(); //check if stone 1 collide
  stone1.checkLoop(); //check 
   
  //stone2
  stone2.stoneypos+=speed;
  stone2.display(); //draw
  stone2.check(); //check if stone 2 collide
  stone2.checkLoop();
 
  //stone3
  stone3.stoneypos+=speed;
  stone3.display(); //draw
  stone3.check(); //check if stone 3 collide
  stone3.checkLoop();
  
  //stone4
  stone4.stoneypos+=speed;
  stone4.display(); //draw
  stone4.check(); //check if stone 2 collide
  stone4.checkLoop();
  
  //show Game score
  textSize(30);
  textAlign(CENTER);
  fill(red);
  if(score >= 100){
  rect(1090, 40, 165, 80);
  }else{
    rect(1095, 40, 155, 80);
  }
  fill(255);
  textFont(f, 22);
  text("Score: "+score, width-105, 45); //display score
  
  //speedup based on score
  if(score == 20){
    speed = 12;
  }else if(score == 50){
    speed = 15;
  }else if(score ==80){
    speed = 18;
  }else if(score > 200){
    speed =21;
  }
  
 //check gameEnd, pause game 
 if(gameEnd){
    pause = true;
  }
  //when game end, stop the game, show Game Over
  if(pause){
    speed = 0;
    rectMode(CENTER);
    stroke(red);
    strokeWeight(10);
    fill(255);
    rect(width/2, height/2, 800, 280); //game over panel
    textFont(f, 100);
    textAlign(CENTER);
    fill(red);
    text("GAME OVER", width/2, height/2); //gameover text
    
    textFont(f, 30);
    textAlign(CENTER);
    fill(150);
    text("*Press Mouse To Play Again*", width/2, height/2+80);
    noStroke();
    
    //when press mouse to continue playing
    if(mousePressed){
      pause= false;
      speed = 10;
      stoneypos = 0;
      cloudypos = -10;
      gameEnd = false;
      score = 0;
    }
  }
}
