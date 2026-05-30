local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本-像素之刃",
    Author = "作者:琼玖",
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("remotes")
local OnHitRemote = Remotes:WaitForChild("onHit")
local UseAbilityRemote = Remotes:WaitForChild("useAbility")

local _G_KillAura = false
local _G_AutoAbility = false

local AbilityList = {
    "DeathSentence", "Sand Tornado", "Cosmic Vision", "WingSmash", "BoneBreak",
    "Specter", "MoltenBeam", "Smite", "BloodyNightmare", "WeepingTouch",
    "AngelsBane", "GoldenEclipse", "RavenSense", "ShadowHook"
}

local AuraRange = 500
local AuraDamage = 9e9
local AuraSpeed = 0.05

task.spawn(function()
    while true do
        task.wait(AuraSpeed)
        
        if not _G_KillAura and not _G_AutoAbility then continue end

        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then continue end

        local targets = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Humanoid") and obj.Health > 0 and obj.Parent ~= character then
                if not Players:GetPlayerFromCharacter(obj.Parent) then
                    local targetPart = obj.Parent:FindFirstChild("HumanoidRootPart") or obj.Parent:FindFirstChild("Head")
                    if targetPart then
                        local distance = (targetPart.Position - rootPart.Position).Magnitude
                        if distance <= AuraRange then
                            table.insert(targets, obj)
                        end
                    end
                end
            end
        end

        if #targets > 0 then
            for _, target in pairs(targets) do
                if _G_KillAura then
                    task.spawn(function()
                        OnHitRemote:FireServer(target, AuraDamage, {}, 0)
                    end)
                end
            end

            if _G_AutoAbility then
                for _, abilityName in pairs(AbilityList) do
                    task.spawn(function()
                        UseAbilityRemote:FireServer(abilityName)
                    end)
                end
            end
        end
    end
end)

local CombatTab = Window:Tab({ Title = '功能', Icon = 'swords' })

Window:SelectTab(1)

CombatTab:Section({ Title = "功能" })

CombatTab:Toggle({
    Title = "杀戮光环",
    Value = false,
    Callback = function(state)
        _G_KillAura = state
        WindUI:Notify({
            Title = "通知",
            Content = state and "已开启" or "已关闭",
            Duration = 2,
            Icon = "Zap"
        })
    end
})

CombatTab:Toggle({
    Title = "自动技能",
    Value = false,
    Callback = function(state)
        _G_AutoAbility = state
        WindUI:Notify({
            Title = "系统",
            Content = state and "已开启自动技能" or "已关闭自动技能",
            Duration = 2,
            Icon = "Flame"
        })
    end
})

CombatTab:Section({ Title = "其他设置" })
CombatTab:Button({
    Title = "重置角色",
    Callback = function()
        LocalPlayer.Character:BreakJoints()
    end
})