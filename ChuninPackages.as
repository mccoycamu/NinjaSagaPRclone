// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ChuninPackages

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import Storage.Character;
    import id.ninjasage.EventHandler;
    import Popups.Confirmation;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class ChuninPackages extends MovieClip 
    {

        public var panelMC:MovieClip;
        public var ancestorPackage:MovieClip;
        public var btn_close:SimpleButton;
        public var chuninPackage:MovieClip;
        private var rewardsArray:Object = {
            "chunin_package":["skill_399", "wpn_864", "back_536"],
            "ancestor_package":[("hair_309_" + Character.character_gender), ("set_1155_" + Character.character_gender), "back_605", "wpn_1341"]
        };
        private var main:*;
        private var eventHandler:EventHandler;
        private var confirmation:Confirmation;

        public function ChuninPackages(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.init();
        }

        private function init():*
        {
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.chuninPackage.btn_buy, MouseEvent.CLICK, this.showConfirmation);
            this.panelMC.ancestorPackage.btn_buy.metaData = {"packageId":"id.ninjasage.ancestor"};
            this.eventHandler.addListener(this.panelMC.ancestorPackage.btn_buy, MouseEvent.CLICK, this.openMerchant);
            var _local_1:* = 0;
            while (_local_1 < 3)
            {
                NinjaSage.loadItemIcon(this.panelMC.chuninPackage.rewardMC[("iconMC" + _local_1)], this.rewardsArray.chunin_package[_local_1]);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < 4)
            {
                NinjaSage.loadItemIcon(this.panelMC.ancestorPackage.rewardMC[("iconMC" + _local_1)], this.rewardsArray.ancestor_package[_local_1]);
                _local_1++;
            };
        }

        private function showConfirmation(e:MouseEvent):*
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Confirm buying Chunin Packages for 2000 Tokens ?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function (_arg_1:MouseEvent):*
            {
                GF.removeAllChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.buyPackage);
            this.panelMC.addChild(this.confirmation);
        }

        private function buyPackage(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
            this.main.loading(true);
            this.main.amf_manager.service("PackageEvent.buyChuninPackage", [Character.char_id, Character.sessionkey], this.buyResponse);
        }

        private function buyResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.giveReward(1, "skill_399,wpn_864,back_536");
                Character.addWeapon("wpn_864");
                Character.addBack("back_536");
                Character.updateSkills("skill_399", true);
                Character.account_tokens = (int(Character.account_tokens) - 2000);
                this.main.HUD.setBasicData();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.showMessage(_arg_1.error);
                };
            };
        }

        private function openMerchant(_arg_1:MouseEvent):*
        {
            this.main.payment.purchaseProduct(_arg_1.currentTarget.metaData.packageId);
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():*
        {
            var _local_1:* = 0;
            while (_local_1 < 3)
            {
                GF.removeAllChild(this.panelMC.chuninPackage.rewardMC[("iconMC" + _local_1)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.chuninPackage.rewardMC[("iconMC" + _local_1)].skillIcon.iconHolder);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < 4)
            {
                GF.removeAllChild(this.panelMC.ancestorPackage.rewardMC[("iconMC" + _local_1)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.ancestorPackage.rewardMC[("iconMC" + _local_1)].skillIcon.iconHolder);
                _local_1++;
            };
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            this.main = null;
            this.character = null;
            this.eventHandler = null;
            this.confirmation = null;
            this.rewardsArray = [];
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

