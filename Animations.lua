-- Lean, idle and camp
system.setScriptName('~t5~Animations.lua')

logger.logCustom('<#FF69B4>[<b>Animations.lua: <#FFC0CB>Loaded!</#FF69B4></b><#FF69B4>]')
notifications.alertInfo("Animations.lua Loaded", "Version: Pre-Release")

emote_id = menu.addSubmenu('self', '~t5~Emotes', '')
scenario_id = menu.addSubmenu('self', '~t5~Scenarios', '')
anim_id = menu.addSubmenu('self', '~t5~Animations', '')
advanced_id = menu.addSubmenu('self', '~t5~Advanced', '')

local render_range = false
local tick_registered = false
local walking = false
warp_to_scenario = true
local anim_speed = 1.0
local scenario_range = 10
local find_ground = true
local force_rest_scenario = false
local play_anim_on_scenario = false
local play_on_spawned_ped = false
local spawned_peds = {}

local animations = {
    {anim_dict = "amb_player@world_human_lean@wall@high@lean_a@base", anim_name = "base", name = "Lean A"},
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
    {anim_dict = "ai_react@breakouts@gen_male@known_poses", anim_name = "pose_getup_from_ass", name = "Sit Butt"},
    {anim_dict = "script_rc@gun5@ig@stage_01@ig3_bellposes", anim_name = "pose_02_idle_famousgunslinger_05", name = "Dual Pistol Pose"},
    {anim_dict = "script_rc@gun5@ig@stage_01@ig3_bellposes", anim_name = "pose_03_idle_famousgunslinger_05", name = "Rifle Shoulder Pose"},
    {anim_dict = "script_re@town_burial@preacher@pose_d@base", anim_name = "base", name = "Standing in silence"},
    {anim_dict = "script_amb@stores@store_lean_shopkeeper_b", anim_name = "impatient_react_a", name = "Shopkeeper Impatient A"},
    {anim_dict = "script_amb@stores@store_lean_shopkeeper_b", anim_name = "impatient_react_b", name = "Shopkeeper Impatient B"},
    {anim_dict = "script_amb@stores@store_lean_shopkeeper_b", anim_name = "base", name = "Shopkeeper Idle"},
    {anim_dict = "amb_misc@world_human_pee@male_a@idle_a", anim_name = "idle_a", name = "Pee"},
    {anim_dict = "amb_camp@world_camp_fire_standing@female_a@base", anim_name = "base", name = "Female Standing 3"},
    {anim_dict = "amb_camp@world_camp_fire_standing@female_b@base", anim_name = "base", name = "Female Standing 4"},
    {anim_dict = "script_common@shared_scenarios@kneel@mourn@female@a@react_look@loop@low", anim_name = "right", name = "Kneeling Head Turn 1"},
    {anim_dict = "script_common@shared_scenarios@kneel@mourn@female@a@react_look@loop@high", anim_name = "left", name = "Kneeling Head Turn 2"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@female", anim_name = "idle_f06", name = "Female Shoulder Rifle 2"},
    {anim_dict = "amb_temp@world_human_seat_steps@female@hands_by_sides@base", anim_name = "base", name = "So Cute UwU"},
    {anim_dict = "script_proc@bounty@wife_and_lover@confront_a", anim_name = "sit_idle_female", name = "Sitting Cute"},
    {anim_dict = "script_mp@photo_studio@possy_photo_1chair", anim_name = "idle_f06", name = "Sitting Cute 2"},
    {anim_dict = "amb_camp@world_camp_grimshaw_stare@wip_base@female_a", anim_name = "base", name = "Female Standing 5"},
    {anim_dict = "amb_camp@world_camp_grimshaw_stare@wip_base@female_b", anim_name = "base", name = "Female Standing 6"},
    {anim_dict = "amb_camp@world_camp_grimshaw_stare@wip_base@female_d", anim_name = "base", name = "Female Standing 7"},
    {anim_dict = "amb_camp@prop_camp_sadie_adler@sit@stare@base", anim_name = "base", name = "Sadie Seat"},
    {anim_dict = "script_mp@photo_studio@row_staggered", anim_name = "idle_f05", name = "Female Standing 8"},
    {anim_dict = "script_re@peep_tom@topless_woman", anim_name = "female_idle_female", name = "Female Fixing Hair"},
    {anim_dict = "script_re@slum_ambush@ig1_woman_leads_to_ambush", anim_name = "enter_ft_prostitute", name = "Leaning Prostitute"},
    {anim_dict = "script_story@ind1@ai_scenario_reactions@party_ai_champagne_lady_c", anim_name = "ai_champagneladyc_goodevening_a_f_m_gamhighsociety_01", name = "Female Holding Glass"},
    {anim_dict = "script_proc@robberies@homestead@aberdeen@undressing", anim_name = "loop_short", name = "Female Standing 9"},
    {anim_dict = "script_proc@robberies@homestead@aberdeen@undressing", anim_name = "loopb", name = "Female Mirror"},
    {anim_dict = "script_proc@robberies@homestead@aberdeen@undressing", anim_name = "loopa", name = "Female Mirror 2"},
    {anim_dict = "script_proc@robberies@homestead@aberdeen@undressing", anim_name = "line01_loop", name = "Female Standing 10"},
    {anim_dict = "amb_rest_lean@world_human_lean@piano@left@female_a@wip_base", anim_name = "wip_base", name = "Girl Boss Lean"},
    {anim_dict = "amb_rest_lean@world_human_lean@piano@left@female_b@wip_base", anim_name = "wip_base", name = "Girl Boss Lean 2"},
    {anim_dict = "amb_rest_lean@world_human_lean@post@left@moonshine@female_a@base", anim_name = "base", name = "Female Standing 11"},
    {anim_dict = "amb_rest_lean@world_human_lean@railing@female_b@react_look@active_look", anim_name = "active_look_front", name = "Leaning On Bar"},
    {anim_dict = "script_mp@photostudio@dog@female", anim_name = "idle_f04", name = "Female Standing"},
    {anim_dict = "mech_inventory@equip_female@base_spin@single_handgun@rhip", anim_name = "loop", name = "Single Gun Spin"},
    {anim_dict = "mech_inventory@equip_female@base_spin@single_handgun@shared", anim_name = "var_a_loop", name = "Single Gun Spin 2"},
    {anim_dict = "mp_lobby@coop@standing@mp_female_a@active_look", anim_name = "active_look", name = "Female Standing 12"},
    {anim_dict = "mp_lobby@coop@standing@mp_female_b@active_look", anim_name = "active_look", name = "Female Standing 13"},
    {anim_dict = "mp_lobby@coop@standing@mp_female_d@active_look", anim_name = "active_look", name = "Female Standing 14"},
    {anim_dict = "mp_lobby@phns@standing@mp_female_b@active_look", anim_name = "active_look", name = "Female Standing 15"},
    {anim_dict = "mp_lobby@standard@crouching@mp_female_a@active_look", anim_name = "active_look", name = "Sit Ground 2"},
    {anim_dict = "script_mp@photostudio@dog@female", anim_name = "idle_f06", name = "Female Standing 2"},
    {anim_dict = "script_mp@photo_studio@chair_rifles@female", anim_name = "idle_f04", name = "Sit Ground 3"},
    {anim_dict = "script_special_ped@pdeep_early_eugenics_proponent@ig@ig_1", anim_name = "carolina_base_carolina", name = "Female Standing 16"},
    {anim_dict = "script_rc@gun4@stage_01@ig@ig2_takephoto", anim_name = "photopose_04_idle_famousgunslinger_04", name = "Double Gun Pose"},
    {anim_dict = "amb_rest_drunk@world_human_sit_ground@drinking_drunk@passed_out@male_d@idle_c", anim_name = "idle_h", name = "Resting"},
    {anim_dict = "script_re@dark_alley_bum@desp@steal", anim_name = "enter_lf_bum", name = "Sit Ground 4"},
    {anim_dict = "script_mp@last_round@photos@pair_a", anim_name = "pose4_f_a1", name = "Leaning Back Fence"},
    {anim_dict = "script_mp@last_round@photos@pair_a", anim_name = "pose4_m_a1", name = "Leaning Back Fence 2"},
    {anim_dict = "script_mp@photo_studio@celebrate@female", anim_name = "idle_f04", name = "Holding Hand Out"},
    {anim_dict = "script_rc@abi3@ig@stage_01@ig2_photopose", anim_name = "pose_c_idle_abigailroberts", name = "Abigail Photo"},
    {anim_dict = "script_rc@abi3@ig@stage_01@ig2_photopose", anim_name = "pose_b_idle_abigailroberts", name = "Abigail Photo 2"},
    {anim_dict = "script_re@grave_robbers@male_a@pose2@react_look@loop@generic", anim_name = "react_look_backright_loop", name = "Look Back Right"},
    {anim_dict = "script_re@grave_robbers@male_a@pose2@react_look@loop@generic", anim_name = "react_look_backleft_loop", name = "Look Back Left"},
    {anim_dict = "cnv_camp@rchso@cnv@cfun5", anim_name = "base_gen_male_c", name = "Lay Ground Side"},
    {anim_dict = "cnv_camp@rchso@cnv@cfsn2", anim_name = "gen_male_a_action", name = "Resting 2"},
    {anim_dict = "cnv_camp@rchso@cnv@ccswn16", anim_name = "uncle_action_a", name = "Eepy Girl"},
    {anim_dict = "amb_camp@world_camp_dynamic_fire@logholdlarge@male_a@react_look@loop@generic", anim_name = "react_look_right_loop", name = "Picking Flower"},
    {anim_dict = "script_rc@gun4@stage_01@ig@ig2_takephoto", anim_name = "photopose_01_idle_famousgunslinger_04", name = "Micah Double Gun Pose"},
    {anim_dict = "cnv_camp@rchso@cnv@cfun2", anim_name = "gen_male_b_action", name = "Sit Ground"},
    {anim_dict = "script_story@gry3@ig@ig_1_meetbillmicah", anim_name = "full_walk_standing", name = "Leaning Side 2"},
    {anim_dict = "script_rc@gun5@ig@stage_01@ig3_bellposes", anim_name = "pose_03_idle_famousgunslinger_05", name = "Shoulder Rifle"},
    {anim_dict = "amb_rest_lean@world_human_lean_fence_fwd_check_out_livestock@male_e@idle_a", anim_name = "idle_a", name = "Leaning On Shoulder"}
}
-- {anim_dict = "", anim_name = "", name = ""},
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
    {scenario = "WORLD_HUMAN_BARTENDER_CLEAN_GLASS", name = "Bartender Clean Glass", female = true, male = true},
    {scenario = "WORLD_HUMAN_GUARD_LEAN_WALL", name = "Guard Lean", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_BACK_RAILING_DRINKING", name = "Lean Back Railing Drink", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_BACK_WALL", name = "Lean Back Wall", female = true, male = true},
    {scenario = "WORLD_HUMAN_SEAT_LEDGE", name = "Seat Ledge", female = true, male = true},
    {scenario = "MP_LOBBY_PROP_HUMAN_SEAT_BENCH_PORCH_DRINKING", name = "Seat Bench Drinking", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_PORCH_DRINKING_MOONSHINE", name = "Seat Bench Drinking Moonshine", female = false, male = true},
    {scenario = "MP_LOBBY_PROP_HUMAN_SEAT_BENCH_PORCH_SMOKING", name = "Seat Bench Smoking", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_FAN", name = "Seat Chair Fan", female = true, male = false},
    {scenario = "MP_LOBBY_PROP_HUMAN_SEAT_CHAIR", name = "Seat Chair", female = true, male = true},
    {scenario = "MP_LOBBY_PROP_HUMAN_SEAT_CHAIR_KNIFE_BADASS", name = "Seat Chair Knife Badass", female = true, male = true},
    {scenario = "MP_LOBBY_PROP_HUMAN_SEAT_CHAIR_WHITTLE", name = "Seat Chair Whittle", female = true, male = true},
    {scenario = "PROP_CAMP_JACK_ES_READ_SEAT", name = "Read Seat", female = true, male = true},
    {scenario = "WORLD_HUMAN_SIT_GROUND_READING", name = "Read Ground", female = true, male = true},
    {scenario = "PROP_CAMP_JAVIER_SEAT_CRATE_BRUSH_HAT", name = "Seat Brush Hat", female = false, male = true},
    {scenario = "PROP_CAMP_MICAH_SEAT_CHAIR_CLEAN_GUN", name = "Seat Clean Gun", female = false, male = true},
    {scenario = "PROP_CAMP_SEAT_CHAIR_CRAFT_POISON_KNIVES", name = "Seat Chair Craft Poisin Knives", female = false, male = true},
    {scenario = "PROP_HUMAN_CAMP_FIRE_SEAT_BOX", name = "Campfire Seat Box", female = true, male = true},
    {scenario = "PROP_HUMAN_REPAIR_WAGON_WHEEL_ON_SMALL", name = "Repair Small Wheel", female = false, male = true},
    {scenario = "PROP_HUMAN_REPAIR_WAGON_WHEEL_ON_LARGE", name = "Repair Large Wheel", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH", name = "Seat Bench", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_BACK", name = "Bench Back", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_TIRED", name = "Seat Bench Tired", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_TIRED_SHAKY", name = "Seat Bench Tired Shaky", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_CIGAR", name = "Seat Chair Cigar", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_SMOKING", name = "Seat Chair Smoking", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_CLEAN_SADDLE", name = "Chair Clean Saddle", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_DRINKING_MOONSHINE", name = "Chair Moonshine", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_FISHING_ROD", name = "Chair Fishing Rod", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_SKETCHING", name = "Chair Sketching", female = true, male = true},
    {scenario = "PROP_HUMAN_SEAT_CRATE_CLEAN_BOOTS", name = "Seat Clean Boots", female = false, male = true},
    {scenario = "PROP_HUMAN_SLEEP_BED_PILLOW_HIGH", name = "Sleep", female = false, male = true},
    {scenario = "WORLD_HUMAN_FAN", name = "Stand Fan", female = true, male = false},
    {scenario = "WORLD_CAMP_DUTCH_SMOKE_CIGAR", name = "Stand Cigar", female = false, male = true},
    {scenario = "WORLD_CAMP_FIRE_LAY_BACK_GROUND", name = "Lay Back", female = false, male = true},
    {scenario = "WORLD_CAMP_FIRE_LAY_GROUND_SIDE", name = "Lay Side", female = true, male = true},
    {scenario = "WORLD_CAMP_FIRE_SEATED_GROUND", name = "Fire Sit", female = true, male = true},
    {scenario = "WORLD_CAMP_FIRE_STANDING", name = "Stand Smoking", female = false, male = true},
    {scenario = "WORLD_CAMP_GUARD_COLD", name = "Guard Cold", female = false, male = true},
    {scenario = "WORLD_CAMP_JACK_SKY", name = "Look at Sky", female = false, male = true},
    {scenario = "WORLD_CAMP_JACK_THROWS_ROCKS_CASUAL", name = "Throwing Rocks", female = false, male = true},
    {scenario = "WORLD_CAMP_JACK_THROWS_ROCKS_LEDGE", name = "Throwing Rocks Ledge", female = false, male = true},
    {scenario = "WORLD_CAMP_JAVIER_KNIFE", name = "Knife Game", female = false, male = true},
    {scenario = "WORLD_CAMP_LENNY_GUARD_CROUCH_TRACKS", name = "Guard Crouch", female = false, male = true},
    {scenario = "WORLD_HUMAN_COFFEE_DRINK", name = "Stand Coffee", female = true, male = true},
    {scenario = "WORLD_HUMAN_WAITING_IMPATIENT", name = "Stand Waiting", female = true, male = true},
    {scenario = "WORLD_HUMAN_VOMIT_KNEEL", name = "Vomit Kneel", female = false, male = true},
    {scenario = "WORLD_HUMAN_VOMIT", name = "Vomit", female = false, male = true},
    {scenario = "WORLD_HUMAN_SIT_SMOKE", name = "Sit Smoke", female = true, male = true},
    {scenario = "WORLD_HUMAN_LEAN_BACK_WALL_SMOKING", name = "Lean Back Smoking", female = true, male = false},
    {scenario = "WORLD_HUMAN_SIT_GROUND_WHITTLE", name = "Sit Ground Whittle", female = false, male = true},
    {scenario = "WORLD_HUMAN_SIT_GROUND_READ_NEWSPAPER", name = "Sit Ground Read Newspaper", female = false, male = true},
    {scenario = "WORLD_HUMAN_SIT_GROUND_COFFEE_DRINK", name = "Sit Ground Coffee Drink", female = true, male = true},
    {scenario = "WORLD_HUMAN_SIT_GROUND", name = "Sit Ground", female = true, male = true},
    {scenario = "WORLD_HUMAN_SIT_DRINK", name = "Sit Ground Drink", female = true, male = true},
    {scenario = "WORLD_HUMAN_SHOPKEEPER", name = "Shopkeeper", female = true, male = true},
    {scenario = "WORLD_HUMAN_LEAN_WALL_LEFT", name = "Lean Wall Left", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_TABLE_SHARPEN_KNIFE", name = "Lean Table Sharpen Knife", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_RAILING_SMOKING", name = "Lean Railing Smoke Pipe", female = true, male = true},
    {scenario = "WORLD_HUMAN_LEAN_RAILING_NO_PROPS", name = "Lean Railing", female = true, male = true},
    {scenario = "WORLD_HUMAN_LEAN_RAILING_DYNAMIC", name = "Lean Railing Dynamic", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_RAILING_DRINKING", name = "Lean Railing Drinking", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_POST_RIGHT", name = "Lean Post Right", female = true, male = true},
    {scenario = "WORLD_HUMAN_LEAN_POST_LEFT", name = "Lean Post Left", female = true, male = true},
    {scenario = "WORLD_HUMAN_LEAN_CHECK_PISTOL", name = "Lean Check Pistol", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_BARREL", name = "Lean Barrel", female = false, male = true},
    {scenario = "WORLD_HUMAN_LEAN_BACK_WHITTLE", name = "Lean Back Whittle", female = false, male = true},
    {scenario = "WORLD_HUMAN_GUARD_LEAN_WALL", name = "Guard Lean", female = false, male = true},
    {scenario = "WORLD_HUMAN_GUARD_MILITARY", name = "Guard Military", female = false, male = true},
    {scenario = "WORLD_HUMAN_GUARD_SCOUT", name = "Guard Scout", female = true, male = true},
    {scenario = "WORLD_HUMAN_GRAVE_MOURNING", name = "Grave Mourning", female = true, male = true},
    {scenario = "WORLD_HUMAN_GRAVE_MOURNING_KNEEL", name = "Grave Mourning Kneel", female = true, male = true},
    {scenario = "WORLD_HUMAN_DRINK_FLASK", name = "Drink Flask", female = false, male = true},
    {scenario = "WORLD_HUMAN_DRINK_CHAMPAGNE", name = "Drink Champagne", female = true, male = true},
    {scenario = "WORLD_HUMAN_CROUCH_INSPECT", name = "Crouch Inspect", female = true, male = true},
    {scenario = "WORLD_HUMAN_COFFEE_DRINK_WIP", name = "Drink Coffee", female = true, male = true},
    {scenario = "WORLD_HUMAN_DRINKING", name = "Stand Drinking", female = true, male = true},
    {scenario = "WORLD_HUMAN_DRINKING_DRUNK", name = "Drinking Drunk", female = false, male = true},
    {scenario = "WORLD_HUMAN_DRINKING_DRUNK_MOONSHINE", name = "Drinking Moonshine Drunk", female = false, male = true},
    {scenario = "WORLD_HUMAN_DRINKING_MOONSHINE", name = "Stand Drinking Moonshine", female = true, male = true},
    {scenario = "PROP_HUMAN_PIANO", name = "Piano", female = false, male = true},
    {scenario = "PROP_HUMAN_PIANO_RIVERBOAT", name = "Piano Riverboat", female = false, male = true},
    {scenario = "PROP_HUMAN_PIANO_SKETCHY", name = "Piano Sketchy", female = false, male = true},
    {scenario = "PROP_HUMAN_PIANO_UPPERCLASS", name = "Piano UpperClass", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_CONCERTINA", name = "Accordion", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_CONCERTINA_DOWNBEAT", name = "Accordion Downbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_CONCERTINA_UPBEAT", name = "Accordion Upbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_HARMONICA", name = "Harmonica", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_HARMONICA_DOWNBEAT", name = "Harmonica Downbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_HARMONICA_UPBEAT", name = "Harmonica Upbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_JAW_HARP", name = "Jaw Harp", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_JAW_HARP_DOWNBEAT", name = "Jaw Harp Downbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_JAW_HARP_UPBEAT", name = "Jaw Harp Upbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_BENCH_MANDOLIN", name = "Mandolin", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_BANJO", name = "Banjo", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_BANJO_DOWNBEAT", name = "Banjo Downbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_BANJO_UPBEAT", name = "Banjo Upbeat", female = false, male = true},
    {scenario = "WORLD_HUMAN_SIT_GUITAR", name = "Guitar", female = false, male = true},
    {scenario = "WORLD_HUMAN_SIT_GUITAR_DOWNBEAT", name = "Guitar Downbeat", female = false, male = true},
    {scenario = "WORLD_HUMAN_SIT_GUITAR_UPBEAT", name = "Guitar Upbeat", female = false, male = true},
    {scenario = "PROP_HUMAN_SEAT_CHAIR_GUITAR", name = "Guitar Seat", female = false, male = true},
    {scenario = "WORLD_HUMAN_TRUMPET", name = "Trumpet", female = false, male = true},
    {scenario = "PROP_HUMAN_ABIGAIL_PIANO", name = "Piano Female", female = true, male = false},
    {scenario = "PROP_HUMAN_SEAT_BENCH_FIDDLE", name = "Fiddle Female", female = true, male = false},
    {scenario = "WORLD_HUMAN_STERNGUY_IDLES", name = "Stern Guy idle", female = false, male = true},
}
-- {scenario = "", name = "", female = true, male = true},

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
        natives.task_taskPlayAnim(ped, anim_dict, anim_name, anim_speed, anim_speed, -1, flags, 0.0, false, 0, false, "", false)
    end
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
    if natives.ped_isPedUsingAnyScenario(ped) then
        natives.task_clearPedTasksImmediately(ped, true, true)
    end

    local x, y, z = natives.entity_getEntityCoords(ped, true, true)
    local ground_z = z
    if find_ground then
        local found, new_ground_z = utility.getGroundZAtCoords(x, y, z + 1.0)
        if found then
            ground_z = new_ground_z
        end
    end
    local heading = natives.entity_getEntityHeading(ped)
    natives.task_taskStartScenarioAtPosition(ped, natives.misc_getHashKey(scenario), x, y, ground_z, heading, 0, true, true, '', 0, false)
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
    natives.misc_displayOnscreenKeyboard(0, "Type an animation", "", "", "", "", "", 255)

    local function keyboard_tick()
        local status = natives.misc_updateOnscreenKeyboard()

        if status == 1 then
            local input_text = natives.misc_getOnscreenKeyboardResult()
            if input_text and input_text ~= "" then
                input_text = string.lower(input_text)
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
                    if #suggestions > 0 then
                        logger.logInfo("Search Results: " .. table.concat(suggestions, ", "))
                    else
                        logger.logError("No matches found for: " .. input_text)
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

menu.addButton('self', '~t~Manual Input', '', function()
    input_box()
end)

menu.addDivider('self', 'Misc')

menu.addToggleButton('self', '~t~Walking Animations', '', walking, function(toggle)
    walking = toggle
end)

menu.addFloatSpinner('self', '~t~Animation Speed', '', 0.1, 10.0, 0.1, anim_speed, function(value)
    anim_speed = value
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

menu.addToggleButton(advanced_id, 'Play Animations on Scenarios', 'May not work on every scenario', play_anim_on_scenario, function(toggle)
    play_anim_on_scenario = toggle
end)

menu.addToggleButton(advanced_id, 'Find Ground', 'Automatically finds the ground level for scenarios.', find_ground, function(toggle)
    find_ground = toggle
end)

menu.addDivider(advanced_id, 'Spawner')

local ped_model_names = {"Arthur", "Female", "Debug"}
local ped_models = {0x0D7114C9, 0x2B769669, 0x4304BF5C}

local model_index = 1

menu.addStringSpinner(advanced_id, 'Select Ped Model', '', model_index - 1, ped_model_names, function(value_idx)
    model_index = value_idx + 1
end)

menu.addButton(advanced_id, 'Spawn Ped', '', function()
    if not spawned_ped or not natives.entity_doesEntityExist(spawned_ped) then
        if cloned_ped and natives.entity_doesEntityExist(cloned_ped) then
            logger.logError("A cloned ped already exists.")
            notifications.alertDanger("Animations.lua", "A cloned ped already exists.")
            return
        end
        local x, y, z = player.getLocalPedCoords()
        local model_hash = ped_models[model_index]
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
        if not spawned_ped or not natives.entity_doesEntityExist(spawned_ped) then
            logger.logError("Failed to spawn ped.")
            notifications.alertDanger("Animations.lua", "Failed to spawn ped.")
        end
    else
        logger.logError("A spawned ped already exists.")
        notifications.alertDanger("Animations.lua", "A spawned ped already exists.")
    end
end)

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

menu.addToggleButton(advanced_id, 'Play Anims on Spawned Ped', '', play_on_spawned_ped, function(toggle)
    play_on_spawned_ped = toggle
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

menu.addButton(advanced_id, 'Delete Spawned Peds', '', function()
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