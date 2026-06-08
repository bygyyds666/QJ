local VirtualUserService = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUserService:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUserService:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本-自动投掷",
    IconThemed = true,
    Author = "作者：琼玖",
    Folder = "少羽牛逼",
    Size = UDim2.fromOffset(100, 325),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    HideSearchBar = true,
    ScrollBarEnabled = true,
})

Window:SetBackgroundImageTransparency(0.6)

Window:EditOpenButton({
    Title = "QJ脚本-自动投掷",
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

local MainSection = Window:Section({ Title = "主要功能", Opened = true })
local MainTab = MainSection:Tab({ Title = "主要功能" })

local autoRebirthEnabled = false
local rebirthLoop = nil

MainTab:Paragraph({
        Title = "这个服务器功能可能有点少",
        Desc = "因为我不知道这个服务器能做些什么，可能也就这些功能可以做一做了",
    })

MainTab:Toggle({
    Title = "自动重生",
    Default = false,
    Callback = function(enabled)
        autoRebirthEnabled = enabled
        if enabled then
            rebirthLoop = task.spawn(function()
                while autoRebirthEnabled do
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes"):WaitForChild("__remotefunction"):InvokeServer("Rebirth", 1)
                    end)
                    task.wait(1)
                end
            end)
        else
            if rebirthLoop then
                task.cancel(rebirthLoop)
                rebirthLoop = nil
            end
        end
    end
})

local autoThrowEnabled = false
local throwLoop = nil

MainTab:Toggle({
    Title = "自动投掷",
    Default = false,
    Callback = function(enabled)
        autoThrowEnabled = enabled
        if enabled then
            throwLoop = task.spawn(function()
                while autoThrowEnabled do
                    pcall(function()
                        game:GetService("ReplicatedStorage"):WaitForChild("Paper"):WaitForChild("Remotes"):WaitForChild("__remoteevent"):FireServer("Throw Object")
                    end)
                    task.wait(1)
                end
            end)
        else
            if throwLoop then
                task.cancel(throwLoop)
                throwLoop = nil
            end
        end
    end
})