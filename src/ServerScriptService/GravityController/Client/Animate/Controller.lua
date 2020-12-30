local animate = script.Parent
local humanoid = animate.Parent:WaitForChild("Humanoid")
local loaded = animate:WaitForChild("Loaded")

require(animate:WaitForChild("VerifyAnims"))(humanoid, animate)

local output
if humanoid.RigType == Enum.HumanoidRigType.R6 then
	output = require(animate:WaitForChild("R6"))
else
	output = require(animate:WaitForChild("R15"))
end

loaded.Value = true

return output