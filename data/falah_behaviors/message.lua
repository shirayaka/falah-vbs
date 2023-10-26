-- Copyright © 2019 Bohemia Interactive Simulations - support@BISimulations.com

-- @name message
-- @description Functions for processing external standard inputs

return {
    ["message"] = {

        -- @description Generic function for making list of receivers based on some specified tags in orderData
        -- @argument orderData [orderData] generic table which defines the order
        ["MakeListOfReceivers"] = function(orderData)
            local receivers = {}

            if (orderData.reportCompletedToParent) then
                receivers[#receivers + 1] = self:GetParentGroup()
            end

            if (orderData.reportCompletedToExternal) then
                receivers[#receivers + 1] = Message.External
            end

            if (orderData.reportCompletedToCustomList ~= nil) then
                for i=1, #orderData.reportCompletedToCustomList do
                    receivers[#receivers + 1] = orderData.reportCompletedToCustomList[i]
                end
            end

            return receivers
        end,

        -- @description Generic function for reporting completition of the order to the list of receivers
        -- @argument receivers [array] brains which should be informed about completetion
        -- @argument orderData [table] usually arg.orderData
        ["ReportOrderCompleted"] = function(receivers, orderData)
            for i=1, #receivers do
                local thisReceiver = receivers[i]
                self:SendMessage(
                    thisReceiver,
                    "OrderCompleted",
                    {
                        originalOrderData = orderData.originalOrderData,
                    }
                )
            end
        end,

        -- @description Generic function for reporting order cannot be completed to the list of receivers
        -- @argument receivers [array] brains which should be informed about completetion
        -- @argument orderData [table] usually arg.orderData
        ["ReportOrderUnableToDo"] = function(receivers, orderData)
            for i=1, #receivers do
                local thisReceiver = receivers[i]
                self:SendMessage(
                    thisReceiver,
                    "OrderCompleted",
                    {
                        originalOrderData = orderData.originalOrderData,
                    }
                )
                self:SendMessage(
                    thisReceiver,
                    "vbsCon_Report",
                    orderData
                )
            end
        end,

        -- @description Update formation trigger
        -- @argument orderData [table] arg.orderData
        -- @argument element [reference|optional] element we would like to request
        -- @return updateNeeded [bool] 
        ["RequestFormationUpdate"] = function(orderData, element, fallbackBtset)
            if element == nil then element = self:GetParentGroup() end
            if fallbackBtset == nil then fallbackBtset = "generic_team" end -- XXX remove hardcoded later
            self:SendMessage(
                element,
                "SensorSetValue",
                {
                    fallbackBtset = fallbackBtset,
                    sensorKey = "FormationUpdate", -- XXX remove hardcoded later, take from orderData.originalOrderData.parentOrderData.sensors
                    sensorValue = true,
                }
            )
        end,   
        
        -- @description Generic function for sending order to your subordinates
        -- @argument receiver [brain] entity or group brain reference
        -- @argument btset [string] name of the btset
        -- @argument behaviorName [string] name of the behavior from list of generic behaviors
        -- @argument behaviorParameters [table] mandatory params assgined to given behaviorName
        -- @argument parentOrderData [table] just copy for children to see what was order context from parent perspective
        -- @argument presetName [string|optional] name of the preset, if no preset passed, "default" is taken
        -- @argument overrides [table|optional] ONLY FOR DEVELOPERS, overriding internal parameters of given btset and its presets
        ["SendOrder"] = function(receiver, btset, orderName, orderParameters, parentOrderData, presetName, overrides)
            self:SendMessage(
                receiver,
                "NewOrder",
                tableExt.Extend(
                    {},
                    {
                        btset = btset,
                        orderName = orderName,
                        orderParameters = orderParameters,
                        parentOrderData = parentOrderData,
                        presetName = presetName,
                        overrides = overrides,
                    },
                    orderParameters
                )
            )
            -- debug.Log(self, receiver, orderName, orderParameters)
        end,
        
        -- @description Debugging function allowing you to store all messages received in given frame
        -- @argument storage [table] where we store the messages and information about time
        -- @argument message [table] new incomming message
        ["StoreLastMessage"] = function(storage, message)
            if storage == nil then
                 return {
                    time = GetSimulationTime(),
                    listOfMessages = {
                        message
                    },
                }
            elseif storage.time ~= GetSimulationTime() then
                return {
                    time = GetSimulationTime(),
                    listOfMessages = {
                        message
                    },
                }
            else
                storage.listOfMessages[#storage.listOfMessages+1] = message
                return storage
            end
        end,

        -- @description Generic function for receiving completition of the order
        -- @argument fullMsg [table] full message
        -- @argument selector [function(key,value)] predicate function that verifies it was received proper confirmation message
        ["ValidateOrderCompleted"] = function(fullMsg, orderName)
            if fullMsg.subject == "OrderCompleted" then
                -- DebugLog("me: " .. self .. " sender: " .. fullMsg.sender .. " - " .. fullMsg.value.originalOrderData.behaviorName .. " =?= " .. behaviorName)
                return fullMsg.value.originalOrderData.orderName == orderName
            end

            DebugLog("[ERROR][message.ValidateOrderCompleted] Subject 'OrderCompleted' is not defined in this MessageHanlder node.")
            return false
        end,
    },
}