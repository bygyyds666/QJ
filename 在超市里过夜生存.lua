local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本",
    Icon = "rbxassetid://1279310654146347060",
    Author = "作者: 琼玖",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(520, 420),
    Transparent = true,
})

Window:EditOpenButton({
    Title = "在超级商店过夜生存",
    Icon = "sword",
    CornerRadius = UDim.new(0, 12),
    StrokeThickness = 2,
    Draggable = true
})

local Tab = Window:Tab({
    Title = "主要功能",
    Icon = "home"
})

local Section = Tab:Section({
    Title = "自动功能"
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local AutoFood = false
local AutoFlash = false
local AutoMelee = false
local AutoGun = false
local AutoHealth = false
local AutoReload = false
local AutoShoot = false
local SuperGun = false
local InfiniteStats = false
local AutoNight = false

local function GetCharacter()
    return LocalPlayer.Character
end

local function GetItems()
    local map = workspace:FindFirstChild("Map")
    if not map then return nil end

    local util = map:FindFirstChild("Util")
    if not util then return nil end

    return util:FindFirstChild("Items")
end

local function PickupByType(itemType)
    local items = GetItems()
    if not items then return end

    for _, v in ipairs(items:GetChildren()) do
        pcall(function()
            if v:FindFirstChild("ToolStats")
            and v.ToolStats:FindFirstChild("ItemType")
            and v.ToolStats.ItemType.Value == itemType then

                ReplicatedStorage.Remotes.RequestPickupItem:FireServer(v)
            end
        end)
    end
end


Section:Toggle({
    Title = "自动收集食物",
    Default = false,
    Callback = function(v)
        AutoFood = v
    end
})

Section:Toggle({
    Title = "自动收集手电筒",
    Default = false,
    Callback = function(v)
        AutoFlash = v
    end
})

Section:Toggle({
    Title = "自动收集近战武器",
    Default = false,
    Callback = function(v)
        AutoMelee = v
    end
})

Section:Toggle({
    Title = "自动收集枪械",
    Default = false,
    Callback = function(v)
        AutoGun = v
    end
})

Section:Toggle({
    Title = "自动收集药品",
    Default = false,
    Callback = function(v)
        AutoHealth = v
    end
})

Section:Toggle({
    Title = "自动装弹",
    Default = false,
    Callback = function(v)
        AutoReload = v
    end
})

Section:Toggle({
    Title = "自动开枪",
    Default = false,
    Callback = function(v)
        AutoShoot = v
    end
})

Section:Toggle({
    Title = "超级枪",
    Default = false,
    Callback = function(v)
        SuperGun = v
    end
})

Section:Toggle({
    Title = "无限体力",
    Default = false,
    Callback = function(v)
        InfiniteStats = v
    end
})

Section:Toggle({
    Title = "夜晚自动躲避",
    Default = false,
    Callback = function(v)
        AutoNight = v
    end
})


task.spawn(function()
    while task.wait(0.3) do
        if AutoFood then
            PickupByType("Food")
        end

        if AutoFlash then
            PickupByType("Flashlight")
        end

        if AutoMelee then
            PickupByType("Melee")
        end

        if AutoGun then
            PickupByType("Gun")
        end

        if AutoHealth then
            PickupByType("Health")
        end
    end
end)


task.spawn(function()
    while task.wait(0.1) do
        if AutoReload then
            pcall(function()
                local char = GetCharacter()
                if not char then return end

                local tool = char:FindFirstChildOfClass("Tool")

                if tool
                and tool:FindFirstChild("ToolStats")
                and tool.ToolStats:FindFirstChild("Ammo") then

                    ReplicatedStorage.Remotes.Weapon.GunReloaded:FireServer(tool, 1)
                end
            end)
        end
    end
end)


task.spawn(function()
    while task.wait(0.05) do
        if AutoShoot then
            pcall(function()

                local char = GetCharacter()
                if not char then return end

                local enemies = workspace:FindFirstChild("Enemies")
                if not enemies then return end

                for _, gun in ipairs(LocalPlayer.Backpack:GetChildren()) do

                    if gun:FindFirstChild("ToolStats")
                    and gun.ToolStats:FindFirstChild("Ammo") then

                        for _, enemy in ipairs(enemies:GetChildren()) do

                            if enemy:FindFirstChild("Humanoid")
                            and enemy.Humanoid.Health > 0
                            and enemy:FindFirstChild("Head") then

                                local dirTbl = {}

                                for i = 1, gun.ToolStats.BulletsPerShot.Value do
                                    table.insert(
                                        dirTbl,
                                        (enemy.Head.Position - char:GetPivot().Position).Unit
                                    )
                                end

                                local args = {
                                    [1] = {
                                        ["FiringPlayer"] = LocalPlayer,
                                        ["FiredTime"] = tick(),
                                        ["FiringPlayerUserId"] = LocalPlayer.UserId,
                                        ["Origin"] = char:GetPivot().Position,
                                        ["UID"] = tostring(math.random(1000,999999)),
                                        ["WeaponInstance"] = gun,

                                        ["ThisBulletProperties"] = {
                                            ["BulletSpread"] = gun.ToolStats.BulletSpread.Value,
                                            ["BulletsPerShot"] = gun.ToolStats.BulletsPerShot.Value,
                                            ["BulletPenetration"] = gun.ToolStats.BulletPenetration.Value,
                                            ["BulletSpeed"] = gun.ToolStats.BulletSpeed.Value,
                                            ["FireSound"] = gun.ToolStats.FireSound.Value,
                                            ["BulletSize"] = gun.ToolStats.BulletSize.Value
                                        },

                                        ["DirectionTbl"] = dirTbl
                                    }
                                }

                                ReplicatedStorage.Remotes.Weapon.GunFired:FireServer(unpack(args))
                            end
                        end
                    end
                end
            end)
        end
    end
end)


task.spawn(function()
    while task.wait(1) do
        if SuperGun then
            pcall(function()

                local function EditGun(gun)
                    if gun
                    and gun:FindFirstChild("ToolStats")
                    and gun.ToolStats:FindFirstChild("Ammo") then

                        gun.ToolStats.ReloadTime.Value = 0
                        gun.ToolStats.FireDelay.Value = 0
                        gun.ToolStats.Ammo.Value = 999999
                        gun.ToolStats.Damage.Value = 999999
                        gun.ToolStats.BulletSpread.Value = 0
                    end
                end

                for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
                    EditGun(v)
                end

                local char = GetCharacter()
                if char then
                    for _, v in ipairs(char:GetChildren()) do
                        EditGun(v)
                    end
                end
            end)
        end
    end
end)


task.spawn(function()
    while task.wait(0.2) do
        if InfiniteStats then
            pcall(function()

                local char = GetCharacter()
                if not char then return end

                local data = char:FindFirstChild("CharacterData")
                if not data then return end

                if data:FindFirstChild("MaxStamina") then
                    data.MaxStamina.Value = 999999
                end

                if data:FindFirstChild("Stamina") then
                    data.Stamina.Value = 999999
                end

                if data:FindFirstChild("MaxEnergy") then
                    data.MaxEnergy.Value = 999999
                end

                if data:FindFirstChild("Energy") then
                    data.Energy.Value = 999999
                end
            end)
        end
    end
end)


task.spawn(function()

    local SafePos = CFrame.new(306.189, 36.675, -519.244)
    local LastPos

    while task.wait(1) do

        if AutoNight then

            pcall(function()

                local gameInfo = ReplicatedStorage:FindFirstChild("GameInfo")
                if not gameInfo then return end

                local tod = gameInfo:FindFirstChild("TimeOfDay")
                if not tod then return end

                local char = GetCharacter()
                if not char then return end

                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                if tod.Value == "Night" then

                    LastPos = hrp.CFrame

                    hrp.Anchored = true
                    hrp.CFrame = SafePos

                else

                    if LastPos then
                        hrp.CFrame = LastPos
                    end

                    hrp.Anchored = false
                end
            end)
        end
    end
end)

WindUI:Notify({
    Title = "QJ脚本",
    Content = "以为您加载在超市商店过夜生存",
    Duration = 5
})