class DripCanvas extends visual {
  drip[] drips = new drip[1000];
  color[] dripColor = new color[5];

  PVector startVel = new PVector(0, 10);

  int wi, he;

  float colorRange = 1;

  Button startRotButton;

  boolean clearReq = false;

  DripCanvas(String id, int x, int y, float s, float f) {
    super(id, x, y, s, f, true);
    this.wi = x;
    this.he = y;
    colorMode(HSB);
    for (int i = 0; i< dripColor.length; i++) {
      dripColor[i] = color(random(255), random(255), random(255), 180);
    }
    for (int i = 0; i< drips.length; i++) {
      drips[i] = new drip(50, dripColor[0], startVel);
      drips[i].alive = false;
    }
  }

  void rotateStart() {
    //clearReq = true;
    this.startVel.rotate(PI/4);
  }

  void feed(Boolean [] t) {
    if (random(50)>35) {
        for (int i = 0; i< dripColor.length; i++) {

          colorRange = random(1, 20);
          dripColor[i] = color(random(colorRange*12, colorRange*12+4), random(colorRange*5, colorRange*6+25), random(colorRange*7, colorRange*11+8));
        }
      }
    if (t[0]) {
      for (int i = 0; i< drips.length; i++) {
        if (drips[i].alive == false) {
          drips[i] = new drip(5, dripColor[0], startVel);
          break;
        }
      }
      
    }
    if (t[1]) {
      for (int i = 0; i< drips.length; i++) {
        if (drips[i].alive == false) {
          drips[i] = new drip(4, dripColor[1], startVel);
          break;
        }
      }
    }
    if (t[2]) {
      for (int i = 0; i< drips.length; i++) {
        if (drips[i].alive == false) {
          drips[i] = new drip(3, dripColor[2], startVel);
          break;
        }
      }
    }
    if (t[3]) {
      for (int i = 0; i< drips.length; i++) {
        if (drips[i].alive == false) {
          drips[i] = new drip(2, dripColor[3], startVel);
          break;
        }
      }
    }
    if (t[4]) {
      for (int i = 0; i< drips.length; i++) {
        if (drips[i].alive == false) {
          drips[i] = new drip(1, dripColor[4], startVel);
          break;
        }
      }
    }
  }
  void show() {
    if (clearReq) {
      background(0);
      clearReq=false;
      for (int i = 0; i< drips.length; i++) {
      if (drips[i] != null) {
        if (drips[i].alive) {
          drips[i].alive = false;
        }
      }
    }
    }
    for (int i = 0; i< drips.length; i++) {
      if (drips[i] != null) {
        if (drips[i].alive) {
          drips[i].show();
          drips[i].update();
        }
      }
    }
  }

  float[] getCamSettings() {
    float[] settings = new float[4];
    settings[0] = this.wi/2;
    settings[1] = this.he/2;
    settings[2] = 0;
    settings[3] = 500;
    return settings;
  }

  void addGui(ControlP5 cp5, int x, int y) {
    startRotButton = cp5.addButton("rotateStart")
      .setPosition(x, y)
      .setSize(20, 10)
      ;
  }

  void removeGui(ControlP5 cp5) {
    cp5.remove("rotateStart");
  }

  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(startRotButton)) {
      rotateStart();
    }
  }
}

class drip {
  boolean alive;
  PVector pos;
  float size;
  color c;
  PVector speed;

  drip(float size, color c, PVector speed) {
    this.alive = true;
    this.size = size;
    this.c = c;
    this.speed = speed.copy();
    if (this.speed.y > 0) {
      this.pos = new PVector(random(800), 0);
    } else if (this.speed.y < 0) {
      this.pos = new PVector(random(800), 600);
    } else {
      if (this.speed.x > 0) {
        this.pos = new PVector(0, random(600));
      } else {
        this.pos = new PVector(800, random(600));
      }
    }
  }

  void update() {
    if (this.alive) {
      if (this.speed.y > 0 && this.pos.y >= 600)  this.alive = false;
      if (this.speed.y < 0 && this.pos.y <= 0)  this.alive = false;
      if (this.speed.x > 0 && this.pos.x >= 800)  this.alive = false;
      if (this.speed.x < 0 && this.pos.x <= 0)  this.alive = false;
      this.pos.add(this.speed);
    }
  }

  void show() {
    noStroke();
    //stroke(255);
    fill(this.c);
    //ellipse(this.pos.x, this.pos.y, this.size, this.size);
    rect(this.pos.x, this.pos.y, this.size, this.size);
  }
}
