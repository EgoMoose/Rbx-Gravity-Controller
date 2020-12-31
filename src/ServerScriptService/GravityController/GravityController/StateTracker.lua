local Maid = require(script.Parent.Utility.Maid)
local Signal = require(script.Parent.Utility.Signal)

-- CONSTANTS

local SPEED = {
	[Enum.HumanoidStateType.Running] = true,
}

local IN_AIR = {
	[Enum.HumanoidStateType.Jumping] = true,
	[Enum.HumanoidStateType.Freefall] = true
}

local REMAP = {
	["onFreefall"] = "onFreeFall",
}

-- Class

local StateTrackerClass = {}
StateTrackerClass.__index = StateTrackerClass
StateTrackerClass.ClassName = "StateTracker"

-- Public Constructors

function StateTrackerClass.new(controller)
	local self = setmetatable({}, StateTrackerClass)

	self._maid = Maid.new()

	self.Controller = controller
	self.State = Enum.HumanoidStateType.Running
	self.Speed = 0

	self.Jumped = false
	self.JumpTick = os.clock()

	self.Animation = require(controller.Character:WaitForChild("Animate"):WaitForChild("Controller"))
	self.Changed = Signal.new()

	init(self)

	return self
end

-- Private Methods

function init(self)
	self._maid:Mark(self.Changed)
	self._maid:Mark(self.Changed:Connect(function(state, speed)
		local name = "on" .. state.Name
		local func = self.Animation[REMAP[name] or name]
		func(speed)
	end))
end

-- Public Methods

function StateTrackerClass:Update(gravityUp, isGrounded, isInputMoving)
	local cVelocity = self.Controller.HRP.Velocity
	local gVelocity = cVelocity:Dot(gravityUp)

	local oldState = self.State
	local oldSpeed = self.Speed

	local newState = nil
	local newSpeed = cVelocity.Magnitude

	if not isGrounded then
		if gVelocity > 0 then
			if self.Jumped then
				newState = Enum.HumanoidStateType.Jumping
			else
				newState = Enum.HumanoidStateType.Freefall
			end
		else
			if self.Jumped then
				self.Jumped = false
			end
			newState = Enum.HumanoidStateType.Freefall
		end
	else
		if self.Jumped and os.clock() - self.JumpTick > 0.1 then
			self.Jumped = false
		end
		newSpeed = (cVelocity - gVelocity*gravityUp).Magnitude
		newState = Enum.HumanoidStateType.Running
	end

	newSpeed = isInputMoving and newSpeed or 0

	if oldState ~= newState or (SPEED[newState] and math.abs(newSpeed - oldSpeed) > 0.1) then
		self.State = newState
		self.Speed = newSpeed
		self.Changed:Fire(newState, newSpeed)
	end
end

function StateTrackerClass:RequestJump()
	self.Jumped = true
	self.JumpTick = os.clock()
end

function StateTrackerClass:Destroy()
	self._maid:Sweep()
end

return StateTrackerClass