module EnhancedDevices.GetQuickHackActions
import EnhancedDevices.Settings.*

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
  if this.evmHacksRemaining <= 0
  || !GlitchScreen.IsDefaultConditionMet(this, context)
  || this.GetBlackboard().GetBool(GetAllBlackboardDefs().VendingMachineDeviceBlackboard.SoldOut) {
    let currentAction: ref<ScriptableDeviceAction>;
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenSuicide", t"QuickHack.SuicideHackBase", this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenBlind", t"QuickHack.BlindHack", this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenGrenade", t"QuickHack.GrenadeHackBase", this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);

    currentAction = this.ActionQuickHackDistraction();
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
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
  if ( ( this.moduleExistsHackingArcadeMachine && settings.hackArcadeMachine ) || this.moduleExistsMalfunctionsArcadeMachine )
  && ( this.evmHacksRemaining <= 0 || !GlitchScreen.IsDefaultConditionMet(this, context) ) {
    let currentAction: ref<ScriptableDeviceAction>;
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenSuicide", t"QuickHack.SuicideHackBase", this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenBlind", t"QuickHack.BlindHack", this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenGrenade", t"QuickHack.GrenadeHackBase", this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);

    currentAction = this.ActionQuickHackDistraction();
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
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
  if ( ( this.moduleExistsHackingArcadeMachine && settings.hackArcadeMachine ) || this.moduleExistsMalfunctionsArcadeMachine )
  && ( this.evmHacksRemaining <= 0 || !GlitchScreen.IsDefaultConditionMet(this, context) ) {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionQuickHackDistraction();
    currentAction.SetDurationValue(this.GetDistractionDuration(currentAction));
    currentAction.SetInactiveWithReason(false, "LocKey#7003"); // THIS AFFECTS ONE QUICKHACK & GOES BEFORE ARRAYPUSH
    ArrayPush(actions, currentAction);

    this.EVMFinalizeQuickHackActions(actions, context);
  } else {
    wrappedMethod(actions, context);
  };
}

// needed for HackingDataTerm and DataTermMalfunctions
// this is used for DataTerm (Fast Travel) only
@addMethod(DataTermControllerPS) // <- (skips BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <-
protected func GetQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) {
  let settings = new EVMMenuSettings();
  if ( ( this.moduleExistsHackingTravelTerminal && settings.hackTravelTerminal ) || this.moduleExistsMalfunctionsTravelTerminal )
  && Equals(this.GetDeviceState(), EDeviceStatus.ON) {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionQuickHackDistraction();
    currentAction.SetDurationValue(10);
    if this.evmHacksRemaining <= 0 || !GlitchScreen.IsDefaultConditionMet(this, context) {
      currentAction.SetInactiveWithReason(false, "LocKey#7003"); // THIS AFFECTS ONE QUICKHACK & GOES BEFORE ARRAYPUSH
    };
    ArrayPush(actions, currentAction);

    this.EVMFinalizeQuickHackActions(actions, context);
  } else {
    super.GetQuickHackActions(actions, context);
  };
}

// 
// 
// BasicDistractionDevices

// GetQuickHackActions resides in BasicDeviceComponentControllerPS
@addMethod(DropPointControllerPS) // <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS <-
protected func GetQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) -> Void {
  if Equals(this.m_distractorType, EPlaystyleType.TECHIE) || Equals(this.m_distractorType, EPlaystyleType.NONE) { return; };
  let settings = new EVMMenuSettings();
  // changed '<= 0'  to '< 0' becuz 2 hacks are being subtracted instead of 1 since cb func OnQuickHackDistraction() is on both BasicDistractionDevice and Device
  if ( ( this.moduleExistsHackingDropPoint && settings.hackDropPoint ) || this.moduleExistsMalfunctionsDropPoint )
  && ( this.evmHacksRemaining < 0 || !GlitchScreen.IsDefaultConditionMet(this, context) )
  && Equals(this.GetDeviceState(), EDeviceStatus.ON) {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionQuickHackDistraction();
    currentAction.SetInactiveWithReason(false, "LocKey#7003"); // THIS AFFECTS ONE QUICKHACK & GOES BEFORE ARRAYPUSH
    ArrayPush(actions, currentAction);

    this.EVMFinalizeQuickHackActions(actions, context);
  } else {
    super.GetQuickHackActions(actions, context);
  };
}

// needed for arcade hacking and Arcade Malfunctions
// this is used for PachinkoMachine only
@wrapMethod(JukeboxControllerPS) // <- (skips BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <-
protected func GetQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) {
  let settings = new EVMMenuSettings();
  if ( ( this.moduleExistsHackingJukebox && settings.hackJukebox ) || this.moduleExistsMalfunctionsJukebox )
  && ( this.evmHacksRemaining <= 0 || !GlitchScreen.IsDefaultConditionMet(this, context) ) {
    let currentAction: ref<ScriptableDeviceAction> = this.ActionQuickHackDistraction();
    currentAction.SetInactiveWithReason(false, "LocKey#7003"); // THIS AFFECTS ONE QUICKHACK & GOES BEFORE ARRAYPUSH
    ArrayPush(actions, currentAction);

    this.EVMFinalizeQuickHackActions(actions, context);
  } else {
    wrappedMethod(actions, context);
  };
}

@wrapMethod(ConfessionBoothControllerPS) // <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS <-
protected func GetQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) {
  let settings = new EVMMenuSettings();
  if ( ( this.moduleExistsHackingConfessionBooth && settings.hackConfessionBooth )
  || this.moduleExistsMalfunctionsConfessionBooth ) {
    let currentAction: ref<ScriptableDeviceAction>;
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenSuicide", t"QuickHack.SuicideHackBase", this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenBlind", t"QuickHack.BlindHack", this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);
    currentAction = this.ActionGlitchScreen(t"DeviceAction.GlitchScreenGrenade", t"QuickHack.GrenadeHackBase", this.GetDistractionDuration(currentAction));
    ArrayPush(actions, currentAction);

    currentAction = this.ActionQuickHackDistraction();
    if this.evmHacksRemaining <= 0 || !GlitchScreen.IsDefaultConditionMet(this, context) {
      currentAction.SetInactiveWithReason(false, "LocKey#7003"); // THIS AFFECTS ONE QUICKHACK & GOES BEFORE ARRAYPUSH
    };
    ArrayPush(actions, currentAction);

    this.EVMFinalizeQuickHackActions(actions, context);
  } else {
    wrappedMethod(actions, context);
  };
}