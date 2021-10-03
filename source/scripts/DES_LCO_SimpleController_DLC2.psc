Scriptname DES_LCO_SimpleController_DLC2 extends LCO_LocationControllerBase  

;/inherited properties
int LCO_Default
int LCO_Player
int LCO_LocalHold
int LCO_Imperial
int LCO_Stormcloak
int LCO_Companions
int LCO_ThievesGuild
int LCO_CollegeOfWinterhold
int LCO_DarkBrotherhood
int LCO_Stormcloak
int LCO_LocalHold
int LCO_Bandits
int LCO_Forsworn
int LCO_Warlock
int LCO_Animals
int LCO_DruadachForsworn
int LCO_Imperial
int LCO_Vampire
Keyword CurrentOwnership
Keyword DefaultOwnership
Keyword ChangeOwnership
int newOwner
int defaultOwner
GlobalVariable realTimeUpdateDelay
GlobalVariable gameTimeUpdateDelay
Location thisLocation
/;

Message property NoClaim Auto
Message Property Claim Auto
Form Property DefaultBanner Auto
Form Property EECoBanner Auto
Form Property RedoranBanner Auto

ObjectReference myDefaultBanner
ObjectReference myEECoBanner
ObjectReference myRedoranBanner

Event onLoad()
	myDefaultBanner = Game.findClosestReferenceOfTypeFromRef(DefaultBanner, self, 400.0)
	myEECoBanner = Game.findClosestReferenceOfTypeFromRef(EECoBanner, self, 400.0)
	myRedoranBanner = Game.findClosestReferenceOfTypeFromRef(RedoranBanner, self, 400.0)
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
	if(choice == 0 && current != LCO_Default)
		newOwner = LCO_Default
		updateBanners(LCO_Default)
		goToState("UpdateQueued")
	elseif(choice == 1 && current != LCO_LocalHold)
		newOwner = LCO_LocalHold
		updateBanners(LCO_LocalHold)
		goToState("UpdateQueued")
	elseif(choice == 2 && current != LCO_Imperial)
		newOwner = LCO_Imperial
		updateBanners(LCO_Imperial)
		goToState("UpdateQueued")
	endif
endEvent

function updateBanners(int i = -1)
	if(i == -1)
		i = thisLocation.getKeywordData(CurrentOwnership) as int
	endIf
	if(i == LCO_Default)
		myDefaultBanner.enableNoWait()
		myRedoranBanner.disableNoWait()
		myEECoBanner.disableNoWait()
	elseif(i == LCO_LocalHold)
		myDefaultBanner.disableNoWait()
		myRedoranBanner.enableNoWait()
		myEECoBanner.disableNoWait()
	elseif(i == LCO_Imperial)
		myDefaultBanner.disableNoWait()
		myRedoranBanner.disableNoWait()
		myEECoBanner.enableNoWait()
	endif
endFunction