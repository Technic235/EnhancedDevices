module EnhancedDevices.Jukebox.RadioFix

// // Jukebox <- (skips BasicDistractionDevice) <- InteractiveDevice <- (skips) <- Device <-
// // JukeboxController <- (skips BasicDistractionDevice) <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// // JukeboxControllerPS <- (skips BasicDistractionDevice) <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

// // Radio <- (skips) <- InteractiveDevice <- (skips) <- Device <-
// // RadioController <- MediaDeviceController <- ScriptableDeviceComponent <- (skips) <- DeviceComponent <-
// // RadioControllerPS <- MediaDeviceController <- ScriptableDeviceComponentPS <- SharedGameplayPS <- DeviceComponentPS <-

// // from RadioControllerPS
@addField(JukeboxControllerPS) let m_stationsInitialized: Bool;

@addMethod(JukeboxControllerPS)
protected cb func OnInstantiated() { // from RadioControllerPS
	super.OnInstantiated();
	this.InitializeStations();
	this.m_isInteractive = true;
}

@wrapMethod(JukeboxControllerPS)
protected func InitializeStations() { // from RadioControllerPS
	if this.m_stationsInitialized { return; };
  wrappedMethod();
	this.m_stationsInitialized = true;
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
protected cb func OnNextStation(evt:ref<NextStation>) {
  wrappedMethod(evt);
  let devicePS = this.GetDevicePS();
  if !devicePS.m_isPlaying {
    devicePS.ExecutePSAction(devicePS.ActionPausePlay());
  };
}

@wrapMethod(Jukebox)
protected cb func OnPreviousStation(evt:ref<PreviousStation>) {
  wrappedMethod(evt);
  let devicePS = this.GetDevicePS();
  if !devicePS.m_isPlaying {
    devicePS.ExecutePSAction(devicePS.ActionPausePlay());
  };
}

@addMethod(JukeboxControllerPS)
protected func ActionPausePlay() -> ref<TogglePlay> {
	let action = new TogglePlay();
	action.SetUp(this);
	action.SetProperties(this.m_isPlaying);
	action.AddDeviceName(this.m_deviceName);
	action.CreateActionWidgetPackage();
	return action;
}

@addField(JukeboxControllerPS) let m_startingStation: Int32 = 0;

@addMethod(Jukebox)
public func ResavePersistentData(ps:ref<PersistentState>) -> Bool { // from Radio
		super.ResavePersistentData(ps);
    let devicePS = this.GetDevicePS();
		let mediaData: MediaResaveData;
		mediaData.m_mediaDeviceData.m_initialStation = devicePS.m_startingStation;
		mediaData.m_mediaDeviceData.m_amountOfStations = ArraySize(devicePS.m_stations);
		mediaData.m_mediaDeviceData.m_activeChannelName = devicePS.m_stations[devicePS.m_startingStation].channelName;
		mediaData.m_mediaDeviceData.m_isInteractive = devicePS.m_isInteractive;
		let radioData: RadioResaveData;
		radioData.m_mediaResaveData = mediaData;
		radioData.m_stations = devicePS.m_stations;
		let psDevice: ref<RadioControllerPS>;
		psDevice.PushResaveData(radioData);
		return true;
	}

// 	// default m_tweakDBDescriptionRecord = T"device_descriptions.Radio";
// // @addField(JukeboxControllerPS) let m_radioSetup: RadioSetup;
// // @addField(JukeboxControllerPS) let m_stations: array<RadioStationsMap>; // already defined on this class
// // ^ from RadioControllerPS ^

// // from MediaDeviceControllerPS
// // @addField(JukeboxControllerPS) let m_previousStation: Int32; // //
// @addField(JukeboxControllerPS) let m_activeChannelName: String;
// // @addField(JukeboxControllerPS) persistent let m_dataInitialized: Bool;
// @addField(JukeboxControllerPS) persistent let m_amountOfStations: Int32;
// // ^ from MediaDeviceControllerPS ^

// @wrapMethod(Jukebox)
// protected cb func OnRequestComponents(ri:EntityRequestComponentsInterface) { // from Radio
//   wrappedMethod(ri);
// 	EntityRequestComponentsInterface.RequestComponent(ri, n"audio", n"soundComponent", false);
// }

// @wrapMethod(JukeboxControllerPS)
// protected func GameAttached() { // from RadioControllerPS
//   wrappedMethod();
// 	this.InitializeRadioStations(); // this & below from RadioControllerPS
// 	this.m_amountOfStations = ArraySize(this.m_stations);
// 	this.m_activeChannelName = this.m_stations[this.m_activeStation].channelName;
// }

// @addMethod(JukeboxControllerPS)
// public const func GetStationByIndex(index:Int32) -> RadioStationsMap { // from RadioControllerPS
// 	let invalidStation: RadioStationsMap;
// 	if index < 0 || index >= ArraySize(this.m_stations) {
//     return invalidStation;
// 	};
// 	return this.m_stations[index];
// }

// @replaceMethod(Jukebox)
// protected func PlayGivenStation() { // from Radio
//   let devicePS = this.GetDevicePS();
// 	let stationIndex = devicePS.GetActiveStationIndex();
// 	let station = devicePS.GetStationByIndex(stationIndex);
// 	GameObject.AudioSwitch(this, n"radio_station", station.soundEvent, n"radio");
// 	let isMetal = Equals(station.soundEvent, n"radio_station_11_metal") ? true : false;
//   this.MetalItUp(isMetal);
// }

// @addMethod(Jukebox)
// private func MetalItUp(isMetal:Bool) { // from Radio
//   let devicePS = this.GetDevicePS();
// 	if !Equals(devicePS.GetDurabilityType(), EDeviceDurabilityType.INVULNERABLE) {
// 		if isMetal {
// 			devicePS.SetDurabilityType(EDeviceDurabilityType.INDESTRUCTIBLE);
// 		} else {
// 			devicePS.SetDurabilityType(EDeviceDurabilityType.DESTRUCTIBLE);
// 		};
// 	};
// }