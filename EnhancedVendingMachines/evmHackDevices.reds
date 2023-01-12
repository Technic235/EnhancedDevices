import evmMenuSettings.*

// PachinkoMachine <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice
// PachinkoMachineController <- ArcadeMachineController <- ScriptableDeviceComponent <- DeviceComponent
// PachinkoMachineControllerPS <- ArcadeMachineControllerPS <- (skips BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS

@addField(ScriptableDeviceComponentPS)
protected let evmHackCount: Int32 = 2;

// PachinkoMachine <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice
@wrapMethod(InteractiveDevice) // this is used for PachinkoMachine, ArcadeMachine, & DropPoint
protected cb func OnQuickHackDistraction(evt:ref<QuickHackDistraction>) -> Void {
  wrappedMethod(evt);
  if evt.IsCompleted() { return; }; // cancels function
  let settings: ref<evmMenuSettings> = new evmMenuSettings();
  if (Equals(this.m_controllerTypeName, n"DropPointController")
  && Equals(settings.evmHackDropPoints, true))
  || (Equals(this.m_controllerTypeName, n"ArcadeMachineController")
  && Equals(settings.evmHackArcadeMachines, true))
  || (Equals(this.GetTweakDBRecord(), t"Devices.FuelDispenser")
  && Equals(settings.evmHackFuelPumps, true))
  {
    let controllerPS = this.GetDevicePS();
    if controllerPS.evmHackCount > -1 { controllerPS.evmHackCount -= 1; };
    if controllerPS.evmHackCount == -1 { return; }; // cancels function
    let eddiesOddsCheck: Int32 = RandRange(0, 100);
    if eddiesOddsCheck < settings.evmEddiesOdds {
      let min: Int32 = settings.evmEddiesMin;
      let max: Int32 = settings.evmEddiesMax;
      if min >= max { min = max-1; };
      let quantity = RandRange(min, max+1); // last # of range is excluded, therefore +1 to make sure 'max' is included
      let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
      TS.GiveItem(GetPlayer(this.GetGame()), MarketSystem.Money(), quantity);
    };

    if controllerPS.evmHackCount == 0 {
      if !this.GetBlackboard().GetBool(GetAllBlackboardDefs().VendingMachineDeviceBlackboard.SoldOut) { // if sold out but not set to sold out.
        this.GetBlackboard().SetBool(GetAllBlackboardDefs().VendingMachineDeviceBlackboard.SoldOut, true); // set to sold out
      };
    };
  };
}

// PachinkoMachine <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice
@wrapMethod(ArcadeMachine) // this is used for PachinkoMachine & ArcadeMachine
protected func StopGlitching() -> Void {
  let settings: ref<evmMenuSettings> = new evmMenuSettings();
  let controllerPS = this.GetDevicePS();
  if Equals(settings.evmHackArcadeMachines, true)
  && controllerPS.evmHackCount <= 0 {
    this.StartGlitching(EGlitchState.DEFAULT, 1.0);
  } else {
    wrappedMethod();
  };
}

// PachinkoMachineControllerPS <- ArcadeMachineControllerPS <- (skips BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS
@wrapMethod(ArcadeMachineControllerPS) // this is used for ArcadeMachine only
protected func GetQuickHackActions(out outActions:array<ref<DeviceAction>>, context:GetActionsContext) {
  let settings: ref<evmMenuSettings> = new evmMenuSettings();
  if Equals(settings.evmHackArcadeMachines, true)
  && this.evmHackCount <= 0 {
		let currentAction:ref<ScriptableDeviceAction>;
		currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenSuicide", t"QuickHack.SuicideHackBase");
		currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
		ArrayPush(outActions, currentAction);
		currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenBlind", t"QuickHack.BlindHack");
		currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
		ArrayPush(outActions, currentAction);
		currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenGrenade", t"QuickHack.GrenadeHackBase");
		currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
		ArrayPush(outActions, currentAction);
		if !GlitchScreen.IsDefaultConditionMet(this, context) {
			ScriptableDeviceComponentPS.SetActionsInactiveAll(outActions, "LocKey#7003", n"");
		};
		currentAction = this.ActionQuickHackDistraction();
		currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
		currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    currentAction.SetInactiveWithReason(false, "LocKey#7003");
		ArrayPush(outActions, currentAction);
		if this.IsGlitching() || this.IsDistracting() {
			ScriptableDeviceComponentPS.SetActionsInactiveAll(outActions, "LocKey#7004", n"");
		};
		this.FinalizeGetQuickHackActions(outActions, context);
  } else {
    wrappedMethod(outActions, context);
  };
}

// PachinkoMachineControllerPS <- ArcadeMachineControllerPS <- (skips BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS
@wrapMethod(PachinkoMachineControllerPS) // this is used for PachinkoMachine only
protected func GetQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) {
  let settings: ref<evmMenuSettings> = new evmMenuSettings();
  if Equals(settings.evmHackArcadeMachines, true)
  && this.evmHackCount <= 0 {
    let currentAction: ref<ScriptableDeviceAction>;
    currentAction = this.ActionQuickHackDistraction();
    currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    currentAction.SetInactiveWithReason(false, "LocKey#7003");
    ArrayPush(actions, currentAction);
    if this.IsGlitching() || this.IsDistracting() {
      ScriptableDeviceComponentPS.SetActionsInactiveAll(actions, "LocKey#7004");
    };
    this.FinalizeGetQuickHackActions(actions, context);
  } else {
    wrappedMethod(actions, context);
  };
}

// PachinkoMachine <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice
@wrapMethod(ArcadeMachine) // this is used for PachinkoMachine & ArcadeMachine
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Void {
  let settings: ref<evmMenuSettings> = new evmMenuSettings();
  let controllerPS = this.GetDevicePS();
  if Equals(settings.evmHackArcadeMachines, true) {
    let settings: ref<evmMenuSettings> = new evmMenuSettings();
    if RandRange(0, 100) < settings.evmHooliganBreakOdds
    && Equals(this.GetDeviceState(), EDeviceStatus.ON) {
      this.TurnOffDevice();
      controllerPS.SetDeviceState(this.GetDeviceState().OFF);
    };
  } else {
    wrappedMethod(hit);
  };
}