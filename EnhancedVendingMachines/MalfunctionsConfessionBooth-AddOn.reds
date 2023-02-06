module ConfessionBoothMalfunctions
// ConfessionBooth <- BasicDistractionDevice <- InteractiveDevice <- (skips) <- Device <-
// ConfessionBoothController <- BasicDistractionDeviceController <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// ConfessionBoothControllerPS <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@wrapMethod(ConfessionBooth) // <- BasicDistractionDevice <- InteractiveDevice <-
protected final func ResolveGameplayState() -> Void {
  wrappedMethod();
  this.RestartDevice();
  let settings = new EVMMenuSettings();
  let malfunctionRate: Int32 = settings.confessionBoothMalfunctionRate;
  if malfunctionRate == 0 { return; };
  let totalSum: Int32 = settings.confessionBoothStatic + settings.confessionBoothGlitch + settings.confessionBoothBroken;
  if totalSum == 0 { totalSum = 1; };
  let shortLimit = Cast<Float>(settings.confessionBoothGlitch) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0;
  let staticLimit = Cast<Float>(settings.confessionBoothStatic) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0 + shortLimit;
  let brokenLimit = Cast<Float>(settings.confessionBoothBroken) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0 + staticLimit;
  this.SetStartingMalfunction(shortLimit, staticLimit, brokenLimit);
}

// EVMSetupShortGlitchListener() & EVMShortGlitchEvent in Malfunctions_Dependencies.reds

@addMethod(ConfessionBooth) // <- BasicDistractionDevice <- InteractiveDevice <-
protected cb func OnEVMShortGlitchEvent(evt:ref<EVMShortGlitchEvent>) {
  if this.GetDevicePS().m_distractionTimeCompleted {
    let delaySystem = GameInstance.GetDelaySystem(this.GetGame());
    let callback = new EVMShortGlitchCallback();
    callback.machine = this;
    delaySystem.DelayCallback(callback, RandRangeF(2, 6), true);
  };
}

// EVMShortGlitchCallback in Malfunctions_Dependencies.reds

// provides some basic functionality when OnHit isnt installed.
@wrapMethod(ConfessionBooth) // <- BasicDistractionDevice <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Void { // hitEvents.script
  let devicePS = this.GetDevicePS();
  if !devicePS.moduleExistsAllMachinesOnHitEvent {
    if Equals(this.GetCurrentGameplayRole(), EGameplayRole.None) // if not assigned "Distract" role
    || Equals(devicePS.evmMalfunctionName, "broken") {
      return;
    };

    if Equals(devicePS.evmMalfunctionName, "static") {
      super.OnHitEvent(hit);
    } else {
      wrappedMethod(hit);
    };
  } else {
    wrappedMethod(hit);
  };
}

@wrapMethod(ConfessionBooth) // <- BasicDistractionDevice <- InteractiveDevice <-
protected func StartGlitching(glitchState:EGlitchState, opt intensity:Float) {
  wrappedMethod(glitchState, intensity);
  let devicePS = this.GetDevicePS();
  if devicePS.evmHacksRemaining <= 0 {
    devicePS.EVMUnregisterShortGlitchMalfunction();
    devicePS.evmMalfunctionName = "static";
  };
}

// called after OnQuickHackDistraction() and HackedEffect()
@wrapMethod(ConfessionBooth) // <- BasicDistractionDevice <- InteractiveDevice <-
protected func StopGlitching() {
  if this.GetDevicePS().evmHacksRemaining > 0 { wrappedMethod(); };
}