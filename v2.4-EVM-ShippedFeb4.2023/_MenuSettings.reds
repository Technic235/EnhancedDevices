public class EVMMenuSettings {
  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 3
  @runtimeProperty("ModSettings.category", "")
  @runtimeProperty("ModSettings.displayName", "'NICOLA!' when hacking") //
  @runtimeProperty("ModSettings.description", "OFF: vending/ice machines & slaught-o-matics no longer make an obnoxious announcement when hacked. Machines with the static starting malfunction have been made silent by default. ON: they will continue to scream at you.")
  let announcementsOn: Bool = false;
  
  // Items Hack Settings
  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Items Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Max possible items")
  @runtimeProperty("ModSettings.description", "The max number of items that can dispense from a vending machine per hack.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "5")
  @runtimeProperty("ModSettings.step", "1")
  let dispenseMax: Int32 = 3;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Items Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Item 1 dispense probability")
  @runtimeProperty("ModSettings.description", "The percentage chance that a vending machine will dispense at least one item from hacking it.")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  let itemDispenseOdds1: Int32 = 35;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Items Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Item 2 dispense probability")
  @runtimeProperty("ModSettings.description", "If the previous probability check succeeded, the percentage chance a 2nd item will dispense from a vending machine hack. A new number is generated for this check.")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "90")
  @runtimeProperty("ModSettings.step", "1")
  let itemDispenseOdds2: Int32 = 15;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Items Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Item 3 dispense probability")
  @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 3rd item will dispense from a vending machine hack. A new number is generated for this check.")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "90")
  @runtimeProperty("ModSettings.step", "1")
  let itemDispenseOdds3: Int32 = 15;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Items Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Item 4 dispense probability")
  @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 4th item will dispense from a vending machine hack. A new number is generated for this check.")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "90")
  @runtimeProperty("ModSettings.step", "1")
  let itemDispenseOdds4: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Items Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Item 5 dispense probability")
  @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 5th item will dispense from a vending machine hack. A new number is generated for this check.")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "90")
  @runtimeProperty("ModSettings.step", "1")
  let itemDispenseOdds5: Int32 = 50;

//   @runtimeProperty("ModSettings.mod", "Enhanced VM$")
//   @runtimeProperty("ModSettings.category", "Items Hack Settings")
//   @runtimeProperty("ModSettings.displayName", "Item 5 dispense probability")
//   @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 5th item will dispense from a vending machine hack. A new number is generated for this check.")
//   @runtimeProperty("ModSettings.min", "1")
//   @runtimeProperty("ModSettings.max", "90")
//   @runtimeProperty("ModSettings.step", "1")
//   let itemDispenseOdds5: Int32 = 50;

//   @runtimeProperty("ModSettings.mod", "Enhanced VM$")
//   @runtimeProperty("ModSettings.category", "Items Hack Settings")
//   @runtimeProperty("ModSettings.displayName", "Item 6 dispense probability")
//   @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 6th item will dispense from a vending machine hack. A new number is generated for this check.")
//   @runtimeProperty("ModSettings.min", "1")
//   @runtimeProperty("ModSettings.max", "90")
//   @runtimeProperty("ModSettings.step", "1")
//   let itemDispenseOdds6: Int32 = 50;

//   @runtimeProperty("ModSettings.mod", "Enhanced VM$")
//   @runtimeProperty("ModSettings.category", "Items Hack Settings")
//   @runtimeProperty("ModSettings.displayName", "Item 7 dispense probability")
//   @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 7th item will dispense from a vending machine hack. A new number is generated for this check.")
//   @runtimeProperty("ModSettings.min", "1")
//   @runtimeProperty("ModSettings.max", "90")
//   @runtimeProperty("ModSettings.step", "1")
//   let itemDispenseOdds7: Int32 = 50;

//   @runtimeProperty("ModSettings.mod", "Enhanced VM$")
//   @runtimeProperty("ModSettings.category", "Items Hack Settings")
//   @runtimeProperty("ModSettings.displayName", "Item 8 dispense probability")
//   @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance an 8th item will dispense from a vending machine hack. A new number is generated for this check.")
//   @runtimeProperty("ModSettings.min", "1")
//   @runtimeProperty("ModSettings.max", "90")
//   @runtimeProperty("ModSettings.step", "1")
//   let itemDispenseOdds8: Int32 = 50;

//   @runtimeProperty("ModSettings.mod", "Enhanced VM$")
//   @runtimeProperty("ModSettings.category", "Items Hack Settings")
//   @runtimeProperty("ModSettings.displayName", "Item 9 dispense probability")
//   @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 9th item will dispense from a vending machine hack. A new number is generated for this check.")
//   @runtimeProperty("ModSettings.min", "1")
//   @runtimeProperty("ModSettings.max", "90")
//   @runtimeProperty("ModSettings.step", "1")
//   let itemDispenseOdds9: Int32 = 50;

//   @runtimeProperty("ModSettings.mod", "Enhanced VM$")
//   @runtimeProperty("ModSettings.category", "Items Hack Settings")
//   @runtimeProperty("ModSettings.displayName", "Item 10 dispense probability")
//   @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 10th item will dispense from a vending machine hack. A new number is generated for this check.")
//   @runtimeProperty("ModSettings.min", "1")
//   @runtimeProperty("ModSettings.max", "90")
//   @runtimeProperty("ModSettings.step", "1")
//   let itemDispenseOdds10: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Items Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Junk dispense probability")
  @runtimeProperty("ModSettings.description", "If no items/eddies are dropped, the percentage chance a vending machine will dispense junk instead of dropping nothing. A new number is generated for this check.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  let junkDispenseOdds: Int32 = 95;

  // used in evmHackEffect() for 'evmItemDropOddsArray: array<Int32>'
  public func ItemHackSettingsToArray() -> array<Int32> {
    return [ // ArraySize() returns 6
      this.junkDispenseOdds,
      this.itemDispenseOdds1,
      this.itemDispenseOdds2,
      this.itemDispenseOdds3,
      this.itemDispenseOdds4,
      this.itemDispenseOdds5
    //   this.itemDispenseOdds6,
    //   this.itemDispenseOdds7,
    //   this.itemDispenseOdds8,
    //   this.itemDispenseOdds9,
    //   this.itemDispenseOdds10
    ];
  }

  // Eddies Hack Settings: 7 total
  // [0] Eddies drop probability - Slider
  // [1] Max eddies - Slider
  // [2] Min eddies - Slider
  // [3] Eddies always possible - Toggle
  // [4] Direct Deposit - Toggle
  // [5] Consolidate eddie bundles - Slider
  // [6] Ice machines drop eddies - Toggle

  // Eddies Hack Settings
  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 0
  @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Eddies drop probability")
  @runtimeProperty("ModSettings.description", "The percentage chance eddies will drop when hacked. The amount is randomly determined by min/max settings.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "90")
  @runtimeProperty("ModSettings.step", "1")
  let eddiesDropOdds: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 1
  @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Max eddies") //
  @runtimeProperty("ModSettings.description", "The max number of eddies that can drop if the probability check passes. Cannot be lower than the min.")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  let eddiesMax: Int32 = 25;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 2
  @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Min eddies") //
  @runtimeProperty("ModSettings.description", "The minimum number of eddies that can drop if the probability check passes. If higher than the max, the min will be reduced to one less than the max.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "99")
  @runtimeProperty("ModSettings.step", "1")
  let eddiesMin: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 3
  @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Eddies always possible") //
  @runtimeProperty("ModSettings.description", "OFF: eddies may only drop if no items are dispensed, assuming the check passes. ON: eddies could potentially drop even when items are dispensed.")
  let eddiesAlways: Bool = false;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 4
  @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Direct deposit") //
  @runtimeProperty("ModSettings.description", "OFF: eddie bundles dispense out of the vending machine that you have to pick up manually. ON: eddies are deposited directly to you without the need to pick them up.")
  let eddiesDeposit: Bool = false;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 5
  @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Consolidate eddie bundles") //
  @runtimeProperty("ModSettings.description", "When Direct deposit is off, this determines the percentage of eddies that are consolidated into fewer bundles. 100%: all eddies will be in a single bundle. 0%: all eddies will be split into bundles of 1 eddie each.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  let eddiesConsolidated: Int32 = 40;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 6
  @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Hack ice machines") //
  @runtimeProperty("ModSettings.description", "OFF: ice machines keep their default behavior of dispensing ice cubes when hacked. ON: ice machines can also drop eddies when hacked.")
  let eddiesFromIceMachine: Bool = true; // part of ArcadeMachineHacking

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 8
  @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Transfer hack arcade/pachinko machines") //
  @runtimeProperty("ModSettings.description", "OFF: both machines keep their default distract behavior when hacked. ON: both machines can transfer eddies to the player via direct deposit.")
  let hackArcadeMachine: Bool = true; // part of ArcadeMachineHacking

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 7
  @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Transfer hack drop points") //
  @runtimeProperty("ModSettings.description", "OFF: drop points keep their default distract behavior when hacked. ON: drop points can transfer eddies to the player via direct deposit.")
  let hackDropPoint: Bool = true; // part of DropPointHacking

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 8
  @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Transfer hack fuel dispensers") //
  @runtimeProperty("ModSettings.description", "OFF: fuel dispensers don't have a distract quickhack. ON: fuel dispensers can distract and transfer eddies to the player via direct deposit.")
  let hackExplosiveDevice: Bool = true; // part of ExplosiveDeviceHacking

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 8
  @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Transfer hack confession booths") //
  @runtimeProperty("ModSettings.description", "OFF: confession booths keep their default distract behavior. ON: confession booths can transfer eddies to the player via direct deposit.")
  let hackConfessionBooth: Bool = true; // part of ConfessionBoothHacking

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 8
  @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
  @runtimeProperty("ModSettings.displayName", "Transfer hack travel terminals") //
  @runtimeProperty("ModSettings.description", "OFF: fast travel terminals don't have a distract quickhack. ON: travel terminals can distract and transfer eddies to the player via direct deposit.")
  let hackTravelTerminal: Bool = true; // part of TravelTerminalHacking

  public func EddiesHackSettingsCount() -> Int32 {
    return 12;
  }

    // Hooligan Settings: 10 total - [9] isn't done yet
    // [0] Multiple drops possible - Toggle
    // [1] Drop behavior when breaking - Enumerator (Nothing when breaking, Sometimes when breaking, Only when breaking)
    // [2] Break probability - Slider
    // ... If three sliders below set to 0 then hide [0]-[1] & [6]-[8]
    // [3] Item probability - Slider
    // [4] Junk probability - Slider
    // [5] Eddies probability - Slider
    // ... If Eddies probability set to 0 then hide [6]-[8]
    // [6] Eddies Max - Slider
    // [7] Eddies Min - Slider
    // [8] Direct Deposit - Toggle
    // [9] Ice machines drop eddies

  // Inspired by yakuzadeso
  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 0
  @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  @runtimeProperty("ModSettings.displayName", "Drop behavior when breaking") 
  @runtimeProperty("ModSettings.description", "Never: no drops if the machine breaks. Sometimes: machines can break and drop something at the same time. Exclusively: drops can only occur when the machine breaks.")
  @runtimeProperty("ModSettings.displayValues", "\"Never\", \"Sometimes\", \"Exclusively\"")
  let onHitDropsOnBreak: EVMDropsOnBreakingEnum = EVMDropsOnBreakingEnum.Never;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 1
  @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  @runtimeProperty("ModSettings.displayName", "Break probability")
  @runtimeProperty("ModSettings.description", "The percentage chance the machine will break per hit.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  let onHitBreakOdds: Int32 = 5;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 2
  @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  @runtimeProperty("ModSettings.displayName", "Junk dispense probability")
  @runtimeProperty("ModSettings.description", "The percentage chance junk will dispense per hit. Junk always gets checked after items and eddies have both been checked.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  let onHitJunkOdds: Int32 = 20;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 3
  @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  @runtimeProperty("ModSettings.displayName", "Item dispense probability")
  @runtimeProperty("ModSettings.description", "The percentage chance an item will dispense per hit.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "90")
  @runtimeProperty("ModSettings.step", "1")
  let onHitItemOdds: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 4
  @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  @runtimeProperty("ModSettings.displayName", "Eddies dispense probability")
  @runtimeProperty("ModSettings.description", "The percentage chance an eddie bundle will dispense per hit. The amount is randomly determined by min/max settings.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "90")
  @runtimeProperty("ModSettings.step", "1")
  let onHitEddiesOdds: Int32 = 50;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 5
  @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  @runtimeProperty("ModSettings.displayName", "Max eddies")
  @runtimeProperty("ModSettings.description", "The max number of eddies that can dispense if the probability check passes. Cannot be lower than the min.")
  @runtimeProperty("ModSettings.min", "1")
  @runtimeProperty("ModSettings.max", "25")
  @runtimeProperty("ModSettings.step", "1")
  let onHitEddiesMax: Int32 = 25;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 6
  @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  @runtimeProperty("ModSettings.displayName", "Min eddies")
  @runtimeProperty("ModSettings.description", "The minimum number of eddies that can dispense if the probability check passes. If higher than the max, the min will be reduced to one less than the max.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "24")
  @runtimeProperty("ModSettings.step", "1")
  let onHitEddiesMin: Int32 = 1;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 7
  @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  @runtimeProperty("ModSettings.displayName", "Simultaneous drops")
  @runtimeProperty("ModSettings.description", "OFF: will only dispense an item or eddies per hit, but not both. ON: an item, eddies, and even junk can simultaneously dispense per hit. If OFF, the drop that gets checked first is randomized (items or eddies, then junk last).")
  let onHitMultiDrop: Bool = false;

  // @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 8
  // @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  // @runtimeProperty("ModSettings.displayName", "Direct deposit")
  // @runtimeProperty("ModSettings.description", "OFF: eddie bundles fall out of the vending machine and you have to pick them up manually. ON: eddies are deposited directly to you without the need to pick them up.")
  let onHitEddiesDeposit: Bool = false; // don't count this but needs to stay on

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  @runtimeProperty("ModSettings.displayName", "Vandalize ice machines")
  @runtimeProperty("ModSettings.description", "OFF: ice machines keep their default behavior of doing nothing when hit. ON: ice machines can drop eddies/junk and break when hit.")
  let onHitIceMachine: Bool = true;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  @runtimeProperty("ModSettings.displayName", "Vandalize arcade/pachinko machines")
  @runtimeProperty("ModSettings.description", "OFF: arcade & pachinko machines keep their default behavior of doing nothing when hit. ON: arcade & pachinko machines can break.")
  let onHitArcadeMachine: Bool = true;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  @runtimeProperty("ModSettings.displayName", "Vandalize drop points")
  @runtimeProperty("ModSettings.description", "OFF: drop points keep their default behavior of doing nothing when hit. ON: drop points can break, but are still useable.")
  let onHitDropPoint: Bool = true;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  @runtimeProperty("ModSettings.displayName", "Vandalize confession booths")
  @runtimeProperty("ModSettings.description", "OFF: confession booths keep their default behavior of doing nothing when hit. ON: confession booths can break.")
  let onHitConfessionBooth: Bool = true;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "On-Hit Vandal Settings")
  @runtimeProperty("ModSettings.displayName", "Vandalize travel terminals")
  @runtimeProperty("ModSettings.description", "OFF: travel terminals keep their default behavior of doing nothing when hit. ON: travel terminals can break, but are still useable.")
  let onHitTravelTerminal: Bool = true;

  public func OnHitSettingsCount() -> Int32 {
    return 13;
  }

//
//
//

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Vending Machines")
  @runtimeProperty("ModSettings.displayName", "Vending machine malfunction rate")
  @runtimeProperty("ModSettings.description", "The overall % of vending machines with a malfunction. 3 types: (continuous) static glitch, (intermittent) short glitch, (completely off) broken. Only set the relative odds sliders of 1 or 2 types to 0 to guarantee those types won't occur.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  let vendingMachineMalfunctionRate: Int32 = 85;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Vending Machines")
  @runtimeProperty("ModSettings.displayName", "Vending machine glitch relative odds")
  @runtimeProperty("ModSettings.description", "The odds a vending machine will short-glitch by default. They can be hacked once and also broken by hitting them. The three malfunction types are only considered if malfunction rate is above 0%.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let vendingMachineGlitch: Int32 = 11;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Vending Machines")
  @runtimeProperty("ModSettings.displayName", "Vending machine static relative odds")
  @runtimeProperty("ModSettings.description", "The odds a vending machine will static-glitch by default. They cannot be hacked, but can be broken by hitting them. Set this higher or lower than the other two types to determine how often this malfunction occurs.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let vendingMachineStatic: Int32 = 11;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Vending Machines")
  @runtimeProperty("ModSettings.displayName", "Vending machine broken relative odds")
  @runtimeProperty("ModSettings.description", "The odds a vending machine will be broken by default. They cannot be hacked. If the relative odds of all three types are equal, they will occur equally.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let vendingMachineBroken: Int32 = 1;

  public func VendingMachineMalfunctionsSettingsCount() -> Int32 {
    return 4;
  }

//
//
//

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Arcade/Pachinko Machines")
  @runtimeProperty("ModSettings.displayName", "Arcade/Pachinko malfunction rate")
  @runtimeProperty("ModSettings.description", "The overall % of machines with a malfunction. 3 types: (continuous) static glitch, (intermittent) short glitch, (completely off) broken. Only set the relative odds sliders of 1 or 2 types to 0 to guarantee those types won't occur.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  let arcadeMachineMalfunctionRate: Int32 = 40;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Arcade/Pachinko Machines")
  @runtimeProperty("ModSettings.displayName", "Arcade/Pachinko glitch relative odds")
  @runtimeProperty("ModSettings.description", "The odds a machine will short-glitch by default. They can be hacked once and also broken by hitting them. The three malfunction types are only considered if malfunction rate is above 0%.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let arcadeMachineGlitch: Int32 = 11;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Arcade/Pachinko Machines")
  @runtimeProperty("ModSettings.displayName", "Arcade/Pachinko static relative odds")
  @runtimeProperty("ModSettings.description", "The odds a machine will static-glitch by default. They cannot be hacked, but can be broken by hitting them. Set this higher or lower than the other two types to determine how often this malfunction occurs.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let arcadeMachineStatic: Int32 = 6;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Arcade/Pachinko Machines")
  @runtimeProperty("ModSettings.displayName", "Arcade/Pachinko broken relative odds")
  @runtimeProperty("ModSettings.description", "The odds a machine will be broken by default. They cannot be hacked. If the relative odds of all three types are equal, they will occur equally.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let arcadeMachineBroken: Int32 = 1;

  public func ArcadeMachineMalfunctionsSettingsCount() -> Int32 {
    return 4;
  }

//
//
//

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Drop Points")
  @runtimeProperty("ModSettings.displayName", "Drop point malfunction rate")
  @runtimeProperty("ModSettings.description", "The overall % of drop points with a malfunction. 3 types: (continuous) static glitch, (intermittent) short glitch, (completely off) broken. Only set the relative odds sliders of 1 or 2 types to 0 to guarantee those types won't occur.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  let dropPointMalfunctionRate: Int32 = 60;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Drop Points")
  @runtimeProperty("ModSettings.displayName", "Drop point glitch relative odds")
  @runtimeProperty("ModSettings.description", "The odds a drop point will short-glitch by default. They can be hacked once and also broken by hitting them. The three malfunction types are only considered if malfunction rate is above 0%.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let dropPointGlitch: Int32 = 11;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Drop Points")
  @runtimeProperty("ModSettings.displayName", "Drop point static relative odds")
  @runtimeProperty("ModSettings.description", "The odds a drop point will static-glitch by default. They cannot be hacked, but can be broken by hitting them. Set this higher or lower than the other two types to determine how often this malfunction occurs.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let dropPointStatic: Int32 = 6;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Drop Points")
  @runtimeProperty("ModSettings.displayName", "Drop point broken relative odds")
  @runtimeProperty("ModSettings.description", "The odds a drop point will be broken by default. They cannot be hacked. If the relative odds of all three types are equal, they will occur equally.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let dropPointBroken: Int32 = 1;

  public func DropPointMalfunctionsSettingsCount() -> Int32 {
    return 4;
  }

//
//
//

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Confession Booths")
  @runtimeProperty("ModSettings.displayName", "Confession booth malfunction rate")
  @runtimeProperty("ModSettings.description", "The overall % of confession booths with a malfunction. 3 types: (continuous) static glitch, (intermittent) short glitch, (completely off) broken. Only set the relative odds sliders of 1 or 2 types to 0 to guarantee those types won't occur.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  let confessionBoothMalfunctionRate: Int32 = 40;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Confession Booths")
  @runtimeProperty("ModSettings.displayName", "Confession booth glitch relative odds")
  @runtimeProperty("ModSettings.description", "The odds a confession booth will short-glitch by default. They can be hacked once and also broken by hitting them. The three malfunction types are only considered if malfunction rate is above 0%.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let confessionBoothGlitch: Int32 = 11;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Confession Booths")
  @runtimeProperty("ModSettings.displayName", "Confession booth static relative odds")
  @runtimeProperty("ModSettings.description", "The odds a confession booth will static-glitch by default. They cannot be hacked, but can be broken by hitting them. Set this higher or lower than the other two types to determine how often this malfunction occurs.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let confessionBoothStatic: Int32 = 6;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Confession Booths")
  @runtimeProperty("ModSettings.displayName", "Confession booth broken relative odds")
  @runtimeProperty("ModSettings.description", "The odds a confession booth will be broken by default. They cannot be hacked. If the relative odds of all three types are equal, they will occur equally.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let confessionBoothBroken: Int32 = 1;

  public func ConfessionBoothMalfunctionsSettingsCount() -> Int32 {
    return 4;
  }

//
//
//

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Travel Terminals")
  @runtimeProperty("ModSettings.displayName", "Travel terminal malfunction rate")
  @runtimeProperty("ModSettings.description", "The overall % of travel terminals with a malfunction. 3 types: (continuous) static glitch, (intermittent) short glitch, (completely off) broken. Only set the relative odds sliders of 1 or 2 types to 0 to guarantee those types won't occur.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "100")
  @runtimeProperty("ModSettings.step", "1")
  let travelTerminalMalfunctionRate: Int32 = 40;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Travel Terminals")
  @runtimeProperty("ModSettings.displayName", "Travel terminal glitch relative odds")
  @runtimeProperty("ModSettings.description", "The odds a travel terminal will short-glitch by default. They can be hacked once and also broken by hitting them. The three malfunction types are only considered if malfunction rate is above 0%.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let travelTerminalGlitch: Int32 = 11;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Travel Terminals")
  @runtimeProperty("ModSettings.displayName", "Travel terminal static relative odds")
  @runtimeProperty("ModSettings.description", "The odds a travel terminal will static-glitch by default. They cannot be hacked, but can be broken by hitting them. Set this higher or lower than the other two types to determine how often this malfunction occurs.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let travelTerminalStatic: Int32 = 6;

  @runtimeProperty("ModSettings.mod", "Enhanced VM$")
  @runtimeProperty("ModSettings.category", "Starting Malfunctions: Travel Terminals")
  @runtimeProperty("ModSettings.displayName", "Travel terminal broken relative odds")
  @runtimeProperty("ModSettings.description", "The odds a travel terminal will be broken by default. They cannot be hacked. If the relative odds of all three types are equal, they will occur equally.")
  @runtimeProperty("ModSettings.min", "0")
  @runtimeProperty("ModSettings.max", "11")
  @runtimeProperty("ModSettings.step", "1")
  let travelTerminalBroken: Int32 = 1;

  public func TravelTerminalMalfunctionsSettingsCount() -> Int32 {
    return 4;
  }
}

enum EVMDropsOnBreakingEnum {
    Never = 0,
    Sometimes = 1,
    Exclusively = 2
}