module AllMachinesOnHitEvent
// <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// <- (skips BasicDistractionDeviceController) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// <- (skips BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-
// DropPoint(Controller)(PS) <- BasicDistractionDevice(Controller)(PS) <-

// baseDeviceActions.script for powering, activating, turning on/off devices

//deviceBase.script
//enum EDeviceStatus {
// 	DISABLED = -2,
// 	UNPOWERED = -1,
// 	OFF = 0,
// 	ON = 1,
// 	INVALID = 2 } // this the default state before any state is applied.

// extended by ArcadeMachine/VendingMachine/BasicDistractionDevice-ControllerPS
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected let evmDropCounter: Int32 = 0;

@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMOnHitDelayedDispense() -> Void {
  if !this.GetDevicePS().IsSoldOut() {
    this.DelayVendingMachineEvent(0.2, true, true);
    this.EVMCountOnDrop();
  };
}

@addField(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected let evmSoldOutProbability: Float;

@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMCountOnDrop() {
  let devicePS = this.GetDevicePS();
  // machines that start with a malfunction will drop less than a machine that started without a malfunction, then acquired a malfunction
  devicePS.evmDropCounter += 1;
  // this.evmSoldOutProbability = 0.0;
  if devicePS.evmHacksRemaining == 2 {
    if devicePS.evmDropCounter < 12 { // can dispense 12
      this.evmSoldOutProbability = 0.025; // 2.5%
    } else {
      this.evmSoldOutProbability = 1.0;
    };
  };

  if devicePS.evmHacksRemaining == 1 {
    if this.evmSoldOutProbability == 0.025
    && !devicePS.IsSoldOut() {
      devicePS.evmDropCounter -= 1; // adds 2 potential drops
    };
    if devicePS.evmDropCounter < 9 { // can dispense 9 + added drops (11 max)
      this.evmSoldOutProbability = 0.05; // 5%
    } else {
      this.evmSoldOutProbability = 1.0;
    };
  };

  if devicePS.evmHacksRemaining <= 0 {
    if !devicePS.IsSoldOut() {
      if this.evmSoldOutProbability == 0.025 { // this doesn't take effect since functional machines go straight to 'sold out' after 2 hacks
      // scratch that. Could be used to allow drops even when machine is broken, if I choose to implement that
        devicePS.evmDropCounter -= 3; // adds 4 potential drops
      } else {
        if this.evmSoldOutProbability == 0.05 {
          devicePS.evmDropCounter -= 1; // adds 2 potential drops
        };
      };
    };
    if devicePS.evmDropCounter < 6 { // can dispense 6 + added drops (10 max)
      this.evmSoldOutProbability = 0.075; // 7.5%
    } else {
      this.evmSoldOutProbability = 1.0;
    };
  };

  this.m_distractionSoundName = n"dev_reflector_turn_on_loop_stop"; //  for extra "oomph"
  GameObject.PlaySoundEvent(this, this.m_distractionSoundName);
	if devicePS.IsSoldOut()
  || RandRangeF(0, 1) <= this.evmSoldOutProbability {
		this.SendSoldOutToUIBlackboard(true);
    devicePS.m_isSoldOut = true;
    devicePS.evmIsReady = false;
    devicePS.m_isReady = false;
    this.RefreshUI();
	};
}

@addField(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
let m_distractionSoundName: CName;


@replaceMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Void { // hitEvents.script
  let devicePS = this.GetDevicePS();
  let settings = new EVMMenuSettings();

  if devicePS.m_distractionTimeCompleted {
    if ( devicePS.moduleExistsVendingMachineMalfunctions && !Equals(devicePS.evmMalfunctionName, "static") )
    || !devicePS.moduleExistsVendingMachineMalfunctions {
      this.StartShortGlitch();
    };
  };

  if devicePS.IsSoldOut() // if sold out
  || Equals(this.GetCurrentGameplayRole(), EGameplayRole.None) { // or not assigned "Distract" role
    if !Equals(devicePS.evmMalfunctionName, "broken") // if not already broken by this mod
    && RandRange(0, 100) < settings.onHitBreakOdds {
      this.DeactivateDevice(); // will turn off if player or NPC (or anything, really) hits it
      this.EVMShutDownMachine();
    };
    return;
  };

  if !Equals(this.m_controllerTypeName, n"IceMachineController")
  || Equals(settings.onHitIceMachine, true) {
    let instigator = hit.attackData.GetInstigator();
    let player = GetPlayer(this.GetGame());
    if Equals(player.GetEntityID(), instigator.GetEntityID()) {
      // the player must be the one to hit the machine for there to be drops.
      let dropsOnBreaking: EVMDropsOnBreakingEnum = settings.onHitDropsOnBreak;
      if Equals(settings.onHitMultiDrop, true) { // if multiple items can fall at once
        switch dropsOnBreaking {
          case EVMDropsOnBreakingEnum.Never: // if never drops on breaking
            if RandRange(0, 100) < settings.onHitBreakOdds {
              this.SendSoldOutToUIBlackboard(true);
              this.DeactivateDevice(); // disables InteractionComponent with m_interaction.Toggle(false);
              this.EVMShutDownMachine();
              return;
            };
            if RandRange(0, 100) < settings.onHitEddiesOdds { this.EVMOnHitDropEddies(); };
            if Equals(this.m_controllerTypeName, n"IceMachineController") {
              if RandRange(0, 100) < settings.onHitJunkOdds { this.EVMOnHitDelayedDispense(); };
            } else {
              if RandRange(0, 100) < settings.onHitItemOdds { this.EVMOnHitDelayedDispense(); };
              if RandRange(0, 100) < settings.onHitJunkOdds {
                this.EVMDispenseOneJunk(1, true);
              }; // slaught-o-matic doesn't dispense junk
            };
            break;

          case EVMDropsOnBreakingEnum.Sometimes: // if sometimes drops on breaking
            if RandRange(0, 100) < settings.onHitEddiesOdds { this.EVMOnHitDropEddies(); };
            if Equals(this.m_controllerTypeName, n"IceMachineController") {
              if RandRange(0, 100) < settings.onHitJunkOdds { this.EVMOnHitDelayedDispense(); };
            } else {
              if RandRange(0, 100) < settings.onHitItemOdds { this.EVMOnHitDelayedDispense(); };
              if RandRange(0, 100) < settings.onHitJunkOdds {
                this.EVMDispenseOneJunk(1, true);
              }; // slaught-o-matic doesn't dispense junk
            };
            if RandRange(0, 100) < settings.onHitBreakOdds {
              this.SendSoldOutToUIBlackboard(true);
              this.DeactivateDevice(); // disables InteractionComponent with m_interaction.Toggle(false);
              this.EVMShutDownMachine();
              return;
            };
            break;

          case EVMDropsOnBreakingEnum.Exclusively: // if only drops on breaking
            if RandRange(0, 100) < settings.onHitBreakOdds {
              if RandRange(0, 100) < settings.onHitEddiesOdds { this.EVMOnHitDropEddies(); };
              if Equals(this.m_controllerTypeName, n"IceMachineController") {
                if RandRange(0, 100) < settings.onHitJunkOdds { this.EVMOnHitDelayedDispense(); };
              } else {
                if RandRange(0, 100) < settings.onHitItemOdds { this.EVMOnHitDelayedDispense(); };
                if RandRange(0, 100) < settings.onHitJunkOdds {
                  this.EVMDispenseOneJunk(1, true);
                }; // slaught-o-matic doesn't dispense junk
              };
              this.SendSoldOutToUIBlackboard(true);
              this.DeactivateDevice(); // disables InteractionComponent with m_interaction.Toggle(false);
              this.EVMShutDownMachine();
              return;
            };
            break;
        };
      } else { // if only one item is allowed to fall at a time
        switch dropsOnBreaking {
          case EVMDropsOnBreakingEnum.Never: // if never drops on breaking
            if RandRange(0, 100) < settings.onHitBreakOdds {
              this.SendSoldOutToUIBlackboard(true);
              this.DeactivateDevice(); // disables InteractionComponent with m_interaction.Toggle(false);
              this.EVMShutDownMachine();
              return;
            };
            this.EVMOnHitSingleDropRandomizer();
            break;

          case EVMDropsOnBreakingEnum.Sometimes: // if sometimes drops on breaking
            this.EVMOnHitSingleDropRandomizer();
            if RandRange(0, 100) < settings.onHitBreakOdds {
              this.SendSoldOutToUIBlackboard(true);
              this.DeactivateDevice(); // disables InteractionComponent with m_interaction.Toggle(false);
              this.EVMShutDownMachine();
              return;
            };
            break;

          case EVMDropsOnBreakingEnum.Exclusively: // if only drops on breaking
            if RandRange(0, 100) < settings.onHitBreakOdds {
              this.EVMOnHitSingleDropRandomizer();
              this.SendSoldOutToUIBlackboard(true);
              this.DeactivateDevice(); // disables InteractionComponent with m_interaction.Toggle(false);
              this.EVMShutDownMachine();
              return;
            };
            break;
        };
      };
    };
  };

  super.OnHitEvent(hit);

  if !Equals(this.GetCurrentGameplayRole(), EGameplayRole.None)
  && !Equals(devicePS.evmMalfunctionName, "broken") {
    this.EVMSetupBlackFlickerListener();
    this.EVMStartBlackGlitch(true, false, false);
    if !Equals(this.m_controllerTypeName, n"WeaponVendingMachineController") {
      this.EVMSetupBlackGlitchListener();
    }
  };
}

@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMDispenseOneJunk(delay:Int32, hitTriggered:Bool) -> Void {
  let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let junkItem: ItemID = this.DetermineJunkItem();

  if TDBID.IsValid(ItemID.GetTDBID(junkItem)) {
    TS.GiveItem(this, junkItem, 1);
    this.DelayHackedEvent(Cast<Float>(delay)*0.2, junkItem);
    this.EVMCountOnDrop();

    let devicePS = this.GetDevicePS();
    if Equals(hitTriggered, true)
    && Equals(devicePS.evmMalfunctionName, "static")
    && devicePS.evmHacksRemaining <= 0 {
      devicePS.m_isReady = false;
      this.RefreshUI();
    };
  };
}


@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMOnHitSingleDropRandomizer() -> Void {
  let settings = new EVMMenuSettings();

  // 0=item, 1=eddies, 2 is excluded
  if RandRange(0, 2) == 0 { // if the item is first
    if !Equals(this.m_controllerTypeName, n"IceMachineController")
    && RandRange(0, 100) < settings.onHitItemOdds {
      this.EVMOnHitDelayedDispense();
      return;
    };
    if RandRange(0, 100) < settings.onHitEddiesOdds {
      this.EVMOnHitDropEddies();
      return;
    };
  } else { // if eddies are first
    if RandRange(0, 100) < settings.onHitEddiesOdds {
      this.EVMOnHitDropEddies();
      return;
    };
    if !Equals(this.m_controllerTypeName, n"IceMachineController")
    && RandRange(0, 100) < settings.onHitItemOdds {
      this.EVMOnHitDelayedDispense();
      return;
    };
  };

  if Equals(this.m_controllerTypeName, n"IceMachineController") {
    if RandRange(0, 100) < settings.onHitJunkOdds {
      this.EVMOnHitDelayedDispense();
    };
  } else { // weapon vending machine (slaught-o-matic) doesn't dispense junk
    if RandRange(0, 100) < settings.onHitJunkOdds {
      this.EVMDispenseOneJunk(1, true);
    };
  };
}


@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMOnHitDropEddies() -> Void {
  let settings = new EVMMenuSettings();
  let min: Int32 = settings.onHitEddiesMin;
  let max: Int32 = settings.onHitEddiesMax;
  if min >= max { min = max - 1; };
  let quantity = RandRange(min, max+1); // last # of range is excluded, therefore +1 to make sure 'max' is included
  let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());

  if Equals(settings.onHitEddiesDeposit, false) { // if direct deposit off
    let callback = new EVMDispenseEddieBundles();
    callback.vendingMachine = this;
    callback.lootManager = GameInstance.GetLootManager(this.GetGame());
    let moneyItem: ItemID = ItemID.FromTDBID(t"Items.money");
    ArrayPush(callback.dropInstructions, DropInstruction.Create(moneyItem, quantity));
    TS.GiveItem(this, moneyItem, quantity);
    let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.GetGame());
    delaySystem.DelayCallback(callback, 0.2, true);
    this.EVMCountOnDrop();
  } // else { // if direct deposit on
  //   TS.GiveItem(GetPlayer(this.GetGame()), MarketSystem.Money(), quantity);
  // };
  let devicePS = this.GetDevicePS();

  if Equals(devicePS.evmMalfunctionName, "static")
  && devicePS.evmHacksRemaining <= 0
  && !Equals(this.m_controllerTypeName, n"IceMachineController") {
    devicePS.m_isReady = false;
    this.RefreshUI();
  }
}


protected class EVMRepeatBlackGlitchEvent extends Event {
  let isPunch: Bool = false;
  let isBlackFlicker: Bool = false;
  let isShortGlitch: Bool = false;
}

// only 1 listener can be assigned in a single frame if in the same function, and last listener will take priority
@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMSetupBlackFlickerListener() -> Void {
  if this.GetDevicePS().evmBlackFlickerCallbackID == 0u { // 0u turns zero into a Uint32 instead of Int32
    let evt = new EVMRepeatBlackGlitchEvent();
    evt.isPunch = false;
    evt.isBlackFlicker = true;
    evt.isShortGlitch = false;
    let delay: GameTime = GameTime.MakeGameTime(0, 0, 0, 50); // days, hours, opt minutes, opt seconds
    this.GetDevicePS().evmBlackFlickerCallbackID = GameInstance.GetTimeSystem(this.GetDevicePS().GetGameInstance()).RegisterDelayedListener(this, evt, delay, -1);
    this.OnEVMRepeatBlackGlitchEvent(evt);
  };
}

// only 1 listener can be assigned in a single frame if in the same function, and last listener will take priority
@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMSetupBlackGlitchListener() -> Void {
  if this.GetDevicePS().evmBlackGlitchCallbackID == 0u // 0u turns zero into a Uint32 instead of Int32
  && !Equals(this.GetDevicePS().evmMalfunctionName, "static") {
    let evt = new EVMRepeatBlackGlitchEvent();
    evt.isPunch = false;
    evt.isBlackFlicker = false;
    evt.isShortGlitch = true;
    let delay: GameTime = GameTime.MakeGameTime(0, 0, 0, 1); // days, hours, opt minutes, opt seconds
    this.GetDevicePS().evmBlackGlitchCallbackID = GameInstance.GetTimeSystem(this.GetDevicePS().GetGameInstance()).RegisterDelayedListener(this, evt, delay, -1);
    this.StartShortGlitch();
  };
}


@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnEVMRepeatBlackGlitchEvent(evt:ref<EVMRepeatBlackGlitchEvent>) {
  if this.GetDevicePS().m_distractionTimeCompleted {
    let delaySystem = GameInstance.GetDelaySystem(this.GetGame());
    if evt.isBlackFlicker { // if black screen flicker
      let callback = new EVMRepeatBlackGlitchCallback();
      callback.machine = this;
      callback.isPunch = false;
      callback.isBlackFlicker = true;
      callback.isShortGlitch = false;
      delaySystem.DelayCallback(callback, RandRangeF(1, 10), true); // randomize start times
    };
    if evt.isShortGlitch { // if on-hit short glitch
      let callback = new EVMStopBlackGlitchCallback();
      callback.machine = this;
      callback.isPunch = false;
      callback.isBlackFlicker = false;
      callback.isShortGlitch = true;
      delaySystem.DelayCallback(callback, RandRangeF(0.25, 0.5), true); // randomize start times
    };
  };
}


protected class EVMRepeatBlackGlitchCallback extends DelayCallback {
  let machine: ref<VendingMachine>;
  let isPunch: Bool;
  let isBlackFlicker: Bool;
  let isShortGlitch: Bool;
  protected func Call() -> Void {
      this.machine.EVMStartBlackGlitch(this.isPunch, this.isBlackFlicker, this.isShortGlitch);
  }
}

// ABOVE IS EVENT STUFF

@addField(InteractiveDevice) // <- Device <- DeviceBase <-
protected let evmBlackScreenTimer: Int32 = 0;

@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMStartBlackGlitch(isPunch:Bool, isBlackFlicker:Bool, isShortGlitch:Bool) -> Void {
  let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.GetGame());
  let callback = new EVMStopBlackGlitchCallback();
  callback.machine = this;
  callback.isPunch = isPunch;
  callback.isBlackFlicker = isBlackFlicker;
  callback.isShortGlitch = isShortGlitch;
  this.GetDevicePS().m_isReady = false;
  this.RefreshUI();

  if isPunch
  && !isBlackFlicker
  && !isShortGlitch {
    this.GetDevicePS().evmIsReady = false;
    this.evmBlackScreenTimer += 1;
    delaySystem.DelayCallback(callback, RandRangeF(1, 3), true); // this is the duration of the on-hit black screen
  };
  if !isPunch
  && isBlackFlicker
  && !isShortGlitch {
    delaySystem.DelayCallback(callback, RandRangeF(0.01, 0.05), true); // this is the duration of the black flicker
  };
}

@addField(InteractiveDevice) // <- Device <- DeviceBase <-
let evmHitCounter: Int32 = 0;

protected class EVMStopBlackGlitchCallback extends DelayCallback {
  let machine: ref<VendingMachine>;
  let isPunch: Bool;
  let isBlackFlicker: Bool;
  let isShortGlitch: Bool;
  protected func Call() -> Void {
    let devicePS = this.machine.GetDevicePS();
    if !this.isBlackFlicker {
      if this.isPunch {
        this.machine.evmBlackScreenTimer -= 1;
        this.machine.evmHitCounter += 1;
      };
      if this.machine.evmBlackScreenTimer <= 0 {
        devicePS.EVMUnregisterHitBlackGlitch();
        this.machine.evmBlackScreenTimer = 0;
        if devicePS.m_distractionTimeCompleted {
          if this.machine.evmHitCounter < 20
          && devicePS.evmHacksRemaining >= 0
          && !devicePS.IsSoldOut() {
            devicePS.m_isReady = true;
            devicePS.evmIsReady = true;
          } else {
            devicePS.m_isReady = false;
            devicePS.evmIsReady = false;
          };
          this.machine.RefreshUI();
        };
      } else {
        if !Equals(devicePS.evmMalfunctionName, "static")
        && devicePS.m_distractionTimeCompleted {
          if this.isShortGlitch { this.machine.StartShortGlitch(); };
        };
      };
    } else { // if this is a black flicker
      if devicePS.m_distractionTimeCompleted {
        if devicePS.evmHacksRemaining >= 0
        && !devicePS.IsSoldOut()
        && ( ( Equals(this.machine.m_controllerTypeName, n"VendingMachineController") && devicePS.evmIsReady )
        || !Equals(this.machine.m_controllerTypeName, n"VendingMachineController") ) {
          devicePS.m_isReady = true;
        };
        this.machine.RefreshUI();
      };
    };
  };
}

// this is used for PachinkoMachine & ArcadeMachine
@wrapMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Void { // also affects PachinkoMachine
  let devicePS = this.GetDevicePS();
  if !Equals(this.GetCurrentGameplayRole(), EGameplayRole.None)
  || !Equals(devicePS.evmMalfunctionName, "broken") {
    wrappedMethod(hit); // conditional checks have been built into StartGlitching() for Arcade/PachinkoMachine
    let settings = new EVMMenuSettings();
    if Equals(this.GetDeviceState(), EDeviceStatus.ON)
    && RandRange(0, 100) < settings.onHitBreakOdds {
      this.TurnOffDevice();
      this.EVMShutDownMachine();
    };
  };
}

// this is used for DropPoint only
@wrapMethod(DropPoint) // <- BasicDistractionDevice <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Void {
  let devicePS = this.GetDevicePS();
  if !Equals(this.GetCurrentGameplayRole(), EGameplayRole.None)
  || !Equals(devicePS.evmMalfunctionName, "broken") {
    let settings = new EVMMenuSettings();
    if Equals(settings.onHitDropPoint, false) {
      wrappedMethod(hit); // default behavior
    } else {
      if devicePS.evmHacksRemaining > 0
      || !devicePS.moduleExistsDropPointMalfunctions {
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
      || !devicePS.moduleExistsConfessionBoothMalfunctions {
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