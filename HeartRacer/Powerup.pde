abstract class Powerup {
  float x, y, radius = 5,speed = 2;
  float vx = 0, vy= 1;
  Powerup(int _x, int _y)
  {
    x = _x;
    y = _y;
  }
  abstract void display();
  abstract void activate(Player p);
  void update()
  {
     x += (vx*speed);
     y += (vy*speed);
  }
}

