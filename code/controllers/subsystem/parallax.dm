SUBSYSTEM_DEF(parallax)
	name = "Parallax"
	wait = 2
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND | SS_NO_INIT
	priority = 65
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/currentrun

/datum/controller/subsystem/parallax/fire(resumed = 0)
	if (!resumed)
		src.currentrun = GLOB.clients.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(length(currentrun))
		var/client/C = currentrun[currentrun.len]
		currentrun.len--
		if (!C || !C.eye)
			if (MC_TICK_CHECK)
				return
			continue
		var/atom/movable/A = C.eye
		if(!A)
			return
		for (A; isloc(A.loc) && !isturf(A.loc); A = A.loc);

		if(A != C.movingmob)
			if(C.movingmob != null)
				C.movingmob.client_mobs_in_contents -= C.mob
				UNSETEMPTY(C.movingmob.client_mobs_in_contents)
			LAZYINITLIST(A.client_mobs_in_contents)
			A.client_mobs_in_contents += C.mob
			C.movingmob = A
		if (MC_TICK_CHECK)
			return
	currentrun = null
