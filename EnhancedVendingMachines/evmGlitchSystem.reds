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
  let dpMalfunctionRate: Int32 = settings.evmDropPointMalfunctionRate;
  if dpMalfunctionRate == 0 { return; };
  let totalSum: Int32 = settings.evmDropPointStaticGlitch + settings.evmDropPointShortGlitch + settings.evmDropPointBroken;
  if totalSum == 0 { totalSum = 1; };
  let dpStaticLimit = Cast<Float>(settings.evmDropPointStaticGlitch / totalSum * dpMalfunctionRate / 100);
  let dpShortLimit = Cast<Float>(settings.evmDropPointShortGlitch / totalSum * dpMalfunctionRate / 100) + dpStaticLimit;
  let dpBrokenLimit = Cast<Float>(settings.evmDropPointBroken / totalSum * dpMalfunctionRate / 100) + dpShortLimit;
  let randomNum = RandRangeF(0, 1);

  if 0.0 < randomNum && randomNum <= dpStaticLimit {
    this.StartGlitching(EGlitchState.DEFAULT, 1.0);
    this.GetDevicePS().evmHackCount = 0;
    return;
  };
  if randomNum <= dpShortLimit {
    this.GetDevicePS().evmHackCount = 1;
    if Equals(this.GetDeviceState(), EDeviceStatus.ON)
    && this.GetDevicePS().evmHackCount > 0 {
      this.EVMSetupRepeatShortGlitchListener();
    };
    return;
  };
  if randomNum <= dpBrokenLimit {
    this.ShutDownMachine();
  };
}


@addMethod(DropPoint)
protected func ShutDownMachine() -> Void {
  // this is from DeactivateDevice() on VendingMachine and all its supers
  // VendingMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <- Device <- DeviceBase
  // this.CutPower(); // isn't needed cuz it calls RevealNetworkGrid/RevealDevicesGrid
	this.RevealNetworkGrid( false );
	this.RevealDevicesGrid( false );
	this.SetGameplayRoleToNone();
	GameObject.UntagObject( this );
	this.m_isPlayerAround = false;

  // it works with just the code above

  // this is from TurnOff(), its supers, and 1-2 other places
	// this.m_advUiComponent.Toggle( false );
	// this.ToggleLights( false );
  // this.StopTransformDistractAnimation("turnON");

  // this.m_isUIdirty = true; // I have no idea what this does but I think it isn't needed.

  // this.RestoreDeviceState(); // this turned it back on lol

  // everything below is valid but doesn't do anything that the above code doesn't already do.
	this.m_uiComponent.Toggle( false );
  this.m_interactionIndicator.ToggleLight( false );
  this.UpdateDeviceState();
	this.HandleMappinRregistration( false );
}


class EVMRepeatShortGlitchEvent extends Event {
  // intentionally empty
}

@addMethod(DropPoint)
protected func EVMSetupRepeatShortGlitchListener() -> Void {
	if this._timeSystemCallbackID == 0 {
    let evt: ref<EVMRepeatShortGlitchEvent> = new EVMRepeatShortGlitchEvent();
    let delay: GameTime = GameTime.MakeGameTime(0, 0, 0, 15); // days, hours, opt minutes, opt seconds
    // Make the numbers bigger since game time is faster than real time. Might also be able to replace with real time in the future.
    // If I'm understanding this correctly, this is dirty coding. The event gets called every 10 game-seconds. Since EVMResetShortGlitchCycle uses a random delay, StartShortGlitch will not occur in-game because another short glitch is already occuring. So it seems more random than it is since some short glitches are skipped. Or it could be that this event waits until RepeatDelayedShortGlitch is finished. Who knows.
		this._timeSystemCallbackID = Cast<Int32>(GameInstance.GetTimeSystem(this.GetDevicePS().GetGameInstance()).RegisterDelayedListener(this, evt, delay, -1));
    // RegisterDelayedListener(entity:weak<Entity>, eventToDelay:Event, delay:GameTime, repeat:Int32, opt sendOldNoifications:Bool) -> Uint32;
    // argument repeat:Int32 repeats that many times (10 times if set to 10) or infinitely if it's set to -1.
	};
}

@addMethod(DropPoint)
protected cb func OnEVMRepeatShortGlitchEvent(evt:ref<EVMRepeatShortGlitchEvent>) {
  let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.GetGame());
  let callback: ref<RepeatDelayedShortGlitch> = new RepeatDelayedShortGlitch();
  callback.dropPoint = this;
  delaySystem.DelayCallback(callback, RandRangeF(2, 6), true);
}

public class RepeatDelayedShortGlitch extends DelayCallback {
  let dropPoint: ref<DropPoint>;
  protected func Call() -> Void {
    this.dropPoint.StartShortGlitch();
  }
}


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