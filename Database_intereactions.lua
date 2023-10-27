local function Get_Value_Type(value)
    local valuetypes_content = { "number", "string", "boolean", "table", "nill", "function", "thread", "Instance" }

    local tablesize = 6

    for v = 0, tablesize do
        if type(value) == valuetypes_content[v] then
            return valuetypes_content[v]
        else
            error("Data Type Not available")
        end
    end
end


--[[
local DataStoreService = game:GetService("DataStoreService")
local dataStore = DataStoreService:GetDataStore("Data_Store_Test_v0")
]]


local function Has_player_joined(playerinst, UserId, datastore)
    local data = datastore:GetAsync(UserId)
    if data then
        local valueholder = data["Has_Joined_BF"]
        if valueholder == true then
            return true
        else
            return false
        end
    else
        return false
    end
end

local function Write_Data(playerinst, UserId, valuetable, datastore)
    local success, errorcode = pcall(function()
        datastore:SetAsync(UserId, valuetable)
    end)

    if success then
        print("Data write success")
    else
        print("Data failed to write")
        error(errorcode)
    end
end


local function Get_Data(playerinst, UserId, dataStore)
    local data

    local success, errorcode = pcall(function()
        data = dataStore:GetAsync(UserId)
    end)

    if success and data then
        print("data retrieved")
        return data
    else
        print("Failed to fetch Data")
        error(errorcode)
    end
end
