// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.PvpShop

package Panels
{
    import id.ninjasage.features.BaseShop;
    import flash.display.SimpleButton;
    import flash.display.MovieClip;
    import flash.text.TextField;

    public dynamic class PvpShop extends BaseShop 
    {

        public var btn_clear:SimpleButton;
        public var btn_close:SimpleButton;
        public var btn_next:SimpleButton;
        public var btn_prev:SimpleButton;
        public var buyGold:SimpleButton;
        public var char_mc:MovieClip;
        public var currencyType:MovieClip;
        public var item_0:MovieClip;
        public var item_1:MovieClip;
        public var item_10:MovieClip;
        public var item_11:MovieClip;
        public var item_12:MovieClip;
        public var item_13:MovieClip;
        public var item_14:MovieClip;
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
        public var mcEssentials:MovieClip;
        public var mcHairstyle:MovieClip;
        public var mcItems:MovieClip;
        public var mcSet:MovieClip;
        public var mcSkill:MovieClip;
        public var mcWeapon:MovieClip;
        public var popup:MovieClip;
        public var txt_gold:TextField;
        public var txt_page:TextField;

        public function PvpShop(param1:*)
        {
            super(param1);
            this.repositionTabs();
            this.initShopData("pvp");
        }

        private function repositionTabs():void
        {
            var tabs:Array = [this.mcWeapon, this.mcSet, this.mcBackItem, this.mcAccessory, this.mcHairstyle, this.mcItems, this.mcEssentials, this.mcSkill];
            var scale:Number = 0.9;
            var startX:Number = this.mcWeapon.x;
            var endX:Number = this.mcSkill.x;
            var step:Number = ((endX - startX) / (tabs.length - 1));
            var refY:Number = this.mcWeapon.y;
            var i:int;
            while (i < tabs.length)
            {
                tabs[i].scaleX = (tabs[i].scaleY = scale);
                tabs[i].x = (startX + (i * step));
                tabs[i].y = refY;
                i++;
            };
        }


    }
}//package Panels

