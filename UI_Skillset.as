// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.UI_Skillset

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import Managers.PreviewManager;
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
    import flash.utils.getDefinitionByName;
    import Managers.OutfitManager;
    import flash.system.System;

    public dynamic class UI_Skillset extends MovieClip 
    {

        public var btn_filter:MovieClip;
        public var element_mc5:MovieClip;
        public var element_mc6:MovieClip;
        public var element_mc7:MovieClip;
        public var element_mc8:MovieClip;
        public var element_mc9:MovieClip;
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
        public var previewMC:PreviewManager;
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

        public function UI_Skillset(_arg_1:*)
        {
            this.main = _arg_1;
            this.tooltip = ToolTip.getInstance();
            this.eventHandler = new EventHandler();
            this.glowFilter = CreateFilter.getGlowFilter({
                "color":0xFFFF00,
                "strength":1000,
                "blurX":8,
                "blurY":8
            });
            this.getSkillSets();
            this.setOwnedSkillsArray();
            this.setElementCategory();
            this.initButton();
            this.initUI();
        }

        public function initUI():*
        {
            this.preview.visible = false;
            this.skillInfoMC.visible = false;
            this.btn_preview.visible = false;
            this.btn_save.visible = false;
            this.btn_filter.filter_on.visible = false;
            this.txt_goToPage.restrict = "0-9";
            this.selectedCategory = this.getElementSkillsArray(int(Character.character_element_1));
            this.equippedSkill = ((Character.character_skill_set.split(",")[0] == "") ? [] : Character.character_skill_set.split(","));
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
            var _local_3:Class;
            var _local_4:MovieClip;
            _arg_1.target.content.stopAllMovieClips();
            _local_4 = _arg_1.target.content.icon;
            if (!Character.play_items_animation)
            {
                _local_4.stopAllMovieClips();
            };
            this.skillIconMC.push(_local_4);
            this[("item_" + this.skillCount)].iconMC.iconHolder.addChild(_local_4);
            this[("item_" + this.skillCount)].gotoAndStop(1);
            this[("item_" + this.skillCount)].visible = true;
            var _local_5:* = this.selectedCategory[this.skillIndex];
            _arg_1.target.content[_local_5].gotoAndStop(1);
            var _local_6:* = SkillLibrary.getSkillInfo(_local_5);
            this[("item_" + this.skillCount)].txt_name.text = _local_6["skill_name"];
            this[("item_" + this.skillCount)].txt_level.text = _local_6["skill_level"];
            if (int(Character.character_lvl) >= _local_6["skill_level"])
            {
                this[("item_" + this.skillCount)]["btn_equip_skill"].visible = true;
                this[("item_" + this.skillCount)]["txt_equipped"].visible = false;
            }
            else
            {
                this[("item_" + this.skillCount)]["btn_equip_skill"].visible = false;
            };
            if (this.equippedSkill.indexOf(_local_5) > -1)
            {
                this[("item_" + this.skillCount)]["btn_equip_skill"].visible = false;
                this[("item_" + this.skillCount)]["txt_equipped"].visible = true;
            }
            else
            {
                this[("item_" + this.skillCount)]["txt_equipped"].visible = false;
            };
            this[("item_" + this.skillCount)].tooltip = _local_6;
            this.eventHandler.addListener(this[("item_" + this.skillCount)]["btn_equip_skill"], MouseEvent.CLICK, this.equipSkill);
            this.eventHandler.addListener(this[("item_" + this.skillCount)], MouseEvent.CLICK, this.showSkillDetail);
            this.eventHandler.addListener(this[("item_" + this.skillCount)], MouseEvent.ROLL_OVER, this.toolTiponOver);
            this.eventHandler.addListener(this[("item_" + this.skillCount)], MouseEvent.ROLL_OUT, this.toolTiponOut);
            this.skillIndex++;
            this.skillCount++;
            this.loadSwf();
        }

        public function showSkillDetail(_arg_1:MouseEvent):*
        {
            var _local_2:* = 0;
            while (_local_2 < 12)
            {
                this[("item_" + _local_2)].gotoAndStop(1);
                _local_2++;
            };
            _arg_1.currentTarget.gotoAndStop(3);
            var _local_3:* = _arg_1.currentTarget.name.replace("item_", "");
            var _local_4:* = _arg_1.currentTarget.tooltip;
            this.skillInfoMC.visible = true;
            this.btn_preview.visible = true;
            this.selectedSkill = _local_4.skill_id;
            GF.removeAllChild(this.skillInfoMC.iconMC.iconHolder);
            NinjaSage.loadItemIcon(this.skillInfoMC.iconMC.iconHolder, this.selectedSkill, "icon");
            this.skillInfoMC.iconType.gotoAndStop(_local_4.skill_type);
            this.skillInfoMC.txt_name.text = _local_4.skill_name;
            this.skillInfoMC.txt_level.text = _local_4.skill_level;
            this.skillInfoMC.txt_cp.text = _local_4.skill_cp_cost;
            this.skillInfoMC.txt_dmg.text = _local_4.skill_damage;
            this.skillInfoMC.txt_cd.text = _local_4.skill_cooldown;
            this.skillInfoMC.txt_description.text = _local_4.skill_description;
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
            this.skill_info = SkillLibrary.getSkillInfo(this.selectedSkill);
            var _local_3:* = _arg_1.target.content[this.selectedSkill];
            this.previewMC = new PreviewManager(this.main, _local_3, this.skill_info);
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
            this.preview.visible = true;
            this.preview.skillMc.addChild(this.previewMC.preview_mc);
            this.previewMC.preview_mc.gotoAndPlay(2);
            this.eventHandler.addListener(this.preview.exitBtn, MouseEvent.CLICK, this.closePreview);
            this.eventHandler.addListener(this.preview.replayBtn, MouseEvent.CLICK, this.handleReplay);
        }

        public function handleReplay(_arg_1:MouseEvent):void
        {
            this.previewMC.preview_mc.gotoAndPlay(2);
        }

        public function closePreview(_arg_1:MouseEvent):void
        {
            this.resetPreviewHolder();
            this.preview.visible = false;
            GF.removeAllChild(this.preview.skillMc);
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
            GF.removeAllChild(this[("skill_" + this.equippedCount)].iconHolder);
            var _local_3:MovieClip = _arg_1.target.content.icon;
            this[("skill_" + this.equippedCount)].iconHolder.addChild(_local_3);
            var _local_4:* = SkillLibrary.getSkillInfo(this.equippedSkill[this.equippedCount]);
            _arg_1.target.content[this.equippedSkill[this.equippedCount]].gotoAndStop(1);
            this[("skill_" + this.equippedCount)].tooltip = _local_4;
            this.eventHandler.addListener(this[("btn_close_slot" + this.equippedCount)], MouseEvent.CLICK, this.removeEquippedSkill);
            this.eventHandler.addListener(this[("skill_" + this.equippedCount)], MouseEvent.MOUSE_OVER, this.toolTiponOver);
            this.eventHandler.addListener(this[("skill_" + this.equippedCount)], MouseEvent.MOUSE_OUT, this.toolTiponOut);
            this[("skill_" + this.equippedCount)].selected = false;
            this.eventHandler.addListener(this[("skill_" + this.equippedCount)], MouseEvent.CLICK, this.selectSwitchingSkill);
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
                    this[("skill_" + _local_4)].selected = false;
                    this[("skill_" + _local_4)].filters = null;
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
            this[("item_" + _local_2)].btn_equip_skill.visible = false;
            this[("item_" + _local_2)].txt_equipped.visible = true;
            this[("item_" + _local_2)].txt_equipped.text = "Equipped";
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
            this.btn_filter.filter_on.visible = (!(this.btn_filter.filter_on.visible));
            this.isDescription = ((this.btn_filter.filter_on.visible) ? true : false);
        }

        public function searchItem(_arg_1:MouseEvent):*
        {
            var _local_4:*;
            var _local_5:*;
            if (this.txt_search.text == "")
            {
                return;
            };
            this.setDefaultArray();
            var _local_2:Array = [];
            var _local_3:String = this.txt_search.text.toLowerCase();
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
            this.txt_search.text = "";
            this.txt_goToPage.text = "";
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
            if (this.txt_goToPage.text == "")
            {
                return;
            };
            if (((int(this.txt_goToPage.text) > this.totalPage) || (int(this.txt_goToPage.text) <= 0)))
            {
                return;
            };
            this.currentPage = int(this.txt_goToPage.text);
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            this.loadSwf();
        }

        public function getSkillSets():*
        {
            this.main.loading(false);
            this.main.amf_manager.service("CharacterService.getSkillSets", [Character.char_id, Character.sessionkey], this.getSkillSetsResponse);
        }

        public function getSkillSetsResponse(_arg_1:Object):*
        {
            var _local_3:*;
            this.skillPreset = _arg_1.skillsets;
            var _local_2:* = 1;
            while (_local_2 < 5)
            {
                this[("btn_preset_" + _local_2)].visible = false;
                _local_2++;
            };
            _local_2 = 1;
            while (_local_2 < (this.skillPreset.length + 1))
            {
                _local_3 = this.skillPreset[(_local_2 - 1)].skills;
                if (_local_3 == Character.character_skill_set)
                {
                    this[("btn_preset_" + _local_2)].filters = [this.glowFilter];
                };
                this[("btn_preset_" + _local_2)].visible = true;
                this.eventHandler.addListener(this[("btn_preset_" + _local_2)], MouseEvent.CLICK, this.changePreset);
                _local_2++;
            };
            if (this.skillPreset.length == 4)
            {
                this.btn_add_preset.visible = false;
            };
            if (this.skillPreset.length >= 1)
            {
                this.btn_help.visible = true;
            };
            this.main.loading(false);
        }

        public function changePreset(_arg_1:MouseEvent):*
        {
            var _local_2:* = 1;
            while (_local_2 < 5)
            {
                this[("btn_preset_" + _local_2)].filters = null;
                _local_2++;
            };
            this.selectedPreset = int(_arg_1.currentTarget.name.replace("btn_preset_", ""));
            if (_arg_1.currentTarget)
            {
                _arg_1.currentTarget.filters = [this.glowFilter];
            };
            if (this.btn_save.visible != true)
            {
                this.btn_save.visible = true;
            };
            if (!this.btn_save.hasEventListener(MouseEvent.CLICK))
            {
                this.eventHandler.addListener(this.btn_save, MouseEvent.CLICK, this.savePreset);
            };
            this.equippedSkill = this.skillPreset[(int(this.selectedPreset) - 1)].skills.split(",");
            Character.character_skill_set = this.skillPreset[(int(this.selectedPreset) - 1)].skills;
            this.resetEquippedIconHolder();
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.loadSwf();
            this.loadEquippedSkills();
        }

        public function savePreset(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.saveSkillSet", [Character.char_id, Character.sessionkey, this.skillPreset[(this.selectedPreset - 1)].id, this.equippedSkill.join(",")], this.savePresetResponse);
        }

        public function savePresetResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.skillPreset = _arg_1.skillsets;
                Character.character_equipped_skills = this.equippedSkill.join(",");
                Character.character_skill_set = this.equippedSkill.join(",");
                this.main.showMessage("Preset has been saved");
            }
            else
            {
                if (_arg_1.result != null)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                    this.destroy();
                };
            };
            this.loadEquippedSkills();
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.loadSwf();
        }

        public function buyConfirmation(_arg_1:MouseEvent):*
        {
            if (Character.account_type == 1)
            {
                this.cost = 200;
            }
            else
            {
                this.cost = 600;
            };
            if (this.skillPreset.length == 0)
            {
                this.cost = 0;
            };
            this.confirmation = (getDefinitionByName("Popups.Confirmation") as Class);
            this.confirmation = new this.confirmation();
            this.confirmation.txtMc.txt.text = (("Are you sure want to unlock new preset for " + this.cost) + " token?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.closeConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.buyPreset);
            addChild(this.confirmation);
        }

        public function closeConfirmation(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
        }

        public function buyPreset(_arg_1:MouseEvent):*
        {
            removeChild(this.confirmation);
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.createSkillSet", [Character.char_id, Character.sessionkey], this.buyPresetResponse);
        }

        public function buyPresetResponse(_arg_1:Object):*
        {
            var _local_2:*;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage("Slot succesfully bought");
                this.skillPreset = _arg_1.skillsets;
                _local_2 = 1;
                while (_local_2 < (this.skillPreset.length + 1))
                {
                    this[("btn_preset_" + String(_local_2))].visible = true;
                    if (!this[("btn_preset_" + String(_local_2))].hasEventListener(MouseEvent.CLICK))
                    {
                        this.eventHandler.addListener(this[("btn_preset_" + String(_local_2))], MouseEvent.CLICK, this.changePreset);
                    };
                    _local_2++;
                };
                if (this.skillPreset.length == 4)
                {
                    this.btn_add_preset.visible = false;
                };
                if (this.skillPreset.length >= 1)
                {
                    this.btn_help.visible = true;
                };
                Character.account_tokens = (int(Character.account_tokens) - this.cost);
                this.main.HUD.setBasicData();
            }
            else
            {
                if (_arg_1.result)
                {
                    this.main.getNotice(_arg_1.result);
                };
            };
        }

        public function showHelp(_arg_1:MouseEvent):*
        {
            this.main.getNotice("You must select your preset first before editing skill preset and press Save Skill Button after editing skills, otherwise it won't be saved to your preset.");
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
            this.txt_page.text = ((this.currentPage + "/") + this.totalPage);
        }

        public function initButton():*
        {
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.btn_clear, MouseEvent.CLICK, this.removeAllEquippedSkill);
            this.eventHandler.addListener(this.btn_to_page, MouseEvent.CLICK, this.goToPage);
            this.eventHandler.addListener(this.btn_search, MouseEvent.CLICK, this.searchItem);
            this.eventHandler.addListener(this.btn_clearSearch, MouseEvent.CLICK, this.onSearchClear);
            this.eventHandler.addListener(this.btn_ResetSkill, MouseEvent.CLICK, this.openExternalPanel);
            this.eventHandler.addListener(this.btn_preview, MouseEvent.CLICK, this.loadSkillAndPreview);
            this.eventHandler.addListener(this.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.btn_add_preset, MouseEvent.CLICK, this.buyConfirmation);
            this.eventHandler.addListener(this.btn_help, MouseEvent.CLICK, this.showHelp);
            this.eventHandler.addListener(this.btn_filter, MouseEvent.CLICK, this.handleSearchFilter);
            NinjaSage.showDynamicTooltip(this.btn_filter.filter_on, "Search by description");
            NinjaSage.showDynamicTooltip(this.btn_filter.filter_off, "Search by name");
        }

        public function setElementCategory():*
        {
            var _local_1:* = 0;
            while (_local_1 < 3)
            {
                this[("element_mc" + _local_1)].visible = false;
                this[("element_mc" + _local_1)].gotoAndStop(1);
                if (Character[("character_element_" + (_local_1 + 1))] > 0)
                {
                    this[("element_mc" + _local_1)].visible = true;
                    this[("element_mc" + _local_1)].gotoAndStop(Character[("character_element_" + (_local_1 + 1))]);
                    this[("element_mc" + _local_1)].element.gotoAndStop(1);
                    NinjaSage.showDynamicTooltip(this[("element_mc" + _local_1)].element, this.getElementName(Character[("character_element_" + (_local_1 + 1))]));
                    this.eventHandler.addListener(this[("element_mc" + _local_1)].element, MouseEvent.CLICK, this.changeCategory);
                    this.eventHandler.addListener(this[("element_mc" + _local_1)].element, MouseEvent.MOUSE_OVER, this.over);
                    this.eventHandler.addListener(this[("element_mc" + _local_1)].element, MouseEvent.MOUSE_OUT, this.out);
                };
                _local_1++;
            };
            var _local_2:Array = ["Taijutsu", "Genjutsu", "Clan", "Shadow War", "Package", "Leaderboard", "Spending"];
            _local_1 = 3;
            while (_local_1 < 10)
            {
                this[("element_mc" + _local_1)].gotoAndStop(1);
                NinjaSage.showDynamicTooltip(this[("element_mc" + _local_1)], _local_2[(_local_1 - 3)]);
                this.eventHandler.addListener(this[("element_mc" + _local_1)], MouseEvent.CLICK, this.changeCategory);
                this.eventHandler.addListener(this[("element_mc" + _local_1)], MouseEvent.MOUSE_OVER, this.over);
                this.eventHandler.addListener(this[("element_mc" + _local_1)], MouseEvent.MOUSE_OUT, this.out);
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
                case "element_mc5":
                    this.selectedCategory = this.getElementSkillsArray(8);
                    break;
                case "element_mc6":
                    this.selectedCategory = this.getElementSkillsArray(9);
                    break;
                case "element_mc7":
                    this.selectedCategory = this.getElementSkillsArray(10);
                    break;
                case "element_mc8":
                    this.selectedCategory = this.getElementSkillsArray(11);
                    break;
                case "element_mc9":
                    this.selectedCategory = this.getElementSkillsArray(12);
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
                case 8:
                    this.currentElement = "clan";
                    return (this.clanSkills);
                case 9:
                    this.currentElement = "shadowwar";
                    return (this.shadowwarSkills);
                case 10:
                    this.currentElement = "package";
                    return (this.packageSkills);
                case 11:
                    this.currentElement = "leaderboard";
                    return (this.leaderboardSkills);
                case 12:
                    this.currentElement = "spending";
                    return (this.spendingSkills);
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
                "genjutsuSkills":SkillLibrary.getSkillIds("7"),
                "clanSkills":SkillLibrary.getSkillByCategory("clan"),
                "shadowwarSkills":SkillLibrary.getSkillByCategory("shadowwar"),
                "packageSkills":SkillLibrary.getSkillByCategory("package"),
                "leaderboardSkills":SkillLibrary.getSkillByCategory("leaderboard"),
                "spendingSkills":SkillLibrary.getSkillByCategory("spending")
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
        }

        public function resetAllElementsTab():*
        {
            this.element_mc0.element.gotoAndStop(1);
            this.element_mc1.element.gotoAndStop(1);
            this.element_mc2.element.gotoAndStop(1);
            var _local_1:* = 3;
            while (_local_1 < 10)
            {
                this[("element_mc" + _local_1)].gotoAndStop(1);
                _local_1++;
            };
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
                GF.removeAllChild(this[("item_" + _local_1)].iconMC.iconHolder);
                this[("item_" + _local_1)].visible = false;
                this[("item_" + _local_1)].gotoAndStop(1);
                delete this[("item_" + _local_1)].tooltip;
                delete this[("item_" + _local_1)].tooltipCache;
                this.eventHandler.removeListener(this[("item_" + _local_1)]["btn_equip_skill"], MouseEvent.CLICK, this.equipSkill);
                this.eventHandler.removeListener(this[("item_" + _local_1)], MouseEvent.CLICK, this.showSkillDetail);
                this.eventHandler.removeListener(this[("item_" + _local_1)], MouseEvent.ROLL_OVER, this.toolTiponOver);
                this.eventHandler.removeListener(this[("item_" + _local_1)], MouseEvent.ROLL_OUT, this.toolTiponOut);
                _local_1++;
            };
        }

        public function resetEquippedIconHolder():*
        {
            this.switchSkillIndexHolder = [];
            var _local_1:* = 0;
            while (_local_1 < 8)
            {
                GF.removeAllChild(this[("skill_" + _local_1)].iconHolder);
                this[("skill_" + _local_1)].selected = false;
                this[("skill_" + _local_1)].filters = null;
                delete this[("skill_" + _local_1)].tooltip;
                delete this[("skill_" + _local_1)].tooltipCache;
                this.eventHandler.removeListener(this[("btn_close_slot" + _local_1)], MouseEvent.CLICK, this.removeEquippedSkill);
                this.eventHandler.removeListener(this[("skill_" + _local_1)], MouseEvent.MOUSE_OVER, this.toolTiponOver);
                this.eventHandler.removeListener(this[("skill_" + _local_1)], MouseEvent.MOUSE_OUT, this.toolTiponOut);
                this.eventHandler.removeListener(this[("skill_" + _local_1)], MouseEvent.CLICK, this.selectSwitchingSkill);
                _local_1++;
            };
        }

        public function resetSkillDetail():*
        {
            this.skillInfoMC.visible = false;
            this.btn_preview.visible = false;
            this.selectedSkill = null;
            this.skillInfoMC.txt_name.text = "";
            this.skillInfoMC.txt_level.text = "";
            this.skillInfoMC.txt_cp.text = "";
            this.skillInfoMC.txt_dmg.text = "";
            this.skillInfoMC.txt_cd.text = "";
            this.skillInfoMC.txt_description.text = "";
            GF.removeAllChild(this.skillInfoMC.iconMC.iconHolder);
        }

        public function resetPreviewHolder():void
        {
            if (this.previewMC)
            {
                this.previewMC.destroy();
            };
            this.previewMC = null;
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
            stage.addChild(this.tooltip);
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
                this.main.getNotice("Equipped skill cannot empty");
                return;
            };
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.equipSkillSet", [Character.char_id, Character.sessionkey, this.equippedSkill.join(",")], this.equipResponse);
        }

        public function equipResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.character_equipped_skills = this.equippedSkill.join(",");
                Character.character_skill_set = this.equippedSkill.join(",");
                this.destroy();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.getNotice(((_arg_1.result) || ("Equipped skill cannot empty")));
                }
                else
                {
                    this.main.getError(_arg_1.error);
                    this.destroy();
                };
            };
        }

        public function destroy():*
        {
            var _local_1:* = 0;
            while (_local_1 < 10)
            {
                NinjaSage.clearDynamicTooltip(this[("element_mc" + _local_1)]);
                _local_1++;
            };
            GF.removeAllChild(this.skillInfoMC.iconMC.iconHolder);
            this.resetPreviewHolder();
            this.resetSkillDetail();
            this.resetIconHolder();
            this.resetEquippedIconHolder();
            NinjaSage.clearDynamicTooltip(this.btn_filter.filter_on);
            NinjaSage.clearDynamicTooltip(this.btn_filter.filter_off);
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.loaderSwf.clear();
            OutfitManager.clearStaticMc();
            BulkLoader.getLoader("assets").removeAll();
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
            this.previewMC = null;
            this.main = null;
            System.gc();
            GF.removeAllChild(this);
        }


    }
}//package Panels

