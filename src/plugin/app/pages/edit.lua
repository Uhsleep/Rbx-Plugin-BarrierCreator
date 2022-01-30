local RunService = game:GetService("RunService")
local Selection = game:GetService("Selection")

local Root = script:FindFirstAncestor("BarrierCreator")
local Roact = require(Root.dependencies.Roact)
local e = Roact.createElement

local Button = require(script.Parent.Parent.components.gtkcomponents.button)
local Checkbox = require(script.Parent.Parent.components.gtkcomponents.checkbox)
local Dictionary = require(Root.dictionary)
local StudioPluginContext = require(script.Parent.Parent.components.studio.studioPluginContext)
-----------------------------------------------------------------------------

local EditPage = Roact.Component:extend("EditPage")

function EditPage:init()
    self.onShouldConnectValueChanged = function(value)
        self.props.pluginModule.barrierLink:EnableConnectionToBeginning(value)
        
        self:setState({
            shouldConnectToBeginning = value
        })
    end

    self.onFinishClicked = function()
        self.props.pluginModule.barrierLink:DetachBarriersAndDestroy()
        self.props.pluginModule:CreateBarrierLink()
        self.props.pluginModule.barrierLink:EnableConnectionToBeginning(self.state.shouldConnectToBeginning)
    end

    self.onHeightFocusLost = function(textbox, enterPressed, inputThatCausedFocusLoss)
        local height = tonumber(textbox.Text)
        if not height or height <= 0 then
            textbox.Text = self.state.height
        else
            self.props.pluginModule.barrierLink:SetBarrierHeight(height)

            self:setState({
                height = height
            })
        end
    end

    self.onHeightChanged = function()

    end

    self.props.pluginModule.barrierLink:SetBarrierHeight(100)

    self:setState({
        shouldConnectToBeginning = false,
        height = 100
    })
end

function EditPage:render()
    local props = {
        background = {
            BackgroundColor3 = Color3.fromRGB(92, 92, 92),
            Size = UDim2.new(1, 0, 1, 0)
        },

        listLayout = {
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Vertical,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.03, 0)
        },


        heightContainer = {
            Size = UDim2.new(1, 0, 0.1, 0),
            BackgroundTransparency = 1,

            LayoutOrder = 1
        },

        heightContainerListLayout = {
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.01, 0)
        },

        heightLabel = {
            -- Size = UDim2.new(0.9, 0, 1, 0),
            Text = "Height:",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundTransparency = 1,
            LayoutOrder = 1
        },

        heightTextbox = {
            Size = UDim2.new(0.2, 0, 1, 0),
            MultiLine = false,
            PlaceholderText = "",
            Text = tostring(self.state.height),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),

            [Roact.Event.FocusLost] = self.onHeightFocusLost,

            LayoutOrder = 2
        },

        scContainer = {
            Size = UDim2.new(1, 0, 0.1, 0),
            BackgroundTransparency = 1,

            LayoutOrder = 2
        },

        scContainerListLayout = {
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0.03, 0)
        },

        checkboxContainer = {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0.1, 0, 1, 0),

            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 1
        },

        checkboxLabel = {
            -- Size = UDim2.new(0.9, 0, 1, 0),
            Text = "Connect end to start",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            AutomaticSize = Enum.AutomaticSize.XY,
            BackgroundTransparency = 1,
            LayoutOrder = 2
        },

        buttonContainer = {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.new(0.5, 0, 0.15, 0),

            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder = 3
        },

        finishButton = {
            position = UDim2.new(0.5, 0, 0.5, 0),
            size = UDim2.new(1, 0, 1, 0),
            color = Color3.fromRGB(26, 196, 102),
            text = "Finish",
            onClick = self.onFinishClicked
        }
    }

    return e("Frame", props.background, {
        ListLayout = e("UIListLayout", props.listLayout),
        
        HeightContainer = e("Frame", props.heightContainer, {
            ListLayout = e("UIListLayout", props.heightContainerListLayout),
            TextLabel = e("TextLabel", props.heightLabel),
            TextBox = e("TextBox", props.heightTextbox)
        }),

        ShouldConnectContainer = e("Frame", props.scContainer, {
            ListLayout = e("UIListLayout", props.scContainerListLayout),

            CheckboxContainer = e("Frame", props.checkboxContainer, {
                ARConstraint = e("UIAspectRatioConstraint", { AspectRatio = 1 }),
    
                Checkbox = e(Checkbox, {
                    value = self.state.shouldConnectToBeginning,
                    onValueChanged = self.onShouldConnectValueChanged
                }),
            }),

            TextLabel = e("TextLabel", props.checkboxLabel)
        }),
        

        ButtonContainer = e("Frame", props.buttonContainer, {
            Button = e(Button, props.finishButton)
        })
    })
end

function EditPage:didMount()

end

function EditPage:didUpdate(lastProps)
    
end

function EditPage:willUnmount()

end

local function EditPageWrapper(props)
    return e(StudioPluginContext.Consumer, {
        render = function(pluginModule)
            return e(EditPage, Dictionary.merge(props, {
                pluginModule = pluginModule
            }))
        end
    })
end

return EditPageWrapper