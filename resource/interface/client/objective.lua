local isOpen = false

---@param title string
---@param content string
function ez.showObjective(title, content)
    if not title or not content then return end
    
    isOpen = true
    SendNUIMessage({
        action = 'showObjective',
        data = {
            title = title,
            content = content
        }
    })
end

function ez.hideObjective()
    isOpen = false
    SendNUIMessage({ action = 'hideObjective' })   
end

function ez.isObjectiveActive()
    return isOpen
end
