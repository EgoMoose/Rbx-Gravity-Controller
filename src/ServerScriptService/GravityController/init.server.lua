local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local StarterCharacterScripts = game:GetService("StarterPlayer"):WaitForChild("StarterCharacterScripts")

local Client = script:WaitForChild("Client")

local function replace(child, parent)
	local found = parent:FindFirstChild(child.Name)
	if found then found:Destroy() end
	child.Parent = parent
end

replace(Client:WaitForChild("PlayerScriptsLoader"), StarterPlayerScripts)
replace(Client:WaitForChild("RbxCharacterSounds"), StarterPlayerScripts)
replace(Client:WaitForChild("Animate"), StarterCharacterScripts)

script:WaitForChild("GravityController").Parent = ReplicatedStorage