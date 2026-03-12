// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.GetPromotion

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import br.com.stimuli.loading.BulkLoader;
    import Managers.AppManager;
    import flash.events.MouseEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import id.ninjasage.features.LinkMenu;
    import com.utils.GF;

    public dynamic class GetPromotion extends MovieClip 
    {

        public var bg:MovieClip;
        public var btn_close:SimpleButton;
        public var imageHolder:MovieClip;
        public var loadingTxt:TextField;
        public var titleTxt:TextField;
        private var main:*;
        private var bannerData:Object;
        private var eventHandler:EventHandler = new EventHandler();
        private var loaderAsset:BulkLoader;

        public function GetPromotion(_arg_1:*)
        {
            this.main = AppManager.getInstance().main;
            this.loaderAsset = this.main.getTempLoader();
            var _local_2:Object = {};
            if ((_arg_1 is String))
            {
                _local_2 = {
                    "url":_arg_1,
                    "link":_arg_1,
                    "title":"",
                    "action":"open:link"
                };
            }
            else
            {
                _local_2 = _arg_1;
            };
            this.bannerData = _local_2;
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.bg, MouseEvent.CLICK, this.closePanel);
            this.addPromotion();
        }

        private function addPromotion():void
        {
            if (!this.bannerData.hasOwnProperty("url"))
            {
                this.destroy();
                return;
            };
            this.loaderAsset.add(this.bannerData.url, {"id":this.bannerData.url});
            this.loaderAsset.addEventListener(BulkLoader.COMPLETE, this.onPromotionLoaded);
            this.loaderAsset.start();
        }

        private function onPromotionLoaded(_arg_1:*):void
        {
            var _local_2:Function;
            this.loaderAsset.removeEventListener(BulkLoader.COMPLETE, this.onPromotionLoaded);
            this.imageHolder.addChild(this.loaderAsset.getContent(this.bannerData.url, true));
            this.imageHolder.width = 1670;
            this.imageHolder.height = 728;
            if (this.bannerData.hasOwnProperty("title"))
            {
                this.titleTxt.text = this.bannerData.title;
            };
            if (this.bannerData.hasOwnProperty("action"))
            {
                _local_2 = ((this.bannerData.action == "open:link") ? this.openLink : this.openMenu);
                this.eventHandler.addListener(this.imageHolder, MouseEvent.CLICK, _local_2);
            };
        }

        public function openLink(_arg_1:MouseEvent):*
        {
            navigateToURL(new URLRequest(this.bannerData.link));
            this.closePanel(_arg_1);
        }

        public function openMenu(_arg_1:MouseEvent):void
        {
            LinkMenu.open(this.bannerData.menu);
            this.closePanel(_arg_1);
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        private function destroy():void
        {
            GF.removeAllChild(this.imageHolder);
            this.eventHandler.removeAllEventListeners();
            this.loaderAsset.clear();
            this.eventHandler = null;
            this.loaderAsset = null;
            this.imageHolder = null;
            this.main = null;
            this.bannerData = null;
            GF.removeAllChild(this);
        }


    }
}//package Panels

