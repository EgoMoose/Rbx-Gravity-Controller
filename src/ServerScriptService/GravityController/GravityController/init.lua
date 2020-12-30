local Utility = script:WaitForChild("Utility")
local CharacterModules = script:WaitForChild("CharacterModules")

local Maid = require(Utility:WaitForChild("Maid"))
local Camera = require(CharacterModules:WaitForChild("Camera"))
local Control = require(CharacterModules:WaitForChild("Control"))
local Collider = require(script:WaitForChild("Collider"))

-- Class

local GravityControllerClass = {}
GravityControllerClass.__index = GravityControllerClass
GravityControllerClass.ClassName = "GravityController"

-- Public Constructors

function GravityControllerClass.new(player)
	local self = setmetatable({}, GravityControllerClass)

	self.Player = player
	self.Character = player.Character
	self.Humanoid = player.Character:WaitForChild("Humanoid")
	self.HRP = self.Humanoid.RootPart

	self._camera = Camera.new(self)
	self._control = Control.new(self)
	self._collider = Collider.new(self)

	self.Maid = Maid.new()

	init(self)

	return self
end

-- Private Methods

function init(self)
	self.Maid:Mark(self._camera)
	self.Maid:Mark(self._control)
end

-- Public Methods

function GravityControllerClass:Destroy()
end

--

return GravityControllerClass