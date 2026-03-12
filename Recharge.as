// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Recharge

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.MouseEvent;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;

    public class Recharge extends MovieClip 
    {

        public var btn_BonusRecharge:SimpleButton;
        public var btn_close:SimpleButton;
        public var package_1:SimpleButton;
        public var package_2:SimpleButton;
        public var package_3:SimpleButton;
        public var package_4:SimpleButton;
        public var package_5:SimpleButton;
        public var package_6:SimpleButton;
        public var btn_RedeemTicket:SimpleButton;
        public var main:*;

        public function Recharge(_arg_1:*)
        {
            this.main = _arg_1;
            this.btn_close.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.package_1.metaData = {"packageId":"id.ninjasage.tokens.50000"};
            this.package_1.addEventListener(MouseEvent.CLICK, this.buyPack);
            this.package_2.metaData = {"packageId":"id.ninjasage.tokens.25000"};
            this.package_2.addEventListener(MouseEvent.CLICK, this.buyPack);
            this.package_3.metaData = {"packageId":"id.ninjasage.tokens.5000"};
            this.package_3.addEventListener(MouseEvent.CLICK, this.buyPack);
            this.package_4.metaData = {"packageId":"id.ninjasage.tokens.2500"};
            this.package_4.addEventListener(MouseEvent.CLICK, this.buyPack);
            this.package_5.metaData = {"packageId":"id.ninjasage.tokens.500"};
            this.package_5.addEventListener(MouseEvent.CLICK, this.buyPack);
            this.package_6.metaData = {"packageId":"id.ninjasage.emblem"};
            this.package_6.addEventListener(MouseEvent.CLICK, this.buyPack);
            this.btn_RedeemTicket.addEventListener(MouseEvent.CLICK, this.buyPack);
            this.btn_BonusRecharge.addEventListener(MouseEvent.CLICK, this.buyPack);
        }

        internal function buyPack(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.name == "btn_RedeemTicket")
            {
                this.main.loadExternalSwfPanel("RedeemTicket", "RedeemTicket");
            }
            else
            {
                if (_arg_1.currentTarget.name == "btn_BonusRecharge")
                {
                    this.main.showMessage("Coming Soon!");
                }
                else
                {
                    navigateToURL(new URLRequest("https://ninjasage.id/merchants"));
                };
            };
        }

        internal function closePanel(_arg_1:MouseEvent):void
        {
            this.main = null;
            this.btn_close.removeEventListener(MouseEvent.CLICK, this.closePanel);
            this.package_1.removeEventListener(MouseEvent.CLICK, this.buyPack);
            this.package_2.removeEventListener(MouseEvent.CLICK, this.buyPack);
            this.package_3.removeEventListener(MouseEvent.CLICK, this.buyPack);
            this.package_4.removeEventListener(MouseEvent.CLICK, this.buyPack);
            this.package_5.removeEventListener(MouseEvent.CLICK, this.buyPack);
            this.package_6.removeEventListener(MouseEvent.CLICK, this.buyPack);
            this.btn_RedeemTicket.removeEventListener(MouseEvent.CLICK, this.buyPack);
            this.btn_BonusRecharge.removeEventListener(MouseEvent.CLICK, this.buyPack);
            parent.removeChild(this);
        }


    }
}//package Panels

