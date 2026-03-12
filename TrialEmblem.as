// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.TrialEmblem

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import Storage.Character;

    public class TrialEmblem extends MovieClip 
    {

        public var btn_close:SimpleButton;
        public var btn_renew:SimpleButton;
        public var txt_totalDay:TextField;
        public var main:*;

        public function TrialEmblem(_arg_1:*)
        {
            this.main = _arg_1;
            this.btn_close.addEventListener(MouseEvent.CLICK, this.closePanel);
            this.btn_renew.metaData = {"packageId":"id.ninjasage.trial.emblem"};
            this.btn_renew.addEventListener(MouseEvent.CLICK, this.goToSite);
            this.getBasicData();
        }

        public function getBasicData():void
        {
            this.txt_totalDay.text = (Character.emblem_duration + " Days Remaining");
            if (int(Character.account_type) == 0)
            {
                this.txt_totalDay.text = "Free User";
            };
            if (((int(Character.account_type) == 1) && (int(Character.emblem_duration) == -1)))
            {
                this.txt_totalDay.text = "Premium";
                this.btn_renew.visible = false;
            };
        }

        public function goToSite(_arg_1:MouseEvent):void
        {
            this.main.payment.purchaseProduct(_arg_1.currentTarget.metaData.packageId);
        }

        public function closePanel(_arg_1:MouseEvent):*
        {
            this.btn_close.removeEventListener(MouseEvent.CLICK, this.closePanel);
            this.btn_renew.removeEventListener(MouseEvent.CLICK, this.closePanel);
            this.main = null;
            parent.removeChild(this);
        }


    }
}//package Panels

