function InitalizeBarbTower()    --Call in FMA
    PresetBarbTower()
end




function PresetBarbTower() 
    GameCallback_OnBuildingUpgradeCompleteBarbTower = GameCallback_OnBuildingUpgradeComplete
    function GameCallback_OnBuildingUpgradeComplete(_OldID, _NewID)
        GameCallback_OnBuildingUpgradeCompleteBarbTower(_OldID, _NewID)
            local upID = _NewID
        if Logic.GetEntityTypeName(Logic.GetEntityType(_NewID)) == "PB_WatchTower_Barb2" then
            local barbTower = {}
            local posX, posY = Logic.GetEntityPosition(upID)
            local ori = Logic.GetEntityOrientation(upID)
            local player = Logic.EntityGetPlayer(upID)
            local missle1 = Logic.CreateEntity(Entities.PB_Missle1, posX, posY, ori, player)
            local missle2 = Logic.CreateEntity(Entities.PB_Missle2, posX, posY, ori, player)
            CppLogic.EntityType.RemoveEntityCategory(Entities.PB_Missle1, EntityCategories.TargetFilter_TargetType)
            CppLogic.EntityType.RemoveEntityCategory(Entities.PB_Missle2, EntityCategories.TargetFilter_TargetType)
            SetInvisibility(missle1, true)
            SetInvisibility(missle2, true)
            table.insert(barbTower,upID)
            table.insert(barbTower, missle1)
            table.insert(barbTower, missle2)
            local jobID = Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_TURN, "", "CheckTowerExisting", 1, {}, barbTower)
        end
    end
end


function CheckTowerExisting(...)
    local _barbTower = arg;
    if IsDead(_barbTower[1]) then
        DestroyEntity(_barbTower[2])
        DestroyEntity(_barbTower[3])
        _barbTower= nil
        return true;
    end
end


--- author:schmeling65		current maintainer:schmeling65		v0.1a
-- Macht Entities unsichtbar bzw. sichtbar basierend auf den EntityScripting-Values
-- 
-- id entweder EntityID oder Skriptname als String
-- flag true oder false: 	true -> unsichtbar
-- false -> sichtbar

function SetInvisibility(id, flag)
	if HistoryFlag == nil then
		if XNetwork.Manager_IsNATReady then
			HistoryFlag = 1
		else
			HistoryFlag = 0
		end
	end

	local idtemp
	if type(id) == "number" then
		idtemp = id
	end
	if type(id) == "string" then
		idtemp = Logic.GetEntityIDByName(id)
	end

	if flag then
		if HistoryFlag == 1 then
			Logic.SetEntityScriptingValue(idtemp, -26, 513)
		elseif HistoryFlag == 0 then
			Logic.SetEntityScriptingValue(idtemp, -30, 513)
		end
	else
		if HistoryFlag == 1 then
			Logic.SetEntityScriptingValue(idtemp, -26, 65793)
		elseif HistoryFlag == 0 then
			Logic.SetEntityScriptingValue(idtemp, -30, 65793)
		end
	end
end