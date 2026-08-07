local ThemeManager = {} do
	local ThemeFields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

	ThemeManager.Library = nil

	local assert = function(condition, errorMessage)
		if not condition then
			error(errorMessage or "assert failed", 3)
		end
	end

	function ThemeManager:SetLibrary(library)
		self.Library = library
	end

	function ThemeManager:ThemeUpdate()
		for _, field in next, ThemeFields do
			if self.Library.Options and self.Library.Options[field] then
				self.Library[field] = self.Library.Options[field].Value
			end
		end

		self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor)
		self.Library:UpdateColorsUsingRegistry()
	end

	--// GUI \\--
	function ThemeManager:CreateThemeManager(groupbox)
		groupbox:AddLabel('Background'):AddColorPicker('BackgroundColor', { Default = self.Library.BackgroundColor, Title = 'Background' })
		groupbox:AddLabel('Main')      :AddColorPicker('MainColor', { Default = self.Library.MainColor, Title = 'Main' })
		groupbox:AddLabel('Accent')    :AddColorPicker('AccentColor', { Default = self.Library.AccentColor, Title = 'Accent' })
		groupbox:AddLabel('Outline')   :AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor, Title = 'Outline' })
		groupbox:AddLabel('Font')      :AddColorPicker('FontColor', { Default = self.Library.FontColor, Title = 'Font' })

		local function UpdateTheme() self:ThemeUpdate() end
		self.Library.Options.BackgroundColor:OnChanged(UpdateTheme)
		self.Library.Options.MainColor:OnChanged(UpdateTheme)
		self.Library.Options.AccentColor:OnChanged(UpdateTheme)
		self.Library.Options.OutlineColor:OnChanged(UpdateTheme)
		self.Library.Options.FontColor:OnChanged(UpdateTheme)
	end

	function ThemeManager:CreateGroupBox(tab)
		assert(self.Library, 'ThemeManager:CreateGroupBox -> Must set ThemeManager.Library first!')
		return tab:AddLeftGroupbox('Theme')
	end

	function ThemeManager:ApplyToTab(tab)
		assert(self.Library, 'ThemeManager:ApplyToTab -> Must set ThemeManager.Library first!')
		local groupbox = self:CreateGroupBox(tab)
		self:CreateThemeManager(groupbox)
	end

	function ThemeManager:ApplyToGroupbox(groupbox)
		assert(self.Library, 'ThemeManager:ApplyToGroupbox -> Must set ThemeManager.Library first!')
		self:CreateThemeManager(groupbox)
	end
end

getgenv().LinoriaThemeManager = ThemeManager
return ThemeManager
