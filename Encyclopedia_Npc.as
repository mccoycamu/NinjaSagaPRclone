// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Encyclopedia_Npc

package Panels
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import br.com.stimuli.loading.BulkLoader;
    import com.abrahamyan.liquid.ToolTip;
    import Managers.PreviewManager;
    import Storage.NpcInfo;
    import flash.events.MouseEvent;
    import flash.events.ErrorEvent;
    import Storage.Character;
    import flash.events.Event;
    import Managers.NinjaSage;
    import com.utils.GF;

    public class Encyclopedia_Npc extends MovieClip 
    {

        private const attackLabel:Array = ["attack_01", "attack_02", "attack_03", "attack_04", "attack_05", "attack_06", "attack_07", "attack_08", "attack_09", "attack_10", "attack_11", "attack_12", "attack_13", "attack_14", "attack_15"];

        public var panelMC:MovieClip;
        public var preview:MovieClip;
        public var txt_title:TextField;
        private var eventHandler:EventHandler;
        private var npcData:Array;
        private var npcDataOriginal:Array;
        private var npcInfo:Object;
        private var loaderSwf:BulkLoader;
        private var itemIndex:int = 0;
        private var itemLoading:int = 0;
        private var itemCount:int = 0;
        private var currentPage:int = 1;
        private var totalPage:int = 1;
        private var selectedNpcIndex:int = -1;
        private var isLoading:Boolean;
        private var firstLoad:Boolean = true;
        private var npcStaticMCArray:Array;
        private var npcStaticMCSelect:MovieClip;
        private var tooltip:ToolTip;
        private var npcMCPreview:PreviewManager;
        private var main:*;

        public function Encyclopedia_Npc(_arg_1:*)
        {
            this.npcData = NpcInfo.getEncyIds();
            this.npcDataOriginal = NpcInfo.getEncyIds();
            this.npcStaticMCArray = [];
            this.npcMCPreview = null;
            this.main = _arg_1;
            this.tooltip = ToolTip.getInstance();
            this.loaderSwf = BulkLoader.createUniqueNamedLoader(9);
            this.eventHandler = new EventHandler();
            this.initUI();
            this.initButton();
        }

        private function initUI():void
        {
            this.totalPage = Math.max(Math.ceil((this.npcData.length / 9)), 1);
            this.panelMC.txt_goToPage.restrict = "0-9";
            this.updatePageNumber();
            this.resetPreviewHolder();
            this.resetSelectedNpcHolder();
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
        }

        private function loadSwf():void
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            this.isLoading = true;
            if (this.itemIndex < this.itemLoading)
            {
                _local_1 = this.npcData[this.itemIndex];
                _local_2 = (("npcs/" + _local_1) + ".swf");
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
                if (this.npcData.length > 0)
                {
                    this.selectNpc(0);
                };
                this.isLoading = false;
                return;
            };
        }

        private function onItemLoadError(_arg_1:ErrorEvent):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.COMPLETE, this.completeIcon);
            this.npcStaticMCArray[this.itemCount] = null;
            this.itemIndex++;
            this.itemCount++;
            this.loadSwf();
        }

        private function completeIcon(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.ERROR, this.onItemLoadError);
            var _local_3:MovieClip = _arg_1.target.content[this.npcData[this.itemIndex]];
            var _local_4:MovieClip;
            _local_4 = ((_arg_1.target.content.hasOwnProperty("StaticFullBody")) ? _arg_1.target.content.StaticFullBody : _arg_1.target.content.StatichuntingHouse);
            if (!Character.play_items_animation)
            {
                _local_4.stopAllMovieClips();
            };
            this.npcStaticMCArray.push(_local_4);
            _local_4.scaleX = 0.27;
            _local_4.scaleY = 0.27;
            _local_4.x = -25;
            _local_4.y = -75;
            this.panelMC[("item_" + this.itemCount)].iconHolder.addChild(_local_4);
            this.panelMC[("item_" + this.itemCount)].gotoAndStop(1);
            this.panelMC[("item_" + this.itemCount)].visible = true;
            var _local_5:String = this.npcData[this.itemIndex];
            _arg_1.target.content[_local_5].gotoAndStop(1);
            var _local_6:Object = NpcInfo.getNpcStats(_local_5);
            this.panelMC[("item_" + this.itemCount)].tooltip = _local_6;
            this.panelMC[("item_" + this.itemCount)].lvlTxt.text = _local_6.npc_level;
            this.eventHandler.addListener(this.panelMC[("item_" + this.itemCount)], MouseEvent.MOUSE_OVER, this.toolTiponOver);
            this.eventHandler.addListener(this.panelMC[("item_" + this.itemCount)], MouseEvent.MOUSE_OUT, this.toolTiponOut);
            this.eventHandler.addListener(this.panelMC[("item_" + this.itemCount)], MouseEvent.CLICK, this.selectNpc);
            this.itemIndex++;
            this.itemCount++;
            this.loadSwf();
        }

        private function selectNpc(_arg_1:*):void
        {
            var _local_2:int = ((_arg_1 is MouseEvent) ? _arg_1.currentTarget.name.replace("item_", "") : _arg_1);
            this.resetSelectedNpcHolder();
            this.selectedNpcIndex = (_local_2 + int((int((this.currentPage - 1)) * 9)));
            var _local_3:Object = this.panelMC[("item_" + _local_2)].tooltip;
            this.panelMC.btn_preview.visible = true;
            this.panelMC.npc_name.visible = true;
            this.eventHandler.addListener(this.panelMC.btn_preview, MouseEvent.CLICK, this.loadPreviewSwf);
            this.panelMC.npc_name.text = _local_3.npc_name;
            NinjaSage.loadIconSWF("npcs", _local_3.npc_id, this.panelMC.npc_mc, "StaticFullBody");
        }

        private function loadPreviewSwf(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.resetPreviewHolder();
            var _local_2:* = this.npcData[this.selectedNpcIndex];
            var _local_3:* = (("npcs/" + _local_2) + ".swf");
            var _local_4:* = this.loaderSwf.add(_local_3);
            _local_4.addEventListener(BulkLoader.COMPLETE, this.onCompleteNpcLoaded);
            _local_4.addEventListener(BulkLoader.ERROR, this.onNpcLoadError);
            this.loaderSwf.start();
        }

        private function onNpcLoadError(_arg_1:ErrorEvent):void
        {
            this.main.loading(false);
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.COMPLETE, this.onCompleteNpcLoaded);
            this.loaderSwf.removeAll();
            this.updatePageNumber();
            this.resetSelectedNpcHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.loadSwf();
        }

        private function onCompleteNpcLoaded(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.ERROR, this.onNpcLoadError);
            this.npcInfo = NpcInfo.getNpcStats(this.npcData[this.selectedNpcIndex]);
            var _local_3:MovieClip = _arg_1.target.content[this.npcInfo.npc_id];
            this.npcMCPreview = new PreviewManager(this.main, _local_3, this.npcInfo);
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
            this.preview.enemyMc.addChild(this.npcMCPreview.preview_mc);
            this.npcMCPreview.preview_mc.gotoAndPlay("standby");
            var _local_1:int;
            while (_local_1 < this.npcInfo.attacks.length)
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
            this.npcMCPreview.preview_mc.gotoAndPlay(_arg_1.currentTarget.name);
        }

        private function resetPreviewHolder():void
        {
            if (this.npcMCPreview)
            {
                this.npcMCPreview.destroy();
            };
            var _local_1:int;
            while (_local_1 < this.attackLabel.length)
            {
                this.preview[this.attackLabel[_local_1]].visible = false;
                _local_1++;
            };
            this.npcInfo = null;
            this.npcMCPreview = null;
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
            this.resetSelectedNpcHolder();
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
            var _local_4:Array = this.npcDataOriginal;
            var _local_5:int = _local_4.length;
            var _local_7:int;
            while (_local_7 < _local_5)
            {
                _local_6 = _local_4[_local_7];
                _local_8 = NpcInfo.getNpcStats(_local_6);
                _local_9 = _local_8["npc_name"].toLowerCase();
                if (_local_9.indexOf(_local_3) >= 0)
                {
                    _local_2.push(_local_6);
                };
                _local_7++;
            };
            this.npcData = _local_2;
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.npcData.length / 9)), 1);
            this.loaderSwf.removeAll();
            this.updatePageNumber();
            this.resetPreviewHolder();
            this.resetSelectedNpcHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.loadSwf();
        }

        private function onSearchClear(_arg_1:MouseEvent):void
        {
            this.panelMC.txt_search.text = "";
            this.panelMC.txt_goToPage.text = "";
            this.npcData = this.npcDataOriginal;
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.npcData.length / 9)), 1);
            this.loaderSwf.removeAll();
            this.updatePageNumber();
            this.resetPreviewHolder();
            this.resetSelectedNpcHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.loadSwf();
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
            this.resetSelectedNpcHolder();
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
                desc = formatDesc(tooltipData.npc_name, "Npc", tooltipData.npc_level, "", tooltipData.description);
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

        private function resetSelectedNpcHolder():void
        {
            GF.removeAllChild(this.panelMC.npc_mc);
            GF.removeAllChild(this.npcStaticMCSelect);
            this.preview.visible = false;
            this.panelMC.btn_preview.visible = false;
            this.panelMC.npc_name.visible = false;
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
            while (_local_1 < this.npcStaticMCArray.length)
            {
                GF.removeAllChild(this.npcStaticMCArray[_local_1]);
                _local_1++;
            };
            this.npcStaticMCArray = [];
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
            if (this.npcData.length < this.itemLoading)
            {
                this.itemLoading = this.npcData.length;
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
            this.resetIconHolder();
            this.resetSelectedNpcHolder();
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
            this.npcData.length = 0;
            this.npcDataOriginal.length = 0;
            GF.removeAllChild(this);
        }


    }
}//package Panels

