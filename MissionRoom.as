// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.MissionRoom

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.MissionLibrary;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.OutfitManager;
    import flash.utils.setTimeout;
    import com.utils.GF;
    import Managers.NinjaSage;
    import Storage.NpcInfo;
    import Managers.StatManager;
    import Storage.EnemyInfo;
    import com.adobe.crypto.CUCSG;
    import Combat.BattleManager;
    import Combat.BattleVars;
    import br.com.stimuli.loading.BulkLoader;
    import flash.system.System;

    public dynamic class MissionRoom extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var response:Object;
        private var recruitCounter:int = 0;
        private var recruitArray:Array;
        private var selectedCategory:Array;
        private var selectedMission:*;
        private var titleScroll:String;
        private var currentPage:int = 1;
        private var totalPage:int = 1;
        private var currentTab:String = "story";

        public var outfits:Array = [];
        private var gradeC:Array = MissionLibrary.getMissionIds("c");
        private var gradeB:Array = MissionLibrary.getMissionIds("b");
        private var gradeA:Array = MissionLibrary.getMissionIds("a");
        private var gradeS:Array = MissionLibrary.getMissionIds("s");
        private var gradeSS:Array = MissionLibrary.getMissionIds("ss");
        private var gradeTP:Array = MissionLibrary.getMissionIds("tp");
        private var gradeSpecial:Array = MissionLibrary.getMissionIds("special");
        private var gradeDaily:Array = MissionLibrary.getMissionIds("daily");

        public function MissionRoom(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.main.handleVillageHUDVisibility(false);
            this.panelMC.missionPanel.addFrameScript(0, this.onGradeList, 3, this.stopMissionPanel, 12, this.onMissionList, 16, this.stopMissionPanel);
            this.panelMC.missionPanel.story.gotoAndStop("select");
            this.panelMC.missionPanel.other.gotoAndStop("unselect");
            this.setFrameOne();
            this.getMissionData();
            this.initButton();
            this.initBasicUI();
        }

        private function setFrameOne():void
        {
            var _local_1:MovieClip = this.panelMC.missionPanel;
            _local_1.menu1.btnGrade_s.gotoAndStop(1);
            _local_1.menu1.btnGrade_a.gotoAndStop(1);
            _local_1.menu1.btnGrade_b.gotoAndStop(1);
            _local_1.menu1.btnGrade_c.gotoAndStop(1);
            _local_1.menu2.btnGrade_special.gotoAndStop(1);
            _local_1.menu2.btnGrade_daily.gotoAndStop(1);
            _local_1.menu2.btnGrade_tp.gotoAndStop(1);
            _local_1.menu2.btnGrade_ss.gotoAndStop(1);
        }

        private function initBasicUI():void
        {
            this.panelMC.recruitPanel.gotoAndStop(1);
            var _local_1:int;
            while (_local_1 < 3)
            {
                this.panelMC.recruitPanel[("recruit" + _local_1)].charLevelMC.visible = false;
                this.panelMC.recruitPanel[("recruit" + _local_1)].rankIcon.visible = false;
                this.panelMC.recruitPanel[("recruit" + _local_1)].emblemIcon.visible = false;
                this.panelMC.recruitPanel[("recruit" + _local_1)].charMc.visible = false;
                _local_1++;
            };
            if (Character.character_recruit_ids.length > 0)
            {
                this.panelMC.btn_removeRecruit.visible = true;
                this.eventHandler.addListener(this.panelMC.btn_removeRecruit, MouseEvent.CLICK, this.removeRecruitedSquad);
            }
            else
            {
                this.panelMC.btn_removeRecruit.visible = false;
            };
            this.panelMC.tokenTxt.text = String(Character.account_tokens);
            this.main.initButton(this.panelMC.getMoreBtn, this.openRecharge, "");
        }

        private function getMissionData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.getMissionRoomData", [Character.char_id, Character.sessionkey], this.onGetMissionData);
        }

        private function onGetMissionData(_arg_1:Object):void
        {
            var _local_2:int;
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.recruitArray = [("char_" + Character.char_id)];
                _local_2 = 0;
                while (_local_2 < this.response.recruit.length)
                {
                    if (this.response.recruit[_local_2].type == "char")
                    {
                        this.recruitArray.push(((this.response.recruit[_local_2].type + "_") + this.response.recruit[_local_2].id));
                    }
                    else
                    {
                        this.recruitArray.push(this.response.recruit[_local_2].id.recruiter_id);
                    };
                    _local_2++;
                };
                this.initRecruitUI();
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

        public function initRecruitUI():void
        {
            if (this.recruitCounter < this.recruitArray.length)
            {
                if (this.recruitArray[this.recruitCounter].indexOf("char_") >= 0)
                {
                    this.loadPlayerCharacter();
                }
                else
                {
                    this.loadNpcCharacter();
                };
                return;
            };
            this.main.loading(false);
        }

        private function loadPlayerCharacter():void
        {
            var _local_3:Object;
            var _local_4:Object;
            var _local_1:OutfitManager = new OutfitManager();
            var _local_2:int = 1;
            while (_local_2 < 4)
            {
                this.panelMC.recruitPanel["recruit0"][("skillBtn" + _local_2)].gotoAndStop(1);
                this.panelMC.recruitPanel["recruit1"][("skillBtn" + _local_2)].gotoAndStop(1);
                this.panelMC.recruitPanel["recruit2"][("skillBtn" + _local_2)].gotoAndStop(1);
                _local_2++;
            };
            if (Character.char_id == this.recruitArray[this.recruitCounter].split("_")[1])
            {
                if (!Character.is_stickman)
                {
                    _local_1.fillOutfit(this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].charMc, Character.character_weapon, Character.character_back_item, Character.character_set, Character.character_hair, Character.character_face, Character.character_color_hair, Character.character_color_skin);
                };
                this.outfits.push(_local_1);
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].charMc.visible = true;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].noPlayer.visible = false;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].recruitTeam.visible = false;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].charLevelMC.visible = true;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].rankIcon.visible = true;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].emblemIcon.visible = (Character.account_type == 1);
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].char_name.text = Character.character_name;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].charLevelMC.levelTxt.text = Character.character_lvl;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].rankIcon.gotoAndStop(Character.character_rank);
                _local_2 = 1;
                while (_local_2 < 4)
                {
                    this.panelMC.recruitPanel["recruit0"][("skillBtn" + _local_2)].gotoAndStop(1);
                    this.panelMC.recruitPanel["recruit1"][("skillBtn" + _local_2)].gotoAndStop(1);
                    this.panelMC.recruitPanel["recruit2"][("skillBtn" + _local_2)].gotoAndStop(1);
                    this.panelMC.recruitPanel[("recruit" + this.recruitCounter)][("skillBtn" + _local_2)].gotoAndStop((int(Character[("character_element_" + _local_2)]) + 1));
                    _local_2++;
                };
            }
            else
            {
                _local_3 = this.response.recruit[(this.recruitCounter - 1)].info.set;
                _local_4 = this.response.recruit[(this.recruitCounter - 1)].info;
                if (!Character.is_stickman)
                {
                    _local_1.fillOutfit(this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].charMc, _local_3.weapon, _local_3.back_item, _local_3.clothing, _local_3.hairstyle, _local_3.face, _local_3.hair_color, _local_3.skin_color);
                };
                this.outfits.push(_local_1);
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].charMc.visible = true;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].noPlayer.visible = false;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].recruitTeam.visible = false;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].charLevelMC.visible = true;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].rankIcon.visible = true;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].emblemIcon.visible = (_local_4.emblem == true);
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].char_name.text = _local_4.name;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].charLevelMC.levelTxt.text = _local_4.level;
                this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].rankIcon.gotoAndStop(_local_4.rank);
                _local_2 = 1;
                while (_local_2 < 4)
                {
                    this.panelMC.recruitPanel[("recruit" + this.recruitCounter)][("skillBtn" + _local_2)].gotoAndStop((int(_local_4[("element_" + _local_2)]) + 1));
                    _local_2++;
                };
            };
            this.recruitCounter++;
            setTimeout(this.initRecruitUI, 100);
        }

        private function loadNpcCharacter():void
        {
            GF.removeAllChild(this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].holder);
            NinjaSage.loadIconSWF("npcs", this.recruitArray[this.recruitCounter], this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].holder, this.recruitArray[this.recruitCounter]);
            this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].charMc.visible = false;
            this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].recruitTeam.visible = false;
            this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].noPlayer.visible = false;
            this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].emblemIcon.visible = false;
            this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].charLevelMC.visible = true;
            this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].rankIcon.visible = true;
            var _local_1:Object = NpcInfo.getNpcStats(this.recruitArray[this.recruitCounter]);
            this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].char_name.text = _local_1.npc_name;
            this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].charLevelMC.levelTxt.text = _local_1.npc_level;
            this.panelMC.recruitPanel[("recruit" + this.recruitCounter)].rankIcon.gotoAndStop(_local_1.npc_rank);
            this.recruitCounter++;
            this.initRecruitUI();
        }

        public function onGradeList():void
        {
            var _local_1:MovieClip = this.panelMC.missionPanel;
            _local_1.stop();
            _local_1.other.gotoAndStop("unselect");
            _local_1.other.btn.gotoAndStop(1);
            _local_1.menu2.visible = false;
            _local_1.arrowMc.visible = false;
            _local_1.arrowMc1.visible = false;
            var _local_2:int;
            while (_local_2 < 3)
            {
                _local_1.doubleXPMc[("doubleXp_" + _local_2)].visible = false;
                _local_1.doubleXPTxt[("doubleTime_" + _local_2)].visible = false;
                _local_1.doubleXPTxt[("doubleTimeBg_" + _local_2)].visible = false;
                _local_2++;
            };
        }

        public function onGradeSMission():void
        {
            var _local_1:MovieClip = this.panelMC.missionPanel;
            var _local_2:int;
            while (_local_2 < 4)
            {
                _local_1.gradeSList[("eightymission_" + _local_2)].gotoAndStop("disable");
                _local_1.gradeSList[("eightymission_" + _local_2)].newMc.visible = false;
                _local_2++;
            };
            _local_1.menu1.visible = false;
            _local_1.btnEightyPrevPage.visible = false;
            _local_1.btnEightyNextPage.visible = false;
            _local_1.gradeSList["eightymission_0"].newMc.visible = true;
            _local_1.gradeSList["eightymission_0"].gotoAndStop("enable");
            this.eventHandler.addListener(_local_1.backBtn, MouseEvent.CLICK, this.backToSelectCategory);
            this.eventHandler.addListener(_local_1.gradeSList["eightymission_0"], MouseEvent.CLICK, this.openGradeSPanel);
            this.eventHandler.addListener(_local_1.gradeSList["eightymission_0"], MouseEvent.MOUSE_OVER, this.onCategoryHover);
            this.eventHandler.addListener(_local_1.gradeSList["eightymission_0"], MouseEvent.MOUSE_OUT, this.onCategoryOut);
        }

        public function openGradeSPanel(_arg_1:MouseEvent):void
        {
            this.main.loadExternalSwfPanel("SMissionMap", "SMissionMap");
            this.destroy();
        }

        public function onMissionListButton():void
        {
            var _local_1:MovieClip = this.panelMC.missionPanel;
            this.eventHandler.addListener(_local_1.btnExit, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(_local_1.missionListMc.backBtn, MouseEvent.CLICK, this.backToSelectCategory);
            this.eventHandler.addListener(_local_1.missionListMc.prevPageBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(_local_1.missionListMc.nextPageBtn, MouseEvent.CLICK, this.changePage);
        }

        public function onMissionList():void
        {
            var _local_3:int;
            var _local_4:Object;
            this.onMissionListButton();
            var _local_1:MovieClip = this.panelMC.missionPanel;
            _local_1.stop();
            _local_1.txt_misssionselect.text = this.titleScroll;
            var _local_2:int;
            while (_local_2 < 3)
            {
                _local_1.missionListMc[("btnMission_" + _local_2)].gotoAndStop(1);
                _local_3 = (_local_2 + int((int((this.currentPage - 1)) * 3)));
                if (this.selectedCategory.length > _local_3)
                {
                    _local_4 = MissionLibrary.getMissionInfo(this.selectedCategory[_local_3]);
                    _local_1.missionListMc[("btnMission_" + _local_2)].visible = true;
                    _local_1.missionListMc[("btnMission_" + _local_2)].nameTxt.text = _local_4["msn_name"];
                    _local_1.missionListMc[("btnMission_" + _local_2)].levelTxt.text = _local_4["msn_level"];
                    _local_1.missionListMc[("btnMission_" + _local_2)].xpTxt.text = _local_4["msn_rewards"].xp;
                    _local_1.missionListMc[("btnMission_" + _local_2)].goldTxt.text = _local_4["msn_rewards"].gold;
                    _local_1.missionListMc[("btnMission_" + _local_2)].sp.visible = false;
                    _local_1.missionListMc[("btnMission_" + _local_2)].tp.visible = false;
                    _local_1.missionListMc[("btnMission_" + _local_2)].doubleXPMc.visible = false;
                    if (_local_4["msn_premium"])
                    {
                        _local_1.missionListMc[("btnMission_" + _local_2)].lockMc.gotoAndStop(3);
                    };
                    if (_local_4["msn_level"] > int(Character.character_lvl))
                    {
                        _local_1.missionListMc[("btnMission_" + _local_2)].lockMc.gotoAndStop(2);
                    }
                    else
                    {
                        _local_1.missionListMc[("btnMission_" + _local_2)].lockMc.gotoAndStop(1);
                    };
                    if (_local_4["msn_grade"] == "tp")
                    {
                        _local_1.missionListMc[("btnMission_" + _local_2)].tp.visible = true;
                        _local_1.missionListMc[("btnMission_" + _local_2)].tpTxt.text = _local_4["msn_rewards"].tp;
                    }
                    else
                    {
                        if (_local_4["msn_grade"] == "ss")
                        {
                            _local_1.missionListMc[("btnMission_" + _local_2)].sp.visible = true;
                            _local_1.missionListMc[("btnMission_" + _local_2)].tpTxt.text = _local_4["msn_rewards"].ss;
                        };
                    };
                    _local_1.missionListMc[("btnMission_" + _local_2)].missionData = _local_4;
                    this.eventHandler.addListener(_local_1.missionListMc[("btnMission_" + _local_2)], MouseEvent.CLICK, this.openDetail);
                    this.eventHandler.addListener(_local_1.missionListMc[("btnMission_" + _local_2)], MouseEvent.MOUSE_OVER, this.onCategoryHover);
                    this.eventHandler.addListener(_local_1.missionListMc[("btnMission_" + _local_2)], MouseEvent.MOUSE_OUT, this.onCategoryOut);
                }
                else
                {
                    _local_1.missionListMc[("btnMission_" + _local_2)].visible = false;
                };
                _local_2++;
            };
            this.totalPage = Math.max(Math.ceil((this.selectedCategory.length / 3)), 1);
            this.updatePageText();
        }

        private function openDetail(_arg_1:MouseEvent):void
        {
            var _local_4:int;
            var _local_2:MovieClip = this.panelMC.missionPanel;
            this.eventHandler.addListener(_local_2.btnExit, MouseEvent.CLICK, this.closePanel);
            this.selectedMission = _arg_1.currentTarget.missionData;
            _local_2.gotoAndStop("detail");
            _local_2.txt_misssionselect.text = this.titleScroll;
            if ((this.selectedMission["msn_id"] in this.response.daily))
            {
                _local_2.detailMc.lbl_completed_detail.text = ("Remaining: " + this.response.daily[this.selectedMission["msn_id"]]);
            };
            _local_2.detailMc.nameTxt.text = this.selectedMission["msn_name"];
            _local_2.detailMc.levelTxt.text = this.selectedMission["msn_level"];
            _local_2.detailMc.descriptionTxt.text = this.selectedMission["msn_description"];
            _local_2.detailMc.xpTxt.text = this.selectedMission["msn_rewards"].xp;
            _local_2.detailMc.goldTxt.text = this.selectedMission["msn_rewards"].gold;
            _local_2.detailMc.sp.visible = false;
            _local_2.detailMc.tp.visible = false;
            _local_2.detailMc.doubleXPMc.visible = false;
            if (this.selectedMission["msn_grade"] == "tp")
            {
                _local_2.detailMc.tp.visible = true;
                _local_2.detailMc.tpTxt.text = this.selectedMission["msn_rewards"].tp;
            }
            else
            {
                if (this.selectedMission["msn_grade"] == "ss")
                {
                    _local_2.detailMc.sp.visible = true;
                    _local_2.detailMc.tpTxt.text = this.selectedMission["msn_rewards"].ss;
                };
            };
            var _local_3:int;
            while (_local_3 < 4)
            {
                _local_4 = (_local_3 + (0 * 4));
                _local_2.detailMc[("rewardItem" + _local_3)].visible = false;
                if (("materials" in this.selectedMission["msn_rewards"]))
                {
                    if (this.selectedMission["msn_rewards"].materials.length > _local_4)
                    {
                        _local_2.detailMc[("rewardItem" + _local_3)].visible = true;
                        NinjaSage.loadItemIcon(_local_2.detailMc[("rewardItem" + _local_3)].iconHolder, this.selectedMission["msn_rewards"].materials[_local_3], "icon");
                    };
                };
                _local_3++;
            };
            this.eventHandler.addListener(_local_2.detailMc.btnBack, MouseEvent.CLICK, this.backToMissionList);
            this.eventHandler.addListener(_local_2.detailMc.btnAccept, MouseEvent.CLICK, this.startMission);
        }

        private function startMission(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            var _local_3:String;
            var _local_4:String;
            var _local_5:int;
            var _local_6:String;
            var _local_7:*;
            if (((Character.character_skill_set == "") || (Character.character_skill_set == null)))
            {
                this.main.showMessage("Please equip at least 1 skill");
                return;
            };
            if (((this.selectedMission["msn_premium"]) && (Character.account_type == 0)))
            {
                this.main.showMessage("Must Premium User to play this mission!");
                return;
            };
            if (this.selectedMission["msn_level"] > int(Character.character_lvl))
            {
                this.main.showMessage("Level too low!");
                return;
            };
            if (this.selectedMission["msn_enemy"].length == 0)
            {
                this.main.loading(true);
                this.main.amf_manager.service("BattleSystem.startSageScrollMiniGame", [Character.char_id, Character.sessionkey, this.selectedMission["msn_id"]], this.onStartMiniGameAmf);
            }
            else
            {
                Character.mission_level = int(this.selectedMission["msn_level"]);
                Character.mission_id = this.selectedMission["msn_id"];
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
                    this.main.amf_manager.service("BattleSystem.startMission", [Character.char_id, Character.mission_id, _local_2, _local_3, _local_4, _local_6, Character.sessionkey], this.onStartMissionAmf);
                };
            };
        }

        private function onStartMissionAmf(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.length != 10)
            {
                this.main.showMessage("You have 0 chance to enter this mission, comeback tomorrow!");
                return;
            };
            Character.is_hunting_house = false;
            Character.battle_code = _arg_1;
            this.main.combat = this.main.loadPanel("Combat.Battle", true);
            BattleManager.init(this.main.combat, this.main, BattleVars.MISSION_MATCH, this.selectedMission["msn_bg"]);
            BattleManager.addPlayerToTeam("player", ("char_" + Character.char_id));
            var _local_2:int;
            while (_local_2 < this.selectedMission["msn_enemy"].length)
            {
                BattleManager.addPlayerToTeam("enemy", this.selectedMission["msn_enemy"][_local_2]);
                _local_2++;
            };
            BattleManager.startBattle();
            this.destroy();
        }

        private function onStartMiniGameAmf(_arg_1:Object):void
        {
            var _local_2:String;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.battle_code = _arg_1.code;
                _local_2 = (this.selectedMission["msn_bg"].charAt(0).toUpperCase() + this.selectedMission["msn_bg"].substring(1).toLowerCase());
                this.main.loadMissionMiniGame(this.selectedMission["msn_bg"], _local_2);
                this.destroy();
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

        private function changePage(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "nextPageBtn":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.onMissionList();
                    };
                    break;
                case "prevPageBtn":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.onMissionList();
                    };
            };
            this.updatePageText();
        }

        private function updatePageText():void
        {
            this.panelMC.missionPanel.missionListMc.pageTxt.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function changeTab(_arg_1:*):void
        {
            var _local_3:String;
            var _local_2:MovieClip = this.panelMC.missionPanel;
            if (_local_2.currentLabel == "mission")
            {
                return;
            };
            if ((_arg_1 is MouseEvent))
            {
                _local_3 = _arg_1.currentTarget.name;
            }
            else
            {
                _local_3 = _arg_1;
            };
            if (_local_3 == "other")
            {
                _local_2.other.gotoAndStop("select");
                _local_2.story.gotoAndStop("unselect");
                _local_2.story.btn.gotoAndStop(1);
                _local_2.menu2.visible = true;
                _local_2.menu1.visible = false;
                this.currentTab = "other";
            }
            else
            {
                _local_2.story.gotoAndStop("select");
                _local_2.other.gotoAndStop("unselect");
                _local_2.other.btn.gotoAndStop(1);
                _local_2.menu1.visible = true;
                _local_2.menu2.visible = false;
                this.currentTab = "story";
            };
        }

        private function changeCategory(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = this.panelMC.missionPanel;
            var _local_3:String = _arg_1.currentTarget.name.replace("btnGrade_", "");
            switch (_local_3)
            {
                case "c":
                    this.selectedCategory = this.gradeC;
                    this.titleScroll = "Grade C Mission";
                    break;
                case "b":
                    this.selectedCategory = this.gradeB;
                    this.titleScroll = "Grade B Mission";
                    break;
                case "a":
                    this.selectedCategory = this.gradeA;
                    this.titleScroll = "Grade A Mission";
                    break;
                case "s":
                    this.selectedCategory = this.gradeS;
                    this.titleScroll = "Grade S Mission";
                    break;
                case "ss":
                    this.selectedCategory = this.gradeSS;
                    this.titleScroll = "SS Training";
                    break;
                case "tp":
                    this.selectedCategory = this.gradeTP;
                    this.titleScroll = "TP Training";
                    break;
                case "daily":
                    this.selectedCategory = this.gradeDaily;
                    this.titleScroll = "Daily Mission";
                    break;
                case "special":
                    this.selectedCategory = this.gradeSpecial;
                    this.titleScroll = "Special Events";
                    break;
            };
            if (_local_3 == "s")
            {
                _local_2.gotoAndPlay("mission");
                this.onGradeSMission();
            }
            else
            {
                _local_2.gotoAndStop("list");
                _local_2.rollMC.addFrameScript(0, this.stopRollMC, 12, this.stopRollMC, 19, this.stopRollMC, 26, this.stopRollMC, 33, this.stopRollMC, 40, this.stopRollMC, 47, this.stopRollMC, 54, this.stopRollMC);
                _local_2.rollMC.gotoAndPlay(_local_3);
                _local_2.gotoAndPlay("list");
            };
        }

        private function backToSelectCategory(_arg_1:MouseEvent):void
        {
            this.panelMC.missionPanel.gotoAndStop("show");
            this.setFrameOne();
            this.onGradeList();
            this.initButton();
            this.changeTab(this.currentTab);
            this.currentPage = 1;
        }

        private function backToMissionList(_arg_1:MouseEvent):void
        {
            this.panelMC.missionPanel.gotoAndPlay(13);
        }

        private function removeRecruitedSquad(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.removeRecruitments", [Character.char_id, Character.sessionkey], this.removeRecruitedSquadRes);
        }

        private function removeRecruitedSquadRes(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                Character.character_recruit_ids = [];
                this.panelMC.btn_removeRecruit.visible = false;
                this.resetRecruitUI();
                this.main.HUD.setBasicData();
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

        private function resetRecruitUI():void
        {
            var _local_1:int = 1;
            while (_local_1 < 3)
            {
                this.panelMC.recruitPanel[("recruit" + _local_1)].charMc.visible = false;
                this.panelMC.recruitPanel[("recruit" + _local_1)].noPlayer.visible = true;
                this.panelMC.recruitPanel[("recruit" + _local_1)].recruitTeam.visible = true;
                this.panelMC.recruitPanel[("recruit" + _local_1)].charLevelMC.visible = false;
                this.panelMC.recruitPanel[("recruit" + _local_1)].rankIcon.visible = false;
                this.panelMC.recruitPanel[("recruit" + _local_1)].emblemIcon.visible = false;
                this.panelMC.recruitPanel[("recruit" + _local_1)].char_name.text = "";
                this.panelMC.recruitPanel[("recruit" + _local_1)].rankIcon.visible = false;
                GF.removeAllChild(this.panelMC.recruitPanel[("recruit" + _local_1)].holder);
                GF.removeAllChild(this.panelMC.recruitPanel[("recruit" + _local_1)].charMc);
                _local_1++;
            };
            _local_1 = 1;
            while (_local_1 < 4)
            {
                this.panelMC.recruitPanel["recruit1"][("skillBtn" + _local_1)].gotoAndStop(1);
                this.panelMC.recruitPanel["recruit2"][("skillBtn" + _local_1)].gotoAndStop(1);
                _local_1++;
            };
        }

        public function initButton():void
        {
            var _local_1:MovieClip = this.panelMC.missionPanel;
            this.eventHandler.addListener(_local_1.btnExit, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(_local_1.other, MouseEvent.CLICK, this.changeTab);
            this.eventHandler.addListener(_local_1.other, MouseEvent.MOUSE_OVER, this.onTabHover);
            this.eventHandler.addListener(_local_1.other, MouseEvent.MOUSE_OUT, this.onTabOut);
            this.eventHandler.addListener(_local_1.story, MouseEvent.CLICK, this.changeTab);
            this.eventHandler.addListener(_local_1.story, MouseEvent.MOUSE_OVER, this.onTabHover);
            this.eventHandler.addListener(_local_1.story, MouseEvent.MOUSE_OUT, this.onTabOut);
            this.eventHandler.addListener(_local_1.menu1.btnGrade_c, MouseEvent.CLICK, this.changeCategory);
            this.eventHandler.addListener(_local_1.menu1.btnGrade_c, MouseEvent.MOUSE_OVER, this.onCategoryHover);
            this.eventHandler.addListener(_local_1.menu1.btnGrade_c, MouseEvent.MOUSE_OUT, this.onCategoryOut);
            this.eventHandler.addListener(_local_1.menu2.btnGrade_daily, MouseEvent.CLICK, this.changeCategory);
            this.eventHandler.addListener(_local_1.menu2.btnGrade_daily, MouseEvent.MOUSE_OVER, this.onCategoryHover);
            this.eventHandler.addListener(_local_1.menu2.btnGrade_daily, MouseEvent.MOUSE_OUT, this.onCategoryOut);
            if (this.gradeSpecial.length > 0)
            {
                this.eventHandler.addListener(_local_1.menu2.btnGrade_special, MouseEvent.CLICK, this.changeCategory);
                this.eventHandler.addListener(_local_1.menu2.btnGrade_special, MouseEvent.MOUSE_OVER, this.onCategoryHover);
                this.eventHandler.addListener(_local_1.menu2.btnGrade_special, MouseEvent.MOUSE_OUT, this.onCategoryOut);
            }
            else
            {
                _local_1.menu2.btnGrade_special.gotoAndStop("disable");
            };
            if (int(Character.character_lvl) >= 20)
            {
                this.eventHandler.addListener(_local_1.menu1.btnGrade_b, MouseEvent.CLICK, this.changeCategory);
                this.eventHandler.addListener(_local_1.menu1.btnGrade_b, MouseEvent.MOUSE_OVER, this.onCategoryHover);
                this.eventHandler.addListener(_local_1.menu1.btnGrade_b, MouseEvent.MOUSE_OUT, this.onCategoryOut);
            }
            else
            {
                _local_1.menu1.btnGrade_b.gotoAndStop("disable");
            };
            if (int(Character.character_lvl) >= 40)
            {
                this.eventHandler.addListener(_local_1.menu1.btnGrade_a, MouseEvent.CLICK, this.changeCategory);
                this.eventHandler.addListener(_local_1.menu1.btnGrade_a, MouseEvent.MOUSE_OVER, this.onCategoryHover);
                this.eventHandler.addListener(_local_1.menu1.btnGrade_a, MouseEvent.MOUSE_OUT, this.onCategoryOut);
                this.eventHandler.addListener(_local_1.menu2.btnGrade_tp, MouseEvent.CLICK, this.changeCategory);
                this.eventHandler.addListener(_local_1.menu2.btnGrade_tp, MouseEvent.MOUSE_OVER, this.onCategoryHover);
                this.eventHandler.addListener(_local_1.menu2.btnGrade_tp, MouseEvent.MOUSE_OUT, this.onCategoryOut);
            }
            else
            {
                _local_1.menu1.btnGrade_a.gotoAndStop("disable");
                _local_1.menu2.btnGrade_tp.gotoAndStop("disable");
            };
            if (int(Character.character_lvl) >= 80)
            {
                this.eventHandler.addListener(_local_1.menu1.btnGrade_s, MouseEvent.CLICK, this.changeCategory);
                this.eventHandler.addListener(_local_1.menu1.btnGrade_s, MouseEvent.MOUSE_OVER, this.onCategoryHover);
                this.eventHandler.addListener(_local_1.menu1.btnGrade_s, MouseEvent.MOUSE_OUT, this.onCategoryOut);
                this.eventHandler.addListener(_local_1.menu2.btnGrade_ss, MouseEvent.CLICK, this.changeCategory);
                this.eventHandler.addListener(_local_1.menu2.btnGrade_ss, MouseEvent.MOUSE_OVER, this.onCategoryHover);
                this.eventHandler.addListener(_local_1.menu2.btnGrade_ss, MouseEvent.MOUSE_OUT, this.onCategoryOut);
            }
            else
            {
                _local_1.menu1.btnGrade_s.gotoAndStop("disable");
                _local_1.menu2.btnGrade_ss.gotoAndStop("disable");
                _local_1.menu2.btnGrade_ss.stampTxt.visible = false;
            };
        }

        private function onCategoryHover(_arg_1:MouseEvent):void
        {
            _arg_1.currentTarget.gotoAndStop("mover");
        }

        private function onCategoryOut(_arg_1:MouseEvent):void
        {
            _arg_1.currentTarget.gotoAndStop("enable");
        }

        private function onTabHover(_arg_1:MouseEvent):void
        {
            _arg_1.currentTarget.btn.gotoAndStop(2);
        }

        private function onTabOut(_arg_1:MouseEvent):void
        {
            _arg_1.currentTarget.btn.gotoAndStop(1);
        }

        private function stopMissionPanel():void
        {
            this.panelMC.missionPanel.stop();
        }

        private function stopRollMC():void
        {
            this.panelMC.missionPanel.rollMC.stop();
        }

        private function openRecharge(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Recharge");
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.main.handleVillageHUDVisibility(true);
            this.main.removeExternalSwfPanel();
            var _local_1:int;
            while (_local_1 < 3)
            {
                GF.removeAllChild(this.panelMC.recruitPanel[("recruit" + _local_1)].charMc);
                _local_1++;
            };
            this.eventHandler.removeAllEventListeners();
            this.recruitArray = [];
            this.gradeC = [];
            this.gradeB = [];
            this.gradeA = [];
            this.gradeS = [];
            this.gradeSS = [];
            this.gradeTP = [];
            this.gradeSpecial = [];
            this.gradeDaily = [];
            this.selectedCategory = [];
            GF.destroyArray(this.outfits);
            NinjaSage.clearLoader();
            BulkLoader.getLoader("assets").removeAll();
            OutfitManager.clearStaticMc();
            this.resetRecruitUI();
            this.outfits = null;
            this.recruitCounter = null;
            this.selectedMission = null;
            this.titleScroll = null;
            this.currentPage = null;
            this.totalPage = null;
            this.currentTab = null;
            this.main = null;
            this.eventHandler = null;
            this.response = null;
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

