module EnhancedDevices.Jukebox.RadioFix

// // Jukebox <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// // JukeboxController <- (skips BasicDistractionDevice) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// // JukeboxControllerPS <- (skips BasicDistractionDevice) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

// // Radio <- (skips) <- InteractiveDevice <- (skips) <- Device <-
// // RadioController <- MediaDeviceController <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// // RadioControllerPS <- MediaDeviceController <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

@wrapMethod(JukeboxControllerPS)
protected cb func OnInstantiated() { // defined on ScriptableDeviceComponentPS
  if this.IsA(n"JukeboxControllerPS") {
    this.m_isInitialized = false;
  };
}

// from RadioControllerPS
@addField(JukeboxControllerPS) let m_stationsInitialized: Bool;

@wrapMethod(JukeboxControllerPS)
protected func InitializeStations() { // defined on JukeboxControllerPS
  if !this.m_stationsInitialized {
    wrappedMethod();
    this.m_stationsInitialized = true;
  };
}

@wrapMethod(JukeboxControllerPS)
protected func GameAttached() { // defined on JukeboxControllerPS
  wrappedMethod();
  this.m_activeStation = RandRange(0, ArraySize(this.m_stations));
}

// @addMethod(JukeboxControllerPS)
// protected func InitializeRadioStations() { // from RadioControllerPS
// 		if this.m_stationsInitialized { return; };
//     ArrayPush(this.m_stations, this.CreateRadioStation(n"radio_station_02_aggro_ind", "Gameplay-Devices-Radio-RadioStationAggroIndie", ERadioStationList.AGGRO_INDUSTRIAL));
//     ArrayPush(this.m_stations, this.CreateRadioStation(n"radio_station_03_elec_ind", "Gameplay-Devices-Radio-RadioStationElectroIndie", ERadioStationList.ELECTRO_INDUSTRIAL));
//     ArrayPush(this.m_stations, this.CreateRadioStation(n"radio_station_04_hiphop", "Gameplay-Devices-Radio-RadioStationHipHop", ERadioStationList.HIP_HOP));
//     ArrayPush(this.m_stations, this.CreateRadioStation(n"radio_station_07_aggro_techno", "Gameplay-Devices-Radio-RadioStationAggroTechno", ERadioStationList.AGGRO_TECHNO));
//     ArrayPush(this.m_stations, this.CreateRadioStation(n"radio_station_09_downtempo", "Gameplay-Devices-Radio-RadioStationDownTempo", ERadioStationList.DOWNTEMPO));
//     ArrayPush(this.m_stations, this.CreateRadioStation(n"radio_station_01_att_rock", "Gameplay-Devices-Radio-RadioStationAttRock", ERadioStationList.ATTITUDE_ROCK));
//     ArrayPush(this.m_stations, this.CreateRadioStation(n"radio_station_05_pop", "Gameplay-Devices-Radio-RadioStationPop", ERadioStationList.POP));
//     ArrayPush(this.m_stations, this.CreateRadioStation(n"radio_station_10_latino", "Gameplay-Devices-Radio-RadioStationLatino", ERadioStationList.LATINO));
//     ArrayPush(this.m_stations, this.CreateRadioStation(n"radio_station_11_metal", "Gameplay-Devices-Radio-RadioStationMetal", ERadioStationList.METAL));
// 		this.m_stationsInitialized = true;
// 	}

// @addMethod(JukeboxControllerPS)
// protected func CreateRadioStation(SoundEvt:CName, ChannelName:String, stationID:ERadioStationList) -> RadioStationsMap { // from RadioControllerPS
// 	return new RadioStationsMap(SoundEvt, ChannelName, stationID);
// }

@wrapMethod(Jukebox)
protected cb func OnNextStation(evt:ref<NextStation>) { // defined on Jukebox (& JukeboxControllerPS)
  wrappedMethod(evt);
  let devicePS = this.GetDevicePS();
  if !devicePS.m_isPlaying {
    devicePS.ExecutePSAction(devicePS.ActionPausePlay());
  };
}

@wrapMethod(Jukebox)
protected cb func OnPreviousStation(evt:ref<PreviousStation>) { // defined on Jukebox (& JukeboxControllerPS)
  wrappedMethod(evt);
  let devicePS = this.GetDevicePS();
  if !devicePS.m_isPlaying {
    devicePS.ExecutePSAction(devicePS.ActionPausePlay());
  };
}

@addMethod(JukeboxControllerPS)
protected func ActionPausePlay() -> ref<TogglePlay> { // custom function
  let action = new TogglePlay();
  action.SetUp(this);
  action.SetProperties(this.m_isPlaying);
  action.AddDeviceName(this.m_deviceName);
  action.CreateActionWidgetPackage();
  return action;
}