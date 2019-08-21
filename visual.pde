class visual {
  String id;
  //translations
  int x, y;
  //scale and fade
  //fade is a number between 0 and 1 that will control the opacity
  float s, f;
  float width, height;
  
  boolean hasCamSettings;

  visual(String id, int x, int y, float s, float f, boolean hasCamSettings) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.s = s;
    this.f = f;
    this.hasCamSettings = hasCamSettings;
  }

  void feed(Boolean [] t) {
    //pass onto visuals
  }
  void show() {
    //iterate through elements and show
  }

  void addGui(ControlP5 cp5, int x, int y) {
  }

  void removeGui(ControlP5 cp5) {
  }
  
  void controlEvent(ControlEvent theEvent){
  }
  
  float[] getCamSettings(){
    float[] settings = new float[4];
    settings[0] = x/2;
    settings[1] = y/2;
    settings[2] = 0;
    settings[3] = 300;
    return settings;
  }
}
