module EnhancedDevices.ArcadeMachine

// PachinkoMachine <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// PachinkoMachineController <- ArcadeMachineController <- (skips BasicDistractionDeviceController) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// PachinkoMachineControllerPS <- ArcadeMachineControllerPS <- (BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@wrapMethod(PachinkoMachine) // <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnGameAttached() {
  wrappedMethod();
  this.m_controllerTypeName = n"PachinkoMachineController";
}

// needed for EVMShutDownMachine()
@addField(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
let evmArcadeStaticEventID: Uint32 = 0u;

// needed for EVMShutDownMachine()
@addMethod(ScriptableDeviceComponentPS) // <- SharedGameplayPS <- DeviceComponentPS <-
protected func EVMUnregisterArcadeSparkMalfunction() {
	if this.evmArcadeStaticEventID != 0u { // this is for arcade machines
    GameInstance.GetTimeSystem(this.GetGameInstance()).UnregisterListener(this.evmArcadeStaticEventID);
    this.evmArcadeStaticEventID = 0u;
	};
}

// ArcadeMachineMalfunctions
// needed for ScriptableDeviceComponentPS-OnQuickHackDistraction()
// which calls ArcadeMachineMalfunctions & VendingMachineHacking
@addMethod(InteractiveDevice) // <- (one-layer discrepancy) <- Device <-
protected func EVMSetupArcadeStaticGlitchListener() {
  let devicePS = this.GetDevicePS();
	if devicePS.evmArcadeStaticEventID == 0u { // 0u turns zero into a Uint32 instead of Int32
    let evt = new EVMArcadeStaticGlitchEvent();
    let delay: GameTime = GameTime.MakeGameTime(0, 0, 0, RandRange(120, 301)); // days, hours, opt minutes, opt seconds
    // RandRange excludes last number so it's really 120-300 game-seconds (2-5 game-minutes)
		devicePS.evmArcadeStaticEventID = GameInstance.GetTimeSystem(devicePS.GetGameInstance()).RegisterDelayedListener(this, evt, delay, -1);
	};
}

public class EVMArcadeStaticGlitchEvent extends Event {
  // intentionally empty
}

// OnEVMArcadeStaticGlitchEvent() & EVMDelayArcadeStaticGlitchCallback in ArcadeMalfunctions

@addField(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
let evmSparkActive: Bool = false;

@addField(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
let evmCanTriggerSpark: Bool = true;

@addField(ArcadeMachine)
let isRepeatSpark: Bool = false;

@addMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMStartArcadeStaticGlitch() {
  if !this.evmSparkActive {
    let delaySystem = GameInstance.GetDelaySystem(this.GetGame());
    let callback = new EVMArcadeSparkCompletedCallback();
    callback.machine = this;

    if !this.isRepeatSpark {
      GameObjectEffectHelper.ActivateEffectAction(this, gamedataFxActionType.Start, n"hack_fx"); // ...n"hack_fx", evt.machine.evmWorldEffectBlackboard, true);
      delaySystem.DelayCallback(callback, 13, true);
      this.evmSparkActive = true;
    };

    if this.isRepeatSpark && this.evmCanTriggerSpark {
      // static SCREEN makes the arcade machine think it has already started hack_fx
      GameObjectEffectHelper.ActivateEffectAction(this, gamedataFxActionType.Start, n"hack_fx"); // ...n"hack_fx", evt.machine.evmWorldEffectBlackboard, true);
      delaySystem.DelayCallback(callback, 13, true);
      this.evmSparkActive = true;

      let callback = new EVMArcadeRepeatSparkReadyCallback();
      callback.machine = this;
      delaySystem.DelayCallback(callback, RandRangeF(26, 65), true);
      this.evmCanTriggerSpark = false;
    };
  };
  this.isRepeatSpark = false;
}

public class EVMArcadeSparkCompletedCallback extends DelayCallback {
  let machine: ref<ArcadeMachine>;
  protected func Call() {
    this.machine.evmSparkActive = false;
  }
}

public class EVMArcadeRepeatSparkReadyCallback extends DelayCallback {
  let machine: ref<ArcadeMachine>;
  protected func Call() {
    this.machine.evmCanTriggerSpark = true;
  }
}

// 
// 
// 

// used for HackingArcadeMachine & MalfunctionsArcadeMachine
// replaced so ActivateEffectAction( this, gamedataFxActionType.Start, 'hack_fx' ); isnt called
@replaceMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func StartGlitching(glitchState:EGlitchState, opt intensity:Float) {
  let glitchData: GlitchData;
  glitchData.state = glitchState;
  glitchData.intensity = intensity;
  if intensity == 0.0 { intensity = 1.0; };
  let evt = new AdvertGlitchEvent();
  evt.SetShouldGlitch(intensity);
  this.QueueEvent(evt);
  this.GetBlackboard().SetVariant(this.GetBlackboardDef().GlitchData, glitchData, true);
  this.GetBlackboard().FireCallbacks();
  if Equals(this.m_controllerTypeName, n"ArcadeMachineController") {
    this.EVMStartArcadeStaticGlitch();
    if this.GetDevicePS().evmHacksRemaining <= 0 {
      this.EVMSetupArcadeStaticGlitchListener();
    };
  };
}

@addMethod(PachinkoMachine) // <- ArcadeMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func StartGlitching(glitchState:EGlitchState, opt intensity:Float) {
  super.StartGlitching(glitchState, intensity);
}

// 
// 
// 

// prevents arcade machines from sparking on hit when broken/off
@if(!ModuleExists("EnhancedDevices.OnHit.ArcadeMachine"))
@wrapMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected cb func OnHitEvent(hit:ref<gameHitEvent>) { // hitEvents.script
  let devicePS = this.GetDevicePS();
  if Equals(this.GetCurrentGameplayRole(), EGameplayRole.None) // if not assigned "Distract" role
  || Equals(devicePS.evmMalfunctionName, "broken") {
    return;
  };

  if this.OnHitFX(hit) {
    wrappedMethod(hit); // conditional checks have been built into StartGlitching() for Arcade/PachinkoMachine
  };
}

// cant put code on MalfunctionsArcadeMachine since we need to prevent the spark FX even when malfunctions are not enabled
@if(!ModuleExists("EnhancedDevices.Malfunctions.ArcadeMachine"))
@addMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func OnHitFX(hit:ref<gameHitEvent>) -> Bool {
  return true;
}

@if(ModuleExists("EnhancedDevices.Malfunctions.ArcadeMachine"))
@addMethod(ArcadeMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func OnHitFX(hit:ref<gameHitEvent>) -> Bool {
  if Equals(this.GetDevicePS().evmMalfunctionName, "static") {
    super.OnHitEvent(hit);
  } else {
    return true;
  };
  return false;
}