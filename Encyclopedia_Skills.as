// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Encyclopedia_Skills

package Panels
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.display.SimpleButton;
    import Storage.SkillLibrary;
    import br.com.stimuli.loading.BulkLoader;
    import Managers.PreviewManager;
    import com.abrahamyan.liquid.ToolTip;
    import id.ninjasage.EventHandler;
    import flash.events.ErrorEvent;
    import Storage.Character;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.utils.GF;
    import Managers.NinjaSage;
    import flash.utils.getTimer;
    import Popups.Confirmation;
    import Managers.OutfitManager;
    import flash.system.System;

    public dynamic class Encyclopedia_Skills extends MovieClip 
    {

        public var bg:MovieClip;
        public var txt_title:TextField;
        public var btn_clearSearch:SimpleButton;
        public var btn_close:SimpleButton;
        public var btn_next:SimpleButton;
        public var btn_prev:SimpleButton;
        public var btn_preview:SimpleButton;
        public var btn_save:SimpleButton;
        public var btn_search:SimpleButton;
        public var btn_to_page:SimpleButton;
        public var btn_element_0:MovieClip;
        public var btn_element_1:MovieClip;
        public var btn_element_2:MovieClip;
        public var btn_element_3:MovieClip;
        public var btn_element_4:MovieClip;
        public var btn_element_5:MovieClip;
        public var btn_element_6:MovieClip;
        public var btn_element_7:MovieClip;
        public var btn_element_8:MovieClip;
        public var btn_element_9:MovieClip;
        public var btn_filter:MovieClip;
        public var skill_0:MovieClip;
        public var skill_1:MovieClip;
        public var skill_2:MovieClip;
        public var skill_3:MovieClip;
        public var skill_4:MovieClip;
        public var skill_5:MovieClip;
        public var skill_6:MovieClip;
        public var preview:MovieClip;
        public var skillInfoMC:MovieClip;
        public var txt_goToPage:TextField;
        public var txt_page:TextField;
        public var txt_search:TextField;
        public var windSkills:Array = SkillLibrary.getEncyIds("1");
        public var waterSkills:Array = SkillLibrary.getEncyIds("5");
        public var fireSkills:Array = SkillLibrary.getEncyIds("2");
        public var thunderSkills:Array = SkillLibrary.getEncyIds("3");
        public var earthSkills:Array = SkillLibrary.getEncyIds("4");
        public var taijutsuSkills:Array = SkillLibrary.getEncyIds("6");
        public var genjutsuSkills:Array = SkillLibrary.getEncyIds("7");
        public var talentSkills:Array = SkillLibrary.getEncyIds("9");
        public var specialSkills:Array = SkillLibrary.getEncyIds("10");
        public var senjutsuSkills:Array = SkillLibrary.getEncyIds("11");
        public var selectedCategory:Array;
        public var skillIconMC:Array = [];
        public var equippedSkill:Array = [];
        public var currentPage:int = 1;
        public var totalPage:int = 1;
        public var skillIndex:int = 0;
        public var skillLoading:int = 0;
        public var skillCount:int = 0;
        public var selectedSkill:String;
        public var currentElement:String;
        public var eventHandler:*;
        public var tooltip:*;
        public var main:*;
        public var loaderSwf:* = BulkLoader.createUniqueNamedLoader(12);
        public var confirmation:*;
        public var previewMC:PreviewManager;
        public var iconMCDetail:MovieClip;
        public var isDescription:Boolean = false;
        public var skill_info:Object;
        public var learnClickCount:int = 0;
        public var learnClickLast:int = 0;
        public var learnClickSkill:String;

        public function Encyclopedia_Skills(param1:*)
        {
            this.main = param1;
            this.tooltip = ToolTip.getInstance();
            this.eventHandler = new EventHandler();
            this.setElementCategory();
            this.initButton();
            this.initUI();
        }

        public function initUI():void
        {
            this.preview.visible = false;
            this.skillInfoMC.visible = false;
            this.skillInfoMC.btn_preview.visible = false;
            this.btn_filter.filter_on.visible = false;
            this.txt_goToPage.restrict = "0-9";
            this.selectedCategory = this.getElementSkillsArray(1);
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.selectedCategory.length / 7)), 1);
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.loadSwf();
        }

        public function loadSwf():void
        {
            var _loc1_:*;
            var _loc2_:*;
            var _loc3_:*;
            this.isLoading = true;
            if (this.skillIndex < this.skillLoading)
            {
                _loc1_ = this.selectedCategory[this.skillIndex];
                _loc2_ = (("skills/" + _loc1_) + ".swf");
                _loc3_ = this.loaderSwf.add(_loc2_);
                _loc3_.addEventListener(BulkLoader.COMPLETE, this.completeIcon);
                _loc3_.addEventListener(BulkLoader.ERROR, this.onItemLoadError);
                this.loaderSwf.start();
                return;
            };
            this.isLoading = false;
        }

        public function onItemLoadError(param1:ErrorEvent):void
        {
            param1.currentTarget.removeEventListener(param1.type, arguments.callee);
            param1.currentTarget.removeEventListener(BulkLoader.COMPLETE, this.completeIcon);
            this.skillIconMC[this.skillCount] = null;
            this.skillIndex++;
            this.skillCount++;
            this.loadSwf();
        }

        public function completeIcon(param1:Event):void
        {
            param1.currentTarget.removeEventListener(param1.type, arguments.callee);
            param1.currentTarget.removeEventListener(BulkLoader.ERROR, this.onItemLoadError);
            var _loc3_:MovieClip;
            _loc3_ = param1.target.content.icon;
            if ((!(Character.play_items_animation)))
            {
                _loc3_.stopAllMovieClips();
            };
            this.skillIconMC.push(_loc3_);
            this[("skill_" + this.skillCount)].iconMC.iconHolder.addChild(_loc3_);
            this[("skill_" + this.skillCount)].gotoAndStop(1);
            this[("skill_" + this.skillCount)].visible = true;
            var _loc4_:* = this.selectedCategory[this.skillIndex];
            if (param1.target.content[_loc4_])
            {
                param1.target.content[_loc4_].gotoAndStop(1);
            };
            var _loc5_:* = SkillLibrary.getSkillInfo(_loc4_);
            this[("skill_" + this.skillCount)].txt_name.text = _loc5_["skill_name"];
            this[("skill_" + this.skillCount)].txt_level.text = _loc5_["skill_level"];
            this[("skill_" + this.skillCount)]["txt_learned"].visible = ((this.hasSkill(_loc4_) >= 1) ? true : false);
            this[("skill_" + this.skillCount)].emblemMC.visible = ((_loc5_.skill_premium) ? true : false);
            this[("skill_" + this.skillCount)].tooltip = _loc5_;
            this.eventHandler.addListener(this[("skill_" + this.skillCount)], MouseEvent.CLICK, this.showSkillDetail);
            this.eventHandler.addListener(this[("skill_" + this.skillCount)], MouseEvent.ROLL_OVER, this.toolTiponOver);
            this.eventHandler.addListener(this[("skill_" + this.skillCount)], MouseEvent.ROLL_OUT, this.toolTiponOut);
            this.skillIndex++;
            this.skillCount++;
            this.loadSwf();
        }

        public function showSkillDetail(param1:MouseEvent):void
        {
            var _loc2_:* = 0;
            while (_loc2_ < 7)
            {
                this[("skill_" + _loc2_)].gotoAndStop(1);
                _loc2_++;
            };
            param1.currentTarget.gotoAndStop(3);
            this.resetSkillDetail();
            var _loc3_:* = param1.currentTarget.name.replace("skill_", "");
            var _loc4_:* = param1.currentTarget.tooltip;
            this.selectedSkill = _loc4_.skill_id;
            this.skillInfoMC.visible = true;
            if ((((((((_loc4_.skill_cooldown > 0) || (this.selectedSkill == "skill_1023")) || (this.selectedSkill == "skill_1050")) || (this.selectedSkill == "skill_3000")) || (this.selectedSkill == "skill_3006")) || (this.selectedSkill == "skill_3107")) || (_loc4_.skill_type == 10)))
            {
                this.skillInfoMC.btn_preview.visible = true;
            };
            GF.removeAllChild(this.skillInfoMC.iconMC.iconHolder);
            NinjaSage.loadItemIcon(this.skillInfoMC.iconMC.iconHolder, this.selectedSkill, "icon");
            this.skillInfoMC.iconType.gotoAndStop(_loc4_.skill_type);
            this.skillInfoMC.txt_name.text = _loc4_.skill_name;
            this.skillInfoMC.txt_level.text = _loc4_.skill_level;
            this.skillInfoMC.emblemMC.visible = _loc4_.skill_premium;
            var _loc5_:int = int(_loc4_.skill_damage);
            var _loc6_:int = int(_loc4_.skill_cp_cost);
            if (_loc4_.skill_type == 9)
            {
                _loc5_ = Math.floor((_loc4_.skill_damage * int(Character.character_lvl)));
                _loc6_ = Math.floor((_loc4_.skill_cp_cost * int(Character.character_lvl)));
            };
            this.skillInfoMC.txt_cp.text = _loc6_;
            this.skillInfoMC.txt_dmg.text = _loc5_;
            this.skillInfoMC.txt_cd.text = _loc4_.skill_cooldown;
            this.skillInfoMC.txt_description.text = _loc4_.skill_description;
            this.handleLearnMultiClick();
        }

        public function loadSkillAndPreview(param1:MouseEvent):void
        {
            this.main.loading(true);
            this.resetPreviewHolder();
            var _loc2_:* = (("skills/" + this.selectedSkill) + ".swf");
            var _loc3_:* = this.loaderSwf.add(_loc2_);
            _loc3_.addEventListener(BulkLoader.COMPLETE, this.completePreview);
            this.loaderSwf.start();
        }

        public function completePreview(param1:Event):void
        {
            param1.currentTarget.removeEventListener(param1.type, arguments.callee);
            this.skill_info = SkillLibrary.getSkillInfo(this.selectedSkill);
            var _loc3_:* = param1.target.content[this.selectedSkill];
            this.previewMC = new PreviewManager(this.main, _loc3_, this.skill_info);
            try
            {
                param1.target.loader.unloadAndStop(true);
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

        public function handleReplay(param1:MouseEvent):void
        {
            this.previewMC.preview_mc.gotoAndPlay(2);
        }

        public function closePreview(param1:MouseEvent):void
        {
            this.resetPreviewHolder();
            this.preview.visible = false;
            GF.removeAllChild(this.preview.skillMc);
        }

        public function handleSearchFilter(param1:MouseEvent):void
        {
            this.btn_filter.filter_on.visible = (!(this.btn_filter.filter_on.visible));
            this.isDescription = ((this.btn_filter.filter_on.visible) ? true : false);
        }

        public function searchItem(param1:MouseEvent):void
        {
            var _loc4_:*;
            var _loc5_:*;
            if (this.txt_search.text == "")
            {
                return;
            };
            this.setDefaultArray();
            var _loc2_:Array = [];
            var _loc3_:String = this.txt_search.text.toLowerCase();
            var _loc6_:* = 0;
            while (_loc6_ < this.selectedCategory.length)
            {
                _loc5_ = this.selectedCategory[_loc6_];
                _loc4_ = SkillLibrary.getSkillInfo(_loc5_);
                if (this.isDescription)
                {
                    if ((((_loc4_) && (Boolean(_loc4_.hasOwnProperty("skill_description")))) && (_loc4_["skill_description"].toLowerCase().indexOf(_loc3_) >= 0)))
                    {
                        _loc2_.push(this.selectedCategory[_loc6_]);
                    };
                }
                else
                {
                    if ((((_loc4_) && (Boolean(_loc4_.hasOwnProperty("skill_name")))) && (_loc4_["skill_name"].toLowerCase().indexOf(_loc3_) >= 0)))
                    {
                        _loc2_.push(this.selectedCategory[_loc6_]);
                    };
                };
                _loc6_++;
            };
            this.selectedCategory = _loc2_;
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.selectedCategory.length / 7)), 1);
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.loadSwf();
        }

        public function onSearchClear(param1:MouseEvent=null):void
        {
            this.txt_search.text = "";
            this.txt_goToPage.text = "";
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.selectedCategory.length / 7)), 1);
            this.setDefaultArray();
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.loadSwf();
        }

        public function goToPage(param1:MouseEvent):void
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

        public function changePage(param1:MouseEvent):void
        {
            if (this.isLoading)
            {
                return;
            };
            switch (param1.currentTarget.name)
            {
                case "btn_next":
                default:
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.loadSwf();
                        break;
                    };
                    return;
                case "btn_prev":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.loadSwf();
                        break;
                    };
                    return;
            };
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            if (this.loaderSwf.itemsLoaded >= 35)
            {
                this.loaderSwf.removeAll();
            };
            this.loadSwf();
        }

        public function updatePageNumber():void
        {
            this.txt_page.text = ((this.currentPage + "/") + this.totalPage);
        }

        public function initButton():void
        {
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.btn_to_page, MouseEvent.CLICK, this.goToPage);
            this.eventHandler.addListener(this.btn_search, MouseEvent.CLICK, this.searchItem);
            this.eventHandler.addListener(this.btn_clearSearch, MouseEvent.CLICK, this.onSearchClear);
            this.eventHandler.addListener(this.skillInfoMC.btn_preview, MouseEvent.CLICK, this.loadSkillAndPreview);
            this.eventHandler.addListener(this.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.btn_filter, MouseEvent.CLICK, this.handleSearchFilter);
            NinjaSage.showDynamicTooltip(this.btn_filter.filter_on, "Search by description");
            NinjaSage.showDynamicTooltip(this.btn_filter.filter_off, "Search by name");
        }

        public function setElementCategory():void
        {
            var _loc1_:Array = ["Wind", "Fire", "Lightning", "Earth", "Water", "Taijutsu", "Genjutsu", "Talent", "Special Class", "Senjutsu"];
            var _loc2_:int;
            while (_loc2_ < _loc1_.length)
            {
                this[("btn_element_" + _loc2_)].gotoAndStop(1);
                NinjaSage.showDynamicTooltip(this[("btn_element_" + _loc2_)], _loc1_[_loc2_]);
                this.eventHandler.addListener(this[("btn_element_" + _loc2_)], MouseEvent.CLICK, this.changeCategory);
                this.eventHandler.addListener(this[("btn_element_" + _loc2_)], MouseEvent.ROLL_OVER, this.over);
                this.eventHandler.addListener(this[("btn_element_" + _loc2_)], MouseEvent.ROLL_OUT, this.out);
                _loc2_++;
            };
        }

        public function changeCategory(param1:MouseEvent):void
        {
            if (this.isLoading)
            {
                return;
            };
            this.resetAllElementsTab();
            param1.currentTarget.gotoAndStop(3);
            var _loc2_:* = ((param1.currentTarget.name == "element") ? param1.currentTarget.parent.name : param1.currentTarget.name);
            switch (_loc2_)
            {
                case "btn_element_0":
                default:
                    this.selectedCategory = this.getElementSkillsArray(1);
                    this.txt_title.text = "Encyclopedia - Wind Jutsu";
                    break;
                case "btn_element_1":
                    this.selectedCategory = this.getElementSkillsArray(2);
                    this.txt_title.text = "Encyclopedia - Fire Jutsu";
                    break;
                case "btn_element_2":
                    this.selectedCategory = this.getElementSkillsArray(3);
                    this.txt_title.text = "Encyclopedia - Lightning Jutsu";
                    break;
                case "btn_element_3":
                    this.selectedCategory = this.getElementSkillsArray(4);
                    this.txt_title.text = "Encyclopedia - Earth Jutsu";
                    break;
                case "btn_element_4":
                    this.selectedCategory = this.getElementSkillsArray(5);
                    this.txt_title.text = "Encyclopedia - Water Jutsu";
                    break;
                case "btn_element_5":
                    this.selectedCategory = this.getElementSkillsArray(6);
                    this.txt_title.text = "Encyclopedia - Taijutsu";
                    break;
                case "btn_element_6":
                    this.selectedCategory = this.getElementSkillsArray(7);
                    this.txt_title.text = "Encyclopedia - Genjutsu";
                    break;
                case "btn_element_7":
                    this.selectedCategory = this.getElementSkillsArray(9);
                    this.txt_title.text = "Encyclopedia - Talent";
                    break;
                case "btn_element_8":
                    this.selectedCategory = this.getElementSkillsArray(10);
                    this.txt_title.text = "Encyclopedia - Special Class";
                    break;
                case "btn_element_9":
                    this.selectedCategory = this.getElementSkillsArray(11);
                    this.txt_title.text = "Encyclopedia - Senjutsu";
            };
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.selectedCategory.length / 7)), 1);
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.resetSkillDetail();
            this.loadSwf();
        }

        public function getElementSkillsArray(param1:int):Array
        {
            switch (param1)
            {
                case 1:
                default:
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
                case 9:
                    this.currentElement = "talent";
                    return (this.talentSkills);
                case 10:
                    this.currentElement = "special";
                    return (this.specialSkills);
                case 11:
                    this.currentElement = "senjutsu";
                    return (this.senjutsuSkills);
                    return ([]);
            };
            return (undefined); //dead code
        }

        public function getElementName(param1:int):String
        {
            switch (param1)
            {
                case 1:
                default:
                    return ("Wind");
                case 2:
                    return ("Fire");
                case 3:
                    return ("Lightning");
                case 4:
                    return ("Earth");
                case 5:
                    return ("Water");
                    return ("No Element");
            };
            return (undefined); //dead code
        }

        public function hasSkill(param1:String):int
        {
            if (Character.character_skills == "")
            {
                return (0);
            };
            var _loc2_:Array = Character.character_skills.split(",");
            return ((_loc2_.indexOf(param1) >= 0) ? 1 : 0);
        }

        public function over(param1:MouseEvent):void
        {
            if (param1.currentTarget.currentFrame !== 3)
            {
                param1.currentTarget.gotoAndStop(2);
            };
        }

        public function out(param1:MouseEvent):void
        {
            if (param1.currentTarget.currentFrame !== 3)
            {
                param1.currentTarget.gotoAndStop(1);
            };
        }

        public function setDefaultArray():void
        {
            switch (this.currentElement)
            {
                case "wind":
                default:
                    this.selectedCategory = this.windSkills;
                    return;
                case "water":
                    this.selectedCategory = this.waterSkills;
                    return;
                case "fire":
                    this.selectedCategory = this.fireSkills;
                    return;
                case "thunder":
                    this.selectedCategory = this.thunderSkills;
                    return;
                case "earth":
                    this.selectedCategory = this.earthSkills;
                    return;
                case "taijutsu":
                    this.selectedCategory = this.taijutsuSkills;
                    return;
                case "genjutsu":
                    this.selectedCategory = this.genjutsuSkills;
                    return;
                case "talent":
                    this.selectedCategory = this.talentSkills;
                    return;
                case "special":
                    this.selectedCategory = this.specialSkills;
                    return;
                case "senjutsu":
                    this.selectedCategory = this.senjutsuSkills;
            };
        }

        public function resetAllElementsTab():void
        {
            var _loc1_:int;
            while (_loc1_ < 10)
            {
                this[("btn_element_" + _loc1_)].gotoAndStop(1);
                _loc1_++;
            };
        }

        public function resetRecursiveProperty():void
        {
            this.skillLoading = (this.currentPage * 7);
            if (this.selectedCategory.length < this.skillLoading)
            {
                this.skillLoading = this.selectedCategory.length;
            };
            this.skillIndex = ((this.currentPage - 1) * 7);
            this.skillCount = 0;
            this.equippedCount = 0;
        }

        public function resetIconHolder():void
        {
            var _loc1_:* = 0;
            while (_loc1_ < this.skillIconMC.length)
            {
                GF.removeAllChild(this.skillIconMC[_loc1_]);
                _loc1_++;
            };
            this.skillIconMC = [];
            _loc1_ = 0;
            while (_loc1_ < 7)
            {
                GF.removeAllChild(this[("skill_" + _loc1_)].iconMC.iconHolder);
                this[("skill_" + _loc1_)].gotoAndStop(1);
                this[("skill_" + _loc1_)].visible = false;
                delete this[("skill_" + _loc1_)].tooltip;
                delete this[("skill_" + _loc1_)].tooltipCache;
                this.eventHandler.removeListener(this[("skill_" + _loc1_)]["btn_equip_skill"], MouseEvent.CLICK, this.equipSkill);
                this.eventHandler.removeListener(this[("skill_" + _loc1_)], MouseEvent.CLICK, this.showSkillDetail);
                this.eventHandler.removeListener(this[("skill_" + _loc1_)], MouseEvent.ROLL_OVER, this.toolTiponOver);
                this.eventHandler.removeListener(this[("skill_" + _loc1_)], MouseEvent.ROLL_OUT, this.toolTiponOut);
                _loc1_++;
            };
        }

        public function resetSkillDetail():void
        {
            var _loc1_:* = null;
            if (this.previewMC)
            {
                if (("destroy" in this.previewMC))
                {
                    this.previewMC.destroy();
                };
                this.previewMC = null;
            };
            this.skillInfoMC.visible = false;
            this.skillInfoMC.btn_preview.visible = false;
            this.skillInfoMC.emblemMC.visible = false;
            this.selectedSkill = null;
            this.skillInfoMC.txt_name.text = "";
            this.skillInfoMC.txt_level.text = "";
            this.skillInfoMC.txt_cp.text = "";
            this.skillInfoMC.txt_dmg.text = "";
            this.skillInfoMC.txt_cd.text = "";
            this.skillInfoMC.txt_description.text = "";
            GF.removeAllChild(this.skillInfoMC.iconMC.iconHolder);
            GF.removeAllChild(this.iconMCDetail);
            this.iconMCDetail = null;
        }

        public function handleLearnMultiClick():void
        {
            if (((this.selectedSkill == null) || (this.hasSkill(this.selectedSkill) >= 1)))
            {
                this.learnClickCount = 0;
                this.learnClickLast = 0;
                this.learnClickSkill = null;
                return;
            };
            var _loc1_:int = getTimer();
            if (((!(this.learnClickSkill == this.selectedSkill)) || ((_loc1_ - this.learnClickLast) > 800)))
            {
                this.learnClickCount = 0;
            };
            this.learnClickSkill = this.selectedSkill;
            this.learnClickLast = _loc1_;
            this.learnClickCount++;
            if (this.learnClickCount >= 5)
            {
                this.learnClickCount = 0;
                this.openLearnConfirmation();
            };
        }

        public function openLearnConfirmation():void
        {
            if (this.confirmation)
            {
                this.closeLearnConfirmation();
            };
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Do you want to learn this skill?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.closeLearnConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onLearnConfirm);
            this.addChild(this.confirmation);
        }

        public function closeLearnConfirmation(param1:MouseEvent=null):void
        {
            if ((!(this.confirmation)))
            {
                return;
            };
            this.eventHandler.removeListener(this.confirmation.btn_close, MouseEvent.CLICK, this.closeLearnConfirmation);
            this.eventHandler.removeListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onLearnConfirm);
            if (this.contains(this.confirmation))
            {
                this.removeChild(this.confirmation);
            };
            this.confirmation = null;
        }

        public function onLearnConfirm(param1:MouseEvent):void
        {
            this.closeLearnConfirmation();
            this.learnSkillRequest();
        }

        public function learnSkillRequest():void
        {
            if (((this.selectedSkill == null) || (this.hasSkill(this.selectedSkill) >= 1)))
            {
                return;
            };
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.learnSkill", [Character.char_id, Character.sessionkey, this.selectedSkill], this.learnSkillResponse);
        }

        public function learnSkillResponse(param1:Object):void
        {
            this.main.loading(false);
            if (param1.status == 1)
            {
                this.addCharacterSkill(this.selectedSkill);
                if (param1.hasOwnProperty("data"))
                {
                    if (param1.data.hasOwnProperty("character_element_1"))
                    {
                        Character.character_element_1 = param1.data.character_element_1;
                    };
                    if (param1.data.hasOwnProperty("character_element_2"))
                    {
                        Character.character_element_2 = param1.data.character_element_2;
                    };
                    if (param1.data.hasOwnProperty("character_element_3"))
                    {
                        Character.character_element_3 = param1.data.character_element_3;
                    };
                };
                this.markSkillLearned(this.selectedSkill);
                if (param1.hasOwnProperty("result"))
                {
                    this.main.showMessage(param1.result);
                };
            }
            else
            {
                if (param1.status == 2)
                {
                    this.main.getNotice("You already own this skill.");
                }
                else
                {
                    if (param1.status == 4)
                    {
                        this.main.getNotice("You cannot learn jutsu from this element.");
                    }
                    else
                    {
                        if (param1.status == 5)
                        {
                            this.main.getNotice("Your level is not high enough for this item.");
                        }
                        else
                        {
                            this.main.getError(param1.error);
                        };
                    };
                };
            };
        }

        public function addCharacterSkill(param1:String):void
        {
            if (((param1 == null) || (param1 == "")))
            {
                return;
            };
            if (Character.character_skills == "")
            {
                Character.character_skills = param1;
                return;
            };
            if (Character.character_skills.indexOf(param1) >= 0)
            {
                return;
            };
            Character.character_skills = ((Character.character_skills + ",") + param1);
        }

        public function markSkillLearned(param1:String):void
        {
            var _loc2_:int;
            while (_loc2_ < 7)
            {
                if (((this[("skill_" + _loc2_)].hasOwnProperty("tooltip")) && (this[("skill_" + _loc2_)].tooltip.skill_id == param1)))
                {
                    this[("skill_" + _loc2_)]["txt_learned"].visible = true;
                    this[("skill_" + _loc2_)].gotoAndStop(1);
                };
                _loc2_++;
            };
        }

        public function resetPreviewHolder():void
        {
            if (this.previewMC)
            {
                this.previewMC.destroy();
            };
            this.previewMC = null;
        }

        public function toolTiponOver(param1:MouseEvent):void
        {
            var _loc3_:Object;
            var _loc4_:int;
            var _loc5_:int;
            var _loc6_:String;
            if (param1.currentTarget.currentFrame !== 3)
            {
                param1.currentTarget.gotoAndStop(2);
            };
            var _loc2_:MovieClip = (param1.currentTarget as MovieClip);
            if ((!(_loc2_.tooltipCache)))
            {
                _loc3_ = _loc2_.tooltip;
                if ((!(_loc3_)))
                {
                    return;
                };
                _loc4_ = int(_loc3_.skill_damage);
                _loc5_ = int(_loc3_.skill_cp_cost);
                if (_loc3_.skill_type == 9)
                {
                    _loc4_ = Math.floor((_loc3_.skill_damage * int(Character.character_lvl)));
                    _loc5_ = Math.floor((_loc3_.skill_cp_cost * int(Character.character_lvl)));
                };
                _loc6_ = ((((((((((_loc3_.skill_name + "\n(Skill)\n\nLevel ") + _loc3_.skill_level) + '\n<font color="#ff0000">Damage: ') + _loc4_) + '</font>\n<font color="#0000ff">CP Cost: ') + _loc5_) + '</font>\n<font color="#ffcc00">Cooldown: ') + _loc3_.skill_cooldown) + "</font>\n\n") + _loc3_.skill_description);
                _loc2_.tooltipCache = _loc6_;
            };
            stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_loc2_.tooltipCache);
        }

        public function toolTiponOut(param1:MouseEvent):void
        {
            if (param1.currentTarget.currentFrame !== 3)
            {
                param1.currentTarget.gotoAndStop(1);
            };
            this.tooltip.hide();
        }

        public function closePanel(param1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            var _loc1_:* = 0;
            while (_loc1_ < 10)
            {
                NinjaSage.clearDynamicTooltip(this[("btn_element_" + _loc1_)]);
                _loc1_++;
            };
            this.resetPreviewHolder();
            this.resetSkillDetail();
            this.resetIconHolder();
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
            this.talentSkills = [];
            this.specialSkills = [];
            this.senjutsuSkills = [];
            this.selectedCategory = [];
            this.skillIconMC = [];
            this.currentPage = 1;
            this.totalPage = 1;
            this.skillIndex = 0;
            this.skillLoading = 0;
            this.skillCount = 0;
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

