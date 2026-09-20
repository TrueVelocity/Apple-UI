local Library = loadstring(game:HttpGet("YOUR_RAW_LINK"))() -- or paste library

local window = Library.new("NEON GLOW UI", true, Enum.KeyCode.RightShift, true)

window:Divider("CORE")

local main = window:Section("Dashboard", "◆")
main:Divider("Welcome to Gen3")
main:Label("This is the glowing neon edition.")
main:Paragraph("Everything has soft glow, better text, hover effects, and a ton of new elements.")

main:Button("Click for Glow Notification", function()
    window:TempNotify("Glowing!", "This toast has a soft neon glow around it.", "rbxassetid://12608259004")
end)

main:Switch("Rainbow Accent", false, function(state)
    window:ToggleRainbow(state)
    print("Rainbow:", state)
end)

main:Slider("Intensity", 0, 100, 50, function(v)
    print("Intensity:", v)
end)

main:Progress("Loading Something Cool", 0.65)

main:Stepper("Amount", 1, 20, 5, function(v)
    print("Stepper:", v)
end)

main:Dropdown("Theme", {"Neon", "Purple", "Cyan", "Red"}, "Neon", function(t)
    window:SetTheme(t)
    window:TempNotify("Theme", "Switched to " .. t, nil)
end)

main:Keybind("UI Toggle", Enum.KeyCode.RightShift, function(k)
    print("Keybind set to", k.Name)
end)

main:ColorPicker("Accent Preview", Color3.fromRGB(0, 255, 170), function(c)
    print("Color:", c)
end)

main:Checkbox("Enable Extra Effects", true, function(s)
    print("Effects:", s)
end)

main:TextField("Custom Text", "Type something cool...", function(t)
    print("Text:", t)
end)

-- Notifications section
local nSec = window:Section("Notifications", "◈")
nSec:Button("Temp Toast", function()
    window:TempNotify("Neon Toast", "Soft glow + clean text", "rbxassetid://12608259004")
end)
nSec:Button("Modal (1 Button)", function()
    window:Notify("Confirm", "This modal also glows.", "Alright", "rbxassetid://12608259004", function()
        print("Confirmed")
    end)
end)
nSec:Button("Modal (2 Buttons)", function()
    window:Notify2("Are you sure?", "This action cannot be undone.", "Yes", "Cancel", nil,
        function() print("Yes") end,
        function() print("Cancel") end)
end)

window:GreenButton(function()
    window:TempNotify("Green Button", "You pressed the glowing green light!", nil)
end)

main:Select()
