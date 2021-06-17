scriptname LCO_ShorsWatchtowerController extends LCO_LocationControllerBase  

;/ inherited properties, states, and functions
autoreadonly int LCO_Default
autoreadonly int LCO_LocalHold
autoreadonly int LCO_Imperial
autoreadonly int LCO_Stormcloak
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

ObjectReference Property RiftGarrisonMarker Auto
ObjectReference Property ImperialGarrisonMarker Auto
ObjectReference Property DefaultRiftMarker Auto
ObjectReference Property DefaultImperialMarker Auto

ObjectReference Property RiftBanner Auto
ObjectReference Property ImperialBanner Auto
ObjectReference Property StormcloakBanner Auto

Actor Property PlayerRef Auto
Message Property Claim Auto
Message Property NoClaim Auto

function updateDefaultMarkers()
	if(newOwner == LCO_Default)
		if(RiftGarrisonMarker.isDisabled())
			DefaultRiftMarker.disableNoWait()
		else
			DefaultRiftMarker.enableNoWait()
		endIf
		if(ImperialGarrisonMarker.isDisabled())
			DefaultImperialMarker.disableNoWait()
		else
			DefaultImperialMarker.enableNoWait()
		endIf
	else
		DefaultRiftMarker.disableNoWait()
		DefaultImperialMarker.disableNoWait()
	endIf
endFunction

Event OnLoad()
	updateDefaultMarkers()
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
				newOwner = LCO_Imperial
				goToState("UpdateQueued")
			elseif(choice == 3)
				newOwner = LCO_Stormcloak
				goToState("UpdateQueued")
			endIf
			updateBanners()
		endIf
	endIf
endEvent

function updateOwnership()
	parent.updateOwnership()
	updateDefaultMarkers()
endFunction

function updateBanners()
	if(newOwner == LCO_Default)
		if(RiftGarrisonMarker.isDisabled())
			RiftBanner.disableNoWait()
		else
			RiftBanner.enableNoWait()
		endIf
		if(ImperialGarrisonMarker.isDisabled())
			ImperialBanner.disableNoWait()
		else
			ImperialBanner.enableNoWait()
		endIf
		StormcloakBanner.disableNoWait()
	elseif(newOwner == LCO_LocalHold)
		RiftBanner.enableNoWait()
		ImperialBanner.disableNoWait()
		StormcloakBanner.disableNoWait()
	elseif(newOwner == LCO_Imperial)
		RiftBanner.disableNoWait()
		ImperialBanner.enableNoWait()
		StormcloakBanner.disableNoWait()
	elseif(newOwner == LCO_Stormcloak)
		RiftBanner.disableNoWait()
		ImperialBanner.disableNoWait()
		StormcloakBanner.enableNoWait()
	endIf
endFunction