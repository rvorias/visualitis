class pillar_img extends visual {
  PImage[] img = new PImage[7];
  int imgIndex;

  pillar_img(String id, int x, int y, float s, float f) {
    super(id, x, y, s, f, true); 
    img[0] = loadImage("pillar_0000.png");
    img[1] = loadImage("pillar_0001.png");
    img[2] = loadImage("pillar_0010.png");
    img[3] = loadImage("pillar_0100.png");
    img[4] = loadImage("pillar_0110.png");
    img[5] = loadImage("pillar_1001.png");
    img[6] = loadImage("pillar_1111.png");
    imgIndex = 0;
  }

  void feed(Boolean [] t) {
    if (t[0] && t[1] && t[2]) {
      imgIndex = 4;
    } else if (t[0] && t[1]) {
      imgIndex = 5;
    } else if (t[0]){
      imgIndex = 6;
    }
    else {
      imgIndex = 0;
    }
  }
  
  void show() {
    background(0);
    image(img[imgIndex], 0, 0);
  }
  
  float[] getCamSettings(){
    float[] settings = new float[4];
    settings[0] = x/2+70;
    settings[1] = y/2-20;
    settings[2] = x/2;
    settings[3] = 120;
    return settings;
  }
}
