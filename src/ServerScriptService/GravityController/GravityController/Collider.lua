local Maid = require(script.Parent.Utility.Maid)

local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Whitelist

-- CONSTANTS

local CUSTOM_PHYSICAL = PhysicalProperties.new (0.7, 0, 0, 1, 100)

-- Class

local ColliderClass = {}
ColliderClass.__index = ColliderClass
ColliderClass.ClassName = "Collider"

-- Public Constructors

function ColliderClass.new(controller)
	local self = setmetatable({}, ColliderClass)
	local sphere, vForce, floor, gryo = create(controller)

	self._maid = Maid.new()
	
	self.Controller = controller

	self.Sphere = sphere
	self.VForce = vForce
	self.FloorDetector = floor
	self.Gyro = gryo

	init(self)

	return self
end

-- Private Methods

local function getHipHeight(controller)
	if controller.Humanoid.RigType == Enum.HumanoidRigType.R15 then
		return controller.Humanoid.HipHeight + 0.05
	end
	return 2
end

local function getAttachement(controller)
	if controller.Humanoid.RigType == Enum.HumanoidRigType.R15 then
		return controller.HRP:WaitForChild("RootRigAttachment")
	end
	return controller.HRP:WaitForChild("RootAttachment")
end

function create(controller)
	local hipHeight = getHipHeight(controller)
	local attach = getAttachement(controller)

	local sphere = Instance.new("Part")
	sphere.Name = "Sphere"
	sphere.Massless = true
	sphere.Size = Vector3.new(2, 2, 2)
	sphere.Shape = Enum.PartType.Ball
	sphere.Transparency = 1
	sphere.CustomPhysicalProperties = CUSTOM_PHYSICAL

	local floor = Instance.new("Part")
	floor.Name = "FloorDectector"
	floor.CanCollide = false
	floor.Massless = true
	floor.Size = Vector3.new(2, 1, 1)
	floor.Transparency = 1

	local weld = Instance.new("Weld")
	weld.C0 = CFrame.new(0, -hipHeight, 0.1)
	weld.Part0 = controller.HRP
	weld.Part1 = sphere
	weld.Parent = sphere

	local weld = Instance.new("Weld")
	weld.C0 = CFrame.new(0, -hipHeight - 1.5, 0)
	weld.Part0 = controller.HRP
	weld.Part1 = floor
	weld.Parent = floor

	local vForce = Instance.new("VectorForce")
	vForce.Force = Vector3.new(0, 0, 0)
	vForce.ApplyAtCenterOfMass = true
	vForce.RelativeTo = Enum.ActuatorRelativeTo.World
	vForce.Attachment0 = attach
	vForce.Parent = controller.HRP

	local gyro = Instance.new("BodyGyro")
	gyro.P = 25000
	gyro.MaxTorque = Vector3.new(100000, 100000, 100000)
	gyro.CFrame = controller.HRP.CFrame
	gyro.Parent = controller.HRP

	sphere.Touched:Connect(function() end)
	floor.Touched:Connect(function() end)

	sphere.Parent = controller.Character
	floor.Parent = controller.Character

	return sphere, vForce, floor, gyro
end

function init(self)
	self._maid:Mark(self.Sphere)
	self._maid:Mark(self.VForce)
	self._maid:Mark(self.FloorDetector)
	self._maid:Mark(self.Gyro)
end

-- Public Methods

function ColliderClass:Update(force, cframe)
	self.VForce.Force = force
	self.Gyro.CFrame = cframe
end

function ColliderClass:IsGrounded(isJumpCheck)
	if not isJumpCheck then
		local parts = self.FloorDetector:GetTouchingParts()
		for _, part in pairs(parts) do
			if not part:IsDescendantOf(self.Controller.Character) then
				return true
			end
		end
	elseif not self.Controller.StateTracker.Jumped then
		local filter = {}
		local parts = self.Sphere:GetTouchingParts()
		for _, part in pairs(parts) do
			if not part:IsDescendantOf(self.Controller.Character) then
				table.insert(filter, part)
			end
		end

		if #filter > 0 then
			params.FilterDescendantsInstances = filter

			local gravityUp = self.Controller._gravityUp
			local result = workspace:Raycast(self.Sphere.Position, -2.1*gravityUp, params)
			if result then
				local max = math.cos(math.rad(self.Controller.Humanoid.MaxSlopeAngle))
				local dot = result.Normal:Dot(gravityUp)
				if max < dot then
					return true
				end
			end
		end
	end
end

function ColliderClass:Destroy()
	self._maid:Sweep()
end

--

return ColliderClass