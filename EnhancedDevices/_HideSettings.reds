module EnhancedDevices.HideSettings
import EnhancedDevices.Settings.*

@addField(SettingsMainGameController)
let modReference: SettingsCategory;

@addField(SettingsMainGameController)
let categoryReference: SettingsCategory;

// shared dependencies absolutely required

// This is for uncategorized settings, but I don't have any
// @wrapMethod(SettingsMainGameController)
// protected func IsResetButtonEnabled() -> Bool {
//   if !this.modReference.isEmpty {
//     let mod = this.modReference;
//     if this.categoryReference.isEmpty {
//       // let category = this.categoryReference; //
//       if Equals(mod.label, n"Enhanced VM$") {
//         let settings = new EVMMenuSettings();
//         // settings to be removed
//       };

//       ArrayClear(this.modReference.options);
//       for option in mod.options {
//         ArrayPush(this.modReference.options, option);
//       };
//     };
//   };
//   return wrappedMethod();
// }

// doesn't require anything else
@if(ModuleExists("EnhancedDevices.Hacking.VendingMachine"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;
      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Items Hack Settings") {
          let i: Int32 = 5;
          // up to 5 items can be dispensed so we start at 5 and subtract from that.
          while i > settings.dispenseMax {
            ArrayErase(category.options, i);
            i -= 1;
          };
        };

        if Equals(category.label, n"Eddies Hack Settings") {
          if settings.eddiesDropOdds == 0 {
            let i = 0;
            while i <= settings.EddiesHackSettingsCount() {
              if IsDefined(category.options[i]) {
                if Equals(category.options[i].GetDisplayName(), n"Max eddies")
                || Equals(category.options[i].GetDisplayName(), n"Min eddies")
                || Equals(category.options[i].GetDisplayName(), n"Eddies always possible")
                || Equals(category.options[i].GetDisplayName(), n"Direct deposit")
                || Equals(category.options[i].GetDisplayName(), n"Consolidate eddie bundles") {
                  ArrayErase(category.options, i);
                } else {
                  i += 1;
                };
              } else {
                break;
              };
            };
          };
          if Equals(settings.eddiesDeposit, true) {
            let i = 0;
            while i <= settings.EddiesHackSettingsCount() {
              if IsDefined(category.options[i]) {
                if Equals(category.options[i].GetDisplayName(), n"Consolidate eddie bundles") {
                  ArrayErase(category.options, i);
                  break;
                } else {
                  i += 1;
                };
              } else {
                break;
              };
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(!ModuleExists("EnhancedDevices.Hacking.VendingMachine"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Items Hack Settings") {
          let i = 0;
          while i < ArraySize(settings.ItemHackSettingsToArray()) {
            ArrayErase(category.options, 0);
            i += 1;
          };
        };

        if Equals(category.label, n"Eddies Hack Settings") {
          let i = 0;
          while i <= settings.EddiesHackSettingsCount() {
            ArrayErase(category.options, 0);
            i += 1;
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// // // requires VendingMachineHackedEffect
// // // includes Transfer hack arcade/pachinko machines
@if(!ModuleExists("EnhancedDevices.Hacking.ArcadeMachine"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Eddies Hack Settings") {
          let i = 0;
          while i <= settings.EddiesHackSettingsCount() {
            if IsDefined(category.options[i]) {
              if Equals(category.options[i].GetDisplayName(), n"Transfer hack arcade/pachinko machines") {
                ArrayErase(category.options, i);
              } else {
                i += 1;
              };
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// // // requires VendingMachineHackedEffect
// // // Includes Transfer hack drop points
@if(!ModuleExists("EnhancedDevices.Hacking.DropPoint"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Eddies Hack Settings") {
          let i = 0;
          while i <= settings.EddiesHackSettingsCount() {
            if IsDefined(category.options[i]) {
              if Equals(category.options[i].GetDisplayName(), n"Transfer hack drop points") {
                ArrayErase(category.options, i);
                break;
              } else {
                i += 1;
              };
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// // // requires VendingMachineHackedEffect
// // // Includes Transfer hack explosive devices
@if(!ModuleExists("EnhancedDevices.Hacking.FuelDispenser"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Eddies Hack Settings") {
          let i = 0;
          while i <= settings.EddiesHackSettingsCount() {
            if IsDefined(category.options[i]) {
              if Equals(category.options[i].GetDisplayName(), n"Transfer hack fuel dispensers") {
                ArrayErase(category.options, i);
                break;
              } else {
                i += 1;
              };
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// // // requires VendingMachineHackedEffect
// // // Includes Transfer hack confession booths
@if(!ModuleExists("EnhancedDevices.Hacking.ConfessionBooth"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Eddies Hack Settings") {
          let i = 0;
          while i <= settings.EddiesHackSettingsCount() {
            if IsDefined(category.options[i]) {
              if Equals(category.options[i].GetDisplayName(), n"Transfer hack confession booths") {
                ArrayErase(category.options, i);
                break;
              } else {
                i += 1;
              };
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// // // requires VendingMachineHackedEffect
// // // Includes Transfer hack travel terminals
@if(!ModuleExists("EnhancedDevices.Hacking.TravelTerminal"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Eddies Hack Settings") {
          let i = 0;
          while i <= settings.EddiesHackSettingsCount() {
            if IsDefined(category.options[i]) {
              if Equals(category.options[i].GetDisplayName(), n"Transfer hack travel terminals") {
                ArrayErase(category.options, i);
                break;
              } else {
                i += 1;
              };
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(ModuleExists("EnhancedDevices.OnHit.VendingMachine"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"On-Hit Vandal Settings") {
          let i = 0;
          while i < settings.OnHitSettingsCount() {
            if IsDefined(category.options[i]) {
              let didDelete = false;
              if settings.onHitItemOdds == 0
              && settings.onHitEddiesOdds == 0
              && settings.onHitJunkOdds == 0 { // if all three sliders off
                if Equals(category.options[i].GetDisplayName(), n"Drop behavior when breaking")
                || Equals(category.options[i].GetDisplayName(), n"Min eddies")
                || Equals(category.options[i].GetDisplayName(), n"Max eddies")
                || Equals(category.options[i].GetDisplayName(), n"Simultaneous drops") {
                  ArrayErase(category.options, i);
                  didDelete = true;
                };
              };

              if ((settings.onHitItemOdds == 0 && settings.onHitEddiesOdds == 0)
              || (settings.onHitItemOdds == 0 && settings.onHitJunkOdds == 0)
              || (settings.onHitEddiesOdds == 0 && settings.onHitJunkOdds == 0)) { // if only two sliders off
                if Equals(category.options[i].GetDisplayName(), n"Simultaneous drops") {
                  ArrayErase(category.options, i);
                  didDelete = true;
                };
              };

              if settings.onHitEddiesOdds == 0 { // if only the eddies slider is off
                if Equals(category.options[i].GetDisplayName(), n"Max eddies")
                || Equals(category.options[i].GetDisplayName(), n"Min eddies") {
                // OR if the eddies slider and one other slider is off
                ArrayErase(category.options, i);
                didDelete = true;
                };
              };

              if !didDelete { i += 1; };
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(!ModuleExists("EnhancedDevices.OnHit.VendingMachine"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"On-Hit Vandal Settings") {
          let i = 0;
          while i < settings.OnHitSettingsCount() {
            if IsDefined(category.options[0]) {
              ArrayErase(category.options, 0);
              i += 1;
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(ModuleExists("EnhancedDevices.Malfunctions.VendingMachine"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Starting Malfunctions: Vending Machines") {
          if settings.vendingMachineMalfunctionRate == 0 {
            let i = settings.VendingMachineMalfunctionsSettingsCount()-1; // returns 4-1 -> returns 3
            while i > 0 {
              if IsDefined(category.options[i]) {
                ArrayErase(category.options, i);
                i -= 1;
              } else {
                break;
              };
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(!ModuleExists("EnhancedDevices.Malfunctions.VendingMachine"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Starting Malfunctions: Vending Machines") {
          let i = 0;
          while i < settings.VendingMachineMalfunctionsSettingsCount() {
            if IsDefined(category.options[0]) {
              ArrayErase(category.options, 0);
              i += 1;
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(ModuleExists("EnhancedDevices.Malfunctions.ArcadeMachine"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Starting Malfunctions: Arcade/Pachinko Machines") {
          if settings.arcadeMachineMalfunctionRate == 0 {
            let i = settings.ArcadeMachineMalfunctionsSettingsCount()-1; // returns 4-1 -> returns 3
            while i > 0 {
              if IsDefined(category.options[i]) {
                ArrayErase(category.options, i);
                i -= 1;
              } else {
                break;
              };
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(!ModuleExists("EnhancedDevices.Malfunctions.ArcadeMachine"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Starting Malfunctions: Arcade/Pachinko Machines") {
          let i = 0;
          while i < settings.ArcadeMachineMalfunctionsSettingsCount() {
            if IsDefined(category.options[0]) {
              ArrayErase(category.options, 0);
              i += 1;
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}



// doesn't require anything else
@if(ModuleExists("EnhancedDevices.Malfunctions.DropPoint"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Starting Malfunctions: Drop Points") {
          if settings.dropPointMalfunctionRate == 0 {
            let i = settings.DropPointMalfunctionsSettingsCount()-1; // returns 4-1 -> returns 3
            while i > 0 {
              if IsDefined(category.options[i]) {
                ArrayErase(category.options, i);
                i -= 1;
              } else {
                break;
              };
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(!ModuleExists("EnhancedDevices.Malfunctions.DropPoint"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Starting Malfunctions: Drop Points") {
          let i = 0;
          while i < settings.DropPointMalfunctionsSettingsCount() {
            if IsDefined(category.options[0]) {
              ArrayErase(category.options, 0);
              i += 1;
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(ModuleExists("EnhancedDevices.Malfunctions.ConfessionBooth"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Starting Malfunctions: Confession Booths") {
          if settings.confessionBoothMalfunctionRate == 0 {
            let i = settings.ConfessionBoothMalfunctionsSettingsCount()-1; // returns 4-1 -> returns 3
            while i > 0 {
              if IsDefined(category.options[i]) {
                ArrayErase(category.options, i);
                i -= 1;
              } else {
                break;
              };
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(!ModuleExists("EnhancedDevices.Malfunctions.ConfessionBooth"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Starting Malfunctions: Confession Booths") {
          let i = 0;
          while i < settings.ConfessionBoothMalfunctionsSettingsCount() {
            if IsDefined(category.options[0]) {
              ArrayErase(category.options, 0);
              i += 1;
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(ModuleExists("EnhancedDevices.Malfunctions.TravelTerminal"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Starting Malfunctions: Travel Terminals") {
          if settings.travelTerminalMalfunctionRate == 0 {
            let i = settings.TravelTerminalMalfunctionsSettingsCount()-1; // returns 4-1 -> returns 3
            while i > 0 {
              if IsDefined(category.options[i]) {
                ArrayErase(category.options, i);
                i -= 1;
              } else {
                break;
              };
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(!ModuleExists("EnhancedDevices.Malfunctions.TravelTerminal"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Starting Malfunctions: Travel Terminals") {
          let i = 0;
          while i < settings.TravelTerminalMalfunctionsSettingsCount() {
            if IsDefined(category.options[0]) {
              ArrayErase(category.options, 0);
              i += 1;
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(ModuleExists("EnhancedDevices.Malfunctions.Jukebox"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Starting Malfunctions: Jukeboxes") {
          if settings.jukeboxMalfunctionRate == 0 {
            let i = settings.JukeboxMalfunctionsSettingsCount()-1; // returns 4-1 -> returns 3
            while i > 0 {
              if IsDefined(category.options[i]) {
                ArrayErase(category.options, i);
                i -= 1;
              } else {
                break;
              };
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// doesn't require anything else
@if(!ModuleExists("EnhancedDevices.Malfunctions.Jukebox"))
@wrapMethod(SettingsMainGameController)
protected func IsResetButtonEnabled() -> Bool {
  if !this.modReference.isEmpty {
    let mod = this.modReference;
    if !this.categoryReference.isEmpty {
      let category = this.categoryReference;

      if Equals(mod.label, n"Enhanced VM$") {
        let settings = new EVMMenuSettings();
        if Equals(category.label, n"Starting Malfunctions: Jukeboxes") {
          let i = 0;
          while i < settings.JukeboxMalfunctionsSettingsCount() {
            if IsDefined(category.options[0]) {
              ArrayErase(category.options, 0);
              i += 1;
            } else {
              break;
            };
          };
        };
      };

      ArrayClear(this.categoryReference.options);
      for option in category.options {
        ArrayPush(this.categoryReference.options, option);
      };
    };
  };
  return wrappedMethod();
}

// shared dependencies absolutely required