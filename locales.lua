local _, ns = ...
local L = {}
ns.L = L

setmetatable(L, { __index = function(t, k)
    local v = tostring(k)
    t[k] = v
    return v
end })

-- Global
L.Enabled = _G.VIDEO_OPTIONS_ENABLED
L.Disabled = _G.VIDEO_OPTIONS_DISABLED
L.Remaining = _G.TEXT_MODE_A_STRING_REMAINING_POINTS
L.HonorableKills = _G.COMBAT_TEXT_SHOW_HONOR_GAINED_TEXT
L.WarbandWide = _G.ITEM_UPGRADE_DISCOUNT_TOOLTIP_ACCOUNT_WIDE

-- English
L.HKs = "%s " .. L.HonorableKills
L.Version = "%s is the current version." -- ns.version
L.Install = "Thanks for installing version |cff%1$s%2$s|r!" -- ns.color, ns.version
L.Update = "Thanks for updating to version |cff%1$s%2$s|r!" -- ns.color, ns.version
L.AddonCompartmentTooltip1 = "|cff" .. ns.color .. "Left-Click:|r Check Honorable Kills"
L.AddonCompartmentTooltip2 = "|cff" .. ns.color .. "Right-Click:|r Open Settings"
L.OptionsTitle1 = "General options:"
L.OptionsGeneral = {
    [1] = {
        key = "characterSpecific",
        name = "Character-specific alerts",
        tooltip = "Instead of displaying alerts for Honorable Kills progress across your Warband, display Character-specific Honorable Kills.",
    },
    [2] = {
        key = "trackAchievements",
        name = "Track Achievements",
        tooltip = "Track progress on the various achievements for increasing numbers of Honorable Kills across your Warband.",
    },
}
L.OptionsTitle2 = "How often do you want to see your progress?"
L.OptionsStats = {
    [1] = {
        key = "displayOnLogin",
        name = "Display stats on login",
        tooltip = "Prints your honorable kills stats in the chat box when you log in.",
    },
}
L.OptionsDivision = {
    key = "displayDivision",
    name = "Display stats every...",
    tooltip = "TODO",
}

-- Check locale and apply appropriate changes below
local CURRENT_LOCALE = GetLocale()

-- German
if CURRENT_LOCALE == "deDE" then return end

-- Spanish
if CURRENT_LOCALE == "esES" then return end

-- Latin-American Spanish
if CURRENT_LOCALE == "esMX" then return end

-- French
if CURRENT_LOCALE == "frFR" then return end

-- Italian
if CURRENT_LOCALE == "itIT" then return end

-- Brazilian Portuguese
if CURRENT_LOCALE == "ptBR" then return end

-- Russian
if CURRENT_LOCALE == "ruRU" then return end

-- Korean
if CURRENT_LOCALE == "koKR" then return end

-- Simplified Chinese
if CURRENT_LOCALE == "zhCN" then return end

-- Traditional Chinese
if CURRENT_LOCALE == "zhTW" then return end

-- Swedish
if CURRENT_LOCALE == "svSE" then return end
