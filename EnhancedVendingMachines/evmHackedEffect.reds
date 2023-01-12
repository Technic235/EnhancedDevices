import evmMenuSettings.*
//for future reference
//Cyberpunk 2077\tools\redmod\tweaks\base\gameplay\static_data\database\loot\vending_machines_loot.tweak
// to create a drop bag with multiple contents... rpgManager.script
// public static function DropManyItems( gameInstance : GameInstance, obj : weak< GameObject >, items : array< ItemModParams > )

//vendingMachineController.script
// protected override function GetQuickHackActions( out outActions : array< DeviceAction >, context : GetActionsContext )

//deviceComponentBase.script for device states
// public const function GetDeviceState() : EDeviceStatus { return m_deviceState; }
// protected function CacheDeviceState( state : EDeviceStatus ) {...}
// protected virtual function SetDeviceState( state : EDeviceStatus ) {...}
// public virtual function EvaluateDeviceState() {...}
@replaceMethod(VendingMachine)
protected func HackedEffect() -> Void {
  // stop script if vending machine is sold out.
  if this.GetBlackboard().GetBool(GetAllBlackboardDefs().VendingMachineDeviceBlackboard.SoldOut) {
    return;
  };

  // new variables for this mod
  let _evmMenuSettings: ref<evmMenuSettings> = new evmMenuSettings();
  let evmItemDropOddsArray: array<Int32> = _evmMenuSettings.evmPushSettingsToArray();
  let evmEddiesOddsCheck: Int32 = RandRange(0, 100);

  if _evmMenuSettings.evmDispenseMax > 0 // if the player wants the possibility of at least 1 item to dispense from the vending machine
  && RandRange(0, 100) < evmItemDropOddsArray[1] { // and the probability threshold has been met for the first item
    this.DelayVendingMachineEvent(0, true, true); // dispense the first item
    this.EVMDispenseItems(_evmMenuSettings, evmItemDropOddsArray); // check the rest of the items
    // no need for PlayItemFall() or RefreshUI() since they're already invoked by...
    // DelayVendingMachineEvent() > VendingMachineFinishedEvent()
  } else { // if no items drop
    if evmEddiesOddsCheck >= _evmMenuSettings.evmEddiesOdds { // if no eddies drop
      if RandRange(0, 100) < evmItemDropOddsArray[0] { // check if junk will drop
        this.EVMDispenseManyJunk(); // drop junk
      }; // slaught-o-matic doesn't drop junk but can be forced to with...
      // let junkItem: ItemID = ItemID.FromTDBID(t"Items.BaseDestroyedJunk");
    } else { // if eddies probability check passes
      if Equals(_evmMenuSettings.evmEddiesAlways, false) { // if 'Eddies always possible' is false
        this.EVMDispenseEddies(evmEddiesOddsCheck); // drop eddies
      };
    };
  };

  if Equals(_evmMenuSettings.evmEddiesAlways, true) { // if 'Eddies always possible' is true
    this.EVMDispenseEddies(evmEddiesOddsCheck); // drop eddies if the probability check passes
  };

  if this.GetDevicePS().IsSoldOut() {
    this.SendSoldOutToUIBlackboard(true);
  };
};


@wrapMethod(IceMachine)
protected func HackedEffect() -> Void {
  if this.GetBlackboard().GetBool(GetAllBlackboardDefs().VendingMachineDeviceBlackboard.SoldOut) {
    return;
  };
  let _evmMenuSettings: ref<evmMenuSettings> = new evmMenuSettings();
  if Equals(_evmMenuSettings.evmEddiesFromIceMachines, true) {
    let evmEddiesOddsCheck: Int32 = RandRange(0, 100);
    if evmEddiesOddsCheck >= _evmMenuSettings.evmEddiesOdds { // if no eddies drop
      if RandRange(0, 100) < _evmMenuSettings.evmDispenseOddsJunk { // check if junk will drop
        wrappedMethod(); // drop junk
      };
    } else { // if eddies probability check passes
      this.EVMDispenseEddies(evmEddiesOddsCheck); // drop eddies
    };
  } else {
    wrappedMethod();
  };
  if this.GetDevicePS().IsSoldOut() { this.SendSoldOutToUIBlackboard(true); };
}


@addMethod(VendingMachine)
protected func EVMDispenseEddies(eddiesOddsCheck: Int32) -> Void {
  let settings: ref<evmMenuSettings> = new evmMenuSettings();
  if eddiesOddsCheck < settings.evmEddiesOdds {
    let min: Int32 = settings.evmEddiesMin;
    let max: Int32 = settings.evmEddiesMax;
    if min >= max {
      min = max - 1;
    };
    let quantity = RandRange(min, max+1);
    // last # of range is excluded, therefore +1 to make sure 'max' is included

    if Equals(settings.evmEddiesDeposit, false) { // if direct deposit off
      this.EVMDispenseEddiesRandomizer(quantity);
    } else { // if direct deposit on
      let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
      TS.GiveItem(GetPlayer(this.GetGame()), MarketSystem.Money(), quantity);
    };
  };
}


public class EVMDispenseEddieBundles extends DelayCallback {
  let vendingMachine: ref<VendingMachine>;
  let lootManager: ref<LootManager>;
  let dropInstructions: array<DropInstruction>;

  protected func Call() -> Void {
    this.lootManager.SpawnItemDropOfManyItems(this.vendingMachine, this.dropInstructions, n"", this.vendingMachine.RandomizePosition());
    this.vendingMachine.PlayItemFall();
    this.vendingMachine.RefreshUI();
  }
}


@addMethod(VendingMachine)
protected func EVMDispenseEddiesRandomizer(quantity: Int32) -> Void {
  let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let moneyItem: ItemID = ItemID.FromTDBID(t"Items.money");
  TS.GiveItem(this, moneyItem, quantity);

  let settings: ref<evmMenuSettings> = new evmMenuSettings();
  if settings.evmEddiesConsolidated == 0 {
    let i: Int32 = 0;
    while i < quantity {
      this.DelayHackedEvent(Cast<Float>(i)*0.2, moneyItem);
      i += 1;
    };
  } else {
    let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.GetGame());
    let callback: ref<EVMDispenseEddieBundles> = new EVMDispenseEddieBundles();
    callback.vendingMachine = this;
    callback.lootManager = GameInstance.GetLootManager(this.GetGame());

    if settings.evmEddiesConsolidated == 100 {
      ArrayPush(callback.dropInstructions, DropInstruction.Create(moneyItem, quantity));
      delaySystem.DelayCallback(callback, 0, true);
      return;
    };

    let split: Float = 100.00 / Cast<Float>(settings.evmEddiesConsolidated);
    let randomizer: Float = RandRangeF(split - (split*0.25), split * 1.5);
    let randomMin: Int32 = FloorF(randomizer);
    let randomMax: Int32 = CeilF(randomizer);
    if randomMin >= randomMax {
      randomMin = randomMax - 2;
      // last # of range is excluded, therefore -2 to random min instead of just -1
    };
    let eddieBundles: Int32 = RandRange(randomMin, randomMax+1);
    // last # of range is excluded, there +1 to ensure 'randomMax' is included and -2 to randomMin to compensate

    if eddieBundles <= 1 { // if only one eddie bundle
      ArrayPush(callback.dropInstructions, DropInstruction.Create(moneyItem, quantity));
      delaySystem.DelayCallback(callback, 0, true);
      return;
    } else { // if more than one eddie bundle
      if eddieBundles >= quantity { // if more bundles than the determined quantity
        let i: Int32 = 0;
        while i < quantity { // dispense the entire quantity in bundles of 1 eddie each
          this.DelayHackedEvent(Cast<Float>(i)*0.2, moneyItem);
          i += 1;
        };
        return;
      };

      let i: Int32 = 0;
      let dividedQuantity: Float = Cast<Float>(quantity) / Cast<Float>(eddieBundles);
      while i < eddieBundles {
        ArrayClear(callback.dropInstructions);
        if (eddieBundles - i) == 1 { // if only one bundle remaining
          ArrayPush(callback.dropInstructions, DropInstruction.Create(moneyItem, quantity));
          delaySystem.DelayCallback(callback, Cast<Float>(i)*0.2, true);
          return;
        };

        let dividedRange: Float = RandRangeF(dividedQuantity - (dividedQuantity*0.5), dividedQuantity + (dividedQuantity*0.5));
        let dividedMin: Int32 = FloorF(dividedRange);
        let dividedMax: Int32 = CeilF(dividedRange);
        if dividedMin >= dividedMax {
          dividedMin = dividedMax - 2;
        };
        let bundleQuantity: Int32 = RandRange(dividedMin, dividedMax+1);
        // last # of range is excluded, therefore +1 to make sure 'dividedMax' is included

        if bundleQuantity >= quantity { // if bundleQuantity is more than the determined quantity
          ArrayPush(callback.dropInstructions, DropInstruction.Create(moneyItem, quantity));
          delaySystem.DelayCallback(callback, Cast<Float>(i)*0.2, true);
          return;
        };

        if bundleQuantity <= 1 { // if the bundle contains 1 or less eddies
          this.DelayHackedEvent(Cast<Float>(i)*0.2, moneyItem);
          quantity -=  1;
        } else { // if the bundle contains at least more than 1 eddie
          ArrayPush(callback.dropInstructions, DropInstruction.Create(moneyItem, bundleQuantity));
          delaySystem.DelayCallback(callback, Cast<Float>(i)*0.2, true);
          quantity -= bundleQuantity;
        };
        i += 1;
      };
    };
  };
}


@addMethod(VendingMachine)
protected func EVMDispenseManyJunk() -> Void {
  let i: Int32 = 0;
  let max: Int32 = RandRange(3, this.GetDevicePS().GetHackedItemCount()+1);
  // last # of range is excluded, therefore +1 to make sure 'this.GetDevicePS().GetHackedItemCount()' is included
  // returns 10 for food/drink vending machines and 5 for weapon vending machines
  while i < max {
    this.EVMDispenseOneJunk(i);
    i += 1;
  };
}


@addMethod(VendingMachine)
protected func EVMDispenseOneJunk(delay:Int32) -> Void {
  let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let junkVariants: array<JunkItemRecord> = this.m_vendorID.m_junkItemArray;
  let junkItem: ItemID = ItemID.FromTDBID(junkVariants[RandRange(0, 2)].m_junkItemID);
  // last # of range is excluded, therefore 1 becomes 2 to make sure 0 & 1 are both possible outcomes
  // RandRange(0, 2) because there are only two junk variants
  // look into ItemID.FromTDBID(t"Items.junk") to see if there are more variants
  TS.GiveItem(this, junkItem, 1);
  this.DelayHackedEvent(Cast<Float>(delay)*0.2, junkItem);
}


@addMethod(VendingMachine)
protected func EVMDispenseItems(settings: ref<evmMenuSettings>, itemDropOddsArray: array<Int32>) -> Void {
  let i: Int32 = 1;
  while settings.evmDispenseMax > i {
    if RandRange(0, 100) < itemDropOddsArray[i+1] { // if the probability threshold has been met for the current item
      this.DelayVendingMachineEvent(Cast<Float>(i)*0.2, true, true); // then dispense the current item from the vending machine
    } else {
      break; // break so that junk doesn't drop when an item probability check fails. Junk only falls if no items have dropped
    };
    i += 1;
  };
}


@wrapMethod(VendingMachine)
protected func StopGlitching() -> Void {
  let controllerPS = this.GetDevicePS();
  if controllerPS.m_hackCount < 1
  && !Equals(this.m_controllerTypeName, n"IceMachineController") {
    // this just prevents the glitch from ending once the vending machine has reached its hack limit
    // could add something here later
  } else {
    wrappedMethod();
  };
}