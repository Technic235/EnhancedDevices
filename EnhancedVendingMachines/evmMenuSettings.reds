module evmMenuSettings
public class evmMenuSettings {
    // Items Hack Settings
    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Items Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Max possible items")
    @runtimeProperty("ModSettings.description", "The max number of items that can dispense from a vending machine per hack.")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "10")
    @runtimeProperty("ModSettings.step", "1")
    let evmDispenseMax: Int32 = 3;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Items Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Item 1 dispense probability")
    @runtimeProperty("ModSettings.description", "The percentage chance that a vending machine will dispense at least one item from hacking it.")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "90")
    @runtimeProperty("ModSettings.step", "1")
    let evmDispenseOdds1: Int32 = 35;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Items Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Item 2 dispense probability")
    @runtimeProperty("ModSettings.description", "If the previous probability check succeeded, the percentage chance a 2nd item will dispense from a vending machine hack. A new number is generated for this check.")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "90")
    @runtimeProperty("ModSettings.step", "1")
    let evmDispenseOdds2: Int32 = 15;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Items Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Item 3 dispense probability")
    @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 3rd item will dispense from a vending machine hack. A new number is generated for this check.")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "90")
    @runtimeProperty("ModSettings.step", "1")
    let evmDispenseOdds3: Int32 = 15;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Items Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Item 4 dispense probability")
    @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 4th item will dispense from a vending machine hack. A new number is generated for this check.")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "90")
    @runtimeProperty("ModSettings.step", "1")
    let evmDispenseOdds4: Int32 = 50;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Items Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Item 5 dispense probability")
    @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 5th item will dispense from a vending machine hack. A new number is generated for this check.")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "90")
    @runtimeProperty("ModSettings.step", "1")
    let evmDispenseOdds5: Int32 = 50;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Items Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Item 6 dispense probability")
    @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 6th item will dispense from a vending machine hack. A new number is generated for this check.")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "90")
    @runtimeProperty("ModSettings.step", "1")
    let evmDispenseOdds6: Int32 = 50;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Items Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Item 7 dispense probability")
    @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 7th item will dispense from a vending machine hack. A new number is generated for this check.")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "90")
    @runtimeProperty("ModSettings.step", "1")
    let evmDispenseOdds7: Int32 = 50;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Items Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Item 8 dispense probability")
    @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance an 8th item will dispense from a vending machine hack. A new number is generated for this check.")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "90")
    @runtimeProperty("ModSettings.step", "1")
    let evmDispenseOdds8: Int32 = 50;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Items Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Item 9 dispense probability")
    @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 9th item will dispense from a vending machine hack. A new number is generated for this check.")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "90")
    @runtimeProperty("ModSettings.step", "1")
    let evmDispenseOdds9: Int32 = 50;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Items Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Item 10 dispense probability")
    @runtimeProperty("ModSettings.description", "If previous probability checks succeeded, the percentage chance a 10th item will dispense from a vending machine hack. A new number is generated for this check.")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "90")
    @runtimeProperty("ModSettings.step", "1")
    let evmDispenseOdds10: Int32 = 50;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Items Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Junk dispense probability")
    @runtimeProperty("ModSettings.description", "If no items/eddies are dropped, the percentage chance a vending machine will dispense junk instead of dropping nothing. A new number is generated for this check.")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "100")
    @runtimeProperty("ModSettings.step", "1")
    let evmDispenseOddsJunk: Int32 = 75;

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
    @runtimeProperty("ModSettings.max", "100")
    @runtimeProperty("ModSettings.step", "1")
    let evmEddiesOdds: Int32 = 90;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 1
    @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Max Eddies") //
    @runtimeProperty("ModSettings.description", "The max number of eddies that can drop if the probability check passes. Cannot be lower than the min.")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "100")
    @runtimeProperty("ModSettings.step", "1")
    let evmEddiesMax: Int32 = 25;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 2
    @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Min Eddies") //
    @runtimeProperty("ModSettings.description", "The minimum number of eddies that can drop if the probability check passes. If higher than the max, the min will be reduced to one less than the max.")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "99")
    @runtimeProperty("ModSettings.step", "1")
    let evmEddiesMin: Int32 = 1;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 3
    @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Eddies always possible") //
    @runtimeProperty("ModSettings.description", "OFF: eddies may only drop if no items are dispensed, assuming the check passes. ON: eddies could potentially drop even when items are dispensed.")
    let evmEddiesAlways: Bool = false;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 4
    @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Direct deposit") //
    @runtimeProperty("ModSettings.description", "OFF: eddie bundles dispense out of the vending machine that you have to pick up manually. ON: eddies are deposited directly to you without the need to pick them up.")
    let evmEddiesDeposit: Bool = false;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 5
    @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Consolidate eddie bundles") //
    @runtimeProperty("ModSettings.description", "When Direct deposit is off, this determines the percentage of eddies that are consolidated into fewer bundles. 100%: all eddies will be in a single bundle. 0%: all eddies will be split into bundles of 1 eddie each.")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "100")
    @runtimeProperty("ModSettings.step", "1")
    let evmEddiesConsolidated: Int32 = 40;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 6
    @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Rob ice machines") //
    @runtimeProperty("ModSettings.description", "OFF: ice machines keep their default behavior of dispensing ice cubes when hacked. ON: ice machines can also drop eddies when hacked.")
    let evmEddiesFromIceMachines: Bool = true;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 7
    @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Rob drop points") //
    @runtimeProperty("ModSettings.description", "OFF: drop points keep their default behavior of doing nothing when hacked. ON: drop points can transfer eddies to the player via direct deposit.")
    let evmHackDropPoints: Bool = true;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 8
    @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Rob arcade machines") //
    @runtimeProperty("ModSettings.description", "OFF: arcade machines keep their default behavior of doing nothing when hacked. ON: arcade machines can transfer eddies to the player via direct deposit.")
    let evmHackArcadeMachines: Bool = true;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 8
    @runtimeProperty("ModSettings.category", "Eddies Hack Settings")
    @runtimeProperty("ModSettings.displayName", "Rob fuel pumps") //
    @runtimeProperty("ModSettings.description", "OFF: fuel pumps keep their default behavior of doing nothing when hacked. ON: fuel pumps can transfer eddies to the player via direct deposit.")
    let evmHackFuelPumps: Bool = true;


    // Hooligan Settings: 10 total - [9] isn't done yet
    // [0] Multiple drops possible - Toggle
    // [1] Drop behavior if breaking - Enumerator (Nothing when breaking, Sometimes when breaking, Only when breaking)
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

    // Hooligan Settings - Inspired by yakuzadeso
    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 0
    @runtimeProperty("ModSettings.category", "On-Hit 'Hooligan' Settings - Inspired by yakuzadeso")
    @runtimeProperty("ModSettings.displayName", "Drop behavior when breaking") 
    @runtimeProperty("ModSettings.description", "Never: no drops if the machine breaks. Sometimes: machines can break and drop something at the same time. Exclusively: drops can only occur when the machine breaks.")
    @runtimeProperty("ModSettings.displayValues", "\"Never\", \"Sometimes\", \"Exclusively\"")
    let evmDropsOnBreaking: EVMDropsOnBreakingEnum = EVMDropsOnBreakingEnum.Never;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 1
    @runtimeProperty("ModSettings.category", "On-Hit 'Hooligan' Settings - Inspired by yakuzadeso")
    @runtimeProperty("ModSettings.displayName", "Break probability")
    @runtimeProperty("ModSettings.description", "The percentage chance the machine will break per hit.")
    @runtimeProperty("ModSettings.min", "5")
    @runtimeProperty("ModSettings.max", "100")
    @runtimeProperty("ModSettings.step", "1")
    let evmHooliganBreakOdds: Int32 = 10;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 2
    @runtimeProperty("ModSettings.category", "On-Hit 'Hooligan' Settings - Inspired by yakuzadeso")
    @runtimeProperty("ModSettings.displayName", "Junk dispense probability")
    @runtimeProperty("ModSettings.description", "The percentage chance junk will dispense per hit. Junk always gets checked after items and eddies have both been checked.")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "100")
    @runtimeProperty("ModSettings.step", "1")
    let evmHooliganJunkOdds: Int32 = 20;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 3
    @runtimeProperty("ModSettings.category", "On-Hit 'Hooligan' Settings - Inspired by yakuzadeso")
    @runtimeProperty("ModSettings.displayName", "Item dispense probability")
    @runtimeProperty("ModSettings.description", "The percentage chance an item will dispense per hit.")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "90")
    @runtimeProperty("ModSettings.step", "1")
    let evmHooliganItemOdds: Int32 = 20;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 4
    @runtimeProperty("ModSettings.category", "On-Hit 'Hooligan' Settings - Inspired by yakuzadeso")
    @runtimeProperty("ModSettings.displayName", "Eddies dispense probability")
    @runtimeProperty("ModSettings.description", "The percentage chance an eddie bundle will dispense per hit. The amount is randomly determined by min/max settings.")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "90")
    @runtimeProperty("ModSettings.step", "1")
    let evmHooliganEddiesOdds: Int32 = 20;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 5
    @runtimeProperty("ModSettings.category", "On-Hit 'Hooligan' Settings - Inspired by yakuzadeso")
    @runtimeProperty("ModSettings.displayName", "Max eddies")
    @runtimeProperty("ModSettings.description", "The max number of eddies that can dispense if the probability check passes. Cannot be lower than the min.")
    @runtimeProperty("ModSettings.min", "1")
    @runtimeProperty("ModSettings.max", "50")
    @runtimeProperty("ModSettings.step", "1")
    let evmHooliganEddiesMax: Int32 = 25;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 6
    @runtimeProperty("ModSettings.category", "On-Hit 'Hooligan' Settings - Inspired by yakuzadeso")
    @runtimeProperty("ModSettings.displayName", "Min eddies")
    @runtimeProperty("ModSettings.description", "The minimum number of eddies that can dispense if the probability check passes. If higher than the max, the min will be reduced to one less than the max.")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "49")
    @runtimeProperty("ModSettings.step", "1")
    let evmHooliganEddiesMin: Int32 = 1;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 7
    @runtimeProperty("ModSettings.category", "On-Hit 'Hooligan' Settings - Inspired by yakuzadeso")
    @runtimeProperty("ModSettings.displayName", "Simultaneous drops")
    @runtimeProperty("ModSettings.description", "OFF: will only dispense an item or eddies per hit, but not both. ON: an item, eddies, and even junk can simultaneously dispense per hit. If OFF, the drop that gets checked first is randomized (items or eddies, then junk last).")
    let evmMultiDrop: Bool = false;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 8
    @runtimeProperty("ModSettings.category", "On-Hit 'Hooligan' Settings - Inspired by yakuzadeso")
    @runtimeProperty("ModSettings.displayName", "Vandalize ice machines")
    @runtimeProperty("ModSettings.description", "OFF: ice machines keep their default behavior of doing nothing when hit. ON: ice machines can drop eddies/junk and glitch/break when hit, but are still useable.")
    let evmHooliganIceMachines: Bool = true;

    // @runtimeProperty("ModSettings.mod", "Enhanced VM$") // 8
    // @runtimeProperty("ModSettings.category", "On-Hit 'Hooligan' Settings - Inspired by yakuzadeso")
    // @runtimeProperty("ModSettings.displayName", "Direct deposit")
    // @runtimeProperty("ModSettings.description", "OFF: eddie bundles fall out of the vending machine and you have to pick them up manually. ON: eddies are deposited directly to you without the need to pick them up.")
    let evmHooliganEddiesDeposit: Bool = false;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Machine Disruption Settings")
    @runtimeProperty("ModSettings.displayName", "Drop point malfunction rate")
    @runtimeProperty("ModSettings.description", "The overall % of drop points with a malfunction. 3 types: (continuous) static glitch, (intermittent) short glitch, (completely off) broken. Only set the weighted odds sliders of 1 or 2 types to 0 to guarantee those types won't occur.")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "100")
    @runtimeProperty("ModSettings.step", "1")
    let evmDropPointMalfunctionRate: Int32 = 100;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Machine Disruption Settings")
    @runtimeProperty("ModSettings.displayName", "Drop point static glitch weighted odds")
    @runtimeProperty("ModSettings.description", "The odds a drop point will static-glitch by default. They cannot be hacked, but can be broken by hitting them. The three malfunction types are only considered if malfunction rate is above 0%.")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "11")
    @runtimeProperty("ModSettings.step", "1")
    let evmDropPointStaticGlitch: Int32 = 0;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Machine Disruption Settings")
    @runtimeProperty("ModSettings.displayName", "Drop point short glitch weighted odds")
    @runtimeProperty("ModSettings.description", "The odds a drop point will short-glitch by default. They can be hacked once and also broken by hitting them. Set this higher or lower than the other two types to determine how often this malfunction occurs.")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "11")
    @runtimeProperty("ModSettings.step", "1")
    let evmDropPointShortGlitch: Int32 = 0;

    @runtimeProperty("ModSettings.mod", "Enhanced VM$")
    @runtimeProperty("ModSettings.category", "Machine Disruption Settings")
    @runtimeProperty("ModSettings.displayName", "Drop point broken weighted odds")
    @runtimeProperty("ModSettings.description", "The odds a drop point will be broken by default. They cannot be hacked. If the weighted odds of all three types are equal, they will occur equally.")
    @runtimeProperty("ModSettings.min", "0")
    @runtimeProperty("ModSettings.max", "11")
    @runtimeProperty("ModSettings.step", "1")
    let evmDropPointBroken: Int32 = 11;

    // used in evmHackEffect() for 'evmItemDropOddsArray: array<Int32>'
    public func evmPushSettingsToArray() -> array<Int32> {
        return [
            this.evmDispenseOddsJunk,
            this.evmDispenseOdds1,
            this.evmDispenseOdds2,
            this.evmDispenseOdds3,
            this.evmDispenseOdds4,
            this.evmDispenseOdds5,
            this.evmDispenseOdds6,
            this.evmDispenseOdds7,
            this.evmDispenseOdds8,
            this.evmDispenseOdds9,
            this.evmDispenseOdds10
        ];
    }
}

enum EVMDropsOnBreakingEnum {
    Never = 0,
    Sometimes = 1,
    Exclusively = 2
}