local Root = script:FindFirstAncestor("BarrierCreator")
local Roact = require(Root.dependencies.Roact)
local e = Roact.createElement

local Dictionary = require(Root.dictionary)
local StudioPluginContext = require(script.Parent.Parent.components.studio.studioPluginContext)

-----------------------------------------------------------------------------

local SelectionOperationMode = Roact.Component:extend("SelectionOperationMode")

function SelectionOperationMode:init()
    
end

function SelectionOperationMode:render()
    return nil
end

-- function SelectionOperationMode:didMount()
    
-- end

function SelectionOperationMode:didUpdate(lastProps)
    
end

function SelectionOperationMode:willUnmount()
    
end

function SelectionOperationModeWrapper(props)
    return e(StudioPluginContext.Consumer, {
        render = function(pluginModule)
            return e(SelectionOperationMode, Dictionary.merge(props, {
                plugin = pluginModule.plugin
            }))
        end
    })
end

return SelectionOperationModeWrapper