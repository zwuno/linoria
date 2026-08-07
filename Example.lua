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

-- We can also get our Main tab via the following code:
-- local LeftGroupBox = Window.Tabs.Main:AddLeftGroupbox("Groupbox")

-- Tabboxes are a tiny bit different, but here's a basic example:
--[[

local TabBox = Tabs.Main:AddLeftTabbox() -- Add Tabbox on left side

local Tab1 = TabBox:AddTab("Tab 1")
local Tab2 = TabBox:AddTab("Tab 2")

-- You can now call AddToggle, etc on the tabs you added to the Tabbox
]]

-- Groupbox:AddToggle
-- Arguments: Index, Options
LeftGroupBox:AddToggle("MyToggle", {
	Text = "This is a toggle",
	Tooltip = "This is a tooltip", -- Information shown when you hover over the toggle
	DisabledTooltip = "I am disabled!", -- Information shown when you hover over the toggle while it's disabled

	Default = true, -- Default value (true / false)
	Disabled = false, -- Will disable the toggle (true / false)
	Visible = true, -- Will make the toggle invisible (true / false)
	Risky = false, -- Makes the text red (the color can be changed using Library.RiskColor) (Default value = false)

	Callback = function(Value)
		print("[cb] MyToggle changed to:", Value)
	end
}):AddColorPicker("ColorPicker1", {
	Default = Color3.new(1, 0, 0),
	Title = "Some color1", -- Optional. Allows you to have a custom color picker title (when you open it)
	Transparency = 0, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

	Callback = function(Value, Transparency)
		print("[cb] Color changed!", Value, "| Transparency changed to:", Transparency)
	end
}):AddColorPicker("ColorPicker2", {
	Default = Color3.new(0, 1, 0),
	Title = "Some color2",
	Transparency = 0,

	Callback = function(Value, Transparency)
		print("[cb] Color changed!", Value, "| Transparency changed to:", Transparency)
	end
}):AddColorPicker("ColorPicker3", {
	Default = Color3.new(0, 0, 1),
	Title = "Some color3",
	Transparency = 0,

	Callback = function(Value, Transparency)
		print("[cb] Color changed!", Value, "| Transparency changed to:", Transparency)
	end
})


-- Fetching a toggle object for later use:
-- Toggles.MyToggle.Value

-- Toggles is a table added to getgenv() by the library
-- You index Toggles with the specified index, in this case it is "MyToggle"
-- To get the state of the toggle you do toggle.Value

-- Calls the passed function when the toggle is updated
Toggles.MyToggle:OnChanged(function()
	-- here we get our toggle object & then get its value
	print("MyToggle changed to:", Toggles.MyToggle.Value)
end)

-- This should print to the console: "My toggle state changed! New value: false"
Toggles.MyToggle:SetValue(false)

-- 1/15/23
-- Deprecated old way of creating buttons in favor of using a table
-- Added DoubleClick button functionality

--[[
	Groupbox:AddButton
	Arguments: {
		Text = string,
		Func = function,
		DoubleClick = boolean
		Tooltip = string,
	}

	You can call :AddButton on a button to add a SubButton!
]]

local MyButton = LeftGroupBox:AddButton({
	Text = "Button",
	Func = function()
		print("You clicked a button!")
		Library:Notify("This is a notification")
	end,
	DoubleClick = false,

	Tooltip = "This is the main button",
	DisabledTooltip = "I am disabled!", -- Information shown when you hover over the button while it's disabled

	Disabled = false, -- Will disable the button (true / false)
	Visible = true -- Will make the button invisible (true / false)
})

local MyButton2 = MyButton:AddButton({
	Text = "Sub button",
	Func = function()
		print("You clicked a sub button!")
		Library:Notify("This is a notification with sound", nil, 4590657391)
	end,
	DoubleClick = true, -- You will have to click this button twice to trigger the callback
	Tooltip = "This is the sub button (double click me!)"
})

local MyDisabledButton = LeftGroupBox:AddButton({
	Text = "Disabled Button",
	Func = function()
		print("You somehow clicked a disabled button!")
	end,
	DoubleClick = false,
	Tooltip = "This is a disabled button",
	DisabledTooltip = "I am disabled!", -- Information shown when you hover over the button while it's disabled
	Disabled = true
})

--[[
	NOTE: You can chain the button methods!
	EXAMPLE:

	LeftGroupBox:AddButton({ Text = "Kill all", Func = Functions.KillAll, Tooltip = "This will kill everyone in the game!" })
		:AddButton({ Text = "Kick all", Func = Functions.KickAll, Tooltip = "This will kick everyone in the game!" })
]]


-- Groupbox:AddLabel
-- Arguments: Text, DoesWrap, Idx
-- Arguments: Idx, Options
LeftGroupBox:AddLabel("This is a label")
LeftGroupBox:AddLabel("This is a label\n\nwhich wraps its text!", true)
LeftGroupBox:AddLabel("This is a label exposed to Labels", true, "TestLabel")
LeftGroupBox:AddLabel("SecondTestLabel", {
	Text = "This is a label made with table options and an index",
	DoesWrap = true -- Defaults to false
})

LeftGroupBox:AddLabel("SecondTestLabel", {
	Text = "This is a label that doesn\"t wrap it\"s own text",
	DoesWrap = false -- Defaults to false
})

-- Labels is a table inside Library that is added to getgenv()
-- You index Library.Labels with the specified index, in this case it is "SecondTestLabel" & "TestLabel"
-- To set the text of the label you do label:SetText

-- Library.Labels.TestLabel:SetText("first changed!")
-- Library.Labels.SecondTestLabel:SetText("second changed!")


-- Groupbox:AddDivider
-- Arguments: None
LeftGroupBox:AddDivider()

--[[
	Groupbox:AddSlider
	Arguments: Idx, SliderOptions

	SliderOptions: {
		Text = string,
		Default = number,
		Min = number,
		Max = number,
		Suffix = string,
		Rounding = number,
		Compact = boolean,
		HideMax = boolean,
	}

	Text, Default, Min, Max, Rounding must be specified.
	Suffix is optional.
	Rounding is the number of decimal places for precision.

	Compact will hide the title label of the Slider

	HideMax will only display the value instead of the value & max value of the slider
	Compact will do the same thing
]]
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
