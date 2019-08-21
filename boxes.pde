class boxes1 extends visual {
  float[] a = new float[5];

  boxes1(String id, int x, int y, float s, float f) {
    super(id, x, y, s, f, false);
    for (int i = 0; i < a.length; i++) {
      a[i] = 150;
    }
  }

  void show() {
    background(0);
    translate(x, y);
    for (int i = 0; i < a.length; i++)
    {
      fill(80, 50, 255, a[i]);
      box((i+1)*150);
      fill(100, 50, 0, a[i]);
      box((i+1)*151);
      a[i] *= 0.6;
    }
  }

  void feed(Boolean [] t) {
    for (int i = 0; i < t.length; i++)
    {
      if (i == 0) {
        if (t[i]) {
          a[i] = 200;
        }
      }
      if (i == 1) {
        if (t[i]) {
          a[i] = 150;
        }
      }
      if (i == 2) {
        if (t[i]) ;
        if (t[i]) {
          a[i] = 150;
        }
      }
      if (i == 3) {
        if (t[i]) {
          a[i] = 150;
        }
      }
      if (i == 4) {
        if (t[i]) {
          a[i] = 150;
        }
      }
    }
  }
}
