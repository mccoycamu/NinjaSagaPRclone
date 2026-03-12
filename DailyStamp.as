// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.DailyStamp

package Panels
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import Storage.Character;
    import com.utils.GF;
    import Managers.NinjaSage;

    public dynamic class DailyStamp extends MovieClip 
    {

        public var panel:MovieClip;
        internal var rewardsArray:Array;
        public var costs:* = [];
        public var loginCount:* = 0;
        public var main:*;
        private var eventHandler:* = new EventHandler();
        private var selected:int = -1;

        public function DailyStamp(_arg_1:*)
        {
            this.rewardsArray = [];
            this.main = _arg_1;
            this.rew_loading = 0;
            addFrameScript(6, this.frame7, 12, this.frame13, 27, this.frame28);
        }

        internal function frame7():*
        {
            var _local_1:* = 1;
            while (_local_1 <= 31)
            {
                this.panel[("s" + _local_1)].visible = false;
                _local_1++;
            };
            var _local_2:* = 0;
            while (_local_2 < 6)
            {
                this.panel[("tick_" + _local_2)].visible = false;
                this.panel[("btn_claim_" + _local_2)].visible = false;
                _local_2++;
            };
            this.loadData();
        }

        internal function frame13():*
        {
            this.stop();
            this.eventHandler.addListener(this.panel.btnClose, MouseEvent.CLICK, this.closePanel, false, 0, true);
        }

        public function loadData():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("DailyReward.getAttendances", [Character.char_id, Character.sessionkey], this.onDataLoaded);
        }

        public function onDataLoaded(_arg_1:*):*
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            if (int(_arg_1.status) != 1)
            {
                if (("result" in _arg_1))
                {
                    this.main.showMessage(_arg_1.result);
                    return;
                };
                this.main.showMessage("Unknown error");
                return;
            };
            this.rewardsArray = _arg_1.items;
            this.loginCount = _arg_1.count;
            for each (_local_2 in _arg_1.attendances)
            {
                if ((("s" + _local_2) in this.panel))
                {
                    this.panel[("s" + _local_2)].visible = true;
                };
            };
            _local_3 = 0;
            while (_local_3 < 6)
            {
                if (_local_3 < this.rewardsArray.length)
                {
                    this.costs.push(this.rewardsArray[_local_3].price);
                    _local_4 = ("DAY0" + (_local_3 + 1));
                    if (this.panel[_local_4])
                    {
                        this.panel[_local_4].text = this.rewardsArray[_local_3].price;
                    };
                    if (_arg_1.rewards[_local_3] == 1)
                    {
                        this.panel[("tick_" + _local_3)].visible = true;
                        this.panel[("btn_claim_" + _local_3)].visible = false;
                    }
                    else
                    {
                        if (this.loginCount >= this.rewardsArray[_local_3].price)
                        {
                            this.panel[("btn_claim_" + _local_3)].visible = true;
                            this.eventHandler.addListener(this.panel[("btn_claim_" + _local_3)], MouseEvent.CLICK, this.claimAttendance, false, 0, true);
                        };
                    };
                }
                else
                {
                    this.panel[("tick_" + _local_3)].visible = false;
                    this.panel[("btn_claim_" + _local_3)].visible = false;
                };
                _local_3++;
            };
            this.loadRewards();
            this.main.loading(false);
        }

        internal function frame28():*
        {
            this.gotoAndStop("idle");
            GF.removeAllChild(this);
        }

        public function claimAttendance(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.selected = int(_arg_1.currentTarget.name.split("_")[2]);
            this.main.amf_manager.service("DailyReward.claimAttendanceReward", [Character.char_id, Character.sessionkey, this.rewardsArray[this.selected].id], this.onClaimAttendance);
        }

        public function onClaimAttendance(_arg_1:Object):*
        {
            this.main.loading(false);
            if (int(_arg_1.status) != 1)
            {
                if (("result" in _arg_1))
                {
                    this.main.showMessage(_arg_1.result);
                    return;
                };
                this.main.showMessage("Unknown error");
                return;
            };
            var _local_2:* = 0;
            while (_local_2 < 6)
            {
                if (_arg_1.rewards[_local_2] == 1)
                {
                    this.panel[("tick_" + _local_2)].visible = true;
                    this.panel[("btn_claim_" + _local_2)].visible = false;
                }
                else
                {
                    if (this.loginCount >= this.costs[_local_2])
                    {
                        this.panel[("btn_claim_" + _local_2)].visible = true;
                        this.eventHandler.addListener(this.panel[("btn_claim_" + _local_2)], MouseEvent.CLICK, this.claimAttendance, false, 0, true);
                    };
                };
                _local_2++;
            };
            Character.addRewards(_arg_1.reward);
            this.panel[("tick_" + this.selected)].visible = true;
            this.panel[("btn_claim_" + this.selected)].visible = false;
            if (_arg_1.level_up == true)
            {
                Character.character_lvl = String((int(Character.character_lvl) + 1));
                Character.character_xp = _arg_1.xp;
                this.main.levelUp();
                this.main.HUD.loadFrame();
            };
            this.main.HUD.loadFrame();
            this.main.HUD.setBasicData();
            this.main.giveReward(1, _arg_1.reward);
        }

        public function closePanel(_arg_1:MouseEvent):*
        {
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.main = null;
            this.gotoAndPlay("exit");
        }

        public function loadRewards():void
        {
            var _local_1:* = 0;
            while (_local_1 < 6)
            {
                this.panel[("iconMc" + _local_1)].ownedTxt.visible = false;
                this.panel[("iconMc" + _local_1)].amtTxt.visible = false;
                NinjaSage.loadItemIcon(this.panel[("iconMc" + _local_1)], this.rewardsArray[_local_1].item);
                _local_1++;
            };
        }


    }
}//package Panels

