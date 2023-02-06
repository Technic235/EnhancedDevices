// // module EnhancedVendingMachines.ModuleConfig

@addField(ScriptableDeviceComponentPS) let moduleExistsAllMachinesOnHitEvent: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsTravelTerminalOnHit: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsVendingMachineHackedEffect: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsArcadeMachineHacking: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsDropPointHacking: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsFuelDispenserHacking: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsConfessionBoothHacking: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsTravelTerminalHacking: Bool = false;

@addField(ScriptableDeviceComponentPS) let moduleExistsVendingMachineMalfunctions: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsArcadeMachineMalfunctions: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsDropPointMalfunctions: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsConfessionBoothMalfunctions: Bool = false;
@addField(ScriptableDeviceComponentPS) let moduleExistsTravelTerminalMalfunctions: Bool = false;

@if(ModuleExists("AllMachinesOnHitEvent"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsAllMachinesOnHitEvent = true;
  wrappedMethod();
}

@if(ModuleExists("TravelTerminalOnHit"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsTravelTerminalOnHit = true;
  wrappedMethod();
}

@if(ModuleExists("VendingMachineHackedEffect"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsVendingMachineHackedEffect = true;
  wrappedMethod();
}

@if(ModuleExists("ArcadeMachineHacking"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsArcadeMachineHacking = true;
  wrappedMethod();
}

@if(ModuleExists("DropPointHacking"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsDropPointHacking = true;
  wrappedMethod();
}

@if(ModuleExists("FuelDispenserHacking"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsFuelDispenserHacking = true;
  wrappedMethod();
}

@if(ModuleExists("ConfessionBoothHacking"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsConfessionBoothHacking = true;
  wrappedMethod();
}

@if(ModuleExists("TravelTerminalHacking"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsTravelTerminalHacking = true;
  wrappedMethod();
}

@if(ModuleExists("VendingMachineMalfunctions"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsVendingMachineMalfunctions = true;
  wrappedMethod();
}

@if(ModuleExists("ArcadeMachineMalfunctions"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsArcadeMachineMalfunctions = true;
  wrappedMethod();
}

@if(ModuleExists("DropPointMalfunctions"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsDropPointMalfunctions = true;
  wrappedMethod();
}

@if(ModuleExists("ConfessionBoothMalfunctions"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsConfessionBoothMalfunctions = true;
  wrappedMethod();
}

@if(ModuleExists("TravelTerminalMalfunctions"))
@wrapMethod(ScriptableDeviceComponentPS)
protected cb func OnInstantiated() {
  this.moduleExistsTravelTerminalMalfunctions = true;
  wrappedMethod();
}