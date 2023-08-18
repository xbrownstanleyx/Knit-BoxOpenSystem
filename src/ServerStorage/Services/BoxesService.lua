local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerComm = require(ReplicatedStorage.Packages.Comm).ServerComm

local BoxesFolder = game.Workspace:WaitForChild('Boxes')
local Box = ReplicatedStorage.Props:WaitForChild("Box")
local MaxBoxes = 25

local BoxService = Knit.CreateService{
    Name = "BoxService",
    Client = {}
}

function BoxService:Create()
    BoxesFolder:ClearAllChildren()
    for i=1,MaxBoxes do
        local Box_Clone = Box:Clone()
        Box_Clone.Parent = BoxesFolder
        Box_Clone:MoveTo(Vector3.new(math.random(-210,230), 3, math.random(-210,230)))
        CollectionService:AddTag(Box_Clone, "Box")
    end
end

function BoxService:FireClient(player,reward)
    self.ServerSignal:Fire(player,reward)
end

function BoxService:KnitInit()
    self.ServerEvent = ServerComm.new(game.ReplicatedStorage, "Spin")
    self.ServerSignal = self.ServerEvent:CreateSignal("SpinerSignal")
end

function BoxService:KnitStart()
    self:Create()
end

return BoxService