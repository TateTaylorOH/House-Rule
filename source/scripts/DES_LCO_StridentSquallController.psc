scriptname DES_LCO_StridentSquallController extends LCO_LocationControllerBase  

;/ inherited properties, states, and functions
autoreadonly int LCO_Default
autoreadonly int LCO_LocalHold
autoreadonly int LCO_CollegeofWinterhold
autoreadonly int LCO_Imperial
int newOwner
Event onInit()
function updateOwnership()
function registerMod()
auto state Waiting
state UpdateQueued
	Event onBeginState()
	Event onUpdate()
	Event onUpdateGameTime()
	Event onUnload()
/;

ObjectReference Property RedoranGarrisonMarker Auto
ObjectReference Property TelvanniGarrisonMarker Auto
ObjectReference Property DefaultRedoranMarker Auto
ObjectReference Property DefaultTelvanniMarker Auto

ObjectReference Property RedoranBanner Auto
ObjectReference Property TelvanniBanner Auto
ObjectReference Property EECBanner Auto

Actor Property PlayerRef Auto
Message Property Claim Auto
Message Property NoClaim Auto

Event OnLoad()
	updateBanners()
endEvent

Event OnActivate(ObjectReference ref)
	if(ref == PlayerRef)
		if(PlayerRef.isInCombat())
			NoClaim.show()
		else
			int choice = Claim.show()
			if(choice == 0)
				newOwner = LCO_Default
				goToState("UpdateQueued")
			elseif(choice == 1)
				newOwner = LCO_LocalHold
				goToState("UpdateQueued")
			elseif(choice == 2)
				newOwner = LCO_CollegeofWinterhold
				goToState("UpdateQueued")
			elseif(choice == 3)
				newOwner = LCO_Imperial
				goToState("UpdateQueued")
			endIf
			updateBanners()
		endIf
	endIf
endEvent

function updateOwnership()
	parent.updateOwnership()
endFunction

function updateBanners()
	if(newOwner == LCO_Default)
		if(RedoranGarrisonMarker.isDisabled())
			RedoranBanner.disableNoWait()
		else
			RedoranBanner.enableNoWait()
		endIf
		if(TelvanniGarrisonMarker.isDisabled())
			TelvanniBanner.disableNoWait()
		else
			TelvanniBanner.enableNoWait()
		endIf
		EECBanner.disableNoWait()
	elseif(newOwner == LCO_LocalHold)
		RedoranBanner.enableNoWait()
		TelvanniBanner.disableNoWait()
		EECBanner.disableNoWait()
	elseif(newOwner == LCO_CollegeofWinterhold)
		RedoranBanner.disableNoWait()
		TelvanniBanner.enableNoWait()
		EECBanner.disableNoWait()
	elseif(newOwner == LCO_Imperial)
		RedoranBanner.disableNoWait()
		TelvanniBanner.disableNoWait()
		EECBanner.enableNoWait()
	endIf
endFunction