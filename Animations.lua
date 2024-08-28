system.setScriptName('~t5~Animations.lua')

logger.logCustom('<#FF69B4>[<b>Animations.lua: <#FFC0CB>Loaded!</#FF69B4></b><#FF69B4>]')
notifications.alertInfo("Animations.lua Loaded", "Version: 1.0")

emote_id = menu.addSubmenu('self', '~t5~Emotes', '')
scenario_id = menu.addSubmenu('self', '~t5~Scenarios', '')
anim_id = menu.addSubmenu('self', '~t5~Animations', '')
animal_id = menu.addSubmenu('self', '~t5~Animal Scenarios', '')
advanced_id = menu.addSubmenu('self', '~t5~Advanced', '')

local render_range = false
local tick_registered = false
local walking = false
warp_to_scenario = true
local anim_speed = 1.0
local scenario_range = 10
local force_rest_scenario = false
local play_anim_on_scenario = false
local play_on_spawned_ped = false
local ground_detection = true
local play_anim_on_horse = false
local movement_distance = 0.50
local spawned_peds = {}

local animations = {
    -- Guns
    {anim_dict = "script_mp@photo_studio@chair_rifles@male", anim_name = "idle_m01", name = "Male Rifle Pose 1"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@male", anim_name = "idle_m06", name = "Male Rifle Pose 2"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@male", anim_name = "idle_m07", name = "Male Rifle Pose 3"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@female", anim_name = "idle_f01", name = "Female Rifle Pose 1"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@female", anim_name = "idle_f06", name = "Female Rifle Pose 2"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@female", anim_name = "idle_f07", name = "Female Rifle Pose 3"},
    {anim_dict = "mech_inspection@weapons@longarms@rifle_bolt_action@base", anim_name = "clean_loop", name = "Clean Rifle"},
    {anim_dict = "mech_inspection@weapons@longarms@rifle_bolt_action@base", anim_name = "base_sweep", name = "Inspect Rifle"},
    {anim_dict = "mech_inspection@weapons@longarms@rifle_bolt_action@base", anim_name = "flipped_sweep", name = "Inspect Rifle 2"},
    {anim_dict = "mech_inspection@weapons@longarms@rifle_bolt_action@base", anim_name = "aim_sweep", name = "Inspect Rifle 3"},
    {anim_dict = "ai_combat@poses@ambient@1h", anim_name = "ambient_1h_aim_under_fire", name = "Pistol Aim Under Fire"},
    {anim_dict = "ai_combat@poses@ambient@1h", anim_name = "ambient_1h_aim", name = "Pistol Aim Pose"},
    {anim_dict = "ai_combat@poses@ambient@2h", anim_name = "ambient_2h_aim_under_fire", name = "Rifle Aim Under Fire"},
    {anim_dict = "ai_combat@poses@ambient@2h", anim_name = "ambient_2h_aim", name = "Rifle Aim Pose"},
    {anim_dict = "ai_combat@poses@cowboy", anim_name = "cowboy_holstered_action_pose", name = "Ready to Draw"},
    {anim_dict = "ai_combat@poses@cowboy@2h", anim_name = "cowboy_2h_unholstered_relaxed_pose", name = "Rifle Relaxed"},
    {anim_dict = "ai_combat@poses@cowboy@2h", anim_name = "cowboy_2h_aim_pose", name = "Standing Rifle Aim"},
    {anim_dict = "ai_combat@poses@cowboy@dual", anim_name = "cowboy_dual_unholstered_action_pose", name = "Dual Pistol Unholstered"},
    {anim_dict = "ai_combat@poses@cowboy@dual", anim_name = "cowboy_dual_aim_pose", name = "Dual Pistol Aim"},
    {anim_dict = "ai_combat@poses@cowboy_crouch@1h", anim_name = "cowboy_crouch_1h_pose", name = "Pistol Crouch"},
    {anim_dict = "ai_combat@poses@cowboy_crouch@1h", anim_name = "cowboy_crouch_1h_aim_pose", name = "Pistol Crouch Aim"},
    {anim_dict = "ai_combat@poses@cowboy_crouch@2h", anim_name = "cowboy_crouch_2h_pose", name = "Rifle Crouch"},
    {anim_dict = "ai_combat@poses@cowboy_crouch@2h", anim_name = "cowboy_crouch_2h_aim_pose", name = "Rifle Crouch Aim"},
    {anim_dict = "ai_combat@poses@military@1h@kneeling", anim_name = "military_1h_aim_kneel", name = "Pistol Aim Kneel"},
    {anim_dict = "ai_combat@poses@military@2h@kneeling", anim_name = "military_2h_aim_kneel", name = "Rifle Aim Kneel"},
    {anim_dict = "script_rc@gun5@ig@stage_01@ig3_bellposes", anim_name = "pose_02_idle_famousgunslinger_05", name = "Dual Pistol Pose"},
    {anim_dict = "script_rc@gun5@ig@stage_01@ig3_bellposes", anim_name = "pose_03_idle_famousgunslinger_05", name = "Rifle Shoulder Pose"},
    {anim_dict = "script_rc@gun4@stage_01@ig@ig2_takephoto", anim_name = "photopose_04_idle_famousgunslinger_04", name = "Double Gun Pose"},
    {anim_dict = "script_rc@gun4@stage_01@ig@ig2_takephoto", anim_name = "photopose_01_idle_famousgunslinger_04", name = "Double Gun Pose 2"},
    {anim_dict = "mech_inventory@equip@fallback@base_spin@pistol_rhip", anim_name = "holster", name = "Single Gun Holster"},
    {anim_dict = "mech_inventory@equip@fallback@base_spin@single_handgun@rhip", anim_name = "loop", name = "Single Gun Spin"},
    {anim_dict = "mech_inventory@equip@fallback@base_spin@single_handgun@shared", anim_name = "var_b_loop", name = "Single Gun Spin Var B"},
    {anim_dict = "mech_inventory@equip@fallback@base_spin@single_handgun@shared", anim_name = "var_c_loop", name = "Single Gun Spin Var C"},
    {anim_dict = "mech_inventory@equip@fallback@base_spin@single_handgun@shared", anim_name = "var_d_loop", name = "Single Gun Spin Var D"},
    {anim_dict = "mech_inventory@equip@fallback@base_spin@single_handgun@shared", anim_name = "var_e", name = "Single Gun Spin Var E"},
    {anim_dict = "mech_inventory@equip@fallback@base_spin@single_handgun@shared", anim_name = "var_f", name = "Single Gun Spin Var F"},
    {anim_dict = "mech_inventory@equip@fallback@base_spin@dual", anim_name = "loop", name = "Dual Gun Spin"},
    {anim_dict = "mech_inventory@equip@fallback@base_spin@dual", anim_name = "var_b_loop", name = "Dual Gun Spin Var B"},
    {anim_dict = "mech_inventory@equip@fallback@base_spin@dual", anim_name = "var_c_loop", name = "Dual Gun Spin Var C"},
    {anim_dict = "mech_inventory@equip@fallback@base_spin@dual", anim_name = "var_d_loop", name = "Dual Gun Spin Var D"},
    {anim_dict = "mech_inventory@equip@fallback@base_spin@dual", anim_name = "var_e", name = "Dual Gun Spin Var E"},
    {anim_dict = "mech_inventory@equip@fallback@base_spin@dual", anim_name = "var_f", name = "Dual Gun Spin Var F"},
    
    -- HorseBack
    -- The HorseBack Animations 90% of them kick you off your horse so they were very limited.
    --{anim_dict = "mech_inventory@equip@fallback@first_person@unarmed@horseback@longarms_gesture", anim_name = "holster", name = "HorseBack Holster Rifle"},
    --{anim_dict = "mech_inventory@equip@fallback@first_person@unarmed@horseback@longarms_gesture", anim_name = "unholster", name = "HorseBack Unholster Rifle"},
    --{anim_dict = "script_story@fud1@ig@ig_horseback_pointing", anim_name = "right_hand_point_01", name = "HorseBack Point Right"},
    {anim_dict = "script_story@fud1@ig@ig_horseback_pointing", anim_name = "left_hand_point_01", name = "HorseBack Point Left"},

    -- Resting and Sitting
    {anim_dict = "ai_react@breakouts@gen_male@known_poses", anim_name = "pose_getup_from_ass", name = "Sit Butt"},
    {anim_dict = "amb_rest_drunk@world_human_sit_ground@drinking_drunk@passed_out@male_d@idle_c", anim_name = "idle_h", name = "Resting"},
    {anim_dict = "cnv_camp@rchso@cnv@cfsn2", anim_name = "gen_male_a_action", name = "Resting 2"},
    {anim_dict = "script_proc@bounty@wife_and_lover@confront_a", anim_name = "sit_idle_female", name = "Sitting Cute"},
    {anim_dict = "script_mp@photo_studio@possy_photo_1chair", anim_name = "idle_f06", name = "Sitting Cute 2"},
    {anim_dict = "mp_lobby@standard@crouching@mp_female_a@active_look", anim_name = "active_look", name = "Sit Ground 2"},
    {anim_dict = "script_re@dark_alley_bum@desp@steal", anim_name = "enter_lf_bum", name = "Sit Ground 4"},
    {anim_dict = "cnv_camp@rchso@cnv@cfun2", anim_name = "gen_male_b_action", name = "Sit Ground"},
    {anim_dict = "cnv_camp@rchso@cnv@cfun5", anim_name = "base_gen_male_c", name = "Lay Ground Side"},
    
    -- Standing and Leaning
    {anim_dict = "amb_player@world_human_lean@wall@high@lean_a@base", anim_name = "base", name = "Lean A"},
    {anim_dict = "amb_rest_drunk@world_human_lean@railing@back@drinking@male_a@idle_a", anim_name = "idle_c", name = "Lean B"},
    {anim_dict = "amb_rest_drunk@world_human_lean@railing@drinking@female_b@base", anim_name = "base", name = "Female Lean A"},
    {anim_dict = "script_re@slum_ambush@ig1_woman_leads_to_ambush", anim_name = "enter_ft_prostitute", name = "Leaning Prostitute"},
    {anim_dict = "script_mp@last_round@photos@pair_a", anim_name = "pose4_f_a1", name = "Leaning Back Fence"},
    {anim_dict = "script_mp@last_round@photos@pair_a", anim_name = "pose4_m_a1", name = "Leaning Back Fence 2"},
    {anim_dict = "amb_rest_lean@world_human_lean_fence_fwd_check_out_livestock@male_e@idle_a", anim_name = "idle_a", name = "Leaning On Shoulder"},
    {anim_dict = "script_story@gry3@ig@ig_1_meetbillmicah", anim_name = "full_walk_standing", name = "Leaning Side"},
    {anim_dict = "amb_rest_lean@world_human_lean@piano@left@female_a@wip_base", anim_name = "wip_base", name = "Girl Boss Lean"},
    {anim_dict = "amb_rest_lean@world_human_lean@piano@left@female_b@wip_base", anim_name = "wip_base", name = "Girl Boss Lean 2"},
    {anim_dict = "amb_rest_lean@world_human_lean@railing@female_b@react_look@active_look", anim_name = "active_look_front", name = "Leaning On Bar"},
    
    -- Female Poses
    {anim_dict = "script_re@peep_tom@topless_woman", anim_name = "female_idle_female", name = "Female Fixing Hair"},
    {anim_dict = "script_story@ind1@ai_scenario_reactions@party_ai_champagne_lady_c", anim_name = "ai_champagneladyc_goodevening_a_f_m_gamhighsociety_01", name = "Female Holding Glass"},
    {anim_dict = "script_proc@robberies@homestead@aberdeen@undressing", anim_name = "loopb", name = "Female Mirror"},
    {anim_dict = "script_proc@robberies@homestead@aberdeen@undressing", anim_name = "loopa", name = "Female Mirror 2"},
    {anim_dict = "mp_lobby@coop@standing@mp_female_a@active_look", anim_name = "active_look", name = "Female Pose 1"},
    {anim_dict = "mp_lobby@coop@standing@mp_female_b@active_look", anim_name = "active_look", name = "Female Pose 2"},
    {anim_dict = "mp_lobby@coop@standing@mp_female_c@active_look", anim_name = "active_look", name = "Female Pose 3"},
    {anim_dict = "mp_lobby@coop@standing@mp_female_d@active_look", anim_name = "active_look", name = "Female Pose 4"},
    {anim_dict = "mp_lobby@phns@standing@mp_female_b@active_look", anim_name = "active_look", name = "Female Pose 5"},
    {anim_dict = "script_mp@photostudio@dog@female", anim_name = "idle_f04", name = "Female Pose 6"},
    {anim_dict = "script_mp@photostudio@dog@female", anim_name = "idle_f06", name = "Female Pose 7"},
    {anim_dict = "mp_lobby@standard@standing@mp_female_a@active_look", anim_name = "active_look", name = "Female Pose 8"},
    {anim_dict = "mp_lobby@standard@standing@mp_female_b@active_look", anim_name = "active_look", name = "Female Pose 9"},
    {anim_dict = "mp_lobby@standard@standing@mp_female_c@active_look", anim_name = "active_look", name = "Female Pose 10"},
    {anim_dict = "mp_lobby@standard@standing@mp_female_d@active_look", anim_name = "active_look", name = "Female Pose 11"},
    {anim_dict = "mp_lobby@standard@standing@mp_female_e@active_look", anim_name = "active_look", name = "Female Pose 12"},
    {anim_dict = "mp_lobby@standard@standing@mp_female_f@active_look", anim_name = "active_look", name = "Female Pose 13"},
    {anim_dict = "mp_lobby@standard@standing@mp_female_g@active_look", anim_name = "active_look", name = "Female Pose 14"},
    {anim_dict = "mp_lobby@standard@standing@mp_female_h@active_look", anim_name = "active_look", name = "Female Pose 15"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@left@moonshine@female_a@base", anim_name = "base", name = "Female Pose 16"},
    {anim_dict = "amb_camp@world_camp_fire_standing@female_a@base", anim_name = "base", name = "Female Pose 17"},
    {anim_dict = "amb_camp@world_camp_fire_standing@female_b@base", anim_name = "base", name = "Female Pose 18"},
    {anim_dict = "amb_camp@world_camp_grimshaw_stare@wip_base@female_a", anim_name = "base", name = "Female Pose 19"},
    {anim_dict = "amb_camp@world_camp_grimshaw_stare@wip_base@female_b", anim_name = "base", name = "Female Pose 20"},
    {anim_dict = "amb_camp@world_camp_grimshaw_stare@wip_base@female_d", anim_name = "base", name = "Female Pose 21"},
    {anim_dict = "script_proc@robberies@homestead@aberdeen@undressing", anim_name = "line01_loop", name = "Female Pose 22"},
    {anim_dict = "script_special_ped@pdeep_early_eugenics_proponent@ig@ig_1", anim_name = "carolina_base_carolina", name = "Female Pose 23"},
    {anim_dict = "script_mp@photo_studio@row_staggered", anim_name = "idle_f05", name = "Female Pose 24"},
    {anim_dict = "script_proc@robberies@homestead@aberdeen@undressing", anim_name = "loop_short", name = "Female Pose 25"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_f02", name = "Female Pose 26"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_f03", name = "Female Pose 27"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_f05", name = "Female Pose 28"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_f06", name = "Female Pose 29"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_f07", name = "Female Pose 30"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_f01", name = "Female Pose 31"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_f04", name = "Female Pose 32"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_f02", name = "Female Pose 33"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_f03", name = "Female Pose 34"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_f05", name = "Female Pose 35"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_f06", name = "Female Pose 36"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_f07", name = "Female Pose 37"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_f01", name = "Female Pose 38"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_f04", name = "Female Pose 39"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_f02", name = "Female Pose 40"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_f03", name = "Female Pose 41"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_f05", name = "Female Pose 42"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_f06", name = "Female Pose 43"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_f07", name = "Female Pose 44"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_f01", name = "Female Pose 45"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_f04", name = "Female Pose 46"},
    {anim_dict = "script_mp@photo_studio@celebrate@female", anim_name = "idle_f04", name = "Female Pose 47"},
    {anim_dict = "script_mp@photo_studio@celebrate@female", anim_name = "idle_f02", name = "Female Pose 48"},
    {anim_dict = "script_mp@photo_studio@celebrate@female", anim_name = "idle_f03", name = "Female Pose 49"},
    {anim_dict = "script_mp@photo_studio@celebrate@female", anim_name = "idle_f05", name = "Female Pose 50"},
    {anim_dict = "script_mp@photo_studio@celebrate@female", anim_name = "idle_f06", name = "Female Pose 51"},
    {anim_dict = "script_mp@photo_studio@celebrate@female", anim_name = "idle_f07", name = "Female Pose 52"},
    {anim_dict = "script_mp@photo_studio@celebrate@female", anim_name = "idle_f01", name = "Female Pose 53"},
    {anim_dict = "script_mp@photo_studio@celebrate@female", anim_name = "idle_f04", name = "Female Pose 54"},
    {anim_dict = "script_mp@photo_studio@fun@female", anim_name = "idle_f04", name = "Female Pose 55"},
    {anim_dict = "script_mp@photo_studio@fun@female", anim_name = "idle_f02", name = "Female Pose 56"},
    {anim_dict = "script_mp@photo_studio@fun@female", anim_name = "idle_f03", name = "Female Pose 57"},
    {anim_dict = "script_mp@photo_studio@fun@female", anim_name = "idle_f05", name = "Female Pose 58"},
    {anim_dict = "script_mp@photo_studio@fun@female", anim_name = "idle_f06", name = "Female Pose 59"},
    {anim_dict = "script_mp@photo_studio@fun@female", anim_name = "idle_f07", name = "Female Pose 60"},
    {anim_dict = "script_mp@photo_studio@fun@female", anim_name = "idle_f01", name = "Female Pose 61"},
    {anim_dict = "script_mp@photo_studio@fun@female", anim_name = "idle_f04", name = "Female Pose 62"},
    {anim_dict = "script_mp@photo_studio@row_staggered", anim_name = "idle_f01", name = "Female Pose 63"},
    {anim_dict = "script_mp@photo_studio@row_staggered", anim_name = "idle_f02", name = "Female Pose 64"},
    {anim_dict = "script_mp@photo_studio@row_staggered", anim_name = "idle_f03", name = "Female Pose 65"},
    {anim_dict = "script_mp@photo_studio@row_staggered", anim_name = "idle_f04", name = "Female Pose 66"},
    {anim_dict = "script_mp@photo_studio@row_staggered", anim_name = "idle_f06", name = "Female Pose 67"},
    {anim_dict = "script_mp@photo_studio@row_staggered", anim_name = "idle_f07", name = "Female Pose 68"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_f01", name = "Female Pose 69"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_f02", name = "Female Pose 70"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_f03", name = "Female Pose 71"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_f04", name = "Female Pose 72"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_f05", name = "Female Pose 73"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_f06", name = "Female Pose 74"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_f07", name = "Female Pose 75"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@female", anim_name = "idle_f02", name = "Female Pose 76"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@female", anim_name = "idle_f03", name = "Female Pose 77"},
    {anim_dict = "mp_lobby@standard@crouching@mp_female_a@active_look", anim_name = "active_look", name = "Female Sitting Pose 1"},
    {anim_dict = "mp_lobby@standard@crouching@mp_female_b@active_look", anim_name = "active_look", name = "Female Sitting Pose 2"},
    {anim_dict = "mp_lobby@standard@seated@mp_female_a@active_look", anim_name = "active_look", name = "Female Sitting Pose 3"},
    {anim_dict = "mp_lobby@standard@seated@mp_female_a@skirt@active_look", anim_name = "active_look", name = "Female Sitting Pose 4"},
    {anim_dict = "mp_lobby@standard@seated@mp_female_b@active_look", anim_name = "active_look", name = "Female Sitting Pose 5"},
    {anim_dict = "mp_lobby@standard@seated@mp_female_b@skirt@active_look", anim_name = "active_look", name = "Female Sitting Pose 6"},
    {anim_dict = "mp_lobby@standard@seated@mp_female_c@skirt@active_look", anim_name = "active_look", name = "Female Sitting Pose 7"},
    {anim_dict = "mp_lobby@standard@seated@mp_female_c@active_look", anim_name = "active_look", name = "Female Sitting Pose 8"},
    {anim_dict = "mp_lobby@standard@seated@mp_female_d@active_look", anim_name = "active_look", name = "Female Sitting Pose 9"},
    {anim_dict = "mp_lobby@standard@seated@mp_female_e@active_look", anim_name = "active_look", name = "Female Sitting Pose 10"},
    {anim_dict = "mp_lobby@standard@seated@mp_female_e@skirt@active_look", anim_name = "active_look", name = "Female Sitting Pose 11"},
    {anim_dict = "mp_lobby@standard@seated@mp_female_f@active_look", anim_name = "active_look", name = "Female Sitting Pose 12"},
    {anim_dict = "amb_temp@world_human_seat_steps@female@hands_by_sides@base", anim_name = "base", name = "Female Sitting Pose 13"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@female", anim_name = "idle_f04", name = "Female Sitting Pose 14"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@female", anim_name = "idle_f05", name = "Female Sitting Pose 15"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@left@female_a@idle_a", anim_name = "idle_a", name = "Lean Post Left Female 1"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@left@female_a@idle_b", anim_name = "idle_d", name = "Lean Post Left Female 2"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@left@female_a@idle_b", anim_name = "idle_f", name = "Lean Post Left Female 3"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@left@female_a@idle_b", anim_name = "idle_e", name = "Lean Post Left Female 4"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@left@female_a@idle_c", anim_name = "idle_h", name = "Lean Post Left Female 5"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@left@female_a@idle_c", anim_name = "idle_g", name = "Lean Post Left Female 6"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@right@female_a@idle_a", anim_name = "idle_a", name = "Lean Post Right Female 1"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@right@female_a@idle_a", anim_name = "idle_b", name = "Lean Post Right Female 2"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@right@female_a@idle_a", anim_name = "idle_c", name = "Lean Post Right Female 3"},
    {anim_dict = "amb_rest_lean@world_human_lean@railing@female_a@idle_a", anim_name = "idle_a", name = "Lean Railing Female 1"},
    {anim_dict = "amb_rest_lean@world_human_lean@railing@female_a@idle_d", anim_name = "idle_j", name = "Lean Railing Female 2"},
    {anim_dict = "amb_rest_lean@world_human_lean@railing@female_b@base", anim_name = "base", name = "Lean Railing Female 3"},
    {anim_dict = "amb_rest_lean@world_human_lean@railing@right@female_a@idle_a", anim_name = "idle_a", name = "Lean Railing Female 4"},
    {anim_dict = "amb_rest_lean@world_human_lean@wall@female_a@idle_c", anim_name = "idle_g", name = "Lean Wall Female 1"},
    {anim_dict = "amb_rest_lean@world_human_lean@wall@female_b@idle_a", anim_name = "idle_b", name = "Lean Wall Female 2"},
    {anim_dict = "amb_rest_lean@world_human_lean_window_left@female@base", anim_name = "base", name = "Lean Window Left Female 1"},
    {anim_dict = "amb_rest_lean@world_human_lean_window_left@female@idle_a", anim_name = "idle_b", name = "Lean Window Left Female 2"},
    {anim_dict = "amb_rest_lean@world_human_lean_window_right@female@base", anim_name = "base", name = "Lean Window Right Female 3"},
    {anim_dict = "amb_rest_lean@world_human_lean_window_right@female@idle_a", anim_name = "idle_b", name = "Lean Window Right Female 4"},
    
    -- Male Poses
    {anim_dict = "mp_lobby@coop@standing@mp_male_a@active_look", anim_name = "active_look", name = "Male Pose 1"},
    {anim_dict = "mp_lobby@coop@standing@mp_male_b@active_look", anim_name = "active_look", name = "Male Pose 2"},
    {anim_dict = "mp_lobby@coop@standing@mp_male_c@active_look", anim_name = "active_look", name = "Male Pose 3"},
    {anim_dict = "mp_lobby@coop@standing@mp_male_d@active_look", anim_name = "active_look", name = "Male Pose 4"},
    {anim_dict = "mp_lobby@standard@standing@mp_male_a@active_look", anim_name = "active_look", name = "Male Pose 5"},
    {anim_dict = "mp_lobby@standard@standing@mp_male_b@active_look", anim_name = "active_look", name = "Male Pose 6"},
    {anim_dict = "mp_lobby@standard@standing@mp_male_c@active_look", anim_name = "active_look", name = "Male Pose 7"},
    {anim_dict = "mp_lobby@standard@standing@mp_male_d@active_look", anim_name = "active_look", name = "Male Pose 8"},
    {anim_dict = "mp_lobby@standard@standing@mp_male_e@active_look", anim_name = "active_look", name = "Male Pose 9"},
    {anim_dict = "mp_lobby@standard@standing@mp_male_f@active_look", anim_name = "active_look", name = "Male Pose 10"},
    {anim_dict = "mp_lobby@standard@standing@mp_male_g@active_look", anim_name = "active_look", name = "Male Pose 11"},
    {anim_dict = "mp_lobby@standard@standing@mp_male_h@active_look", anim_name = "active_look", name = "Male Pose 12"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@male", anim_name = "idle_m02", name = "Male Pose 13"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@male", anim_name = "idle_m03", name = "Male Pose 14"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@male", anim_name = "idle_m04", name = "Male Pose 15"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@male", anim_name = "idle_m05", name = "Male Pose 16"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_m01", name = "Male Pose 17"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_m02", name = "Male Pose 18"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_m03", name = "Male Pose 19"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_m04", name = "Male Pose 20"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_m05", name = "Male Pose 21"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_m06", name = "Male Pose 22"},
    {anim_dict = "script_mp@photo_studio@2chairs", anim_name = "idle_m07", name = "Male Pose 23"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_m01", name = "Male Pose 24"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_m02", name = "Male Pose 25"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_m03", name = "Male Pose 26"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_m04", name = "Male Pose 27"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_m05", name = "Male Pose 28"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_m06", name = "Male Pose 29"},
    {anim_dict = "script_mp@photo_studio@aimpistols_row", anim_name = "idle_m07", name = "Male Pose 30"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_m01", name = "Male Pose 31"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_m02", name = "Male Pose 32"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_m03", name = "Male Pose 33"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_m04", name = "Male Pose 34"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_m05", name = "Male Pose 35"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_m06", name = "Male Pose 36"},
    {anim_dict = "script_mp@photo_studio@aimpistols_vform", anim_name = "idle_m07", name = "Male Pose 37"},
    {anim_dict = "script_mp@photo_studio@celebrate@male", anim_name = "idle_m01", name = "Male Pose 38"},
    {anim_dict = "script_mp@photo_studio@celebrate@male", anim_name = "idle_m02", name = "Male Pose 39"},
    {anim_dict = "script_mp@photo_studio@celebrate@male", anim_name = "idle_m03", name = "Male Pose 40"},
    {anim_dict = "script_mp@photo_studio@celebrate@male", anim_name = "idle_m04", name = "Male Pose 41"},
    {anim_dict = "script_mp@photo_studio@celebrate@male", anim_name = "idle_m05", name = "Male Pose 42"},
    {anim_dict = "script_mp@photo_studio@celebrate@male", anim_name = "idle_m06", name = "Male Pose 43"},
    {anim_dict = "script_mp@photo_studio@celebrate@male", anim_name = "idle_m07", name = "Male Pose 44"},
    {anim_dict = "script_mp@photo_studio@fun@male", anim_name = "idle_m01", name = "Male Pose 45"},
    {anim_dict = "script_mp@photo_studio@fun@male", anim_name = "idle_m02", name = "Male Pose 46"},
    {anim_dict = "script_mp@photo_studio@fun@male", anim_name = "idle_m03", name = "Male Pose 47"},
    {anim_dict = "script_mp@photo_studio@fun@male", anim_name = "idle_m04", name = "Male Pose 48"},
    {anim_dict = "script_mp@photo_studio@fun@male", anim_name = "idle_m05", name = "Male Pose 49"},
    {anim_dict = "script_mp@photo_studio@fun@male", anim_name = "idle_m06", name = "Male Pose 50"},
    {anim_dict = "script_mp@photo_studio@fun@male", anim_name = "idle_m07", name = "Male Pose 51"},
    {anim_dict = "script_mp@photo_studio@dog@male", anim_name = "idle_m01", name = "Male Pose 52"},
    {anim_dict = "script_mp@photo_studio@dog@male", anim_name = "idle_m02", name = "Male Pose 53"},
    {anim_dict = "script_mp@photo_studio@dog@male", anim_name = "idle_m03", name = "Male Pose 54"},
    {anim_dict = "script_mp@photo_studio@dog@male", anim_name = "idle_m04", name = "Male Pose 55"},
    {anim_dict = "script_mp@photo_studio@dog@male", anim_name = "idle_m05", name = "Male Pose 56"},
    {anim_dict = "script_mp@photo_studio@dog@male", anim_name = "idle_m06", name = "Male Pose 57"},
    {anim_dict = "script_mp@photo_studio@shoot_rifle", anim_name = "idle_f02", name = "Male Pose 58"},
    {anim_dict = "script_mp@photo_studio@shoot_rifle", anim_name = "idle_f03", name = "Male Pose 59"},
    {anim_dict = "script_mp@photo_studio@shoot_rifle", anim_name = "idle_f04", name = "Male Pose 60"},
    {anim_dict = "script_mp@photo_studio@shoot_rifle", anim_name = "idle_f05", name = "Male Pose 61"},
    {anim_dict = "script_mp@photo_studio@shoot_rifle", anim_name = "idle_f06", name = "Male Pose 62"},
    {anim_dict = "script_mp@photo_studio@shoot_rifle", anim_name = "idle_f07", name = "Male Pose 63"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_m01", name = "Male Pose 64"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_m02", name = "Male Pose 65"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_m03", name = "Male Pose 66"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_m04", name = "Male Pose 67"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_m05", name = "Male Pose 68"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_m06", name = "Male Pose 69"},
    {anim_dict = "script_mp@photo_studio@vformation", anim_name = "idle_m07", name = "Male Pose 70"},
    {anim_dict = "mp_lobby@standard@crouching@mp_male_a@active_look", anim_name = "active_look", name = "Male Sitting Pose 1"},
    {anim_dict = "mp_lobby@standard@crouching@mp_male_b@active_look", anim_name = "active_look", name = "Male Sitting Pose 2"},
    {anim_dict = "mp_lobby@standard@seated@mp_male_a@active_look", anim_name = "active_look", name = "Male Sitting Pose 3"},
    {anim_dict = "mp_lobby@standard@seated@mp_male_b@active_look", anim_name = "active_look", name = "Male Sitting Pose 4"},
    {anim_dict = "mp_lobby@standard@seated@mp_male_c@active_look", anim_name = "active_look", name = "Male Sitting Pose 5"},
    {anim_dict = "mp_lobby@standard@seated@mp_male_d@active_look", anim_name = "active_look", name = "Male Sitting Pose 6"},
    {anim_dict = "mp_lobby@standard@seated@mp_male_e@active_look", anim_name = "active_look", name = "Male Sitting Pose 7"},
    {anim_dict = "mp_lobby@standard@seated@mp_male_f@active_look", anim_name = "active_look", name = "Male Sitting Pose 8"},
    {anim_dict = "script_mp@photo_studio@dog@male", anim_name = "idle_m07", name = "Male Sitting Pose 9"},
    {anim_dict = "amb_rest_lean@world_human_lean@bar@read_newspaper@male_d@idle_a", anim_name = "idle_c", name = "Lean on Bar 1"},
    {anim_dict = "amb_rest_lean@world_human_lean@bar@read_newspaper@male_d@idle_b", anim_name = "idle_f", name = "Lean on Bar 2"},
    {anim_dict = "amb_rest_lean@world_human_lean@bar@read_newspaper@male_d@idle_b", anim_name = "idle_d", name = "Lean on Bar 3"},
    {anim_dict = "amb_rest_lean@world_human_lean@bar@read_newspaper@male_d@idle_b", anim_name = "idle_e", name = "Lean on Bar 4"},
    {anim_dict = "amb_rest_lean@world_human_lean@bar@read_newspaper@male_d@idle_c", anim_name = "idle_h", name = "Lean on Bar 5"},
    {anim_dict = "amb_rest_lean@world_human_lean@bar@read_newspaper@male_d@idle_c", anim_name = "idle_g", name = "Lean on Bar 6"},
    {anim_dict = "script_common@shared_scenarios@stand@bar@lean_2_hands@male_a@idle_a", anim_name = "idle_a", name = "Lean on Bar 7"},
    {anim_dict = "amb_rest_lean@world_human_lean@barrel@read_newspaper@male_a@idle_a", anim_name = "idle_b", name = "Lean back on Bar 1"},
    {anim_dict = "amb_rest_lean@world_human_lean@barrel@read_newspaper@male_a@idle_a", anim_name = "idle_a", name = "Lean back on Bar 2"},
    {anim_dict = "amb_rest_lean@world_human_lean@barrel@read_newspaper@male_a@idle_a", anim_name = "idle_c", name = "Lean back on Bar 3"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@left@hand_planted@male_b@idle_a", anim_name = "idle_b", name = "Lean Post Left Male 1"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@left@male_a@idle_a", anim_name = "idle_c", name = "Lean Post Left Male 2"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@left@male_a@idle_a", anim_name = "idle_a", name = "Lean Post Left Male 3"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@left@male_a@idle_a", anim_name = "idle_b", name = "Lean Post Left Male 4"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@right@hand_planted@male_b@idle_a", anim_name = "idle_b", name = "Lean Post Right Male 1"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@right@hand_planted@male_b@idle_a", anim_name = "idle_c", name = "Lean Post Right Male 2"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@right@male_a@idle_a", anim_name = "idle_a", name = "Lean Post Right Male 3"},
    {anim_dict = "amb_rest_lean@world_human_lean@railing@male_a@idle_a", anim_name = "idle_b", name = "Lean Railing Male 1"},
    {anim_dict = "amb_rest_lean@world_human_lean@railing@male_b@idle_a", anim_name = "idle_a", name = "Lean Railing Male 2"},
    {anim_dict = "amb_rest_lean@world_human_lean@railing@male_c@idle_a", anim_name = "idle_a", name = "Lean Railing Male 3"},
    {anim_dict = "amb_rest_lean@world_human_lean@railing@male_d@idle_a", anim_name = "idle_b", name = "Lean Railing Male 4"},
    {anim_dict = "amb_rest_lean@world_human_lean_rail@male_a@lean@base", anim_name = "base", name = "Lean Railing Male 5"},
    {anim_dict = "amb_rest_lean@world_human_lean@wall@male_a@idle_a", anim_name = "idle_a", name = "Lean Wall Male 1"},
    {anim_dict = "amb_rest_lean@world_human_lean@wall@male_b@base", anim_name = "base", name = "Lean Wall Male 2"},
    {anim_dict = "amb_rest_lean@world_human_lean@wall@male_c@idle_a", anim_name = "idle_b", name = "Lean Wall Male 3"},
    {anim_dict = "amb_rest_lean@world_human_lean@wall@male_d@idle_a", anim_name = "idle_b", name = "Lean Wall Male 4"},
    {anim_dict = "amb_rest_lean@world_human_lean@wall@right@male_b@idle_a", anim_name = "idle_c", name = "Lean Wall Male 5"},
    {anim_dict = "amb_rest_lean@world_human_lean_window_left@male@base", anim_name = "base", name = "Lean Window Left Male 1"},
    {anim_dict = "amb_rest_lean@world_human_lean_window_left@male@idle_a", anim_name = "idle_a", name = "Lean Window Left Male 2"},
    {anim_dict = "amb_rest_lean@world_human_lean_window_right@male@base", anim_name = "base", name = "Lean Window Left Male 3"},
    {anim_dict = "amb_rest_lean@world_human_lean_window_right@male@idle_a", anim_name = "idle_a", name = "Lean Window Left Male 4"},
    {anim_dict = "amb_rest_lean@world_human_lean_fence_fwd_check_out_livestock@male_e@idle_a", anim_name = "idle_a", name = "Lean Fence Male 1"},
    {anim_dict = "amb_rest_lean@world_human_lean_fence_fwd_check_out_livestock@male_f@idle_a", anim_name = "idle_b", name = "Lean Fence Male 2"},
    
    -- Misc
    {anim_dict = "script_re@town_burial@preacher@pose_d@base", anim_name = "base", name = "Standing in silence"},
    {anim_dict = "script_amb@stores@store_lean_shopkeeper_b", anim_name = "impatient_react_a", name = "Shopkeeper Impatient A"},
    {anim_dict = "script_amb@stores@store_lean_shopkeeper_b", anim_name = "impatient_react_b", name = "Shopkeeper Impatient B"},
    {anim_dict = "script_amb@stores@store_lean_shopkeeper_b", anim_name = "base", name = "Shopkeeper Idle"},
    {anim_dict = "amb_misc@world_human_pee@male_a@idle_a", anim_name = "idle_a", name = "Pee"},
    {anim_dict = "script_common@shared_scenarios@kneel@mourn@female@a@react_look@loop@low", anim_name = "right", name = "Kneeling Head Turn Right"},
    {anim_dict = "script_common@shared_scenarios@kneel@mourn@female@a@react_look@loop@high", anim_name = "left", name = "Kneeling Head Turn Left"},
    {anim_dict = "script_rc@abi3@ig@stage_01@ig2_photopose", anim_name = "pose_c_idle_abigailroberts", name = "Abigail Photo"},
    {anim_dict = "script_rc@abi3@ig@stage_01@ig2_photopose", anim_name = "pose_b_idle_abigailroberts", name = "Abigail Photo 2"},
    {anim_dict = "script_re@grave_robbers@male_a@pose2@react_look@loop@generic", anim_name = "react_look_backright_loop", name = "Look Back Right"},
    {anim_dict = "script_re@grave_robbers@male_a@pose2@react_look@loop@generic", anim_name = "react_look_backleft_loop", name = "Look Back Left"},
    {anim_dict = "cnv_camp@rchso@cnv@ccswn16", anim_name = "uncle_action_a", name = "Eepy Girl"},
    {anim_dict = "amb_camp@world_camp_dynamic_fire@logholdlarge@male_a@react_look@loop@generic", anim_name = "react_look_right_loop", name = "Picking Flower"},
    {anim_dict = "script_shows@cancandance@p1", anim_name = "cancandance_fem0", name = "CanCan P1 Fem Dance 1"},
    {anim_dict = "script_shows@cancandance@p1", anim_name = "cancandance_fem1", name = "CanCan P1 Fem Dance 2"},
    {anim_dict = "script_shows@cancandance@p1", anim_name = "cancandance_fem2", name = "CanCan P1 Fem Dance 3"},
    {anim_dict = "script_shows@cancandance@p1", anim_name = "cancandance_fem3", name = "CanCan P1 Fem Dance 4"},
    {anim_dict = "script_shows@cancandance@p2", anim_name = "cancandance_p2_fem1", name = "CanCan P2 Fem Dance 1"},
    {anim_dict = "script_shows@cancandance@p2", anim_name = "cancandance_p2_fem0", name = "CanCan P2 Fem Dance 2"},
    {anim_dict = "script_shows@cancandance@p2", anim_name = "cancandance_p2_fem2", name = "CanCan P2 Fem Dance 3"},
    {anim_dict = "script_shows@cancandance@p2", anim_name = "cancandance_p2_fem3", name = "CanCan P2 Fem Dance 4"},
    {anim_dict = "script_shows@cancandance@p2", anim_name = "cancandance_p2_fem4", name = "CanCan P2 Fem Dance 5"},
    {anim_dict = "script_shows@cancandance@p1", anim_name = "cancandance_male", name = "CanCan P1 Male Dance"},
    {anim_dict = "script_shows@cancandance@p2", anim_name = "cancandance_p2_male", name = "CanCan P2 Male Dance"},
    {anim_dict = "script_shows@firedancer@act3_p1", anim_name = "dance", name = "Fire Dance"},
    {anim_dict = "script_shows@snakedancer@act1_p1", anim_name = "dance_dancer", name = "Snake Dancer 1"},
    {anim_dict = "script_shows@snakedancer@act1_p1", anim_name = "kiss_win_dancer", name = "Snake Dancer 2"},
    {anim_dict = "script_shows@snakedancer@act2_p1", anim_name = "dance_dancer", name = "Snake Dancer 3"},
    {anim_dict = "script_shows@sworddance@act3_p1", anim_name = "dancer_sworddance", name = "Sword Dance"},
    {anim_dict = "amb_misc@world_human_dancing@female_a@base", anim_name = "base", name = "Dance Female Base"},
    {anim_dict = "amb_misc@world_human_dancing@female_a@idle_a", anim_name = "idle_a", name = "Female Dance Idle A"},
    {anim_dict = "amb_misc@world_human_dancing@female_a@idle_a", anim_name = "idle_b", name = "Female Dance Idle B"},
    {anim_dict = "amb_misc@world_human_dancing@female_a@idle_a", anim_name = "idle_c", name = "Female Dance Idle C"},
    {anim_dict = "amb_misc@world_human_dancing@female_a@idle_b", anim_name = "idle_d", name = "Female Dance Idle D"},
    {anim_dict = "amb_misc@world_human_dancing@female_a@idle_b", anim_name = "idle_e", name = "Female Dance Idle E"},
    {anim_dict = "amb_misc@world_human_dancing@female_a@idle_b", anim_name = "idle_f", name = "Female Dance Idle F"},
    {anim_dict = "amb_misc@world_human_dancing@female_a@idle_c", anim_name = "idle_g", name = "Female Dance Idle G"},
    {anim_dict = "amb_misc@world_human_dancing@female_a@idle_c", anim_name = "idle_h", name = "Female Dance Idle H"},
    {anim_dict = "amb_misc@world_human_drunk_dancing@female@base", anim_name = "base", name = "Drunk Dance Female Base"},
    {anim_dict = "amb_misc@world_human_drunk_dancing@male@base", anim_name = "base", name = "Drunk Dance Male Base"},
    {anim_dict = "amb_misc@world_human_drunk_dancing@male@male_a@idle_a", anim_name = "idle_b", name = "Drunk Dance Male Idle B"},
    {anim_dict = "amb_misc@world_human_drunk_dancing@male@male_a@idle_a", anim_name = "idle_a", name = "Drunk Dance Male Idle A"},
    {anim_dict = "amb_misc@world_human_drunk_dancing@male@male_a@idle_a", anim_name = "idle_c", name = "Drunk Dance Male Idle C"},
    {anim_dict = "amb_misc@world_human_drunk_dancing@male@male_a@idle_b", anim_name = "idle_f", name = "Drunk Dance Male Idle F"},
    {anim_dict = "amb_misc@world_human_drunk_dancing@male@male_a@idle_b", anim_name = "idle_e", name = "Drunk Dance Male Idle E"},
    {anim_dict = "amb_misc@world_human_drunk_dancing@male@male_a@idle_b", anim_name = "idle_d", name = "Drunk Dance Male Idle D"},
    {anim_dict = "amb_misc@world_human_drunk_dancing@male@male_b@idle_a", anim_name = "idle_a", name = "Drunk Dance Male B Idle A"},
    {anim_dict = "amb_misc@world_human_drunk_dancing@male@male_b@idle_a", anim_name = "idle_b", name = "Drunk Dance Male B Idle B"},
    {anim_dict = "amb_misc@world_human_drunk_dancing@male@male_b@idle_a", anim_name = "idle_c", name = "Drunk Dance Male B Idle C"},
    {anim_dict = "amb_misc@world_human_drunk_dancing@male@male_b@idle_b", anim_name = "idle_e", name = "Drunk Dance Male B Idle E"},
    {anim_dict = "amb_misc@world_human_drunk_dancing@male@male_b@idle_b", anim_name = "idle_d", name = "Drunk Dance Male B Idle D"},
}

local emotes = {
    {emote_hash = 0x39C68938, name = "Flip Off"},
    {emote_hash = 0xA25C7339, name = "Crazy"},
    {emote_hash = 0x910C8F72, name = "Air Banjo"},
    {emote_hash = 0x7FC09D55, name = "Beckon"},
    {emote_hash = 0x17AA1FFF, name = "Biting Gold Coin"},
    {emote_hash = 0x72E36635, name = "Blow Kiss"},
    {emote_hash = 0xB55EEAF3, name = "Boast"},
    {emote_hash = 0xE953BBB7, name = "Check Pocket Watch"},
    {emote_hash = 0xD833963E, name = "Coin Flip"},
    {emote_hash = 0xFFF9D9F1, name = "Fist Pump"},
    {emote_hash = 0xD1DE4D57, name = "Flex"},
    {emote_hash = 0x427B55FF, name = "Follow Me"},
    {emote_hash = 0x2F7D0AAE, name = "Hissyfit"},
    {emote_hash = 0x344F2AAD, name = "Howl"},
    {emote_hash = 0xCC2CC3AC, name = "Hypnosis Pocket Watch"},
    {emote_hash = 0xEEC55CB7, name = "Idea"},
    {emote_hash = 0xE73CA11A, name = "Let's Craft"},
    {emote_hash = 0x451FDE80, name = "Let's Fish"},
    {emote_hash = 0x5EFEBD3B, name = "Let's Go"},
    {emote_hash = 0xCDB9A85C, name = "Let's Play Cards"},
    {emote_hash = 0x37BD5D0E, name = "Look Distance"},
    {emote_hash = 0x0078D3CC, name = "Look Yonder"},
    {emote_hash = 0xC932823C, name = "New Threads"},
    {emote_hash = 0x1CFB34E2, name = "Point"},
    {emote_hash = 0x1C46EA2F, name = "Posse Up"},
    {emote_hash = 0x325069E6, name = "Prayer"},
    {emote_hash = 0x4DF1E20B, name = "Prospector Jig"},
    {emote_hash = 0xB755B5B1, name = "Rock Paper Scissors"},
    {emote_hash = 0x2322C484, name = "Scheme"},
    {emote_hash = 0x9E47E124, name = "Shoot Hip"},
    {emote_hash = 0x7396A2DE, name = "Skyward Shooting"},
    {emote_hash = 0x81615BA3, name = "Smoke Cigar"},
    {emote_hash = 0x8B7F8EEB, name = "Smoke Cigarette"},
    {emote_hash = 0x65147D0F, name = "Snot Rocket"},
    {emote_hash = 0x3AE9C12A, name = "Spin and Aim"},
    {emote_hash = 0x826DB95A, name = "Spit"},
    {emote_hash = 0xD0528D38, name = "Spooky"},
    {emote_hash = 0x9B31C214, name = "Stop Here"},
    {emote_hash = 0xBA51B111, name = "Take Notes"},
    {emote_hash = 0xA3B3C49B, name = "Wet Your Whistle"},
    {emote_hash = 0xEE810879, name = "Dance Awkward A"},
    {emote_hash = 0xF0AF179A, name = "Dance Carefree A"},
    {emote_hash = 0xDA4651B5, name = "Dance Carefree B"},
    {emote_hash = 0xF504A733, name = "Dance Confident A"},
    {emote_hash = 0xFED34C73, name = "Dance Confident B"},
    {emote_hash = 0x9548C407, name = "Dance Drunk A"},
    {emote_hash = 0x3E32E670, name = "Dance Drunk B"},
    {emote_hash = 0x6FBDDC68, name = "Dance Formal A"},
    {emote_hash = 0x847214D2, name = "Dance Graceful A"},
    {emote_hash = 0xCFC7AEBA, name = "Dance Old A"},
    {emote_hash = 0x0CF840A9, name = "Dance Wild A"},
    {emote_hash = 0x43F71CA8, name = "Dance Wild B"},
    {emote_hash = 0x8186AA35, name = "Fancy Bow"},
    {emote_hash = 0x4F3E0424, name = "Flying Kiss"},
    {emote_hash = 0x35B5A903, name = "Gentle Wave"},
    {emote_hash = 0x9CA62011, name = "Get Over Here"},
    {emote_hash = 0x1F3549C4, name = "Glad"},
    {emote_hash = 0x6A662B8A, name = "Hand Shake"},
    {emote_hash = 0xE18A99A1, name = "Hat Flick"},
    {emote_hash = 0xA927A00F, name = "Hat Tip"},
    {emote_hash = 0x3196F0E3, name = "Hey You"},
    {emote_hash = 0xE68763B3, name = "Outpour"},
    {emote_hash = 0x949C021C, name = "Respectful Bow"},
    {emote_hash = 0x3CB5E70E, name = "Seven"},
    {emote_hash = 0xA38D1E64, name = "Subtle Wave"},
    {emote_hash = 0xE4746943, name = "Tada"},
    {emote_hash = 0x1960746B, name = "Thumbsup"},
    {emote_hash = 0x700DD5CB, name = "Tough"},
    {emote_hash = 0xEBC75584, name = "Wave Near"},
    {emote_hash = 0xFD1A80D5, name = "Amazed"},
    {emote_hash = 0xF2D01E20, name = "Applause"},
    {emote_hash = 0x09D39270, name = "Beg Mercy"},
    {emote_hash = 0xC84FB6B6, name = "Clap Along"},
    {emote_hash = 0xAD799324, name = "Facepalm"},
    {emote_hash = 0xFB4C77D3, name = "Hangover"},
    {emote_hash = 0x6B6D921F, name = "How Dare You"},
    {emote_hash = 0xBD4EC3FB, name = "Vomit"},
    {emote_hash = 0x9DF6FD3F, name = "Hush Your Mouth"},
    {emote_hash = 0x11B0F575, name = "Jovial Laugh"},
    {emote_hash = 0xCEF7AA76, name = "Nod Head"},
    {emote_hash = 0xAEC37CFB, name = "Phew"},
    {emote_hash = 0x2FDFF3B2, name = "Point Laugh"},
    {emote_hash = 0xB1C3DE80, name = "Scared"},
    {emote_hash = 0xD91245C6, name = "Shake Head"},
    {emote_hash = 0xF96C2623, name = "Shot"},
    {emote_hash = 0x2E097BB5, name = "Shrug"},
    {emote_hash = 0xC4610D39, name = "Shuffle"},
    {emote_hash = 0x3D04F806, name = "Slow Clap"},
    {emote_hash = 0xAFF1D9B3, name = "Sniffing"},
    {emote_hash = 0x04D94578, name = "Sob"},
    {emote_hash = 0xC303F8C3, name = "Surrender"},
    {emote_hash = 0x7FCB989C, name = "Thanks"},
    {emote_hash = 0x2365F9A5, name = "This Guy"},
    {emote_hash = 0x59F420A1, name = "Thumbs Down"},
    {emote_hash = 0xFF45D102, name = "Wag Finger"},
    {emote_hash = 0x13A5C689, name = "Who Me"},
    {emote_hash = 0x1A92F963, name = "Yeehaw"},
    {emote_hash = 0x5E4C76AD, name = "Best Shot"},
    {emote_hash = 0x0EB7A5F2, name = "Boohoo"},
    {emote_hash = 0x6CC9FE53, name = "Chicken"},
    {emote_hash = 0x523DA9D9, name = "Cock Snook"},
    {emote_hash = 0x299BD92F, name = "Cougar Snarl"},
    {emote_hash = 0x1B375028, name = "Cruising Bruising"},
    {emote_hash = 0x203F0CD8, name = "Fiddlehead"},
    {emote_hash = 0xD097AF13, name = "Finger Slinger"},
    {emote_hash = 0xBA4E4740, name = "Frighten"},
    {emote_hash = 0x711D2A1F, name = "Gorilla Chest"},
    {emote_hash = 0xDF036AFF, name = "I'm Watching You"},
    {emote_hash = 0x209BD95E, name = "Small"},
    {emote_hash = 0x5B65DD1D, name = "Provoke"},
    {emote_hash = 0x6C281B79, name = "Ripper"},
    {emote_hash = 0x4AE9E06C, name = "Throat Slit"},
    {emote_hash = 0x15216DE4, name = "Up Yours"},
    {emote_hash = 0x828C7F5B, name = "Versus"},
    {emote_hash = 0x3AD8141A, name = "War Cry"},
    {emote_hash = 0xF6130E04, name = "You Stink"}
}

local scenarios = {
    -- Guard
    {scenario = "WORLD_HUMAN_GUARD_LEAN_WALL", name = "Guard Lean", female = false, male = true},
    {scenario = "WORLD_HUMAN_GUARD_MILITARY", name = "Guard Military", female = false, male = true},
    {scenario = "WORLD_HUMAN_GUARD_SCOUT", name = "Guard Scout", female = true, male = true},
    {scenario = "WORLD_CAMP_LENNY_GUARD_CROUCH_TRACKS", name = "Guard Crouch", female = false, male = true},
    {scenario = "WORLD_CAMP_GUARD_COLD", name = "Guard Cold", female = false, male = true},
    
    -- Leaning
    {scenario = "WORLD_HUMAN_LEAN_WALL_LEFT", name = "Lean Wall Left", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_BACK_WALL", name = "Lean Back Wall", female = true, male = true},
    {scenario = "WORLD_HUMAN_LEAN_BACK_WALL_SMOKING", name = "Lean Back Smoking", female = true, male = false},
    {scenario = "WORLD_HUMAN_LEAN_BACK_RAILING_DRINKING", name = "Lean Back Railing Drink", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_RAILING_SMOKING", name = "Lean Railing Smoke", female = true, male = true},
    {scenario = "WORLD_HUMAN_LEAN_RAILING_NO_PROPS", name = "Lean Railing", female = true, male = true},
    {scenario = "WORLD_HUMAN_LEAN_RAILING_DYNAMIC", name = "Lean Railing Dynamic", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_RAILING_DRINKING", name = "Lean Railing Drinking", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_POST_RIGHT", name = "Lean Post Right", female = true, male = true},
    {scenario = "WORLD_HUMAN_LEAN_POST_LEFT", name = "Lean Post Left", female = true, male = true},
    {scenario = "WORLD_HUMAN_LEAN_TABLE_SHARPEN_KNIFE", name = "Lean Table Sharpen Knife", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_CHECK_PISTOL", name = "Lean Check Pistol", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_BARREL", name = "Lean Barrel", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_BACK_WHITTLE", name = "Lean Back Whittle", female = false, male = true},

    -- Sitting
    {scenario = "WORLD_HUMAN_SEAT_LEDGE", name = "Seat Ledge", female = true, male = true},
    {scenario = "MP_LOBBY_PROP_HUMAN_SEAT_BENCH_PORCH_DRINKING", name = "Seat Bench Drinking", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_PORCH_DRINKING_MOONSHINE", name = "Seat Bench Drinking Moonshine", female = false, male = true},
    {scenario = "MP_LOBBY_PROP_HUMAN_SEAT_BENCH_PORCH_SMOKING", name = "Seat Bench Smoking", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH", name = "Seat Bench", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_BACK", name = "Bench Back", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_TIRED", name = "Seat Bench Tired", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_TIRED_SHAKY", name = "Seat Bench Tired Shaky", female = false, male = true},
    {scenario = "SC_CAMP_VIG_SORE_JOINTS_MALE", name = "Seat Bench Fire", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_CONCERTINA", name = "Seat Bench Accordion", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_CONCERTINA_DOWNBEAT", name = "Seat Bench Accordion Downbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_CONCERTINA_UPBEAT", name = "Seat Bench Accordion Upbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_HARMONICA", name = "Seat Bench Harmonica", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_HARMONICA_DOWNBEAT", name = "Seat Bench Harmonica Downbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_HARMONICA_UPBEAT", name = "Seat Bench Harmonica Upbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_JAW_HARP", name = "Seat Bench Jaw Harp", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_JAW_HARP_DOWNBEAT", name = "Seat Bench Jaw Harp Downbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_JAW_HARP_UPBEAT", name = "Seat Bench Jaw Harp Upbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_MANDOLIN", name = "Seat Bench Mandolin", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_GUITAR", name = "Guitar Seat Chair", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_FAN", name = "Seat Chair Fan", female = true, male = false},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_READING", name = "Seat Chair Read", female = true, male = false},
    {scenario = "MP_LOBBY_PROP_HUMAN_SEAT_CHAIR", name = "Seat Chair", female = true, male = true},
    {scenario = "MP_LOBBY_PROP_HUMAN_SEAT_CHAIR_KNIFE_BADASS", name = "Seat Chair Knife Badass", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_SHARPEN_KNIFE_GUS", name = "Seat Chair Sharpen Knife", female = false, male = true},
    {scenario = "MP_LOBBY_PROP_HUMAN_SEAT_CHAIR_WHITTLE", name = "Seat Chair Whittle", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_CIGAR", name = "Seat Chair Cigar", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_SMOKING", name = "Seat Chair Smoking", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_CLEAN_SADDLE", name = "Chair Clean Saddle", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_DRINKING_MOONSHINE", name = "Chair Moonshine", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_FISHING_ROD", name = "Chair Fishing Rod", female = false, male = true},
    {scenario = "PROP_CAMP_JAVIER_SEAT_CHAIR_CRICKETS", name = "Chair Crickets", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_SAD", name = "Chair Sad", female = true, male = false},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_SKETCHING", name = "Chair Sketching", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_SKETCHING_HARRIET", name = "Chair Harriet Sketching", female = true, male = false},
    {scenario = "PROP_CAMP_JACK_ES_READ_SEAT", name = "Read Seat", female = true, male = true},
    {scenario = "WORLD_HUMAN_SIT_GROUND_READING", name = "Read Ground", female = true, male = true},
    {scenario = "WORLD_CAMP_SIT_GROUND_STEW_LAZY", name = "Stew Ground", female = false, male = true},
    {scenario = "WORLD_HUMAN_CANNED_FOOD_COOKING", name = "Ground Cooking Food", female = false, male = true},
    {scenario = "PROP_CAMP_JAVIER_SEAT_CRATE_BRUSH_HAT", name = "Seat Brush Hat", female = false, male = true},
    {scenario = "PROP_CAMP_MICAH_SEAT_CHAIR_CLEAN_GUN", name = "Seat Clean Pistol", female = false, male = true},
    {scenario = "PROP_CAMP_SEAT_CHAIR_CRAFT_POISON_KNIVES", name = "Seat Chair Craft Poison Knives", female = false, male = true},
    {scenario = "PROP_HUMAN_CAMP_FIRE_SEAT_BOX", name = "Campfire Seat Box", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_BANJO", name = "Banjo", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_BANJO_DOWNBEAT", name = "Banjo Downbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_BANJO_UPBEAT", name = "Banjo Upbeat", female = false, male = true},
    {scenario = "WORLD_HUMAN_SIT_GUITAR", name = "Guitar", female = false, male = true},
    {scenario = "WORLD_HUMAN_SIT_GUITAR_DOWNBEAT", name = "Guitar Downbeat", female = false, male = true},
    {scenario = "WORLD_HUMAN_SIT_GUITAR_UPBEAT", name = "Guitar Upbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CRATE_CLEAN_BOOTS", name = "Seat Clean Boots", female = false, male = true},

    -- Standing
    {scenario = "WORLD_HUMAN_FIRE_STAND", name = "Stand Fire", female = true, male = true},
    {scenario = "WORLD_HUMAN_BADASS", name = "Stand Badass", female = false, male = true},
    {scenario = "WORLD_CAMP_FIRE_STANDING", name = "Stand Smoking", female = false, male = true},
    {scenario = "WORLD_HUMAN_FAN", name = "Stand Fan", female = true, male = false},
    {scenario = "WORLD_CAMP_DUTCH_SMOKE_CIGAR", name = "Stand Cigar", female = false, male = true},
    {scenario = "WORLD_CAMP_DUTCH_SMOKE_CIGAR_GUS", name = "Stand Cigar Fancy", female = false, male = true},
    {scenario = "WORLD_HUMAN_COFFEE_DRINK", name = "Stand Coffee", female = true, male = true},
    {scenario = "WORLD_HUMAN_WRITE_NOTEBOOK", name = "Stand Notebook", female = true, male = true},
    {scenario = "WORLD_HUMAN_CLIPBOARD", name = "Stand ClipBoard", female = false, male = true},
    {scenario = "WORLD_HUMAN_WAITING_IMPATIENT", name = "Stand Waiting", female = true, male = true},
    {scenario = "WORLD_HUMAN_DRINKING", name = "Stand Drinking", female = true, male = true},
    {scenario = "WORLD_HUMAN_DRINKING_MOONSHINE", name = "Stand Drinking Moonshine", female = true, male = true},
    {scenario = "WORLD_HUMAN_DRINK_FLASK", name = "Drink Flask", female = false, male = true},
    {scenario = "WORLD_HUMAN_DRINK_CHAMPAGNE", name = "Drink Champagne", female = true, male = true},
    {scenario = "WORLD_HUMAN_POCKET_MIRROR", name = "Pocket Mirror", female = true, male = false},
    {scenario = "WORLD_HUMAN_DRINKING_DRUNK", name = "Drinking Drunk", female = false, male = true},
    {scenario = "WORLD_HUMAN_DRINKING_DRUNK_MOONSHINE", name = "Drinking Moonshine Drunk", female = false, male = true},
    {scenario = "WORLD_HUMAN_VOMIT", name = "Vomit", female = false, male = true},
    {scenario = "WORLD_HUMAN_VOMIT_KNEEL", name = "Vomit Kneel", female = false, male = true},
    {scenario = "WORLD_HUMAN_STERNGUY_IDLES", name = "Stern Guy idle", female = false, male = true},
    
    -- laying down
    {scenario = "WORLD_CAMP_FIRE_LAY_BACK_GROUND", name = "Lay Back", female = false, male = true},
    {scenario = "WORLD_CAMP_FIRE_LAY_GROUND_SIDE", name = "Lay Side", female = true, male = true},

    -- Some Instruments
    {scenario = "PROP_HUMAN_PIANO", name = "Piano", female = false, male = true},
    {scenario = "PROP_HUMAN_PIANO_RIVERBOAT", name = "Piano Riverboat", female = false, male = true},
    {scenario = "PROP_HUMAN_PIANO_SKETCHY", name = "Piano Sketchy", female = false, male = true},
    {scenario = "PROP_HUMAN_PIANO_UPPERCLASS", name = "Piano UpperClass", female = false, male = true},
    {scenario = "WORLD_HUMAN_TRUMPET", name = "Trumpet", female = false, male = true},
    {scenario = "PROP_HUMAN_ABIGAIL_PIANO", name = "Piano Female", female = true, male = false},
    {scenario = "PROP_HUMAN_SEAT_BENCH_FIDDLE", name = "Fiddle Female", female = true, male = false},

    -- Campfire
    {scenario = "WORLD_CAMP_FIRE_SEATED_GROUND", name = "Fire Sit", female = true, male = true},
    {scenario = "PROP_HUMAN_CAMP_FIRE_SEAT_BOX", name = "Campfire Seat Box", female = true, male = true},
    {scenario = "WORLD_HUMAN_SIT_SMOKE", name = "Sit Smoke", female = true, male = true},
    {scenario = "WORLD_HUMAN_SIT_GROUND_WHITTLE", name = "Sit Ground Whittle", female = false, male = true},
    {scenario = "WORLD_HUMAN_SIT_GROUND_READ_NEWSPAPER", name = "Sit Ground Read Newspaper", female = false, male = true},
    {scenario = "WORLD_HUMAN_SIT_GROUND_COFFEE_DRINK", name = "Sit Ground Coffee Drink", female = true, male = true},
    {scenario = "WORLD_HUMAN_SIT_GROUND", name = "Sit Ground", female = true, male = true},
    {scenario = "WORLD_HUMAN_SIT_DRINK", name = "Sit Ground Drink", female = true, male = true},

    -- Repair
    {scenario = "PROP_HUMAN_REPAIR_WAGON_WHEEL_ON_SMALL", name = "Repair Small Wheel", female = false, male = true},
    {scenario = "PROP_HUMAN_REPAIR_WAGON_WHEEL_ON_LARGE", name = "Repair Large Wheel", female = false, male = true},

    -- Misc
    {scenario = "WORLD_HUMAN_GRAVE_MOURNING", name = "Grave Mourning", female = true, male = true},
    {scenario = "WORLD_HUMAN_GRAVE_MOURNING_KNEEL", name = "Grave Mourning Kneel", female = true, male = true},
    {scenario = "WORLD_CAMP_JACK_SKY", name = "Look at Sky", female = false, male = true},
    {scenario = "WORLD_CAMP_JACK_THROWS_ROCKS_CASUAL", name = "Throwing Rocks", female = false, male = true},
    {scenario = "WORLD_CAMP_JACK_THROWS_ROCKS_LEDGE", name = "Throwing Rocks Ledge", female = false, male = true},
    {scenario = "WORLD_HUMAN_BARTENDER_CLEAN_GLASS", name = "Bartender Clean Glass", female = true, male = true},
    {scenario = "WORLD_HUMAN_SHOPKEEPER", name = "Shopkeeper", female = true, male = true},
    {scenario = "WORLD_CAMP_JAVIER_KNIFE", name = "Knife Game", female = false, male = true},
    {scenario = "WORLD_HUMAN_CROUCH_INSPECT", name = "Crouch Inspect", female = true, male = true},
    {scenario = "WORLD_HUMAN_COFFEE_DRINK_WIP", name = "Drink Coffee", female = true, male = true},
    {scenario = "PROP_HUMAN_SLEEP_BED_PILLOW_HIGH", name = "Sleep", female = false, male = true},
    {scenario = "WORLD_HUMAN_DANCING", name = "Dance", female = true, male = false},
    {scenario = "WORLD_HUMAN_SLEDGEHAMMER", name = "SledgeHammer", female = false, male = true},
}

local animal_animations = {
    {scenario = "WORLD_ANIMAL_BAT_HANGING", name = "Bat Hanging"},
    {scenario = "WORLD_ANIMAL_BAT_HANGING_DEMO", name = "Bat Hanging Demo"},
    {scenario = "WORLD_ANIMAL_CALIFORNIACONDOR_ON_PERCH", name = "California Condor on Perch"},
    {scenario = "WORLD_ANIMAL_CAROLINAPARAKEET_ON_PERCH", name = "Carolina Parakeet on Perch"},
    {scenario = "WORLD_ANIMAL_BIRD_ON_PERCH", name = "Bird on Perch"},
    {scenario = "WORLD_ANIMAL_CHICKEN_RESTING", name = "Chicken Resting"},
    {scenario = "WORLD_ANIMAL_CHICKEN_SLEEPING", name = "Chicken Sleeping"},
    {scenario = "WORLD_ANIMAL_CHICKEN_EATING", name = "Chicken Eating"},
    {scenario = "WORLD_ANIMAL_CHICKEN_EATING_SITTING", name = "Chicken Eating Sitting"},
    {scenario = "WORLD_ANIMAL_CROW_ON_PERCH", name = "Crow on Perch"},
    {scenario = "WORLD_ANIMAL_CROW_EATING_PERCHED", name = "Crow Eating Perched"},
    {scenario = "WORLD_ANIMAL_CROW_DRINK_PERCHED", name = "Crow Drink Perched"},
    {scenario = "WORLD_ANIMAL_CROW_DRINK_GROUND", name = "Crow Drink Ground"},
    {scenario = "WORLD_ANIMAL_CROW_EATING_GROUND", name = "Crow Eating Ground"},
    {scenario = "WORLD_ANIMAL_CROW_EATING_GROUND_FROM_GROUND", name = "Crow Eating Ground from Ground"},
    {scenario = "WORLD_ANIMAL_DUCK_GROUND_RESTING", name = "Duck Ground Resting"},
    {scenario = "WORLD_ANIMAL_EAGLE_DRINK_GROUND", name = "Eagle Drink Ground"},
    {scenario = "WORLD_ANIMAL_EAGLE_EATING_GROUND", name = "Eagle Eating Ground"},
    {scenario = "WORLD_ANIMAL_EAGLE_EATING_GROUND_FROM_GROUND", name = "Eagle Eating Ground from Ground"},
    {scenario = "WORLD_ANIMAL_EAGLE_ON_PERCH", name = "Eagle on Perch"},
    {scenario = "WORLD_ANIMAL_EAGLE_EATING_PERCHED", name = "Eagle Eating Perched"},
    {scenario = "WORLD_ANIMAL_GOOSECANADA_GRAZING", name = "Canada Goose Grazing"},
    {scenario = "WORLD_ANIMAL_GOOSECANADA_RESTING", name = "Canada Goose Resting"},
    {scenario = "WORLD_ANIMAL_HERON_ON_PERCH", name = "Heron on Perch"},
    {scenario = "WORLD_ANIMAL_HERON_RESTING", name = "Heron Resting"},
    {scenario = "WORLD_ANIMAL_HERON_CATCH_FISH", name = "Heron Catch Fish"},
    {scenario = "WORLD_ANIMAL_OWL_DRINK_GROUND", name = "Owl Drink Ground"},
    {scenario = "WORLD_ANIMAL_OWL_EATING_GROUND", name = "Owl Eating Ground"},
    {scenario = "WORLD_ANIMAL_OWL_ON_PERCH", name = "Owl on Perch"},
    {scenario = "WORLD_ANIMAL_OWL_EATING_PERCHED", name = "Owl Eating Perched"},
    {scenario = "WORLD_ANIMAL_PARROT_ON_PERCH", name = "Parrot on Perch"},
    {scenario = "WORLD_ANIMAL_PARROT_ON_GROUND", name = "Parrot on Ground"},
    {scenario = "WORLD_ANIMAL_PELICAN_ON_PERCH", name = "Pelican on Perch"},
    {scenario = "WORLD_ANIMAL_PIGEON_BATHING", name = "Pigeon Bathing"},
    {scenario = "WORLD_ANIMAL_PIGEON_EAT_GROUND", name = "Pigeon Eat Ground"},
    {scenario = "WORLD_ANIMAL_PIGEON_EAT_GROUND_FROM_GROUND", name = "Pigeon Eat Ground from Ground"},
    {scenario = "WORLD_ANIMAL_PIGEON_DRINK_GROUND", name = "Pigeon Drink Ground"},
    {scenario = "WORLD_ANIMAL_PIGEON_EAT_PERCHED", name = "Pigeon Eat Perched"},
    {scenario = "WORLD_ANIMAL_PIGEON_DRINK_PERCHED", name = "Pigeon Drink Perched"},
    {scenario = "WORLD_ANIMAL_PIGEON_ON_PERCH", name = "Pigeon on Perch"},
    {scenario = "WORLD_ANIMAL_QUAIL_GRAZING", name = "Quail Grazing"},
    {scenario = "WORLD_ANIMAL_SEAGULL_EAT_GROUND", name = "Seagull Eat Ground"},
    {scenario = "WORLD_ANIMAL_SEAGULL_EAT_GROUND_FROM_GROUND", name = "Seagull Eat Ground from Ground"},
    {scenario = "WORLD_ANIMAL_SEAGULL_ON_PERCH", name = "Seagull on Perch"},
    {scenario = "WORLD_ANIMAL_SEAGULL_RESTING_GROUND", name = "Seagull Resting Ground"},
    {scenario = "WORLD_ANIMAL_SEAGULL_RESTING_PERCHED", name = "Seagull Resting Perched"},
    {scenario = "WORLD_ANIMAL_ROOSTER_EATING", name = "Rooster Eating"},
    {scenario = "WORLD_ANIMAL_ROOSTER_RESTING", name = "Rooster Resting"},
    {scenario = "WORLD_ANIMAL_SPARROW_DRINK_GROUND", name = "Sparrow Drink Ground"},
    {scenario = "WORLD_ANIMAL_SPARROW_EATING_GROUND", name = "Sparrow Eating Ground"},
    {scenario = "WORLD_ANIMAL_SPARROW_EATING_GROUND_FROM_GROUND", name = "Sparrow Eating Ground from Ground"},
    {scenario = "WORLD_ANIMAL_SPARROW_ON_PERCH", name = "Sparrow on Perch"},
    {scenario = "WORLD_ANIMAL_SPARROW_BATHING", name = "Sparrow Bathing"},
    {scenario = "WORLD_ANIMAL_TURKEY_GRAZING", name = "Turkey Grazing"},
    {scenario = "WORLD_ANIMAL_TURKEY_GRAZING_DOMESTIC", name = "Domestic Turkey Grazing"},
    {scenario = "WORLD_ANIMAL_VULTURE_EATING", name = "Vulture Eating"},
    {scenario = "WORLD_ANIMAL_VULTURE_EATING_FROM_GROUND", name = "Vulture Eating from Ground"},
    {scenario = "WORLD_ANIMAL_VULTURE_ON_PERCH", name = "Vulture on Perch"},
    {scenario = "WORLD_ANIMAL_VULTURE_SUNNING", name = "Vulture Sunning"},
    {scenario = "WORLD_ANIMAL_VULTURE_SUNNING_PERCHED", name = "Vulture Sunning Perched"},
    {scenario = "WORLD_ANIMAL_VULTURE_PREENING", name = "Vulture Preening"},
    {scenario = "WORLD_ANIMAL_WOODPECKER_PECKING_TREE", name = "Woodpecker Pecking Tree"},
    {scenario = "WORLD_ANIMAL_FISH_BREAK_SURFACE", name = "Fish Break Surface"},
    {scenario = "WORLD_ANIMAL_FISH_JUMPING", name = "Fish Jumping"},
    {scenario = "WORLD_ANIMAL_FISH_IDLE", name = "Fish Idle"},
    {scenario = "WORLD_ANIMAL_BADGER_EAT_GROUND", name = "Badger Eat Ground"},
    {scenario = "WORLD_ANIMAL_BEAR_SITTING", name = "Bear Sitting"},
    {scenario = "WORLD_ANIMAL_BEAR_RESTING", name = "Bear Resting"},
    {scenario = "WORLD_ANIMAL_BEAR_FORAGING_GROUND", name = "Bear Foraging Ground"},
    {scenario = "WORLD_ANIMAL_BEAR_SLEEPING", name = "Bear Sleeping"},
    {scenario = "WORLD_ANIMAL_BEAR_SNIFFING_GROUND", name = "Bear Sniffing Ground"},
    {scenario = "WORLD_ANIMAL_BEAR_EAT_CARCASS", name = "Bear Eat Carcass"},
    {scenario = "WORLD_ANIMAL_BEAR_EATING_BERRIES", name = "Bear Eating Berries"},
    {scenario = "WORLD_ANIMAL_BEAR_INJURED_ON_GROUND", name = "Bear Injured on Ground"},
    {scenario = "WORLD_ANIMAL_BEAR_STUNNED_ON_GROUND", name = "Bear Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_BEARBLACK_SNIFFING_GROUND", name = "Black Bear Sniffing Ground"},
    {scenario = "WORLD_ANIMAL_BEARBLACK_SLEEPING", name = "Black Bear Sleeping"},
    {scenario = "WORLD_ANIMAL_BEARBLACK_RESTING", name = "Black Bear Resting"},
    {scenario = "WORLD_ANIMAL_BEARBLACK_SITTING", name = "Black Bear Sitting"},
    {scenario = "WORLD_ANIMAL_BEARBLACK_EATING_BERRIES", name = "Black Bear Eating Berries"},
    {scenario = "WORLD_ANIMAL_BEARBLACK_EAT_CARCASS", name = "Black Bear Eat Carcass"},
    {scenario = "WORLD_ANIMAL_BEARBLACK_INJURED_ON_GROUND", name = "Black Bear Injured on Ground"},
    {scenario = "WORLD_ANIMAL_BEARBLACK_STUNNED_ON_GROUND", name = "Black Bear Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_BEARBLACK_FORAGING_GROUND", name = "Black Bear Foraging Ground"},
    {scenario = "WORLD_ANIMAL_BEAVER_EATING", name = "Beaver Eating"},
    {scenario = "WORLD_ANIMAL_BEAVER_EAT_TREE", name = "Beaver Eat Tree"},
    {scenario = "WORLD_ANIMAL_BIG_CAT_DRINKING", name = "Big Cat Drinking"},
    {scenario = "WORLD_ANIMAL_BIG_CAT_EATING", name = "Big Cat Eating"},
    {scenario = "WORLD_ANIMAL_BIG_CAT_INJURED_ON_GROUND", name = "Big Cat Injured on Ground"},
    {scenario = "WORLD_ANIMAL_BIG_CAT_STUNNED_ON_GROUND", name = "Big Cat Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_BIG_CAT_RESTING", name = "Big Cat Resting"},
    {scenario = "WORLD_ANIMAL_BIG_CAT_SLEEPING", name = "Big Cat Sleeping"},
    {scenario = "WORLD_ANIMAL_BOAR_GRAZING", name = "Boar Grazing"},
    {scenario = "WORLD_ANIMAL_BOAR_DRINK_GROUND", name = "Boar Drink Ground"},
    {scenario = "WORLD_ANIMAL_BOAR_EAT_CARCASS", name = "Boar Eat Carcass"},
    {scenario = "WORLD_ANIMAL_BOAR_SITTING", name = "Boar Sitting"},
    {scenario = "WORLD_ANIMAL_BOAR_RESTING", name = "Boar Resting"},
    {scenario = "WORLD_ANIMAL_BOAR_INJURED_ON_GROUND", name = "Boar Injured on Ground"},
    {scenario = "WORLD_ANIMAL_BOAR_STUNNED_ON_GROUND", name = "Boar Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_BOAR_SLEEPING", name = "Boar Sleeping"},
    {scenario = "WORLD_ANIMAL_BUCK_INJURED_ON_GROUND", name = "Buck Injured on Ground"},
    {scenario = "WORLD_ANIMAL_BUFFALO_WALLOW", name = "Buffalo Wallow"},
    {scenario = "WORLD_ANIMAL_BUFFALO_RESTING", name = "Buffalo Resting"},
    {scenario = "WORLD_ANIMAL_BUFFALO_GRAZING", name = "Buffalo Grazing"},
    {scenario = "WORLD_ANIMAL_BUFFALO_DRINKING", name = "Buffalo Drinking"},
    {scenario = "WORLD_ANIMAL_BUFFALO_INJURED_ON_GROUND", name = "Buffalo Injured on Ground"},
    {scenario = "WORLD_ANIMAL_BUFFALO_STUNNED_ON_GROUND", name = "Buffalo Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_BULL_DRINK_GROUND", name = "Bull Drink Ground"},
    {scenario = "WORLD_ANIMAL_BULL_GRAZING", name = "Bull Grazing"},
    {scenario = "WORLD_ANIMAL_BULL_INJURED_ON_GROUND", name = "Bull Injured on Ground"},
    {scenario = "WORLD_ANIMAL_BULL_STUNNED_ON_GROUND", name = "Bull Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_BULL_RESTING", name = "Bull Resting"},
    {scenario = "WORLD_ANIMAL_BULL_SLEEPING", name = "Bull Sleeping"},
    {scenario = "WORLD_ANIMAL_CAT_CLAW_SHARPEN", name = "Cat Claw Sharpen"},
    {scenario = "WORLD_ANIMAL_CAT_DRINKING", name = "Cat Drinking"},
    {scenario = "WORLD_ANIMAL_CAT_EATING", name = "Cat Eating"},
    {scenario = "WORLD_ANIMAL_CAT_RESTING", name = "Cat Resting"},
    {scenario = "WORLD_ANIMAL_CAT_SITTING", name = "Cat Sitting"},
    {scenario = "WORLD_ANIMAL_CAT_SLEEPING", name = "Cat Sleeping"},
    {scenario = "WORLD_ANIMAL_COW_DRINK_GROUND", name = "Cow Drink Ground"},
    {scenario = "WORLD_ANIMAL_COW_DRINK_TROUGH", name = "Cow Drink Trough"},
    {scenario = "WORLD_ANIMAL_COW_INJURED_ON_GROUND", name = "Cow Injured on Ground"},
    {scenario = "WORLD_ANIMAL_COW_STUNNED_ON_GROUND", name = "Cow Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_COW_RESTING", name = "Cow Resting"},
    {scenario = "WORLD_ANIMAL_COW_SLEEPING", name = "Cow Sleeping"},
    {scenario = "WORLD_ANIMAL_COW_GRAZING", name = "Cow Grazing"},
    {scenario = "WORLD_ANIMAL_COYOTE_EATING_GROUND", name = "Coyote Eating Ground"},
    {scenario = "WORLD_ANIMAL_COYOTE_DRINK_GROUND", name = "Coyote Drink Ground"},
    {scenario = "WORLD_ANIMAL_COYOTE_INJURED_ON_GROUND", name = "Coyote Injured on Ground"},
    {scenario = "WORLD_ANIMAL_COYOTE_RESTING", name = "Coyote Resting"},
    {scenario = "WORLD_ANIMAL_COYOTE_SLEEPING", name = "Coyote Sleeping"},
    {scenario = "WORLD_ANIMAL_COYOTE_SNIFFING_GROUND", name = "Coyote Sniffing Ground"},
    {scenario = "WORLD_ANIMAL_COYOTE_DIGGING", name = "Coyote Digging"},
    {scenario = "WORLD_ANIMAL_COYOTE_HOWLING", name = "Coyote Howling"},
    {scenario = "WORLD_ANIMAL_COYOTE_HOWLING_SITTING", name = "Coyote Howling Sitting"},
    {scenario = "WORLD_ANIMAL_DEER_GRAZING", name = "Deer Grazing"},
    {scenario = "WORLD_ANIMAL_DEER_GRAZING_WANDERS", name = "Deer Grazing Wanders"},
    {scenario = "WORLD_ANIMAL_DEER_DRINKING", name = "Deer Drinking"},
    {scenario = "WORLD_ANIMAL_DEER_TREE_RUB", name = "Deer Tree Rub"},
    {scenario = "WORLD_ANIMAL_DEER_RESTING", name = "Deer Resting"},
    {scenario = "WORLD_ANIMAL_DEER_SLEEPING", name = "Deer Sleeping"},
    {scenario = "WORLD_ANIMAL_DEER_INJURED_ON_GROUND", name = "Deer Injured on Ground"},
    {scenario = "WORLD_ANIMAL_DEER_STUNNED_ON_GROUND", name = "Deer Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_DOG_INJURED_ON_GROUND", name = "Dog Injured on Ground"},
    {scenario = "WORLD_ANIMAL_DOG_STUNNED_ON_GROUND", name = "Dog Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_DOG_MARK_TERRITORY_A", name = "Dog Mark Territory A"},
    {scenario = "WORLD_ANIMAL_DOG_BARKING_GROUND", name = "Dog Barking Ground"},
    {scenario = "WORLD_ANIMAL_DOG_BARK_GROWL", name = "Dog Bark Growl"},
    {scenario = "WORLD_ANIMAL_DOG_EATING_GROUND", name = "Dog Eating Ground"},
    {scenario = "WORLD_ANIMAL_DOG_DRINK_GROUND", name = "Dog Drink Ground"},
    {scenario = "WORLD_ANIMAL_DOG_SITTING", name = "Dog Sitting"},
    {scenario = "WORLD_ANIMAL_DOG_RESTING", name = "Dog Resting"},
    {scenario = "WORLD_ANIMAL_DOG_SNIFFING_GROUND", name = "Dog Sniffing Ground"},
    {scenario = "WORLD_ANIMAL_DOG_BARKING_UP", name = "Dog Barking Up"},
    {scenario = "WORLD_ANIMAL_DOG_BARKING_VICIOUS", name = "Dog Barking Vicious"},
    {scenario = "WORLD_ANIMAL_DOG_DIGGING", name = "Dog Digging"},
    {scenario = "WORLD_ANIMAL_DOG_POOPING", name = "Dog Pooping"},
    {scenario = "WORLD_ANIMAL_DOG_GUARD_GROWL", name = "Dog Guard Growl"},
    {scenario = "WORLD_ANIMAL_DOG_HOWLING", name = "Dog Howling"},
    {scenario = "WORLD_ANIMAL_DOG_HOWLING_SITTING", name = "Dog Howling Sitting"},
    {scenario = "WORLD_ANIMAL_DOG_BEGGING", name = "Dog Begging"},
    {scenario = "WORLD_ANIMAL_DOG_ROLL_GROUND", name = "Dog Roll Ground"},
    {scenario = "WORLD_ANIMAL_DOG_SLEEPING", name = "Dog Sleeping"},
    {scenario = "WORLD_ANIMAL_ELK_DRINKING", name = "Elk Drinking"},
    {scenario = "WORLD_ANIMAL_DONKEY_DRINK_GROUND", name = "Donkey Drink Ground"},
    {scenario = "WORLD_ANIMAL_DONKEY_GRAZING", name = "Donkey Grazing"},
    {scenario = "WORLD_ANIMAL_DONKEY_INJURED_ON_GROUND", name = "Donkey Injured on Ground"},
    {scenario = "WORLD_ANIMAL_DONKEY_RESTING", name = "Donkey Resting"},
    {scenario = "WORLD_ANIMAL_DONKEY_SLEEPING", name = "Donkey Sleeping"},
    {scenario = "WORLD_ANIMAL_ELK_DRINK_WADING", name = "Elk Drink Wading"},
    {scenario = "WORLD_ANIMAL_ELK_EATING_LEAVES", name = "Elk Eating Leaves"},
    {scenario = "WORLD_ANIMAL_ELK_GRAZING", name = "Elk Grazing"},
    {scenario = "WORLD_ANIMAL_ELK_INJURED_ON_GROUND", name = "Elk Injured on Ground"},
    {scenario = "WORLD_ANIMAL_ELK_STUNNED_ON_GROUND", name = "Elk Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_ELK_RESTING", name = "Elk Resting"},
    {scenario = "WORLD_ANIMAL_ELK_SLEEPING", name = "Elk Sleeping"},
    {scenario = "WORLD_ANIMAL_FOX_DIGGING", name = "Fox Digging"},
    {scenario = "WORLD_ANIMAL_FOX_DRINK_GROUND", name = "Fox Drink Ground"},
    {scenario = "WORLD_ANIMAL_FOX_EATING_GROUND", name = "Fox Eating Ground"},
    {scenario = "WORLD_ANIMAL_FOX_INJURED_ON_GROUND", name = "Fox Injured on Ground"},
    {scenario = "WORLD_ANIMAL_FOX_STUNNED_ON_GROUND", name = "Fox Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_FOX_RESTING", name = "Fox Resting"},
    {scenario = "WORLD_ANIMAL_FOX_SITTING", name = "Fox Sitting"},
    {scenario = "WORLD_ANIMAL_FOX_SLEEPING", name = "Fox Sleeping"},
    {scenario = "WORLD_ANIMAL_GOAT_DRINK_GROUND", name = "Goat Drink Ground"},
    {scenario = "WORLD_ANIMAL_GOAT_GRAZING", name = "Goat Grazing"},
    {scenario = "WORLD_ANIMAL_GOAT_INJURED_ON_GROUND", name = "Goat Injured on Ground"},
    {scenario = "WORLD_ANIMAL_GOAT_STUNNED_ON_GROUND", name = "Goat Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_GOAT_RESTING", name = "Goat Resting"},
    {scenario = "WORLD_ANIMAL_GOAT_SLEEPING", name = "Goat Sleeping"},
    {scenario = "WORLD_ANIMAL_HORSE_DRINK_GROUND", name = "Horse Drink Ground"},
    {scenario = "WORLD_ANIMAL_HORSE_INJURED_ON_GROUND", name = "Horse Injured on Ground"},
    {scenario = "WORLD_ANIMAL_HORSE_INJURED_ON_GROUND_RIGHT", name = "Horse Injured on Ground Right"},
    {scenario = "WORLD_ANIMAL_HORSE_GRAZING", name = "Horse Grazing"},
    {scenario = "WORLD_ANIMAL_HORSE_RESTING", name = "Horse Resting"},
    {scenario = "WORLD_ANIMAL_HORSE_SLEEPING", name = "Horse Sleeping"},
    {scenario = "WORLD_ANIMAL_HORSE_WALLOW", name = "Horse Wallow"},
    {scenario = "WORLD_ANIMAL_LIONMANGY_INJURED_ON_GROUND", name = "Mangy Lion Injured on Ground"},
    {scenario = "WORLD_ANIMAL_MOOSE_DRINK_GROUND", name = "Moose Drink Ground"},
    {scenario = "WORLD_ANIMAL_MOOSE_DRINK_WADING", name = "Moose Drink Wading"},
    {scenario = "WORLD_ANIMAL_MOOSE_EAT_LEAVES", name = "Moose Eat Leaves"},
    {scenario = "WORLD_ANIMAL_MOOSE_GRAZING", name = "Moose Grazing"},
    {scenario = "WORLD_ANIMAL_MOOSE_INJURED_ON_GROUND", name = "Moose Injured on Ground"},
    {scenario = "WORLD_ANIMAL_MOOSE_STUNNED_ON_GROUND", name = "Moose Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_MOOSE_RESTING", name = "Moose Resting"},
    {scenario = "WORLD_ANIMAL_MUSKRAT_EATING", name = "Muskrat Eating"},
    {scenario = "WORLD_ANIMAL_OX_DRINK_GROUND", name = "Ox Drink Ground"},
    {scenario = "WORLD_ANIMAL_OX_GRAZING", name = "Ox Grazing"},
    {scenario = "WORLD_ANIMAL_OX_RESTING", name = "Ox Resting"},
    {scenario = "WORLD_ANIMAL_OX_SLEEPING", name = "Ox Sleeping"},
    {scenario = "WORLD_ANIMAL_PIG_GRAZING", name = "Pig Grazing"},
    {scenario = "WORLD_ANIMAL_PIG_INJURED_ON_GROUND", name = "Pig Injured on Ground"},
    {scenario = "WORLD_ANIMAL_PIG_STUNNED_ON_GROUND", name = "Pig Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_PIG_SITTING", name = "Pig Sitting"},
    {scenario = "WORLD_ANIMAL_PIG_RESTING", name = "Pig Resting"},
    {scenario = "WORLD_ANIMAL_PIG_ROLL_MUD", name = "Pig Roll Mud"},
    {scenario = "WORLD_ANIMAL_PIG_EAT_CARCASS", name = "Pig Eat Carcass"},
    {scenario = "WORLD_ANIMAL_PIG_DRINK_GROUND", name = "Pig Drink Ground"},
    {scenario = "WORLD_ANIMAL_PIG_SLEEPING", name = "Pig Sleeping"},
    {scenario = "WORLD_ANIMAL_POSSUM_DRINK_GROUND", name = "Possum Drink Ground"},
    {scenario = "WORLD_ANIMAL_POSSUM_EAT_GROUND", name = "Possum Eat Ground"},
    {scenario = "WORLD_ANIMAL_RABBIT_DRINKING", name = "Rabbit Drinking"},
    {scenario = "WORLD_ANIMAL_RABBIT_GRAZING", name = "Rabbit Grazing"},
    {scenario = "WORLD_ANIMAL_RABBIT_FLEE_HOLE", name = "Rabbit Flee Hole"},
    {scenario = "WORLD_ANIMAL_RACCOON_EATING_GROUND", name = "Raccoon Eating Ground"},
    {scenario = "WORLD_ANIMAL_RACCOON_FLEE_HOLE", name = "Raccoon Flee Hole"},
    {scenario = "WORLD_ANIMAL_RAM_GRAZING", name = "Ram Grazing"},
    {scenario = "WORLD_ANIMAL_RAM_DRINKING", name = "Ram Drinking"},
    {scenario = "WORLD_ANIMAL_RAM_TREE_RUB", name = "Ram Tree Rub"},
    {scenario = "WORLD_ANIMAL_RAM_RESTING", name = "Ram Resting"},
    {scenario = "WORLD_ANIMAL_RAT_EATING", name = "Rat Eating"},
    {scenario = "WORLD_ANIMAL_RAT_FLEE_HOLE", name = "Rat Flee Hole"},
    {scenario = "WORLD_ANIMAL_SHEEP_GRAZING", name = "Sheep Grazing"},
    {scenario = "WORLD_ANIMAL_SHEEP_DRINKING", name = "Sheep Drinking"},
    {scenario = "PROP_ANIMAL_SHEEP_DRINK_TROUGH", name = "Prop Sheep Drink Trough"},
    {scenario = "WORLD_ANIMAL_SHEEP_INJURED_ON_GROUND", name = "Sheep Injured on Ground"},
    {scenario = "WORLD_ANIMAL_SHEEP_STUNNED_ON_GROUND", name = "Sheep Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_SHEEP_RESTING", name = "Sheep Resting"},
    {scenario = "WORLD_ANIMAL_SHEEP_SLEEPING", name = "Sheep Sleeping"},
    {scenario = "WORLD_ANIMAL_SKUNK_DIGGING", name = "Skunk Digging"},
    {scenario = "WORLD_ANIMAL_SKUNK_EATING", name = "Skunk Eating"},
    {scenario = "WORLD_ANIMAL_SKUNK_FLEE_HOLE", name = "Skunk Flee Hole"},
    {scenario = "WORLD_ANIMAL_SQUIRREL_EATING", name = "Squirrel Eating"},
    {scenario = "WORLD_ANIMAL_SQUIRREL_FLEE_HOLE", name = "Squirrel Flee Hole"},
    {scenario = "WORLD_ANIMAL_SQUIRREL_ON_LOG", name = "Squirrel on Log"},
    {scenario = "WORLD_ANIMAL_WOLF_MARK_TERRITORY", name = "Wolf Mark Territory"},
    {scenario = "WORLD_ANIMAL_WOLF_RESTING", name = "Wolf Resting"},
    {scenario = "WORLD_ANIMAL_WOLF_SLEEPING", name = "Wolf Sleeping"},
    {scenario = "WORLD_ANIMAL_WOLF_SNIFFING_GROUND", name = "Wolf Sniffing Ground"},
    {scenario = "WORLD_ANIMAL_WOLF_HOWLING", name = "Wolf Howling"},
    {scenario = "WORLD_ANIMAL_WOLF_HOWLING_SITTING", name = "Wolf Sit Howl"},
    {scenario = "WORLD_ANIMAL_WOLF_SITTING", name = "Wolf Sitting"},
    {scenario = "WORLD_ANIMAL_WOLF_INJURED_ON_GROUND", name = "Wolf Injured on Ground"},
    {scenario = "WORLD_ANIMAL_WOLF_STUNNED_ON_GROUND", name = "Wolf Stunned on Ground"},
    {scenario = "WORLD_ANIMAL_WOLF_DRINKING", name = "Wolf Drinking"},
    {scenario = "WORLD_ANIMAL_WOLF_EATING", name = "Wolf Eating"},
    {scenario = "WORLD_ANIMAL_WOLF_EAT_CORPSE", name = "Wolf Eat Corpse"}
}

local last_anim_dict = nil
local last_anim_name = nil
local spawned_ped = nil
local cloned_ped = nil

local function start_anim(anim_dict, anim_name)
    local ped = player.getLocalPed()

    if play_on_spawned_ped then
        if spawned_ped and natives.entity_doesEntityExist(spawned_ped) then
            ped = spawned_ped
        elseif cloned_ped and natives.entity_doesEntityExist(cloned_ped) then
            ped = cloned_ped
        end
    end

    if natives.ped_isPedUsingAnyScenario(ped) and play_anim_on_scenario then
        natives.task_playAnimOnRunningScenario(ped, anim_dict, anim_name)
    else
        if not play_anim_on_scenario then
            natives.task_clearPedTasksImmediately(ped, true, true)
        end
        if not natives.streaming_hasAnimDictLoaded(anim_dict) then
            natives.streaming_requestAnimDict(anim_dict)
            while not natives.streaming_hasAnimDictLoaded(anim_dict) do
                system.yield(0)
            end
        end
        local flags = walking and 31 or 1
        natives.task_taskPlayAnim(ped, anim_dict, anim_name, 1.0, 1.0, -1, flags, 0.0, false, 0, false, "", false)
    end

    last_anim_dict = anim_dict
    last_anim_name = anim_name
    system.yield(10)
    natives.entity_setEntityAnimSpeed(ped, anim_dict, anim_name, anim_speed)
end

local function start_emote(emote_hash)
    local ped = player.getLocalPed()

    if play_on_spawned_ped then
        if spawned_ped and natives.entity_doesEntityExist(spawned_ped) then
            ped = spawned_ped
        elseif cloned_ped and natives.entity_doesEntityExist(cloned_ped) then
            ped = cloned_ped
        end
    end
    if natives.ped_isPedUsingAnyScenario(ped) then
        natives.task_clearPedTasksImmediately(ped, true, true)
    end
    local playback_mode = walking and 0 or 2

    natives.task_taskPlayEmoteWithHash(ped, 1, playback_mode, emote_hash, true, false, false, false, false)
end

local function start_scenario(scenario)
    local ped = player.getLocalPed()

    if play_on_spawned_ped then
        if spawned_ped and natives.entity_doesEntityExist(spawned_ped) then
            ped = spawned_ped
        elseif cloned_ped and natives.entity_doesEntityExist(cloned_ped) then
            ped = cloned_ped
        end
    end

    local x, y, z = natives.entity_getEntityCoords(ped, true, true)
    local heading = natives.entity_getEntityHeading(ped)

    if natives.ped_isPedUsingAnyScenario(ped) then
        natives.task_clearPedTasks(ped, true, true)
    else
        if ground_detection then
            z = z - 1
        else
            z = z
        end
    end

    natives.task_taskStartScenarioAtPosition(ped, natives.misc_getHashKey(scenario), x, y, z, heading, 0, true, true, '', 0, false)
end

local function play_nearby_scenario()
    local ped = player.getLocalPed()

    if play_on_spawned_ped then
        if spawned_ped and natives.entity_doesEntityExist(spawned_ped) then
            ped = spawned_ped
        elseif cloned_ped and natives.entity_doesEntityExist(cloned_ped) then
            ped = cloned_ped
        end
    end
    local x, y, z = player.getLocalPedCoords()
    
    if not natives.task_doesScenarioExistInArea(x, y, z, scenario_range, true, 0, false) then
        logger.logError("No scenario found within range.")
        notifications.alertDanger("Animations.lua", "No scenario found within range")
        return
    end
    
    if warp_to_scenario then
        natives.task_taskUseNearestScenarioToCoordWarp(ped, x, y, z, scenario_range, -1, true, false, false, false)
    else
        natives.task_taskUseNearestScenarioToCoord(ped, x, y, z, scenario_range, -1, true, false, false, false)
    end
end

local function play_nearby_train_scenario()
    local ped = player.getLocalPed()

    if play_on_spawned_ped then
        if spawned_ped and natives.entity_doesEntityExist(spawned_ped) then
            ped = spawned_ped
        elseif cloned_ped and natives.entity_doesEntityExist(cloned_ped) then
            ped = cloned_ped
        end
    end
    local x, y, z = player.getLocalPedCoords()
    
    if not natives.task_doesScenarioExistInArea(x, y, z, scenario_range, true, 0, false) then
        logger.logError("No scenario found within range.")
        notifications.alertDanger("Animations.lua", "No scenario found within range")
        return
    end
    natives.task_taskUseNearestTrainScenarioToCoordWarp(ped, x, y, z, scenario_range)
end

local function input_box()
    natives.misc_displayOnscreenKeyboard(0, "", "", "", "", "", "", 255)

    local function keyboard_tick()
        local status = natives.misc_updateOnscreenKeyboard()

        if status == 1 then
            local input_text = natives.misc_getOnscreenKeyboardResult()
            if input_text and input_text ~= "" then
                input_text = string.lower(input_text)
                if #input_text >= 4 then
                    local found = false
                    local ped = player.getLocalPed()
                    local is_male = natives.ped_isPedMale(ped)

                    for _, anim in ipairs(animations) do
                        if string.lower(anim.name) == input_text then
                            start_anim(anim.anim_dict, anim.anim_name)
                            logger.logInfo("Playing Animation: " .. anim.name)
                            found = true
                            break
                        end
                    end

                    if not found then
                        for _, scenario in ipairs(scenarios) do
                            if string.lower(scenario.name) == input_text and ((is_male and scenario.male) or (not is_male and scenario.female)) then
                                start_scenario(scenario.scenario)
                                logger.logInfo("Starting Scenario: " .. scenario.name)
                                found = true
                                break
                            end
                        end
                    end

                    if not found then
                        for _, emote in ipairs(emotes) do
                            if string.lower(emote.name) == input_text then
                                start_emote(emote.emote_hash)
                                logger.logInfo("Playing Emote: " .. emote.name)
                                found = true
                                break
                            end
                        end
                    end

                    if not found then
                        for _, anim in ipairs(animal_animations) do
                            if string.lower(anim.name) == input_text then
                                start_scenario(anim.scenario)
                                logger.logInfo("Starting Animal Scenario: " .. anim.name)
                                found = true
                                break
                            end
                        end
                    end

                    if not found then
                        notifications.alertInfo("Animations.lua", "No animation found. Please see console for search results.")
                        local suggestions = {}
                        for _, anim in ipairs(animations) do
                            if string.find(string.lower(anim.name), input_text) then
                                table.insert(suggestions, anim.name .. " (Animation)")
                            end
                        end
                        for _, scenario in ipairs(scenarios) do
                            if string.find(string.lower(scenario.name), input_text) and ((is_male and scenario.male) or (not is_male and scenario.female)) then
                                table.insert(suggestions, scenario.name .. " (Scenario)")
                            end
                        end
                        for _, emote in ipairs(emotes) do
                            if string.find(string.lower(emote.name), input_text) then
                                table.insert(suggestions, emote.name .. " (Emote)")
                            end
                        end
                        for _, anim in ipairs(animal_animations) do
                            if string.find(string.lower(anim.name), input_text) then
                                table.insert(suggestions, anim.name .. " (Animal Scenario)")
                            end
                        end
                        if #suggestions > 0 then
                            logger.logInfo("Search Results: " .. table.concat(suggestions, ", "))
                        else
                            logger.logError("No matches found for: " .. input_text)
                        end
                    end
                else
                    logger.logError("Search must be at least 4 characters long.")
                    notifications.alertDanger("Animations.lua", "Search must be at least 4 characters long.")
                end
            end
            system.unregisterTick(keyboard_tick)
        elseif status == 2 or status == 3 then
            logger.logError("Keyboard was canceled or an error occurred.")
            system.unregisterTick(keyboard_tick)
        end
    end

    system.registerTick(keyboard_tick)
end

local function clear_peds()
    pools.getPedsInRadius(3.0, function(ped_handle, ped_model)
        if natives.network_networkHasControlOfEntity(ped_handle) then
            spawner.deletePed(ped_handle)
        else
            utility.requestControlOfEntity(ped_handle, 50)
            if natives.network_networkHasControlOfEntity(ped_handle) then
                spawner.deletePed(ped_handle)
            end
        end
    end)
end

for _, anim in ipairs(animations) do
    menu.addButton(anim_id, anim.name, '', function()
        start_anim(anim.anim_dict, anim.anim_name, anim.walking)
    end)
end

for _, emote in ipairs(emotes) do
    menu.addButton(emote_id, emote.name, '', function()
        start_emote(emote.emote_hash)
    end)
end

for _, scenario in ipairs(scenarios) do
    if (natives.ped_isPedMale(player.getLocalPed()) and scenario.male) or (not natives.ped_isPedMale(player.getLocalPed()) and scenario.female) then
        menu.addButton(scenario_id, scenario.name, '', function()
            start_scenario(scenario.scenario)
        end)
    end
end

for _, anim in ipairs(animal_animations) do
    menu.addButton(animal_id, anim.name, '', function()
        start_scenario(anim.scenario)
    end)
end

menu.addButton('self', '~t~Manual Input', '', function()
    input_box()
end)

menu.addDivider('self', 'Misc')

menu.addToggleButton('self', '~t~Walking/Upper Body Animation', '', walking, function(toggle)
    walking = toggle
end)

menu.addFloatSpinner('self', '~t~Animation Speed', '', 0.1, 10.0, 0.1, anim_speed, function(value)
    anim_speed = value
    if last_anim_dict and last_anim_name then
        local ped = play_on_spawned_ped and (spawned_ped or cloned_ped) or player.getLocalPed()
        if ped and natives.entity_doesEntityExist(ped) then
            natives.entity_setEntityAnimSpeed(ped, last_anim_dict, last_anim_name, anim_speed)
        end
    end
end)

menu.addButton('self', '~t~Clear Nearby Peds', '', function()
   clear_peds()
end)

menu.addButton(advanced_id, 'Play Nearby Scenario', '', function()
    play_nearby_scenario()
end)

menu.addButton(advanced_id, 'Play Nearby Train Scenario', '', function()
    play_nearby_train_scenario()
end)

menu.addIntSpinner(advanced_id, 'Scenario Range', '', 1, 100, 1, scenario_range, function(value)
    scenario_range = value
end)

menu.addToggleButton(advanced_id, 'Render Scenario Range', '', render_range, function(toggle)
    render_range = toggle
    if render_range and not tick_registered then
        system.registerTick(function()
            if render_range then
                local x, y, z = player.getLocalPedCoords()
                natives.graphics_drawMarker(0x94FDAE17, x, y, z, 0, 0, 0, 0, 0, 0, scenario_range * 2, scenario_range * 2, 1.0, 255, 255, 255, 100, false, false, 0, true, '', '', false)
            else
                system.unregisterTick()
                tick_registered = false
            end
        end)
        tick_registered = true
    elseif not render_range and tick_registered then
        system.unregisterTick()
        tick_registered = false
    end
end)

menu.addToggleButton(advanced_id, 'Warp to Scenario', '', warp_to_scenario, function(toggle)
    warp_to_scenario = toggle
end)

menu.addDivider(advanced_id, 'Settings')

menu.addButton(advanced_id, 'Force Rest Scenario', '', function()
    force_rest_scenario = not force_rest_scenario
    natives.player_forceRestScenario(force_rest_scenario)
end)

menu.addToggleButton(advanced_id, 'Ground Detection', '', ground_detection, function(toggle)
    ground_detection = toggle
end)

menu.addToggleButton(advanced_id, 'Play Animations on Scenarios', 'May not work on every scenario', play_anim_on_scenario, function(toggle)
    play_anim_on_scenario = toggle
end)

menu.addButton(advanced_id, 'Look at me', '', function()
    local ped = player.getLocalPed()
    if spawned_ped and natives.entity_doesEntityExist(spawned_ped) then
        natives.task_taskTurnPedToFaceEntity(spawned_ped, ped, 0, 0, 0, 0)
    end
    if cloned_ped and natives.entity_doesEntityExist(cloned_ped) then
        natives.task_taskTurnPedToFaceEntity(cloned_ped, ped, 0, 0, 0, 0)
    end
end)

menu.addFloatSpinner(advanced_id, 'Move Distance', '', 0.1, 5.0, 0.1, movement_distance, function(value)
    movement_distance = value
end)

function move_ped(direction)
    local ped = spawned_ped or cloned_ped
    if not ped or not natives.entity_doesEntityExist(ped) then
        logger.logError("No active ped to move.")
        notifications.alertDanger("Animations.lua", "No active ped to move.")
        return
    end

    local offsetX, offsetY, offsetZ = 0, 0, 0

    if direction == "forward" then
        offsetY = movement_distance
    elseif direction == "backward" then
        offsetY = -movement_distance
    elseif direction == "right" then
        offsetX = movement_distance
    elseif direction == "left" then
        offsetX = -movement_distance
    end

    local x, y, z = natives.entity_getOffsetFromEntityInWorldCoords(ped, offsetX, offsetY, -1)

    natives.entity_setEntityCoords(ped, x, y, z, false, false, false, false)
end

menu.addButton(advanced_id, 'Move Forward', '', function() move_ped('forward') end)
menu.addButton(advanced_id, 'Move Backward', '', function() move_ped('backward') end)
menu.addButton(advanced_id, 'Move Left', '', function() move_ped('left') end)
menu.addButton(advanced_id, 'Move Right', '', function() move_ped('right') end)

menu.addDivider(advanced_id, 'Spawner')

local ped_model_names = {"Arthur", "Abe", "Aberdeenpig Farmer", "Aberdeen Sister", "Abigail Roberts", "Acrobat", "Adam Gray", "Agnes Dowd", "Albert Cake Esquire", "Albert Mason", "Anders Helgerson", "Angel", "Angry Husband", "Angus Geddes", "Ansel Atherton", "Antony Foremen", "Archer Fordham", "Archibald Jameson", "Archie Down", "Art Appraiser", "ASB Deputy 01", "Ashton", "Balloon Operator", "Band Bassist", "Band Drummer", "Band Pianist", "Band Singer", "Baptiste", "Bartholomew Braithwaite", "Bathing Ladies 01", "Beaten Up Captain", "Beau Gray", "Bill Williamson", "BIV Coach Driver", "BLW Photographer", "BLW Witness", "Braithwaite Butler", "Braithwaite Maid", "Braithwaite Servant", "Brenda Crawley", "Bronte", "Bronte's Butler", "Brother Dorkins", "Brynn Tildon", "Bubba", "Cabaret MC", "Cajun", "Can Can Man 01", "Can Can 01", "Can Can 02", "Can Can 03", "Can Can 04", "Captain Monroe", "Cassidy", "Catherine Braithwaite", "Cattle Rustler", "Cave Hermit", "Chain Prisoner 01", "Chain Prisoner 02", "Charles Smith", "Chelonian Master", "Cig Card Guy", "Clay", "Cleet", "Clive", "Col Favours", "Colm O'Driscoll", "Cooper", "Cornwall Train Conductor", "Crackpot Inventor", "Crackpot Robot", "Creepy Old Lady", "Creole Captain", "Creole Doctor", "Creole Guy", "Dale Maroney", "Davey Callender", "David Geddes", "Desmond", "Didsbury", "Dino Bones Lady", "Disguised Duster 01", "Disguised Duster 02", "Disguised Duster 03", "Doroethea Wicklow", "Dr. Higgins", "Dr. Malcolm MacIntosh", "Duncan Geddes", "Duster Informant 01", "Dutch", "Eagle Flies", "Edgar Ross", "Edith Down", "Edith John", "Edmund Lowry", "Escape Artist", "Escape Artist Assistant", "Evelyn Miller", "Ex Confed Informant", "Ex Confeds Leader 01", "Exotic Collector", "Famous Gunslinger 01", "Famous Gunslinger 02", "Famous Gunslinger 03", "Famous Gunslinger 04", "Famous Gunslinger 05", "Famous Gunslinger 06", "Featherston Chambers", "Feats of Strength", "Fight Ref", "Fire Breather", "Fish Collector", "Forgiven Husband 01", "Forgiven Wife 01", "Formy Art Big Woman", "Francis Sinclair", "French Artist", "Frenchman 01", "Fussar", "Gareth Braithwaite", "Gavin", "Gen Story Female", "Gen Story Male", "Gerald Braithwaite", "German Daughter", "German Father", "German Mother", "German Son", "Gilbert Knightly", "Gloria", "Grizzled Jon", "Guido Martelli", "Hamish", "Hector Fellowes", "Henri Lemieux", "Herbalist", "Hercule", "Heston Jameson", "Hobart Crawley", "Hosea Matthews", "Ian Gray", "Jack Marston", "Jack Marston Teen", "Jamie", "Janson", "Javier Escuella", "Jeb", "Jim Calloway", "Jock Gray", "Joe", "Joe Butler", "John Marston", "John The Baptising Madman", "John Weathers", "Josiah Trelawny", "Jules", "Karen", "Karen's John 01", "Kieran", "Laramie", "Leigh Gray", "Lemiux Assistant", "Lenny", "Leon", "Leo Strauss", "Levi Simon", "Leviticus Cornwall", "Lillian Powell", "Lilly Millet", "Londonderry Son", "Luca Napoli", "Magnifico", "Mama Watson", "Marshall Thurwell", "Mary Beth", "Mary Linton", "Meditating Monk", "Meredith", "Meredith's Mother", "Micah Bell", "Micah's Nemesis", "Mickey", "Milton Andrews", "Miss Marjorie", "Mixed Race Kid", "Moira", "Molly O'Shea", "Alfredo Montez", "Allison", "Amos Lansing", "Bonnie", "Bounty Hunter", "Camp Cook", "Cliff", "Cripps", "Grace Lancing", "Hans", "Henchman", "Horley", "Jeremiah Shaw", "Jessica", "Jorge Montez", "Langston", "Lee", "Mabel", "Marshall Davies", "Moonshiner", "Mr. Adller", "Old Man Jones", "Revenge Marshall", "Samson Finch", "Shaky", "Sheriff Freeman", "Teddy Brown", "Terrance", "The Boy", "Travelling Saleswoman", "Went", "Mr. Adller", "Mr. Devon", "Mr. Linton", "Mr. Pearson", "Mrs. Adller", "Mrs. Fellows", "Mrs. Geddes", "Mrs. Londonderry", "Mrs. Weathers", "Mrs. Calhoun", "Mrs. Sinclair", "Mr. Wayne", "Mud2 Big Guy", "Mysterious Stranger", "NBX Drunk", "NBX Executed", "NBX Police Chief Formal", "NBX Receptionist 01", "Nial Whelan", "Nicholas Timmins", "Nils", "Norris Forsythe", "Obediah Hinton", "Oddfellow Spinhead", "OD Prostitute", "Opera Singer", "Paytah", "Penelope Braithwaite", "Pinkerton Goon", "Poison Well Shaman", "Poor Joe", "Priest Wedding", "Princess Isabeau", "Professor Bell", "Rains Fall", "Ramon Cortez", "Reverend Fortheringham", "Rev Swanson", "Rhode Deputy 01", "Rhode Deputy 02", "Rhodes Assistant", "Rhodes Kidnap Victim", "Rhodes Saloon Bouncer", "Ring Master", "Rocky Seven Widow", "Samaritan", "Scott Gray", "SD Doctor 01", "SD Priest", "SD Saloon Drunk 01", "SD Street Kid Thief", "SD Street Kid 01", "SD Street Kid 01A", "SD Street Kid 01B", "SD Street Kid 02", "Sean", "Sheriff Freeman", "Sheriff Owens", "Sister Calderon", "Slave Catcher", "Soothsayer", "Strawberry Outlaw 01", "Strawberry Outlaw 02", "STR Deputy 01", "STR Deputy 02", "STR Sheriff 01", "Sun Worshipper", "Susan Grimshaw", "Swamp Freak", "Swamp Weirdo Sonny", "Sword Dancer", "Tavish Gray", "Taxidermist", "Theodore Levin", "Thomas Down", "Tiger Handler", "Tilly", "Timothy Donahue", "Tiny Hermit", "Tom Dickens", "Town Crier", "Treasure Hunter", "Twin Brother 01", "Twin Brother 02", "Twin Groupie 01", "Twin Groupie 02", "Uncle", "Uniduster Jail 01", "Val Auction Boss 01", "Val Deputy 01", "Val Praying Man", "Val Prostitute 01", "Val Prostitute 02", "Val Sheriff", "Vampire", "VHT Bath Girl", "Wapiti Boy", "War Vet", "Watson 01", "Watson 02", "Watson 03", "Welsh Fighter", "Winton Holmes", "Wrobel"}
local ped_models = {0x0D7114C9, 0xA8B1C9F7, 0xAB6C83B9, 0x78F9C32F, 0xEED46B48, 0x582954CA, 0x6A7308E5, 0x0596AA7B, 0x28E45219, 0x1E9A4722, 0x19ACF207, 0x31DC5CD8, 0x17F33DAA, 0xF5FE5824, 0x563E79E7, 0xCADCA094, 0x328BA546, 0x7920404D, 0xF8BAA439, 0x5FA98D21, 0x1B703333, 0xB6AC4FC1, 0x253EF371, 0x3C3844C4, 0x559E17B2, 0x8EA36E09, 0xF3178A28, 0xF3C61748, 0xFB614B3F, 0xD29F17B9, 0xFCAF1AFE, 0x4B780F88, 0x7B67B26A, 0xDF333F2B, 0x1AA22618, 0x4D3B6EF2, 0xDFE6F4B8, 0xEB20D71E, 0x1C76CA2D, 0x0DBD6C20, 0x90C94DCD, 0xD18A3207, 0x1CC577E5, 0x0AF97379, 0xD012554C, 0x5411589F, 0xF344B612, 0x2D0C353F, 0xD0C13881, 0x2F5D75D4, 0xBD791211, 0x12DABCCF, 0x4EB9996F, 0x2E6B8F33, 0x5262264D, 0x5F1AD166, 0x074B53CC, 0x8451929D, 0xF367F0C8, 0x53DD98DF, 0x34F835DE, 0xD303ACD2, 0xDBCB9834, 0xE44D789F, 0xFF292AA4, 0x0E174AF7, 0xCF10E769, 0x72A3A733, 0xC43EAC49, 0x4BBF80D3, 0x3BF7829E, 0xC061B459, 0xD163B76B, 0x3B38C996, 0x96C421E4, 0x16C57A26, 0x65A7F0E7, 0x9EAF0DAE, 0x66E939A1, 0x8ACCB671, 0x4AB3D571, 0x32C998FD, 0x5888E47B, 0x4A3D47E4, 0x0748A3DA, 0xF45739BF, 0xC8245F3C, 0x9FC15494, 0xA02C1ADB, 0x73E82274, 0x9660A42D, 0xFD38D463, 0xE52A1621, 0xCB790850, 0x58672CFB, 0x88A17BE6, 0x929C4793, 0x2C4CA0A0, 0xF0EAC712, 0x11E95A0F, 0x59D39598, 0xFA274E38, 0x504E7A85, 0xDEBB9761, 0x14F583D4, 0x236820B9, 0x79B7CD5F, 0x8D374040, 0x8D6618C3, 0x53308B76, 0xEADD5782, 0x5A3FC29E, 0x61F3D8F8, 0xD36D9790, 0xB4449A8A, 0x9634D7B5, 0xD809F182, 0xF258BC07, 0x8D883B70, 0x968AB03C, 0x4C5C60B2, 0x3CCC99B1, 0xD9E8B86A, 0xBB35418E, 0x39FD28AE, 0x5205A246, 0x771EA179, 0x0D5EB39A, 0xE1B35B43, 0x9B5487C9, 0xBDB43F31, 0x9EDFC6EB, 0x6D084810, 0x6D8B4BB9, 0x30324925, 0x0C60474A, 0x4C165ECF, 0xA560451D, 0xB0C337A3, 0x490733E8, 0x88094B37, 0x71F7EE1B, 0xDA5990BC, 0x004C2AF4, 0xD2E125B6, 0x6DE3800C, 0x5548F1E9, 0x6C30159E, 0x9DE34628, 0xE569265F, 0x54951099, 0x05B6D06D, 0x442FBDDC, 0x7D357931, 0x3BFD7D5D, 0xB4F83876, 0x9A3E29FB, 0x013504F0, 0x739BA0D6, 0xBFD90AEA, 0x97F8823A, 0x3AEDE260, 0xF8AE5F8D, 0xC91ADF62, 0xFA0312B3, 0x4D24C49A, 0x8A1FCA47, 0x19686DFA, 0x55C7D09F, 0x4DBE35B8, 0x77435EF1, 0x5F5942DD, 0x4B6ECAEF, 0x3940877D, 0x9B37429C, 0x3EA5B5BC, 0xF04DEE7E, 0xC0321438, 0x3112E4AC, 0xDE361D65, 0xE2D294AB, 0xA1DFB431, 0x01004B26, 0x859CBAAC, 0xFBBC94C6, 0x9BAAB546, 0xEB55C35E, 0x4C4448BA, 0x931F01E5, 0x30E034CA, 0x39456FEE, 0x892944C5, 0x9F7769F3, 0xEADDA26C, 0x1DD24709, 0x2CDA4B15, 0x893E6E25, 0xDAB77DF1, 0x4BFBF802, 0x2EDEF9ED, 0x6B759DBB, 0x8BF81D72, 0x9A00FB76, 0x75DCACF2, 0xB93CB429, 0xE24327D2, 0x65C51599, 0xA3261C0D, 0xE87FE55D, 0x4549CCA0, 0xE757DE29, 0x9A3713AD, 0x28AE1CF3, 0xBB202735, 0xB36FBE5E, 0x04B479C0, 0xE20455E9, 0xB496E3FB, 0xAB270CC9, 0xA89E5746, 0xEFBFEDB1, 0x3AAAB060, 0x155E51DB, 0x2AB79B76, 0xEFC21975, 0x5187C29B, 0xFEFB81C0, 0x4481AEDF, 0x62C1389E, 0x41A0B3F7, 0x84490A12, 0xF65EE3E1, 0x753590C4, 0x79AEBA08, 0xC19649AA, 0xC175E70A, 0xB304BB4D, 0x4995C0A5, 0x031076F6, 0xB4B65231, 0x04156A73, 0xA91215CD, 0x62589584, 0x5B00992C, 0xBC537EB7, 0x8617AB88, 0xA06649D4, 0x2E258627, 0x19E97506, 0xDD5F0343, 0x89F94DED, 0x7E1809E8, 0x85FE1E48, 0x7CF95C98, 0x656E59CC, 0x60713474, 0xC7BB68D5, 0x583389C7, 0x774AB298, 0x0F23E138, 0x7FA4ED12, 0x772D9802, 0xF79A7EC2, 0xF0297311, 0xCF75E336, 0xCF12BFF0, 0xE4E66C41, 0x6DC2F2F2, 0x0F274F72, 0xEEB2E5FD, 0x678E7CA0, 0x32541234, 0x6EF76684, 0xE0D7A2B2, 0xC192917D, 0xCEE81C27, 0x839CCCAC, 0xE9B80099, 0x51C80EFD, 0x4B7EAC47, 0x99D4C8F2, 0xA792AF18, 0xDDD99BA5, 0x83E7B7BB, 0x196D5830, 0x6509A069, 0xA9A328D5, 0x87A4C0B9, 0x9654DDCF, 0x53E86B71, 0x21914E41, 0x49644A6F, 0x03DFFD04, 0xD690782C, 0x3DE6A545, 0x8868C876, 0x8853FF79, 0xBABFD910, 0x13458A93, 0x3AF591E8, 0x361005DD, 0xA49B62BA, 0xFD3C2696, 0xEB8B8335, 0xC63726DF, 0x87EF0B8D, 0x70BEBBCF, 0x6C07EC33, 0x4124A908, 0x3A643444, 0x2B769669, 0x8FB23370, 0xD95BCB7D, 0x36781BAC, 0xFB0A7382, 0x9C0C8EE9, 0x69439F09, 0x8C16E4AF, 0x44EFD66E, 0x02E86DB1, 0x03387076, 0xBE52968B}

local ped_model_index = 1

menu.addStringSpinner(advanced_id, 'Ped Model', '', ped_model_index - 1, ped_model_names, function(value_idx)
    ped_model_index = value_idx + 1
end)

local ped_variant_index = 0

menu.addIntSpinner(advanced_id, 'Ped Variant', '', 0, 300, 1, ped_variant_index, function(value)
    ped_variant_index = value
end)

function spawn_ped()
    if not spawned_ped or not natives.entity_doesEntityExist(spawned_ped) then
        if cloned_ped and natives.entity_doesEntityExist(cloned_ped) then
            logger.logError("A cloned ped already exists.")
            notifications.alertDanger("Animations.lua", "A cloned ped already exists.")
            return
        end
        local x, y, z = player.getLocalPedCoords()
        local model_hash = ped_models[ped_model_index]
        spawned_ped = spawner.spawnPed(model_hash, x, y, z, true)
        table.insert(spawned_peds, spawned_ped)
        natives.task_taskSetBlockingOfNonTemporaryEvents(spawned_ped, true)
        natives.ped_setPedKeepTask(spawned_ped, true)
        natives.entity_setEntityInvincible(spawned_ped, true)
        natives.ped_setPedCanRagdoll(spawned_ped, false)
        natives.ped_setPedConfigFlag(spawned_ped, 61, true)
        natives.ped_setPedCanBeLassoed(spawned_ped, false)
        natives.ped_setPedLassoHogtieFlag(spawned_ped, 0, false)
        natives.ped_setPedCanBeTargetted(spawned_ped, false)
        natives.ped_setPedCanBeTargettedByTeam(spawned_ped, -1, false)
        natives.ped_setPedCanBeTargettedByTeam(spawned_ped, 0, false)
        natives.ped_setPedCanBeTargettedByTeam(spawned_ped, 2, false)
        natives.ped_setPedCanBeTargettedByTeam(spawned_ped, 3, false)
        natives.ped_setBlockingOfNonTemporaryEvents(spawned_ped, true)
        natives.ped_setPedFleeAttributes(spawned_ped, 0, false)
        natives.ped_setPedCombatAttributes(spawned_ped, 17, false)
        natives.ped_setPedCombatAttributes(spawned_ped, 38, true)
        utility.autoBlockControlRequests(spawned_ped, true)
        natives.ped_equipPedOutfitPreset(spawned_ped, ped_variant_index, false)
    else
        logger.logError("A spawned ped already exists.")
        notifications.alertDanger("Animations.lua", "A spawned ped already exists.")
    end
end

menu.addButton(advanced_id, 'Spawn Ped', '', spawn_ped)

local animal_model_names = {"California Condor", "Bat", "California ParaKeet", "Crow", "Sparrow", "Chicken", "Duck", "Eagle", "Canadian Goose", "Heron", "Owl", "Parrot", "Pelican", "Pigeon", "Quail", "Seagull", "Rooster", "Wild Turkey", "Turkey 1", "Turkey 2", "Vulture", "Woodpecker", "BlueGill", "Catfish", "Large Catfish", "Pickerel", "Sturgeon", "Large Bass", "Bass", "Badger", "Bear", "Black Bear", "Beaver", "Cougar", "Lion", "Panther", "Boar", "Giant Boar", "Buck", "Buffalo", "Bull", "Cat", "Cow", "Coyote", "Deer", "American Fox Hound", "Australian Sheperd", "Bluetick Coonhound", "Catahoula Cur", "Chesbay Retriever", "Border Collie", "Hobo Dog", "Hound Dog", "Husky", "Labrador", "Lion Dog", "Poodle", "Rufus", "Street Dog", "Elk", "Donkey", "Fox", "Goat", "Horse", "Moose", "Muskrat", "Ox", "Pig", "Glowing Possum", "Possum", "Glowing Rabbit", "Rabbit", "Raccoon", "Ram", "Rat", "Sheep", "Skunk", "Squirrel", "Wolf Large", "Wolf Medium", "Wolf Small"}
local animal_models = {0x47E1D597, 0x28308168, 0x681E834B, 0x5DF8F2C, 0xC2B75D41, 0x8506531D, 0xC42E08CB, 0x57027587, 0x2B1B02CA, 0x41462AB0, 0xCCA5E0B0, 0x94DD14B8, 0x4B751E5C, 0x06A20728, 0x7D7ED3F4, 0xF62ADA90, 0x789C821E, 0x881F1C91, 0xE438917C, 0xF61A353F, 0x41D8593C, 0x2B7AD8CD, 0x6F4C2A6C, 0x29F1CB9D, 0x5BAEE06E, 0xB97D1BFD, 0xEE111F34, 0x1BA2A2E8, 0x750FD65, 0xBA41697E, 0xBCFD0E7F, 0x2B845466, 0x2D4B3F63, 0x056154F7, 0xC68B3C66, 0x629DDF49, 0xE8CBC01C, 0xDE99DA6D, 0x9770DD23, 0x5CC5E869, 0x0BAA25A3, 0x573201B8, 0xFCFA9E1E, 0x1CA6B883, 0x423417A7, 0x40E01848, 0xAE6C236C, 0x2552B009, 0xC25FE171, 0xE8C446CB, 0x40D2BCBC, 0xC5C5D255, 0x801131EF, 0x62F7C1B3, 0xAD779EB4, 0xCA89FC80, 0x40CAC0E7, 0x5EDF32B4, 0x3B313FCE, 0x87895317, 0x69A37A7B, 0xF0F6D94, 0xD3105A6D, 0x8AF8EE20, 0xBE871B28, 0xBC61ABDD, 0x21294FD8, 0x3C0BFE72, 0xDECED2FD, 0xABA8FB1F, 0xF4EA3B49, 0xDFB55C81, 0x56EF91BF, 0xA27F49A3, 0x3AFD2922, 0x02679F5C, 0xB7C8F704, 0x5758D069, 0xBBD91DDA, 0xCB391381, 0xCE924A27}

local model_index = 1

menu.addStringSpinner(advanced_id, 'Animal Model', '', model_index - 1, animal_model_names, function(value_idx)
    model_index = value_idx + 1
end)

local variant_index = 0

menu.addIntSpinner(advanced_id, 'Animal Variant', '', 0, 300, 1, variant_index, function(value)
    variant_index = value
end)

function spawn_animal()
    if not spawned_ped or not natives.entity_doesEntityExist(spawned_ped) then
        if cloned_ped and natives.entity_doesEntityExist(cloned_ped) then
            logger.logError("A cloned ped already exists.")
            notifications.alertDanger("Animations.lua", "A cloned ped already exists.")
            return
        end
        local x, y, z = player.getLocalPedCoords()
        local model_hash = animal_models[model_index]
        spawned_ped = spawner.spawnPed(model_hash, x, y, z, true)
        table.insert(spawned_peds, spawned_ped)
        natives.task_taskSetBlockingOfNonTemporaryEvents(spawned_ped, true)
        natives.ped_setPedKeepTask(spawned_ped, true)
        natives.entity_setEntityInvincible(spawned_ped, true)
        natives.ped_setPedCanRagdoll(spawned_ped, false)
        natives.ped_setPedConfigFlag(spawned_ped, 61, true)
        natives.ped_setPedCanBeLassoed(spawned_ped, false)
        natives.ped_setPedLassoHogtieFlag(spawned_ped, 0, false)
        natives.ped_setPedCanBeTargetted(spawned_ped, false)
        natives.ped_setPedCanBeTargettedByTeam(spawned_ped, -1, false)
        natives.ped_setPedCanBeTargettedByTeam(spawned_ped, 0, false)
        natives.ped_setPedCanBeTargettedByTeam(spawned_ped, 2, false)
        natives.ped_setPedCanBeTargettedByTeam(spawned_ped, 3, false)
        natives.ped_setBlockingOfNonTemporaryEvents(spawned_ped, true)
        natives.ped_setPedFleeAttributes(spawned_ped, 0, false)
        natives.ped_setPedCombatAttributes(spawned_ped, 17, false)
        natives.ped_setPedCombatAttributes(spawned_ped, 38, true)
        utility.autoBlockControlRequests(spawned_ped, true)
        natives.ped_equipPedOutfitPreset(spawned_ped, variant_index, false)
    else
        logger.logError("An animal has already been spawned.")
        notifications.alertDanger("Animations.lua", "An animal has already been spawned.")
    end
end

menu.addButton(advanced_id, 'Spawn Animal', '', spawn_animal)

local function input_box_for_spawning()
    natives.misc_displayOnscreenKeyboard(0, "", "", "", "", "", "", 255)

    local function keyboard_tick()
        local status = natives.misc_updateOnscreenKeyboard()
        if status == 1 then
            local input_text = natives.misc_getOnscreenKeyboardResult()
            if input_text and input_text ~= "" then
                input_text = string.lower(input_text)
                local found = false

                if spawned_ped and natives.entity_doesEntityExist(spawned_ped) or cloned_ped and natives.entity_doesEntityExist(cloned_ped) then
                    logger.logError("A ped or clone is already active. Please remove before spawning another.")
                    notifications.alertDanger("Animations.lua", "ERROR: A ped or clone is already active.")
                    system.unregisterTick(keyboard_tick)
                    return
                end

                local suggestions = {}
                for idx, name in ipairs(ped_model_names) do
                    if string.lower(name) == input_text then
                        ped_model_index = idx
                        spawn_ped()
                        found = true
                        break
                    elseif string.find(string.lower(name), input_text) then
                        table.insert(suggestions, name)
                    end
                end

                if not found then
                    for idx, name in ipairs(animal_model_names) do
                        if string.lower(name) == input_text then
                            model_index = idx
                            spawn_animal()
                            found = true
                            break
                        elseif string.find(string.lower(name), input_text) then
                            table.insert(suggestions, name)
                        end
                    end
                end

                if not found then
                    if #suggestions > 0 then
                        notifications.alertInfo("Animations.lua", "No ped found. Please see console for search results.")
                        logger.logInfo("Search Results: " .. table.concat(suggestions, ", "))
                    else
                        logger.logError("No matches found for: " .. input_text)
                        notifications.alertInfo("Animations.lua", "ERROR: No matching ped or animal name found.")
                    end
                end
            end
            system.unregisterTick(keyboard_tick)
        elseif status == 2 or status == 3 then
            logger.logError("Keyboard was canceled or an error occurred.")
            system.unregisterTick(keyboard_tick)
        end
    end

    system.registerTick(keyboard_tick)
end

menu.addButton(advanced_id, "Manual Input Spawn", "", input_box_for_spawning)

menu.addButton(advanced_id, 'Clone Ped', '', function()
    if not cloned_ped or not natives.entity_doesEntityExist(cloned_ped) then
        if spawned_ped and natives.entity_doesEntityExist(spawned_ped) then
            logger.logError("A spawned ped already exists.")
            notifications.alertDanger("Animations.lua", "A spawned ped already exists.")
            return
        end
        local ped = player.getLocalPed()
        cloned_ped = natives.ped_clonePed(ped, true, false, true)
        table.insert(spawned_peds, cloned_ped)
        natives.task_taskSetBlockingOfNonTemporaryEvents(cloned_ped, true)
        natives.ped_setPedKeepTask(cloned_ped, true)
        natives.entity_setEntityInvincible(cloned_ped, true)
        natives.ped_setPedCanRagdoll(cloned_ped, false)
        natives.ped_setPedConfigFlag(cloned_ped, 61, true)
        natives.ped_setPedCanBeLassoed(cloned_ped, false)
        natives.ped_setPedLassoHogtieFlag(cloned_ped, 0, false)
        natives.ped_setPedCanBeTargetted(cloned_ped, false)
        natives.ped_setPedCanBeTargettedByTeam(cloned_ped, -1, false)
        natives.ped_setPedCanBeTargettedByTeam(cloned_ped, 0, false)
        natives.ped_setPedCanBeTargettedByTeam(cloned_ped, 2, false)
        natives.ped_setPedCanBeTargettedByTeam(cloned_ped, 3, false)
        natives.ped_setBlockingOfNonTemporaryEvents(cloned_ped, true)
        natives.ped_setPedFleeAttributes(cloned_ped, 0, false)
        natives.ped_setPedCombatAttributes(cloned_ped, 17, false)
        natives.ped_setPedCombatAttributes(cloned_ped, 38, true)
        utility.autoBlockControlRequests(cloned_ped, true)
        if not cloned_ped or not natives.entity_doesEntityExist(cloned_ped) then
            logger.logError("Failed to clone ped.")
            notifications.alertDanger("Animations.lua", "Failed to clone ped.")
        end
    else
        logger.logError("A cloned ped already exists.")
        notifications.alertDanger("Animations.lua", "A cloned ped already exists.")
    end
end)

menu.addButton('player', 'Clone Ped', '', function(player_idx)
    if not cloned_ped or not natives.entity_doesEntityExist(cloned_ped) then
        local ped = player.getPed(player_idx)
        cloned_ped = natives.ped_clonePed(ped, true, false, true)
        table.insert(spawned_peds, cloned_ped)
        natives.task_taskSetBlockingOfNonTemporaryEvents(cloned_ped, true)
        natives.ped_setPedKeepTask(cloned_ped, true)
        natives.entity_setEntityInvincible(cloned_ped, true)
        natives.ped_setPedCanRagdoll(cloned_ped, false)
        natives.ped_setPedConfigFlag(cloned_ped, 61, true)
        natives.ped_setPedCanBeLassoed(cloned_ped, false)
        natives.ped_setPedLassoHogtieFlag(cloned_ped, 0, false)
        natives.ped_setPedCanBeTargetted(cloned_ped, false)
        natives.ped_setPedCanBeTargettedByTeam(cloned_ped, -1, false)
        natives.ped_setPedCanBeTargettedByTeam(cloned_ped, 0, false)
        natives.ped_setPedCanBeTargettedByTeam(cloned_ped, 2, false)
        natives.ped_setPedCanBeTargettedByTeam(cloned_ped, 3, false)
        natives.ped_setBlockingOfNonTemporaryEvents(cloned_ped, true)
        natives.ped_setPedFleeAttributes(cloned_ped, 0, false)
        natives.ped_setPedCombatAttributes(cloned_ped, 17, false)
        natives.ped_setPedCombatAttributes(cloned_ped, 38, true)
        utility.autoBlockControlRequests(cloned_ped, true)
        if not cloned_ped or not natives.entity_doesEntityExist(cloned_ped) then
            logger.logError("Failed to clone ped.")
            notifications.alertDanger("Animations.lua", "Failed to clone ped.")
        end
    else
        logger.logError("A cloned ped or spawned ped already exists.")
        notifications.alertDanger("Animations.lua", "A clone or spawned ped already exists.")
    end
end)

menu.addToggleButton(advanced_id, 'Play Animations on Spawned Ped', '', play_on_spawned_ped, function(toggle)
    play_on_spawned_ped = toggle
end)

menu.addToggleButton(advanced_id, 'Play Animations on Horse', '', play_anim_on_horse, function(toggle)
    play_anim_on_horse = toggle
    local player_ped = player.getLocalPed()
    if play_anim_on_horse then
        local current_horse = natives.ped_isPedOnMount(player_ped) and natives.ped_getMount(player_ped) or natives.ped_getLastMount(player_ped)
        if current_horse and natives.entity_doesEntityExist(current_horse) then
            spawned_ped = current_horse
        else
            logger.logError("No horse found.")
            notifications.alertDanger("Animations.lua", "No horse found.")
            play_anim_on_horse = false
            if not play_on_spawned_ped then
                spawned_ped = nil
            end
        end
    end
end)

menu.addButton(advanced_id, 'Teleport Ped to Me', '', function()
    if spawned_ped and natives.entity_doesEntityExist(spawned_ped) then
        local x, y, z = player.getLocalPedCoords()
        natives.entity_setEntityCoords(spawned_ped, x, y, z, false, false, false, false)
    end
    if cloned_ped and natives.entity_doesEntityExist(cloned_ped) then
        local x, y, z = player.getLocalPedCoords()
        natives.entity_setEntityCoords(cloned_ped, x, y, z, false, false, false, false)
    end
end)

menu.addButton(advanced_id, 'Teleport Me to Ped', '', function()
    if spawned_ped and natives.entity_doesEntityExist(spawned_ped) then
        local x, y, z = natives.entity_getEntityCoords(spawned_ped, true, false)
        natives.entity_setEntityCoords(player.getLocalPed(), x, y, z, false, false, false, false)
    end
    if cloned_ped and natives.entity_doesEntityExist(cloned_ped) then
        local x, y, z = natives.entity_getEntityCoords(cloned_ped, true, false)
        utility.teleportToCoords(x, y, z)
    end
end)

menu.addButton(advanced_id, 'Next Ped', 'This will clear the current ped reference so a new one can be spawned.', function()
    spawned_ped = nil
    cloned_ped = nil
end)

menu.addButton(advanced_id, 'Clear Tasks for Spawned Ped', '', function()
    if spawned_ped and natives.entity_doesEntityExist(spawned_ped) then
        natives.task_clearPedTasks(spawned_ped, true, true)
    end
    if cloned_ped and natives.entity_doesEntityExist(cloned_ped) then
        natives.task_clearPedTasks(cloned_ped, true, true)
    end
end)

menu.addButton(advanced_id, 'Delete Spawned Ped', '', function()
    for _, ped in ipairs(spawned_peds) do
        if natives.entity_doesEntityExist(ped) then
            spawner.deletePed(ped)
        end
    end
    spawned_peds = {}
end)

menu.addButton('self', '~e~Clear Tasks', '', function()
    local ped = player.getLocalPed()
    natives.task_clearPedTasksImmediately(ped, true, true)
end)

system.registerDestructor(function()
    if tick_registered then
        system.unregisterTick()
        tick_registered = false
    end
end)
