// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.SkillInventory

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import br.com.stimuli.loading.BulkLoader;
    import com.abrahamyan.liquid.ToolTip;
    import id.ninjasage.EventHandler;
    import com.utils.CreateFilter;
    import Storage.Character;
    import flash.events.ErrorEvent;
    import Storage.SkillLibrary;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.utils.GF;
    import Managers.NinjaSage;
    import Managers.OutfitManager;
    import flash.system.System;

    public dynamic class SkillInventory extends MovieClip 
    {

        public var panelMC:MovieClip;
        public var btn_ResetSkill:SimpleButton;
        public var btn_add_preset:SimpleButton;
        public var btn_clear:SimpleButton;
        public var btn_clearSearch:SimpleButton;
        public var btn_close:SimpleButton;
        public var btn_close_slot0:SimpleButton;
        public var btn_close_slot1:SimpleButton;
        public var btn_close_slot2:SimpleButton;
        public var btn_close_slot3:SimpleButton;
        public var btn_close_slot4:SimpleButton;
        public var btn_close_slot5:SimpleButton;
        public var btn_close_slot6:SimpleButton;
        public var btn_close_slot7:SimpleButton;
        public var btn_help:SimpleButton;
        public var btn_next:SimpleButton;
        public var btn_preset_1:SimpleButton;
        public var btn_preset_2:SimpleButton;
        public var btn_preset_3:SimpleButton;
        public var btn_preset_4:SimpleButton;
        public var btn_prev:SimpleButton;
        public var btn_preview:SimpleButton;
        public var btn_save:SimpleButton;
        public var btn_search:SimpleButton;
        public var btn_to_page:SimpleButton;
        public var element_mc0:MovieClip;
        public var element_mc1:MovieClip;
        public var element_mc2:MovieClip;
        public var element_mc3:MovieClip;
        public var element_mc4:MovieClip;
        public var item_0:MovieClip;
        public var item_1:MovieClip;
        public var item_10:MovieClip;
        public var item_11:MovieClip;
        public var item_2:MovieClip;
        public var item_3:MovieClip;
        public var item_4:MovieClip;
        public var item_5:MovieClip;
        public var item_6:MovieClip;
        public var item_7:MovieClip;
        public var item_8:MovieClip;
        public var item_9:MovieClip;
        public var preview:MovieClip;
        public var skillInfoMC:MovieClip;
        public var skill_0:MovieClip;
        public var skill_1:MovieClip;
        public var skill_2:MovieClip;
        public var skill_3:MovieClip;
        public var skill_4:MovieClip;
        public var skill_5:MovieClip;
        public var skill_6:MovieClip;
        public var skill_7:MovieClip;
        public var txt_goToPage:TextField;
        public var txt_page:TextField;
        public var txt_search:TextField;
        public var selectedCategory:Array;
        public var skillPreset:Array;
        public var currentPage:int = 1;
        public var totalPage:int = 1;
        public var skillIndex:int = 0;
        public var skillLoading:int = 0;
        public var skillCount:int = 0;
        public var equippedCount:int = 0;
        public var cost:int = 0;
        public var selectedPreset:int = 1;
        public var selectedSkill:String;
        public var currentElement:String;
        public var eventHandler:*;
        public var tooltip:*;
        public var main:*;
        public var glowFilter:*;
        public var confirmation:*;
        public var previewMC:* = null;
        public var isDescription:Boolean = false;

        public var skillIconMC:Array = [];
        public var equippedSkill:Array = [];
        public var switchSkillIndexHolder:Array = [];
        public var loaderSwf:* = BulkLoader.createUniqueNamedLoader(12);
        public var windSkills:Array = [];
        public var waterSkills:Array = [];
        public var fireSkills:Array = [];
        public var thunderSkills:Array = [];
        public var earthSkills:Array = [];
        public var taijutsuSkills:Array = [];
        public var genjutsuSkills:Array = [];
        public var clanSkills:Array = [];
        public var shadowwarSkills:Array = [];
        public var packageSkills:Array = [];
        public var leaderboardSkills:Array = [];
        public var spendingSkills:Array = [];

        public function SkillInventory(_arg_1:*, _arg_2:*, _arg_3:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2;
            this.tooltip = ToolTip.getInstance();
            this.eventHandler = new EventHandler();
            this.glowFilter = CreateFilter.getGlowFilter({
                "color":0xFFFF00,
                "strength":1000,
                "blurX":8,
                "blurY":8
            });
            this.setOwnedSkillsArray();
            this.setElementCategory();
            this.initButton();
            this.initUI();
        }

        public function initUI():*
        {
            this.panelMC.preview.visible = false;
            this.panelMC.skillInfoMC.visible = false;
            this.panelMC.btn_preview.visible = false;
            this.panelMC.btn_filter.filter_on.visible = false;
            this.panelMC.txt_goToPage.restrict = "0-9";
            this.selectedCategory = this.getElementSkillsArray(int(Character.character_element_1));
            this.equippedSkill = PresetData.preset_skill.split(",");
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.selectedCategory.length / 12)), 1);
            this.loadEquippedSkills();
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.loadSwf();
        }

        public function loadSwf():*
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            this.isLoading = true;
            if (this.skillIndex < this.skillLoading)
            {
                _local_1 = this.selectedCategory[this.skillIndex];
                _local_2 = (("skills/" + _local_1) + ".swf");
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

        public function onItemLoadError(_arg_1:ErrorEvent):*
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.COMPLETE, this.completeIcon);
            this.skillIconMC[this.skillCount] = null;
            this.skillIndex++;
            this.skillCount++;
            this.loadSwf();
        }

        public function completeIcon(_arg_1:Event):*
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.ERROR, this.onItemLoadError);
            var _local_3:MovieClip;
            _local_3 = _arg_1.target.content["icon"];
            if (!Character.play_items_animation)
            {
                _local_3.stopAllMovieClips();
            };
            this.skillIconMC.push(_local_3);
            this.panelMC[("item_" + this.skillCount)].iconMC.iconHolder.addChild(_local_3);
            this.panelMC[("item_" + this.skillCount)].gotoAndStop(1);
            this.panelMC[("item_" + this.skillCount)].visible = true;
            var _local_4:* = this.selectedCategory[this.skillIndex];
            if (_arg_1.target.content[_local_4])
            {
                _arg_1.target.content[_local_4].gotoAndStop(1);
            };
            var _local_5:* = SkillLibrary.getSkillInfo(_local_4);
            this.panelMC[("item_" + this.skillCount)].txt_name.text = _local_5["skill_name"];
            this.panelMC[("item_" + this.skillCount)].txt_level.text = _local_5["skill_level"];
            if (int(Character.character_lvl) >= _local_5["skill_level"])
            {
                this.panelMC[("item_" + this.skillCount)]["btn_equip_skill"].visible = true;
                this.panelMC[("item_" + this.skillCount)]["txt_equipped"].visible = false;
            }
            else
            {
                this.panelMC[("item_" + this.skillCount)]["btn_equip_skill"].visible = false;
            };
            if (this.equippedSkill.indexOf(_local_4) > -1)
            {
                this.panelMC[("item_" + this.skillCount)]["btn_equip_skill"].visible = false;
                this.panelMC[("item_" + this.skillCount)]["txt_equipped"].visible = true;
            }
            else
            {
                this.panelMC[("item_" + this.skillCount)]["txt_equipped"].visible = false;
            };
            this.panelMC[("item_" + this.skillCount)].tooltip = _local_5;
            this.eventHandler.addListener(this.panelMC[("item_" + this.skillCount)]["btn_equip_skill"], MouseEvent.CLICK, this.equipSkill);
            this.eventHandler.addListener(this.panelMC[("item_" + this.skillCount)], MouseEvent.CLICK, this.showSkillDetail);
            this.eventHandler.addListener(this.panelMC[("item_" + this.skillCount)], MouseEvent.ROLL_OVER, this.toolTiponOver);
            this.eventHandler.addListener(this.panelMC[("item_" + this.skillCount)], MouseEvent.ROLL_OUT, this.toolTiponOut);
            this.skillIndex++;
            this.skillCount++;
            this.loadSwf();
        }

        public function showSkillDetail(_arg_1:MouseEvent):*
        {
            var _local_2:* = 0;
            while (_local_2 < 12)
            {
                this.panelMC[("item_" + _local_2)].gotoAndStop(1);
                _local_2++;
            };
            _arg_1.currentTarget.gotoAndStop(3);
            var _local_3:* = _arg_1.currentTarget.name.replace("item_", "");
            var _local_4:* = _arg_1.currentTarget.tooltip;
            this.panelMC.skillInfoMC.visible = true;
            this.panelMC.btn_preview.visible = true;
            this.selectedSkill = _local_4.skill_id;
            GF.removeAllChild(this.panelMC.skillInfoMC.iconMC.iconHolder);
            NinjaSage.loadItemIcon(this.panelMC.skillInfoMC.iconMC.iconHolder, this.selectedSkill, "icon");
            this.panelMC.skillInfoMC.iconType.gotoAndStop(_local_4.skill_type);
            this.panelMC.skillInfoMC.txt_name.text = _local_4.skill_name;
            this.panelMC.skillInfoMC.txt_level.text = _local_4.skill_level;
            this.panelMC.skillInfoMC.txt_cp.text = _local_4.skill_cp_cost;
            this.panelMC.skillInfoMC.txt_dmg.text = _local_4.skill_damage;
            this.panelMC.skillInfoMC.txt_cd.text = _local_4.skill_cooldown;
            this.panelMC.skillInfoMC.txt_description.text = _local_4.skill_description;
        }

        public function loadSkillAndPreview(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.resetPreviewHolder();
            var _local_2:* = (("skills/" + this.selectedSkill) + ".swf");
            var _local_3:* = this.loaderSwf.add(_local_2);
            _local_3.addEventListener(BulkLoader.COMPLETE, this.completePreview);
            this.loaderSwf.start();
        }

        public function completePreview(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            this.panelMC.previewMC = _arg_1.target.content[this.selectedSkill];
            this.panelMC.previewMC.gotoAndStop(1);
            this.skill_info = SkillLibrary.getSkillInfo(this.selectedSkill);
            this.setFrameScript();
            if (!Character.is_stickman)
            {
                this.main.outfit_manager.fillOutfit(this.panelMC.previewMC, Character.character_weapon, Character.character_back_item, Character.character_set, Character.character_hair, Character.character_face, Character.character_color_hair, Character.character_color_skin);
            };
            this.panelMC.previewMC.scaleX = -0.7;
            this.panelMC.previewMC.scaleY = 0.7;
            try
            {
                _arg_1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
            this.main.loading(false);
            this.showPreview();
        }

        public function showPreview():void
        {
            this.panelMC.preview.visible = true;
            this.panelMC.preview.skillMc.addChild(this.panelMC.previewMC);
            this.panelMC.previewMC.gotoAndPlay(2);
            this.eventHandler.addListener(this.panelMC.preview.exitBtn, MouseEvent.CLICK, this.closePreview);
            this.eventHandler.addListener(this.panelMC.preview.replayBtn, MouseEvent.CLICK, this.handleReplay);
        }

        public function handleReplay(_arg_1:MouseEvent):void
        {
            this.panelMC.previewMC.gotoAndPlay(2);
        }

        private function setFrameScript():void
        {
            var i:int;
            this.panelMC.previewMC.addFrameScript((this.panelMC.previewMC.totalFrames - 1), this.handleEndAnimation);
            if (this.skill_info.anims.hasOwnProperty("fullscreen"))
            {
                this.panelMC.previewMC.addFrameScript(this.skill_info.anims.fullscreen.add, this.addFullScreen);
                this.panelMC.previewMC.addFrameScript(this.skill_info.anims.fullscreen.remove, this.removeFullScreen);
            };
            if (this.skill_info.anims.hasOwnProperty("bunshin"))
            {
                i = 0;
                while (i < this.skill_info.anims.bunshin.length)
                {
                    function (i:int):void
                    {
                        this.panelMC.previewMC.addFrameScript(this.skill_info.anims.bunshin[i], function ():void
                        {
                            handleBunshin(previewMC[("shandow" + String((i + 1)))]);
                        });
                    }.call(this, i);
                    i = (i + 1);
                };
            };
            this.panelMC.previewMC.gotoAndStop(1);
        }

        private function clearFrameScript():void
        {
            var _local_1:int;
            this.panelMC.previewMC.addFrameScript((this.panelMC.previewMC.totalFrames - 1), null);
            if (this.skill_info.anims.hasOwnProperty("fullscreen"))
            {
                this.panelMC.previewMC.addFrameScript(this.skill_info.anims.fullscreen.add, null);
                this.panelMC.previewMC.addFrameScript(this.skill_info.anims.fullscreen.remove, null);
            };
            if (this.skill_info.anims.hasOwnProperty("bunshin"))
            {
                _local_1 = 0;
                while (_local_1 < this.skill_info.anims.bunshin.length)
                {
                    this.panelMC.previewMC.addFrameScript(this.skill_info.anims.bunshin[_local_1], null);
                    _local_1++;
                };
            };
            this.panelMC.previewMC.gotoAndStop(1);
        }

        public function addFullScreen():void
        {
            var _local_1:int = (("scale" in this.skill_info.anims.fullscreen) ? this.skill_info.anims.fullscreen.scale : 2);
            this.panelMC.previewMC.fullScreenEffect.x = 0;
            this.panelMC.previewMC.fullScreenEffect.y = 0;
            this.panelMC.previewMC.fullScreenEffect.scaleX = _local_1;
            this.panelMC.previewMC.fullScreenEffect.scaleY = _local_1;
            this.main.loader.addChild(this.panelMC.previewMC.fullScreenEffect);
        }

        public function removeFullScreen():void
        {
            this.main.loader.removeChild(this.panelMC.previewMC.fullScreenEffect);
        }

        public function handleBunshin(_arg_1:MovieClip):void
        {
            if (!Character.is_stickman)
            {
                this.main.outfit_manager.fillOutfit(_arg_1, Character.character_weapon, Character.character_back_item, Character.character_set, Character.character_hair, Character.character_face, Character.character_color_hair, Character.character_color_skin);
            };
        }

        public function handleEndAnimation():void
        {
            this.panelMC.previewMC.gotoAndStop(1);
            this.panelMC.previewMC.x = 0;
            this.panelMC.previewMC.y = 0;
        }

        public function closePreview(_arg_1:MouseEvent):void
        {
            this.resetPreviewHolder();
            this.panelMC.preview.visible = false;
        }

        public function loadEquippedSkills():*
        {
            var _local_1:*;
            var _local_2:*;
            if (this.equippedCount < this.equippedSkill.length)
            {
                _local_1 = (("skills/" + this.equippedSkill[this.equippedCount]) + ".swf");
                _local_2 = this.loaderSwf.add(_local_1);
                _local_2.addEventListener(BulkLoader.COMPLETE, this.completeEquipIcon);
                this.loaderSwf.start();
            }
            else
            {
                return;
            };
        }

        public function completeEquipIcon(_arg_1:Event):*
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            GF.removeAllChild(this.panelMC[("skill_" + this.equippedCount)].iconHolder);
            var _local_3:MovieClip = _arg_1.target.content["icon"];
            _arg_1.target.content[this.equippedSkill[this.equippedCount]].gotoAndStop(1);
            this.panelMC[("skill_" + this.equippedCount)].iconHolder.addChild(_local_3);
            var _local_4:* = SkillLibrary.getSkillInfo(this.equippedSkill[this.equippedCount]);
            this.panelMC[("skill_" + this.equippedCount)].tooltip = _local_4;
            this.eventHandler.addListener(this.panelMC[("btn_close_slot" + this.equippedCount)], MouseEvent.CLICK, this.removeEquippedSkill);
            this.eventHandler.addListener(this.panelMC[("skill_" + this.equippedCount)], MouseEvent.MOUSE_OVER, this.toolTiponOver);
            this.eventHandler.addListener(this.panelMC[("skill_" + this.equippedCount)], MouseEvent.MOUSE_OUT, this.toolTiponOut);
            this.panelMC[("skill_" + this.equippedCount)].selected = false;
            this.eventHandler.addListener(this.panelMC[("skill_" + this.equippedCount)], MouseEvent.CLICK, this.selectSwitchingSkill);
            this.equippedCount++;
            this.loadEquippedSkills();
        }

        public function selectSwitchingSkill(_arg_1:MouseEvent):*
        {
            var _local_3:*;
            var _local_4:*;
            _arg_1.currentTarget.filters = [this.glowFilter];
            var _local_2:* = _arg_1.currentTarget.name.replace("skill_", "");
            if (_arg_1.currentTarget.selected)
            {
                this.switchSkillIndexHolder = [];
                _arg_1.currentTarget.selected = false;
                _arg_1.currentTarget.filters = null;
                return;
            };
            _arg_1.currentTarget.selected = true;
            this.switchSkillIndexHolder.push(_local_2);
            if (this.switchSkillIndexHolder.length == 2)
            {
                this.tooltip.hide();
                _local_3 = this.equippedSkill[this.switchSkillIndexHolder[0]];
                this.equippedSkill[this.switchSkillIndexHolder[0]] = this.equippedSkill[this.switchSkillIndexHolder[1]];
                this.equippedSkill[this.switchSkillIndexHolder[1]] = _local_3;
                this.switchSkillIndexHolder = [];
                _local_4 = 0;
                while (_local_4 < 8)
                {
                    this.panelMC[("skill_" + _local_4)].selected = false;
                    this.panelMC[("skill_" + _local_4)].filters = null;
                    _local_4++;
                };
                this.resetRecursiveProperty();
                this.resetEquippedIconHolder();
                this.loadEquippedSkills();
            };
        }

        public function equipSkill(_arg_1:MouseEvent):*
        {
            if (this.equippedSkill.length >= 8)
            {
                return;
            };
            var _local_2:int = _arg_1.currentTarget.parent.name.replace("item_", "");
            var _local_3:int = (_local_2 + int((int((this.currentPage - 1)) * 12)));
            this.panelMC[("item_" + _local_2)].btn_equip_skill.visible = false;
            this.panelMC[("item_" + _local_2)].txt_equipped.visible = true;
            this.panelMC[("item_" + _local_2)].txt_equipped.text = "Equipped";
            this.equippedSkill.push(this.selectedCategory[_local_3]);
            this.loadEquippedSkills();
        }

        public function removeEquippedSkill(_arg_1:MouseEvent):*
        {
            if (this.isLoading)
            {
                return;
            };
            var _local_2:* = _arg_1.currentTarget.name.replace("btn_close_slot", "");
            if (_local_2 >= this.equippedSkill.length)
            {
                return;
            };
            this.equippedSkill.splice(_local_2, 1);
            this.resetEquippedIconHolder();
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.loadSwf();
            this.loadEquippedSkills();
        }

        public function removeAllEquippedSkill(_arg_1:MouseEvent):*
        {
            this.equippedSkill = [];
            this.resetEquippedIconHolder();
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.loadSwf();
            this.loadEquippedSkills();
        }

        public function handleSearchFilter(_arg_1:MouseEvent):*
        {
            this.panelMC.btn_filter.filter_on.visible = (!(this.panelMC.btn_filter.filter_on.visible));
            this.isDescription = ((this.panelMC.btn_filter.filter_on.visible) ? true : false);
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
                _local_5 = this.selectedCategory[_local_6];
                _local_4 = SkillLibrary.getSkillInfo(_local_5);
                if (this.isDescription)
                {
                    if ((((_local_4) && (_local_4.hasOwnProperty("skill_description"))) && (_local_4["skill_description"].toLowerCase().indexOf(_local_3) >= 0)))
                    {
                        _local_2.push(this.selectedCategory[_local_6]);
                    };
                }
                else
                {
                    if ((((_local_4) && (_local_4.hasOwnProperty("skill_name"))) && (_local_4["skill_name"].toLowerCase().indexOf(_local_3) >= 0)))
                    {
                        _local_2.push(this.selectedCategory[_local_6]);
                    };
                };
                _local_6++;
            };
            this.selectedCategory = _local_2;
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.selectedCategory.length / 12)), 1);
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.loadSwf();
        }

        public function onSearchClear(_arg_1:MouseEvent=null):*
        {
            this.panelMC.txt_search.text = "";
            this.panelMC.txt_goToPage.text = "";
            if (this.currentElement == "wind")
            {
                this.selectedCategory = this.windSkills;
            }
            else
            {
                if (this.currentElement == "water")
                {
                    this.selectedCategory = this.waterSkills;
                }
                else
                {
                    if (this.currentElement == "fire")
                    {
                        this.selectedCategory = this.fireSkills;
                    }
                    else
                    {
                        if (this.currentElement == "thunder")
                        {
                            this.selectedCategory = this.thunderSkills;
                        }
                        else
                        {
                            if (this.currentElement == "earth")
                            {
                                this.selectedCategory = this.earthSkills;
                            }
                            else
                            {
                                if (this.currentElement == "taijutsu")
                                {
                                    this.selectedCategory = this.taijutsuSkills;
                                }
                                else
                                {
                                    if (this.currentElement == "genjutsu")
                                    {
                                        this.selectedCategory = this.genjutsuSkills;
                                    }
                                    else
                                    {
                                        if (this.currentElement == "clan")
                                        {
                                            this.selectedCategory = this.clanSkills;
                                        }
                                        else
                                        {
                                            if (this.currentElement == "shadowwar")
                                            {
                                                this.selectedCategory = this.shadowwarSkills;
                                            }
                                            else
                                            {
                                                if (this.currentElement == "package")
                                                {
                                                    this.selectedCategory = this.packageSkills;
                                                }
                                                else
                                                {
                                                    if (this.currentElement == "leaderboard")
                                                    {
                                                        this.selectedCategory = this.leaderboardSkills;
                                                    }
                                                    else
                                                    {
                                                        if (this.currentElement == "spending")
                                                        {
                                                            this.selectedCategory = this.spendingSkills;
                                                        };
                                                    };
                                                };
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.selectedCategory.length / 12)), 1);
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
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
                        this.loadSwf();
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
                        this.loadSwf();
                    }
                    else
                    {
                        return;
                    };
            };
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            if (this.loaderSwf.itemsLoaded >= 60)
            {
                this.loaderSwf.removeAll();
            };
            this.loadSwf();
        }

        public function updatePageNumber():*
        {
            this.panelMC.txt_page.text = ((this.currentPage + "/") + this.totalPage);
        }

        public function initButton():*
        {
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btn_clear, MouseEvent.CLICK, this.removeAllEquippedSkill);
            this.eventHandler.addListener(this.panelMC.btn_to_page, MouseEvent.CLICK, this.goToPage);
            this.eventHandler.addListener(this.panelMC.btn_search, MouseEvent.CLICK, this.searchItem);
            this.eventHandler.addListener(this.panelMC.btn_clearSearch, MouseEvent.CLICK, this.onSearchClear);
            this.eventHandler.addListener(this.panelMC.btn_ResetSkill, MouseEvent.CLICK, this.openExternalPanel);
            this.eventHandler.addListener(this.panelMC.btn_preview, MouseEvent.CLICK, this.loadSkillAndPreview);
            this.eventHandler.addListener(this.panelMC.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btn_filter, MouseEvent.CLICK, this.handleSearchFilter);
            NinjaSage.showDynamicTooltip(this.panelMC.btn_filter.filter_on, "Search by description");
            NinjaSage.showDynamicTooltip(this.panelMC.btn_filter.filter_off, "Search by name");
        }

        public function setElementCategory():*
        {
            var _local_1:* = 0;
            while (_local_1 < 3)
            {
                this.panelMC[("element_mc" + _local_1)].visible = false;
                this.panelMC[("element_mc" + _local_1)].gotoAndStop(1);
                if (Character[("character_element_" + (_local_1 + 1))] > 0)
                {
                    this.panelMC[("element_mc" + _local_1)].visible = true;
                    this.panelMC[("element_mc" + _local_1)].gotoAndStop(Character[("character_element_" + (_local_1 + 1))]);
                    this.panelMC[("element_mc" + _local_1)].element.gotoAndStop(1);
                    NinjaSage.showDynamicTooltip(this.panelMC[("element_mc" + _local_1)].element, this.getElementName(Character[("character_element_" + (_local_1 + 1))]));
                    this.eventHandler.addListener(this.panelMC[("element_mc" + _local_1)].element, MouseEvent.CLICK, this.changeCategory);
                    this.eventHandler.addListener(this.panelMC[("element_mc" + _local_1)].element, MouseEvent.MOUSE_OVER, this.over);
                    this.eventHandler.addListener(this.panelMC[("element_mc" + _local_1)].element, MouseEvent.MOUSE_OUT, this.out);
                };
                _local_1++;
            };
            _local_1 = 3;
            while (_local_1 < 5)
            {
                this.panelMC[("element_mc" + _local_1)].gotoAndStop(1);
                this.eventHandler.addListener(this.panelMC[("element_mc" + _local_1)], MouseEvent.CLICK, this.changeCategory);
                this.eventHandler.addListener(this.panelMC[("element_mc" + _local_1)], MouseEvent.MOUSE_OVER, this.over);
                this.eventHandler.addListener(this.panelMC[("element_mc" + _local_1)], MouseEvent.MOUSE_OUT, this.out);
                _local_1++;
            };
        }

        public function changeCategory(_arg_1:MouseEvent):*
        {
            if (this.isLoading)
            {
                return;
            };
            this.resetAllElementsTab();
            _arg_1.currentTarget.gotoAndStop(3);
            var _local_2:* = ((_arg_1.currentTarget.name == "element") ? _arg_1.currentTarget.parent.name : _arg_1.currentTarget.name);
            switch (_local_2)
            {
                case "element_mc0":
                    this.selectedCategory = this.getElementSkillsArray(int(Character.character_element_1));
                    break;
                case "element_mc1":
                    this.selectedCategory = this.getElementSkillsArray(int(Character.character_element_2));
                    break;
                case "element_mc2":
                    this.selectedCategory = this.getElementSkillsArray(int(Character.character_element_3));
                    break;
                case "element_mc3":
                    this.selectedCategory = this.getElementSkillsArray(6);
                    break;
                case "element_mc4":
                    this.selectedCategory = this.getElementSkillsArray(7);
                    break;
            };
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.selectedCategory.length / 12)), 1);
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.resetSkillDetail();
            this.loadSwf();
        }

        public function getElementSkillsArray(_arg_1:int):Array
        {
            switch (_arg_1)
            {
                case 1:
                    this.currentElement = "wind";
                    return (this.windSkills);
                case 2:
                    this.currentElement = "fire";
                    return (this.fireSkills);
                case 3:
                    this.currentElement = "thunder";
                    return (this.thunderSkills);
                case 4:
                    this.currentElement = "earth";
                    return (this.earthSkills);
                case 5:
                    this.currentElement = "water";
                    return (this.waterSkills);
                case 6:
                    this.currentElement = "taijutsu";
                    return (this.taijutsuSkills);
                case 7:
                    this.currentElement = "genjutsu";
                    return (this.genjutsuSkills);
                default:
                    return ([]);
            };
        }

        public function getElementName(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case 1:
                    return ("Wind");
                case 2:
                    return ("Fire");
                case 3:
                    return ("Lightning");
                case 4:
                    return ("Earth");
                case 5:
                    return ("Water");
            };
            return ("No Element");
        }

        public function setOwnedSkillsArray():*
        {
            var _local_4:*;
            var _local_1:* = Character.character_skills.split(",");
            var _local_2:* = {
                "windSkills":SkillLibrary.getSkillIds("1"),
                "waterSkills":SkillLibrary.getSkillIds("5"),
                "fireSkills":SkillLibrary.getSkillIds("2"),
                "thunderSkills":SkillLibrary.getSkillIds("3"),
                "earthSkills":SkillLibrary.getSkillIds("4"),
                "taijutsuSkills":SkillLibrary.getSkillIds("6"),
                "genjutsuSkills":SkillLibrary.getSkillIds("7")
            };
            var _local_3:* = 0;
            while (_local_3 < _local_1.length)
            {
                for (_local_4 in _local_2)
                {
                    if (_local_2[_local_4].indexOf(_local_1[_local_3]) > -1)
                    {
                        this[_local_4].push(_local_1[_local_3]);
                    };
                };
                _local_3++;
            };
        }

        public function over(_arg_1:MouseEvent):*
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        public function out(_arg_1:MouseEvent):*
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
        }

        public function setDefaultArray():*
        {
            if (this.currentElement == "wind")
            {
                this.selectedCategory = this.windSkills;
            }
            else
            {
                if (this.currentElement == "water")
                {
                    this.selectedCategory = this.waterSkills;
                }
                else
                {
                    if (this.currentElement == "fire")
                    {
                        this.selectedCategory = this.fireSkills;
                    }
                    else
                    {
                        if (this.currentElement == "thunder")
                        {
                            this.selectedCategory = this.thunderSkills;
                        }
                        else
                        {
                            if (this.currentElement == "earth")
                            {
                                this.selectedCategory = this.earthSkills;
                            }
                            else
                            {
                                if (this.currentElement == "taijutsu")
                                {
                                    this.selectedCategory = this.taijutsuSkills;
                                }
                                else
                                {
                                    if (this.currentElement == "genjutsu")
                                    {
                                        this.selectedCategory = this.genjutsuSkills;
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        public function resetAllElementsTab():*
        {
            this.panelMC.element_mc0.element.gotoAndStop(1);
            this.panelMC.element_mc1.element.gotoAndStop(1);
            this.panelMC.element_mc2.element.gotoAndStop(1);
            this.panelMC.element_mc3.gotoAndStop(1);
            this.panelMC.element_mc4.gotoAndStop(1);
        }

        public function resetRecursiveProperty():*
        {
            this.skillLoading = (this.currentPage * 12);
            if (this.selectedCategory.length < this.skillLoading)
            {
                this.skillLoading = this.selectedCategory.length;
            };
            this.skillIndex = ((this.currentPage - 1) * 12);
            this.skillCount = 0;
            this.equippedCount = 0;
        }

        public function resetIconHolder():*
        {
            var _local_1:* = 0;
            while (_local_1 < this.skillIconMC.length)
            {
                GF.removeAllChild(this.skillIconMC[_local_1]);
                _local_1++;
            };
            this.skillIconMC = [];
            _local_1 = 0;
            while (_local_1 < 12)
            {
                GF.removeAllChild(this.panelMC[("item_" + _local_1)].iconMC.iconHolder);
                this.panelMC[("item_" + _local_1)].visible = false;
                this.panelMC[("item_" + _local_1)].gotoAndStop(1);
                delete this.panelMC[("item_" + _local_1)].tooltip;
                delete this.panelMC[("item_" + _local_1)].tooltipCache;
                this.eventHandler.removeListener(this.panelMC[("item_" + _local_1)]["btn_equip_skill"], MouseEvent.CLICK, this.equipSkill);
                this.eventHandler.removeListener(this.panelMC[("item_" + _local_1)], MouseEvent.CLICK, this.showSkillDetail);
                this.eventHandler.removeListener(this.panelMC[("item_" + _local_1)], MouseEvent.ROLL_OVER, this.toolTiponOver);
                this.eventHandler.removeListener(this.panelMC[("item_" + _local_1)], MouseEvent.ROLL_OUT, this.toolTiponOut);
                _local_1++;
            };
        }

        public function resetEquippedIconHolder():*
        {
            this.switchSkillIndexHolder = [];
            var _local_1:* = 0;
            while (_local_1 < 8)
            {
                GF.removeAllChild(this.panelMC[("skill_" + _local_1)].iconHolder);
                this.panelMC[("skill_" + _local_1)].selected = false;
                this.panelMC[("skill_" + _local_1)].filters = null;
                delete this.panelMC[("skill_" + _local_1)].tooltip;
                delete this.panelMC[("skill_" + _local_1)].tooltipCache;
                this.eventHandler.removeListener(this.panelMC[("btn_close_slot" + _local_1)], MouseEvent.CLICK, this.removeEquippedSkill);
                this.eventHandler.removeListener(this.panelMC[("skill_" + _local_1)], MouseEvent.MOUSE_OVER, this.toolTiponOver);
                this.eventHandler.removeListener(this.panelMC[("skill_" + _local_1)], MouseEvent.MOUSE_OUT, this.toolTiponOut);
                this.eventHandler.removeListener(this.panelMC[("skill_" + _local_1)], MouseEvent.CLICK, this.selectSwitchingSkill);
                _local_1++;
            };
        }

        public function resetSkillDetail():*
        {
            this.panelMC.skillInfoMC.visible = false;
            this.panelMC.btn_preview.visible = false;
            this.selectedSkill = null;
            this.panelMC.skillInfoMC.txt_name.text = "";
            this.panelMC.skillInfoMC.txt_level.text = "";
            this.panelMC.skillInfoMC.txt_cp.text = "";
            this.panelMC.skillInfoMC.txt_dmg.text = "";
            this.panelMC.skillInfoMC.txt_cd.text = "";
            this.panelMC.skillInfoMC.txt_description.text = "";
            GF.removeAllChild(this.panelMC.skillInfoMC.iconMC.iconHolder);
        }

        public function resetPreviewHolder():void
        {
            var _local_1:*;
            if (this.panelMC.previewMC)
            {
                this.clearFrameScript();
                for each (_local_1 in ["effectMc", "fullScreenEffect", "back", "back_hair", "head", "hitAreaMc", "left_hand", "left_lower_arm", "left_lower_leg", "left_shoe", "left_upper_arm", "left_upper_leg", "lower_body", "right_hand", "right_lower_arm", "right_lower_leg", "right_shoe", "right_upper_arm", "right_upper_leg", "shadow", "skirt", "throw02Mc", "upper_body", "weapon"])
                {
                    if (this.panelMC.previewMC.hasOwnProperty(_local_1))
                    {
                        GF.removeAllChild(this.panelMC.previewMC[_local_1]);
                    };
                };
            };
            GF.removeAllChild(this.panelMC.previewMC);
            OutfitManager.removeChildsFromMovieClips(this.panelMC.preview.skillMc);
            this.panelMC.previewMC = null;
        }

        public function openExternalPanel(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name.replace("btn_", "");
            this.main.loadExternalSwfPanel(_local_2, _local_2);
        }

        public function toolTiponOver(_arg_1:MouseEvent):void
        {
            var _local_3:Object;
            var _local_4:String;
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
            var _local_2:MovieClip = (_arg_1.currentTarget as MovieClip);
            if (!_local_2.tooltipCache)
            {
                _local_3 = _local_2.tooltip;
                if (!_local_3)
                {
                    return;
                };
                _local_4 = ((((((((((_local_3.skill_name + "\n(Skill)\n\nLevel ") + _local_3.skill_level) + '\n<font color="#ff0000">Damage: ') + _local_3.skill_damage) + '</font>\n<font color="#0000ff">CP Cost: ') + _local_3.skill_cp_cost) + '</font>\n<font color="#ffcc00">Cooldown: ') + _local_3.skill_cooldown) + "</font>\n\n") + _local_3.skill_description);
                _local_2.tooltipCache = _local_4;
            };
            this.main.stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_2.tooltipCache);
        }

        public function toolTiponOut(_arg_1:MouseEvent):*
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
            this.tooltip.hide();
        }

        public function closePanel(_arg_1:MouseEvent):*
        {
            if (this.equippedSkill.length == 0)
            {
                this._main.getNotice("Equipped skill cannot empty");
                return;
            };
            this.destroy();
        }

        public function destroy():*
        {
            PresetData.preset_skill = this.equippedSkill.join(",");
            var _local_1:* = 0;
            while (_local_1 < 5)
            {
                NinjaSage.clearDynamicTooltip(this.panelMC[("element_mc" + _local_1)]);
                _local_1++;
            };
            GF.removeAllChild(this.panelMC.skillInfoMC.iconMC.iconHolder);
            this.resetPreviewHolder();
            this.resetSkillDetail();
            this.resetIconHolder();
            this.resetEquippedIconHolder();
            NinjaSage.clearDynamicTooltip(this.panelMC.btn_filter.filter_on);
            NinjaSage.clearDynamicTooltip(this.panelMC.btn_filter.filter_off);
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.loaderSwf.clear();
            this.eventHandler.removeAllEventListeners();
            this.tooltip.destroy();
            this.windSkills = [];
            this.waterSkills = [];
            this.fireSkills = [];
            this.thunderSkills = [];
            this.earthSkills = [];
            this.taijutsuSkills = [];
            this.genjutsuSkills = [];
            this.clanSkills = [];
            this.shadowwarSkills = [];
            this.packageSkills = [];
            this.leaderboardSkills = [];
            this.spendingSkills = [];
            this.selectedCategory = [];
            this.skillIconMC = [];
            this.equippedSkill = [];
            this.skillPreset = [];
            this.currentPage = 1;
            this.totalPage = 1;
            this.skillIndex = 0;
            this.skillLoading = 0;
            this.skillCount = 0;
            this.equippedCount = 0;
            this.cost = 0;
            this.selectedPreset = 1;
            this.glowFilter = null;
            this.confirmation = null;
            this.selectedSkill = null;
            this.currentElement = null;
            this.eventHandler = null;
            this.tooltip = null;
            this.loaderSwf = null;
            this.panelMC.previewMC = null;
            this.panelMC.visible = false;
            this.main = null;
            System.gc();
        }


    }
}//package id.ninjasage.features

