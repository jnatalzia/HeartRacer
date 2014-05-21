class Obstacle
{
  float radius = 5;
  float vx, vy;
  float x, y;
  float speed;
  float heartrate;
  int alpha = 255;
  Obstacle(int _x, int _y)
  {
    radius = (int)random(6, 10);

    x = _x;
    y = _y;

    vx=0;
    vy=1;
    speed = 2;
  }
  void display()
  {
    x += (vx*speed);
    y += (vy*speed);


    fill(255, 255, 255, alpha);
    noStroke();
    ellipse(x, y, radius*2, radius*2);
  }
  void display(boolean slowed)
  {
    if (slowed)
    {
      x += (vx*(speed/2));
      y += (vy*(speed/2));
    }
    else
    {
      x += (vx*speed);
      y += (vy*speed);
    }

    fill(255, 255, 255);
    noStroke();
    ellipse(x, y, radius*2, radius*2);
  }
}

