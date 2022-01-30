local Root = script:FindFirstAncestor("BarrierCreator")
local Roact = require(Root.dependencies.Roact)

local StudioToolbarContext = Roact.createContext(nil)

return StudioToolbarContext