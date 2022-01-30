local Root = script:FindFirstAncestor("BarrierCreator")
local Roact = require(Root.dependencies.Roact)
local e = Roact.createElement

local Dictionary = require(Root.dictionary)
local StudioPluginContext = require(script.Parent.studioPluginContext)
local StudioToolbarContext = require(script.Parent.studioToolbarContext)

-----------------------------------------------------------------------------

local StudioToolbar = Roact.Component:extend("StudioToolbar")

function StudioToolbar:init()
    self.toolbar = self.props.plugin:CreateToolbar(self.props.name)
end

function StudioToolbar:render()
    return e(StudioToolbarContext.Provider, {
        value = self.toolbar
    }, self.props[Roact.Children])
end

-- function StudioToolbar:didMount()
    
-- end

function StudioToolbar:willUnmount()
    self.toolbar:Destroy()
end

function StudioToolbarWrapper(props)
    return e(StudioPluginContext.Consumer, {
        render = function(pluginModule)
            return e(StudioToolbar, Dictionary.merge(props, {
                plugin = pluginModule.plugin
            }))
        end
    })
end

return StudioToolbarWrapper