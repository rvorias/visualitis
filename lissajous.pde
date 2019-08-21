class Lissa extends visual {

  int verticalDetail = 1000;

  float[] sineHC = new float[verticalDetail];
  float[] cosHC = new float[verticalDetail];

  /* Scale image and reduce by 10 pixels to remove from edge of screen */
  int AX, BX;

  /* Try different values for a & b */
  // eg a=1, b=3; a=1, b=2; a = 3, b = 4; a=9, b=8; 

  float a = 1.79;
  float b = 1.8;
  float delta = PI/2;

  float x, y;
  float t=10;
  float inc_t = 0.05;

  float term = verticalDetail/(2*PI);

  int wi, he;
  
  int beatCntr = 0;
  
  float colorP = 180;

  Lissa(String id, int x, int y, float s, float f) {
    super(id, x, y, s, f, true); 
    this.wi = x;
    this.he = y;

    AX = (x/2) - 10;
    BX = (y/2) - 10;

    //smooth();
    fill(255);

    for (int i=0; i<verticalDetail; i++) {
      sineHC[i] = sin(2*PI*i/verticalDetail);
      cosHC[i] = sin(2*PI*i/verticalDetail+PI/2.0);
    }
  }

  void show() {
    // background(0);
    strokeWeight(5);
    stroke((sin(t/colorP)+1)/2*255, (sin(t/colorP+PI/3)+1)/2*255, (sin(t/colorP+PI/5)+1)/2*255);;
    for (int i = 0; i < 100; i++) {
      x = AX*sineHC[int((a*(t+inc_t*i) + delta)*term)%verticalDetail] + wi/2;
      y = BX*sineHC[int((b*(t+inc_t*i))*term)%verticalDetail] + he/2;  
      point(x, y);
    }

    t = t+inc_t*100;
    delta = delta+0.001;
    a = a + 0.0001;
  }

  void feed(Boolean [] t) {
    if (t[0]) {
      beatCntr++;
      if (beatCntr == 16){
        beatCntr = 0;
        background(0);
      }
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
