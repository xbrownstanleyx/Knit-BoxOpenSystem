local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

for _,Module in pairs(ServerStorage.Source:GetDescendants()) do
    local isModule = Module:IsA("ModuleScript")

    local isComponent = Module:IsDescendantOf(ServerStorage.Source.Components) and Module.Name:match("Component$")
    local isService = Module:IsDescendantOf(ServerStorage.Source.Services) and Module.Name:match("Service$")

    if isModule and (isComponent or isService) then
        require(Module)
    end
end

Knit.Start():catch(warn):await()