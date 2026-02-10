---@meta
--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>

    This code is basically Linden's code, we've just edited some lines to our preferencies, but 99% of the code is Linden's ox_lib code
]]

---@class TextUIOptions
---@field key string
---@field text string

local isOpen = false

---@param options TextUIOptions[]
function ez.showTextUI(options)
    if not options or type(options) ~= 'table' then
        error('expected table, received: %s', type(options))
    end

    SendNUIMessage({
        action = 'textUi',
        data = options
    })

    isOpen = true
end

function ez.hideTextUI()
    SendNUIMessage({
        action = 'textUiHide'
    })

    isOpen = false
end

---@return boolean, string | nil
function ez.isTextUIOpen() return isOpen end
