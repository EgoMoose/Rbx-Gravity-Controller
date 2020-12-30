-- Class

local CameraClass = {}
CameraClass.__index = CameraClass
CameraClass.ClassName = "Camera"

-- Public Constructors

function CameraClass.new(controller)
	local self = setmetatable({}, CameraClass)

	local player = controller.Player
	local playerModule = require(player.PlayerScripts:WaitForChild("PlayerModule"))

	self.Controller = controller

	self.UpVector = Vector3.new(0, 1, 0)
	self.CameraModule = playerModule:GetCameras()

	init(self)

	return self
end

-- Private methods

function init(self)
	self.CameraModule:SetTransitionRate(0.15)
	function self.CameraModule.GetUpVector(this, upVector)
		return self.UpVector
	end
end

-- Public Methods

function CameraClass:SetUpVector(normal)
	self.UpVector = normal
end

function CameraClass:Destroy()
	self.UpVector = Vector3.new(0, 1, 0)
	function self.CameraModule.GetUpVector(this, upVector)
		return Vector3.new(0, 1, 0)
	end
end

--

return CameraClass