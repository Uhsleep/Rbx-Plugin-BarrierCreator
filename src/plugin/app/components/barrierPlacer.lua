local RunService = game:GetService("RunService")
local Selection = game:GetService("Selection")

local Root = script:FindFirstAncestor("BarrierCreator")
local Roact = require(Root.dependencies.Roact)
local e = Roact.createElement

local Dictionary = require(Root.dictionary)
local StudioPluginContext = require(script.Parent.studio.studioPluginContext)

-----------------------------------------------------------------------------

local BarrierPlacer = Roact.Component:extend("BarrierPlacer")

function BarrierPlacer:init()

end

function BarrierPlacer:render()
    return nil
end

function BarrierPlacer:didMount()
    self.props.plugin:Activate(true)
    self.mouse = self.props.plugin:GetMouse()
    self.mouse.Icon = "rbxasset://SystemCursors/Arrow"
    self.barrierLink = self.props.barrierLink

    if self.props.active then
        self.connection = self.mouse.Button1Up:Connect(function()
            self.barrierLink:AddPoint(self.mouse.Hit.Position)
        end)
    end
end

function BarrierPlacer:didUpdate(lastProps)
    if self.barrierLink ~= self.props.barrierLink then
        self.barrierLink = self.props.barrierLink
    end
end

function BarrierPlacer:willUnmount()
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
    end

    self.props.plugin:Deactivate()
end

function BarrierPlacerWrapper(props)
    return e(StudioPluginContext.Consumer, {
        render = function(pluginModule)
            return e(BarrierPlacer, Dictionary.merge(props, {
                plugin = pluginModule.plugin,
                barrierLink = pluginModule.barrierLink
            }))
        end
    })
end

return BarrierPlacerWrapper