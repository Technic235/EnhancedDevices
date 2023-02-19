module EnhancedDevices.Malfunctions
import EnhancedDevices.ArcadeMachine.*

// <- InteractiveDevice <- (skips) <- Device <- DeviceBase <-
// <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@addMethod(InteractiveDevice) // <- (one-layer discrepancy) <- Device <- DeviceBase <-
protected func RestartDevice() {
  let devicePS = this.GetDevicePS();
  devicePS.EVMUnregisterHoloFlicker();
  devicePS.SetDeviceState(EDeviceStatus.ON);
  this.m_uiComponent.Toggle(true);
}

// @addField(InteractiveDevice) let machineType: CName;

// called by DropPoint/VendingMachine/ArcadeMachine-ResolveGameplayState() in Malfunctions
@addMethod(InteractiveDevice) // <- (one-layer discrepancy) <- Device <- DeviceBase <-
protected func SetStartingMalfunction(shortLimit:Float, staticLimit:Float, brokenLimit:Float) {
  // if Equals(this.machineType, n"JukeboxController") { // Jukebox.script is on a ton of random devices
  //   if Equals(this.m_controllerTypeName, n"JukeboxController") { // but m_controllerTypeName gets overwritten on those devices
      this.ActivateStartingMalfunction(shortLimit, staticLimit, brokenLimit);
  //   } else {
  //     this.machineType = n"";
  //   };
  // } else {
  //   if !Equals(this.machineType, n"") {
  //     this.ActivateStartingMalfunction(shortLimit, staticLimit, brokenLimit);
  //   };
  // };
}


@addMethod(InteractiveDevice)
protected func ActivateStartingMalfunction(shortLimit:Float, staticLimit:Float, brokenLimit:Float) {
  let devicePS = this.GetDevicePS();
  let randomNum = RandRangeF(0, 1);
  if 0.0 < randomNum && randomNum <= shortLimit { // if randomNum falls within the glitch range
    devicePS.evmHacksRemaining = 1;
    this.EVMSetupShortGlitchListener(); // malfunction = glitch
    return;
  };
  if randomNum <= staticLimit { // if randomNum falls within the static range
    devicePS.evmMalfunctionName = "static"; // this must go before StartGlitching to prevent items from dispensing
    if Equals(this.m_controllerTypeName, n"DropPointController") { // cb func OnQuickHackDistraction is on BasicDistractionDevice & Device so 2 hacks get subtracted every hack
      devicePS.evmHacksRemaining = -1; // so set StopGlitching to work if hacksRemaining is ">= 0" instead of "> 0" to counteract the double subtract
    } else {
      devicePS.evmHacksRemaining = 0;
    };
    (this as VendingMachine).LoudVendingMachines(false);
    if Equals(this.m_controllerTypeName, n"JukeboxController") {
      let jukeboxPS = (this as Jukebox).GetDevicePS();
      let SFXcache = jukeboxPS.m_jukeboxSetup.m_glitchSFX;
      jukeboxPS.m_jukeboxSetup.m_glitchSFX = n"";
      this.StartGlitching(EGlitchState.DEFAULT, 1.0); // this invokes HackedEffect
      jukeboxPS.m_jukeboxSetup.m_glitchSFX = SFXcache; // restore the SFX so it works for OnHitEvent()
    } else {
      this.StartGlitching(EGlitchState.DEFAULT, 1.0); // this invokes HackedEffect
    };
    return;
  };
  if randomNum <= brokenLimit { // if randomNum falls within the broken range
    this.EVMShutDownMachine(); // malfunction = broken
  };
  // if randomNum falls outside of all ranges, do nothing
}

    // if Equals(this.m_controllerTypeName, n"ArcadeMachineController")
    // || Equals(this.m_controllerTypeName, n"PachinkoMachineController")
    // || Equals(this.m_controllerTypeName, n"ConfessionBoothController")
    // || Equals(this.m_controllerTypeName, n"DropPointController")
    // || Equals(this.m_controllerTypeName, n"JukeboxController")
    // || Equals(this.m_controllerTypeName, n"TravelTerminalController")
    // || Equals(this.m_controllerTypeName, n"VendingMachineController")
    // || Equals(this.m_controllerTypeName, n"WeaponVendingMachineController")
    // || Equals(this.m_controllerTypeName, n"IceMachineController") {

@addMethod(InteractiveDevice) // <- (one-layer discrepancy) <- Device <- DeviceBase <-
protected func EVMSetupShortGlitchListener() {
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

public class EVMShortGlitchEvent extends Event {
  // intentionally empty
}

// OnEVMShortGlitchEvent() in DropPoint/Arcade/VendingMachine Malfunction files

public class EVMShortGlitchCallback extends DelayCallback {
  let machine: ref<InteractiveDevice>;
  protected func Call() {
    if this.machine.GetDevicePS().evmHacksRemaining > 0 {
      if Equals(this.machine.m_controllerTypeName, n"VendingMachineController")
      || Equals(this.machine.m_controllerTypeName, n"WeaponVendingMachineController")
      || Equals(this.machine.m_controllerTypeName, n"IceMachineController") {
        (this.machine as VendingMachine).StartShortGlitch(); // defined on VendingMachine
        return;
      };
      if Equals(this.machine.m_controllerTypeName, n"ArcadeMachineController")
      || Equals(this.machine.m_controllerTypeName, n"PachinkoMachineController") {
        let arcadeMachine = this.machine as ArcadeMachine;
        arcadeMachine.isRepeatSpark = true;
        arcadeMachine.StartShortGlitch(); // defined on ArcadeMachine
        return;
      };
      if Equals(this.machine.m_controllerTypeName, n"DropPointController") {
        (this.machine as DropPoint).StartShortGlitch(); // defined on DropPoint
        return;
      };
      if Equals(this.machine.m_controllerTypeName, n"ConfessionBoothController") {
        (this.machine as ConfessionBooth).StartShortGlitch(); // defined on ConfessionBooth
        return;
      };
      if Equals(this.machine.m_controllerTypeName, n"DataTermController") {
        (this.machine as DataTerm).StartShortGlitch(); // defined on DataTerm
        // StartHoloFlicker() added to StartShortGlitch()
        return;
      };
      if Equals(this.machine.m_controllerTypeName, n"JukeboxController") {
        (this.machine as Jukebox).JukeboxGlitch(this.machine as Jukebox);
        return; // Jukebox is the only machine that has a custom StartShortGlitch() function
      };
    };
  }
}

@if(!ModuleExists("EnhancedDevices.Jukebox"))
@addMethod(Jukebox)
protected func JukeboxGlitch(jukebox:ref<Jukebox>) {}

@if(ModuleExists("EnhancedDevices.Jukebox"))
@addMethod(Jukebox)
protected func JukeboxGlitch(jukebox:ref<Jukebox>) {
  jukebox.StartShortGlitch(); // defined on Jukebox
}