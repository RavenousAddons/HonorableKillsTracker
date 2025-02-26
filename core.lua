local ADDON_NAME, ns = ...
local L = ns.L

local characterID = UnitGUID("player")

local CT = C_Timer

-- Load the Addon

function HonorableKillTracker_OnLoad(self)
    self:RegisterEvent("LOADING_SCREEN_ENABLED")
    self:RegisterEvent("LOADING_SCREEN_DISABLED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("CRITERIA_UPDATE")
end

-- Event Triggers

function HonorableKillTracker_OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        local isInitialLogin, isReloadingUi = ...
        ns:SetPlayerState()
        ns:SetOptionDefaults()
        ns:CreateSettingsPanel(HKT_options, ns.data.defaults, L.Settings, ns.name, ns.prefix, ns.version)
        if not HKT_version then
            ns:PrettyPrint(L.Install:format(ns.color, ns.version))
        elseif HKT_version ~= ns.version then
            -- Version-specific messages go here...
        end
        HKT_version = ns.version
        if isInitialLogin then
            if ns:OptionValue(HKT_options, "displayOnLogin") then
                C_Timer.After(3, function()
                    ns:Alert(true)
                end)
            end
        end
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    elseif event == "LOADING_SCREEN_ENABLED" then
        self:UnregisterEvent("CRITERIA_UPDATE")
    elseif event == "LOADING_SCREEN_DISABLED" then
        self:RegisterEvent("CRITERIA_UPDATE")
    elseif event == "CRITERIA_UPDATE" then
        C_Timer.After(1, function()
            ns:Alert()
        end)
    end
end

-- Addon Compartment Handling

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

-- Slash Command Handling

SlashCmdList["HONORABLEKILLTRACKER"] = function(message)
    if message == "v" or message:match("ver") then
        -- Print the current addon version
        ns:PrettyPrint(L.Version:format(ns.version))
    elseif message == "c" or message:match("con") or message == "o" or message:match("opt") or message == "s" or message:match("sett") or message:match("togg") then
        -- Open settings window
        ns:OpenSettings()
    else
        -- Print HK count
        ns:Alert(true)
    end
end
SLASH_HONORABLEKILLTRACKER1 = "/" .. ns.command
