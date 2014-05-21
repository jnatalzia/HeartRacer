class Grow extends Powerup {
  Grow(int _x, int _y)
  {
    super(_x, _y);
    radius = 10;
  }
  void display()
  {
    update();
    fill(181, 38, 38);
    textSize(12);

    ellipse(x, y, radius*2, radius*2);
    fill(255, 255, 255);
    text("G", x-4, y+4);
  }
  void activate(Player p)
  {
    p.radius += 2;
  }
}

