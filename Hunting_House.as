// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Hunting_House

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import com.abrahamyan.liquid.ToolTip;
    import id.ninjasage.EventHandler;
    import fl.motion.Color;
    import flash.events.MouseEvent;
    import Storage.Character;
    import Storage.Library;
    import com.utils.GF;
    import Managers.NinjaSage;
    import flash.system.System;

    public class Hunting_House extends MovieClip 
    {

        public var boss_0:MovieClip;
        public var boss_1:MovieClip;
        public var boss_2:MovieClip;
        public var boss_3:MovieClip;
        public var boss_4:MovieClip;
        public var btn_close:SimpleButton;
        public var btn_fight:SimpleButton;
        public var btn_next:SimpleButton;
        public var btn_prev:SimpleButton;
        public var btn_reset:SimpleButton;
        public var btn_Blacksmith:SimpleButton;
        public var btn_Recruit:SimpleButton;
        public var dropMC:MovieClip;
        public var loader_0:MovieClip;
        public var loader_1:MovieClip;
        public var lock_0:MovieClip;
        public var lock_1:MovieClip;
        public var lock_2:MovieClip;
        public var lock_3:MovieClip;
        public var lock_4:MovieClip;
        public var pageTxt:TextField;
        public var popup:MovieClip;
        public var txt_desc:TextField;
        public var txt_gold:TextField;
        public var txt_xp:TextField;
        public var main:*;
        internal var boss_rn:* = 0;
        internal var curr_page:* = 1;
        internal var itemCnt:* = 0;
        internal var total_page:* = 1;
        public var boss_id:* = "";
        public var boss_num:* = -1;
        internal var obj:*;
        public var tooltip:ToolTip;

        internal var enemy_data:Array = [];
        internal var bossList:* = ["ene_81", "ene_82", "ene_83", ["ene_84", "ene_85"], "ene_86", "ene_106", "ene_120", "ene_155"];
        public var curr_page_boss:Array = [];
        public var array_info_holder:Array = [];
        public var rewardsArray:Array = [];
        private var eventHandler:* = new EventHandler();
        internal var color:Color = new Color();

        public function Hunting_House(_arg_1:*)
        {
            this.main = _arg_1;
            this.popup.visible = false;
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.btn_reset, MouseEvent.CLICK, this.openPop);
            this.eventHandler.addListener(this.btn_Blacksmith, MouseEvent.CLICK, this.openBlacksmith);
            this.eventHandler.addListener(this.btn_Recruit, MouseEvent.CLICK, this.openSocial);
            this.eventHandler.addListener(this.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.btn_prev, MouseEvent.CLICK, this.changePage);
            this.tooltip = ToolTip.getInstance();
            this.getData();
        }

        internal function getData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("HuntingHouse.getData", [Character.sessionkey, Character.char_id], this.dataResponse);
        }

        internal function openBlacksmith(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Blacksmith");
        }

        internal function openSocial(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Social");
        }

        internal function dataResponse(_arg_1:Object):void
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                _local_2 = _arg_1.data.split(",");
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    this.enemy_data.push(_local_2[_local_3]);
                    _local_3++;
                };
                this.loadBasicData(this.enemy_data, this.itemCnt);
            }
            else
            {
                this.main.getError(_arg_1.error_code);
            };
        }

        internal function openPop(_arg_1:MouseEvent):void
        {
            this.popup.visible = true;
            this.eventHandler.addListener(this.popup.btn_close, MouseEvent.CLICK, this.closePop);
            this.eventHandler.addListener(this.popup.bg, MouseEvent.CLICK, this.closePop);
            this.eventHandler.addListener(this.popup.btn_confirm, MouseEvent.CLICK, this.resetTries);
        }

        internal function closePop(_arg_1:MouseEvent):void
        {
            this.popup.visible = false;
        }

        internal function resetTries(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("HuntingHouse.buyTries", [Character.sessionkey, Character.char_id], this.buyResponse);
        }

        internal function buyResponse(_arg_1:Object):void
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            this.popup.visible = false;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.account_tokens = (Character.account_tokens - 50);
                _local_2 = _arg_1.data.split(",");
                _local_3 = 0;
                this.enemy_data = [];
                while (_local_3 < _local_2.length)
                {
                    this.enemy_data.push(_local_2[_local_3]);
                    _local_3++;
                };
                this.loadBasicData(this.enemy_data, this.itemCnt);
            }
            else
            {
                if (_arg_1.status == 2)
                {
                    this.main.getNotice("You dont have enough tokens to reset the hunting attempts.");
                }
                else
                {
                    this.main.getError(_arg_1.error_code);
                };
            };
        }

        internal function changePage(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.name == "btn_next")
            {
                if (this.curr_page < this.total_page)
                {
                    this.curr_page++;
                    this.itemCnt = 5;
                    this.loadBasicData(this.enemy_data, this.itemCnt);
                };
            }
            else
            {
                if (_arg_1.currentTarget.name == "btn_prev")
                {
                    if (this.curr_page != 1)
                    {
                        this.curr_page--;
                        this.itemCnt = (this.itemCnt - 5);
                        this.loadBasicData(this.enemy_data, this.itemCnt);
                    };
                };
            };
            this.pageTxt.text = ((this.curr_page + "/") + this.total_page);
        }

        internal function loadBasicData(_arg_1:Array, _arg_2:*):void
        {
            var _local_6:*;
            var _local_3:* = undefined;
            var _local_4:* = 5;
            this.total_page = int(((this.bossList.length / 5) + 1));
            if (this.bossList.length < 6)
            {
                _local_4 = this.bossList.length;
                this.total_page = 1;
            };
            if ((this.bossList.length % 5) == 0)
            {
                this.total_page = (this.bossList.length / 5);
            };
            this.pageTxt.text = ((this.curr_page + "/") + this.total_page);
            var _local_5:* = 0;
            while (_local_5 < 5)
            {
                _local_3 = this.loadBossData(_arg_2);
                if (_local_3["name"] == null)
                {
                    this[("boss_" + _local_5)].visible = false;
                    _local_5++;
                }
                else
                {
                    _local_6 = {"bossTnc":_arg_2};
                    this[("boss_" + _local_5)].visible = true;
                    this[("boss_" + _local_5)].gotoAndStop(1);
                    this[("boss_" + _local_5)]["txt_name"].text = _local_3.name;
                    this[("boss_" + _local_5)]["txt_lvl"].text = _local_3.lvl;
                    this[("boss_" + _local_5)]["txt_attempt"].text = ("x" + _arg_1[_arg_2]);
                    this[("boss_" + _local_5)]["rankMC"].gotoAndStop(_local_3.rank);
                    this[("boss_" + _local_5)]["clickmask"].metaData = _local_6;
                    if (Character.character_lvl >= _local_3.lvl)
                    {
                        if (_arg_1[_arg_2] > 0)
                        {
                            this.color.brightness = 0;
                            this[("lock_" + _local_5)].visible = false;
                            this[("boss_" + _local_5)]["clickmask"].buttonMode = true;
                            this[("boss_" + _local_5)].transform.colorTransform = this.color;
                            this.eventHandler.addListener(this[("boss_" + _local_5)]["clickmask"], MouseEvent.MOUSE_OVER, this.bossOver);
                            this.eventHandler.addListener(this[("boss_" + _local_5)]["clickmask"], MouseEvent.MOUSE_OUT, this.bossOut);
                            this.eventHandler.addListener(this[("boss_" + _local_5)]["clickmask"], MouseEvent.CLICK, this.bossClick);
                        }
                        else
                        {
                            this.color.brightness = -0.3;
                            this[("lock_" + _local_5)].visible = false;
                            this[("boss_" + _local_5)]["clickmask"].buttonMode = true;
                            this[("boss_" + _local_5)].transform.colorTransform = this.color;
                            this.eventHandler.addListener(this[("boss_" + _local_5)]["clickmask"], MouseEvent.MOUSE_OVER, this.bossOver);
                            this.eventHandler.addListener(this[("boss_" + _local_5)]["clickmask"], MouseEvent.MOUSE_OUT, this.bossOut);
                            this.eventHandler.addListener(this[("boss_" + _local_5)]["clickmask"], MouseEvent.CLICK, this.bossClick);
                        };
                    }
                    else
                    {
                        this.color.brightness = -0.3;
                        this[("lock_" + _local_5)].visible = true;
                        this[("boss_" + _local_5)]["clickmask"].buttonMode = false;
                        this[("boss_" + _local_5)].transform.colorTransform = this.color;
                        this[("boss_" + _local_5)]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER, this.bossOver);
                        this[("boss_" + _local_5)]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT, this.bossOut);
                        this[("boss_" + _local_5)]["clickmask"].removeEventListener(MouseEvent.CLICK, this.bossClick);
                    };
                    _arg_2++;
                    _local_5++;
                };
            };
            this.selectBoss(this.itemCnt);
            this["boss_0"].gotoAndStop(3);
        }

        internal function bossOver(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.parent.currentFrame != 3)
            {
                _arg_1.currentTarget.parent.gotoAndStop(2);
            };
        }

        internal function bossOut(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.parent.currentFrame != 3)
            {
                _arg_1.currentTarget.parent.gotoAndStop(1);
            };
        }

        internal function bossClick(_arg_1:MouseEvent):void
        {
            var _local_2:* = 0;
            while (_local_2 < 5)
            {
                this[("boss_" + _local_2)].gotoAndStop(1);
                _local_2++;
            };
            this.boss_rn = _arg_1.currentTarget.metaData.bossTnc;
            _arg_1.currentTarget.parent.gotoAndStop(3);
            var _local_3:* = _arg_1.currentTarget.parent.name.split("_");
            _local_3 = _local_3[1];
            this.selectBoss(this.boss_rn);
        }

        internal function selectBoss(_arg_1:int):void
        {
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            var _local_9:*;
            var _local_10:*;
            this.array_info_holder = [];
            this.rewardsArray = [];
            var _local_2:* = this.loadBossData(_arg_1);
            Character.hunting_house_boss_id = (this.boss_id = _local_2.id);
            Character.hunting_house_boss_num = (this.boss_num = _local_2.num);
            this.txt_desc.text = _local_2.desc;
            this.txt_xp.text = _local_2.xp;
            this.txt_gold.text = _local_2.gold;
            if (this.enemy_data[_arg_1] > 0)
            {
                this.color.brightness = 0;
                this.btn_fight.visible = true;
                this.btn_fight.mouseEnabled = true;
                this.btn_fight.transform.colorTransform = this.color;
                this.eventHandler.addListener(this.btn_fight, MouseEvent.CLICK, this.startBattle);
            }
            else
            {
                this.color.brightness = -0.6;
                this.btn_fight.visible = false;
                this.btn_fight.mouseEnabled = false;
                this.btn_fight.transform.colorTransform = this.color;
                this.eventHandler.removeListener(this.btn_fight, MouseEvent.CLICK, this.startBattle);
            };
            while (this.loader_0.numChildren > 0)
            {
                this.loader_0.removeChildAt(0);
            };
            while (this.loader_1.numChildren > 0)
            {
                this.loader_1.removeChildAt(0);
            };
            var _local_3:* = 0;
            while (_local_3 < 6)
            {
                this.dropMC[("iconMC" + _local_3)].visible = false;
                while (this.dropMC[("iconMC" + _local_3)].iconHolder.numChildren > 0)
                {
                    this.dropMC[("iconMC" + _local_3)].iconHolder.removeChildAt(0);
                };
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < _local_2.rewards.length)
            {
                this.dropMC[("iconMC" + _local_3)].visible = true;
                this.eventHandler.addListener(this.dropMC[("iconMC" + _local_3)], MouseEvent.ROLL_OVER, this.toolTiponOver, false, 0, true);
                this.eventHandler.addListener(this.dropMC[("iconMC" + _local_3)], MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                _local_6 = _local_2.rewards[_local_3];
                _local_7 = _local_6.split("_");
                _local_8 = Library.getItemInfo(_local_6);
                if (_local_7[0] == "wpn")
                {
                    _local_9 = "items";
                    _local_10 = new Array(_local_8["item_name"], _local_8["item_level"], _local_8["item_damage"], _local_8["item_description"]);
                }
                else
                {
                    _local_9 = "materials";
                    _local_10 = new Array(_local_8["item_name"], _local_8["item_level"], _local_8["item_description"]);
                };
                this.array_info_holder.push(_local_10);
                this.rewardsArray.push(_local_6);
                GF.removeAllChild(this.dropMC[("iconMC" + _local_3)].iconHolder);
                NinjaSage.loadIconSWF(_local_9, _local_6, this.dropMC[("iconMC" + _local_3)]);
                _local_3++;
            };
            var _local_4:* = 0;
            var _local_5:* = _local_2.id;
            while (_local_4 < _local_5.length)
            {
                NinjaSage.loadIconSWF("enemy", _local_5[_local_4], this[("loader_" + _local_4)], "StatichuntingHouse");
                _local_4++;
            };
        }

        internal function startBattle(_arg_1:MouseEvent):void
        {
            if (int(Character.character_lvl) >= 10)
            {
                this.main.loading(true);
                this.main.amf_manager.service("HuntingHouse.startHunting", [Character.char_id, this.boss_num, Character.sessionkey], this.onStartHuntingAmf);
            };
        }

        public function onStartHuntingAmf(_arg_1:*):*
        {
            var _local_2:*;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                _local_2 = this.loadBossData(this.boss_num);
                Character.mission_id = _local_2["msn_bg"];
                Character.is_christmas_event = false;
                Character.is_hunting_house = false;
                Character.battle_code = _arg_1.code;
                Character.battle_characters = [("char_" + Character.char_id)];
                Character.battle_enemies = this.boss_id;
                this.main.combat = this.main.loadPanel("Panels.Combat", true);
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

        internal function loadBossData(_arg_1:int):*
        {
            var _local_2:* = {};
            switch (_arg_1)
            {
                case 0:
                    _local_2.id = ["ene_81"];
                    _local_2.num = 0;
                    _local_2.name = "Ginkotsu";
                    _local_2.msn_bg = "mission_21";
                    _local_2.lvl = "10";
                    _local_2.rank = 4;
                    _local_2.desc = "These wolf-like Ginkotsu live in the forest between the Wind Village and the Fire Village. \nThey are the best hunters in the forest. They always attack adventurers and passersby in the forest.";
                    _local_2.rewards = ["wpn_121", "material_01", "material_02"];
                    _local_2.gold = 4000;
                    _local_2.xp = 1491;
                    break;
                case 1:
                    _local_2.id = ["ene_82"];
                    _local_2.num = 1;
                    _local_2.name = "Shikigami Yanki";
                    _local_2.msn_bg = "mission_22";
                    _local_2.lvl = "20";
                    _local_2.rank = 4;
                    _local_2.desc = "Summoned by Kojima. Kojima ordered Yanki to protect Kojima's Third Laboratory.\nYanki will not allow anyone to enter the laboratory.";
                    _local_2.rewards = ["wpn_123", "material_01", "material_02", "material_03"];
                    _local_2.gold = 5000;
                    _local_2.xp = 4078;
                    break;
                case 2:
                    _local_2.id = ["ene_83"];
                    _local_2.num = 2;
                    _local_2.name = "Gedo Sessho Seki";
                    _local_2.msn_bg = "mission_83";
                    _local_2.lvl = "25";
                    _local_2.rank = 3;
                    _local_2.desc = "Summoned by Kojima, Gedo Sessho Seki is the guardian of his Third Laboratory.";
                    _local_2.rewards = ["wpn_152", "material_01", "material_02", "material_03"];
                    _local_2.gold = 6000;
                    _local_2.xp = 6745;
                    break;
                case 3:
                    _local_2.id = ["ene_84", "ene_85"];
                    _local_2.num = 3;
                    _local_2.name = "Tengu";
                    _local_2.msn_bg = "mission_84";
                    _local_2.lvl = "30";
                    _local_2.rank = 3;
                    _local_2.desc = "Kojima used Kinjutsu to turn dead bodies into these zombie Tengu.\nThese Tengu can recall and use all jutsu they learned when they were alive. Only the summoner may control them.";
                    _local_2.rewards = ["wpn_120", "wpn_122", "material_01", "material_02", "material_03", "material_04"];
                    _local_2.gold = 7000;
                    _local_2.xp = 10602;
                    break;
                case 4:
                    _local_2.id = ["ene_86"];
                    _local_2.num = 4;
                    _local_2.name = "Byakko";
                    _local_2.msn_bg = "mission_86";
                    _local_2.lvl = "40";
                    _local_2.rank = 2;
                    _local_2.desc = "Many years ago, an escaped ninja attempted to use a Kinjutsu to merge his body with the summon monster 'Byakko' to gain immortality. \nHe failed. 'Byakko' devoured him - it is a violent and cruel monster.";
                    _local_2.rewards = ["wpn_124", "material_01", "material_02", "material_03", "material_04", "material_05"];
                    _local_2.gold = 14000;
                    _local_2.xp = 17834;
                    break;
                case 5:
                    _local_2.id = ["ene_106"];
                    _local_2.num = 5;
                    _local_2.name = "Ape King";
                    _local_2.msn_bg = "mission_106";
                    _local_2.lvl = "50";
                    _local_2.rank = 2;
                    _local_2.desc = "Living in the Ape Mountain, Ape King is the leader of all apes.";
                    _local_2.rewards = ["wpn_276", "material_01", "material_02", "material_03", "material_04", "material_05"];
                    _local_2.gold = 20000;
                    _local_2.xp = 48750;
                    break;
                case 6:
                    _local_2.id = ["ene_120"];
                    _local_2.num = 6;
                    _local_2.name = "Battle Turtle";
                    _local_2.msn_bg = "mission_120";
                    _local_2.lvl = "55";
                    _local_2.rank = 2;
                    _local_2.desc = "Originated from the north, the Battle Turtle is known of its age, which is signified by the thorns on its shell.";
                    _local_2.rewards = ["wpn_330", "material_01", "material_02", "material_03", "material_04", "material_05"];
                    _local_2.gold = 25000;
                    _local_2.xp = 58152;
                    break;
                case 7:
                    _local_2.id = ["ene_155"];
                    _local_2.num = 7;
                    _local_2.name = "Soul General Mutoh";
                    _local_2.msn_bg = "mission_155";
                    _local_2.lvl = "60";
                    _local_2.rank = 1;
                    _local_2.desc = "Once dead, but resurrected with (Kinjutsu: Reverse Soul Resurrection), Soul General is now a rank SS-criminal who escaped to the Samu Village and serve as a secret weapon.";
                    _local_2.rewards = ["wpn_786", "material_03", "material_04", "material_05"];
                    _local_2.gold = 30000;
                    _local_2.xp = 68225;
            };
            if (!_local_2.hasOwnProperty("name"))
            {
                _local_2.id = null;
                _local_2.name = null;
            };
            return (_local_2);
        }

        public function toolTiponOver(_arg_1:MouseEvent):void
        {
            var _local_2:* = _arg_1.currentTarget.name;
            _local_2 = _local_2.replace("iconMC", "");
            var _local_3:* = this.rewardsArray[int(_local_2)];
            var _local_4:* = _local_3.split("_");
            var _local_5:* = "";
            switch (_local_4[0])
            {
                case "wpn":
                    _local_5 = (((((((("" + this.array_info_holder[int(_local_2)][0]) + "\n(Weapon)\n") + "\nLevel ") + this.array_info_holder[int(_local_2)][1]) + "\nDamage : ") + this.array_info_holder[int(_local_2)][2]) + "\n\n") + this.array_info_holder[int(_local_2)][3]);
                    break;
                case "material":
                    _local_5 = (((((("" + this.array_info_holder[int(_local_2)][0]) + "\n(Material)\n") + "\nLevel ") + this.array_info_holder[int(_local_2)][1]) + "\n\n") + this.array_info_holder[int(_local_2)][2]);
            };
            stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_5);
        }

        internal function toolTiponOut(_arg_1:MouseEvent):void
        {
            this.tooltip.hide();
        }

        internal function killEverything():void
        {
            this.eventHandler.removeAllEventListeners();
            var _local_1:* = 0;
            while (_local_1 < 6)
            {
                GF.removeAllChild(this.dropMC[("iconMC" + _local_1)].iconHolder);
                _local_1++;
            };
            NinjaSage.clearLoader();
            this.color = null;
            this.enemy_data = null;
            this.main = null;
            this.tooltip = null;
            this.popup = null;
            this.eventHandler = null;
            GF.removeAllChild(this);
            System.gc();
        }

        internal function closePanel(_arg_1:MouseEvent):void
        {
            this.killEverything();
            parent.removeChild(this);
        }


    }
}//package Panels

