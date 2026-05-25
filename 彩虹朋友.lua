local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本 | 彩虹朋友",
    Icon = "rbxassetid://1279310654146347060",
    Author = "作者: 琼玖",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(540, 430),
    Transparent = true,
})

Window:EditOpenButton({
    Title = "彩虹朋友",
    Icon = "sword",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"),
        Color3.fromHex("F89B29")
    ),
    Draggable = true
})

local Tab = Window:Tab({
    Title = "彩虹朋友功能",
    Icon = "home"
})


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer


local AutoCollect = false
local AutoPut = false
local AutoEye = false
local MonsterESP = false
local ItemESP = false

local MonsterConnection
local ItemConnection


Tab:Toggle({
    Title = "自动收集物品",
    Default = false,
    Callback = function(v)
        AutoCollect = v
    end
})

task.spawn(function()

    while task.wait(0.1) do

        if AutoCollect then

            pcall(function()

                local char = LocalPlayer.Character

                if not char then
                    return
                end

                local hrp = char:FindFirstChild("HumanoidRootPart")

                if not hrp then
                    return
                end

                local Items = {
                    "FoodOrange",
                    "FoodPink",
                    "FoodGreen",
                    "Battery",
                    "LightBulb",
                    "GasCanister",
                    "CakeMix"
                }

                for i = 1,24 do
                    table.insert(Items,"Block"..i)
                end

                for i = 1,14 do
                    table.insert(Items,"Fuse"..i)
                end

                for _,v in pairs(workspace:GetDescendants()) do

                    if table.find(Items,v.Name) then

                        local trigger = v:FindFirstChild("TouchTrigger")

                        if trigger and trigger:IsA("BasePart") then
                            trigger.CFrame = hrp.CFrame
                        end
                    end
                end
            end)
        end
    end
end)

Tab:Toggle({
    Title = "自动放置物品",
    Default = false,
    Callback = function(v)
        AutoPut = v
    end
})

task.spawn(function()

    while task.wait(0.1) do

        if AutoPut then

            pcall(function()

                local char = LocalPlayer.Character

                if not char then
                    return
                end

                local hrp = char:FindFirstChild("HumanoidRootPart")

                if not hrp then
                    return
                end

                local build = workspace:FindFirstChild("GroupBuildStructures")

                if not build then
                    return
                end

                for _,v in pairs(build:GetChildren()) do

                    if v:FindFirstChild("Trigger") then

                        local trigger = v.Trigger

                        if trigger:IsA("BasePart") then
                            trigger.CFrame = hrp.CFrame
                        end
                    end
                end
            end)
        end
    end
end)


Tab:Toggle({
    Title = "自动收集眼球",
    Default = false,
    Callback = function(v)
        AutoEye = v
    end
})

task.spawn(function()

    while task.wait(0.1) do

        if AutoEye then

            pcall(function()

                local ignore = workspace:FindFirstChild("ignore")

                if not ignore then
                    return
                end

                local char = LocalPlayer.Character

                if not char then
                    return
                end

                local hrp = char:FindFirstChild("HumanoidRootPart")

                if not hrp then
                    return
                end

                for _,v in pairs(ignore:GetDescendants()) do

                    if v.Name == "RootPart"
                    and v:IsA("BasePart")
                    and v.Parent
                    and v.Parent.Name == "Looky" then

                        hrp.CFrame = v.CFrame
                        task.wait(0.2)
                    end
                end
            end)
        end
    end
end)


Tab:Toggle({
    Title = "怪物上色内透",
    Default = false,
    Callback = function(v)

        MonsterESP = v

        if v then

            MonsterConnection =
                RunService.RenderStepped:Connect(function()

                pcall(function()

                    local monsters =
                        workspace:FindFirstChild("Monsters")

                    if not monsters then
                        return
                    end

                    for _,monster in pairs(monsters:GetChildren()) do

                        if not monster:FindFirstChild("MonsterESP") then

                            local esp = Instance.new("Highlight")

                            esp.Name = "MonsterESP"
                            esp.Parent = monster

                            esp.DepthMode =
                                Enum.HighlightDepthMode.AlwaysOnTop

                            esp.FillTransparency = 0.5

                            if monster.Name == "Blue" then

                                esp.FillColor =
                                    Color3.fromRGB(0,85,255)

                            elseif monster.Name == "Green" then

                                esp.FillColor =
                                    Color3.fromRGB(0,255,0)

                            elseif monster.Name == "Purple" then

                                esp.FillColor =
                                    Color3.fromRGB(170,0,255)

                            elseif monster.Name == "Yellow" then

                                esp.FillColor =
                                    Color3.fromRGB(255,255,0)

                            else

                                esp.FillColor =
                                    Color3.fromRGB(255,0,0)
                            end
                        end
                    end
                end)
            end)

        else

            if MonsterConnection then
                MonsterConnection:Disconnect()
            end

            local monsters = workspace:FindFirstChild("Monsters")

            if monsters then

                for _,monster in pairs(monsters:GetChildren()) do

                    if monster:FindFirstChild("MonsterESP") then
                        monster.MonsterESP:Destroy()
                    end
                end
            end
        end
    end
})

Tab:Toggle({
    Title = "物品上色内透",
    Default = false,
    Callback = function(v)

        ItemESP = v

        if v then

            ItemConnection =
                RunService.RenderStepped:Connect(function()

                pcall(function()

                    for _,obj in pairs(workspace:GetDescendants()) do

                        if obj.Name == "TouchTrigger"
                        and obj.Parent
                        and not obj.Parent:FindFirstChild("ItemESP") then

                            local esp = Instance.new("Highlight")

                            esp.Name = "ItemESP"
                            esp.Parent = obj.Parent

                            esp.DepthMode =
                                Enum.HighlightDepthMode.AlwaysOnTop

                            esp.FillColor =
                                Color3.fromRGB(0,255,0)

                            esp.FillTransparency = 0.5
                        end
                    end
                end)
            end)

        else

            if ItemConnection then
                ItemConnection:Disconnect()
            end

            for _,obj in pairs(workspace:GetDescendants()) do

                if obj.Name == "ItemESP" then
                    obj:Destroy()
                end
            end
        end
    end
})


WindUI:Notify({
    Title = "QJ脚本",
    Content = "以为您启用彩虹朋友脚本",
    Duration = 5
})