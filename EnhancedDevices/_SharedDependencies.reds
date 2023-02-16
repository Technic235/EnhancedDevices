module EnhancedDevices
import EnhancedDevices.Settings.*

// PachinkoMachine <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// PachinkoMachineController <- ArcadeMachineController <- (skips BasicDistractionDeviceController) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// PachinkoMachineControllerPS <- ArcadeMachineControllerPS <- (BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-
// IceMachine/WeaponMachine <- VendingMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <-
// IceMachine(Controller)(PS)/WeaponMachine(Controller)(PS) <- VendingMachine(Controller)(PS) <- (BasicDistractionDevice(Controller)(PS)) <- ScriptableDeviceComponent(PS) <-
// DropPoint(Controller)(PS) <- BasicDistractionDevice(Controller)(PS) <-

@wrapMethod(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected cb func OnInstantiated() -> Void {
  wrappedMethod();
  this.m_distractionTimeCompleted = true;
}

// used for malfunctions and hacking
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected let evmHacksRemaining: Int32 = 2;

// used everywhere
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected let evmMalfunctionName: String = "";

@wrapMethod(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected func OnQuickHackDistraction(evt:ref<QuickHackDistraction>) -> EntityNotificationType { // CALLED TWICE
  if evt.IsStarted() {
    let settings = new EVMMenuSettings();
    let announcementsOn: Bool;
    if settings.announcementsOn { announcementsOn = true; } else { announcementsOn = false; };
    let device = this.GetOwnerEntityWeak() as VendingMachine;
    device.LoudVendingMachines(announcementsOn);

    if Equals(device.m_controllerTypeName, n"VendingMachineController") { this.evmIsReady = false; }; ///////////////// this is for On-Hit
    if this.evmHacksRemaining >= -1 { this.evmHacksRemaining -= 1; }; // works on all devices
  };

  if evt.IsCompleted() {
    (this.GetOwnerEntityWeak() as InteractiveDevice).UpdateDeviceState(); // ensures this always gets called cuz some parts of the code omits this.
  };

  return wrappedMethod(evt);
}

// called by DropPointHacking-DropPoint-OnQuickHackDistraction() and VendingMachineHacking-PachinkoMachine-OnQuickHackDistraction()
@addMethod(InteractiveDevice) // <- (one-layer discrepancy) <- Device <-
protected func EVMMoneyFromHacking() -> Void {
  let settings = new EVMMenuSettings();
  if RandRange(0, 100) < settings.eddiesDropOdds {
    let min: Int32 = settings.eddiesMin;
    let max: Int32 = settings.eddiesMax;
    if min >= max { min = max-1; };
    let quantity = RandRange(min, max+1); // last # of range is excluded, therefore +1 to make sure 'max' is included
    let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
    TS.GiveItem(GetPlayer(this.GetGame()), MarketSystem.Money(), quantity);
  };
}

// needed for EVMShutDownMachine()
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected let evmShortGlitchCallbackID: Uint32;

// needed for EVMShutDownMachine()
@addMethod(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected func EVMUnregisterShortGlitchMalfunction() {
  if this.evmShortGlitchCallbackID != 0u { // this is for all devices - 0u turns zero into a Uint32 instead of Int32
    GameInstance.GetTimeSystem(this.GetGameInstance()).UnregisterListener(this.evmShortGlitchCallbackID);
    this.evmShortGlitchCallbackID = 0u;
  };
}

@addMethod(InteractiveDevice) // <- (one-layer discrepancy) <- Device <-
protected func EVMShutDownMachine() -> Void {
  let devicePS = this.GetDevicePS();
  // let vendingMachine = (this as VendingMachine);
  // devicePS.ActionSetDeviceOFF(); // look into this

  devicePS.evmMalfunctionName = "broken";
  devicePS.evmHacksRemaining = 0;
  devicePS.evmIsReady = false;

  if Equals(this.m_controllerTypeName, n"PachinkoMachineController") {
		GameObject.PlayMetadataEvent(this, n"");
  };

  devicePS.EVMUnregisterShortGlitchMalfunction();
  devicePS.EVMUnregisterArcadeSparkMalfunction();
  devicePS.EVMUnregisterHitBlackFlicker();
  devicePS.EVMUnregisterHitBlackGlitch();

  if Equals(this.m_controllerTypeName, n"DataTermController") {
    super.DeactivateDevice(); // avoids ToggleLogicLayer(false); & UnregisterMappin();
    this.m_interaction.Toggle(true); // turns this back on so scanner UI still appears
  } else {
    this.DeactivateDevice();
  };
  
	this.SetGameplayRoleToNone(); // takes away quickhack options
  this.m_uiComponent.Toggle(false); // turns off the screen

  if !Equals(this.m_controllerTypeName, n"DropPointController")
  && !Equals(this.m_controllerTypeName, n"DataTermController") {
    devicePS.SetDeviceState(this.GetDeviceState().OFF); // makes scanner UI say the device is OFF
  };
  // If device state not turned back to ON, changing the device state to OFF prevents the machine from resetting its malfunction when leaving and reentering the area. Also causes a bug where UI says "Error: No compatible quickhacks found" and the scanner highlight comes back.

  // devicePS.m_activationState = EActivationState.NONE; // No noticable difference
  // vendingMachine.TurnOffDevice(); // No noticable difference
	// vendingMachine.RevealNetworkGrid( false ); // No noticable difference
	// vendingMachine.RevealDevicesGrid( false ); // No noticable difference
	// vendingMachine.m_isPlayerAround = false; // // No noticable difference
  // vendingMachine.m_isUIdirty = true; // No noticable difference.
  // vendingMachine.m_interactionIndicator.ToggleLight( false ); // No noticable difference
  // vendingMachine.UpdateDeviceState(); // No noticable difference
  // vendingMachine.RefreshUI(); // No noticable difference

  // GameObject.UntagObject( this ); // this happens by default
  // vendingMachine.CutPower(); // isn't needed cuz it calls RevealNetworkGrid/RevealDevicesGrid
  // vendingMachine.m_advUiComponent.Toggle( false ); // // No noticable difference
	// vendingMachine.ToggleLights( false ); // // No noticable difference
  // vendingMachine.StopTransformDistractAnimation("turnON"); // not found
	// vendingMachine.HandleMappinRregistration( false ); // not found
}