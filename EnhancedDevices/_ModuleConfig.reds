module EnhancedDevices.ModuleConfig

@addField(ScriptableDeviceComponentPS) let moduleExistsOnHitVendingMachine: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsOnHitArcadeMachine: Bool = false;
// @addField(ScriptableDeviceComponentPS) let moduleExistsOnHitTravelTerminal: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsOnHitJukebox: Bool = false;

@addField(ScriptableDeviceComponentPS) let moduleExistsHackingVendingMachine: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsHackingArcadeMachine: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsHackingDropPoint: Bool = false;
// @addField(ScriptableDeviceComponentPS) let moduleExistsHackingFuelDispenser: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsHackingConfessionBooth: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsHackingTravelTerminal: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsHackingJukebox: Bool = false;

@addField(ScriptableDeviceComponentPS) let moduleExistsMalfunctionsVendingMachine: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsMalfunctionsArcadeMachine: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsMalfunctionsDropPoint: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsMalfunctionsConfessionBooth: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsMalfunctionsTravelTerminal: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsMalfunctionsJukebox: Bool = false;

@if(ModuleExists("EnhancedDevices.OnHit.VendingMachine"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsOnHitVendingMachine = true;
  wrappedMethod();
}

@if(ModuleExists("EnhancedDevices.OnHit.ArcadeMachine"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsOnHitArcadeMachine = true;
  wrappedMethod();
}

// @if(ModuleExists("EnhancedDevices.OnHit.TravelTerminal"))
// @wrapMethod(ScriptableDeviceComponentPS)
// protected cb func OnInstantiated() {
//   this.moduleExistsOnHitTravelTerminal = true;
//   wrappedMethod();
// }

@if(ModuleExists("EnhancedDevices.OnHit.Jukebox"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsOnHitJukebox = true;
  wrappedMethod();
}

@if(ModuleExists("EnhancedDevices.Hacking.VendingMachine"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsHackingVendingMachine = true;
  wrappedMethod();
}

@if(ModuleExists("EnhancedDevices.Hacking.ArcadeMachine"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsHackingArcadeMachine = true;
  wrappedMethod();
}

@if(ModuleExists("EnhancedDevices.Hacking.DropPoint"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsHackingDropPoint = true;
  wrappedMethod();
}

// @if(ModuleExists("EnhancedDevices.Hacking.FuelDispenser"))
// @wrapMethod(ScriptableDeviceComponentPS)
// protected cb func OnInstantiated() {
//   this.moduleExistsHackingFuelDispenser = true;
//   wrappedMethod();
// }

@if(ModuleExists("EnhancedDevices.Hacking.ConfessionBooth"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsHackingConfessionBooth = true;
  wrappedMethod();
}

@if(ModuleExists("EnhancedDevices.Hacking.TravelTerminal"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsHackingTravelTerminal = true;
  wrappedMethod();
}

@if(ModuleExists("EnhancedDevices.Hacking.Jukebox"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsHackingJukebox = true;
  wrappedMethod();
}


@if(ModuleExists("EnhancedDevices.Malfunctions.VendingMachine"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsMalfunctionsVendingMachine = true;
  wrappedMethod();
}

@if(ModuleExists("EnhancedDevices.Malfunctions.ArcadeMachine"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsMalfunctionsArcadeMachine = true;
  wrappedMethod();
}

@if(ModuleExists("EnhancedDevices.Malfunctions.DropPoint"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsMalfunctionsDropPoint = true;
  wrappedMethod();
}

@if(ModuleExists("EnhancedDevices.Malfunctions.ConfessionBooth"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsMalfunctionsConfessionBooth = true;
  wrappedMethod();
}

@if(ModuleExists("EnhancedDevices.Malfunctions.TravelTerminal"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsMalfunctionsTravelTerminal = true;
  wrappedMethod();
}

@if(ModuleExists("EnhancedDevices.Malfunctions.Jukebox"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsMalfunctionsJukebox = true;
  wrappedMethod();
}