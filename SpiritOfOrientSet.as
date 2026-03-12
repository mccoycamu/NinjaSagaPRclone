// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.SpiritOfOrientSet

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import Popups.Confirmation;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import com.utils.GF;

    public dynamic class SpiritOfOrientSet extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var costumeData:Object = {};
        private var price:int;
        private var target:int;
        private var confirmation:Confirmation;
        private var eventHandler:EventHandler;
        private var main:*;

        public function SpiritOfOrientSet(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.getData();
        }

        private function getData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("ExoticPackage.get", [Character.char_id, Character.sessionkey], this.getDataResponse);
        }

        private function getDataResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.costumeData = _arg_1.packages.spiritoforient;
            }
            else
            {
                if (((_arg_1.status > 1) && (_arg_1.hasOwnProperty("result"))))
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
            this.initUI();
        }

        private function initUI():void
        {
            this.panelMC.panelMC.goldMC.visible = false;
            this.panelMC.panelMC.tokenMC.visible = true;
            this.panelMC.panelMC.tokenMC.tokenTxt.text = this.costumeData.price;
            this.eventHandler.addListener(this.panelMC.panelMC.tokenMC.tokenBuy, MouseEvent.CLICK, this.showConfirmation);
            var _local_1:* = 0;
            while (_local_1 < this.costumeData.items.length)
            {
                NinjaSage.loadItemIcon(this.panelMC.panelMC[("icon_" + _local_1)], this.costumeData.items[_local_1]);
                _local_1++;
            };
            this.panelMC.panelMC.tokenTxt.text = Character.account_tokens;
            this.panelMC.panelMC.goldTxt.text = Character.character_gold;
            this.panelMC.panelMC.titleTxt.text = this.costumeData.name;
            this.eventHandler.addListener(this.panelMC.panelMC.getMoreBtn, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.panelMC.panelMC.getMoreBtn1, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.panelMC.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
        }

        private function showConfirmation(e:MouseEvent):void
        {
            var price:* = (this.costumeData.price + " Token(s)");
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (((("Confirm buying " + this.costumeData.name) + " for ") + price) + " ?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function (_arg_1:MouseEvent):*
            {
                GF.removeAllChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.buyPackage);
            this.panelMC.addChild(this.confirmation);
        }

        private function buyPackage(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.confirmation);
            this.main.loading(true);
            this.main.amf_manager.service("ExoticPackage.buy", [Character.char_id, Character.sessionkey, "spiritoforient"], this.buyResponse);
        }

        private function buyResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.addRewards(_arg_1.rewards);
                this.main.giveReward(1, _arg_1.rewards, "anniversary");
                Character.account_tokens = (int(Character.account_tokens) - this.costumeData.price);
                this.panelMC.panelMC.tokenTxt.text = Character.account_tokens;
                this.panelMC.panelMC.goldTxt.text = Character.character_gold;
                this.panelMC.panelMC.goldMC.visible = false;
                this.main.HUD.setBasicData();
            }
            else
            {
                if (((_arg_1.status > 1) && (_arg_1.hasOwnProperty("result"))))
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.showMessage(_arg_1.error);
                };
            };
        }

        private function openRecharge(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Recharge");
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            var _local_1:* = 0;
            while (_local_1 < 6)
            {
                GF.removeAllChild(this.panelMC.panelMC[("icon_" + _local_1)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.panelMC[("icon_" + _local_1)].skillIcon.iconHolder);
                _local_1++;
            };
            this.main.removeExternalSwfPanel();
            this.eventHandler.removeAllEventListeners();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.costumeData = [];
            this.main = null;
            this.eventHandler = null;
            this.confirmation = null;
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

