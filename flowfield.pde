class flowfield extends visual {
  int scl = 50;
  int cols, rows;
  PVector[][][] field;
  float xoff = 0;
  float yoff = 0;
  float zoff = 0;
  float inc = 0.1;
  float fieldOffset = 0;
  int pop = 5000;
  particle[] particles = new particle[pop];
  float maxVel = 10.0;
  float fieldMag = 5;
  int d;
  int width;
  int height;
  Boolean[] triggers = new Boolean [5];

  boolean enableDazeBoom = false;
  boolean enableLightPartition = false;

  Slider maxPVel;
  
  Toggle dazeBoom;
  Toggle lightPart;

  flowfield(String id, int x, int y, float s, float f) {
    super(id, x, y, s, f, true); 
    this.width = x;
    this.height = y;
    generate();
  }

  void generate() {
    background(0);
    rows = int(height/scl);
    cols = int(width/scl);
    d = int(width/scl);
    field = new PVector[cols][rows][d];

    for (int i = 0; i < particles.length; i++) {
      particles[i] = new particle(scl);
    }
  }

  void addGui(ControlP5 cp5, int x, int y) {
    maxPVel = cp5.addSlider("maxParticleVelocity")
      .setPosition(x, y)
      .setSize(80, 18)
      .setRange(1, 20)
      .setValue(10)
      ;
   dazeBoom = cp5.addToggle("dazeandboom")
      .setPosition(x+150, y)
      .setSize(20, 10)
      .setValue(false);
    ;
    lightPart = cp5.addToggle("lightpartition")
      .setPosition(x+150, y+30)
      .setSize(20, 10)
      .setValue(false);
    ;
  }

  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(maxPVel)) {
      maxVel = maxPVel.getValue();
    }
    if (theEvent.isFrom(dazeBoom)) {
      enableDazeBoom = !enableDazeBoom;
    }
    if (theEvent.isFrom(lightPart)) {
      enableLightPartition = !enableLightPartition;
    }
  }

  void removeGui(ControlP5 cp5) {
    cp5.remove("maxParticleVelocity");
    cp5.remove("dazeandboom");
    cp5.remove("lightpartition");
  }

  void feed(Boolean [] t) {
    this.triggers = t;
  }

  void show() {
    colorMode(RGB);
    rotateY(-5.0f);
    background(0);
    xoff = fieldOffset;
    for (int i = 0; i < cols; i++) {
      yoff = fieldOffset;  
      for (int j = 0; j < rows; j++) {
        zoff = fieldOffset;
        for (int k = 0; k < d; k++) {
          field[i][j][k] = PVector.fromAngle(map(noise(xoff, yoff, zoff), 0, 1, 0, 2*PI));
          field[i][j][k].z = (field[i][j][k].x + field[i][j][k].y)/2;
          field[i][j][k].setMag(fieldMag);
          zoff += inc;
        }
        yoff += inc;
      }
      xoff += inc;
    }
    fieldOffset += inc/50;


    for (int i = 0; i < particles.length; i++) {
      if (particles[i].maxVel != this.maxVel) particles[i].maxVel = this.maxVel;
      particles[i].follow(field);
      particles[i].update();
      if (triggers[0]) {
        if (enableDazeBoom) {
          particles[i].vel.setMag(0);
          particles[i].dazed();
          particles[i].boom();
        }
        if (enableLightPartition) {
          if (particles[i].pos.y > this.height/3) {
            particles[i].boom();
          }
        }
      }

      particles[i].show();
      particles[i].edges();
    }
  }

  float[] getCamSettings() {
    float[] settings = new float[4];
    settings[0] = this.width/2;
    settings[1] = this.height/2;
    settings[2] = 0;
    settings[3] = 300;
    return settings;
  }
}

class particle {
  PVector pos = new PVector(random(width), random(height), random(width));
  PVector vel = new PVector();
  PVector acc = new PVector();
  PVector prevPos = pos.copy();
  float size = 2.0;
  color c;
  float maxVel = 10.0;
  int scl;
  float daze = 0;

  particle(int scl) {
    this.scl = scl;
  }

  void update() {
    this.prevPos = pos.copy();
    this.vel.add(this.acc);
    if (this.vel.mag() > maxVel) this.vel.setMag(maxVel);
    this.vel.setMag((1-daze)*maxVel);
    this.daze *= 0.2;
    this.pos.add(this.vel);
    this.acc.mult(0);
  }

  void follow(PVector[][][] field) {
    int x = floor(this.pos.x/scl);
    int y = floor(this.pos.y/scl);
    int z = floor(this.pos.z/scl);
    addForce(field[x][y][z]);
  }

  void addForce(PVector v) {
    this.acc.add(v);
  }

  void show() {
    edgesFade();
    stroke(this.c);
    strokeWeight(constrain(size, 1, 10));
    line(this.pos.x, this.pos.y, this.pos.z, this.prevPos.x + (this.prevPos.x-this.pos.x)*size, this.prevPos.y + (this.prevPos.y-this.pos.y)*size, this.prevPos.z + (this.prevPos.z-this.pos.z)*size);
    size = size * 0.9;
  }

  void boom() {
    size = 3;
  }

  void dazed() {
    this.daze = .8;
  }

  void edges() {
    if (this.pos.x < 0) this.pos.x = width-1;
    if (this.pos.y < 0) this.pos.y = height-1;
    if (this.pos.x > width-1) this.pos.x = 0;
    if (this.pos.y > height-1) this.pos.y = 0;
    if (this.pos.z < 0) this.pos.z = width-1;
    if (this.pos.z > width-1) this.pos.z = 0;
  }

  void edgesFade() {
    PVector rgb = new PVector(255*abs(sin(this.pos.z*5)), map(this.pos.z, 0, width, 0, 255), (this.pos.z*0.5*size)%255);
    float fadeR = 100;

    if (this.pos.x < fadeR) rgb.setMag(rgb.mag()*(this.pos.x/fadeR)); 
    if (this.pos.y < fadeR) rgb.setMag(rgb.mag()*(this.pos.y/fadeR));
    if (this.pos.z < fadeR) rgb.setMag(rgb.mag()*(this.pos.z/fadeR));
    if (this.pos.x > width-fadeR) rgb.setMag(rgb.mag()*((width-this.pos.x)/fadeR));
    if (this.pos.y > height-fadeR) rgb.setMag(rgb.mag()*((height-this.pos.y)/fadeR));
    if (this.pos.z > width-fadeR) rgb.setMag(rgb.mag()*((width-this.pos.z)/fadeR));
    this.c = color(rgb.x, rgb.y, rgb.z);
  }
}
