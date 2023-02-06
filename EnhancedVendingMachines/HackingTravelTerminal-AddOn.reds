module TravelTerminalHacking
// scanning_device_gameplay_roles.tweak
// scanner_chunks.script

@wrapMethod(QuickHackDescriptionGameController)
protected cb func OnQuickHackDataChanged(value:Variant) {
  wrappedMethod(value);
  Log(ToString(this.m_selectedData.m_actionOwnerName)); // shows up in CET in-game Game Log
  Log(this.m_selectedData.m_title);

  if Equals(this.m_selectedData.m_actionOwnerName, n"LocKey#91") // DATATERM: FAST TRAVEL ?
  && Equals(this.m_selectedData.m_title, "LocKey#6990") { // DISTRACT ENEMIES
    this.m_selectedData.m_duration = 10; // manually set duration
    this.SetupDuration();
  };
}

@addMethod(DataTermControllerPS)
protected func CanCreateAnyQuickHackActions() -> Bool {
	return true;
}

@addMethod(DataTermControllerPS) // <- (skips BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <-
protected func ActionQuickHackDistraction() -> ref<QuickHackDistraction> {
	let action = new QuickHackDistraction();
	action.SetUp(this);
	action.SetProperties();
	action.AddDeviceName(this.m_deviceName);
	action.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
  // action.SetDurationValue(this.GetDistractionDuration(action));
	action.SetDurationValue(10); // manually set duration
	// action.CreateInteraction();
	return action;
}

// wrapping the cb func was causing irreparable issues
@addMethod(DataTerm) // <- (skips BasicDistractionDevice) <- InteractiveDevice <- Device <-
protected cb func OnQuickHackDistraction(evt:ref<QuickHackDistraction>) { // CALLED TWICE
  if evt.IsStarted() {
		this.ShowQuickHackDuration(evt); // from Device
		this.StartGlitching(EGlitchState.DEFAULT, 1.0); // from Device
    let settings = new EVMMenuSettings();
    if Equals(this.m_controllerTypeName, n"DataTermController")
    && settings.hackTravelTerminal { this.EVMMoneyFromHacking(); };
  };

  if evt.IsCompleted() {
    this.StopGlitching(); // from Device
  };
}