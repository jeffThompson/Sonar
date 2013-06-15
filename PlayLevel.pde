
// normal gameplay (ie: non-title screen)
void playLevel() {

  background(0);
  
  // if enough time has passed, increase the # of obstacles
  if ((prevMillis + 30000) < millis() && numObstacles < maxObstacles) {
    numObstacles++;                                                       // increment count
    obstacles.add(new Obstacle(random(0, width), random(-height, 0)));    // add new obstacle
    prevMillis = millis();                                                // reset time
  }  

  // sonar scan (scanning itself run in TouchInteraction only when needed)
  if (showSonar) {
    if (scanEveryFrame) sonar.runScan();
    sonar.display();
  }

  // display player
  player.move();
  player.display();

  // display and display obstacles
  updateObstacleOrder();
  for (int i=obstacles.size()-1; i>=0; i-=1) {
    Obstacle obs = obstacles.get(i);
    obs.updatePosition();
    obs.testCollision();

    // if specified, display obstacles onscreen
    if (showObstacles) obs.display();

    // when offscreen, remove and make a new obstacle above
    if (obs.y > height + obs.diameter) {
      obstacles.remove(i);
      obstacles.add(new Obstacle(random(0, width), random(-height, 0)));
    }
  }
  
  // check if any obstacles are being hit: if none are, turn off sound
  anyHit = false;                                           // keep track of all obstacles
  for (Obstacle obs : obstacles) {
    if (obs.isHit) {
      anyHit = true;                                        // if one is hit, set main anyHit flag to true
      if (!collision.isPlaying) collision.collide(obs.x);   // if the collision isn't already going, start it passing the x position for panning
    }
  }
  if (!anyHit) collision.stopPlayback();                    // if we were playing but are now not hitting any obs, stop collision

  // if on, show some debugging info (FPS, etc)
  if (showDebug) {
    fill(255);
    noStroke();
    textFont(font);
    textAlign(LEFT, TOP);
    
    String info = "DEGUGGING INFO";
    info += "\nFPS: " + nf(frameRate, 0,2);
    info += "\n# OBS: " + numObstacles;
    text(info, 50, 50);
  }
}
