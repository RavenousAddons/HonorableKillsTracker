local ADDON_NAME, ns = ...
local L = ns.L

ns.data.warbandFormatted = "|cff01e2ff" .. L.WarbandWide .. "|r"

local achievements = ns.data.achievements
local achievementsSize = #achievements

local CT = C_Timer
local CQL = C_QuestLog

---
-- Local Functions
---

local function FormatNumber(number)
    local thousandsSeparator = ns:OptionValue(HKT_options, "thousandsSeparator") == 2 and "." or ","
    local formatted = tostring(number)
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1" .. thousandsSeparator .. "%2")
        if k == 0 then
            break
        end
    end
    return formatted
end

local function GetAchievementData()
    -- if ns.data.achievementData ~= nil then
    --     return ns.data.achievementData
    -- end

    local data = {}

    local previousReqQuantity = 0
    for i = 1, achievementsSize do
        local _, _, _, quantity, reqQuantity = GetAchievementCriteriaInfo(achievements[i], 1)
        if quantity < reqQuantity and quantity > previousReqQuantity then
            data.id = achievements[i]
            data.quantity = quantity
            data.reqQuantity = reqQuantity
            previousReqQuantity = reqQuantity
        end
    end

    ns.data.achievementData = data
    return data
end

local function ShouldTrackCharacterSpecific()
    local achievementData = GetAchievementData()
    return ns:OptionValue(HKT_options, "characterSpecific") or achievementData.id == nil
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

local function PrintStats(trackingType, key, honorableKills, forced)
    print(L.HKs:format(trackingType) .. ": " .. (forced and FormatNumber(honorableKills) or FormatChange(FormatNumber(HKT_data[key] or "0"), FormatNumber(honorableKills))))
end

local function CharacterHKs()
    local value = GetStatistic(ns.data.statistic)
    return value and tonumber(value) or 0
end

local function WarbandHKs()
    local achievementData = GetAchievementData()
    return achievementData.quantity
end

local function MatchesDivision(characterHKs, warbandHKs, characterSpecific)
    local displayDivision = ns.data.divisions[ns:OptionValue(HKT_options, "displayDivision")]
    if displayDivision == 0 then
        return false
    elseif displayDivision == 1 then
        return true
    end
    local x = math.fmod(characterSpecific and characterHKs or warbandHKs, displayDivision)
    return x == 0
end

local function AchievementLink()
    local achievementData = GetAchievementData()
    return "|cffffffaa|Hachievement:" .. achievementData.id .. ":" .. ns.data.characterID .. ":0:0:0:0:0:0:0:0|h[" .. L.HKs:format(achievementData.reqQuantity) .. "]|h|r"
end

local displayLocked = false
local function DisplayStats(characterHKs, warbandHKs, characterSpecific, forced)
    if displayLocked and not forced then
        return
    end
    displayLocked = true

    -- Print stats based on character-specific parameter
    local trackingType = characterSpecific and ns.data.characterNameFormatted or ns.data.warbandFormatted
    local key = characterSpecific and "honorableKillsCharacter" or "honorableKills"
    local honorableKills = characterSpecific and characterHKs or warbandHKs
    PrintStats(trackingType, key, honorableKills, forced)

    -- Print stats based on opposite of character-specific parameter
    if forced and ns.data.achievementData.quantity then
        trackingType = characterSpecific and ns.data.warbandFormatted or ns.data.characterNameFormatted
        key = characterSpecific and "honorableKills" or "honorableKillsCharacter"
        honorableKills = characterSpecific and warbandHKs or characterHKs
        PrintStats(trackingType, key, honorableKills, forced)
    end

    local achievementData = GetAchievementData()
    if ns:OptionValue(HKT_options, "trackAchievements") and achievementData.reqQuantity and warbandHKs < achievementData.reqQuantity then
        local remaining = achievementData.reqQuantity - warbandHKs
        print(AchievementLink() .. " " .. L.Remaining:format(FormatNumber(remaining or "0")))
    end

    C_Timer.After(1, function()
        displayLocked = false
    end)
end

---
-- Namespaced Functions
---

--- Returns an option from the options table
-- @param {boolean} forced
function ns:Alert(forced)
    C_Timer.After(0, function()
        local characterSpecific = ShouldTrackCharacterSpecific()
        local characterHKs = CharacterHKs()
        local warbandHKs = WarbandHKs()

        if forced or (MatchesDivision(characterHKs, warbandHKs, characterSpecific) and HKT_data.honorableKillsCharacter < characterHKs) then
            DisplayStats(characterHKs, warbandHKs, characterSpecific, forced)
        end

        HKT_data.honorableKills = warbandHKs
        HKT_data.honorableKillsCharacter = characterHKs
    end)
end

--- Set some data about the player
function ns:SetPlayerState()
    ns.data.characterID = UnitGUID("player")
    ns.data.characterName = UnitName("player") .. "-" .. GetNormalizedRealmName("player")
    local _, className, _ = UnitClass("player")
    ns.data.className = className
    ns.data.characterNameFormatted = "|cff" .. ns.data.classColors[ns.data.className:lower()] .. ns.data.characterName .. "|r"
end

--- Sets default options if they are not already set
function ns:SetOptionDefaults()
    HKT_data = HKT_data or {}
    HKT_options = HKT_options or {}
    for option, default in pairs(ns.data.defaults) do
        ns:SetOptionDefault(HKT_options, option, default)
    end
end
