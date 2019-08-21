class Sines extends visual {
  int amount = 37;
  int verticalDetail = 600;
  float[] sineHC = new float[verticalDetail];
  float yOffset = 10;
  float yOffsetIncrease = 0.02;
  float weight = 2;
  float rotation = 0;
  float t1, t2;
  int wi, he;
  boolean bg = false;
  int verticalSpacing = 5;


  Slider vertDetail;
  Slider vertSpacing;
  Slider yoffs;

  Toggle backgroundFreeze;
  Toggle reverse;

  Sines(String id, int x, int y, float s, float f) {
    super(id, x, y, s, f, true);
    this.wi = x;
    this.he = y;
    colorMode(RGB);
    for (int i=0; i<verticalDetail; i++) {
      sineHC[i] = sin(2*PI*i/verticalDetail);
    }
  }

  void addGui(ControlP5 cp5, int x, int y) {
    vertDetail = cp5.addSlider("vertDetail")
      .setPosition(x, y)
      .setSize(80, 18)
      .setRange(10, 600)
      .setValue(600)
      ;
    vertSpacing = cp5.addSlider("vertSpacing")
      .setPosition(x, y + 20)
      .setSize(80, 18)
      .setRange(1, 20)
      .setValue(5)
      ;
    yoffs = cp5.addSlider("speed")
      .setPosition(x, y + 40)
      .setSize(80, 18)
      .setRange(0, 1.0)
      .setValue(0.02)
      ;

    backgroundFreeze = cp5.addToggle("bgFreeze")
      .setPosition(x+150, y)
      .setSize(20, 10)
      .setValue(this.bg);
    ;
    reverse = cp5.addToggle("reverseSines")
      .setPosition(x+150, y+30)
      .setSize(20, 10)
      .setValue(false);
    ;
  }

  void removeGui(ControlP5 cp5) {
    cp5.remove("vertDetail");
    cp5.remove("speed");
    cp5.remove("vertSpacing");
    cp5.remove("bgFreeze");
    cp5.remove("reverseSines");
  }

  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(vertDetail)) {
      verticalDetail = int(vertDetail.getValue());
      float[] sineHC = new float[verticalDetail];
      for (int i=0; i<verticalDetail; i++) {
        sineHC[i] = sin(2*PI*i/verticalDetail);
      }
    } else if (theEvent.isFrom(vertSpacing)) {
      verticalSpacing = int(vertSpacing.getValue());
    } else if (theEvent.isFrom(backgroundFreeze)) {
      this.bg = !this.bg;
    } else if (theEvent.isFrom(reverse)) {
      yOffsetIncrease = -yOffsetIncrease;
    } else if (theEvent.isFrom(yoffs)) {
      yOffsetIncrease = yoffs.getValue();
    }
  }

  void feed(Boolean [] t) {
    if (t[0]) {
      weight = 15;
    }
    if (t[1]) {
    }
  }
  void show() {
    t1 = sineHC[abs(7*int(yOffset)%verticalDetail)];
    t2 = sineHC[abs(11*int(yOffset+amount/2)%verticalDetail)];
    if (!bg) background(0);
    stroke(255*t2, 255*t1, 210);
    strokeWeight(this.weight);
    this.weight = max(this.weight*0.9, 3);
    for (int i=0; i<amount; i++) {
      for (int j=0; j<verticalDetail; j+=verticalSpacing) {
        point(-20+i*22+sineHC[abs(int((j+yOffset*(i+amount/2))%verticalDetail))]*15, j, -5);
        //point(-20+i*22+sineHC[abs(int((j+yOffset*(i+amount/2))%verticalDetail))]*15, j, 50);
        //point(j, -20+i*22+sineHC[abs(int((j+yOffset*(i+amount/2))%600))]*15);
      }
    }
    yOffset+=yOffsetIncrease;
  }

  float[] getCamSettings() {
    float[] settings = new float[4];
    settings[0] = wi/2;
    settings[1] = he/2;
    settings[2] = 0;
    settings[3] = 400;
    return settings;
  }
}
