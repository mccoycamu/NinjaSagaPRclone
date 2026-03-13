// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.BattleTimer

package Combat
{
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    public class BattleTimer 
    {

        public static var turn_timer:Timer = null;
        public static var turn_timer_seconds:int = 20;


        public static function startTurnTimer():*
        {
            if (((!(turn_timer == null)) && (turn_timer.running)))
            {
                stopTurnTimer();
            };
            turn_timer = new Timer(1000, turn_timer_seconds);
            var _local_1:* = BattleManager.getBattle();
            if (_local_1)
            {
                _local_1.atk_turnTimerTxt.visible = true;
                _local_1.atk_turnTimerTxt.txt.text = String(turn_timer_seconds);
            };
            turn_timer.addEventListener(TimerEvent.TIMER, turnTimerTick, false, 0, true);
            turn_timer.addEventListener(TimerEvent.TIMER_COMPLETE, turnTimerCompleted, false, 0, true);
            turn_timer.start();
        }

        public static function stopTurnTimer():*
        {
            if (((!(turn_timer == null)) && (turn_timer.running)))
            {
                turn_timer.removeEventListener(TimerEvent.TIMER, turnTimerTick);
                turn_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, turnTimerCompleted);
                turn_timer.stop();
                turn_timer.reset();
            };
            var _local_1:* = BattleManager.getBattle();
            if (_local_1)
            {
                _local_1.atk_turnTimerTxt.visible = false;
                _local_1.atk_turnTimerTxt.txt.text = "";
            };
        }

        public static function turnTimerTick(_arg_1:TimerEvent):*
        {
            var _local_2:* = BattleManager.getBattle();
            if (((BattleVars.MATCH_RUNNING) && (_local_2)))
            {
                _local_2.atk_turnTimerTxt.txt.text = String((turn_timer_seconds - int(_arg_1.currentTarget.currentCount)));
            };
        }

        public static function turnTimerCompleted(_arg_1:TimerEvent):*
        {
            turn_timer.removeEventListener(TimerEvent.TIMER, turnTimerTick);
            turn_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, turnTimerCompleted);
            var _local_2:* = BattleManager.getBattle();
            if (_local_2)
            {
                _local_2.atk_turnTimerTxt.visible = false;
                _local_2.atk_turnTimerTxt.txt.text = "";
                _local_2.actionBar.visible = false;
            };
            if (BattleVars.MATCH_RUNNING)
            {
                BattleManager.startRun();
            };
        }

        public static function destroy():*
        {
            stopTurnTimer();
            turn_timer = null;
        }


    }
}//package Combat

