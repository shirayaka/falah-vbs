-- Copyright © 2019 Bohemia Interactive Simulations - support@BISimulations.com

-- @name orbat
-- @description Functions for table operations

return {
    ["orbat"] = {
        -- @description Return children entities references on given orbat level
        -- @argument inputOrbat [table|optional] if no table given, using current level of orbat from given call context
        -- @argument selector [function|optional] extra condition selection subset of children
        -- @argument skipValidation [bool|optional] shall we skip validity check on selected values
        -- @return childElements [array] list of entities
        ["GetChildElements"] = function(inputOrbat, selector, skipValidation)
            local childElements = {}
            local childElementsData = {}
            local childElementsAll = {}
            if skipValidation == nil then skipValidation = false end
            if inputOrbat ~= nil then -- use input orbat primarly
                 for i=1, #inputOrbat.children do
                    childElementsData[#childElementsData + 1] = inputOrbat.children[i] 
                end
            elseif bb.orbat ~= nil then -- direct access to current level in bb.orbat
                for i=1, #bb.orbat.children do
                    childElementsData[#childElementsData + 1] = bb.orbat.children[i] 
                end
            else -- fallback generating children list using standard API
                if self.GetEntities ~= nil then
                    for member in self:GetEntities() do childElementsAll[#childElementsAll + 1] = member end
                else
                    for member in self:GetChildGroups() do childElementsAll[#childElementsAll + 1] = member end
                end
            end
            
            if #childElementsData > 0 then 
                for i=1, #childElementsData do
                    local child = childElementsData[i]
                    if selector == nil or selector(child) then
                        if orbat.IsAliveAndValid(child.reference) or skipValidation then
                            childElements[#childElements + 1] = child.reference
                        end
                    end
                end
            else
                for i=1, #childElementsAll do
                    local child = childElementsAll[i]
                    if selector == nil or selector(child) then
                        if orbat.IsAliveAndValid(child) or skipValidation then
                            childElements[#childElements + 1] = child
                        end
                    end
                end
            end
            return childElements
        end,

        -- @description Return if given element IsAlive and Valid
        -- @argument element [reference|optional] entity/group reference
        -- @return [bool] IsAliveAndValid
        ["IsAliveAndValid"] = function(element)
            if element ~= nil then
                if element:Valid() then
                    if element:IsAlive() then
                        return true
                    end
                end
            end
            return false
        end,

        -- @description Reorder formation based on available soldiers
        -- @argument listOfChildElements [array] all alive entities in group from bb.orbat
        -- @argument pointman [entity] point unit
        -- @return newOrder [array] of entities
        ["Reorder"] = function(listOfChildElements, pointman)
            local newOrder = {
                [1] = pointman
            }
            for i=1, #listOfChildElements do
                local childElement = listOfChildElements[i]
                if childElement ~= pointman then
                    newOrder[#newOrder + 1] = childElement
                end
            end

            self:SetChildOrder(newOrder)
            return newOrder
        end,
    },
}