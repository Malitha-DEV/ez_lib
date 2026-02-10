---@meta
--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>

    This code is basically Linden's code, we've just edited some lines to our preferencies, but 99% of the code is Linden's ox_lib code
]]

---@type promise?
local alert = nil
local alertId = 0

---@class AlertDialogProps
---@field header string;
---@field content string;
---@field typing? boolean;
---@field cancel? boolean?;
---@field labels? {cancel?: string, confirm?: string}

---@param data AlertDialogProps
---@param timeout? number Force the window to timeout after `x` milliseconds.
---@return 'cancel' | 'confirm' | nil
function ez.alertDialog(data, timeout)
    if alert then return end

    local id = alertId + 1
    alertId = id
    alert = promise.new()

    SetNuiFocus(true, true)

    SendNUIMessage({
        action = 'sendAlert',
        data = data
    })

    if timeout then
        SetTimeout(timeout, function()
            if id == alertId and alert then
                SendNUIMessage({ action = 'closeAlertDialog' })
            end
        end)
    end

    return Citizen.Await(alert)
end

RegisterNUICallback('closeAlert', function(status, cb)
    cb(1)
    SetNuiFocus(false, false)
    local p = alert
    alertId = 0
    alert = nil
    p:resolve(status)
end)
