/mob/living/carbon/alien
	name = "alien"
	icon = 'icons/mob/alien.dmi'
	gender = FEMALE
	dna = null
	faction = list(ROLE_ALIEN)
	sight = SEE_MOBS
	see_in_dark = 4
	verb_say = "hisses"
	initial_language_holder = /datum/language_holder/alien
	bubble_icon = "alien"
	type_of_meat = /obj/item/reagent_containers/food/snacks/meat/slab/xeno
//BLUEMOON EDIT START
//Дальше бога нет
	has_anus = TRUE
	has_vagina = TRUE
	has_penis = TRUE
	has_balls = TRUE

//BLUEMOON EDIT END
	typing_indicator_state = /obj/effect/overlay/typing_indicator/additional/alien

	/// Whether they can ventcrawl; this is set individually for 'humanoid' and 'royal' types
	/// 'royal' types (Praetorian, Queen) cannot ventcrawl
	var/can_ventcrawl

	/// How much brute damage without armor piercing they do against mobs in melee
	var/meleeSlashHumanPower = 20
	/// How much power they have for DefaultCombatKnockdown when attacking humans
	var/meleeKnockdownPower = 100
	/// How much brute damage they do to simple animals
	var/meleeSlashSAPower = 35

	var/has_fine_manipulation = 0
	var/move_delay_add = 0 // movement delay to add

	status_flags = CANUNCONSCIOUS|CANPUSH

	heat_protection = 0.5
	var/leaping = 0
	gib_type = /obj/effect/decal/cleanable/blood/gibs/xeno
	unique_name = 1

	var/static/regex/alien_name_regex = new("alien (larva|sentinel|drone|hunter|praetorian|queen)( \\(\\d+\\))?")

/mob/living/carbon/alien/Initialize(mapload)
	add_verb(src, /mob/living/proc/mob_sleep)
	add_verb(src, /mob/living/proc/lay_down)

	create_bodyparts() //initialize bodyparts

	create_internal_organs()

	if(can_ventcrawl)
		AddElement(/datum/element/ventcrawling, given_tier = VENTCRAWLER_ALWAYS)

	. = ..()

/mob/living/carbon/alien/create_internal_organs()
	internal_organs += new /obj/item/organ/brain/alien
	internal_organs += new /obj/item/organ/alien/hivenode
	internal_organs += new /obj/item/organ/tongue/alien
	internal_organs += new /obj/item/organ/eyes/night_vision/alien
	internal_organs += new /obj/item/organ/ears
	..()

/mob/living/carbon/alien/assess_threat(judgement_criteria, lasercolor = "", datum/callback/weaponcheck=null) // beepsky won't hunt aliums
	return -10

/mob/living/carbon/alien/handle_environment(datum/gas_mixture/environment)
	if(!environment)
		return

	var/loc_temp = get_temperature(environment)

	// Aliens are now weak to fire.

	//After then, it reacts to the surrounding atmosphere based on your thermal protection
	if(!on_fire) // If you're on fire, ignore local air temperature
		if(loc_temp > bodytemperature)
			//Place is hotter than we are
			var/thermal_protection = heat_protection //This returns a 0 - 1 value, which corresponds to the percentage of heat protection.
			if(thermal_protection < 1)
				adjust_bodytemperature((1-thermal_protection) * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR))
		else
			adjust_bodytemperature(1 * ((loc_temp - bodytemperature) / BODYTEMP_HEAT_DIVISOR))

	if(bodytemperature > BODYTEMP_HEAT_DAMAGE_LIMIT)
		//Body temperature is too hot.
		throw_alert("alien_fire", /atom/movable/screen/alert/alien_fire)
		switch(bodytemperature)
			if(360 to 400)
				apply_damage(HEAT_DAMAGE_LEVEL_1, BURN)
			if(400 to 460)
				apply_damage(HEAT_DAMAGE_LEVEL_2, BURN)
			if(460 to INFINITY)
				if(on_fire)
					apply_damage(HEAT_DAMAGE_LEVEL_3, BURN)
				else
					apply_damage(HEAT_DAMAGE_LEVEL_2, BURN)
	else
		clear_alert("alien_fire")

/mob/living/carbon/alien/reagent_check(datum/reagent/R) //can metabolize all reagents
	return 0

/mob/living/carbon/alien/IsAdvancedToolUser()
	return has_fine_manipulation

/mob/living/carbon/alien/get_status_tab_items()
	. = ..()
	. += "Intent: [a_intent]"

/mob/living/carbon/alien/getTrail()
	if(getBruteLoss() < 200)
		return pick (list("xltrails_1", "xltrails2"))
	else
		return pick (list("xttrails_1", "xttrails2"))
/*----------------------------------------
Proc: AddInfectionImages()
Des: Gives the client of the alien an image on each infected mob.
----------------------------------------*/
/mob/living/carbon/alien/proc/AddInfectionImages()
	if (client)
		for (var/i in GLOB.mob_living_list)
			var/mob/living/L = i
			if(HAS_TRAIT(L, TRAIT_XENO_HOST))
				var/obj/item/organ/body_egg/alien_embryo/A = L.getorgan(/obj/item/organ/body_egg/alien_embryo)
				if(A)
					var/I = image('icons/mob/alien.dmi', loc = L, icon_state = "infected[A.stage]")
					client.images += I
	return


/*----------------------------------------
Proc: RemoveInfectionImages()
Des: Removes all infected images from the alien.
----------------------------------------*/
/mob/living/carbon/alien/proc/RemoveInfectionImages()
	if (client)
		for(var/image/I in client.images)
			var/searchfor = "infected"
			if(findtext(I.icon_state, searchfor, 1, length(searchfor) + 1))
				qdel(I)
	return

/mob/living/carbon/alien/canBeHandcuffed()
	return 1

/mob/living/carbon/alien/get_standard_pixel_y_offset(lying = 0)
	return initial(pixel_y)

/mob/living/carbon/alien/proc/alien_evolve(mob/living/carbon/alien/new_xeno)
	to_chat(src, "<span class='noticealien'>You begin to evolve!</span>")
	visible_message("<span class='alertalien'>[src] begins to twist and contort!</span>",
		"<span class='alertalien'>You begin to twist and contort!</span>")
	new_xeno.setDir(dir)
	if(!alien_name_regex.Find(name))
		new_xeno.name = name
		new_xeno.real_name = real_name
	if(mind)
		mind.transfer_to(new_xeno)
	qdel(src)

/mob/living/carbon/alien/can_hold_items()
	return has_fine_manipulation
