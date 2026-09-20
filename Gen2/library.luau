--[[
    Apple UI Library - Remake (Gen2)
    Modern, feature-rich rewrite of the original Apple-UI
]]

local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local CoreGui = game:GetService("CoreGui")

-- Theme (easy to customize)
local Theme = {
    Background = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.12,
    Accent = Color3.fromRGB(21, 103, 251),
    Text = Color3.fromRGB(30, 30, 30),
    TextSecondary = Color3.fromRGB(95, 95, 95),
    Border = Color3.fromRGB(210, 210, 210),
    Success = Color3.fromRGB(39, 200, 63),
    Warning = Color3.fromRGB(255, 189, 46),
    Danger = Color3.fromRGB(254, 94, 86),
    Corner = UDim.new(0, 12),
    Font = Enum.Font.Gotham,
    FontMedium = Enum.Font.GothamMedium,
}

local function tween(obj, props, duration, style, direction)
    style = style or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.InOut
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.4, style, direction), props)
    t:Play()
    return t
end

local function protect(gui)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
    end
end

local function getParent()
    if gethui then return gethui() end
    return CoreGui
end

function Library.new(title, showSplash, toggleKey, destroyPrevious)
    local self = setmetatable({}, Library)
    
    -- Destroy previous
    local parent = getParent()
    if destroyPrevious then
        local existing = parent:FindFirstChild("AppleUI_Gen2")
        if existing then
            existing:Destroy()
        end
    end

    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AppleUI_Gen2"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    protect(screenGui)
    screenGui.Parent = parent

    -- Splash
    if showSplash then
        local splash = Instance.new("Frame")
        splash.Name = "Splash"
        splash.AnchorPoint = Vector2.new(0.5, 0.5)
        splash.Size = UDim2.fromOffset(320, 320)
        splash.Position = UDim2.new(0.5, 0, 2, 0)
        splash.BackgroundColor3 = Theme.Background
        splash.BackgroundTransparency = 0.3
        splash.ZIndex = 50
        splash.Parent = screenGui
        
        local sc = Instance.new("UICorner")
        sc.CornerRadius = UDim.new(0, 20)
        sc.Parent = splash
        
        local icon = Instance.new("ImageLabel")
        icon.AnchorPoint = Vector2.new(0.5, 0.5)
        icon.Size = UDim2.fromOffset(160, 160)
        icon.Position = UDim2.fromScale(0.5, 0.5)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxassetid://12621719043"
        icon.ZIndex = 51
        icon.Parent = splash
        
        tween(splash, {Position = UDim2.fromScale(0.5, 0.5)}, 0.8)
        task.delay(1.8, function()
            tween(splash, {Position = UDim2.new(0.5, 0, 2, 0)}, 0.7)
            Debris:AddItem(splash, 0.8)
        end)
    end

    -- Main Window
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Size = UDim2.fromOffset(740, 560)
    main.Position = UDim2.new(0.5, 0, 2, 0)
    main.BackgroundColor3 = Theme.Background
    main.BackgroundTransparency = Theme.BackgroundTransparency
    main.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = Theme.Corner
    mainCorner.Parent = main

    -- Dragging
    local dragging, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
    local buttons = Instance.new("Frame")
    buttons.Size = UDim2.fromOffset(90, 40)
    buttons.Position = UDim2.fromOffset(14, 12)
    buttons.BackgroundTransparency = 1
    buttons.Parent = main
    
    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.Padding = UDim.new(0, 8)
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLayout.Parent = buttons

    local function makeTraffic(color, callback)
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromOffset(14, 14)
        b.BackgroundColor3 = color
        b.Text = ""
        b.AutoButtonColor = false
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1, 0)
        c.Parent = b
        b.Parent = buttons
        if callback then b.MouseButton1Click:Connect(callback) end
        return b
    end

    local closeBtn = makeTraffic(Theme.Danger, function()
        screenGui:Destroy()
    end)
    local minimizeBtn = makeTraffic(Theme.Warning)
    local greenBtn = makeTraffic(Theme.Success)

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -120, 0, 28)
    titleLabel.Position = UDim2.fromOffset(110, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Theme.FontMedium
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title or "Apple UI"
    titleLabel.Parent = main

    -- Search
    local searchFrame = Instance.new("Frame")
    searchFrame.Size = UDim2.fromOffset(210, 32)
    searchFrame.Position = UDim2.fromOffset(18, 58)
    searchFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    searchFrame.Parent = main
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 8)
    sc.Parent = searchFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -36, 1, 0)
    searchBox.Position = UDim2.fromOffset(32, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Theme.Font
    searchBox.TextSize = 15
    searchBox.TextColor3 = Theme.Text
    searchBox.PlaceholderText = "Search..."
    searchBox.PlaceholderColor3 = Theme.TextSecondary
    searchBox.Text = ""
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchFrame

    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Size = UDim2.fromOffset(18, 18)
    searchIcon.Position = UDim2.fromOffset(8, 7)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = "rbxassetid://2804603863"
    searchIcon.ImageColor3 = Theme.TextSecondary
    searchIcon.Parent = searchFrame

    -- Sidebar
    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.fromOffset(230, 450)
    sidebar.Position = UDim2.fromOffset(14, 100)
    sidebar.BackgroundTransparency = 1
    sidebar.BorderSizePixel = 0
    sidebar.ScrollBarThickness = 3
    sidebar.ScrollBarImageColor3 = Theme.Accent
    sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sidebar.Parent = main

    local sideLayout = Instance.new("UIListLayout")
    sideLayout.Padding = UDim.new(0, 4)
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sideLayout.Parent = sidebar

    -- Work area
    local workArea = Instance.new("Frame")
    workArea.Name = "WorkArea"
    workArea.Size = UDim2.new(1, -260, 1, -20)
    workArea.Position = UDim2.fromOffset(250, 10)
    workArea.BackgroundColor3 = Theme.Background
    workArea.BackgroundTransparency = 0.3
    workArea.Parent = main
    local wc = Instance.new("UICorner")
    wc.CornerRadius = Theme.Corner
    wc.Parent = workArea

    -- Search logic
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = string.lower(searchBox.Text)
        for _, child in ipairs(sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.Visible = query == "" or string.find(string.lower(child.Text), query, 1, true) ~= nil
            end
        end
    end)

    -- Visibility toggle
    local visible = true
    local toggling = false
    function self:Toggle()
        if toggling then return end
        toggling = true
        visible = not visible
        if visible then
            tween(main, {Position = UDim2.fromScale(0.5, 0.5)}, 0.45)
        else
            tween(main, {Position = main.Position + UDim2.fromOffset(0, 800)}, 0.45)
        end
        task.wait(0.5)
        toggling = false
    end

    minimizeBtn.MouseButton1Click:Connect(function()
        self:Toggle()
    end)

    if toggleKey then
        UserInputService.InputBegan:Connect(function(input, gpe)
            if not gpe and input.KeyCode == toggleKey then
                self:Toggle()
            end
        end)
    end

    -- Green button
    function self:GreenButton(callback)
        if self._greenConn then self._greenConn:Disconnect() end
        self._greenConn = greenBtn.MouseButton1Click:Connect(callback)
    end

    -- Notifications
    function self:TempNotify(title, text, icon)
        for _, v in ipairs(screenGui:GetChildren()) do
            if v.Name == "TempNotif" then
                v.Position = v.Position + UDim2.fromOffset(0, 130)
            end
        end

        local n = Instance.new("Frame")
        n.Name = "TempNotif"
        n.AnchorPoint = Vector2.new(1, 0)
        n.Size = UDim2.fromOffset(360, 100)
        n.Position = UDim2.new(1, -20, 0, 20)
        n.BackgroundColor3 = Theme.Background
        n.BackgroundTransparency = 0.1
        n.ZIndex = 100
        n.Parent = screenGui
        local nc = Instance.new("UICorner")
        nc.CornerRadius = Theme.Corner
        nc.Parent = n

        local t1 = Instance.new("TextLabel")
        t1.Size = UDim2.new(1, -90, 0, 28)
        t1.Position = UDim2.fromOffset(80, 12)
        t1.BackgroundTransparency = 1
        t1.Font = Theme.FontMedium
        t1.TextSize = 18
        t1.TextColor3 = Theme.Text
        t1.TextXAlignment = Enum.TextXAlignment.Left
        t1.Text = title
        t1.ZIndex = 101
        t1.Parent = n

        local t2 = Instance.new("TextLabel")
        t2.Size = UDim2.new(1, -90, 0, 50)
        t2.Position = UDim2.fromOffset(80, 40)
        t2.BackgroundTransparency = 1
        t2.Font = Theme.Font
        t2.TextSize = 14
        t2.TextColor3 = Theme.TextSecondary
        t2.TextXAlignment = Enum.TextXAlignment.Left
        t2.TextYAlignment = Enum.TextYAlignment.Top
        t2.TextWrapped = true
        t2.Text = text
        t2.ZIndex = 101
        t2.Parent = n

        if icon then
            local ic = Instance.new("ImageLabel")
            ic.Size = UDim2.fromOffset(54, 54)
            ic.Position = UDim2.fromOffset(14, 23)
            ic.BackgroundTransparency = 1
            ic.Image = icon
            ic.ZIndex = 101
            ic.Parent = n
        end

        Debris:AddItem(n, 4.5)
    end

    local modalOpen = false
    function self:Notify(title, text, buttonText, icon, callback)
        if modalOpen then return end
        modalOpen = true

        local overlay = Instance.new("Frame")
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.new(0, 0, 0)
        overlay.BackgroundTransparency = 0.55
        overlay.ZIndex = 80
        overlay.Parent = main
        local oc = Instance.new("UICorner")
        oc.CornerRadius = Theme.Corner
        oc.Parent = overlay

        local modal = Instance.new("Frame")
        modal.AnchorPoint = Vector2.new(0.5, 0.5)
        modal.Size = UDim2.fromOffset(300, 320)
        modal.Position = UDim2.fromScale(0.5, 0.5)
        modal.BackgroundColor3 = Theme.Background
        modal.ZIndex = 90
        modal.Parent = main
        local mc = Instance.new("UICorner")
        mc.CornerRadius = Theme.Corner
        mc.Parent = modal

        if icon then
            local ic = Instance.new("ImageLabel")
            ic.Size = UDim2.fromOffset(80, 80)
            ic.Position = UDim2.new(0.5, -40, 0, 30)
            ic.BackgroundTransparency = 1
            ic.Image = icon
            ic.ZIndex = 91
            ic.Parent = modal
        end

        local t1 = Instance.new("TextLabel")
        t1.Size = UDim2.new(1, -40, 0, 30)
        t1.Position = UDim2.fromOffset(20, 130)
        t1.BackgroundTransparency = 1
        t1.Font = Theme.FontMedium
        t1.TextSize = 22
        t1.TextColor3 = Theme.Text
        t1.Text = title
        t1.ZIndex = 91
        t1.Parent = modal

        local t2 = Instance.new("TextLabel")
        t2.Size = UDim2.new(1, -40, 0, 70)
        t2.Position = UDim2.fromOffset(20, 165)
        t2.BackgroundTransparency = 1
        t2.Font = Theme.Font
        t2.TextSize = 15
        t2.TextColor3 = Theme.TextSecondary
        t2.TextWrapped = true
        t2.Text = text
        t2.ZIndex = 91
        t2.Parent = modal

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -40, 0, 42)
        btn.Position = UDim2.fromOffset(20, 255)
        btn.BackgroundColor3 = Theme.Accent
        btn.Font = Theme.Font
        btn.TextSize = 17
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Text = buttonText or "OK"
        btn.ZIndex = 91
        btn.Parent = modal
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 8)
        bc.Parent = btn

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
        overlay.BackgroundColor3 = Color3.new(0, 0, 0)
        overlay.BackgroundTransparency = 0.55
        overlay.ZIndex = 80
        overlay.Parent = main
        local oc = Instance.new("UICorner")
        oc.CornerRadius = Theme.Corner
        oc.Parent = overlay

        local modal = Instance.new("Frame")
        modal.AnchorPoint = Vector2.new(0.5, 0.5)
        modal.Size = UDim2.fromOffset(300, 340)
        modal.Position = UDim2.fromScale(0.5, 0.5)
        modal.BackgroundColor3 = Theme.Background
        modal.ZIndex = 90
        modal.Parent = main
        local mc = Instance.new("UICorner")
        mc.CornerRadius = Theme.Corner
        mc.Parent = modal

        if icon then
            local ic = Instance.new("ImageLabel")
            ic.Size = UDim2.fromOffset(80, 80)
            ic.Position = UDim2.new(0.5, -40, 0, 24)
            ic.BackgroundTransparency = 1
            ic.Image = icon
            ic.ZIndex = 91
            ic.Parent = modal
        end

        local t1 = Instance.new("TextLabel")
        t1.Size = UDim2.new(1, -40, 0, 28)
        t1.Position = UDim2.fromOffset(20, 120)
        t1.BackgroundTransparency = 1
        t1.Font = Theme.FontMedium
        t1.TextSize = 20
        t1.TextColor3 = Theme.Text
        t1.Text = title
        t1.ZIndex = 91
        t1.Parent = modal

        local t2 = Instance.new("TextLabel")
        t2.Size = UDim2.new(1, -40, 0, 60)
        t2.Position = UDim2.fromOffset(20, 152)
        t2.BackgroundTransparency = 1
        t2.Font = Theme.Font
        t2.TextSize = 14
        t2.TextColor3 = Theme.TextSecondary
        t2.TextWrapped = true
        t2.Text = text
        t2.ZIndex = 91
        t2.Parent = modal

        local function makeBtn(y, text, primary, cb)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -40, 0, 38)
            btn.Position = UDim2.fromOffset(20, y)
            btn.BackgroundColor3 = primary and Theme.Accent or Color3.fromRGB(240, 240, 240)
            btn.Font = Theme.Font
            btn.TextSize = 16
            btn.TextColor3 = primary and Color3.new(1,1,1) or Theme.Text
            btn.Text = text
            btn.ZIndex = 91
            btn.Parent = modal
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 8)
            bc.Parent = btn
            btn.MouseButton1Click:Connect(function()
                if cb then cb() end
                overlay:Destroy()
                modal:Destroy()
                modalOpen = false
            end)
        end

        makeBtn(230, b1 or "Yes", true, cb1)
        makeBtn(278, b2 or "No", false, cb2)
    end

    -- Divider in sidebar
    function self:Divider(text)
        local d = Instance.new("TextLabel")
        d.Size = UDim2.new(1, -10, 0, 26)
        d.BackgroundTransparency = 1
        d.Font = Theme.Font
        d.TextSize = 14
        d.TextColor3 = Theme.TextSecondary
        d.TextXAlignment = Enum.TextXAlignment.Left
        d.Text = text or ""
        d.Parent = sidebar
    end

    -- Sections / Tabs
    local sections = {}
    local workAreas = {}
    local currentSection

    function self:Section(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, 36)
        btn.BackgroundColor3 = Theme.Accent
        btn.BackgroundTransparency = 1
        btn.Font = Theme.Font
        btn.TextSize = 16
        btn.TextColor3 = Theme.Text
        btn.Text = name
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.Parent = sidebar
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 8)
        bc.Parent = btn
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 12)
        pad.Parent = btn

        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, -20, 1, -20)
        content.Position = UDim2.fromOffset(10, 10)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 3
        content.ScrollBarImageColor3 = Theme.Accent
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        content.Visible = false
        content.Parent = workArea

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 8)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = content

        table.insert(sections, btn)
        table.insert(workAreas, content)

        local section = {}

        function section:Select()
            for _, s in ipairs(sections) do
                s.BackgroundTransparency = 1
                s.TextColor3 = Theme.Text
            end
            for _, w in ipairs(workAreas) do
                w.Visible = false
            end
            btn.BackgroundTransparency = 0
            btn.TextColor3 = Color3.new(1, 1, 1)
            content.Visible = true
            currentSection = section
        end

        btn.MouseButton1Click:Connect(function()
            section:Select()
        end)

        -- Elements
        function section:Divider(text)
            local d = Instance.new("TextLabel")
            d.Size = UDim2.new(1, -10, 0, 32)
            d.BackgroundTransparency = 1
            d.Font = Theme.FontMedium
            d.TextSize = 18
            d.TextColor3 = Theme.Text
            d.TextXAlignment = Enum.TextXAlignment.Left
            d.Text = text or ""
            d.Parent = content
        end

        function section:Label(text)
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -10, 0, 28)
            l.BackgroundTransparency = 1
            l.Font = Theme.Font
            l.TextSize = 15
            l.TextColor3 = Theme.TextSecondary
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.TextWrapped = true
            l.Text = text
            l.Parent = content
            return l
        end

        function section:Paragraph(text)
            local p = Instance.new("TextLabel")
            p.Size = UDim2.new(1, -10, 0, 0)
            p.AutomaticSize = Enum.AutomaticSize.Y
            p.BackgroundTransparency = 1
            p.Font = Theme.Font
            p.TextSize = 14
            p.TextColor3 = Theme.TextSecondary
            p.TextXAlignment = Enum.TextXAlignment.Left
            p.TextWrapped = true
            p.Text = text
            p.Parent = content
            return p
        end

        function section:Button(text, callback)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -10, 0, 36)
            b.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            b.Font = Theme.Font
            b.TextSize = 15
            b.TextColor3 = Theme.Accent
            b.Text = text
            b.AutoButtonColor = false
            b.Parent = content
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 8)
            c.Parent = b
            local stroke = Instance.new("UIStroke")
            stroke.Color = Theme.Accent
            stroke.Thickness = 1
            stroke.Parent = b

            b.MouseButton1Click:Connect(function()
                tween(b, {TextSize = 13}, 0.08)
                task.wait(0.08)
                tween(b, {TextSize = 15}, 0.08)
                if callback then callback() end
            end)
            return b
        end

        function section:Switch(text, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 36)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -80, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Theme.Font
            label.TextSize = 15
            label.TextColor3 = Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = frame

            local track = Instance.new("TextButton")
            track.Size = UDim2.fromOffset(52, 28)
            track.Position = UDim2.new(1, -52, 0.5, -14)
            track.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(200, 200, 200)
            track.Text = ""
            track.AutoButtonColor = false
            track.Parent = frame
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(24, 24)
            knob.Position = default and UDim2.fromOffset(26, 2) or UDim2.fromOffset(2, 2)
            knob.BackgroundColor3 = Color3.new(1, 1, 1)
            knob.Parent = track
            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(1, 0)
            kc.Parent = knob

            local state = default
            local function toggle()
                state = not state
                tween(knob, {Position = state and UDim2.fromOffset(26, 2) or UDim2.fromOffset(2, 2)}, 0.15)
                tween(track, {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(200, 200, 200)}, 0.15)
                if callback then callback(state) end
            end
            track.MouseButton1Click:Connect(toggle)
            return {Set = function(_, v) if state ~= v then toggle() end end, Get = function() return state end}
        end

        function section:TextField(text, placeholder, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 36)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.4, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Theme.Font
            label.TextSize = 15
            label.TextColor3 = Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = frame

            local boxFrame = Instance.new("Frame")
            boxFrame.Size = UDim2.new(0.58, 0, 0, 32)
            boxFrame.Position = UDim2.new(0.42, 0, 0.5, -16)
            boxFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
            boxFrame.Parent = frame
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 8)
            bc.Parent = boxFrame

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -16, 1, 0)
            box.Position = UDim2.fromOffset(8, 0)
            box.BackgroundTransparency = 1
            box.Font = Theme.Font
            box.TextSize = 14
            box.TextColor3 = Theme.Text
            box.PlaceholderText = placeholder or ""
            box.PlaceholderColor3 = Theme.TextSecondary
            box.Text = ""
            box.ClearTextOnFocus = false
            box.Parent = boxFrame

            if callback then
                box.FocusLost:Connect(function()
                    callback(box.Text)
                end)
            end
            return box
        end

        function section:Slider(text, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = default or min

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 50)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.BackgroundTransparency = 1
            label.Font = Theme.Font
            label.TextSize = 15
            label.TextColor3 = Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text .. ": " .. tostring(default)
            label.Parent = frame

            local track = Instance.new("Frame")
            track.Size = UDim2.new(1, 0, 0, 6)
            track.Position = UDim2.fromOffset(0, 32)
            track.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
            track.Parent = frame
            local tc = Instance.new("UICorner")
            tc.CornerRadius = UDim.new(1, 0)
            tc.Parent = track

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Theme.Accent
            fill.Parent = track
            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(1, 0)
            fc.Parent = fill

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(16, 16)
            knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
            knob.BackgroundColor3 = Theme.Accent
            knob.Parent = track
            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(1, 0)
            kc.Parent = knob

            local value = default
            local sliding = false

            local function update(input)
                local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * rel + 0.5)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, -8, 0.5, -8)
                label.Text = text .. ": " .. tostring(value)
                if callback then callback(value) end
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    update(input)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)

            return {Set = function(_, v)
                value = math.clamp(v, min, max)
                local rel = (value - min) / (max - min)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, -8, 0.5, -8)
                label.Text = text .. ": " .. tostring(value)
            end, Get = function() return value end}
        end

        function section:Dropdown(text, options, default, callback)
            options = options or {}
            local selected = default or options[1] or "None"

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 36)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.4, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Theme.Font
            label.TextSize = 15
            label.TextColor3 = Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = frame

            local drop = Instance.new("TextButton")
            drop.Size = UDim2.new(0.58, 0, 0, 32)
            drop.Position = UDim2.new(0.42, 0, 0.5, -16)
            drop.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
            drop.Font = Theme.Font
            drop.TextSize = 14
            drop.TextColor3 = Theme.Text
            drop.Text = selected
            drop.AutoButtonColor = false
            drop.Parent = frame
            local dc = Instance.new("UICorner")
            dc.CornerRadius = UDim.new(0, 8)
            dc.Parent = drop

            local open = false
            local listFrame

            drop.MouseButton1Click:Connect(function()
                if open then
                    if listFrame then listFrame:Destroy() end
                    open = false
                    return
                end
                open = true
                listFrame = Instance.new("Frame")
                listFrame.Size = UDim2.new(0.58, 0, 0, math.min(#options * 32, 160))
                listFrame.Position = UDim2.new(0.42, 0, 1, 4)
                listFrame.BackgroundColor3 = Theme.Background
                listFrame.ZIndex = 50
                listFrame.Parent = frame
                local lc = Instance.new("UICorner")
                lc.CornerRadius = UDim.new(0, 8)
                lc.Parent = listFrame
                local stroke = Instance.new("UIStroke")
                stroke.Color = Theme.Border
                stroke.Parent = listFrame

                local listLayout = Instance.new("UIListLayout")
                listLayout.Parent = listFrame

                for _, opt in ipairs(options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(1, 0, 0, 32)
                    optBtn.BackgroundTransparency = 1
                    optBtn.Font = Theme.Font
                    optBtn.TextSize = 14
                    optBtn.TextColor3 = Theme.Text
                    optBtn.Text = opt
                    optBtn.ZIndex = 51
                    optBtn.Parent = listFrame
                    optBtn.MouseButton1Click:Connect(function()
                        selected = opt
                        drop.Text = opt
                        if callback then callback(opt) end
                        listFrame:Destroy()
                        open = false
                    end)
                end
            end)

            return {Set = function(_, v) selected = v; drop.Text = v end, Get = function() return selected end}
        end

        function section:Keybind(text, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 36)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Theme.Font
            label.TextSize = 15
            label.TextColor3 = Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = frame

            local keyBtn = Instance.new("TextButton")
            keyBtn.Size = UDim2.new(0.45, 0, 0, 30)
            keyBtn.Position = UDim2.new(0.55, 0, 0.5, -15)
            keyBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
            keyBtn.Font = Theme.Font
            keyBtn.TextSize = 13
            keyBtn.TextColor3 = Theme.Text
            keyBtn.Text = default and default.Name or "None"
            keyBtn.AutoButtonColor = false
            keyBtn.Parent = frame
            local kc = Instance.new("UICorner")
            kc.CornerRadius = UDim.new(0, 8)
            kc.Parent = keyBtn

            local listening = false
            local current = default

            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
            end)

            local conn
            conn = UserInputService.InputBegan:Connect(function(input, gpe)
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
            default = default or Color3.fromRGB(21, 103, 251)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 36)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.6, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Font = Theme.Font
            label.TextSize = 15
            label.TextColor3 = Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = frame

            local preview = Instance.new("TextButton")
            preview.Size = UDim2.fromOffset(60, 28)
            preview.Position = UDim2.new(1, -60, 0.5, -14)
            preview.BackgroundColor3 = default
            preview.Text = ""
            preview.AutoButtonColor = false
            preview.Parent = frame
            local pc = Instance.new("UICorner")
            pc.CornerRadius = UDim.new(0, 6)
            pc.Parent = preview

            -- Simple cycle through common colors for demo (full HSV picker would be larger)
            local colors = {
                Color3.fromRGB(21, 103, 251),
                Color3.fromRGB(255, 59, 48),
                Color3.fromRGB(52, 199, 89),
                Color3.fromRGB(255, 149, 0),
                Color3.fromRGB(175, 82, 222),
                Color3.fromRGB(90, 200, 250),
                Color3.fromRGB(255, 204, 0),
                Color3.fromRGB(0, 0, 0),
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
            frame.Size = UDim2.new(1, -10, 0, 32)
            frame.BackgroundTransparency = 1
            frame.Parent = content

            local box = Instance.new("TextButton")
            box.Size = UDim2.fromOffset(22, 22)
            box.Position = UDim2.fromOffset(0, 5)
            box.BackgroundColor3 = default and Theme.Accent or Color3.fromRGB(230, 230, 230)
            box.Text = default and "✓" or ""
            box.Font = Theme.FontMedium
            box.TextSize = 16
            box.TextColor3 = Color3.new(1, 1, 1)
            box.AutoButtonColor = false
            box.Parent = frame
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 5)
            bc.Parent = box

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -34, 1, 0)
            label.Position = UDim2.fromOffset(30, 0)
            label.BackgroundTransparency = 1
            label.Font = Theme.Font
            label.TextSize = 15
            label.TextColor3 = Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = text
            label.Parent = frame

            local state = default
            box.MouseButton1Click:Connect(function()
                state = not state
                box.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(230, 230, 230)
                box.Text = state and "✓" or ""
                if callback then callback(state) end
            end)

            return {Get = function() return state end, Set = function(_, v)
                state = v
                box.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(230, 230, 230)
                box.Text = state and "✓" or ""
            end}
        end

        -- Auto select first section
        if #sections == 1 then
            section:Select()
        end

        return section
    end

    -- Show window
    tween(main, {Position = UDim2.fromScale(0.5, 0.5)}, 0.7)

    self.Main = main
    self.ScreenGui = screenGui
    return self
end

return Library
