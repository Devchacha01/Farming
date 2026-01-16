Config = {}
Config.Debug = false

-- Keybinds (Standard RedM/RSG keys)
Config.Keys = {
    ["G"] = 0x760A9C6F,
    ["F"] = 0xB2F377E8,
    ["BACKSPACE"] = 0x156F7119,
    ["ENTER"] = 0xC7B5340A,
    ["E"] = 0xCEFD9220,
    ["SHIFT"] = 0x8FFC75D6,
    ["LALT"] = 0x8AAA0AD4,
    ["B"] = 0x4CC0E2FE,
    ["J"] = 0xF3830D8E, 
}

Config.EnableBannedZones = true
Config.BannedZones = {
    -- Town Name, Radius
    { coords = vector3(-179.52, 626.71, 114.09), radius = 50.0, name = "Valentine" },
    { coords = vector3(-315.34, 733.91, 117.8), radius = 100.0, name = "Valentine Station" },
    { coords = vector3(2725.68, -1251.15, 49.62), radius = 150.0, name = "Saint Denis" },
    { coords = vector3(1346.04, -1320.18, 77.01), radius = 80.0, name = "Rhodes" }, 
    { coords = vector3(-812.96, -1320.57, 43.68), radius = 100.0, name = "Blackwater" },
    { coords = vector3(-3684.69, -2600.67, -13.62), radius = 100.0, name = "Armadillo" },
    { coords = vector3(2924.96, 1332.22, 44.55), radius = 80.0, name = "Annesburg" },
    { coords = vector3(-1782.9, -391.24, 156.96), radius = 50.0, name = "Strawberry" },
    { coords = vector3(-5244.59, -3013.31, -5.69), radius = 80.0, name = "Tumbleweed" },
}

Config.DrawText = true
Config.RenderDistance = 20.0
Config.PlantSpace = 1.5
Config.RequestUpdateTime = 2 -- minutes

Config.Items = {
    water = "water", -- Item given when filling bucket/drinking
    emptybucket = "bucket", -- Item required to fill water (optional logic)
    fullbucket = "fullbucket", -- Item given after filling
    fertilizer = "fertilizer",
    trimmer = "shears", 
}

-- Farming Shop NPC
-- Farming Shop NPCs
Config.ShopNPCs = {
    {
        coords = vector3(2842.99, -1235.43, 47.67),
        heading = 180.0,
        model = "A_M_M_UniBoatCrew_01",
        blip = {
            enabled = true,
            sprite = "blip_shop_store", -- Valid General Store Icon from rsg-shops
            -- color = "BLIP_MODIFIER_MP_COLOR_32",
            label = "Farming Supplies"
        }
    },
    {
        coords = vector3(-370.96, 754.50, 115.71),
        heading = 180.0,
        model = "A_M_M_UniBoatCrew_01",
        blip = {
            enabled = true,
            sprite = "blip_shop_store", -- Valid General Store Icon
            -- color = "BLIP_MODIFIER_MP_COLOR_32",
            label = "Farming Supplies"
        }
    },
    {
        coords = vector3(-756.16, -1318.13, 43.77),
        heading = 260.85,
        model = "A_M_M_UniBoatCrew_01",
        blip = {
            enabled = true,
            sprite = "blip_shop_store",
            label = "Farming Supplies"
        }
    },
    {
        coords = vector3(-3692.92, -2628.55, -13.69),
        heading = 88.10,
        model = "A_M_M_UniBoatCrew_01",
        blip = {
            enabled = true,
            sprite = "blip_shop_store",
            label = "Farming Supplies"
        }
    }
}







-- Water Interaction Settings
Config.WaterTypes = {
    [1] =  {["name"] = "Sea of Coronado",       ["waterhash"] = -247856387, ["watertype"] = "lake"},
    [2] =  {["name"] = "San Luis River",        ["waterhash"] = -1504425495, ["watertype"] = "river"},
    [3] =  {["name"] = "Lake Don Julio",        ["waterhash"] = -1369817450, ["watertype"] = "lake"},
    [4] =  {["name"] = "Flat Iron Lake",        ["waterhash"] = -1356490953, ["watertype"] = "lake"},
    [5] =  {["name"] = "Upper Montana River",   ["waterhash"] = -1781130443, ["watertype"] = "river"},
    [6] =  {["name"] = "Owanjila",              ["waterhash"] = -1300497193, ["watertype"] = "river"},
    [7] =  {["name"] = "HawkEye Creek",         ["waterhash"] = -1276586360, ["watertype"] = "river"},
    [8] =  {["name"] = "Little Creek River",    ["waterhash"] = -1410384421, ["watertype"] = "river"},
    [9] =  {["name"] = "Dakota River",          ["waterhash"] = 370072007, ["watertype"] = "river"},
    [10] =  {["name"] = "Beartooth Beck",       ["waterhash"] = 650214731, ["watertype"] = "river"},
    [11] =  {["name"] = "Lake Isabella",        ["waterhash"] = 592454541, ["watertype"] = "lake"},
    [12] =  {["name"] = "Cattail Pond",         ["waterhash"] = -804804953, ["watertype"] = "lake"},
    [13] =  {["name"] = "Deadboot Creek",       ["waterhash"] = 1245451421, ["watertype"] = "river"},
    [14] =  {["name"] = "Spider Gorge",         ["waterhash"] = -218679770, ["watertype"] = "river"},
    [15] =  {["name"] = "O'Creagh's Run",       ["waterhash"] = -1817904483, ["watertype"] = "lake"},
    [16] =  {["name"] = "Moonstone Pond",       ["waterhash"] = -811730579, ["watertype"] = "lake"},
    [17] =  {["name"] = "Roanoke Valley",       ["waterhash"] = -1229593481, ["watertype"] = "river"},
    [18] =  {["name"] = "Elysian Pool",         ["waterhash"] = -105598602, ["watertype"] = "lake"},
    [19] =  {["name"] = "Lannahechee River",    ["waterhash"] = -2040708515, ["watertype"] = "river"},
    [20] =  {["name"] = "Dakota River",         ["waterhash"] = 370072007, ["watertype"] = "river"},
    [21] =  {["name"] = "Random1",              ["waterhash"] = 231313522, ["watertype"] = "river"},
    [22] =  {["name"] = "Random2",              ["waterhash"] = 2005774838, ["watertype"] = "river"},
    [23] =  {["name"] = "Random3",              ["waterhash"] = -1287619521, ["watertype"] = "river"},
    [24] =  {["name"] = "Random4",              ["waterhash"] = -1308233316, ["watertype"] = "river"},
    [25] =  {["name"] = "Random5",              ["waterhash"] = -196675805, ["watertype"] = "river"},
}

Config.Seeds = {
    ["Alaskan Ginseng"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_ab_sim", minGrowth = 0 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 50, offset = 0.0 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 90, offset = 0.0 }
        },
        seedname = "alaskan_ginseng_seed",
        seedreq = 2,
        rewarditem = "alaskan_ginseng",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Pumpkin"] = {
        prop = "p_pumpkin_02x",
        stages = {
            { prop = "crp_ginseng_ab_sim", minGrowth = 0, offset = 0.0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "p_pumpkin_02x", minGrowth = 80 }
        },
        seedname = "pumpkin_seed",
        seedreq = 1,
        rewarditem = "pumpkin",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 2000,
        offset = -0.05,
    },
    ["American Ginseng"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_ab_sim", minGrowth = 0 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 50, offset = 0.0 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 90, offset = 0.0 }
        },
        seedname = "american_ginseng_seed",
        seedreq = 2,
        rewarditem = "american_ginseng",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Hop"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 80, offset = 0.0 }
        },
        seedname = "hop_seed",
        seedreq = 2,
        rewarditem = "hop",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 2000,
        offset = 0.2,
    },
    ["Pepper"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 80, offset = 0.0 }
        },
        seedname = "pepper_seed",
        seedreq = 2,
        rewarditem = "pimenta",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Black Currant"] = {
        prop = "crp_berry_har_aa_sim",
        stages = {
            { prop = "crp_berry_sap_aa_sim", minGrowth = 0 },
            { prop = "crp_berry_aa_sim", minGrowth = 40 },
            { prop = "crp_berry_har_aa_sim", minGrowth = 85 }
        },
        seedname = "black_currant_seed",
        seedreq = 2,
        rewarditem = "black_currant",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Blood Flower"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 80, offset = 0.0 }
        },
        seedname = "blood_flower_seed",
        seedreq = 2,
        rewarditem = "Blood_Flower",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Choc Daisy"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 80, offset = 0.0 }
        },
        seedname = "choc_daisy_seed",
        seedreq = 2,
        rewarditem = "Choc_Daisy",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Coffee"] = {
        prop = "crp_berry_har_aa_sim",
        stages = {
            { prop = "crp_berry_sap_aa_sim", minGrowth = 0 },
            { prop = "crp_berry_aa_sim", minGrowth = 33 },
            { prop = "crp_berry_har_aa_sim", minGrowth = 66 }
        },
        seedname = "coffee_seed",
        seedreq = 2,
        rewarditem = "coffeebeans",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Creekplum"] = {
        prop = "crp_berry_har_aa_sim",
        stages = {
            { prop = "crp_berry_sap_aa_sim", minGrowth = 0 },
            { prop = "crp_berry_aa_sim", minGrowth = 40 },
            { prop = "crp_berry_har_aa_sim", minGrowth = 85 }
        },
        seedname = "creekplum_seed",
        seedreq = 2,
        rewarditem = "creekplum",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Creeking Thyme"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 80, offset = 0.0 }
        },
        seedname = "Creeking_Thyme_Seed",
        seedreq = 2,
        rewarditem = "Creeking_Thyme",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Crows Garlic"] = {
        prop = "crp_potato_aa_sim",
        stages = {
            { prop = "crp_ginseng_ab_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 50 },
            { prop = "crp_potato_aa_sim", minGrowth = 90 }
        },
        seedname = "crows_garlic_seed",
        seedreq = 2,
        rewarditem = "crows_garlic",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["English Mace"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 80, offset = 0.0 }
        },
        seedname = "English_Mace_Seed",
        seedreq = 2,
        rewarditem = "English_Mace",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Tobacco"] = {
        prop = "crp_tobaccoplant_bc_sim",
        stages = {
            { prop = "crp_tobaccoplant_ca_sim", minGrowth = 0 },
            { prop = "crp_tobaccoplant_bb_sim", minGrowth = 33 },
            { prop = "crp_tobaccoplant_bc_sim", minGrowth = 66 }
        },
        seedname = "tobacco_seed",
        seedreq = 2,
        rewarditem = "tobacco",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 2500,
        offset = 0.2,
    },
    ["Milk Weed"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 80, offset = 0.0 }
        },
        seedname = "milk_weed_seed",
        seedreq = 2,
        rewarditem = "milk_weed",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Oleander Sage"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 80, offset = 0.0 }
        },
        seedname = "oleander_sage_seed",
        seedreq = 2,
        rewarditem = "oleander_sage",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Oregano"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 80, offset = 0.0 }
        },
        seedname = "Oregano_Seed",
        seedreq = 2,
        rewarditem = "Oregano",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Parasol Mushroom"] = {
        prop = "s_inv_parasol",
        seedname = "parasol_mushroom_seed",
        seedreq = 2,
        rewarditem = "parasol_mushroom",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Prairie Poppy"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 80, offset = 0.0 }
        },
        seedname = "prairie_poppy_seed",
        seedreq = 2,
        rewarditem = "prairie_poppy",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Red Raspberry"] = {
        prop = "crp_berry_har_aa_sim",
        stages = {
            { prop = "crp_berry_sap_aa_sim", minGrowth = 0 },
            { prop = "crp_berry_aa_sim", minGrowth = 40 },
            { prop = "crp_berry_har_aa_sim", minGrowth = 85 }
        },
        seedname = "red_raspberry_seed",
        seedreq = 2,
        rewarditem = "red_raspberry",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Red Sage"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 80, offset = 0.0 }
        },
        seedname = "red_sage_seed",
        seedreq = 2,
        rewarditem = "red_sage",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Tea"] = {
        prop = "crp_tobaccoplant_bc_sim",
        stages = {
            { prop = "crp_tobaccoplant_ba_sim", minGrowth = 0 },
            { prop = "crp_tobaccoplant_bb_sim", minGrowth = 33 },
            { prop = "crp_tobaccoplant_bc_sim", minGrowth = 66 }
        },
        seedname = "teaseeds",
        seedreq = 2,
        rewarditem = "tealeaf",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 2500,
        offset = 0.2,
    },
    ["Wild Carrot"] = {
        prop = "crp_carrots_ba_sim",
        stages = {
            { prop = "crp_carrots_sap_ba_sim", minGrowth = 0 },
            { prop = "crp_carrots_aa_sim", minGrowth = 33 },
            { prop = "crp_carrots_ba_sim", minGrowth = 66, offset = 0.0 }
        },
        seedname = "wild_carrot_seed",
        seedreq = 2,
        rewarditem = "wild_carrot",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Wild Mint"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 80, offset = 0.0 }
        },
        seedname = "wild_mint_seed",
        seedreq = 2,
        rewarditem = "wild_mint",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Wintergreen Berry"] = {
        prop = "crp_berry_har_aa_sim",
        stages = {
            { prop = "crp_berry_sap_aa_sim", minGrowth = 0 },
            { prop = "crp_berry_aa_sim", minGrowth = 40 },
            { prop = "crp_berry_har_aa_sim", minGrowth = 85 }
        },
        seedname = "wintergreen_berry_seed",
        seedreq = 2,
        rewarditem = "wintergreen_berry",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Yarrow"] = {
        prop = "crp_ginseng_ba_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_potato_aa_sim", minGrowth = 40 },
            { prop = "crp_ginseng_ba_sim", minGrowth = 80, offset = 0.0 }
        },
        seedname = "yarrow_seed",
        seedreq = 2,
        rewarditem = "yarrow",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Corn"] = {
        prop = "crp_cornstalks_cb_sim", -- Default (Stage 1)
        stages = {
            -- Stage 1: Young (0-33%)
            { prop = "crp_cornstalks_cb_sim", minGrowth = 0 },
            -- Stage 2: Medium (33-66%)
            { prop = "crp_cornstalks_ca_sim", minGrowth = 33 },
            -- Stage 3: Mature (66-100%)
            { prop = "crp_cornstalks_ab_sim", minGrowth = 66, offset = 2.5 }
        },
        seedname = "corn_seed",
        seedreq = 2,
        rewarditem = "Corn",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2, -- Height offset may need adjustment per stage, but fixed for now
    },
    ["Apple"] = {
        prop = "p_tree_orange_01",
        seedname = "apple_seed",
        seedreq = 2,
        rewarditem = "Apple",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 3000,
        offset = 0.5,
    },
    ["Sugar"] = {
        prop = "crp_sugarcane_ad_sim", -- Default (Mature)
        stages = {
            { prop = "crp_sugarcane_aa_sim", minGrowth = 0 },  -- Young
            { prop = "crp_sugarcane_ab_sim", minGrowth = 50 }, -- Medium
            { prop = "crp_sugarcane_ad_sim", minGrowth = 90 }  -- Mature/Harvest
        },
        seedname = "sugarcaneseed",
        seedreq = 2,
        rewarditem = "cana",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 2000,
        offset = 0.2,
    },
    ["Potato"] = {
        prop = "crp_potato_aa_sim",
        stages = {
            { prop = "crp_ginseng_ab_sim", minGrowth = 0, offset = 0.0 },
            { prop = "crp_potato_aa_sim", minGrowth = 50 },
            { prop = "crp_potato_aa_sim", minGrowth = 90 }
        },
        seedname = "potato_seed",
        seedreq = 2,
        rewarditem = "Potato",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Peach"] = {
        prop = "p_tree_orange_01",
        seedname = "peachseeds",
        seedreq = 2,
        rewarditem = "consumable_peach",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 3000,
        offset = 0.5,
    },
    ["Cherry"] = {
        prop = "crp_berry_har_aa_sim",
        stages = {
            { prop = "crp_berry_sap_aa_sim", minGrowth = 0 },
            { prop = "crp_berry_aa_sim", minGrowth = 40 },
            { prop = "crp_berry_har_aa_sim", minGrowth = 85 }
        },
        seedname = "cherry_seed",
        seedreq = 2,
        rewarditem = "cherry",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 3000,
        offset = 0.5,
    },
    ["Wheat"] = {
        prop = "crp_wheat_dry_long_aa_sim", -- Default
        stages = {
            { prop = "crp_wheat_sap_long_aa_sim", minGrowth = 0 },  -- Young
            { prop = "crp_wheat_sap_long_ab_sim", minGrowth = 50 }, -- Mature Green
            { prop = "crp_wheat_dry_long_aa_sim", minGrowth = 90 }  -- Harvest Dry
        },
        seedname = "wheat_seed",
        seedreq = 2,
        rewarditem = "wheat",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 3000,
        offset = 0.5,
    },

    ["Lemon"] = {
        prop = "p_tree_orange_01",
        seedname = "lemon_seed",
        seedreq = 2,
        rewarditem = "lemon",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 3000,
        offset = 0.5,
    },
    ["Barley"] = {
        prop = "crp_wheat_dry_long_aa_sim",
        stages = {
            { prop = "crp_wheat_sap_long_aa_sim", minGrowth = 0 },
            { prop = "crp_wheat_sap_long_ab_sim", minGrowth = 50 },
            { prop = "crp_wheat_dry_long_aa_sim", minGrowth = 90 }
        },
        seedname = "barley_seed",
        seedreq = 2,
        rewarditem = "barley",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 3000,
        offset = 0.5,
    },
    ["Banana"] = {
        prop = "p_tree_banana_01_lg",
        seedname = "banana_seed",
        seedreq = 2,
        rewarditem = "banana",
        rewardcount = 6,
        timetowater = 10,
        totaltime = 15,
        difficulty = 3000,
        offset = 0.5,
    },
    ["Tomato"] = {
        prop = "crp_tomatoes_har_aa_sim", -- Default
        stages = {
            { prop = "crp_tomatoes_sap_aa_sim", minGrowth = 0 },  -- Young
            { prop = "crp_tomatoes_aa_sim", minGrowth = 50 },     -- Flowering
            { prop = "crp_tomatoes_har_aa_sim", minGrowth = 90 }  -- Ripe
        },
        seedname = "tomato_seed",
        seedreq = 2,
        rewarditem = "tomato",
        rewardcount = 4,
        timetowater = 10,
        totaltime = 15,
        difficulty = 4000,
        offset = 0.2,
    },
    ["Lettuce"] = {
        prop = "crp_lettuce_aa_sim",
        stages = {
            { prop = "s_inv_wildmint01x", minGrowth = 0 },   -- Generic Sprout (Young)
            { prop = "crp_lettuce_aa_sim", minGrowth = 50 }, -- Growing
            { prop = "crp_lettuce_aa_sim", minGrowth = 90 }  -- Mature
        },
        seedname = "lettuce_seed",
        seedreq = 2,
        rewarditem = "lettuce",
        rewardcount = 4,
        timetowater = 10,
        totaltime = 15,
        difficulty = 3000,
        offset = 0.2,
    },
    ["Broccoli"] = {
        prop = "crp_broccoli_aa_sim",
        stages = {
            { prop = "crp_ginseng_aa_sim", minGrowth = 0 },
            { prop = "crp_lettuce_aa_sim", minGrowth = 40 },
            { prop = "crp_broccoli_aa_sim", minGrowth = 80 }
        },
        seedname = "broccoli_seed",
        seedreq = 2,
        rewarditem = "broccoli",
        rewardcount = 4,
        timetowater = 10,
        totaltime = 15,
        difficulty = 3000,
        offset = 0.2,
    },
}

-- Defines the Shop Items (Tools + Manual Seed List)
Config.ShopItems = {
    -- Tools
    { name = 'bucket',                  price = 2,  amount = 100, info = {}, type = "item", slot = 1 },
    { name = 'fertilizer',              price = 5,  amount = 100, info = {}, type = "item", slot = 2 },
    { name = 'shovel',                  price = 5,  amount = 100, info = {}, type = "item", slot = 3 },
    
    -- Seeds
    { name = "alaskan_ginseng_seed",    price = 2,  amount = 100, info = {}, type = "item", slot = 4 },
    { name = "american_ginseng_seed",   price = 2,  amount = 100, info = {}, type = "item", slot = 5 },
    { name = "hop_seed",                price = 2,  amount = 100, info = {}, type = "item", slot = 6 },
    { name = "black_currant_seed",      price = 2,  amount = 100, info = {}, type = "item", slot = 7 },
    { name = "creekplum_seed",          price = 2,  amount = 100, info = {}, type = "item", slot = 8 },
    { name = "crows_garlic_seed",       price = 2,  amount = 100, info = {}, type = "item", slot = 9 },
    { name = "indian_tobbaco_seed",     price = 2,  amount = 100, info = {}, type = "item", slot = 10 },
    { name = "milk_weed_seed",          price = 2,  amount = 100, info = {}, type = "item", slot = 11 },
    { name = "oleander_sage_seed",      price = 2,  amount = 100, info = {}, type = "item", slot = 12 },
    { name = "parasol_mushroom_seed",   price = 2,  amount = 100, info = {}, type = "item", slot = 13 },
    { name = "prairie_poppy_seed",      price = 2,  amount = 100, info = {}, type = "item", slot = 14 },
    { name = "red_raspberry_seed",      price = 2,  amount = 100, info = {}, type = "item", slot = 15 },
    { name = "red_sage_seed",           price = 2,  amount = 100, info = {}, type = "item", slot = 16 },
    { name = "wild_carrot_seed",        price = 2,  amount = 100, info = {}, type = "item", slot = 17 },
    { name = "wild_mint_seed",          price = 2,  amount = 100, info = {}, type = "item", slot = 18 },
    { name = "wintergreen_berry_seed",  price = 2,  amount = 100, info = {}, type = "item", slot = 19 },
    { name = "yarrow_seed",             price = 2,  amount = 100, info = {}, type = "item", slot = 20 },
    { name = "corn_seed",               price = 2,  amount = 100, info = {}, type = "item", slot = 21 },
    { name = "apple_seed",              price = 2,  amount = 100, info = {}, type = "item", slot = 22 },
    { name = "potato_seed",             price = 2,  amount = 100, info = {}, type = "item", slot = 23 },
    { name = "wheat_seed",              price = 2,  amount = 100, info = {}, type = "item", slot = 24 },
    { name = "pumpkin_seed",            price = 2,  amount = 100, info = {}, type = "item", slot = 25 },
    { name = "coffee_seed",             price = 2,  amount = 100, info = {}, type = "item", slot = 26 },
    { name = "pepper_seed",             price = 2,  amount = 100, info = {}, type = "item", slot = 27 },
    { name = "blood_flower_seed",       price = 2,  amount = 100, info = {}, type = "item", slot = 28 },
    { name = "choc_daisy_seed",         price = 2,  amount = 100, info = {}, type = "item", slot = 29 },
    { name = "hummingbird_sage_seed",   price = 2,  amount = 100, info = {}, type = "item", slot = 30 },
    { name = "tobacco_seed",            price = 2,  amount = 100, info = {}, type = "item", slot = 31 },
    { name = "cherry_seed",             price = 2,  amount = 100, info = {}, type = "item", slot = 32 },
    { name = "lemon_seed",              price = 2,  amount = 100, info = {}, type = "item", slot = 33 },
    { name = "barley_seed",             price = 2,  amount = 100, info = {}, type = "item", slot = 34 },
    { name = "banana_seed",             price = 2,  amount = 100, info = {}, type = "item", slot = 35 },
    { name = "lettuce_seed",            price = 2,  amount = 100, info = {}, type = "item", slot = 36 },
    { name = "broccoli_seed",           price = 2,  amount = 100, info = {}, type = "item", slot = 37 },
    { name = "sugarcaneseed",           price = 2,  amount = 100, info = {}, type = "item", slot = 38 },
    { name = "tomato_seed",             price = 2,  amount = 100, info = {}, type = "item", slot = 39 },
    { name = "teaseeds",                price = 2,  amount = 100, info = {}, type = "item", slot = 40 },
    { name = "English_Mace_Seed",       price = 2,  amount = 100, info = {}, type = "item", slot = 41 },
    { name = "Oregano_Seed",            price = 2,  amount = 100, info = {}, type = "item", slot = 42 },
    { name = "Creeking_Thyme_Seed",     price = 2,  amount = 100, info = {}, type = "item", slot = 43 },
}
