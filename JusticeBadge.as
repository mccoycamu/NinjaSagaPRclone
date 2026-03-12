// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.JusticeBadge

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import Managers.StatManager;
    import Popups.Confirmation;
    import Storage.GameData;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import Storage.Character;
    import id.ninjasage.Util;
    import com.utils.GF;

    public dynamic class JusticeBadge extends MovieClip 
    {

        private const MATERIAL_BADGE:String = "material_2110";

        public var panelMC:MovieClip;
        private var eventHandler:*;
        private var main:*;
        private var currentPage:int = 1;
        private var totalPage:int = 1;
        private var selectedExchange:int = -1;
        private var ownedMaterial:int = 0;
        private var rewardArray:Array = [];
        private var statManager:StatManager;
        private var confirmation:Confirmation;
        private var destroyed:Boolean = false;

        public function JusticeBadge(_arg_1:*, _arg_2:*)
        {
            this.rewardArray = GameData.get("justice_badge").rewards;
            this.statManager = new StatManager(this);
            super();
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.eventHandler.addListener(this.panelMC.closeBtn, MouseEvent.CLICK, this.closePanel);
            this.getEventData();
        }

        private function getEventData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("JusticeBadgeEvent2024.getEventData", [Character.char_id, Character.sessionkey], this.eventDataResponse);
        }

        private function eventDataResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.ownedMaterial = _arg_1.materials;
                this.panelMC.endTxt.text = _arg_1.end;
            }
            else
            {
                if (((_arg_1.status > 1) && (_arg_1.hasOwnProperty("result"))))
                {
                    this.main.showMessage(_arg_1.result);
                    this.destroy();
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
            var _local_8:String;
            this.panelMC.ownedTxt.text = ("x" + this.ownedMaterial);
            var _local_1:int;
            while (_local_1 < this.rewardArray.length)
            {
                this.panelMC[("priceTxt_" + _local_1)].text = ("x" + this.rewardArray[_local_1].requirement);
                _local_8 = ((this.ownedMaterial >= this.rewardArray[_local_1].requirement) ? "initButton" : "initButtonDisable");
                var _local_9:* = this.main;
                (_local_9[_local_8](this.panelMC[("exchangeBtn_" + _local_1)], this.exchangeConfirmation, "Exchange"));
                _local_1++;
            };
            var _local_2:int = this.rewardArray[0].id.replace("xp_", "");
            var _local_3:int = int(this.statManager.calculate_xp(int(Character.character_lvl)));
            var _local_4:int = int(((_local_3 * _local_2) / 100));
            var _local_5:int = this.rewardArray[1].id.replace("gold_", "");
            var _local_6:int = this.rewardArray[2].id.replace("tp_", "");
            var _local_7:int = this.rewardArray[3].id.replace("ss_", "");
            this.panelMC["rewardTxt_0"].text = (("+" + Util.formatNumberWithDot(_local_4)) + " XP");
            this.panelMC["rewardTxt_1"].text = (Util.formatNumberWithDot(_local_5) + " Gold");
            this.panelMC["rewardTxt_2"].text = (Util.formatNumberWithDot(_local_6) + " TP");
            this.panelMC["rewardTxt_3"].text = (Util.formatNumberWithDot(_local_7) + " SS");
        }

        private function exchangeConfirmation(e:MouseEvent):void
        {
            this.confirmation = new Confirmation();
            this.selectedExchange = e.currentTarget.name.replace("exchangeBtn_", "");
            this.confirmation.txtMc.txt.text = (((("Are you sure that you want to exchange " + this.panelMC[("rewardTxt_" + this.selectedExchange)].text) + " for ") + this.rewardArray[this.selectedExchange].requirement) + " Justice Badge?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():*
            {
                GF.removeAllChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.exchangeBadge);
            this.panelMC.addChild(this.confirmation);
        }

        private function exchangeBadge(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.confirmation);
            this.main.loading(true);
            this.main.amf_manager.service("JusticeBadgeEvent2024.exchange", [Character.char_id, Character.sessionkey, this.rewardArray[this.selectedExchange].requirement], this.onExchangeBadge);
        }

        private function onExchangeBadge(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.addRewards(_arg_1.rewards);
                Character.removeMaterials(this.MATERIAL_BADGE, this.rewardArray[this.selectedExchange].requirement);
                this.ownedMaterial = _arg_1.materials;
                if (_arg_1.level_up)
                {
                    this.main.levelUp();
                };
                Character.character_lvl = _arg_1.level;
                Character.character_xp = _arg_1.xp;
                this.main.giveReward(1, _arg_1.rewards);
                this.main.HUD.loadFrame();
                this.main.HUD.setBasicData();
                this.initUI();
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
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            if (this.destroyed)
            {
                return;
            };
            this.destroyed = true;
            this.main.clearEvents();
            this.main.removeExternalSwfPanel();
            this.eventHandler.removeAllEventListeners();
            this.rewardArray = [];
            this.statManager = null;
            this.confirmation = null;
            this.main = null;
            this.eventHandler = null;
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

