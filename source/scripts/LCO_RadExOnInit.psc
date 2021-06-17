scriptname LCO_RadExOnInit extends Quest

Location[] Property ExcludedLocations Auto
FormList Property RadExFLST Auto

Event OnInit()
	int i = ExcludedLocations.length
	while i > 0
		i -= 1
		Location loc = ExcludedLocations[i]
		if(!RadExFLST.hasForm(loc))
			RadExFLST.addForm(loc)
		endIf
	endWhile
endEvent