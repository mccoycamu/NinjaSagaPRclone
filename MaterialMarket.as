// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.MaterialMarket

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import Storage.Character;
    import Storage.ForgeData;
    import com.utils.GF;
    import flash.events.Event;
    import Storage.SkillLibrary;
    import Managers.NinjaSage;
    import Storage.Library;
    import Storage.PetInfo;
    import Popups.Confirmation;
    import flash.system.System;

    public class MaterialMarket extends MovieClip 
    {

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
        public var pageTxt:TextField;
        public var prevPageBtn:SimpleButton;
        public var main:*;
        public var orig_indicator:* = "wpn";
        internal var curr_page:* = 1;
        internal var itemCnt:* = 0;
        internal var itList:*;
        internal var total_page:* = 1;
        public var curr_page_items:Array = [];
        public var is_loading:* = false;
        public var lnr:* = 0;
        public var eventHandler:*;
        private var confirmation:*;
        private var selectedItem:*;

        public function MaterialMarket(_arg_1:*)
        {
            this.eventHandler = new EventHandler();
            this.main = _arg_1;
            this.main.handleVillageHUDVisibility(false);
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
            this.getItems();
        }

        public function getItems():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("MaterialMarket.getItems", [Character.char_id, Character.sessionkey], this.onGetItems);
        }

        public function onGetItems(_arg_1:*):*
        {
            if (_arg_1.status > 1)
            {
                this.main.getNotice(_arg_1.result);
                return;
            };
            ForgeData.constructData(_arg_1.items);
            this.itList = ForgeData.getItemByCategory("wpn");
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
            this.resetButtons();
            this.mcWeapon.buttonMode = true;
            this.eventHandler.addListener(this.mcWeapon, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.addListener(this.mcWeapon, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.addListener(this.mcWeapon, MouseEvent.CLICK, this.click);
            this.mcSet.buttonMode = true;
            this.eventHandler.addListener(this.mcSet, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.addListener(this.mcSet, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.addListener(this.mcSet, MouseEvent.CLICK, this.click);
            this.mcBackItem.buttonMode = true;
            this.eventHandler.addListener(this.mcBackItem, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.addListener(this.mcBackItem, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.addListener(this.mcBackItem, MouseEvent.CLICK, this.click);
            this.mcAccessory.buttonMode = true;
            this.eventHandler.addListener(this.mcAccessory, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.addListener(this.mcAccessory, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.addListener(this.mcAccessory, MouseEvent.CLICK, this.click);
            this.mcHairstyle.buttonMode = true;
            this.eventHandler.addListener(this.mcHairstyle, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.addListener(this.mcHairstyle, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.addListener(this.mcHairstyle, MouseEvent.CLICK, this.click);
            this.mcSkill.buttonMode = true;
            this.eventHandler.addListener(this.mcSkill, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.addListener(this.mcSkill, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.addListener(this.mcSkill, MouseEvent.CLICK, this.click);
            this.mcPet.buttonMode = true;
            this.eventHandler.addListener(this.mcPet, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.addListener(this.mcPet, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.addListener(this.mcPet, MouseEvent.CLICK, this.click);
            this.mcMaterial.buttonMode = true;
            this.eventHandler.addListener(this.mcMaterial, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.addListener(this.mcMaterial, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.addListener(this.mcMaterial, MouseEvent.CLICK, this.click);
            this.eventHandler.addListener(this.nextPageBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.prevPageBtn, MouseEvent.CLICK, this.changePage);
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
            GF.removeAllChild(this.item_0.iconMc.iconHolder);
            GF.removeAllChild(this.item_1.iconMc.iconHolder);
            GF.removeAllChild(this.item_2.iconMc.iconHolder);
            var _local_1:* = 0;
            while (_local_1 < 10)
            {
                this.item_0[("item_" + _local_1)].visible = false;
                this.item_1[("item_" + _local_1)].visible = false;
                this.item_2[("item_" + _local_1)].visible = false;
                GF.removeAllChild(this.item_0[("item_" + _local_1)].iconMC.iconHolder);
                GF.removeAllChild(this.item_1[("item_" + _local_1)].iconMC.iconHolder);
                GF.removeAllChild(this.item_2[("item_" + _local_1)].iconMC.iconHolder);
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
                this.itList = ForgeData.getItemByCategory("wpn");
                this.orig_indicator = "Weapon";
            }
            else
            {
                if (_arg_1 == "BackItem")
                {
                    this.itList = ForgeData.getItemByCategory("back");
                    this.orig_indicator = "BackItem";
                }
                else
                {
                    if (_arg_1 == "Set")
                    {
                        this.itList = ForgeData.getItemByCategory("set");
                        this.orig_indicator = "Set";
                    }
                    else
                    {
                        if (_arg_1 == "Accessory")
                        {
                            this.itList = ForgeData.getItemByCategory("accessory");
                            this.orig_indicator = "Accessory";
                        }
                        else
                        {
                            if (_arg_1 == "Hairstyle")
                            {
                                this.itList = ForgeData.getItemByCategory("hair");
                                this.orig_indicator = "Hairstyle";
                            }
                            else
                            {
                                if (_arg_1 == "Skill")
                                {
                                    this.itList = ForgeData.getItemByCategory("skill");
                                    this.orig_indicator = "Skill";
                                }
                                else
                                {
                                    if (_arg_1 == "Pet")
                                    {
                                        this.itList = ForgeData.getItemByCategory("pet");
                                        this.orig_indicator = "Pet";
                                    }
                                    else
                                    {
                                        if (_arg_1 == "Material")
                                        {
                                            this.itList = ForgeData.getItemByCategory("material");
                                            this.orig_indicator = "Material";
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            var _local_4:* = 3;
            this.total_page = int(((this.itList.length / 3) + 1));
            if (this.itList.length < 4)
            {
                _local_4 = this.itList.length;
                this.total_page = 1;
            };
            if ((this.itList.length % 3) == 0)
            {
                this.total_page = (this.itList.length / 3);
            };
            this.total_page = Math.max(this.total_page, 1);
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
                    this.itemCnt = (this.itemCnt + 3);
                    this.clearSlots();
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
                        this.clearSlots();
                        this.loadItems(this.itemCnt, this.curr_page);
                    };
                };
            };
            this.pageTxt.text = ((this.curr_page + "/") + this.total_page);
        }

        internal function checkLoading(_arg_1:Event):*
        {
            this.lnr++;
            if (this.lnr > 3)
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
            if ((_local_13 = Math.ceil((this.itList.length / _arg_2))) >= 3)
            {
                _local_13 = 3;
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
                    _local_4 = ForgeData.getForgeItems(_local_3);
                    _local_5 = Character.isItemOwned(_local_3);
                    this[("item_" + _local_12)].endTxt.text = ((_local_4["item_mat_end"] == null) ? "Unavailable" : _local_4["item_mat_end"]);
                    this[("item_" + _local_12)].ownedTxt.text = ((!(_local_5)) ? "" : "Owned");
                    if ((_local_6 = (_local_6 = _local_3.split("_"))[0]) == "skill")
                    {
                        _local_9 = SkillLibrary.getSkillInfo(_local_3);
                        this[("item_" + _local_12)].lvlTxt.text = _local_9["skill_level"];
                        this[("item_" + _local_12)].skillIconMc.visible = true;
                        this[("item_" + _local_12)].iconMc.visible = false;
                        GF.removeAllChild(this[("item_" + _local_12)].skillIconMc.iconHolder);
                        NinjaSage.loadItemIcon(this[("item_" + _local_12)].skillIconMc.iconHolder, _local_3, "icon");
                    }
                    else
                    {
                        if (_local_6 == "wpn")
                        {
                            _local_9 = Library.getItemInfo(_local_3);
                            this[("item_" + _local_12)].lvlTxt.text = _local_9["item_level"];
                            GF.removeAllChild(this[("item_" + _local_12)].iconMc.iconHolder);
                            NinjaSage.loadItemIcon(this[("item_" + _local_12)].iconMc.iconHolder, _local_3, "icon");
                            this[("item_" + _local_12)].skillIconMc.visible = false;
                            this[("item_" + _local_12)].iconMc.visible = true;
                        }
                        else
                        {
                            if (_local_6 == "pet")
                            {
                                _local_9 = PetInfo.getPetStats(_local_3);
                                this[("item_" + _local_12)].lvlTxt.text = 20;
                                GF.removeAllChild(this[("item_" + _local_12)].iconMc.iconHolder);
                                NinjaSage.loadItemIcon(this[("item_" + _local_12)].iconMc.iconHolder, _local_3, "icon");
                                this[("item_" + _local_12)].skillIconMc.visible = false;
                                this[("item_" + _local_12)].iconMc.visible = true;
                            }
                            else
                            {
                                if (_local_6 == "material")
                                {
                                    _local_9 = Library.getItemInfo(_local_3);
                                    this[("item_" + _local_12)].lvlTxt.text = 20;
                                    GF.removeAllChild(this[("item_" + _local_12)].iconMc.iconHolder);
                                    NinjaSage.loadItemIcon(this[("item_" + _local_12)].iconMc.iconHolder, _local_3, "icon");
                                    this[("item_" + _local_12)].skillIconMc.visible = false;
                                    this[("item_" + _local_12)].iconMc.visible = true;
                                }
                                else
                                {
                                    _local_9 = Library.getItemInfo(_local_3);
                                    this[("item_" + _local_12)].lvlTxt.text = _local_9["item_level"];
                                    GF.removeAllChild(this[("item_" + _local_12)].iconMc.iconHolder);
                                    NinjaSage.loadItemIcon(this[("item_" + _local_12)].iconMc.iconHolder, _local_3, "icon");
                                    this[("item_" + _local_12)].skillIconMc.visible = false;
                                    this[("item_" + _local_12)].iconMc.visible = true;
                                };
                            };
                        };
                    };
                    this[("item_" + _local_12)].forgeBtn.metaData = {"item_info":_local_9};
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
                            NinjaSage.loadItemIcon(this[("item_" + _local_12)][("item_" + _local_7)].iconMC.iconHolder, _local_4["item_materials"][_local_7], "icon");
                            _local_11 = this.calculateMat(_local_4["item_materials"][_local_7]);
                            _local_9 = Library.getItemInfo(_local_4["item_materials"][_local_7]);
                        }
                        else
                        {
                            if (_local_3[0] == "wpn")
                            {
                                GF.removeAllChild(this[("item_" + _local_12)][("item_" + _local_7)].iconMC.iconHolder);
                                NinjaSage.loadItemIcon(this[("item_" + _local_12)][("item_" + _local_7)].iconMC.iconHolder, _local_4["item_materials"][_local_7], "icon");
                                _local_11 = this.calculateWeapon(_local_4["item_materials"][_local_7]);
                                _local_9 = Library.getItemInfo(_local_4["item_materials"][_local_7]);
                            }
                            else
                            {
                                if (_local_3[0] == "back")
                                {
                                    GF.removeAllChild(this[("item_" + _local_12)][("item_" + _local_7)].iconMC.iconHolder);
                                    NinjaSage.loadItemIcon(this[("item_" + _local_12)][("item_" + _local_7)].iconMC.iconHolder, _local_4["item_materials"][_local_7], "icon");
                                    _local_11 = this.calculateBackItem(_local_4["item_materials"][_local_7]);
                                    _local_9 = Library.getItemInfo(_local_4["item_materials"][_local_7]);
                                }
                                else
                                {
                                    GF.removeAllChild(this[("item_" + _local_12)][("item_" + _local_7)].skillIconMc.iconHolder);
                                    this[("item_" + _local_12)][("item_" + _local_7)].iconMC.visible = false;
                                    this[("item_" + _local_12)][("item_" + _local_7)].skillIconMc.visible = true;
                                    NinjaSage.loadItemIcon(this[("item_" + _local_12)][("item_" + _local_7)].skillIconMc.iconHolder, _local_4["item_materials"][_local_7], "icon");
                                    _local_11 = ((Character.isItemOwned(_local_4["item_materials"][_local_7])) ? 1 : 0);
                                    _local_9 = SkillLibrary.getSkillInfo(_local_4["item_materials"][_local_7]);
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
                            this.eventHandler.addListener(this[("item_" + _local_12)].forgeBtn, MouseEvent.CLICK, this.onForgeItemConfirmation);
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
                            this.eventHandler.addListener(this[("item_" + _local_12)].forgeBtn, MouseEvent.CLICK, this.onForgeItemConfirmation);
                        }
                        else
                        {
                            this[("item_" + _local_12)].statusMC.gotoAndStop(2);
                            this[("item_" + _local_12)].forgeBtn.visible = false;
                        };
                    };
                    if (((_local_5) && (this.orig_indicator == "Skill")))
                    {
                        this[("item_" + _local_12)].statusMC.gotoAndStop(2);
                        this[("item_" + _local_12)].forgeBtn.visible = false;
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

        public function onForgeItemConfirmation(e:MouseEvent):*
        {
            var _loc2_:* = int(e.currentTarget.parent.name.replace("item_", ""));
            var itemInfo:* = e.currentTarget.metaData.item_info;
            var itemName:* = "";
            if (("item_name" in itemInfo))
            {
                itemName = itemInfo["item_name"];
            }
            else
            {
                if (("skill_name" in itemInfo))
                {
                    itemName = itemInfo["skill_name"];
                }
                else
                {
                    if (("pet_name" in itemInfo))
                    {
                        itemName = itemInfo["pet_name"];
                    };
                };
            };
            this.selectedItem = this.curr_page_items[_loc2_];
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (("Are you sure want to forge " + itemName) + " ?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():void
            {
                removeChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onForgeItemRequest);
            addChild(this.confirmation);
        }

        public function onForgeItemRequest(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            this.main.loading(true);
            this.main.amf_manager.service("MaterialMarket.forgeItem", [Character.char_id, Character.sessionkey, this.selectedItem], this.onForgeItemResponse);
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

        internal function killEverything():void
        {
            this.main.handleVillageHUDVisibility(true);
            this.clearSlots();
            this.eventHandler.removeAllEventListeners();
            this.eventHandler.removeListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.removeListener(this.mcWeapon, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.removeListener(this.mcWeapon, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.removeListener(this.mcWeapon, MouseEvent.CLICK, this.click);
            this.eventHandler.removeListener(this.mcSet, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.removeListener(this.mcSet, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.removeListener(this.mcSet, MouseEvent.CLICK, this.click);
            this.eventHandler.removeListener(this.mcBackItem, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.removeListener(this.mcBackItem, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.removeListener(this.mcBackItem, MouseEvent.CLICK, this.click);
            this.eventHandler.removeListener(this.mcAccessory, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.removeListener(this.mcAccessory, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.removeListener(this.mcAccessory, MouseEvent.CLICK, this.click);
            this.eventHandler.removeListener(this.mcHairstyle, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.removeListener(this.mcHairstyle, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.removeListener(this.mcHairstyle, MouseEvent.CLICK, this.click);
            this.eventHandler.removeListener(this.mcSkill, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.removeListener(this.mcSkill, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.removeListener(this.mcSkill, MouseEvent.CLICK, this.click);
            this.eventHandler.removeListener(this.mcPet, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.removeListener(this.mcPet, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.removeListener(this.mcPet, MouseEvent.CLICK, this.click);
            this.eventHandler.removeListener(this.nextPageBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.removeListener(this.prevPageBtn, MouseEvent.CLICK, this.changePage);
            var _local_1:* = 0;
            GF.removeAllChild(this.item_0.iconMc.iconHolder);
            GF.removeAllChild(this.item_1.iconMc.iconHolder);
            GF.removeAllChild(this.item_2.iconMc.iconHolder);
            this.item_0.forgeBtn.metaData = {};
            this.item_1.forgeBtn.metaData = {};
            this.item_2.forgeBtn.metaData = {};
            while (_local_1 < 10)
            {
                GF.removeAllChild(this.item_0[("item_" + _local_1)].iconMC.iconHolder);
                GF.removeAllChild(this.item_1[("item_" + _local_1)].iconMC.iconHolder);
                GF.removeAllChild(this.item_2[("item_" + _local_1)].iconMC.iconHolder);
                _local_1++;
            };
            NinjaSage.clearEventListener();
            this.mcWeapon.buttonMode = false;
            this.mcSet.buttonMode = false;
            this.mcBackItem.buttonMode = false;
            this.mcAccessory.buttonMode = false;
            this.mcHairstyle.buttonMode = false;
            this.mcSkill.buttonMode = false;
            this.eventHandler = null;
            this.main = null;
            System.gc();
        }

        internal function closePanel(_arg_1:MouseEvent):void
        {
            this.killEverything();
            GF.removeAllChild(this);
        }


    }
}//package Panels

