local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local LeaderStats = Knit.CreateService {
    Name = 'LeaderStats',
    Client = {}
}

function LeaderStats:Add(player,value_name,value_type)
    if player.leaderstats:FindFirstChild(value_name) then return end
    if value_type == 'num' or value_type == nil then
        local value = Instance.new('IntValue',player.leaderstats)
        value.Name = value_name
    elseif value_type == 'string' then
        local value = Instance.new('StringValue',player.leaderstats)
        value.Name = value_name
    end
end

function LeaderStats:Create(player)
    local leader = Instance.new('Folder',player)
    leader.Name = "leaderstats"
    local Money = Instance.new("IntValue",leader)
    Money.Name = 'Money'
end

function LeaderStats:KnitStart()
    game:GetService('Players').PlayerAdded:Connect(function(player)
        self:Create(player)
    end)
end

return LeaderStats