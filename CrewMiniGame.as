// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.CrewMiniGame

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Managers.AppManager;
    import Storage.Character;
    import flash.events.MouseEvent;
    import id.ninjasage.Crew;
    import com.hurlant.util.Hex;
    import com.hurlant.crypto.Crypto;
    import com.utils.GF;

    public class CrewMiniGame extends MovieClip 
    {

        private const totalLevel:int = 3;
        private const TimeFree:int = 5;
        private const HeartFree:int = 10;

        public var mc:MovieClip;
        private var currStage:int;
        private var isStart:Boolean = false;
        private var correctStep:Array;
        private var clickedStep:int;
        private var isPlayed:Boolean = false;
        private var heartRemain:int = 3;
        private var calledFinishTime:int = 0;
        private var energyRefillRemainTime:int;
        private var energyRefillCounting:EnergyRefillSystem = new EnergyRefillSystem();
        private var levelData:Array;
        private var currStep:int;
        private var c:*;
        private var ts:*;
        public var eventHandler:EventHandler;
        public var main:* = AppManager.getInstance().main;
        public var crewParent:*;

        public function CrewMiniGame(_arg_1:*, _arg_2:*)
        {
            this.crewParent = _arg_1;
            this.eventHandler = new EventHandler();
            this.levelData = [{
                "level":1,
                "time":45,
                "size":9,
                "step":3
            }, {
                "level":2,
                "time":30,
                "size":16,
                "step":4
            }, {
                "level":3,
                "time":20,
                "size":25,
                "step":6
            }];
            this.mc = _arg_2;
            this.mc.addFrameScript(8, this.onShow);
            super();
        }

        private function loadPanelContent():void
        {
            var _local_1:*;
            this.mc.panelMc.stageLT.text = ((("Stage " + this.currStage) + " / ") + this.levelData.length);
            this.mc.panelMc.Token.myTokenTxt.text = Character.account_tokens;
            this.mc.panelMc.payPanel.costLabel.text = "Cost";
            this.mc.panelMc.payPanel.costTxt.text = this.TimeFree;
            this.mc.panelMc.heartBarMC.costLabel.text = "Cost";
            this.mc.panelMc.heartBarMC.costTxt.text = this.HeartFree;
            this.main.initButton(this.mc.panelMc.payPanel.confirmBtn, this.onClickBuyTime, "Buy");
            this.main.initButton(this.mc.panelMc.heartBarMC.confirmBtn, this.onClickBuyHeart, "Buy");
            if (this.currStage >= 1)
            {
                _local_1 = 0;
                while (_local_1 < this.levelData[(this.currStage - 1)].size)
                {
                    this.eventHandler.addListener(this.mc.panelMc[("mainGameStageMc" + this.currStage)][("iconMc_" + _local_1)], MouseEvent.CLICK, this.onClickChooseStep);
                    _local_1++;
                };
            };
        }

        private function gameStart():void
        {
            this.updateHeart();
            this.changeStage();
        }

        private function changeStage():void
        {
            var _local_1:int;
            this.currStage++;
            this.mc.panelMc["stageLogo"].visible = true;
            _local_1 = 1;
            while (_local_1 < (this.totalLevel + 1))
            {
                this.mc.panelMc[("mainGameStageMc" + _local_1)].visible = false;
                _local_1++;
            };
            this.mc.panelMc["stageLogo"].gotoAndStop(("stage" + this.currStage));
            this.mc.panelMc["stageLogo"][("logo" + this.currStage)].addFrameScript(19, this.onStage);
            this.mc.panelMc["stageLogo"][("logo" + this.currStage)].gotoAndPlay("show");
            this.mc.panelMc["timer"].text = (this.levelData[(this.currStage - 1)].time + "s");
            this.loadPanelContent();
        }

        private function resetGameLevel():void
        {
            var _local_1:int;
            this.correctStep = [];
            do 
            {
                _local_1 = this.random(0, this.levelData[(this.currStage - 1)].size);
                if (this.correctStep.indexOf(_local_1) < 0)
                {
                    this.correctStep.push(_local_1);
                };
            } while (this.correctStep.length < this.levelData[(this.currStage - 1)].step);
            this.currStep = 0;
            this.isPlayed = false;
            this.showNextStep();
        }

        private function random(_arg_1:int, _arg_2:int):int
        {
            var _local_3:int = (_arg_2 - _arg_1);
            return (_arg_1 + (Math.random() * _local_3));
        }

        private function showStep(_arg_1:int):void
        {
            this.mc.panelMc[("mainGameStageMc" + this.currStage)][("iconMc_" + _arg_1)].addFrameScript(14, this.showNextStep, 30, this.nextStage);
            this.mc.panelMc[("mainGameStageMc" + this.currStage)][("iconMc_" + _arg_1)].gotoAndPlay("show");
        }

        private function clearStage():void
        {
            var _local_1:int;
            _local_1 = 0;
            while (_local_1 < this.correctStep.length)
            {
                this.mc.panelMc[("mainGameStageMc" + this.currStage)][("iconMc_" + this.correctStep[_local_1])].gotoAndPlay("correct");
                _local_1++;
            };
        }

        private function updateHeart():void
        {
            this.mc.panelMc["heartBarMC"].gotoAndStop((4 - this.heartRemain));
            if (this.heartRemain == 0)
            {
                this.energyRefillCounting.stopTimer();
                this.finishGame();
            };
        }

        private function finishGame(_arg_1:*=0):void
        {
            this.isPlayed = false;
            this.main.loading(true);
            var _local_2:* = new Date().getTime();
            Crew.instance.finishMiniGame({
                "c":this.c,
                "t":this.ts,
                "r":_arg_1,
                "n":_local_2,
                "h":Hex.fromArray(Crypto.getHash("md5").hash(Hex.toArray(Hex.fromString([this.c, this.ts, _arg_1, _local_2].join("|")))))
            }, this.finishMiniGameRes);
        }

        private function finishMiniGameRes(_arg_1:*=null, _arg_2:*=null):void
        {
            if ((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("r"))) && (!(_arg_1.r == ""))))
            {
                this.main.loading(false);
                Character.addRewards(_arg_1.r);
                this.main.giveReward(1, _arg_1.r);
                this.crewParent.getMiniGameData();
                this.backToCrewWar();
            }
            else
            {
                this.main.loading(false);
                this.mc.panelMc["popupLose"].addFrameScript(4, this.onShowLost);
                this.mc.panelMc["popupLose"].gotoAndPlay("show");
            };
        }

        private function updateCounting():void
        {
            this.energyRefillRemainTime--;
        }

        private function buyTime():void
        {
            this.main.loading(true);
            this.energyRefillCounting.stopTimer();
            Crew.instance.buyMiniGame(1, this.buyTimeResponse);
        }

        private function buyTimeResponse(_arg_1:*=null, _arg_2:*=null):void
        {
            this.main.loading(false);
            this.energyRefillCounting.startTimer(this.mc.panelMc, this.energyRefillRemainTime, this.finishGame, this.updateCounting, "[time]s");
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("t"))))
            {
                Character.account_tokens = _arg_1.t;
                this.energyRefillRemainTime = (this.energyRefillRemainTime + 10);
                this.loadPanelContent();
            };
        }

        private function buyHeart():void
        {
            this.main.loading(true);
            this.energyRefillCounting.stopTimer();
            Crew.instance.buyMiniGame(2, this.buyHeartResponse);
        }

        private function buyHeartResponse(_arg_1:*=null, _arg_2:*=null):void
        {
            this.main.loading(false);
            this.energyRefillCounting.startTimer(this.mc.panelMc, this.energyRefillRemainTime, this.finishGame, this.updateCounting, "[time]s");
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("t"))))
            {
                Character.account_tokens = _arg_1.t;
                this.heartRemain = (this.heartRemain + 1);
                this.updateHeart();
                this.loadPanelContent();
            };
        }

        public function show():void
        {
            this.gotoAndPlay("show");
        }

        public function onShow():void
        {
            this.currStage = 0;
            this.mc.stop();
            this.mc.panelMc["stageLogo"].visible = false;
            this.mc.panelMc["popupTutorial"].addFrameScript(11, this.onInitTutor);
            this.mc.panelMc["popupTutorial"].gotoAndPlay("show");
        }

        public function onInitTutor():void
        {
            this.mc.panelMc["stageLogo"].visible = false;
            this.mc.panelMc.popupTutorial.panel.titleTxt.text = "Game Tutorial";
            this.mc.panelMc.popupTutorial.panel.instMC.subTxt1.text = "Show the order \nof step";
            this.mc.panelMc.popupTutorial.panel.instMC.subTxt2.text = "Click the step \nby following order";
            this.mc.panelMc.popupTutorial.panel.instMC.subTxt3.text = "Show the order \nof step";
            this.mc.panelMc.popupTutorial.panel.instMC.subTxt4.text = "Click the step \nby following order";
            this.main.initButton(this.mc.panelMc.popupTutorial.panel.instMC.btnGo, this.onClickStart, "Start");
            this.eventHandler.addListener(this.mc.panelMc.popupTutorial.panel.btnClose, MouseEvent.CLICK, this.onClickHide);
            this.loadPanelContent();
        }

        public function onStage():void
        {
            this.isStart = true;
            this.mc.panelMc[("mainGameStageMc" + this.currStage)].visible = true;
            this.mc.panelMc["stageLogo"].visible = false;
            this.resetGameLevel();
        }

        public function showNextStep():void
        {
            if (this.currStep < int(this.levelData[(this.currStage - 1)].step))
            {
                this.showStep(this.correctStep[this.currStep]);
                this.currStep++;
            }
            else
            {
                this.isPlayed = true;
                this.clickedStep = 0;
                this.energyRefillRemainTime = this.levelData[(this.currStage - 1)].time;
                this.energyRefillCounting.startTimer(this.mc.panelMc, this.energyRefillRemainTime, this.finishGame, this.updateCounting, "[time]s");
            };
        }

        public function backToCrewWar():void
        {
            this.destroy();
        }

        public function nextStage():void
        {
            this.calledFinishTime++;
            if (this.calledFinishTime == int(this.levelData[(this.currStage - 1)].step))
            {
                if (this.currStage == 3)
                {
                    this.finishGame(1);
                    return;
                };
                this.mc.panelMc["popupWin"].addFrameScript(4, this.onShowWin);
                this.mc.panelMc["popupWin"].gotoAndPlay("show");
                this.calledFinishTime = 0;
            };
        }

        public function onShowWin():void
        {
            this.mc.panelMc.popupWin.panel.titleTxt.text = "Stage Clear";
            this.mc.panelMc.popupWin.panel.stageTxt.text = "Congratulations!";
            this.main.initButton(this.mc.panelMc.popupWin.panel.btnNext, this.onClickNextStage, "Next");
            this.loadPanelContent();
        }

        public function onShowLost():void
        {
            this.mc.panelMc.popupLose.panel.titleTxt.text = "Mission Fail";
            this.mc.panelMc.popupLose.panel.detailTxt.text = "Sorry, please try again.";
            this.main.initButton(this.mc.panelMc.popupLose.panel.btnQuit, this.onClickHide, "OK");
            this.loadPanelContent();
        }

        private function onClickChooseStep(_arg_1:MouseEvent):void
        {
            if (!this.isPlayed)
            {
                return;
            };
            if (_arg_1.currentTarget.currentLabel == "click")
            {
                return;
            };
            if (this.correctStep[this.clickedStep] == int(_arg_1.currentTarget.name.replace("iconMc_", "")))
            {
                _arg_1.currentTarget.gotoAndPlay("click");
                this.clickedStep++;
            }
            else
            {
                this.heartRemain--;
                this.updateHeart();
                this.mc.panelMc["popUpGetReward"].gotoAndPlay("show");
            };
            if (this.clickedStep == int(this.levelData[(this.currStage - 1)].step))
            {
                this.clearStage();
                this.energyRefillCounting.stopTimer();
            };
        }

        private function onClickNextStage(_arg_1:MouseEvent):void
        {
            this.changeStage();
            this.mc.panelMc["popupWin"].gotoAndPlay("exit");
        }

        private function onClickHide(_arg_1:MouseEvent):void
        {
            this.backToCrewWar();
        }

        private function onClickBuyTime(_arg_1:MouseEvent):void
        {
            if (!this.isPlayed)
            {
                this.main.showMessage("Please wait the game start");
                return;
            };
            this.buyTime();
        }

        private function onClickBuyHeart(_arg_1:MouseEvent):void
        {
            if (this.heartRemain == 3)
            {
                this.main.showMessage("Heart is full");
                return;
            };
            this.buyHeart();
        }

        private function onClickStart(_arg_1:MouseEvent):void
        {
            Crew.instance.startMiniGame(this.onStartRes);
        }

        private function onStartRes(_arg_1:*=null, _arg_2:*=null):*
        {
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("c"))))
            {
                this.c = _arg_1.c;
                this.ts = _arg_1.t;
                this.mc.panelMc["popupTutorial"].gotoAndPlay("exit");
                this.gameStart();
            }
            else
            {
                if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
                {
                    this.main.showMessage(_arg_1.errorMessage);
                }
                else
                {
                    this.main.showMessage("Unable to start the game");
                };
            };
        }

        private function onClickNextPage(_arg_1:MouseEvent):void
        {
            this.mc.panelMc["popupTutorial"]["instMC"].gotoAndPlay(2);
            this.loadPanelContent();
        }

        private function onClickPrevPage(_arg_1:MouseEvent):void
        {
            this.mc.panelMc["popupTutorial"]["instMC"].gotoAndPlay(1);
            this.loadPanelContent();
        }

        public function destroy():*
        {
            if (this.energyRefillCounting)
            {
                this.energyRefillCounting.stopTimer();
            };
            this.crewParent.initStatusDisplay();
            this.main.HUD.setBasicData();
            GF.removeAllChild(this.mc);
            this.mc = null;
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.main = null;
            this.levelData = null;
            this.energyRefillCounting = null;
            this.correctStep = null;
            this.crewParent = null;
        }


    }
}//package id.ninjasage.features

import flash.utils.Timer;
import flash.display.MovieClip;
import flash.events.TimerEvent;

class EnergyRefillSystem 
{

    /*private*/ var energyTimer:Timer = null;
    /*private*/ var slotHolder:MovieClip;
    /*private*/ var energyTime:uint;
    /*private*/ var remainingTime:int;
    /*private*/ var cbFnComplete:Function;
    /*private*/ var cbFnUpdate:Function;
    /*private*/ var desText:String;
    public var updateSlot:Boolean = true;


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
        if (this.energyTimer == null)
        {
            this.slotHolder["timer"].visible = true;
            _local_6 = int(this.remainingTime);
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
            this.energyTimer = new Timer(1000, this.remainingTime);
            this.energyTimer.addEventListener(TimerEvent.TIMER, this.onUpdateProgress);
            this.energyTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
            this.energyTimer.start();
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
            _local_2 = int(this.remainingTime);
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
        if (this.energyTimer != null)
        {
            this.energyTimer.reset();
            this.energyTimer.stop();
            this.energyTimer = null;
        };
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


