Scriptname LCO_SimpleController_VampiresAndSuch extends LCO_LocationControllerBase  

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
int LCO_Dawnguard
int LCO_Volkihar
int LCO_Bandits
int LCO_Forsworn
int LCO_Warlock
int LCO_Animals
int LCO_DruadachForsworn
int LCO_VigilOfStendarr
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
Form Property VolkiharBanner Auto
Form Property VigilantBanner Auto
Form Property DawnguardBanner Auto

ObjectReference myDefaultBanner
ObjectReference myVolkiharBanner
ObjectReference myVigilantBanner
ObjectReference myDawnguardBanner

Event onLoad()
	myDefaultBanner = Game.findClosestReferenceOfTypeFromRef(DefaultBanner, self, 400.0)
	myVolkiharBanner = Game.findClosestReferenceOfTypeFromRef(VolkiharBanner, self, 400.0)
	myVigilantBanner = Game.findClosestReferenceOfTypeFromRef(VigilantBanner, self, 400.0)
	myDawnguardBanner = Game.findClosestReferenceOfTypeFromRef(DawnguardBanner, self, 400.0)
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
	elseif(choice == 1 && current != LCO_Volkihar)
		newOwner = LCO_Volkihar
		updateBanners(LCO_Volkihar)
		goToState("UpdateQueued")
	elseif(choice == 2 && current != LCO_VigilOfStendarr)
		newOwner = LCO_VigilOfStendarr
		updateBanners(LCO_VigilOfStendarr)
		goToState("UpdateQueued")
	elseif(choice == 3 && current != LCO_Dawnguard)
		newOwner = LCO_Dawnguard
		updateBanners(LCO_Dawnguard)
		goToState("UpdateQueued")
	endIf
endEvent

function updateBanners(int i = -1)
	if(i == -1)
		i = thisLocation.getKeywordData(CurrentOwnership) as int
	endIf
	if(i == LCO_Default)
		myDefaultBanner.enableNoWait()
		myVolkiharBanner.disableNoWait()
		myVigilantBanner.disableNoWait()
		myDawnguardBanner.disableNoWait()
	elseif(i == LCO_Volkihar)
		myDefaultBanner.disableNoWait()
		myVolkiharBanner.enableNoWait()
		myVigilantBanner.disableNoWait()
		myDawnguardBanner.disableNoWait()
	elseif(i == LCO_VigilOfStendarr)
		myDefaultBanner.disableNoWait()
		myVolkiharBanner.disableNoWait()
		myVigilantBanner.enableNoWait()
		myDawnguardBanner.disableNoWait()
	elseif(i == LCO_Dawnguard)
		myDefaultBanner.disableNoWait()
		myVolkiharBanner.disableNoWait()
		myVigilantBanner.disableNoWait()
		myDawnguardBanner.enableNoWait()
	endIf
endFunction