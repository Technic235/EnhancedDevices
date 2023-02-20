module EnhancedDevices.Malfunctions.Jukebox
import EnhancedDevices.Malfunctions.*
import EnhancedDevices.Settings.*

// Jukebox <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// JukeboxController <- (skips BasicDistractionDevice) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// JukeboxControllerPS <- (skips BasicDistractionDevice) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@wrapMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnTakeControl(ri:EntityResolveComponentsInterface) { // ResolveGameplayState() not defined on Jukebox, but OnTakeControl() is
  wrappedMethod(ri);
  this.RestartDevice();
  let settings = new EVMMenuSettings();
  let malfunctionRate: Int32 = settings.jukeboxMalfunctionRate;
  if malfunctionRate == 0 { return; };
  let totalSum: Int32 = settings.jukeboxStatic + settings.jukeboxGlitch + settings.jukeboxBroken;
  if totalSum == 0 { totalSum = 1; };
  let shortLimit = Cast<Float>(settings.jukeboxGlitch) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0;
  let staticLimit = Cast<Float>(settings.jukeboxStatic) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0 + shortLimit;
  let brokenLimit = Cast<Float>(settings.jukeboxBroken) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0 + staticLimit;
  this.SetStartingMalfunction(shortLimit, staticLimit, brokenLimit);
}

// EVMSetupShortGlitchListener() & EVMShortGlitchEvent in Malfunctions

@addMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnEVMShortGlitchEvent(evt:ref<EVMShortGlitchEvent>) { // custom event
  if this.GetDevicePS().m_distractionTimeCompleted {
    let delaySystem = GameInstance.GetDelaySystem(this.GetGame());
    let callback = new EVMShortGlitchCallback();
    callback.machine = this;
    delaySystem.DelayCallback(callback, RandRangeF(2, 6), true);
  };
}

// EVMShortGlitchCallback in Malfunctions

@wrapMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func StartGlitching(glitchState:EGlitchState, opt intensity:Float) { // defined on Jukebox
  wrappedMethod(glitchState, intensity);
  let devicePS = this.GetDevicePS();
  if devicePS.evmHacksRemaining <= 0 {
    devicePS.EVMUnregisterShortGlitchMalfunction();
    devicePS.evmMalfunctionName = "static";
  };
}

// called after OnQuickHackDistraction() and HackedEffect()
@wrapMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func StopGlitching() { // defined on Jukebox
  if this.GetDevicePS().evmHacksRemaining > 0 { wrappedMethod(); };
}

// provides some basic functionality when OnHit isnt installed.
@if(!ModuleExists("EnhancedDevices.OnHit.Jukebox"))
@wrapMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) { // defined on Device
  if this.IsA(n"Jukebox") {
    let devicePS = this.GetDevicePS();
    if Equals(this.GetCurrentGameplayRole(), EGameplayRole.None) // if not assigned "Distract" role
    || Equals(devicePS.evmMalfunctionName, "broken") {
      return;
    };

    wrappedMethod(hit); // triggers security but doesn't cancel glitching
    if devicePS.evmHacksRemaining > 0 {
      this.StartShortGlitch();
    };
    if RandRangeF(0, 10) < 1.0 {
      GameObject.PlaySoundEvent(this, devicePS.GetGlitchSFX());
    };
  } else {
    wrappedMethod(hit);
  };
}