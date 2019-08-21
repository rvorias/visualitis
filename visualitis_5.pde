import peasy.PeasyCam;
PeasyCam cam;

visual[] visuals;
visual activeVisual;
Controller c;
BeatTrigger bt;

float[] camSettings;

int activeIndex;

void settings() {
  size(800, 600, P3D);
  //fullScreen(2);
}

void setup() {
  bt = new BeatTrigger(this);
  cam = new PeasyCam(this, width/2, height/2, width/2, 700);
  visuals = new visual[13];
  visuals[0] = new Waver("waver_test", width, height, 1, 1, bt);
  visuals[11] = new boxes1("boxes_purple", width/2, height/2, 1, 1);
  visuals[1] = new diamondField("diamondfield_purple_rotating", width/2, height/2, 1, 1, true, true);
  visuals[2] = new diamondField("diamondfield_purple", width/2, height/2, 1, 1, false, true);
  visuals[3] = new flowfield("f", width, height, 1, 1);
  visuals[4] = new pillar_img("pillar images", width, height, 1, 1);
  visuals[5] = new Sherman("sherman-bust", width, height, 1, 1);
  visuals[6] = new DripCanvas("dripper_test", width, height, 1, 1);
  visuals[7] = new Delaun("Delauny", width, height, 1, 1);
  visuals[8] = new Smiley("Smile", width, height, 1, 1, false);
  visuals[9] = new Sines("sine", width, height, 1, 1);
  visuals[10] = new Lissa("lissajous", width, height, 1, 1);
  visuals[12] = new Fire("vuur", width, height, 1, 1);
  c = new Controller(bt, visuals);
  activeIndex = c.activeVisualIndex;
  activeVisual = visuals[activeIndex];
}

void draw() {
  if (activeIndex != c.activeVisualIndex) {
    background(0);
    activeIndex = c.activeVisualIndex;
    activeVisual = visuals[activeIndex];
    if (activeVisual.hasCamSettings) {
      this.camSettings = activeVisual.getCamSettings();
      cam = new PeasyCam(this, camSettings[0], camSettings[1], camSettings[2], camSettings[3]);
    }
  }
  bt.analyze();
  activeVisual.feed(bt.triggers);
  activeVisual.show();
  if (c.cameraResetRequest) resetCamera();
}

void resetCamera() {
  cam = new PeasyCam(this, width/2, height/2, width/2, 700);
  c.cameraResetRequest = false;
}

public void stop() {
  super.stop();
}

public void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
    }
    if (keyCode == DOWN ) {
    }
  }
}
