--[[
    Nova UI Library - Gen4
    High-quality neon-inspired UI library
]]

local Nova = {}
Nova.__index = Nova

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local function getParent()
    if gethui then return gethui() end
    if syn and syn.protect_gui then
        local g = Instance.new("ScreenGui")
        syn.protect_gui(g)
        return g
    end
    return CoreGui
end

local function tween(obj, props, time, style, dir)
    local info = TweenInfo.new(time or 0.35, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local Themes = {
    Neon = {
        Background = Color3.fromRGB(16, 16, 22),
        Surface = Color3.fromRGB(24, 24, 34),
        SurfaceHover = Color3.fromRGB(32, 32, 46),
        Accent = Color3.fromRGB(0, 255, 170),
        AccentDark = Color3.fromRGB(0, 180, 120),
        Text = Color3.fromRGB(240, 245, 255),
        TextDim = Color3.fromRGB(140, 150, 175),
        Stroke = Color3.fromRGB(50, 55, 75),
        Danger = Color3.fromRGB(255, 75, 95),
        Warning = Color3.fromRGB(255, 190, 60),
        Success = Color3.fromRGB(0, 255, 170),
    },
    Purple = {
        Background = Color3.fromRGB(18, 14, 28),
        Surface = Color3.fromRGB(28, 22, 42),
        SurfaceHover = Color3.fromRGB(38, 30, 58),
        Accent = Color3.fromRGB(180, 100, 255),
        AccentDark = Color3.fromRGB(140, 70, 210),
        Text = Color3.fromRGB(245, 240, 255),
        TextDim = Color3.fromRGB(160, 145, 190),
        Stroke = Color3.fromRGB(60, 50, 90),
        Danger = Color3.fromRGB(255, 75, 95),
        Warning = Color3.fromRGB(255, 190, 60),
        Success = Color3.fromRGB(180, 100, 255),
    },
    Cyan = {
        Background = Color3.fromRGB(12, 18, 24),
        Surface = Color3.fromRGB(20, 30, 40),
        SurfaceHover = Color3.fromRGB(28, 42, 56),
        Accent = Color3.fromRGB(0, 210, 255),
        AccentDark = Color3.fromRGB(0, 160, 200),
        Text = Color3.fromRGB(230, 250, 255),
        TextDim = Color3.fromRGB(120, 170, 190),
        Stroke = Color3.fromRGB(40, 60, 80),
        Danger = Color3.fromRGB(255, 75, 95),
        Warning = Color3.fromRGB(255, 190, 60),
        Success = Color3.fromRGB(0, 210, 255),
    }
}

local CurrentTheme = Themes.Neon

local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

local function corner(obj, r)
    return create("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent = obj})
end

local function stroke(obj, color, thickness, transparency)
    return create("UIStroke", {
        Color = color or CurrentTheme.Stroke,
        Thickness = thickness or 1,
        Transparency = transparency or 0.4,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = obj
    })
end

local function padding(obj, t, b, l, r)
    return create("UIPadding", {
        PaddingTop = UDim.new(0, t or 0),
        PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0),
        PaddingRight = UDim.new(0, r or 0),
        Parent = obj
    })
end

-- ================= MAIN =================
function Nova:CreateWindow(settings)
    settings = settings or {}
    local title = settings.Name or "Nova UI"
    local toggleKey = settings.ToggleKey or Enum.KeyCode.RightShift
    local configName = settings.ConfigName or "NovaConfig"

    local screenGui = create("ScreenGui", {
        Name = "NovaUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = getParent()
    })

    -- Main Frame
    local main = create("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(520, 480),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundColor3 = CurrentTheme.Background,
        Parent = screenGui
    })
    corner(main, 12)
    stroke(main, CurrentTheme.Accent, 1.2, 0.7)

    -- Soft glow
    local glow = create("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = CurrentTheme.Accent,
        ImageTransparency = 0.75,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Size = UDim2.new(1, 60, 1, 60),
        Position = UDim2.fromOffset(-30, -30),
        ZIndex = 0,
        Parent = main
    })

    -- Topbar
    local topbar = create("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = CurrentTheme.Surface,
        BorderSizePixel = 0,
        Parent = main
    })
    corner(topbar, 12)
    create("Frame", { -- corner fix
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.fromOffset(0, 26),
        BackgroundColor3 = CurrentTheme.Surface,
        BorderSizePixel = 0,
        Parent = topbar
    })

    -- Traffic lights
    local traffic = create("Frame", {
        Size = UDim2.fromOffset(70, 42),
        BackgroundTransparency = 1,
        Parent = topbar
    })
    local tLayout = create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 7),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = traffic
    })

    local function trafficButton(color, callback)
        local b = create("TextButton", {
            Size = UDim2.fromOffset(12, 12),
            BackgroundColor3 = color,
            Text = "",
            AutoButtonColor = false,
            Parent = traffic
        })
        corner(b, 20)
        if callback then b.MouseButton1Click:Connect(callback) end
        return b
    end

    trafficButton(CurrentTheme.Danger, function() screenGui:Destroy() end)
    local minimizeBtn = trafficButton(CurrentTheme.Warning)
    local greenBtn = trafficButton(CurrentTheme.Success)

    -- Title
    local titleLabel = create("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.fromOffset(80, 0),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = CurrentTheme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = title,
        Parent = topbar
    })

    -- Dragging
    local dragging, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Content area
    local content = create("Frame", {
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.fromOffset(10, 50),
        BackgroundTransparency = 1,
        Parent = main
    })

    -- Tab buttons container (left)
    local tabList = create("ScrollingFrame", {
        Size = UDim2.fromOffset(130, 1),
        Size = UDim2.new(0, 130, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = CurrentTheme.Accent,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = content
    })
    local tabLayout = create("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabList
    })

    -- Elements container (right)
    local elementsContainer = create("Frame", {
        Size = UDim2.new(1, -140, 1, 0),
        Position = UDim2.fromOffset(140, 0),
        BackgroundTransparency = 1,
        Parent = content
    })

    local tabs = {}
    local selectedTab = nil

    local Window = {}

    function Window:CreateTab(name, icon)
        local tabBtn = create("TextButton", {
            Size = UDim2.new(1, -4, 0, 34),
            BackgroundColor3 = CurrentTheme.Surface,
            BackgroundTransparency = 1,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = CurrentTheme.TextDim,
            Text = name,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            Parent = tabList
        })
        corner(tabBtn, 7)
        padding(tabBtn, 0, 0, 10, 0)

        local page = create("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = CurrentTheme.Accent,
            CanvasSize = UDim2.new(0,0,0,0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = elementsContainer
        })
        local pageLayout = create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = page
        })
        padding(page, 4, 8, 4, 8)

        local tab = {Button = tabBtn, Page = page, Elements = {}}

        function tab:Select()
            if selectedTab then
                selectedTab.Button.BackgroundTransparency = 1
                selectedTab.Button.TextColor3 = CurrentTheme.TextDim
                selectedTab.Page.Visible = false
            end
            selectedTab = tab
            tabBtn.BackgroundTransparency = 0.3
            tabBtn.BackgroundColor3 = CurrentTheme.Accent
            tabBtn.TextColor3 = Color3.fromRGB(10, 15, 20)
            page.Visible = true
        end

        tabBtn.MouseButton1Click:Connect(function()
            tab:Select()
        end)

        -- Element creators
        function tab:CreateSection(text)
            local s = create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextColor3 = CurrentTheme.Accent,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = string.upper(text),
                Parent = page
            })
            return s
        end

        function tab:CreateLabel(text)
            local l = create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = CurrentTheme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Text = text,
                Parent = page
            })
            return l
        end

        function tab:CreateParagraph(title, content)
            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = CurrentTheme.Surface,
                Parent = page
            })
            corner(frame, 8)
            stroke(frame, CurrentTheme.Stroke, 1, 0.6)
            padding(frame, 10, 10, 12, 12)

            create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 18),
                BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = title,
                Parent = frame
            })
            create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Position = UDim2.fromOffset(0, 22),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = CurrentTheme.TextDim,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Text = content,
                Parent = frame
            })
            return frame
        end

        function tab:CreateButton(opts)
            opts = opts or {}
            local btn = create("TextButton", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = CurrentTheme.Surface,
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                Text = opts.Name or "Button",
                AutoButtonColor = false,
                Parent = page
            })
            corner(btn, 8)
            stroke(btn, CurrentTheme.Stroke, 1, 0.5)

            btn.MouseEnter:Connect(function()
                tween(btn, {BackgroundColor3 = CurrentTheme.SurfaceHover}, 0.2)
            end)
            btn.MouseLeave:Connect(function()
                tween(btn, {BackgroundColor3 = CurrentTheme.Surface}, 0.2)
            end)
            btn.MouseButton1Click:Connect(function()
                if opts.Callback then
                    task.spawn(opts.Callback)
                end
            end)
            return btn
        end

        function tab:CreateToggle(opts)
            opts = opts or {}
            local state = opts.CurrentValue or false

            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = CurrentTheme.Surface,
                Parent = page
            })
            corner(frame, 8)
            stroke(frame, CurrentTheme.Stroke, 1, 0.5)
            padding(frame, 0, 0, 12, 12)

            local label = create("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = opts.Name or "Toggle",
                Parent = frame
            })

            local track = create("TextButton", {
                Size = UDim2.fromOffset(44, 24),
                Position = UDim2.new(1, -44, 0.5, -12),
                BackgroundColor3 = state and CurrentTheme.Accent or Color3.fromRGB(50, 50, 65),
                Text = "",
                AutoButtonColor = false,
                Parent = frame
            })
            corner(track, 12)

            local knob = create("Frame", {
                Size = UDim2.fromOffset(18, 18),
                Position = state and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = track
            })
            corner(knob, 20)

            local function set(value)
                state = value
                tween(knob, {Position = state and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3)}, 0.2)
                tween(track, {BackgroundColor3 = state and CurrentTheme.Accent or Color3.fromRGB(50, 50, 65)}, 0.2)
                if opts.Callback then opts.Callback(state) end
            end

            track.MouseButton1Click:Connect(function()
                set(not state)
            end)

            return {
                Set = function(_, v) set(v) end,
                Get = function() return state end
            }
        end

        function tab:CreateSlider(opts)
            opts = opts or {}
            local min, max = opts.Range and opts.Range[1] or 0, opts.Range and opts.Range[2] or 100
            local value = opts.CurrentValue or min
            local increment = opts.Increment or 1

            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 52),
                BackgroundColor3 = CurrentTheme.Surface,
                Parent = page
            })
            corner(frame, 8)
            stroke(frame, CurrentTheme.Stroke, 1, 0.5)
            padding(frame, 8, 8, 12, 12)

            local label = create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 16),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = (opts.Name or "Slider") .. "  •  " .. tostring(value),
                Parent = frame
            })

            local track = create("Frame", {
                Size = UDim2.new(1, 0, 0, 6),
                Position = UDim2.fromOffset(0, 28),
                BackgroundColor3 = Color3.fromRGB(40, 40, 55),
                Parent = frame
            })
            corner(track, 6)

            local fill = create("Frame", {
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = CurrentTheme.Accent,
                Parent = track
            })
            corner(fill, 6)

            local sliding = false
            local function update(input)
                local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                value = math.floor((min + (max - min) * rel) / increment + 0.5) * increment
                value = math.clamp(value, min, max)
                fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                label.Text = (opts.Name or "Slider") .. "  •  " .. tostring(value) .. (opts.Suffix and (" " .. opts.Suffix) or "")
                if opts.Callback then opts.Callback(value) end
            end

            track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    update(i)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding then update(i) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            return {
                Set = function(_, v)
                    value = math.clamp(v, min, max)
                    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    label.Text = (opts.Name or "Slider") .. "  •  " .. tostring(value)
                end,
                Get = function() return value end
            }
        end

        function tab:CreateDropdown(opts)
            opts = opts or {}
            local options = opts.Options or {}
            local selected = opts.CurrentOption and opts.CurrentOption[1] or options[1] or "None"

            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = CurrentTheme.Surface,
                Parent = page
            })
            corner(frame, 8)
            stroke(frame, CurrentTheme.Stroke, 1, 0.5)
            padding(frame, 0, 0, 12, 12)

            create("TextLabel", {
                Size = UDim2.new(0.45, 0, 1, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = opts.Name or "Dropdown",
                Parent = frame
            })

            local dropBtn = create("TextButton", {
                Size = UDim2.new(0.5, 0, 0, 26),
                Position = UDim2.new(0.5, 0, 0.5, -13),
                BackgroundColor3 = CurrentTheme.Background,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = CurrentTheme.Text,
                Text = selected .. " ▼",
                AutoButtonColor = false,
                Parent = frame
            })
            corner(dropBtn, 6)

            local open = false
            local listFrame

            dropBtn.MouseButton1Click:Connect(function()
                if open then
                    if listFrame then listFrame:Destroy() end
                    open = false
                    return
                end
                open = true
                listFrame = create("Frame", {
                    Size = UDim2.new(0.5, 0, 0, math.min(#options * 28, 140)),
                    Position = UDim2.new(0.5, 0, 1, 4),
                    BackgroundColor3 = CurrentTheme.Surface,
                    ZIndex = 20,
                    Parent = frame
                })
                corner(listFrame, 6)
                stroke(listFrame, CurrentTheme.Accent, 1, 0.5)
                local lLayout = create("UIListLayout", {Parent = listFrame})

                for _, opt in ipairs(options) do
                    local o = create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BackgroundTransparency = 1,
                        Font = Enum.Font.Gotham,
                        TextSize = 12,
                        TextColor3 = CurrentTheme.Text,
                        Text = opt,
                        ZIndex = 21,
                        Parent = listFrame
                    })
                    o.MouseButton1Click:Connect(function()
                        selected = opt
                        dropBtn.Text = opt .. " ▼"
                        if opts.Callback then opts.Callback({opt}) end
                        listFrame:Destroy()
                        open = false
                    end)
                end
            end)

            return {
                Set = function(_, v)
                    selected = type(v) == "table" and v[1] or v
                    dropBtn.Text = selected .. " ▼"
                end,
                Get = function() return selected end
            }
        end

        function tab:CreateKeybind(opts)
            opts = opts or {}
            local current = opts.CurrentKeybind or "None"

            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = CurrentTheme.Surface,
                Parent = page
            })
            corner(frame, 8)
            stroke(frame, CurrentTheme.Stroke, 1, 0.5)
            padding(frame, 0, 0, 12, 12)

            create("TextLabel", {
                Size = UDim2.new(0.5, 0, 1, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = opts.Name or "Keybind",
                Parent = frame
            })

            local keyBtn = create("TextButton", {
                Size = UDim2.new(0.42, 0, 0, 26),
                Position = UDim2.new(0.58, 0, 0.5, -13),
                BackgroundColor3 = CurrentTheme.Background,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = CurrentTheme.Accent,
                Text = current,
                AutoButtonColor = false,
                Parent = frame
            })
            corner(keyBtn, 6)

            local listening = false
            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if listening and not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
                    current = input.KeyCode.Name
                    keyBtn.Text = current
                    listening = false
                    if opts.Callback then opts.Callback(current) end
                end
            end)

            return {
                Set = function(_, v) current = v; keyBtn.Text = v end,
                Get = function() return current end
            }
        end

        function tab:CreateInput(opts)
            opts = opts or {}
            local frame = create("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = CurrentTheme.Surface,
                Parent = page
            })
            corner(frame, 8)
            stroke(frame, CurrentTheme.Stroke, 1, 0.5)
            padding(frame, 0, 0, 12, 12)

            create("TextLabel", {
                Size = UDim2.new(0.38, 0, 1, 0),
                BackgroundTransparency = 1,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                TextColor3 = CurrentTheme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = opts.Name or "Input",
                Parent = frame
            })

            local box = create("TextBox", {
                Size = UDim2.new(0.58, 0, 0, 26),
                Position = UDim2.new(0.42, 0, 0.5, -13),
                BackgroundColor3 = CurrentTheme.Background,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = CurrentTheme.Text,
                PlaceholderText = opts.PlaceholderText or "...",
                PlaceholderColor3 = CurrentTheme.TextDim,
                Text = opts.CurrentValue or "",
                ClearTextOnFocus = false,
                Parent = frame
            })
            corner(box, 6)

            box.FocusLost:Connect(function()
                if opts.Callback then opts.Callback(box.Text) end
            end)

            return box
        end

        if #tabs == 0 then
            tab:Select()
        end
        table.insert(tabs, tab)
        return tab
    end

    -- Visibility
    local visible = true
    function Window:Toggle()
        visible = not visible
        main.Visible = visible
    end

    minimizeBtn.MouseButton1Click:Connect(function()
        Window:Toggle()
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == toggleKey then
            Window:Toggle()
        end
    end)

    function Window:Notify(data)
        -- Simple notification for now
        print("[Notify]", data.Title, data.Content)
    end

    function Window:SetTheme(name)
        if Themes[name] then
            CurrentTheme = Themes[name]
        end
    end

    -- Green button callback
    function Window:SetGreenButton(callback)
        greenBtn.MouseButton1Click:Connect(callback)
    end

    return Window
end

return Nova
