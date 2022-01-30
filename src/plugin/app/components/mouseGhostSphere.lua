local RunService = game:GetService("RunService")

local Root = script:FindFirstAncestor("BarrierCreator")
local Roact = require(Root.dependencies.Roact)
local e = Roact.createElement

local Dictionary = require(Root.dictionary)
local StudioPluginContext = require(script.Parent.studio.studioPluginContext)

-----------------------------------------------------------------------------

local MouseGhostSphere = Roact.Component:extend("MouseGhostSphere")

function MouseGhostSphere:init()

end

function MouseGhostSphere:render()
    return nil
end

function MouseGhostSphere:didMount()
    self.mouse = self.props.plugin:GetMouse()

    local part = Instance.new("Part")
    part.Name = "GhostSphere"
    part.Transparency = 0.5
    part.Shape = Enum.PartType.Ball
    part.Color = Color3.fromRGB(191, 0, 0)
    part.Locked = true

    self.ghostPart = part

    self.mouse.TargetFilter = self.ghostPart

    if self.props.active then
        self.ghostPart.Parent = workspace

        self.connection = RunService.Heartbeat:Connect(function()
            local hitCFrame = self.mouse.Hit
            -- print("hitframe:", hitCFrame)
            self.ghostPart.CFrame = hitCFrame
        end)
    end
end

function MouseGhostSphere:didUpdate(lastProps)
    
end

function MouseGhostSphere:willUnmount()
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
    end

    self.ghostPart:Destroy()
end

function MouseGhostSphereWrapper(props)
    return e(StudioPluginContext.Consumer, {
        render = function(pluginModule)
            return e(MouseGhostSphere, Dictionary.merge(props, {
                plugin = pluginModule.plugin
            }))
        end
    })
end

return MouseGhostSphereWrapper