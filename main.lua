GatherLevel = LibStub("AceAddon-3.0"):NewAddon("GatherLevel", "AceConsole-3.0", "AceEvent-3.0")

GatherLevel.professions = {}

function GatherLevel:OnInitialize()
    self:Print("initialized")
end

function GatherLevel:OnEnable()
    FetchProfessionSkills()
    self:Print("enabled")
end

function GatherLevel:OnDisable()
    self:Print("disabled")
end

function GatherLevel:CHAT_MSG_SKILL(_, text, ...)
    for profName in pairs(GatherLevel.professions) do
        local newRank = string.match(text, "Your skill in " .. profName .. " has increased to (%d+).")
        SetProfessionRank(profName, tonumber(newRank))
    end
end

function GatherLevel:SKILL_LINES_CHANGED(_)
    -- Major change to skill list happened, reload data
    GatherLevel.professions = {}
    FetchProfessionSkills()
end

GatherLevel:RegisterEvent("CHAT_MSG_SKILL")
GatherLevel:RegisterEvent("SKILL_LINES_CHANGED")

function OnShowTooltip(tooltip)
    local lines = tooltip:GetTooltipData()["lines"]

    if lines[1] == nil then return end
    if lines[1]["leftText"] == nil then return end

    ExpandTooltip(tooltip, lines[1]["leftText"])
end

GameTooltip:HookScript("OnShow", OnShowTooltip)

