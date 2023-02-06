module ArcadeMachineHacking
// PachinkoMachine <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// PachinkoMachineController <- ArcadeMachineController <- (skips BasicDistractionDeviceController) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// PachinkoMachineControllerPS <- ArcadeMachineControllerPS <- (BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@addMethod(ArcadeMachine) // <- InteractiveDevice <- Device <-
protected cb func OnQuickHackDistraction(evt:ref<QuickHackDistraction>) { // CALLED TWICE
  if evt.IsStarted() {
		this.ShowQuickHackDuration(evt); // from Device
		this.StartGlitching(EGlitchState.DEFAULT, 1.0); // from Device
    let settings = new EVMMenuSettings();
    if settings.hackArcadeMachine { this.EVMMoneyFromHacking(); };
  };

  if evt.IsCompleted() {
    this.StopGlitching(); // from Device
  };
}

@wrapMethod(PachinkoMachine) // <- ArcadeMachine <- InteractiveDevice <- Device <-
protected cb func OnQuickHackDistraction(evt:ref<QuickHackDistraction>) { // CALLED TWICE
  wrappedMethod(evt); // PachinkoMachine's OnQuickHackDistraction invokes Device's OnQuickHackDistraction
  if evt.IsStarted() {
    let settings = new EVMMenuSettings();
    if settings.hackArcadeMachine { this.EVMMoneyFromHacking(); };
  };
}