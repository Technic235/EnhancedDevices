module EnhancedDevices.Malfunctions.TravelTerminal
import EnhancedDevices.Malfunctions.*
import EnhancedDevices.Settings.*

// DataTerm <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// DataTermController <- (skips BasicDistractionDevice) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// DataTermControllerPS <- (skips BasicDistractionDevice) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@wrapMethod(DataTerm) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected final func ResolveGameplayState() -> Void {
  wrappedMethod();
  this.RestartDevice();
  this.machineType = n"DataTermController";
  let settings = new EVMMenuSettings();
  let malfunctionRate: Int32 = settings.travelTerminalMalfunctionRate;
  if malfunctionRate == 0 { return; };
  let totalSum: Int32 = settings.travelTerminalStatic + settings.travelTerminalGlitch + settings.travelTerminalBroken;
  if totalSum == 0 { totalSum = 1; };
  let shortLimit = Cast<Float>(settings.travelTerminalGlitch) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0;
  let staticLimit = Cast<Float>(settings.travelTerminalStatic) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0 + shortLimit;
  let brokenLimit = Cast<Float>(settings.travelTerminalBroken) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0 + staticLimit;
  this.SetStartingMalfunction(shortLimit, staticLimit, brokenLimit);
}

// EVMSetupShortGlitchListener() & EVMShortGlitchEvent in Malfunctions

@addMethod(DataTerm) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnEVMShortGlitchEvent(evt:ref<EVMShortGlitchEvent>) {
  if this.GetDevicePS().m_distractionTimeCompleted {
    let delaySystem = GameInstance.GetDelaySystem(this.GetGame());
    let callback = new EVMShortGlitchCallback();
    callback.machine = this;
    delaySystem.DelayCallback(callback, RandRangeF(2, 6), true);
  };
}

// EVMShortGlitchCallback in Malfunctions

@wrapMethod(DataTerm) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func StartGlitching(glitchState:EGlitchState, opt intensity:Float) {
  wrappedMethod(glitchState, intensity);
  let devicePS = this.GetDevicePS();
  if devicePS.evmHacksRemaining <= 0 {
    devicePS.EVMUnregisterShortGlitchMalfunction();
    devicePS.evmMalfunctionName = "static";
  };
}

// called after OnQuickHackDistraction() and HackedEffect()
@wrapMethod(DataTerm) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func StopGlitching() {
  if this.GetDevicePS().evmHacksRemaining > 0 { wrappedMethod(); };
}

// provides some basic functionality when OnHit isnt installed.
@if(!ModuleExists("EnhancedDevices.OnHit.TravelTerminal"))
@wrapMethod(DataTerm) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Void { // hitEvents.script
  let devicePS = this.GetDevicePS();
  if Equals(this.GetCurrentGameplayRole(), EGameplayRole.None) // if not assigned "Distract" role
  || Equals(devicePS.evmMalfunctionName, "broken") {
    this.StartHoloFlicker();
    return;
  };

  if Equals(devicePS.evmMalfunctionName, "static") {
    this.StartHoloFlicker();
    super.OnHitEvent(hit);
  } else {
    wrappedMethod(hit);
  };
}