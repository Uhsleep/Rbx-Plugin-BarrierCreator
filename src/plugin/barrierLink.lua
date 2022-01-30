local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")

local BarrierLink = {}
BarrierLink.__index = BarrierLink

function createBarrier(height, positionA, positionB)
    local size = Vector3.new(1, height, (positionA - positionB).Magnitude)
    local position = (positionA + positionB) / 2

    local part = Instance.new("Part")
    part.Size = size
    part.CFrame = CFrame.lookAt(position, positionB)
    part.CFrame = part.CFrame + part.CFrame:VectorToWorldSpace(Vector3.new(0, height / 2, 0))
    part.Anchored = true
    part.Parent = workspace
    
    return part
end

function createPoint(position)
    -- local size = Vector3.new(1, height, (positionA - positionB).Magnitude)
    -- local position = (positionA + positionB) / 2

    local part = Instance.new("Part")
    part.Shape = Enum.PartType.Ball
    part.Color = Color3.fromRGB(191, 0, 0)
    part.Position = position
    part.Parent = workspace
    
    return part
end

function BarrierLink:AddBarrierBetweenPoints(indexA, indexB)
    local positionA = self.points[indexA].Position
    local positionB = self.points[indexB].Position

    local barrierPart = createBarrier(self.height, positionA, positionB)
    barrierPart.Name = "Barrier" .. self:NumBarriers() + 1
    barrierPart.Parent = self.barriersModel

    table.insert(self.barriers, barrierPart)
end

function BarrierLink:AddPoint(position)
    -- 1. add position to end of list
    local index = self:NumPoints() + 1
    local pointPart = createPoint(position)
    pointPart.Name = "Point" .. index
    pointPart.Parent = self.pointsModel
    self.points[index] = pointPart

    -- 2. check if there is a previous point
    --      if so, add a barrier between these points
    if self:NumPoints() > 1 then
        self:AddBarrierBetweenPoints(self.selectedPointIndex, index)
    else
        -- print("Setting group model parent to workspace")
        self.groupModel.Parent = workspace
    end

    self:SetSelectedPoint(index)

    if self.connectionToBeginningEnabled then
        if self:NumBarriers() > 1 and not self.ghostConnectionBarrier then
            local part = createBarrier(self.height, self.points[self:NumPoints()].Position, self.points[1].Position)
            part.Transparency = 0.75
            part.Parent = self.groupModel
            part.Name = "GhostConnectionBarrier"

            self.ghostConnectionBarrier = part
        else
            self:UpdateGhostConnectionBarrier()
        end
    end

    ChangeHistoryService:SetWaypoint("Added Barrier Point")
end

function BarrierLink:UpdateGhostConnectionBarrier()
    if not self:HasGhostConnectionBarrier() then
        return
    end

    local positionA = self.points[self:NumPoints()].Position
    local positionB = self.points[1].Position

    local size = Vector3.new(1, self.height, (positionA - positionB).Magnitude)
    local position = (positionA + positionB) / 2

    local part = self.ghostConnectionBarrier
    part.Size = size
    part.CFrame = CFrame.lookAt(position, positionB)
    part.CFrame = part.CFrame + part.CFrame:VectorToWorldSpace(Vector3.new(0, self.height / 2, 0))
end

function BarrierLink:SetSelectedPoint(index)
    if index < 1 or index > self:NumPoints() then
        return
    end

    local previousSelectedPart = self:GetPoint(self.selectedPointIndex)
    if previousSelectedPart then
        previousSelectedPart.Color = Color3.fromRGB(191, 0, 0)
    end

    local newSelectedPart = self:GetPoint(index)
    newSelectedPart.Color = Color3.fromRGB(255, 255, 71)

    self.selectedPointIndex = index
end

function BarrierLink:SetSelectedPointByPart(part)
    for index, p in ipairs(self.points) do
        if p == part then
            self:SetSelectedPoint(index)
            return
        end
    end
end

-- EVERYTHING THAT HANDLES MOVING AND UPDATING THE PARTS

function BarrierLink:MovePoint(index, position)
 -- when moving a point, we need to update the 2 barriers that are attached to it
end

function BarrierLink:MovePointByPart(part, position)
    -- when moving a point, we need to update the 2 barriers that are attached to it
end

function BarrierLink:MoveBarrier(index, position)
    -- when moving a barrier, we need to update the points AND the other barriers attached to those points
end

function BarrierLink:MoveBarrierByPart(part, position)
    -- when moving a barrier, we need to update the points AND the other barriers attached to those points
end

------------------------------------------------------------------

function BarrierLink:InsertPoint(position, index)

end

function BarrierLink:RemovePoint(position, index)

end


function BarrierLink:SetBarrierHeight(height)
    self.height = height

    -- update the ghost barrier connection height
    if self:HasGhostConnectionBarrier() then
        self:UpdateGhostConnectionBarrier()
    end
end


function BarrierLink:NumPoints()
    return #self.points
end

function BarrierLink:NumBarriers()
    return #self.barriers
end

function BarrierLink:RemoveBarrier(barrierPart)

end

function BarrierLink:GetPoint(index)
    return self.points[index]
end

function BarrierLink:Destroy()
    if self.groupModel then
        self.groupModel:Destroy()
    end

    if self.undoConnection then
        self.undoConnection:Disconnect()
        self.undoConnection = nil
    end

    if self.redoConnection then
        self.redoConnection:Disconnect()
        self.redoConnection = nil
    end

    self.groupModel = nil
    self.pointsModel = nil
    self.barriersModel = nil
    self.ghostConnectionBarrier = nil
end

function BarrierLink:DetachBarriersAndDestroy()
    self.barriersModel.Parent = workspace

    -- move ghost connection barrier
    local part = self.ghostConnectionBarrier
    if part then
        part.Parent = self.barriersModel
        part.Transparency = 0
        part.Name = "Barrier" .. tostring(self:NumBarriers() + 1)
    end
    
    self:Destroy()
end

function BarrierLink:EnableConnectionToBeginning(enabled)
    self.connectionToBeginningEnabled = enabled

    if enabled then
        if self:NumBarriers() > 1 then
            local part = createBarrier(self.height, self.points[self:NumPoints()].Position, self.points[1].Position)
            part.Transparency = 0.75
            part.Parent = self.groupModel
            part.Name = "GhostConnectionBarrier"

            self.ghostConnectionBarrier = part
        end
    else
        if self.ghostConnectionBarrier then
            self.ghostConnectionBarrier:Destroy()
            self.ghostConnectionBarrier = nil
        end
    end
end

function BarrierLink:HasGhostConnectionBarrier()
    return self.ghostConnectionBarrier ~= nil
end

----------------------------------------------------------------------

return function()
    local barrierLink = setmetatable({
        height = 100,
        points = {},
        barriers = {},
        selectedPointIndex = 0,
        connectToBeginning = false,

        pointsModel = Instance.new("Model"),
        barriersModel = Instance.new("Model")
    }, BarrierLink)

    ChangeHistoryService:SetWaypoint("Initializing Barrier Link")

    barrierLink.groupModel = Instance.new("Model")
    barrierLink.groupModel.Name = "BarrierCreator"

    barrierLink.pointsModel.Name = "Points"
    barrierLink.pointsModel.Parent = barrierLink.groupModel

    barrierLink.barriersModel.Name = "Barriers"
    barrierLink.barriersModel.Parent = barrierLink.groupModel

    ChangeHistoryService:SetWaypoint("Initialized Barrier Link")

    barrierLink.undoConnection = ChangeHistoryService.OnUndo:Connect(function(waypoint)
        if waypoint ~= "Added Barrier Point" then
            return
        end

        table.remove(barrierLink.points)

        if barrierLink:NumBarriers() >= 1 then
            -- barrierLink.barriers[barrierLink:NumBarriers()]:Destroy()
            table.remove(barrierLink.barriers)
        end

        barrierLink:SetSelectedPoint(barrierLink:NumPoints())

        -- print(barrierLink:NumPoints())
        -- print(barrierLink.points)
    end)
    
    barrierLink.redoConnection = ChangeHistoryService.OnRedo:Connect(function(waypoint)
        if waypoint ~= "Added Barrier Point" then
            return
        end

        -- local position = table.remove(positionHistoryStack)
        -- if position then
        --     barrierLink:AddPoint(position)
        -- end

        local objects = Selection:Get()
        if #objects > 0 then
            for _, obj in ipairs(objects) do
                if string.match(obj.Name, "Point") and obj.Parent == barrierLink.pointsModel then
                    local pointFound = false
                    for _, point in ipairs(barrierLink.points) do
                        if  point == obj then                 
                            pointFound = true
                            break
                        end
                    end

                    if not pointFound then
                        table.insert(barrierLink.points, obj)
                        barrierLink:SetSelectedPoint(barrierLink:NumPoints())
                    end

                elseif string.match(obj.Name, "Barrier") and obj.Parent == barrierLink.barriersModel then
                    table.insert(barrierLink.barriers, obj)
                end
            end
        end

        Selection:Set({})

        -- print(barrierLink:NumPoints())
        -- print(barrierLink.points)
    end)
    
    return barrierLink
end