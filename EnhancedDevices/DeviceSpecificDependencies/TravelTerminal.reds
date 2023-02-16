module EnhancedDevices.TravelTerminal

// DataTerm <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// DataTermController <- (skips BasicDistractionDeviceController) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// DataTermControllerPS <- (BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

// needed for EVMShutDownMachine() & when DataTerm gains "static" malfunction
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
let evmHoloFlickerCallbackID: Uint32;

// needed for RestartDevice() on InteractiveDevice in Malfunctions
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
    delaySystem.DelayCallback(callback, RandRangeF(0.01, 0.05), true);
  };
}

protected class EVMEndDataTermHoloFlickerCallback extends DelayCallback {
  let dataTerm: ref<DataTerm>;
  protected func Call() -> Void {
    this.dataTerm.GetDevicePS().GetDeviceOperationsContainer().Execute(n"show_holo", this.dataTerm);
    if !Equals(this.dataTerm.GetDevicePS().evmMalfunctionName, "broken") {
      this.dataTerm.m_uiComponent.Toggle(true);
    };
  }
}

@wrapMethod(DataTerm)
protected func StartShortGlitch() {
  this.StartHoloFlicker();
  wrappedMethod();
}