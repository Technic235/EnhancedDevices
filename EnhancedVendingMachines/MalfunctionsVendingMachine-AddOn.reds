module VendingMachineMalfunctions
// <- VendingMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// <- VendingMachineController <- (skips BasicDistractionDeviceController) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// <- VendingMachineControllerPS <- (skips BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-
// IceMachine(Controller)(PS)/WeaponMachine(Controller)(PS) <- VendingMachine(Controller)(PS) <-

@wrapMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected final func ResolveGameplayState() -> Void {
  wrappedMethod();
  this.RestartDevice();
  let settings = new EVMMenuSettings();
  let malfunctionRate: Int32 = settings.vendingMachineMalfunctionRate;
  if malfunctionRate == 0 { return; };
  let totalSum: Int32 = settings.vendingMachineStatic + settings.vendingMachineGlitch + settings.vendingMachineBroken;
  if totalSum == 0 { totalSum = 1; };
  let shortLimit = Cast<Float>(settings.vendingMachineGlitch) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0;
  let staticLimit = Cast<Float>(settings.vendingMachineStatic) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0 + shortLimit;
  let brokenLimit = Cast<Float>(settings.vendingMachineBroken) / Cast<Float>(totalSum) * Cast<Float>(malfunctionRate) / 100.0 + staticLimit;
  this.SetStartingMalfunction(shortLimit, staticLimit, brokenLimit);
}

// EVMSetupShortGlitchListener() & EVMShortGlitchEvent in Malfunctions_Dependencies.reds

@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
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
@wrapMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
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

// provides basic functionality when HackedEffect isn't installed
@wrapMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func HackedEffect() { // invoked by StartGlitching
  // stop script if vending machine is sold out.
  let devicePS = this.GetDevicePS();
  if Equals(devicePS.evmMalfunctionName, "static") && !devicePS.moduleExistsVendingMachineHackedEffect {
    if devicePS.IsSoldOut() {
      this.SendSoldOutToUIBlackboard(true);
    };
  } else {
    wrappedMethod();
  };
}