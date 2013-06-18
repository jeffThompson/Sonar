
// when leaving the app...
void onPause() {
  sensorManager.unregisterListener(sensorListener);    // turn off sensor listener  

    sonarSweep.pause();                                  // pause all sound files
  centerClick.pause();
  hitSound.pause(); 
  bgSound.pause();
  sideSound.pause();
  rollSound.pause();

  super.onPause();                                     // pass along to main function
}

// when we return (run in try statement - appears can sometimes throw a npe)
void onResume() {
  try {
    super.onResume();

    // start up background sound
    if (!bgSound.isPlaying()) bgSound.start();

    // re-initialize the accelerometer
    sensorManager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);
    sensorListener = new SensorListener();
    accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
    sensorManager.registerListener(sensorListener, accelerometer, SensorManager.SENSOR_DELAY_GAME);
  }
  catch (Exception e) {
    e.printStackTrace();
  }
}

