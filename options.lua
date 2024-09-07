local ADDON_NAME, ns = ...
local L = ns.L

local defaults = ns.data.defaults

local function CreateCheckBox(category, variable, name, tooltip)
    local setting = Settings.RegisterAddOnSetting(category, ns.prefix .. variable, ns.prefix .. variable, HKT_options, type(defaults[variable]), name, defaults[variable])
    Settings.SetOnValueChangedCallback(variable, function(event)
        HKT_options[ns.prefix .. variable] = setting:GetValue()
    end)
    Settings.CreateCheckbox(category, setting, tooltip)
end

function ns:CreateSettingsPanel()
    local category, layout = Settings.RegisterVerticalLayoutCategory(ns.name)
    Settings.RegisterAddOnCategory(category)

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.OptionsTitle))

    for index = 1, #L.Options do
        local option = L.Options[index]
        CreateCheckBox(category, option.key, option.name, option.tooltip)
    end

    ns.Settings = category
end
