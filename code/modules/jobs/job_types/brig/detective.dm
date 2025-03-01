/datum/job/detective
	title = "Detective"
	flag = DETECTIVE
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	department_head = list("Head of Security")
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#c02f2f"
	minimal_player_age = 7
	exp_requirements = 3000
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/detective
	plasma_outfit = /datum/outfit/plasmaman/detective
	considered_combat_role = TRUE

	access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_COURT, ACCESS_BRIG, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_SECURITY, ACCESS_SEC_DOORS, ACCESS_FORENSICS_LOCKERS, ACCESS_MORGUE, ACCESS_MAINT_TUNNELS, ACCESS_COURT, ACCESS_BRIG, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SEC

	mind_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_DETECTIVE
	blacklisted_quirks = list(/datum/quirk/mute, /datum/quirk/brainproblems, /datum/quirk/nonviolent, /datum/quirk/monophobia)
	threat = 1

	family_heirlooms = list(
		/obj/item/reagent_containers/food/drinks/flask/det
	)

/datum/outfit/job/detective
	name = "Detective"
	jobtype = /datum/job/detective

	belt = /obj/item/pda/detective
	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/rank/security/detective
	neck = /obj/item/clothing/neck/tie/black
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/det_suit
	gloves = /obj/item/clothing/gloves/color/black
	head = /obj/item/clothing/head/fedora/det_hat
	l_pocket = /obj/item/toy/crayon/white
	r_pocket = /obj/item/lighter
	backpack_contents = list(/obj/item/storage/box/evidence=1,\
		/obj/item/detective_scanner=1,\
		/obj/item/melee/classic_baton=1)
	mask = /obj/item/clothing/mask/cigarette

	implants = list(/obj/item/implant/mindshield)

	chameleon_extras = list(/obj/item/gun/ballistic/revolver/detective, /obj/item/clothing/glasses/sunglasses)

/datum/outfit/job/detective/syndicate
	name = "Syndicate Detective"
	jobtype = /datum/job/detective

	//belt = /obj/item/pda/syndicate/no_deto

	ears = /obj/item/radio/headset/headset_sec/alt
	uniform = /obj/item/clothing/under/rank/security/officer/util
	neck = /obj/item/clothing/neck/tie/black
	shoes = /obj/item/clothing/shoes/jackboots/tall_default
	suit = /obj/item/clothing/suit/det_suit
	gloves = /obj/item/clothing/gloves/combat
	head = /obj/item/clothing/head/fedora/det_hat
	l_pocket = /obj/item/toy/crayon/white
	r_pocket = /obj/item/lighter
	backpack_contents = list(/obj/item/storage/box/evidence=1,\
		/obj/item/detective_scanner=1,\
		/obj/item/syndicate_uplink_high=1,\
		/obj/item/melee/classic_baton=1)
	mask = /obj/item/clothing/mask/cigarette/cigar/havana

	backpack = /obj/item/storage/backpack/duffelbag/syndie/ammo
	satchel = /obj/item/storage/backpack/duffelbag/syndie/ammo
	duffelbag = /obj/item/storage/backpack/duffelbag/syndie/ammo
	box = /obj/item/storage/box/survival/syndie
	pda_slot = ITEM_SLOT_BELT

/datum/outfit/job/detective/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE, client/preference_source)
	..()
	var/obj/item/clothing/mask/cigarette/cig = H.wear_mask
	if(istype(cig)) //Some species specfic changes can mess this up (plasmamen)
		cig.light("")

	if(visualsOnly)
		return

