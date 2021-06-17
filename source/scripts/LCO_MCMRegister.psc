scriptname LCO_MCMRegister extends Quest

ReferenceAlias Property ControllerAlias Auto

Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
	Utility.wait(1.0)
	ObjectReference ref = ControllerAlias.getReference()
	if(ref && ref as LCO_LocationControllerBase)
		(ref as LCO_LocationControllerBase).registerMod()
	endIf
	stop()
endEvent