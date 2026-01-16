local RSGCore = exports['rsg-core']:GetCoreObject()

-- simple cache for server-side plant tracking
local ServerPlants = {} 

-- Shop Logic
local ShopBaseName = "farming_supplies"

CreateThread(function()
    Wait(1000)
    if Config.ShopNPCs then
        for i, shop in pairs(Config.ShopNPCs) do
            local shopData = {
                name = ShopBaseName .. "_" .. i,
                label = "Farming Supplies",
                coords = shop.coords,
                items = Config.ShopItems
            }
            exports['rsg-inventory']:CreateShop(shopData)
        end
    end
end)

RegisterNetEvent('rsg-farming:server:openShop', function(index)
    local src = source
    local shopId = index or 1
    exports['rsg-inventory']:OpenShop(src, ShopBaseName .. "_" .. shopId)
end)


-- Initialize and Load Plants
Citizen.CreateThread(function()
    MySQL.query('SELECT * FROM rsg_farming', {}, function(result)
        if result and #result > 0 then
            for i = 1, #result do
                local data = json.decode(result[i].data)
                data.id = result[i].id
                ServerPlants[result[i].id] = data
            end
        end
    end)
end)

-- MAINTENANCE LOOP: Health, Water, Growth
CreateThread(function()
    while true do
        Wait(60000) -- Run every 1 minute
        local updated = false
        local batchUpdates = {}
        
        for id, plant in pairs(ServerPlants) do
            local changed = false
            
            -- Get plant data for calculations
            local plantType = plant.type or plant.plantname
            local seedData = Config.Seeds[plantType]
            local growthTimeMinutes = 5 -- Default 5 min local
            if seedData and seedData.totaltime then
                growthTimeMinutes = seedData.totaltime
            end

            -- 1. Water Decay
            -- Logic: We want the user to water roughly 3 times during the growth cycle.
            -- So water capacity (100) should last (growthTime / 3) minutes.
            -- Decay per minute = 100 / (growthTime / 3) = 300 / growthTime.
            local decayRate = 300 / growthTimeMinutes
            
            -- Keep decay reasonable (min 2, max 50?)
            decayRate = math.max(2, math.min(50, decayRate))

            if plant.water and plant.water > 0 then
                plant.water = math.max(0, plant.water - decayRate)
                changed = true
            end
            
            -- 2. Growth Logic (Server Side)
			-- Initialize growth if missing
			if not plant.growth then 
                plant.growth = 0 
                changed = true 
            end

            if plant.water and plant.water > 0 and plant.growth < 100 then
                 -- Calculate increment per minute: 100 / growthTime
                 local increment = 100 / growthTimeMinutes
                 
                 -- Fertilizer Bonus (35% faster)
                 if plant.fertilized then
                     increment = increment * 1.35
                 end
                 
                 plant.growth = math.min(100, plant.growth + increment)
                 changed = true
            end
            
            -- 3. Health Decay logic
            if not plant.health then plant.health = 100 end
            
            -- If water < 20, damage health
            if plant.water and plant.water < 20 then
                 plant.health = math.max(0, plant.health - 5)
                 changed = true
            end
            
            -- 4. Check Death
            if plant.health <= 0 then
                -- Plant dies
                if ServerPlants[id] then
                    ServerPlants[id] = nil
                    MySQL.query('DELETE FROM rsg_farming WHERE id = ?', {id})
                    TriggerClientEvent('rsg-farming:client:removePlant', -1, id)
                end
                changed = false -- Plant removed, no update needed
            end

            if changed and ServerPlants[id] then
                ServerPlants[id] = plant
                MySQL.update('UPDATE rsg_farming SET data = ? WHERE id = ?', {json.encode(plant), id})
                -- Collect for batch sync
                batchUpdates[id] = plant
                updated = true
            end
        end
        
        -- Send BATCH update to all clients (One network event instead of N)
        if updated then
            TriggerClientEvent('rsg-farming:client:syncPlantsBatch', -1, batchUpdates)
        end
    end
end)


-- Helper: Add elapsed time to plant data for client sync
function PreparePlantForClient(plant)
    -- Simply return the plant data as the server is now the source of truth for growth
    return plant
end

-- Event: Player Requests Plant Data
RegisterNetEvent('rsg-farming:server:requestPlants', function()
    local src = source
    local clientPlants = {}
    for id, plant in pairs(ServerPlants) do
        clientPlants[id] = PreparePlantForClient(plant)
    end
    TriggerClientEvent('rsg-farming:client:syncPlants', src, clientPlants)
end)


-- Event: Player Plants a Seed
RegisterNetEvent('rsg-farming:server:plantSeed', function(plantData)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end

    -- Initialize Stats
    plantData.health = 100
    plantData.weed = 0
    plantData.water = 0 
    plantData.growth = 0
    plantData.fertilized = false

    MySQL.insert('INSERT INTO rsg_farming (citizenid, plantname, data) VALUES (?, ?, ?)',
        {Player.PlayerData.citizenid, plantData.type, json.encode(plantData)}, function(id)
        
        plantData.id = id
        ServerPlants[id] = plantData
        TriggerClientEvent('rsg-farming:client:addPlant', -1, plantData) -- Sync to all
    end)
end)

-- Event: Update Plant Status (Water/Fertilize/Growth)
RegisterNetEvent('rsg-farming:server:updatePlant', function(plantId, newData)
    if ServerPlants[plantId] then
        ServerPlants[plantId] = newData
        MySQL.update('UPDATE rsg_farming SET data = ? WHERE id = ?', {json.encode(newData), plantId})
        TriggerClientEvent('rsg-farming:client:updatePlant', -1, plantId, newData)
    end
end)

-- Event: Remove Weeds
RegisterNetEvent('rsg-farming:server:removeWeeds', function(plantId)
    local src = source
    if ServerPlants[plantId] then
        ServerPlants[plantId].weed = 0
        MySQL.update('UPDATE rsg_farming SET data = ? WHERE id = ?', {json.encode(ServerPlants[plantId]), plantId})
        TriggerClientEvent('rsg-farming:client:updatePlant', -1, plantId, PreparePlantForClient(ServerPlants[plantId]))
        TriggerClientEvent('ox_lib:notify', src, { title = 'Success', description = 'Weeds removed!', type = 'success' })
    end
end)

-- Event: Remove Plant (Harvest/Death)
RegisterNetEvent('rsg-farming:server:removePlant', function(plantId)
    if ServerPlants[plantId] then
        ServerPlants[plantId] = nil
        MySQL.query('DELETE FROM rsg_farming WHERE id = ?', {plantId})
        TriggerClientEvent('rsg-farming:client:removePlant', -1, plantId)
    end
end)

-- Event: Harvest Reward
RegisterNetEvent('rsg-farming:server:harvest', function(plantId)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local plant = ServerPlants[plantId]
    
    if plant and Player then
        -- Check if plant needs water (vanilla check)
        if not plant.water or plant.water < 0 then
             -- Relaxed this check slightly since water decays, but essentially it shouldn't be dry?
             -- Actually, let's just check Health for harvest capability
        end

        -- Health Check: Cannot harvest if too unhealthy
        if plant.health and plant.health < 20 then
            TriggerClientEvent('ox_lib:notify', src, { title = 'Error', description = 'Plant is too unhealthy to harvest!', type = 'error' })
            return
        end
        
        -- Check if plant is fully grown
        if plant.growth < 100 then
             TriggerClientEvent('ox_lib:notify', src, { 
                title = 'Not Ready', 
                description = string.format('Crop is at %d%% growth', math.floor(plant.growth or 0)), 
                type = 'error' 
            })
            return
        end
        
        local seedData = Config.Seeds[plant.type]
        if seedData then
            -- Yield calculation based on health
            local healthFactor = (plant.health or 100) / 100
            local baseReward = seedData.rewardcount
            
            -- Fertilizer Bonus (+50% Yield)
            if plant.fertilized then
                baseReward = math.ceil(baseReward * 1.5)
            end
            
            local finalCount = math.max(1, math.floor(baseReward * healthFactor))
            
            Player.Functions.AddItem(seedData.rewarditem, finalCount)
            TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items[seedData.rewarditem], "add")
            
            TriggerClientEvent('ox_lib:notify', src, { 
                title = 'Harvested!', 
                description = 'You harvested ' .. finalCount .. 'x ' .. seedData.rewarditem .. ' (Quality: ' .. math.floor(healthFactor * 100) .. '%)', 
                type = 'success' 
            })
            
            -- Remove plant after harvest
            ServerPlants[plantId] = nil
            MySQL.query('DELETE FROM rsg_farming WHERE id = ?', {plantId})
            TriggerClientEvent('rsg-farming:client:removePlant', -1, plantId)
        end
    end
end)


-- Event: Fertilize Plant
RegisterNetEvent('rsg-farming:server:fertilizePlant', function(plantId)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local plant = ServerPlants[plantId]

    if plant and Player then
        if Player.Functions.RemoveItem('fertilizer', 1) then
            plant.fertilized = true
            
            -- If plant was already watered, adjust elapsed time to account for speed boost?
            -- It's complex to retroactively apply speed boost.
            -- Simplification: Speed boost applies to total duration check logic dynamically.
            
            ServerPlants[plantId] = plant
            MySQL.update('UPDATE rsg_farming SET data = ? WHERE id = ?', {json.encode(plant), plantId})
            TriggerClientEvent('rsg-farming:client:updatePlant', -1, plantId, PreparePlantForClient(plant))
            TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items['fertilizer'], "remove")
            TriggerClientEvent('ox_lib:notify', src, { title = 'Success', description = 'Plant fertilized! Growth speed +35%, Yield +50%', type = 'success' })
        else
            TriggerClientEvent('ox_lib:notify', src, { title = 'Error', description = 'You need fertilizer', type = 'error' })
        end
    end
end)


-- Event: Give Water (Called from Client when filling bucket)
RegisterNetEvent('rsg-farming:server:fillBucket', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player then
        if Player.Functions.RemoveItem('emptybucket', 1) then
            Player.Functions.AddItem('fullbucket', 1, nil, { uses = 10 })
            TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items['fullbucket'], "add")
            TriggerClientEvent('ox_lib:notify', src, { title = 'Success', description = 'Bucket filled with water (10 uses)', type = 'success' })
        else
            TriggerClientEvent('ox_lib:notify', src, { title = 'Error', description = 'You need an empty bucket', type = 'error' })
        end
    end
end)


-- Event: Water Plant
local BUCKET_MAX_USES = 10

RegisterNetEvent('rsg-farming:server:waterPlant', function(plantId)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local plant = ServerPlants[plantId]
    
    if plant and Player then
        -- Check for fullbucket with uses tracking
        local bucket = Player.Functions.GetItemByName('fullbucket')
        local wateringCan = not bucket and Player.Functions.GetItemByName('wateringcan_full')
        
        if bucket or wateringCan then
            
            if bucket then
                -- Get current uses (default to BUCKET_MAX_USES if new bucket)
                local uses = (bucket.info and bucket.info.uses) or BUCKET_MAX_USES
                uses = uses - 1
                
                if uses <= 0 then
                    -- Bucket is empty, replace with empty bucket
                    Player.Functions.RemoveItem('fullbucket', 1, bucket.slot)
                    Player.Functions.AddItem('emptybucket', 1)
                    TriggerClientEvent('rsg-inventory:client:ItemBox', src, RSGCore.Shared.Items['emptybucket'], "add")
                    TriggerClientEvent('ox_lib:notify', src, { title = 'Info', description = 'Bucket is now empty!', type = 'inform' })
                else
                    -- Update bucket uses
                    Player.Functions.RemoveItem('fullbucket', 1, bucket.slot)
                    Player.Functions.AddItem('fullbucket', 1, nil, { uses = uses })
                    TriggerClientEvent('ox_lib:notify', src, { title = 'Info', description = 'Bucket uses remaining: ' .. uses, type = 'inform' })
                end
            elseif wateringCan then
                -- Watering can empties after one use
                Player.Functions.RemoveItem('wateringcan_full', 1, wateringCan.slot)
                Player.Functions.AddItem('wateringcan_empty', 1)
            end
            
            -- Update plant water level
            plant.water = 100
            
            ServerPlants[plantId] = plant
            MySQL.update('UPDATE rsg_farming SET data = ? WHERE id = ?', {json.encode(plant), plantId})
            TriggerClientEvent('rsg-farming:client:updatePlant', -1, plantId, plant)
            
            TriggerClientEvent('ox_lib:notify', src, { title = 'Success', description = 'Plant watered! Growth has started.', type = 'success' })
        else
            TriggerClientEvent('ox_lib:notify', src, { title = 'Error', description = 'You need a full bucket or watering can', type = 'error' })
        end
    end
end)


-- Event: Destroy Plant
RegisterNetEvent('rsg-farming:server:destroyPlant', function(plantId)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    
    if ServerPlants[plantId] and Player then
        ServerPlants[plantId] = nil
        MySQL.query('DELETE FROM rsg_farming WHERE id = ?', {plantId})
        TriggerClientEvent('rsg-farming:client:removePlant', -1, plantId)
        TriggerClientEvent('ox_lib:notify', src, { title = 'Success', description = 'Plant destroyed', type = 'success' })
    end
end)

-- Usable Items
RSGCore.Functions.CreateUseableItem('fullbucket', function(source, item)
    local src = source
    TriggerClientEvent('rsg-farming:client:useWater', src)
end)

RSGCore.Functions.CreateUseableItem('wateringcan_full', function(source, item)
    local src = source
    TriggerClientEvent('rsg-farming:client:useWater', src)
end)

for plantName, data in pairs(Config.Seeds) do
    RSGCore.Functions.CreateUseableItem(data.seedname, function(source, item)
        local src = source
        -- Remove seed from inventory
        local Player = RSGCore.Functions.GetPlayer(src)
        if Player and Player.Functions.RemoveItem(data.seedname, data.seedreq or 1) then
            TriggerClientEvent('rsg-farming:client:useSeed', src, plantName)
        else
            TriggerClientEvent('ox_lib:notify', src, { title = 'Error', description = 'Not enough seeds', type = 'error' })
        end
    end)
end
