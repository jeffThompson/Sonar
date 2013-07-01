
class SonarObj {

  final int noteDuration = 5;              // in milliseconds
  final int radius = 200;                  // how far the visuals extend from player
  final boolean playCenterClick = true;    // play a sound at top of sweep
  final int displayStep = 2;               // ie scan resolution; how many lines to show (1 = all, 2 = every other, etc)
  final int lineWidth = 5;                 // width of scan lines

  boolean isPlaying = false;
  float[] scan = new float[180];
  final int scanLen = scan.length;

  SonarObj () {
    // nothing to do here :)
  }

  // scan for obstacles
  void runScan() {

    // iterate all obstacles, get data
    for (int i=0; i<scanLen; i++) {
      scan[i] = 0;
    }
    for (Obstacle obs : obstacles) {
      for (int i=int(degrees(obs.angleLeft)); i<int(degrees(obs.angleRight)); i++) {
        try {
          scan[i] = max(obs.colorDist, scan[i]);
        }
        catch (ArrayIndexOutOfBoundsException aioobe) {
          // skip if out of range
        }
      }
    }
  }

  // draw scan onscreen
  // note: this seems to be a cause of the sketch slowing down (removing push/pop in the for loop helps)
  void display() {
    pushMatrix();
    translate(player.x, player.y);
    rotate(PI);
    for (int i=0; i<scanLen; i+=displayStep) {
      rotate(radians(displayStep));
      stroke(scan[i]);
      strokeWeight(lineWidth);
      line(0, 0, radius, 0);
    }
    popMatrix();
  }
}

// play the sonar sound
void playSweep() {
  sonar.isPlaying = true;
  float amp, panL, panR;

  if (!sonarSweep.isPlaying()) sonarSweep.start();
  sonarSweep.seekTo(0);

  for (int i=0; i<sonar.scanLen; i++) { 

    // very high click in the middle
    if (sonar.playCenterClick && i == 90) {
      centerClick.setVolume(0.8, 0.8);   // volume for center click
      centerClick.seekTo(0);             // play audio
      delay(100);                        // set time for click (best if a little longer than the rest of the sonar)
      centerClick.pause();               // stop audio
    }

    // regular sweep
    else {
      amp = map(sonar.scan[i], 255, 0, 1.0, 0.03);    // just a little sound for no objects (easier to hear the pan)
      panL = map(i, 0, sonar.scanLen-1, 1.0, 0.0);    // set panning based on position in array
      panR = map(i, 0, sonar.scanLen-1, 0.0, 1.0);
      sonarSweep.setVolume(panL*amp, panR*amp);
      delay(sonar.noteDuration);
    }
  }

  if (sonarSweep.isPlaying()) sonarSweep.pause();
  sonar.isPlaying = false;
}

