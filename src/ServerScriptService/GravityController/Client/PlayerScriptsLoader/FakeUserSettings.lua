local FFLAG_OVERRIDES = {
	["UserRemoveTheCameraApi"] = false
}

local FakeUserSettings = {}

function FakeUserSettings:IsUserFeatureEnabled(name)
	if FFLAG_OVERRIDES[name] ~= nil then
		return FFLAG_OVERRIDES[name]
	end
	return UserSettings():IsUserFeatureEnabled(name)
end

function FakeUserSettings:SafeIsUserFeatureEnabled(name)
	local success, result = pcall(function()
		return self:IsUserFeatureEnabled(name)
	end)
	return success and result
end

function FakeUserSettings:GetService(name)
	return UserSettings():GetService(name)
end

local function FakeUserSettingsFunc()
	return FakeUserSettings
end

return FakeUserSettingsFunc