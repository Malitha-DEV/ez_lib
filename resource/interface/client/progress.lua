---@meta
--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>

    This code is basically Linden's code, we've just edited some lines to our preferencies, but 99% of the code is Linden's ox_lib code
]]

local progress
local DisableControlAction = DisableControlAction
local DisablePlayerFiring = DisablePlayerFiring
local playerState = LocalPlayer.state
local createdProps = {}

---@class ProgressPropProps
---@field model string
---@field bone? number
---@field pos vector3
---@field rot vector3
---@field rotOrder? number

---@class ProgressProps
---@field label? string
---@field duration number
---@field useWhileDead? boolean
---@field allowRagdoll? boolean
---@field allowCuffed? boolean
---@field allowFalling? boolean
---@field allowSwimming? boolean
---@field canCancel? boolean
---@field anim? { dict?: string, clip: string, flag?: number, blendIn?: number, blendOut?: number, duration?: number, playbackRate?: number, lockX?: boolean, lockY?: boolean, lockZ?: boolean, scenario?: string, playEnter?: boolean }
---@field prop? ProgressPropProps | ProgressPropProps[]
---@field disable? { move?: boolean, sprint?: boolean, car?: boolean, combat?: boolean, mouse?: boolean }

local function createProp(ped, prop)
    lib.requestModel(prop.model)
    local coords = GetEntityCoords(ped)
    local object = CreateObject(prop.model, coords.x, coords.y, coords.z, false, false, false)

    AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, prop.bone or 60309), prop.pos.x, prop.pos.y, prop.pos.z, prop.rot.x, prop.rot.y, prop.rot.z, true,
        true, false, true, prop.rotOrder or 0, true)
    SetModelAsNoLongerNeeded(prop.model)

    return object
end

local function interruptProgress(data)
    if not data.useWhileDead and IsEntityDead(cache.ped) then return true end
    if not data.allowRagdoll and IsPedRagdoll(cache.ped) then return true end
    if not data.allowCuffed and IsPedCuffed(cache.ped) then return true end
    if not data.allowFalling and IsPedFalling(cache.ped) then return true end
    if not data.allowSwimming and IsPedSwimming(cache.ped) then return true end
end

local isFivem = cache.game == 'fivem'

local controls = {
    INPUT_LOOK_LR = isFivem and 1 or 0xA987235F,
    INPUT_LOOK_UD = isFivem and 2 or 0xD2047988,
    INPUT_SPRINT = isFivem and 21 or 0x8FFC75D6,
    INPUT_AIM = isFivem and 25 or 0xF84FA74F,
}

---@param data ProgressProps
---@return boolean?
function ez.progressBar(data)
    if progress then return end

    playerState.invBusy = true
    progress = data
    local anim = data.anim

    if anim then
        if anim.dict then
            lib.requestAnimDict(anim.dict)

            TaskPlayAnim(cache.ped, anim.dict, anim.clip, anim.blendIn or 3.0, anim.blendOut or 1.0, anim.duration or -1, anim.flag or 49, anim.playbackRate or 0,
                anim.lockX, anim.lockY, anim.lockZ)
            RemoveAnimDict(anim.dict)
        elseif anim.scenario then
            TaskStartScenarioInPlace(cache.ped, anim.scenario, 0, anim.playEnter == nil or anim.playEnter --[[@as boolean]])
        end
    end

    if data.prop then
        playerState:set('ez:progressProps', data.prop, true)
    end

    local disable = data.disable
    local startTime = GetGameTimer()

    while progress do
        if disable then
            if disable.mouse then
                DisableControlAction(0, controls.INPUT_LOOK_LR, true)
                DisableControlAction(0, controls.INPUT_LOOK_UD, true)
            end

            if disable.move then
                DisableControlAction(0, controls.INPUT_SPRINT, true)
                DisableControlAction(0, 30, true)
                DisableControlAction(0, 31, true)
            end

            if disable.sprint then
                DisableControlAction(0, controls.INPUT_SPRINT, true)
            end

            if disable.car then
                DisableControlAction(0, 63, true)
                DisableControlAction(0, 64, true)
                DisableControlAction(0, 71, true)
                DisableControlAction(0, 72, true)
                DisableControlAction(0, 75, true)
            end

            if disable.combat then
                DisableControlAction(0, controls.INPUT_AIM, true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisablePlayerFiring(cache.playerId, true)
            end
        end

        if interruptProgress(data) then
            progress = false
            break
        end

        Wait(0)
    end

    if data.prop then
        playerState:set('ez:progressProps', nil, true)
    end

    if anim then
        if anim.scenario then
            ClearPedTasksImmediately(cache.ped)
        else
            StopAnimTask(cache.ped, anim.dict, anim.clip, 1.0)
        end
    end

    local cancel = not progress or GetGameTimer() - startTime < data.duration

    SendNUIMessage({
        action = 'progressComplete',
        data = cancel
    })

    progress = nil
    playerState.invBusy = false

    return not cancel
end

---@param data ProgressProps
---@return boolean?
function ez.progressCircle(data)
    if progress then return end

    playerState.invBusy = true
    progress = data
    local anim = data.anim

    SendNUIMessage({
        action = 'progress',
        data = {
            label = data.label,
            duration = data.duration,
        }
    })

    if anim then
        if anim.dict then
            lib.requestAnimDict(anim.dict)

            TaskPlayAnim(cache.ped, anim.dict, anim.clip, anim.blendIn or 3.0, anim.blendOut or 1.0, anim.duration or -1, anim.flag or 49, anim.playbackRate or 0,
                anim.lockX, anim.lockY, anim.lockZ)
            RemoveAnimDict(anim.dict)
        elseif anim.scenario then
            TaskStartScenarioInPlace(cache.ped, anim.scenario, 0, anim.playEnter == nil or anim.playEnter --[[@as boolean]])
        end
    end

    if data.prop then
        playerState:set('ez:progressProps', data.prop, true)
    end

    local disable = data.disable
    local startTime = GetGameTimer()

    while progress do
        if disable then
            if disable.mouse then
                DisableControlAction(0, controls.INPUT_LOOK_LR, true)
                DisableControlAction(0, controls.INPUT_LOOK_UD, true)
            end

            if disable.move then
                DisableControlAction(0, controls.INPUT_SPRINT, true)
                DisableControlAction(0, 30, true)
                DisableControlAction(0, 31, true)
            end

            if disable.sprint then
                DisableControlAction(0, controls.INPUT_SPRINT, true)
            end

            if disable.car then
                DisableControlAction(0, 63, true)
                DisableControlAction(0, 64, true)
                DisableControlAction(0, 71, true)
                DisableControlAction(0, 72, true)
                DisableControlAction(0, 75, true)
            end

            if disable.combat then
                DisableControlAction(0, controls.INPUT_AIM, true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisablePlayerFiring(cache.playerId, true)
            end
        end

        if interruptProgress(data) then
            progress = false
            break
        end

        Wait(0)
    end

    if data.prop then
        playerState:set('ez:progressProps', nil, true)
    end

    if anim then
        if anim.scenario then
            ClearPedTasksImmediately(cache.ped)
        else
            StopAnimTask(cache.ped, anim.dict, anim.clip, 1.0)
        end
    end

    local cancel = not progress or GetGameTimer() - startTime < data.duration

    SendNUIMessage({
        action = 'progressComplete',
        data = cancel
    })

    progress = nil
    playerState.invBusy = false

    return not cancel
end

function ez.cancelProgress()
    if not progress then return end

    progress = false
end

RegisterCommand('cancelprogress', function()
    if progress?.canCancel then progress = false end
end)

if isFivem then
    RegisterKeyMapping('cancelprogress', 'Cancel progressbar', 'keyboard', 'x')
end

local function deleteProgressProps(serverId)
    local playerProps = createdProps[serverId]
    if not playerProps then return end
    for i = 1, #playerProps do
        local prop = playerProps[i]
        if DoesEntityExist(prop) then
            DeleteEntity(prop)
        end
    end
    createdProps[serverId] = nil
end

RegisterNetEvent('onPlayerDropped', function(serverId)
    deleteProgressProps(serverId)
end)

AddStateBagChangeHandler('ez:progressProps', nil, function(bagName, key, value, reserved, replicated)
    if replicated then return end

    local ply = GetPlayerFromStateBagName(bagName)
    if ply == 0 then return end

    local ped = GetPlayerPed(ply)
    local serverId = GetPlayerServerId(ply)

    if not value then
        return deleteProgressProps(serverId)
    end

    createdProps[serverId] = {}
    local playerProps = createdProps[serverId]

    if value.model then
        playerProps[#playerProps + 1] = createProp(ped, value)
    else
        for i = 1, #value do
            local prop = value[i]

            if prop then
                playerProps[#playerProps + 1] = createProp(ped, prop)
            end
        end
    end
end)
