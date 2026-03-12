// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.BaseShop

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import com.abrahamyan.liquid.ToolTip;
    import br.com.stimuli.loading.BulkLoader;
    import fl.motion.Color;
    import Popups.Confirmation;
    import Storage.GameData;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.OutfitManager;
    import flash.events.ErrorEvent;
    import Storage.SkillLibrary;
    import Storage.Library;
    import flash.events.Event;
    import com.utils.GF;
    import Popups.ItemBuyConfirmation;
    import Managers.NinjaSage;
    import flash.geom.ColorTransform;
    import flash.system.System;

    public dynamic class BaseShop extends MovieClip 
    {

        public static var hairMC:MovieClip;
        public static var backHairMC:MovieClip;

        public var weaponArray:Array;
        public var backArray:Array;
        public var accArray:Array;
        public var setArray:Array;
        public var hairArray:Array;
        public var essentialArray:Array;
        public var consumableArray:Array;
        public var skillArray:Array;
        public var selectedCategory:Array;
        public var presets:Array;
        public var currentPage:int = 1;
        public var totalPage:int = 1;
        public var itemIndex:int = 0;
        public var itemLoading:int = 0;
        public var itemCount:int = 0;
        public var buyQuantity:int = 1;
        public var tabIndicator:String = "weapon";
        public var selectedHairColor:String;
        public var selectedSkinColor:String;
        public var shopType:String;
        public var selectedBuyitem:Object;
        public var selectedHairMC:MovieClip;
        public var selectedBackHairMC:MovieClip;
        public var isLoading:Boolean;
        public var tempWeaponMC:MovieClip;
        public var tempBackItemMC:MovieClip;
        public var tempHairMC:MovieClip;
        public var tempBackHairMC:MovieClip;
        public var tempSetMC:MovieClip;
        public var tempSkirtMC:MovieClip;
        public var buyPanel:MovieClip;
        public var eventHandler:EventHandler;
        public var tooltip:ToolTip;
        public var main:*;
        public var loaderSwf:BulkLoader;
        public var color:Color;
        public var confirmation:Confirmation;

        public var outfits:Array = [];
        public var iconMCArray:Array = [];
        public var itemEquipMC:Array = [];
        public var backHairMC:Array = [];
        public var skirtMC:Array = [];
        public var selectedSetMC:Array = [];
        public var tempSetArray:Array = [];
        public const tabButton:Array = ["mcWeapon", "mcSet", "mcBackItem", "mcAccessory", "mcHairstyle", "mcItems", "mcEssentials", "mcSkill"];
        public const bodyArray:Array = ["upper_body", "lower_body", "left_upper_arm", "left_lower_arm", "left_hand", "left_upper_leg", "left_lower_leg", "left_shoe", "right_upper_arm", "right_lower_arm", "right_hand", "right_upper_leg", "right_lower_leg", "right_shoe"];

        public function BaseShop(_arg_1:*)
        {
            this.main = _arg_1;
            this.eventHandler = new EventHandler();
            this.tooltip = ToolTip.getInstance();
            this.loaderSwf = BulkLoader.createUniqueNamedLoader(10);
            this.color = new Color();
            this.main.handleVillageHUDVisibility(false);
        }

        public function initShopData(_arg_1:String):void
        {
            this.shopType = _arg_1;
            var _local_2:* = GameData.get("shop");
            this.weaponArray = _local_2[this.shopType].weapons;
            this.backArray = _local_2[this.shopType].backs;
            this.accArray = _local_2[this.shopType].accs;
            this.consumableArray = _local_2[this.shopType].items;
            this.essentialArray = _local_2[this.shopType].essentials;
            this.skillArray = _local_2[this.shopType].skills;
            this.hairArray = [];
            this.setArray = [];
            var _local_3:int;
            while (_local_3 < _local_2[this.shopType].hairs.length)
            {
                this.hairArray.push(_local_2[this.shopType].hairs[_local_3].replace("%s", Character.character_gender));
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < _local_2[this.shopType].sets.length)
            {
                this.setArray.push(_local_2[this.shopType].sets[_local_3].replace("%s", Character.character_gender));
                _local_3++;
            };
            this.initButton();
            this.initUI();
        }

        public function initButton():void
        {
            var openMenu:String;
            var i:* = 0;
            while (i < this.tabButton.length)
            {
                this[this.tabButton[i]].gotoAndStop(1);
                this[this.tabButton[i]].buttonMode = true;
                this.eventHandler.addListener(this[this.tabButton[i]], MouseEvent.CLICK, this.changeCategory);
                this.eventHandler.addListener(this[this.tabButton[i]], MouseEvent.MOUSE_OVER, this.hoverOver);
                this.eventHandler.addListener(this[this.tabButton[i]], MouseEvent.MOUSE_OUT, this.hoverOut);
                i++;
            };
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.btn_clear, MouseEvent.CLICK, this.clearPreview);
            this.eventHandler.addListener(this.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.buyGold, MouseEvent.CLICK, this.openRecharge);
            switch (this.shopType)
            {
                case "clan":
                    openMenu = LinkMenu.ClanWar;
                    break;
                case "pvp":
                    openMenu = LinkMenu.PvP;
                    break;
                case "crew":
                    openMenu = LinkMenu.CrewWar;
                    break;
                default:
                    openMenu = null;
            };
            this.eventHandler.addListener(this.currencyType.getMore, MouseEvent.CLICK, function (_arg_1:MouseEvent):*
            {
                if (openMenu)
                {
                    LinkMenu.open(openMenu);
                    destroy();
                }
                else
                {
                    main.loadPanel("Panels.Recharge");
                };
            });
        }

        public function initUI():void
        {
            var _local_1:*;
            if (!Character.is_stickman)
            {
                _local_1 = new OutfitManager();
                _local_1.fillOutfit(this.char_mc, Character.character_weapon, Character.character_back_item, Character.character_set, Character.character_hair, Character.character_face, Character.character_color_hair, Character.character_color_skin);
                this.outfits.push(_local_1);
            };
            this.updatePlayerCurrency();
            this.selectedHairColor = Character.character_color_hair;
            this.selectedSkinColor = Character.character_color_skin;
            this.popup.visible = false;
            this.mcWeapon.gotoAndStop(3);
            this.tabIndicator = "weapon";
            this.selectedCategory = this.weaponArray;
            this.totalPage = Math.max(Math.ceil((this.selectedCategory.length / 15)), 1);
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.loadSwf();
        }

        public function updatePlayerCurrency():void
        {
            this.txt_gold.text = Character.character_gold;
            this.currencyType.gotoAndStop(this.getCurrencyType(this.shopType));
            this.currencyType.txt.text = this.getPlayerCurrency(this.shopType);
        }

        public function loadSwf():void
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            this.isLoading = true;
            if (this.itemIndex < this.itemLoading)
            {
                _local_1 = this.selectedCategory[this.itemIndex];
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

        public function completeIcon(_arg_1:Event):void
        {
            var _local_6:MovieClip;
            var _local_7:Array;
            var _local_8:*;
            var _local_9:MovieClip;
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.ERROR, this.onItemLoadError);
            var _local_3:MovieClip;
            _local_3 = _arg_1.target.content.icon;
            if (!Character.play_items_animation)
            {
                _local_3.stopAllMovieClips();
            };
            this.iconMCArray.push(_local_3);
            this[("item_" + this.itemCount)].visible = true;
            this[("item_" + this.itemCount)].gotoAndStop(1);
            var _local_4:* = this.selectedCategory[this.itemIndex];
            var _local_5:Object = {};
            if (this.selectedCategory[this.itemIndex].indexOf("skill") > -1)
            {
                _local_5 = SkillLibrary.getSkillInfo(_local_4);
                _local_5.item_id = _local_5.skill_id;
                _local_5.item_level = _local_5.skill_level;
                _local_5.item_name = _local_5.skill_name;
                _local_5.item_price_gold = _local_5.skill_price_gold;
                _local_5.item_price_token = _local_5.skill_price_tokens;
                this[("item_" + this.itemCount)].iconMc.visible = false;
                this[("item_" + this.itemCount)].skillIcon.visible = true;
                this[("item_" + this.itemCount)].skillIcon.iconHolder.addChild(_local_3);
            }
            else
            {
                _local_5 = Library.getItemInfo(_local_4);
                this[("item_" + this.itemCount)].iconMc.visible = true;
                this[("item_" + this.itemCount)].skillIcon.visible = false;
                this[("item_" + this.itemCount)].iconMc.iconHolder.addChild(_local_3);
            };
            if (this.tabIndicator == "weapon")
            {
                _local_3 = _arg_1.target.content.weapon;
                if (!Character.play_items_animation)
                {
                    _local_3.stopAllMovieClips();
                };
                this.itemEquipMC.push(_local_3);
            }
            else
            {
                if (this.tabIndicator == "back")
                {
                    _local_3 = _arg_1.target.content.back_item;
                    if (!Character.play_items_animation)
                    {
                        _local_3.stopAllMovieClips();
                    };
                    this.itemEquipMC.push(_local_3);
                }
                else
                {
                    if (this.tabIndicator == "hair")
                    {
                        _local_3 = _arg_1.target.content.hair;
                        if (!Character.play_items_animation)
                        {
                            _local_3.stopAllMovieClips();
                        };
                        this.itemEquipMC.push(_local_3);
                        try
                        {
                            _local_6 = _arg_1.target.content.back_hair;
                            if (!Character.play_items_animation)
                            {
                                _local_6.stopAllMovieClips();
                            };
                            this.backHairMC.push(_local_6);
                        }
                        catch(error)
                        {
                        };
                    }
                    else
                    {
                        if (this.tabIndicator == "set")
                        {
                            _local_7 = [];
                            _local_8 = 0;
                            while (_local_8 < this.bodyArray.length)
                            {
                                _local_3 = _arg_1.target.content[this.bodyArray[_local_8]];
                                if (!Character.play_items_animation)
                                {
                                    _local_3.stopAllMovieClips();
                                };
                                _local_7.push(_local_3);
                                _local_8++;
                            };
                            try
                            {
                                _local_9 = _arg_1.target.content.skirt;
                                if (!Character.play_items_animation)
                                {
                                    _local_9.stopAllMovieClips();
                                };
                                this.skirtMC.push(_local_9);
                            }
                            catch(error)
                            {
                            };
                            this.itemEquipMC.push(_local_7);
                        };
                    };
                };
            };
            this[("item_" + this.itemCount)].lvlTxt.text = _local_5.item_level;
            if (Character.hasSkill(_local_5.item_id) > 0)
            {
                this[("item_" + this.itemCount)].amtTxt.visible = true;
                this[("item_" + this.itemCount)].amtTxt.text = "Owned";
            };
            if (Character.isItemOwned(_local_5.item_id) > 0)
            {
                this[("item_" + this.itemCount)].amtTxt.visible = true;
                this[("item_" + this.itemCount)].amtTxt.text = "Owned";
            };
            if (_local_5.item_premium)
            {
                this[("item_" + this.itemCount)].emblemMC.visible = true;
            };
            this[("item_" + this.itemCount)].clickMask.tooltip = _local_5;
            this[("item_" + this.itemCount)].clickMask.item_type = _local_4.split("_")[0];
            this[("item_" + this.itemCount)].clickMask.metaData = {"id":_local_4};
            this.eventHandler.addListener(this[("item_" + this.itemCount)].clickMask, MouseEvent.MOUSE_OVER, this.toolTiponOver);
            this.eventHandler.addListener(this[("item_" + this.itemCount)].clickMask, MouseEvent.MOUSE_OUT, this.toolTiponOut);
            this.eventHandler.addListener(this[("item_" + this.itemCount)].clickMask, MouseEvent.CLICK, this.loadItem);
            if (_local_5.item_price_merit > 0)
            {
                _local_5.buy_price = _local_5.item_price_merit;
                _local_5.buy_type = "merit";
                this[("item_" + this.itemCount)].btn_buy_merit.visible = true;
                this[("item_" + this.itemCount)].btn_buy_merit.buttonMode = true;
                this[("item_" + this.itemCount)].btn_buy_merit.txt_price.text = _local_5.item_price_merit;
                this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_merit, MouseEvent.MOUSE_OVER, this.hoverOver);
                this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_merit, MouseEvent.MOUSE_OUT, this.hoverOut);
                this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_merit, MouseEvent.CLICK, this.openBuyConfirmation);
                this[("item_" + this.itemCount)].btn_buy_merit.metaData = {"item_info":_local_5};
            }
            else
            {
                if (_local_5.item_price_prestige > 0)
                {
                    _local_5.buy_price = _local_5.item_price_prestige;
                    _local_5.buy_type = "prestige";
                    this[("item_" + this.itemCount)].btn_buy_prestige.visible = true;
                    this[("item_" + this.itemCount)].btn_buy_prestige.buttonMode = true;
                    this[("item_" + this.itemCount)].btn_buy_prestige.txt_price.text = _local_5.item_price_prestige;
                    this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_prestige, MouseEvent.MOUSE_OVER, this.hoverOver);
                    this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_prestige, MouseEvent.MOUSE_OUT, this.hoverOut);
                    this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_prestige, MouseEvent.CLICK, this.openBuyConfirmation);
                    this[("item_" + this.itemCount)].btn_buy_prestige.metaData = {"item_info":_local_5};
                }
                else
                {
                    if (_local_5.item_price_pvp > 0)
                    {
                        _local_5.buy_price = _local_5.item_price_pvp;
                        _local_5.buy_type = "pvp";
                        this[("item_" + this.itemCount)].btn_buy_pvp.visible = true;
                        this[("item_" + this.itemCount)].btn_buy_pvp.buttonMode = true;
                        this[("item_" + this.itemCount)].btn_buy_pvp.txt_price.text = _local_5.item_price_pvp;
                        this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_pvp, MouseEvent.MOUSE_OVER, this.hoverOver);
                        this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_pvp, MouseEvent.MOUSE_OUT, this.hoverOut);
                        this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_pvp, MouseEvent.CLICK, this.openBuyConfirmation);
                        this[("item_" + this.itemCount)].btn_buy_pvp.metaData = {"item_info":_local_5};
                    }
                    else
                    {
                        if (_local_5.item_price_tokens > 0)
                        {
                            _local_5.buy_price = _local_5.item_price_tokens;
                            _local_5.buy_type = "token";
                            this[("item_" + this.itemCount)].btn_buy_token.visible = true;
                            this[("item_" + this.itemCount)].btn_buy_token.buttonMode = true;
                            this[("item_" + this.itemCount)].btn_buy_token.txt_price.text = _local_5.item_price_tokens;
                            this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_token, MouseEvent.MOUSE_OVER, this.hoverOver);
                            this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_token, MouseEvent.MOUSE_OUT, this.hoverOut);
                            this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_token, MouseEvent.CLICK, this.openBuyConfirmation);
                            this[("item_" + this.itemCount)].btn_buy_token.metaData = {"item_info":_local_5};
                        }
                        else
                        {
                            if (_local_5.item_price_gold > 0)
                            {
                                _local_5.buy_price = _local_5.item_price_gold;
                                _local_5.buy_type = "gold";
                                this[("item_" + this.itemCount)].btn_buy_gold.visible = true;
                                this[("item_" + this.itemCount)].btn_buy_gold.buttonMode = true;
                                this[("item_" + this.itemCount)].btn_buy_gold.txt_price.text = _local_5.item_price_gold;
                                this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_gold, MouseEvent.MOUSE_OVER, this.hoverOver);
                                this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_gold, MouseEvent.MOUSE_OUT, this.hoverOut);
                                this.eventHandler.addListener(this[("item_" + this.itemCount)].btn_buy_gold, MouseEvent.CLICK, this.openBuyConfirmation);
                                this[("item_" + this.itemCount)].btn_buy_gold.metaData = {"item_info":_local_5};
                            };
                        };
                    };
                };
            };
            if ((((_local_5.item_id.indexOf("material") >= 0) || (_local_5.item_id.indexOf("essential") >= 0)) || (_local_5.item_id.indexOf("item") >= 0)))
            {
                this.eventHandler.removeListener(this[("item_" + this.itemCount)].clickMask, MouseEvent.CLICK, this.loadItem);
            };
            this.itemIndex++;
            this.itemCount++;
            this.loadSwf();
        }

        public function loadItem(_arg_1:MouseEvent):void
        {
            var _local_2:String = _arg_1.currentTarget.metaData.id;
            var _local_3:* = (("items/" + _local_2) + ".swf");
            var _local_4:* = this.loaderSwf.add(_local_3);
            _local_4.addEventListener(BulkLoader.COMPLETE, this.previewItem);
            this.loaderSwf.start();
        }

        public function previewItem(_arg_1:Event):void
        {
            var _local_2:*;
            if (this.tabIndicator == "weapon")
            {
                this.removeChildsFromMovieClip(this.char_mc["weapon"]);
                if (this.tempWeaponMC != null)
                {
                    this.tempWeaponMC.stopAllMovieClips();
                };
                GF.removeAllChild(this.tempWeaponMC);
                this.tempWeaponMC = null;
                this.tempWeaponMC = _arg_1.target.content.weapon;
                this.char_mc["weapon"].addChild(this.tempWeaponMC);
            }
            else
            {
                if (this.tabIndicator == "back")
                {
                    this.removeChildsFromMovieClip(this.char_mc["back"]);
                    if (this.tempBackItemMC != null)
                    {
                        this.tempBackItemMC.stopAllMovieClips();
                    };
                    GF.removeAllChild(this.tempBackItemMC);
                    this.tempBackItemMC = null;
                    this.tempBackItemMC = _arg_1.target.content.back_item;
                    this.char_mc["back"].addChild(this.tempBackItemMC);
                }
                else
                {
                    if (this.tabIndicator == "hair")
                    {
                        this.removeChildsFromMovieClip(this.char_mc.head["hair"]);
                        if (this.tempHairMC != null)
                        {
                            this.tempHairMC.stopAllMovieClips();
                        };
                        GF.removeAllChild(this.tempHairMC);
                        this.tempHairMC = null;
                        this.tempHairMC = _arg_1.target.content.hair;
                        this.selectedHairMC = this.tempHairMC;
                        this.addHairColor(this.tempHairMC);
                        this.char_mc.head["hair"].addChild(this.tempHairMC);
                        try
                        {
                            this.removeChildsFromMovieClip(this.char_mc["back_hair"]);
                            if (this.tempBackHairMC != null)
                            {
                                this.tempBackHairMC.stopAllMovieClips();
                            };
                            GF.removeAllChild(this.tempBackHairMC);
                            this.tempBackHairMC = null;
                            this.tempBackHairMC = _arg_1.target.content.back_hair;
                            this.selectedBackHairMC = this.tempBackHairMC;
                            this.addHairColor(this.tempBackHairMC);
                            this.char_mc["back_hair"].addChild(this.tempBackHairMC);
                        }
                        catch(error:Error)
                        {
                        };
                    }
                    else
                    {
                        if (this.tabIndicator == "set")
                        {
                            _local_2 = 0;
                            while (_local_2 < this.selectedSetMC.length)
                            {
                                if (this.selectedSetMC[_local_2] != null)
                                {
                                    this.selectedSetMC[_local_2].stopAllMovieClips();
                                };
                                GF.removeAllChild(this.selectedSetMC[_local_2]);
                                _local_2++;
                            };
                            this.selectedSetMC = [];
                            _local_2 = 0;
                            while (_local_2 < this.tempSetArray.length)
                            {
                                if (this.tempSetArray[_local_2] != null)
                                {
                                    this.tempSetArray[_local_2].stopAllMovieClips();
                                };
                                GF.removeAllChild(this.tempSetArray[_local_2]);
                                _local_2++;
                            };
                            this.tempSetArray = [];
                            _local_2 = 0;
                            while (_local_2 < this.bodyArray.length)
                            {
                                this.tempSetMC = _arg_1.target.content[this.bodyArray[_local_2]];
                                this.tempSetArray.push(this.tempSetMC);
                                _local_2++;
                            };
                            _local_2 = 0;
                            while (_local_2 < this.bodyArray.length)
                            {
                                this.removeChildsFromMovieClip(this.char_mc[this.bodyArray[_local_2]]);
                                this.selectedSetMC.push(this.tempSetArray[_local_2]);
                                this.addSkinColor(this.tempSetArray[_local_2]);
                                this.char_mc[this.bodyArray[_local_2]].addChild(this.tempSetArray[_local_2]);
                                try
                                {
                                    this.removeChildsFromMovieClip(this.char_mc["skirt"]);
                                    if (this.tempSkirtMC != null)
                                    {
                                        this.tempSkirtMC.stopAllMovieClips();
                                    };
                                    GF.removeAllChild(this.tempSkirtMC);
                                    this.tempSkirtMC = null;
                                    this.tempSkirtMC = _arg_1.target.content.skirt;
                                    this.selectedBackHairMC = this.tempSkirtMC;
                                    this.char_mc["skirt"].addChild(this.tempSkirtMC);
                                }
                                catch(error:Error)
                                {
                                };
                                _local_2++;
                            };
                        };
                    };
                };
            };
        }

        public function openBuyConfirmation(_arg_1:MouseEvent):void
        {
            var _local_3:MovieClip;
            var _local_2:* = _arg_1.currentTarget.metaData;
            this.selectedBuyitem = _local_2.item_info;
            this.buyPanel = new ItemBuyConfirmation();
            this.buyPanel.btn_sell.visible = false;
            this.eventHandler.addListener(this.buyPanel.btn_buy, MouseEvent.CLICK, this.buyItemAmf);
            this.eventHandler.addListener(this.buyPanel.btn_prev, MouseEvent.CLICK, this.onChangeQuantity);
            this.eventHandler.addListener(this.buyPanel.btn_prev_10, MouseEvent.CLICK, this.onChangeQuantity);
            this.eventHandler.addListener(this.buyPanel.btn_next, MouseEvent.CLICK, this.onChangeQuantity);
            this.eventHandler.addListener(this.buyPanel.btn_next_10, MouseEvent.CLICK, this.onChangeQuantity);
            this.eventHandler.addListener(this.buyPanel.btn_close, MouseEvent.CLICK, this.onCloseConfItem);
            this.buyPanel.item.lvlTxt.text = this.selectedBuyitem["item_level"];
            this.buyPanel.item.gotoAndStop(1);
            this.buyPanel.currencyIcon.gotoAndStop(this.selectedBuyitem.buy_type);
            this.buyPanel.desctxt.text = (("Confirm buying " + this.selectedBuyitem["item_name"]) + "?");
            this.buyPanel.txt_quality.text = this.buyQuantity;
            this.buyPanel.txt_gold.text = String((this.buyQuantity * this.selectedBuyitem.buy_price));
            GF.removeAllChild(this.buyPanel.item.iconMc.iconHolder);
            GF.removeAllChild(this.buyPanel.item.skillIcon.iconHolder);
            this.buyPanel.item.iconMc.visible = false;
            this.buyPanel.item.skillIcon.visible = false;
            if (this.selectedBuyitem.item_id.indexOf("skill") > -1)
            {
                this.buyPanel.item.skillIcon.visible = true;
                _local_3 = this.buyPanel.item.skillIcon.iconHolder;
            }
            else
            {
                this.buyPanel.item.iconMc.visible = true;
                _local_3 = this.buyPanel.item.iconMc.iconHolder;
            };
            NinjaSage.loadItemIcon(_local_3, this.selectedBuyitem.item_id, "icon");
            this.main.loader.addChild(this.buyPanel);
        }

        public function onChangeQuantity(_arg_1:MouseEvent):void
        {
            if (this.selectedBuyitem.item_id.indexOf("skill") > -1)
            {
                return;
            };
            switch (_arg_1.currentTarget.name)
            {
                case "btn_prev":
                    if (this.buyQuantity > 1)
                    {
                        this.buyQuantity--;
                        break;
                    };
                    break;
                case "btn_prev_10":
                    if (this.buyQuantity > 10)
                    {
                        this.buyQuantity = (this.buyQuantity - 10);
                        break;
                    };
                    this.buyQuantity = 1;
                    break;
                case "btn_next":
                    if (this.buyQuantity < 100)
                    {
                        this.buyQuantity++;
                        break;
                    };
                    break;
                case "btn_next_10":
                    if (this.buyQuantity < 100)
                    {
                        this.buyQuantity = (this.buyQuantity + 10);
                        break;
                    };
            };
            if (this.buyQuantity > 100)
            {
                this.buyQuantity = 100;
            };
            this.buyPanel.txt_quality.text = this.buyQuantity;
            this.buyPanel.txt_gold.text = String((this.buyQuantity * this.selectedBuyitem.buy_price));
        }

        public function buyItemAmf(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.buyItem", [Character.char_id, Character.sessionkey, this.selectedBuyitem.item_id, this.buyQuantity], this.buyResponse);
        }

        public function buyResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage((((this.buyQuantity + " ") + this.selectedBuyitem.item_name) + " succesfully bought!"));
                if (this.selectedBuyitem.buy_type == "gold")
                {
                    Character.character_gold = String((Number(Character.character_gold) - this.selectedBuyitem.buy_price));
                }
                else
                {
                    if (this.selectedBuyitem.buy_type == "prestige")
                    {
                        Character.character_prestige = String((Number(Character.character_prestige) - this.selectedBuyitem.buy_price));
                    }
                    else
                    {
                        if (this.selectedBuyitem.buy_type == "token")
                        {
                            Character.account_tokens = (Character.account_tokens - this.selectedBuyitem.buy_price);
                        }
                        else
                        {
                            if (this.selectedBuyitem.buy_type == "pvp")
                            {
                                Character.character_pvp_point = (Character.character_pvp_point - this.selectedBuyitem.buy_price);
                            }
                            else
                            {
                                if (this.selectedBuyitem.buy_type == "merit")
                                {
                                    Character.character_merit = (Character.character_merit - this.selectedBuyitem.buy_price);
                                };
                            };
                        };
                    };
                };
                Character.addRewards(((this.selectedBuyitem.item_id + ":") + this.buyQuantity));
                this.updatePlayerCurrency();
                this.main.HUD.setBasicData();
                this.onCloseConfItem();
                this.resetIconHolder();
                this.resetRecursiveProperty();
                this.updatePageNumber();
                this.loadSwf();
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
            this.buyQuantity = 1;
        }

        public function onCloseConfItem(_arg_1:MouseEvent=null):void
        {
            GF.removeAllChild(this.buyPanel.item.iconMc.iconHolder);
            GF.removeAllChild(this.buyPanel.item.skillIcon.iconHolder);
            GF.removeAllChild(this.buyPanel);
            this.buyQuantity = 1;
            this.buyPanel = null;
        }

        public function clearPreview(_arg_1:MouseEvent):void
        {
            this.removeChildsFromMovieClip(this.char_mc["weapon"]);
            this.removeChildsFromMovieClip(this.char_mc["back"]);
            this.removeChildsFromMovieClip(this.char_mc.head["hair"]);
            this.removeChildsFromMovieClip(this.char_mc["back_hair"]);
            this.removeChildsFromMovieClip(this.char_mc["skirt"]);
            var _local_2:* = 0;
            while (_local_2 < this.bodyArray.length)
            {
                this.removeChildsFromMovieClip(this.char_mc[this.bodyArray[_local_2]]);
                this.char_mc[this.bodyArray[_local_2]].addChild(OutfitManager.set_mc[_local_2]);
                _local_2++;
            };
            try
            {
                this.char_mc["weapon"].addChild(OutfitManager.weapon_mc[0]);
                this.char_mc.head["hair"].addChild(OutfitManager.hair_mc[0]);
                this.char_mc["back_hair"].addChild(OutfitManager.hair_mc[1]);
                this.char_mc["skirt"].addChild(OutfitManager.set_mc[14]);
                this.char_mc["back"].addChild(OutfitManager.back_mc[0]);
            }
            catch(error:Error)
            {
            };
        }

        public function addHairColor(_arg_1:MovieClip):void
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

        public function addSkinColor(_arg_1:MovieClip):void
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

        public function changePage(_arg_1:MouseEvent):void
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
            if (this.loaderSwf.itemsLoaded >= 50)
            {
                this.loaderSwf.removeAll();
            };
            this.loadSwf();
        }

        public function updatePageNumber():void
        {
            this.txt_page.text = ((this.currentPage + "/") + this.totalPage);
        }

        public function changeCategory(_arg_1:MouseEvent):void
        {
            if (this.isLoading)
            {
                return;
            };
            var _local_2:* = 0;
            while (_local_2 < this.tabButton.length)
            {
                this[this.tabButton[_local_2]].gotoAndStop(1);
                _local_2++;
            };
            _arg_1.currentTarget.gotoAndStop(3);
            var _local_3:String = _arg_1.currentTarget.name;
            switch (_local_3)
            {
                case "mcWeapon":
                    this.selectedCategory = this.weaponArray;
                    this.tabIndicator = "weapon";
                    break;
                case "mcSet":
                    this.selectedCategory = this.setArray;
                    this.tabIndicator = "set";
                    break;
                case "mcBackItem":
                    this.selectedCategory = this.backArray;
                    this.tabIndicator = "back";
                    break;
                case "mcAccessory":
                    this.selectedCategory = this.accArray;
                    this.tabIndicator = "accessory";
                    break;
                case "mcEssentials":
                    this.selectedCategory = this.essentialArray;
                    this.tabIndicator = "essential";
                    break;
                case "mcHairstyle":
                    this.selectedCategory = this.hairArray;
                    this.tabIndicator = "hair";
                    break;
                case "mcItems":
                    this.selectedCategory = this.consumableArray;
                    this.tabIndicator = "consumable";
                    break;
                case "mcSkill":
                    this.selectedCategory = this.skillArray;
                    this.tabIndicator = "skill";
                    break;
            };
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.selectedCategory.length / 15)), 1);
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            this.loadSwf();
        }

        public function openRecharge(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Recharge");
        }

        public function resetRecursiveProperty():void
        {
            this.itemLoading = (this.currentPage * 15);
            if (this.selectedCategory.length < this.itemLoading)
            {
                this.itemLoading = this.selectedCategory.length;
            };
            this.itemIndex = ((this.currentPage - 1) * 15);
            this.itemCount = 0;
        }

        public function resetIconHolder():void
        {
            var _local_1:int;
            var _local_2:*;
            _local_1 = 0;
            while (_local_1 < this.itemEquipMC.length)
            {
                if (this.tabIndicator == "set")
                {
                    _local_2 = 0;
                    while (_local_2 < this.bodyArray.length)
                    {
                        if (((!(this.itemEquipMC[_local_1] == null)) && (!(this.itemEquipMC[_local_1][_local_2] == null))))
                        {
                            this.itemEquipMC[_local_1][_local_2].stopAllMovieClips();
                            GF.removeAllChild(this.itemEquipMC[_local_1][_local_2]);
                        };
                        _local_2++;
                    };
                }
                else
                {
                    if ((this.itemEquipMC[_local_1] is Array))
                    {
                        _local_2 = 0;
                        while (_local_2 < this.bodyArray.length)
                        {
                            if (this.itemEquipMC[_local_1][_local_2] != null)
                            {
                                this.itemEquipMC[_local_1][_local_2].stopAllMovieClips();
                            };
                            GF.removeAllChild(this.itemEquipMC[_local_1][_local_2]);
                            _local_2++;
                        };
                    }
                    else
                    {
                        if (this.itemEquipMC[_local_1] != null)
                        {
                            this.itemEquipMC[_local_1].stopAllMovieClips();
                        };
                        GF.removeAllChild(this.itemEquipMC[_local_1]);
                    };
                };
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.backHairMC.length)
            {
                if (this.backHairMC[_local_1] != null)
                {
                    this.backHairMC[_local_1].stopAllMovieClips();
                };
                GF.removeAllChild(this.backHairMC[_local_1]);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.skirtMC.length)
            {
                if (this.skirtMC[_local_1] != null)
                {
                    this.skirtMC[_local_1].stopAllMovieClips();
                };
                GF.removeAllChild(this.skirtMC[_local_1]);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.iconMCArray.length)
            {
                if (this.iconMCArray[_local_1] != null)
                {
                    this.iconMCArray[_local_1].stopAllMovieClips();
                };
                GF.removeAllChild(this.iconMCArray[_local_1]);
                _local_1++;
            };
            this.iconMCArray = [];
            this.itemEquipMC = [];
            this.backHairMC = [];
            this.skirtMC = [];
            _local_1 = 0;
            while (_local_1 < 15)
            {
                GF.removeAllChild(this[("item_" + _local_1)].iconMc.iconHolder);
                this[("item_" + _local_1)].gotoAndStop(1);
                this[("item_" + _local_1)].visible = false;
                this[("item_" + _local_1)].skillIcon.visible = false;
                this[("item_" + _local_1)].lockMc.visible = false;
                this[("item_" + _local_1)].emblemMC.visible = false;
                this[("item_" + _local_1)].amtTxt.visible = false;
                delete this[("item_" + _local_1)].clickMask.tooltip;
                delete this[("item_" + _local_1)].clickMask.tooltipCache;
                this[("item_" + _local_1)].btn_buy_token.gotoAndStop(1);
                this[("item_" + _local_1)].btn_buy_gold.gotoAndStop(1);
                this[("item_" + _local_1)].btn_buy_pvp.gotoAndStop(1);
                this[("item_" + _local_1)].btn_buy_prestige.gotoAndStop(1);
                this[("item_" + _local_1)].btn_buy_merit.gotoAndStop(1);
                this[("item_" + _local_1)].btn_buy_token.visible = false;
                this[("item_" + _local_1)].btn_buy_gold.visible = false;
                this[("item_" + _local_1)].btn_buy_pvp.visible = false;
                this[("item_" + _local_1)].btn_buy_prestige.visible = false;
                this[("item_" + _local_1)].btn_buy_merit.visible = false;
                this[("item_" + _local_1)].btn_buy_token.buttonMode = false;
                this[("item_" + _local_1)].btn_buy_gold.buttonMode = false;
                this[("item_" + _local_1)].btn_buy_pvp.buttonMode = false;
                this[("item_" + _local_1)].btn_buy_prestige.buttonMode = false;
                this[("item_" + _local_1)].btn_buy_merit.buttonMode = false;
                this[("item_" + _local_1)].btn_buy_token.metaData = {};
                this[("item_" + _local_1)].btn_buy_gold.metaData = {};
                this[("item_" + _local_1)].btn_buy_pvp.metaData = {};
                this[("item_" + _local_1)].btn_buy_prestige.metaData = {};
                this[("item_" + _local_1)].btn_buy_merit.metaData = {};
                this.eventHandler.removeListener(this[("item_" + _local_1)].clickMask, MouseEvent.MOUSE_OVER, this.toolTiponOver);
                this.eventHandler.removeListener(this[("item_" + _local_1)].clickMask, MouseEvent.MOUSE_OUT, this.toolTiponOut);
                this.eventHandler.removeListener(this[("item_" + _local_1)].clickMask, MouseEvent.CLICK, this.loadItem);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_token, MouseEvent.MOUSE_OVER, this.hoverOver);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_token, MouseEvent.MOUSE_OUT, this.hoverOut);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_token, MouseEvent.CLICK, this.openBuyConfirmation);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_gold, MouseEvent.MOUSE_OVER, this.hoverOver);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_gold, MouseEvent.MOUSE_OUT, this.hoverOut);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_gold, MouseEvent.CLICK, this.openBuyConfirmation);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_pvp, MouseEvent.MOUSE_OVER, this.hoverOver);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_pvp, MouseEvent.MOUSE_OUT, this.hoverOut);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_pvp, MouseEvent.CLICK, this.openBuyConfirmation);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_prestige, MouseEvent.MOUSE_OVER, this.hoverOver);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_prestige, MouseEvent.MOUSE_OUT, this.hoverOut);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_prestige, MouseEvent.CLICK, this.openBuyConfirmation);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_merit, MouseEvent.MOUSE_OVER, this.hoverOver);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_merit, MouseEvent.MOUSE_OUT, this.hoverOut);
                this.eventHandler.removeListener(this[("item_" + _local_1)].btn_buy_merit, MouseEvent.CLICK, this.openBuyConfirmation);
                _local_1++;
            };
        }

        public function removeChildsFromMovieClip(_arg_1:MovieClip):void
        {
            GF.removeAllChild(_arg_1);
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
                        if (_local_3 == "skill")
                        {
                            _local_2 = "skills";
                        }
                        else
                        {
                            _local_2 = "items";
                        };
                    };
                };
            };
            return (_local_2);
        }

        public function getCurrencyType(_arg_1:String):String
        {
            switch (_arg_1)
            {
                case "normal":
                    return ("token");
                case "clan":
                    return ("prestige");
                case "pvp":
                    return ("pvp");
                case "crew":
                    return ("merit");
                default:
                    return ("gold");
            };
        }

        public function getPlayerCurrency(_arg_1:String):Number
        {
            switch (_arg_1)
            {
                case "normal":
                    return (Number(Character.account_tokens));
                case "clan":
                    return (Number(Character.character_prestige));
                case "pvp":
                    return (Number(Character.character_pvp_point));
                case "crew":
                    return (Number(Character.character_merit));
                default:
                    return (Number(Character.character_gold));
            };
        }

        public function hoverOver(_arg_1:Event):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        public function hoverOut(_arg_1:Event):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
        }

        public function toolTiponOver(e:MouseEvent):void
        {
            var tooltipData:Object;
            var desc:String;
            var itemType:String;
            e.currentTarget.parent.gotoAndStop(2);
            var mc:MovieClip = (e.currentTarget as MovieClip);
            if (!mc.tooltipCache)
            {
                var formatDesc:Function = function (_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String="", _arg_5:String=""):String
                {
                    var _local_6:* = "";
                    switch (itemType)
                    {
                        case "material":
                            _local_6 = (('\n<font color="#00cc00">Owned: ' + Character.getMaterialAmount(tooltipData.item_id)) + "</font>");
                            break;
                        case "essential":
                            _local_6 = (('\n<font color="#00cc00">Owned: ' + Character.getEssentialAmount(tooltipData.item_id)) + "</font>");
                            break;
                        case "item":
                            _local_6 = (('\n<font color="#00cc00">Owned: ' + Character.getConsumableAmount(tooltipData.item_id)) + "</font>");
                            break;
                    };
                    return ((((((((_arg_1 + "\n(") + itemType) + ")\n\nLevel ") + _arg_3) + _arg_4) + _local_6) + "\n\n") + _arg_5);
                };
                tooltipData = mc.tooltip;
                if (!tooltipData)
                {
                    return;
                };
                itemType = mc.item_type;
                switch (itemType)
                {
                    case "skill":
                        desc = formatDesc(tooltipData.skill_name, "Skill", tooltipData.skill_level, (((((('\n<font color="#ff0000">Damage: ' + tooltipData.skill_damage) + '</font>\n<font color="#0000ff">CP Cost: ') + tooltipData.skill_cp_cost) + '</font>\n<font color="#ffcc00">Cooldown: ') + tooltipData.skill_cooldown) + "</font>"), tooltipData.skill_description);
                        break;
                    case "wpn":
                        desc = formatDesc(tooltipData.item_name, "Weapon", tooltipData.item_level, (('\n<font color="#ff0000">Damage: ' + tooltipData.item_damage) + "</font>"), tooltipData.item_description);
                        break;
                    case "back":
                        desc = formatDesc(tooltipData.item_name, "Back Item", tooltipData.item_level, "", tooltipData.item_description);
                        break;
                    case "set":
                        desc = formatDesc(tooltipData.item_name, "Clothes", tooltipData.item_level, "", tooltipData.item_description);
                        break;
                    case "hair":
                        desc = formatDesc(tooltipData.item_name, "Hairstyle", tooltipData.item_level, "", tooltipData.item_description);
                        break;
                    case "accessory":
                        desc = formatDesc(tooltipData.item_name, "Accessories", tooltipData.item_level, "", tooltipData.item_description);
                        break;
                    case "material":
                        desc = formatDesc(tooltipData.item_name, "Material", tooltipData.item_level, "", tooltipData.item_description);
                        break;
                    case "essential":
                        desc = formatDesc(tooltipData.item_name, "Essentials", tooltipData.item_level, "", tooltipData.item_description);
                        break;
                    case "item":
                        desc = formatDesc(tooltipData.item_name, "Consumables", tooltipData.item_level, "", tooltipData.item_description);
                        break;
                    case "pet":
                        desc = formatDesc(tooltipData.pet_name, "Pet", tooltipData.pet_level, "", tooltipData.description);
                        break;
                    case "tokens":
                        desc = (("(Token)\n" + tooltipData) + " Tokens");
                        break;
                    case "gold":
                        desc = (("(Gold)\n" + tooltipData) + " Gold");
                        break;
                    case "tp":
                        desc = (("(TP)\n" + tooltipData) + " TP");
                        break;
                    case "xp":
                        desc = (("(XP)\n" + tooltipData) + " XP");
                        break;
                    case "ss":
                        desc = (("(SS)\n" + tooltipData) + " SS");
                        break;
                    default:
                        desc = "";
                };
                mc.tooltipCache = desc;
            };
            stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(mc.tooltipCache);
        }

        public function toolTiponOut(_arg_1:MouseEvent):void
        {
            _arg_1.currentTarget.parent.gotoAndStop(1);
            this.tooltip.hide();
        }

        public function removeCharMCItems(_arg_1:*):void
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

        public function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            var _local_1:*;
            this.main.handleVillageHUDVisibility(true);
            this.main.HUD.setBasicData();
            this.main.HUD.loadFrame();
            _local_1 = 0;
            while (_local_1 < 15)
            {
                GF.removeAllChild(this[("item_" + _local_1)].iconMc.iconHolder);
                this[("item_" + _local_1)].clickMask.tooltip = null;
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.tabButton.length)
            {
                this[this.tabButton[_local_1]].buttonMode = false;
                _local_1++;
            };
            GF.removeAllChild(this.tempWeaponMC);
            GF.removeAllChild(this.tempBackItemMC);
            GF.removeAllChild(this.tempHairMC);
            GF.removeAllChild(this.tempBackHairMC);
            GF.removeAllChild(this.tempSetMC);
            GF.removeAllChild(this.tempSkirtMC);
            _local_1 = 0;
            while (_local_1 < this.tempSetArray.length)
            {
                GF.removeAllChild(this.tempSetArray[_local_1]);
                _local_1++;
            };
            GF.destroyArray(this.outfits);
            this.main.clearEvents();
            this.eventHandler.removeAllEventListeners();
            this.resetIconHolder();
            this.tooltip.destroy();
            this.loaderSwf.clear();
            NinjaSage.clearLoader();
            OutfitManager.clearStaticMc();
            BulkLoader.getLoader("assets").removeAll();
            this.weaponArray = [];
            this.backArray = [];
            this.accArray = [];
            this.setArray = [];
            this.hairArray = [];
            this.essentialArray = [];
            this.consumableArray = [];
            this.skillArray = [];
            this.selectedCategory = [];
            this.outfits = [];
            this.itemEquipMC = [];
            this.backHairMC = [];
            this.skirtMC = [];
            this.tempSetArray = [];
            this.iconMCArray = [];
            this.currentPage = 1;
            this.totalPage = 1;
            this.buyQuantity = 1;
            this.tempWeaponMC = null;
            this.tempBackItemMC = null;
            this.tempHairMC = null;
            this.tempBackHairMC = null;
            this.tempSetMC = null;
            this.tempSkirtMC = null;
            this.buyPanel = null;
            this.confirmation = null;
            this.selectedBuyitem = null;
            this.selectedHairColor = null;
            this.selectedSkinColor = null;
            this.selectedHairMC = null;
            this.selectedBackHairMC = null;
            this.selectedSetMC = null;
            this.loaderSwf = null;
            this.tabIndicator = null;
            this.color = null;
            this.eventHandler = null;
            this.tooltip = null;
            this.main = null;
            this.removeCharMCItems(this.char_mc);
            GF.removeAllChild(this.char_mc);
            GF.removeAllChild(this);
            System.gc();
        }


    }
}//package id.ninjasage.features

