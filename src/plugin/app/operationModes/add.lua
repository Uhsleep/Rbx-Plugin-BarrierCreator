local Root = script:FindFirstAncestor("BarrierCreator")
local Roact = require(Root.dependencies.Roact)
local e = Roact.createElement


local MouseGhostSphere = require(script.Parent.Parent.components.mouseGhostSphere)
local BarrierPlacer = require(script.Parent.Parent.components.barrierPlacer)
local Dictionary = require(Root.dictionary)
local StudioPluginContext = require(script.Parent.Parent.components.studio.studioPluginContext)

-----------------------------------------------------------------------------

local AddOperationMode = Roact.Component:extend("AddOperationMode")

function AddOperationMode:init()
    
end

function AddOperationMode:render()
    return Roact.createFragment({
        MouseGhostSphere = e(MouseGhostSphere, {
            active = true
        }),

        BarrierPlacer = e(BarrierPlacer, {
            active = true
        })
    })
end

-- function AddOperationMode:didMount()
    
-- end

function AddOperationMode:didUpdate(lastProps)

end

function AddOperationMode:willUnmount()
    
end

function AddOperationModeWrapper(props)
    return e(StudioPluginContext.Consumer, {
        render = function(pluginModule)
            return e(AddOperationMode, Dictionary.merge(props, {
                plugin = pluginModule.plugin
            }))
        end
    })
end

return AddOperationModeWrapper