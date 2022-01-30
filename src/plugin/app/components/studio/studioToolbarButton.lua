local Root = script:FindFirstAncestor("BarrierCreator")
local Roact = require(Root.dependencies.Roact)
local e = Roact.createElement

local Dictionary = require(Root.dictionary)
local StudioToolbarContext = require(script.Parent.studioToolbarContext)

-----------------------------------------------------------------------------

local StudioToolbarButton = Roact.Component:extend("StudioToolbarButton")

function StudioToolbarButton:init()
    self.button = self.props.toolbar:CreateButton("BarrierCreationButton", "Create, delete, and modify barriers in the world", "rbxassetid://8636651656", "Create Barrier")
    self.button.ClickableWhenViewportHidden = false

    if self.props.onClick then
        self.button.Click:Connect(self.props.onClick)
    end
end

function StudioToolbarButton:render()
    return nil
end

function StudioToolbarButton:didMount()

end

function StudioToolbarButton:didUpdate(lastProps)
	-- if self.props.enabled ~= lastProps.enabled then
	-- 	self.button.Enabled = self.props.enabled
	-- end

	if self.props.active ~= lastProps.active then
		self.button:SetActive(self.props.active)
	end
end

function StudioToolbarButton:willUnmount()
    self.button:Destroy()
end

function StudioToolbarButtonWrapper(props)
    return e(StudioToolbarContext.Consumer, {
        render = function(toolbar)
            return e(StudioToolbarButton, Dictionary.merge(props, {
                toolbar = toolbar
            }))
        end
    })
end

return StudioToolbarButtonWrapper