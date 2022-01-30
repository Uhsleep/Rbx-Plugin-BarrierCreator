local Root = script:FindFirstAncestor("BarrierCreator")
local Roact = require(Root.dependencies.Roact)
local e = Roact.createElement

local AddOperationMode = require(script.Parent.operationModes.add)
local SelectionOperationMode = require(script.Parent.operationModes.selection)

local Dictionary = require(Root.dictionary)
local StudioPluginContext = require(script.Parent.components.studio.studioPluginContext)

-----------------------------------------------------------------------------

local OperationModeManager = Roact.Component:extend("OperationModeManager")

function OperationModeManager:init()
    self.operationModes = {
        SelectionOperationMode,
        AddOperationMode,
    }
end

function OperationModeManager:render()
    local operatingMode = self.operationModes[self.props.operatingMode]

    return operatingMode and self.props.active and e(operatingMode) or nil
end

-- function OperationModeManager:didMount()
    
-- end

function OperationModeManager:didUpdate(lastProps)

end

function OperationModeManager:willUnmount()
   
end

function OperationModeManagerWrapper(props)
    return e(StudioPluginContext.Consumer, {
        render = function(pluginModule)
            return e(OperationModeManager, Dictionary.merge(props, {
                plugin = pluginModule.plugin
            }))
        end
    })
end

return OperationModeManagerWrapper