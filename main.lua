GatherLevel = LibStub("AceAddon-3.0"):NewAddon("GatherLevel", "AceConsole-3.0", "AceEvent-3.0")

function GatherLevel:OnInitialize()
    self:Print("initialized")
end

function GatherLevel:OnEnable()
    self:Print("enabled")
    -- self:Print(GetNumPrimaryProfessions())
end

function GetProffesionSkills()
    local professions = {}

    local i = 0
    while i < GetNumSkillLines() do
        local skillName, _, _, skillRank, skillTemp, skillModifier, skillMax = GetSkillLineInfo(i)
        if skillName ~= nil and GatheringProfessions[skillName] then
            professions[skillName] = {
                rank = skillRank,
                temp = skillTemp,
                modifier = skillModifier,
                max = skillMax
            }
        end
        i = i + 1
    end

    return professions
end

function GatherLevel:OnDisable()
    self:Print("disabled")
end

function GetNodeInfo(itemName)
    local item = Herbs[itemName]

    if item == nil then return nil end

    local color = Colors.yellow

    local herbalism = GetProffesionSkills()["Herbalism"]
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

