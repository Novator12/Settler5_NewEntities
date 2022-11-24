function HelgarBombSelection()
    GameCallback_GUI_SelectionChangedHelgarSel = GameCallback_GUI_SelectionChanged
    function GameCallback_GUI_SelectionChanged()
        GameCallback_GUI_SelectionChangedHelgarSel()
        local sel = GUI.GetSelectedEntity()
        if sel == GetID(trupp1) then
            XGUIEng.ShowWidget("Selection_HeroVet", 1)
        end
        XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)
    end
end


function BanditenSelection()
    GameCallback_GUI_SelectionChangedBanditen = GameCallback_GUI_SelectionChanged
    function GameCallback_GUI_SelectionChanged()
        GameCallback_GUI_SelectionChangedBanditen()
        local sel = GUI.GetSelectedEntity()
        local type = Logic.GetEntityTypeName(Logic.GetEntityType(sel))
        if type == "CU_BanditLeaderSword1" or type == "CU_BanditLeaderSword2" then
            local VideoName = "data\\graphics\\videos\\cu_banditleadersword1.bik"
                XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, VideoName, 1 )
        elseif type == "CU_BanditLeaderBow1" then
            local VideoName = "data\\graphics\\videos\\pu_leaderbow2.bik"
                XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, VideoName, 1 )
        elseif type == "CU_BanditLeaderBow2" then
            local VideoName = "data\\graphics\\videos\\pu_leaderbow3.bik"
                XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, VideoName, 1 )
        end
        XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)
    end
end



function CalvaryFormationSelection()
    GameCallback_GUI_SelectionChangedCalvary = GameCallback_GUI_SelectionChanged
    function GameCallback_GUI_SelectionChanged()
        GameCallback_GUI_SelectionChangedCalvary()
        local EntityId = GUI.GetSelectedEntity()
        if Logic.GetEntityTypeName(Logic.GetEntityType(EntityId)) == "PU_LeaderCavalry1" or
            Logic.GetEntityTypeName(Logic.GetEntityType(EntityId)) == "PU_LeaderCavalry2" or
            Logic.GetEntityTypeName(Logic.GetEntityType(EntityId)) == "PU_LeaderHeavyCavalry1" or
            Logic.GetEntityTypeName(Logic.GetEntityType(EntityId)) == "PU_LeaderHeavyCavalry2" then
            XGUIEng.ShowWidget(gvGUI_WidgetID.SelectionLeader, 1)
        end
        if Logic.GetEntityTypeName(Logic.GetEntityType(EntityId)) == "PU_BattleSerf" then
            XGUIEng.ShowWidget("Commands_Leader",1) -- battleserf formation fix
        end
    end
end

function IsHeroSelection()
    GameCallback_GUI_SelectionChangedIsHero = GameCallback_GUI_SelectionChanged
    function GameCallback_GUI_SelectionChanged()
        GameCallback_GUI_SelectionChangedIsHero()
        local EntityId = GUI.GetSelectedEntity()
        if Logic.IsHero(EntityId) == 1 then
            XGUIEng.DisableButton("Command_ExpelAll", 1)
        else
            XGUIEng.DisableButton("Command_ExpelAll", 0)
        end
        XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)
    end
end


function BarbarianHQSelection()
	GameCallback_GUI_SelectionChangedBarbarianCastle = GameCallback_GUI_SelectionChanged
    function GameCallback_GUI_SelectionChanged()
        GameCallback_GUI_SelectionChangedBarbarianCastle()
        local sel = GUI.GetSelectedEntity()
        local ty = Logic.GetEntityType(sel)
        if ty == Entities.CB_Barbarian_Castle1 then
            XGUIEng.ShowWidget("Selection_Building", 1)
            XGUIEng.ShowWidget("Headquarter", 1)
            XGUIEng.ShowWidget("Upgrade_BarbHeadquarter1", 1)
            XGUIEng.ShowWidget("Upgrade_BarbHeadquarter2", 0)
            XGUIEng.ShowWidget("Upgrade_Headquarter1", 0)
            XGUIEng.ShowWidget("Upgrade_Headquarter2", 0)
            local VideoName = "data\\graphics\\videos\\pb_headquarters1.bik"
                XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, VideoName, 1 )
        end
		if ty == Entities.CB_Barbarian_Castle2 then
            XGUIEng.ShowWidget("Selection_Building", 1)
            XGUIEng.ShowWidget("Headquarter", 1)
            XGUIEng.ShowWidget("Upgrade_BarbHeadquarter1", 0)
            XGUIEng.ShowWidget("Upgrade_BarbHeadquarter2", 1)
            XGUIEng.ShowWidget("Upgrade_Headquarter1", 0)
            XGUIEng.ShowWidget("Upgrade_Headquarter2", 0)
            local VideoName = "data\\graphics\\videos\\pb_headquarters2.bik"
                XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, VideoName, 1 )
        end
		if ty == Entities.CB_Barbarian_Castle3 then
            XGUIEng.ShowWidget("Selection_Building", 1)
            XGUIEng.ShowWidget("Headquarter", 1)
            XGUIEng.ShowWidget("Upgrade_BarbHeadquarter1", 0)
            XGUIEng.ShowWidget("Upgrade_BarbHeadquarter2", 0)
            XGUIEng.ShowWidget("Upgrade_Headquarter1", 0)
            XGUIEng.ShowWidget("Upgrade_Headquarter2", 0)
            local VideoName = "data\\graphics\\videos\\pb_headquarters3.bik"
                XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, VideoName, 1 )
        end
		XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)
    end
	function GUIAction_BuySerf()
        local BuildingID = GUI.GetSelectedEntity()
        if Logic.GetRemainingUpgradeTimeForBuilding(BuildingID ) ~= Logic.GetTotalUpgradeTimeForBuilding (BuildingID) then
            return
        end
        local PlayerID = GUI.GetPlayerID()
        
        local VCThreshold = Logic.GetLogicPropertiesMotivationThresholdVCLock()
        local AverageMotivation = Logic.GetAverageMotivation(PlayerID)
        
        if AverageMotivation < VCThreshold then
            GUI.AddNote(XGUIEng.GetStringTableText("InGameMessages/Note_VillageCentersAreClosed"))
            return
        end
        if Logic.GetTechnologyResearchedAtBuilding(BuildingID) ~= 0 then
            return
        end
        if Logic.GetPlayerAttractionUsage( PlayerID ) >= Logic.GetPlayerAttractionLimit( PlayerID ) then
            GUI.SendPopulationLimitReachedFeedbackEvent()
            return
        end
        
        Logic.FillSerfCostsTable( InterfaceGlobals.CostTable )
            
        if InterfaceTool_HasPlayerEnoughResources_Feedback( InterfaceGlobals.CostTable ) == 1 then
            --GUI.BuySerf(BuildingID)
            CppLogic.Entity.Building.HQBuySerf(BuildingID)
        end
    end
	GUIUpdate_GlobalTechnologiesButtonsBarbarianCastle=GUIUpdate_GlobalTechnologiesButtons
    function GUIUpdate_GlobalTechnologiesButtons(but, tech, btype)
        if btype == Entities.PB_Headquarters1 then
            btype = Entities.CB_Barbarian_Castle1
        end
        GUIUpdate_GlobalTechnologiesButtonsBarbarianCastle(but, tech, btype)
    end
end


function SignalFireSelection()
    GameCallback_GUI_SelectionChangedSignalFire = GameCallback_GUI_SelectionChanged
    function GameCallback_GUI_SelectionChanged()
        GameCallback_GUI_SelectionChangedSignalFire()
        local sel = GUI.GetSelectedEntity()
        local ty = Logic.GetEntityType(sel)
        if ty == Entities.CB_Signalfire_Base then
            XGUIEng.ShowWidget("SignalFire", 1)
            XGUIEng.ShowWidget("SignalFire_Pay", 1)
            local VideoName = "data\\graphics\\videos\\pb_tower1.bik"
                XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, VideoName, 1 )
        end
        XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)
    end
end



function VillageCenterBarbSelection()
    GameCallback_GUI_SelectionChangedVillageBarb = GameCallback_GUI_SelectionChanged
    function GameCallback_GUI_SelectionChanged()
        GameCallback_GUI_SelectionChangedVillageBarb()
        local sel = GUI.GetSelectedEntity()
        local ty = Logic.GetEntityType(sel)
        if ty == Entities.PB_VillageCenterBarbarian then
			if Logic.IsConstructionComplete(sel)==1 then -- ui nicht anzeigen, wenn gebäude im bau, musst du bei denanderen neuen gebäuden vermutlich auch machen
				XGUIEng.ShowWidget("VillageBarbarian", 1)
			end
            local VideoName = "data\\graphics\\videos\\pb_villagecenter1.bik"
                XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, VideoName, 1 )
        end
        XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)
    end
	BuildingPlacementRotation_GUIAction_PlaceBuilding = GUIAction_PlaceBuilding
	function GUIAction_PlaceBuilding(ucat)
		CppLogic.Logic.SetPlaceBuildingRotation(0)
		BuildingPlacementRotation_GUIAction_PlaceBuilding(ucat)
	end
end

function BarbTowerSelection()
    GameCallback_GUI_SelectionChangedBarbTower1 = GameCallback_GUI_SelectionChanged
    function GameCallback_GUI_SelectionChanged()
        GameCallback_GUI_SelectionChangedBarbTower1()
        local sel = GUI.GetSelectedEntity()
        local ty = Logic.GetEntityType(sel)
        if ty == Entities.PB_WatchTower_Barb then
			if Logic.IsConstructionComplete(sel)==1 then -- ui nicht anzeigen, wenn gebäude im bau, musst du bei denanderen neuen gebäuden vermutlich auch machen
				XGUIEng.ShowWidget("BarbTower", 1)
			end
            local VideoName = "data\\graphics\\videos\\pb_tower1.bik"
                XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, VideoName, 1 )
        end
        XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)
    end
end


function WoodMineSelection1()
    GameCallback_GUI_SelectionChangedWoodmine1 = GameCallback_GUI_SelectionChanged
    function GameCallback_GUI_SelectionChanged()
        GameCallback_GUI_SelectionChangedWoodmine1()
        local sel = GUI.GetSelectedEntity()
        local ty = Logic.GetEntityType(sel)
        if ty == Entities.PB_WoodMine1 then
			if Logic.IsConstructionComplete(sel)==1 then -- ui nicht anzeigen, wenn gebäude im bau, musst du bei denanderen neuen gebäuden vermutlich auch machen
				XGUIEng.ShowWidget("Woodmine", 1)
                XGUIEng.ShowWidget("Upgrade_Woodmine1", 1)
                XGUIEng.ShowWidget("WoodMineAmount", 1)
			end
            local VideoName = "data\\graphics\\videos\\pb_sawmill1.bik"
                XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, VideoName, 1 )
        end
        XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)
    end
end

function WoodMineSelection2()
    GameCallback_GUI_SelectionChangedWoodmine2 = GameCallback_GUI_SelectionChanged
    function GameCallback_GUI_SelectionChanged()
        GameCallback_GUI_SelectionChangedWoodmine2()
        local sel = GUI.GetSelectedEntity()
        local ty = Logic.GetEntityType(sel)
        if ty == Entities.PB_WoodMine2 then
			if Logic.IsConstructionComplete(sel)==1 then -- ui nicht anzeigen, wenn gebäude im bau, musst du bei denanderen neuen gebäuden vermutlich auch machen
				XGUIEng.ShowWidget("Woodmine", 1)
                XGUIEng.ShowWidget("Upgrade_Woodmine1", 0)
                XGUIEng.ShowWidget("Upgrade_Woodmine2", 1)
                XGUIEng.ShowWidget("WoodMineAmount", 1)
			end
            local VideoName = "data\\graphics\\videos\\pb_sawmill1.bik"
                XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, VideoName, 1 )
        end
        XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)
    end
end

function WoodMineSelection3()
    GameCallback_GUI_SelectionChangedWoodmine3 = GameCallback_GUI_SelectionChanged
    function GameCallback_GUI_SelectionChanged()
        GameCallback_GUI_SelectionChangedWoodmine3()
        local sel = GUI.GetSelectedEntity()
        local ty = Logic.GetEntityType(sel)
        if ty == Entities.PB_WoodMine3 then
			if Logic.IsConstructionComplete(sel)==1 then -- ui nicht anzeigen, wenn gebäude im bau, musst du bei denanderen neuen gebäuden vermutlich auch machen
				XGUIEng.ShowWidget("Woodmine", 1)
                XGUIEng.ShowWidget("Upgrade_Woodmine1", 0)
                XGUIEng.ShowWidget("Upgrade_Woodmine2", 0)
                XGUIEng.ShowWidget("WoodMineAmount", 1)
			end
            local VideoName = "data\\graphics\\videos\\pb_sawmill2.bik"
                XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, VideoName, 1 )
        end
        XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)
    end
end



function SerfSelection()
    GameCallback_GUI_SelectionChangedSerfSelection = GameCallback_GUI_SelectionChanged
    function GameCallback_GUI_SelectionChanged()
        GameCallback_GUI_SelectionChangedSerfSelection()
        local sel = GUI.GetSelectedEntity()
        if IsValid(sel) then
            local ty = Logic.GetEntityType(sel)
            if ty == Entities.PU_Serf then
                    XGUIEng.HighLightButton(gvGUI_WidgetID.ToSerfBeatificationMenu,1)	
                    XGUIEng.HighLightButton(XGUIEng.GetWidgetID("SerfToBarbarianMenu"),1)
            end
        end
    end
end

function BarbArenaSelection()
    GameCallback_GUI_SelectionChangedBarbArena = GameCallback_GUI_SelectionChanged
    function GameCallback_GUI_SelectionChanged()
        GameCallback_GUI_SelectionChangedBarbArena()
        local sel = GUI.GetSelectedEntity()
        local ty = Logic.GetEntityType(sel)
        if ty == Entities.CB_Barbarian_Arena then
			if Logic.IsConstructionComplete(sel)==1 then -- ui nicht anzeigen, wenn gebäude im bau, muss bei den anderen neuen gebäuden vermutlich auch gemacht werden
				XGUIEng.ShowWidget("BarbArena", 1)
			end
            local VideoName = "data\\graphics\\videos\\pb_stable1.bik"
                XGUIEng.StartVideoPlayback( gvGUI_WidgetID.VideoPreview, VideoName, 1 )
        end
        XGUIEng.DoManualButtonUpdate(gvGUI_WidgetID.InGame)
    end
end




function InitBuildingSelection()
    SerfSelection()
    BarbarianHQSelection() 
    SignalFireSelection() 
    VillageCenterBarbSelection()
    BarbTowerSelection()
    WoodMineSelection1()
    WoodMineSelection2()
    WoodMineSelection3()
    BarbArenaSelection()
    CalvaryFormationSelection()
    IsHeroSelection()
    BanditenSelection()
end