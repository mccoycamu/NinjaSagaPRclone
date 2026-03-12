// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.SMissionMap

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.MissionLibrary;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.StatManager;
    import Storage.EnemyInfo;
    import com.adobe.crypto.CUCSG;
    import Combat.BattleManager;
    import Combat.BattleVars;
    import Managers.OutfitManager;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class SMissionMap extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var response:Object;
        private var buyType:String;
        private var refillType:String;
        private var amount:int = 1;
        private var price:int;
        private var cost:int = 0;
        private var gradeS:Array = MissionLibrary.getMissionIds("s");
        private var enemies:Object = {"stage1":["ene_440", "ene_441", "ene_442", "ene_443", "ene_444"]};
        private var selectedStage:int;
        private var selectedMission:*;
        private var currentStage:int;
        private var energyUsage:Array = [10, 12, 14, 16, 25];

        public function SMissionMap(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.main.handleVillageHUDVisibility(false);
            this.setFrameScript();
            this.getData();
            this.initButton();
        }

        private function setFrameScript():void
        {
            this.panelMC.getHeartPopup.addFrameScript(0, this.stopAnimation, 7, this.onShowPopupGetHeart, 16, this.stopAnimation, 29, this.backToIdle);
            this.panelMC.energyBuyPopup.addFrameScript(0, this.stopAnimation, 8, this.onShowPopupRefill, 14, this.stopAnimation, 24, this.backToIdle, 35, this.backToIdle);
            this.panelMC.popupTreasure.addFrameScript(0, this.stopAnimation, 8, this.onShowPopupBattle, 15, this.stopAnimation, 28, this.backToIdle);
            this.panelMC.getHeartPopup.gotoAndStop(1);
            this.panelMC.energyBuyPopup.gotoAndStop(1);
            this.panelMC.popupTreasure.gotoAndStop(1);
        }

        private function stopAnimation():void
        {
            this.panelMC.getHeartPopup.stop();
            this.panelMC.energyBuyPopup.stop();
            this.panelMC.popupTreasure.stop();
        }

        private function backToIdle():void
        {
            this.panelMC.getHeartPopup.gotoAndStop(1);
            this.panelMC.energyBuyPopup.gotoAndStop(1);
            this.panelMC.popupTreasure.gotoAndStop(1);
        }

        private function getData():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("BattleSystem.getMissionSData", [Character.char_id, Character.sessionkey], this.onGetMissionData);
        }

        private function onGetMissionData(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.currentStage = _arg_1.stage;
                this.initUI();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                    this.destroy();
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function initUI():*
        {
            var _local_2:*;
            this.panelMC.goldTxt.text = Character.character_gold;
            this.panelMC.tokenTxt.text = Character.account_tokens;
            this.panelMC.energyTxt.text = ((this.response.energy + "/") + this.response.max_energy);
            var _local_1:* = 0;
            while (_local_1 < 5)
            {
                _local_2 = (_local_1 + (0 * 5));
                this.panelMC[("btnMission" + _local_1)].visible = false;
                if (this.currentStage > _local_2)
                {
                    this.panelMC[("btnMission" + _local_1)].visible = true;
                    this.main.initButton(this.panelMC[("btnMission" + _local_1)], this.openPopup, "");
                };
                _local_1++;
            };
        }

        public function onShowPopupBattle():*
        {
            var _local_1:* = this.panelMC.popupTreasure.panel;
            var _local_2:* = MissionLibrary.getMissionInfo(this.gradeS[this.selectedStage]);
            this.selectedMission = _local_2;
            _local_1.detailTitletxt.text = _local_2["msn_name"];
            _local_1.storydetailtxt.text = _local_2["msn_description"];
            _local_1.wintxt.text = "Winning Condition: Defeat All Enemies";
            _local_1.losetxt.text = "Losing Condition: Player is Defeated";
            _local_1.warningtxt.text = ("Minumum Requirement: Level " + _local_2["msn_level"]);
            _local_1.detailgoldtxt.text = _local_2["msn_rewards"].gold;
            _local_1.detailxptxt.text = _local_2["msn_rewards"].xp;
            (Character.character_recruit_ids.length + "/2");
            _local_1.teammembertxt.text = (Character.character_recruit_ids.length + "/2");
            _local_1.goBattleBtn.txt2.text = ("-" + this.energyUsage[this.selectedStage]);
            this.main.initButton(_local_1.goBattleBtn, this.startMission, "Battle");
            this.eventHandler.addListener(_local_1.btnClose, MouseEvent.CLICK, this.closeBattle);
        }

        private function startMission(_arg_1:MouseEvent):*
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            if (this.selectedMission["msn_level"] > int(Character.character_lvl))
            {
                this.main.showMessage("Level too low!");
                return;
            };
            Character.mission_level = int(this.selectedMission["msn_level"]);
            Character.mission_id = this.selectedMission["msn_id"];
            Character.stage_grade_s_mission = (this.selectedStage + 1);
            if (int(Character.character_lvl) >= int(this.selectedMission["msn_level"]))
            {
                _local_2 = "";
                _local_3 = "";
                _local_4 = StatManager.calculate_stats_with_data("agility", Character.character_lvl, Character.atrrib_earth, Character.atrrib_water, Character.atrrib_wind, Character.atrrib_lightning);
                _local_5 = 0;
                while (_local_5 < this.selectedMission["msn_enemy"].length)
                {
                    _local_7 = EnemyInfo.getEnemyStats(this.selectedMission["msn_enemy"][_local_5]);
                    if (_local_2 == "")
                    {
                        _local_2 = this.selectedMission["msn_enemy"][_local_5];
                        _local_3 = ((((("id:" + _local_7["enemy_id"]) + "|hp:") + _local_7["enemy_hp"]) + "|agility:") + _local_7["enemy_agility"]);
                    }
                    else
                    {
                        _local_2 = ((_local_2 + ",") + this.selectedMission["msn_enemy"][_local_5]);
                        _local_3 = ((((((_local_3 + "#id:") + _local_7["enemy_id"]) + "|hp:") + _local_7["enemy_hp"]) + "|agility:") + _local_7["enemy_agility"]);
                    };
                    _local_5++;
                };
                this.main.loading(true);
                _local_6 = CUCSG.hash(((_local_2 + _local_3) + _local_4));
                this.main.amf_manager.service("BattleSystem.startMission", [Character.char_id, Character.mission_id, _local_2, _local_3, _local_4, _local_6, Character.sessionkey, Character.stage_grade_s_mission], this.onStartMissionAmf);
            };
        }

        private function onStartMissionAmf(_arg_1:Object):*
        {
            var _local_4:int;
            var _local_5:Array;
            var _local_6:int;
            this.main.loading(false);
            if (_arg_1.length != 10)
            {
                this.main.showMessage("Not enough energy to enter this mission");
                return;
            };
            Character.is_hunting_house = false;
            Character.battle_code = _arg_1;
            var _local_2:Array = [];
            var _local_3:int;
            if ((this.selectedStage + 1) == 1)
            {
                this.main.combat = this.main.loadPanel("Combat.Battle", true);
                BattleManager.init(this.main.combat, this.main, BattleVars.MISSION_MATCH, this.selectedMission["msn_bg"]);
                BattleManager.addPlayerToTeam("player", ("char_" + Character.char_id));
                _local_3 = 0;
                while (_local_3 < 3)
                {
                    _local_4 = Math.floor((Math.random() * this.enemies[("stage" + (this.selectedStage + 1))].length));
                    _local_2.push(this.enemies[("stage" + (this.selectedStage + 1))][_local_4]);
                    this.enemies[("stage" + (this.selectedStage + 1))].splice(_local_4, 1);
                    _local_3++;
                };
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    BattleManager.addPlayerToTeam("enemy", _local_2[_local_3]);
                    _local_3++;
                };
                BattleManager.startBattle();
            }
            else
            {
                if ((this.selectedStage + 1) == 2)
                {
                    _local_5 = ["ene_445", "ene_446", "ene_447"];
                    _local_3 = 0;
                    while (_local_3 < 3)
                    {
                        _local_6 = 0;
                        while (_local_6 < _local_5.length)
                        {
                            _local_4 = int(Math.floor((Math.random() * _local_5.length)));
                            _local_2.push(_local_5[_local_4]);
                            _local_6++;
                        };
                        this.main.grade_s_battle_enemies[_local_3] = _local_2;
                        _local_2 = [];
                        _local_3++;
                    };
                    this.main.grade_s_battle_counter = 0;
                    this.main.startGradeSBattle(this.main.grade_s_battle_counter);
                }
                else
                {
                    if ((this.selectedStage + 1) == 3)
                    {
                        this.main.ambushBattleData = {
                            "random_enemy":["ene_448", "ene_449", "ene_450"],
                            "final_enemy":["ene_448", "ene_449", "ene_450"],
                            "current_engagement":0,
                            "min_engagement":3,
                            "max_engagement":6
                        };
                        OutfitManager.removeChildsFromMovieClips(this.main.loader);
                        this.main.loadAmbushBattle();
                    }
                    else
                    {
                        if ((this.selectedStage + 1) == 4)
                        {
                            this.main.is_grade_s_stage_4 = true;
                            this.main.grade_s_battle_counter = 0;
                            this.main.loadStage4GradeS();
                        }
                        else
                        {
                            if ((this.selectedStage + 1) == 5)
                            {
                                this.main.is_grade_s_stage_5 = true;
                                this.main.grade_s_battle_counter = 0;
                                this.main.loadStage5GradeS();
                            };
                        };
                    };
                };
            };
            this.destroy();
        }

        public function onShowPopupRefill():*
        {
            var _local_1:* = this.panelMC.energyBuyPopup.panel;
            this.main.initButton(_local_1.useRefillAllBtn, this.useRefill, "USE");
            this.main.initButton(_local_1.useRefillFiveBtn, this.useRefill, "USE");
            this.main.initButton(_local_1.buyFullBtn, this.openPopup, "50");
            this.main.initButton(_local_1.buyFiveBtn, this.openPopup, "15");
            _local_1.detailMc0.ownedFiveNumTxt.text = this.response.materials.material_899;
            _local_1.detailMc0.ownedAllNumTxt.text = this.response.materials.material_900;
            this.eventHandler.addListener(_local_1.btnClose, MouseEvent.CLICK, this.closeRefill);
        }

        public function useRefill(_arg_1:MouseEvent):*
        {
            this.refillType = ((_arg_1.currentTarget.name == "useRefillAllBtn") ? "material_900" : "material_899");
            this.main.loading(false);
            this.main.amf_manager.service("BattleSystem.refillRamenMissionS", [Character.char_id, Character.sessionkey, this.refillType], this.onUseRefill);
        }

        public function onUseRefill(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                Character.removeMaterials(this.refillType, 1);
                this.panelMC.energyBuyPopup.panel.detailMc0.ownedFiveNumTxt.text = _arg_1.materials.material_899;
                this.panelMC.energyBuyPopup.panel.detailMc0.ownedAllNumTxt.text = _arg_1.materials.material_900;
                this.panelMC.energyTxt.text = ((_arg_1.energy + "/") + this.response.max_energy);
                this.main.HUD.setBasicData();
                this.main.showMessage(_arg_1.result);
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        public function onShowPopupGetHeart():*
        {
            var _local_1:* = this.panelMC.getHeartPopup.panel;
            _local_1.fullIcon.visible = false;
            _local_1.fiveIcon.visible = false;
            if (this.buyType == "material_900")
            {
                this.price = 50;
                _local_1.fullIcon.visible = true;
            }
            else
            {
                this.price = 15;
                _local_1.fiveIcon.visible = true;
            };
            this.main.initButton(_local_1.buyBtn, this.buyRamen, "Buy");
            this.cost = (this.price * this.amount);
            _local_1.amountTxt.text = this.amount;
            _local_1.tokenTxt.text = this.cost;
            this.eventHandler.addListener(_local_1.btnNextPage, MouseEvent.CLICK, this.changeAmount);
            this.eventHandler.addListener(_local_1.btnPrevPage, MouseEvent.CLICK, this.changeAmount);
            this.eventHandler.addListener(_local_1.btnClose, MouseEvent.CLICK, this.closeBuyRamen);
        }

        private function changeAmount(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name;
            var _local_3:* = this.panelMC.getHeartPopup.panel;
            if (((this.amount <= 1) && (!(_local_2 == "btnNextPage"))))
            {
                return;
            };
            if (_local_2 == "btnNextPage")
            {
                this.amount = (this.amount + 1);
            }
            else
            {
                this.amount--;
            };
            this.cost = (this.price * this.amount);
            _local_3.amountTxt.text = this.amount;
            _local_3.tokenTxt.text = this.cost;
            this.main.initButton(_local_3.buyBtn, this.buyRamen, "Buy");
        }

        private function buyRamen(_arg_1:MouseEvent):*
        {
            this.main.loading(false);
            this.main.amf_manager.service("BattleSystem.buyRamenMissionS", [Character.char_id, Character.sessionkey, this.buyType, this.amount], this.onBuyRamen);
        }

        private function onBuyRamen(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                Character.addMaterials(this.buyType, this.amount);
                Character.account_tokens = (Character.account_tokens - this.cost);
                this.panelMC.energyBuyPopup.panel.detailMc0.ownedFiveNumTxt.text = _arg_1.materials.material_899;
                this.panelMC.energyBuyPopup.panel.detailMc0.ownedAllNumTxt.text = _arg_1.materials.material_900;
                this.main.HUD.setBasicData();
                this.main.showMessage((this.amount + " Ramen bought!"));
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function closeBuyRamen(_arg_1:MouseEvent):*
        {
            this.panelMC.getHeartPopup.gotoAndPlay(18);
            this.amount = 1;
            this.price = 0;
            this.cost = 0;
        }

        private function closeRefill(_arg_1:MouseEvent):*
        {
            this.panelMC.energyBuyPopup.gotoAndPlay("exit");
        }

        private function closeBattle(_arg_1:MouseEvent):*
        {
            this.panelMC.popupTreasure.gotoAndPlay("exit");
        }

        private function initButton():*
        {
            this.main.initButton(this.panelMC.energyBtn, this.openPopup, "");
            this.main.initButton(this.panelMC.convertBtn, this.openPopup, "");
            this.main.initButton(this.panelMC.getMoreBtn, this.openPopup, "");
            this.eventHandler.addListener(this.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btnSpin, MouseEvent.CLICK, this.openPopup);
        }

        private function openPopup(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "energyBtn":
                    this.panelMC.energyBuyPopup.gotoAndPlay(2);
                    return;
                case "convertBtn":
                    this.main.loadPanel("Panels.Recharge");
                    return;
                case "getMoreBtn":
                    this.main.loadPanel("Panels.Recharge");
                    return;
                case "buyFullBtn":
                    this.buyType = "material_900";
                    this.panelMC.getHeartPopup.gotoAndPlay(2);
                    return;
                case "buyFiveBtn":
                    this.buyType = "material_899";
                    this.panelMC.getHeartPopup.gotoAndPlay(2);
                    return;
                case "btnSpin":
                    this.main.loadExternalSwfPanel("SpinMission", "SpinMission");
                    return;
                case "btnMission0":
                    this.selectedStage = 0;
                    this.panelMC.popupTreasure.gotoAndPlay(2);
                    return;
                case "btnMission1":
                    this.selectedStage = 1;
                    this.panelMC.popupTreasure.gotoAndPlay(2);
                    return;
                case "btnMission2":
                    this.selectedStage = 2;
                    this.panelMC.popupTreasure.gotoAndPlay(2);
                    return;
                case "btnMission3":
                    this.selectedStage = 3;
                    this.panelMC.popupTreasure.gotoAndPlay(2);
                    return;
                case "btnMission4":
                    this.selectedStage = 4;
                    this.panelMC.popupTreasure.gotoAndPlay(2);
                    return;
            };
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():*
        {
            this.main.handleVillageHUDVisibility(true);
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            this.gradeS = [];
            this.main = null;
            this.eventHandler = null;
            this.response = null;
            this.enemies = null;
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

