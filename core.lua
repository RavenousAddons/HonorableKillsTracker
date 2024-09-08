local ADDON_NAME, ns = ...
local L = ns.L

local characterID = UnitGUID("player")

local CT = C_Timer

-- Load the Addon

function HonorableKillTracker_OnLoad(self)
    self:RegisterEvent("PLAYER_LOGIN")
    self:RegisterEvent("CRITERIA_UPDATE")
end

-- Event Triggers

function HonorableKillTracker_OnEvent(self, event, arg, ...)
    if event == "PLAYER_LOGIN" then
        ns:SetDefaultOptions()
        ns:CreateSettingsPanel()
        if not HKT_version then
            ns:PrettyPrint(L.Install:format(ns.color, ns.version))
        elseif HKT_version ~= ns.version then
            ns:PrettyPrint(L.Update:format(ns.color, ns.version))
            -- Version-specific messages go here...
        end
        HKT_version = ns.version
        if ns:OptionValue("displayOnLogin") then
            ns:Alert(true)
        end
    elseif event == "CRITERIA_UPDATE" then
        ns:Alert()
    end
end

AddonCompartmentFrame:RegisterAddon({
    text = ns.title,
    icon = ns.icon,
    registerForAnyClick = true,
    notCheckable = true,
    func = function(button, menuInputData, menu)
        local mouseButton = menuInputData.buttonName
        if mouseButton == "RightButton" then
            ns:OpenSettings()
            return
        end
        ns:Alert(true)
    end,
    funcOnEnter = function(menuItem)
        GameTooltip:SetOwner(menuItem)
        GameTooltip:SetText(ns.name .. "        v" .. ns.version)
        GameTooltip:AddLine(" ", 1, 1, 1, true)
        GameTooltip:AddLine(L.AddonCompartmentTooltip1, 1, 1, 1, true)
        GameTooltip:AddLine(L.AddonCompartmentTooltip2, 1, 1, 1, true)
        GameTooltip:Show()
    end,
    funcOnLeave = function()
        GameTooltip:Hide()
    end,
})

SlashCmdList["HONORABLEKILLTRACKER"] = function(message)
    if message == "v" or message:match("ver") then
        -- Print the current addon version
        ns:PrettyPrint(L.Version:format(ns.version))
    elseif message == "c" or message:match("con") or message == "o" or message:match("opt") or message == "s" or message:match("sett") or message:match("togg") then
        -- Open settings window
        ns:OpenSettings()
    else
        -- Print the timer
        ns:Alert(true)
    end
end
SLASH_HONORABLEKILLTRACKER1 = "/" .. ns.command
