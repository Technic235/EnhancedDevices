import evmMenuSettings.*
// baseDeviceActions.script for powering, activating, turning on/off devices

//deviceBase.script
//enum EDeviceStatus {
// 	DISABLED = -2,
// 	UNPOWERED = -1,
// 	OFF = 0,
// 	ON = 1,
// 	INVALID = 2 } // this the default state before any state is applied.


@replaceMethod(VendingMachine)
protected cb func OnHitEvent(hit:ref<gameHitEvent>) -> Void { // hitEvents.script
  let settings: ref<evmMenuSettings> = new evmMenuSettings();
  // let controllerPS = this.GetDevicePS();
  if this.GetBlackboard().GetBool(GetAllBlackboardDefs().VendingMachineDeviceBlackboard.SoldOut) { // if sold out
    if RandRange(0, 100) < settings.evmHooliganBreakOdds
    && Equals(this.GetDeviceState(), EDeviceStatus.ON) {
      this.DeactivateDevice(); // will turn off if player or NPC (or anything, really) hits it
    };
    return; // cancels function
  };

  if !Equals(this.m_controllerTypeName, n"IceMachineController")
  || Equals(settings.evmHooliganIceMachines, true) {
    let instigator = hit.attackData.GetInstigator();
    let player = GetPlayer(this.GetGame());
    if Equals(player.GetEntityID(), instigator.GetEntityID()) {
      // the player must be the one to hit the machine for there to be drops.
      // but glitching will still occur from any hit (check bottom of function)
      let _evmDropsOnBreaking: EVMDropsOnBreakingEnum = settings.evmDropsOnBreaking;
      if Equals(settings.evmMultiDrop, true) { // if multiple items can fall at once
        switch _evmDropsOnBreaking {
          case EVMDropsOnBreakingEnum.Never: // if never drops on breaking
            if RandRange(0, 100) < settings.evmHooliganBreakOdds {
              this.SendSoldOutToUIBlackboard(true);
              this.DeactivateDevice(); // disables InteractionComponent with m_interaction.Toggle( false );
              return;
            };
            if RandRange(0, 100) < settings.evmHooliganEddiesOdds { this.EVMHooliganDropEddies(); };
            if Equals(this.m_controllerTypeName, n"IceMachineController") {
              if RandRange(0, 100) < settings.evmHooliganJunkOdds { this.DelayVendingMachineEvent(0.2, true, true); };
            } else {
              if RandRange(0, 100) < settings.evmHooliganItemOdds { this.DelayVendingMachineEvent(0.2, true, true); };
              if RandRange(0, 100) < settings.evmHooliganJunkOdds { this.EVMDispenseOneJunk(1); }; // slaught-o-matic doesn't dispense junk
            };
            break;

          case EVMDropsOnBreakingEnum.Sometimes: // if sometimes drops on breaking
            if RandRange(0, 100) < settings.evmHooliganEddiesOdds { this.EVMHooliganDropEddies(); };
            if Equals(this.m_controllerTypeName, n"IceMachineController") {
              if RandRange(0, 100) < settings.evmHooliganJunkOdds { this.DelayVendingMachineEvent(0.2, true, true); };
            } else {
              if RandRange(0, 100) < settings.evmHooliganItemOdds { this.DelayVendingMachineEvent(0.2, true, true); };
              if RandRange(0, 100) < settings.evmHooliganJunkOdds { this.EVMDispenseOneJunk(1); }; // slaught-o-matic doesn't dispense junk
            };
            if RandRange(0, 100) < settings.evmHooliganBreakOdds {
              this.SendSoldOutToUIBlackboard(true);
              this.DeactivateDevice();
              return;
            };
            break;

          case EVMDropsOnBreakingEnum.Exclusively: // if only drops on breaking
            if RandRange(0, 100) < settings.evmHooliganBreakOdds {
              if RandRange(0, 100) < settings.evmHooliganEddiesOdds { this.EVMHooliganDropEddies(); };
              if Equals(this.m_controllerTypeName, n"IceMachineController") {
                if RandRange(0, 100) < settings.evmHooliganJunkOdds { this.DelayVendingMachineEvent(0.2, true, true); };
              } else {
                if RandRange(0, 100) < settings.evmHooliganItemOdds { this.DelayVendingMachineEvent(0.2, true, true); };
                if RandRange(0, 100) < settings.evmHooliganJunkOdds { this.EVMDispenseOneJunk(1); }; // slaught-o-matic doesn't dispense junk
              };
              this.SendSoldOutToUIBlackboard(true);
              this.DeactivateDevice();
              return;
            };
            break;
        };
      } else { // if only one item is allowed to fall at a time
        switch _evmDropsOnBreaking {
          case EVMDropsOnBreakingEnum.Never: // if never drops on breaking
            if RandRange(0, 100) < settings.evmHooliganBreakOdds {
              this.SendSoldOutToUIBlackboard(true);
              this.DeactivateDevice();
              return;
            };
            this.EVMSingleDropRandomizer();
            break;

          case EVMDropsOnBreakingEnum.Sometimes: // if sometimes drops on breaking
            this.EVMSingleDropRandomizer();
            if RandRange(0, 100) < settings.evmHooliganBreakOdds {
              this.SendSoldOutToUIBlackboard(true);
              this.DeactivateDevice();
              return;
            };
            break;

          case EVMDropsOnBreakingEnum.Exclusively: // if only drops on breaking
            if RandRange(0, 100) < settings.evmHooliganBreakOdds {
              this.EVMSingleDropRandomizer();
              this.SendSoldOutToUIBlackboard(true);
              this.DeactivateDevice();
              return;
            };
            break;
        };
      };
    };
  };
  this.StartShortGlitch();
}


@addMethod(VendingMachine)
protected func EVMSingleDropRandomizer() -> Void {
  let settings: ref<evmMenuSettings> = new evmMenuSettings();
  let firstPriority: Int32 = RandRange(0, 2); // 0=item, 1=eddies, 2 is excluded

  if firstPriority == 0 { // if the item is first
    if !Equals(this.m_controllerTypeName, n"IceMachineController")
    && RandRange(0, 100) < settings.evmHooliganItemOdds {
      this.DelayVendingMachineEvent(0.2, true, true);
      return;
    };
    if RandRange(0, 100) < settings.evmHooliganEddiesOdds {
      this.EVMHooliganDropEddies();
      return;
    };
  };

  if firstPriority == 1 { // if eddies are first
    if RandRange(0, 100) < settings.evmHooliganEddiesOdds {
      this.EVMHooliganDropEddies();
      return;
    };
    if !Equals(this.m_controllerTypeName, n"IceMachineController")
    && RandRange(0, 100) < settings.evmHooliganItemOdds {
      this.DelayVendingMachineEvent(0.2, true, true);
      return;
    };
  };

  if Equals(this.m_controllerTypeName, n"IceMachineController") {
    if RandRange(0, 100) < settings.evmHooliganJunkOdds { this.DelayVendingMachineEvent(0.2, true, true); };
  } else { // weapon vending machine (slaught-o-matic) doesn't dispense junk
    if RandRange(0, 100) < settings.evmHooliganJunkOdds { this.EVMDispenseOneJunk(1); };
  };
}


@addMethod(VendingMachine)
protected func EVMHooliganDropEddies() -> Void {
  let settings: ref<evmMenuSettings> = new evmMenuSettings();
  let min: Int32 = settings.evmEddiesMin;
  let max: Int32 = settings.evmEddiesMax;
  if min >= max { min = max - 1; };
  let quantity = RandRange(min, max+1); // last # of range is excluded, therefore +1 to make sure 'max' is included
  let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());

  if Equals(settings.evmHooliganEddiesDeposit, false) { // if direct deposit off
    let callback: ref<EVMDispenseEddieBundles> = new EVMDispenseEddieBundles();
    callback.vendingMachine = this;
    callback.lootManager = GameInstance.GetLootManager(this.GetGame());
    let moneyItem: ItemID = ItemID.FromTDBID(t"Items.money");
    ArrayPush(callback.dropInstructions, DropInstruction.Create(moneyItem, quantity));
    TS.GiveItem(this, moneyItem, quantity);
    let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.GetGame());
    delaySystem.DelayCallback(callback, 0.2, true);
  } else { // if direct deposit on
    TS.GiveItem(GetPlayer(this.GetGame()), MarketSystem.Money(), quantity);
  };
}