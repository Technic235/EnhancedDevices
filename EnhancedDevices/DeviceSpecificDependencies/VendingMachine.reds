module EnhancedDevices.VendingMachine

// <- VendingMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// <- VendingMachineController <- (skips BasicDistractionDeviceController) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// <- VendingMachineControllerPS <- (skips BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-
// IceMachine(Controller)(PS)/WeaponMachine(Controller)(PS) <- VendingMachine(Controller)(PS) <-

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

// also used by vending machine hacking, but only to facilitate EnhancedDevices.OnHit.VendingMachine
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected let evmIsReady: Bool = true;

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

  if devicePS.moduleExistsMalfunctionsVendingMachine {
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

// used by EnhancedDevices.OnHit.VendingMachine and VendingMachineHackedEffect-EVMDispenseEddiesRandomizer()
public class EVMDispenseEddieBundles extends DelayCallback {
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