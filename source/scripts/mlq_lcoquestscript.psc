Scriptname MLQ_LCOQuestScript extends Quest  

Keyword Property CurrentOwnership Auto
Keyword Property DefaultOwnership Auto
ReferenceAlias[] Property ControlMarkerAliases Auto
FormList Property RadiantExclusionFormList Auto

Event onStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int newController, int excludeFromRadiant)
	bool isSetupProperly = akLocation.hasKeyword(CurrentOwnership)
	if(newController == 0 && akLocation.hasKeyword(DefaultOwnership)) ;defaulting ownership and a specific faction is the default
		newController = akLocation.getKeywordData(DefaultOwnership) as int
	endIf
	if(isSetupProperly)
		int index = akLocation.getKeywordData(CurrentOwnership) as int
		ObjectReference currentControllerRef = ControlMarkerAliases[index].getReference()
		ObjectReference newControllerRef = ControlMarkerAliases[newController].getReference()
		if(currentControllerRef && !currentControllerRef.isDisabled() && newControllerRef && newControllerRef.isDisabled());if any of these conditions aren't met it's best to just not deal with this
			currentControllerRef.disable()
			newControllerRef.enable()
			akLocation.setKeywordData(CurrentOwnership, newController as float)
			if(excludeFromRadiant == 0 && RadiantExclusionFormList.hasForm(akLocation))
				RadiantExclusionFormList.removeAddedForm(akLocation)
			elseif(excludeFromRadiant != 0 && !RadiantExclusionFormList.hasForm(akLocation))
				RadiantExclusionFormList.addForm(akLocation)
			endIf
		endIf
	else ; fuck you this is going to be so much messier now
		int index = ControlMarkerAliases.length
		ObjectReference currentControllerRef = None
		while (index > 0 && !currentControllerRef)
			index -= 1
			ObjectReference temp = ControlMarkerAliases[index].getReference()
			if(temp && !temp.isDisabled())
				currentControllerRef = temp
				ObjectReference newControllerRef = ControlMarkerAliases[newController].getReference()
				if(currentControllerRef && !currentControllerRef.isDisabled() && newControllerRef && newControllerRef.isDisabled())
					currentControllerRef.disable()
					newControllerRef.enable()
					if(excludeFromRadiant == 0 && RadiantExclusionFormList.hasForm(akLocation))
						RadiantExclusionFormList.removeAddedForm(akLocation)
					elseif(excludeFromRadiant != 0 && !RadiantExclusionFormList.hasForm(akLocation))
						RadiantExclusionFormList.addForm(akLocation)
					endIf
				endIf
			endIf
		endWhile
	endIf
	stop()
endEvent

int function getControllerIndex(String controllerName) global
	if(controllerName == "Default" || controllerName == "")
		return 0
	elseif(controllerName == "Player")
		return 1
	elseif(controllerName == "Local Hold" || controllerName == "LocalHold" || controllerName == "Hold" || controllerName == "Guard")
		return 2
	elseif(controllerName == "Imperial" || controllerName == "Empire" || controllerName == "Imp")
		return 3
	elseif(controllerName == "Stormcloak" || controllerName == "SC")
		return 4
	elseif(controllerName == "Companions")
		return 5
	elseif(controllerName == "Thieves Guild" || controllerName == "ThievesGuild" || controllerName == "TG")
		return 6
	elseif(controllerName == "College of Winterhold" || controllerName == "CollegeOfWinterhold" || controllerName == "CoW")
		return 7
	elseif(controllerName == "Dark Brotherhood" || controllerName == "DarkBrotherhood" || controllerName == "DB")
		return 8
	elseif(controllerName == "Dawnguard" || controllerName == "DG" || controllerName == "VH")
		return 9
	elseif(controllerName == "Volkihar Vampires" || controllerName == "Volkihar" || controllerName == "RV")
		return 10
	elseif(controllerName == "Bandits" || controllerName == "Bandit")
		return 11
	elseif(controllerName == "Forsworn")
		return 12
	elseif(controllerName == "Warlock" || controllerName == "Warlocks")
		return 13
	elseif(controllerName == "Animals" || controllerName == "Spriggan")
		return 14
	elseif(controllerName == "Druadach Forsworn" || controllerName == "Madanach")
		return 15
	elseif(controllerName == "Vigil" || controllerName == "Vigil of Stendarr")
		return 16
	elseif(controllerName == "Vampire" || controllerName == "Vampires")
		return 17
	endIf
	return -1
endFunction