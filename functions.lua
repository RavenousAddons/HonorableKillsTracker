local ADDON_NAME, ns = ...
local L = ns.L

ns.data.warbandFormatted = "|cff01e2ff" .. L.WarbandWide .. "|r"

local achievements = ns.data.achievements
local achievementsCount = #achievements

local CT = C_Timer
local CQL = C_QuestLog

---
-- Local Functions
---

-- Set default values for options which are not yet set.
-- @param {string} option
-- @param {any} default
local function RegisterDefaultOption(option, default)
    if HKT_options[ns.prefix .. option] == nil then
        if HKT_options[option] ~= nil then
            HKT_options[ns.prefix .. option] = HKT_options[option]
            HKT_options[option] = nil
        else
            HKT_options[ns.prefix .. option] = default
        end
    end
end

local function FormatNumber(number)
    local thousandsSeparator = ns:OptionValue("thousandsSeparator") == 2 and "." or ","
    local formatted = tostring(number)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1" .. thousandsSeparator .. "%2")
        if k == 0 then
            break
        end
    end
    return formatted
end

local function HighestAchievementIndex()
    if ns.data.highestAchievementIndex ~= nil then
        return ns.data.highestAchievementIndex
    end
    local index
    for total, _ in pairs(achievements) do
        if index == nil or index < total then
            index = total
        end
    end
    ns.data.highestAchievementIndex = tonumber(index)
    return tonumber(index)
end

local function HighestAchievementID()
    if ns.data.highestAchievementID ~= nil then
        return ns.data.highestAchievementID
    end
    local id = tonumber(achievements[HighestAchievementIndex()])
    ns.data.highestAchievementID = id
    return id
end

local function CurrentAchievementIndex(warbandHKs)
    if ns.data.currentAchievementIndex ~= nil and warbandHKs < ns.data.currentAchievementIndex then
        return ns.data.currentAchievementIndex
    end
    local max = HighestAchievementIndex()
    if warbandHKs >= max then
        return max
    end

    local index
    for total, _ in pairs(achievements) do
        if warbandHKs < total and total < (index or max) then
            index = tonumber(total)
        end
    end
    ns.data.currentAchievementIndex = index
    return index
end

local function CurrentAchievementID(warbandHKs)
    if ns.data.currentAchievementID ~= nil and ns.data.currentAchievementIndex ~= nil and warbandHKs < ns.data.currentAchievementIndex then
        return ns.data.currentAchievementID
    end
    local id = tonumber(achievements[CurrentAchievementIndex(warbandHKs)])
    ns.data.currentAchievementID = id
    return id
end

local function AchievementLink(warbandHKs)
    return "|cffffffaa|Hachievement:" .. CurrentAchievementID(warbandHKs) .. ":" .. ns.data.characterID .. ":0:0:0:0:0:0:0:0|h[" .. L.HKs:format(CurrentAchievementIndex(warbandHKs)) .. "]|h|r"
end

local function ShouldTrackCharacterSpecific(warbandHKs)
    return ns:OptionValue("characterSpecific") or HighestAchievementIndex() < warbandHKs
end

local function DisplayDivision()
    return ns.data.divisions[ns:OptionValue("displayDivision")]
end

local function GetChangeIndex(old, new)
    local minLength = math.min(#old, #new)
    for i = 1, minLength do
        if old:sub(i, i) ~= "," and old:sub(i, i) ~= new:sub(i, i) and new:sub(i, i) ~= "," then
            return i
        end
    end
    if #old ~= #new then
        return minLength + 1
    end
    return nil
end

local function FormatChange(old, new)
    local index = GetChangeIndex(old, new)
    if not index then
        return new
    end
    local left = new:sub(1, index - 1)
    local right = new:sub(index)
    return left .. "|cff44ff44" .. right .. "|r"
end

local function CharacterHKs()
    local value = GetStatistic(ns.data.statistic)
    return value and tonumber(value) or 0
end

local function WarbandHKs()
    local criteria = select(9, GetAchievementCriteriaInfo(HighestAchievementID(), 1))
    if criteria ~= nil then
        local value = criteria:match('%d+')
        return tonumber(value)
    end
    return 0
end

local function PrintStats(trackingType, key, honorableKills)
    print(L.HKs:format(trackingType) .. ": " .. FormatChange(FormatNumber(HKT_data[key] or "0"), FormatNumber(honorableKills)))
end

local function EqualDivision(characterHKs, warbandHKs, characterSpecific)
    local displayDivision = DisplayDivision()
    if displayDivision == 0 then
        return false
    elseif displayDivision == 1 then
        return true
    end
    local x = math.fmod(characterSpecific and characterHKs or warbandHKs, displayDivision)
    return x == 0
end

local displayLocked = false
local function DisplayStats(characterHKs, warbandHKs, characterSpecific, force)
    if force or not displayLocked then
        displayLocked = true
        -- Print stats based on character-specific parameter
        local trackingType = characterSpecific and ns.data.characterNameFormatted or ns.data.warbandFormatted
        local key = characterSpecific and "honorableKillsCharacter" or "honorableKills"
        local honorableKills = characterSpecific and characterHKs or warbandHKs
        PrintStats(trackingType, key, honorableKills)

        -- Print stats based on opposite of character-specific parameter
        if force then
            trackingType = characterSpecific and ns.data.warbandFormatted or ns.data.characterNameFormatted
            key = characterSpecific and "honorableKills" or "honorableKillsCharacter"
            honorableKills = characterSpecific and warbandHKs or characterHKs
            PrintStats(trackingType, key, honorableKills)
        end

        local remaining = CurrentAchievementIndex(warbandHKs) - warbandHKs
        if ns:OptionValue("trackAchievements") and warbandHKs < HighestAchievementIndex() then
            print(AchievementLink(warbandHKs) .. " " .. L.Remaining:format(FormatNumber(HKT_data.remaining or "0")))
        end

        HKT_data.remaining = remaining
        C_Timer.After(1, function()
            displayLocked = false
        end)
    end
end

---
-- Namespaced Functions
---

--- Set some data about the player
function ns:SetPlayerState()
    ns.data.characterID = UnitGUID("player")
    ns.data.characterName = UnitName("player") .. "-" .. GetNormalizedRealmName("player")
    local _, className, _ = UnitClass("player")
    ns.data.className = className
    ns.data.characterNameFormatted = "|cff" .. ns.data.classColors[ns.data.className:lower()] .. ns.data.characterName .. "|r"
end

--- Returns an option from the options table
function ns:OptionValue(option)
    return HKT_options[ns.prefix .. option]
end

--- Sets default options if they are not already set
function ns:SetDefaultOptions()
    HKT_data = HKT_data or {}
    HKT_options = HKT_options or {}
    for option, default in pairs(ns.data.defaults) do
        RegisterDefaultOption(option, default)
    end
end

--- Prints a formatted message to the chat
-- @param {string} message
function ns:PrettyPrint(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cff" .. ns.color .. ns.name .. "|r " .. message)
end

--- Opens the Addon settings menu and plays a sound
function ns:OpenSettings()
    PlaySound(SOUNDKIT.IG_MAINMENU_OPEN)
    Settings.OpenToCategory(ns.Settings:GetID())
end

function ns:Alert(force)
    local characterHKs = CharacterHKs()
    local warbandHKs = WarbandHKs()
    local characterSpecific = ShouldTrackCharacterSpecific(warbandHKs)
    if force or (EqualDivision(characterHKs, warbandHKs, characterSpecific) and HKT_data.honorableKillsCharacter < characterHKs) then
        DisplayStats(characterHKs, warbandHKs, characterSpecific, force)
    end
    HKT_data.honorableKills = warbandHKs
    HKT_data.honorableKillsCharacter = characterHKs
end