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
L.AddonCompartmentTooltip1 = "|cff" .. ns.color .. "Left-Click:|r Check " .. L.HonorableKills
L.AddonCompartmentTooltip2 = "|cff" .. ns.color .. "Right-Click:|r Open Settings"
L.OptionsTitle1 = "General options:"
L.OptionsGeneral = {
    [1] = {
        key = "characterSpecific",
        name = "Prioritize character-specific stats",
        tooltip = "Instead of displaying alerts for " .. L.HonorableKills .. " progress across your Warband, display Character-specific " .. L.HonorableKills .. ".",
    },
    [2] = {
        key = "trackAchievements",
        name = "Track Achievements",
        tooltip = "Track progress on the various achievements for increasing numbers of " .. L.HonorableKills .. " across your Warband.",
    },
}
L.OptionsTitle2 = "How often do you want to see your progress?"
L.OptionsStats = {
    [1] = {
        key = "displayOnLogin",
        name = "Display stats on login",
        tooltip = "Prints your " .. L.HonorableKills .. " stats in the chat box when you log in.",
    },
}
L.OptionsDivision = {
    key = "displayDivision",
    name = "Display stats every...",
    tooltip = "Change how often you will be alerted to progress in the number of your " .. L.HonorableKills .. ".",
}

-- Check locale and apply appropriate changes below
local CURRENT_LOCALE = GetLocale()

-- British English
if CURRENT_LOCALE == "enGB" then
    L.OptionsGeneral[1].name = "Prioritise character-specific stats"
end
