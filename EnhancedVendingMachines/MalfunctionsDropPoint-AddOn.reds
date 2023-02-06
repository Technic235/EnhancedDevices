module DropPointMalfunctions
// DropPoint <- BasicDistractionDevice <- InteractiveDevice <- (skips) <- Device <-
// DropPointController <- BasicDistractionDeviceController <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// DropPointControllerPS <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@wrapMethod(DropPoint) // <- BasicDistractionDevice <- InteractiveDevice <-
protected final func ResolveGameplayState() -> Void {
  wrappedMethod();
  this.RestartDevice();
  let settings = new EVMMenuSettings();
  let malfunctionRate: Int32 = settings.dropPointMalfunctionRate;
  if malfunctionRate == 0 { return; };
  let totalSum: Int32 = settings.dropPointStatic + settings.dropPointGlitch + settings.dropPointBroken;
  if totalSum == 0 { totalSum = 1; };
  let shortLimit = Cast<Float>(settings.dropPointGlitch) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0;
  let staticLimit = Cast<Float>(settings.dropPointStatic) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0 + shortLimit;
  let brokenLimit = Cast<Float>(settings.dropPointBroken) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0 + staticLimit;
  this.SetStartingMalfunction(shortLimit, staticLimit, brokenLimit);
}

// EVMSetupShortGlitchListener() & EVMShortGlitchEvent in Malfunctions_Dependencies.reds

@addMethod(DropPoint) // <- BasicDistractionDevice <- InteractiveDevice <-
protected cb func OnEVMShortGlitchEvent(evt:ref<EVMShortGlitchEvent>) {
  if this.GetDevicePS().m_distractionTimeCompleted {
    let delaySystem = GameInstance.GetDelaySystem(this.GetGame());
    let callback = new EVMShortGlitchCallback();
    callback.machine = this;
    delaySystem.DelayCallback(callback, RandRangeF(2, 6), true);
  };
}

// EVMShortGlitchCallback in Malfunctions_Dependencies.reds

@wrapMethod(DropPoint) // <- BasicDistractionDevice <- InteractiveDevice <-
protected func StartGlitching(glitchState:EGlitchState, opt intensity:Float) {
  wrappedMethod(glitchState, intensity);
  let devicePS = this.GetDevicePS();
  if devicePS.evmHacksRemaining < 0 { // changed "<= 0" to "< 0" since two hacks are subtracted per hack
    devicePS.EVMUnregisterShortGlitchMalfunction();
    devicePS.evmMalfunctionName = "static";
  };
}

@wrapMethod(DropPoint) // <- BasicDistractionDevice <- InteractiveDevice <-
protected func StopGlitching() {
  if this.GetDevicePS().evmHacksRemaining >= 0 { wrappedMethod(); };
  // changed '> 0'  to '>= 0' becuz 2 hacks are being subtracted instead of 1 since cb func OnQuickHackDistraction() is on both BasicDistractionDevice and Device
}