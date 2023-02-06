module TravelTerminalOnHit

// this is used for DataTerm (Fast Travel Terminal) only
@wrapMethod(DataTerm) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Void {
  let devicePS = this.GetDevicePS();
  this.StartHoloFlicker();
  this.EVMSetupHoloFlickerListener();
  if !Equals(this.GetCurrentGameplayRole(), EGameplayRole.None)
  || !Equals(devicePS.evmMalfunctionName, "broken") {
    let settings = new EVMMenuSettings();
    if Equals(settings.onHitTravelTerminal, false) {
      wrappedMethod(hit); // default behavior
    } else {
      if devicePS.evmHacksRemaining > 0
      || !devicePS.moduleExistsTravelTerminalMalfunctions {
        wrappedMethod(hit); // default behavior
      } else { // still can trigger security but doesn't cancel glitching
        super.OnHitEvent(hit);
      };
      // if Equals(this.GetDeviceState(), EDeviceStatus.ON)
      if RandRange(0, 100) < settings.onHitBreakOdds {
        this.EVMShutDownMachine();
      };
    };
  };
}

@wrapMethod(DataTerm) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func StartGlitching(glitchState:EGlitchState, opt intensity:Float) {
  wrappedMethod(glitchState, intensity);
  let devicePS = this.GetDevicePS();
  if devicePS.evmHacksRemaining <= 0 {
    this.EVMSetupHoloFlickerListener();
  };
}

// basically a copy of EVMSetupShortGlitchListener() on InteractiveDevice in Malfunctions_Dependencies.reds
@addMethod(InteractiveDevice) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMSetupHoloFlickerListener() -> Void {
  let devicePS = this.GetDevicePS();
	if devicePS.evmHoloFlickerCallbackID == 0u { // 0u turns zero into a Uint32 instead of Int32
    let evt = new EVMHoloFlickerEvent();
    let delay: GameTime = GameTime.MakeGameTime(0, 0, 0, 5); // days, hours, opt minutes, opt seconds
		devicePS.evmHoloFlickerCallbackID = GameInstance.GetTimeSystem(devicePS.GetGameInstance()).RegisterDelayedListener(this, evt, delay, -1);
    // argument repeat:Int32 repeats that many times (10 times if set to 10) or infinitely if it's set to -1.
	};
}

protected class EVMHoloFlickerEvent extends Event {
  // intentionally empty
}

@addMethod(DataTerm) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnEVMHoloFlickerEvent(evt:ref<EVMHoloFlickerEvent>) {
  let delaySystem = GameInstance.GetDelaySystem(this.GetGame());
  let callback = new EVMHoloFlickerCallback();
  callback.dataTerm = this;
  delaySystem.DelayCallback(callback, 0, true);
}

protected class EVMHoloFlickerCallback extends DelayCallback {
  let dataTerm: ref<DataTerm>;
  protected func Call() -> Void {
    this.dataTerm.StartHoloFlicker();
  }
}