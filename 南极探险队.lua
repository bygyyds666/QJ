local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本-南极探险队",
    Folder = "QJ脚本-南极探险队",
    Author = "作者：琼玖",
})

local Lighting = game:GetService("Lighting")
local TweenServiceBlur = game:GetService("TweenService")

local blur = Lighting:FindFirstChildOfClass("BlurEffect")
if not blur then
    blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting
end

task.spawn(function()
    local wasOpen = false
    while true do
        task.wait(0.1)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        local isOpen = mainFrame and mainFrame.Visible or false
        
        if isOpen ~= wasOpen then
            wasOpen = isOpen
            TweenServiceBlur:Create(blur, TweenInfo.new(0.3), {
                Size = isOpen and 20 or 0
            }):Play()
        end
    end
end)

local MainTab = Window:Tab({ Title = '功能', Icon = 'layers' })
Window:SelectTab(1)

getgenv().AntiFallEnabled = false
local function ApplyFallBypass()
    if getgenv().FallDamageHookLoaded then return end
    pcall(function()
        local TargetMetatable = getrawmetatable(game)
        local OriginalNamecall = TargetMetatable.__namecall
        setreadonly(TargetMetatable, false)
        TargetMetatable.__namecall = newcclosure(function(self, ...)
            local Method = getnamecallmethod()
            if getgenv().AntiFallEnabled and Method == "FireServer" then
                local RemoteName = tostring(self)
                if RemoteName:find("Fall") or RemoteName:find("Damage") or RemoteName:find("Hurt") then
                    return nil 
                end
            end
            return OriginalNamecall(self, ...)
        end)
        setreadonly(TargetMetatable, true)
    end)
    getgenv().FallDamageHookLoaded = true
end
task.spawn(ApplyFallBypass)

MainTab:Toggle({
    Title = "开启无掉落伤害",
    Value = false,
    Callback = function(Value)
        getgenv().AntiFallEnabled = Value
        if Value then
            task.spawn(function()
                while getgenv().AntiFallEnabled do
                    local Character = LocalPlayer.Character
                    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                    if Humanoid then
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local tpSpeedValue, tpWalkEnabled = 16, false

MainTab:Slider({ 
    Title = "修改移动速度", 
    Step = 1, 
    Value = {Min = 16, Max = 200, Default = 16}, 
    Callback = function(v) 
        tpSpeedValue = tonumber(v) or 16 
    end 
})

MainTab:Toggle({ 
    Title = "确认执行修改移动速度", 
    Callback = function(state)
        tpWalkEnabled = state
        if state then 
            task.spawn(function()
                while tpWalkEnabled do
                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hum and hrp and hum.MoveDirection.Magnitude > 0 then 
                        pcall(function() 
                            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (tpSpeedValue - 16) * 0.05) 
                        end) 
                    end
                    RunService.RenderStepped:Wait()
                end
            end) 
        end
    end 
})

local jump_Ys = nil
MainTab:Toggle({ 
    Title = "开启无限跳", 
    Callback = function(v)
        getgenv().Jump = v
        if jump_Ys then jump_Ys:Disconnect(); jump_Ys = nil end
        if getgenv().Jump then 
            jump_Ys = UserInputService.JumpRequest:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then 
                    character.Humanoid:ChangeState("Jumping") 
                end
            end) 
        end
    end 
})