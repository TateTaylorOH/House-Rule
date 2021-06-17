scriptname LCO_LocationControllerBase extends ObjectReference
{has a Waiting state and an UpdateQueued state. will be in waiting state by default. set the newOwner property and go to the UpdateQueued state to update the ownership. Update will be delayed until the first of an elapsed real time, elapsed game time, or this object is unloaded.}

int property LCO_Default = 0 autoreadonly
int property LCO_Player = 1 autoreadonly
int property LCO_LocalHold = 2 autoreadonly
int property LCO_Imperial = 3 autoreadonly
int property LCO_Stormcloak = 4 autoreadonly
int property LCO_Companions = 5 autoreadonly
int property LCO_ThievesGuild = 6 autoreadonly
int property LCO_CollegeOfWinterhold = 7 autoreadonly
int property LCO_DarkBrotherhood = 8 autoreadonly
int property LCO_Dawnguard = 9 autoreadonly
int property LCO_Volkihar = 10 autoreadonly
int property LCO_Bandits = 11 autoreadonly
int property LCO_Forsworn = 12 autoreadonly
int property LCO_Warlock = 13 autoreadonly
int property LCO_Animals = 14 autoreadonly
int property LCO_DruadachForsworn = 15 autoreadonly
int property LCO_VigilOfStendarr = 16 autoreadonly
int property LCO_Vampire = 17 autoreadonly

Keyword property CurrentOwnership Auto
Keyword property DefaultOwnership Auto
Keyword property ChangeOwnership Auto

int property newOwner auto
int property defaultOwner auto

GlobalVariable property realTimeUpdateDelay auto
GlobalVariable property gameTimeUpdateDelay auto

Location property thisLocation auto

Event onInit()
	thisLocation.setKeywordData(DefaultOwnership, defaultOwner)
	thisLocation.setKeywordData(CurrentOwnership, defaultOwner)
	newOwner = defaultOwner
endEvent

auto state Waiting

endState

state UpdateQueued
	Event onBeginState()
		float rtDelay = 300.0
		float gtDelay = 24.0
		if(realTimeUpdateDelay && realTimeUpdateDelay.getValue() != 0.0)
			rtDelay = realTimeUpdateDelay.getValue()
		endIf
		if(gameTimeUpdateDelay && gameTimeUpdateDelay.getValue() != 0.0)
			gtDelay = gameTimeUpdateDelay.getValue()
		endIf
		registerForSingleUpdate(rtDelay)
		registerForSingleUpdateGameTime(gtDelay)
	endEvent
	
	;these three events are the cases where we want to update the ownership
	Event onUpdate()
		goToState("Waiting")
		updateOwnership()
	endEvent
	Event onUpdateGameTime()
		goToState("Waiting")
		updateOwnership()
	endEvent
	Event onUnload()
		goToState("Waiting")
		updateOwnership()
	endEvent
endState

function updateOwnership()
	if(newOwner != (thisLocation.getKeywordData(CurrentOwnership) as int))
		int noRadiant = (newOwner >= LCO_Player && newOwner <= LCO_Volkihar) as int ; the beauty of sequential enums
		ChangeOwnership.sendStoryEvent(thisLocation, none, none, newOwner, noRadiant)
	endIf
endFunction

; only used for MCM stuff
function registerMod()

endFunction