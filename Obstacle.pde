
class Obstacle {
  final int diameter = width/10;                // size of obstacle (circle)
  float x, y, leftX, leftY, rightX, rightY;     // position variables
  float angleCenter, angleLeft, angleRight;     // angle variables
  float dist;                                   // distance to player
  int colorDist;                                // distance scaled from 0-255
  final int radius = diameter/2;                // easier version for collision detection
  boolean isHit = false;                        // is the player currently hitting the obstacle?

  Obstacle (float _x, float _y) {
    x = _x;
    y = _y;
  }

  // update vertical position, angle, and distance
  void updatePosition() {
    if (accelData[1] > 0) y += (accelData[1] * levelSpeed) + levelSpeed;   // move using tilt forward  (always move at least a little bit)
    else y += levelSpeed;
    
    dist = dist(x, y, player.x, player.y);                      // find distance from player
    colorDist = int(map(dist, 0, player.visionDist, 255, 0));   // get into color range (0-255)
    colorDist = constrain(colorDist, 0, 255);                   // clamp to 0-255

    angleCenter = atan2(y-player.y, x-player.x);                // get the angle to center of object

    leftX = x + radius * cos(angleCenter-HALF_PI);              // trig! get angle to L/R for the full scan size (tells us how close we are)
    leftY = y + radius * sin(angleCenter-HALF_PI);
    angleLeft = atan2(player.y - leftY, player.x - leftX);

    rightX = x + radius * cos(angleCenter+HALF_PI);
    rightY = y + radius * sin(angleCenter+HALF_PI);
    angleRight = atan2(player.y - rightY, player.x - rightX);
  }

  // check for collision with player
  void testCollision() {
    if (dist < radius + player.radius) {
      isHit = true;
    }
    else {
      isHit = false;
    }
  }

  // draw onscreen
  void display() {
    noStroke();
    fill(255,150,0, map(dist, 0, player.visionDist, 255, 0));    // vary transparency with distance
    ellipse(x, y, diameter, diameter);
  }

  // return angle in degrees (required for sorting clockwise)
  int getAngleInDegrees() {
    return int(degrees(angleCenter));
  }
}

// sort by order clockwise (for sonar beeps!)
void updateObstacleOrder() {
  Collections.sort(obstacles, new Comparator<Obstacle>() {
    @Override public int compare(Obstacle o1, Obstacle o2) {
      return int(o1.getAngleInDegrees() - o2.getAngleInDegrees());
    }
  });
}
