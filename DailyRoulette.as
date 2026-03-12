// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.DailyRoulette

package Panels
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import Storage.Character;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

    public class DailyRoulette extends MovieClip 
    {

        public var panel:MovieClip;
        public var main:*;
        internal var roulette:*;
        internal var eventHandler:* = new EventHandler();

        public function DailyRoulette(_arg_1:*)
        {
            this.main = _arg_1;
            this.panel.roulette.gotoAndStop(11);
            this.panel.consecutive.gotoAndStop(0);
            this.eventHandler.addListener(this.panel.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panel.btn_spin, MouseEvent.CLICK, this.spin);
            this.getData();
        }

        public function getData():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("DailyRoulette.getData", [Character.char_id, Character.sessionkey], this.onGetData);
        }

        public function onGetData(_arg_1:*):*
        {
            this.main.loading(false);
            if (_arg_1.status > 1)
            {
                this.main.getNotice(_arg_1.result);
                return;
            };
            if (_arg_1.status == 0)
            {
                this.main.getNotice("Unknown error");
                return;
            };
            this.panel.consecutive.gotoAndStop(int(_arg_1.bonus));
            if (int(_arg_1.can_spin) == 1)
            {
                this.panel.btn_spin.visible = true;
            }
            else
            {
                this.main.giveMessage("You can spin again tomorrow");
                this.panel.btn_spin.visible = false;
            };
        }

        public function closePanel(_arg_1:MouseEvent):*
        {
            this.main = null;
            this.panel.roulette = null;
            this.roulette = null;
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            parent.removeChild(this);
        }

        public function spin(_arg_1:MouseEvent):*
        {
            this.panel.roulette.gotoAndPlay(1);
            var _local_2:Timer = new Timer(800, 1);
            _local_2.start();
            this.eventHandler.addListener(_local_2, TimerEvent.TIMER_COMPLETE, this.startAmf);
            this.panel.btn_spin.removeEventListener(MouseEvent.CLICK, this.spin);
        }

        public function startAmf(_arg_1:*):*
        {
            this.main.amf_manager.service("DailyRoulette.spin", [Character.char_id, Character.sessionkey], this.spinRewards);
        }

        private function spinRewards(_arg_1:*):void
        {
            this.panel.btn_spin.removeEventListener(MouseEvent.CLICK, this.spin);
            if (int(_arg_1.status) > 0)
            {
                this.main.giveReward(1, _arg_1.reward_string);
            }
            else
            {
                if (int(_arg_1.status) == 2)
                {
                    this.main.giveMessage("You Can Spin Again Tomorrow!");
                }
                else
                {
                    this.main.getNotice("Unknown Error");
                };
            };
            if (int(_arg_1.status) == 1)
            {
                Character.character_xp = _arg_1.xp;
                Character.account_tokens = int(_arg_1.tokens);
                Character.character_gold = _arg_1.gold;
                this.panel.roulette.gotoAndStop(int(_arg_1.reward));
                this.panel.consecutive.gotoAndStop(int(_arg_1.bonus));
            }
            else
            {
                this.panel.roulette.gotoAndStop(11);
                this.panel.consecutive.gotoAndStop(1);
            };
            this.panel.roulette.last_frame.gotoAndStop(35);
            if (_arg_1.level_up == true)
            {
                Character.character_lvl = String((int(Character.character_lvl) + 1));
                Character.character_xp = _arg_1.xp;
                this.main.levelUp();
            };
        }


    }
}//package Panels

