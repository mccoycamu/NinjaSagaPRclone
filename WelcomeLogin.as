// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.WelcomeLogin

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import com.utils.GF;

    public dynamic class WelcomeLogin extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var rewardData:Array = [];
        private var main:*;
        private var eventHandler:EventHandler;
        private var response:Object;
        private var selectedLogin:int;

        public function WelcomeLogin(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2;
            this.eventHandler = new EventHandler();
            this.getEventData();
        }

        private function getEventData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("WelcomeLogin.get", [Character.char_id, Character.sessionkey], this.eventDataResponse);
        }

        private function eventDataResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.rewardData = _arg_1.rewards;
                this.initUI();
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
        }

        private function initUI():void
        {
            this.eventHandler.addListener(this.panelMC.panelMC.closeBtn, MouseEvent.CLICK, this.closePanel);
            var _local_1:* = 0;
            while (_local_1 < 7)
            {
                this.panelMC.panelMC[("day_" + _local_1)].dayTxt.text = ("Day " + (_local_1 + 1));
                this.main.initButton(this.panelMC.panelMC[("day_" + _local_1)].claimBtn, this.claimReward, "Claim");
                if (((this.response.rewards[_local_1].c == 0) && ((this.response.logins - 1) >= _local_1)))
                {
                    this.panelMC.panelMC[("day_" + _local_1)].tick.visible = false;
                    this.panelMC.panelMC[("day_" + _local_1)].lock.visible = false;
                    this.panelMC.panelMC[("day_" + _local_1)].claimBtn.visible = true;
                }
                else
                {
                    if (((this.response.rewards[_local_1].c == 0) && ((this.response.logins - 1) < _local_1)))
                    {
                        this.panelMC.panelMC[("day_" + _local_1)].tick.visible = false;
                        this.panelMC.panelMC[("day_" + _local_1)].lock.visible = true;
                        this.panelMC.panelMC[("day_" + _local_1)].claimBtn.visible = false;
                    }
                    else
                    {
                        if (this.response.rewards[_local_1].c == 1)
                        {
                            this.panelMC.panelMC[("day_" + _local_1)].tick.visible = true;
                            this.panelMC.panelMC[("day_" + _local_1)].lock.visible = false;
                            this.panelMC.panelMC[("day_" + _local_1)].claimBtn.visible = false;
                        };
                    };
                };
                this.panelMC.panelMC[("day_" + _local_1)].iconMc.rewardIcon.amountTxt.text = ((this.rewardData[_local_1].r.split(":")[1] != null) ? ("x" + this.rewardData[_local_1].r.split(":")[1]) : "");
                NinjaSage.loadItemIcon(this.panelMC.panelMC[("day_" + _local_1)].iconMc, this.rewardData[_local_1].r.split(":")[0]);
                _local_1++;
            };
        }

        private function claimReward(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.selectedLogin = _arg_1.currentTarget.parent.name.replace("day_", "");
            this.main.amf_manager.service("WelcomeLogin.claim", [Character.char_id, Character.sessionkey, this.selectedLogin], this.onRewardClaimed);
        }

        private function onRewardClaimed(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.addRewards(_arg_1.rewards);
                this.main.giveReward(1, _arg_1.rewards);
                this.main.HUD.setBasicData();
                this.panelMC.panelMC[("day_" + this.selectedLogin)].tick.visible = true;
                this.panelMC.panelMC[("day_" + this.selectedLogin)].lock.visible = false;
                this.panelMC.panelMC[("day_" + this.selectedLogin)].claimBtn.visible = false;
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
            this.main.clearEvents();
            this.main.removeExternalSwfPanel();
            this.eventHandler.removeAllEventListeners();
            this.main = null;
            this.eventHandler = null;
            this.response = null;
            this.rewardData = [];
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

