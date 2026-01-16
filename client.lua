local RSGCore = exports['rsg-core']:GetCoreObject()
local PlayerData = {}
local Plants = {}
local RenderedPlants = {}

-- Ghost Placement Variables
local isPlacing = false
local ghostObject = nil
local currentPlantType = nil
local placementCoords = nil
local placementHeading = 0.0

-- Growth time in seconds (5 minutes)
local GROWTH_TIME = 300

--------------------------------------------------------------------------------
-- PLAYER LOAD/UNLOAD
--------------------------------------------------------------------------------
RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
    PlayerData = RSGCore.Functions.GetPlayerData()
    TriggerServerEvent('rsg-farming:server:requestPlants')
end)

RegisterNetEvent('RSGCore:Client:OnPlayerUnload', function()
    PlayerData = {}
    for k, v in pairs(RenderedPlants) do
        if DoesEntityExist(v) then DeleteObject(v) end
    end
    RenderedPlants = {}
    Plants = {}
end)

--------------------------------------------------------------------------------
-- NUI FUNCTIONS
--------------------------------------------------------------------------------
local menuOpen = false
local currentMenuPlantId = nil

function ShowPlantMenu(plantId)
    local plant = Plants[plantId]
    if not plant then return end
    
    menuOpen = true
    currentMenuPlantId = plantId
    SetNuiFocus(true, true)
    
    local waterPercent = plant.water or 0
    local healthPercent = plant.health or 100
    local weedPercent = plant.weed or 0
    local growthPercent = CalculateGrowth(plant)
    local timeRemaining = CalculateTimeRemaining(plant)
    
    SendNUIMessage({
        action = 'openPlantMenu',
        plantData = {
            id = plantId,
            type = plant.type,
            water = waterPercent,
            health = healthPercent,
            weed = weedPercent,
            fertilized = plant.fertilized,
            growth = growthPercent,
            timeRemaining = timeRemaining
        }
    })
end

function ShowProgress(title, duration)
    SendNUIMessage({
        action = 'showProgress',
        title = title,
        duration = duration
    })
end

function HideProgress()
    SendNUIMessage({ action = 'hideProgress' })
end

function ShowPopup(text, duration)
    SendNUIMessage({
        action = 'showPopup',
        text = text,
        duration = duration or 3000
    })
end

function HidePopup()
    SendNUIMessage({ action = 'hidePopup' })
end

-- Get current unix timestamp (client-safe)
function GetCurrentTime()
    -- Use network time or fallback to game timer approximation
    return GetNetworkTimeAccurate() / 1000
end

-- Calculate growth percentage based on server wateredTime
-- Calculate growth percentage based on server wateredTime
-- Calculate growth (Server Synced)
function CalculateGrowth(plant)
    return math.floor(plant.growth or 0)
end

-- Calculate time remaining based on growth percentage
function CalculateTimeRemaining(plant)
    local seedData = Config.Seeds[plant.type]
    -- Get total time in seconds (default 5 mins/300s if missing)
    local totalTimeSeconds = (seedData and seedData.totaltime and seedData.totaltime * 60) or 300
    
    local effectiveGrowthTime = totalTimeSeconds
    if plant.fertilized then
        effectiveGrowthTime = math.floor(totalTimeSeconds / 1.35) -- Matches server speed boost (1.35x rate)
    end

    local growth = plant.growth or 0
    if growth >= 100 then return 0 end
    
    local remainingPercent = 100 - growth
    local remainingSeconds = effectiveGrowthTime * (remainingPercent / 100)
    
    return math.ceil(remainingSeconds)
end

-- NUI Callbacks
RegisterNUICallback('plantAction', function(data, cb)
    cb('ok')
    menuOpen = false
    SetNuiFocus(false, false)
    
    local action = data.action
    local plantId = data.plantId
    
    if action == 'water' then
        WaterPlant(plantId)
    elseif action == 'harvest' then
        HarvestPlant(plantId)
    elseif action == 'destroy' then
        DestroyPlant(plantId)
    elseif action == 'removeWeeds' then
        RemoveWeeds(plantId)
    elseif action == 'fertilize' then
        FertilizePlant(plantId)
    end
end)

RegisterNUICallback('closeMenu', function(data, cb)
    cb('ok')
    menuOpen = false
    currentMenuPlantId = nil
    SetNuiFocus(false, false)
end)


--------------------------------------------------------------------------------
-- FARMING SHOP NPC (Third-Eye)
--------------------------------------------------------------------------------
local ShopEntities = {}

CreateThread(function()
    if not Config.ShopNPCs then return end
    
    for i, shop in pairs(Config.ShopNPCs) do
        local shopIndex = i
        local model = GetHashKey(shop.model)
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(10) end
        
        local ped = CreatePed(model, shop.coords.x, shop.coords.y, shop.coords.z - 1.0, shop.heading, false, false, false, false)
        Citizen.InvokeNative(0x283978A15512B2FE, ped, true) -- SetRandomOutfitVariation
        SetEntityAsMissionEntity(ped, true, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        
        local blip = nil
        -- Blip
        if shop.blip and shop.blip.enabled then
            -- 0x554D9D53F696D002 = AddBlipForCoord(style, x, y, z)
            blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, shop.coords.x, shop.coords.y, shop.coords.z)
            
            local spriteHash = shop.blip.sprite
            if type(spriteHash) == 'string' then spriteHash = GetHashKey(spriteHash) end
            SetBlipSprite(blip, spriteHash, true)
            
            -- SetBlipScale (0xD38744167B2FA257)
            Citizen.InvokeNative(0xD38744167B2FA257, blip, 0.5) -- Scale 0.5

            -- Blip Modifier (Color)
            if shop.blip.color then
                Citizen.InvokeNative(0x662D364ABF16DE2F, blip, GetHashKey(shop.blip.color)) -- BlipAddModifier
            end

            -- CreateVarString for Blip Label
            local blipName = CreateVarString(10, 'LITERAL_STRING', shop.blip.label)
            Citizen.InvokeNative(0x9CB1A1623062F402, blip, blipName) -- SetBlipNameFromPlayerString
        end
        
        table.insert(ShopEntities, { ped = ped, blip = blip })
        
        -- Interaction
        exports['rsg-target']:AddTargetEntity(ped, {
            options = {
                {
                    type = "client",
                    action = function()
                        TriggerServerEvent('rsg-farming:server:openShop', shopIndex)
                    end,
                    icon = "fas fa-seedling",
                    label = "Open Farming Shop",
                },
            },
            distance = 2.5,
        })
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    for _, entity in pairs(ShopEntities) do
        if entity.ped then DeletePed(entity.ped) end
        if entity.blip then RemoveBlip(entity.blip) end
    end
end)


-- ESC Key Handler Thread (prevents getting stuck)
CreateThread(function()
    while true do
        Wait(0)
        if menuOpen then
            if IsControlJustPressed(0, 0x156F7119) then -- BACKSPACE/ESC
                SetNuiFocus(false, false)
                SendNUIMessage({ action = 'closeMenu' })
                menuOpen = false
            end
        else
            Wait(500)
        end
    end
end)


--------------------------------------------------------------------------------
-- GHOST OBJECT PLACEMENT SYSTEM
--------------------------------------------------------------------------------
local function GetGroundZ(x, y, z)
    local found, groundZ = GetGroundZFor_3dCoord(x, y, z + 5.0, false)
    if found then
        return groundZ
    end
    return z
end

-- Forward declarations
local FinalizePlacement
local CancelPlacement

-- Cancel Placement Function
CancelPlacement = function()
    if DoesEntityExist(ghostObject) then
        DeleteObject(ghostObject)
        ghostObject = nil
    end
    isPlacing = false
    currentPlantType = nil
    placementCoords = nil
    HidePopup()
    exports.ox_lib:notify({ title = 'Cancelled', description = 'Planting cancelled', type = 'error' })
end

-- Finalize Placement Function
FinalizePlacement = function()
    if not isPlacing or not placementCoords then return end
    
    -- Delete ghost
    if DoesEntityExist(ghostObject) then
        DeleteObject(ghostObject)
        ghostObject = nil
    end
    
    HidePopup()
    ShowPopup('Planting ' .. currentPlantType .. '...', 5000)
    
    -- Play planting animation
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_FARMER_WEEDING'), -1, true, false, false, false)
    ShowProgress('Planting Seeds...', 5000)
    
    Wait(5000)
    ClearPedTasks(PlayerPedId())
    HideProgress()
    HidePopup()
    
    local plantData = {
        type = currentPlantType,
        coords = { x = placementCoords.x, y = placementCoords.y, z = placementCoords.z },
        heading = placementHeading,
        -- Default stats set by server, but client can init basic ones
        water = 0,
        growth = 0,
        stage = 1,
        plantedTime = GetGameTimer()
    }
    TriggerServerEvent('rsg-farming:server:plantSeed', plantData)
    
    isPlacing = false
    currentPlantType = nil
    placementCoords = nil
    
    ShowPopup('Seeds Planted!', 2000)
end

local function StartPlacement(plantType)
    if isPlacing then return end
    
    -- Shovel Check
    local hasShovel = exports['rsg-inventory']:HasItem('shovel', 1)
    if not hasShovel then
        exports.ox_lib:notify({ title = 'Error', description = 'You need a shovel to plant seeds!', type = 'error' })
        return
    end

    if Config.EnableBannedZones and Config.BannedZones then
        local pCoords = GetEntityCoords(PlayerPedId())
        for _, zone in pairs(Config.BannedZones) do
            if #(pCoords - zone.coords) < zone.radius then
                exports.ox_lib:notify({ title = 'Restricted Area', description = 'Farming is not allowed in ' .. zone.name, type = 'error' })
                return
            end
        end
    end
    
    local seedData = Config.Seeds[plantType]
    if not seedData then
        exports.ox_lib:notify({ title = 'Error', description = 'Invalid seed type', type = 'error' })
        return
    end
    
    isPlacing = true
    currentPlantType = plantType
    placementHeading = 0.0
    
    -- Determine Prop (Use Mature Stage if available)
    local propName = seedData.prop
    if seedData.stages and #seedData.stages > 0 then
        propName = seedData.stages[#seedData.stages].prop -- Use the last stage (Mature)
    end

    local model = GetHashKey(propName)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end
    
    local playerCoords = GetEntityCoords(PlayerPedId())
    local groundZ = GetGroundZ(playerCoords.x, playerCoords.y, playerCoords.z)
    
    ghostObject = CreateObject(model, playerCoords.x, playerCoords.y + 2.0, groundZ - (seedData.offset or 0.0), false, false, false)
    SetEntityAlpha(ghostObject, 150, false)
    SetEntityCollision(ghostObject, false, false)
    FreezeEntityPosition(ghostObject, true)
    
    ShowPopup('PLACE ' .. string.upper(plantType) .. ' • [Q/E] ROTATE • ENTER to Plant • BACKSPACE to Cancel', 0)

    
    CreateThread(function()
        while isPlacing do
            Wait(0)
            
            local playerCoords = GetEntityCoords(PlayerPedId())
            local camRot = GetGameplayCamRot(2)
            local forward = vector3(
                -math.sin(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)),
                math.cos(math.rad(camRot.z)) * math.cos(math.rad(camRot.x)),
                0.0
            )
            local right = vector3(
                math.cos(math.rad(camRot.z)),
                math.sin(math.rad(camRot.z)),
                0.0
            )
            
            -- Get ghost position (in front of player)
            local offset = 2.5
            local ghostPos = playerCoords + (forward * offset)
            
            -- Movement controls
            if IsControlPressed(0, 0x7065027D) then -- W
                ghostPos = ghostPos + (forward * 0.05)
            end
            if IsControlPressed(0, 0xD27782E3) then -- S
                ghostPos = ghostPos - (forward * 0.05)
            end
            if IsControlPressed(0, 0x05CA7C52) then -- A
                ghostPos = ghostPos - (right * 0.05)
            end
            if IsControlPressed(0, 0x6319DB71) then -- D
                ghostPos = ghostPos + (right * 0.05)
            end
            
            -- Rotation controls
            if IsControlPressed(0, 0xDE794E3E) then -- Q
                placementHeading = placementHeading + 1.0
            end
            if IsControlPressed(0, 0xCEFD9220) then -- E
                placementHeading = placementHeading - 1.0
            end
            
            -- Get ground Z for ghost position
            local groundZ = GetGroundZ(ghostPos.x, ghostPos.y, ghostPos.z)
            placementCoords = vector3(ghostPos.x, ghostPos.y, groundZ)
            
            -- Update ghost object position
            if DoesEntityExist(ghostObject) then
                SetEntityCoords(ghostObject, placementCoords.x, placementCoords.y, placementCoords.z - (seedData.offset or 0.0), false, false, false, false)
                SetEntityHeading(ghostObject, placementHeading)
            end
            
            -- Confirm placement
            if IsControlJustPressed(0, 0xC7B5340A) then -- ENTER
                FinalizePlacement()
            end
            
            -- Cancel placement
            if IsControlJustPressed(0, 0x156F7119) then -- BACKSPACE
                CancelPlacement()
            end
        end
    end)
end

--------------------------------------------------------------------------------
-- PLANT SYNC EVENTS
--------------------------------------------------------------------------------
RegisterNetEvent('rsg-farming:client:syncPlants', function(serverPlants)
    Plants = serverPlants or {}
    -- Optimization: Do NOT spawn all props here. The distance loop will handle it.
end)

RegisterNetEvent('rsg-farming:client:syncPlantsBatch', function(batchUpdates)
    for id, plant in pairs(batchUpdates) do
        -- Update local data
        -- Preserve currentModel if existing to prevent unnecessary flickering if model hasn't changed
        local oldModel = Plants[id] and Plants[id].currentModel
        Plants[id] = plant
        if oldModel then Plants[id].currentModel = oldModel end

        -- Refresh menu logic
        if menuOpen and currentMenuPlantId == id then
            ShowPlantMenu(id)
        end
    end
end)

RegisterNetEvent('rsg-farming:client:addPlant', function(plantData)
    Plants[plantData.id] = plantData
    SpawnPlantProp(plantData.id, plantData)
end)

RegisterNetEvent('rsg-farming:client:updatePlant', function(plantId, newData)
    Plants[plantId] = newData
    
    -- If menu is open for this plant, refresh it
    if menuOpen and currentMenuPlantId == plantId then
        ShowPlantMenu(plantId)
    end
end)

RegisterNetEvent('rsg-farming:client:removePlant', function(plantId)
    if RenderedPlants[plantId] then
        exports['rsg-target']:RemoveTargetEntity(RenderedPlants[plantId])
        DeleteObject(RenderedPlants[plantId])
        RenderedPlants[plantId] = nil
    end
    Plants[plantId] = nil
end)

--------------------------------------------------------------------------------
-- SPAWN PLANT PROP WITH THIRD-EYE
--------------------------------------------------------------------------------
-- Helper: Get Model based on Growth Stage
local function GetPlantModel(plantType, growthPercent)
    local seedData = Config.Seeds[plantType]
    if not seedData then return nil, nil end
    
    -- Default single prop
    local modelName = seedData.prop
    local activeStage = nil
    
    -- Multi-stage check
    if seedData.stages then
        for _, stage in ipairs(seedData.stages) do
            if growthPercent >= stage.minGrowth then
                modelName = stage.prop
                activeStage = stage
            end
        end
    end
    
    return GetHashKey(modelName), activeStage
end

function SpawnPlantProp(id, plant)
    local growth = CalculateGrowth(plant)
    local model, stageData = GetPlantModel(plant.type, growth)
    if not model then return end

    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(model) then return end
    
    local coords = vector3(plant.coords.x, plant.coords.y, plant.coords.z)
    local seedData = Config.Seeds[plant.type]
    local groundZ = GetGroundZ(coords.x, coords.y, coords.z)
    
    -- Check for updates to existing prop
    if RenderedPlants[id] then
        if plant.currentModel == model then
             return 
        else
             DeleteObject(RenderedPlants[id])
             RenderedPlants[id] = nil
        end
    end

    local obj = CreateObject(model, coords.x, coords.y, groundZ, false, false, false)
    SetEntityAsMissionEntity(obj, true, true)
    
    -- Determine offset: Check stage specific offset first, then fall back to global seed offset, then 0.0
    local finalOffset = seedData.offset or 0.0
    if stageData and stageData.offset then
        finalOffset = stageData.offset
    end

    -- Use explicit groundZ instead of PlaceObjectOnGroundProperly to prevent floating
    SetEntityCoords(obj, coords.x, coords.y, groundZ - finalOffset, false, false, false, false)
    
    FreezeEntityPosition(obj, true)
    SetEntityHeading(obj, plant.heading or 0.0)
    SetEntityCollision(obj, true, true)
    
    RenderedPlants[id] = obj
    
    -- Store current model hash on the entity object index for later comparison
    plant.currentModel = model 
    
    -- Add Third-Eye Target to Plant
    exports['rsg-target']:AddTargetEntity(obj, {
        options = {
            {
                type = "client",
                action = function()
                    ShowPlantMenu(id)
                end,
                icon = "fas fa-seedling",
                label = "Inspect Crop",
            },
        },
        distance = 7.0,
    })
end

--------------------------------------------------------------------------------
-- PLANT INTERACTION FUNCTIONS
--------------------------------------------------------------------------------

-- Helper function to properly clean up scenario animations and attached props
local function CleanupScenario(ped)
    ClearPedTasksImmediately(ped)
    
    -- Remove any props attached to hands (common bone IDs for hands)
    local handBones = {
        GetEntityBoneIndexByName(ped, "SKEL_L_Hand"),
        GetEntityBoneIndexByName(ped, "SKEL_R_Hand"),
        GetEntityBoneIndexByName(ped, "PH_L_Hand"),
        GetEntityBoneIndexByName(ped, "PH_R_Hand"),
    }
    
    -- Find and delete attached objects
    local coords = GetEntityCoords(ped)
    local objects = GetGamePool('CObject')
    for _, obj in pairs(objects) do
        if DoesEntityExist(obj) then
            local objCoords = GetEntityCoords(obj)
            local dist = #(coords - objCoords)
            if dist < 2.0 and IsEntityAttachedToEntity(obj, ped) then
                DeleteEntity(obj)
            end
        end
    end
end

function WaterPlant(plantId)
    local plant = Plants[plantId]
    if not plant then return end
    
    -- Check if player has water/bucket
    local hasWater = exports['rsg-inventory']:HasItem('fullbucket', 1)
    if not hasWater then
        exports.ox_lib:notify({ title = 'Error', description = 'You need a full bucket of water', type = 'error' })
        return
    end
    
    local ped = PlayerPedId()
    ShowPopup('Watering Crop...', 4000)
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_BUCKET_POUR_LOW'), -1, true, false, false, false)
    ShowProgress('Watering...', 4000)
    
    Wait(4000)
    CleanupScenario(ped)
    HideProgress()
    HidePopup()
    
    TriggerServerEvent('rsg-farming:server:waterPlant', plantId)
    ShowPopup('Crop Watered!', 2000)
end

function RemoveWeeds(plantId)
    local plant = Plants[plantId]
    if not plant then return end
    
    local ped = PlayerPedId()
    ShowPopup('Removing Weeds...', 5000)
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_FARMER_WEEDING'), -1, true, false, false, false)
    ShowProgress('Removing Weeds...', 5000)
    
    Wait(5000)
    CleanupScenario(ped)
    HideProgress()
    HidePopup()
    
    TriggerServerEvent('rsg-farming:server:removeWeeds', plantId)
    ShowPopup('Weeds Removed!', 2000)
end

function FertilizePlant(plantId)
    local plant = Plants[plantId]
    if not plant then return end
    
    local hasItem = exports['rsg-inventory']:HasItem('fertilizer', 1)
    if not hasItem then
        exports.ox_lib:notify({ title = 'Error', description = 'You need fertilizer', type = 'error' })
        return
    end

    local ped = PlayerPedId()
    ShowPopup('Fertilizing...', 4000)
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_FEED_CHICKEN'), -1, true, false, false, false)
    ShowProgress('Fertilizing...', 4000)
    
    Wait(4000)
    CleanupScenario(ped)
    HideProgress()
    HidePopup()
    
    TriggerServerEvent('rsg-farming:server:fertilizePlant', plantId)
end

function HarvestPlant(plantId)
    local plant = Plants[plantId]
    if not plant then return end
    
    -- Check if fully grown
    local growthPercent = CalculateGrowth(plant)
    if growthPercent < 100 then
        exports.ox_lib:notify({ title = 'Error', description = 'Crop is not ready to harvest yet', type = 'error' })
        return
    end
    
    local ped = PlayerPedId()
    ShowPopup('Harvesting Crop...', 5000)
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_FARMER_WEEDING'), -1, true, false, false, false)
    ShowProgress('Harvesting...', 5000)
    
    Wait(5000)
    CleanupScenario(ped)
    HideProgress()
    HidePopup()
    
    TriggerServerEvent('rsg-farming:server:harvest', plantId)
    ShowPopup('Crop Harvested!', 2000)
end

function DestroyPlant(plantId)
    local plant = Plants[plantId]
    if not plant then return end

    local ped = PlayerPedId()
    ShowPopup('Destroying Crop...', 3000)
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
    ShowProgress('Setting Fire...', 3000)
    
    -- Create fire effect at plant location
    local plantCoords = vector3(plant.coords.x, plant.coords.y, plant.coords.z)
    local fire = StartScriptFire(plantCoords.x, plantCoords.y, plantCoords.z, 25, false, false, false, 0)
    
    Wait(3000)
    
    RemoveScriptFire(fire)
    CleanupScenario(ped)
    HideProgress()
    HidePopup()
    
    TriggerServerEvent('rsg-farming:server:destroyPlant', plantId)
    ShowPopup('Crop Destroyed', 2000)
end

--------------------------------------------------------------------------------
-- USE SEED EVENT (Triggers Ghost Placement)
--------------------------------------------------------------------------------
RegisterNetEvent('rsg-farming:client:useSeed', function(plantType)
    StartPlacement(plantType)
end)

--------------------------------------------------------------------------------
-- WATER INTERACTION (Pumps & Natural Water)
--------------------------------------------------------------------------------

-- Action Handler
RegisterNetEvent('rsg-farming:client:waterAction', function(action)
    local ped = PlayerPedId()
    
    if action == 'fillBucket' then
        local hasBucket = exports['rsg-inventory']:HasItem('bucket', 1) 
        if not hasBucket then
             exports.ox_lib:notify({ title='Error', description='You need an empty bucket!', type='error' })
             return
        end
        TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_BUCKET_POUR_LOW'), -1, true, false, false, false)
        if lib.progressBar({
            duration = 4000,
            label = 'Filling Bucket...',
            useWhileDead = false,
            canCancel = true,
            disable = { move = true, car = true, combat = true },
        }) then
            CleanupScenario(ped)
            TriggerServerEvent('rsg-farming:server:fillBucket')
        else
            CleanupScenario(ped)
        end
        
    elseif action == 'drink' then
        TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_DRINKING'), -1, true, false, false, false)
        if lib.progressBar({
            duration = 5000,
            label = 'Drinking...',
            useWhileDead = false,
            canCancel = true,
            disable = { move = true, car = true, combat = true },
        }) then
            CleanupScenario(ped)
            TriggerServerEvent('rsg-farming:server:drinkWater')
        else
            CleanupScenario(ped)
        end
        
    elseif action == 'wash' then
        TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_WASH_FACE_BUCKET_GROUND'), -1, true, false, false, false)
        if lib.progressBar({
            duration = 5000,
            label = 'Washing...',
            useWhileDead = false,
            canCancel = true,
            disable = { move = true, car = true, combat = true },
        }) then
            CleanupScenario(ped)
            TriggerServerEvent('rsg-farming:server:washSelf')
        else
            CleanupScenario(ped)
        end
    end
end)

-- Pump Target (Third Eye)
CreateThread(function()
    local waterPumps = {'p_waterpump01x', 'p_waterpump01x_high'}
    exports['rsg-target']:AddTargetModel(waterPumps, {
        options = {
            {
                type = "client",
                action = function() TriggerEvent('rsg-farming:client:waterAction', 'fillBucket') end,
                icon = "fas fa-faucet",
                label = "Fill Bucket",
            },
            {
                type = "client",
                action = function() TriggerEvent('rsg-farming:client:waterAction', 'drink') end,
                icon = "fas fa-glass-water",
                label = "Drink",
            },
            {
                type = "client",
                action = function() TriggerEvent('rsg-farming:client:waterAction', 'wash') end,
                icon = "fas fa-soap",
                label = "Wash",
            },
        },
        distance = 2.0,
    })
end)

-- Main Render/Update Loop
CreateThread(function()
    while true do
        Wait(2000) -- Check every 2 seconds
        
        local pCoords = GetEntityCoords(PlayerPedId())
        
        for id, plant in pairs(Plants) do
            local dist = #(pCoords - vector3(plant.coords.x, plant.coords.y, plant.coords.z))
            
            if dist < Config.RenderDistance then
                -- Check if needs spawning OR updating
                if not RenderedPlants[id] then
                    SpawnPlantProp(id, plant)
                else
                    -- Check if model has changed (growth)
                    local growth = CalculateGrowth(plant)
                    local expectedModel, _ = GetPlantModel(plant.type, growth)
                    
                    if expectedModel and plant.currentModel ~= expectedModel then
                        -- Force update by calling spawn (it now handles delete-replace)
                        SpawnPlantProp(id, plant)
                    end
                end
            else
                -- Despawn if too far
                if RenderedPlants[id] then
                    if DoesEntityExist(RenderedPlants[id]) then
                        exports['rsg-target']:RemoveTargetEntity(RenderedPlants[id])
                        DeleteObject(RenderedPlants[id])
                    end
                    RenderedPlants[id] = nil
                end
            end
        end
    end
end)

-- Helper for 3D Text (Local definition ensures availability)
local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFontForCurrentCommand(1)
        SetTextColor(255, 255, 255, 215)
        local str = CreateVarString(10, "LITERAL_STRING", text)
        SetTextCentre(1)
        DisplayText(str, _x, _y)
    end
end

-- Natural Water Interaction (Ox Lib UI)
CreateThread(function()
    local textShown = false
    while true do
        local sleep = 1000
        
        if LocalPlayer.state.isLoggedIn then
            local ped = PlayerPedId()
            
            if IsEntityInWater(ped) and not IsPedInAnyVehicle(ped, true) then
                sleep = 0
                
                if not textShown then
                    lib.showTextUI('[ALT] Fill Bucket', { position = "right-center" })
                    textShown = true
                end
                
                if IsControlJustPressed(0, 0x8AAA0AD4) then -- LEFT ALT
                    TriggerEvent('rsg-farming:client:waterAction', 'fillBucket')
                end
            else
                if textShown then
                    lib.hideTextUI()
                    textShown = false
                end
            end
        end
        Wait(sleep)
    end
end)

--------------------------------------------------------------------------------
-- DISTANCE CULLING LOOP (Optimization)
--------------------------------------------------------------------------------
CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for id, plant in pairs(Plants) do
            local plantCoords = vector3(plant.coords.x, plant.coords.y, plant.coords.z)
            local dist = #(playerCoords - plantCoords)
            
            if dist < 50.0 then
                -- In Range: Spawn if not rendered
                if not RenderedPlants[id] then
                    SpawnPlantProp(id, plant)
                end
            else
                -- Out of Range: Delete if rendered
                if RenderedPlants[id] then
                     exports['rsg-target']:RemoveTargetEntity(RenderedPlants[id])
                     DeleteObject(RenderedPlants[id])
                     RenderedPlants[id] = nil
                     if plant.currentModel then plant.currentModel = nil end
                end
            end
        end
        Wait(1000) -- Check distance every second
    end
end)

--------------------------------------------------------------------------------
-- GROWTH STAGE UPDATE LOOP
--------------------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(5000) -- Check every 5 seconds
        
        for id, obj in pairs(RenderedPlants) do
            local plant = Plants[id]
            if plant and DoesEntityExist(obj) then
                local growth = CalculateGrowth(plant)
                local expectedModel = GetPlantModel(plant.type, growth)
                
                -- Check if model needs updating (using stored currentModel)
                if expectedModel and plant.currentModel ~= expectedModel then
                    -- Model changed! Respawn it.
                    -- We delete the old object and spawn the new one.
                    -- SpawnPlantProp will handle the mechanics.
                    
                    exports['rsg-target']:RemoveTargetEntity(obj)
                    DeleteObject(obj)
                    RenderedPlants[id] = nil
                    
                    SpawnPlantProp(id, plant)
                end
            end
        end
    end
end)
