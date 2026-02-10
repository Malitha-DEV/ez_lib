---@class BlipData
---@field name string
---@field sprite integer
---@field color integer
---@field scale number

---@param coords vector3 | vector4
---@param data BlipData
local function createBlip(coords, data)
    if not data then return end

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite (blip, data.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, data.scale)
    SetBlipColour (blip, data.color)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(data.name)
    EndTextCommandSetBlipName(blip)

    return blip
end

local function hasJob(jobs)
    if type(jobs) == 'string' then
        jobs = { jobs } ---@cast jobs string[]
    end

    for _, job in ipairs(jobs) do
        if job == Framework.getJob() then
            return true
        end
    end

    return false
end

-- Custom dispatch
RegisterNetEvent('ez_lib:dispatch:call')
AddEventHandler('ez_lib:dispatch:call', function(coords, data, jobs)
    if hasJob(jobs) then
        lib.notify({
            title = data.Code,
            description = data.Message,
            position = 'top-right',
            duration = 10000,
            style = {
                width = 330,
                backgroundColor = '#0d3482',
                color = '#FFFFFF',
                padding = 20,
            },
            icon = 'shield-halved',
        })
        local blip = createBlip(coords, {
            name = data.Title,
            sprite = data.Sprite or 161, 
            scale = 2.0, 
            color = 0
        })
        Citizen.SetTimeout(30000, function()
            RemoveBlip(blip)
        end)
    end
end)
