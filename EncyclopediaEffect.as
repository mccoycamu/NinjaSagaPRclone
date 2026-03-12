// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.EncyclopediaEffect

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.GameData;
    import flash.events.MouseEvent;
    import flash.text.TextFormat;
    import flash.text.TextField;
    import com.utils.GF;

    public dynamic class EncyclopediaEffect extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var selectedEffect:Array;
        private var main:*;
        private var buffList:Array;
        private var debuffList:Array;
        private var buffCategoryList:Array = ["All", "Offense", "Defense", "Hybrid"];
        private var debuffCategoryList:Array = ["All", "Offense", "Defense", "Control", "Hybrid"];
        private var currentTab:String;
        private var currentCategoryIndex:int;
        private var currentPage:int;
        private var totalPage:int;
        private var eventHandler:EventHandler;
        private var defaultFontSize:int = 20;

        public function EncyclopediaEffect(_arg_1:*, _arg_2:*)
        {
            var _local_3:Object = GameData.get("encyclopedia");
            this.panelMC = _arg_2.panelMC;
            this.buffList = _local_3.effect.buffs;
            this.debuffList = _local_3.effect.debuffs;
            this.main = _arg_1;
            this.eventHandler = new EventHandler();
            this.panelMC.txt_search.text = "";
            this.currentTab = "buff";
            this.currentCategoryIndex = 0;
            this.initButton();
            this.initCategoryButton();
            this.sortEffect();
        }

        private function initButton():void
        {
            this.panelMC.btn_buff.gotoAndStop(3);
            this.panelMC.btn_debuff.gotoAndStop(1);
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btn_buff, MouseEvent.CLICK, this.changeTab);
            this.eventHandler.addListener(this.panelMC.btn_buff, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.addListener(this.panelMC.btn_buff, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.addListener(this.panelMC.btn_debuff, MouseEvent.CLICK, this.changeTab);
            this.eventHandler.addListener(this.panelMC.btn_debuff, MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.addListener(this.panelMC.btn_debuff, MouseEvent.MOUSE_OUT, this.out);
            this.eventHandler.addListener(this.panelMC.btn_search, MouseEvent.CLICK, this.searchEffect);
            this.eventHandler.addListener(this.panelMC.btn_clearSearch, MouseEvent.CLICK, this.clearSearch);
            this.eventHandler.addListener(this.panelMC.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btn_next, MouseEvent.CLICK, this.changePage);
        }

        private function sortEffect():void
        {
            this.selectedEffect = [];
            var _local_1:Object = {};
            var _local_2:Array = ((this.currentTab == "buff") ? this.buffList : this.debuffList);
            var _local_3:Array = ((this.currentTab == "buff") ? this.buffCategoryList : this.debuffCategoryList);
            var _local_4:int;
            while (_local_4 < _local_2.length)
            {
                if (this.currentCategoryIndex == 0)
                {
                    _local_1 = _local_2[_local_4];
                    this.selectedEffect.push(_local_1);
                }
                else
                {
                    if (_local_2[_local_4].category == _local_3[this.currentCategoryIndex].toLowerCase())
                    {
                        _local_1 = _local_2[_local_4];
                        this.selectedEffect.push(_local_1);
                    };
                };
                _local_4++;
            };
            this.selectedEffect.sortOn("name", Array.CASEINSENSITIVE);
            this.currentPage = 1;
            this.totalPage = Math.max(1, Math.ceil((this.selectedEffect.length / 8)));
            this.showStatusEffect();
        }

        private function showStatusEffect():void
        {
            var _local_5:int;
            var _local_1:String = ((this.currentTab == "buff") ? "Buff" : "Debuff");
            var _local_2:String = ((this.currentTab == "buff") ? this.buffCategoryList[this.currentCategoryIndex] : this.debuffCategoryList[this.currentCategoryIndex]);
            var _local_3:String = ((_local_2 + " ") + _local_1);
            this.panelMC.content.txt_title_0.htmlText = this.formatColor(this.currentCategoryIndex, _local_3);
            this.panelMC.content.txt_title_1.htmlText = this.formatColor(this.currentCategoryIndex, _local_3);
            var _local_4:int;
            while (_local_4 < 8)
            {
                _local_5 = (_local_4 + ((this.currentPage - 1) * 8));
                this.panelMC.content[("effect_" + _local_4)].visible = false;
                if (_local_5 < this.selectedEffect.length)
                {
                    this.panelMC.content[("effect_" + _local_4)].visible = true;
                    this.panelMC.content[("effect_" + _local_4)].txt_effect_title.htmlText = this.formatColor(this.currentCategoryIndex, this.selectedEffect[_local_5].name);
                    this.adjustDescriptionFontSize(this.panelMC.content[("effect_" + _local_4)].txt_effect_description, this.selectedEffect[_local_5].description);
                };
                _local_4++;
            };
            this.updatePageNumber();
        }

        private function adjustDescriptionFontSize(_arg_1:TextField, _arg_2:String):void
        {
            var _local_10:int;
            var _local_11:int;
            var _local_3:TextFormat = _arg_1.getTextFormat();
            var _local_4:Object = ((_local_3.size) || (this.defaultFontSize));
            _local_3.size = this.defaultFontSize;
            _arg_1.htmlText = _arg_2;
            _arg_1.setTextFormat(_local_3);
            var _local_5:int = _arg_1.height;
            var _local_6:int = _arg_1.width;
            var _local_7:int = _arg_1.textHeight;
            var _local_8:int = _arg_1.textWidth;
            var _local_9:* = (_local_7 > _local_5);
            if (_local_9)
            {
                _local_10 = this.defaultFontSize;
                _local_11 = 8;
                while ((((_arg_1.textHeight > _local_5) || (_arg_1.textWidth > _local_6)) && (_local_10 > _local_11)))
                {
                    _local_10 = (_local_10 - 0.5);
                    _local_3.size = _local_10;
                    _arg_1.setTextFormat(_local_3);
                    _local_7 = _arg_1.textHeight;
                    _local_8 = _arg_1.textWidth;
                };
            }
            else
            {
                _local_3.size = this.defaultFontSize;
                _arg_1.setTextFormat(_local_3);
            };
        }

        private function formatColor(_arg_1:int, _arg_2:String):String
        {
            if (this.currentTab == "buff")
            {
                switch (_arg_1)
                {
                    case 0:
                        return (this.colorize(_arg_2, "#66ff33"));
                    case 1:
                        return (this.colorize(_arg_2, "#ff3838"));
                    case 2:
                        return (this.colorize(_arg_2, "#ff9900"));
                };
            }
            else
            {
                switch (_arg_1)
                {
                    case 0:
                        return (this.colorize(_arg_2, "#ff3838"));
                    case 1:
                        return (this.colorize(_arg_2, "#ff3838"));
                    case 2:
                        return (this.colorize(_arg_2, "#ff9900"));
                };
            };
            return (this.colorize(_arg_2, "#cc66ff"));
        }

        private function colorize(_arg_1:String, _arg_2:String):String
        {
            return (((('<font color="' + _arg_2) + '">') + _arg_1) + "</font>");
        }

        private function clearSearch(_arg_1:MouseEvent):void
        {
            this.panelMC.txt_search.text = "";
            this.sortEffect();
        }

        private function searchEffect(_arg_1:MouseEvent):void
        {
            var _local_5:Object;
            var _local_6:String;
            var _local_2:Array = [];
            var _local_3:Array = ((this.currentTab == "buff") ? this.buffList : this.debuffList);
            var _local_4:String = this.panelMC.txt_search.text.toLowerCase();
            var _local_7:int;
            while (_local_7 < _local_3.length)
            {
                _local_5 = _local_3[_local_7];
                _local_6 = _local_5.name.toLowerCase();
                if (_local_6.indexOf(_local_4) >= 0)
                {
                    _local_2.push(_local_5);
                };
                _local_7++;
            };
            this.selectedEffect = [];
            _local_7 = 0;
            while (_local_7 < _local_2.length)
            {
                _local_5 = _local_2[_local_7];
                this.selectedEffect.push(_local_5);
                _local_7++;
            };
            this.selectedEffect.sortOn("name", Array.CASEINSENSITIVE);
            this.currentCategoryIndex = 0;
            this.initCategoryButton();
            this.panelMC.btn_0.gotoAndStop(3);
            this.currentPage = 1;
            this.totalPage = Math.max(1, Math.ceil((this.selectedEffect.length / 8)));
            this.updatePageNumber();
            this.showStatusEffect();
        }

        private function changePage(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_prev":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                    };
                    break;
                case "btn_next":
                    if (this.currentPage < this.totalPage)
                    {
                        this.currentPage++;
                    };
            };
            this.showStatusEffect();
        }

        private function updatePageNumber():void
        {
            this.panelMC.txt_page.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function resetTab():void
        {
            this.panelMC.btn_buff.gotoAndStop(1);
            this.panelMC.btn_debuff.gotoAndStop(1);
        }

        private function resetCategoryTab():void
        {
            var _local_1:int;
            while (_local_1 < 5)
            {
                this.panelMC[("btn_" + _local_1)].gotoAndStop(1);
                _local_1++;
            };
        }

        private function changeTab(_arg_1:MouseEvent):void
        {
            this.resetTab();
            _arg_1.currentTarget.gotoAndStop(3);
            this.currentTab = ((_arg_1.currentTarget.name == "btn_buff") ? "buff" : "debuff");
            this.currentCategoryIndex = 0;
            this.initCategoryButton();
            this.sortEffect();
        }

        private function initCategoryButton():void
        {
            var _local_1:Array = ((this.currentTab == "buff") ? this.buffCategoryList : this.debuffCategoryList);
            var _local_2:int;
            while (_local_2 < 5)
            {
                this.panelMC[("btn_" + _local_2)].visible = false;
                this.panelMC[("btn_" + _local_2)].gotoAndStop(1);
                if (_local_2 < _local_1.length)
                {
                    this.panelMC[("btn_" + _local_2)].visible = true;
                    this.panelMC[("btn_" + _local_2)].txt.text = _local_1[_local_2];
                    this.eventHandler.addListener(this.panelMC[("btn_" + _local_2)], MouseEvent.CLICK, this.changeCategory);
                    this.eventHandler.addListener(this.panelMC[("btn_" + _local_2)], MouseEvent.MOUSE_OVER, this.over);
                    this.eventHandler.addListener(this.panelMC[("btn_" + _local_2)], MouseEvent.MOUSE_OUT, this.out);
                };
                _local_2++;
            };
        }

        private function changeCategory(_arg_1:MouseEvent):void
        {
            this.currentCategoryIndex = _arg_1.currentTarget.name.replace("btn_", "");
            this.resetCategoryTab();
            _arg_1.currentTarget.gotoAndStop(3);
            this.sortEffect();
        }

        private function over(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        private function out(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.main = null;
            this.currentTab = null;
            this.selectedEffect = [];
            this.buffList = [];
            this.debuffList = [];
            this.buffCategoryList = [];
            this.debuffCategoryList = [];
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
        }


    }
}//package id.ninjasage.features

