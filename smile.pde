class Smiley extends visual {
  String id;
  //translations
  int x, y;
  //scale and fade
  //fade is a number between 0 and 1 that will control the opacity
  float s, f;
  float wi, he;

  float w = 20;
  int radialSegments = 100;
  float angle = PI/5;
  float incr = 0.04;
  float t = 0;
  float sc = 3.5;
  
  color[] faceColors = new color[5];

  boolean hasCamSettings;

  Smiley(String id, int x, int y, float s, float f, boolean hasCamSettings) {
    super(id, x, y, s, f, true);
    this.wi = x;
    this.he = y;
    colorMode(RGB);
    this.hasCamSettings = hasCamSettings;
    for (int i = 0; i < faceColors.length; i++) {
     faceColors[i] = color(random(255), random(255), random(255)); 
    }
  }

  void feed(Boolean [] t) {
    if (t[0] == true){
      faceColors[0] = color(random(255), random(255), random(255));
    }
    else if (t[1] == true){
      faceColors[1] = color(random(255), random(255), random(255));
    }
    else if (t[2] == true){
      faceColors[2] = color(random(255), random(255), random(255));
    }
    else if (t[3] == true){
      faceColors[3] = color(random(255), random(255), random(255));
    }
  }
  void show() {
    //ortho(-width/2, width/2, -height/2, height/2);
    background(0);
    angle = t/10;
    t += incr;
    drawHollowCillinder(0, 0, 80, 100, faceColors[0]);
    drawHollowCillinder(-27, -30, 0, 15, faceColors[1]);
    drawHollowCillinder(27, -30, 0, 15, faceColors[2]);
    drawArc(0, 40, 34, 50, faceColors[3]);
  }

  void addGui(ControlP5 cp5, int x, int y) {
  }

  void removeGui(ControlP5 cp5) {
  }

  void controlEvent(ControlEvent theEvent) {
  }

  float[] getCamSettings() {
    float[] settings = new float[4];
    settings[0] = x/2;
    settings[1] = y/2;
    settings[2] = x/2;
    settings[3] = 700;
    return settings;
  }

  void drawArc(float X, float Y, float r, float R, color c) {
    float x, y, z;
    pushMatrix();
    scale(sc);
    rotateY(angle);
    translate(X, Y);
    noStroke();
    fill(c);
    beginShape(QUAD_STRIP); 
    for (int i = 0; i < radialSegments+1; i++) {
      x = r * cos(PI*(float(i)/float(radialSegments)));
      y = r * sin(-PI*(float(i)/float(radialSegments)));
      z = -w/2;
      vertex(x, y, z);
      x = r * cos(PI*(float(i)/float(radialSegments)));
      y = r * sin(-PI*(float(i)/float(radialSegments)));
      z = w/2;
      vertex(x, y, z);
    }
    endShape();
    beginShape(QUAD_STRIP); 
    for (int i = 0; i < radialSegments+1; i++) {
      x = R * cos(PI*(float(i)/float(radialSegments)));
      y = R * sin(-PI*(float(i)/float(radialSegments)));
      z = -w/2;
      vertex(x, y, z);
      x = R * cos(PI*(float(i)/float(radialSegments)));
      y = R * sin(-PI*(float(i)/float(radialSegments)));
      z = w/2;
      vertex(x, y, z);
    }
    endShape();
    beginShape(QUAD_STRIP); 
    for (int i = 0; i < radialSegments+1; i++) {
      x = r * cos(PI*(float(i)/float(radialSegments)));
      y = r * sin(-PI*(float(i)/float(radialSegments)));
      z = w/2;
      vertex(x, y, z);
      x = R * cos(PI*(float(i)/float(radialSegments)));
      y = R * sin(-PI*(float(i)/float(radialSegments)));
      z = w/2;
      vertex(x, y, z);
    }
    endShape();
    beginShape(QUAD_STRIP); 
    for (int i = 0; i < radialSegments+1; i++) {
      x = r * cos(PI*(float(i)/float(radialSegments)));
      y = r * sin(-PI*(float(i)/float(radialSegments)));
      z = -w/2;
      vertex(x, y, z);
      x = R * cos(PI*(float(i)/float(radialSegments)));
      y = R * sin(-PI*(float(i)/float(radialSegments)));
      z = -w/2;
      vertex(x, y, z);
    }
    endShape();
    popMatrix();
  }

  void drawHollowCillinder(float X, float Y, float r, float R, color c) {
    float x, y, z;
    pushMatrix();
    scale(sc);
    rotateY(angle);
    translate(X, Y);
    fill(c);
    noStroke();
    beginShape(QUAD_STRIP); 
    for (int i = 0; i < radialSegments+1; i++) {
      x = r * cos(2*PI*(float(i)/float(radialSegments)));
      y = r * sin(2*PI*(float(i)/float(radialSegments)));
      z = -w/2;
      vertex(x, y, z);
      x = r * cos(2*PI*(float(i)/float(radialSegments)));
      y = r * sin(2*PI*(float(i)/float(radialSegments)));
      z = w/2;
      vertex(x, y, z);
    }
    endShape();
    beginShape(QUAD_STRIP); 
    for (int i = 0; i < radialSegments+1; i++) {
      x = R * cos(2*PI*(float(i)/float(radialSegments)));
      z = -w/2;
      y = R * sin(2*PI*(float(i)/float(radialSegments)));
      vertex(x, y, z);
      x = R * cos(2*PI*(float(i)/float(radialSegments)));
      z = w/2;
      y = R * sin(2*PI*(float(i)/float(radialSegments)));
      vertex(x, y, z);
    }
    endShape();
    beginShape(QUAD_STRIP); 
    for (int i = 0; i < radialSegments+1; i++) {
      x = r * cos(2*PI*(float(i)/float(radialSegments)));
      z = -w/2;
      y = r * sin(2*PI*(float(i)/float(radialSegments)));
      vertex(x, y, z);
      x = R * cos(2*PI*(float(i)/float(radialSegments)));
      z = -w/2;
      y = R * sin(2*PI*(float(i)/float(radialSegments)));
      vertex(x, y, z);
    }
    endShape();
    beginShape(QUAD_STRIP); 
    for (int i = 0; i < radialSegments+1; i++) {
      x = r * cos(2*PI*(float(i)/float(radialSegments)));
      z = w/2;
      y = r * sin(2*PI*(float(i)/float(radialSegments)));
      vertex(x, y, z);
      x = R * cos(2*PI*(float(i)/float(radialSegments)));
      z = w/2;
      y = R * sin(2*PI*(float(i)/float(radialSegments)));
      vertex(x, y, z);
    }
    endShape();
    popMatrix();
  }
}
