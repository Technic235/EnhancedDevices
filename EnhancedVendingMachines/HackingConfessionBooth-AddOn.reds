module ConfessionBoothHacking

@wrapMethod(ConfessionBoothControllerPS) // <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS <-
protected final func GetQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) {
  let settings = new EVMMenuSettings();
  if settings.hackConfessionBooths {
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
    if this.evmHacksRemaining <= 0 || !GlitchScreen.IsDefaultConditionMet(this, context) {
      currentAction.SetInactiveWithReason(false, "LocKey#7003"); // THIS AFFECTS ONE QUICKHACK & GOES BEFORE ARRAYPUSH
    };

    ArrayPush(actions, currentAction);

    this.EVMFinalizeQuickHackActions(actions, context);
  } else {
    wrappedMethod(actions, context);
  };
}

// wrapping the cb func was causing irreparable issues
@addMethod(ConfessionBooth) // <- BasicDistractionDevice <- InteractiveDevice <- Device <-
protected cb func OnQuickHackDistraction(evt:ref<QuickHackDistraction>) { // CALLED TWICE
  if evt.IsStarted() {
		this.ShowQuickHackDuration(evt); // from Device
		this.StartGlitching(EGlitchState.DEFAULT, 1.0); // from Device
    this.StartDistraction(true); // from BasicDistractionDevice
    let settings = new EVMMenuSettings();
    if Equals(this.m_controllerTypeName, n"ConfessionBoothController")
    && settings.hackConfessionBooths { this.EVMMoneyFromHacking(); };
  };

  if evt.IsCompleted() {
    this.StopGlitching(); // from Device
    this.StopDistraction(); // from BasicDistractionDevice
  };
}