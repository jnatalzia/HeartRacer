class Shrink extends Powerup {
  Shrink(int _x, int _y)
  {
    super(_x, _y);
    radius = 10;
  }
  void display()
  {
    update();
    fill(187, 140, 237);
    textSize(12);

    ellipse(x, y, radius*2, radius*2);
    fill(255, 255, 255);
    text("S", x-4, y+4);
    //println(x+ ", "+y);
  }
  void activate(Player p)
  {
    if (p.radius >= 5) p.radius -= 2;
  }
}

