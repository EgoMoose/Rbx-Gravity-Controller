local STATE_MAP = {
	["climb"] = Enum.HumanoidStateType.Climbing,
	["fall"] = Enum.HumanoidStateType.Freefall,
	["idle"] = Enum.HumanoidStateType.RunningNoPhysics,
	["jump"] = Enum.HumanoidStateType.Jumping,
	["run"] = Enum.HumanoidStateType.Running,
	["swim"] = Enum.HumanoidStateType.Swimming,
	["swimidle"] = Enum.HumanoidStateType.Swimming,
	["walk"] = Enum.HumanoidStateType.Running,
}

return function(animator, callback)
	local humanoid = animator.Parent
	local prevState = humanoid:GetState()

	return animator.AnimationPlayed:Connect(function(track)
		local container = track.Animation and track.Animation.Parent
		if container then
			local state = STATE_MAP[container.Name]
			if state and container.Parent and container.Parent.Name == "Animate" then
				callback(prevState, state)
				prevState = state
			end
		end
	end)
end