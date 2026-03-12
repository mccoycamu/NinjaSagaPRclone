// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.ClanCreate

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import Storage.Character;
    import id.ninjasage.EventHandler;
    import Managers.NinjaSage;
    import flash.events.MouseEvent;
    import Popups.Confirmation;
    import com.utils.GF;
    import id.ninjasage.Clan;

    public class ClanCreate extends MovieClip 
    {

        public var btn_ClanShop:SimpleButton;
        public var btn_clan_list:SimpleButton;
        public var btn_close:SimpleButton;
        public var btn_create:SimpleButton;
        public var clan_name:TextField;
        public var iconMc0:MovieClip;
        public var iconMc1:MovieClip;
        public var iconMc2:MovieClip;
        public var iconMc3:MovieClip;
        public var iconMc4:MovieClip;
        public var main:*;
        public var clan_rews:* = ["wpn_400", "back_100", ("hair_78_" + Character.character_gender), ("set_300_" + Character.character_gender), "skill_01"];
        public var confirmation:*;
        public var eventHandler:*;

        public function ClanCreate(_arg_1:*)
        {
            this.main = _arg_1;
            this.eventHandler = new EventHandler();
            this.addButtonListeners();
            this.showRewards();
        }

        public function showRewards():*
        {
            var _local_1:* = 0;
            while (_local_1 < 5)
            {
                NinjaSage.loadIconSWF(((_local_1 < 4) ? "items" : "skills"), this.clan_rews[_local_1], this[("iconMc" + _local_1)]);
                _local_1++;
            };
        }

        public function addButtonListeners():*
        {
            this.eventHandler.addListener(this.btn_create, MouseEvent.CLICK, this.createClanConfirmation, false, 0, true);
            this.eventHandler.addListener(this.btn_clan_list, MouseEvent.CLICK, this.onClanList, false, 0, true);
            this.eventHandler.addListener(this.btn_ClanShop, MouseEvent.CLICK, this.openPanel, false, 0, true);
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.onClosePanel, false, 0, true);
        }

        public function createClanConfirmation(e:MouseEvent):*
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure want to create clan?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():*
            {
                removeChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onCreateClanReq);
            addChild(this.confirmation);
        }

        public function onCreateClanReq(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            var _local_2:Array;
            if (this["clan_name"].text == "")
            {
                this.main.getNotice("Clan name should not be empty!");
            }
            else
            {
                this.main.loading(true);
                Clan.instance.createClan(this.clan_name.text, this.onCreateClanRes);
            };
        }

        public function onCreateClanRes(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (_arg_1 == "ok")
            {
                Character.account_tokens = (Character.account_tokens - 1000);
                Clan.instance.getClanData(this.onGetClanData);
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getError("");
            };
        }

        public function onGetClanData(_arg_1:*, _arg_2:*=null):*
        {
            if ((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("clan"))) && (_arg_1.hasOwnProperty("char"))))
            {
                Character.clan_data = _arg_1.clan;
                Character.clan_char_data = _arg_1.char;
                this.main.loadPanel("Panels.ClanVillage");
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            this.onClosePanel(null);
        }

        public function onClanList(_arg_1:MouseEvent):*
        {
            this.main.loadPanel("Panels.ClanRequest");
            this.onClosePanel(_arg_1);
        }

        private function openPanel(_arg_1:MouseEvent):*
        {
            var _local_2:String = _arg_1.currentTarget.name.replace("btn_", "");
            this.main.loadPanel(("Panels." + _local_2));
        }

        public function onClosePanel(_arg_1:MouseEvent):*
        {
            var _local_2:* = 0;
            while (_local_2 < 5)
            {
                GF.removeAllChild(this[("iconMc" + _local_2)]);
                _local_2++;
            };
            NinjaSage.clearLoader();
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.main = null;
            GF.removeAllChild(this);
            parent.removeChild(this);
        }


    }
}//package Panels

