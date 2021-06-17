Scriptname LCO_ClearLocOnKillAlias extends ReferenceAlias  

Event OnDeath(Actor akKiller)
	getReference().getCurrentLocation().setCleared()
endEvent