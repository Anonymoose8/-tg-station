/obj/item/organ/internal
	origin_tech = "biotech=2"
	force = 1
	w_class = 2
	throwforce = 0
	var/zone ="error"
	var/slot = "error"
	var/vital = 0

	var/organ_action_name = null

/obj/item/organ/internal/proc/Remove()
	if(organ_action_name)
		action_button_name = null

/obj/item/organ/internal/proc/on_find(mob/living/finder)
	return

/obj/item/organ/internal/proc/on_life()
	return

/obj/item/organ/internal/proc/prepare_eat()
	var/obj/item/weapon/reagent_containers/food/snacks/S = new
	S.name = name
	S.desc = desc
	S.icon = icon
	S.icon_state = icon_state
	S.origin_tech = origin_tech
	S.w_class = w_class
	S.reagents.add_reagent("nutriment", 5)

	return S

/obj/item/organ/internal/Destroy()
	if(owner)
		organdatum.dismember(ORGAN_REMOVED, 1)
	..()

/obj/item/organ/internal/attack(mob/living/carbon/M, mob/user)
	if(M == user && ishuman(user))
		var/mob/living/carbon/human/H = user
		if(organtype == ORGAN_ORGANIC)
			var/obj/item/weapon/reagent_containers/food/snacks/S = prepare_eat()
			if(S)
				H.drop_item()
				H.put_in_active_hand(S)
				S.attack(H, H)
				qdel(src)
	else
		..()

//Looking for brains?
//Try code/modules/mob/living/carbon/brain/brain_item.dm



/obj/item/organ/internal/heart
	name = "heart"
	hardpoint = "heart"
	icon_state = "heart-on"
	desc = "Some days, your heart is just not in it."
	origin_tech = "biotech=3"
	var/beating = 1

/obj/item/organ/internal/heart/update_icon()
	if(beating)
		icon_state = "heart-on"
	else
		icon_state = "heart-off"

/obj/item/organ/internal/heart/examine(mob/user)
	if(beating)
		user << "It's still beating."
	else
		user << "It stopped beating."

/obj/item/organ/internal/heart/Insert(mob/living/carbon/M, special = 0)
	..()
	beating = 1
	update_icon()

/obj/item/organ/internal/heart/Remove(special = 0)
	..()
	spawn(120)
		beating = 0
		update_icon()

/obj/item/organ/internal/heart/prepare_eat()
	var/obj/S = ..()
	S.icon_state = "heart-off"
	return S



/obj/item/organ/internal/appendix
	name = "appendix"
	hardpoint = "appendix"
	icon_state = "appendix"
	desc = "The greyshirt of organs."
	var/inflamed = 0

/obj/item/organ/internal/appendix/update_icon()
	if(inflamed)
		icon_state = "appendixinflamed"
		name = "inflamed appendix"
	else
		icon_state = "appendix"
		name = "appendix"

/obj/item/organ/internal/appendix/Remove(special = 0)
	if(owner)
		for(var/datum/disease/appendicitis/A in owner.viruses)
			A.cure()
			inflamed = 1
	update_icon()
	..()

/obj/item/organ/internal/appendix/Insert(mob/living/carbon/M)
	..()
	if(inflamed)
		M.AddDisease(new /datum/disease/appendicitis)

/obj/item/organ/internal/appendix/prepare_eat()
	var/obj/S = ..()
	if(inflamed)
		S.reagents.add_reagent("????", 5)
	return S