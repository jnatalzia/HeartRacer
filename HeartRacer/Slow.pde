class Slow extends Powerup {
  PImage img;
  Slow(int _x, int _y)
  {
    super(_x, _y);
    radius = 10;
    img = loadImage("clock.png");
  }
  void display()
  {
    update();
    fill(187, 140, 237);
    textSize(12);

    ellipse(x, y, radius*2, radius*2);
    fill(255, 255, 255);
    image(img,x-5,y-5,10,10);
  }
  void activate(Player p)
  {
    //p.radius -= 2;
    p.isSlowing = true;
    p.slowtimer = 0;
  }
}

