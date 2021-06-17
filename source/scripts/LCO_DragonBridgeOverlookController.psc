scriptname LCO_DragonBridgeOverlookController extends LCO_SimpleController_RFIS

ObjectReference Property ForswornAnyMarker Auto
ObjectReference Property NorAnyMarker Auto

ObjectReference Property ForswornBannerSupport Auto
ObjectReference Property OtherBannerSupport Auto

function updateOwnership()
	parent.updateOwnership()
	if(newOwner == LCO_Default || newOwner == LCO_Forsworn || newOwner == LCO_DruadachForsworn)
		ForswornAnyMarker.enableNoWait()
		NorAnyMarker.disableNoWait()
	elseif(newOwner == LCO_LocalHold || newOwner == LCO_Stormcloak)
		ForswornAnyMarker.disableNoWait()
		NorAnyMarker.enableNoWait()
	else
		ForswornAnyMarker.disableNoWait()
		NorAnyMarker.disableNoWait()
	endif
endFunction

function updateBanners(int i = -1)
	parent.updateBanners(i)
	if(i == LCO_Forsworn || i == LCO_DruadachForsworn)
		ForswornBannerSupport.enableNoWait()
		OtherBannerSupport.disableNoWait()
	else
		ForswornBannerSupport.disableNoWait()
		OtherBannerSupport.enableNoWait()
	endIf
endFunction