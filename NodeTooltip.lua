function FormatNodeInfo(skillInfo, nodeInfo)
    local color = Colors.yellow

    if nodeInfo.level.min > skillInfo.rank then
        color = Colors.red
    elseif nodeInfo.level.gray > skillInfo.rank then
        color = Colors.green
    elseif nodeInfo.level.gray <= skillInfo.rank then
        color = Colors.gray
    end

    return skillInfo.name .. " " .. nodeInfo.level.min .. "\nGray " .. nodeInfo.level.gray, color
end

function GetNodeInfo(nodeName)
    -- Herbs
    local herb = Herbs[nodeName]

    if herb ~= nil then
        local herbInfo = GatherLevel.professions["Herbalism"]
        if herbInfo == nil then return nil end

        return FormatNodeInfo(herbInfo, herb)
    end

    -- Mining nodes
    local miningNode = MiningNodes[nodeName]

    if miningNode ~= nil then
        local miningInfo = GatherLevel.professions["Mining"]
        if miningInfo == nil then return nil end

        return FormatNodeInfo(miningInfo, miningNode)
    end

    return nil
end

function ExpandTooltip(tooltip, tooltipText)
    local additionalText, color = GetNodeInfo(tooltipText)

    if additionalText == nil or color == nil then return end

    tooltip:AddLine("\n" .. additionalText, color.r, color.g, color.b)
end

