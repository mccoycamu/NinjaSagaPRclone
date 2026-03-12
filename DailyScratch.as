// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.DailyScratch

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import id.ninjasage.EventHandler;
    import Storage.GameData;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class DailyScratch extends MovieClip 
    {

        public var iconMC:MovieClip;
        public var popupRewardMC:MovieClip;
        public var scratch_0:MovieClip;
        public var btn_close:SimpleButton;
        public var btn_reward:SimpleButton;
        public var loginView:MovieClip;
        public var scratch_1:MovieClip;
        public var scratch_2:MovieClip;
        public var scratch_3:MovieClip;
        public var ticketMc:MovieClip;
        public var rewardMc:MovieClip;
        private var eventHandler:EventHandler = new EventHandler();
        private var rewardData:Array;
        private var grandPrizeData:Array;
        private var selectedScratch:int;
        private var obtainedReward:String;
        private var response:Object;
        private var main:*;

        public function DailyScratch(_arg_1:*)
        {
            var _local_2:* = GameData.get("scratch");
            this.grandPrizeData = _local_2.grand_prize;
            this.rewardData = [];
            var _local_3:int;
            while (_local_3 < _local_2.rewards.length)
            {
                this.rewardData.push(_local_2.rewards[_local_3].replace("%s", Character.character_gender));
                _local_3++;
            };
            super();
            this.main = _arg_1;
            this.initUI();
        }

        private function initUI():void
        {
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.btn_reward, MouseEvent.CLICK, this.openRewardList);
            this.popupRewardMC.visible = false;
            this.rewardMc.visible = false;
            this.loginView.gotoAndStop(1);
            this.ticketMc.gotoAndStop(1);
            var _local_1:int;
            while (_local_1 < 3)
            {
                this[("scratch_" + _local_1)].stop();
                _local_1++;
            };
            this.loadGrandPrizeIcon();
            this.getData();
        }

        private function getData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("DailyScratch.getData", [Character.char_id, Character.sessionkey], this.onGetData);
        }

        private function onGetData(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.loginView.gotoAndStop(int(this.response.consecutive));
                this.checkScratch();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    if (_arg_1.hasOwnProperty("result"))
                    {
                        this.main.showMessage(_arg_1.result);
                        return;
                    };
                    this.main.showMessage("Unknown Error");
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function checkScratch():void
        {
            this.ticketMc.remainScratch_Txt.text = (("You have " + this.response.ticket) + " FREE SCRATCH now");
            this.ticketMc.gotoAndStop(("left_" + Math.max(1, Math.min(9, this.response.ticket))));
            if (int(this.response.ticket) > 0)
            {
                this.enableScratch();
            }
            else
            {
                this.main.showMessage("You can scratch again tomorrow");
                this.disableScratch();
            };
        }

        private function enableScratch():void
        {
            var _local_1:int;
            while (_local_1 < 3)
            {
                this[("scratch_" + _local_1)].gotoAndStop("idle");
                this.eventHandler.addListener(this[("scratch_" + _local_1)], MouseEvent.CLICK, this.scratchAMF);
                _local_1++;
            };
        }

        private function disableScratch():void
        {
            var _local_1:int;
            while (_local_1 < 3)
            {
                this[("scratch_" + _local_1)].gotoAndStop("idle");
                this.eventHandler.removeListener(this[("scratch_" + _local_1)], MouseEvent.CLICK, this.scratchAMF);
                _local_1++;
            };
        }

        private function scratchAMF(_arg_1:MouseEvent):void
        {
            this.disableScratch();
            this.selectedScratch = _arg_1.currentTarget.name.replace("scratch_", "");
            this.main.amf_manager.service("DailyScratch.scratch", [Character.char_id, Character.sessionkey], this.onGetReward);
        }

        private function onGetReward(_arg_1:Object):void
        {
            if (_arg_1.status == 1)
            {
                this.obtainedReward = _arg_1.reward;
                this[("scratch_" + this.selectedScratch)].gotoAndPlay("select");
                this[("scratch_" + this.selectedScratch)].addFrameScript(23, this.showPopupReward);
                this[("scratch_" + this.selectedScratch)].iconMC.amtTxt.visible = false;
                this[("scratch_" + this.selectedScratch)].iconMC.ownedTxt.visible = false;
                NinjaSage.loadItemIcon(this[("scratch_" + this.selectedScratch)].iconMC, this.obtainedReward);
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    if (_arg_1.hasOwnProperty("result"))
                    {
                        this.main.showMessage(_arg_1.result);
                        return;
                    };
                    this.main.showMessage("Unknown Error");
                    this.enableScratch();
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function showPopupReward():void
        {
            this[("scratch_" + this.selectedScratch)].stop();
            this.eventHandler.addListener(this.popupRewardMC.btn_confirm, MouseEvent.CLICK, this.closePopupReward);
            this.popupRewardMC.iconMC.amtTxt.visible = false;
            this.popupRewardMC.iconMC.ownedTxt.visible = false;
            NinjaSage.loadItemIcon(this.popupRewardMC.iconMC, this.obtainedReward);
            Character.addRewards(this.obtainedReward);
            this.popupRewardMC.visible = true;
        }

        private function closePopupReward(_arg_1:MouseEvent):void
        {
            if (this.response.ticket > 0)
            {
                this.response.ticket--;
            };
            this.popupRewardMC.visible = false;
            this.eventHandler.removeListener(this.popupRewardMC.btn_confirm, MouseEvent.CLICK, this.closePopupReward);
            GF.removeAllChild(this.popupRewardMC.iconMC.rewardIcon.iconHolder);
            GF.removeAllChild(this.popupRewardMC.iconMC.skillIcon.iconHolder);
            this.selectedScratch = -1;
            this.obtainedReward = "";
            this.checkScratch();
        }

        private function loadGrandPrizeIcon():void
        {
            this.iconMC.amtTxt.visible = false;
            this.iconMC.ownedTxt.visible = false;
            NinjaSage.loadItemIcon(this.iconMC, this.grandPrizeData[0]);
        }

        private function openRewardList(_arg_1:MouseEvent):void
        {
            this.rewardMc.visible = true;
            this.eventHandler.addListener(this.rewardMc.btn_close, MouseEvent.CLICK, this.closeRewardList);
            var _local_2:int;
            while (_local_2 < this.rewardData.length)
            {
                this.rewardMc[("iconMC" + _local_2)].amtTxt.visible = false;
                this.rewardMc[("iconMC" + _local_2)].ownedTxt.visible = false;
                NinjaSage.loadItemIcon(this.rewardMc[("iconMC" + _local_2)], this.rewardData[_local_2]);
                _local_2++;
            };
        }

        private function closeRewardList(_arg_1:MouseEvent):void
        {
            this.rewardMc.visible = false;
            this.eventHandler.removeListener(this.rewardMc.btn_close, MouseEvent.CLICK, this.closeRewardList);
            var _local_2:int;
            while (_local_2 < this.rewardData.length)
            {
                GF.removeAllChild(this.rewardMc[("iconMC" + _local_2)].rewardIcon.iconHolder);
                GF.removeAllChild(this.rewardMc[("iconMC" + _local_2)].skillIcon.iconHolder);
                _local_2++;
            };
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.main = null;
            this.response = null;
            this.obtainedReward = null;
            this.rewardData = [];
            this.grandPrizeData = [];
            this.selectedScratch = -1;
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            GF.removeAllChild(this);
            System.gc();
        }


    }
}//package Panels

