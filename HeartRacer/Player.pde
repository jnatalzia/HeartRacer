class Player {
  float radius = 10;
  ArrayList<Pulse> pulses;
  float x, y;
  int alpha=255;
  boolean isDead = false, isSlowing = false;
  int slowtimer = -1, slowtime = 250;
  int deadRadius = 50;
  PVector[] trail = new PVector[50];

  Player() {
    pulses = new ArrayList<Pulse>();

    //initialize trail array
    for (int i =0; i < trail.length;i++)
    {
      trail[i] = new PVector(mouseX, mouseY);
    }
  }
  void display()
  {
    if (isDead)
    {
      radius+=.5;
      alpha-=10;
      if (radius >= deadRadius)
      {
        radius = deadRadius;
      }
      fill(247, 196, 77, alpha);
      noStroke();
      ellipse(x, y, radius*2, radius*2);
      return;
    }
    if (slowtimer != -1)
    {
      slowtimer++;
      if (slowtimer > slowtime)
      {
        slowtimer = -1;
        isSlowing = false;
      }
    }

    x = mouseX;
    y = mouseY;

    for (int i = pulses.size()-1; i >=0; i--)
    {
      Pulse p = pulses.get(i);
      p.display();
    }

    fill(78, 205, 196);
    noStroke();
    ellipse(x, y, radius*2, radius*2);
  }
  void addPulse()
  {
    pulses.add(new Pulse(this));
  }
  void removePulse(Pulse p)
  {
    //remove pulse 
    pulses.remove(p);
    //println(pulses.size());
  }
  void die()
  {
    isDead=true;
    deadRadius = (int)radius+100;
    isSlowing = false;
  }
}

