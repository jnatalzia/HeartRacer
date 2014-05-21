class Pulse
{
  int radius = 0;
  int lifespan = 1000;
  int alpha = 255;
  Player p;
 Pulse(Player play)
{
  p = play;
}
void display()
{
  fill(196,77,88,alpha);
  stroke(196,77,88,alpha);
  radius++;
  alpha -= 4;
  if (alpha <= 0)
  {
     alpha = 0;
    p.removePulse(this); 
  }
  strokeWeight(3);
  noFill();
  ellipse(p.x,p.y,radius*2,radius*2);
}
  
}
