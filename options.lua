local ADDON_NAME, ns = ...
local L = ns.L

local defaults = ns.data.defaults

local function CreateCheckBox(category, variable, name, tooltip)
    local setting = Settings.RegisterAddOnSetting(category, ns.prefix .. variable, ns.prefix .. variable, HKT_options, type(defaults[variable]), name, defaults[variable])
    Settings.CreateCheckbox(category, setting, tooltip)
end

local function CreateDropDown(category, variable, name, options, tooltip)
    local setting = Settings.RegisterAddOnSetting(category, ns.prefix .. variable, ns.prefix .. variable, HKT_options, type(defaults[variable]), name, defaults[variable])
    Settings.CreateDropdown(category, setting, options, tooltip)
end

function ns:CreateSettingsPanel()
    local category, layout = Settings.RegisterVerticalLayoutCategory(ns.name)
    Settings.RegisterAddOnCategory(category)

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.OptionsTitle1))

    for index = 1, #L.OptionsGeneral do
        local option = L.OptionsGeneral[index]
        CreateCheckBox(category, option.key, option.name, option.tooltip)
    end

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L.OptionsTitle2))

    for index = 1, #L.OptionsStats do
        local option = L.OptionsStats[index]
        CreateCheckBox(category, option.key, option.name, option.tooltip)
    end

    local function GetDivisionOptions()
        local container = Settings.CreateControlTextContainer()
        container:Add(0, "Never")
        for index = 1, #ns.data.divisions do
            local value = ns.data.divisions[index]
            container:Add(index, value .. " " .. L.HonorableKills)
        end
        return container:GetData()
    end
    CreateDropDown(category, L.OptionsDivision.key, L.OptionsDivision.name, GetDivisionOptions, L.OptionsDivision.tooltip)

    ns.Settings = category
end
