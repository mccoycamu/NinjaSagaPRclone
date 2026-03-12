// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.EudemonGarden

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import Storage.GameData;
    import fl.motion.Color;
    import flash.events.MouseEvent;
    import Storage.Character;
    import com.utils.GF;
    import Storage.Library;
    import Managers.NinjaSage;
    import Combat.BattleManager;
    import Combat.BattleVars;
    import com.hurlant.crypto.Crypto;
    import flash.utils.ByteArray;
    import com.hurlant.util.Hex;
    import flash.system.System;

    public class EudemonGarden extends MovieClip 
    {

        public var panelMC:MovieClip;
        public var main:*;
        public var boss_rn:int = 0;
        public var curr_page:int = 1;
        public var itemCnt:int = 0;
        public var total_page:int = 1;
        public var boss_id:String = "";
        public var boss_num:int = -1;

        private var gameData:* = GameData.get("eudemon");
        public var enemy_data:Array = [];
        public var bossList:* = gameData.bosses.length;
        public var curr_page_boss:Array = [];
        public var color:Color = new Color();

        public function EudemonGarden(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2;
            this.panelMC.popup.visible = false;
            this.panelMC.btn_close.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.panelMC.btn_reset.addEventListener(MouseEvent.CLICK, this.openPop);
            this.panelMC.btn_Blacksmith.addEventListener(MouseEvent.CLICK, this.openBlacksmith);
            this.panelMC.btn_Recruit.addEventListener(MouseEvent.CLICK, this.openSocial);
            this.panelMC.btn_next.addEventListener(MouseEvent.CLICK, this.changePage);
            this.panelMC.btn_prev.addEventListener(MouseEvent.CLICK, this.changePage);
            this.getData();
        }

        internal function getData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("EudemonGarden.getData", [Character.sessionkey, Character.char_id], this.dataResponse);
        }

        internal function openBlacksmith(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Blacksmith");
        }

        internal function openSocial(_arg_1:MouseEvent):void
        {
            this.main.loadExternalSwfPanel("Social", "Social");
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
            this.panelMC.popup.visible = true;
            var _local_2:int = ((int(Character.character_lvl) >= 80) ? 80 : 50);
            this.panelMC.popup.txt.text = (("Confirm restoring all Hunting House tries for " + _local_2) + " Tokens ? ");
            this.panelMC.popup.btn_close.removeEventListener(MouseEvent.CLICK, this.closePop);
            this.panelMC.popup.btn_close.addEventListener(MouseEvent.CLICK, this.closePop);
            this.panelMC.popup.bg.removeEventListener(MouseEvent.CLICK, this.closePop);
            this.panelMC.popup.bg.addEventListener(MouseEvent.CLICK, this.closePop);
            this.panelMC.popup.btn_confirm.removeEventListener(MouseEvent.CLICK, this.resetTries);
            this.panelMC.popup.btn_confirm.addEventListener(MouseEvent.CLICK, this.resetTries);
        }

        internal function closePop(_arg_1:MouseEvent):void
        {
            this.panelMC.popup.visible = false;
        }

        internal function resetTries(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("EudemonGarden.buyTries", [Character.sessionkey, Character.char_id], this.buyResponse);
        }

        internal function buyResponse(_arg_1:Object):void
        {
            var _local_4:int;
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            this.panelMC.popup.visible = false;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                _local_4 = ((int(Character.character_lvl) >= 80) ? 80 : 50);
                Character.account_tokens = (Character.account_tokens - _local_4);
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
                    this.itemCnt = (this.itemCnt + 5);
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
            this.panelMC.pageTxt.text = ((this.curr_page + "/") + this.total_page);
        }

        internal function loadBasicData(_arg_1:Array, _arg_2:*):void
        {
            var _local_6:*;
            var _local_7:*;
            this.main.handleVillageHUDVisibility(false);
            var _local_3:* = undefined;
            var _local_4:* = 5;
            this.total_page = int(((this.bossList / 5) + 1));
            if (this.bossList < 6)
            {
                _local_4 = this.bossList;
                this.total_page = 1;
            };
            if ((this.bossList % 5) == 0)
            {
                this.total_page = (this.bossList / 5);
            };
            this.panelMC.pageTxt.text = ((this.curr_page + "/") + this.total_page);
            var _local_5:* = 0;
            while (_local_5 < 5)
            {
                _local_3 = this.loadBossData(_arg_2);
                _local_6 = (_local_5 + int((int((this.curr_page - 1)) * 5)));
                if (this.bossList > _local_6)
                {
                    this.panelMC[("boss_" + _local_5)].visible = true;
                    _local_7 = {"bossTnc":_arg_2};
                    this.panelMC[("boss_" + _local_5)].gotoAndStop(1);
                    this.panelMC[("boss_" + _local_5)]["txt_name"].text = _local_3.name;
                    this.panelMC[("boss_" + _local_5)]["txt_lvl"].text = _local_3.lvl;
                    this.panelMC[("boss_" + _local_5)]["txt_attempt"].text = ("x" + _arg_1[_arg_2]);
                    this.panelMC[("boss_" + _local_5)]["rankMC"].gotoAndStop(_local_3.rank);
                    if (int(Character.character_lvl) >= int(_local_3.lvl))
                    {
                        if (_arg_1[_arg_2] > 0)
                        {
                            this.color.brightness = 0;
                            this.panelMC[("lock_" + _local_5)].visible = false;
                            this.panelMC[("boss_" + _local_5)]["clickmask"].buttonMode = true;
                            this.panelMC[("boss_" + _local_5)].transform.colorTransform = this.color;
                            this.panelMC[("boss_" + _local_5)]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER, this.bossOver);
                            this.panelMC[("boss_" + _local_5)]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT, this.bossOut);
                            this.panelMC[("boss_" + _local_5)]["clickmask"].removeEventListener(MouseEvent.CLICK, this.bossClick);
                            this.panelMC[("boss_" + _local_5)]["clickmask"].addEventListener(MouseEvent.MOUSE_OVER, this.bossOver);
                            this.panelMC[("boss_" + _local_5)]["clickmask"].addEventListener(MouseEvent.MOUSE_OUT, this.bossOut);
                            this.panelMC[("boss_" + _local_5)]["clickmask"].addEventListener(MouseEvent.CLICK, this.bossClick);
                        }
                        else
                        {
                            this.color.brightness = -0.3;
                            this.panelMC[("lock_" + _local_5)].visible = false;
                            this.panelMC[("boss_" + _local_5)]["clickmask"].buttonMode = true;
                            this.panelMC[("boss_" + _local_5)].transform.colorTransform = this.color;
                            this.panelMC[("boss_" + _local_5)]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER, this.bossOver);
                            this.panelMC[("boss_" + _local_5)]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT, this.bossOut);
                            this.panelMC[("boss_" + _local_5)]["clickmask"].removeEventListener(MouseEvent.CLICK, this.bossClick);
                            this.panelMC[("boss_" + _local_5)]["clickmask"].addEventListener(MouseEvent.MOUSE_OVER, this.bossOver);
                            this.panelMC[("boss_" + _local_5)]["clickmask"].addEventListener(MouseEvent.MOUSE_OUT, this.bossOut);
                            this.panelMC[("boss_" + _local_5)]["clickmask"].addEventListener(MouseEvent.CLICK, this.bossClick);
                        };
                    }
                    else
                    {
                        this.color.brightness = -0.3;
                        this.panelMC[("lock_" + _local_5)].visible = true;
                        this.panelMC[("boss_" + _local_5)]["clickmask"].buttonMode = false;
                        this.panelMC[("boss_" + _local_5)].transform.colorTransform = this.color;
                        this.panelMC[("boss_" + _local_5)]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER, this.bossOver);
                        this.panelMC[("boss_" + _local_5)]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT, this.bossOut);
                        this.panelMC[("boss_" + _local_5)]["clickmask"].removeEventListener(MouseEvent.CLICK, this.bossClick);
                    };
                    this.panelMC[("boss_" + _local_5)]["clickmask"].metaData = _local_7;
                }
                else
                {
                    this.panelMC[("boss_" + _local_5)].visible = false;
                    this.panelMC[("lock_" + _local_5)].visible = false;
                };
                _arg_2++;
                _local_5++;
            };
            this.selectBoss(this.itemCnt);
            this.panelMC["boss_0"].gotoAndStop(3);
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
                this.panelMC[("boss_" + _local_2)].gotoAndStop(1);
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
            var _local_2:* = this.loadBossData(_arg_1);
            Character.hunting_house_boss_id = (this.boss_id = _local_2.id);
            Character.hunting_house_boss_num = (this.boss_num = _local_2.num);
            this.panelMC.txt_desc.text = _local_2.desc;
            this.panelMC.txt_xp.text = _local_2.xp;
            this.panelMC.txt_gold.text = _local_2.gold;
            if (this.enemy_data[_arg_1] > 0)
            {
                this.color.brightness = 0;
                this.panelMC.btn_fight.visible = true;
                this.panelMC.btn_fight.mouseEnabled = true;
                this.panelMC.btn_fight.transform.colorTransform = this.color;
                this.panelMC.btn_fight.removeEventListener(MouseEvent.CLICK, this.startBattle);
                this.panelMC.btn_fight.addEventListener(MouseEvent.CLICK, this.startBattle);
            }
            else
            {
                this.color.brightness = -0.6;
                this.panelMC.btn_fight.visible = false;
                this.panelMC.btn_fight.mouseEnabled = false;
                this.panelMC.btn_fight.transform.colorTransform = this.color;
                this.panelMC.btn_fight.removeEventListener(MouseEvent.CLICK, this.startBattle);
            };
            GF.removeAllChild(this.panelMC.loader_0);
            GF.removeAllChild(this.panelMC.loader_1);
            var _local_3:* = 0;
            while (_local_3 < 14)
            {
                this.panelMC.dropMC[("iconMC" + _local_3)].visible = false;
                while (this.panelMC.dropMC[("iconMC" + _local_3)].iconHolder.numChildren > 0)
                {
                    this.panelMC.dropMC[("iconMC" + _local_3)].iconHolder.removeChildAt(0);
                };
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < _local_2.rewards.length)
            {
                this.panelMC.dropMC[("iconMC" + _local_3)].visible = true;
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
                GF.removeAllChild(this.panelMC.dropMC[("iconMC" + _local_3)].iconHolder);
                NinjaSage.loadItemIcon(this.panelMC.dropMC[("iconMC" + _local_3)].iconHolder, _local_6, "icon");
                _local_3++;
            };
            var _local_4:* = 0;
            var _local_5:* = _local_2.id;
            while (_local_4 < _local_5.length)
            {
                NinjaSage.loadIconSWF("enemy", _local_5[_local_4], this.panelMC[("loader_" + _local_4)], "StatichuntingHouse");
                _local_4++;
            };
        }

        internal function startBattle(_arg_1:MouseEvent):void
        {
            if (((Character.character_skill_set == "") || (Character.character_skill_set == null)))
            {
                this.main.showMessage("Please equip at least 1 skill");
                return;
            };
            if (int(Character.character_lvl) >= 10)
            {
                this.main.loading(true);
                this.main.amf_manager.service("EudemonGarden.startHunting", [Character.char_id, this.boss_num, Character.sessionkey], this.onStartHuntingAmf);
            };
        }

        public function onStartHuntingAmf(_arg_1:*):*
        {
            var _local_2:*;
            var _local_3:int;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                _local_2 = this.loadBossData(this.boss_num);
                Character.is_eudemon_garden = true;
                Character.eudemon_boss_num = this.boss_num;
                Character.battle_code = _arg_1.code;
                if (_arg_1.hash != this.__hash(((Character.char_id + Character.battle_code) + this.boss_num)))
                {
                    this.main.loading(false);
                    this.main.showMessage("Invalid hash, please try again or re-logout");
                    return;
                };
                this.main.combat = this.main.loadPanel("Combat.Battle", true);
                BattleManager.init(this.main.combat, this.main, BattleVars.EVENT_MATCH, _local_2["bg"]);
                BattleManager.addPlayerToTeam("player", ("char_" + Character.char_id));
                _local_3 = 0;
                while (_local_3 < _local_2.id.length)
                {
                    BattleManager.addPlayerToTeam("enemy", _local_2.id[_local_3]);
                    _local_3++;
                };
                BattleManager.startBattle();
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

        internal function loadBossData(_arg_1:int):*
        {
            return (this.gameData.bosses[_arg_1]);
        }

        private function __hash(_arg_1:*):*
        {
            var _local_2:ByteArray = Crypto.getHash("sha256").hash(Crypto.bytesArray(_arg_1));
            return (Hex.fromArray(_local_2));
        }

        public function destroy():void
        {
            this.main.handleVillageHUDVisibility(true);
            this.panelMC.btn_close.removeEventListener(MouseEvent.CLICK, this.closePanel);
            this.panelMC.btn_reset.removeEventListener(MouseEvent.CLICK, this.openPop);
            this.panelMC.btn_Blacksmith.removeEventListener(MouseEvent.CLICK, this.openBlacksmith);
            this.panelMC.btn_Recruit.removeEventListener(MouseEvent.CLICK, this.openSocial);
            this.panelMC.btn_next.removeEventListener(MouseEvent.CLICK, this.changePage);
            this.panelMC.btn_prev.removeEventListener(MouseEvent.CLICK, this.changePage);
            this.panelMC.popup.btn_close.removeEventListener(MouseEvent.CLICK, this.closePop);
            this.panelMC.popup.bg.removeEventListener(MouseEvent.CLICK, this.closePop);
            this.panelMC.popup.btn_confirm.removeEventListener(MouseEvent.CLICK, this.resetTries);
            var _local_1:int;
            while (_local_1 < 5)
            {
                this.panelMC[("boss_" + _local_1)]["clickmask"].removeEventListener(MouseEvent.MOUSE_OVER, this.bossOver);
                this.panelMC[("boss_" + _local_1)]["clickmask"].removeEventListener(MouseEvent.MOUSE_OUT, this.bossOut);
                this.panelMC[("boss_" + _local_1)]["clickmask"].removeEventListener(MouseEvent.CLICK, this.bossClick);
                _local_1++;
            };
            this.panelMC.btn_fight.removeEventListener(MouseEvent.CLICK, this.startBattle);
            GF.removeAllChild(this.panelMC.loader_0);
            GF.removeAllChild(this.panelMC.loader_1);
            _local_1 = 0;
            while (_local_1 < 14)
            {
                GF.removeAllChild(this.panelMC.dropMC[("iconMC" + _local_1)].iconHolder);
                _local_1++;
            };
            this.main.removeExternalSwfPanel();
            NinjaSage.clearLoader();
            this.color = null;
            this.enemy_data = null;
            this.main = null;
            this.gameData = null;
            GF.removeAllChild(this.panelMC);
            System.gc();
        }

        internal function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }


    }
}//package id.ninjasage.features

