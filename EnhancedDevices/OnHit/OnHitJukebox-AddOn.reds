module EnhancedDevices.OnHit.Jukebox
import EnhancedDevices.Settings.*

// Jukebox <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// JukeboxController <- (skips BasicDistractionDevice) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// JukeboxControllerPS <- (skips BasicDistractionDevice) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@wrapMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Void {
  let devicePS = this.GetDevicePS();
  if !Equals(this.GetCurrentGameplayRole(), EGameplayRole.None)
  || !Equals(devicePS.evmMalfunctionName, "broken") {
    let settings = new EVMMenuSettings();
    if Equals(settings.onHitJukebox, false) {
      wrappedMethod(hit); // default behavior
    } else {
      if devicePS.evmHacksRemaining > 0
      || !devicePS.moduleExistsMalfunctionsJukebox {
        wrappedMethod(hit); // default behavior
      } else { // still can trigger security but doesn't cancel glitching
        super.OnHitEvent(hit);
        if RandRangeF(0, 10) < 1.0 {
          GameObject.PlaySoundEvent(this, devicePS.GetGlitchSFX());
        }
      };
      if Equals(this.GetDeviceState(), EDeviceStatus.ON)
      && RandRange(0, 100) < settings.onHitBreakOdds {
        this.EVMShutDownMachine();
      };
    };
  };
}