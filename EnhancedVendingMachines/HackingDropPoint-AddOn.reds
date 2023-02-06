module DropPointHacking
// DropPoint <- BasicDistractionDevice <- InteractiveDevice
// DropPointController <- ScriptableDeviceComponent <- DeviceComponent
// DropPointControllerPS <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS

// by having one cb func on BasicDistractionDevice and another on class Device, it was subtracting 2 hacks each time instead of just one.
// wrapping the cb func was causing irreparable issues
@addMethod(DropPoint) // <- BasicDistractionDevice <- InteractiveDevice <- Device <-
protected cb func OnQuickHackDistraction(evt:ref<QuickHackDistraction>) { // CALLED TWICE
  if evt.IsStarted() {
		this.ShowQuickHackDuration(evt); // from Device
		this.StartGlitching(EGlitchState.DEFAULT, 1.0); // from Device
    this.StartDistraction(true); // from BasicDistractionDevice
    let settings = new EVMMenuSettings();
    if Equals(settings.hackDropPoints, true) { this.EVMMoneyFromHacking(); };
  };

  if evt.IsCompleted() {
    this.StopGlitching(); // from Device
    this.StopDistraction(); // from BasicDistractionDevice
  };
}