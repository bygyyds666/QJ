local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()
local Confirmed = false

local Window = WindUI:CreateWindow({
    Title = "QJ脚本",
    Icon = "palette",
    Author = "作者：琼玖",
    Folder = "Premium",
    Size = UDim2.fromOffset(550, 400),
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function() end
    },
    SideBarWidth = 200,
    HideSearchBar = false,
})

Window:Tag({
    Title = "蜂群模拟器",
    Color = Color3.fromHex("#00ffff")
})

Window:EditOpenButton({
    Title = "蜂群模拟器",
    Icon = "crown",
    CornerRadius = UDim.new(0, 8),
    StrokeThickness = 3,
    Color = ColorSequence.new(
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 165, 0),
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(139, 0, 0)
    ),
    Draggable = true,
})

local MainTab = Window:Tab({Title = "自动功能", Icon = "settings"})
local Section1 = MainTab:Section({Title = "自动收集"})

local autoCollect = false
local collectConnection
local ToolCollectEvent = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ToolCollect")

Section1:Toggle({
    Title = "自动收集花粉",
    Default = false,
    Callback = function(state)
        autoCollect = state
        if autoCollect then
            collectConnection = task.spawn(function()
                while autoCollect do
                    ToolCollectEvent:FireServer()
                    task.wait(0.5)
                end
            end)
        else
            autoCollect = false
            if collectConnection then
                task.cancel(collectConnection)
                collectConnection = nil
            end
        end
    end
})

local TeleportTab = Window:Tab({Title = "传送点", Icon = "map-pin"})
local TeleportSection = TeleportTab:Section({Title = "传送"})

TeleportSection:Paragraph({
        Title = "由于我没有解锁太多地方所以就没弄传送，需要你自己去设置一下",
        Desc = "你可以将一个传送点设置在蜂巢，另一个传送点设置在采蜜的地方",
    })
    
local teleportPoints = {
    {name = "传送点1", pos = nil},
    {name = "传送点2", pos = nil},
}

-- 快速获取角色 HumanoidRootPart
local function getRootPart()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        return char.HumanoidRootPart
    end
    return nil
end

for i, point in ipairs(teleportPoints) do
    local index = i 

    TeleportSection:Button({
        Title = " 设置传送点 " .. point.name,
        Callback = function()
            local root = getRootPart()
            if root then
                teleportPoints[index].pos = root.Position
                print(point.name .. " 已设置: " .. tostring(root.Position))
            else
                print("角色未加载，设置失败")
            end
        end
    })

    TeleportSection:Button({
        Title = "传送传送点 " .. point.name,
        Callback = function()
            local pos = teleportPoints[index].pos
            if pos then
                local root = getRootPart()
                if root then
                    root.CFrame = CFrame.new(pos)
                    print("已传送到 " .. point.name)
                else
                    print("角色未加载")
                end
            else
                print(point.name .. " 尚未设置，请先点击设置")
            end
        end
    })

    TeleportSection:Button({
        Title = "清除传送点 " .. point.name,
        Callback = function()
            teleportPoints[index].pos = nil
            print(point.name .. " 已清除")
        end
    })
end