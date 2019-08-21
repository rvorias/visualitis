class Sherman extends visual {
  String id;
  //translations
  int x, y;
  //scale and fade
  //fade is a number between 0 and 1 that will control the opacity
  float s, f;
  float width, height;

  PImage bg = loadImage("yung_sherman.jpg");

  float angle;
  float concentration;
  float viewOff;

  PVector half = new PVector();
  PVector mouse = new PVector();

  PShape bust;
  boolean beatRotate;
  boolean normalRotate;
  boolean flashBg = false;
  Toggle bRot, normRot;

  int spotFromEdge = 100;

  Sherman(String id, int x, int y, float s, float f) {
    super(id, x, y, s, f, false); 
    this.width = x;
    this.height = y;

    bust = loadShape("bust.obj");
    bust.setFill(color(255, 0, 127, 255));
    bust.setAmbient(0xff7f7f00);
    bust.setSpecular(0xff0000ff);
    bust.scale(20);
    angle = QUARTER_PI;
    viewOff = height * .86602;
    half.set(width * .5, height * .5);
    beatRotate = false;
  }

  void feed(Boolean [] t) {
    if (t[0] && beatRotate) { 
      bust.rotateY((random(2)-1)*random(5)*0.08);
    }
    if (t[1]) {
      mouse.set(random(spotFromEdge, width-spotFromEdge)-half.x, random(spotFromEdge, height - spotFromEdge)-half.y, viewOff);
      mouse.normalize();
    }
    if (t[4]) flashBg = true;
  }
  void show() {
    if (flashBg) {
      flashBg = false;
      background(bg);
    } else background(0);
    camera(0, 0, viewOff, 
      0, -150, 0, 
      0, 1, -1);

    lightSpecular(64, 64, 64);

    // Horizonal light.
    spotLight(0, 127, 255, 
      -half.x, sin(frameCount * .02) * half.y - 150, 0, 
      1, 0, 0, 
      PI, 25);

    // Vertical light.
    spotLight(0, 255, 127, 
      cos(frameCount * .02) * half.x, -half.y - 150, 0, 
      0, 1, 0, 
      PI, 25);

    // Flash light.
    spotLight(191, 170, 133, 
      0, 0, viewOff, 
      mouse.x, mouse.y, -1, 
      angle, concentration);

    spotLight(191, 170, 133, 
      0, 0, viewOff, 
      mouse.x, mouse.y, -1, 
      angle, concentration);

    translate(0, 40);
    shape(bust);
    //translate(200, 40);
    //scale(-1.0);
    //shape(bust);

    if (normalRotate) bust.rotateY(0.015f);


    concentration = map(cos(frameCount * .01), -1, 1, 12, 100);
  }

  void addGui(ControlP5 cp5, int x, int y) {
    bRot = cp5.addToggle("beatRotation")
      .setPosition(x, y)
      .setSize(20, 10)
      .setValue(this.beatRotate);
    normRot = cp5.addToggle("normalRotation")
      .setPosition(x, y + 30)
      .setSize(20, 10)
      .setValue(this.beatRotate);
  }

  void removeGui(ControlP5 cp5) {
    cp5.remove("beatRotation");
    cp5.remove("normalRotation");
  }

  void toggleRotate() {
    this.beatRotate = !this.beatRotate;
  }

  void toggleNormRotate() {
    this.normalRotate = !this.normalRotate;
  }

  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(bRot)) {
      toggleRotate();
    }
    if (theEvent.isFrom(normRot)) {
      toggleNormRotate();
    }
  }
}
