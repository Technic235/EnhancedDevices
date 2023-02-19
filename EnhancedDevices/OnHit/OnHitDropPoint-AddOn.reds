module EnhancedDevices.OnHit.DropPoint
import EnhancedDevices.Settings.*

// DropPoint <- BasicDistractionDevice <- InteractiveDevice <- (skips) <- Device <-
// DropPointController <- BasicDistractionDeviceController <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// DropPointControllerPS <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

// this is used for DropPoint only
@wrapMethod(DropPoint) // <- BasicDistractionDevice <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Void {
  let devicePS = this.GetDevicePS();
  if !Equals(this.GetCurrentGameplayRole(), EGameplayRole.None)
  && !Equals(devicePS.evmMalfunctionName, "broken") {
    let settings = new EVMMenuSettings();
    if Equals(settings.onHitDropPoint, false) {
      wrappedMethod(hit); // default behavior
    } else {
      if devicePS.evmHacksRemaining > 0
      || !devicePS.moduleExistsMalfunctionsDropPoint {
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