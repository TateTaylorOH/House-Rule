Scriptname DES_LCO_SimpleController_DLC2 extends LCO_SimpleControllerBase

Form Property DefaultBanner Auto
{base form for the default banner near the controller.}
Form Property RedoranBanner Auto
{base form for the House Redoran banner near the controller.}
Form Property EECBanner Auto
{base form for the East Empire Company banner near the controller.}
Form Property TribeBanner Auto
{base form for the Thirsk Tribe banner near the controller.}
ObjectReference Property EnableEEC Auto

ObjectReference myDefaultBanner
ObjectReference myRedoranBanner
ObjectReference myEECBanner
ObjectReference myTribeBanner

function getLocalBanners()
	myDefaultBanner = Game.findClosestReferenceOfTypeFromRef(DefaultBanner, self, 400.0)
	myRedoranBanner = Game.findClosestReferenceOfTypeFromRef(RedoranBanner, self, 400.0)
	myEECBanner = Game.findClosestReferenceOfTypeFromRef(EECBanner, self, 400.0)
	myTribeBanner = Game.findClosestReferenceOfTypeFromRef(TribeBanner, self, 400.0)
endFunction

int function processChoice(int selectedChoice, int currentOwner)
	if(selectedChoice == 0)
		return LCO.Default()
	elseif(selectedChoice == 1)
		return LCO.LocalHold()
	elseif(selectedChoice == 2)
		return LCO.EastEmpireCompany()
	elseif(selectedChoice == 3)
		return LCO.Player()
	endIf
	return currentOwner
endFunction

function hide()
	parent.hide()
	myDefaultBanner.disableNoWait()
	myRedoranBanner.disableNoWait()
	myEECBanner.disableNoWait()
	myTribeBanner.disableNoWait()
endFunction

function updateBanners(int i = -1)
	if(i == -1)
		i = thisLocation.getKeywordData(CurrentOwnership) as int
	endIf
	if(i == LCO.Default())
		myDefaultBanner.enableNoWait()
		myRedoranBanner.disableNoWait()
		myEECBanner.disableNoWait()
		myTribeBanner.disableNoWait()
	elseif(i == LCO.LocalHold())
		myDefaultBanner.disableNoWait()
		myRedoranBanner.enableNoWait()
		myEECBanner.disableNoWait()
		myTribeBanner.disableNoWait()
	elseif(i == LCO.EastEmpireCompany())
		EnableEEC.Enable()
		myDefaultBanner.disableNoWait()
		myRedoranBanner.disableNoWait()
		myEECBanner.enableNoWait()
		myTribeBanner.disableNoWait()
	elseif(i == LCO.Player())
		myDefaultBanner.disableNoWait()
		myRedoranBanner.disableNoWait()
		myEECBanner.disableNoWait()
		myTribeBanner.enableNoWait()
	endIf
endFunction