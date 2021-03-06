
class Player {
  
  color fillColor = color(45,130,40);          // what color are you?
  final int diameter = 200;                    // size of player onscreen
  final float speed = 10.0;                    // multiply sensor reading for faster movement
  
  final float visionDist = width/3;            // how far can we see (in pixels, when obstacles are visible)
  float x, y;                                  // position onscreen (x set as arg, y hardcoded to bottom of screen)
  final int radius = diameter/2;               // for easier collision detection
  boolean hitWall = false;                     // are we hitting the side of the screen?
  final float maxRollVol = 0.5;                // maximum volume for rolling sound when moving

  Player (float _x) {
    x = _x;
    y = height-diameter-20;           // set along bottom of screen
  }

  // update position on tilt
  void move() {
    if (accelData != null) {
      x -= accelData[0] * speed;
      if (x + radius > width) {           // if off L side
        x = width-radius;
        if (!sideSound.isPlaying() && !hitWall) {
          sideSound.setVolume(0.1, 0.6);
          sideSound.start();
          hitWall = true;
        }
      }
      else if (x - radius < 0) {          // if off R side
        x = radius;
        if (!sideSound.isPlaying() && !hitWall) {
          sideSound.setVolume(0.6, 0.1);
          sideSound.start();
          hitWall = true;
        }
      }
      else {
        hitWall = false;
      }
    }

    // sound of player rolling across screen
    if (x > radius && x < width-radius) {                                 // don't play when against the wall
      float rollVol = map(abs(accelData[0]), 0, 10, 0.0, maxRollVol);     // map max volume to speed of rolling
      float L = map(x, radius, width-radius, rollVol, 0.0);
      float R =  map(x, radius, width-radius, 0.0, rollVol);
      rollSound.setVolume(L, R);                                          // pan
    }
    else {                                                                // if against side, set to silent
      rollSound.setVolume(0.0, 0.0);
    }
  }

  // display onscreen
  void display() {
    noStroke();
    fill(fillColor);
    ellipse(x, y, diameter, diameter);
  }
}

