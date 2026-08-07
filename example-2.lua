local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ShowToggleFrameInKeybinds = true -- Make toggle keybinds work inside the keybinds UI (aka adds a toggle to the UI). Good for mobile users (Default value = true)
Library.ShowCustomCursor = true -- Toggles the Linoria cursor globaly (Default value = true)
Library.NotifySide = "Left" -- Changes the side of the notifications globaly (Left, Right) (Default value = Left)

local Window = Library:CreateWindow({
	Title = "Example menu",
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = true,
	UnlockMouseWhileOpen = true,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 0.2
})

local Tabs = {
	Main = Window:AddTab("Main"),
	["UI Settings"] = Window:AddTab("UI Settings"),
}

-- Groupbox and Tabbox inherit the same functions
-- except Tabboxes you have to call the functions on a tab (Tabbox:AddTab(name))
local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Groupbox")

-- One of every base component, so nothing gets missed:

-- Toggle
LeftGroupBox:AddToggle("MyToggle", {
	Text = "This is a toggle",
	Default = true,

	Callback = function(Value)
		print("[cb] MyToggle changed to:", Value)
	end
})

-- ColorPicker (chained off a label — AddColorPicker lives on BaseAddonsFuncs,
-- so it's always called off another element, not the groupbox directly)
LeftGroupBox:AddLabel("Some color"):AddColorPicker("MyColorPicker", {
	Default = Color3.new(1, 0, 0),
	Title = "Some color",
	Transparency = 0,

	Callback = function(Value, Transparency)
		print("[cb] Color changed!", Value, "| Transparency changed to:", Transparency)
	end
})

-- Button
LeftGroupBox:AddButton({
	Text = "Button",
	Func = function()
		print("You clicked a button!")
		Library:Notify("This is a notification")
	end,
	DoubleClick = false,
	Tooltip = "This is the main button",
})

-- Label
LeftGroupBox:AddLabel("This is a label")

-- Slider
LeftGroupBox:AddSlider("MySlider", {
	Text = "This is my slider!",
	Default = 0,
	Min = 0,
	Max = 5,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		print("[cb] Slider changed to:", Value)
	end
})

-- Dropdown
LeftGroupBox:AddDropdown("MyDropdown", {
	Text = "Dropdown",
	Values = { "Addon", "Dropdown" },
	Default = 1,
	Multi = false,

	Callback = function(Value)
		print("[cb] Dropdown got changed. New value:", Value)
	end,
})

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- NOTE: our fork's SaveManager does NOT call IgnoreThemeSettings.
-- Theme colors (BackgroundColor, MainColor, AccentColor, OutlineColor, FontColor)
-- are ordinary ColorPicker options, so they get saved/loaded as part of each config on purpose.

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

-- our fork's SaveManager owns both configs AND theme colors (single folder, no separate ThemeManager:SetFolder call needed)
SaveManager:SetFolder("MyScriptHub")
-- SaveManager:SetSubFolder("specific-place") -- optional, e.g. per-game/per-place config separation

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs["UI Settings"])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs["UI Settings"])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
