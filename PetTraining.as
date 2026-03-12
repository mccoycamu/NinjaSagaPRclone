// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.PetTraining

package Panels
{
    import flash.display.MovieClip;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.utils.GF;

    public class PetTraining extends MovieClip 
    {

        private var trainTimer:Timer = null;
        private var slotHolder:MovieClip;
        private var trainingTime:uint;
        private var remainingTime:uint;
        private var slotNum:uint;
        private var petId:uint;
        private var petDataId:uint;
        private var cbFnComplete:Function;
        private var cbFnTick:Function;


        public function startTimer(_arg_1:int, _arg_2:MovieClip, _arg_3:uint, _arg_4:int, _arg_5:Function, _arg_6:Function):*
        {
            this.slotHolder = _arg_2;
            this.slotNum = uint(String(this.slotHolder.name).substr(7, 1));
            this.remainingTime = _arg_3;
            this.trainingTime = _arg_4;
            this.cbFnTick = _arg_5;
            this.cbFnComplete = _arg_6;
            this.petId = _arg_1;
            if (this.remainingTime == 0)
            {
                this.cbFnComplete(this.slotNum);
            }
            else
            {
                if (this.trainTimer == null)
                {
                    this.trainTimer = new Timer(1000, this.remainingTime);
                    this.trainTimer.addEventListener(TimerEvent.TIMER, this.onUpdateProgress);
                    this.trainTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
                    this.trainTimer.start();
                };
            };
        }

        private function onUpdateProgress(_arg_1:TimerEvent):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            if (this.remainingTime > 0)
            {
                this.remainingTime--;
            };
            if (this.slotHolder["timerTxt"])
            {
                _local_2 = this.remainingTime;
                if (_local_2 < 0)
                {
                    _local_2 = 0;
                };
                _local_3 = int(Math.floor((_local_2 / 60)));
                _local_4 = int(Math.floor((_local_3 / 60)));
                _local_2 = (_local_2 % 60);
                _local_3 = (_local_3 % 60);
                this.slotHolder["timerTxt"].text = ((((this.checkDigits(_local_4) + ":") + this.checkDigits(_local_3)) + ":") + this.checkDigits(_local_2));
                this.slotHolder["percentBar"].scaleX = Math.max(0, ((this.trainingTime - this.remainingTime) / this.trainingTime));
                if (this.cbFnTick != null)
                {
                    this.cbFnTick(this.petId);
                };
            };
        }

        private function onTimerComplete(_arg_1:TimerEvent):void
        {
            this.trainTimer = null;
            this.trainTimer.removeEventListener(TimerEvent.TIMER, this.onUpdateProgress);
            this.trainTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
            if (this.cbFnTick != null)
            {
                this.cbFnTick(this.petId);
            };
            if (this.cbFnComplete != null)
            {
                this.stopTimer();
                this.cbFnComplete(this.slotNum);
            };
        }

        public function stopTimer():*
        {
            if (this.trainTimer != null)
            {
                this.trainTimer.removeEventListener(TimerEvent.TIMER, this.onUpdateProgress);
                this.trainTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
                this.trainTimer.reset();
                this.trainTimer.stop();
                this.trainTimer = null;
            };
        }

        public function destroy():*
        {
            this.stopTimer();
            GF.removeAllChild(this.slotHolder);
            this.cbFnComplete = null;
            this.cbFnTick = null;
        }

        private function checkDigits(_arg_1:int):String
        {
            if (_arg_1.toString().length < 2)
            {
                return ("0" + _arg_1.toString());
            };
            return (_arg_1.toString());
        }


    }
}//package Panels

