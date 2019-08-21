import ddf.minim.analysis.*;
import ddf.minim.*;

class BeatTrigger {
  Minim minim;
  AudioInput in;
  FFT fft;

  int bands = 256;
  //float[] spectrum = new float[bands];
  int bandsToAnalyze = 10;
  int triggerAmount = 5;
  int bandHistSize = 200;
  float[][] bandHist = new float [bandsToAnalyze][bandHistSize];
  float[] histSum = new float [bandsToAnalyze];
  float[] histVarSum = new float [bandsToAnalyze];
  float[] histAvg = new float [bandsToAnalyze];
  float[] histVar = new float [bandsToAnalyze];
  float[] histMax = new float [bandsToAnalyze];

  int bandCutOff;
  int upperBandLim;

  Boolean[] triggers = new Boolean [triggerAmount];
  float[] triggerBins = new float [triggerAmount];
  float[][] triggerConfig = new float[triggerAmount][bandsToAnalyze];
  int[] triggerConfigSums = new int[triggerAmount];
  float[] sensitivity = new float [triggerAmount];
  int sensCurrentSelection = 0;
  float sensitivityResetVal = 1.8;

  Boolean smoothing;
  float smoothingFac;

  BeatTrigger(PApplet p) {
    minim = new Minim(p);
    in = minim.getLineIn(Minim.STEREO, 1024);
    fft = new FFT(in.bufferSize(), in.sampleRate());

    for (int i = 0; i < bandsToAnalyze; i++)
    {
      this.histSum[i] = 0;
      this.histVarSum[i] = 0;
      this.histAvg[i] = 0;
      this.histVar[i] = 0;
      this.histMax[i] = 0;
      for (int j = 0; j < bandHistSize; j++)
      {
        this.bandHist[i][j] = 0;
      }
    }
    for (int i = 0; i < triggerAmount; i++)
    {
      this.triggers[i] = false;
      this.triggerBins[i] = 0;
      this.sensitivity[i] = sensitivityResetVal;
      for (int j = 0; j < bandsToAnalyze; j++)
      {
        triggerConfig[i][j] = 0;
      }
      this.triggerConfigSums[i] = 0;
    }
    bandCutOff = 0;
    smoothing = false;
    smoothingFac = 0.2;
  }

  void setTriggerConfig(float[][] triggerArray) {
    this.triggerConfig = triggerArray;
    for (int i = 0; i < triggerAmount; i++)
    {
      triggerConfigSums[i] = 0;
      for (int j = 0; j < bandsToAnalyze; j++)
      {
        triggerConfigSums[i] += triggerConfig[i][j];
      }
    }
  }

  void analyze() {
    float A;
    float sum, sumVar;
    fft.forward(in.mix);

    this.upperBandLim = this.bandHistSize - this.bandCutOff;

    for (int i = 0; i < bandsToAnalyze; i++)
    {
      A = fft.getBand(i);
      sum = 0;
      sumVar = 0;
      for (int j = upperBandLim-1; j > 0; j--)
      {
        this.bandHist[i][j] = this.bandHist[i][j-1];
        sum += this.bandHist[i][j];
        sumVar += pow(histAvg[i]-this.bandHist[i][j], 2);
      }
      for (int j = upperBandLim; j < bandHistSize; j++)
      {
        this.bandHist[i][j] = 0;
      }
      if (A > this.histAvg[i]*2) this.histMax[i] = this.histAvg[i]*3;
      //forces re-maxing
      //this.histMax[i] *= 0.99;
      if (smoothing) this.bandHist[i][0] = this.bandHist[i][1] + smoothingFac*(A-this.bandHist[i][1]);
      if (!smoothing) this.bandHist[i][0] = A;
      this.histAvg[i] = sum/this.upperBandLim;
      this.histVar[i] = sqrt(sumVar/this.upperBandLim);
      triggerCollect();
      triggerEvaluate();
    }
  }

  Boolean [] getTriggers() {
    return this.triggers;
  }

  void triggerEvaluate() {
    for (int i = 0; i < triggerAmount; i++)
    {
      if (triggerBins[i] > sensitivity[i]) triggers[i] = true;
      else triggers[i] = false;
    }
  }

  void triggerCollect() {
    for (int i = 0; i < triggerAmount; i++)
    {
      this.triggerBins[i] = 0;
      for (int j = 0; j < bandsToAnalyze; j++)
      {
        //triggerBins[i] += triggerConfig[i][j] * max((fft.getBand(j)-(histAvg[j]+histVar[j]))/histMax[j], 0);
        triggerBins[i] += triggerConfig[i][j] * max((fft.getBand(j)-(histAvg[j]+histVar[j])), 0);
      }
      //calculate average
      triggerBins[i] = triggerBins[i]/triggerConfigSums[i];
    }
  }

  void show() {
  }

  void stop()
  {
    minim.stop();
  }

  void sensMenu() {
    textSize(10);
    for (int i = 0; i < sensitivity.length; i++)
    {
      fill(255);  
      text(sensitivity[i], 10, 10 + 10 * i);
    }
    stroke(50, 200, 200);
    noFill();
    rect(10, 10 * sensCurrentSelection, 50, 10);
  }
}
