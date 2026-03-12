// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Mission_Room

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import fl.motion.Color;
    import flash.events.MouseEvent;
    import Storage.Character;
    import Storage.MissionLibrary;
    import Managers.StatManager;
    import Storage.EnemyInfo;
    import com.adobe.crypto.CUCSG;
    import Combat.BattleManager;
    import Combat.BattleVars;
    import flash.system.System;

    public class Mission_Room extends MovieClip 
    {

        public static var hair_mc:Array = [];

        public var btn_cat_0:MovieClip;
        public var btn_cat_1:MovieClip;
        public var btn_cat_2:MovieClip;
        public var btn_cat_3:MovieClip;
        public var btn_cat_4:MovieClip;
        public var btn_close:SimpleButton;
        public var btn_fight:SimpleButton;
        public var btn_next:SimpleButton;
        public var btn_prev:SimpleButton;
        public var btn_return:SimpleButton;
        public var btn_removeRecruit:SimpleButton;
        public var char_0:MovieClip;
        public var char_1:MovieClip;
        public var char_2:MovieClip;
        public var infoMC:MovieClip;
        public var msn_0:MovieClip;
        public var msn_1:MovieClip;
        public var msn_2:MovieClip;
        public var msn_3:MovieClip;
        public var txt_page:TextField;
        public var txt_type:TextField;
        public var main:*;
        internal var grade_c:Array = ["msn_01", "msn_02", "msn_03", "msn_04", "msn_05", "msn_06", "msn_07", "msn_08", "msn_09", "msn_10", "msn_11", "msn_12", "msn_13", "msn_14", "msn_15", "msn_16", "msn_17", "msn_18", "msn_19", "msn_20"];
        internal var grade_b:Array = ["msn_21", "msn_22", "msn_23", "msn_24", "msn_25", "msn_26", "msn_27", "msn_28", "msn_29", "msn_30", "msn_31", "msn_32", "msn_33", "msn_34", "msn_35", "msn_36", "msn_37", "msn_38", "msn_39", "msn_40"];
        internal var grade_a:Array = ["msn_41", "msn_42", "msn_43", "msn_44", "msn_45", "msn_46", "msn_47", "msn_48", "msn_49", "msn_50", "msn_51", "msn_52", "msn_53", "msn_54", "msn_55", "msn_56", "msn_57", "msn_58", "msn_59", "msn_60"];
        internal var grade_daily:Array = ["msn_101", "msn_102", "msn_103", "msn_104", "msn_105", "msn_106", "msn_107", "msn_108", "msn_109", "msn_110", "msn_111"];
        internal var curr_page:int = 1;
        internal var curr_target:int;
        internal var curr_target_mc:*;
        internal var total_page:int = 1;
        internal var itemCnt:int = 0;
        internal var total_items:int = 0;
        internal var color:Color = new Color();
        public var stage_missions:Array = [];
        public var stage_type:* = "";
        internal var hairMC:MovieClip;
        internal var backHairMC:MovieClip;
        internal var color_1:uint;
        internal var color_2:uint;

        public function Mission_Room(_arg_1:*)
        {
            this.main = _arg_1;
            this.gotoAndStop(1);
            this.loadBasicData();
        }

        internal function loadBasicData():void
        {
            this.btn_close.addEventListener(MouseEvent.CLICK, this.closePanel);
            if (Character.character_recruit_ids.length > 0)
            {
                this.btn_removeRecruit.visible = true;
                this.btn_removeRecruit.addEventListener(MouseEvent.CLICK, this.removeRecruitedSquad);
            }
            else
            {
                this.btn_removeRecruit.visible = false;
            };
            var _local_1:* = 0;
            while (_local_1 < 5)
            {
                this[("btn_cat_" + _local_1)].gotoAndStop(1);
                this[("btn_cat_" + _local_1)]["clickmask"].mouseEnabled = true;
                this[("btn_cat_" + _local_1)]["clickmask"].addEventListener(MouseEvent.MOUSE_OVER, this.mOver);
                this[("btn_cat_" + _local_1)]["clickmask"].addEventListener(MouseEvent.MOUSE_OUT, this.mOut);
                this[("btn_cat_" + _local_1)]["clickmask"].addEventListener(MouseEvent.CLICK, this.selectCategory);
                _local_1++;
            };
            this["btn_cat_4"].gotoAndStop(3);
            this["btn_cat_4"]["clickmask"].mouseEnabled = false;
            this["btn_cat_4"]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER, this.mOver);
            this["btn_cat_4"]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT, this.mOut);
            this["btn_cat_4"]["clickmask"].removeEventListener(MouseEvent.CLICK, this.selectCategory);
            if (((int(Character.character_lvl) > 20) || (int(Character.character_rank) > 1)))
            {
                this.btn_cat_1.gotoAndStop(1);
                this["btn_cat_1"]["clickmask"].mouseEnabled = true;
            }
            else
            {
                this.btn_cat_1.gotoAndStop(3);
                this["btn_cat_1"]["clickmask"].mouseEnabled = false;
            };
            if (((int(Character.character_lvl) > 40) || (int(Character.character_rank) > 3)))
            {
                this.btn_cat_2.gotoAndStop(1);
                this["btn_cat_2"]["clickmask"].mouseEnabled = true;
            }
            else
            {
                this.btn_cat_2.gotoAndStop(3);
                this["btn_cat_2"]["clickmask"].mouseEnabled = false;
            };
            if (((int(Character.character_lvl) > 0) || (int(Character.character_rank) > 0)))
            {
                this.btn_cat_3.gotoAndStop(1);
                this["btn_cat_3"]["clickmask"].mouseEnabled = true;
            }
            else
            {
                this.btn_cat_3.gotoAndStop(3);
                this["btn_cat_3"]["clickmask"].mouseEnabled = false;
            };
            this.char_0.lvlMC.txt_lvl.text = Character.character_lvl;
            this.char_0.txt_name.text = Character.character_name;
            this.char_0.rankMC.gotoAndStop(Character.character_rank);
            this.char_0.element_1.gotoAndStop((int(Character.character_element_1) + 1));
            this.char_0.element_2.gotoAndStop((int(Character.character_element_2) + 1));
            this.char_0.element_1.addEventListener(MouseEvent.CLICK, this.openAcademy);
            this.char_0.element_2.addEventListener(MouseEvent.CLICK, this.openAcademy);
            if (Character.account_type == 0)
            {
                this.char_0.element_3.gotoAndStop(1);
                this.char_0.element_3.addEventListener(MouseEvent.CLICK, this.openPremiumPop);
            }
            else
            {
                this.char_0.element_3.gotoAndStop((int(Character.character_element_3) + 1));
                this.char_0.element_3.addEventListener(MouseEvent.CLICK, this.openAcademy);
            };
            if (Character.account_type == 0)
            {
                this.char_0.emblemMC.gotoAndStop(1);
                this.char_0.emblemMC.addEventListener(MouseEvent.CLICK, this.openPremiumPop);
            }
            else
            {
                if (Character.account_type == 1)
                {
                    this.char_0.emblemMC.gotoAndStop(2);
                };
            };
            if (Character.character_talent_1)
            {
                this.char_0.talent_1.gotoAndStop(Character.character_talent_1);
            }
            else
            {
                this.char_0.talent_1.gotoAndStop(3);
            };
            if (Character.character_talent_2)
            {
                this.char_0.talent_2.gotoAndStop(Character.character_talent_2);
            }
            else
            {
                this.char_0.talent_2.gotoAndStop(4);
            };
            if (Character.character_talent_3)
            {
                this.char_0.talent_3.gotoAndStop(Character.character_talent_3);
            }
            else
            {
                this.char_0.talent_3.gotoAndStop(4);
            };
            this.main.outfit_manager.fillHead(this.char_0.holder, Character.character_hair, Character.character_face, Character.character_color_hair, Character.character_color_skin);
            var _local_2:* = 1;
            while (_local_2 < 3)
            {
                this[("char_" + _local_2)].visible = false;
                this[("char_" + _local_2)].holder.visible = false;
                this[("char_" + _local_2)].lvlMC.visible = false;
                this[("char_" + _local_2)].txt_name.text = "None";
                this[("char_" + _local_2)].rankMC.gotoAndStop(1);
                this[("char_" + _local_2)].emblemMC.gotoAndStop(1);
                this[("char_" + _local_2)].talent_1.gotoAndStop(1);
                this[("char_" + _local_2)].talent_2.gotoAndStop(1);
                this[("char_" + _local_2)].talent_3.gotoAndStop(1);
                this[("char_" + _local_2)].element_1.gotoAndStop(1);
                this[("char_" + _local_2)].element_2.gotoAndStop(1);
                this[("char_" + _local_2)].element_3.gotoAndStop(1);
                _local_2++;
            };
        }

        internal function openPremiumPop(_arg_1:MouseEvent):void
        {
            parent.removeChild(this);
            this.main.loadPanel("Popups.EmblemUpgrade");
        }

        internal function openAcademy(_arg_1:MouseEvent):void
        {
            if (Character._inBattle)
            {
                this.main.giveMessage("You can't change your skill set during battle !");
            };
        }

        internal function mOver(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.parent.currentFrame !== 3)
            {
                _arg_1.currentTarget.parent.gotoAndStop(2);
            };
        }

        internal function mOut(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.parent.currentFrame !== 3)
            {
                _arg_1.currentTarget.parent.gotoAndStop(1);
            };
        }

        internal function selectCategory(_arg_1:MouseEvent):void
        {
            this.killEverything();
            this.gotoAndStop(2);
            var _local_2:* = _arg_1.currentTarget.parent.name.split("_");
            _local_2 = _local_2[2];
            this.loadMissionCategory(_local_2);
        }

        internal function loadMissionCategory(_arg_1:String):void
        {
            this.btn_return.addEventListener(MouseEvent.CLICK, this.returnToMain);
            this.resetSlots();
            if (_arg_1 == "0")
            {
                this.stage_type = "C";
                this.stage_missions = this.grade_c;
                this.curr_target = 1;
                this.getMissionInfo(this.curr_target);
                this.curr_target_mc = this["msn_0"];
                this.txt_type.text = "Grade C Missions";
            }
            else
            {
                if (_arg_1 == "1")
                {
                    this.stage_type = "B";
                    this.stage_missions = this.grade_b;
                    this.curr_target = 21;
                    this.getMissionInfo(this.curr_target);
                    this.curr_target_mc = this["msn_0"];
                    this.txt_type.text = "Grade B Missions";
                }
                else
                {
                    if (_arg_1 == "2")
                    {
                        this.stage_type = "A";
                        this.stage_missions = this.grade_a;
                        this.curr_target = 41;
                        this.getMissionInfo(this.curr_target);
                        this.curr_target_mc = this["msn_0"];
                        this.txt_type.text = "Grade A Missions";
                    }
                    else
                    {
                        if (_arg_1 == "3")
                        {
                            this.stage_type = "Daily";
                            this.stage_missions = this.grade_daily;
                            this.curr_target = 101;
                            this.getMissionInfo(this.curr_target);
                            this.curr_target_mc = this["msn_0"];
                            this.txt_type.text = "Daily Missions";
                        };
                    };
                };
            };
            this.total_page = Math.ceil((this.stage_missions.length / 4));
            this.total_items = this.stage_missions.length;
            this.curr_page = 1;
            this.itemCnt = 0;
            this.loadItems();
            this.btn_next.addEventListener(MouseEvent.CLICK, this.changePage);
            this.btn_prev.addEventListener(MouseEvent.CLICK, this.changePage);
            this.btn_fight.addEventListener(MouseEvent.CLICK, this.startFight);
        }

        internal function startFight(_arg_1:MouseEvent):*
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            var _local_5:* = undefined;
            var _local_6:* = undefined;
            var _local_7:* = undefined;
            var _local_8:* = MissionLibrary.getMissionInfo(("msn_" + this.curr_target));
            Character.mission_level = int(_local_8["msn_level"]);
            if (int(Character.character_lvl) >= int(_local_8["msn_level"]))
            {
                _local_2 = "";
                _local_3 = "";
                _local_4 = StatManager.calculate_stats_with_data("agility", Character.character_lvl, Character.atrrib_earth, Character.atrrib_water, Character.atrrib_wind, Character.atrrib_lightning);
                _local_5 = 0;
                while (_local_5 < _local_8["msn_enemy"].length)
                {
                    _local_7 = EnemyInfo.getEnemyStats(_local_8["msn_enemy"][_local_5]);
                    if (_local_2 == "")
                    {
                        _local_2 = _local_8["msn_enemy"][_local_5];
                        _local_3 = ((((("id:" + _local_7["enemy_id"]) + "|hp:") + _local_7["enemy_hp"]) + "|agility:") + _local_7["enemy_agility"]);
                    }
                    else
                    {
                        _local_2 = ((_local_2 + ",") + _local_8["msn_enemy"][_local_5]);
                        _local_3 = ((((((_local_3 + "#id:") + _local_7["enemy_id"]) + "|hp:") + _local_7["enemy_hp"]) + "|agility:") + _local_7["enemy_agility"]);
                    };
                    _local_5++;
                };
                this.main.loading(true);
                _local_6 = CUCSG.hash(((_local_2 + _local_3) + _local_4));
                this.main.amf_manager.service("BattleSystem.startMission", [Character.char_id, Character.mission_id, _local_2, _local_3, _local_4, _local_6, Character.sessionkey], this.onStartMissionAmf);
            };
        }

        public function onStartMissionAmf(_arg_1:*):*
        {
            this.main.loading(false);
            if (_arg_1.length != 10)
            {
                this.main.giveMessage("You have 0 chance to enter this mission, comeback tomorrow!");
                return;
            };
            var _local_2:* = MissionLibrary.getMissionInfo(Character.mission_id);
            Character.is_hunting_house = false;
            Character.battle_code = _arg_1;
            this.main.combat = this.main.loadPanel("Combat.Battle", true);
            BattleManager.init(this.main.combat, this.main, BattleVars.MISSION_MATCH, _local_2["msn_bg"]);
            BattleManager.addPlayerToTeam("player", ("char_" + Character.char_id));
            var _local_3:int;
            while (_local_3 < _local_2["msn_enemy"].length)
            {
                BattleManager.addPlayerToTeam("enemy", _local_2["msn_enemy"][_local_3]);
                _local_3++;
            };
            BattleManager.startBattle();
            _local_2 = null;
        }

        internal function loadItems():void
        {
            var _local_1:* = undefined;
            var _local_2:* = undefined;
            this.msn_0.visible = false;
            this.msn_1.visible = false;
            this.msn_2.visible = false;
            this.msn_3.visible = false;
            var _local_3:* = 0;
            if (this.stage_type == "B")
            {
                _local_3 = 20;
            };
            if (this.stage_type == "A")
            {
                _local_3 = 40;
            };
            if (this.stage_type == "Daily")
            {
                _local_3 = 100;
            };
            var _local_4:* = 0;
            var _local_5:int = (int((this.curr_page - 1)) * 4);
            var _local_6:int = (int(this.curr_page) * 4);
            while (_local_5 < _local_6)
            {
                if (_local_5 < int(this.total_items))
                {
                    if (this.curr_target_mc.name == ("msn_" + int(_local_5)))
                    {
                        this.curr_target_mc.gotoAndStop(3);
                    };
                    _local_1 = (_local_5 + int(_local_3));
                    _local_2 = MissionLibrary.getMissionInfo(("msn_" + (_local_1 + int(1))));
                    this[("msn_" + _local_4)]["clickmask"].addEventListener(MouseEvent.MOUSE_OVER, this.mOver);
                    this[("msn_" + _local_4)]["clickmask"].addEventListener(MouseEvent.MOUSE_OUT, this.mOut);
                    this[("msn_" + _local_4)].visible = true;
                    this[("msn_" + _local_4)]["txt_name"].text = _local_2["msn_name"];
                    this[("msn_" + _local_4)]["txt_lvl"].text = _local_2["msn_level"];
                    this[("msn_" + _local_4)]["txt_xp"].text = _local_2["msn_reward_xp"];
                    this[("msn_" + _local_4)]["txt_gold"].text = _local_2["msn_reward_gold"];
                    this[("msn_" + _local_4)]["txt_tp"].text = _local_2["msn_reward_tp"];
                    this[("msn_" + _local_4)]["txt_ss"].text = _local_2["msn_reward_ss"];
                    if (_local_2["msn_level"] > Character.character_lvl)
                    {
                        this[("msn_" + _local_4)].lockMC.visible = true;
                        this[("msn_" + _local_4)].lockMC.gotoAndStop(1);
                    }
                    else
                    {
                        this[("msn_" + _local_4)].lockMC.visible = false;
                        this[("msn_" + _local_4)].lockMC.gotoAndStop(1);
                    };
                    if (((_local_2["msn_premium"]) && (Character.account_type == 0)))
                    {
                        this[("msn_" + _local_4)].lockMC.visible = true;
                        this[("msn_" + _local_4)].lockMC.gotoAndStop(2);
                        this[("msn_" + _local_4)].lockMC.addEventListener(MouseEvent.CLICK, this.openPremiumPop);
                        this.color.brightness = -0.3;
                        this[("msn_" + _local_4)].transform.colorTransform = this.color;
                    }
                    else
                    {
                        if (((_local_2["msn_premium"]) && (!(Character.account_type === 0))))
                        {
                            this[("msn_" + _local_4)].lockMC.visible = true;
                            this[("msn_" + _local_4)].lockMC.gotoAndStop(2);
                            this[("msn_" + _local_4)].lockMC.removeEventListener(MouseEvent.CLICK, this.openPremiumPop);
                            this.color.brightness = 0;
                            this[("msn_" + _local_4)].transform.colorTransform = this.color;
                        }
                        else
                        {
                            this[("msn_" + _local_4)].lockMC.visible = false;
                            this[("msn_" + _local_4)].lockMC.removeEventListener(MouseEvent.CLICK, this.openPremiumPop);
                            this.color.brightness = 0;
                            this[("msn_" + _local_4)].transform.colorTransform = this.color;
                        };
                    };
                    this[("msn_" + _local_4)]["clickmask"].buttonMode = true;
                    this[("msn_" + _local_4)]["clickmask"].addEventListener(MouseEvent.CLICK, this.selectMission);
                    _local_4++;
                };
                _local_5++;
            };
            this.txt_page.text = ((this.curr_page + "/") + this.total_page);
        }

        internal function selectMission(_arg_1:MouseEvent):void
        {
            this.resetSlots();
            _arg_1.currentTarget.parent.gotoAndStop(3);
            this.curr_target_mc = _arg_1.currentTarget.parent;
            var _local_2:* = _arg_1.currentTarget.parent.name.split("_");
            _local_2 = _local_2[1];
            _local_2 = (((int(this.curr_page) - 1) * 4) + (int(_local_2) + 1));
            var _local_3:* = 0;
            if (this.stage_type == "B")
            {
                _local_3 = 20;
            };
            if (this.stage_type == "A")
            {
                _local_3 = 40;
            };
            if (this.stage_type == "Daily")
            {
                _local_3 = 100;
            };
            _local_2 = (int(_local_2) + int(_local_3));
            this.getMissionInfo(_local_2);
        }

        internal function getMissionInfo(_arg_1:int):void
        {
            this.curr_target = _arg_1;
            var _local_2:* = MissionLibrary.getMissionInfo(("msn_" + this.curr_target));
            Character.mission_id = _local_2.msn_id;
            this.infoMC["txt_name"].text = _local_2["msn_name"];
            this.infoMC["txt_desc"].text = _local_2["msn_description"];
            this.infoMC["txt_tp"].text = _local_2["msn_reward_tp"];
            this.infoMC["txt_ss"].text = _local_2["msn_reward_ss"];
            this.infoMC["txt_xp"].text = _local_2["msn_reward_xp"];
            this.infoMC["txt_gold"].text = _local_2["msn_reward_gold"];
            this.btn_fight.visible = false;
            if (int(Character.character_lvl) >= int(_local_2["msn_level"]))
            {
                this.btn_fight.visible = true;
            };
        }

        internal function resetSlots():void
        {
            this["msn_0"].gotoAndStop(1);
            this["msn_1"].gotoAndStop(1);
            this["msn_2"].gotoAndStop(1);
            this["msn_3"].gotoAndStop(1);
        }

        internal function changePage(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.name == "btn_next")
            {
                if (this.curr_page < this.total_page)
                {
                    this.curr_page++;
                    this.resetSlots();
                    this.loadItems();
                };
            }
            else
            {
                if (_arg_1.currentTarget.name == "btn_prev")
                {
                    if (this.curr_page > 1)
                    {
                        this.curr_page--;
                        this.resetSlots();
                        this.loadItems();
                    };
                };
            };
        }

        internal function returnToMain(_arg_1:MouseEvent):void
        {
            this.killEverything();
            this.gotoAndStop(1);
            this.loadBasicData();
        }

        internal function removeRecruitedSquad(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.removeRecruitments", [Character.char_id, Character.sessionkey], this.removeRecruitedSquadRes);
        }

        internal function removeRecruitedSquadRes(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                Character.character_recruit_ids = [];
                this.btn_removeRecruit.visible = false;
                this.btn_removeRecruit.removeEventListener(MouseEvent.CLICK, this.removeRecruitedSquad);
                this.btn_removeRecruit = null;
                this.main.HUD.setBasicData();
            }
            else
            {
                this.main.getError(_arg_1.error);
            };
        }

        internal function killEverything():void
        {
            var _local_1:* = undefined;
            try
            {
                this.btn_close.removeEventListener(MouseEvent.CLICK, this.closePanel);
                this.btn_return.removeEventListener(MouseEvent.CLICK, this.returnToMain);
                this.char_0.element_1.removeEventListener(MouseEvent.CLICK, this.openAcademy);
                this.char_0.element_2.removeEventListener(MouseEvent.CLICK, this.openAcademy);
                this.char_0.element_3.removeEventListener(MouseEvent.CLICK, this.openAcademy);
                this.char_0.element_3.removeEventListener(MouseEvent.CLICK, this.openPremiumPop);
                this.char_0.emblemMC.removeEventListener(MouseEvent.CLICK, this.openPremiumPop);
                this.btn_next.removeEventListener(MouseEvent.CLICK, this.changePage);
                this.btn_prev.removeEventListener(MouseEvent.CLICK, this.changePage);
                this.msn_0.lockMC.removeEventListener(MouseEvent.CLICK, this.openPremiumPop);
                this.msn_1.lockMC.removeEventListener(MouseEvent.CLICK, this.openPremiumPop);
                this.msn_2.lockMC.removeEventListener(MouseEvent.CLICK, this.openPremiumPop);
                this.msn_3.lockMC.removeEventListener(MouseEvent.CLICK, this.openPremiumPop);
                this.msn_0.clickmask.removeEventListener(MouseEvent.CLICK, this.selectMission);
                this.msn_1.clickmask.removeEventListener(MouseEvent.CLICK, this.selectMission);
                this.msn_2.clickmask.removeEventListener(MouseEvent.CLICK, this.selectMission);
                this.msn_3.clickmask.removeEventListener(MouseEvent.CLICK, this.selectMission);
                this.msn_0.clickmask.removeEventListener(MouseEvent.MOUSE_OVER, this.mOver);
                this.msn_0.clickmask.removeEventListener(MouseEvent.MOUSE_OUT, this.mOut);
                this.msn_1.clickmask.removeEventListener(MouseEvent.MOUSE_OVER, this.mOver);
                this.msn_1.clickmask.removeEventListener(MouseEvent.MOUSE_OUT, this.mOut);
                this.msn_2.clickmask.removeEventListener(MouseEvent.MOUSE_OVER, this.mOver);
                this.msn_2.clickmask.removeEventListener(MouseEvent.MOUSE_OUT, this.mOut);
                this.msn_3.clickmask.removeEventListener(MouseEvent.MOUSE_OVER, this.mOver);
                this.msn_3.clickmask.removeEventListener(MouseEvent.MOUSE_OUT, this.mOut);
                _local_1 = 0;
                while (_local_1 < 5)
                {
                    this[("btn_cat_" + _local_1)]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER, this.mOver);
                    this[("btn_cat_" + _local_1)]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT, this.mOut);
                    this[("btn_cat_" + _local_1)]["clickmask"].removeEventListener(MouseEvent.CLICK, this.selectCategory);
                    _local_1++;
                };
                this.main = null;
                hair_mc = null;
                this.grade_c = null;
                this.grade_b = null;
                this.grade_daily = null;
                this.stage_missions = null;
                this.stage_type = null;
                this.curr_page = undefined;
                this.curr_target = undefined;
                this.curr_target_mc = null;
                this.total_page = undefined;
                this.itemCnt = undefined;
                this.total_items = undefined;
                this.color = null;
            }
            catch(e)
            {
            };
            System.gc();
        }

        internal function closePanel(_arg_1:MouseEvent):void
        {
            this.killEverything();
            this.grade_c = null;
            this.curr_page = undefined;
            this.curr_target = undefined;
            this.curr_target_mc = null;
            this.total_page = undefined;
            this.itemCnt = undefined;
            this.total_items = undefined;
            this.color = null;
            parent.removeChild(this);
        }


    }
}//package Panels

