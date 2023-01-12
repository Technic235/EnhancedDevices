import evmMenuSettings.*

// @wrapMethod(DropPoint) // DropPoint <- BasicDistractionDevice <- InteractiveDevice
// protected cb func OnGameAttached() -> Void {
//   wrappedMethod();
// }

@addField(InteractiveDevice)
let _timeSystemCallbackID: Int32; // do not remove underscore. timeSystemCallbackID throws an error.


@wrapMethod(DropPoint) // DropPoint <- BasicDistractionDevice <- InteractiveDevice
protected func ResolveGameplayState() -> Void {
  wrappedMethod();
  let settings = new evmMenuSettings();
  let dpMalfunctionRate = settings.evmDropPointMalfunctionRate;
  if dpMalfunctionRate == 0 { return; };
  let totalSum = settings.evmDropPointStaticGlitch + settings.evmDropPointShortGlitch + settings.evmDropPointBroken;
  if totalSum == 0 { totalSum = 1; };
  let dpStaticLimit = Cast<Float>(settings.evmDropPointStaticGlitch / totalSum * dpMalfunctionRate / 100);
  let dpShortLimit = Cast<Float>(settings.evmDropPointShortGlitch / totalSum * dpMalfunctionRate / 100) + dpStaticLimit;
  let dpBrokenLimit = Cast<Float>(settings.evmDropPointBroken / totalSum * dpMalfunctionRate / 100) + dpShortLimit;
  let randomNum = RandRangeF(0, 1);
  // let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.GetGame());
  // evmTimeSystem = GameInstance.GetTimeSystem(this.GetDevicePS().GetGameInstance());

  // this.ActivateDevice();
  if 0.0 < randomNum && randomNum <= dpStaticLimit {
    this.StartGlitching(EGlitchState.DEFAULT, 1.0);
    this.GetDevicePS().evmHackCount = 0;
    return;
  };
  if randomNum <= dpShortLimit {
    // let callback: ref<RepeatDelayedShortGlitch> = new RepeatDelayedShortGlitch();
    // callback.dropPoint = this;
    this.GetDevicePS().evmHackCount = 1;
    if Equals(this.GetDeviceState(), EDeviceStatus.ON)
    && this.GetDevicePS().evmHackCount > 0 {
      this.EVMSetupRepeatShortGlitchListener();
      // let randomTimer = RandRangeF(2, 8);
      // delaySystem.DelayCallback(callback, randomTimer, true);
    };

    // timeSystem.RegisterIntervalListener(this, callback, 1, 10, 10);
    return;
  };
  if randomNum <= dpBrokenLimit {
    this.ShutDownMachine();
    return;
  };
}


@addMethod(DropPoint)
protected func ShutDownMachine() -> Void {
//     this.TurnOffDevice();
//     this.RefreshInteraction();

//     let data:ref<FocusForcedHighlightData> = new FocusForcedHighlightData();
//     let highlightData: ref<HighlightInstance> = new HighlightInstance();
//     data.highlightType = EFocusForcedHighlightType.CLUE;
//     data.outlineType = EFocusOutlineType.CLUE;
//     data.priority = EPriority.Absolute;
//     data.patternType = VisionModePatternType.Default;
//     data.isRevealed = false;
//     data.isSavable = false;
//     this.GetDevicePS().m_exposeQuickHacks = false;
//     this.GetDevicePS().ExposeQuickHacks(false);
//     this.GetDevicePS().m_disableQuickHacks = true;
//     this.GetDevicePS().UnpowerDevice();
//     highlightData.context = HighlightContext.DEFAULT;
//     highlightData.state = InstanceState.HIDDEN;
//     data.InitializeWithHudInstruction(highlightData);
//     this.m_scanningComponent.ForceVisionAppearance(data);
//     this.m_scanningComponent.SetBlocked(false);
//     this.m_interaction.Toggle(false);
//     this.uiSlotComponent.Toggle(false);
//     this.SetScannerDirty(true);
//     let hudData:ref<HUDActorUpdateData> = new HUDActorUpdateData();
//     hudData.updateVisibility = true;
//     hudData.canOpenScannerInfoValue = false;
//     hudData.visibilityValue = ActorVisibilityStatus.OUTSIDE_CAMERA;
//     this.RequestHUDRefresh(hudData);








    // this.RefreshInteraction();
    // //remove quickhacks
    // this.GetDevicePS().ExposeQuickHacks(false);
    // this.GetDevicePS().m_disableQuickHacks = true;

    // //safety
    // this.TurnOffDevice();
    // //this unpowers the device and removes nearly everything (including the highlight)
    // this.GetDevicePS().UnpowerDevice();

    // //remove all kind of interactions (extra safety)
    // this.m_interaction.Toggle(false);
    // this.uiSlotComponent.Toggle(false);
    // this.SetScannerDirty(true);




  this.RefreshInteraction();

  //remove quickhacks
  this.GetDevicePS().ExposeQuickHacks(false);
  this.GetDevicePS().m_disableQuickHacks = true;

  //safety
  // Simply using DeactivateDevice() on DropPoint isnt enough becuz quickhack options still show when scanning. Only using this.GetDevicePS().SetDeviceState(this.GetDeviceState().OFF); results in an error message saying the power is out, but I want it to look entirely broken.
  this.DeactivateDevice(); // DeactivateDevice() <- TurnOffDevice() <- TurnOffScreen() <- m_uiComponent.Toggle(false);
  //this unpowers the device and removes nearly everything (including the highlight)
  this.GetDevicePS().UnpowerDevice(); // this is probably better than 'this.GetDevicePS().SetDeviceState(this.GetDeviceState().OFF)'
  // this.GetDevicePS().SetDeviceState(this.GetDeviceState().OFF);

  //remove all kind of interactions (extra safety)
  this.m_interaction.Toggle(false);
  this.uiSlotComponent.Toggle(false);
  this.SetScannerDirty(true);
}


class EVMRepeatShortGlitchEvent extends Event {
  // intentionally empty?
}

@addMethod(DropPoint)
protected cb func OnEVMRepeatShortGlitchEvent(evt:ref<EVMRepeatShortGlitchEvent>) {
	this.EVMResetShortGlitchCycle();
}

// vehicleComponent.script
@addMethod(DropPoint)
protected func EVMSetupRepeatShortGlitchListener() -> Void {
	if this._timeSystemCallbackID == 0 {
    let evt: ref<EVMRepeatShortGlitchEvent> = new EVMRepeatShortGlitchEvent();
    let randomSeconds = RandRange(3, 12);
    let delay: GameTime = GameTime.MakeGameTime(0, 0, 0, randomSeconds); // days, hours, opt minutes, opt seconds
		this._timeSystemCallbackID = Cast<Int32>(GameInstance.GetTimeSystem(this.GetDevicePS().GetGameInstance()).RegisterDelayedListener(this, evt, delay, -1));
    // RegisterDelayedListener(entity:weak<Entity>, eventToDelay:Event, delay:GameTime, repeat:Int32, opt sendOldNoifications:Bool) -> Uint32;
		this.EVMResetShortGlitchCycle();
	};
}

@addMethod(DropPoint)
protected func EVMResetShortGlitchCycle() -> Void {
  this.StartShortGlitch();
}


// public class RepeatDelayedShortGlitch extends DelayCallback {
//   let dropPoint: ref<DropPoint>;

//   protected func Call() -> Void {
//     this.dropPoint.StartShortGlitch();
//   }
// }


	// protected function PassGameTimeToVehBB()
	// {
	// 	var timeSys : TimeSystem;
	// 	var currTime : GameTime;
	// 	var timeString : String;
	// 	var hours : Int32;
	// 	timeSys = GameInstance.GetTimeSystem( GetVehicle().GetGame() );
	// 	currTime = timeSys.GetGameTime();
	// 	hours = GameTime.Hours( currTime );
	// 	if( hours > 12 )
	// 	{
	// 		hours = hours - 12;
	// 	}
	// 	timeString = ( StrReplace( SpaceFill( IntToString( hours ), 2, ESpaceFillMode.JustifyRight ), " ", "0" ) + ":" ) + StrReplace( SpaceFill( IntToString( GameTime.Minutes( currTime ) ), 2, ESpaceFillMode.JustifyRight ), " ", "0" );
	// 	m_vehicleBlackboard.SetString( GetAllBlackboardDefs().Vehicle.GameTime, timeString );
	// }



// vehicleComponent.script
	// protected function SetupGameTimeToBBListener()
	// {
	// 	var delay : GameTime;
	// 	var evt : MinutePassedEvent;
	// 	if( m_timeSystemCallbackID == ( ( Uint32 )( 0 ) ) )
	// 	{
	// 		evt = new MinutePassedEvent;
	// 		delay = GameTime.MakeGameTime( 0, 0, 1, 0 );
	// 		m_timeSystemCallbackID = GameInstance.GetTimeSystem( GetVehicle().GetGame() ).RegisterDelayedListener( GetVehicle(), evt, delay, -1 );
	// 		PassGameTimeToVehBB();
	// 	}
	// }



  // let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.GetGame());
  // let callback: ref<EVMDispenseEddieBundles> = new EVMDispenseEddieBundles();
  // callback.vendingMachine = this;
  // callback.lootManager = GameInstance.GetLootManager(this.GetGame());
  // ArrayPush(callback.dropInstructions, DropInstruction.Create(moneyItem, quantity));
  // delaySystem.DelayCallback(callback, 0, true);

	// public function SetAsQuickHack( optional wasExecutedAtLeastOnce : Bool )
	// {
	// 	m_isQuickHack = true;
	// 	m_wasPerformedOnOwner = wasExecutedAtLeastOnce;
	// 	ProduceInteractionParts();
	// }


// @addField(InteractiveDevice) // leaving this on didnt work
// let m_advUiComponent: ref<IComponent>;


// @wrapMethod(DropPoint)
// protected cb func OnRequestComponents(ri:EntityRequestComponentsInterface) {
// 	EntityRequestComponentsInterface.RequestComponent(ri, n"ads", n"AdvertisementWidgetComponent", false);
//   wrappedMethod(ri);
// }


// @wrapMethod(InteractiveDevice) // leaving this on didnt work
// protected cb func OnTakeControl(ri:EntityResolveComponentsInterface) -> Void {
//   this.m_advUiComponent = EntityResolveComponentsInterface.GetComponent(ri, n"ads");
//   wrappedMethod(ri);
// }






// @wrapMethod(DropPoint)
// protected cb func OnTakeControl(ri:EntityResolveComponentsInterface) -> Void {
//   wrappedMethod(ri);
//   this.ShutDownMachine();
// }

// VendingMachine <- (skips BasicDistractionDevice) <- InteractiveDevice
// @addMethod(DropPoint) // DropPoint <- BasicDistractionDevice <- InteractiveDevice
// protected func ShutDownMachine() -> Void {
  // this.GetBlackboard().SetBool(GetAllBlackboardDefs().VendingMachineDeviceBlackboard.SoldOut, true); // set to sold out
  // this.DeactivateDevice(); // DeactivateDevice() <- TurnOffDevice() <- TurnOffScreen() <- m_uiComponent.Toggle( false );
//   this.GetDevicePS().SetDeviceState(this.GetDeviceState().OFF);
//   return;
// }