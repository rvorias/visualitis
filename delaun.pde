import megamu.mesh.*;

class Delaun extends visual {
  int amountOfPoints = 50;

  float[][] origPoints = new float[amountOfPoints][2];
  float[][] points = new float[amountOfPoints][2];

  float wi, he;

  Delaunay myDelaunay;

  Slider delaunayElements;

  float noiseS = 0;
  float noiseInc = 0.01;
  Delaun(String id, int x, int y, float s, float f) {
    super(id, x, y, s, f, true); 
    this.wi = x;
    this.he = y;
    for (int i=0; i<amountOfPoints; i++)
    {
      origPoints[i][0] = random(x); // first point, x
      origPoints[i][1] = random(y); // first point, y
    }

    for (int i=0; i<5; i++)
    {
      t[i] = 100;
    }
  }

  float[] getCamSettings() {
    float[] settings = new float[4];
    settings[0] = this.wi/2;
    settings[1] = this.he/2;
    settings[2] = 0;
    settings[3] = 400;
    return settings;
  }

  void show() {
    background(0);
    morphPoints();
    updateDelaunay();
    noiseS += noiseInc;
    for (int i=0; i<5; i++)
    {
      t[i]+=0.1;
    }
  }

  void feed(Boolean [] t) {
    if (t[0]) {
      this.t[0] = 0;
    } else if (t[1]) {
      this.t[1] = 0;
    } else if (t[2]) {
      this.t[2] = 0;
    } else if (t[3]) {
      this.t[3] = 0;
    } else if (t[4]) {
      this.t[4] = 0;
    }
  }

  //GUI elements
  float amp = 20;
  float[] t = new float [5];
  float A = -0.8;
  float B = -10;
  boolean randomJigger = false;
  boolean radialJigger = !randomJigger;

  void morphPoints() {
    for (int i=0; i<amountOfPoints; i++)
    {
      this.points[i][0] = this.origPoints[i][0] + amp*(noise(origPoints[i][0]/amp+noiseS)-0.5);

      this.points[i][1] = this.origPoints[i][1] + amp*(noise(origPoints[i][1]/amp+noiseS)-0.5); // first point, y
      if (randomJigger) {
        if (i<amountOfPoints/5) {
          this.points[i][0] += random(-1, 1)*amp*cos(B*t[0])*exp(A*t[0]);
          this.points[i][1] += random(-1, 1)*amp*cos(B*t[0])*exp(A*t[0]);
        }
        if (i>amountOfPoints/5) {
          this.points[i][0] += random(-1, 1)*amp*cos(B*t[1])*exp(A*t[1])/3;
          this.points[i][1] += random(-1, 1)*amp*cos(B*t[1])*exp(A*t[1])/3;
        }
      }
      if (radialJigger) {
        if (i<amountOfPoints/5) {
          this.points[i][0] += (this.points[i][0]-this.wi/2)/amp*cos(B*t[0])*exp(A*t[0]);
          this.points[i][1] += (this.points[i][1]-this.he/2)/amp*cos(B*t[0])*exp(A*t[0]);
        }
        if (i>amountOfPoints/5 && i<amountOfPoints*2/5) {
          this.points[i][0] += (this.points[i][0]-this.wi/2)/amp*cos(B*t[1])*exp(A*t[1])/2;
          this.points[i][1] += (this.points[i][1]-this.he/2)/amp*cos(B*t[1])*exp(A*t[1])/2;
        }
        if (i>amountOfPoints*2/5 && i<amountOfPoints*3/5) {
          this.points[i][0] += (this.points[i][0]-this.wi/2)/amp*cos(B*t[1])*exp(A*t[2])/4;
          this.points[i][1] += (this.points[i][1]-this.he/2)/amp*cos(B*t[1])*exp(A*t[2])/4;
        }
        if (i>amountOfPoints*3/5 && i<amountOfPoints*4/5) {
          this.points[i][0] += (this.points[i][0]-this.wi/2)/amp*cos(B*t[1])*exp(A*t[3])/8;
          this.points[i][1] += (this.points[i][1]-this.he/2)/amp*cos(B*t[1])*exp(A*t[3])/8;
        }
        if (i>amountOfPoints*4/5 && i<amountOfPoints) {
          this.points[i][0] += (this.points[i][0]-this.wi/2)/amp*cos(B*t[1])*exp(A*t[4])/16;
          this.points[i][1] += (this.points[i][1]-this.he/2)/amp*cos(B*t[1])*exp(A*t[4])/16;
        }
      }
    }
  }

  void updateDelaunay() {
    this.myDelaunay = new Delaunay(this.points);
    float[][] myEdges = myDelaunay.getEdges();

    for (int i=0; i<myEdges.length; i++)
    {
      float startX = myEdges[i][0];
      float startY = myEdges[i][1];
      float endX = myEdges[i][2];
      float endY = myEdges[i][3];
      stroke(map((endY-startY)*(endY-startY)+(endX-startX)*(endX-startX), 0, 4000, 255, 0), 50, 60);
      strokeWeight(1);
      line( startX, startY, endX, endY );
    }
  }

  void addGui(ControlP5 cp5, int x, int y) {
    delaunayElements = cp5.addSlider("elements")
      .setPosition(x, y)
      .setSize(80, 18)
      .setRange(5, 1000)
      .setValue(amountOfPoints)
      ;
  }

  void removeGui(ControlP5 cp5) {
    cp5.remove("elements");
  }

  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(delaunayElements)) {
      this.amountOfPoints = int(delaunayElements.getValue());
      origPoints = new float[amountOfPoints][2];
      points = new float[amountOfPoints][2];
      this.wi = x;
    this.he = y;
    for (int i=0; i<amountOfPoints; i++)
    {
      origPoints[i][0] = random(wi); // first point, x
      origPoints[i][1] = random(he); // first point, y
    }
    }
  }
}
