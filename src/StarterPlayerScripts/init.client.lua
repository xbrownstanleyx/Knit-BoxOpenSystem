local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

for _,Module in pairs(ReplicatedStorage.Source:GetDescendants()) do
    local isModule = Module:IsA("ModuleScript")

    local isComponent = Module:IsDescendantOf(ReplicatedStorage.Source.Components) and Module.Name:match("Component$")
    local isService = Module:IsDescendantOf(ReplicatedStorage.Source.Controllers) and Module.Name:match("Controller$")

    if isModule and (isComponent or isService) then
        require(Module)
    end
end

Knit.Start():catch(warn):await()
