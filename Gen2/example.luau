local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/TrueVelocity/Apple-UI/refs/heads/main/Gen2/library.luau"))() -- or paste the library above

local window = Library.new("Apple UI Gen2", true, Enum.KeyCode.RightShift, true)

window:Divider("MAIN")

local main = window:Section("Main")
main:Divider("Welcome")
main:Label("This is a fully remade Apple-style UI library.")
main:Paragraph("It includes buttons, toggles, sliders, dropdowns, keybinds, color pickers, checkboxes, notifications and more.")

main:Button("Click Me", function()
    print("Button pressed!")
    window:TempNotify("Success", "You clicked the button!", "rbxassetid://12608259004")
end)

main:Switch("Enable Feature", false, function(state)
    print("Switch:", state)
end)

main:TextField("Username", "Enter username...", function(text)
    print("TextField:", text)
end)

main:Slider("WalkSpeed", 16, 200, 16, function(val)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)

main:Dropdown("Theme", {"Light", "Dark", "Blue", "Purple"}, "Light", function(opt)
    print("Selected theme:", opt)
end)

main:Keybind("Toggle UI", Enum.KeyCode.RightShift, function(key)
    print("New keybind:", key.Name)
end)

main:ColorPicker("Accent Color", Color3.fromRGB(21, 103, 251), function(color)
    print("Color selected:", color)
end)

main:Checkbox("Auto Farm", false, function(state)
    print("Auto Farm:", state)
end)

-- Notifications section
local notifSec = window:Section("Notifications")
notifSec:Button("Temp Notification", function()
    window:TempNotify("Warning", "This is a temporary toast notification.", "rbxassetid://12608259004")
end)

notifSec:Button("Single Button Notify", function()
    window:Notify("Hello!", "This is a modal notification with one button.", "Got it", "rbxassetid://12608259004", function()
        print("OK clicked")
    end)
end)

notifSec:Button("Two Button Notify", function()
    window:Notify2("Confirm", "Do you want to continue?", "Yes", "No", "rbxassetid://12608259004",
        function() print("Yes") end,
        function() print("No") end
    )
end)

window:GreenButton(function()
    print("Green traffic light clicked!")
    window:TempNotify("Green Button", "You pressed the green button!", "rbxassetid://12608259004")
end)

-- Select first section
main:Select()
