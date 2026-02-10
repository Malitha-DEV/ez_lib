---@meta
--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>

    This code is basically Linden's code, we've just edited some lines to our preferencies, but 99% of the code is Linden's ox_lib code
]]

---@class InputDialogRowProps
---@field type 'input' | 'number' | 'checkbox' | 'select' | 'multi-select' | 'slider' | 'color' | 'date' | 'date-range' | 'time' | 'textarea'
---@field label string
---@field default? any
---@field password? boolean
---@field icon? string
---@field placeholder? string
---@field disabled? boolean
---@field options? { value: string, label: string }[]
---@field checked? boolean
---@field min? number
---@field max? number
---@field step? number
---@field autosize? boolean
---@field required? boolean
---@field format? string
---@field returnString? boolean
---@field clearable? boolean
---@field searchable? boolean
---@field description? string
---@field maxSelectedValues? number

---@class InputDialogOptionsProps
---@field allowCancel? boolean

---@param heading string
---@param rows string[] | InputDialogRowProps[]
---@param options InputDialogOptionsProps[]?
---@return string[] | number[] | boolean[] | nil
function ez.inputDialog(heading, rows, options)
    if input then return end
    input = promise.new()

    -- Backwards compat with string tables
    for i = 1, #rows do
        if type(rows[i]) == 'string' then
            rows[i] = { type = 'input', label = rows[i] --[[@as string]] }
        end
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openDialog',
        data = {
            heading = heading,
            rows = rows,
            options = options
        }
    })

    return Citizen.Await(input)
end

RegisterNUICallback('inputData', function(data, cb)
    cb(1)
    SetNuiFocus(false, false)
    local p = input
    input = nil

    if not data then return p:resolve(nil) end

    p:resolve(data)
end)
