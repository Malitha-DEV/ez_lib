---@diagnostic disable: duplicate-set-field
---@diagnostic disable: duplicate-doc-field

if GetResourceState('qb-core') ~= 'started' then return end

Framework = { name = 'qb-core' }
local sharedObject = exports['qb-core']:GetCoreObject()
Framework.object = sharedObject
QBCore = sharedObject
---@class Player
---@field source number
---@field QBPlayer any
local player = {}

function Framework.getPlayerFromId(id)
    local player = setmetatable({}, { __index = player })
    player.QBPlayer = sharedObject.Functions.GetPlayer(id)

    if not player.QBPlayer then return end

    player.source = id

    return player
end

function Framework.getPlayerFromIdentifier(identifier)
    local player = setmetatable({}, { __index = player })
    player.QBPlayer = sharedObject.Functions.GetPlayerByCitizenId(identifier)

    if not player.QBPlayer then return end

    player.source = player.QBPlayer.PlayerData.source

    return player
end

Framework.registerUsableItem = sharedObject.Functions.CreateUseableItem

Framework.getPlayers = sharedObject.Functions.GetQBPlayers

function Framework.getItemLabel(item)
    return exports.ox_inventory:Items()[item]?.label or 'ITEM_NOT_FOUND'
end

function Framework.getItems()
    return exports.ox_inventory:Items()
end

function player:hasGroup(name)
    return sharedObject.Functions.HasPermission(self.source, name) == name
end

function player:hasOneOfGroups(groups)
    if type(groups) == 'table' and table.type(groups) == 'array' then
        for _, name in ipairs(groups) do
            if sharedObject.Functions.HasPermission(self.source, name) == name then
                return true
            end
        end
    end

    for k,v in pairs(groups) do
        if sharedObject.Functions.HasPermission(self.source, k) then
            return true
        end
    end

    return false
end

function player:addItem(name, count, metadata)
    count = count or 1

    if not exports.ox_inventory:CanCarryItem(self.source, name, count) then
        return false
    end

    return exports.ox_inventory:AddItem(self.source, name, count, metadata)
end

function player:removeItem(name, count)
    count = count or 1

    exports.ox_inventory:RemoveItem(self.source, name, count)
end

function player:canCarryItem(name, count)
    return exports.ox_inventory:CanCarryItem(self.source, name, count or 1)
end

function player:getItemCount(name)
    return exports.ox_inventory:GetItemCount(self.source, name)
end

function player:hasItem(name)
    return self:getItemCount(name) > 0
end

function player:getAccountMoney(account)
    if account == 'money' then
        account = 'cash'
    end

    return self.QBPlayer.Functions.GetMoney(account)
end

function player:addAccountMoney(account, amount)
    if account == 'money' then
        account = 'cash'
    end

    self.QBPlayer.Functions.AddMoney(account, amount)  
end

function player:removeAccountMoney(account, amount)
    if account == 'money' then
        account = 'cash'
    end

    self.QBPlayer.Functions.RemoveMoney(account, amount)
end

function player:getJob()
    return self.QBPlayer.PlayerData.job.name, self.QBPlayer.PlayerData.job.label
end

function player:hasOneOfJobs(jobs)
    if type(jobs) == 'table' and table.type(jobs) == 'array' then
        for _, job in ipairs(jobs) do
            if job == self.QBPlayer.PlayerData.job.name then
                return true
            end
        end
    end

    return jobs[self.QBPlayer.PlayerData.job.name] or false
end

function player:getJobGrade()
    return self.QBPlayer.PlayerData.job.grade.level, self.QBPlayer.PlayerData.job.grade.name
end

function player:setJob(name, grade)
    return self.QBPlayer.Functions.SetJob(name, grade)
end

function player:setDuty(value)
    return self.QBPlayer.Functions.SetJobDuty(value)
end

function player:getIdentifier()   
    return self.QBPlayer.PlayerData.citizenid
end

function player:getFirstName()
    return self.QBPlayer.PlayerData.charinfo.firstname
end

function player:getLastName()
    return self.QBPlayer.PlayerData.charinfo.lastname
end

function player:updateNames(firstname, lastname)
    if not firstname and not lastname then return end

    local charinfo = self.QBPlayer.PlayerData.charinfo

    if firstname then
        local edit = firstname:gsub("^%l", string.upper)
        charinfo.firstname = edit
    end

    if lastname then
        local edit = lastname:gsub("^%l", string.upper)
        charinfo.lastname = edit
    end

    self.QBPlayer.Functions.SetPlayerData('charinfo', charinfo)
    self.QBPlayer.Functions.Save()
    self.QBPlayer.Functions.UpdatePlayerData(false)

    TriggerClientEvent('QBCore:Player:UpdatePlayerData', player.source)
end

return Framework
