module EnhancedDevices.Hacking.VendingMachine
import EnhancedDevices.VendingMachine.*
import EnhancedDevices.Settings.*
import EnhancedDevices.*

// <- VendingMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// <- VendingMachineController <- (skips BasicDistractionDeviceController) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// <- VendingMachineControllerPS <- (skips BasicDistractionDeviceControllerPS) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-
// IceMachine(Controller)(PS)/WeaponMachine(Controller)(PS) <- VendingMachine(Controller)(PS) <-

//deviceComponentBase.script for device states
// public const function GetDeviceState() : EDeviceStatus { return m_deviceState; }
// protected function CacheDeviceState( state : EDeviceStatus ) {...}
// protected virtual function SetDeviceState( state : EDeviceStatus ) {...}
// public virtual function EvaluateDeviceState() {...}

@replaceMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func HackedEffect() -> Void {
  // stop script if vending machine is sold out.
  if this.GetBlackboard().GetBool(GetAllBlackboardDefs().VendingMachineDeviceBlackboard.SoldOut)
  || this.GetDevicePS().evmHacksRemaining < 0 // evmHacksRemaining <= 0  ---->  evmHacksRemaining < 0
  || Equals(this.GetDevicePS().evmMalfunctionName, "static") {
    // need to DECREASE this by 1 since there's complications in OnQuickHackDistraction() in VendingMachineMalfunctions.reds
    return;
  };

  // new variables for this mod
  let settings = new EVMMenuSettings();
  let itemDropOddsArray: array<Int32> = settings.ItemHackSettingsToArray();
  let eddiesOddsCheck = RandRange(0, 100);

  if settings.dispenseMax > 0 // if the player wants the possibility of at least 1 item to dispense from the vending machine
  && RandRange(0, 100) < itemDropOddsArray[1] { // and the probability threshold has been met for the first item
    this.DelayVendingMachineEvent(0, true, true); // dispense the first item
    this.EVMDispenseItems(settings, itemDropOddsArray); // check the rest of the items
    // no need for PlayItemFall() or RefreshUI() since they're already invoked by...
    // DelayVendingMachineEvent() -> VendingMachineFinishedEvent()
  } else { // if no items drop
    if eddiesOddsCheck >= settings.eddiesDropOdds { // if no eddies drop
      if RandRange(0, 100) < itemDropOddsArray[0] { // check if junk will drop
        this.EVMDispenseManyJunk(); // drop junk
      }; // slaught-o-matic doesn't drop junk but can be forced to with...
      // let junkItem: ItemID = ItemID.FromTDBID(t"Items.BaseDestroyedJunk");
    } else { // if eddies probability check passes
      if Equals(settings.eddiesAlways, false) { // if 'Eddies always possible' is false
        this.EVMDispenseEddies(eddiesOddsCheck); // drop eddies
      };
    };
  };

  if Equals(settings.eddiesAlways, true) { // if 'Eddies always possible' is true
    this.EVMDispenseEddies(eddiesOddsCheck); // drop eddies if the probability check passes
  };

  if this.GetDevicePS().IsSoldOut() {
    this.SendSoldOutToUIBlackboard(true);
    this.m_interaction.Toggle(false); // does this do anything?
  };
};


@wrapMethod(IceMachine) // <- VendingMachine <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func HackedEffect() -> Void {
  let devicePS = this.GetDevicePS();
  if this.GetBlackboard().GetBool(GetAllBlackboardDefs().VendingMachineDeviceBlackboard.SoldOut)
  || devicePS.evmHacksRemaining < 0
  || Equals(devicePS.evmMalfunctionName, "static") {
    // need to DECREASE this by 1 since there's complications in OnQuickHackDistraction() in VendingMachineMalfunctions.reds
    return;
  };
  let settings = new EVMMenuSettings();
  if Equals(settings.eddiesFromIceMachine, true) {
    let eddiesOddsCheck = RandRange(0, 100);
    if eddiesOddsCheck >= settings.eddiesDropOdds { // if no eddies drop
      if RandRange(0, 100) < settings.junkDispenseOdds { // check if junk will drop
        wrappedMethod(); // drop junk
      };
    } else { // if eddies probability check passes
      this.EVMDispenseEddies(eddiesOddsCheck); // drop eddies
    };
  } else {
    wrappedMethod();
  };
  if devicePS.IsSoldOut() {
    this.SendSoldOutToUIBlackboard(true);
    devicePS.m_isSoldOut = true;
    this.RefreshUI(); // does this need to happen?
  };
}

@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMDispenseEddies(eddiesOddsCheck:Int32) -> Void {
  let settings = new EVMMenuSettings();
  if eddiesOddsCheck < settings.eddiesDropOdds {
    let min: Int32 = settings.eddiesMin;
    let max: Int32 = settings.eddiesMax;
    if min >= max {
      min = max - 1;
    };
    let quantity = RandRange(min, max+1);
    // last # of range is excluded, therefore +1 to make sure 'max' is included

    if Equals(settings.eddiesDeposit, false) { // if direct deposit off
      this.EVMDispenseEddiesRandomizer(quantity);
    } else { // if direct deposit on
      let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
      TS.GiveItem(GetPlayer(this.GetGame()), MarketSystem.Money(), quantity);
    };
  };
}

@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMDispenseEddiesRandomizer(quantity:Int32) -> Void {
  let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  let moneyItem: ItemID = ItemID.FromTDBID(t"Items.money");
  TS.GiveItem(this, moneyItem, quantity);

  let settings = new EVMMenuSettings();
  if settings.eddiesConsolidated == 0 {
    let i: Int32 = 0;
    while i < quantity {
      this.DelayHackedEvent(Cast<Float>(i)*0.2, moneyItem);
      i += 1;
    };
  } else {
    let delaySystem: ref<DelaySystem> = GameInstance.GetDelaySystem(this.GetGame());
    let callback = new EVMDispenseEddieBundles();
    callback.vendingMachine = this;
    callback.lootManager = GameInstance.GetLootManager(this.GetGame());

    if settings.eddiesConsolidated == 100 {
      ArrayPush(callback.dropInstructions, DropInstruction.Create(moneyItem, quantity));
      delaySystem.DelayCallback(callback, 0, true);
      return;
    };

    let split: Float = 100.00 / Cast<Float>(settings.eddiesConsolidated);
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


@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMDispenseManyJunk() -> Void {
  let i: Int32 = 0;
  let max: Int32 = RandRange(3, this.GetDevicePS().GetHackedItemCount()+1);
  // last # of range is excluded, therefore +1 to make sure 'this.GetDevicePS().GetHackedItemCount()' is included
  // returns 10 for food/drink vending machines and 5 for weapon vending machines
  let TS: ref<TransactionSystem> = GameInstance.GetTransactionSystem(this.GetGame());
  while i < max {
    let junkItem: ItemID = this.DetermineJunkItem();
    if TDBID.IsValid(ItemID.GetTDBID(junkItem)) {
      TS.GiveItem(this, junkItem, 1);
      this.DelayHackedEvent(Cast<Float>(i)*0.2, junkItem);
    };
    i += 1;
  };

  let devicePS = this.GetDevicePS();
  if Equals(devicePS.evmMalfunctionName, "static")
  && devicePS.evmHacksRemaining < 0 {
    devicePS.m_isReady = false;
    this.RefreshUI();
  };
}


@addMethod(VendingMachine) // <- (skips BasicDistractionDevice) <- InteractiveDevice <-
protected func EVMDispenseItems(settings:ref<EVMMenuSettings>, itemDropOddsArray:array<Int32>) -> Void {
  let i: Int32 = 1;
  while settings.dispenseMax > i {
    if RandRange(0, 100) < itemDropOddsArray[i+1] { // if the probability threshold has been met for the current item
      this.DelayVendingMachineEvent(Cast<Float>(i)*0.2, true, true); // then dispense the current item from the vending machine
    } else {
      break; // break so that junk doesn't drop when an item probability check fails. Junk only falls if no items have dropped
    };
    i += 1;
  };
}