AceGUI = LibStub("AceGUI-3.0")

function PromptNodeDataCollection(GL, itemName)
    local herb = Herbs[itemName]
    if herb ~= nil then
        local herbInfo = GatherLevel.professions[Professions.Herbalism]
        local expectedColor = GetNodeColorName(herbInfo, herb)
        OpenInfoBox(GL, Professions.Herbalism, herbInfo.rank, itemName, expectedColor)
        return
    end

    local mineNode = MiningNodes[itemName]
    if mineNode ~= nil then
        local miningInfo = GatherLevel.professions[Professions.Mining]
        local expectedColor = GetNodeColorName(miningInfo, mineNode)
        OpenInfoBox(GL, Professions.Mining, miningInfo.rank, itemName, expectedColor)
    end
end

function OpenInfoBox(GL, profession, professionLevel, itemName, expectedColor)
    local frame = AceGUI:Create("Frame")
    frame:SetTitle("GatherLevel Data Collection")
    frame:SetStatusText(profession)
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    frame:SetLayout("List")
    frame:SetHeight(250)
    frame:SetWidth(250)

    local label = AceGUI:Create("Label")
    label:SetText("You looted: " .. itemName .. "\nWhich should be " .. expectedColor .."\n\nPress the actual level:")
    frame:AddChild(label)

    for _, color in pairs(ColorNames) do
        local colorBtn = AceGUI:Create("Button")
        colorBtn:SetText(color)
        colorBtn:SetCallback("OnClick", function() SaveNodeInfo(GL, profession, professionLevel, itemName, color)  end)
        frame:AddChild(colorBtn)
    end
end

function SaveNodeInfo(GL, profession, professionLevel, itemName, levelColor)
    GL:Print("should save: " .. profession .. "." .. itemName .. "=" .. levelColor .. " at " .. tostring(professionLevel))
    -- TODO: implement
end
