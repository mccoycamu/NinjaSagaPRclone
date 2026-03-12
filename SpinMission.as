// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.SpinMission

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import flash.utils.Timer;
    import Storage.Character;
    import Managers.NinjaSage;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class SpinMission extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var response:Object;
        private var chance:Object;
        private var rewardsArray:Array = [];
        private var rewardsQty:Array = [];
        private var timeArray:Array;
        private var loopPosition:int;
        private var loopPositionMax:int = 6;
        private var timer:Timer;
        private var itemGet:String;

        public function SpinMission(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.onShow();
            this.panelMC.addFrameScript(8, this.frame9, 14, this.frame15);
        }

        public function onShow():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("DailyReward.getMissionGradeSSpin", [Character.char_id, Character.sessionkey], this.onGetData);
        }

        public function onGetData(_arg_1:Object):*
        {
            var _local_2:*;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                _local_2 = 0;
                while (_local_2 < _arg_1.rewards.length)
                {
                    this.rewardsArray.push(_arg_1.rewards[_local_2].id);
                    this.rewardsQty.push(_arg_1.rewards[_local_2].qty);
                    if ((((((this.rewardsArray[_local_2].indexOf("gold_") >= 0) || (this.rewardsArray[_local_2].indexOf("tokens_") >= 0)) || (this.rewardsArray[_local_2].indexOf("tp_") >= 0)) || (this.rewardsArray[_local_2].indexOf("xp_") >= 0)) || (this.rewardsArray[_local_2].indexOf("ss_") >= 0)))
                    {
                        this.rewardsQty[_local_2] = null;
                    };
                    _local_2++;
                };
                this.chance = _arg_1.spin;
                this.panelMC.gotoAndPlay(1);
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                    this.hide();
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        public function initUI():*
        {
            this.panelMC.panel.titleTxt.text = "Grade S Mission Reward";
            this.panelMC.panel.chanceTxt.text = ((("Chance: " + this.chance.chance) + "/") + this.chance.max);
            var _local_1:* = 0;
            while (_local_1 < this.rewardsArray.length)
            {
                NinjaSage.loadItemIcon(this.panelMC.panel[("iconMc2_" + _local_1)].rewardIcon.iconHolder, this.rewardsArray[_local_1], "icon");
                this.panelMC.panel[("iconMc2_" + _local_1)].amountTxt.text = ((this.rewardsQty[_local_1] == null) ? "" : ("x" + this.rewardsQty[_local_1]));
                this.panelMC.panel[("iconMc2_" + _local_1)].gotoAndStop(1);
                _local_1++;
            };
            this.eventHandler.addListener(this.panelMC.panel.btnClose, MouseEvent.CLICK, this.hide);
            this.eventHandler.addListener(this.panelMC.panel.btnSpin, MouseEvent.CLICK, this.getReward);
        }

        public function getReward(_arg_1:MouseEvent):*
        {
            this.main.amf_manager.service("DailyReward.getRewardMissionGradeS", [Character.char_id, Character.sessionkey], this.startSpin);
        }

        public function startSpin(_arg_1:Object):void
        {
            var _local_2:*;
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.itemGet = this.response.reward;
                _local_2 = this.itemGet.split(":");
                if (this.rewardsArray.indexOf(_local_2[0]) >= 0)
                {
                    this.timeArray = this.getTimeArray(this.rewardsArray.indexOf(_local_2[0]));
                    this.loopPosition = -1;
                    this.timeUp();
                }
                else
                {
                    this.main.showMessage("Reward not found");
                    return;
                };
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function timeUp(_arg_1:TimerEvent=null):void
        {
            var _local_3:*;
            var _local_2:int;
            if (this.timer)
            {
                this.timer.stop();
            };
            _local_2 = 0;
            while (_local_2 < this.loopPositionMax)
            {
                this.panelMC.panel[("iconMc2_" + _local_2)].gotoAndStop(1);
                _local_2++;
            };
            if (this.loopPosition >= 0)
            {
                this.panelMC.panel[("iconMc2_" + this.loopPosition)].gotoAndStop(2);
            };
            if (this.timeArray.length > 0)
            {
                this.loopPosition++;
                if (this.loopPosition >= this.loopPositionMax)
                {
                    this.loopPosition = 0;
                };
                this.timer = new Timer(this.timeArray.shift());
                this.eventHandler.addListener(this.timer, TimerEvent.TIMER, this.timeUp);
                this.timer.start();
            }
            else
            {
                _local_2 = 0;
                while (_local_2 < this.rewardsArray.length)
                {
                    this.panelMC.panel[("iconMc2_" + _local_2)].gotoAndStop(1);
                    _local_2++;
                };
                _local_3 = this.itemGet.split(":");
                Character.addRewards(this.itemGet);
                this.main.HUD.setBasicData();
                this.chance.chance--;
                this.panelMC.panel.chanceTxt.text = ((("Chance: " + this.chance.chance) + "/") + this.chance.max);
                if ((((((_local_3[0].indexOf("gold_") >= 0) || (_local_3[0].indexOf("tokens_") >= 0)) || (_local_3[0].indexOf("tp_") >= 0)) || (_local_3[0].indexOf("xp_") >= 0)) || (_local_3[0].indexOf("ss_") >= 0)))
                {
                    this.main.giveReward(1, _local_3[0]);
                }
                else
                {
                    this.main.giveReward(1, ((_local_3[0] + ":") + _local_3[1]));
                };
            };
        }

        private function getTimeArray(_arg_1:int):Array
        {
            var _local_2:int;
            var _local_3:Number = 0;
            var _local_4:Array = [];
            var _local_5:int;
            _local_2 = 0;
            while ((((!(((_local_2 - 2) % 6) == _arg_1)) || (Math.random() > 0.1)) || (_local_5 < 10)))
            {
                if (((_local_2 - 2) % 6) == _arg_1)
                {
                    _local_5++;
                };
                _local_3 = (_local_3 + 0.001);
                _local_4.push(int((1 / _local_3)));
                _local_2++;
            };
            return (_local_4.reverse());
        }

        private function hide(_arg_1:MouseEvent=null):void
        {
            this.destroy();
        }

        internal function frame9():*
        {
            this.initUI();
        }

        internal function frame15():*
        {
            this.panelMC.stop();
        }

        internal function destroy():*
        {
            var _local_1:int;
            while (_local_1 < this.rewardsArray.length)
            {
                this.panelMC.panel[("iconMc2_" + _local_1)].rewardIcon.iconHolder;
                _local_1++;
            };
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            this.rewardsArray = [];
            this.timeArray = [];
            this.loopPosition = null;
            this.loopPositionMax = null;
            this.timer = null;
            this.itemGet = null;
            this.chance = null;
            this.main = null;
            this.eventHandler = null;
            this.response = null;
            this.rewardsArray = null;
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

