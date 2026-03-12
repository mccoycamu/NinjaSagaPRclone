// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Battle_UI_Gear

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import com.abrahamyan.liquid.ToolTip;
    import id.ninjasage.EventHandler;
    import Storage.Library;
    import flash.events.MouseEvent;
    import com.utils.GF;
    import Managers.NinjaSage;
    import flash.system.System;
    import Storage.Character;
    import Combat.BattleManager;
    import Combat.BattleVars;
    import id.ninjasage.multiplayer.battle.BattleAnimationEvent;
    import flash.utils.setTimeout;
    import Combat.BattleTimer;
    import id.ninjasage.Log;
    import flash.utils.getQualifiedClassName;

    public class Battle_UI_Gear extends MovieClip 
    {

        public var btn_close:SimpleButton;
        public var btn_next:SimpleButton;
        public var btn_prev:SimpleButton;
        public var item_0:MovieClip;
        public var item_1:MovieClip;
        public var item_2:MovieClip;
        public var item_3:MovieClip;
        public var item_4:MovieClip;
        public var item_5:MovieClip;
        public var item_6:MovieClip;
        public var item_7:MovieClip;
        public var item_8:MovieClip;
        public var item_9:MovieClip;
        public var txt_page:TextField;
        public var main:*;
        public var combat:*;
        public var current_page:* = 1;
        public var total_page:* = 1;
        public var current_number:* = 0;
        public var usable_items:Array = [];
        public var character_usable_items:Array = [];
        public var array_info_holder:Array = [];
        public var tooltip:ToolTip;
        public var cache:Object;
        public var eventHandler:* = new EventHandler();

        public function Battle_UI_Gear(_arg_1:*=null, _arg_2:*=null, _arg_3:int=0)
        {
            this.usable_items = Library.getConsumableIds();
            super();
            if ((((!(_arg_1 == null)) && (_arg_2 == null)) && (_arg_3 == 0)))
            {
                this.main = _arg_1;
                this.combat = this.main.combat;
                this.current_number = (((!(this.combat == null)) && (!(this.combat.agility_bar_manager == null))) ? this.combat.agility_bar_manager.ambush_num : 0);
            }
            else
            {
                this.combat = _arg_1;
                this.main = _arg_2;
                this.current_number = _arg_3;
            };
            this.tooltip = ToolTip.getInstance();
            this.hideItems();
            this.getUsableItemsAndUpdateDisplay();
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
        }

        internal function closePanel(_arg_1:MouseEvent=null):void
        {
            this.btn_prev.removeEventListener(MouseEvent.CLICK, this.changePagination);
            this.btn_next.removeEventListener(MouseEvent.CLICK, this.changePagination);
            this.btn_close.removeEventListener(MouseEvent.CLICK, this.closePanel);
            this.btn_prev = null;
            this.btn_next = null;
            this.btn_close = null;
            var _local_2:int;
            while (_local_2 < 10)
            {
                GF.removeAllChild(this[("item_" + _local_2)].iconMc.iconHolder);
                this[("item_" + _local_2)] = null;
                _local_2++;
            };
            if (((!(this.combat == null)) && (!(this.combat.gear == null))))
            {
                this.combat.gear = null;
                if (parent)
                {
                    parent.removeChild(this);
                };
            };
            NinjaSage.clearLoader();
            this.destroy();
            System.gc();
        }

        public function hideItems():void
        {
            var _local_1:int;
            while (_local_1 < 10)
            {
                this[("item_" + _local_1)].gotoAndStop(1);
                this[("item_" + _local_1)].visible = false;
                _local_1++;
            };
        }

        public function getUsableItemsAndUpdateDisplay():void
        {
            var _local_1:String = Character.character_consumables;
            if (_local_1 == "")
            {
                this.character_usable_items = [];
                this.current_page = 1;
                this.total_page = 1;
                this.updatePageNumberDisplay();
                this.displayUsableItems();
                return;
            };
            var _local_2:Array = ((_local_1.indexOf(",") >= 0) ? _local_1.split(",") : [_local_1]);
            this.character_usable_items = _local_2.filter(this.filterUsableItems, null);
            this.current_page = 1;
            this.total_page = Math.ceil((this.character_usable_items.length / 10));
            this.updatePageNumberDisplay();
            this.displayUsableItems();
        }

        private function filterUsableItems(_arg_1:String, _arg_2:int, _arg_3:Array):Boolean
        {
            var _local_4:String = _arg_1.split(":")[0];
            return (this.usable_items.indexOf(_local_4) >= 0);
        }

        public function updatePageNumberDisplay():void
        {
            this.txt_page.text = ((this.current_page + "/") + this.total_page);
            if (!this.btn_prev.hasEventListener(MouseEvent.CLICK))
            {
                this.eventHandler.addListener(this.btn_prev, MouseEvent.CLICK, this.changePagination);
            };
            if (!this.btn_next.hasEventListener(MouseEvent.CLICK))
            {
                this.eventHandler.addListener(this.btn_next, MouseEvent.CLICK, this.changePagination);
            };
        }

        public function changePagination(_arg_1:MouseEvent):void
        {
            var _local_2:String = _arg_1.currentTarget.name;
            if (((_local_2 == "btn_prev") && (this.current_page > 1)))
            {
                this.current_page--;
            }
            else
            {
                if (((_local_2 == "btn_next") && (this.current_page < this.total_page)))
                {
                    this.current_page++;
                };
            };
            this.displayUsableItems();
            this.txt_page.text = ((this.current_page + "/") + this.total_page);
        }

        public function displayUsableItems():void
        {
            var _local_2:String;
            var _local_3:String;
            var _local_4:Object;
            var _local_5:Array;
            var _local_7:Array;
            var _local_8:Object;
            this.hideItems();
            this.array_info_holder = [];
            var _local_1:int;
            var _local_6:int;
            while (_local_6 < 10)
            {
                _local_1 = (_local_6 + ((this.current_page - 1) * 10));
                if (this.character_usable_items.length <= _local_1) break;
                _local_7 = this.character_usable_items[_local_1].split(":");
                _local_3 = _local_7[0];
                _local_2 = _local_7[1];
                _local_4 = Library.getItemInfo(_local_3);
                _local_5 = [_local_4["item_name"], _local_4["item_level"], _local_4["item_description"]];
                this.array_info_holder.push(_local_5);
                _local_8 = this[("item_" + _local_6)];
                GF.removeAllChild(_local_8.iconMc.iconHolder);
                NinjaSage.loadIconSWF("consumables", _local_3, _local_8.iconMc);
                this.eventHandler.addListener(_local_8, MouseEvent.ROLL_OVER, this.toolTiponOver, false, 0, true);
                this.eventHandler.addListener(_local_8, MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                _local_8.amtTxt.text = ("x" + _local_2);
                _local_8.lvlTxt.text = _local_4.item_level;
                _local_8.visible = true;
                _local_8.btn_use.visible = true;
                _local_8.lockMc.visible = false;
                if (int(_local_4.item_level) > int(Character.character_lvl))
                {
                    _local_8.lockMc.visible = true;
                    _local_8.btn_use.visible = false;
                }
                else
                {
                    this.eventHandler.addListener(_local_8.btn_use, MouseEvent.CLICK, this.handleItemUse);
                };
                _local_6++;
            };
        }

        internal function toolTiponOver(_arg_1:MouseEvent):void
        {
            var _local_2:String = String(_arg_1.currentTarget.name).replace("item_", "");
            var _local_3:int = int(_local_2);
            var _local_4:Array = this.array_info_holder[_local_3];
            var _local_5:String = (((((_local_4[0] + "\n(Item)\n") + "\nLevel ") + _local_4[1]) + "\n\n") + _local_4[2]);
            stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_5);
        }

        public function toolTiponOut(_arg_1:MouseEvent):void
        {
            this.tooltip.hide();
        }

        public function handleItemUse(_arg_1:MouseEvent):void
        {
            var _local_4:*;
            var _local_5:*;
            this.visible = false;
            var _local_2:int = _arg_1.currentTarget.parent.name.replace("item_", "");
            var _local_3:int = (_local_2 + ((this.current_page - 1) * 10));
            var _local_6:* = (_local_4 = this.character_usable_items[_local_3].split(":"))[0];
            var _local_7:* = (_local_5 = Library.getItemInfo(_local_6)).effect;
            if ((((_local_6 == "item_52") || (_local_6 == "item_53")) || (_local_6 == "item_54")))
            {
                if (BattleManager.BATTLE_VARS.BATTLE_MODE != BattleVars.DRAGON_HUNT_MATCH)
                {
                    if (this.main != null)
                    {
                        this.main.showMessage("Sealing Scroll can be used during Dragon Hunt Battles.");
                    };
                    return;
                };
            };
            if (((_local_6 == "item_58") && (!(Character.is_cny_event))))
            {
                if (this.main != null)
                {
                    this.main.showMessage("Chinese Sealing Scroll can be used during Chinese New Year Battles.");
                };
                return;
            };
            dispatchEvent(new BattleAnimationEvent(BattleAnimationEvent.ITEM_USE, false, false, _local_6));
            this.cache = {
                "id":_local_6,
                "effect":_local_7
            };
            if (((!(this.main == null)) && (!(this.main.amf_manager == null))))
            {
                this.main.amf_manager.service("CharacterService.useBattleItem", [Character.sessionkey, Character.char_id, _local_6], this.onUserItemResponse);
            }
            else
            {
                this.onUseItem();
            };
        }

        public function onUseItem():void
        {
            var _local_1:String = this.cache.id;
            var _local_2:Array = this.cache.effect;
            var _local_3:Boolean;
            var _local_4:Boolean;
            if ((((_local_1 == "item_52") || (_local_1 == "item_53")) || (_local_1 == "item_58")))
            {
                if (this.combat != null)
                {
                    _local_3 = ((_local_1 == "item_53") || (this.combat.checkSealEnemy()));
                    if (_local_3)
                    {
                        if (this.main != null)
                        {
                            this.main.showMessage("Capture Success!");
                        };
                        if (this.combat.preCaptureEnemy != null)
                        {
                            setTimeout(this.combat.preCaptureEnemy, 200);
                        };
                        if (this.combat.captureEnemy != null)
                        {
                            setTimeout(this.combat.captureEnemy, 1200);
                        };
                    }
                    else
                    {
                        if (this.main != null)
                        {
                            this.main.showMessage("Capture failed, try again");
                        };
                        setTimeout(BattleManager.startRun, 500);
                    };
                };
            }
            else
            {
                if (_local_1 == "item_01")
                {
                    setTimeout(this.onRunWithItem, 200);
                    return;
                };
                if (_local_1 == "item_54")
                {
                    if (((!(this.combat == null)) && (!(this.combat.showPercentageHpOfEnemy == null))))
                    {
                        setTimeout(this.combat.showPercentageHpOfEnemy, 500);
                    };
                    this.recoverWithItem(_local_2);
                }
                else
                {
                    this.recoverWithItem(_local_2);
                };
            };
            if ((((!(this.combat == null)) && (!(this.combat.character_team_players == null))) && (!(this.combat.character_team_players[this.current_number] == null))))
            {
                this.combat.character_team_players[this.current_number].gotoAndPlay("item");
                if (this.combat.character_team_players[this.current_number].actions_manager != null)
                {
                    this.combat.character_team_players[this.current_number].actions_manager.setActionBarVisible(false);
                };
            };
            this.tooltip.hide();
            BattleTimer.stopTurnTimer();
            Character.removeConsumables(_local_1, 1);
            Character.battle_logs.push({
                "_":"DH",
                "__":_local_1
            });
            this.closePanel(null);
        }

        private function recoverWithItem(_arg_1:Array):void
        {
            var _local_4:Object;
            var _local_5:Number;
            if ((((this.combat == null) || (this.combat.character_team_players == null)) || (this.combat.character_team_players[this.current_number] == null)))
            {
                return;
            };
            var _local_2:Object = this.combat.character_team_players[this.current_number];
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_4 = _arg_1[_local_3];
                if (_local_4.hasOwnProperty("recover"))
                {
                    _local_5 = 0;
                    switch (_local_4.name)
                    {
                        case "hp_percent":
                            _local_5 = Math.floor(((_local_2.health_manager.max_hp * _local_4.recover) / 100));
                            break;
                        case "hp_number":
                            _local_5 = _local_4.recover;
                            break;
                        case "cp_percent":
                            _local_5 = Math.floor(((_local_2.health_manager.max_cp * _local_4.recover) / 100));
                            break;
                        case "cp_number":
                            _local_5 = _local_4.recover;
                            break;
                        case "sp_percent":
                            _local_5 = Math.floor(((_local_2.health_manager.max_sp * _local_4.recover) / 100));
                            break;
                        case "sp_number":
                            _local_5 = _local_4.recover;
                            break;
                        default:
                            _local_5 = 0;
                    };
                    if (_local_5 > 0)
                    {
                        _local_5 = _local_2.effects_manager.increaseRecoverByEffects(_local_5, ((_local_4.name.indexOf("hp") != -1) ? "hp" : "cp"));
                        if (_local_4.name.indexOf("hp") != -1)
                        {
                            _local_2.health_manager.addHealth(_local_5, "HealMC ");
                        }
                        else
                        {
                            if (_local_4.name.indexOf("cp") != -1)
                            {
                                _local_2.health_manager.addCP(_local_5);
                            }
                            else
                            {
                                if (_local_4.name.indexOf("sp") != -1)
                                {
                                    _local_2.health_manager.addSP("Recover SP +", _local_5);
                                };
                            };
                        };
                    };
                }
                else
                {
                    if (_local_4.type === "Buff")
                    {
                        _local_2.effects_manager.addBuff(_local_4);
                    }
                    else
                    {
                        _local_2.effects_manager.addDebuff(_local_4);
                    };
                };
                _local_3++;
            };
            setTimeout(BattleManager.startRun, 750);
        }

        public function onUserItemResponse(_arg_1:Object):void
        {
            if (_arg_1.status == 1)
            {
                this.onUseItem();
            }
            else
            {
                if (((!(this.main == null)) && (!(this.main.giveMessage == null))))
                {
                    this.main.giveMessage(_arg_1.result);
                };
            };
        }

        public function onRunWithItem():void
        {
            if ((((!(this.combat == null)) && (!(this.combat.character_team_players == null))) && (!(this.combat.character_team_players[this.current_number] == null))))
            {
                this.combat.character_team_players[this.current_number].gotoAndPlay("smoke");
                try
                {
                    if (BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.EXAM_MATCH)
                    {
                        Character.character_class = null;
                    };
                }
                catch(e)
                {
                };
                if (this.combat.character_team_players[this.current_number].actions_manager != null)
                {
                    this.combat.character_team_players[this.current_number].actions_manager.setActionBarVisible(false);
                };
            };
            var _local_1:* = BattleManager.getBattle();
            if (_local_1 != null)
            {
                _local_1.resetGameModes();
                if (_local_1._main != null)
                {
                    _local_1._main.battleRewards("0", "0", "Run", false);
                };
            };
            System.gc();
            this.closePanel(null);
        }

        public function destroy():void
        {
            Log.debug(this, "DESTROY", getQualifiedClassName(this));
            GF.removeAllChild(this);
            GF.clearArray(this.character_usable_items);
            GF.clearArray(this.array_info_holder);
            if (this.eventHandler)
            {
                this.eventHandler.removeAllEventListeners();
            };
            if (this.tooltip)
            {
                this.tooltip.destroy();
                this.tooltip = null;
            };
            this.cache = null;
            this.usable_items = null;
            this.array_info_holder = null;
            this.character_usable_items = null;
            this.eventHandler = null;
            this.combat = null;
            this.main = null;
        }


    }
}//package Panels

