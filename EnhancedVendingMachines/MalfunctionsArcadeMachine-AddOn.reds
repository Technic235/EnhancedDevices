module ArcadeMachineMalfunctions
// PachinkoMachine <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// PachinkoMachineController <- ArcadeMachineController <- (skips BasicDistractionDeviceController) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// PachinkoMachineControllerPS <- ArcadeMachineControllerPS <- (BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@wrapMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected final func ResolveGameplayState() -> Void {
  wrappedMethod();
  this.RestartDevice();
  let settings = new EVMMenuSettings();
  let malfunctionRate: Int32 = settings.arcadeMachineMalfunctionRate;
  if malfunctionRate == 0 { return; };
  let totalSum: Int32 = settings.arcadeMachineStatic + settings.arcadeMachineGlitch + settings.arcadeMachineBroken;
  if totalSum == 0 { totalSum = 1; };
  let shortLimit = Cast<Float>(settings.arcadeMachineGlitch) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0;
  let staticLimit = Cast<Float>(settings.arcadeMachineStatic) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0 + shortLimit;
  let brokenLimit = Cast<Float>(settings.arcadeMachineBroken) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0 + staticLimit;
  this.SetStartingMalfunction(shortLimit, staticLimit, brokenLimit);
}

// EVMSetupShortGlitchListener() & EVMShortGlitchEvent in Malfunctions_Dependencies.reds

// gives machines a repeating short glitch effect, which all machines can acquire
@addMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnEVMShortGlitchEvent(evt:ref<EVMShortGlitchEvent>) {
  if this.GetDevicePS().m_distractionTimeCompleted {
    let delaySystem = GameInstance.GetDelaySystem(this.GetGame());
    let callback = new EVMShortGlitchCallback();
    callback.machine = this;
    delaySystem.DelayCallback(callback, RandRangeF(2, 6), true);
  };
}

// EVMShortGlitchCallback in Malfunctions_Dependencies.reds

// EVMSetupArcadeStaticGlitchListener() & EVMArcadeStaticGlitchEvent in DependenciesShared.reds

// prevents arcade machines from sparking before the current spark FX loop is finished
@addMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnEVMArcadeStaticGlitchEvent(evt:ref<EVMArcadeStaticGlitchEvent>) {
  let delaySystem = GameInstance.GetDelaySystem(this.GetGame());
  let callback = new EVMDelayArcadeStaticGlitchCallback();
  callback.machine = this;
  delaySystem.DelayCallback(callback, RandRangeF(0, 10), true); // randomize start times
}

class EVMDelayArcadeStaticGlitchCallback extends DelayCallback {
  let machine: ref<ArcadeMachine>;
  protected func Call() -> Void {
    this.machine.EVMStartArcadeStaticGlitch();
  }
}

// Bool evmSparkActive, EVMStartArcadeStaticGlitch(), & EVMArcadeStaticGlitchCompletedCallback in Shared Dependencies

@wrapMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func StartGlitching(glitchState:EGlitchState, opt intensity:Float) { // works on PachinkoMachine also?
  wrappedMethod(glitchState, intensity);
  let devicePS = this.GetDevicePS();
  if devicePS.evmHacksRemaining <= 0 {
    devicePS.EVMUnregisterShortGlitchMalfunction();
    devicePS.evmMalfunctionName = "static";
  };
}

// called after OnQuickHackDistraction() and HackedEffect()
@wrapMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func StopGlitching() { // works on PachinkoMachine also
  if this.GetDevicePS().evmHacksRemaining > 0 { wrappedMethod(); };
}