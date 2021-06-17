Scriptname LCO_VigilDestructionMonitoringScript extends ReferenceAlias  

DLC1_QF_DLC1VQ01MiscObjective_0100D06C Property Dawnguard Auto
GlobalVariable Property LCO_Vigil_isSelectable Auto
Keyword Property LocationChangeOwnershipEvent Auto
Keyword Property LocationCurrentOwnership Auto
Location[] Property VigilLocations Auto
float property LCO_VigilOfStendarr = 16.0 autoreadonly
MLQ_LCOQuestScript Property LCOQuest Auto

int i
Location loc

auto state waiting
	Event OnLocationChange(Location akOldLoc, Location akNewLoc)
		registerForSingleUpdate(5.0)
	endEvent

	Event OnUpdate()
		if(Dawnguard.DLC1HallNormalState.isDisabled())
			goToState("destroyTheVigil")
		endIf
	endEvent
endState

state destroyTheVigil
	Event OnBeginState()
		LCO_Vigil_isSelectable.setValue(0.0)
		i = VigilLocations.length - 1
		loc = VigilLocations[i]
		LocationChangeOwnershipEvent.SendStoryEvent(loc) ; this is actually all you need to do to revert these. i expected it to be more complicated.
		registerForSingleUpdate(1.0)
	endEvent
	
	Event OnUpdate()
		if(loc.getKeywordData(LocationCurrentOwnership) == LCO_VigilOfStendarr || LCOQuest.isRunning())
			registerForSingleUpdate(1.0)
		else
			i -= 1
			loc = VigilLocations[i]
			LocationChangeOwnershipEvent.SendStoryEvent(loc)
			if(i > 0)
				registerForSingleUpdate(1.0)
			else
				getOwningQuest().stop()
			endIf
		endIf
	endEvent
endState