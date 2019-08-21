class Waver extends visual {

  //1 = single
  //2 = mirror
  //3 = quad
  //4 = distancelines
  int waveMode = 4;

  float amp = 100.0;
  float distance = 50.0;

  int wi, he;

  Slider waveAmp;
  Slider waveDistance;

  RadioButton r;
  
  Toggle colorRand;
  
  color[] colors = new color[10];
  color color_pri, color_sec;
  
  boolean colorRandomize = false;
  
  int timer_reset = 50;
  int timer = timer_reset;
  
  
  int r1, r2;

  Waver(String id, int x, int y, float s, float f, BeatTrigger bt) {
    super(id, x, y, s, f, true); 
    this.wi = x;
    this.he = y;
    this.colors[0] = #FFFFFF;
    this.colors[1] = #000000;
    this.colors[2] = #1B0075; //blue
    this.colors[3] = #1BFA75; //green
    this.colors[4] = #710000; //red
    this.colors[5] = #BD78AD; //pink
    this.colors[6] = #19D475; //green
    this.colors[7] = #E5AC04; //yellow
    this.colors[8] = #2D079B; //purple
    this.colors[9] = #04DB8D; //teal
    
    this.color_pri = colors[0];
    this.color_sec = colors[1];
  }

  void show() {
    //if (!this.colorRandomize) {
    //  this.color_pri = this.colors[0];
    //  this.color_sec = this.colors[1];
    //}
    
    if (waveMode == 1) {
      background(this.color_sec);
      stroke(this.color_pri);
      strokeWeight(2);
      for (int i = 0; i< this.x; i++) {
        point(i, bt.in.left.get(i)*amp+this.he/2);
      }
    }
    if (waveMode == 2) {
      background(this.color_sec);
      stroke(this.color_pri);
      strokeWeight(2);
      for (int i = 0; i < this.x-1; i++) {
        line(i, this.he/2 + bt.in.left.get(i)*this.amp + this.distance/2, i + 1, this.he/2 + bt.in.left.get(i + 1)*this.amp + this.distance/2);
        line(i, this.he/2 - bt.in.left.get(i)*this.amp - this.distance/2, i + 1, this.he/2 - bt.in.left.get(i + 1)*this.amp - this.distance/2);
      }
    }
    if (waveMode == 3) {
      background(this.color_pri);
      stroke(this.color_sec);
      strokeWeight(2);
      for (int i = 0; i < this.x-1; i++) {
        line(i, this.he/2 + bt.in.left.get(i)*amp + distance/2, i, this.he);
        line(i, this.he/2 - bt.in.left.get(i)*amp - distance/2, i, 0);
      }
    }
    if (waveMode == 4) {
      background(this.color_pri);
      strokeWeight(2);
      for (int i = 0; i < this.x-1; i++) {
        stroke(this.color_sec);
        line(i, this.he/2 + bt.in.left.get(i)*this.amp + this.distance/2, i, this.he);
        line(i, this.he/2 - bt.in.left.get(i)*this.amp - this.distance/2, i, 0);
        stroke(map(bt.in.left.get(i)*10, 0, 1, 255, 0));
        line(i, this.he/2 + bt.in.left.get(i)*this.amp + this.distance/2, i, this.he/2 - bt.in.left.get(i)*this.amp - this.distance/2);
      }
    }
  }

  void feed(Boolean [] t) {
    if (t[0] && this.colorRandomize && this.timer == 0){
      r1 = int(random(10));
      r2 = int(random(10));
      while (r1 == r2) {
        r2 = int(random(10));
      }
      this.color_pri = this.colors[r1];
      this.color_sec = this.colors[r2];
      this.timer = timer_reset;
    }
    if (this.timer > 0) this.timer--;
  }

  void addGui(ControlP5 cp5, int x, int y) {
    waveAmp = cp5.addSlider("wAmp")
      .setPosition(x, y)
      .setSize(80, 18)
      .setRange(0, 1000)
      .setValue(100)
      ;
    waveDistance = cp5.addSlider("wDis")
      .setPosition(x, y + 20)
      .setSize(80, 18)
      .setRange(0, 400)
      .setValue(50)
      ;
    r = cp5.addRadioButton("waveModus")
      .setPosition(x, y + 40)
      .setSize(10, 10)
      .setColorForeground(color(120))
      .setColorActive(color(255))
      .setColorLabel(color(255))
      .setItemsPerRow(4)
      .setSpacingColumn(35)
      .addItem("single", 1)
      .addItem("mirror", 2)
      .addItem("quad", 3)
      .addItem("distancelines", 4)
      ;
      colorRand = cp5.addToggle("randomizeColors")
      .setPosition(x, y+60)
      .setSize(20, 10)
      .setValue(this.colorRandomize);
    ;
  }

  void removeGui(ControlP5 cp5) {
    cp5.remove("wAmp");
    cp5.remove("wDis");
    cp5.remove("waveModus");
    cp5.remove("randomizeColors");
  }

  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(waveAmp)) {
      amp = int(waveAmp.getValue());
    }
    if (theEvent.isFrom(waveDistance)) {
      distance = int(waveDistance.getValue());
    }
    if (theEvent.isFrom(r)) {
      waveMode = int(r.getValue());
    }
    if (theEvent.isFrom(colorRand)) {
      this.colorRandomize = !this.colorRandomize;
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
