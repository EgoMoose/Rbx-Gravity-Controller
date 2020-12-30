local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tool = script.Parent
local GravityControllerClass = require(ReplicatedStorage:WaitForChild("GravityController"))

local params = RaycastParams.new()
params.FilterDescendantsInstances = {}
params.FilterType = Enum.RaycastFilterType.Blacklist

local gravityController = nil

local function getGravityUp(self, oldGravity)
	local result = workspace:Raycast(self.HRP.Position, -5*oldGravity, params)
	if result then
		return result.Normal
	end
	return oldGravity
end

tool.Equipped:Connect(function()
	gravityController = GravityControllerClass.new(Players.LocalPlayer)
	gravityController.GetGravityUp = getGravityUp
	params.FilterDescendantsInstances = {gravityController.Character}
end)

tool.Unequipped:Connect(function()
	if gravityController then
		gravityController:Destroy()
	end
end)