GatherLevel = LibStub("AceAddon-3.0"):NewAddon("GatherLevel", "AceConsole-3.0", "AceEvent-3.0")

GatherLevel.professions = {}

local defaults = {
  profile = {
    collectData = false,
    herbs = {},
    mineNodes = {}
  },
}

function GatherLevel:ToggleDataCollection()
    self.nodeDb.profile.collectData = not self.nodeDb.profile.collectData
    self:RegisterDataCollection()
    self:Print("collectData: " .. tostring(self.nodeDb.profile.collectData))
end

function GatherLevel:RegisterDataCollection()
    if self.nodeDb.profile.collectData then
        GatherLevel:RegisterEvent("CHAT_MSG_LOOT")
    else
        GatherLevel:UnregisterEvent("CHAT_MSG_LOOT")
    end
end

function GatherLevel:OnInitialize()
    self.nodeDb = LibStub("AceDB-3.0"):New("GatherLevelNodeDB", defaults, true)
    self:RegisterChatCommand("gatherCollect", "ToggleDataCollection")
    self:RegisterDataCollection()
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

function GatherLevel:CHAT_MSG_LOOT(_, text, ...)
    local itemLink = string.match(text, "You receive loot: (.+)")
    -- for whatever reason, I cannot match it at once
    local itemReceived = string.match(itemLink, "%[(.+)%]")

    PromptNodeDataCollection(self, itemReceived)
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

