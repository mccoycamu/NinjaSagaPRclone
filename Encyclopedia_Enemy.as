// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Encyclopedia_Enemy

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import br.com.stimuli.loading.BulkLoader;
    import com.abrahamyan.liquid.ToolTip;
    import Managers.PreviewManager;
    import Storage.GameData;
    import Storage.EnemyInfo;
    import flash.events.MouseEvent;
    import flash.events.ErrorEvent;
    import Storage.Character;
    import flash.events.Event;
    import Managers.NinjaSage;
    import com.utils.GF;
    import Combat.BattleManager;
    import Combat.BattleVars;

    public class Encyclopedia_Enemy extends MovieClip 
    {

        private const attackLabel:Array = ["attack_01", "attack_02", "attack_03", "attack_04", "attack_05", "attack_06", "attack_07", "attack_08", "attack_09", "attack_10", "attack_11", "attack_12", "attack_13", "attack_14", "attack_15"];

        public var optionMC:MovieClip;
        public var panelMC:MovieClip;
        public var preview:MovieClip;
        public var buyGold:SimpleButton;
        public var buyTokens:SimpleButton;
        public var txt_title:TextField;
        public var txt_gold:TextField;
        public var txt_token:TextField;
        private var eventHandler:EventHandler;
        private var enemyData:Array;
        private var enemyDataOriginal:Array;
        private var enemyInfo:Object;
        private var loaderSwf:BulkLoader;
        private var itemIndex:int = 0;
        private var itemLoading:int = 0;
        private var itemCount:int = 0;
        private var currentPage:int = 1;
        private var totalPage:int = 1;
        private var currentPageBackground:int = 1;
        private var totalPageBackground:int = 1;
        private var selectedEnemyIndex:int = -1;
        private var isLoading:Boolean;
        private var firstLoad:Boolean = true;
        private var enemyStaticMCArray:Array;
        private var enemyStaticMCSelect:MovieClip;
        private var tooltip:ToolTip;
        private var enemyMCPreview:PreviewManager;
        private var backgroundData:Array;
        private var battleEnemyId:Array;
        private var selectedMission:String = "mission_155";
        private var multiplier:Number = 1;
        private var selectedDiff:int = 1;
        private var main:*;

        public function Encyclopedia_Enemy(_arg_1:*)
        {
            var _local_2:* = GameData.get("encyclopedia");
            this.enemyData = EnemyInfo.getEncyIds();
            this.enemyDataOriginal = EnemyInfo.getEncyIds();
            this.backgroundData = _local_2.background;
            this.enemyStaticMCArray = [];
            this.battleEnemyId = [];
            this.enemyMCPreview = null;
            this.main = _arg_1;
            this.tooltip = ToolTip.getInstance();
            this.loaderSwf = BulkLoader.createUniqueNamedLoader(9);
            this.eventHandler = new EventHandler();
            this.initUI();
            this.initButton();
        }

        private function initUI():void
        {
            this.totalPage = Math.max(Math.ceil((this.enemyData.length / 9)), 1);
            this.panelMC.txt_goToPage.restrict = "0-9";
            this.updatePageNumber();
            this.updateBackgroundHolder();
            this.resetEnemyPrepHolder();
            this.resetPreviewHolder();
            this.resetSelectedEnemyHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.loadSwf();
        }

        private function initButton():void
        {
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btn_to_page, MouseEvent.CLICK, this.goToPage);
            this.eventHandler.addListener(this.panelMC.btn_search, MouseEvent.CLICK, this.searchItem);
            this.eventHandler.addListener(this.panelMC.btn_clearSearch, MouseEvent.CLICK, this.onSearchClear);
            this.eventHandler.addListener(this.panelMC.btn_plus, MouseEvent.CLICK, this.addEnemy);
            this.eventHandler.addListener(this.panelMC.btn_reset, MouseEvent.CLICK, this.resetEnemy);
            this.eventHandler.addListener(this.panelMC.btn_battle, MouseEvent.CLICK, this.startBattle);
            this.eventHandler.addListener(this.panelMC.btn_option, MouseEvent.CLICK, this.openOption);
        }

        private function loadSwf():void
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            this.isLoading = true;
            if (this.itemIndex < this.itemLoading)
            {
                _local_1 = this.enemyData[this.itemIndex];
                _local_2 = (("enemy/" + _local_1) + ".swf");
                _local_3 = this.loaderSwf.add(_local_2, {
                    "id":_local_1,
                    "type":"movieclip"
                });
                _local_3.addEventListener(BulkLoader.COMPLETE, this.completeIcon);
                _local_3.addEventListener(BulkLoader.ERROR, this.onItemLoadError);
                this.loaderSwf.start();
            }
            else
            {
                if (this.firstLoad)
                {
                    this.main.loading(false);
                    this.firstLoad = false;
                };
                if (this.enemyData.length > 0)
                {
                    this.selectEnemy(0);
                };
                this.isLoading = false;
                return;
            };
        }

        private function onItemLoadError(_arg_1:ErrorEvent):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.COMPLETE, this.completeIcon);
            this.enemyStaticMCArray[this.itemCount] = null;
            this.itemIndex++;
            this.itemCount++;
            this.loadSwf();
        }

        private function completeIcon(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.ERROR, this.onItemLoadError);
            var _local_3:MovieClip;
            _local_3 = ((_arg_1.target.content.hasOwnProperty("StaticFullBody")) ? _arg_1.target.content.StaticFullBody : _arg_1.target.content.StatichuntingHouse);
            if (!Character.play_items_animation)
            {
                _local_3.stopAllMovieClips();
            };
            this.enemyStaticMCArray.push(_local_3);
            _local_3.scaleX = 0.27;
            _local_3.scaleY = 0.27;
            _local_3.x = -25;
            _local_3.y = -75;
            this.panelMC[("item_" + this.itemCount)].iconHolder.addChild(_local_3);
            this.panelMC[("item_" + this.itemCount)].gotoAndStop(1);
            this.panelMC[("item_" + this.itemCount)].visible = true;
            var _local_4:String = this.enemyData[this.itemIndex];
            _arg_1.target.content[_local_4].gotoAndStop(1);
            var _local_5:Object = EnemyInfo.getEnemyStats(_local_4);
            this.panelMC[("item_" + this.itemCount)].tooltip = _local_5;
            this.panelMC[("item_" + this.itemCount)].lvlTxt.text = _local_5.enemy_level;
            this.eventHandler.addListener(this.panelMC[("item_" + this.itemCount)], MouseEvent.MOUSE_OVER, this.toolTiponOver);
            this.eventHandler.addListener(this.panelMC[("item_" + this.itemCount)], MouseEvent.MOUSE_OUT, this.toolTiponOut);
            this.eventHandler.addListener(this.panelMC[("item_" + this.itemCount)], MouseEvent.CLICK, this.selectEnemy);
            this.itemIndex++;
            this.itemCount++;
            this.loadSwf();
        }

        private function selectEnemy(_arg_1:*):void
        {
            var _local_2:int = ((_arg_1 is MouseEvent) ? _arg_1.currentTarget.name.replace("item_", "") : _arg_1);
            this.resetSelectedEnemyHolder();
            this.selectedEnemyIndex = (_local_2 + int((int((this.currentPage - 1)) * 9)));
            var _local_3:Object = this.panelMC[("item_" + _local_2)].tooltip;
            this.panelMC.btn_preview.visible = true;
            this.panelMC.enemy_name.visible = true;
            this.eventHandler.addListener(this.panelMC.btn_preview, MouseEvent.CLICK, this.loadPreviewSwf);
            this.panelMC.enemy_name.text = _local_3.enemy_name;
            NinjaSage.loadIconSWF("enemy", _local_3.enemy_id, this.panelMC.enemy_mc, "StaticFullBody");
        }

        private function loadPreviewSwf(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.resetPreviewHolder();
            var _local_2:* = this.enemyData[this.selectedEnemyIndex];
            var _local_3:* = (("enemy/" + _local_2) + ".swf");
            var _local_4:* = this.loaderSwf.add(_local_3);
            _local_4.addEventListener(BulkLoader.COMPLETE, this.onCompleteEnemyLoaded);
            _local_4.addEventListener(BulkLoader.ERROR, this.onEnemyLoadError);
            this.loaderSwf.start();
        }

        private function onEnemyLoadError(_arg_1:ErrorEvent):void
        {
            this.main.loading(false);
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.COMPLETE, this.onCompleteEnemyLoaded);
            this.loaderSwf.removeAll();
            this.updatePageNumber();
            this.resetSelectedEnemyHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.loadSwf();
        }

        private function onCompleteEnemyLoaded(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.ERROR, this.onEnemyLoadError);
            this.enemyInfo = EnemyInfo.getEnemyStats(this.enemyData[this.selectedEnemyIndex]);
            var _local_3:MovieClip = _arg_1.target.content[this.enemyInfo.enemy_id];
            this.enemyMCPreview = new PreviewManager(this.main, _local_3, this.enemyInfo);
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

        private function showPreview():void
        {
            this.preview.visible = true;
            this.preview.enemyMc.addChild(this.enemyMCPreview.preview_mc);
            this.enemyMCPreview.preview_mc.gotoAndPlay("standby");
            var _local_1:int;
            while (_local_1 < this.enemyInfo.attacks.length)
            {
                this.preview[this.attackLabel[_local_1]].visible = true;
                this.main.initButton(this.preview[this.attackLabel[_local_1]], this.playSkillAnimation, ("Skill " + (_local_1 + 1)));
                this.main.initButton(this.preview.dodge, this.playSkillAnimation, "Dodge");
                this.main.initButton(this.preview.hit, this.playSkillAnimation, "Hit");
                this.main.initButton(this.preview.dead, this.playSkillAnimation, "Dead");
                _local_1++;
            };
            this.eventHandler.addListener(this.preview.exitBtn, MouseEvent.CLICK, this.closePreview);
        }

        private function playSkillAnimation(_arg_1:MouseEvent):void
        {
            this.enemyMCPreview.preview_mc.gotoAndPlay(_arg_1.currentTarget.name);
        }

        private function resetPreviewHolder():void
        {
            if (this.enemyMCPreview)
            {
                this.enemyMCPreview.destroy();
            };
            var _local_1:int;
            while (_local_1 < this.attackLabel.length)
            {
                this.preview[this.attackLabel[_local_1]].visible = false;
                _local_1++;
            };
            this.enemyInfo = null;
            this.enemyMCPreview = null;
        }

        private function closePreview(_arg_1:MouseEvent):void
        {
            this.resetPreviewHolder();
            this.preview.visible = false;
            GF.removeAllChild(this.preview.enemyMc);
        }

        private function goToPage(_arg_1:MouseEvent):void
        {
            if ((((this.panelMC.txt_goToPage.text == "") || (this.panelMC.txt_goToPage.text < 1)) || (this.panelMC.txt_goToPage.text > this.totalPage)))
            {
                return;
            };
            this.currentPage = int(this.panelMC.txt_goToPage.text);
            this.updatePageNumber();
            this.resetPreviewHolder();
            this.resetSelectedEnemyHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.loadSwf();
        }

        private function searchItem(_arg_1:MouseEvent):void
        {
            var _local_6:String;
            var _local_8:Object;
            var _local_9:String;
            var _local_2:Array = [];
            var _local_3:String = this.panelMC.txt_search.text.toLowerCase();
            var _local_4:Array = this.enemyDataOriginal;
            var _local_5:int = _local_4.length;
            var _local_7:int;
            while (_local_7 < _local_5)
            {
                _local_6 = _local_4[_local_7];
                _local_8 = EnemyInfo.getEnemyStats(_local_6);
                _local_9 = _local_8["enemy_name"].toLowerCase();
                if (_local_9.indexOf(_local_3) >= 0)
                {
                    _local_2.push(_local_6);
                };
                _local_7++;
            };
            this.enemyData = _local_2;
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.enemyData.length / 9)), 1);
            this.loaderSwf.removeAll();
            this.updatePageNumber();
            this.resetPreviewHolder();
            this.resetSelectedEnemyHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.loadSwf();
        }

        private function onSearchClear(_arg_1:MouseEvent):void
        {
            this.panelMC.txt_search.text = "";
            this.panelMC.txt_goToPage.text = "";
            this.enemyData = this.enemyDataOriginal;
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.enemyData.length / 9)), 1);
            this.loaderSwf.removeAll();
            this.updatePageNumber();
            this.resetPreviewHolder();
            this.resetSelectedEnemyHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.loadSwf();
        }

        public function addEnemy(_arg_1:MouseEvent):void
        {
            if (this.battleEnemyId.length >= 3)
            {
                this.main.showMessage("Can't add more than 3 enemy");
                return;
            };
            this.battleEnemyId.push(this.enemyData[this.selectedEnemyIndex]);
            this.resetEnemyPrepHolder();
            this.updateBattlePrep();
        }

        public function updateBattlePrep():void
        {
            var _local_1:int;
            while (_local_1 < this.battleEnemyId.length)
            {
                this.panelMC[("enemy_" + _local_1)].visible = true;
                this.panelMC[("enemy_" + _local_1)].iconHolder.scaleX = 0.27;
                this.panelMC[("enemy_" + _local_1)].iconHolder.scaleY = 0.27;
                this.panelMC[("enemy_" + _local_1)].iconHolder.x = -25;
                this.panelMC[("enemy_" + _local_1)].iconHolder.y = -75;
                NinjaSage.loadIconSWF("enemy", this.battleEnemyId[_local_1], this.panelMC[("enemy_" + _local_1)].iconHolder, "StaticFullBody");
                _local_1++;
            };
        }

        public function updateBackgroundHolder():void
        {
            GF.removeAllChild(this.panelMC.bg);
            this.panelMC.bg.scaleX = 0.2;
            this.panelMC.bg.scaleY = 0.2;
            NinjaSage.loadIconSWF("mission", Character.encyclopedia_battle.background, this.panelMC.bg, "BattleBG");
        }

        public function resetEnemyPrepHolder():void
        {
            var _local_1:int;
            while (_local_1 < 3)
            {
                GF.removeAllChild(this.panelMC[("enemy_" + _local_1)].iconHolder);
                this.panelMC[("enemy_" + _local_1)].iconHolder.scaleX = 1;
                this.panelMC[("enemy_" + _local_1)].iconHolder.scaleY = 1;
                this.panelMC[("enemy_" + _local_1)].iconHolder.x = 0;
                this.panelMC[("enemy_" + _local_1)].iconHolder.y = 0;
                this.panelMC[("enemy_" + _local_1)].gotoAndStop(1);
                this.panelMC[("enemy_" + _local_1)].lockMc.visible = false;
                this.panelMC[("enemy_" + _local_1)].emblemMC.visible = false;
                this.panelMC[("enemy_" + _local_1)].amtTxt.visible = false;
                this.panelMC[("enemy_" + _local_1)].lvlTxt.visible = false;
                this.panelMC[("enemy_" + _local_1)].lvlLabel.visible = false;
                this.panelMC[("enemy_" + _local_1)].visible = false;
                _local_1++;
            };
            this.panelMC.bg.gotoAndStop(1);
        }

        public function openOption(_arg_1:MouseEvent):void
        {
            this.optionMC.visible = true;
            this.selectedMission = Character.encyclopedia_battle.background;
            Character.encyclopedia_battle.background = Character.encyclopedia_battle.background;
            this.optionMC.txt_allow_difficulty.text = Character.encyclopedia_battle.difficulty;
            this.optionMC.txt_allow_control.text = ((Character.encyclopedia_battle.controllable) ? "YES" : "NO ");
            this.optionMC.descTxt.text = "";
            this.totalPageBackground = Math.max(Math.ceil((this.backgroundData.length / 6)), 1);
            this.optionMC.txt_page.text = ((this.currentPageBackground + "/") + this.totalPageBackground);
            this.eventHandler.addListener(this.optionMC.btn_prev_page, MouseEvent.CLICK, this.changePageBackground);
            this.eventHandler.addListener(this.optionMC.btn_next_page, MouseEvent.CLICK, this.changePageBackground);
            this.eventHandler.addListener(this.optionMC.btn_prev_control, MouseEvent.CLICK, this.setControllable);
            this.eventHandler.addListener(this.optionMC.btn_next_control, MouseEvent.CLICK, this.setControllable);
            this.eventHandler.addListener(this.optionMC.btn_prev_difficulty, MouseEvent.CLICK, this.setDifficulty);
            this.eventHandler.addListener(this.optionMC.btn_next_difficulty, MouseEvent.CLICK, this.setDifficulty);
            this.eventHandler.addListener(this.optionMC.btn_save, MouseEvent.CLICK, this.saveBattleOption);
            this.eventHandler.addListener(this.optionMC.btn_close, MouseEvent.CLICK, this.closeOption);
            this.loadBackground();
        }

        public function closeOption(_arg_1:MouseEvent=null):void
        {
            var _local_2:int;
            while (_local_2 < 6)
            {
                GF.removeAllChild(this.optionMC[("stage" + _local_2)].bgHolder);
                _local_2++;
            };
            this.optionMC.visible = false;
        }

        public function loadBackground():void
        {
            var _local_2:*;
            var _local_1:int;
            while (_local_1 < 6)
            {
                this.optionMC[("stage" + _local_1)].gotoAndStop(1);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < 6)
            {
                _local_2 = (_local_1 + int((int((this.currentPageBackground - 1)) * 6)));
                this.optionMC[("stage" + _local_1)].visible = false;
                if (this.backgroundData.length > _local_2)
                {
                    this.optionMC[("stage" + _local_1)].visible = true;
                    this.optionMC[("stage" + _local_1)].bgHolder.scaleX = 0.36;
                    this.optionMC[("stage" + _local_1)].bgHolder.scaleY = 0.25;
                    GF.removeAllChild(this.optionMC[("stage" + _local_1)].bgHolder);
                    NinjaSage.loadIconSWF("mission", this.backgroundData[_local_2], this.optionMC[("stage" + _local_1)].bgHolder, "BattleBG");
                    this.optionMC[("stage" + _local_1)].mission_id = this.backgroundData[_local_2];
                    this.eventHandler.addListener(this.optionMC[("stage" + _local_1)], MouseEvent.CLICK, this.selectMission);
                };
                _local_1++;
            };
        }

        public function selectMission(_arg_1:MouseEvent):void
        {
            var _local_2:* = 0;
            while (_local_2 < 6)
            {
                this.optionMC[("stage" + _local_2)].gotoAndStop(1);
                _local_2++;
            };
            _arg_1.currentTarget.gotoAndStop(2);
            this.selectedMission = _arg_1.currentTarget.mission_id;
        }

        public function changePageBackground(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next_page":
                    if (this.totalPageBackground > this.currentPageBackground)
                    {
                        this.currentPageBackground++;
                        this.loadBackground();
                    };
                    break;
                case "btn_prev_page":
                    if (this.currentPageBackground > 1)
                    {
                        this.currentPageBackground--;
                        this.loadBackground();
                    };
            };
            this.updatePageTextBackground();
        }

        public function updatePageTextBackground():void
        {
            this.optionMC.txt_page.text = ((this.currentPageBackground + "/") + this.totalPageBackground);
        }

        public function setControllable(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_prev_control":
                    this.optionMC.txt_allow_control.text = "NO";
                    return;
                case "btn_next_control":
                    this.optionMC.txt_allow_control.text = "YES";
                    return;
            };
        }

        public function setDifficulty(_arg_1:MouseEvent):void
        {
            var _local_2:* = [{
                "name":"EASY",
                "multiplier":0.7
            }, {
                "name":"NORMAL",
                "multiplier":1
            }, {
                "name":"HARD",
                "multiplier":1.2
            }];
            switch (_arg_1.currentTarget.name)
            {
                case "btn_prev_difficulty":
                    this.selectedDiff--;
                    if (this.selectedDiff < 0)
                    {
                        this.selectedDiff = 0;
                        return;
                    };
                    break;
                case "btn_next_difficulty":
                    this.selectedDiff++;
                    if (this.selectedDiff > (int(_local_2.length) - 1))
                    {
                        this.selectedDiff = (int(_local_2.length) - 1);
                        return;
                    };
                    break;
            };
            this.optionMC.txt_allow_difficulty.text = _local_2[this.selectedDiff].name;
            this.multiplier = _local_2[this.selectedDiff].multiplier;
        }

        public function saveBattleOption(_arg_1:MouseEvent):void
        {
            this.optionMC.visible = false;
            this.main.showMessage("Option Saved!");
            Character.encyclopedia_battle.multiplier = this.multiplier;
            Character.encyclopedia_battle.controllable = ((this.optionMC.txt_allow_control.text == "YES") ? true : false);
            Character.encyclopedia_battle.background = this.selectedMission;
            Character.encyclopedia_battle.difficulty = this.optionMC.txt_allow_difficulty.text;
            this.updateBackgroundHolder();
        }

        public function startBattle(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            if (((Character.character_skill_set == "") || (Character.character_skill_set == null)))
            {
                this.main.showMessage("Please equip at least 1 skill");
                return;
            };
            Character.mission_level = Character.character_lvl;
            this.main.combat = this.main.loadPanel("Combat.Battle", true);
            BattleManager.init(this.main.combat, this.main, BattleVars.TEST_MATCH, Character.encyclopedia_battle.background);
            BattleManager.addPlayerToTeam("player", ("char_" + Character.char_id));
            Character.teammate_controllable = Character.encyclopedia_battle.controllable;
            Character.encyclopedia_battle.battle = true;
            if (this.battleEnemyId.length == 0)
            {
                BattleManager.addPlayerToTeam("enemy", this.enemyData[this.selectedEnemyIndex]);
            }
            else
            {
                _local_2 = 0;
                while (_local_2 < this.battleEnemyId.length)
                {
                    BattleManager.addPlayerToTeam("enemy", this.battleEnemyId[_local_2]);
                    _local_2++;
                };
            };
            BattleManager.startBattle();
            this.destroy();
        }

        public function resetEnemy(_arg_1:MouseEvent):void
        {
            this.battleEnemyId = [];
            this.resetEnemyPrepHolder();
            this.updateBattlePrep();
        }

        private function changePage(_arg_1:MouseEvent):void
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
            this.resetPreviewHolder();
            this.resetSelectedEnemyHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            this.loaderSwf.removeAll();
            this.loadSwf();
        }

        private function updatePageNumber():void
        {
            this.panelMC.txt_page.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function hoverOver(_arg_1:Event):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        private function hoverOut(_arg_1:Event):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
        }

        private function toolTiponOver(e:MouseEvent):void
        {
            var tooltipData:Object;
            var desc:String;
            var itemType:String;
            e.currentTarget.gotoAndStop(2);
            var mc:MovieClip = (e.currentTarget as MovieClip);
            if (!mc.tooltipCache)
            {
                var formatDesc:Function = function (_arg_1:String, _arg_2:String, _arg_3:String="", _arg_4:String="", _arg_5:String=""):String
                {
                    return (((((((_arg_1 + "\n(") + _arg_2) + ")\n") + ((_arg_3) ? ("\nLevel: " + _arg_3) : "")) + ((_arg_4) ? ("\n" + _arg_4) : "")) + "\n\n") + _arg_5);
                };
                tooltipData = mc.tooltip;
                if (!tooltipData)
                {
                    return;
                };
                itemType = mc.item_type;
                desc = formatDesc(tooltipData.enemy_name, "Enemy", tooltipData.enemy_level, "", tooltipData.description);
                mc.tooltipCache = desc;
            };
            stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(mc.tooltipCache);
        }

        private function toolTiponOut(_arg_1:MouseEvent):void
        {
            _arg_1.currentTarget.gotoAndStop(1);
            this.tooltip.hide();
        }

        private function resetSelectedEnemyHolder():void
        {
            GF.removeAllChild(this.panelMC.enemy_mc);
            GF.removeAllChild(this.enemyStaticMCSelect);
            this.preview.visible = false;
            this.optionMC.visible = false;
            this.panelMC.btn_preview.visible = false;
            this.panelMC.enemy_name.visible = false;
            this.eventHandler.removeListener(this.panelMC.btn_preview, MouseEvent.CLICK, this.loadPreviewSwf);
            var _local_1:int;
            while (_local_1 < 9)
            {
                this.panelMC[("item_" + _local_1)].gotoAndStop(1);
                _local_1++;
            };
        }

        private function resetIconHolder():void
        {
            var _local_1:int;
            while (_local_1 < this.enemyStaticMCArray.length)
            {
                GF.removeAllChild(this.enemyStaticMCArray[_local_1]);
                _local_1++;
            };
            this.enemyStaticMCArray = [];
            _local_1 = 0;
            while (_local_1 < 9)
            {
                GF.removeAllChild(this.panelMC[("item_" + _local_1)].iconMc.iconHolder);
                this.panelMC[("item_" + _local_1)].gotoAndStop(1);
                this.panelMC[("item_" + _local_1)].visible = false;
                this.panelMC[("item_" + _local_1)].lockMc.visible = false;
                this.panelMC[("item_" + _local_1)].emblemMC.visible = false;
                this.panelMC[("item_" + _local_1)].amtTxt.visible = false;
                delete this.panelMC[("item_" + _local_1)].tooltip;
                delete this.panelMC[("item_" + _local_1)].tooltipCache;
                this.eventHandler.removeListener(this.panelMC[("item_" + _local_1)], MouseEvent.MOUSE_OVER, this.toolTiponOver);
                this.eventHandler.removeListener(this.panelMC[("item_" + _local_1)], MouseEvent.MOUSE_OUT, this.toolTiponOut);
                _local_1++;
            };
        }

        private function resetRecursiveProperty():void
        {
            this.itemLoading = (this.currentPage * 9);
            if (this.enemyData.length < this.itemLoading)
            {
                this.itemLoading = this.enemyData.length;
            };
            this.itemIndex = ((this.currentPage - 1) * 9);
            this.itemCount = 0;
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.main.clearEvents();
            this.closeOption();
            this.updateBackgroundHolder();
            this.resetEnemyPrepHolder();
            this.resetIconHolder();
            this.resetSelectedEnemyHolder();
            this.resetPreviewHolder();
            this.resetRecursiveProperty();
            this.eventHandler.removeAllEventListeners();
            this.loaderSwf.clear();
            this.tooltip.destroy();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.tooltip = null;
            this.loaderSwf = null;
            this.main = null;
            this.enemyData.length = 0;
            this.enemyDataOriginal.length = 0;
            GF.removeAllChild(this);
        }


    }
}//package Panels

