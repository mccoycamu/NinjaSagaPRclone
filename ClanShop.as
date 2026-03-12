// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.ClanShop

package Panels
{
    import id.ninjasage.features.BaseShop;
    import flash.display.SimpleButton;
    import flash.display.MovieClip;
    import flash.text.TextField;
    import flash.events.MouseEvent;

    public dynamic class ClanShop extends BaseShop 
    {

        public var btn_ClanItemUpgrade:SimpleButton;
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

        public function ClanShop(main:*)
        {
            super(main);
            this.hideMovieclips();
            this.initShopData("clan");
            this.eventHandler.addListener(this.btn_ClanItemUpgrade, MouseEvent.CLICK, function (_arg_1:MouseEvent)
            {
                internal::main.loadPanel("Panels.ClanItemUpgrade");
            });
        }

        protected function hideMovieclips():void
        {
            this.mcSkill.visible = false;
            this.mcSet.visible = false;
            this.mcHairstyle.visible = false;
            this.mcAccessory.visible = false;
        }


    }
}//package Panels

