import evmMenuSettings.*

// DropPoint <- BasicDistractionDevice <- InteractiveDevice
// DropPointController <- ScriptableDeviceComponent <- DeviceComponent
// DropPointControllerPS <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS

// no longer needed because evmHackArcade had to define evmHackCount in the class that BasicDistractionDeviceControllerPS extends from
// @addField(BasicDistractionDeviceControllerPS)
// protected let evmHackCount: Int32 = 2;

@wrapMethod(DropPoint)
protected func StartDistraction(on:Bool) -> Void {
  wrappedMethod();
  // let evt: ref<InteractionActivationEvent>;
  // this.OnInteractionActivated(evt);
  // this.StartRevealingOnProximity();
  // this.ShowMappinOnProximity();
  // this.RefreshUI(false);
}


@wrapMethod(DropPoint) // DropPoint <- BasicDistractionDevice <- InteractiveDevice
protected func StopDistraction() -> Void {
  let settings: ref<evmMenuSettings> = new evmMenuSettings();
  if Equals(settings.evmHackDropPoints, true)
  && this.GetDevicePS().evmHackCount <= 0 {
    this.StartGlitching(EGlitchState.DEFAULT, 1.0);
  } else {
    wrappedMethod();
  };
  this.UpdateDeviceState();
}


@wrapMethod(DropPointControllerPS) // DropPointControllerPS <- BasicDistractionDeviceControllerPS <- ScriptableDeviceComponentPS
protected func GetQuickHackActions(out actions:array<ref<DeviceAction>>, context:GetActionsContext) -> Void {
  if Equals(this.GetDeviceState(), EDeviceStatus.ON) {
    let settings: ref<evmMenuSettings> = new evmMenuSettings();
    if Equals(settings.evmHackDropPoints, true) {
      let currentAction: ref<ScriptableDeviceAction>;
      if Equals(this.m_distractorType, EPlaystyleType.TECHIE) || Equals(this.m_distractorType, EPlaystyleType.NONE) { return; };
      currentAction = this.ActionQuickHackDistraction();
      currentAction.SetObjectActionID(t"DeviceAction.MalfunctionClassHack");
      if this.evmHackCount <= 0 {
        currentAction.SetInactiveWithReason(false, "LocKey#7003");
      };
      ArrayPush(actions, currentAction);
      if this.IsGlitching() || this.IsDistracting() {
        ScriptableDeviceComponentPS.SetActionsInactiveAll(actions, "LocKey#7004", n"");
      };
      if this.IsOFF() {
        ScriptableDeviceComponentPS.SetActionsInactiveAll(actions, "LocKey#7005", n"");
      };
      this.FinalizeGetQuickHackActions(actions, context);
    } else {
      wrappedMethod(actions, context);
    };
  };
}


@wrapMethod(DropPoint) // DropPoint <- BasicDistractionDevice <- InteractiveDevice
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Bool {
  wrappedMethod(hit);
  let settings: ref<evmMenuSettings> = new evmMenuSettings();
  if Equals(settings.evmHackDropPoints, true) {
    let settings: ref<evmMenuSettings> = new evmMenuSettings();
    if RandRange(0, 100) < settings.evmHooliganBreakOdds
    && Equals(this.GetDeviceState(), EDeviceStatus.ON) {
      this.ShutDownMachine();
    //       this.TurnOffDevice();
    // this.RefreshInteraction();

    // let data:ref<FocusForcedHighlightData> = new FocusForcedHighlightData();
    // let highlightData: ref<HighlightInstance> = new HighlightInstance();
    // data.highlightType = EFocusForcedHighlightType.CLUE;
    // data.outlineType = EFocusOutlineType.CLUE;
    // data.priority = EPriority.Absolute;
    // data.patternType = VisionModePatternType.Default;
    // data.isRevealed = false;
    // data.isSavable = false;
    // this.GetDevicePS().m_exposeQuickHacks = false;
    // this.GetDevicePS().ExposeQuickHacks(false);
    // this.GetDevicePS().m_disableQuickHacks = true;
    // this.GetDevicePS().UnpowerDevice();
    // highlightData.context = HighlightContext.DEFAULT;
    // highlightData.state = InstanceState.HIDDEN;
    // data.InitializeWithHudInstruction(highlightData);
    // this.m_scanningComponent.ForceVisionAppearance(data);
    // this.m_scanningComponent.SetBlocked(false);
    // this.m_interaction.Toggle(false);
    // this.uiSlotComponent.Toggle(false);
    // this.SetScannerDirty(true);
    // let hudData:ref<HUDActorUpdateData> = new HUDActorUpdateData();
    // hudData.updateVisibility = true;
    // hudData.canOpenScannerInfoValue = false;
    // hudData.visibilityValue = ActorVisibilityStatus.OUTSIDE_CAMERA;
    // this.RequestHUDRefresh(hudData);
    };
  };
}


// for future reference
// tools\redmod\tweaks\base\gameplay\static_data\database\interactions\hack_interactions.tweak
// ^ includes information on all quickhacks

// tools\redmod\tweaks\base\gameplay\static_data\database\object_actions\device_actions.tweak
// QuickHackToggleON : ToggleStateClassHack {
// 	actionName = "QuickHackToggleON";
// 	fk< InteractionBase > objectActionUI = "Interactions.";
// }

// ChangeMusicAction : ObjectAction {
// 	actionName = "ChangeMusicAction";
// 	fk< InteractionBase > objectActionUI = "Interactions.ChangeMusicHack";
// }

// QuickHackDistraction : ObjectAction {
// 	actionName = "QuickHackDistraction";
// 	fk< InteractionBase > objectActionUI = "Interactions.QuickHackDistraction";
// }