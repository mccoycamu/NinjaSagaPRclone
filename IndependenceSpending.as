// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.IndependenceSpending

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.GameData;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import com.utils.GF;

    public dynamic class IndependenceSpending extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var eventHandler:EventHandler;
        private var main:*;
        private var response:Object;
        private var rewardData:Array = [];
        private var targetClaim:int;

        public function IndependenceSpending(_arg_1:*, _arg_2:*)
        {
            var _local_3:Object = GameData.get("independence2025");
            var _local_4:int;
            while (_local_4 < _local_3.spending.length)
            {
                this.rewardData.push({
                    "rewardId":_local_3.spending[_local_4].id.replace("%s", Character.character_gender),
                    "rewardReq":_local_3.spending[_local_4].requirement,
                    "rewardQty":_local_3.spending[_local_4].quantity
                });
                _local_4++;
            };
            super();
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.getData();
        }

        private function getData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("IndependenceEvent2025.getSpendingRewards", [Character.char_id, Character.sessionkey], this.onGetEventData);
        }

        private function onGetEventData(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.initUI();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
                this.destroy();
            };
        }

        private function initUI():void
        {
            this.eventHandler.addListener(this.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            this.panelMC.tokenTxt.text = this.response.spent;
            var _local_1:int;
            while (_local_1 < 13)
            {
                this.panelMC[("IconMc_" + _local_1)].tokenTxt.text = this.rewardData[_local_1].rewardReq;
                this.panelMC[("arrowMc_" + _local_1)].visible = false;
                if (((this.response.spent < this.rewardData[_local_1].rewardReq) || (this.response.rewards[_local_1] == true)))
                {
                    this.main.initButtonDisable(this.panelMC[("IconMc_" + _local_1)].claimBtn, this.claimReward, "Claim");
                    this.panelMC[("IconMc_" + _local_1)].claimBtn.visible = false;
                    this.panelMC[("IconMc_" + _local_1)].IconMc.lockMC.visible = true;
                }
                else
                {
                    this.main.initButton(this.panelMC[("IconMc_" + _local_1)].claimBtn, this.claimReward, "Claim");
                    this.panelMC[("IconMc_" + _local_1)].claimBtn.visible = true;
                    this.panelMC[("IconMc_" + _local_1)].IconMc.lockMC.visible = false;
                };
                if (this.response.rewards[_local_1] == true)
                {
                    this.panelMC[("IconMc_" + _local_1)].IconMc.tickMC.visible = true;
                    this.panelMC[("IconMc_" + _local_1)].IconMc.lockMC.visible = false;
                }
                else
                {
                    this.panelMC[("IconMc_" + _local_1)].IconMc.tickMC.visible = false;
                };
                this.panelMC[("IconMc_" + _local_1)].IconMc.amountTxt.visible = false;
                this.panelMC[("IconMc_" + _local_1)].IconMc.ownedTxt.visible = false;
                if (Character.hasSkill(this.rewardData[_local_1].rewardId) > 0)
                {
                    this.panelMC[("IconMc_" + _local_1)].IconMc.ownedTxt.visible = true;
                    this.panelMC[("IconMc_" + _local_1)].IconMc.ownedTxt.text = "Owned";
                };
                if (Character.isItemOwned(this.rewardData[_local_1].rewardId) > 0)
                {
                    this.panelMC[("IconMc_" + _local_1)].IconMc.ownedTxt.visible = true;
                    this.panelMC[("IconMc_" + _local_1)].IconMc.ownedTxt.text = "Owned";
                };
                if (this.rewardData[_local_1].rewardQty > 1)
                {
                    this.panelMC[("IconMc_" + _local_1)].IconMc.amountTxt.visible = true;
                    this.panelMC[("IconMc_" + _local_1)].IconMc.amountTxt.text = ("x" + String(this.rewardData[_local_1].rewardQty));
                };
                NinjaSage.loadItemIcon(this.panelMC[("IconMc_" + _local_1)].IconMc, this.rewardData[_local_1].rewardId);
                _local_1++;
            };
        }

        private function claimReward(_arg_1:MouseEvent):void
        {
            this.targetClaim = _arg_1.currentTarget.parent.name.replace("IconMc_", "");
            this.main.loading(false);
            this.main.amf_manager.service("IndependenceEvent2025.claimSpendingRewards", [Character.char_id, Character.sessionkey, this.rewardData[this.targetClaim].rewardReq], this.onRewardClaimed);
        }

        private function onRewardClaimed(_arg_1:Object):void
        {
            if (_arg_1.status == 1)
            {
                Character.addRewards(this.rewardData[this.targetClaim].rewardId);
                this.main.giveReward(1, this.rewardData[this.targetClaim].rewardId, "independence");
                this.response.rewards[this.targetClaim] = true;
                this.initUI();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.eventHandler.removeAllEventListeners();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.main = null;
            this.eventHandler = null;
            this.response = null;
            this.rewardData.length = 0;
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
        }


    }
}//package id.ninjasage.features

