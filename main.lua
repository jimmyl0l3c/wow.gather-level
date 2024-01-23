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

-- TODO: also update rank max after training
GatherLevel:RegisterEvent("CHAT_MSG_SKILL")

function GetNodeInfo(itemName)
    local item = Herbs[itemName]

    if item == nil then return nil end

    local color = Colors.yellow

    local herbalism = GatherLevel.professions["Herbalism"]
    if herbalism ~= nil then
        if item.level.min > herbalism.rank then
            color = Colors.red
        elseif item.level.gray > herbalism.rank then
            color = Colors.green
        elseif item.level.gray <= herbalism.rank then
            color = Colors.gray
        end
    end

    return "Herb " .. item.level.min .. "\nGray " .. item.level.gray, color
end

function OnShowTooltip(tooltip)
    local lines = tooltip:GetTooltipData()["lines"]

    if lines[1] == nil then return end
    if lines[1]["leftText"] == nil then return end

    local tooltipText = lines[1]["leftText"]

    local additionalText, color = GetNodeInfo(tooltipText)

    if additionalText == nil or color == nil then return end

    tooltip:AddLine("\n" .. additionalText, color.r, color.g, color.b)
end

GameTooltip:HookScript("OnShow", OnShowTooltip)

