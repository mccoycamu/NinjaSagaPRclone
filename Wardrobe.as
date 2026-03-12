// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.Wardrobe

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import br.com.stimuli.loading.BulkLoader;
    import Storage.Character;
    import com.abrahamyan.liquid.ToolTip;
    import id.ninjasage.EventHandler;
    import fl.motion.Color;
    import flash.events.MouseEvent;
    import flash.utils.getDefinitionByName;
    import Managers.OutfitManager;
    import Managers.NinjaSage;
    import com.utils.GF;
    import flash.events.ErrorEvent;
    import Storage.Library;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.system.System;

    public dynamic class Wardrobe extends MovieClip 
    {

        public var panelMC:MovieClip;
        public var btn_clear:SimpleButton;
        public var btn_clearSearch:SimpleButton;
        public var btn_close:SimpleButton;
        public var btn_next:SimpleButton;
        public var btn_preset:SimpleButton;
        public var btn_prev:SimpleButton;
        public var btn_search:SimpleButton;
        public var btn_to_page:SimpleButton;
        public var btn_unequip:SimpleButton;
        public var char_mc:MovieClip;
        public var colorMC0:MovieClip;
        public var colorMC1:MovieClip;
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
        public var mcAccessory:MovieClip;
        public var mcBackItem:MovieClip;
        public var mcColor:MovieClip;
        public var mcEssentials:MovieClip;
        public var mcHairstyle:MovieClip;
        public var mcItems:MovieClip;
        public var mcMaterials:MovieClip;
        public var mcSet:MovieClip;
        public var mcWeapon:MovieClip;
        public var presetMC:MovieClip;
        public var txt_goToPage:TextField;
        public var txt_page:TextField;
        public var txt_search:TextField;
        public var weaponArray:Array;
        public var backArray:Array;
        public var accArray:Array;
        public var setArray:Array;
        public var hairArray:Array;
        public var materialArray:Array;
        public var essentialArray:Array;
        public var consumableArray:Array;
        public var selectedCategory:Array;
        public var presets:Array;
        public var currentPage:int = 1;
        public var totalPage:int = 1;
        public var itemIndex:int = 0;
        public var itemLoading:int = 0;
        public var itemCount:int = 0;
        public var presetTarget:int;
        public var preset_total_page:int = 0;
        public var preset_curr_page:int = 1;
        public var tabIndicator:String = "weapon";
        public var equippedItem:String;
        public var usableItem:String;
        public var selectedHairColor:String;
        public var selectedSkinColor:String;
        public var selectedHairMC:MovieClip;
        public var selectedBackHairMC:MovieClip;
        public var selectedSetMC:Array;
        public var color:*;
        public var isLoading:Boolean;
        public var firstLoad:Boolean = true;
        public var eventHandler:*;
        public var tooltip:*;
        public var main:*;
        public var confirmation:*;
        public var character:*;
        public var preset_selection_parent:*;
        public var savedWithButton:String;
        public var selected_class:String;
        public var skill_inventoryMC:*;
        public var pet_inventoryMC:*;

        public var outfits:Array = [];
        public var itemEquipMC:Array = [];
        public var backHairMC:Array = [];
        public var skirtMC:Array = [];
        public var tabButton:Array = ["mcHairstyle", "mcSet", "mcBackItem", "mcWeapon", "mcAccessory", "mcPet"];
        public var bodyArray:Array = ["upper_body", "lower_body", "left_upper_arm", "left_lower_arm", "left_hand", "left_upper_leg", "left_lower_leg", "left_shoe", "right_upper_arm", "right_lower_arm", "right_hand", "right_upper_leg", "right_lower_leg", "right_shoe"];
        public var loaderSwf:* = BulkLoader.createUniqueNamedLoader(10);

        public function Wardrobe(_arg_1:*, _arg_2:*, _arg_3:*)
        {
            this.weaponArray = this.sortItems(Character.character_weapons.split(","));
            this.setArray = this.sortItems(Character.character_sets.split(","));
            this.backArray = this.sortItems(Character.character_back_items.split(","));
            this.accArray = this.sortItems(Character.character_accessories.split(","));
            this.hairArray = this.sortItems(Character.character_hairs.split(","));
            super();
            this.main = _arg_1;
            this.panelMC = _arg_2;
            this.preset_selection_parent = _arg_3;
            this.tooltip = ToolTip.getInstance();
            this.eventHandler = new EventHandler();
            this.color = new Color();
            this.initButton();
            this.initUI();
        }

        public function initButton():*
        {
            var _local_1:* = 0;
            while (_local_1 < this.tabButton.length)
            {
                this.panelMC[this.tabButton[_local_1]].gotoAndStop(1);
                this.panelMC[this.tabButton[_local_1]].buttonMode = true;
                this.eventHandler.addListener(this.panelMC[this.tabButton[_local_1]], MouseEvent.CLICK, this.changeCategory);
                _local_1++;
            };
            if (PresetData.preset_id_used == PresetData.preset_id_edit)
            {
                this.panelMC.btn_use.visible = false;
            };
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btn_to_page, MouseEvent.CLICK, this.goToPage);
            this.eventHandler.addListener(this.panelMC.btn_search, MouseEvent.CLICK, this.searchItem);
            this.eventHandler.addListener(this.panelMC.btn_clearSearch, MouseEvent.CLICK, this.clearSearch);
            this.eventHandler.addListener(this.panelMC.btn_skill, MouseEvent.CLICK, this.openSkillInventory);
            this.eventHandler.addListener(this.panelMC.btn_save, MouseEvent.CLICK, this.savePreset);
            this.eventHandler.addListener(this.panelMC.btn_use, MouseEvent.CLICK, this.usePreset);
        }

        public function openSkillInventory(_arg_1:MouseEvent):*
        {
            var _local_2:MovieClip = this.preset_selection_parent.skillMC;
            var _local_3:Class = (getDefinitionByName("id.ninjasage.features.SkillInventory") as Class);
            this.skill_inventoryMC = new _local_3(this.main, _local_2, this);
            _local_2.visible = true;
        }

        public function initUI():*
        {
            var _local_1:*;
            if (!Character.is_stickman)
            {
                _local_1 = new OutfitManager();
                _local_1.fillOutfit(this.panelMC.char_mc, PresetData.preset_wpn, PresetData.preset_back, PresetData.preset_set, PresetData.preset_hair, Character.character_face, Character.character_color_hair, Character.character_color_skin);
                this.outfits.push(_local_1);
            };
            this.panelMC.txt_goToPage.restrict = "0-9";
            this.panelMC.txt_title.text = (Character.character_name + "'s Wardrobe");
            this.panelMC.txt_presetName.text = PresetData.selected_preset_name;
            this.selectedHairColor = Character.character_color_hair;
            this.selectedSkinColor = Character.character_color_skin;
            this.tabIndicator = "hair";
            this.selectedCategory = this.hairArray;
            this.equippedItem = PresetData.preset_hair;
            this.totalPage = Math.ceil((this.selectedCategory.length / 9));
            this.loadTabIconSwf();
            this.loadPetIconAndBody();
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.loadSwf();
        }

        public function loadTabIconSwf(_arg_1:int=100000000):*
        {
            var _local_3:int;
            var _local_2:Array = [PresetData.preset_hair, PresetData.preset_set, PresetData.preset_back, PresetData.preset_wpn, PresetData.preset_acc];
            if (_arg_1 > 4)
            {
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    NinjaSage.loadItemIcon(this.panelMC[this.tabButton[_local_3]], _local_2[_local_3]);
                    _local_3++;
                };
            }
            else
            {
                NinjaSage.loadItemIcon(this.panelMC[this.tabButton[_arg_1]], _local_2[_arg_1]);
            };
        }

        public function loadPetIconAndBody():*
        {
            GF.removeAllChild(this.panelMC.pet_mc);
            GF.removeAllChild(this.panelMC.mcPet.rewardIcon.iconHolder);
            if (((PresetData.preset_pet == "") || (PresetData.preset_pet_id == 0)))
            {
                return;
            };
            NinjaSage.loadItemIcon(this.panelMC.mcPet, PresetData.preset_pet);
            this.panelMC.pet_mc.scaleX = 1.4;
            this.panelMC.pet_mc.scaleY = 1.4;
            NinjaSage.loadIconSWF("pets", PresetData.preset_pet, this.panelMC.pet_mc, PresetData.preset_pet);
        }

        public function loadSwf():*
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            this.isLoading = true;
            if (this.itemIndex < this.itemLoading)
            {
                _local_1 = this.selectedCategory[this.itemIndex].split(":")[0];
                _local_2 = (((this.getAssetPath(_local_1) + "/") + _local_1) + ".swf");
                _local_3 = this.loaderSwf.add(_local_2);
                _local_3.addEventListener(BulkLoader.COMPLETE, this.completeIcon);
                _local_3.addEventListener(BulkLoader.ERROR, this.onItemLoadError);
                this.loaderSwf.start();
            }
            else
            {
                this.isLoading = false;
                return;
            };
        }

        public function onItemLoadError(_arg_1:ErrorEvent):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.COMPLETE, this.completeIcon);
            this.itemEquipMC[this.itemCount] = null;
            this.backHairMC[this.itemCount] = null;
            this.skirtMC[this.itemCount] = null;
            this.itemIndex++;
            this.itemCount++;
            this.loadSwf();
        }

        public function completeIcon(_arg_1:Event):*
        {
            var _local_8:Array;
            var _local_9:*;
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.ERROR, this.onItemLoadError);
            var _local_3:Class;
            var _local_4:MovieClip;
            _local_4 = _arg_1.target.content["icon"];
            if (!Character.play_items_animation)
            {
                _local_4.stopAllMovieClips();
            };
            this.panelMC[("item_" + this.itemCount)].iconMc.iconHolder.addChild(_local_4);
            this.panelMC[("item_" + this.itemCount)].gotoAndStop(1);
            this.panelMC[("item_" + this.itemCount)].visible = true;
            if (this.tabIndicator == "weapon")
            {
                _local_4 = _arg_1.target.content["weapon"];
                if (!Character.play_items_animation)
                {
                    _local_4.stopAllMovieClips();
                };
                this.itemEquipMC.push(_local_4);
            }
            else
            {
                if (this.tabIndicator == "back")
                {
                    _local_4 = _arg_1.target.content["back_item"];
                    if (!Character.play_items_animation)
                    {
                        _local_4.stopAllMovieClips();
                    };
                    this.itemEquipMC.push(_local_4);
                }
                else
                {
                    if (this.tabIndicator == "hair")
                    {
                        _local_4 = _arg_1.target.content["hair"];
                        if (!Character.play_items_animation)
                        {
                            _local_4.stopAllMovieClips();
                        };
                        this.itemEquipMC.push(_local_4);
                        try
                        {
                            _local_4 = _arg_1.target.content["back_hair"];
                            if (!Character.play_items_animation)
                            {
                                _local_4.stopAllMovieClips();
                            };
                            this.backHairMC.push(_local_4);
                        }
                        catch(error)
                        {
                        };
                    }
                    else
                    {
                        if (this.tabIndicator == "set")
                        {
                            _local_8 = [];
                            _local_9 = 0;
                            while (_local_9 < this.bodyArray.length)
                            {
                                _local_4 = _arg_1.target.content[this.bodyArray[_local_9]];
                                if (!Character.play_items_animation)
                                {
                                    _local_4.stopAllMovieClips();
                                };
                                _local_8.push(_local_4);
                                _local_9++;
                            };
                            try
                            {
                                _local_4 = _arg_1.target.content["skirt"];
                                if (!Character.play_items_animation)
                                {
                                    _local_4.stopAllMovieClips();
                                };
                                this.skirtMC.push(_local_4);
                            }
                            catch(error)
                            {
                            };
                            this.itemEquipMC.push(_local_8);
                        };
                    };
                };
            };
            var _local_5:* = this.selectedCategory[this.itemIndex].split(":")[0];
            var _local_6:* = this.selectedCategory[this.itemIndex].split(":")[1];
            var _local_7:* = Library.getItemInfo(_local_5);
            this.panelMC[("item_" + this.itemCount)].lvlTxt.text = _local_7.item_level;
            if (_local_6 != undefined)
            {
                this.panelMC[("item_" + this.itemCount)].amtTxt.visible = true;
                this.panelMC[("item_" + this.itemCount)].amtTxt.text = ("x" + _local_6);
            }
            else
            {
                this.panelMC[("item_" + this.itemCount)].amtTxt.visible = false;
                _local_6 = 1;
            };
            if (_local_7.item_premium)
            {
                this.panelMC[("item_" + this.itemCount)].emblemMC.visible = true;
            };
            if (_local_7.item_level <= int(Character.character_lvl))
            {
                this.color.brightness = 0;
                this.panelMC[("item_" + this.itemCount)].transform.colorTransform = this.color;
                this.panelMC[("item_" + this.itemCount)].btn_equip.visible = true;
                this.panelMC[("item_" + this.itemCount)].lockMc.visible = false;
            };
            this.panelMC[("item_" + this.itemCount)].btn_sell.visible = false;
            if (_local_5 == this.equippedItem)
            {
                this.panelMC["item_0"]["txt_equipped"].visible = true;
                this.panelMC["item_0"]["btn_equip"].visible = false;
            };
            this.panelMC[("item_" + this.itemCount)].clickmask.tooltip = _local_7;
            this.panelMC[("item_" + this.itemCount)].clickmask.item_type = _local_5.split("_")[0];
            this.panelMC[("item_" + this.itemCount)].btn_equip.metaData = {"equip_item":_local_7["item_id"]};
            this.eventHandler.addListener(this.panelMC[("item_" + this.itemCount)].clickmask, MouseEvent.MOUSE_OVER, this.toolTiponOver);
            this.eventHandler.addListener(this.panelMC[("item_" + this.itemCount)].clickmask, MouseEvent.MOUSE_OUT, this.toolTiponOut);
            this.eventHandler.addListener(this.panelMC[("item_" + this.itemCount)].clickmask, MouseEvent.CLICK, this.previewItem);
            this.eventHandler.addListener(this.panelMC[("item_" + this.itemCount)].btn_equip, MouseEvent.CLICK, this.equipItem);
            if ((((_local_7.item_id.indexOf("material") >= 0) || (_local_7.item_id.indexOf("essential") >= 0)) || (_local_7.item_id.indexOf("item") >= 0)))
            {
                this.eventHandler.removeListener(this.panelMC[("item_" + this.itemCount)].clickmask, MouseEvent.CLICK, this.previewItem);
                this.eventHandler.removeListener(this.panelMC[("item_" + this.itemCount)].btn_equip, MouseEvent.CLICK, this.equipItem);
            };
            this.itemIndex++;
            this.itemCount++;
            this.loadSwf();
        }

        public function previewItem(_arg_1:MouseEvent):*
        {
            var _local_3:*;
            var _local_2:int = _arg_1.currentTarget.parent.name.replace("item_", "");
            if (this.tabIndicator == "weapon")
            {
                this.removeChildsFromMovieClip(this.panelMC.char_mc["weapon"]);
                this.panelMC.char_mc["weapon"].addChild(this.itemEquipMC[_local_2]);
            }
            else
            {
                if (this.tabIndicator == "back")
                {
                    this.removeChildsFromMovieClip(this.panelMC.char_mc["back"]);
                    this.panelMC.char_mc["back"].addChild(this.itemEquipMC[_local_2]);
                }
                else
                {
                    if (this.tabIndicator == "hair")
                    {
                        this.removeChildsFromMovieClip(this.panelMC.char_mc.head["hair"]);
                        this.selectedHairMC = this.itemEquipMC[_local_2];
                        this.addHairColor(this.itemEquipMC[_local_2]);
                        this.panelMC.char_mc.head["hair"].addChild(this.itemEquipMC[_local_2]);
                        try
                        {
                            this.removeChildsFromMovieClip(this.panelMC.char_mc["back_hair"]);
                            this.selectedBackHairMC = this.backHairMC[_local_2];
                            this.addHairColor(this.backHairMC[_local_2]);
                            this.panelMC.char_mc["back_hair"].addChild(this.backHairMC[_local_2]);
                        }
                        catch(error:Error)
                        {
                        };
                    }
                    else
                    {
                        if (this.tabIndicator == "set")
                        {
                            this.selectedSetMC = [];
                            _local_3 = 0;
                            while (_local_3 < this.bodyArray.length)
                            {
                                this.removeChildsFromMovieClip(this.panelMC.char_mc[this.bodyArray[_local_3]]);
                                this.selectedSetMC.push(this.itemEquipMC[_local_2][_local_3]);
                                this.addSkinColor(this.itemEquipMC[_local_2][_local_3]);
                                this.panelMC.char_mc[this.bodyArray[_local_3]].addChild(this.itemEquipMC[_local_2][_local_3]);
                                try
                                {
                                    this.removeChildsFromMovieClip(this.panelMC.char_mc["skirt"]);
                                    this.panelMC.char_mc["skirt"].addChild(this.skirtMC[_local_2]);
                                }
                                catch(error:Error)
                                {
                                };
                                _local_3++;
                            };
                        };
                    };
                };
            };
        }

        public function equipItem(_arg_1:MouseEvent):*
        {
            var _local_5:*;
            var _local_2:* = _arg_1.currentTarget.metaData.equip_item;
            var _local_3:* = _local_2.split("_")[0];
            var _local_4:int = _arg_1.currentTarget.parent.name.replace("item_", "");
            if (_local_3 == "wpn")
            {
                this.removeChildsFromMovieClip(this.panelMC.char_mc["weapon"]);
                PresetData.preset_wpn = _local_2;
                this.equippedItem = _local_2;
                this.panelMC.char_mc["weapon"].addChild(this.itemEquipMC[_local_4]);
                OutfitManager.weapon_mc[0] = this.itemEquipMC[_local_4];
                this.loadTabIconSwf(3);
                this.setDefaultArray();
            }
            else
            {
                if (_local_3 == "back")
                {
                    this.removeChildsFromMovieClip(this.panelMC.char_mc["back"]);
                    PresetData.preset_back = _local_2;
                    this.equippedItem = _local_2;
                    this.panelMC.char_mc["back"].addChild(this.itemEquipMC[_local_4]);
                    OutfitManager.back_mc[0] = this.itemEquipMC[_local_4];
                    this.loadTabIconSwf(2);
                    this.setDefaultArray();
                }
                else
                {
                    if (_local_3 == "hair")
                    {
                        this.removeChildsFromMovieClip(this.panelMC.char_mc.head["hair"]);
                        this.selectedHairMC = this.itemEquipMC[_local_4];
                        this.addHairColor(this.itemEquipMC[_local_4]);
                        PresetData.preset_hair = _local_2;
                        this.equippedItem = _local_2;
                        this.panelMC.char_mc.head["hair"].addChild(this.itemEquipMC[_local_4]);
                        OutfitManager.hair_mc[0] = this.itemEquipMC[_local_4];
                        try
                        {
                            this.removeChildsFromMovieClip(this.panelMC.char_mc["back_hair"]);
                            this.selectedBackHairMC = this.backHairMC[_local_4];
                            this.addHairColor(this.backHairMC[_local_4]);
                            this.panelMC.char_mc["back_hair"].addChild(this.backHairMC[_local_4]);
                            OutfitManager.hair_mc[1] = this.backHairMC[_local_4];
                        }
                        catch(error:Error)
                        {
                        };
                        this.loadTabIconSwf(0);
                        this.setDefaultArray();
                    }
                    else
                    {
                        if (_local_3 == "accessory")
                        {
                            PresetData.preset_acc = _local_2;
                            this.equippedItem = _local_2;
                            this.loadTabIconSwf(4);
                            this.setDefaultArray();
                        }
                        else
                        {
                            if (_local_3 == "set")
                            {
                                this.selectedSetMC = [];
                                _local_5 = 0;
                                while (_local_5 < this.bodyArray.length)
                                {
                                    this.removeChildsFromMovieClip(this.panelMC.char_mc[this.bodyArray[_local_5]]);
                                    this.selectedSetMC.push(this.itemEquipMC[_local_4][_local_5]);
                                    this.addSkinColor(this.itemEquipMC[_local_4][_local_5]);
                                    this.panelMC.char_mc[this.bodyArray[_local_5]].addChild(this.itemEquipMC[_local_4][_local_5]);
                                    OutfitManager.set_mc[_local_5] = this.itemEquipMC[_local_4][_local_5];
                                    try
                                    {
                                        this.removeChildsFromMovieClip(this.panelMC.char_mc["skirt"]);
                                        this.panelMC.char_mc["skirt"].addChild(this.skirtMC[_local_4]);
                                        OutfitManager.set_mc[14] = this.skirtMC[_local_4];
                                    }
                                    catch(error:Error)
                                    {
                                    };
                                    _local_5++;
                                };
                                PresetData.preset_set = _local_2;
                                this.equippedItem = _local_2;
                                this.loadTabIconSwf(1);
                                this.setDefaultArray();
                            };
                        };
                    };
                };
            };
            this.currentPage = 1;
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            this.loadSwf();
        }

        public function searchItem(_arg_1:MouseEvent):*
        {
            var _local_4:*;
            var _local_5:*;
            if (this.panelMC.txt_search.text == "")
            {
                return;
            };
            this.setDefaultArray();
            var _local_2:Array = [];
            var _local_3:String = this.panelMC.txt_search.text.toLowerCase();
            var _local_6:* = 0;
            while (_local_6 < this.selectedCategory.length)
            {
                _local_5 = this.selectedCategory[_local_6].split(":")[0];
                _local_4 = Library.getItemInfo(_local_5);
                if ((((_local_4) && (_local_4.hasOwnProperty("item_name"))) && (_local_4["item_name"].toLowerCase().indexOf(_local_3) >= 0)))
                {
                    _local_2.push(this.selectedCategory[_local_6]);
                };
                _local_6++;
            };
            this.selectedCategory = this.sortItems(_local_2);
            this.totalPage = Math.ceil((this.selectedCategory.length / 9));
            this.currentPage = 1;
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            this.loadSwf();
        }

        public function clearSearch(_arg_1:MouseEvent):*
        {
            this.panelMC.txt_search.text = "";
            this.panelMC.txt_goToPage.text = "";
            this.currentPage = 1;
            this.setDefaultArray();
            this.totalPage = Math.ceil((this.selectedCategory.length / 9));
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            this.loadSwf();
        }

        public function goToPage(_arg_1:MouseEvent):*
        {
            if (this.panelMC.txt_goToPage.text == "")
            {
                return;
            };
            if (((int(this.panelMC.txt_goToPage.text) > this.totalPage) || (int(this.panelMC.txt_goToPage.text) <= 0)))
            {
                return;
            };
            this.currentPage = int(this.panelMC.txt_goToPage.text);
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            this.loadSwf();
        }

        public function clearPreview(_arg_1:MouseEvent):*
        {
            this.removeChildsFromMovieClip(this.panelMC.char_mc["weapon"]);
            this.removeChildsFromMovieClip(this.panelMC.char_mc["back"]);
            this.removeChildsFromMovieClip(this.panelMC.char_mc.head["hair"]);
            this.removeChildsFromMovieClip(this.panelMC.char_mc["back_hair"]);
            this.removeChildsFromMovieClip(this.panelMC.char_mc["skirt"]);
            var _local_2:* = 0;
            while (_local_2 < this.bodyArray.length)
            {
                this.removeChildsFromMovieClip(this.panelMC.char_mc[this.bodyArray[_local_2]]);
                this.panelMC.char_mc[this.bodyArray[_local_2]].addChild(OutfitManager.set_mc[_local_2]);
                _local_2++;
            };
            try
            {
                this.panelMC.char_mc["weapon"].addChild(OutfitManager.weapon_mc[0]);
                this.panelMC.char_mc.head["hair"].addChild(OutfitManager.hair_mc[0]);
                this.panelMC.char_mc["back_hair"].addChild(OutfitManager.hair_mc[1]);
                this.panelMC.char_mc["skirt"].addChild(OutfitManager.set_mc[14]);
                this.panelMC.char_mc["back"].addChild(OutfitManager.back_mc[0]);
            }
            catch(error:Error)
            {
            };
        }

        public function unEquipItem(_arg_1:MouseEvent):*
        {
            if (this.tabIndicator == "accessories")
            {
                PresetData.preset_acc = "accessory_00";
                this.equippedItem = "accessory_00";
            }
            else
            {
                if (this.tabIndicator == "back")
                {
                    PresetData.preset_back = "back_00";
                    this.equippedItem = "back_00";
                    this.removeChildsFromMovieClip(this.panelMC.char_mc["back"]);
                    OutfitManager.back_mc[0] = null;
                };
            };
            this.currentPage = 1;
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            this.loadSwf();
        }

        public function addHairColor(_arg_1:MovieClip):*
        {
            var _local_2:ColorTransform = new ColorTransform();
            var _local_3:ColorTransform = new ColorTransform();
            var _local_4:* = this.selectedHairColor.split("|");
            _local_2.color = _local_4[0];
            _local_3.color = _local_4[1];
            if ((("hair_color_1" in _arg_1) && (!(_local_4[0] == "null"))))
            {
                try
                {
                    _arg_1.hair_color_1.transform.colorTransform = _local_2;
                }
                catch(error:Error)
                {
                };
            };
            if ((("hair_color_2" in _arg_1) && (!(_local_4[1] == "null"))))
            {
                try
                {
                    _arg_1.hair_color_2.transform.colorTransform = _local_3;
                }
                catch(error:Error)
                {
                };
            };
        }

        public function addSkinColor(_arg_1:MovieClip):*
        {
            var _local_2:ColorTransform = new ColorTransform();
            var _local_3:* = this.selectedSkinColor.split("|");
            _local_2.color = _local_3[0];
            if (_local_3[0] != "null")
            {
                if (("skin_color" in _arg_1))
                {
                    try
                    {
                        _arg_1.skin_color.transform.colorTransform = _local_2;
                    }
                    catch(error:Error)
                    {
                    };
                };
            };
        }

        public function addFaceColor(_arg_1:MovieClip):*
        {
            var _local_2:ColorTransform = new ColorTransform();
            var _local_3:* = this.selectedSkinColor.split("|");
            _local_2.color = _local_3[1];
            if (_local_3[1] != "null")
            {
                if (("skin_color" in _arg_1))
                {
                    try
                    {
                        _arg_1.skin_color.transform.colorTransform = _local_2;
                    }
                    catch(error:Error)
                    {
                    };
                };
            };
        }

        public function resetSkinColor(_arg_1:MouseEvent):*
        {
            Character.character_color_skin = "null|null";
            this.selectedSkinColor = "null|null";
            var _local_2:ColorTransform = new ColorTransform();
            var _local_3:* = 0;
            while (_local_3 < this.bodyArray.length)
            {
                this.removeChildsFromMovieClip(this.panelMC.char_mc[this.bodyArray[_local_3]]);
                if (("skin_color" in this.selectedSetMC[_local_3]))
                {
                    this.selectedSetMC[_local_3].skin_color.transform.colorTransform = _local_2;
                };
                this.panelMC.char_mc[this.bodyArray[_local_3]].addChild(this.selectedSetMC[_local_3]);
                _local_3++;
            };
            this.removeChildsFromMovieClip(this.panelMC.char_mc.head.face);
            OutfitManager.face_mc[0].skin_color.transform.colorTransform = _local_2;
            this.panelMC.char_mc.head.face.addChild(OutfitManager.face_mc[0]);
        }

        public function colorChangeHandler1(_arg_1:*):*
        {
            var _local_2:* = uint(("0x" + _arg_1.target.hexValue));
            var _local_3:* = this.selectedHairColor.split("|");
            this.selectedHairColor = ((_local_2 + "|") + _local_3[1]);
            Character.character_color_hair = this.selectedHairColor;
            this.removeChildsFromMovieClip(this.panelMC.char_mc.head["hair"]);
            this.addHairColor(this.selectedHairMC);
            this.panelMC.char_mc.head["hair"].addChild(this.selectedHairMC);
        }

        public function colorChangeHandler2(_arg_1:*):*
        {
            var _local_2:* = uint(("0x" + _arg_1.target.hexValue));
            var _local_3:* = this.selectedHairColor.split("|");
            this.selectedHairColor = ((_local_3[0] + "|") + _local_2);
            Character.character_color_hair = this.selectedHairColor;
            this.removeChildsFromMovieClip(this.panelMC.char_mc.head["hair"]);
            this.addHairColor(this.selectedHairMC);
            this.panelMC.char_mc.head["hair"].addChild(this.selectedHairMC);
        }

        public function colorChangeHandler3(_arg_1:*):*
        {
            var _local_2:* = uint(("0x" + _arg_1.target.hexValue));
            var _local_3:* = this.selectedSkinColor.split("|");
            this.selectedSkinColor = ((_local_2 + "|") + _local_3[1]);
            Character.character_color_skin = this.selectedSkinColor;
            var _local_4:* = 0;
            while (_local_4 < this.bodyArray.length)
            {
                this.removeChildsFromMovieClip(this.panelMC.char_mc[this.bodyArray[_local_4]]);
                this.addSkinColor(this.selectedSetMC[_local_4]);
                this.panelMC.char_mc[this.bodyArray[_local_4]].addChild(this.selectedSetMC[_local_4]);
                _local_4++;
            };
        }

        public function colorChangeHandler4(_arg_1:*):*
        {
            var _local_2:* = uint(("0x" + _arg_1.target.hexValue));
            var _local_3:* = this.selectedSkinColor.split("|");
            this.selectedSkinColor = ((_local_3[0] + "|") + _local_2);
            Character.character_color_skin = this.selectedSkinColor;
            this.removeChildsFromMovieClip(this.panelMC.char_mc.head.face);
            this.addFaceColor(OutfitManager.face_mc[0]);
            this.panelMC.char_mc.head.face.addChild(OutfitManager.face_mc[0]);
        }

        public function changePage(_arg_1:MouseEvent):*
        {
            if (this.isLoading)
            {
                return;
            };
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                    }
                    else
                    {
                        return;
                    };
                    break;
                case "btn_prev":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                    }
                    else
                    {
                        return;
                    };
            };
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            if (this.loaderSwf.itemsLoaded >= 40)
            {
                this.loaderSwf.removeAll();
            };
            this.loadSwf();
        }

        public function updatePageNumber():*
        {
            this.panelMC.txt_page.text = ((this.currentPage + "/") + this.totalPage);
        }

        public function changeCategory(_arg_1:MouseEvent):*
        {
            var _local_4:MovieClip;
            var _local_5:Class;
            if (this.isLoading)
            {
                return;
            };
            var _local_2:* = 0;
            while (_local_2 < this.tabButton.length)
            {
                this.panelMC[this.tabButton[_local_2]].gotoAndStop(1);
                _local_2++;
            };
            _arg_1.currentTarget.gotoAndStop(3);
            var _local_3:String = _arg_1.currentTarget.name;
            switch (_local_3)
            {
                case "mcWeapon":
                    this.selectedCategory = this.weaponArray;
                    this.tabIndicator = "weapon";
                    this.equippedItem = PresetData.preset_wpn;
                    break;
                case "mcSet":
                    this.selectedCategory = this.setArray;
                    this.tabIndicator = "set";
                    this.equippedItem = PresetData.preset_set;
                    break;
                case "mcBackItem":
                    this.selectedCategory = this.backArray;
                    this.tabIndicator = "back";
                    this.equippedItem = PresetData.preset_back;
                    break;
                case "mcAccessory":
                    this.selectedCategory = this.accArray;
                    this.tabIndicator = "accessories";
                    this.equippedItem = PresetData.preset_acc;
                    break;
                case "mcEssentials":
                    this.selectedCategory = this.essentialArray;
                    this.tabIndicator = "essential";
                    break;
                case "mcMaterials":
                    this.selectedCategory = this.materialArray;
                    this.tabIndicator = "material";
                    break;
                case "mcHairstyle":
                    this.selectedCategory = this.hairArray;
                    this.tabIndicator = "hair";
                    this.equippedItem = PresetData.preset_hair;
                    break;
                case "mcItems":
                    this.selectedCategory = this.consumableArray;
                    this.tabIndicator = "consumable";
                    break;
                case "mcColor":
                    break;
                case "mcPet":
                    _local_4 = this.preset_selection_parent.petMC;
                    _local_5 = (getDefinitionByName("id.ninjasage.features.PetInventory") as Class);
                    this.pet_inventoryMC = new _local_5(this.main, _local_4, this);
                    _local_4.visible = true;
                    return;
            };
            if (_local_3 != "mcColor")
            {
                this.currentPage = 1;
                this.totalPage = Math.ceil((this.selectedCategory.length / 9));
                this.resetIconHolder();
                this.resetRecursiveProperty();
                this.updatePageNumber();
                this.loadSwf();
            };
        }

        public function setDefaultArray():*
        {
            if (this.tabIndicator == "weapon")
            {
                this.weaponArray = this.sortItems(Character.character_weapons.split(","));
                this.selectedCategory = this.weaponArray;
            }
            else
            {
                if (this.tabIndicator == "set")
                {
                    this.setArray = this.sortItems(Character.character_sets.split(","));
                    this.selectedCategory = this.setArray;
                }
                else
                {
                    if (this.tabIndicator == "back")
                    {
                        this.backArray = this.sortItems(Character.character_back_items.split(","));
                        this.selectedCategory = this.backArray;
                    }
                    else
                    {
                        if (this.tabIndicator == "accessories")
                        {
                            this.accArray = this.sortItems(Character.character_accessories.split(","));
                            this.selectedCategory = this.accArray;
                        }
                        else
                        {
                            if (this.tabIndicator == "hair")
                            {
                                this.hairArray = this.sortItems(Character.character_hairs.split(","));
                                this.selectedCategory = this.hairArray;
                            };
                        };
                    };
                };
            };
        }

        public function resetRecursiveProperty():*
        {
            this.itemLoading = (this.currentPage * 9);
            if (this.selectedCategory.length < this.itemLoading)
            {
                this.itemLoading = this.selectedCategory.length;
            };
            this.itemIndex = ((this.currentPage - 1) * 9);
            this.itemCount = 0;
        }

        public function resetIconHolder():*
        {
            this.itemEquipMC = [];
            this.backHairMC = [];
            this.skirtMC = [];
            var _local_1:* = 0;
            while (_local_1 < 9)
            {
                GF.removeAllChild(this.panelMC[("item_" + _local_1)].iconMc.iconHolder);
                this.color.brightness = -0.3;
                this.panelMC[("item_" + _local_1)].transform.colorTransform = this.color;
                this.panelMC[("item_" + _local_1)].gotoAndStop(1);
                this.panelMC[("item_" + _local_1)].visible = false;
                this.panelMC[("item_" + _local_1)].btn_equip.visible = false;
                this.panelMC[("item_" + _local_1)].btn_use.visible = false;
                this.panelMC[("item_" + _local_1)].lockMc.visible = true;
                this.panelMC[("item_" + _local_1)].emblemMC.visible = false;
                this.panelMC[("item_" + _local_1)].amtTxt.visible = false;
                this.panelMC[("item_" + _local_1)].txt_equipped.visible = false;
                this.panelMC[("item_" + _local_1)].clickmask.tooltip = null;
                this.panelMC[("item_" + _local_1)].btn_use.metaData = {};
                this.panelMC[("item_" + _local_1)].btn_equip.metaData = {};
                this.eventHandler.removeListener(this.panelMC[("item_" + _local_1)].clickmask, MouseEvent.MOUSE_OVER, this.toolTiponOver);
                this.eventHandler.removeListener(this.panelMC[("item_" + _local_1)].clickmask, MouseEvent.MOUSE_OUT, this.toolTiponOut);
                this.eventHandler.removeListener(this.panelMC[("item_" + _local_1)].clickmask, MouseEvent.CLICK, this.previewItem);
                this.eventHandler.removeListener(this.panelMC[("item_" + _local_1)].btn_equip, MouseEvent.CLICK, this.equipItem);
                this.eventHandler.removeListener(this.panelMC[("item_" + _local_1)].btn_use, MouseEvent.CLICK, this.useItem);
                _local_1++;
            };
        }

        public function removeChildsFromMovieClip(_arg_1:MovieClip):*
        {
            while (_arg_1.numChildren > 0)
            {
                _arg_1.removeChildAt(0);
            };
        }

        public function getAssetPath(_arg_1:String):String
        {
            var _local_2:String;
            var _local_3:String = _arg_1.split("_")[0];
            if (_local_3 == "material")
            {
                _local_2 = "materials";
            }
            else
            {
                if (_local_3 == "essential")
                {
                    _local_2 = "essentials";
                }
                else
                {
                    if (_local_3 == "item")
                    {
                        _local_2 = "consumables";
                    }
                    else
                    {
                        _local_2 = "items";
                    };
                };
            };
            return (_local_2);
        }

        public function hoverOver(_arg_1:Event):*
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        public function hoverOut(_arg_1:Event):*
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
        }

        public function toolTiponOver(_arg_1:MouseEvent):*
        {
            _arg_1.currentTarget.parent.gotoAndStop(2);
            var _local_2:* = "";
            switch (_arg_1.currentTarget.item_type)
            {
                case "skill":
                    _local_2 = (((((((((((("" + _arg_1.currentTarget.tooltip.skill_name) + "\n(Skill)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.skill_level) + "\nDamage: ") + _arg_1.currentTarget.tooltip.skill_damage) + "\nCP Cost: ") + _arg_1.currentTarget.tooltip.skill_cp_cost) + "\nCooldown: ") + _arg_1.currentTarget.tooltip.skill_cooldown) + "\n\n") + _arg_1.currentTarget.tooltip.skill_description);
                    break;
                case "wpn":
                    _local_2 = (((((((("" + _arg_1.currentTarget.tooltip.item_name) + "\n(Weapon)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.item_level) + '\n<font color="#ff0000">Damage: ') + _arg_1.currentTarget.tooltip.item_damage) + "</font>\n\n") + _arg_1.currentTarget.tooltip.item_description);
                    break;
                case "back":
                    _local_2 = (((((("" + _arg_1.currentTarget.tooltip.item_name) + "\n(Back Item)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.item_level) + "\n\n") + _arg_1.currentTarget.tooltip.item_description);
                    break;
                case "set":
                    _local_2 = (((((("" + _arg_1.currentTarget.tooltip.item_name) + "\n(Clothes)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.item_level) + "\n\n") + _arg_1.currentTarget.tooltip.item_description);
                    break;
                case "hair":
                    _local_2 = (((((("" + _arg_1.currentTarget.tooltip.item_name) + "\n(Hairstyle)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.item_level) + "\n\n") + _arg_1.currentTarget.tooltip.item_description);
                    break;
                case "accessory":
                    _local_2 = (((((("" + _arg_1.currentTarget.tooltip.item_name) + "\n(Accessories)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.item_level) + "\n\n") + _arg_1.currentTarget.tooltip.item_description);
                    break;
                case "material":
                    _local_2 = (((((("" + _arg_1.currentTarget.tooltip.item_name) + "\n(Material)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.item_level) + "\n\n") + _arg_1.currentTarget.tooltip.item_description);
                    break;
                case "essential":
                    _local_2 = (((((("" + _arg_1.currentTarget.tooltip.item_name) + "\n(Essentials)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.item_level) + "\n\n") + _arg_1.currentTarget.tooltip.item_description);
                    break;
                case "item":
                    _local_2 = (((((("" + _arg_1.currentTarget.tooltip.item_name) + "\n(Consumables)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.item_level) + "\n\n") + _arg_1.currentTarget.tooltip.item_description);
                    break;
                case "pet":
                    _local_2 = (((((("" + _arg_1.currentTarget.tooltip.pet_name) + "\n(Pet)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.pet_level) + "\n\n") + _arg_1.currentTarget.tooltip.description);
                    break;
                case "tokens":
                    _local_2 = (("(Token)\n" + _arg_1.currentTarget.tooltip) + " Tokens");
                    break;
                case "gold":
                    _local_2 = (("(Gold)\n" + _arg_1.currentTarget.tooltip) + " Gold");
                    break;
                case "tp":
                    _local_2 = (("(TP)\n" + _arg_1.currentTarget.tooltip) + " TP");
                    break;
                case "xp":
                    _local_2 = (("(XP)\n" + _arg_1.currentTarget.tooltip) + " XP");
            };
            this.main.stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_2);
        }

        public function toolTiponOut(_arg_1:MouseEvent):*
        {
            _arg_1.currentTarget.parent.gotoAndStop(1);
            this.tooltip.hide();
        }

        public function sortItems(_arg_1:Array):*
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            var _local_5:* = null;
            var _local_6:* = 0;
            if (_arg_1.length == 1)
            {
                return (_arg_1);
            };
            if (((PresetData.preset_back == "back_00") || (PresetData.preset_acc == "accessory_00")))
            {
                if ((((_local_2 = _arg_1[_local_6].split("_"))[0] == "back") || (_local_2[0] == "accessory")))
                {
                    return (_arg_1);
                };
            };
            while (_local_6 < _arg_1.length)
            {
                if (((((((_local_4 = (_local_3 = _arg_1[_local_6].split(":"))[0]) == PresetData.preset_wpn) || (_local_4 == PresetData.preset_back)) || (_local_4 == PresetData.preset_acc)) || (_local_4 == PresetData.preset_set)) || (_local_4 == PresetData.preset_hair)))
                {
                    _local_5 = _arg_1[_local_6];
                };
                _local_6++;
            };
            var _local_7:Array = ((_local_5 != null) ? [_local_5] : [_arg_1[0]]);
            _local_6 = 0;
            var _local_8:* = 1;
            while (_local_6 < _arg_1.length)
            {
                if (_local_7[0] != _arg_1[_local_6])
                {
                    _local_7[_local_8] = _arg_1[_local_6];
                    _local_8++;
                };
                _local_6++;
            };
            return (_local_7);
        }

        public function savePreset(_arg_1:MouseEvent):void
        {
            if (_arg_1 != null)
            {
                this.savedWithButton = _arg_1.currentTarget.name;
            };
            this.main.loading(true);
            var _local_2:Array = [Character.char_id, Character.sessionkey, PresetData.preset_id_edit, this.panelMC.txt_presetName.text, PresetData.preset_wpn, PresetData.preset_set, PresetData.preset_hair, PresetData.preset_back, PresetData.preset_acc, PresetData.preset_hair_color, PresetData.preset_skill, PresetData.preset_pet_id];
            this.main.amf_manager.service("ShadowWar.executeService", ["savePreset", _local_2], this.onPresetSaved);
        }

        private function onPresetSaved(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.preset_selection_parent.getData();
                PresetData.selected_preset_name = this.panelMC.txt_presetName.text;
                if (this.savedWithButton == "btn_close")
                {
                    this.destroy();
                    return;
                };
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

        public function usePreset(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("ShadowWar.executeService", ["usePreset", [Character.char_id, Character.sessionkey, PresetData.preset_id_edit]], this.onPresetUsed);
        }

        private function onPresetUsed(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.panelMC.btn_use.visible = false;
                this.preset_selection_parent.getData();
                PresetData.preset_id_used = PresetData.preset_id_edit;
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

        public function closePanel(_arg_1:MouseEvent):*
        {
            this.savedWithButton = _arg_1.currentTarget.name;
            this.savePreset(null);
        }

        public function removeCharMCItems(_arg_1:*):*
        {
            if (((!(_arg_1)) || (_arg_1 == null)))
            {
                return;
            };
            if (_arg_1.hasOwnProperty("weapon"))
            {
                GF.removeAllChild(_arg_1.weapon);
            };
            if (_arg_1.hasOwnProperty("back"))
            {
                GF.removeAllChild(_arg_1.back);
            };
            if (_arg_1.hasOwnProperty("skirt"))
            {
                GF.removeAllChild(_arg_1.skirt);
            };
            if (_arg_1.hasOwnProperty("head"))
            {
                if (_arg_1["head"].hasOwnProperty("hair"))
                {
                    GF.removeAllChild(_arg_1.head.hair);
                };
                if (_arg_1["head"].hasOwnProperty("face"))
                {
                    GF.removeAllChild(_arg_1.head.face);
                };
            };
            if (_arg_1.hasOwnProperty("back_hair"))
            {
                GF.removeAllChild(_arg_1.back_hair);
            };
        }

        public function destroy():*
        {
            var _local_1:* = 0;
            while (_local_1 < 9)
            {
                GF.removeAllChild(this.panelMC[("item_" + _local_1)].iconMc.iconHolder);
                this.panelMC[("item_" + _local_1)].clickmask.tooltip = null;
                this.panelMC[("item_" + _local_1)].btn_use.metaData = {};
                this.panelMC[("item_" + _local_1)].btn_equip.metaData = {};
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.tabButton.length)
            {
                this.panelMC[this.tabButton[_local_1]].buttonMode = false;
                _local_1++;
            };
            GF.destroyArray(this.outfits);
            this.firstLoad = true;
            this.eventHandler.removeAllEventListeners();
            this.tooltip.destroy();
            NinjaSage.clearLoader();
            this.loaderSwf.clear();
            OutfitManager.clearStaticMc();
            BulkLoader.getLoader("assets").removeAll();
            this.weaponArray = [];
            this.backArray = [];
            this.accArray = [];
            this.setArray = [];
            this.hairArray = [];
            this.materialArray = [];
            this.essentialArray = [];
            this.consumableArray = [];
            this.selectedCategory = [];
            this.outfits = [];
            this.itemEquipMC = [];
            this.backHairMC = [];
            this.skirtMC = [];
            this.currentPage = 1;
            this.totalPage = 1;
            this.presetTarget = 0;
            this.preset_total_page = 0;
            this.preset_curr_page = 1;
            this.savedWithButton = null;
            this.confirmation = null;
            this.selectedHairColor = null;
            this.selectedSkinColor = null;
            this.selectedHairMC = null;
            this.selectedBackHairMC = null;
            this.selectedSetMC = null;
            this.loaderSwf = null;
            this.tabIndicator = null;
            this.equippedItem = null;
            this.color = null;
            this.eventHandler = null;
            this.tooltip = null;
            this.main = null;
            this.pet_inventoryMC = null;
            this.skill_inventoryMC = null;
            this.removeCharMCItems(this.panelMC.char_mc);
            this.panelMC.visible = false;
            System.gc();
        }


    }
}//package id.ninjasage.features

