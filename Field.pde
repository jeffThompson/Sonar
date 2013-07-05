
class Field {
  final int numDotsWide = 20;                // # of dots across (will be the same vertically)
  final int diameter = 5;                    // size to draw the dots
  final color fillColor = color(255);        // dot color
  final int trans = 100;                     // dot transparency
  final int maxBeepSpeed = 800;              // slowest (longest interval between beeps) in ms
  final int minBeepSpeed = 70;               // fastest (also in ms)

  float y = 0.0;                             // y position of top row (will move and reset)
  float speed = 0.0;                         // sets to speed of obstacles
  final int spacing = width/numDotsWide;     // spacing of the dots
  boolean isBeeping = false;                 // play the beep? toggled with 'B'
  long prevMillis;                           // previous time the beep started
  int beepInterval;                          // time between beeps (set by speed)

  Field() {
    fieldBeep.setVolume(0.03, 0.03);    // set volume, for convenience and so I can find it again later :)
    prevMillis = millis();
  }

  void update() {
    if (accelData[1] > 0) speed = (accelData[1] * levelSpeed) + levelSpeed;   // same as obstacles 
    y += speed;
    if (y > height) y = 0;

    // play beeping sound
    if (beepWhenMoving) {
      beepInterval = int(map(speed, 0, 30, maxBeepSpeed, minBeepSpeed));    // set interval based on current speed
      if (millis() > prevMillis + beepInterval) {
        if (fieldBeep.isPlaying()) fieldBeep.seekTo(0);
        else fieldBeep.start();
        prevMillis = millis();
      }
    }
  }

  void display() {
    noStroke();
    fill(fillColor, trans);
    for (int ty = -height; ty < height; ty += spacing) {
      for (int tx = 0; tx < width; tx += spacing) {
        if (ty + y >= height-height/2) fill(fillColor, map(ty+y, height-height/2,height, trans, 0));    // fade dots to black at bottom
        ellipse(tx + spacing/2, ty + y, diameter, diameter);
      }
    }
  }
}
