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
		local state = STATE_MAP[track.Name]

		if not state then
			local container = track.Animation.Parent
			state = container and STATE_MAP[container.Name]
		end

		if state then
			callback(prevState, state)
			prevState = state
		end
	end)
end