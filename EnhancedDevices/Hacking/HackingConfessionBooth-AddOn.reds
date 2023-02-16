module EnhancedDevices.Hacking.ConfessionBooth
import EnhancedDevices.Settings.*

// ConfessionBooth <- BasicDistractionDevice <- InteractiveDevice <- (skips) <- Device <-
// ConfessionBoothController <- BasicDistractionDeviceController <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// ConfessionBoothControllerPS <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

// wrapping the cb func was causing irreparable issues
@addMethod(ConfessionBooth) // <- BasicDistractionDevice <- InteractiveDevice <- Device <-
protected cb func OnQuickHackDistraction(evt:ref<QuickHackDistraction>) { // CALLED TWICE
  if evt.IsStarted() {
		this.ShowQuickHackDuration(evt); // from Device
		this.StartGlitching(EGlitchState.DEFAULT, 1.0); // from Device
    this.StartDistraction(true); // from BasicDistractionDevice
    let settings = new EVMMenuSettings();
    if Equals(this.m_controllerTypeName, n"ConfessionBoothController")
    && settings.hackConfessionBooth { this.EVMMoneyFromHacking(); };
  };

  if evt.IsCompleted() {
    this.StopGlitching(); // from Device
    this.StopDistraction(); // from BasicDistractionDevice
  };
}