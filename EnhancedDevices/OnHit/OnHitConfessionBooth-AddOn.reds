module EnhancedDevices.OnHit.ConfessionBooth
import EnhancedDevices.Settings.*

// ConfessionBooth <- BasicDistractionDevice <- InteractiveDevice <- (skips) <- Device <-
// ConfessionBoothController <- BasicDistractionDeviceController <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// ConfessionBoothControllerPS <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

// this is used for ConfessionBooth only
@wrapMethod(ConfessionBooth) // <- BasicDistractionDevice <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Void {
  let devicePS = this.GetDevicePS();
  if !Equals(this.GetCurrentGameplayRole(), EGameplayRole.None)
  || !Equals(devicePS.evmMalfunctionName, "broken") {
    let settings = new EVMMenuSettings();
    if Equals(settings.onHitConfessionBooth, false) {
      wrappedMethod(hit); // default behavior
    } else {
      if devicePS.evmHacksRemaining > 0
      || !devicePS.moduleExistsMalfunctionsConfessionBooth {
        wrappedMethod(hit); // default behavior
      } else { // still can trigger security but doesn't cancel glitching
        super.OnHitEvent(hit);
      };
      if Equals(this.GetDeviceState(), EDeviceStatus.ON)
      && RandRange(0, 100) < settings.onHitBreakOdds {
        this.EVMShutDownMachine();
      };
    };
  };
}