local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local VirtualUserService = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUserService:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUserService:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

local PlayerConfig = {
    playernamedied = "",
    dropdown = {},
    LoopTeleport = false,
    LoopFling = false,
}

function shuaxinlb(includeSelf)
    PlayerConfig.dropdown = {}
    if includeSelf then
        for _, player in pairs(game.Players:GetPlayers()) do
            table.insert(PlayerConfig.dropdown, player.Name)
        end
    else
        local localPlayer = game.Players.LocalPlayer
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= localPlayer then
                table.insert(PlayerConfig.dropdown, player.Name)
            end
        end
    end
end

shuaxinlb(true)

function gradient(text, startColor, endColor)
    local result = ""
    local length = #text
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        local char = text:sub(i, i)
        result = result .. string.format("<font color=\"rgb(%d, %d, %d)\">%s</font>", r, g, b, char)
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = "QJ脚本-通用",
    IconThemed = true,
    Author = "作者：琼玖",
    Folder = "少羽牛逼",
    Size = UDim2.fromOffset(100, 325),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Callback = function() print("clicked") end,
        Anonymous = false
    },
    SideBarWidth = 200,
    HideSearchBar = true,
    ScrollBarEnabled = true,
})

Window:SetBackgroundImageTransparency(0.6)

Window:EditOpenButton({
    Title = "QJ脚本-通用",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 1,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("00FFFF")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("00BFFF")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("007FFF"))
    }),
    GradientRotation = 45,
    FlowSpeed = 2,
    AnimateGradient = true,
    Draggable = true,
})

local Tabs = {}

Tabs.Main = Window:Section({ Title = "玩家控制", Opened = true })
Tabs.TransTab = Tabs.Main:Tab({ Title = "传送功能", Icon = "navigation" })
Tabs.HitboxTab = Tabs.Main:Tab({ Title = "范围设置", Icon = "box" })
Tabs.MovementTab = Tabs.Main:Tab({ Title = "移动控制", Icon = "move" })
Tabs.PlayerTab = Tabs.Main:Tab({ Title = "主要功能", Icon = "user" })

Tabs.TransTab:Section({ Title = "玩家选择", Icon = "users" })

local selectedPlayer = ""
local playerDropdown = Tabs.TransTab:Dropdown({
    Title = "选择玩家名称",
    Multi = false,
    AllowNone = true,
    Values = PlayerConfig.dropdown,
    Callback = function(player)
        PlayerConfig.playernamedied = player
        selectedPlayer = player
    end
})

Tabs.TransTab:Button({
    Title = "刷新玩家列表",
    Callback = function()
        shuaxinlb(true)
        playerDropdown:Refresh(PlayerConfig.dropdown)
        WindUI:Notify({ Title = "成功", Content = "玩家列表已刷新", Duration = 3 })
    end
})

Tabs.TransTab:Section({ Title = "传送功能", Icon = "navigation" })

Tabs.TransTab:Button({
    Title = "传送到玩家旁边",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            WindUI:Notify({ Title = "错误", Content = "本地角色未加载", Duration = 5 })
            return
        end
        local localRootPart = localPlayer.Character.HumanoidRootPart
        local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            localRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            WindUI:Notify({ Title = "成功", Content = "已传送到玩家身边", Duration = 5 })
        else
            WindUI:Notify({ Title = "错误", Content = "无法传送: 玩家已消失", Duration = 5 })
        end
    end
})

local loopTeleportToggle = Tabs.TransTab:Toggle({
    Title = "循环锁定传送",
    Callback = function(enabled)
        PlayerConfig.LoopTeleport = enabled
        if enabled then
            WindUI:Notify({ Title = "成功", Content = "已开启循环传送", Duration = 5 })
            task.spawn(function()
                while PlayerConfig.LoopTeleport do
                    local localPlayer = game.Players.LocalPlayer
                    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        task.wait(0.5)
                        continue
                    end
                    local localRootPart = localPlayer.Character.HumanoidRootPart
                    local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        localRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    end
                    task.wait()
                end
            end)
        else
            WindUI:Notify({ Title = "成功", Content = "已关闭循环传送", Duration = 5 })
        end
    end
})

Tabs.TransTab:Button({
    Title = "把玩家传送过来",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            WindUI:Notify({ Title = "错误", Content = "本地角色未加载", Duration = 5 })
            return
        end
        local localRootPart = localPlayer.Character.HumanoidRootPart
        local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            targetPlayer.Character.HumanoidRootPart.CFrame = localRootPart.CFrame * CFrame.new(0, 3, 0)
            WindUI:Notify({ Title = "成功", Content = "已将玩家传送过来", Duration = 5 })
        else
            WindUI:Notify({ Title = "错误", Content = "无法传送: 玩家已消失", Duration = 5 })
        end
    end
})

local attractAllToggle = Tabs.TransTab:Toggle({
    Title = "吸全部乐子",
    Callback = function(enabled)
        if enabled then
            WindUI:Notify({ Title = "成功", Content = "已开启吸全部玩家", Duration = 5 })
            task.spawn(function()
                while attractAllToggle.Value do
                    local localPlayer = game.Players.LocalPlayer
                    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        task.wait(0.5)
                        continue
                    end
                    local localRootPart = localPlayer.Character.HumanoidRootPart
                    local localPosition = localRootPart.Position
                    local lookVector = localRootPart.CFrame.LookVector
                    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = CFrame.new(localPosition + lookVector * 3, localPosition + lookVector * 4)
                        end
                    end
                    task.wait()
                end
            end)
        else
            WindUI:Notify({ Title = "成功", Content = "已关闭吸全部玩家", Duration = 5 })
        end
    end
})

Tabs.TransTab:Section({ Title = "甩飞功能", Icon = "zap" })

local function ThrowPlayer(targetPlayer)
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    
    local localCharacter = localPlayer.Character
    local localHumanoid = localCharacter and localCharacter:FindFirstChildOfClass("Humanoid")
    local localRootPart = localHumanoid and localCharacter:FindFirstChild("HumanoidRootPart")
    if not localRootPart then return false end

    local targetCharacter = targetPlayer.Character
    local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
    local targetRootPart = targetHumanoid and targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetRootPart then return false end

    if not getgenv().OldPos then
        getgenv().OldPos = localRootPart.CFrame
    elseif localRootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = localRootPart.CFrame
    end

    getgenv().FPDH = workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight = math.huge

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "EpixVel"
    bodyVelocity.Parent = localRootPart
    bodyVelocity.Velocity = Vector3.new(900000000, 900000000, 900000000)
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

    localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    local rotationAngle = 0

    for i = 1, 10 do
        rotationAngle = rotationAngle + 100
        localRootPart.CFrame = targetRootPart.CFrame * CFrame.new(0, 1.5, 0) + targetHumanoid.MoveDirection * targetRootPart.Velocity.Magnitude / 1.25
        localRootPart.CFrame = localRootPart.CFrame * CFrame.Angles(math.rad(rotationAngle), 0, 0)
        task.wait(0.05)
        localRootPart.CFrame = targetRootPart.CFrame * CFrame.new(0, -1.5, 0) + targetHumanoid.MoveDirection * targetRootPart.Velocity.Magnitude / 1.25
        localRootPart.CFrame = localRootPart.CFrame * CFrame.Angles(math.rad(rotationAngle), 0, 0)
        task.wait(0.05)
    end

    bodyVelocity:Destroy()
    localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)

    if getgenv().OldPos then
        repeat
            localRootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
            localHumanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            task.wait()
        until (localRootPart.Position - getgenv().OldPos.Position).Magnitude < 25
    end

    workspace.FallenPartsDestroyHeight = getgenv().FPDH
    return true
end

local function FindPlayerByName(name)
    if not name or name == "" then return nil end
    name = name:lower()
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            if player.Name:lower():match("^" .. name) or (player.DisplayName and player.DisplayName:lower():match("^" .. name)) then
                return player
            end
        end
    end
    return nil
end

Tabs.TransTab:Button({
    Title = "甩飞一次",
    Callback = function()
        if PlayerConfig.playernamedied == nil or PlayerConfig.playernamedied == "" then
            WindUI:Notify({ Title = "错误", Content = "请先选择玩家", Duration = 5 })
            return
        end
        local foundPlayer = FindPlayerByName(PlayerConfig.playernamedied)
        if foundPlayer then
            if ThrowPlayer(foundPlayer) then
                WindUI:Notify({ Title = "成功", Content = "甩飞完成", Duration = 5 })
            else
                WindUI:Notify({ Title = "错误", Content = "玩家消失", Duration = 5 })
            end
        else
            WindUI:Notify({ Title = "错误", Content = "未找到玩家", Duration = 5 })
        end
    end
})

local loopFlingToggle = Tabs.TransTab:Toggle({
    Title = "循环甩飞",
    Callback = function(enabled)
        PlayerConfig.LoopFling = enabled
        if enabled then
            WindUI:Notify({ Title = "成功", Content = "已开启循环甩飞", Duration = 5 })
            task.spawn(function()
                while PlayerConfig.LoopFling do
                    if PlayerConfig.playernamedied ~= nil and PlayerConfig.playernamedied ~= "" then
                        local foundPlayer = FindPlayerByName(PlayerConfig.playernamedied)
                        if foundPlayer then
                            ThrowPlayer(foundPlayer)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            WindUI:Notify({ Title = "成功", Content = "已关闭循环甩飞", Duration = 5 })
        end
    end
})

local antiFlingToggle = Tabs.TransTab:Toggle({
    Title = "防甩飞",
    Callback = function(enabled)
        local localPlayer = game.Players.LocalPlayer
        local character = localPlayer.Character
        if not character then
            character = localPlayer.CharacterAdded:Wait()
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then
            WindUI:Notify({ Title = "错误", Content = "角色未加载完成", Duration = 5 })
            return
        end

        if enabled then
            humanoid.PlatformStand = true
            local antiVelocity = Instance.new("BodyVelocity")
            antiVelocity.Name = "AntiFling"
            antiVelocity.Parent = rootPart
            antiVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            antiVelocity.Velocity = Vector3.new(0, 0, 0)

            local antiAngular = Instance.new("BodyAngularVelocity")
            antiAngular.Name = "AntiFlingAngular"
            antiAngular.Parent = rootPart
            antiAngular.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            antiAngular.AngularVelocity = Vector3.new(0, 0, 0)

            WindUI:Notify({ Title = "成功", Content = "已开启防甩飞", Duration = 5 })
        else
            humanoid.PlatformStand = false
            local antiVelocity = rootPart:FindFirstChild("AntiFling")
            if antiVelocity then antiVelocity:Destroy() end
            local antiAngular = rootPart:FindFirstChild("AntiFlingAngular")
            if antiAngular then antiAngular:Destroy() end
            WindUI:Notify({ Title = "成功", Content = "已关闭防甩飞", Duration = 5 })
        end
    end
})

Tabs.HitboxTab:Section({ Title = "范围设置", Icon = "box" })

getgenv().HitboxSize = 15
getgenv().HitboxTransparency = 0.9
getgenv().TeamCheck = false

Tabs.HitboxTab:Button({
    Title = "范围",
    Description = "只能开启 无法关闭",
    Callback = function()
        WindUI:Notify({ Title = "成功", Content = "范围已激活", Duration = 3 })
        task.spawn(function()
            while task.wait(0.1) do
                local Players = game:GetService("Players")
                local localPlayer = Players.LocalPlayer
                for _, player in pairs(Players:GetPlayers()) do
                    if (not getgenv().TeamCheck) or (player.Team ~= localPlayer.Team) then
                        pcall(function()
                            local character = player.Character
                            if character and character:FindFirstChild("HumanoidRootPart") then
                                local rootPart = character.HumanoidRootPart
                                rootPart.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
                                rootPart.Transparency = getgenv().HitboxTransparency
                                rootPart.BrickColor = BrickColor.new("Really black")
                                rootPart.Material = Enum.Material.Neon
                                rootPart.CanCollide = false
                            end
                        end)
                    end
                end
            end
        end)
    end
})

Tabs.HitboxTab:Slider({
    Title = "范围大小设置",
    Value = { Min = 0, Max = 500, Default = 15 },
    Callback = function(size)
        getgenv().HitboxSize = size
    end
})

local teamCheckToggle = Tabs.HitboxTab:Toggle({
    Title = "队伍检测",
    Callback = function(enabled)
        getgenv().TeamCheck = enabled
        WindUI:Notify({ Title = "成功", Content = "队伍检测" .. (enabled and "已开启" or "已关闭"), Duration = 3 })
    end
})

Tabs.HitboxTab:Slider({
    Title = "范围透明度设置",
    Value = { Min = 0, Max = 1, Default = 0.9 },
    Decimals = 2,
    Callback = function(transparency)
        getgenv().HitboxTransparency = transparency
    end
})

Tabs.HitboxTab:Section({ Title = "快捷设置范围大小", Icon = "fast-forward" })

local quickSizes = {
    {name = "范围清空", size = 0},
    {name = "范围10", size = 10},
    {name = "范围20", size = 20},
    {name = "范围50", size = 50},
    {name = "范围100", size = 100},
    {name = "范围150", size = 150},
    {name = "范围200", size = 200},
    {name = "范围300", size = 300},
    {name = "范围400", size = 400},
    {name = "范围500", size = 500},
}

for _, sizeInfo in ipairs(quickSizes) do
    Tabs.HitboxTab:Button({
        Title = sizeInfo.name,
        Callback = function()
            getgenv().HitboxSize = sizeInfo.size
            WindUI:Notify({ Title = "成功", Content = "已设置范围大小为: " .. sizeInfo.size, Duration = 3 })
        end
    })
end

Tabs.MovementTab:Section({ Title = "移动设置", Icon = "move" })

local walkSpeedSlider = Tabs.MovementTab:Slider({
    Title = "设置速度",
    Value = { Min = 16, Max = 400, Default = 16 },
    Callback = function(walkSpeed)
        task.spawn(function()
            while task.wait() do
                local localPlayer = game.Players.LocalPlayer
                local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = walkSpeed
                end
            end
        end)
    end
})

local jumpPowerSlider = Tabs.MovementTab:Slider({
    Title = "设置跳跃高度",
    Value = { Min = 50, Max = 400, Default = 50 },
    Callback = function(jumpPower)
        task.spawn(function()
            while task.wait() do
                local localPlayer = game.Players.LocalPlayer
                local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = jumpPower
                end
            end
        end)
    end
})

Tabs.MovementTab:Section({ Title = "快速跑步", Icon = "running" })

local speedValue = 50
Tabs.MovementTab:Input({
    Title = "设置快速跑步速度",
    PlaceholderText = "输入速度值",
    Callback = function(speed)
        speedValue = tonumber(speed) or 50
        WindUI:Notify({ Title = "成功", Content = "已设置跑步速度为: " .. speedValue, Duration = 3 })
    end
})

local speedToggle = Tabs.MovementTab:Toggle({
    Title = "开启快速跑步",
    Callback = function(enabled)
        if enabled then
            getgenv().sudu = game:GetService("RunService").Heartbeat:Connect(function()
                local localPlayer = game.Players.LocalPlayer
                local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Parent and humanoid.MoveDirection.Magnitude > 0 then
                    localPlayer.Character:TranslateBy(humanoid.MoveDirection * speedValue / 60)
                end
            end)
            WindUI:Notify({ Title = "成功", Content = "已开启快速跑步", Duration = 3 })
        elseif getgenv().sudu then
            getgenv().sudu:Disconnect()
            getgenv().sudu = nil
            WindUI:Notify({ Title = "成功", Content = "已关闭快速跑步", Duration = 3 })
        end
    end
})

Tabs.PlayerTab:Section({ Title = "美化", Icon = "user" })

local headlessToggle = Tabs.PlayerTab:Toggle({
    Title = "美化无头",
    Default = false,
    Callback = function(enabled)
        local localPlayer = game.Players.LocalPlayer
        local char = localPlayer.Character
        if not char then
            char = localPlayer.CharacterAdded:Wait()
        end
        local head = char:FindFirstChild("Head")
        if head then
            head.Transparency = enabled and 1 or 0
            if enabled then
                local decal = head:FindFirstChildOfClass("Decal")
                if decal then decal:Destroy() end
            end
        end
    end
})

local legToggle = Tabs.PlayerTab:Toggle({
    Title = "美化断腿",
    Default = false,
    Callback = function(enabled)
        local localPlayer = game.Players.LocalPlayer
        local char = localPlayer.Character
        if not char then
            char = localPlayer.CharacterAdded:Wait()
        end
        local rightLeg = char:FindFirstChild("RightLeg") or char:FindFirstChild("Right Leg")
        if rightLeg then
            for _, child in pairs(rightLeg:GetChildren()) do
                if child:IsA("SpecialMesh") then child:Destroy() end
            end
            if enabled then
                local specialMesh = Instance.new("SpecialMesh")
                specialMesh.MeshId = "rbxassetid://101851696"
                specialMesh.TextureId = "rbxassetid://115727863"
                specialMesh.Scale = Vector3.new(1, 1, 1)
                specialMesh.Parent = rightLeg
            end
        end
    end
})

local hatToggle = Tabs.PlayerTab:Toggle({
    Title = "删除帽子",
    Default = false,
    Callback = function(enabled)
        if enabled then
            local localPlayer = game.Players.LocalPlayer
            local char = localPlayer.Character
            if not char then
                char = localPlayer.CharacterAdded:Wait()
            end
            for _, accessory in pairs(char:GetChildren()) do
                if accessory:IsA("Accessory") then accessory:Destroy() end
            end
        end
    end
})

local rainbowCharacterConnection = nil

local clothesToggle = Tabs.PlayerTab:Toggle({
    Title = "删除全部衣服",
    Default = false,
    Callback = function(enabled)
        if enabled then
            if rainbowCharacterConnection then 
                rainbowCharacterConnection:Disconnect() 
                rainbowCharacterConnection = nil
            end
            local localPlayer = game.Players.LocalPlayer
            local char = localPlayer.Character
            if not char then
                char = localPlayer.CharacterAdded:Wait()
            end
            for _, child in pairs(char:GetChildren()) do
                if child:IsA("Clothing") or child:IsA("Shirt") or child:IsA("Pants") then
                    child:Destroy()
                end
            end
            WindUI:Notify({ Title = "成功", Content = "已删除全部衣服", Duration = 3 })
        else
            if rainbowCharacterConnection then
                rainbowCharacterConnection:Disconnect()
                rainbowCharacterConnection = nil
            end
        end
    end
})

Tabs.PlayerTab:Section({ Title = "功能性", Icon = "settings" })

local noclipStepped = nil
local noclipToggle = Tabs.PlayerTab:Toggle({
    Title = "穿墙",
    Default = false,
    Callback = function(enabled)
        if enabled then
            if noclipStepped then noclipStepped:Disconnect() end
            noclipStepped = game:GetService("RunService").Stepped:Connect(function()
                local localPlayer = game.Players.LocalPlayer
                local char = localPlayer.Character
                if not char then return end
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
            WindUI:Notify({ Title = "成功", Content = "穿墙已开启", Duration = 3 })
        else
            if noclipStepped then
                noclipStepped:Disconnect()
                noclipStepped = nil
            end
            WindUI:Notify({ Title = "成功", Content = "穿墙已关闭", Duration = 3 })
        end
    end
})

local infJumpToggle = Tabs.PlayerTab:Toggle({
    Title = "无限跳",
    Default = false,
    Callback = function(enabled)
        getgenv().InfJ = enabled
        WindUI:Notify({ Title = "成功", Content = "无限跳" .. (enabled and "已开启" or "已关闭"), Duration = 3 })
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().InfJ then
        local char = game.Players.LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Tabs.PlayerTab:Button({
    Title = "飞行",
    Callback = function()
        game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Credits";
                Text ="zhanghuihuihui";
                Duration = 2.5;
            })
-- Gui to Lua
-- Version: 3.2

-- Instances:

local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")

--Properties:

main.Name = "main"
main.Parent = game.CoreGui
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14.000

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
down.Position = UDim2.new(0, 0, 0.491228074, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14.000

onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
onof.Size = UDim2.new(0, 56, 0, 28)
onof.Font = Enum.Font.SourceSans
onof.Text = "fly"
onof.TextColor3 = Color3.fromRGB(0, 0, 0)
onof.TextSize = 14.000

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 100, 0, 28)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "gui by me_ozoneYT"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
plus.Position = UDim2.new(0.231578946, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true
plus.TextSize = 14.000
plus.TextWrapped = true

speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
speed.Size = UDim2.new(0, 44, 0, 28)
speed.Font = Enum.Font.SourceSans
speed.Text = "1"
speed.TextColor3 = Color3.fromRGB(0, 0, 0)
speed.TextScaled = true
speed.TextSize = 14.000
speed.TextWrapped = true

mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
mine.Size = UDim2.new(0, 45, 0, 29)
mine.Font = Enum.Font.SourceSans
mine.Text = "-"
mine.TextColor3 = Color3.fromRGB(0, 0, 0)
mine.TextScaled = true
mine.TextSize = 14.000
mine.TextWrapped = true

speeds = 1

local speaker = game:GetService("Players").LocalPlayer

local chr = game.Players.LocalPlayer.Character
local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

nowe = false

Frame.Active = true -- main = gui
Frame.Draggable = true

onof.MouseButton1Down:connect(function()

	if nowe == true then
		nowe = false

		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	else 
		nowe = true



		for i = 1, speeds do
			spawn(function()

				local hb = game:GetService("RunService").Heartbeat	


				tpwalking = true
				local chr = game.Players.LocalPlayer.Character
				local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
				while tpwalking and hb:Wait() and chr and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						chr:TranslateBy(hum.MoveDirection)
					end
				end

			end)
		end
		game.Players.LocalPlayer.Character.Animate.Disabled = true
		local Char = game.Players.LocalPlayer.Character
		local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

		for i,v in next, Hum:GetPlayingAnimationTracks() do
			v:AdjustSpeed(0)
		end
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
		speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
		speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
	end




	
		local plr = game.Players.LocalPlayer
		local UpperTorso = plr.Character.LowerTorso
		local flying = true
		local deb = true
		local ctrl = {f = 0, b = 0, l = 0, r = 0}
		local lastctrl = {f = 0, b = 0, l = 0, r = 0}
		local maxspeed = 50
		local speed = 0


		local bg = Instance.new("BodyGyro", UpperTorso)
		bg.P = 9e4
		bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.cframe = UpperTorso.CFrame
		local bv = Instance.new("BodyVelocity", UpperTorso)
		bv.velocity = Vector3.new(0,0.1,0)
		bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
		if nowe == true then
			plr.Character.Humanoid.PlatformStand = true
		end
		while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
			wait()

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed = speed+.5+(speed/maxspeed)
				if speed > maxspeed then
					speed = maxspeed
				end
			elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
				speed = speed-1
				if speed < 0 then
					speed = 0
				end
			end
			if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
				bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
			else
				bv.velocity = Vector3.new(0,0,0)
			end

			bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
		end
		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()
		plr.Character.Humanoid.PlatformStand = false
		game.Players.LocalPlayer.Character.Animate.Disabled = false
		tpwalking = false



	





end)


up.MouseButton1Down:connect(function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,2,0)
	
end)


down.MouseButton1Down:connect(function()

	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-2,0)

end)


game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
	wait(0.7)
	game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
	game.Players.LocalPlayer.Character.Animate.Disabled = false

end)


plus.MouseButton1Down:connect(function()
	speeds = speeds + 1
	speed.Text = speeds
	if nowe == true then
		

	tpwalking = false
	for i = 1, speeds do
		spawn(function()

			local hb = game:GetService("RunService").Heartbeat	


			tpwalking = true
			local chr = game.Players.LocalPlayer.Character
			local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
			while tpwalking and hb:Wait() and chr and hum and hum.Parent do
				if hum.MoveDirection.Magnitude > 0 then
					chr:TranslateBy(hum.MoveDirection)
				end
			end

		end)
		end
		end
end)
mine.MouseButton1Down:connect(function()
	if speeds == 1 then
		speed.Text = 'can not be less than 1'
		wait(1)
		speed.Text = speeds
	else
	speeds = speeds - 1
		speed.Text = speeds
		if nowe == true then
	tpwalking = false
	for i = 1, speeds do
		spawn(function()

			local hb = game:GetService("RunService").Heartbeat	


			tpwalking = true
			local chr = game.Players.LocalPlayer.Character
			local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
			while tpwalking and hb:Wait() and chr and hum and hum.Parent do
				if hum.MoveDirection.Magnitude > 0 then
					chr:TranslateBy(hum.MoveDirection)
				end
			end

		end)
		end
		end
		end
end)
    end
})
