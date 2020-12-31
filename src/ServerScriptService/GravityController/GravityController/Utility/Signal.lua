-- Class

local SignalClass = {}
SignalClass.__index = SignalClass
SignalClass.ClassName = "Signal"

-- Public Constructors

function SignalClass.new()
	local self = setmetatable({}, SignalClass)

	self._connections = {}
	self._bind = Instance.new("BindableEvent")
	self._params = nil

	return self
end

-- Public Methods

function SignalClass:Connect(func)
	local connection = self._bind.Event:Connect(function()
		func(unpack(self._params))
	end)
	table.insert(self._connections, connection)
	return connection
end

function SignalClass:Fire(...)
	self._params = {...} -- to avoid cyclic table BS
	self._bind:Fire()
	self._params = nil
end

function SignalClass:Wait()
	return self._bind.Event:Wait()
end

function SignalClass:Clear()
	for _, connection in pairs(self._connections) do
		connection:Dsiconnect()
	end
	self._connections = {}
end

function SignalClass:Destroy()
	self:Clear()
	self._bind:Destroy()
	self._bind = nil
end

--

return SignalClass