# visualitis - Reactive Audiovisuals in Processing

This program analyzes an audio-stream in realtime and produces various generative visuals.

The main screen serves a couple purposes:

- show audio information
- fine-tune and control the beat analyzer module
- select a `visual` object
- shows adaptive controls per `visual` class.

Each `visual` object listens to five beat detections. Each beat detection can be set to listen to certain FFT bins.
For example, the main beat listens to the lowest frequency FFT bin. 
Depending on which of the five beat detections is triggered, different elements in a `visual` object can be activated.