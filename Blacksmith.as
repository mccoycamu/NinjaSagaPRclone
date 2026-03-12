// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Blacksmith

package Panels
{
    import flash.display.MovieClip;
    import com.abrahamyan.liquid.ToolTip;
    import Storage.BlacksmithData;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import Storage.Character;
    import com.utils.GF;
    import Managers.NinjaSage;
    import flash.system.System;
    import Storage.Library;
    import Popups.Confirmation;

    public dynamic class Blacksmith extends MovieClip 
    {

        public var panel:MovieClip;
        public var main:*;
        public var orig_indicator:* = "wpn";
        public var array_info_holder:Array;
        internal var character_weapons_amount:Array;
        internal var curr_page:* = 1;
        internal var itemCnt:* = 0;
        internal var itList:*;
        internal var total_page:* = 1;
        public var curr_page_items:Array;
        private var tooltip:ToolTip;
        private var confirmation:*;
        private var eventHandler:*;

        public function Blacksmith(_arg_1:*)
        {
            this.itList = BlacksmithData.weaponList;
            this.curr_page_items = [];
            this.array_info_holder = [];
            this.main = _arg_1;
            this.tooltip = ToolTip.getInstance();
            this.eventHandler = new EventHandler();
            this.main.handleVillageHUDVisibility(false);
            this.eventHandler.addListener(this.panel.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panel.nextPageBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panel.prevPageBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panel.buyGold, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.panel.buyToken, MouseEvent.CLICK, this.openRecharge);
            this.panel.txt_gold.text = Character.character_gold;
            this.panel.txt_token.text = Character.account_tokens;
            var _local_2:* = 1;
            while (_local_2 < 7)
            {
                this.panel.ownedMagatama[("level_" + _local_2)].text = this.getMaterial(("material_0" + _local_2));
                _local_2++;
            };
            this.loadCategory();
        }

        public function openRecharge(_arg_1:MouseEvent):*
        {
            this.main.loadPanel("Panels.Recharge");
        }

        public function closePanel(_arg_1:MouseEvent):*
        {
            this.main.handleVillageHUDVisibility(true);
            this.main = null;
            this.array_info_holder = null;
            this.eventHandler.removeAllEventListeners();
            this.curr_page_items = null;
            this.itList = null;
            this.tooltip = null;
            this.confirmation = null;
            this.eventHandler = null;
            var _local_2:* = 0;
            while (_local_2 < 3)
            {
                GF.removeAllChild(this.panel[("item_" + _local_2)].iconMc.iconHolder);
                GF.removeAllChild(this.panel[("item_" + _local_2)].iconMc1.iconHolder);
                _local_2++;
            };
            if (NinjaSage.loader != null)
            {
                NinjaSage.loader.removeAll();
            };
            this.panel = null;
            GF.removeAllChild(this);
            System.gc();
        }

        internal function getMaterial(_arg_1:String):*
        {
            var _local_2:* = undefined;
            var _local_3:Array = [];
            if (Character.character_materials != "")
            {
                if (Character.character_materials.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_materials.split(",");
                }
                else
                {
                    _local_3 = [Character.character_materials];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                if ((_local_2 = _local_3[_local_4].split(":"))[0] == _arg_1)
                {
                    return (_local_2[1]);
                };
                _local_4++;
            };
            return (0);
        }

        internal function loadCategory():void
        {
            this.itemCnt = 0;
            this.curr_page = 1;
            this.total_page = 1;
            this.itList = BlacksmithData.weaponList;
            this.orig_indicator = "wpn";
            var _local_1:* = 3;
            this.total_page = int(((this.itList.length / 3) + 1));
            if (this.itList.length < 4)
            {
                _local_1 = this.itList.length;
                this.total_page = 1;
            };
            if ((this.itList.length % 3) == 0)
            {
                this.total_page = (this.itList.length / 3);
            };
            this.panel.pageTxt.text = ((this.curr_page + "/") + this.total_page);
            this.array_info_holder.splice(0);
            this.loadItems(this.itemCnt, this.curr_page);
        }

        internal function loadItems(_arg_1:*, _arg_2:*):void
        {
            var _local_12:*;
            var _local_13:*;
            var _local_14:*;
            var _local_15:*;
            var _local_16:*;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            var _local_5:* = undefined;
            var _local_6:* = undefined;
            var _local_7:* = undefined;
            var _local_8:* = undefined;
            var _local_9:* = undefined;
            this.curr_page_items = [];
            var _local_10:* = 0;
            var _local_11:* = int((this.itList.length / _arg_2));
            if (_local_11 >= 3)
            {
                _local_11 = 3;
            }
            else
            {
                _local_11--;
            };
            while (_local_10 < 3)
            {
                _local_4 = this.itList[_arg_1];
                _local_5 = BlacksmithData.getForgeItems(_local_4);
                if (_local_5["item_materials"] == null)
                {
                    this.panel[("item_" + _local_10)].visible = false;
                    _local_10++;
                }
                else
                {
                    this.panel[("item_" + _local_10)].visible = true;
                    this.curr_page_items.push(_local_4);
                    _local_8 = Library.getItemInfo(_local_4);
                    this.panel[("item_" + _local_10)].ownedTxt.text = ((Character.isItemOwned(_local_4)) ? "Owned" : "");
                    _local_12 = Library.getItemInfo(_local_5["req_weapon"]);
                    if (_local_4 == null)
                    {
                        this.panel[("item_" + _local_10)].matqtyTxt.text = "x0";
                    }
                    else
                    {
                        this.panel[("item_" + _local_10)].matqtyTxt.text = ("x" + this.calculateWeapon(_local_5["req_weapon"]));
                    };
                    this.panel[("item_" + _local_10)].matlvTxt.text = _local_12["item_level"];
                    this.eventHandler.addListener(this.panel[("item_" + _local_10)].iconMc, MouseEvent.ROLL_OVER, this.tooltipOnHover, false, 0, true);
                    this.eventHandler.addListener(this.panel[("item_" + _local_10)].iconMc1, MouseEvent.ROLL_OVER, this.tooltipOnHover, false, 0, true);
                    this.eventHandler.addListener(this.panel[("item_" + _local_10)].iconMc, MouseEvent.ROLL_OUT, this.tooltipOnOut, false, 0, true);
                    this.eventHandler.addListener(this.panel[("item_" + _local_10)].iconMc1, MouseEvent.ROLL_OUT, this.tooltipOnOut, false, 0, true);
                    this.panel[("item_" + _local_10)].statusMC.gotoAndStop(2);
                    GF.removeAllChild(this.panel[("item_" + _local_10)].iconMc.iconHolder);
                    GF.removeAllChild(this.panel[("item_" + _local_10)].iconMc1.iconHolder);
                    NinjaSage.loadIconSWF("items", _local_5["req_weapon"], this.panel[("item_" + _local_10)].iconMc);
                    NinjaSage.loadIconSWF("items", _local_4, this.panel[("item_" + _local_10)].iconMc1);
                    _local_13 = _local_12["item_premium"];
                    _local_14 = _local_8["item_premium"];
                    _local_15 = {"wpn_id":_local_8["item_id"]};
                    this.panel[("item_" + _local_10)].forgeBtn.metaData = _local_15;
                    this.eventHandler.addListener(this.panel[("item_" + _local_10)].forgeBtn, MouseEvent.CLICK, this.onForgeItemRequest, false, 0, true);
                    this.panel[("item_" + _local_10)].buyBtn.metaData = _local_15;
                    this.eventHandler.addListener(this.panel[("item_" + _local_10)].buyBtn, MouseEvent.CLICK, this.onBuyItemRequest, false, 0, true);
                    this.panel[("item_" + _local_10)].iconMc1.metaData = {"description":(((((((_local_8["item_name"] + "\n") + "\nLevel ") + _local_8["item_level"]) + '\n<font color="#ff0000">Damage: ') + _local_8["item_damage"]) + "</font>\n\n ") + _local_8["item_description"])};
                    this.panel[("item_" + _local_10)].emblemMc.visible = false;
                    this.panel[("item_" + _local_10)].iconMc.metaData = {"description":(((((((_local_12["item_name"] + "\n") + "\nLevel ") + _local_12["item_level"]) + '\n<font color="#ff0000">Damage: ') + _local_12["item_damage"]) + "</font>\n\n ") + _local_12["item_description"])};
                    if (_local_13 == true)
                    {
                        this.panel[("item_" + _local_10)].emblemMc.visible = true;
                        this.panel[("item_" + _local_10)].emblemMc.gotoAndStop(2);
                    };
                    this.panel[("item_" + _local_10)].forgelvTxt.text = _local_8["item_level"];
                    this.panel[("item_" + _local_10)].matlvTxt.text = _local_12["item_level"];
                    this.panel[("item_" + _local_10)].costTxt.text = _local_5["gold_price"];
                    this.panel[("item_" + _local_10)].tokenTxt.text = (_local_5["token_price"] + " Tokens");
                    this.panel[("item_" + _local_10)].iconMc.visible = true;
                    _local_16 = 1;
                    while (_local_16 < 7)
                    {
                        this.panel[("item_" + _local_10)].requiredMaterials[("level_" + _local_16)].text = "0";
                        _local_16++;
                    };
                    _local_3 = 0;
                    while (_local_3 < _local_5["item_materials"].length)
                    {
                        this.panel[("item_" + _local_10)].requiredMaterials[("level_" + (_local_3 + 1))].text = _local_5["item_mat_price"][_local_3];
                        _local_3++;
                    };
                    _local_6 = 0;
                    _local_7 = 0;
                    _local_10++;
                    _arg_1++;
                };
            };
            _local_10 = null;
            _local_6 = null;
            _local_7 = null;
            _local_9 = null;
            _local_4 = null;
            _local_5 = null;
            _local_8 = null;
        }

        internal function getWeaponRequired(_arg_1:String):*
        {
            var _local_2:* = undefined;
            var _local_3:Array = [];
            if (Character.character_weapons != "")
            {
                if (Character.character_weapons.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_weapons.split(",");
                }
                else
                {
                    _local_3 = [Character.character_weapons];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                if ((_local_2 = _local_3[_local_4].split(":"))[0] == _arg_1)
                {
                    return (_local_2[1]);
                };
                _local_4++;
            };
            return (0);
        }

        public function onBuyItemRequest(e:MouseEvent):*
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure want to buy this item?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():*
            {
                removeChild(confirmation);
            });
            this.confirmation.btn_confirm.metaData = {"wpn_id":e.currentTarget.metaData.wpn_id};
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.buyItemRequest);
            addChild(this.confirmation);
        }

        public function buyItemRequest(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            this.main.loading(true);
            this.main.amf_manager.service("Blacksmith.forgeItem", [Character.char_id, Character.sessionkey, _arg_1.currentTarget.metaData.wpn_id, "tokens"], this.onForgeItemResponse);
        }

        public function onForgeItemRequest(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("Blacksmith.forgeItem", [Character.char_id, Character.sessionkey, _arg_1.currentTarget.metaData.wpn_id, "gold"], this.onForgeItemResponse);
        }

        public function onForgeItemResponse(_arg_1:Object):*
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            this.main.loading(false);
            if (int(_arg_1.status) > 0)
            {
                if (int(_arg_1.status) == 1)
                {
                    _local_2 = _arg_1.item;
                    Character.addWeapon(_local_2);
                    _local_3 = _arg_1.requirements;
                    _local_4 = 0;
                    while (_local_4 < _local_3[0].length)
                    {
                        if (_local_3[0][_local_4].indexOf("material_") >= 0)
                        {
                            Character.removeMaterials(_local_3[0][_local_4], _local_3[1][_local_4]);
                        };
                        if (_local_3[0][_local_4].indexOf("wpn_") >= 0)
                        {
                            Character.removeWeapon(_local_3[0][_local_4], _local_3[1][_local_4]);
                        };
                        _local_4++;
                    };
                    this.main.giveMessage(_arg_1.result);
                }
                else
                {
                    this.main.getNotice(_arg_1.result);
                };
                this.loadCategory();
            }
            else
            {
                this.main.getError(_arg_1.error);
            };
        }

        internal function gotoCharacterSelect():*
        {
            this.main.loadPanel("Panels.CharacterSelect");
        }

        internal function calculateWeapon(_arg_1:String):*
        {
            var _local_2:* = undefined;
            var _local_3:* = Character.character_weapons.split(",");
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                if ((_local_2 = _local_3[_local_4].split(":"))[0] == _arg_1)
                {
                    return (_local_2[1]);
                };
                _local_4++;
            };
            return (0);
        }

        internal function tooltipOnHover(_arg_1:MouseEvent):void
        {
            stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_arg_1.currentTarget.metaData.description);
        }

        internal function tooltipOnOut(_arg_1:MouseEvent):void
        {
            this.tooltip.hide();
        }

        internal function changePage(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.name == "nextPageBtn")
            {
                if (this.curr_page < this.total_page)
                {
                    this.curr_page++;
                    this.itemCnt = (this.itemCnt + 3);
                    this.array_info_holder.splice(0);
                    this.loadItems(this.itemCnt, this.curr_page);
                };
            }
            else
            {
                if (_arg_1.currentTarget.name == "prevPageBtn")
                {
                    if (this.curr_page != 1)
                    {
                        this.curr_page--;
                        this.itemCnt = (this.itemCnt - 3);
                        this.array_info_holder.splice(0);
                        this.loadItems(this.itemCnt, this.curr_page);
                    };
                };
            };
            this.panel.pageTxt.text = ((this.curr_page + "/") + this.total_page);
        }


    }
}//package Panels

