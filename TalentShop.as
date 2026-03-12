// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.TalentShop

package Panels
{
    import flash.display.MovieClip;
    import Popups.TalentsShow;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import com.utils.GF;

    public class TalentShop extends MovieClip 
    {

        public var btnEnter:MovieClip;
        public var btnExit:MovieClip;
        public var confirmBox:MovieClip;
        public var show_mc:TalentsShow;
        public var main:*;
        public var eventHandler:* = new EventHandler();

        public function TalentShop(_arg_1:*)
        {
            this.main = _arg_1;
            this.addButtonListeners();
            this.show_mc.visible = false;
            this.main.handleVillageHUDVisibility(false);
            this.confirmBox.gotoAndStop(1);
        }

        public function addButtonListeners():*
        {
            this.main.initButton(this.btnEnter, this.openTalentShop, "Go");
            this.main.initButton(this.btnExit, this.closeThis);
        }

        public function showConfirmationBox(_arg_1:*, _arg_2:*):*
        {
            this.confirmBox.visible = true;
            this.confirmBox.gotoAndStop("show");
            this.confirmBox.displayTxt.text = _arg_1;
            this.eventHandler.addListener(this.confirmBox.yesBtn, MouseEvent.CLICK, _arg_2);
            this.eventHandler.addListener(this.confirmBox.noBtn, MouseEvent.CLICK, this.closeConfirmBox);
        }

        public function closeConfirmBox(_arg_1:MouseEvent):*
        {
            this.confirmBox.visible = false;
        }

        public function closeThis(_arg_1:MouseEvent):*
        {
            this.main.handleVillageHUDVisibility(true);
            this.main.clearEvents();
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.main = null;
            GF.removeAllChild(this.show_mc);
            GF.removeAllChild(this);
        }

        public function openTalentShop(_arg_1:MouseEvent):*
        {
            this.show_mc.visible = true;
            this.show_mc.openThis(this);
        }


    }
}//package Panels

