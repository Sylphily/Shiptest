//Copy-pasted kepori stuff
/datum/species/vox
	name = "\improper Vox"
	id = SPECIES_VOX
	default_color = "6060FF"
	species_age_min = 17
	species_age_max = 280
	species_traits = list(EYECOLOR, NO_UNDERWEAR)
	mutant_bodyparts = list("vox_head_quills", "vox_neck_quills")
	default_features = list("mcolor" = "0F0", "wings" = "None", "vox_head_quills" = "None", "vox_neck_quills" = "None")
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/chicken
	disliked_food = GRAIN
	liked_food = MEAT
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	loreblurb = "Vox test"
	say_mod = "shrieks"
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	species_clothing_path = 'icons/mob/clothing/species/vox.dmi'
	species_eye_path = 'icons/mob/vox_parts.dmi'
	punchdamagelow = 6
	punchdamagehigh = 12
	mutanttongue = /obj/item/organ/tongue/vox
	species_language_holder = /datum/language_holder/vox

	bodytemp_heat_divisor = VOX_BODYTEMP_HEAT_DIVISOR
	bodytemp_cold_divisor = VOX_BODYTEMP_COLD_DIVISOR
	bodytemp_autorecovery_min = VOX_BODYTEMP_AUTORECOVERY_MIN

	species_chest = /obj/item/bodypart/chest/vox
	species_head = /obj/item/bodypart/head/vox
	species_l_arm = /obj/item/bodypart/l_arm/vox
	species_r_arm = /obj/item/bodypart/r_arm/vox
	species_l_leg = /obj/item/bodypart/l_leg/vox
	species_r_leg = /obj/item/bodypart/r_leg/vox

	var/static/list/allergy_reactions = list(
		"Your beak itches.",
		"Your stomach churns.",
		"Your tail flicks on its own.",
		"Your quills feel heavy.",
		"Your lungs struggle to fill."
		)

	var/static/list/allergic_to = typecacheof(
		list(
			/datum/reagent/medicine/ephedrine,
			/datum/reagent/medicine/atropine,
			/datum/reagent/medicine/epinephrine,
			/datum/reagent/medicine/mannitol,
			/datum/reagent/medicine/antihol,
			/datum/reagent/medicine/stimulants,
			/datum/reagent/medicine/inaprovaline
		)
	)

/datum/species/vox/random_name(gender,unique,lastname,attempts)
	. = ""

	var/new_name = ""
	var/static/list/syllables = list("ti", "ti", "ti", "hi", "hi", "ki", "ki", "ki", "ki", "ya", "ta", "ha", "ka", "ya", "chi", "cha", "kah", \
		"skre", "ahk", "ehk", "rawk", "kra", "ki", "ii", "kri", "ka")
	for(var/x = rand(3,8) to 0 step -1)
		new_name += pick(syllables)
	. += "[capitalize(new_name)]"

	if(unique && attempts < 10)
		if(findname(new_name))
			. = .(gender, TRUE, null, attempts++)

	return .



/datum/species/vox/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	C.base_pixel_x -= 9
	C.pixel_x = C.base_pixel_x
	C.update_hands_on_rotate()

/datum/species/vox/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	C.base_pixel_x += 9
	C.pixel_x = C.base_pixel_x
	C.stop_updating_hands()

/datum/species/vox/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	if(allergic_to[chem.type]) //Is_type_in_typecache is BAD.
		H.reagents.add_reagent(/datum/reagent/toxin/histamine, chem.metabolization_rate * 5)
		if(prob(7))
			to_chat(H, "<span class='danger'>[pick(allergy_reactions)]</span>")
		else if(prob(7))
			H.emote("clack")
		return FALSE //Its a bit TOO mean to have the chems not work at all.
	return ..()

/datum/species/vox/get_item_offsets_for_dir(var/dir, var/hand)
	////LEFT/RIGHT
	switch(dir)
		if(SOUTH)
			return list(list("x" = 10, "y" = -1), list("x" = 8, "y" = -1))
		if(NORTH)
			return list(list("x" = 9, "y" = 0), list("x" = 9, "y" = 0))
		if(EAST)
			return list(list("x" = 18, "y" = 2), list("x" = 21, "y" = -1))
		if(WEST)
			return list(list("x" = -5, "y" = -1), list("x" = -1, "y" = 2))

/datum/species/vox/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	. = ..()
	var/obj/item/environmental_regulator/regulator = new
	if(!H.equip_to_slot_if_possible(regulator, ITEM_SLOT_BACK, swap = TRUE))
		if(!H.put_in_hands(regulator, forced = TRUE))
			regulator.forceMove(get_turf(H))
