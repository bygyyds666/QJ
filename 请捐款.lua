local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()
local Confirmed = false

local Window = WindUI:CreateWindow({
    Title = "QJ脚本",
    Icon = "palette",
    Author = "作者：琼玖",
    Folder = "Premium",
    Size = UDim2.fromOffset(550, 320),
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
        end
    },
    SideBarWidth = 200,
    HideSearchBar = false,
})

Window:Tag({
    Title = "请捐赠",
    Color = Color3.fromHex("#00ffff")
})

Window:EditOpenButton({
    Title = "请捐款",
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

local MainTab = Window:Tab({Title = "摊位管理", Icon = "settings"})
MainTab:Section({Title = "主要功能"})

local autoThanks = false
local thanksMessages = {
    "谢谢爸爸捐赠!",
    "感谢爸爸支持!",
    "谢谢爸爸捐赠!"
}
MainTab:Toggle({
    Title = "捐赠自动感谢",
    Desc = "收到捐赠后自动发送感谢消息",
    Default = false,
    Callback = function(Value)
        autoThanks = Value
        if Value then
            game.Players.LocalPlayer.leaderstats.Raised.Changed:Connect(function()
                if autoThanks then
                    local randomMsg = thanksMessages[math.random(1, #thanksMessages)]
                    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(randomMsg, "All")
                end
            end)
        end
    end
})

local antiAFK = false
MainTab:Toggle({
    Title = "防止AFK",
    Default = false,
    Callback = function(Value)
        antiAFK = Value
        if Value then
            local VirtualInputManager = game:GetService("VirtualInputManager")
            task.spawn(function()
                while antiAFK do
                    task.wait(30)
                    VirtualInputManager:SendKeyEvent(true, "W", false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, "W", false, game)
                end
            end)
        end
    end
})

local autoTalk = false
local talkInterval = 60
local talkMessages = {
    "欢迎来到我的摊位!",
    "请支持我",
    "请多多捐赠支持!",
    "我是最好的!",
    "谢谢大家的支持!"
}

MainTab:Toggle({
    Title = "自动说话",
    Desc = "定期自动发送消息",
    Default = false,
    Callback = function(Value)
        autoTalk = Value
        if Value then
            task.spawn(function()
                while autoTalk do
                    for i = 1, 5 do
                        if not autoTalk then break end
                        local randomMsg = talkMessages[math.random(1, #talkMessages)]
                        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(randomMsg, "All")
                        task.wait(1)
                    end
                    task.wait(talkInterval - 5)
                end
            end)
        end
    end
})

MainTab:Slider({
    Title = "说话间隔(秒)",
    Desc = "设置自动说话的间隔时间",
    Value = {
        Min = 10,
        Max = 300,
        Default = 60
    },
    Callback = function(Value)
        talkInterval = Value
    end
})

MainTab:Input({
    Title = "自定义说话内容",
    Desc = "输入自定义的说话内容(用逗号分隔)",
    Placeholder = "消息1,消息2,消息3",
    Callback = function(Value)
        if Value and Value ~= "" then
            local newMessages = {}
            for msg in string.gmatch(Value, "([^,]+)") do
                table.insert(newMessages, msg:gsub("^%s*(.-)%s*$", "%1"))
            end
            if #newMessages > 0 then
                talkMessages = newMessages
                WindUI:Notify({
                    Title = "说话内容已更新",
                    Content = "已设置 " .. #newMessages .. " 条自定义消息",
                    Duration = 3
                })
            end
        end
    end
})