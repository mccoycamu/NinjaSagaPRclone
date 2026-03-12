// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.PetFrenzy

package Panels
{
    import flash.display.MovieClip;
    import id.ninjasage.features.ChristmasMenu;
    import id.ninjasage.EventHandler;
    import com.utils.NumberUtil;
    import flash.utils.setTimeout;
    import com.utils.GF;
    import Managers.NinjaSage;
    import com.hurlant.util.Hex;
    import com.hurlant.crypto.Crypto;
    import Storage.Character;
    import flash.events.MouseEvent;

    public dynamic class PetFrenzy extends MovieClip 
    {

        public var panelMC:MovieClip;
        public var christmasMenu:ChristmasMenu;
        public var win:Boolean = false;
        public var foes:Array = [];
        public var score:int = 0;
        public var ySpeed:Number = 0;
        public var xSpeed:Number = 0;
        public var main:*;
        public var eventHandler:EventHandler;
        public var timerHandler:TimerHandler = new TimerHandler();
        public var remainingTime:int = 60;
        public var destroyed:Boolean = false;
        public var maxScore:int = 120;

        public function PetFrenzy(_arg_1:*, _arg_2:ChristmasMenu)
        {
            this.main = _arg_1;
            this.eventHandler = new EventHandler();
            this.christmasMenu = _arg_2;
            this.init();
        }

        public function getRank():String
        {
            var _local_1:int = this.score;
            if (_local_1 <= 20)
            {
                return ("E");
            };
            if (_local_1 <= 40)
            {
                return ("D");
            };
            if (_local_1 <= 60)
            {
                return ("C");
            };
            if (_local_1 <= 80)
            {
                return ("B");
            };
            if (_local_1 <= 120)
            {
                return ("A");
            };
            return ("S");
        }

        public function init():void
        {
            var _local_3:MovieClip;
            this.destroyed = false;
            this.panelMC.winPopupMC.visible = false;
            this.panelMC.bg.bg.totem.gotoAndStop(1);
            this.panelMC.pointBar.bar.scaleX = Math.max(Math.min((this.score / this.maxScore), 1), 0);
            var _local_1:int = NumberUtil.randomInt(8, 15);
            var _local_2:int;
            while (_local_2 < _local_1)
            {
                this.life();
                _local_2++;
            };
            this.scheduleNextLife();
            this.timerHandler.startTimer(this.panelMC, this.remainingTime, this.isWin, this.updateTimer, "[time]s");
            _local_2 = 0;
            while (_local_2 < 4)
            {
                _local_3 = this.panelMC.bg[("particle" + _local_2)];
                _local_3.visible = false;
                _local_3.mc.gotoAndStop((_local_2 + 1));
                _local_2++;
            };
        }

        public function updateTimer():void
        {
            this.remainingTime--;
        }

        public function scheduleNextLife():void
        {
            if (this.win)
            {
                return;
            };
            var _local_1:int = int((2000 + (Math.random() * 1000)));
            setTimeout(this.onLifeTimer, _local_1);
        }

        public function onLifeTimer():void
        {
            this.life();
            this.scheduleNextLife();
        }

        public function death(f:MovieClip):void
        {
            var slimeStandbyLabel:Object;
            var slimeDeadLabel:Object;
            var slimeEyesIdleLabel:Object;
            var slimeEyesHitLabel:Object;
            var slimeEyesOhLabel:Object;
            var slimeEyesPhewLabel:Object;
            var i:int;
            while (i < this.foes.length)
            {
                if (this.foes[i] == f)
                {
                    GF.removeAllChild(this.foes[i]);
                    slimeStandbyLabel = NinjaSage.getLabelFrames(f, "stand");
                    slimeDeadLabel = NinjaSage.getLabelFrames(f, "die");
                    slimeEyesIdleLabel = NinjaSage.getLabelFrames(f.body.eyes, "idle");
                    slimeEyesHitLabel = NinjaSage.getLabelFrames(f.body.eyes, "hit");
                    slimeEyesOhLabel = NinjaSage.getLabelFrames(f.body.eyes, "oh");
                    slimeEyesPhewLabel = NinjaSage.getLabelFrames(f.body.eyes, "phew");
                    f.addFrameScript((slimeStandbyLabel.end - 1), null);
                    f.addFrameScript((slimeDeadLabel.end - 1), null);
                    f.addFrameScript(0, null);
                    f.body.eyes.addFrameScript((slimeEyesIdleLabel.end - 1), null);
                    f.body.eyes.addFrameScript((slimeEyesOhLabel.end - 1), null);
                    f.body.eyes.addFrameScript((slimeEyesPhewLabel.end - 1), null);
                    this.foes[i] = null;
                    break;
                };
                i = (i + 1);
            };
            try
            {
                this.scheduleNextLife();
            }
            catch(e:Error)
            {
            };
        }

        public function addScore():void
        {
            this.score++;
            this.panelMC.t.t.t.text = ("" + this.score);
            this.panelMC.pointBar.bar.scaleX = Math.max(Math.min((this.score / this.maxScore), 1), 0);
        }

        public function isWin():void
        {
            this.main.loading(true);
            var _local_1:String = Hex.fromArray(Crypto.getHash("sha256").hash(Crypto.bytesArray(((((((String(Character.char_id) + "|") + String(Character.sessionkey)) + "|") + String(this.score)) + "|") + String(Character.battle_code)))));
            this.main.amf_manager.service("ChristmasEvent2025.finishMinigame", [Character.char_id, Character.sessionkey, this.score, _local_1], this.onWinResult);
        }

        public function onWinResult(_arg_1:Object):void
        {
            var _local_2:int;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.win = true;
                this.panelMC.winPopupMC.visible = true;
                this.christmasMenu.minigameResponse.energy = _arg_1.current_energy;
                this.panelMC.winPopupMC.rankMC.gotoAndStop(this.getRank().toLowerCase());
                this.panelMC.winPopupMC.scoreTxt.text = this.score;
                this.eventHandler.addListener(this.panelMC.winPopupMC.btn_claim, MouseEvent.CLICK, this.closePanel);
                Character.addRewards(_arg_1.rewards);
                this.main.HUD.setBasicData();
                _local_2 = 0;
                while (_local_2 < 5)
                {
                    this.panelMC.winPopupMC[("iconMc" + _local_2)].visible = false;
                    if (_local_2 < _arg_1.rewards.length)
                    {
                        this.panelMC.winPopupMC[("iconMc" + _local_2)].visible = true;
                        NinjaSage.loadItemIcon(this.panelMC.winPopupMC[("iconMc" + _local_2)], _arg_1.rewards[_local_2]);
                        this.panelMC.winPopupMC[("iconMc" + _local_2)].amountTxt.text = "";
                        this.panelMC.winPopupMC[("iconMc" + _local_2)].ownedTxt.visible = false;
                        this.panelMC.winPopupMC[("iconMc" + _local_2)].btn_preview.visible = false;
                        if (Character.hasSkill(_arg_1.rewards[_local_2]) > 0)
                        {
                            this.panelMC.winPopupMC[("iconMc" + _local_2)].ownedTxt.visible = true;
                            this.panelMC.winPopupMC[("iconMc" + _local_2)].ownedTxt.text = "Owned";
                        };
                        if (Character.isItemOwned(_arg_1.rewards[_local_2]) > 0)
                        {
                            this.panelMC.winPopupMC[("iconMc" + _local_2)].ownedTxt.visible = true;
                            this.panelMC.winPopupMC[("iconMc" + _local_2)].ownedTxt.text = "Owned";
                        };
                    };
                    _local_2++;
                };
                this.timerHandler.stopTimer();
                this.timerHandler.destroy();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
                this.closePanel(null);
            };
        }

        public function life():void
        {
            var _local_3:int;
            var _local_4:MovieClip;
            var _local_5:int;
            var _local_6:int;
            if (this.win)
            {
                return;
            };
            var _local_1:int = -1;
            var _local_2:int;
            while (_local_2 < 15)
            {
                _local_3 = NumberUtil.randomInt(0, 15);
                if (!this.foes[_local_3])
                {
                    _local_1 = _local_3;
                    _local_4 = new Slimes();
                    this.handleSlimeAnimation(_local_4);
                    this.panelMC.addChild(_local_4);
                    _local_5 = 0x0500;
                    _local_6 = NumberUtil.randomInt(200, 400);
                    _local_4.x = Math.max(0, Math.min(1920, (240 + (_local_5 * Math.random()))));
                    _local_4.y = Math.max(_local_6, Math.min(900, (-500 + (_local_1 * 100))));
                    this.foes[_local_1] = _local_4;
                    this.sortLayers();
                    return;
                };
                _local_2++;
            };
        }

        public function handleSlimeAnimation(slime:MovieClip):void
        {
            var randomFrame:int;
            var slimeStandbyLabel:Object = NinjaSage.getLabelFrames(slime, "stand");
            var slimeDeadLabel:Object = NinjaSage.getLabelFrames(slime, "die");
            var slimeEyesIdleLabel:Object = NinjaSage.getLabelFrames(slime.body.eyes, "idle");
            var slimeEyesHitLabel:Object = NinjaSage.getLabelFrames(slime.body.eyes, "hit");
            var slimeEyesOhLabel:Object = NinjaSage.getLabelFrames(slime.body.eyes, "oh");
            var slimeEyesPhewLabel:Object = NinjaSage.getLabelFrames(slime.body.eyes, "phew");
            randomFrame = NumberUtil.randomInt(1, 24);
            slime.addFrameScript((slimeStandbyLabel.end - 1), function ():void
            {
                slime.gotoAndPlay("stand");
            });
            slime.addFrameScript((slimeDeadLabel.end - 1), function ():void
            {
                death(slime);
            });
            slime.addFrameScript(0, function ():void
            {
                slime.body.gotoAndStop(randomFrame);
                slime.body.eyes.color.gotoAndStop(randomFrame);
            });
            slime.body.eyes.addFrameScript((slimeEyesIdleLabel.end - 1), function ():void
            {
                slime.body.eyes.gotoAndPlay("idle");
            });
            slime.body.eyes.addFrameScript((slimeEyesOhLabel.end - 1), function ():void
            {
                slime.body.eyes.gotoAndPlay("oh");
            });
            slime.body.eyes.addFrameScript((slimeEyesPhewLabel.end - 1), function ():void
            {
                slime.body.eyes.gotoAndPlay("idle");
            });
            this.eventHandler.addListener(slime.body, MouseEvent.MOUSE_OVER, function ():void
            {
                slime.body.eyes.gotoAndPlay("oh");
            });
            this.eventHandler.addListener(slime.body, MouseEvent.MOUSE_OUT, function ():void
            {
                slime.body.eyes.gotoAndPlay("phew");
            });
            this.eventHandler.addListener(slime.body, MouseEvent.CLICK, function ():void
            {
                slime.body.eyes.gotoAndPlay("hit");
                slime.gotoAndPlay("die");
                addScore();
                var _local_1:int;
                while (_local_1 < 8)
                {
                    if (slime[("bubble" + _local_1)])
                    {
                        slime[("bubble" + _local_1)].color.gotoAndStop(randomFrame);
                    };
                    _local_1++;
                };
            });
        }

        public function sortLayers():void
        {
            var _local_1:int;
            var _local_2:int = int((this.foes.length - 1));
            while (_local_2 >= 0)
            {
                if (this.foes[_local_2])
                {
                    this.panelMC.setChildIndex(this.foes[_local_2], ((this.panelMC.numChildren - 3) - _local_1));
                    _local_1++;
                };
                _local_2--;
            };
        }

        public function particleDropSpeed(_arg_1:MovieClip):void
        {
            this.ySpeed = (this.ySpeed + (Math.random() - 0.5));
            this.xSpeed = (this.xSpeed + (Math.random() - 0.5));
            if (_arg_1.y > (this.panelMC.y + 30))
            {
                this.ySpeed = (this.ySpeed * 0.9);
                this.ySpeed = (this.ySpeed - 0.2);
            };
            if (_arg_1.y < (this.panelMC.y - 30))
            {
                this.ySpeed = (this.ySpeed * 0.9);
                this.ySpeed = (this.ySpeed + 0.2);
            };
            if (_arg_1.x > (this.panelMC.x + 50))
            {
                this.xSpeed = (this.xSpeed * 0.9);
                this.xSpeed = (this.xSpeed - 0.2);
            };
            if (_arg_1.x < (this.panelMC.x - 50))
            {
                this.xSpeed = (this.xSpeed * 0.9);
                this.xSpeed = (this.xSpeed + 0.2);
            };
            _arg_1.y = (_arg_1.y + this.ySpeed);
            _arg_1.x = (_arg_1.x + this.xSpeed);
        }

        public function closePanel(_arg_1:MouseEvent):void
        {
            this.christmasMenu.showThisPanel();
            this.destroy();
        }

        public function destroy():void
        {
            if (this.destroyed)
            {
                return;
            };
            this.destroyed = true;
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.timerHandler = null;
            this.main = null;
            this.foes = null;
            this.christmasMenu = null;
            GF.removeAllChild(this);
        }


    }
}//package Panels

import flash.utils.Timer;
import flash.display.MovieClip;
import id.ninjasage.EventHandler;
import flash.events.TimerEvent;

class TimerHandler 
{

    /*private*/ var timer:Timer = null;
    /*private*/ var slotHolder:MovieClip;
    /*private*/ var time:uint;
    /*private*/ var remainingTime:int;
    /*private*/ var cbFnComplete:Function;
    /*private*/ var cbFnUpdate:Function;
    /*private*/ var desText:String;
    public var updateSlot:Boolean = true;
    public var eventHandler:*;

    public function TimerHandler()
    {
        this.eventHandler = new EventHandler();
    }

    public function startTimer(_arg_1:MovieClip, _arg_2:int, _arg_3:Function, _arg_4:Function, _arg_5:String):*
    {
        var _local_6:int;
        var _local_7:int;
        var _local_8:String;
        this.slotHolder = _arg_1;
        this.remainingTime = _arg_2;
        this.cbFnComplete = _arg_3;
        this.cbFnUpdate = _arg_4;
        this.desText = _arg_5;
        if (this.remainingTime == 0)
        {
            this.cbFnComplete();
            return;
        };
        if (this.timer == null)
        {
            this.slotHolder["timer"].visible = true;
            _local_6 = this.remainingTime;
            if (_local_6 < 0)
            {
                _local_6 = 0;
            };
            _local_7 = int(Math.floor((_local_6 / 60)));
            _local_6 = (_local_6 % 60);
            _local_7 = (_local_7 % 60);
            _local_8 = String(((_local_7 * 60) + _local_6));
            if (this.updateSlot)
            {
                this.slotHolder["timer"].text = this.desText.replace("[time]", _local_8);
            };
            this.timer = new Timer(1000, this.remainingTime);
            this.eventHandler.addListener(this.timer, TimerEvent.TIMER, this.onUpdateProgress);
            this.eventHandler.addListener(this.timer, TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
            this.timer.start();
        };
    }

    /*private*/ function onUpdateProgress(_arg_1:TimerEvent):void
    {
        var _local_2:int;
        var _local_3:int;
        var _local_4:String;
        if (this.remainingTime > 0)
        {
            this.cbFnUpdate();
            this.remainingTime--;
        };
        if (this.slotHolder["timer"])
        {
            _local_2 = this.remainingTime;
            if (_local_2 < 0)
            {
                _local_2 = 0;
            };
            _local_3 = int(Math.floor((_local_2 / 60)));
            _local_2 = (_local_2 % 60);
            _local_3 = (_local_3 % 60);
            _local_4 = String(((_local_3 * 60) + _local_2));
            if (this.updateSlot)
            {
                this.slotHolder["timer"].text = this.desText.replace("[time]", _local_4);
            };
        };
    }

    /*private*/ function onTimerComplete(_arg_1:TimerEvent):void
    {
        if (this.cbFnComplete != null)
        {
            this.stopTimer();
            this.cbFnComplete();
        };
    }

    public function stopTimer():*
    {
        if (this.timer != null)
        {
            this.timer.reset();
            this.timer.stop();
            this.timer = null;
        };
    }

    public function destroy():void
    {
        this.stopTimer();
        this.slotHolder = null;
        this.cbFnComplete = null;
        this.cbFnUpdate = null;
        this.desText = null;
        if (this.eventHandler)
        {
            this.eventHandler.removeAllEventListeners();
        };
        this.eventHandler = null;
    }

    /*private*/ function checkDigits(_arg_1:int):String
    {
        if (_arg_1.toString().length < 2)
        {
            return ("0" + _arg_1.toString());
        };
        return (_arg_1.toString());
    }


}


