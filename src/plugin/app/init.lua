local Root = script:FindFirstAncestor("BarrierCreator")
local Roact = require(Root.dependencies.Roact)
local e = Roact.createElement

local EditPage = require(script.pages.edit)
local OperationModeManager = require(script.operationModeManager)
local StudioPluginContext = require(script.components.studio.studioPluginContext)
local StudioToolbar = require(script.components.studio.studioToolbar)
local StudioToolbarButton = require(script.components.studio.studioToolbarButton)
local StudioDockWidget = require(script.components.studio.studioDockWidget)
-----------------------------------------------------------------------------

local App = Roact.Component:extend("App")

function App:init()
    self:setState({
        enabled = false,
        operatingMode = 2,
    })
end

function App:render()
    return e(StudioPluginContext.Provider, { 
        value = self.props.pluginModule
    }, {
        StudioToolbar = e(StudioToolbar, {
            name = self.props.pluginModule.name
        }, {
            StudioToolbarButton = e(StudioToolbarButton, {
                active = self.state.enabled,

                onClick = function()
                    print("Toolbar button clicked")
                    self:setState(function(prevState)
                        return {
                            enabled = not prevState.enabled
                        }
                    end)
                end
            })
        }),


        -- UI
        StudioDockWidget = e(StudioDockWidget, {
            enabled = self.state.enabled,
            title = "Barrier Creator",

            onInitialState = function(enabled)
                self:setState({
                    enabled = enabled
                })
            end,

            onClose = function()
                self:setState({
                    enabled = false
                })
            end
        }, {
            EditPage = e(EditPage)
        }),

        
        -- World Behaviors
        OperationModeManager = e(OperationModeManager, {
            operatingMode = self.state.operatingMode,
            active = self.state.enabled
        })
    })
end

return App