// <- InteractiveDevice <- (skips) <- Device <- DeviceBase <-
// <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@addMethod(InteractiveDevice) // <- (one-layer discrepancy) <- Device <- DeviceBase <-
protected func RestartDevice() {
  let devicePS = this.GetDevicePS();
  devicePS.EVMUnregisterHoloFlicker();
  devicePS.SetDeviceState(EDeviceStatus.ON);
  this.m_uiComponent.Toggle(true);
  if !Equals(devicePS.evmMalfunctionName, "glitch") {
    devicePS.evmMalfunctionName = "";
  } else { // keeps the short glitch malfunction if it already had one
    devicePS.evmHacksRemaining = 1; // this must go before StartGlitching to prevent items from dispensing
    this.EVMSetupShortGlitchListener();
    return;
  };
}

// called by DropPoint/VendingMachine/ArcadeMachine-ResolveGameplayState() in Malfunctions
@addMethod(InteractiveDevice) // <- (one-layer discrepancy) <- Device <- DeviceBase <-
protected func SetStartingMalfunction(shortLimit:Float, staticLimit:Float, brokenLimit:Float) -> Void {
  let devicePS = this.GetDevicePS();
  let randomNum = RandRangeF(0, 1);
  if 0.0 < randomNum && randomNum <= shortLimit {
    devicePS.evmHacksRemaining = 1;
    this.EVMSetupShortGlitchListener(); // malfunction = glitch
    return;
  };
  if randomNum <= staticLimit {
    devicePS.evmMalfunctionName = "static"; // this must go before StartGlitching to prevent items from dispensing
    if Equals(this.m_controllerTypeName, n"DropPointController") { // cb func OnQuickHackDistraction is on BasicDistractionDevice & Device so 2 hacks get subtracted every hack
      devicePS.evmHacksRemaining = -1; // so set StopGlitching to work if hacksRemaining is ">= 0" instead of "> 0" to counteract the double subtract
    } else {
      devicePS.evmHacksRemaining = 0;
    };
    (this as VendingMachine).LoudVendingMachines(false);
    this.StartGlitching(EGlitchState.DEFAULT, 1.0); // this invokes HackedEffect
    return;
  };
  if randomNum <= brokenLimit {
    this.EVMShutDownMachine(); // malfunction = broken
  };
}

@addMethod(InteractiveDevice) // <- (one-layer discrepancy) <- Device <- DeviceBase <-
protected func EVMSetupShortGlitchListener() -> Void {
  let devicePS = this.GetDevicePS();
	if devicePS.evmShortGlitchCallbackID == 0u { // 0u turns zero into a Uint32 instead of Int32
    devicePS.evmMalfunctionName = "glitch";
    let evt = new EVMShortGlitchEvent();
    let delay: GameTime = GameTime.MakeGameTime(0, 0, 0, 15); // days, hours, opt minutes, opt seconds
    // Make the numbers bigger since game time is faster than real time. Might also be able to replace with real time in the future.
    // If I'm understanding this correctly, this is dirty coding. The event gets called every 15 game-seconds.
    // Since EVMResetShortGlitchCycle uses a random delay, StartShortGlitch will not occur in-game because another short glitch is already occuring.
    // So it seems more random than it is since some short glitches are skipped. Or it could be that this event waits until RepeatDelayedShortGlitch is finished. Who knows.
		devicePS.evmShortGlitchCallbackID = GameInstance.GetTimeSystem(devicePS.GetGameInstance()).RegisterDelayedListener(this, evt, delay, -1);
    // argument repeat:Int32 repeats that many times (10 times if set to 10) or infinitely if it's set to -1.
	};
}

protected class EVMShortGlitchEvent extends Event {
  // intentionally empty
}

// OnEVMShortGlitchEvent() in DropPoint/Arcade/VendingMachine Malfunction files

protected class EVMShortGlitchCallback extends DelayCallback {
  let machine: ref<InteractiveDevice>;
  protected func Call() -> Void {
    if this.machine.GetDevicePS().evmHacksRemaining > 0 {
      if Equals(this.machine.m_controllerTypeName, n"VendingMachineController")
      || Equals(this.machine.m_controllerTypeName, n"WeaponVendingMachineController")
      || Equals(this.machine.m_controllerTypeName, n"IceMachineController") {
        (this.machine as VendingMachine).StartShortGlitch(); // defined on VendingMachine
      };
      if Equals(this.machine.m_controllerTypeName, n"ArcadeMachineController")
      || Equals(this.machine.m_controllerTypeName, n"PachinkoMachineController") {
        (this.machine as ArcadeMachine).StartShortGlitch(); // defined on ArcadeMachine
      };
      if Equals(this.machine.m_controllerTypeName, n"DropPointController") {
        (this.machine as DropPoint).StartShortGlitch(); // defined on DropPoint
      };
      if Equals(this.machine.m_controllerTypeName, n"ConfessionBoothController") {
        (this.machine as ConfessionBooth).StartShortGlitch(); // defined on ConfessionBooth
      };
      if Equals(this.machine.m_controllerTypeName, n"DataTermController") {
        (this.machine as DataTerm).StartShortGlitch(); // defined on DataTerm
        // StartHoloFlicker() added to StartShortGlitch()
      };
    };
  }
}