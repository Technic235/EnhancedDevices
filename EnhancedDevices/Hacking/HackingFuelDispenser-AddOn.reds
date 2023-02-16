module EnhancedDevices.Hacking.FuelDispenser
import EnhancedDevices.Settings.*
// ExplosiveDevice <- BasicDistractionDevice <- InteractiveDevice <- (skips) <- Device <-
// ExplosiveDeviceController <- BasicDistractionDeviceController <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// ExplosiveDeviceControllerPS <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@wrapMethod(ExplosiveTriggerDevice) // <- ExplosiveDevice <- BasicDistractionDevice <-
protected func ResolveGameplayState() {
  wrappedMethod();
  this.m_controllerTypeName = n"ExplosiveTriggerDeviceController";
}

@wrapMethod(SensorDevice) // <- ExplosiveDevice <- BasicDistractionDevice <-
protected func ResolveGameplayState() {
  wrappedMethod();
  this.m_controllerTypeName = n"SensorDeviceController";
}

@wrapMethod(ExplosiveDeviceControllerPS) // <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS <-
protected func GetQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) {
  if Equals(this.m_distractorType, EPlaystyleType.TECHIE) || Equals(this.m_distractorType, EPlaystyleType.NONE) { return; };
  let settings = new EVMMenuSettings();
  if Equals((this.GetOwnerEntityWeak() as ExplosiveDevice).m_controllerTypeName, n"ExplosiveDeviceController")
  && settings.hackExplosiveDevice {
    let currentAction: ref<ScriptableDeviceAction>;
    currentAction = this.ActionQuickHackDistraction();
    if this.evmHacksRemaining <= 0 || !GlitchScreen.IsDefaultConditionMet(this, context) {
      currentAction.SetInactiveWithReason(false, "LocKey#7003"); // THIS AFFECTS ONE QUICKHACK & GOES BEFORE ARRAYPUSH
    };
    ArrayPush(actions, currentAction);

    if !this.IsExplosiveWithQhacks() {
      this.EVMFinalizeQuickHackActions(actions, context);
      return;
    };
    if this.IsON() && this.IsDisabledWithQhacks() {
      currentAction = this.ActionQuickHackToggleON();
      // currentAction.SetObjectActionID(t"DeviceAction.ToggleStateClassHack");
      ArrayPush(actions, currentAction);
    };
    if this.HasNPCWorkspotKillInteraction() && this.IsSomeoneUsingNPCWorkspot() {
      currentAction = this.ActionOverloadDevice();
      currentAction.SetObjectActionID(t"DeviceAction.OverloadClassHack");
      currentAction.SetInactiveWithReason(!this.m_wasQuickHacked && this.IsSomeoneUsingNPCWorkspot(), "LocKey#7011");
      ArrayPush(actions, currentAction);
    } else {
      currentAction = this.ActionQuickHackExplodeExplosive();
      currentAction.SetObjectActionID(t"DeviceAction.OverloadClassHack");
      ArrayPush(actions, currentAction);
    };

    this.EVMFinalizeQuickHackActions(actions, context);
  } else {
    wrappedMethod(actions, context);
  };
}

// no glitch effect for fuel dispensers but I still included the code, just in case

// wrapping the cb func was causing irreparable issues
@addMethod(ExplosiveDevice) // <- BasicDistractionDevice <- InteractiveDevice <- Device <-
protected cb func OnQuickHackDistraction(evt:ref<QuickHackDistraction>) { // CALLED TWICE
  if evt.IsStarted() {
		this.ShowQuickHackDuration(evt); // from Device
		this.StartGlitching(EGlitchState.DEFAULT, 1.0); // from Device
    this.StartDistraction(true); // from BasicDistractionDevice
    let settings = new EVMMenuSettings();
    if Equals(this.m_controllerTypeName, n"ExplosiveDeviceController")
    && settings.hackExplosiveDevice { this.EVMMoneyFromHacking(); };
    let devicePS = this.GetDevicePS();
    if devicePS.evmHacksRemaining <= 0 {
      // devicePS.EVMUnregisterShortGlitchMalfunction(); // FuelDispensers don't have malfunctions until I can find a VFX
      devicePS.evmMalfunctionName = "static";
    };
  };

  if evt.IsCompleted() {
    this.StopGlitching(); // from Device
    this.StopDistraction(); // from BasicDistractionDevice
  };
}