local DataStoreService = game:GetService("DataStoreService")
local PlayerDataStore = DataStoreService:GetDataStore("Datastore_000A")

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

local function Create_Folders_In_Player(plrinst)
	local MetaData = Instance.new("Folder")
	MetaData.Name = "MetaData"
	MetaData.Parent = plrinst

	local values = {"teamValue", "raceValue", "genderValue", "displayNameValue"}

	for _, name in ipairs(values) do
		local value = Instance.new("StringValue")
		value.Name = name
		value.Parent = MetaData
	end

	return MetaData
end

local function Assign_role(metaData)

	local teamValue = metaData:FindFirstChild("teamValue")
	local raceValue = metaData:FindFirstChild("raceValue")

	if not (teamValue and raceValue) then
		return 
	end

	local teams = {"Human", "Monster"}

	local races = {
		{"Human", "halfHuman", "DivineHuman"},
		{"Orc", "Goblin", "Slime", "Demon"}
	}

	local teamIndex = math.random(1, #teams)
	local raceIndex = math.random(1, #races[teamIndex])

	teamValue.Value = teams[teamIndex]
	raceValue.Value = races[teamIndex][raceIndex]

end



game.Players.PlayerAdded:Connect(function(plrinst)

	local UserId = plrinst.UserId

	print(Has_player_joined(plrinst,UserId,PlayerDataStore))
	if not Has_player_joined(plrinst,UserId,PlayerDataStore) then -- if player dont have data

		local metaData = Create_Folders_In_Player(plrinst)


		Assign_role(metaData)

		local teamValue = metaData:FindFirstChild("teamValue")
		local raceValue = metaData:FindFirstChild("raceValue")
		local genderValue = metaData:FindFirstChild("genderValue")
		local displayNameValue = metaData:FindFirstChild("displayNameValue")

		local data = {
			["Has_Joined_BF"] = true,
			["teamValue"] = teamValue.Value,
			["raceValue"] = raceValue.Value,
			["genderValue"] = genderValue.Value,
			["displayNameValue"] = displayNameValue.Value
		}

		Write_Data(plrinst,UserId,data,PlayerDataStore)
	else
		
		local retrieved_datatable = Get_Data(plrinst,UserId,PlayerDataStore)

		local metaData = Create_Folders_In_Player(plrinst)

		local teamValue = metaData:FindFirstChild("teamValue")
		local raceValue = metaData:FindFirstChild("raceValue")
		local genderValue = metaData:FindFirstChild("genderValue")
		local displayNameValue = metaData:FindFirstChild("displayNameValue")

		local Retrived_teamValue = retrieved_datatable["teamValue"]
		local Retrived_raceValue = retrieved_datatable["raceValue"]
		local Retrived_genderValue = retrieved_datatable["genderValue"]
		local Retrived_displayNameValue = retrieved_datatable["displayNameValue"]


		teamValue.Value = Retrived_teamValue
		raceValue.Value = Retrived_raceValue
		genderValue.Value = Retrived_genderValue
		displayNameValue.Value = Retrived_displayNameValue
	end
end)
