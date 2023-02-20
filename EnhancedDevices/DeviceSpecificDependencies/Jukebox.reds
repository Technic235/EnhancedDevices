module EnhancedDevices.Jukebox
import EnhancedDevices.Malfunctions.*

// Jukebox <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// JukeboxController <- (skips BasicDistractionDevice) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// JukeboxControllerPS <- (skips BasicDistractionDevice) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@if(!ModuleExists("EnhancedDevices.OnHit.Jukebox"))
@wrapMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) { // defined on Device
  wrappedMethod(hit); // triggers security but doesn't cancel glitching
  if this.IsA(n"Jukebox")
  && !this.GetDevicePS().moduleExistsMalfunctionsJukebox {
    this.StartShortGlitch();
  };
}

@addField(Jukebox) let m_isShortGlitchActive: Bool = false;
@addField(Jukebox) let m_shortGlitchDelayID: DelayID;

@addMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
protected func StartShortGlitch() { // not defined anywhere
if this.GetDevicePS().IsGlitching() { return; };
  if !this.m_isShortGlitchActive {
    let evt = new StopShortGlitchEvent();
    this.StartGlitching(EGlitchState.DEFAULT, 1.0, true);
    this.m_shortGlitchDelayID = GameInstance.GetDelaySystem(this.GetGame()).DelayEvent(this, evt, 0.25);
    this.m_isShortGlitchActive = true;
  };
}

@addMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
protected cb func OnStopShortGlitch(evt:ref<StopShortGlitchEvent>) { // not defined anywhere
  this.m_isShortGlitchActive = false;
  if !this.GetDevicePS().IsGlitching() {
    this.StopGlitching();
  };
}

@addMethod(Jukebox) // <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
protected func StartGlitching(glitchState:EGlitchState, opt intensity:Float, isShortGlitch:Bool) { // overload of an existing function on Jukebox
  this.AdvertGlitch(true, this.GetGlitchData(glitchState));
  this.RefreshUI();
}