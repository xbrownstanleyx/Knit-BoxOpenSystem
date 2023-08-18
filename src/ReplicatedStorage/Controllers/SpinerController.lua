local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Tween = game:GetService('TweenService')
local Players = game:GetService('Players')

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local CrateGui = PlayerGui:WaitForChild("CrateGui")
local UnboxGui = CrateGui:WaitForChild("UnboxGui")

local Knit = require(ReplicatedStorage.Packages.Knit)
local ClientComm = require(ReplicatedStorage.Packages.Comm).ClientComm

local minTime, maxTime = 4, 6
local minCells, maxCells = 30, 40

local cells = math.random(minCells, maxCells)
local unboxTime = math.random(minTime, maxTime)

local Spiner = Knit.CreateController{
    Name = "Spiner",
}

function Spiner:GetSpin(reward)
    local weaponCell = math.random(25, cells-2)
	local RewardVPF
				
	UnboxGui.WeaponsClipping.Scroller.Size = UDim2.new(0, cells * UnboxGui.WeaponsClipping.Scroller.AbsoluteSize.Y, 1, 0)
	UnboxGui.WeaponsClipping.Scroller:ClearAllChildren()
				
	for i = 1, cells do
		local reward_for_frame = nil
		
		local Frame = Instance.new('Frame')
		local Text = Instance.new('TextLabel')
					
		if i ~= weaponCell then
			reward_for_frame = math.random(2, 1000)
		else
			reward_for_frame = reward
			RewardVPF = Frame
		end
        Frame.Size = UDim2.new(0, UnboxGui.WeaponsClipping.Scroller.AbsoluteSize.X / cells, 1, 0)
        Frame.Position = UDim2.new(0, Frame.AbsoluteSize.X * ((i - 1)*1.2), 0, 0)
        Text.Parent = Frame
        Text.Size = UDim2.new(1,0,1,0)
        Text.Text = tostring(reward_for_frame)
        Text.TextScaled = true
        Text.BorderSizePixel = 0
        Text.TextColor3 = Color3.new(0.290196, 0.67451, 0)
        Text.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        Text.Font = Enum.Font.SourceSansBold
        Frame.Name = 'Main'
        Text.Name = 'Text'
        
        local UiCorner = Instance.new('UICorner')
        UiCorner.Parent = Frame
        UiCorner.CornerRadius = UDim.new(0,25)
        local UiCornerText = Instance.new('UICorner')
        UiCornerText.Parent = Text
        UiCornerText.CornerRadius = UDim.new(0,25)
                        
        Frame.Parent = UnboxGui.WeaponsClipping.Scroller
	end
	
	CrateGui.Enabled = true
				
	local offset = math.random(-RewardVPF.AbsoluteSize.X/2, RewardVPF.AbsoluteSize.X/2)
	local distance = (RewardVPF.AbsolutePosition.X + (RewardVPF.AbsoluteSize.X / 2)) - UnboxGui.Marker.AbsolutePosition.X
				
	UnboxGui.WeaponsClipping.Scroller:TweenPosition(UDim2.new(0, -distance + offset, 0, 0), "InOut", "Quad", unboxTime)
				
	task.wait(unboxTime+0.5)
	coroutine.wrap(function()
		for i,v in pairs(UnboxGui.WeaponsClipping.Scroller:GetChildren()) do
			if i ~= weaponCell then
				v.BackgroundTransparency = 0.5
					
				local goal2 = {}
				goal2.BackgroundTransparency = 0.5
				goal2.TextTransparency = 0.5
				Tween:Create(v.Text, TweenInfo.new(0.1), goal2):Play()
			end
		end
		task.wait(1.2)
		CrateGui.Enabled = false
	end)()
end

function Spiner:KnitInit()
    self.ClientEvent = ClientComm.new(ReplicatedStorage, false, "Spin")
    self.EventObj = self.ClientEvent:BuildObject()
end

function Spiner:KnitStart(msg)
    self.EventObj.SpinerSignal:Connect(function(reward)
        self:GetSpin(reward)
    end)
end

return Spiner