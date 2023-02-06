// import EnhancedVendingMachines.ModuleConfig.*

// PachinkoMachine <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// PachinkoMachineController <- ArcadeMachineController <- (skips BasicDistractionDeviceController) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// PachinkoMachineControllerPS <- ArcadeMachineControllerPS <- (BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-
// IceMachine/WeaponMachine <- VendingMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <-
// IceMachine(Controller)(PS)/WeaponMachine(Controller)(PS) <- VendingMachine(Controller)(PS) <- (BasicDistractionDevice(Controller)(PS)) <- ScriptableDeviceComponent(PS) <-
// DropPoint(Controller)(PS) <- BasicDistractionDevice(Controller)(PS) <-

//
//
//
//
// START Malfunction section

// ArcadeMachineMalfunctions
// needed for ScriptableDeviceComponentPS-OnQuickHackDistraction()
// which calls ArcadeMachineMalfunctions & VendingMachineHacking
@addMethod(InteractiveDevice) // <- (one-layer discrepancy) <- Device <-
protected func EVMSetupArcadeStaticGlitchListener() -> Void {
  let devicePS = this.GetDevicePS();
	if devicePS.evmArcadeStaticEventID == 0u { // 0u turns zero into a Uint32 instead of Int32
    let evt = new EVMArcadeStaticGlitchEvent();
    let delay: GameTime = GameTime.MakeGameTime(0, 0, 0, RandRange(120, 301)); // days, hours, opt minutes, opt seconds
    // RandRange excludes last number so it's really 120-300 game-seconds (2-5 game-minutes)
		devicePS.evmArcadeStaticEventID = GameInstance.GetTimeSystem(devicePS.GetGameInstance()).RegisterDelayedListener(this, evt, delay, -1);
	};
}

public class EVMArcadeStaticGlitchEvent extends Event {
  // intentionally empty
}

// OnEVMArcadeStaticGlitchEvent() & EVMDelayArcadeStaticGlitchCallback in ArcadeMalfunctions

@addField(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
let evmSparkActive: Bool = false;

@addMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMStartArcadeStaticGlitch() {
  if !this.evmSparkActive {
    // static SCREEN makes the arcade machine think it has already started hack_fx
    GameObjectEffectHelper.ActivateEffectAction(this, gamedataFxActionType.Start, n"hack_fx"); // ...n"hack_fx", evt.machine.evmWorldEffectBlackboard, true);
    let delaySystem = GameInstance.GetDelaySystem(this.GetGame());
    let callback = new EVMArcadeStaticGlitchCompletedCallback();
    callback.machine = this;
    delaySystem.DelayCallback(callback, 13, true);
    this.evmSparkActive = true;
  };
}

class EVMArcadeStaticGlitchCompletedCallback extends DelayCallback {
  let machine: ref<ArcadeMachine>;
  protected func Call() -> Void {
    this.machine.evmSparkActive = false;
  }
}

//  END Malfunction section
//
//  
//
//

@wrapMethod(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected cb func OnInstantiated() -> Void {
  wrappedMethod();
  this.m_distractionTimeCompleted = true;
}

@wrapMethod(WeaponVendingMachine) // <- VendingMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnTakeControl(ri:EntityResolveComponentsInterface) {
  wrappedMethod(ri); // wrappedMethod must come first for the sfx to work
  this.GetDevicePS().m_weaponVendingMachineSFX.m_gunFalls = n"dev_ice_machine_ice_cube_falls";
  this.GetDevicePS().m_weaponVendingMachineSetup.m_vendorTweakID = t"Vendors.SlaughtOMaticVendor";
}

@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func LoudVendingMachines(announcementsOn:Bool) {
  let devicePS = this.GetDevicePS();

  if !announcementsOn {
    if Equals(this.m_controllerTypeName, n"VendingMachineController") {
      (devicePS as VendingMachineControllerPS).m_vendingMachineSFX.m_glitchingStart = n""; // no more "hfjkdshfjhsdkj NICOLA!!!!"
    };
    if Equals(this.m_controllerTypeName, n"WeaponVendingMachineController") {
      (devicePS as WeaponVendingMachineControllerPS).m_weaponVendingMachineSFX.m_glitchingStart = n""; // no more "hfjkdshfjhsdkj NICOLA!!!!"
    };
    if Equals(this.m_controllerTypeName, n"IceMachineController") {
      (devicePS as IceMachineControllerPS).m_iceMachineSFX.m_glitchingStart = n""; // no more "hfjkdshfjhsdkj NICOLA!!!!"
    };
  } else {
    if Equals(this.m_controllerTypeName, n"VendingMachineController") {
      (devicePS as VendingMachineControllerPS).m_vendingMachineSFX.m_glitchingStart = n"amb_int_custom_megabuilding_01_adverts_interactive_nicola_01_select_q110";
    };
    if Equals(this.m_controllerTypeName, n"WeaponVendingMachineController") {
      (devicePS as WeaponVendingMachineControllerPS).m_weaponVendingMachineSFX.m_glitchingStart = n"amb_int_custom_megabuilding_01_adverts_interactive_nicola_01_select_q110";
    };
    if Equals(this.m_controllerTypeName, n"IceMachineController") {
      (devicePS as IceMachineControllerPS).m_iceMachineSFX.m_glitchingStart = n"amb_int_custom_megabuilding_01_adverts_interactive_nicola_01_select_q110";
    };
  }
}

// used for malfunctions and hacking
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected let evmHacksRemaining: Int32 = 2;

// used everywhere
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected let evmMalfunctionName: String = "";

// also used by vending machine hacking, but only to facilitate AllMachinesOnHitEvent
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected let evmIsReady: Bool = true;

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

// used for HackingArcadeMachine & MalfunctionsArcadeMachine
// replaced so ActivateEffectAction( this, gamedataFxActionType.Start, 'hack_fx' ); isnt called
@replaceMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func StartGlitching(glitchState:EGlitchState, opt intensity:Float) -> Void {
  let glitchData: GlitchData;
  glitchData.state = glitchState;
  glitchData.intensity = intensity;
  if intensity == 0.0 { intensity = 1.0; };
  let evt = new AdvertGlitchEvent();
  evt.SetShouldGlitch(intensity);
  this.QueueEvent(evt);
  this.GetBlackboard().SetVariant(this.GetBlackboardDef().GlitchData, glitchData, true);
  this.GetBlackboard().FireCallbacks();
  if Equals(this.m_controllerTypeName, n"ArcadeMachineController") {
    this.EVMStartArcadeStaticGlitch();
    if this.GetDevicePS().evmHacksRemaining <= 0 {
    this.EVMSetupArcadeStaticGlitchListener();
    };
  };
}

@addMethod(PachinkoMachine) // <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func StartGlitching(glitchState:EGlitchState, opt intensity:Float) -> Void {
  super.StartGlitching(glitchState, intensity);
}

// required for HackedEffect and OnHitEvent
// makes sure screen remains black for the duration of the hack when items are dispensed.
// still causes WeaponVendingMachine processing screen to get stuck if item dispenses after final hack since m_isReady = false
@wrapMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnVendingMachineFinishedEvent(evt:ref<VendingMachineFinishedEvent>) {
  let devicePS = this.GetDevicePS();
  wrappedMethod(evt);
  if devicePS.m_distractionTimeCompleted && !devicePS.IsSoldOut() && devicePS.evmIsReady {
    devicePS.m_isReady = true;
  } else {
    devicePS.m_isReady = false;
  };
}

// required for HackedEffect and OnHitEvent
// makes sure screen remains black for the duration of the hack when items are dispensed.
// still causes processing screen to get stuck if item dispenses after final hack since m_isReady = false
@wrapMethod(IceMachine) // <- VendingMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnVendingMachineFinishedEvent(evt:ref<VendingMachineFinishedEvent>) {
  let devicePS = this.GetDevicePS();
  wrappedMethod(evt);
  if devicePS.m_distractionTimeCompleted && !devicePS.IsSoldOut() && devicePS.evmIsReady {
    devicePS.m_isReady = true;
  } else {
    devicePS.m_isReady = false;
  };
}

// called after OnQuickHackDistraction() and HackedEffect()
// Brings default behavior in line with normal vending machines
@wrapMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func StopGlitching() {
  let devicePS = this.GetDevicePS();
  if ( Equals(devicePS.evmMalfunctionName, "") && devicePS.evmHacksRemaining > 0 )
  || Equals(devicePS.evmMalfunctionName, "glitch")
  || Equals(devicePS.evmMalfunctionName, "static") {
    devicePS.evmIsReady = true;
    devicePS.m_isReady = true;
    this.RefreshUI();
  }

  if devicePS.moduleExistsVendingMachineMalfunctions {
    if devicePS.evmHacksRemaining > 0 { wrappedMethod(); };
  } else {
    wrappedMethod();
  };

  if devicePS.IsSoldOut()
  || ( Equals(devicePS.evmMalfunctionName, "") && devicePS.evmHacksRemaining <= 0 ) {
    devicePS.evmIsReady = false; // WeaponVendingMachine has no StopGlitching and IceMachine's just calls super.StopGlitching
    devicePS.m_isReady = false; // the equivalent of SendSoldOutToUIBlackboard(true), but for WeaponVendingMachine/IceMachine
  };

  if devicePS.evmHacksRemaining <= 0 {
    devicePS.EVMUnregisterShortGlitchMalfunction();
    devicePS.evmMalfunctionName = "static";
  };
}

// prevents arcade machines from sparking on hit when broken/off
@wrapMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Void { // hitEvents.script
  let devicePS = this.GetDevicePS();
  if !devicePS.moduleExistsAllMachinesOnHitEvent {
    if !Equals(this.GetCurrentGameplayRole(), EGameplayRole.None) // if not assigned "Distract" role
    || !Equals(devicePS.evmMalfunctionName, "broken") {
      wrappedMethod(hit);
    }
  } else {
    wrappedMethod(hit);
  };
}

// used by AllMachinesOnHitEvent and VendingMachineHackedEffect-EVMDispenseEddiesRandomizer()
protected class EVMDispenseEddieBundles extends DelayCallback {
  let vendingMachine: ref<VendingMachine>;
  let lootManager: ref<LootManager>;
  let dropInstructions: array<DropInstruction>;
  protected func Call() -> Void {
    this.lootManager.SpawnItemDropOfManyItems(this.vendingMachine, this.dropInstructions, n"", this.vendingMachine.RandomizePosition());
    if Equals(this.vendingMachine.m_controllerTypeName, n"WeaponVendingMachineController")
    || Equals(this.vendingMachine.m_controllerTypeName, n"IceMachineController") {
      GameObject.PlaySoundEvent( this.vendingMachine, n"dev_vending_machine_can_falls" );
    } else {
      this.vendingMachine.PlayItemFall();
    }
    this.vendingMachine.RefreshUI(); // do I need this?
  }
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

// used for hacking & on-hit
@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func DetermineJunkItem() -> ItemID {
  let randomNum = RandRangeF(0, 100);
  let junkVariants: array<JunkItemRecord> = this.m_vendorID.m_junkItemArray;
  // last # of range is excluded, therefore 1 becomes 2 to make sure 0 & 1 are both possible outcomes
  // RandRange(0, 2) because there are only two junk variants
  // look into ItemID.FromTDBID(t"Items.junk") to see if there are more variants
  if Equals(this.m_controllerTypeName, n"VendingMachineController") {
    if randomNum < 7.5 {
      return ItemID.FromTDBID(t"Items.GenericPoorJunkItem2"); // old can
    };
    if randomNum < 15.0 {
      return ItemID.FromTDBID(t"Items.Junk"); // moldy syn-cheese
    };
    if randomNum < 22.5 {
      return ItemID.FromTDBID(t"Items.TygerClawsJunkItem2"); // chopsticks
    };
    if randomNum < 30.0 {
      return ItemID.FromTDBID(t"Items.ValentinosJunkItem3"); // decorative spoon
    };
    return ItemID.FromTDBID(junkVariants[RandRange(0, 2)].m_junkItemID);
  };

  if Equals(this.m_controllerTypeName, n"WeaponVendingMachineController") {
    if randomNum < 3.75 {
      return ItemID.FromTDBID(t"Items.GenericGangJunkItem5"); // bloody knife
    };
    if randomNum < 7.5 {
      return ItemID.FromTDBID(t"Items.WraithsJunkItem2"); // bloody bandage
    };
    if randomNum < 11.25 {
      return ItemID.FromTDBID(t"Items.MaelstromJunkItem3"); // broken eye implant
    };
    if randomNum < 15.0 {
      return ItemID.FromTDBID(t"Items.ScavengersJunkItem1"); // dull scalpel
    };
    if randomNum < 18.75 {
      return ItemID.FromTDBID(t"Items.ScavengersJunkItem2"); // handcuffs
    };
    if randomNum < 22.5 {
      return ItemID.FromTDBID(t"Items.WraithsJunkItem1"); // tire iron
    };
    if randomNum < 26.25 {
      return ItemID.FromTDBID(t"Items.MilitechJunkItem2"); // military pocket knife
    };
    if randomNum < 30.0 {
      return ItemID.FromTDBID(t"Items.GenericGangJunkItem2"); // tattoo needle
    };
  };
  return ItemID.FromTDBID(t"");
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

// needed for EVMShutDownMachine()
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
let evmArcadeStaticEventID: Uint32 = 0u;

// needed for EVMShutDownMachine()
@addMethod(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected func EVMUnregisterArcadeSparkMalfunction() {
	if this.evmArcadeStaticEventID != 0u { // this is for arcade machines
    GameInstance.GetTimeSystem(this.GetGameInstance()).UnregisterListener(this.evmArcadeStaticEventID);
    this.evmArcadeStaticEventID = 0u;
	};
}

// needed for EVMShutDownMachine()
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected let evmBlackFlickerCallbackID: Uint32;

// needed for EVMShutDownMachine()
@addMethod(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected func EVMUnregisterHitBlackFlicker() {
  if this.evmBlackFlickerCallbackID != 0u { // this is for vending machines
    GameInstance.GetTimeSystem(this.GetGameInstance()).UnregisterListener(this.evmBlackFlickerCallbackID);
    this.evmBlackFlickerCallbackID = 0u;
  };
}

// needed for EVMShutDownMachine()
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected let evmBlackGlitchCallbackID: Uint32;

// needed for EVMShutDownMachine()
@addMethod(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected func EVMUnregisterHitBlackGlitch() {
  if this.evmBlackGlitchCallbackID != 0u { // this is for vending machines
    GameInstance.GetTimeSystem(this.GetGameInstance()).UnregisterListener(this.evmBlackGlitchCallbackID);
    this.evmBlackGlitchCallbackID = 0u;
  };
}

// needed for EVMShutDownMachine() & when DataTerm gains "static" malfunction
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
let evmHoloFlickerCallbackID: Uint32;

// needed for RestartDevice() on InteractiveDevice in Malfunctions_Dependencies.reds
@addMethod(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected func EVMUnregisterHoloFlicker() {
  if this.evmHoloFlickerCallbackID != 0u { // this is for vending machines
    GameInstance.GetTimeSystem(this.GetGameInstance()).UnregisterListener(this.evmHoloFlickerCallbackID);
    this.evmHoloFlickerCallbackID = 0u;
  };
}

@addMethod(DataTerm)
protected func StartHoloFlicker() {
  let flickerActive = false;
  let delaySystem = GameInstance.GetDelaySystem(this.GetGame());
  let callback = new EVMEndDataTermHoloFlickerCallback();
  callback.dataTerm = this;
  if RandRangeF(0, 5) < 1.0 {
    this.GetDevicePS().GetDeviceOperationsContainer().Execute(n"hide_holo", this);
    delaySystem.DelayCallback(callback, RandRangeF(0.05, 0.2), true);

    if RandRangeF(0, 3) < 1.0 { this.m_uiComponent.Toggle(false); }; // 6.66% chance, then an additional 0.66% chance below
    flickerActive = true;
  };

  if !flickerActive
  && RandRangeF(0, 10) < 1.0 { // 7.26% chance when combined with above chances
    this.m_uiComponent.Toggle(false);
    delaySystem.DelayCallback(callback, RandRangeF(0.05, 0.2), true);
  };
}

protected class EVMEndDataTermHoloFlickerCallback extends DelayCallback {
  let dataTerm: ref<DataTerm>;
  protected func Call() -> Void {
    this.dataTerm.GetDevicePS().GetDeviceOperationsContainer().Execute(n"show_holo", this.dataTerm);
    if !Equals(this.dataTerm.GetDevicePS().evmMalfunctionName, "broken") {
      this.dataTerm.m_uiComponent.Toggle( true );
    };
  }
}

@wrapMethod(DataTerm)
protected func StartShortGlitch() {
  this.StartHoloFlicker();
  wrappedMethod();
}

@wrapMethod(PachinkoMachine) // <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnGameAttached() {
  wrappedMethod();
  this.m_controllerTypeName = n"PachinkoMachineController";
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
  
	this.SetGameplayRoleToNone(); // NECESSARY - takes away quickhack options
  this.m_uiComponent.Toggle(false); // NECESSARY - turns off the screen

  if !Equals(this.m_controllerTypeName, n"DropPointController")
  && !Equals(this.m_controllerTypeName, n"DataTermController") {
    devicePS.SetDeviceState(this.GetDeviceState().OFF); // makes scanner UI say the device is OFF
  };
  // If device state not turned back to ON, changing the device state to OFF prevents the machine from resetting its malfunction when leaving and reentering the area. Also causes a bug where UI says "Error: No compatible quickhacks found" and the scanner highlight comes back

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

@addMethod(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected func EVMFinalizeQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) {
  if this.IsGlitching() || this.IsDistracting() {
    ScriptableDeviceComponentPS.SetActionsInactiveAll(actions, "LocKey#7004");
  };
  if this.IsOFF() {
    ScriptableDeviceComponentPS.SetActionsInactiveAll(actions, "LocKey#7005");
  };
  this.FinalizeGetQuickHackActions(actions, context);
}

// this is used for VendingMachine only
@wrapMethod(VendingMachineControllerPS) // <- (BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <-
protected func GetQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) {
  // if Equals(this.GetDeviceState(), EDeviceStatus.ON)
  if (this.evmHacksRemaining <= 0
  || this.GetBlackboard().GetBool(GetAllBlackboardDefs().VendingMachineDeviceBlackboard.SoldOut)) {
    let currentAction:ref<ScriptableDeviceAction>;
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenSuicide", t"QuickHack.SuicideHackBase");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenBlind", t"QuickHack.BlindHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenGrenade", t"QuickHack.GrenadeHackBase");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);

    currentAction = this.ActionQuickHackDistraction();
    currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    // currentAction.SetInactiveWithReason(false, "LocKey#7003"); // THIS AFFECTS ONE QUICKHACK & GOES BEFORE ARRAYPUSH
    ArrayPush(actions, currentAction);

    ScriptableDeviceComponentPS.SetActionsInactiveAll(actions, "LocKey#7003"); // THIS AFFECTS ALL QUICKHACKS & GOES AFTER ARRAYPUSH
    this.EVMFinalizeQuickHackActions(actions, context);
  } else {
    wrappedMethod(actions, context);
  };
}

// needed for arcade hacking and Arcade Malfunctions
// this is used for ArcadeMachine only
@wrapMethod(ArcadeMachineControllerPS) // <- (skips BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <-
protected func GetQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) {
  let settings = new EVMMenuSettings();
  if ( ( this.moduleExistsArcadeMachineHacking && settings.hackArcadeMachine )
  || this.moduleExistsArcadeMachineMalfunctions )
  // && Equals(this.GetDeviceState(), EDeviceStatus.ON)
  && this.evmHacksRemaining <= 0 {
    let currentAction:ref<ScriptableDeviceAction>;
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenSuicide", t"QuickHack.SuicideHackBase");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenBlind", t"QuickHack.BlindHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenGrenade", t"QuickHack.GrenadeHackBase");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);

    currentAction = this.ActionQuickHackDistraction();
    currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    // currentAction.SetInactiveWithReason(false, "LocKey#7003"); // THIS AFFECTS ONE QUICKHACK & GOES BEFORE ARRAYPUSH
    ArrayPush(actions, currentAction);

    ScriptableDeviceComponentPS.SetActionsInactiveAll(actions, "LocKey#7003"); // THIS AFFECTS ALL QUICKHACKS & GOES AFTER ARRAYPUSH
    this.EVMFinalizeQuickHackActions(actions, context);
  } else {
    wrappedMethod(actions, context);
  };
}

// needed for arcade hacking and Arcade Malfunctions
// this is used for PachinkoMachine only
@wrapMethod(PachinkoMachineControllerPS) // <- ArcadeMachineControllerPS <- (skips BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <-
protected func GetQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) {
  let settings = new EVMMenuSettings();
  if ( ( this.moduleExistsArcadeMachineHacking && settings.hackArcadeMachine )
  || this.moduleExistsArcadeMachineMalfunctions )
  // && Equals(this.GetDeviceState(), EDeviceStatus.ON)
  && this.evmHacksRemaining <= 0 {
    let currentAction: ref<ScriptableDeviceAction>;
    currentAction = this.ActionQuickHackDistraction();
    currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    // currentAction.SetInactiveWithReason(false, "LocKey#7003"); // THIS AFFECTS ONE QUICKHACK & GOES BEFORE ARRAYPUSH
    ArrayPush(actions, currentAction);

    ScriptableDeviceComponentPS.SetActionsInactiveAll(actions, "LocKey#7003"); // THIS AFFECTS ALL QUICKHACKS & GOES AFTER ARRAYPUSH
    this.EVMFinalizeQuickHackActions(actions, context);
  } else {
    wrappedMethod(actions, context);
  };
}

// GetQuickHackActions resides in BasicDeviceComponentControllerPS
@wrapMethod(DropPointControllerPS) // <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS <-
protected func GetQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) -> Void {
  if Equals(this.m_distractorType, EPlaystyleType.TECHIE) || Equals(this.m_distractorType, EPlaystyleType.NONE) { return; };
  let settings = new EVMMenuSettings();
  if ( ( this.moduleExistsDropPointHacking && settings.hackDropPoint )
  || this.moduleExistsDropPointMalfunctions )
  && Equals(this.GetDeviceState(), EDeviceStatus.ON)
  && this.evmHacksRemaining < 0 {
  // changed '<= 0'  to '< 0' becuz 2 hacks are being subtracted instead of 1 since cb func OnQuickHackDistraction() is on both BasicDistractionDevice and Device
    let currentAction: ref<ScriptableDeviceAction>;
    currentAction = this.ActionQuickHackDistraction();
    currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);

    ScriptableDeviceComponentPS.SetActionsInactiveAll(actions, "LocKey#7003");
    this.EVMFinalizeQuickHackActions(actions, context);
  } else {
    wrappedMethod(actions, context);
  };
}

// needed for HackingDataTerm and DataTermMalfunctions
// this is used for DataTerm (Fast Travel Terminal) only
@addMethod(DataTermControllerPS) // <- (skips BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <-
protected func GetQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) {
  let settings = new EVMMenuSettings();
  if ( ( this.moduleExistsTravelTerminalHacking && settings.hackTravelTerminal )
  || this.moduleExistsTravelTerminalMalfunctions )
  && Equals(this.GetDeviceState(), EDeviceStatus.ON) {
    let currentAction: ref<ScriptableDeviceAction>;
    currentAction = this.ActionQuickHackDistraction();
    if this.evmHacksRemaining <= 0 {
      currentAction.SetInactiveWithReason(false, "LocKey#7003"); // THIS AFFECTS ONE QUICKHACK & GOES BEFORE ARRAYPUSH
    };
    ArrayPush(actions, currentAction);

    this.EVMFinalizeQuickHackActions(actions, context);
  } else {
    super.GetQuickHackActions(actions, context);
  };
}