
class Collision {
  boolean isPlaying = false;          // are we playing the collision right now?
  final int hitVibeIntensity = 60;    // 0 = none, 100 = a lot (really is duration in ms)

  Collision () {
    // nothing here!
  }

  void collide(float ox) {
    isPlaying = true;                    // set to true (avoids retriggering)
    vibe.vibrate(hitVibeIntensity);      // vibration for N ms

    // pan depending on side that is hit (softly with a little in the other channel)
    if (ox < player.x) hitSound.setVolume(0.6, 0.2);
    else hitSound.setVolume(0.2, 0.6);
    if (!hitSound.isPlaying()) hitSound.start();  
    hitSound.seekTo(0);
  }
  
  void stopPlayback() {
    if (hitSound.isPlaying()) hitSound.pause();
    isPlaying = false;
  }
}

