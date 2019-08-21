class Fire extends visual {

  PImage buffer1;
  PImage buffer2;
  PImage coolingMap;
  float coolingScale = 5;
  float scroller = 0;
  float scrollSpeed = 0.5;
  float coolAmp = 2.5;
  int sc = 4;

  int showMode = 1; 

  int wi, he;

  Slider cooler;
  Slider convection;
  Slider coolAm;


  Fire(String id, int x, int y, float s, float f) {
    super(id, x, y, s, f, true); 
    this.wi = x;
    this.he = y;

    buffer1 = createImage(this.wi/sc, this.he/sc, RGB);
    buffer2 = createImage(this.wi/sc, this.he/sc, RGB);
    coolingMap = createImage(this.wi/sc, this.he/sc, RGB);
  }

  void source()
  {
    buffer1.loadPixels();
    for (int x = 0; x < this.wi/sc; x++) {
      int y = this.he/sc-1;
      int index = x + y * this.wi/sc;
      buffer1.pixels[index] = color(255);
      buffer1.pixels[index-this.wi/sc] = color(150);
    }
    buffer1.updatePixels();
  }

  void spread() {
    buffer1.loadPixels();
    buffer2.loadPixels();
    for (int x = 1; x < this.wi/sc-1; x++) {
      for (int y = 1; y < this.he/sc-1; y++) {
        int index = x + (y) * this.wi/sc;
        float b1 = brightness(buffer1.pixels[index-1]);
        float b2 = brightness(buffer1.pixels[index+1]);
        float b3 = brightness(buffer1.pixels[index-this.wi/sc]);
        float b4 = brightness(buffer1.pixels[index+this.wi/sc]);

        float c = (b1+b2+b3+b4)/4.0 - noise(x/coolingScale, y/coolingScale - scroller)*coolAmp;
        if (c < 0) c = 0;
        buffer2.pixels[index-this.wi/sc] = color(c);
      }
    }
    scroller += scrollSpeed;
    buffer2.updatePixels();
  }

  void show() {
    background(0);
    source();
    spread();
    PImage temp = buffer1;
    buffer1 = buffer2;
    buffer2 = temp;

    if (showMode == 1) {
      blendMode(SCREEN);
      //image(buffer1, 0, 0);
      pushMatrix();
      translate(this.wi, this.he);
      rotate(PI);
      scale(4);
      image(buffer1, 0, 0);
      popMatrix();
      scale(4);
      image(buffer1, 0, 0);
    }

    if (showMode == 2) {
      scale(4);
      image(buffer1, 0, 0);
    }
  }

  void feed(Boolean [] t) {
    if (t[0]) {
    }
  }

  void addGui(ControlP5 cp5, int x, int y) {
    cooler = cp5.addSlider("cScale")
      .setPosition(x, y)
      .setSize(80, 18)
      .setRange(0.1, 50)
      .setValue(this.coolingScale)
      ;
    convection = cp5.addSlider("coolMapSpeed")
      .setPosition(x, y + 20)
      .setSize(80, 18)
      .setRange(0, 0.5)
      .setValue(this.scrollSpeed)
      ;
    coolAm = cp5.addSlider("coolStrenght")
      .setPosition(x, y + 40)
      .setSize(80, 18)
      .setRange(0, 100)
      .setValue(this.coolAmp)
      ;
  }

  void removeGui(ControlP5 cp5) {
    cp5.remove("cScale");
    cp5.remove("coolMapSpeed");
    cp5.remove("coolStrenght");
  }

  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(cooler)) {
      this.coolingScale = int(cooler.getValue());
    }
    if (theEvent.isFrom(convection)) {
      this.scrollSpeed = int(convection.getValue());
    }
    if (theEvent.isFrom(coolAm)) {
      this.coolAmp = int(coolAm.getValue());
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
}
