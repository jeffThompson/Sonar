
void loadSounds() {
  try {

    // filenames
    final String sonarSweepFilename = "330sine-165sine-440sine.wav";         // sonar sweep sound
    final String hitSoundFilename = "220sine-295sine-330sine.wav";           // sound when hitting an obstacle
    final String centerClickFilename = "centerClick.wav";                    // click at top of sonar sweep (if specified)
    final String sideSoundFilename = "sideSound_110sine-110sine.wav";        // sound when hitting side of screen
    final String bgSoundFilename = "bgLotsaRandom.wav";                      // background music/sound
    final String rollSoundFilename = "rollSound.wav";                        // for when the player moves

    // sonar sweep
    sonarSweep = new MediaPlayer();
    AssetManager assets = this.getAssets();
    AssetFileDescriptor fd = assets.openFd(sonarSweepFilename);
    sonarSweep.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    sonarSweep.prepare();

    // if specified, center click for sonar sweep
    centerClick = new MediaPlayer();
    assets = this.getAssets();
    fd = assets.openFd(centerClickFilename);
    centerClick.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    centerClick.prepare();

    // when hitting obstacle
    hitSound = new MediaPlayer();
    assets = this.getAssets();
    fd = assets.openFd(hitSoundFilename);
    hitSound.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    hitSound.prepare();

    // sound when hitting edge of screen
    sideSound = new MediaPlayer();
    assets = this.getAssets();
    fd = assets.openFd(sideSoundFilename);
    sideSound.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    sideSound.prepare();

    // background sound
    bgSound = new MediaPlayer();
    assets = this.getAssets();
    fd = assets.openFd(bgSoundFilename);
    bgSound.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    bgSound.prepare();

    // player moving sound
    rollSound = new MediaPlayer();
    assets = this.getAssets();
    fd = assets.openFd(rollSoundFilename);
    rollSound.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    rollSound.prepare();
  }

  // any errors?
  catch (IOException ioe) {
    println("Error (probably could not find/load the audio file - is it in the sketch's data folder?)");
    println(ioe);
  }
}

