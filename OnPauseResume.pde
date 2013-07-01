
// when leaving the app...
void onPause() {
  sensorManager.unregisterListener(sensorListener);    // turn off sensor listener  

  sonarSweep.pause();                                  // pause all sound files
  centerClick.pause();
  hitSound.pause(); 
  bgSound.pause();
  sideSound.pause();
  rollSound.pause();
  fieldBeep.pause();

  super.onPause();                                     // pass along to main function
}

// when we return (run in try statement - appears can sometimes throw a npe)
void onResume() {
  super.onResume();

  // start up background and field sounds
  if (bgSound != null && !bgSound.isPlaying()) bgSound.start();
  if (beepWhenMoving && fieldBeep != null && !fieldBeep.isPlaying()) fieldBeep.start();

  // re-initialize the accelerometer
  sensorManager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);
  sensorListener = new SensorListener();
  accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  sensorManager.registerListener(sensorListener, accelerometer, SensorManager.SENSOR_DELAY_GAME);
}

