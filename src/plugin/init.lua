local Roact = require(script.Parent.dependencies.Roact)
local App = require(script.app)
local BarrierLink = require(script.barrierLink)

local Plugin = {
    name = "Barrier Creator",
}

function Plugin:Init(plugin)
    self.plugin = plugin
    self.barrierLink = BarrierLink()

    local app = Roact.createElement(App, {
        pluginModule = self
    })

    self.roactTree = Roact.mount(app, nil, "BarrierCreator UI")
end

function Plugin:CreateBarrierLink()
    if self.barrierLink then
        self.barrierLink:Destroy()
    end

    self.barrierLink = BarrierLink()

    Roact.update(self.roactTree, Roact.createElement(App, {
        pluginModule = self,
    }))
end

function Plugin:OnUnloading(plugin)
    -- print("Unloading")
    Roact.unmount(self.roactTree)
    self.barrierLink:Destroy()
end

function Plugin:OnDeactivation(plugin)
    -- print("Deactivation")
end


return Plugin