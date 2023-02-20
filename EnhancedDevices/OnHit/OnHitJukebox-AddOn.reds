module EnhancedDevices.OnHit.Jukebox
import EnhancedDevices.Settings.*

// Jukebox <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// JukeboxController <- (skips BasicDistractionDevice) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// JukeboxControllerPS <- (skips BasicDistractionDevice) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@wrapMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) { // defined on Device
  if this.IsA(n"Jukebox") {
    let devicePS = this.GetDevicePS();
    if Equals(this.GetCurrentGameplayRole(), EGameplayRole.None)
    || Equals(devicePS.evmMalfunctionName, "broken") {
      return;
    };

    wrappedMethod(hit); // triggers security but doesn't cancel glitching
    let settings = new EVMMenuSettings();
    if settings.onHitJukebox
    && ( devicePS.evmHacksRemaining > 0 || !devicePS.moduleExistsMalfunctionsJukebox ) {
      this.StartShortGlitch();
    };

    if RandRangeF(0, 10) < 1.0 {
      GameObject.PlaySoundEvent(this, devicePS.GetGlitchSFX());
    };

    if Equals(this.GetDeviceState(), EDeviceStatus.ON)
    && RandRange(0, 100) < settings.onHitBreakOdds {
      this.EVMShutDownMachine();
    };
  } else {
    wrappedMethod(hit);
  }
}
