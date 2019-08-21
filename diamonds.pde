class diamondField extends visual {
  int boxAmount = 50;
  boxes[] bs = new boxes[boxAmount];
  float rotation = 0;
  Boolean doesRotate = false;

  float zoomScale;
  Boolean zoomTrigger = false;
  Boolean doesZoom = true;

  Toggle rot1, zoom1;

  diamondField(String id, int x, int y, float s, float f, Boolean r, Boolean z) {
    super(id, x, y, s, f, false); 
    generate();
    this.doesRotate = r;
    this.doesZoom = z;
  }

  void addGui(ControlP5 cp5, int x, int y) {
    rot1 = cp5.addToggle("rotateT")
      .setPosition(x, y)
      .setSize(20, 10)
      .setValue(this.doesRotate);
    ;
    zoom1 = cp5.addToggle("zoomT")
      .setPosition(x, y + 30)
      .setSize(20, 10)
      .setValue(this.doesZoom);
    ;
  }

  void toggleRotate() {
    this.doesRotate = !this.doesRotate;
  }

  void toggleZoom() {
    this.doesZoom = !this.doesZoom;
  }

  void removeGui(ControlP5 cp5) {
    cp5.remove("rotateT");
    cp5.remove("zoomT");
  }

  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(rot1)) {
      toggleRotate();
    } else if (theEvent.isFrom(zoom1)) {
      toggleZoom();
    }
  }

  void generate() {
    for (int i = 0; i < boxAmount; i++) {
      int amount = int(map(i, 0, boxAmount, 1, 6));
      float R = random(150 + amount * 20);
      float G = random(255);
      float B = random(200 + amount*10);
      color kl = color(R, G, B);

      int arms = 4;
      float radius = random(10, 400);
      float offset = random(20, 150);
      float z = random(-400, 0);

      bs[i] = new boxes(kl, amount, arms, radius, offset, z);
      bs[i].rotate = this.doesRotate;
    }
    this.zoomScale = s/2.0;
  }

  void zoom() {
    if (this.doesZoom) {
      this.zoomScale += 0.008;
      if (this.zoomScale>2) {
        this.zoomTrigger = true;
      }
    } else {
      this.zoomScale = 1.0;
    }
  }

  void feed(Boolean [] t) {
    for (int i = 0; i < t.length; i++)
    {
      if (i == 0) {
        if (t[i]) {
          if (zoomTrigger) {
            zoomScale = s;
            generate();
            zoomTrigger = false;
          }
          bs[int(random(0, boxAmount/5))].activate();
        }
      }
      if (i == 1) {
        if (t[i]) bs[int(random(boxAmount/5+1, 2*boxAmount/5))].activate();
      }
      if (i == 2) {
        if (t[i]) bs[int(random(2*boxAmount/5+1, 3*boxAmount/5))].activate();
      }
      if (i == 3) {
        if (t[i]) bs[int(random(3*boxAmount/5 +1, 4*boxAmount/5))].activate();
      }
      if (i == 4) {
        if (t[i]) bs[int(random(4*boxAmount/5+1, 5*boxAmount/5))].activate();
      }
    }
  }

  void show() {
    zoom();
    pushMatrix();
    background(0);
    translate(x, y);
    if (this.doesRotate) {
      this.rotation += PI/450.0;
      rotate(rotation);
    }
    scale(zoomScale);
    for (int i = 0; i < boxAmount; i++) {
      bs[i].rotate = this.doesRotate;
      bs[i].show();
    }
    popMatrix();
  }
}

class boxes {
  color kl, fadable;
  int amount, arms;
  float radius, offset;
  float z;
  float alpha;
  float originalSize, sizeX, sizeY, sizeZ;
  boolean active;
  float xS, yS, zS;
  float lifeTime;
  float dRot;

  float rotation;
  Boolean rotate;

  boxes(color kl, int amount, int arms, float radius, float offset, float z) {
    this.kl = kl;
    this.fadable = this.kl;
    this.amount = amount;
    this.arms = arms;
    this.radius = radius;
    this.offset = offset;
    this.z = z;
    this.originalSize = random(40, 60);
    this.reset();
    this.active = false;
    this.xS = random(0.85, 1.03); //scale parameters
    this.yS = random(0.85, 1.03);
    this.zS = random(0.85, 1.03);
    //this.dRot = random(0.01, 0.03); //rotation diff
    this.rotation = 0;
    this.rotate = false;
  }

  void activate() {
    this.active = true;
    this.reset();
  }

  void reset() {
    this.lifeTime = random(10, 20);
    this.alpha = random(75, 150);
    this.sizeX = this.originalSize;
    this.sizeY = this.originalSize;
    this.sizeZ = this.originalSize/4;
  }

  void show() {
    if (this.rotate) this.rotation += PI/450.0;

    this.lifeTime--;
    if (this.active && this.lifeTime > 0) {
      this.sizeX *= xS;
      this.sizeY *= yS;
      this.sizeZ *= zS;
    } else {
    }
    pushMatrix();
    noStroke();
    this.alpha *= 0.8;
    fill(this.kl, this.alpha);
    //translate(width/2, height/2, 0);
    rotate(PI/4);
    if (rotate) rotate(rotation*float(this.amount));
    for (int i = 0; i < this.arms; i++) {
      if (this.amount == 1) { //single mid arm
        rotate(TWO_PI/this.arms);
        translate(this.radius, 0);
        box(this.sizeX, this.sizeY, this.sizeZ);
        translate(-this.radius, 0);
      }
      if (this.amount == 2) { //pair on arm
        rotate(TWO_PI/this.arms);
        translate(this.radius, this.offset);
        box(this.sizeX, this.sizeY, this.sizeZ);
        translate(0, -2*this.offset);
        box(this.sizeX, this.sizeY, this.sizeZ);
        translate(-this.radius, this.offset);
      }
      if (this.amount == 3) { //trio in corner
        //offset works here as spacing between the boxes
        rotate(TWO_PI/this.arms);
        translate(this.radius, this.radius);
        box(this.sizeX, this.sizeY, this.sizeZ);
        translate(-this.offset, 0);
        box(this.sizeX, this.sizeY, this.sizeZ);
        translate(this.offset, -this.offset);
        box(this.sizeX, this.sizeY, this.sizeZ);
        translate(-this.radius, -this.radius + this.offset);
      }
      if (this.amount == 4) { //single in corner, naturally a little bigger in size
        rotate(TWO_PI/this.arms);
        translate(this.radius - this.offset/2, this.offset/2);
        box(this.sizeX, this.sizeY, this.sizeZ);
        translate(0, -this.offset);
        box(this.sizeX, this.sizeY, this.sizeZ);
        translate(this.offset, 0);
        box(this.sizeX, this.sizeY, this.sizeZ);
        translate(0, this.offset);
        box(this.sizeX, this.sizeY, this.sizeZ);
        translate(-this.radius - this.offset/2, -this.offset/2);
      }      
      if (this.amount == 5) { //single in corner, naturally a little bigger in size
        rotate(TWO_PI/this.arms);
        translate(this.radius, this.radius, -z);
        box(this.sizeX, this.sizeY, this.sizeZ);
        translate(-this.radius, -this.radius, z);
      }
    }
    popMatrix();
  }
}
