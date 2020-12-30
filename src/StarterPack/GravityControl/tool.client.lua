local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tool = script.Parent
local GravityControllerClass = require(ReplicatedStorage:WaitForChild("GravityController"))

local gravityController = nil

tool.Equipped:Connect(function()
	gravityController = GravityControllerClass.new(Players.LocalPlayer)
end)

tool.Unequipped:Connect(function()
	if gravityController then
		gravityController:Destroy()
	end
end)