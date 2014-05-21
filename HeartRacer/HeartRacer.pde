import processing.serial.*;
//constants
final int STATE_PLAYING = 0;
final int STATE_MENU = 1;
final int STATE_PAUSED = 2;
final int STATE_GAME_OVER = 3;
//properties
PFont rLight;

PImage menuIMG;

//heartrate stuffs
Serial port;
int Sensor;      // HOLDS PULSE SENSOR DATA FROM ARDUINO
int IBI;         // HOLDS TIME BETWEN HEARTBEATS FROM ARDUINO
int BPM = 58;         // HOLDS HEART RATE VALUE FROM ARDUINO
boolean beat = false;

int speedAddition = 0;

int SIZE_WIDTH = 800, SIZE_HEIGHT = 600;

Player player;

ArrayList<Obstacle> obstacles;
ArrayList<Powerup> powerups;

int[] obstacleChance;

int gameState = 1;
int score = 0;

//images
boolean serialAttached = false;

void setup()
{
  rLight = loadFont("Roboto-Light.vlw");
  textFont(rLight);
  noCursor();
  size(SIZE_WIDTH, SIZE_HEIGHT);
  player = new Player();
  obstacles = new ArrayList<Obstacle>();

  //obstacles.add(new Obstacle(200, 200));
  powerups = new ArrayList<Powerup>();
  obstacleChance = new int[4];
  obstacleChance[0] = 20;
  obstacleChance[1] = 30;
  obstacleChance[2] = 40;

  menuIMG = loadImage("splash.png");

  //println(test.x);
  if (serialAttached) serialSetup();
}
void serialSetup()
{
  println(Serial.list());    // print a list of available serial ports
  // choose the number between the [] that is connected to the Arduino
  port = new Serial(this, Serial.list()[5], 115200);  // make sure Arduino is talking serial at this baud rate
  port.clear();            // flush buffer
  port.bufferUntil('\n');  // set buffer full flag on receipt of carriage return
}
void draw()
{ 
  clear();
  strokeWeight(0);
  //fill(85, 98, 112);
  if (!player.isSlowing) fill(51, 51, 51);
  else fill(150, 150, 150);
  rect(0, 0, SIZE_WIDTH, SIZE_HEIGHT);

  if (gameState == STATE_PLAYING)
  {
    playingDraw();
  }
  else if (gameState == STATE_MENU)
  {
    menuDraw();
  }
  else if (gameState == STATE_GAME_OVER)
  {
    gameOverDraw();
  }
}
void menuDraw()
{
  fill(255, 255, 255);
  textSize(50);

  image(menuIMG, 0, 0);
  if (beat)
  {
    player.addPulse(); 
    beat = false;
  }
  player.display();
  //text("Heart-Race", SIZE_WIDTH/2-130, SIZE_HEIGHT/2 - 125);
}
void gameOverDraw()
{
  float rand = random(0, 100);

  //int index = 1500/score;
  /*int chance = 25;
   if (rand < chance)
   {
   int xPos = (int)random(0, SIZE_WIDTH);
   int yPos= -10;
   
   obstacles.add(new Obstacle(xPos, yPos));
   }*/
  for (int i = obstacles.size()-1;i >=0; i--)
  {
    Obstacle o = obstacles.get(i);

    o.alpha -= 5;

    o.speed = 2/(60.0/BPM)+ speedAddition;

    if (player.isSlowing)
      o.display(true);
    else
      o.display();

    //test for offscreen
    if (o.x < 0 || o.alpha <= 0)
      obstacles.remove(o);
  }

  player.display();
  drawUI();
}
void playingDraw()
{
  score++;
  float rand = random(0, 100);
  float chance = 20.0 * (BPM/60.0) * score/1000.0;
  
  //println(chance);
  
  if (chance > 75) chance = 75;
  
  //println(chance);
  if (rand < chance)
  {
    int xPos = (int)random(0, SIZE_WIDTH*2);
    int yPos;
    if (xPos < SIZE_WIDTH) yPos = -20;
    else yPos = (int)random(0, SIZE_HEIGHT);

    obstacles.add(new Obstacle(xPos, yPos));
  }

  rand = random(0, 2000);
  int xPos = (int)random(0, SIZE_WIDTH);
  int yPos = -10;

  if (rand < 10)
    powerups.add(new Shrink(xPos, yPos));
  else if (rand > 10 && rand < 15)
    powerups.add(new Slow(xPos, yPos));
  else if (rand > 15 && rand < 25)
    powerups.add(new Grow(xPos, yPos));


  if (beat)
  {
    player.addPulse(); 
    beat = false;
  }
  player.display();


 if (score % 1000 == 0)
    {
       speedAddition += 1; 
       if (speedAddition > 4) speedAddition = 4;
    }
  //speedAddition
  for (int i = obstacles.size()-1;i >=0; i--)
  {
    Obstacle o = obstacles.get(i);

    //collision test
    if (circlesIntersect(player.x, player.y, player.radius, o.x, o.y, o.radius))
    {
      player.die();
      obstacles.remove(o);
      gameState = STATE_GAME_OVER;
      break;
    }

    o.speed = 2/(60.0/BPM) + speedAddition;
    //o.speed += 

    //println((float)60/BPM);

    if (player.isSlowing)
      o.display(true);
    else
      o.display();

    //test for offscreen
    if (o.x < 0)
      obstacles.remove(o);
  }
  for (int i = powerups.size()-1;i >=0; i--)
  {
    Powerup p = powerups.get(i);
    //println("firing");
    //p.display();

    if (circlesIntersect(player.x, player.y, player.radius, p.x, p.y, p.radius))
    {
      p.activate(player);
      powerups.remove(p);
    }

    p.display();

    if (p.x < 0)
      powerups.remove(p);
  }

  drawUI();
}
void mouseClicked()
{
  //player.addPulse();
  if (gameState == STATE_MENU)
    gameState = STATE_PLAYING;
  else if (gameState == STATE_GAME_OVER)
  {
    player = new Player();
    gameState = STATE_PLAYING;
    score = 0;
    obstacles.clear();
    powerups.clear();
  }
}
void drawUI()
{
  fill(255, 107, 107);
  textSize(40);
  textAlign(RIGHT);
  text(BPM, 790, 40);
  textSize(24);
  textAlign(LEFT);
  text(score, 10, 30);
  if (gameState == STATE_GAME_OVER)
  {
    fill(255, 255, 255);
    textSize(50);
    textAlign(CENTER);
    text("Game Over", SIZE_WIDTH/2, SIZE_HEIGHT/2 - 50); 
    textSize(35);
    text("Your final score: " + score, SIZE_WIDTH/2, SIZE_HEIGHT/2);
    textSize(16);
    text("(click anywhere to play again)", SIZE_WIDTH/2, SIZE_HEIGHT/2+40);
  }
}
boolean circlesIntersect(float x1, float y1, float r1, float x2, float y2, float r2)
{
  return dist(x1, y1, x2, y2) < r1 + r2;
}

