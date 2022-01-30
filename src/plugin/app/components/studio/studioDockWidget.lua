local Root = script:FindFirstAncestor("BarrierCreator")
local Roact = require(Root.dependencies.Roact)
local e = Roact.createElement

local Dictionary = require(Root.dictionary)
local StudioPluginContext = require(script.Parent.studioPluginContext)

-----------------------------------------------------------------------------

local StudioDockWidget = Roact.Component:extend("StudioDockWidget")

function StudioDockWidget:init()
    local widgetInfo = DockWidgetPluginGuiInfo.new(
        Enum.InitialDockState.Left,
        true,
        false,
        200,
        300,
        150,
        150
    )

    self.dockWidget = self.props.plugin:CreateDockWidgetPluginGui("BCWidgetGui", widgetInfo)
    self.dockWidget.Title = self.props.title

    if self.props.onInitialState then
        self.props.onInitialState(self.dockWidget.Enabled)
    end

    self.dockWidget:BindToClose(function()
        if self.props.onClose then
            self.props.onClose()
        else
            self.dockWidget.Enabled = false
        end
    end)
end

function StudioDockWidget:render()
    return e(Roact.Portal, {
        target = self.dockWidget
    }, self.props[Roact.Children])
end

-- function StudioDockWidget:didMount()
    
-- end

function StudioDockWidget:didUpdate(lastProps)
    if self.props.enabled ~= lastProps.enabled then
        self.dockWidget.Enabled = self.props.enabled
    end
end

function StudioDockWidget:willUnmount()
    self.dockWidget:Destroy()
end

function StudioDockWidgetWrapper(props)
    return e(StudioPluginContext.Consumer, {
        render = function(pluginModule)
            return e(StudioDockWidget, Dictionary.merge(props, {
                plugin = pluginModule.plugin
            }))
        end
    })
end

return StudioDockWidgetWrapper