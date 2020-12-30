local Maid = require(script.Parent.Utility.Maid)

-- Class

local ColliderClass = {}
ColliderClass.__index = Collider
ColliderClass.ClassName = "Collider"

-- Public Constructors

function ColliderClass.new(controller)
	local self = setmetatable({}, ColliderClass)
	local sphere, vForce, floor = create(controller)

	self._maid = Maid.new()
	
	self.Sphere = sphere
	self.VForce = vForce
	self.FloorDetector = floor

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
	sphere.Size = Vector3.new(2, 2, 2)
	sphere.Shape = Enum.PartType.Ball
	sphere.Transparency = 1

	local floor = Instance.new("Part")
	floor.Name = "FloorDectector"
	floor.CanCollide = false
	floor.Size = Vector3.new(2, 1, 1)
	floor.Transparency = 1

	local weld = Instance.new("Weld")
	weld.C0 = CFrame.new(0, -hipHeight, 0)
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
	vForce.RelativeTo = Enum.ActuatorRelativeTo.World
	vForce.Attachment0 = attach
	vForce.Parent = controller.HRP

	sphere.Touched:Connect(function() end)
	floor.Touched:Connect(function() end)

	sphere.Parent = controller.Character
	floor.Parent = controller.Character

	return sphere, vForce, floor
end

function init(self)
	self._maid:Mark(self.Sphere)
	self._maid:Mark(self.VForce)
	self._maid:Mark(self.FloorDetector)
end

-- Public Methods

function ColliderClass:Destroy()
	self._maid:Sweep()
end

--

return ColliderClass