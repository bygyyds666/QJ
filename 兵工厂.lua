local HttpService = cloneref(game:GetService("HttpService"))

local isfunctionhooked = clonefunction(isfunctionhooked)
if isfunctionhooked(game.HttpGet) or isfunctionhooked(getnamecallmethod) or isfunctionhooked(request) then 
    return 
end

local function verifyKey(k)
    local ok, res = pcall(function()
        return request({
            Url = "https://ouo.lat/api/verify.php",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({key = k, time = os.time()})
        })
    end)
    
    if not ok then return false end
    
    if res.Body ~= "True" then
        return false
    end
    
    local ok2, res2 = pcall(function()
        return game:HttpGet("https://www.wtb.lat/keysystem/check-key?key="..k.."&user="..game.Players.LocalPlayer.Name)
    end)
    
    return ok2 and res2 == "success"
end

local key = ""
pcall(function() key = readfile("DyzhKey.json") end)
if key ~= "" then
    if verifyKey(key) then
        print('验证完成')
    else
        return
    end
end


local function verifyKey(k)
    local ok, res = pcall(function()
        return request({
            Url = "https://ouo.lat/api/verify.php",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({key = k, time = os.time()})
        })
    end)
    
    if not ok then return false end
    
    if res.Body ~= "True" then
        return false
    end
    
    local ok2, res2 = pcall(function()
        return game:HttpGet("https://www.wtb.lat/keysystem/check-key?key="..k.."&user="..game.Players.LocalPlayer.Name)
    end)
    
    return ok2 and res2 == "success"
end

local key = ""
pcall(function() key = readfile("DyzhKey.json") end)
if key ~= "" then
    if verifyKey(key) then
        print('验证完成')
    else
        return
    end
end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()
local Window = WindUI:CreateWindow({
    Title = "QJ脚本",
    Icon = "sword",
    IconThemed = true,
    Author = "作者 琼玖",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(500, 400),
    Transparent = true,
    Theme = "Light",
    User = {
        Enabled = true,
        Callback = function() print("clicked") end,
        Anonymous = true
    },
    SideBarWidth = 200,
    ScrollBarEnabled = true
})
local Tab = Window:Tab({  
    Title = "碰撞箱扩大",  
    Icon = "box",  
    Locked = false,
})
local hitboxEnabled = false
local noCollisionEnabled = false
local hitbox_original_properties = {}
local hitboxSize = 21
local hitboxTransparency = 6
local teamCheck = "FFA"

local defaultBodyParts = {
    "UpperTorso",
    "Head",
    "HumanoidRootPart"
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local WarningText = Instance.new("TextLabel", ScreenGui)
WarningText.Size = UDim2.new(0, 200, 0, 50)
WarningText.TextSize = 16
WarningText.Position = UDim2.new(0.5, -150, 0, 0)
WarningText.Text = "警告：可能出现碰撞问题"
WarningText.TextColor3 = Color3.new(1, 0, 0)
WarningText.BackgroundTransparency = 1
WarningText.Visible = false

local function savedPart(player, part)
    if not hitbox_original_properties[player] then
        hitbox_original_properties[player] = {}
    end
    if not hitbox_original_properties[player][part.Name] then
        hitbox_original_properties[player][part.Name] = {
            CanCollide = part.CanCollide,
            Transparency = part.Transparency,
            Size = part.Size
        }
    end
end

local function restoredPart(player)
    if hitbox_original_properties[player] then
        for partName, properties in pairs(hitbox_original_properties[player]) do
            local part = player.Character and player.Character:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                part.CanCollide = properties.CanCollide
                part.Transparency = properties.Transparency
                part.Size = properties.Size
            end
        end
    end
end

local function findClosestPart(player, partName)
    if not player.Character then return nil end
    for _, part in ipairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") and part.Name:lower():match(partName:lower()) then
            return part
        end
    end
    return nil
end

local function extendHitbox(player)
    for _, partName in ipairs(defaultBodyParts) do
        local part = player.Character and (player.Character:FindFirstChild(partName) or findClosestPart(player, partName))
        if part and part:IsA("BasePart") then
            savedPart(player, part)
            part.CanCollide = not noCollisionEnabled
            part.Transparency = hitboxTransparency / 10
            part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
        end
    end
end

local function isEnemy(player)
    if teamCheck == "FFA" or teamCheck == "Everyone" then
        return true
    end
    return player.Team ~= LocalPlayer.Team
end

local function shouldExtendHitbox(player)
    return isEnemy(player)
end

local function updateHitboxes()
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if shouldExtendHitbox(v) then
                extendHitbox(v)
            else
                restoredPart(v)
            end
        end
    end
end

local function onCharacterAdded(character)
    task.wait(0.1)
    if hitboxEnabled then
        updateHitboxes()
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(onCharacterAdded)
    player.CharacterRemoving:Connect(function()
        restoredPart(player)
        hitbox_original_properties[player] = nil
    end)
end

local function checkForDeadPlayers()
    for player, _ in pairs(hitbox_original_properties) do
        if not player.Parent or not player.Character or not player.Character:IsDescendantOf(game) then
            restoredPart(player)
            hitbox_original_properties[player] = nil
        end
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

Tab:Button({
    Title = "点击此处启动Hitbox功能",
    Callback = function()
        coroutine.wrap(function()
            while true do
                if hitboxEnabled then
                    updateHitboxes()
                    checkForDeadPlayers()
                end
                task.wait(0.1)
            end
        end)()
    end
})

Tab:Toggle({
    Title = "开启Hitbox",
    Value = false,
    Callback = function(state)
        hitboxEnabled = state
        if not state then
            for _, player in ipairs(Players:GetPlayers()) do
                restoredPart(player)
            end
            hitbox_original_properties = {}
        else
            updateHitboxes()
        end
    end
})

Tab:Slider({
    Title = "Hitbox大小",
    Value = {
        Min = 1,
        Max = 25,
        Default = 21
    },
    Callback = function(value)
        hitboxSize = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end
})

Tab:Slider({
    Title = "Hitbox透明度",
    Value = {
        Min = 1,
        Max = 10,
        Default = 6
    },
    Callback = function(value)
        hitboxTransparency = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end
})

Tab:Dropdown({
    Title = "队伍检测",
    Multi = false,
    AllowNone = false,
    Value = "FFA",
    Values = {"FFA", "队伍模式", "所有人"},
    Callback = function(value)
        teamCheck = value
        if hitboxEnabled then
            updateHitboxes()
        end
    end
})

Tab:Toggle({
    Title = "无碰撞模式",
    Value = false,
    Callback = function(state)
        noCollisionEnabled = state
        WarningText.Visible = state
        coroutine.wrap(function()
            while noCollisionEnabled do
                if hitboxEnabled then
                    updateHitboxes()
                end
                task.wait(0.01)
            end
            if hitboxEnabled then
                updateHitboxes()
            end
        end)()
    end
})

Tab:Toggle({
    Title = "半自动农场",
    Value = false,
    Callback = function(bool)
        getgenv().AutoFarm = bool
        local runServiceConnection
        local mouseDown = false
        local player = game.Players.LocalPlayer
        local camera = game.Workspace.CurrentCamera
        game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = bool and "Infinite Ammo" or ""

        local function getClosestEnemyPlayer()
            local closestDistance = math.huge
            local closestPlayer = nil
            for _, enemyPlayer in pairs(game.Players:GetPlayers()) do
                if enemyPlayer ~= player and enemyPlayer.TeamColor ~= player.TeamColor and enemyPlayer.Character then
                    local hrp = enemyPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = enemyPlayer.Character:FindFirstChild("Humanoid")
                    if hrp and humanoid and humanoid.Health > 0 then
                        local dist = (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                        if dist < closestDistance and hrp.Position.Y >= 0 then
                            closestDistance = dist
                            closestPlayer = enemyPlayer
                        end
                    end
                end
            end
            return closestPlayer
        end

        local function startAutoFarm()
            game:GetService("ReplicatedStorage").wkspc.TimeScale.Value = 12
            runServiceConnection = game:GetService("RunService").Stepped:Connect(function()
                if getgenv().AutoFarm then
                    local target = getClosestEnemyPlayer()
                    if target then
                        local pos = target.Character.HumanoidRootPart.Position + Vector3.new(0, 0, -4)
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
                            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
                            if not mouseDown then
                                mouse1press()
                                mouseDown = true
                            end
                        end
                    else
                        if mouseDown then
                            mouse1release()
                            mouseDown = false
                        end
                    end
                else
                    if runServiceConnection then
                        runServiceConnection:Disconnect()
                        runServiceConnection = nil
                    end
                    if mouseDown then
                        mouse1release()
                        mouseDown = false
                    end
                end
            end)
        end

        local function onCharacterAdded(character)
            wait(0.5)
            startAutoFarm()
        end

        player.CharacterAdded:Connect(onCharacterAdded)
        if bool then
            wait(0.5)
            startAutoFarm()
        else
            game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = ""
            getgenv().AutoFarm = false
            game:GetService("ReplicatedStorage").wkspc.TimeScale.Value = 1
            if runServiceConnection then
                runServiceConnection:Disconnect()
                runServiceConnection = nil
            end
            if mouseDown then
                mouse1release()
                mouseDown = false
            end
        end
    end
})
local Tab = Window:Tab({  
    Title = "枪械设置",  
    Icon = "crosshair",  
    Locked = false,
})

Tab:Toggle({
    Title = "无限弹药 v1",
    Value = false,
    Callback = function(state)
        game:GetService("ReplicatedStorage").wkspc.CurrentCurse.Value = state and "Infinite Ammo" or ""
    end
})

local originalValues = {
    FireRate = {},
    ReloadTime = {},
    EReloadTime = {},
    Auto = {},
    Spread = {},
    Recoil = {}
}

Tab:Toggle({
    Title = "快速换弹",
    Value = false,
    Callback = function(state)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
            if v:FindFirstChild("ReloadTime") then
                if state then
                    if not originalValues.ReloadTime[v] then
                        originalValues.ReloadTime[v] = v.ReloadTime.Value
                    end
                    v.ReloadTime.Value = 0.01
                else
                    v.ReloadTime.Value = originalValues.ReloadTime[v] or 0.8
                end
            end
            if v:FindFirstChild("EReloadTime") then
                if state then
                    if not originalValues.EReloadTime[v] then
                        originalValues.EReloadTime[v] = v.EReloadTime.Value
                    end
                    v.EReloadTime.Value = 0.01
                else
                    v.EReloadTime.Value = originalValues.EReloadTime[v] or 0.8
                end
            end
        end
    end
})

Tab:Toggle({
    Title = "快速射击",
    Value = false,
    Callback = function(state)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "FireRate" or v.Name == "BFireRate" then
                if state then
                    if not originalValues.FireRate[v] then
                        originalValues.FireRate[v] = v.Value
                    end
                    v.Value = 0.02
                else
                    v.Value = originalValues.FireRate[v] or 0.8
                end
            end
        end
    end
})

Tab:Toggle({
    Title = "自动连发",
    Value = false,
    Callback = function(state)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "Auto" or v.Name == "AutoFire" or v.Name == "Automatic" or v.Name == "AutoShoot" or v.Name == "AutoGun" then
                if state then
                    if not originalValues.Auto[v] then
                        originalValues.Auto[v] = v.Value
                    end
                    v.Value = true
                else
                    v.Value = originalValues.Auto[v] or false
                end
            end
        end
    end
})

Tab:Toggle({
    Title = "无扩散",
    Value = false,
    Callback = function(state)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "MaxSpread" or v.Name == "Spread" or v.Name == "SpreadControl" then
                if state then
                    if not originalValues.Spread[v] then
                        originalValues.Spread[v] = v.Value
                    end
                    v.Value = 0
                else
                    v.Value = originalValues.Spread[v] or 1
                end
            end
        end
    end
})

Tab:Toggle({
    Title = "无后坐力",
    Value = false,
    Callback = function(state)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "RecoilControl" or v.Name == "Recoil" then
                if state then
                    if not originalValues.Recoil[v] then
                        originalValues.Recoil[v] = v.Value
                    end
                    v.Value = 0
                else
                    v.Value = originalValues.Recoil[v] or 1
                end
            end
        end
    end
})
local Tab = Window:Tab({  
    Title = "玩家",  
    Icon = "person-standing",  
    Locked = false,
})
Tab:Button({
    Title = "移速(懒得写)",
    Desc = nil,
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dream77239/fly/main/README.md"))()
    end
})
local isJumpPowerEnabled = false
local jumpMethods = {"Velocity", "Vector", "CFrame"}
local selectedJumpMethod = jumpMethods[1]

Tab:Toggle({
    Title = "自定义跳跃高度",
    Value = false,
    Callback = function(state)
        isJumpPowerEnabled = state
    end
})

Tab:Dropdown({
    Title = "跳跃方法",
    Multi = false,
    AllowNone = false,
    Value = selectedJumpMethod,
    Values = jumpMethods,
    Callback = function(selected)
        selectedJumpMethod = selected
    end
})

Tab:Slider({
    Title = "跳跃高度",
    Value = {
        Min = 30,
        Max = 500,
        Default = 30,
    },
    Callback = function(value)
        local player = game:GetService("Players").LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.UseJumpPower = true
            humanoid.Jumping:Connect(function(isActive)
                if isJumpPowerEnabled and isActive then
                    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        if selectedJumpMethod == "Velocity" then
                            rootPart.Velocity = Vector3.new(rootPart.Velocity.X, value, rootPart.Velocity.Z)
                        elseif selectedJumpMethod == "Vector" then
                            rootPart.Velocity = Vector3.new(0, value, 0)
                        elseif selectedJumpMethod == "CFrame" then
                            player.Character:SetPrimaryPartCFrame(player.Character:GetPrimaryPartCFrame() + Vector3.new(0, value, 0))
                        end
                    end
                end
            end)
        end
    end
})
local Tab = Window:Tab({  
    Title = "美化",  
    Icon = "hand-platter",  
    Locked = false,
})

-- Arm Skins
local armMaterial = "Plastic"
local armColor = Color3.fromRGB(50, 50, 50)
local armCharmsEnabled = false

Tab:Dropdown({
    Title = "手臂材质",
    Multi = false,
    AllowNone = false,
    Value = armMaterial,
    Values = {"Plastic", "ForceField", "Wood", "Grass"},
    Callback = function(value)
        armMaterial = value
    end
})

Tab:Colorpicker({
    Title = "手臂颜色",
    Default = Color3.fromRGB(50, 50, 50),
    Callback = function(color)
        armColor = color
    end
})

Tab:Toggle({
    Title = "开启手臂美化",
    Value = false,
    Callback = function(state)
        armCharmsEnabled = state
        if armCharmsEnabled then
            spawn(function()
                while armCharmsEnabled do
                    task.wait(0.01)
                    local cameraArms = workspace.Camera:FindFirstChild("Arms")
                    if cameraArms then
                        for _, part in pairs(cameraArms:GetDescendants()) do
                            if part.Name == 'Right Arm' or part.Name == 'Left Arm' then
                                if part:IsA("BasePart") then
                                    part.Material = Enum.Material[armMaterial]
                                    part.Color = armColor
                                end
                            elseif part:IsA("SpecialMesh") then
                                if part.TextureId == '' then
                                    part.TextureId = 'rbxassetid://0'
                                    part.VertexColor = Vector3.new(armColor.R, armColor.G, armColor.B)
                                end
                            elseif part.Name == 'L' or part.Name == 'R' then
                                part:Destroy()
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- Gun Skins
local gunMaterial = "Plastic"
local gunColor = Color3.fromRGB(50, 50, 50)
local gunCharmsEnabled = false

Tab:Dropdown({
    Title = "枪械材质",
    Multi = false,
    AllowNone = false,
    Value = gunMaterial,
    Values = {"Plastic", "ForceField", "Wood", "Grass"},
    Callback = function(value)
        gunMaterial = value
    end
})

Tab:Colorpicker({
    Title = "枪械颜色",
    Default = Color3.fromRGB(50, 50, 50),
    Callback = function(color)
        gunColor = color
    end
})

Tab:Toggle({
    Title = "开启枪械美化",
    Value = false,
    Callback = function(state)
        gunCharmsEnabled = state
        if gunCharmsEnabled then
            spawn(function()
                while gunCharmsEnabled do
                    task.wait(0.01)
                    local cameraArms = workspace.Camera:FindFirstChild("Arms")
                    if cameraArms then
                        for _, part in pairs(cameraArms:GetDescendants()) do
                            if part:IsA("MeshPart") then
                                part.Material = Enum.Material[gunMaterial]
                                part.Color = gunColor
                            end
                        end
                    end
                end
            end)
        end
    end
})
local Tab = Window:Tab({  
    Title = "聊天标签/娱乐",  
    Icon = "message-circle",  
    Locked = false,
})
Tab:Toggle({
    Title = "IsChad",
    Value = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if player:FindFirstChild("IsChad") then
            player.IsChad:Destroy()
        end
        if state then
            local val = Instance.new("IntValue", player)
            val.Name = "IsChad"
        end
    end
})

Tab:Toggle({
    Title = "VIP",
    Value = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if player:FindFirstChild("VIP") then
            player.VIP:Destroy()
        end
        if state then
            local val = Instance.new("IntValue", player)
            val.Name = "VIP"
        end
    end
})

Tab:Toggle({
    Title = "OldVIP",
    Value = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if player:FindFirstChild("OldVIP") then
            player.OldVIP:Destroy()
        end
        if state then
            local val = Instance.new("IntValue", player)
            val.Name = "OldVIP"
        end
    end
})

Tab:Toggle({
    Title = "Romin",
    Value = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if player:FindFirstChild("Romin") then
            player.Romin:Destroy()
        end
        if state then
            local val = Instance.new("IntValue", player)
            val.Name = "Romin"
        end
    end
})

Tab:Toggle({
    Title = "管理员",
    Value = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if player:FindFirstChild("IsAdmin") then
            player.IsAdmin:Destroy()
        end
        if state then
            local val = Instance.new("IntValue", player)
            val.Name = "IsAdmin"
        end
    end
})
local Tab = Window:Tab({
    Title = "设置",
    Icon = "settings",
    Locked = false,
})
local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

Tab:Dropdown({
    Title = "更改ui颜色",
    Multi = false,
    AllowNone = false,
    Value = nil,
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end
})