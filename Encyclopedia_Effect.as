// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Encyclopedia_Effect

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import Storage.GameData;
    import com.utils.CreateFilter;
    import flash.events.MouseEvent;
    import com.utils.GF;

    public dynamic class Encyclopedia_Effect extends MovieClip 
    {

        public var btn_clearSearch:SimpleButton;
        public var btn_search:SimpleButton;
        public var txt_search:TextField;
        public var btn_close:SimpleButton;
        public var btn_buff:SimpleButton;
        public var btn_debuff:SimpleButton;
        public var effectTxt:TextField;
        private var selectedEffect:Array;
        private var main:*;
        private var buffList:Array;
        private var debuffList:Array;
        private var currentTab:String;
        private var eventHandler:EventHandler;
        private var glowFilter:*;

        public function Encyclopedia_Effect(_arg_1:*)
        {
            var _local_2:Object = GameData.get("encyclopedia");
            this.buffList = _local_2.effect.buffs;
            this.debuffList = _local_2.effect.debuffs;
            this.main = _arg_1;
            this.eventHandler = new EventHandler();
            this.glowFilter = CreateFilter.getGlowFilter({
                "color":0xFFFF00,
                "strength":1000,
                "blurX":6,
                "blurY":6
            });
            this.btn_buff.filters = [this.glowFilter];
            this.currentTab = "buff";
            this.initData();
        }

        private function initData():*
        {
            var _local_3:*;
            this.selectedEffect = [];
            var _local_1:Array = ((this.currentTab == "buff") ? this.buffList : this.debuffList);
            var _local_2:int;
            while (_local_2 < _local_1.length)
            {
                _local_3 = _local_1[_local_2];
                this.selectedEffect.push(this.formatEffect(_local_3));
                _local_2++;
            };
            this.showStatusEffect();
        }

        private function showStatusEffect():*
        {
            this.effectTxt.htmlText = this.selectedEffect.join("\n");
            this.effectTxt.scrollV = this.effectTxt.scrollV;
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.btn_buff, MouseEvent.CLICK, this.changeEffect);
            this.eventHandler.addListener(this.btn_debuff, MouseEvent.CLICK, this.changeEffect);
            this.eventHandler.addListener(this.btn_search, MouseEvent.CLICK, this.searchEffect);
            this.eventHandler.addListener(this.btn_clearSearch, MouseEvent.CLICK, this.clearSearch);
        }

        private function formatEffect(_arg_1:*):*
        {
            return (((this.formatColor(this.currentTab, _arg_1.name) + "\n") + _arg_1.description) + "\n");
        }

        private function formatColor(_arg_1:*, _arg_2:*):*
        {
            switch (_arg_1)
            {
                case "buff":
                    return (this.colorize(_arg_2, "#00ff00"));
                case "debuff":
                    return (this.colorize(_arg_2, "#ff0000"));
                default:
                    return (this.colorize(_arg_2, "#ffffff"));
            };
        }

        private function colorize(_arg_1:*, _arg_2:*):*
        {
            return (((('<font color="' + _arg_2) + '">') + _arg_1) + "</font>");
        }

        private function clearSearch(_arg_1:MouseEvent):void
        {
            this.txt_search.text = "";
            this.initData();
        }

        private function searchEffect(_arg_1:MouseEvent):void
        {
            var _local_5:Object;
            var _local_6:String;
            var _local_2:Array = [];
            var _local_3:Array = ((this.currentTab == "buff") ? this.buffList : this.debuffList);
            var _local_4:String = this.txt_search.text.toLowerCase();
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
                this.selectedEffect.push(this.formatEffect(_local_5));
                _local_7++;
            };
            this.showStatusEffect();
        }

        private function changeEffect(_arg_1:MouseEvent):*
        {
            this.btn_buff.filters = null;
            this.btn_debuff.filters = null;
            if (_arg_1.currentTarget.name == "btn_buff")
            {
                this.currentTab = "buff";
                this.btn_buff.filters = [this.glowFilter];
            }
            else
            {
                this.currentTab = "debuff";
                this.btn_debuff.filters = [this.glowFilter];
            };
            this.initData();
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():*
        {
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.main = null;
            this.currentTab = null;
            this.btn_buff.filters = null;
            this.btn_debuff.filters = null;
            this.selectedEffect = [];
            this.buffList = [];
            this.debuffList = [];
            this.effectTxt.htmlText = "";
            GF.removeAllChild(this);
        }


    }
}//package Panels

