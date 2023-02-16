module EnhancedDevices.OnHit.ArcadeMachine
import EnhancedDevices.Settings.*

// PachinkoMachine <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// PachinkoMachineController <- ArcadeMachineController <- (skips BasicDistractionDeviceController) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// PachinkoMachineControllerPS <- ArcadeMachineControllerPS <- (BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

// this is used for PachinkoMachine & ArcadeMachine
@wrapMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Void { // also affects PachinkoMachine
  let devicePS = this.GetDevicePS();
  if !Equals(this.GetCurrentGameplayRole(), EGameplayRole.None)
  && !Equals(devicePS.evmMalfunctionName, "broken") {
    wrappedMethod(hit); // conditional checks have been built into StartGlitching() for Arcade/PachinkoMachine
    let settings = new EVMMenuSettings();
    if Equals(this.GetDeviceState(), EDeviceStatus.ON)
    && RandRange(0, 100) < settings.onHitBreakOdds {
      this.TurnOffDevice();
      this.EVMShutDownMachine();
    };
  };
}