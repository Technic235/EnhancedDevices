module EnhancedDevices.OnHit.Jukebox
import EnhancedDevices.Settings.*

// Jukebox <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// JukeboxController <- (skips BasicDistractionDevice) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// JukeboxControllerPS <- (skips BasicDistractionDevice) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@wrapMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) {
  if Equals(this.m_controllerTypeName, n"JukeboxController") {
    let devicePS = this.GetDevicePS();
    if Equals(this.GetCurrentGameplayRole(), EGameplayRole.None)
    || Equals(devicePS.evmMalfunctionName, "broken") {
      return;
    };

    let settings = new EVMMenuSettings();
    if Equals(settings.onHitJukebox, false) {
      wrappedMethod(hit); // default behavior
    } else {
      if RandRangeF(0, 10) < 1.0 {
        GameObject.PlaySoundEvent(this, devicePS.GetGlitchSFX());
      };
      if devicePS.evmHacksRemaining > 0
      || !devicePS.moduleExistsMalfunctionsJukebox {
        wrappedMethod(hit); // default behavior
      } else { // still can trigger security but doesn't cancel glitching
        super.OnHitEvent(hit);
      };

      if Equals(this.GetDeviceState(), EDeviceStatus.ON)
      && RandRange(0, 100) < settings.onHitBreakOdds {
        this.EVMShutDownMachine();
      };
    };
  } else {
    wrappedMethod(hit); // default behavior
  };
}