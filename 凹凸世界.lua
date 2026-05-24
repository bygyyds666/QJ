local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local gradientColors = {
    "rgb(0, 255, 0)",
    "rgb(0, 230, 0)",
    "rgb(0, 210, 0)",
    "rgb(0, 190, 0)",
    "rgb(0, 170, 0)",
    "rgb(0, 150, 0)",
    "rgb(0, 140, 0)",
    "rgb(0, 130, 0)",
    "rgb(0, 120, 0)",
    "rgb(0, 110, 0)"
}
function createUI()
    local Window = WindUI:CreateWindow({
        Title = "凹凸世界",
        Icon = "sword",
        IconThemed = true,
        Author = "v9.1.7.8",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(400, 300),
        Transparent = true,
        Theme = "Dark",
        HideSearchBar = false,
        ScrollBarEnabled = true,
        Resizable = true,
        Background = "https://raw.githubusercontent.com/XxwanhexxX/UN/main/preview_png.png",
        BackgroundImageTransparency = 0.5,
        User = {
            Enabled = true,
            Callback = function()
                WindUI:Notify({
                    Title = "个人信息",
                    Content = "一野(培根)", 
                    Duration = 2,
                    Icon = "user"
                })
            end,
            Anonymous = false
        },
        SideBarWidth = 180,
        Search = {
            Enabled = true,
            Placeholder = "搜索...",
            Callback = function(searchText)
                print("搜索:", searchText)
            end
        }
    })

    Window:EditOpenButton({
        Title = "QJ脚本",
        Icon = "sword",
        CornerRadius = UDim.new(0,12),
        StrokeThickness = 3,
        Color = ColorSequence.new(Color3.fromHex("00FF00")),
        Draggable = true,
    })

    Window:Tag({
        Title = "作者：琼玖",
        Color = Color3.fromHex("#32CD32")
    })

    spawn(function()
        while true do
            for hue = 0, 1, 0.01 do  
                local color = Color3.fromHSV(hue, 0.8, 1)  
                Window:EditOpenButton({
                    Color = ColorSequence.new(color)
                })
                wait(0.04)  
            end
        end
    end)

    local refereeTab = Window:Tab({Title = "物品", Icon = "sports"})
    refereeTab:Button({
        Title = "直接获得裁判球",
        Icon = "download",
        Callback = function()
            local RemoteEvent = game:GetService("ReplicatedStorage").Project.RemoteEvent.ControlMessageEvent
            if not RemoteEvent then
                WindUI:Notify({
                    Title = "获取失败",
                    Content = "未找到目标RemoteEvent",
                    Duration = 3,
                    Icon = "x-circle"
                })
                return
            end

            WindUI:Notify({
                Title = "开始获取",
                Content = "正在获取50个裁判球",
                Duration = 2,
                Icon = "play"
            })

            spawn(function()
                for i = 1, 50 do
                    local args = {[1] = 2, [2] = {[1] = 1, [2] = 1, [3] = 19}}
                    RemoteEvent:FireServer(unpack(args))
                    
                    if i % 10 == 0 then
                        WindUI:Notify({
                            Title = "获取进度",
                            Content = "已获取 " .. i .. "/50 个裁判球",
                            Duration = 1,
                            Icon = "check-circle"
                        })
                    end
                    
                    task.wait(0.1)
                end

                WindUI:Notify({
                    Title = "获取完成",
                    Content = "已成功获取50个裁判球",
                    Duration = 4,
                    Icon = "success"
                })
            end)
        end
    })

    local aboutTab = Window:Tab({Title = "关于", Icon = "info"})
    local aboutSection = aboutTab:Section({Title = "信息", Opened = true})
    aboutSection:Paragraph({
        Title = "凹凸世界付费版",
        Desc = "作者:琼玖 ",
        Image = "sword",
        ImageSize = 20,
        Color = "White"
    })
    aboutSection:Button({
        Title = "支持我们",
        Icon = "heart",
        Callback = function()
            WindUI:Notify({
                Title = "感谢支持",
                Content = "您的支持是我们的动力！",
                Duration = 3,
                Icon = "heart"
            })
        end
    })

    refereeTab:Select()

    WindUI:Notify({
        Title = "凹凸世界付费版",
        Content = "UI框架已加载完成！",
        Duration = 3,
        Icon = "sword"
    })
end

createUI()