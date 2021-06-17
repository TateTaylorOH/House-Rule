Scriptname LCO_SimpleController_RFIS extends LCO_LocationControllerBase

Message property NoClaim Auto
Message Property Claim Auto
Form Property DefaultBanner Auto
Form Property ReachBanner Auto
Form Property DruadachForswornBanner Auto
Form Property ImperialBanner Auto
Form Property StormcloakBanner Auto

ObjectReference myDefaultBanner
ObjectReference myReachBanner
ObjectReference myDruadachForswornBanner
ObjectReference myImperialBanner
ObjectReference myStormcloakBanner 

Event onLoad()
	myDefaultBanner = Game.findClosestReferenceOfTypeFromRef(DefaultBanner, self, 400.0)
	myReachBanner = Game.findClosestReferenceOfTypeFromRef(ReachBanner, self, 400.0)
	myDruadachForswornBanner = Game.findClosestReferenceOfTypeFromRef(DruadachForswornBanner, self, 400.0)
	myImperialBanner = Game.findClosestReferenceOfTypeFromRef(ImperialBanner, self, 400.0)
	myStormcloakBanner = Game.findClosestReferenceOfTypeFromRef(StormcloakBanner, self, 400.0)
	updateBanners()
	setDisplayName(thisLocation.getName())
endEvent

Event onActivate(ObjectReference akActionRef)
	if((akActionRef as Actor).isInCombat() || !thisLocation.isCleared())
		NoClaim.show()
		return
	endIf
	int choice = Claim.show()
	int current = thisLocation.getKeywordData(CurrentOwnership) as int
	if(choice == 0 && current != LCO_Default) ; incidentally I'm usually one to say hardcoding is bad but tbh eh
		newOwner = LCO_Default ; this is a specific version of a general script for specific cases
		updateBanners(LCO_Default)
		goToState("UpdateQueued")
	elseif(choice == 1 && current != LCO_LocalHold) ; and I already know how it's supposed to work and when
		newOwner = LCO_LocalHold
		updateBanners(LCO_LocalHold)
		goToState("UpdateQueued")
	elseif(choice == 2 && current != LCO_DruadachForsworn)
		newOwner = LCO_DruadachForsworn
		updateBanners(LCO_DruadachForsworn)
		goToState("UpdateQueued")
	elseif(choice == 3 && current != LCO_Imperial)
		newOwner = LCO_Imperial
		updateBanners(LCO_Imperial)
		goToState("UpdateQueued")
	elseif(choice == 4 && current != LCO_Stormcloak)
		newOwner = LCO_Stormcloak
		updateBanners(LCO_Stormcloak)
		goToState("UpdateQueued")
	endIf
endEvent

function updateBanners(int i = -1)
	if(i == -1)
		i = thisLocation.getKeywordData(CurrentOwnership) as int
	endIf
	if(i == LCO_Default)
		myDefaultBanner.enableNoWait()
		myReachBanner.disableNoWait()
		myDruadachForswornBanner.disableNoWait()
		myImperialBanner.disableNoWait()
		myStormcloakBanner.disableNoWait()
	elseif(i == LCO_LocalHold)
		myDefaultBanner.disableNoWait()
		myReachBanner.enableNoWait()
		myDruadachForswornBanner.disableNoWait()
		myImperialBanner.disableNoWait()
		myStormcloakBanner.disableNoWait()
	elseif(i == LCO_DruadachForsworn)
		myDefaultBanner.disableNoWait()
		myReachBanner.disableNoWait()
		myDruadachForswornBanner.enableNoWait()
		myImperialBanner.disableNoWait()
		myStormcloakBanner.disableNoWait()
	elseif(i == LCO_Imperial)
		myDefaultBanner.disableNoWait()
		myReachBanner.disableNoWait()
		myDruadachForswornBanner.disableNoWait()
		myImperialBanner.enableNoWait()
		myStormcloakBanner.disableNoWait()
	elseif(i == LCO_Stormcloak)
		myDefaultBanner.disableNoWait()
		myReachBanner.disableNoWait()
		myDruadachForswornBanner.disableNoWait()
		myImperialBanner.disableNoWait()
		myStormcloakBanner.enableNoWait()
	endIf
endFunction