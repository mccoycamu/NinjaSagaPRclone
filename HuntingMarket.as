// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.HuntingMarket

package Panels
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import com.abrahamyan.liquid.ToolTip;
    import flash.events.MouseEvent;
    import Storage.Character;
    import Storage.ForgeDataHunting;
    import flash.events.Event;
    import Storage.SkillLibrary;
    import com.utils.GF;
    import Managers.NinjaSage;
    import Storage.Library;
    import Storage.PetInfo;
    import flash.display.Loader;
    import flash.net.URLRequest;
    import id.ninjasage.Util;
    import flash.system.System;

    public class HuntingMarket extends MovieClip 
    {

        public var item_3:MovieClip;
        public var titleTxt:TextField;
        public var btn_close:SimpleButton;
        public var item_0:MovieClip;
        public var item_1:MovieClip;
        public var item_2:MovieClip;
        public var materialList:* = [];
        public var mcAccessory:MovieClip;
        public var mcBackItem:MovieClip;
        public var mcHairstyle:MovieClip;
        public var mcPet:MovieClip;
        public var mcSet:MovieClip;
        public var mcSkill:MovieClip;
        public var mcWeapon:MovieClip;
        public var mcMaterial:MovieClip;
        public var nextPageBtn:SimpleButton;
        public var materialBagBtn:SimpleButton;
        public var pageTxt:TextField;
        public var prevPageBtn:SimpleButton;
        public var main:*;
        public var tooltip:ToolTip;
        public var orig_indicator:* = "wpn";
        public var array_info_holder:Array;
        internal var curr_page:* = 1;
        internal var itemCnt:* = 0;
        internal var itList:*;
        internal var total_page:* = 1;
        public var curr_page_items:Array = [];
        public var is_loading:* = false;
        public var lnr:* = 0;

        public function HuntingMarket(_arg_1:*)
        {
            this.main = _arg_1;
            this.main.handleVillageHUDVisibility(false);
            this.btn_close.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.getItems();
        }

        public function getItems():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("HuntingHouse.getItems", [Character.char_id, Character.sessionkey], this.onGetItems);
        }

        public function onGetItems(_arg_1:*):*
        {
            if (_arg_1.status > 1)
            {
                this.main.loading(false);
                this.main.getNotice(_arg_1.result);
                this.closePanel();
                return;
            };
            ForgeDataHunting.constructData(_arg_1.items);
            this.itList = ForgeDataHunting.getItemByCategory("wpn");
            this.setUI();
            this.mcWeapon.gotoAndStop(1);
            this.loadCategory("Weapon");
            this.main.loading(false);
        }

        internal function resetButtons():void
        {
            this.mcWeapon.gotoAndStop(3);
            this.mcSet.gotoAndStop(3);
            this.mcBackItem.gotoAndStop(3);
            this.mcAccessory.gotoAndStop(3);
            this.mcHairstyle.gotoAndStop(3);
            this.mcSkill.gotoAndStop(3);
            this.mcPet.gotoAndStop(3);
            this.mcMaterial.gotoAndStop(3);
        }

        internal function setUI():void
        {
            this.array_info_holder = [];
            this.tooltip = ToolTip.getInstance();
            this.resetButtons();
            this.mcWeapon.buttonMode = true;
            this.mcWeapon.addEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcWeapon.addEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcWeapon.addEventListener(MouseEvent.CLICK, this.click);
            this.mcSet.buttonMode = true;
            this.mcSet.addEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcSet.addEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcSet.addEventListener(MouseEvent.CLICK, this.click);
            this.mcBackItem.buttonMode = true;
            this.mcBackItem.addEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcBackItem.addEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcBackItem.addEventListener(MouseEvent.CLICK, this.click);
            this.mcAccessory.buttonMode = true;
            this.mcAccessory.addEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcAccessory.addEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcAccessory.addEventListener(MouseEvent.CLICK, this.click);
            this.mcHairstyle.buttonMode = true;
            this.mcHairstyle.addEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcHairstyle.addEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcHairstyle.addEventListener(MouseEvent.CLICK, this.click);
            this.mcSkill.buttonMode = true;
            this.mcSkill.addEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcSkill.addEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcSkill.addEventListener(MouseEvent.CLICK, this.click);
            this.mcPet.buttonMode = true;
            this.mcPet.addEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcPet.addEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcPet.addEventListener(MouseEvent.CLICK, this.click);
            this.mcMaterial.buttonMode = true;
            this.mcMaterial.addEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcMaterial.addEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcMaterial.addEventListener(MouseEvent.CLICK, this.click);
            this.nextPageBtn.addEventListener(MouseEvent.CLICK, this.changePage);
            this.prevPageBtn.addEventListener(MouseEvent.CLICK, this.changePage);
            this.materialBagBtn.addEventListener(MouseEvent.CLICK, this.openGear);
        }

        internal function openGear(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.UI_Gear");
        }

        internal function over(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame != 1)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        internal function out(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame != 1)
            {
                _arg_1.currentTarget.gotoAndStop(3);
            };
        }

        internal function click(_arg_1:MouseEvent):void
        {
            var _local_2:* = undefined;
            if (_arg_1.currentTarget.currentFrame != 1)
            {
                this.resetButtons();
                _arg_1.currentTarget.gotoAndStop(1);
                _local_2 = _arg_1.currentTarget.name.split("mc");
                _local_2 = _local_2[1];
                this.loadCategory(_local_2);
            };
            _local_2 = null;
        }

        internal function clearSlots():void
        {
            this.item_0.visible = false;
            this.item_1.visible = false;
            this.item_2.visible = false;
            this.item_3.visible = false;
            var _local_1:* = 0;
            while (_local_1 < 12)
            {
                this.item_0[("item_" + _local_1)].visible = false;
                this.item_1[("item_" + _local_1)].visible = false;
                this.item_2[("item_" + _local_1)].visible = false;
                this.item_3[("item_" + _local_1)].visible = false;
                while (this.item_0.iconMc.iconHolder.numChildren > 0)
                {
                    this.item_0.iconMc.iconHolder.removeChildAt(0);
                };
                while (this.item_1.iconMc.iconHolder.numChildren > 0)
                {
                    this.item_1.iconMc.iconHolder.removeChildAt(0);
                };
                while (this.item_2.iconMc.iconHolder.numChildren > 0)
                {
                    this.item_2.iconMc.iconHolder.removeChildAt(0);
                };
                while (this.item_3.iconMc.iconHolder.numChildren > 0)
                {
                    this.item_3.iconMc.iconHolder.removeChildAt(0);
                };
                while (this.item_0.skillIconMc.iconHolder.numChildren > 0)
                {
                    this.item_0.skillIconMc.iconHolder.removeChildAt(0);
                };
                while (this.item_1.skillIconMc.iconHolder.numChildren > 0)
                {
                    this.item_1.skillIconMc.iconHolder.removeChildAt(0);
                };
                while (this.item_2.skillIconMc.iconHolder.numChildren > 0)
                {
                    this.item_2.skillIconMc.iconHolder.removeChildAt(0);
                };
                while (this.item_3.skillIconMc.iconHolder.numChildren > 0)
                {
                    this.item_3.skillIconMc.iconHolder.removeChildAt(0);
                };
                while (this.item_0[("item_" + _local_1)].iconMC.iconHolder.numChildren > 0)
                {
                    this.item_0[("item_" + _local_1)].iconMC.iconHolder.removeChildAt(0);
                };
                while (this.item_1[("item_" + _local_1)].iconMC.iconHolder.numChildren > 0)
                {
                    this.item_1[("item_" + _local_1)].iconMC.iconHolder.removeChildAt(0);
                };
                while (this.item_2[("item_" + _local_1)].iconMC.iconHolder.numChildren > 0)
                {
                    this.item_2[("item_" + _local_1)].iconMC.iconHolder.removeChildAt(0);
                };
                while (this.item_3[("item_" + _local_1)].iconMC.iconHolder.numChildren > 0)
                {
                    this.item_3[("item_" + _local_1)].iconMC.iconHolder.removeChildAt(0);
                };
                _local_1++;
            };
            _local_1 = null;
        }

        internal function loadCategory(_arg_1:String, _arg_2:int=1, _arg_3:*=0):void
        {
            if (this.is_loading)
            {
                return;
            };
            this.clearSlots();
            this.itemCnt = _arg_3;
            this.curr_page = _arg_2;
            this.total_page = 1;
            if (_arg_1 == "Weapon")
            {
                this.itList = ForgeDataHunting.getItemByCategory("wpn");
                this.orig_indicator = "Weapon";
            }
            else
            {
                if (_arg_1 == "BackItem")
                {
                    this.itList = ForgeDataHunting.getItemByCategory("back");
                    this.orig_indicator = "BackItem";
                }
                else
                {
                    if (_arg_1 == "Set")
                    {
                        this.itList = ForgeDataHunting.getItemByCategory("set");
                        this.orig_indicator = "Set";
                    }
                    else
                    {
                        if (_arg_1 == "Accessory")
                        {
                            this.itList = ForgeDataHunting.getItemByCategory("accessory");
                            this.orig_indicator = "Accessory";
                        }
                        else
                        {
                            if (_arg_1 == "Hairstyle")
                            {
                                this.itList = ForgeDataHunting.getItemByCategory("hair");
                                this.orig_indicator = "Hairstyle";
                            }
                            else
                            {
                                if (_arg_1 == "Skill")
                                {
                                    this.itList = ForgeDataHunting.getItemByCategory("skill");
                                    this.orig_indicator = "Skill";
                                }
                                else
                                {
                                    if (_arg_1 == "Pet")
                                    {
                                        this.itList = ForgeDataHunting.getItemByCategory("pet");
                                        this.orig_indicator = "Pet";
                                    }
                                    else
                                    {
                                        if (_arg_1 == "Material")
                                        {
                                            this.itList = ForgeDataHunting.getItemByCategory("material");
                                            this.orig_indicator = "Material";
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            this.total_page = Math.max(Math.ceil((this.itList.length / 4)), 1);
            this.array_info_holder.splice(0);
            this.pageTxt.text = ((this.curr_page + "/") + this.total_page);
            this.loadItems(this.itemCnt, this.curr_page);
        }

        internal function changePage(_arg_1:MouseEvent):void
        {
            if (this.is_loading)
            {
                return;
            };
            if (_arg_1.currentTarget.name == "nextPageBtn")
            {
                if (this.curr_page < this.total_page)
                {
                    this.curr_page++;
                    this.itemCnt = (this.itemCnt + 4);
                    this.clearSlots();
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
                        this.itemCnt = (this.itemCnt - 4);
                        this.clearSlots();
                        this.array_info_holder.splice(0);
                        this.loadItems(this.itemCnt, this.curr_page);
                    };
                };
            };
            this.pageTxt.text = ((this.curr_page + "/") + this.total_page);
        }

        internal function checkLoading(_arg_1:Event):*
        {
            this.lnr++;
            if (this.lnr > 4)
            {
                this.is_loading = false;
            };
        }

        internal function loadItems(_arg_1:*, _arg_2:*):void
        {
            var _local_13:*;
            var _local_14:*;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            var _local_5:* = undefined;
            var _local_6:* = undefined;
            var _local_7:* = undefined;
            var _local_8:* = undefined;
            var _local_9:* = undefined;
            var _local_10:* = undefined;
            var _local_11:* = undefined;
            this.lnr = 0;
            this.is_loading = true;
            addEventListener(Event.ENTER_FRAME, this.checkLoading);
            this.curr_page_items = [];
            var _local_12:* = 0;
            if ((_local_13 = Math.ceil((this.itList.length / _arg_2))) >= 4)
            {
                _local_13 = 4;
            };
            while (_local_12 < _local_13)
            {
                if ((_local_3 = this.itList[_arg_1]) == undefined)
                {
                    _local_12++;
                }
                else
                {
                    this[("item_" + _local_12)].visible = true;
                    this.curr_page_items.push(_local_3);
                    _local_4 = ForgeDataHunting.getForgeItems(_local_3);
                    _local_5 = Character.isItemOwned(_local_3);
                    this[("item_" + _local_12)].ownedTxt.text = ((!(_local_5)) ? "" : "Owned");
                    if ((_local_6 = (_local_6 = _local_3.split("_"))[0]) == "skill")
                    {
                        _local_9 = SkillLibrary.getSkillInfo(_local_3);
                        this[("item_" + _local_12)].lvlTxt.text = _local_9["skill_level"];
                        this[("item_" + _local_12)].skillIconMc.visible = true;
                        this[("item_" + _local_12)].iconMc.visible = false;
                        GF.removeAllChild(this[("item_" + _local_12)].skillIconMc.iconHolder);
                        NinjaSage.loadIconSWF("skills", _local_3, this[("item_" + _local_12)].skillIconMc);
                        this[("item_" + _local_12)].skillIconMc.addEventListener(MouseEvent.ROLL_OVER, this.toolTiponOver, false, 0, true);
                        this[("item_" + _local_12)].skillIconMc.addEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                        _local_10 = new Array(_local_9["skill_name"], _local_9["skill_level"], _local_9["skill_damage"], _local_9["skill_cp_cost"], _local_9["skill_cooldown"], _local_9["skill_description"]);
                        this.array_info_holder.push(_local_10);
                    }
                    else
                    {
                        if (_local_6 == "wpn")
                        {
                            _local_9 = Library.getItemInfo(_local_3);
                            this[("item_" + _local_12)].lvlTxt.text = _local_9["item_level"];
                            GF.removeAllChild(this[("item_" + _local_12)].iconMc.iconHolder);
                            NinjaSage.loadIconSWF("items", _local_3, this[("item_" + _local_12)].iconMc);
                            this[("item_" + _local_12)].skillIconMc.visible = false;
                            this[("item_" + _local_12)].iconMc.visible = true;
                            this[("item_" + _local_12)].iconMc.addEventListener(MouseEvent.ROLL_OVER, this.toolTiponOver, false, 0, true);
                            this[("item_" + _local_12)].iconMc.addEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                            _local_10 = new Array(_local_9["item_name"], _local_9["item_level"], _local_9["item_damage"], _local_9["item_description"]);
                            this.array_info_holder.push(_local_10);
                        }
                        else
                        {
                            if (_local_6 == "pet")
                            {
                                _local_9 = PetInfo.getPetStats(_local_3);
                                this[("item_" + _local_12)].lvlTxt.text = 20;
                                GF.removeAllChild(this[("item_" + _local_12)].iconMc.iconHolder);
                                NinjaSage.loadIconSWF("pets", _local_3, this[("item_" + _local_12)].iconMc);
                                this[("item_" + _local_12)].skillIconMc.visible = false;
                                this[("item_" + _local_12)].iconMc.visible = true;
                                this[("item_" + _local_12)].iconMc.addEventListener(MouseEvent.ROLL_OVER, this.toolTiponOver, false, 0, true);
                                this[("item_" + _local_12)].iconMc.addEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                                _local_10 = new Array(_local_9["pet_name"], "20", _local_9["description"]);
                                this.array_info_holder.push(_local_10);
                            }
                            else
                            {
                                if (_local_6 == "material")
                                {
                                    _local_9 = Library.getItemInfo(_local_3);
                                    this[("item_" + _local_12)].lvlTxt.text = 20;
                                    GF.removeAllChild(this[("item_" + _local_12)].iconMc.iconHolder);
                                    NinjaSage.loadIconSWF("materials", _local_3, this[("item_" + _local_12)].iconMc);
                                    this[("item_" + _local_12)].skillIconMc.visible = false;
                                    this[("item_" + _local_12)].iconMc.visible = true;
                                    this[("item_" + _local_12)].iconMc.addEventListener(MouseEvent.ROLL_OVER, this.toolTiponOver, false, 0, true);
                                    this[("item_" + _local_12)].iconMc.addEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                                    _local_10 = new Array(_local_9["item_name"], _local_9["item_level"], _local_9["item_description"]);
                                    this.array_info_holder.push(_local_10);
                                }
                                else
                                {
                                    _local_9 = Library.getItemInfo(_local_3);
                                    this[("item_" + _local_12)].lvlTxt.text = _local_9["item_level"];
                                    GF.removeAllChild(this[("item_" + _local_12)].iconMc.iconHolder);
                                    NinjaSage.loadIconSWF("items", _local_3, this[("item_" + _local_12)].iconMc);
                                    this[("item_" + _local_12)].skillIconMc.visible = false;
                                    this[("item_" + _local_12)].iconMc.visible = true;
                                    this[("item_" + _local_12)].iconMc.addEventListener(MouseEvent.ROLL_OVER, this.toolTiponOver, false, 0, true);
                                    this[("item_" + _local_12)].iconMc.addEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                                    _local_10 = new Array(_local_9["item_name"], _local_9["item_level"], _local_9["item_description"]);
                                    this.array_info_holder.push(_local_10);
                                };
                            };
                        };
                    };
                    _local_7 = 0;
                    _local_8 = 0;
                    while (_local_7 < _local_4["item_materials"].length)
                    {
                        this[("item_" + _local_12)][("item_" + _local_7)].visible = true;
                        this[("item_" + _local_12)][("item_" + _local_7)].iconMC.visible = true;
                        this[("item_" + _local_12)][("item_" + _local_7)].skillIconMc.visible = false;
                        _local_14 = _local_3;
                        _local_3 = _local_4["item_materials"][_local_7];
                        _local_3 = _local_3.split("_");
                        _local_11 = 0;
                        if (_local_3[0] == "material")
                        {
                            GF.removeAllChild(this[("item_" + _local_12)][("item_" + _local_7)].iconMC.iconHolder);
                            NinjaSage.loadIconSWF("materials", _local_4["item_materials"][_local_7], this[("item_" + _local_12)][("item_" + _local_7)].iconMC);
                            _local_11 = this.calculateMat(_local_4["item_materials"][_local_7]);
                            _local_9 = Library.getItemInfo(_local_4["item_materials"][_local_7]);
                            this[("item_" + _local_12)][("item_" + _local_7)].iconMC.addEventListener(MouseEvent.ROLL_OVER, this.toolTiponOverMats, false, 0, true);
                            this[("item_" + _local_12)][("item_" + _local_7)].iconMC.addEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                            this[("item_" + _local_12)][("item_" + _local_7)].iconMC.item_type = "Material";
                            this[("item_" + _local_12)][("item_" + _local_7)].iconMC.tooltip = [_local_9["item_name"], _local_9["item_level"], _local_9["item_description"]];
                        }
                        else
                        {
                            if (_local_3[0] == "wpn")
                            {
                                GF.removeAllChild(this[("item_" + _local_12)][("item_" + _local_7)].iconMC.iconHolder);
                                NinjaSage.loadIconSWF("items", _local_4["item_materials"][_local_7], this[("item_" + _local_12)][("item_" + _local_7)].iconMC);
                                _local_11 = this.calculateWeapon(_local_4["item_materials"][_local_7]);
                                _local_9 = Library.getItemInfo(_local_4["item_materials"][_local_7]);
                                this[("item_" + _local_12)][("item_" + _local_7)].iconMC.addEventListener(MouseEvent.ROLL_OVER, this.toolTiponOverMats, false, 0, true);
                                this[("item_" + _local_12)][("item_" + _local_7)].iconMC.addEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                                this[("item_" + _local_12)][("item_" + _local_7)].iconMC.item_type = "Weapon";
                                this[("item_" + _local_12)][("item_" + _local_7)].iconMC.tooltip = [_local_9["item_name"], _local_9["item_level"], _local_9["item_damage"], _local_9["item_description"]];
                            }
                            else
                            {
                                if (_local_3[0] == "back")
                                {
                                    GF.removeAllChild(this[("item_" + _local_12)][("item_" + _local_7)].iconMC.iconHolder);
                                    NinjaSage.loadIconSWF("items", _local_4["item_materials"][_local_7], this[("item_" + _local_12)][("item_" + _local_7)].iconMC);
                                    _local_11 = this.calculateBackItem(_local_4["item_materials"][_local_7]);
                                    _local_9 = Library.getItemInfo(_local_4["item_materials"][_local_7]);
                                    this[("item_" + _local_12)][("item_" + _local_7)].iconMC.addEventListener(MouseEvent.ROLL_OVER, this.toolTiponOverMats, false, 0, true);
                                    this[("item_" + _local_12)][("item_" + _local_7)].iconMC.addEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                                    this[("item_" + _local_12)][("item_" + _local_7)].iconMC.item_type = "BackItem";
                                    this[("item_" + _local_12)][("item_" + _local_7)].iconMC.tooltip = [_local_9["item_name"], _local_9["item_level"], _local_9["item_description"]];
                                }
                                else
                                {
                                    GF.removeAllChild(this[("item_" + _local_12)][("item_" + _local_7)].skillIconMc.iconHolder);
                                    this[("item_" + _local_12)][("item_" + _local_7)].iconMC.visible = false;
                                    this[("item_" + _local_12)][("item_" + _local_7)].skillIconMc.visible = true;
                                    NinjaSage.loadIconSWF("skills", _local_4["item_materials"][_local_7], this[("item_" + _local_12)][("item_" + _local_7)].skillIconMc);
                                    _local_11 = ((Character.isItemOwned(_local_4["item_materials"][_local_7])) ? 1 : 0);
                                    _local_9 = SkillLibrary.getSkillInfo(_local_4["item_materials"][_local_7]);
                                    this[("item_" + _local_12)][("item_" + _local_7)].iconMC.addEventListener(MouseEvent.ROLL_OVER, this.toolTiponOverMats, false, 0, true);
                                    this[("item_" + _local_12)][("item_" + _local_7)].iconMC.addEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                                    this[("item_" + _local_12)][("item_" + _local_7)].iconMC.item_type = "Skill";
                                    this[("item_" + _local_12)][("item_" + _local_7)].iconMC.tooltip = [_local_9["skill_name"], _local_9["skill_level"], _local_9["skill_damage"], _local_9["skill_cp_cost"], _local_9["skill_cooldown"], _local_9["skill_description"]];
                                };
                            };
                        };
                        this[("item_" + _local_12)][("item_" + _local_7)].txt1.text = _local_11;
                        this[("item_" + _local_12)][("item_" + _local_7)].txt2.text = _local_4["item_mat_price"][_local_7];
                        if (int(_local_11) >= int(_local_4["item_mat_price"][_local_7]))
                        {
                            _local_8++;
                        };
                        _local_7++;
                    };
                    if (_local_4["item_materials"].length == 1)
                    {
                        if (_local_8 >= _local_4["item_materials"].length)
                        {
                            this[("item_" + _local_12)].statusMC.gotoAndStop(1);
                            this[("item_" + _local_12)].forgeBtn.visible = true;
                            this[("item_" + _local_12)].forgeBtn.addEventListener(MouseEvent.CLICK, this.onForgeItemRequest);
                        }
                        else
                        {
                            this[("item_" + _local_12)].statusMC.gotoAndStop(2);
                            this[("item_" + _local_12)].forgeBtn.visible = false;
                        };
                    }
                    else
                    {
                        if (_local_8 >= _local_4["item_materials"].length)
                        {
                            this[("item_" + _local_12)].statusMC.gotoAndStop(1);
                            this[("item_" + _local_12)].forgeBtn.visible = true;
                            this[("item_" + _local_12)].forgeBtn.addEventListener(MouseEvent.CLICK, this.onForgeItemRequest);
                        }
                        else
                        {
                            this[("item_" + _local_12)].statusMC.gotoAndStop(2);
                            this[("item_" + _local_12)].forgeBtn.visible = false;
                        };
                    };
                    _arg_1++;
                    _local_12++;
                };
            };
            _local_12 = null;
            _local_7 = null;
            _local_8 = null;
            _local_11 = null;
            _local_3 = null;
            _local_4 = null;
            _local_9 = null;
        }

        public function onForgeItemRequest(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            var _local_2:* = int(_arg_1.currentTarget.parent.name.replace("item_", ""));
            var _local_3:* = this.curr_page_items[_local_2];
            this.main.amf_manager.service("HuntingHouse.forgeItem", [Character.char_id, Character.sessionkey, _local_3], this.onForgeItemResponse);
        }

        public function onForgeItemResponse(_arg_1:Object):*
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            this.main.loading(false);
            if (_arg_1.status > 0)
            {
                if (_arg_1.status == 1)
                {
                    _local_2 = _arg_1.item;
                    if (_local_2.indexOf("material_") >= 0)
                    {
                        Character.addMaterials(_local_2);
                    }
                    else
                    {
                        if (_local_2.indexOf("wpn_") >= 0)
                        {
                            Character.addWeapon(_local_2);
                        }
                        else
                        {
                            if (_local_2.indexOf("back_") >= 0)
                            {
                                Character.addBack(_local_2);
                            }
                            else
                            {
                                if (_local_2.indexOf("set_") >= 0)
                                {
                                    Character.addSet(_local_2);
                                }
                                else
                                {
                                    if (_local_2.indexOf("accessory_") >= 0)
                                    {
                                        Character.addAccessory(_local_2);
                                    }
                                    else
                                    {
                                        if (_local_2.indexOf("skill_") >= 0)
                                        {
                                            Character.updateSkills(_local_2);
                                        }
                                        else
                                        {
                                            if (_local_2.indexOf("hair_") >= 0)
                                            {
                                                Character.addHair(_local_2);
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
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
                        if (_local_3[0][_local_4].indexOf("back_") >= 0)
                        {
                            Character.removeBackItem(_local_3[0][_local_4], _local_3[1][_local_4]);
                        };
                        if (_local_3[0][_local_4] == Character.character_weapon)
                        {
                            Character.character_weapon = "wpn_01";
                        };
                        if (_local_3[0][_local_4] == Character.character_back_item)
                        {
                            Character.character_back_item = "back_01";
                        };
                        if (_local_3[0][_local_4] == Character.character_accessory)
                        {
                            Character.character_accessory = "accessory_01";
                        };
                        _local_4++;
                    };
                }
                else
                {
                    this.main.getNotice(_arg_1.result);
                };
                this.loadCategory(this.orig_indicator, this.curr_page, this.itemCnt);
            }
            else
            {
                this.main.getError(_arg_1.error);
            };
        }

        internal function calculateWeapon(_arg_1:String):*
        {
            var _local_2:* = undefined;
            var _local_3:* = Character.character_weapons.split(",");
            var _local_4:* = 0;
            var _local_5:* = 0;
            while (_local_4 < _local_3.length)
            {
                if ((_local_2 = _local_3[_local_4].split(":"))[0] == _arg_1)
                {
                    _local_5 = _local_2[1];
                };
                _local_4++;
            };
            return (_local_5);
        }

        internal function calculateBackItem(_arg_1:String):*
        {
            var _local_2:* = undefined;
            var _local_3:* = Character.character_back_items.split(",");
            var _local_4:* = 0;
            var _local_5:* = 0;
            while (_local_4 < _local_3.length)
            {
                if ((_local_2 = _local_3[_local_4].split(":"))[0] == _arg_1)
                {
                    _local_5 = _local_2[1];
                };
                _local_4++;
            };
            return (_local_5);
        }

        internal function calculateMat(_arg_1:String):*
        {
            var _local_2:* = undefined;
            var _local_3:* = Character.character_materials.split(",");
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

        public function loadSkillSWF(param1:String, param2:*):void
        {
            var object:* = undefined;
            var item:String = param1;
            object = param2;
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (_arg_1:Event):*
            {
                _arg_1.target.removeEventListener(_arg_1.type, arguments.callee);
                item_completeIcon(_arg_1, object);
            }, false, 0, true);
            loader.load(new URLRequest(Util.url((("skills/" + item) + ".swf"))));
        }

        public function loadIconSWF(param1:String, param2:*):void
        {
            var object:* = undefined;
            var item:String = param1;
            object = param2;
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (_arg_1:Event):*
            {
                _arg_1.target.removeEventListener(_arg_1.type, arguments.callee);
                item_completeIcon(_arg_1, object);
            }, false, 0, true);
            loader.load(new URLRequest(Util.url((("items/" + item) + ".swf"))));
        }

        public function loadMaterialSWF(param1:String, param2:*):void
        {
            var object:* = undefined;
            var item:String = param1;
            object = param2;
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (_arg_1:Event):*
            {
                _arg_1.target.removeEventListener(_arg_1.type, arguments.callee);
                item_completeIcon(_arg_1, object);
            }, false, 0, true);
            loader.load(new URLRequest(Util.url((("materials/" + item) + ".swf"))));
        }

        public function item_completeIcon(_arg_1:*, _arg_2:*):void
        {
            var _local_3:Class = (_arg_1.target.applicationDomain.getDefinition("icon") as Class);
            var _local_4:* = new (_local_3)();
            _arg_2.iconHolder.addChild(_local_4);
        }

        internal function toolTiponOver(_arg_1:MouseEvent):void
        {
            var _local_2:* = _arg_1.currentTarget.parent.name;
            _local_2 = _local_2.replace("item_", "");
            var _local_3:* = "";
            switch (this.orig_indicator)
            {
                case "Weapon":
                    _local_3 = (((((((("" + this.array_info_holder[int(_local_2)][0]) + "\n(Weapon)\n") + "\nLevel ") + this.array_info_holder[int(_local_2)][1]) + "\nDamage : ") + this.array_info_holder[int(_local_2)][2]) + "\n\n") + this.array_info_holder[int(_local_2)][3]);
                    break;
                case "Set":
                    _local_3 = (((((("" + this.array_info_holder[int(_local_2)][0]) + "\n(Clothing)\n") + "\nLevel ") + this.array_info_holder[int(_local_2)][1]) + "\n\n") + this.array_info_holder[int(_local_2)][2]);
                    break;
                case "BackItem":
                    _local_3 = (((((("" + this.array_info_holder[int(_local_2)][0]) + "\n(Back Item)\n") + "\nLevel ") + this.array_info_holder[int(_local_2)][1]) + "\n\n") + this.array_info_holder[int(_local_2)][2]);
                    break;
                case "Accessory":
                    _local_3 = (((((("" + this.array_info_holder[int(_local_2)][0]) + "\n(Accessory)\n") + "\nLevel ") + this.array_info_holder[int(_local_2)][1]) + "\n\n") + this.array_info_holder[int(_local_2)][2]);
                    break;
                case "Hairstyle":
                    _local_3 = (((((("" + this.array_info_holder[int(_local_2)][0]) + "\n(Hairstyle)\n") + "\nLevel ") + this.array_info_holder[int(_local_2)][1]) + "\n\n") + this.array_info_holder[int(_local_2)][2]);
                    break;
                case "Skill":
                    _local_3 = (((((((((((("" + this.array_info_holder[int(_local_2)][0]) + "\n(Skill)\n") + "\nLevel ") + this.array_info_holder[int(_local_2)][1]) + "\nDamage: ") + this.array_info_holder[int(_local_2)][2]) + "\nCP Cost: ") + this.array_info_holder[int(_local_2)][3]) + "\nCooldown: ") + this.array_info_holder[int(_local_2)][4]) + "\n\n") + this.array_info_holder[int(_local_2)][5]);
                    break;
                case "Pet":
                    _local_3 = (((((("" + this.array_info_holder[int(_local_2)][0]) + "\n(Pet)\n") + "\nLevel ") + this.array_info_holder[int(_local_2)][1]) + "\n\n") + this.array_info_holder[int(_local_2)][2]);
                    break;
                case "Material":
                    _local_3 = (((((("" + this.array_info_holder[int(_local_2)][0]) + "\n(Material)\n") + "\nLevel ") + this.array_info_holder[int(_local_2)][1]) + "\n\n") + this.array_info_holder[int(_local_2)][2]);
                    break;
            };
            stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_3);
        }

        internal function toolTiponOverMats(_arg_1:MouseEvent):void
        {
            var _local_2:* = _arg_1.currentTarget.parent.name;
            var _local_3:* = _arg_1.currentTarget.tooltip;
            _local_2 = _local_2.replace("item_", "");
            var _local_4:* = "";
            switch (_arg_1.currentTarget.item_type)
            {
                case "Weapon":
                    _local_4 = (((((((("" + _local_3[0]) + "\n(Weapon)\n") + "\nLevel ") + _local_3[1]) + "\nDamage : ") + _local_3[2]) + "\n\n") + _local_3[3]);
                    break;
                case "Set":
                    _local_4 = (((((("" + _local_3[0]) + "\n(Clothing)\n") + "\nLevel ") + _local_3[1]) + "\n\n") + _local_3[2]);
                    break;
                case "BackItem":
                    _local_4 = (((((("" + _local_3[0]) + "\n(Back Item)\n") + "\nLevel ") + _local_3[1]) + "\n\n") + _local_3[2]);
                    break;
                case "Accessory":
                    _local_4 = (((((("" + _local_3[0]) + "\n(Accessory)\n") + "\nLevel ") + _local_3[1]) + "\n\n") + _local_3[2]);
                    break;
                case "Hairstyle":
                    _local_4 = (((((("" + _local_3[0]) + "\n(Hairstyle)\n") + "\nLevel ") + _local_3[1]) + "\n\n") + _local_3[2]);
                    break;
                case "Skill":
                    _local_4 = (((((((((((("" + _local_3[0]) + "\n(Skill)\n") + "\nLevel ") + _local_3[1]) + "\nDamage: ") + _local_3[2]) + "\nCP Cost: ") + _local_3[3]) + "\nCooldown: ") + _local_3[4]) + "\n\n") + _local_3[5]);
                    break;
                case "Pet":
                    _local_4 = (((((("" + _local_3[0]) + "\n(Pet)\n") + "\nLevel ") + _local_3[1]) + "\n\n") + _local_3[2]);
                    break;
                case "Material":
                    _local_4 = (((((("" + _local_3[0]) + "\n(Material)\n") + "\nLevel ") + _local_3[1]) + "\n\n") + _local_3[2]);
                    break;
            };
            stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_4);
        }

        internal function toolTiponOut(_arg_1:MouseEvent):void
        {
            this.tooltip.hide();
        }

        internal function killEverything():void
        {
            this.main.handleVillageHUDVisibility(true);
            this.clearSlots();
            this.btn_close.removeEventListener(MouseEvent.CLICK, this.closePanel);
            this.mcWeapon.removeEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcWeapon.removeEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcWeapon.removeEventListener(MouseEvent.CLICK, this.click);
            this.mcSet.removeEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcSet.removeEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcSet.removeEventListener(MouseEvent.CLICK, this.click);
            this.mcBackItem.removeEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcBackItem.removeEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcBackItem.removeEventListener(MouseEvent.CLICK, this.click);
            this.mcAccessory.removeEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcAccessory.removeEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcAccessory.removeEventListener(MouseEvent.CLICK, this.click);
            this.mcHairstyle.removeEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcHairstyle.removeEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcHairstyle.removeEventListener(MouseEvent.CLICK, this.click);
            this.mcSkill.removeEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcSkill.removeEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcSkill.removeEventListener(MouseEvent.CLICK, this.click);
            this.mcPet.removeEventListener(MouseEvent.MOUSE_OVER, this.over);
            this.mcPet.removeEventListener(MouseEvent.MOUSE_OUT, this.out);
            this.mcPet.removeEventListener(MouseEvent.CLICK, this.click);
            this.nextPageBtn.removeEventListener(MouseEvent.CLICK, this.changePage);
            this.prevPageBtn.removeEventListener(MouseEvent.CLICK, this.changePage);
            this["item_0"].iconMc.removeEventListener(MouseEvent.ROLL_OVER, this.toolTiponOver);
            this["item_0"].iconMc.removeEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut);
            this["item_1"].iconMc.removeEventListener(MouseEvent.ROLL_OVER, this.toolTiponOver);
            this["item_1"].iconMc.removeEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut);
            this["item_2"].iconMc.removeEventListener(MouseEvent.ROLL_OVER, this.toolTiponOver);
            this["item_2"].iconMc.removeEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut);
            this["item_0"].skillIconMc.removeEventListener(MouseEvent.ROLL_OVER, this.toolTiponOver);
            this["item_0"].skillIconMc.removeEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut);
            this["item_1"].skillIconMc.removeEventListener(MouseEvent.ROLL_OVER, this.toolTiponOver);
            this["item_1"].skillIconMc.removeEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut);
            this["item_2"].skillIconMc.removeEventListener(MouseEvent.ROLL_OVER, this.toolTiponOver);
            this["item_2"].skillIconMc.removeEventListener(MouseEvent.ROLL_OUT, this.toolTiponOut);
            this.mcWeapon.buttonMode = false;
            this.mcSet.buttonMode = false;
            this.mcBackItem.buttonMode = false;
            this.mcAccessory.buttonMode = false;
            this.mcHairstyle.buttonMode = false;
            this.mcSkill.buttonMode = false;
            this.tooltip = null;
            this.main = null;
            this.array_info_holder = null;
            System.gc();
        }

        internal function closePanel(_arg_1:MouseEvent=null):void
        {
            this.killEverything();
            parent.removeChild(this);
        }


    }
}//package Panels

