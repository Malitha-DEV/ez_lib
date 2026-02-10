---@class NotifyProps
---@field title? string
---@field description string
---@field type? 'success' | 'inform' | 'error' Default error
---@field duration? integer In milliseconds, default 5000ms

---@param data NotifyProps
function ez.notify(data)
    SendNUIMessage({
        action = 'notify',
        data = data
    })
end
