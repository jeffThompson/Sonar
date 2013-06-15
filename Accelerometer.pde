
// when there's a new accel value, update the 'accelData' array
class SensorListener implements SensorEventListener {
  void onSensorChanged(SensorEvent event) {
    if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
      accelData = event.values;
    }
  }
  void onAccuracyChanged(Sensor sensor, int accuracy) {
    // nothing here, but this method is required for the code to work...
  }
}

