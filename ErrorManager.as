// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Managers.ErrorManager

package Managers
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import flash.events.MouseEvent;
    import br.com.stimuli.loading.BulkLoader;
    import com.utils.GF;
    import flash.system.System;

    public class ErrorManager extends MovieClip 
    {

        public var btn_refresh:SimpleButton;
        public var errorCode:TextField;
        public var errorMsg:TextField;
        public var errorTitle:TextField;
        public var main:*;

        public function ErrorManager(_arg_1:*)
        {
            this.main = _arg_1;
            this.btn_refresh.addEventListener(MouseEvent.CLICK, this.logout);
        }

        public function errorInfo(_arg_1:String="2000"):*
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            switch (_arg_1)
            {
                case "110":
                    _local_2 = "Maintenance";
                    _local_3 = "The game is currently under maintenance.";
                    break;
                case "1100":
                    _local_2 = "Banned";
                    _local_3 = "Your account has been banned due to hacking activities detected. Please reach out to support.";
                    break;
                case "282":
                    _local_2 = "Invalid Equipped Gear";
                    _local_3 = "You have equipped an item you don't have permission for.";
                    break;
                case "269":
                    _local_2 = "Item Not Sellable";
                    _local_3 = "The item you are attempting to sell cannot be sold.";
                    break;
                case "230":
                    _local_2 = "Invalid Sell Quantity";
                    _local_3 = "You are trying to sell more items than you have in your inventory.";
                    break;
                case "230":
                    _local_2 = "Invalid Sell Quantity";
                    _local_3 = "You are trying to sell more items than you have in your inventory.";
                    break;
                case "918":
                    _local_2 = "Invalid Talent";
                    _local_3 = "The talent you are trying to learn does not exist.";
                    break;
                case "666":
                    _local_2 = "Account Problem";
                    _local_3 = "Oops! Something Went Wrong Error. Please relogin your account. If this common occur, please reach out the contact support";
                    break;
                default:
                    _local_2 = "Connection Error";
                    _local_3 = "You have disconnected from the server.";
            };
            this.errorTitle.text = _local_2;
            this.errorMsg.text = _local_3;
            this.errorCode.text = ("Error Code: " + _arg_1);
        }

        internal function logout(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            this.btn_refresh.removeEventListener(MouseEvent.CLICK, this.logout);
            this.main.removeAllChildsFromLoader();
            this.main.removeAllLoadedPanels();
            this.main.loadPanel("Managers.LoginManager");
            for each (_local_2 in ["combat", "assets", "skills", "specialclass", "talents", "panels", "etc"])
            {
                BulkLoader.getLoader(_local_2).removeAll();
            };
            if (((this.main) && (!(this.main.combat == null))))
            {
                this.main.combat.destroy();
                this.main.combat = null;
            };
            GF.removeAllChild(this);
            System.gc();
            this.main = null;
        }


    }
}//package Managers

