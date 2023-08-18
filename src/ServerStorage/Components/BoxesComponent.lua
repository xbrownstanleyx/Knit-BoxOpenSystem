local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Knit = require(ReplicatedStorage.Packages.Knit)
local Component = require(ReplicatedStorage.Packages.Component)
local Trove = require(ReplicatedStorage.Packages.Trove)


local BoxesFolder = game.Workspace:WaitForChild('Boxes')

local BoxesInfo = require(script.Parent.Parent.Modules.BoxesInfo)

local Loger = {}
function Loger.ShouldConstruct(component)
    if not Component.Instance:IsA('Model') then return false end
    if Component.Instance.Parent ~= BoxesFolder then return false end
    return true
end

local BoxesComponent = Component.new{
    Tag = BoxesInfo.TAG,
    Ancestors = {BoxesFolder},
    Extensions = Loger
}

function BoxesComponent:Player_Win(plr)
    local money = plr.leaderstats:FindFirstChild("Money")
    if money then
        self.BoxService:FireClient(plr,self.Win)
        money.Value += self.Win
        self:Exit()
    end
end

function BoxesComponent:onTouched(hit)
    local plr = Players:GetPlayerFromCharacter(hit.Parent)
    if plr then
        print(plr.Name .. " win " .. tostring(self.Win))
        self:Player_Win(plr)
    end
end

function BoxesComponent:Construct()
    self.Win = math.random(50, 1000)
    self._trove = Trove.new()
end

function BoxesComponent:Start()
    self.BoxService = Knit.GetService('BoxService')
    self._trove:AttachToInstance(self.Instance) -- When Instance will destroy the Trove will destroy itself
    self._trove:Add(self.Instance.PrimaryPart.Touched:Connect(function(hit) -- Add taker on Function
        self:onTouched(hit)
    end))
end

function BoxesComponent:Exit()
    self.Instance:Destroy()
end

return BoxesComponent