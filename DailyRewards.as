// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.DailyRewards

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import Popups.Confirmation;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import Storage.Character;
    import flash.utils.setTimeout;
    import flash.utils.clearTimeout;

    public class DailyRewards extends MovieClip 
    {

        public var claim_3:SimpleButton;
        public var tokenAni:MovieClip;
        public var xpAni:MovieClip;
        public var Icon:MovieClip;
        public var learnAllSkills:MovieClip;
        public var btnClose:SimpleButton;
        public var buyGold:SimpleButton;
        public var buyTokens:SimpleButton;
        public var claim_0:SimpleButton;
        public var claim_1:SimpleButton;
        public var claim_2:SimpleButton;
        public var icon:MovieClip;
        public var tokenIcon:MovieClip;
        public var txt_0:TextField;
        public var txt_1:TextField;
        public var txt_2:TextField;
        public var txt_gold:TextField;
        public var txt_token:TextField;
        public var xpBounsIcon:MovieClip;
        public var xp_data:MovieClip;
        public var main:*;
        internal var conf:Confirmation;
        internal var element:int;
        private var eventHandler:EventHandler = new EventHandler();
        private var timestamp:*;
        private var timeout:*;

        public function DailyRewards(_arg_1:*)
        {
            this.main = _arg_1;
            this.main.loading(true);
            this.updateDisplay();
            this.tokenAni.addFrameScript(25, this.callUpdate);
            this.xpAni.addFrameScript(25, this.callUpdate);
            this.eventHandler.addListener(this.learnAllSkills.btnClose, MouseEvent.CLICK, this.onClosePopup);
        }

        public function callUpdate():*
        {
            this.updateDisplay();
        }

        public function updateDisplay():*
        {
            this.learnAllSkills.visible = false;
            this.txt_0.text = "";
            this.txt_1.text = "";
            this.claim_0.visible = false;
            this.claim_1.visible = false;
            this.claim_2.visible = false;
            this.claim_3.visible = false;
            if (int(Character.character_lvl) >= 80)
            {
                this.txt_2.visible = false;
                this.claim_2.visible = true;
                this.claim_2.addEventListener(MouseEvent.CLICK, this.claimScroll);
            };
            this.tokenAni.gotoAndStop("idle");
            this.xpAni.gotoAndStop("idle");
            this.eventHandler.addListener(this.btnClose, MouseEvent.CLICK, this.onClose);
            this.getInfo();
            this.main.HUD.setBasicData();
        }

        public function getInfo():*
        {
            this.main.amf_manager.service("DailyReward.getDailyData", [Character.char_id, Character.sessionkey], this.onGetData);
        }

        public function onGetData(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                this.txt_0.text = ((_arg_1.tokens == true) ? "" : "Come back tomorrow!");
                if (!_arg_1.xp)
                {
                    if (_arg_1.timer > 0)
                    {
                        this.timestamp = _arg_1.timer;
                        this.updateTimeLeft();
                    }
                    else
                    {
                        this.txt_1.text = "Come back tomorrow!";
                    };
                };
                this.claim_0.visible = (_arg_1.tokens == true);
                this.claim_1.visible = (_arg_1.xp == true);
                this.claim_3.visible = (_arg_1.xp == true);
                if (((this.claim_1.visible) && (this.claim_3.visible)))
                {
                    this.txt_1.text = "";
                };
                if (int(Character.character_lvl) >= 80)
                {
                    this.claim_2.visible = (_arg_1.scroll == false);
                };
                this.eventHandler.addListener(this.claim_0, MouseEvent.CLICK, this.claimTokens);
                this.eventHandler.addListener(this.claim_1, MouseEvent.CLICK, this.claimXP);
                this.eventHandler.addListener(this.claim_3, MouseEvent.CLICK, this.claimDoubleXP);
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.getNotice(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
            this.main.loading(false);
        }

        public function claimTokens(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("DailyReward.getDailyTokenData", [Character.char_id, Character.sessionkey], this.onClaimedTokens);
        }

        public function onClaimedTokens(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.tokenAni.gotoAndPlay("show");
                Character.account_tokens = (Character.account_tokens + 25);
                this.claim_0.visible = false;
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.getNotice(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        public function claimXP(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("DailyReward.claimDailyXP", [Character.char_id, Character.sessionkey], this.onClaimedXP);
        }

        public function onClaimedXP(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.xpAni.gotoAndPlay("show");
                this.main.giveReward(1, ("xp_" + _arg_1.reward));
                Character.character_xp = _arg_1.xp;
                if (_arg_1.level_up == true)
                {
                    Character.character_lvl = String((int(Character.character_lvl) + 1));
                    Character.character_xp = _arg_1.xp;
                    this.main.levelUp();
                    this.main.HUD.loadFrame();
                };
                this.claim_1.visible = false;
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.getNotice(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        public function claimDoubleXP(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("DailyReward.claimDoubleXP", [Character.char_id, Character.sessionkey], this.onClaimedDoubleXP);
        }

        public function onClaimedDoubleXP(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.xpAni.gotoAndPlay("show");
                this.claim_1.visible = false;
                this.claim_3.visible = false;
                this.timestamp = _arg_1.timer;
                this.updateTimeLeft();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.getNotice(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        public function updateTimeLeft():void
        {
            if (this.timestamp == null)
            {
                return;
            };
            var _local_1:* = 86400;
            var _local_2:* = 3600;
            var _local_3:* = 60;
            var _local_4:* = this.timestamp;
            var _local_5:* = Math.floor((_local_4 / _local_1));
            var _local_6:* = Math.floor(((_local_4 - (_local_5 * _local_1)) / _local_2));
            var _local_7:* = Math.floor((((_local_4 - (_local_5 * _local_1)) - (_local_6 * _local_2)) / _local_3));
            this.txt_1.text = ((((_local_5 + ":") + _local_6) + ":") + _local_7);
            this.timeout = setTimeout(this.updateTimeLeft, 10000);
            this.timestamp = (this.timestamp - 10);
        }

        public function claimScroll(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("DailyReward.claimScrollOfWisdom", [Character.char_id, Character.sessionkey], this.onClaimedScroll);
        }

        public function onClaimedScroll(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.giveReward(1, "essential_10");
                Character.addEssentials("essentia_10");
                this.claim_2.visible = false;
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.getNotice(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        public function claimSkills(_arg_1:MouseEvent):*
        {
            this.main.loadExternalSwfPanel("ScrollOfWisdom", "ScrollOfWisdom");
        }

        public function onClosePopup(_arg_1:*=null):*
        {
            this.learnAllSkills.visible = false;
        }

        public function onClose(_arg_1:*=null):*
        {
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            if (this.timeout)
            {
                clearTimeout(this.timeout);
            };
            this.timeout = null;
            this.main.HUD.setBasicData();
            this.main = null;
            parent.removeChild(this);
        }


    }
}//package Panels

