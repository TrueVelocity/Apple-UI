--[[
    Apple UI Library - Gen3 Neon Glow
    Extremely polished, glowing, feature-rich rewrite
]]

local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- ================= THEMES =================
local Themes = {
    Neon = {
        Background = Color3.fromRGB(12, 12, 18),
        Surface = Color3.fromRGB(22, 22, 32),
        Surface2 = Color3.fromRGB(32, 32, 48),
        Accent = Color3.fromRGB(0, 255, 170),
        AccentDark = Color3.fromRGB(0, 180, 120),
        Text = Color3.fromRGB(240, 245, 255),
        TextDim = Color3.fromRGB(140, 150, 170),
        Danger = Color3.fromRGB(255, 70, 90),
        Warning = Color3.fromRGB(255, 190, 50),
        Success = Color3.fromRGB(0, 255, 170),
        Glow = Color3.fromRGB(0, 255, 170),
    },
    Purple = {
        Background = Color3.fromRGB(14, 10, 22),
        Surface = Color3.fromRGB(28, 20, 42),
        Surface2 = Color3.fromRGB(42, 30, 62),
        Accent = Color3.fromRGB(180, 90, 255),
        AccentDark = Color3.fromRGB(130, 50, 200),
        Text = Color3.fromRGB(245, 240, 255),
        TextDim = Color3.fromRGB(160, 140, 190),
        Danger = Color3.fromRGB(255, 70, 90),
        Warning = Color3.fromRGB(255, 190, 50),
        Success = Color3.fromRGB(180, 90, 255),
        Glow = Color3.fromRGB(180, 90, 255),
    },
    Cyan = {
        Background = Color3.fromRGB(8, 16, 22),
        Surface = Color3.fromRGB(16, 28, 38),
        Surface2 = Color3.fromRGB(24, 42, 58),
        Accent = Color3.fromRGB(0, 220, 255),
        AccentDark = Color3.fromRGB(0, 160, 200),
        Text = Color3.fromRGB(230, 250, 255),
        TextDim = Color3.fromRGB(120, 170, 190),
        Danger = Color3.fromRGB(255, 70, 90),
        Warning = Color3.fromRGB(255, 190, 50),
        Success = Color3.fromRGB(0, 220, 255),
        Glow = Color3.fromRGB(0, 220, 255),
    },
    Red = {
        Background = Color3.fromRGB(18, 8, 10),
        Surface = Color3.fromRGB(32, 14, 18),
        Surface2 = Color3.fromRGB(48, 22, 28),
        Accent = Color3.fromRGB(255, 60, 90),
        AccentDark = Color3.fromRGB(200, 30, 60),
        Text = Color3.fromRGB(255, 240, 245),
        TextDim = Color3.fromRGB(180, 130, 140),
        Danger = Color3.fromRGB(255, 70, 90),
        Warning = Color3.fromRGB(255, 190, 50),
        Success = Color3.fromRGB(255, 60, 90),
        Glow = Color3.fromRGB(255, 60, 90),
    }
}

local CurrentTheme = Themes.Neon
local RainbowMode = false

-- ================= HELPERS =================
local function tween(obj, props, time, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.35, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function protect(gui)
    if syn and syn.protect_gui then syn.protect_gui(gui) end
end

local function getParent()
    return gethui and gethui() or CoreGui
end

local function addGlow(parent, color, sizeMult, transparency)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084" -- soft glow
    glow.ImageColor3 = color or CurrentTheme.Glow
    glow.ImageTransparency = transparency or 0.55
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(24, 24, 276, 276)
    glow.Size = UDim2.new(1, sizeMult or 40, 1, sizeMult or 40)
    glow.Position = UDim2.fromOffset(-(sizeMult or 40)/2, -(sizeMult or 40)/2)
    glow.ZIndex = parent.ZIndex - 1
    glow.Parent = parent
    return glow
end

local function addStroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or CurrentTheme.Accent
    s.Thickness = thickness or 1.2
    s.Transparency = transparency or 0.3
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function createCorner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
    return c
end

-- ================= LIBRARY =================
function Library.new(title, showSplash, toggleKey, destroyPrevious)
    local self = setmetatable({}, Library)

    local parent = getParent()
    if destroyPrevious then
        local old = parent:FindFirstChild("AppleUI_Gen3")
        if old then old:Destroy() end
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AppleUI_Gen3"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    protect(screenGui)
    screenGui.Parent = parent

    -- ========== SPLASH ==========
    if showSplash then
        local splash = Instance.new("Frame")
        splash.AnchorPoint = Vector2.new(0.5, 0.5)
        splash.Size = UDim2.fromOffset(280, 280)
        splash.Position = UDim2.new(0.5, 0, 1.5, 0)
        splash.BackgroundColor3 = CurrentTheme.Surface
        splash.ZIndex = 100
        splash.Parent = screenGui
        createCorner(splash, 24)
        addGlow(splash, CurrentTheme.Glow, 80, 0.4)

        local logo = Instance.new("TextLabel")
        logo.Size = UDim2.fromScale(1, 1)
        logo.BackgroundTransparency = 1
        logo.Font = Enum.Font.GothamBlack
        logo.TextSize = 42
        logo.TextColor3 = CurrentTheme.Accent
        logo.Text = "A"
        logo.ZIndex = 101
        logo.Parent = splash

        tween(splash, {Position = UDim2.fromScale(0.5, 0.5)}, 0.7)
        task.delay(1.6, function()
            tween(splash, {Position = UDim2.new(0.5, 0, 1.6, 0), BackgroundTransparency = 1}, 0.55)
            Debris:AddItem(splash, 0.7)
        end)
    end

    -- ========== MAIN WINDOW ==========
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Size = UDim2.fromOffset(780, 580)
    main.Position = UDim2.new(0.5, 0, 1.4, 0)
    main.BackgroundColor3 = CurrentTheme.Background
    main.Parent = screenGui
    createCorner(main, 16)
    addGlow(main, CurrentTheme.Glow, 60, 0.65)
    addStroke(main, CurrentTheme.Accent, 1.5, 0.6)

    -- Gradient overlay
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180,180,220))
    }
    grad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.92),
        NumberSequenceKeypoint.new(1, 0.97)
    }
    grad.Rotation = 45
    grad.Parent = main

    -- Dragging
    local dragging, dragStart, startPos
    main.InputBegan:Connect(function(input)
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

    -- Traffic lights
    local traffic = Instance.new("Frame")
    traffic.Size = UDim2.fromOffset(90, 36)
    traffic.Position = UDim2.fromOffset(16, 14)
    traffic.BackgroundTransparency = 1
    traffic.Parent = main

    local tLayout = Instance.new("UIListLayout")
    tLayout.FillDirection = Enum.FillDirection.Horizontal
    tLayout.Padding = UDim.new(0, 9)
    tLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tLayout.Parent = traffic

    local function trafficBtn(color, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(15, 15)
        b.BackgroundColor3 = color
        b.Text = ""
        b.AutoButtonColor = false
        createCorner(b, 20)
        addGlow(b, color, 18, 0.5)
        b.Parent = traffic
        if callback then b.MouseButton1Click:Connect(callback) end
        return b
    end

    local closeBtn = trafficBtn(CurrentTheme.Danger, function() screenGui:Destroy() end)
    local minBtn = trafficBtn(CurrentTheme.Warning)
    local greenBtn = trafficBtn(CurrentTheme.Success)

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -140, 0, 28)
    titleLabel.Position = UDim2.fromOffset(120, 14)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = CurrentTheme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title or "NEON UI"
    titleLabel.Parent = main

    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = CurrentTheme.Accent
    titleStroke.Thickness = 0.6
    titleStroke.Transparency = 0.7
    titleStroke.Parent = titleLabel

    -- Search
    local searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.fromOffset(220, 34)
    searchFrame.Position = UDim2.fromOffset(18, 56)
    searchFrame.BackgroundColor3 = CurrentTheme.Surface
    searchFrame.Parent = main
    createCorner(searchFrame, 9)
    addStroke(searchFrame, CurrentTheme.Accent, 1, 0.75)

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -40, 1, 0)
    searchBox.Position = UDim2.fromOffset(36, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 14
    searchBox.TextColor3 = CurrentTheme.Text
    searchBox.PlaceholderText = "Search sections..."
    searchBox.PlaceholderColor3 = CurrentTheme.TextDim
    searchBox.Text = ""
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchFrame

    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Size = UDim2.fromOffset(16, 16)
    searchIcon.Position = UDim2.fromOffset(12, 9)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = "rbxassetid://2804603863"
    searchIcon.ImageColor3 = CurrentTheme.Accent
    searchIcon.Parent = searchFrame

    -- Sidebar
    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Size = UDim2.fromOffset(230, 460)
    sidebar.Position = UDim2.fromOffset(16, 100)
    sidebar.BackgroundTransparency = 1
    sidebar.BorderSizePixel = 0
    sidebar.ScrollBarThickness = 3
    sidebar.ScrollBarImageColor3 = CurrentTheme.Accent
    sidebar.CanvasSize = UDim2.new(0,0,0,0)
    sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sidebar.Parent = main

    local sideLayout = Instance.new("UIListLayout")
    sideLayout.Padding = UDim.new(0, 5)
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideLayout.Parent = sidebar

    -- Work Area
    local workArea = Instance.new("Frame")
    workArea.Size = UDim2.new(1, -270, 1, -24)
    workArea.Position = UDim2.fromOffset(260, 12)
    workArea.BackgroundColor3 = CurrentTheme.Surface
    workArea.Parent = main
    createCorner(workArea, 14)
    addStroke(workArea, CurrentTheme.Accent, 1, 0.8)

    -- Search filter
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(searchBox.Text)
        for _, child in ipairs(sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.Visible = q == "" or string.find(string.lower(child.Text), q, 1, true)
            end
        end
    end)

    -- Visibility
    local visible = true
    local toggling = false
    function self:Toggle()
        if toggling then return end
        toggling = true
        visible = not visible
        if visible then
            tween(main, {Position = UDim2.fromScale(0.5, 0.5)}, 0.5)
        else
            tween(main, {Position = main.Position + UDim2.fromOffset(0, 900)}, 0.5)
        end
        task.wait(0.55)
        toggling = false
    end

    minBtn.MouseButton1Click:Connect(function() self:Toggle() end)
    if toggleKey then
        UserInputService.InputBegan:Connect(function(i, gpe)
            if not gpe and i.KeyCode == toggleKey then self:Toggle() end
        end)
    end

    function self:GreenButton(cb)
        if self._green then self._green:Disconnect() end
        self._green = greenBtn.MouseButton1Click:Connect(cb)
    end

    -- ========== NOTIFICATIONS ==========
    function self:TempNotify(title, text, icon)
        for _, v in ipairs(screenGui:GetChildren()) do
            if v.Name == "TempNotif" then
                v.Position = v.Position + UDim2.fromOffset(0, 118)
            end
        end

        local n = Instance.new("Frame")
        n.Name = "TempNotif"
        n.AnchorPoint = Vector2.new(1, 0)
        n.Size = UDim2.fromOffset(340, 96)
        n.Position = UDim2.new(1, -24, 0, 24)
        n.BackgroundColor3 = CurrentTheme.Surface
        n.ZIndex = 200
        n.Parent = screenGui
        createCorner(n, 14)
        addGlow(n, CurrentTheme.Glow, 50, 0.5)
        addStroke(n, CurrentTheme.Accent, 1.4, 0.4)

        local t1 = Instance.new("TextLabel")
        t1.Size = UDim2.new(1, -90, 0, 26)
        t1.Position = UDim2.fromOffset(78, 14)
        t1.BackgroundTransparency = 1
        t1.Font = Enum.Font.GothamBold
        t1.TextSize = 17
        t1.TextColor3 = CurrentTheme.Text
        t1.TextXAlignment = Enum.TextXAlignment.Left
        t1.Text = title
        t1.ZIndex = 201
        t1.Parent = n

        local t2 = Instance.new("TextLabel")
        t2.Size = UDim2.new(1, -90, 0, 42)
        t2.Position = UDim2.fromOffset(78, 42)
        t2.BackgroundTransparency = 1
        t2.Font = Enum.Font.Gotham
        t2.TextSize = 13
        t2.TextColor3 = CurrentTheme.TextDim
        t2.TextXAlignment = Enum.TextXAlignment.Left
        t2.TextYAlignment = Enum.TextYAlignment.Top
        t2.TextWrapped = true
        t2.Text = text
        t2.ZIndex = 201
        t2.Parent = n

        if icon then
            local ic = Instance.new("ImageLabel")
            ic.Size = UDim2.fromOffset(48, 48)
            ic.Position = UDim2.fromOffset(16, 24)
            ic.BackgroundTransparency = 1
            ic.Image = icon
            ic.ZIndex = 201
            ic.Parent = n
        end

        Debris:AddItem(n, 4.2)
    end

    local modalOpen = false
    function self:Notify(title, text, btnText, icon, callback)
        if modalOpen then return end
        modalOpen = true

        local overlay = Instance.new("Frame")
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.new(0,0,0)
        overlay.BackgroundTransparency = 0.55
        overlay.ZIndex = 150
        overlay.Parent = main
        createCorner(overlay, 16)

        local modal = Instance.new("Frame")
        modal.AnchorPoint = Vector2.new(0.5, 0.5)
        modal.Size = UDim2.fromOffset(310, 310)
        modal.Position = UDim2.fromScale(0.5, 0.5)
        modal.BackgroundColor3 = CurrentTheme.Surface
        modal.ZIndex = 160
        modal.Parent = main
        createCorner(modal, 16)
        addGlow(modal, CurrentTheme.Glow, 70, 0.4)
        addStroke(modal, CurrentTheme.Accent, 1.5, 0.35)

        if icon then
            local ic = Instance.new("ImageLabel")
            ic.Size = UDim2.fromOffset(72, 72)
            ic.Position = UDim2.new(0.5, -36, 0, 28)
            ic.BackgroundTransparency = 1
            ic.Image = icon
            ic.ZIndex = 161
            ic.Parent = modal
        end

        local t1 = Instance.new("TextLabel")
        t1.Size = UDim2.new(1, -40, 0, 28)
        t1.Position = UDim2.fromOffset(20, 118)
        t1.BackgroundTransparency = 1
        t1.Font = Enum.Font.GothamBold
        t1.TextSize = 20
        t1.TextColor3 = CurrentTheme.Text
        t1.Text = title
        t1.ZIndex = 161
        t1.Parent = modal

        local t2 = Instance.new("TextLabel")
        t2.Size = UDim2.new(1, -40, 0, 60)
        t2.Position = UDim2.fromOffset(20, 152)
        t2.BackgroundTransparency = 1
        t2.Font = Enum.Font.Gotham
        t2.TextSize = 14
        t2.TextColor3 = CurrentTheme.TextDim
        t2.TextWrapped = true
        t2.Text = text
        t2.ZIndex = 161
        t2.Parent = modal

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -40, 0, 42)
        btn.Position = UDim2.fromOffset(20, 240)
        btn.BackgroundColor3 = CurrentTheme.Accent
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 15
        btn.TextColor3 = Color3.fromRGB(10, 10, 15)
        btn.Text = btnText or "OK"
        btn.ZIndex = 161
        btn.Parent = modal
        createCorner(btn, 10)
        addGlow(btn, CurrentTheme.Glow, 30, 0.45)

        btn.MouseButton1Click:Connect(function()
            if callback then callback() end
            overlay:Destroy()
            modal:Destroy()
            modalOpen = false
        end)
    end

    function self:Notify2(title, text, b1, b2, icon, cb1, cb2)
        if modalOpen then return end
        modalOpen = true

        local overlay = Instance.new("Frame")
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.new(0,0,0)
        overlay.BackgroundTransparency = 0.55
        overlay.ZIndex = 150
        overlay.Parent = main
        createCorner(overlay, 16)

        local modal = Instance.new("Frame")
        modal.AnchorPoint = Vector2.new(0.5, 0.5)
        modal.Size = UDim2.fromOffset(310, 340)
        modal.Position = UDim2.fromScale(0.5, 0.5)
        modal.BackgroundColor3 = CurrentTheme.Surface
        modal.ZIndex = 160
        modal.Parent = main
        createCorner(modal, 16)
        addGlow(modal, CurrentTheme.Glow, 70, 0.4)
        addStroke(modal, CurrentTheme.Accent, 1.5, 0.35)

        if icon then
            local ic = Instance.new("ImageLabel")
            ic.Size = UDim2.fromOffset(68, 68)
            ic.Position = UDim2.new(0.5, -34, 0, 24)
            ic.BackgroundTransparency = 1
            ic.Image = icon
            ic.ZIndex = 161
            ic.Parent = modal
        end

        local t1 = Instance.new("TextLabel")
        t1.Size = UDim2.new(1, -40, 0, 26)
        t1.Position = UDim2.fromOffset(20, 110)
        t1.BackgroundTransparency = 1
        t1.Font = Enum.Font.GothamBold
        t1.TextSize = 19
        t1.TextColor3 = CurrentTheme.Text
        t1.Text = title
        t1.ZIndex = 161
        t1.Parent = modal

        local t2 = Instance.new("TextLabel")
        t2.Size = UDim2.new(1, -40, 0, 55)
        t2.Position = UDim2.fromOffset(20, 142)
        t2.BackgroundTransparency = 1
        t2.Font = Enum.Font.Gotham
        t2.TextSize = 13
        t2.TextColor3 = CurrentTheme.TextDim
        t2.TextWrapped = true
        t2.Text = text
        t2.ZIndex = 161
        t2.Parent = modal

        local function makeBtn(y, txt, primary, cb)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -40, 0, 38)
            b.Position = UDim2.fromOffset(20, y)
            b.BackgroundColor3 = primary and CurrentTheme.Accent or CurrentTheme.Surface2
            b.Font = Enum.Font.GothamBold
            b.TextSize = 14
            b.TextColor3 = primary and Color3.fromRGB(10,10,15) or CurrentTheme.Text
            b.Text = txt
            b.ZIndex = 161
            b.Parent = modal
            createCorner(b, 9)
            if primary then addGlow(b, CurrentTheme.Glow, 28, 0.5) end
            b.MouseButton1Click:Connect(function()
                if cb then cb() end
                overlay:Destroy()
                modal:Destroy()
                modalOpen = false
            end)
        end

        makeBtn(225, b1 or "Yes", true, cb1)
        makeBtn(275, b2 or "No", false, cb2)
    end

    -- ========== SECTIONS ==========
    local sections, workAreas = {}, {}

    function self:Divider(text)
        local d = Instance.new("TextLabel")
        d.Size = UDim2.new(1, -8, 0, 24)
        d.BackgroundTransparency = 1
        d.Font = Enum.Font.GothamBold
        d.TextSize = 12
        d.TextColor3 = CurrentTheme.Accent
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.Text = string.upper(text or "")
        d.Parent = sidebar
    end

    function self:Section(name, icon)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -6, 0, 38)
        btn.BackgroundColor3 = CurrentTheme.Accent
        btn.BackgroundTransparency = 1
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 15
        btn.TextColor3 = CurrentTheme.TextDim
        btn.Text = (icon and (icon .. "  ") or "") .. name
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.Parent = sidebar
        createCorner(btn, 9)
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 14)
        pad.Parent = btn

        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, -24, 1, -24)
        content.Position = UDim2.fromOffset(12, 12)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 3
        content.ScrollBarImageColor3 = CurrentTheme.Accent
        content.CanvasSize = UDim2.new(0,0,0,0)
        content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        content.Visible = false
        content.Parent = workArea

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 9)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = content

        table.insert(sections, btn)
        table.insert(workAreas, content)

        local section = {}

        function section:Select()
            for _, s in ipairs(sections) do
                s.BackgroundTransparency = 1
                s.TextColor3 = CurrentTheme.TextDim
            end
            for _, w in ipairs(workAreas) do w.Visible = false end
            btn.BackgroundTransparency = 0.15
            btn.TextColor3 = CurrentTheme.Text
            content.Visible = true
        end

        btn.MouseButton1Click:Connect(function() section:Select() end)

        -- ===== ELEMENTS =====
        function section:Divider(text)
            local d = Instance.new("TextLabel")
            d.Size = UDim2.new(1, -8, 0, 28)
            d.BackgroundTransparency = 1
            d.Font = Enum.Font.GothamBold
            d.TextSize = 16
            d.TextColor3 = CurrentTheme.Text
            d.TextXAlignment = Enum.TextXAlignment.Left
            d.Text = text or ""
            d.Parent = content
        end

        function section:Label(text)
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -8, 0, 26)
            l.BackgroundTransparency = 1
            l.Font = Enum.Font.Gotham
            l.TextSize = 14
            l.TextColor3 = CurrentTheme.TextDim
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.TextWrapped = true
            l.Text = text
            l.Parent = content
            return l
        end

        function section:Paragraph(text)
            local p = Instance.new("TextLabel")
            p.Size = UDim2.new(1, -8, 0, 0)
            p.AutomaticSize = Enum.AutomaticSize.Y
            p.BackgroundTransparency = 1
            p.Font = Enum.Font.Gotham
            p.TextSize = 13
            p.TextColor3 = CurrentTheme.TextDim
            p.TextXAlignment = Enum.TextXAlignment.Left
            p.TextWrapped = true
            p.Text = text
            p.Parent = content
            return p
        end

        function section:Button(text, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -8, 0, 38)
            b.BackgroundColor3 = CurrentTheme.Surface2
            b.Font = Enum.Font.GothamMedium
            b.TextSize = 14
            b.TextColor3 = CurrentTheme.Text
            b.Text = text
            b.AutoButtonColor = false
            b.Parent = content
            createCorner(b, 9)
            addStroke(b, CurrentTheme.Accent, 1.1, 0.55)

            b.MouseEnter:Connect(function()
                tween(b, {BackgroundColor3 = CurrentTheme.Accent}, 0.2)
                b.TextColor3 = Color3.fromRGB(10,10,15)
            end)
            b.MouseLeave:Connect(function()
                tween(b, {BackgroundColor3 = CurrentTheme.Surface2}, 0.2)
                b.TextColor3 = CurrentTheme.Text
            end)
            b.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            return b
        end

        function section:Switch(text, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 38)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -70, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = CurrentTheme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = frame

            local track = Instance.new("TextButton")
            track.Size = UDim2.fromOffset(52, 28)
            track.Position = UDim2.new(1, -52, 0.5, -14)
            track.BackgroundColor3 = default and CurrentTheme.Accent or CurrentTheme.Surface2
            track.Text = ""
            track.AutoButtonColor = false
            track.Parent = frame
            createCorner(track, 20)
            if default then addGlow(track, CurrentTheme.Glow, 20, 0.5) end

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(22, 22)
            knob.Position = default and UDim2.fromOffset(27, 3) or UDim2.fromOffset(3, 3)
            knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
            knob.Parent = track
            createCorner(knob, 20)

            local state = default
            local function toggle()
                state = not state
                tween(knob, {Position = state and UDim2.fromOffset(27, 3) or UDim2.fromOffset(3, 3)}, 0.18)
                tween(track, {BackgroundColor3 = state and CurrentTheme.Accent or CurrentTheme.Surface2}, 0.18)
                if callback then callback(state) end
            end
            track.MouseButton1Click:Connect(toggle)
            return {Set = function(_, v) if state ~= v then toggle() end end, Get = function() return state end}
        end

        function section:TextField(text, placeholder, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 38)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.38, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = CurrentTheme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = frame

            local boxF = Instance.new("Frame")
            boxF.Size = UDim2.new(0.6, 0, 0, 32)
            boxF.Position = UDim2.new(0.4, 0, 0.5, -16)
            boxF.BackgroundColor3 = CurrentTheme.Surface2
            boxF.Parent = frame
            createCorner(boxF, 8)
            addStroke(boxF, CurrentTheme.Accent, 1, 0.7)

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -14, 1, 0)
            box.Position = UDim2.fromOffset(7, 0)
            box.BackgroundTransparency = 1
            box.Font = Enum.Font.Gotham
            box.TextSize = 13
            box.TextColor3 = CurrentTheme.Text
            box.PlaceholderText = placeholder or ""
            box.PlaceholderColor3 = CurrentTheme.TextDim
            box.Text = ""
            box.ClearTextOnFocus = false
            box.Parent = boxF

            if callback then
                box.FocusLost:Connect(function() callback(box.Text) end)
            end
            return box
        end

        function section:Slider(text, min, max, default, callback)
            min, max, default = min or 0, max or 100, default or min
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 52)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = CurrentTheme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text .. "  •  " .. tostring(default)
            label.Parent = frame

            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, 0, 0, 6)
            track.Position = UDim2.fromOffset(0, 34)
            track.BackgroundColor3 = CurrentTheme.Surface2
            track.Parent = frame
            createCorner(track, 10)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            fill.BackgroundColor3 = CurrentTheme.Accent
            fill.Parent = track
            createCorner(fill, 10)
            addGlow(fill, CurrentTheme.Glow, 16, 0.55)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(16, 16)
            knob.Position = UDim2.new((default-min)/(max-min), -8, 0.5, -8)
            knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
            knob.Parent = track
            createCorner(knob, 20)
            addGlow(knob, CurrentTheme.Glow, 14, 0.4)

            local value = default
            local sliding = false

            local function update(input)
                local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * rel + 0.5)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, -8, 0.5, -8)
                label.Text = text .. "  •  " .. tostring(value)
                if callback then callback(value) end
            end

            track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    update(i)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    update(i)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            return {
                Set = function(_, v)
                    value = math.clamp(v, min, max)
                    local rel = (value - min) / (max - min)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    knob.Position = UDim2.new(rel, -8, 0.5, -8)
                    label.Text = text .. "  •  " .. tostring(value)
                end,
                Get = function() return value end
            }
        end

        function section:Dropdown(text, options, default, callback)
            options = options or {}
            local selected = default or options[1] or "None"

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 38)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.38, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = CurrentTheme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = frame

            local drop = Instance.new("TextButton")
            drop.Size = UDim2.new(0.6, 0, 0, 32)
            drop.Position = UDim2.new(0.4, 0, 0.5, -16)
            drop.BackgroundColor3 = CurrentTheme.Surface2
            drop.Font = Enum.Font.Gotham
            drop.TextSize = 13
            drop.TextColor3 = CurrentTheme.Text
            drop.Text = selected .. "  ▼"
            drop.AutoButtonColor = false
            drop.Parent = frame
            createCorner(drop, 8)
            addStroke(drop, CurrentTheme.Accent, 1, 0.7)

            local open = false
            local list

            drop.MouseButton1Click:Connect(function()
                if open then
                    if list then list:Destroy() end
                    open = false
                    return
                end
                open = true
                list = Instance.new("Frame")
                list.Size = UDim2.new(0.6, 0, 0, math.min(#options * 32, 160))
                list.Position = UDim2.new(0.4, 0, 1, 6)
                list.BackgroundColor3 = CurrentTheme.Surface
                list.ZIndex = 50
                list.Parent = frame
                createCorner(list, 8)
                addStroke(list, CurrentTheme.Accent, 1.2, 0.4)
                addGlow(list, CurrentTheme.Glow, 30, 0.55)

                local lLayout = Instance.new("UIListLayout")
                lLayout.Parent = list

                for _, opt in ipairs(options) do
                    local o = Instance.new("TextButton")
                    o.Size = UDim2.new(1, 0, 0, 32)
                    o.BackgroundTransparency = 1
                    o.Font = Enum.Font.Gotham
                    o.TextSize = 13
                    o.TextColor3 = CurrentTheme.Text
                    o.Text = opt
                    o.ZIndex = 51
                    o.Parent = list
                    o.MouseButton1Click:Connect(function()
                        selected = opt
                        drop.Text = opt .. "  ▼"
                        if callback then callback(opt) end
                        list:Destroy()
                        open = false
                    end)
                end
            end)

            return {Set = function(_, v) selected = v; drop.Text = v .. "  ▼" end, Get = function() return selected end}
        end

        function section:Keybind(text, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 38)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = CurrentTheme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = frame

            local keyBtn = Instance.new("TextButton")
            keyBtn.Size = UDim2.new(0.46, 0, 0, 30)
            keyBtn.Position = UDim2.new(0.54, 0, 0.5, -15)
            keyBtn.BackgroundColor3 = CurrentTheme.Surface2
            keyBtn.Font = Enum.Font.GothamBold
            keyBtn.TextSize = 12
            keyBtn.TextColor3 = CurrentTheme.Accent
            keyBtn.Text = default and default.Name or "None"
            keyBtn.AutoButtonColor = false
            keyBtn.Parent = frame
            createCorner(keyBtn, 8)
            addStroke(keyBtn, CurrentTheme.Accent, 1, 0.6)

            local listening = false
            local current = default

            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if listening and not gpe and input.UserInputType == Enum.UserInputType.Keyboard then
                    current = input.KeyCode
                    keyBtn.Text = current.Name
                    listening = false
                    if callback then callback(current) end
                end
            end)

            return {Get = function() return current end, Set = function(_, k) current = k; keyBtn.Text = k.Name end}
        end

        function section:ColorPicker(text, default, callback)
            default = default or CurrentTheme.Accent
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 38)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.55, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = CurrentTheme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = frame

            local preview = Instance.new("TextButton")
            preview.Size = UDim2.fromOffset(70, 28)
            preview.Position = UDim2.new(1, -70, 0.5, -14)
            preview.BackgroundColor3 = default
            preview.Text = ""
            preview.AutoButtonColor = false
            preview.Parent = frame
            createCorner(preview, 7)
            addGlow(preview, default, 18, 0.45)

            local colors = {
                Color3.fromRGB(0, 255, 170),
                Color3.fromRGB(180, 90, 255),
                Color3.fromRGB(0, 220, 255),
                Color3.fromRGB(255, 60, 90),
                Color3.fromRGB(255, 190, 50),
                Color3.fromRGB(255, 255, 255),
                Color3.fromRGB(100, 100, 255),
                Color3.fromRGB(255, 100, 200),
            }
            local idx = 1
            preview.MouseButton1Click:Connect(function()
                idx = idx % #colors + 1
                preview.BackgroundColor3 = colors[idx]
                if callback then callback(colors[idx]) end
            end)

            return {Get = function() return preview.BackgroundColor3 end, Set = function(_, c) preview.BackgroundColor3 = c end}
        end

        function section:Checkbox(text, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 32)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local box = Instance.new("TextButton")
            box.Size = UDim2.fromOffset(22, 22)
            box.Position = UDim2.fromOffset(0, 5)
            box.BackgroundColor3 = default and CurrentTheme.Accent or CurrentTheme.Surface2
            box.Text = default and "✓" or ""
            box.Font = Enum.Font.GothamBold
            box.TextSize = 15
            box.TextColor3 = Color3.fromRGB(10,10,15)
            box.AutoButtonColor = false
            box.Parent = frame
            createCorner(box, 6)
            if default then addGlow(box, CurrentTheme.Glow, 14, 0.5) end

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -32, 1, 0)
            label.Position = UDim2.fromOffset(30, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = CurrentTheme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = frame

            local state = default
            box.MouseButton1Click:Connect(function()
                state = not state
                box.BackgroundColor3 = state and CurrentTheme.Accent or CurrentTheme.Surface2
                box.Text = state and "✓" or ""
                if callback then callback(state) end
            end)

            return {Get = function() return state end, Set = function(_, v)
                state = v
                box.BackgroundColor3 = state and CurrentTheme.Accent or CurrentTheme.Surface2
                box.Text = state and "✓" or ""
            end}
        end

        function section:Progress(text, value)
            value = math.clamp(value or 0, 0, 1)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 42)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 18)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = 13
            label.TextColor3 = CurrentTheme.TextDim
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text .. "  " .. math.floor(value * 100) .. "%"
            label.Parent = frame

            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, 0, 0, 8)
            track.Position = UDim2.fromOffset(0, 26)
            track.BackgroundColor3 = CurrentTheme.Surface2
            track.Parent = frame
            createCorner(track, 10)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(value, 0, 1, 0)
            fill.BackgroundColor3 = CurrentTheme.Accent
            fill.Parent = track
            createCorner(fill, 10)
            addGlow(fill, CurrentTheme.Glow, 14, 0.5)

            return {
                Set = function(_, v)
                    v = math.clamp(v, 0, 1)
                    fill.Size = UDim2.new(v, 0, 1, 0)
                    label.Text = text .. "  " .. math.floor(v * 100) .. "%"
                end
            }
        end

        function section:Stepper(text, min, max, default, callback)
            min, max, default = min or 0, max or 10, default or min
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -8, 0, 38)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.45, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = CurrentTheme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = frame

            local value = default
            local valLabel = Instance.new("TextLabel")
            valLabel.Size = UDim2.fromOffset(50, 28)
            valLabel.Position = UDim2.new(1, -120, 0.5, -14)
            valLabel.BackgroundColor3 = CurrentTheme.Surface2
            valLabel.Font = Enum.Font.GothamBold
            valLabel.TextSize = 14
            valLabel.TextColor3 = CurrentTheme.Accent
            valLabel.Text = tostring(value)
            valLabel.Parent = frame
            createCorner(valLabel, 7)

            local function makeStep(x, txt, delta)
                local b = Instance.new("TextButton")
                b.Size = UDim2.fromOffset(28, 28)
                b.Position = UDim2.new(1, x, 0.5, -14)
                b.BackgroundColor3 = CurrentTheme.Surface2
                b.Font = Enum.Font.GothamBold
                b.TextSize = 16
                b.TextColor3 = CurrentTheme.Text
                b.Text = txt
                b.AutoButtonColor = false
                b.Parent = frame
                createCorner(b, 7)
                b.MouseButton1Click:Connect(function()
                    value = math.clamp(value + delta, min, max)
                    valLabel.Text = tostring(value)
                    if callback then callback(value) end
                end)
            end
            makeStep(-90, "−", -1)
            makeStep(-30, "+", 1)

            return {Get = function() return value end, Set = function(_, v) value = math.clamp(v, min, max); valLabel.Text = tostring(value) end}
        end

        if #sections == 1 then section:Select() end
        return section
    end

    -- Theme + Rainbow
    function self:SetTheme(name)
        if Themes[name] then
            CurrentTheme = Themes[name]
            -- Note: full live theme reload would require rebuilding, so this is for new elements
        end
    end

    function self:ToggleRainbow(state)
        RainbowMode = state
    end

    -- Entrance
    tween(main, {Position = UDim2.fromScale(0.5, 0.5)}, 0.75)

    self.Main = main
    self.ScreenGui = screenGui
    return self
end

return Library
