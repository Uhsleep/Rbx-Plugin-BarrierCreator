local Root = script:FindFirstAncestor("BarrierCreator")
local Roact = require(Root.dependencies.Roact)

return function()
    return Roact
end