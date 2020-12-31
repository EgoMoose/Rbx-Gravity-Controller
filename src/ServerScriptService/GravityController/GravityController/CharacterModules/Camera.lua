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
	self.CameraModule = playerModule:GetCameras()

	init(self)

	return self
end

-- Private methods

function init(self)
	--self.CameraModule:SetTransitionRate(1)
	function self.CameraModule.GetUpVector(this, upVector)
		return self.Controller._gravityUp
	end
end

-- Public Methods

function CameraClass:Destroy()
	function self.CameraModule.GetUpVector(this, upVector)
		return Vector3.new(0, 1, 0)
	end
end

--

return CameraClass