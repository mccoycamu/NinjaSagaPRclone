// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.pvp.battle.PvPBattleVars

package id.ninjasage.pvp.battle
{
    import com.utils.GF;

    public class PvPBattleVars 
    {

        public static const MATCH_STATE_STARTED:int = 1;
        public static const MATCH_STATE_ENDED:int = 2;
        public static const SKILL_SCALE:Number = 0.42;
        public static const CHAR_SCALE:Number = 0.42;
        public static const PET_SCALE:Number = 0.75;
        public static const ENEMY_SCALE:Number = 0.8;
        public static const POSITION_MELEE_1:String = "melee_1";
        public static const POSITION_MELEE_2:String = "melee_2";
        public static const POSITION_MELEE_3:String = "melee_3";
        public static const POSITION_RANGE_1:String = "range_1";
        public static const POSITION_RANGE_2:String = "range_2";
        public static const POSITION_RANGE_3:String = "range_3";
        public static const POSITION_START:String = "start";
        public static const Position_MELEE_1:String = POSITION_MELEE_1;//"melee_1"
        public static const Position_MELEE_2:String = POSITION_MELEE_2;//"melee_2"
        public static const Position_MELEE_3:String = POSITION_MELEE_3;//"melee_3"
        public static const Position_RANGE_1:String = POSITION_RANGE_1;//"range_1"
        public static const Position_RANGE_2:String = POSITION_RANGE_2;//"range_2"
        public static const Position_RANGE_3:String = POSITION_RANGE_3;//"range_3"
        public static const Position_START:String = POSITION_START;//"start"
        private static const MAX_TEAM_SIZE:int = 3;
        private static const TEAM_PLAYER:String = "player";
        private static const TEAM_ENEMY:String = "enemy";

        private var _battleId:String = "";
        private var _matchState:int = 0;
        private var _battleMode:String = "";
        private var _battleBackground:String = "";
        private var _originalBattleBackground:String = "";
        private var _playerTeam:Array;
        private var _enemyTeam:Array;
        private var _playerTarget:int = 0;
        private var _enemyTarget:int = 0;
        private var _matchRunning:Boolean = false;

        public function PvPBattleVars()
        {
            this._playerTeam = [];
            this._enemyTeam = [];
        }

        public function reset():void
        {
            if (this._playerTeam)
            {
                GF.clearArray(this._playerTeam);
                this._playerTeam.length = 0;
            };
            this._playerTeam = [];
            if (this._enemyTeam)
            {
                GF.clearArray(this._enemyTeam);
                this._enemyTeam.length = 0;
            };
            this._enemyTeam = [];
            this._battleId = "";
            this._matchState = 0;
            this._battleMode = "";
            this._battleBackground = "";
            this._originalBattleBackground = "";
            this._playerTarget = 0;
            this._enemyTarget = 0;
            this._matchRunning = false;
        }

        public function addPlayerToTeam(_arg_1:String, _arg_2:String):Boolean
        {
            if (((!(_arg_2)) || (_arg_2.length == 0)))
            {
                return (false);
            };
            var _local_3:Array = this.getTeamArray(_arg_1);
            if (!_local_3)
            {
                return (false);
            };
            if (_local_3.length >= MAX_TEAM_SIZE)
            {
                return (false);
            };
            if (_local_3.indexOf(_arg_2) >= 0)
            {
                return (false);
            };
            _local_3.push(_arg_2);
            return (true);
        }

        private function getTeamArray(_arg_1:String):Array
        {
            switch (_arg_1)
            {
                case TEAM_PLAYER:
                    return (this._playerTeam);
                case TEAM_ENEMY:
                    return (this._enemyTeam);
                default:
                    return (null);
            };
        }

        public function destroy():void
        {
            if (this._playerTeam)
            {
                GF.clearArray(this._playerTeam);
                this._playerTeam.length = 0;
                this._playerTeam = null;
            };
            if (this._enemyTeam)
            {
                GF.clearArray(this._enemyTeam);
                this._enemyTeam.length = 0;
                this._enemyTeam = null;
            };
            this._battleId = null;
            this._battleMode = null;
            this._battleBackground = null;
            this._originalBattleBackground = null;
            this._matchState = 0;
            this._playerTarget = 0;
            this._enemyTarget = 0;
            this._matchRunning = false;
        }

        public function get battleId():String
        {
            return ((this._battleId) || (""));
        }

        public function set battleId(_arg_1:String):void
        {
            this._battleId = ((_arg_1) || (""));
        }

        public function get matchState():int
        {
            return (this._matchState);
        }

        public function set matchState(_arg_1:int):void
        {
            this._matchState = _arg_1;
        }

        public function get battleMode():String
        {
            return ((this._battleMode) || (""));
        }

        public function set battleMode(_arg_1:String):void
        {
            this._battleMode = ((_arg_1) || (""));
        }

        public function get battleBackground():String
        {
            return ((this._battleBackground) || (""));
        }

        public function set battleBackground(_arg_1:String):void
        {
            this._battleBackground = ((_arg_1) || (""));
        }

        public function get originalBattleBackground():String
        {
            return ((this._originalBattleBackground) || (""));
        }

        public function set originalBattleBackground(_arg_1:String):void
        {
            this._originalBattleBackground = ((_arg_1) || (""));
        }

        public function get playerTeam():Array
        {
            return ((this._playerTeam) ? this._playerTeam.concat() : []);
        }

        public function get enemyTeam():Array
        {
            return ((this._enemyTeam) ? this._enemyTeam.concat() : []);
        }

        public function get playerTarget():int
        {
            return (this._playerTarget);
        }

        public function set playerTarget(_arg_1:int):void
        {
            this._playerTarget = _arg_1;
        }

        public function get enemyTarget():int
        {
            return (this._enemyTarget);
        }

        public function set enemyTarget(_arg_1:int):void
        {
            this._enemyTarget = _arg_1;
        }

        public function get matchRunning():Boolean
        {
            return (this._matchRunning);
        }

        public function set matchRunning(_arg_1:Boolean):void
        {
            this._matchRunning = _arg_1;
        }


    }
}//package id.ninjasage.pvp.battle

