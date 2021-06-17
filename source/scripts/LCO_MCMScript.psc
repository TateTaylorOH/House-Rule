scriptname LCO_MCMScript extends SKI_ConfigBase

GlobalVariable Property LCO_IsActive Auto
Keyword Property LCO_MCMSetup Auto
Quest Property LCO_MCMRegisterQuest Auto
Quest Property LocationChangeOwnershipQuest Auto
LocationRefType Property LCO_Controller Auto
String[] Property LCO_Factions Auto
FormList Property HoldLocations Auto
Keyword Property LocTypeHold Auto
bool locationsInitted

GlobalVariable currentRTDelay
GlobalVariable currentGTDelay

;LCO Properties
Keyword Property LocationChangeOwnership Auto
Keyword Property LocationCurrentOwnership Auto
Keyword Property LocationDefaultOwnership Auto
GlobalVariable Property LCO_RTUpdateDelay Auto
GlobalVariable Property LCO_GTUpdateDelay Auto
float def_RTUpdateDelay = 300.0
float def_GTUpdateDelay = 24.0
string info_RTUpdateDelay
string info_GTUpdateDelay
string format_RTUpdate = "{0} seconds"
string format_GTUpdate =  "{2} hours"
string name_RTUpdateDelay = "Real Time Update Delay"
string name_GTUpdateDelay = "Game Time Update Delay"
; simple locations properties
string LCOPath = "Data/MLQ/LCO/"
int SupportedLocationsList
Location Property EastmarchHoldLocation Auto
Location Property FalkreathHoldLocation Auto
Location Property HaafingarHoldLocation Auto
Location Property HjaalmarchHoldLocation Auto
Location Property PaleHoldLocation Auto
Location Property ReachHoldLocation Auto
Location Property RiftHoldLocation Auto
Location Property WhiterunHoldLocation Auto
Location Property WinterholdHoldLocation Auto
string[] detectedHolds
string[] detectedStates
string[] EastmarchLocations
string[] FalkreathLocations
string[] HaafingarLocations
string[] HjaalmarchLocations
string[] PaleLocations
string[] ReachLocations
string[] RiftLocations
string[] WhiterunLocations
string[] WinterholdLocations
string displayedHold
Location selectedLocation
int[] menuOwners
string[] menuOwnerNames

;Tactical Valtheim Properties
bool ValtheimRegistered
Location Property Valtheim Auto
GlobalVariable Property TacValt_RTDelay Auto Hidden
GlobalVariable Property TacValt_GTDelay Auto Hidden
GlobalVariable Property TacValt_ShieldBlockLevel Auto Hidden
GlobalVariable Property TacValt_ShieldFireLevel Auto Hidden
GlobalVariable Property TacValt_ShieldFrostLevel Auto Hidden
GlobalVariable Property TacValt_ShieldShockLevel Auto Hidden
string info_TacValt_ShieldBlockLevel
string info_TacValt_ShieldFireLevel
string info_TacValt_ShieldFrostLevel
string info_TacValt_ShieldShockLevel
int blockMax = 5
int resMax = 4

;Halted Stream Mine Properties
bool HSMRegistered
Location Property HaltedStreamCamp Auto Hidden
GlobalVariable Property HSM_RTDelay Auto Hidden
GlobalVariable Property HSM_GTDelay Auto Hidden
GlobalVariable Property HSM_Controller Auto Hidden
GlobalVariable Property HSM_MerchantUpdateRate Auto Hidden
HSMQuestScript Property HSM_MerchantInventoryQuest Auto Hidden

;Serenity Properties
bool SMCRegistered
Location Property SilentMoonsCamp Auto
String[] Property MoonPhases Auto
String[] Property LunarForgeStates Auto
GlobalVariable Property SMC_RTDelay Auto Hidden
GlobalVariable Property SMC_GTDelay Auto Hidden
GlobalVariable Property SMC_Moonrise Auto Hidden
GlobalVariable Property SMC_Moonset Auto Hidden
GlobalVariable Property SMC_MoonPhase Auto Hidden
GlobalVariable Property SMC_CurrentLunarForgeState Auto Hidden
float def_SMC_Moonrise = 21.0
float def_SMC_Moonset = 5.0
string info_SMC_Moonrise
string info_SMC_Moonset
string info_SMC_MoonPhase
string info_SMC_CurrentLunarForgeState

int function getVersion()
	return 2
endFunction
Event OnVersionUpdate(int newVersion)
	;currentVersion variable inherited from SKI_ConfigBase has old version
	initLocations()
	currentVersion = getVersion()
endEvent

Event OnConfigInit()
	currentVersion = getVersion()
	LCO_IsActive.setValue(1.0)
	Pages = new String[5]
	Pages[0] = "Settings"
	;Pages[1] = "Tactical Valtheim"
	;Pages[2] = "Halted Stream Mine"
	;Pages[3] = "Serenity"
	;Pages[4] = "Simple Locations"
	registerForSingleUpdate(3.0)
endEvent
Event OnUpdate()
	initLocations()
endEvent

Event OnPageReset(String pageName)
	if(pageName != "Simple Locations")
		displayedHold = ""
	endIf
	if(pageName == "Settings")
		SetCursorFillMode(TOP_TO_BOTTOM)
		AddSliderOptionST("RTUpdateDelay", name_RTUpdateDelay, LCO_RTUpdateDelay.getValue(), format_RTUpdate)
		AddSliderOptionST("GTUpdateDelay", name_GTUpdateDelay, LCO_GTUpdateDelay.getValue(), format_GTUpdate)
		currentRTDelay = LCO_RTUpdateDelay
		currentGTDelay = LCO_GTUpdateDelay
		SetCursorPosition(1)
		AddToggleOptionST("TacValt_Register", "Register Tactical Valtheim", ValtheimRegistered)
		AddToggleOptionST("HSM_Register", "Register Halted Stream Mine", HSMRegistered)
		AddToggleOptionST("SMC_Register", "Register Serenity", SMCRegistered)
		if(checkJContainers())
			AddTextOptionST("jRegister", "Register Simple Locations", "")
		endIf
	elseif(pageName == "Tactical Valtheim")
		SetCursorFillMode(TOP_TO_BOTTOM)
		int valtOwner = Valtheim.getKeywordData(LocationCurrentOwnership) as int
		AddMenuOptionST("TacValt_Controller", "Owners", getOwnerName(Valtheim), OPTION_FLAG_DISABLED)
		AddSliderOptionST("RTUpdateDelay", name_RTUpdateDelay, TacValt_RTDelay.getValue(), format_RTUpdate)
		AddSliderOptionST("GTUpdateDelay", name_GTUpdateDelay, TacValt_GTDelay.getValue(), format_GTUpdate)
		currentRTDelay = TacValt_RTDelay
		currentGTDelay = TacValt_GTDelay
		AddHeaderOption("Shield of Valtheim Levels")
		AddSliderOptionST("TacValt_BlockLevelState", TacValtShieldString("Fortify Block", TacValt_ShieldBlockLevel), TacValtShieldProgress(TacValt_ShieldBlockLevel), "{0}%", OPTION_FLAG_DISABLED)
		AddSliderOptionST("TacValt_FireLevelState", TacValtShieldString("Resist Fire", TacValt_ShieldFireLevel), TacValtShieldProgress(TacValt_ShieldFireLevel), "{0}%", OPTION_FLAG_DISABLED)
		AddSliderOptionST("TacValt_FrostLevelState", TacValtShieldString("Resist Frost", TacValt_ShieldFrostLevel), TacValtShieldProgress(TacValt_ShieldFrostLevel), "{0}%", OPTION_FLAG_DISABLED)
		AddSliderOptionST("TacValt_ShockLevelState", TacValtShieldString("Resist Shock", TacValt_ShieldShockLevel), TacValtShieldProgress(TacValt_ShieldShockLevel), "{0}%", OPTION_FLAG_DISABLED)
	elseif(pageName == "Halted Stream Mine")
		SetCursorFillMode(TOP_TO_BOTTOM)
		int hsmOwner = HaltedStreamCamp.getKeywordData(LocationCurrentOwnership) as int
		string ownerName
		if(hsmOwner != 1)
			ownerName = getOwnerName(HaltedStreamCamp)
		elseif (HSM_Controller.getValue() == 3.0)
			ownerName = "House Gray-Mane"
		else
			ownerName = "House Battle-Born"
		endIf
		AddMenuOptionST("HSM_Controller", "Owners", ownerName, OPTION_FLAG_DISABLED)
		AddSliderOptionST("RTUpdateDelay", name_RTUpdateDelay, HSM_RTDelay.getValue(), format_RTUpdate)
		AddSliderOptionST("GTUpdateDelay", name_GTUpdateDelay, HSM_GTDelay.getValue(), format_GTUpdate)
		currentRTDelay = HSM_RTDelay
		currentGTDelay = HSM_GTDelay
		AddHeaderOption("Halted Stream Mining Options")
		AddSliderOptionST("HSM_FjoriBoost", "Fjori's Bonus", HSM_MerchantInventoryQuest.FjoriScaler * 100.0, "{0}%", OPTION_FLAG_DISABLED)
		AddSliderOptionST("HSM_PrivateGold", "Extra Gold - Great House", HSM_MerchantInventoryQuest.privateGold, "{0}", OPTION_FLAG_DISABLED)
		AddSliderOptionST("HSM_WhiterunGold", "Extra Gold - Whiterun", HSM_MerchantInventoryQuest.whiterunGold, "{0}", OPTION_FLAG_DISABLED)
		AddSliderOptionST("HSM_GoldStdDev", "Gold Standard Dev.", HSM_MerchantInventoryQuest.goldStdDev, "{0}", OPTION_FLAG_DISABLED)
		AddSliderOptionST("HSM_GoldMax", "Gold Max", HSM_MerchantInventoryQuest.goldMax, "{0}", OPTION_FLAG_DISABLED)
		SetCursorPosition(9)
		AddSliderOptionST("HSM_OreMean", "Average Iron Ore", HSM_MerchantInventoryQuest.oreMean, "{0}", OPTION_FLAG_DISABLED)
		AddSliderOptionST("HSM_OreStdDev", "Ore Standard Dev.", HSM_MerchantInventoryQuest.oreStdDev, "{0}", OPTION_FLAG_DISABLED)
		AddSliderOptionST("HSM_OreMax", "Ore Max", HSM_MerchantInventoryQuest.oreMax, "{0}", OPTION_FLAG_DISABLED)
	elseif(pageName == "Serenity")
		SetCursorFillMode(TOP_TO_BOTTOM)
		int smcOwner = SilentMoonsCamp.getKeywordData(LocationCurrentOwnership) as int
		AddMenuOptionST("SMC_Controller", "Owners", getOwnerName(SilentMoonsCamp), OPTION_FLAG_DISABLED)
		AddSliderOptionST("RTUpdateDelay", name_RTUpdateDelay, SMC_RTDelay.getValue(), format_RTUpdate)
		AddSliderOptionST("GTUpdateDelay", name_GTUpdateDelay, SMC_GTDelay.getValue(), format_GTUpdate)
		AddHeaderOption("The Moon")
		int phase = SMC_MoonPhase.getValue() as int
		AddMenuOptionST("SMC_MoonPhaseState", "Current Phase", MoonPhases[phase])
		AddSliderOptionST("SMC_MoonriseState", "Moonrise", (SMC_Moonrise.getValue() as int % 12) as float, getTimeFormatString(SMC_Moonrise))
		AddSliderOptionST("SMC_MoonsetState", "Moonset", (SMC_Moonset.getValue() as int % 12) as float, getTimeFormatString(SMC_Moonset))
		int lforge = SMC_CurrentLunarForgeState.getValue() as int
		AddMenuOptionST("SMC_LunarForgeState", "Lunar Forge", LunarForgeStates[lforge], OPTION_FLAG_DISABLED)
	elseif(pageName == "Simple Locations")
		SetCursorFillMode(TOP_TO_BOTTOM)
		int i = 0
		while i < detectedHolds.length
			;locEastmarch
			;locFalkreath
			;locHaafingar
			;locHjaalmarch
			;locPale
			;locReach
			;locRift
			;locWhiterun
			;locWinterhold
			AddTextOptionST(detectedStates[i], detectedHolds[i], "")
			i += 1
		endWhile
		if(displayedHold != "")
			i = 0
			string[] displayedLocs
			if(displayedHold == "locEastmarch")
				displayedLocs = EastmarchLocations
			elseif(displayedHold == "locFalkreath")
				displayedLocs = FalkreathLocations
			elseif(displayedHold == "locHaafingar")
				displayedLocs = HaafingarLocations
			elseif(displayedHold == "locHjaalmarch")
				displayedLocs = HjaalmarchLocations
			elseif(displayedHold == "locPale")
				displayedLocs = PaleLocations
			elseif(displayedHold == "locReach")
				displayedLocs = ReachLocations
			elseif(displayedHold == "locRift")
				displayedLocs = RiftLocations
			elseif(displayedHold == "locWhiterun")
				displayedLocs = WhiterunLocations
			elseif(displayedHold == "locWinterhold")
				displayedLocs = WinterholdLocations
			endIf
			setCursorPosition(1)
			while i < displayedLocs.length
				string jKey = displayedLocs[i]
				string jPath = "." + jKey + "."
				string displayName = JValue.solveStr(SupportedLocationsList, jPath + "displayName")
				Location loc = JValue.solveForm(SupportedLocationsList, jPath + "locationForm") as Location
				AddMenuOptionST(jKey, displayName, getOwnerName(loc))
				i += 1
			endWhile
		endIf
	endIf
endEvent

; utility functions
function initLocations()
	if(locationsInitted)
		return
	endIf
	locationsInitted = true
	Utility.wait(3.0) ; to make sure the radiant system triggers after script fuckery
	; specific mods
	bool valtheimDetected = Valtheim.hasRefType(LCO_Controller)
	if(valtheimDetected)
		LCO_MCMSetup.SendStoryEvent(Valtheim)
		while(!ValtheimRegistered)
			Utility.wait(1.0)
		endWhile
	endIf
	bool hsmDetected = HaltedStreamCamp.hasRefType(LCO_Controller)
	if(hsmDetected)
		LCO_MCMSetup.SendStoryEvent(HaltedStreamCamp)
		while(!HSMRegistered)
			Utility.wait(1.0)
		endWhile
	endIf
	bool smcDetected = SilentMoonsCamp.hasRefType(LCO_Controller)
	if(SilentMoonsCamp.hasRefType(LCO_Controller))
		LCO_MCMSetup.SendStoryEvent(SilentMoonsCamp)
		while(!SMCRegistered)
			Utility.wait(1.0)
		endWhile
	endIf
	; simple locations
	if(checkJContainers())
		RegisterSimpleLocations(true)
	endIf
endFunction
function RegisterTacticalValtheim(GlobalVariable RTDelay, GlobalVariable GTDelay, GlobalVariable ShieldBlockLevel, GlobalVariable ShieldFireLevel, GlobalVariable ShieldFrostLevel, GlobalVariable ShieldShockLevel)
	ValtheimRegistered = true
	Pages[1] = "Tactical Valtheim"
	TacValt_RTDelay = RTDelay
	TacValt_GTDelay = GTDelay
	TacValt_ShieldBlockLevel = ShieldBlockLevel
	TacValt_ShieldFireLevel = ShieldFireLevel
	TacValt_ShieldFrostLevel = ShieldFrostLevel
	TacValt_ShieldShockLevel = ShieldShockLevel
	Debug.notification("LCO: Tactical Valtheim registered.")
endFunction
function RegisterHaltedStreamMine(GlobalVariable RTDelay, GlobalVariable GTDelay, GlobalVariable Controller, GlobalVariable MerchantUpdateRate, Quest HSMQuest)
	HSMRegistered = true
	Pages[2] = "Halted Stream Mine"
	HSM_RTDelay = RTDelay
	HSM_GTDelay = GTDelay
	HSM_Controller = Controller
	HSM_MerchantUpdateRate = MerchantUpdateRate
	HSM_MerchantInventoryQuest = HSMQuest as HSMQuestScript
	Debug.notification("LCO: Halted Stream Mine registered.")
endFunction
function RegisterSerenity(GlobalVariable RTDelay, GlobalVariable GTDelay, GlobalVariable Moonrise, GlobalVariable Moonset, GlobalVariable MoonPhase, GlobalVariable CurrentLunarForgeState)
	SMCRegistered = true
	Pages[3] = "Serenity"
	SMC_RTDelay = RTDelay
	SMC_GTDelay = GTDelay
	SMC_Moonrise = Moonrise
	SMC_Moonset = Moonset
	SMC_MoonPhase = MoonPhase
	SMC_CurrentLunarForgeState = CurrentLunarForgeState
	Debug.notification("LCO: Serenity registered.")
endFunction
function RegisterSimpleLocations(bool firstTime = false)
	if(!firstTime)
		SupportedLocationsList = JValue.release(SupportedLocationsList)
	endIf
	SupportedLocationsList = JValue.retain(JValue.readFromFile(LCOPath + "LocationList.json"))
	int SLLkeys = JMap.getObj(SupportedLocationsList, "sortedKeysList")
	int maxKeys = JValue.count(SLLkeys)
	int i = 0
	int jEastmarchLocations = JArray.object()
	int jFalkreathLocations = JArray.object()
	int jHaafingarLocations = JArray.object()
	int jHjaalmarchLocations = JArray.object()
	int jPaleLocations = JArray.object()
	int jReachLocations = JArray.object()
	int jRiftLocations = JArray.object()
	int jWhiterunLocations = JArray.object()
	int jWinterholdLocations = JArray.object()
	; first, check which locations are present
	while i < maxKeys
		string jKey = JArray.getStr(SLLkeys, i)
		string jPath = "." + jKey + ".locationForm"
		Form f = JValue.solveForm(SupportedLocationsList, jPath)
		if (f as Location && (f as Location).hasRefType(LCO_Controller))
			jPath = "." + jKey + ".parentHold"
			Location parentHold = JValue.solveForm(SupportedLocationsList, jPath) as Location
			if(parentHold == EastmarchHoldLocation) ;I'd like to imagine there's a worldline where we got switch statements
				JArray.addStr(jEastmarchLocations, jKey) ;but that seems a little too optimistic
			elseif(parentHold == FalkreathHoldLocation)
				JArray.addStr(jFalkreathLocations, jKey)
			elseif(parentHold == HaafingarHoldLocation)
				JArray.addStr(jHaafingarLocations, jKey)
			elseif(parentHold == HjaalmarchHoldLocation)
				JArray.addStr(jHjaalmarchLocations, jKey)
			elseif(parentHold == PaleHoldLocation)
				JArray.addStr(jPaleLocations, jKey)
			elseif(parentHold == ReachHoldLocation)
				JArray.addStr(jReachLocations, jKey)
			elseif(parentHold == RiftHoldLocation)
				JArray.addStr(jRiftLocations, jKey)
			elseif(parentHold == WhiterunHoldLocation)
				JArray.addStr(jWhiterunLocations, jKey)
			elseif(parentHold == WinterholdHoldLocation)
				JArray.addStr(jWinterholdLocations, jKey)
			endIf
		endIf
		i += 1
	endWhile
	; next, check which holds have locations we need to track
	bool bEastmarch = JValue.count(jEastmarchLocations) > 0
	bool bFalkreath = JValue.count(jFalkreathLocations) > 0
	bool bHaafingar = JValue.count(jHaafingarLocations) > 0
	bool bHjaalmarch = JValue.count(jHjaalmarchLocations) > 0
	bool bPale = JValue.count(jPaleLocations) > 0
	bool bReach = JValue.count(jReachLocations) > 0
	bool bRift = JValue.count(jRiftLocations) > 0
	bool bWhiterun = JValue.count(jWhiterunLocations) > 0
	bool bWinterhold = JValue.count(jWinterholdLocations) > 0
	int NonzeroHolds = (bEastmarch as int) + (bFalkreath as int) + (bHaafingar as int) + (bHjaalmarch as int) + (bPale as int) + (bReach as int) + (bRift as int) + (bWhiterun as int) + (bWinterhold as int)
	detectedHolds = Utility.createStringArray(NonzeroHolds)
	detectedStates = Utility.createStringArray(NonzeroHolds)
	i = 0
	if(bEastmarch)
		detectedHolds[i] = "Eastmarch"
		detectedStates[i] = "locEastmarch"
		i += 1
		EastmarchLocations = Utility.createStringArray(JValue.count(jEastmarchLocations))
		JArray.writeToStringPArray(jEastmarchLocations, EastmarchLocations)
	EndIf
	if(bFalkreath)
		detectedHolds[i] = "Falkreath"
		detectedStates[i] = "locFalkreath"
		i += 1
		FalkreathLocations = Utility.createStringArray(JValue.count(jFalkreathLocations))
		JArray.writeToStringPArray(jFalkreathLocations, FalkreathLocations)
	EndIf
	if(bHaafingar)
		detectedHolds[i] = "Haafingar"
		detectedStates[i] = "locHaafingar"
		i += 1
		HaafingarLocations = Utility.createStringArray(JValue.count(jHaafingarLocations))
		JArray.writeToStringPArray(jHaafingarLocations, HaafingarLocations)
	EndIf
	if(bHjaalmarch)
		detectedHolds[i] = "Hjaalmarch"
		detectedStates[i] = "locHjaalmarch"
		i += 1
		HjaalmarchLocations = Utility.createStringArray(JValue.count(jHjaalmarchLocations))
		JArray.writeToStringPArray(jHjaalmarchLocations, HjaalmarchLocations)
	EndIf
	if(bPale)
		detectedHolds[i] = "The Pale"
		detectedStates[i] = "locPale"
		i += 1
		PaleLocations = Utility.createStringArray(JValue.count(jPaleLocations))
		JArray.writeToStringPArray(jPaleLocations, PaleLocations)
	EndIf
	if(bReach)
		detectedHolds[i] = "The Reach"
		detectedStates[i] = "locReach"
		i += 1
		ReachLocations = Utility.createStringArray(JValue.count(jReachLocations))
		JArray.writeToStringPArray(jReachLocations, ReachLocations)
	EndIf
	if(bRift)
		detectedHolds[i] = "The Rift"
		detectedStates[i] = "locRift"
		i += 1
		RiftLocations = Utility.createStringArray(JValue.count(jRiftLocations))
		JArray.writeToStringPArray(jRiftLocations, RiftLocations)
	EndIf
	if(bWhiterun)
		detectedHolds[i] = "Whiterun"
		detectedStates[i] = "locWhiterun"
		i += 1
		WhiterunLocations = Utility.createStringArray(JValue.count(jWhiterunLocations))
		JArray.writeToStringPArray(jWhiterunLocations, WhiterunLocations)
	EndIf
	if(bWinterhold)
		detectedHolds[i] = "Winterhold"
		detectedStates[i] = "locWinterhold"
		i += 1
		WinterholdLocations = Utility.createStringArray(JValue.count(jWinterholdLocations))
		JArray.writeToStringPArray(jWinterholdLocations, WinterholdLocations)
	EndIf
	if(i > 0)
		Pages[4] = "Simple Locations"
	endIf
	JValue.release(SLLkeys)
	JValue.release(jEastmarchLocations)
	jValue.release(jFalkreathLocations)
	jValue.release(jHaafingarLocations)
	jValue.release(jHjaalmarchLocations)
	jValue.release(jPaleLocations)
	jValue.release(jReachLocations)
	jValue.release(jRiftLocations)
	jValue.release(jWhiterunLocations)
	jValue.release(jWinterholdLocations)
	Debug.notification("LCO: Simple locations registered.")
endFunction
bool function checkJContainers()
	return JContainers.APIVersion() >= 3
endFunction
string function prettify(float f)
	string s = f as string
	int pointIndex = StringUtil.find(s, ".", 0)
	int i = StringUtil.getLength(s)
	while (i > pointIndex + 1 && StringUtil.getNthChar(s, i - 1) == "0")
		i -= 1
	endWhile
	return StringUtil.substring(s, 0, i + 1)
endFunction
function SetSliderDialogValues(float startValue, float defaultValue, float minValue, float maxValue, float interval)
	SetSliderDialogStartValue(startValue)
	SetSliderDialogDefaultValue(defaultValue)
	SetSliderDialogRange(minValue, maxValue)
	SetSliderDialogInterval(interval)
endFunction
function updateSliderOption(float value, GlobalVariable setting, string formatString = "{0}", bool noUpdate = false, string stateName = "")
	setting.setValue(value)
	SetSliderOptionValueST(value, formatString, noUpdate, stateName)
endFunction
string function getOwnerName(Location loc, int i = -1)
	if(i == -1)
		i = loc.getKeywordData(LocationCurrentOwnership) as int
	endIf
	if(i == 2)
		int j = HoldLocations.getSize()
		while j > 0
			j -= 1
			Location Hold = HoldLocations.getAt(j) as Location
			if(Hold.isSameLocation(loc, LocTypeHold))
				return Hold.getName()
			endIf
		endWhile
	endIf
	return LCO_Factions[i]
endFunction
string function TacValtShieldString(string enchName, GlobalVariable effectMag)
	int level = effectMag.getValue() as int
	if(level == resMax || (level == blockMax && effectMag == TacValt_ShieldBlockLevel))
		return enchName + " (Level MAX)"
	else
		return enchName + " (Level " + level + ")"
	endIf
endFunction
int function TacValtShieldProgress(GlobalVariable effectMag)
	float fmag = effectMag.getValue()
	int imag = fmag as int
	if(imag == resMax || (imag == blockMax && effectMag == TacValt_ShieldBlockLevel))
		return 100
	else
		fmag -= imag as float
		fmag *= 100.0
		imag = fmag as int
		return imag
	endIf
endFunction
string function getTimeFormatString(GlobalVariable time)
	float ftime = time.getValue()
	string stime = "AM"
	if(ftime >= 13.0)
		stime = "PM"
	endIf
	int itime = (ftime * 100.0) as int
	itime %= 100
	return "{0}:" + itime + " " + stime
endFunction

;main settings page
state RTUpdateDelay
	Event OnHighlightST()
		setInfoText(info_RTUpdateDelay)
	endEvent
	Event OnDefaultST()
		updateSliderOption(def_RTUpdateDelay, currentRTDelay, format_RTUpdate)
	endEvent
	Event OnSliderOpenST()
		SetSliderDialogValues(currentRTDelay.getValue(), def_RTUpdateDelay, 1.0, 600.0, 1.0)
	endEvent
	Event OnSliderAcceptST(float value)
		updateSliderOption(value, currentRTDelay, format_RTUpdate)
	endEvent
endState
state GTUpdateDelay
	Event OnHighlightST()
		setInfoText(info_GTUpdateDelay)
	endEvent
	Event OnDefaultST()
		updateSliderOption(def_GTUpdateDelay, currentGTDelay, format_GTUpdate)
	endEvent
	Event OnSliderOpenST()
		SetSliderDialogValues(currentGTDelay.getValue(), def_GTUpdateDelay, 0.25, 72.0, 0.25)
	endEvent
	Event OnSliderAcceptST(float value)
		updateSliderOption(value, currentGTDelay, format_GTUpdate)
	endEvent
endState
state TacValt_Register
	Event OnHighlightST()
		setInfoText("If you have installed Tactical Valtheim, you can access its settings through this MCM once the menu has registered it.")
	endEvent
	Event OnSelectST()
		if(!ValtheimRegistered)
			LCO_MCMSetup.SendStoryEvent(Valtheim)
			ShowMessage("Close the menu to register this location.", false)
		endIf
	endEvent
endState
state HSM_Register
	Event OnHighlightST()
		setInfoText("If you have installed Halted Stream Mine, you can access its settings through this MCM once the menu has registered it.")
	endEvent
	Event OnSelectST()
		if(!HSMRegistered)
			LCO_MCMSetup.SendStoryEvent(HaltedStreamCamp)
			ShowMessage("Close the menu to register this location.", false)
		endIf
	endEvent
endState
state SMC_Register
	Event OnHighlightST()
		setInfoText("If you have installed Serenity, you can access its settings through this MCM once the menu has registered it.")
	endEvent
	Event OnSelectST()
		if(!SMCRegistered)
			LCO_MCMSetup.SendStoryEvent(SilentMoonsCamp)
			ShowMessage("Close the menu to register this location.", false)
		endIf
	endEvent
endState
state jRegister
	Event OnHighlightST()
		setInfoText("If you have installed a location and it does not appear here, you can press this button to check all locations again.")
	endEvent
	Event OnSelectST()
		RegisterSimpleLocations()
	endEvent
endState
;Simple Locations options
state locEastmarch
	Event OnHighlightST()
		setInfoText("Eastmarch is the central eastern part of Skyrim, surrounding Windhelm.")
	endEvent
	Event OnSelectST()
		displayedHold = getState()
		ForcePageReset()
	endEvent
endState
state locFalkreath
	Event OnHighlightST()
		setInfoText("Falkreath is a temperate, densely forested region in the central south of Skyrim.")
	endEvent
	Event OnSelectST()
		displayedHold = getState()
		ForcePageReset()
	endEvent
endState
state locHaafingar
	Event OnHighlightST()
		setInfoText("Haafingar is the northwest reaches of Skyrim, surrounding Solitude.")
	endEvent
	Event OnSelectST()
		displayedHold = getState()
		ForcePageReset()
	endEvent
endState
state locHjaalmarch
	Event OnHighlightST()
		setInfoText("Hjaalmarch is the frozen marshes of Skyrim around Morthal.")
	endEvent
	Event OnSelectST()
		displayedHold = getState()
		ForcePageReset()
	endEvent
endState
state locPale
	Event OnHighlightST()
		setInfoText("The Pale is the central northern region of Skyrim around Dawnstar.")
	endEvent
	Event OnSelectST()
		displayedHold = getState()
		ForcePageReset()
	endEvent
endState
state locReach
	Event OnHighlightST()
		setInfoText("Markarth and the Reach are in the mountainous western part of Skyrim.")
	endEvent
	Event OnSelectST()
		displayedHold = getState()
		ForcePageReset()
	endEvent
endState
state locRift
	Event OnHighlightST()
		setInfoText("Riften is named for the Rift, a plateau in southeastern Skyrim.")
	endEvent
	Event OnSelectST()
		displayedHold = getState()
		ForcePageReset()
	endEvent
endState
state locWhiterun
	Event OnHighlightST()
		setInfoText("Whiterun sits in the tundra at the center of Skyrim.")
	endEvent
	Event OnSelectST()
		displayedHold = getState()
		ForcePageReset()
	endEvent
endState
state locWinterhold
	Event OnHighlightST()
		setInfoText("Winterhold is the glacial mountain region in Skyrim's northeast.")
	endEvent
	Event OnSelectST()
		displayedHold = getState()
		ForcePageReset()
	endEvent
endState
; generic location menu options
Event OnHighlightST()
endEvent
Event OnDefaultST()
	if(LocationChangeOwnershipQuest.isRunning())
		ShowMessage("The quest that handles changing ownership is already running. You will have to wait until the quest is done to change the owner.", false)
	else
		string jPath =  "." + getState() + "."
		selectedLocation = JValue.solveForm(SupportedLocationsList, jPath + "locationForm") as Location
		int defaultOwner = JValue.solveInt(SupportedLocationsList, jPath + "defaultOwner")
		LocationChangeOwnership.sendStoryEvent(selectedLocation, none, none, defaultOwner, 1)
		SetMenuOptionValueST(LCO_Factions[defaultOwner])
	endIf
endEvent
Event OnMenuOpenST()
	string jPath =  "." + getState() + "."
	selectedLocation = JValue.solveForm(SupportedLocationsList, jPath + "locationForm") as Location
	int jOwners = JValue.solveObj(SupportedLocationsList, jPath + "supportedOwners")
	int count = JValue.count(jOwners)
	menuOwners = Utility.createIntArray(count)
	menuOwnerNames = Utility.createStringArray(count)
	int i = 0
	while i < count
		int lcoIndex = JArray.getInt(jOwners, i)
		menuOwners[i] = lcoIndex
		menuOwnerNames[i] = getOwnerName(selectedLocation, lcoIndex)
		i += 1
	endWhile
	int currentOwner = selectedLocation.getKeywordData(LocationCurrentOwnership) as int
	int startIndex = menuOwners.find(currentOwner)
	SetMenuDialogStartIndex(startIndex)
	SetMenuDialogDefaultIndex(0)
	SetMenuDialogOptions(menuOwnerNames)
endEvent
Event OnMenuAcceptST(int index)
	if(LocationChangeOwnershipQuest.isRunning())
		ShowMessage("The quest that handles changing ownership is already running. You will have to wait until the quest is done to change the owner.", false)
	else
		LocationChangeOwnership.sendStoryEvent(selectedLocation, none, none, menuOwners[index], 1)
		SetMenuOptionValueST(menuOwnerNames[index])
	endIf
endEvent
;Tactical Valtheim page
state TacValt_Controller
	Event OnHighlightST()
		setInfoText("Shows what faction currently controls, and which other factions can control, this location. Does not change who controls it.")
	endEvent
	Event OnDefaultST()
	endEvent
	Event OnMenuOpenST()
		int index
		int controller = Valtheim.getKeywordData(LocationCurrentOwnership) as int
		if(controller == 11)
			index = 0
		elseif(controller == 2)
			index = 1
		elseif(controller == 3)
			index = 2
		elseif(controller == 4)
			index = 3
		endIf
		string[] factions = new string[4]
		factions[0] = "Bandits"
		factions[1] = "Whiterun Hold"
		factions[2] = "The Empire"
		factions[3] = "Stormcloaks"
		SetMenuDialogStartIndex(index)
		SetMenuDialogOptions(factions)
	endEvent
	Event OnMenuAcceptST(int index)
	endEvent
endState
state TacValt_BlockLevelState
	Event OnHighlightST()
	endEvent
	Event OnDefaultST()
	endEvent
	Event OnSliderOpenST()
	endEvent
	Event OnSliderAcceptST(float value)
	endEvent
endState
state TacValt_FireLevelState
	Event OnHighlightST()
		setInfoText("Shows the level of this effect on the shield's enchantment. The effect will grow as more hits of this type are blocked.")
	endEvent
	Event OnDefaultST()
	endEvent
	Event OnSliderOpenST()
	endEvent
	Event OnSliderAcceptST(float value)
	endEvent
endState
state TacValt_FrostLevelState
	Event OnHighlightST()
		setInfoText("Shows the level of this effect on the shield's enchantment. The effect will grow as more hits of this type are blocked.")
	endEvent
	Event OnDefaultST()
	endEvent
	Event OnSliderOpenST()
	endEvent
	Event OnSliderAcceptST(float value)
	endEvent
endState
state TacValt_ShockLevelState
	Event OnHighlightST()
		setInfoText("Shows the level of this effect on the shield's enchantment. The effect will grow as more hits of this type are blocked.")
	endEvent
	Event OnDefaultST()
	endEvent
	Event OnSliderOpenST()
	endEvent
	Event OnSliderAcceptST(float value)
	endEvent
endState
;Serenity Page
state SMC_Controller
	Event OnHighlightST()
		setInfoText("Shows what faction currently controls, and which other factions can control, this location. Does not change who controls it.")
	endEvent
	Event OnDefaultST()
	endEvent
	Event OnMenuOpenST()
		int index
		int controller = SilentMoonsCamp.getKeywordData(LocationCurrentOwnership) as int
		if(controller == 11)
			index = 0
		elseif(controller == 2)
			index = 1
		elseif(controller == 3)
			index = 2
		elseif(controller == 4)
			index = 3
		endIf
		string[] factions = new string[4]
		factions[0] = "Bandits"
		factions[1] = "Whiterun Hold"
		factions[2] = "The Empire"
		factions[3] = "Stormcloaks"
		SetMenuDialogStartIndex(index)
		SetMenuDialogOptions(factions)
	endEvent
	Event OnMenuAcceptST(int index)
	endEvent
endState
state SMC_MoonPhaseState
	Event OnHighlightST()
		setInfoText("Lists the current phase of the moon, and shows the full cycle. Does not change the phase of the moon.")
	endEvent
	Event OnDefaultST()
	endEvent
	Event OnMenuOpenST()
		SetMenuDialogStartIndex(SMC_MoonPhase.getValue() as int)
		SetMenuDialogOptions(MoonPhases)
	endEvent
	Event OnMenuAcceptST(int index)
	endEvent
endState
state SMC_MoonriseState
	Event OnHighlightST()
		setInfoText("The hour at which the lunar forge activates and the lunar enchantments begin affecting targets.")
	endEvent
	Event OnDefaultST()
		SMC_Moonrise.setValue(def_SMC_Moonrise)
		SetSliderOptionValueST((SMC_Moonrise.getValue() as int % 12) as float, getTimeFormatString(SMC_Moonrise))
	endEvent
	Event OnSliderOpenST()
		SetSliderDialogValues(SMC_Moonrise.getValue(), def_SMC_Moonrise, 0.0, 24.0, 0.25)
	endEvent
	Event OnSliderAcceptST(float value)
		SMC_Moonrise.setValue(value)
		SetSliderOptionValueST((SMC_Moonrise.getValue() as int % 12) as float, getTimeFormatString(SMC_Moonrise))
	endEvent
endState
state SMC_MoonsetState
	Event OnHighlightST()
		setInfoText("The hour at which the lunar forge deactivates and the lunar enchantments stop affecting targets.")
	endEvent
	Event OnDefaultST()
		SMC_Moonset.setValue(def_SMC_Moonset)
		SetSliderOptionValueST((SMC_Moonset.getValue() as int % 12) as float, getTimeFormatString(SMC_Moonset))
	endEvent
	Event OnSliderOpenST()
		SetSliderDialogValues(SMC_Moonset.getValue(), def_SMC_Moonset, 0.0, 24.0, 0.25)
	endEvent
	Event OnSliderAcceptST(float value)
		SMC_Moonset.setValue(value)
		SetSliderOptionValueST((SMC_Moonset.getValue() as int % 12) as float, getTimeFormatString(SMC_Moonset))
	endEvent
endState
state SMC_LunarForgeState
	Event OnHighlightST()
		setInfoText("What weapons the Lunar Forge will produce.")
	endEvent
	Event OnDefaultST()
	endEvent
	Event OnMenuOpenST()
	endEvent
	Event OnMenuAcceptST(int index)
	endEvent
endState