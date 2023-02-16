module EnhancedDevices.Hacking.Jukebox
import EnhancedDevices.Settings.*

// Jukebox <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// JukeboxController <- (skips BasicDistractionDevice) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// JukeboxControllerPS <- (skips BasicDistractionDevice) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

// wrapping the cb func was causing irreparable issues
@addMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
protected cb func OnQuickHackDistraction(evt:ref<QuickHackDistraction>) { // CALLED TWICE
  if evt.IsStarted() {
		this.ShowQuickHackDuration(evt); // from Device
		this.StartGlitching(EGlitchState.DEFAULT, 1.0); // from Device
    let settings = new EVMMenuSettings();
    if Equals(this.m_controllerTypeName, n"JukeboxController")
    && settings.hackJukebox { this.EVMMoneyFromHacking(); };
  };

  if evt.IsCompleted() {
    this.StopGlitching(); // from Device
  };
}