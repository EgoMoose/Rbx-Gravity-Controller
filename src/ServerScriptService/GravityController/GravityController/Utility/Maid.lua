-- CONSTANTS

local FORMAT_STR = "Maid does not support type \"%s\""

local DESTRUCTORS = {
	["function"] = function(item)
		item()
	end;
	["RBXScriptConnection"] = function(item)
		item:Disconnect()
	end;
	["Instance"] = function(item)
		item:Destroy()
	end;
	["table"] = function(item)
		item:Destroy()
	end
}

-- Class

local MaidClass = {}
MaidClass.__index = MaidClass
MaidClass.ClassName = "Maid"

-- Public Constructors

function MaidClass.new(...)
	local self = setmetatable({}, MaidClass)
	
	self.Trash = {}

	for _, item in pairs({...}) do
		self:Mark(item)
	end
	
	return self
end

-- Public Methods

function MaidClass:Mark(item)
	local tof = typeof(item)
	
	if DESTRUCTORS[tof] then
		self.Trash[item] = tof
	else
		error(FORMAT_STR:format(tof), 2)
	end
end

function MaidClass:Unmark(item)
	if item then
		self.Trash[item] = nil
	else
		self.Trash = {}
	end
end

function MaidClass:Sweep()
	for item, tof in pairs(self.Trash) do
		DESTRUCTORS[tof](item)
	end
	self.Trash = {}
end

MaidClass.Destroy = MaidClass.Sweep

--

return MaidClass