
import android.view.MotionEvent;                      // required imports for fancy touch access
import android.content.Context;
import android.hardware.Sensor;                       // reading sensor data
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Vibrator;                           // vibration
import android.media.*;                               // audio playback
import android.content.res.*;
import android.media.AudioTrack;
import android.view.inputmethod.InputMethodManager;   // keyboard
import java.util.*;                                   // sorting ArrayLists

/*
SONAR
 Jeff Thompson | 2013 | www.jeffreythompson.org
 
 Created with generous support from Harvestworks' Cultural Innovation Fund program.
 
 TO DO - TOP PRIORITY
 + drawing the sonar scan is slowing things down, grrr (multiple push/pop? just too much? - reducing the # of lines helps)
 + deflect obstacles when hit? deflect you?
 
 TO DO - THINK/TRY
 + modes (randomly chosen at startup? after a certain # of interactions?):
     where the more you hit the more obs, they go faster but get smaller
     where the more that you don't hit and reach the end means more and faster
     the more you hit the larger they get
     the stiller you are the faster they go
 
 Keyboard adjustments:
 + O = obstacle visibility (default off)
 + S = sonar scan visibility (default on)
 + D = debug info (default off)
 + E = scan every frame (default on)
 + M = background sound (default on)
 + B = toggle move beeps (default on)
 + 1-9 = set # of obstacles onscreen (starts at 3, increases over time)
 
 Required permissions:
 + VIBRATE
 
 */

int numObstacles = 3;               // at a time, increases over time
final int maxObstacles = 30;        // max # of obstacles
final float levelSpeed = 3.0;       // vertical movement (multiplier for tilt control)

boolean showObstacles = false;      // 'o' to toggle
boolean showSonar = true;           // 's' to toggle
boolean showDebug = false;          // 'd' to show debug info (framerate, # obs, etc)
boolean scanEveryFrame = true;      // 'e' to toggle scanning sonar every frame (may cause lagging)
boolean beepWhenMoving = true;      // 'b' to toggle beeping when moving

Player player;
SonarObj sonar;
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
Field field;
Collision collision;
boolean introScreen = true;        // show intro screen? touch to release and play
boolean anyHit = false;

SensorManager sensorManager;       // keep track of sensor
SensorListener sensorListener;     // special class for noting sensor changes
Sensor accelerometer;              // Sensor object for accelerometer
float[] accelData;                 // x,y,z sensor data

Vibrator vibe;                                                                            // vibration motor
MediaPlayer sonarSweep, centerClick, hitSound, sideSound, bgSound, rollSound, fieldBeep;  // sound files

PFont font;          // font for info
PImage titleImage;   // title image (clearer and more flexible about font choice)
long prevMillis;     // keep track of time to increment the # of obstacles onscreen


void setup() {

  // basic setup
  orientation(LANDSCAPE);
  //frameRate(24);          // clamp framerate (prevents slowing noticeably)

  // initialize vibration and sounds
  vibe = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
  loadSounds();

  // create player, sonar, obstacles, and background field
  player = new Player(width/2);            // starting x position (y set in class - just above bottom)
  sonar = new SonarObj();
  collision = new Collision();
  for (int i=0; i<numObstacles; i++) {
    obstacles.add(new Obstacle(random(0, width), random(-height, 0)));
  }
  field = new Field();

  // font stuff
  font = createFont("Sans-Serif", height/36);
  textAlign(CENTER, CENTER);

  // start playing background sound
  bgSound.start();
  bgSound.setLooping(true);
  bgSound.setVolume(0.15, 0.15);

  // start rolling sound
  rollSound.start();
  rollSound.setLooping(true);
  rollSound.setVolume(0.0, 0.0);

  // load title
  titleImage = loadImage("TitleScreen.png");
}

void draw() {
  if (introScreen) displayIntro();
  else playLevel();
}

