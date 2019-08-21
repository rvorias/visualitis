import controlP5.*;

class Controller extends PApplet {
  ControlP5 cp5;

  Controller(BeatTrigger bt, visual[] visuals) {
    super();
    this.bt = bt;
    this.visuals = visuals;
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  BeatTrigger bt;
  Boolean btLoaded;

  Slider sens0;
  Slider sens1;
  Slider sens2;
  Slider sens3;
  Slider sens4;
  int sensi0;
  int sensi1;
  int sensi2;
  int sensi3;
  int sensi4;
  DropdownList dHist;
  int dHistSelector = 0;

  //new
  ListBox visualLib;
  int amountOfVisuals;
  visual[] visuals;
  int activeVisualIndex;
  Group visualG;
  //\new

  Slider bandCutOff;
  int cutOff;
  int smoothingFactor;

  PFont font;

  Boolean forceNormalize;
  Boolean cameraResetRequest = false;

  int rPaneX;

  CheckBox trig0, trig1, trig2, trig3, trig4;

  void settings() {
    size(600, 800);
  }

  void setup() {
    noStroke();
    smooth();
    frameRate(60);
    //font = loadFont("Dialog.plain-10.vlw");
    //textFont(font, 10);
    gui();
    forceNormalize = false;
    rPaneX = width-150;
    activeVisualIndex = 0;
  }

  void fillVisualLib() {
    for (int i = 0; i < this.visuals.length; i++) {
      visualLib.addItem(visuals[i].id, i);
    }
  }

  void gui() {
    cp5 = new ControlP5(this);

    cp5.addFrameRate().setInterval(10).setPosition(width - 30, 10);

    sens0 = cp5.addSlider("sensi0")
      .setPosition(10, 280)
      .setSize(80, 18)
      .setRange(0, 100)
      .setValue(15)
      ;
    sens1 = cp5.addSlider("sensi1")
      .setPosition(10, 300)
      .setSize(80, 18)
      .setRange(0, 100)
      .setValue(15)
      ;
    sens2 = cp5.addSlider("sensi2")
      .setPosition(10, 320)
      .setSize(80, 18)
      .setRange(0, 100)
      .setValue(15)
      ;
    sens3 = cp5.addSlider("sensi3")
      .setPosition(10, 340)
      .setSize(80, 18)
      .setRange(0, 100)
      .setValue(15)
      ;
    sens4 = cp5.addSlider("sensi4")
      .setPosition(10, 360)
      .setSize(80, 18)
      .setRange(0, 100)
      .setValue(15)
      ;
    bandCutOff = cp5.addSlider("cutOff")
      .setPosition(120, 160)
      .setSize(80, 10)
      .setRange(0, 150)
      .setValue(0)
      ;
    cp5.addToggle("forceNormalize")
      .setPosition(120, 175)
      .setSize(20, 10)
      ;
    cp5.getController("forceNormalize").getCaptionLabel().alignY(ControlP5.LEFT).setPaddingX(25);
    bandCutOff = cp5.addSlider("smoothingFactor")
      .setPosition(240, 160)
      .setSize(80, 10)
      .setRange(1, 10)
      .setValue(1)
      ;
    cp5.addToggle("smoothing")
      .setPosition(240, 175)
      .setSize(20, 10)
      ;
    cp5.getController("smoothing").getCaptionLabel().alignY(ControlP5.LEFT).setPaddingX(25);
    cp5.addButton("histMaxReset")
      .setPosition(120, 190)
      .setSize(60, 10)
      ;
    dHist = cp5.addDropdownList("dHist")
      .setPosition(10, 160)
      .setSize(100, 100)
      ;
    dHist.addItem("hist[0]", 0);
    dHist.addItem("hist[1]", 1);
    dHist.addItem("hist[2]", 2);
    dHist.addItem("hist[3]", 3);
    dHist.addItem("hist[4]", 4);
    dHist.addItem("hist[5]", 5);
    dHist.addItem("hist[6]", 6);
    dHist.addItem("hist[7]", 7);
    dHist.addItem("hist[8]", 8);
    dHist.addItem("hist[9]", 9);
    dHist.setValue(0);
    dHist.close();

    trig0 = cp5.addCheckBox("trigger_0")
      .setPosition(140, 280)
      .setSize(10, 10)
      .setItemsPerRow(1)
      .setSpacingRow(2)
      .addItem("t00", 0)
      .addItem("t01", 1)
      .addItem("t02", 2)
      .addItem("t03", 3)
      .addItem("t04", 4)
      .addItem("t05", 5)
      .addItem("t06", 6)
      .addItem("t07", 7)
      .addItem("t08", 8)
      .addItem("t09", 9)
      .toggle(1)
      .toggle(2)
      ;
    trig1 = cp5.addCheckBox("trigger_1")
      .setPosition(180, 280)
      .setSize(10, 10)
      .setItemsPerRow(1)
      .setSpacingRow(2)
      .addItem("t10", 0)
      .addItem("t11", 1)
      .addItem("t12", 2)
      .addItem("t13", 3)
      .addItem("t14", 4)
      .addItem("t15", 5)
      .addItem("t16", 6)
      .addItem("t17", 7)
      .addItem("t18", 8)
      .addItem("t19", 9)
      .toggle(3)
      .toggle(4)
      ;
    trig2 = cp5.addCheckBox("trigger_2")
      .setPosition(220, 280)
      .setSize(10, 10)
      .setItemsPerRow(1)
      .setSpacingRow(2)
      .addItem("t20", 0)
      .addItem("t21", 1)
      .addItem("t22", 2)
      .addItem("t23", 3)
      .addItem("t24", 4)
      .addItem("t25", 5)
      .addItem("t26", 6)
      .addItem("t27", 7)
      .addItem("t28", 8)
      .addItem("t29", 9)
      .toggle(5)
      .toggle(6)
      ;
    trig3 = cp5.addCheckBox("trigger_3")
      .setPosition(260, 280)
      .setSize(10, 10)
      .setItemsPerRow(1)
      .setSpacingRow(2)
      .addItem("t30", 0)
      .addItem("t31", 1)
      .addItem("t32", 2)
      .addItem("t33", 3)
      .addItem("t34", 4)
      .addItem("t35", 5)
      .addItem("t36", 6)
      .addItem("t37", 7)
      .addItem("t38", 8)
      .addItem("t39", 9)
      .toggle(7)
      .toggle(8)
      ;
    trig4 = cp5.addCheckBox("trigger_4")
      .setPosition(300, 280)
      .setSize(10, 10)
      .setItemsPerRow(1)
      .setSpacingRow(2)
      .addItem("t40", 0)
      .addItem("t41", 1)
      .addItem("t42", 2)
      .addItem("t43", 3)
      .addItem("t44", 4)
      .addItem("t45", 5)
      .addItem("t46", 6)
      .addItem("t47", 7)
      .addItem("t48", 8)
      .addItem("t49", 9)
      ;
    visualLib = cp5.addListBox("visualLib")
      .setPosition(350, 500)
      .setSize(200, 120)
      .setItemHeight(15)
      .setBarHeight(15)
      ;
    cp5.addButton("makeActive")
      .setPosition(350, 480)
      .setSize(60, 10)
      ;
    sendTriggerConfig(bt);
    visualG = cp5.addGroup("g1");
    fillVisualLib();
    cp5.addButton("resetCam")
      .setPosition(450, 480)
      .setSize(60, 10)
      ;
  }

  void draw() {
    bt.analyze();
    background(0);
    //drawGuideLines();

    bandVisualizer(int(dHist.getValue()), 10, 150);

    fftVisualizer(rPaneX, 100);

    bt.sensitivity[0] = float(sensi0)/10.0;
    bt.sensitivity[1] = float(sensi1)/10.0;
    bt.sensitivity[2] = float(sensi2)/10.0;
    bt.sensitivity[3] = float(sensi3)/10.0;
    bt.sensitivity[4] = float(sensi4)/10.0;
    bt.bandCutOff = cutOff;
    bt.smoothingFac = 1/float(smoothingFactor);

    for (int i = 0; i < bt.bandsToAnalyze; i++)
    {
      bandInfo(i, rPaneX, 120+34*i);
    }
    triggerVisualizer(141, 270);
  }

  void drawGuideLines() {
    for (int i = 0; i < max(width, height); i = i + 50)
    {
      if (i%100 == 0) stroke(150);
      else stroke(50);
      line(0, i, width, i);
      line(i, 0, i, height);
    }
  }

  void triggerVisualizer(int x, int y) {
    for (int i = 0; i < bt.triggerAmount; i++)
    {
      //small bar
      rect(x + 40*i, y, 5, max(-bt.triggerBins[i],-50));
      //large bar if beat detected
      if (bt.triggers[i]) {
        fill(160, 20, 20);
        rect(x + 10 +40*i, y, 20, -50);
      }
    }
  }

  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(trig0) || theEvent.isFrom(trig1) || theEvent.isFrom(trig2) || theEvent.isFrom(trig3) || theEvent.isFrom(trig4)) {
      sendTriggerConfig(bt);
      //println("sending trigger config");
    } else if (theEvent.isFrom(visualLib)) {
    } else {
      visuals[activeVisualIndex].controlEvent(theEvent);
    }
  }

  void sendTriggerConfig(BeatTrigger bt) {
    float[][] triggerArray = new float[bt.triggerAmount][bt.bandsToAnalyze];
    for (int i = 0; i < bt.bandsToAnalyze; i++)
    {
      triggerArray[0][i] = trig0.getArrayValue()[i];
      triggerArray[1][i] = trig1.getArrayValue()[i];
      triggerArray[2][i] = trig2.getArrayValue()[i];
      triggerArray[3][i] = trig3.getArrayValue()[i];
      triggerArray[4][i] = trig4.getArrayValue()[i];
    }
    bt.setTriggerConfig(triggerArray);
  }

  void bandInfo(int b, int x, int y) {
    float spacing = 10;
    fill(150, 170, 255);
    text("_Band_" + b + "____________", x, y);
    text("AVG    " + String.format("%.02f", bt.histAvg[b]), x, y+spacing);
    text("VAR    " + String.format("%.02f", bt.histVar[b]), x, y+spacing*2);
    text("REL SPR", x + 70, y+spacing*1);
    text("    " + String.format("%.1f", bt.histVar[b]/(bt.histAvg[b]+bt.histVar[b])*100) + " %", x + 60, y+spacing*2);
  }

  void fftVisualizer(int x, int y) {
    for (int i = 0; i < 50; i++)
    {
      stroke(255);
      line(x+2*i, y, x+2*i, y-bt.fft.getBand(i));
    }
  }

  void bandVisualizer(int band, int x, int y) {
    float maxH = 100;
    for (int i = 0; i < bt.upperBandLim; i++)
    {
      if (forceNormalize == true) {
        line(x+2*i, y, x+2*i, y-bt.bandHist[band][i]/bt.histMax[band]*maxH);
        stroke(200, 0, 200);
        line(x, y-bt.histAvg[band]/bt.histMax[band]*maxH, x + 2*bt.upperBandLim, y-bt.histAvg[band]/bt.histMax[band]*maxH);
        stroke(255, 0, 0);
        line(x, y-(bt.histAvg[band]+bt.histVar[band])/bt.histMax[band]*maxH, x + 2*bt.upperBandLim, y-(bt.histAvg[band]+bt.histVar[band])/bt.histMax[band]*maxH);
        stroke(255);
      } else {
        line(x+2*i, y, x+2*i, y-bt.bandHist[band][i]);
        stroke(200, 0, 200);
        line(x, y-bt.histAvg[band], x + 2*bt.upperBandLim, y-bt.histAvg[band]);
        stroke(255, 0, 0);
        line(x, y-(bt.histAvg[band]+bt.histVar[band]), x + 2*bt.upperBandLim, y-(bt.histAvg[band]+bt.histVar[band]));
        stroke(255);
      }
    }
  }

  void forceNormalize() {
    forceNormalize = !forceNormalize;
  }
  
  void resetCam() {
    cameraResetRequest = true;
  }

  void makeActive() {
    visuals[activeVisualIndex].removeGui(cp5);
    activeVisualIndex = int(visualLib.getValue());
    visuals[activeVisualIndex].addGui(cp5, 50, 500);
  }

  void smoothing() {
    bt.smoothing = !bt.smoothing;
  }

  void histMaxReset() {
    for (int i = 0; i < bt.bandsToAnalyze; i++)
    {
      bt.histMax[i] = 1;
    }
  }

  public void keyPressed() {
    if (key == CODED) {
      if (keyCode == UP) {
        bt.triggers[0] = true;
      }
      if (keyCode == DOWN ) {
      }
      if (keyCode == LEFT ) {
      }
      if (keyCode == RIGHT ) {
      }
    }
  }
}
