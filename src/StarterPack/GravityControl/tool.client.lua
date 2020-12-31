local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tool = script.Parent
local GravityControllerClass = require(ReplicatedStorage:WaitForChild("GravityController"))

local params = RaycastParams.new()
params.FilterDescendantsInstances = {}
params.FilterType = Enum.RaycastFilterType.Blacklist

local gravityController = nil

local function getGravityUp(self, oldGravity)
	local result = workspace:Raycast(self.HRP.Position, -5*oldGravity, params)
	if result and result.Instance.CanCollide and not result.Instance.Parent:FindFirstChild("Humanoid") then
		return result.Normal
	end
	return oldGravity
end

tool.Equipped:Connect(function()
	gravityController = GravityControllerClass.new(Players.LocalPlayer)
	gravityController.GetGravityUp = getGravityUp
	gravityController.Maid:Mark(RunService.Heartbeat:Connect(function(dt)
		local height = gravityController:GetFallHeight()
		if height < -50 then
			gravityController:ResetGravity(Vector3.new(0, 1, 0))
		end
	end))

	params.FilterDescendantsInstances = {gravityController.Character}
end)

tool.Unequipped:Connect(function()
	if gravityController then
		gravityController:Destroy()
	end
end)