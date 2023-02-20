module EnhancedDevices.Hacking.Jukebox
import EnhancedDevices.Settings.*

// Jukebox <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// JukeboxController <- (skips BasicDistractionDevice) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// JukeboxControllerPS <- (skips BasicDistractionDevice) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@wrapMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
protected cb func OnQuickHackDistraction(evt:ref<QuickHackDistraction>) { // defined on Device & CALLED TWICE
  wrappedMethod(evt);
  if this.IsA(n"Jukebox")
  && evt.IsStarted() {
    let settings = new EVMMenuSettings();
    if settings.hackJukebox { this.EVMMoneyFromHacking(); };
  };
}