-- Fetch profession skill level of trained gathering professions
function FetchProfessionSkills()
    local numSkillLines = GetNumSkillLines()

    for i=0,numSkillLines do
        local skillName, _, _, skillRank, skillTemp, skillModifier, skillMax = GetSkillLineInfo(i)

        if skillName ~= nil and IsGatheringProfession[skillName] then
            GatherLevel.professions[skillName] = {
                name = skillName,
                rank = skillRank,
                temp = skillTemp,
                modifier = skillModifier,
                max = skillMax
            }
        end
    end
end

-- Set profession skill level to new value
function SetProfessionRank(professionName, newRank)
    if professionName == nil then
        return
    end

    local profession = GatherLevel.professions[professionName]

    if profession == nil then
        return
    end

    profession.rank = newRank
end

