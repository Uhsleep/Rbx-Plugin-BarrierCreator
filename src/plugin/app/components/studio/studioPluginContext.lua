local Root = script:FindFirstAncestor("BarrierCreator")
local Roact = require(Root.dependencies.Roact)

local StudioPluginContext = Roact.createContext(nil)

return StudioPluginContext