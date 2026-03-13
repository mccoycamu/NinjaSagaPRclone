// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.BattleVars

package Combat
{
    import com.utils.NumberUtil;
    import Storage.SkillLibrary;
    import com.utils.GF;

    public class BattleVars 
    {

        public static const MATCH_STATE_STARTED:int = 1;
        public static const MATCH_STATE_ENDED:int = 2;
        public static const SKILL_SCALE:Number = 0.42;
        public static const CHAR_SCALE:Number = 0.42;
        public static const NPC_SCALE:Number = 0.75;
        public static const PET_SCALE:Number = 0.75;
        public static const ENEMY_SCALE:Number = 0.8;
        public static const Position_MELEE_1:String = "melee_1";
        public static const Position_MELEE_2:String = "melee_2";
        public static const Position_MELEE_3:String = "melee_3";
        public static const Position_MELEE_4:String = "melee_4";
        public static const Position_MELEE_5:String = "melee_5";
        public static const Position_RANGE_1:String = "range_1";
        public static const Position_RANGE_2:String = "range_2";
        public static const Position_RANGE_3:String = "range_3";
        public static const Position_RANGE_4:String = "range_4";
        public static const Position_START:String = "start";
        public static var PLAYER_TEAM_LOADED:Boolean = false;
        public static var ENEMY_TEAM_LOADED:Boolean = false;
        public static var MASTER_PLAYER_TARGET:int = 0;
        public static var PLAYER_TARGET:int = 0;
        public static var ENEMY_TARGET:int = 0;
        public static var FRIENDLY_MATCH:String = "FRIENDLY";
        public static var MISSION_MATCH:String = "MISSION";
        public static var EVENT_MATCH:String = "EVENT";
        public static var CLAN_MATCH:String = "CLAN";
        public static var CREW_MATCH:String = "CREW";
        public static var EXAM_MATCH:String = "EXAM";
        public static var ARENA_MATCH:String = "ARENA";
        public static var DRAGON_HUNT_MATCH:String = "DRAGONHUNT";
        public static var TEST_MATCH:String = "TEST";
        public static var SHADOWWAR_MATCH:String = "SHADOWWAR";
        public static var MATCH_RUNNING:Boolean = false;
        public static var CAN_NOT_DODGE:Boolean = false;
        public static var IS_DODGED:Boolean = false;
        public static var IS_CRITICAL:Boolean = false;
        public static var IS_COMBUSTION:Boolean = false;
        public static var IS_BLOCKED:Boolean = false;
        public static var IS_DAMAGE_CONVERTED:Boolean = false;
        public static var IS_DAMAGE_CONVERTED_CP:Boolean = false;
        public static var IS_DISPERSED:Boolean = false;
        public static var REDUCED_HP_AS_DAMAGE:Boolean = false;
        public static var SHOW_DAMAGE_ZERO:Boolean = false;
        public static var ATTACKER_TYPE:String = "";
        public static var ATTACK_TYPE:String = "";
        public static var ATTACK_FROM:String = "";
        public static var TITAN_MODE:Boolean = false;
        public static var EMBERSTEP:Boolean = false;
        public static var EMBERSTEP_USED:String = "";
        public static var OVERLOAD_MODE:Boolean = false;
        public static var JUST_USED_TITAN:Boolean = false;
        public static var JUST_USED_EMBERSTEP:Boolean = false;
        public static var JUST_USED_OVERLOAD:Boolean = false;
        public static var IS_SELF_SKILL:Boolean = false;
        public static var SWITCH_ATTACK_MODELS:Boolean = false;
        public static var IS_GENJUTSU:Boolean = false;
        public static var COPY_SKILL:Boolean = false;
        public static var COUNTER_SKILL:Boolean = false;
        public static var STEAL_JUTSU:Boolean = false;
        public static var GENJUTSU_REBOUND:Boolean = false;
        public static var ANIMATION_OVERRIDE:Boolean = false;
        public static var ANIMATION_OVERRIDER:String = "";
        public static var BACKGROUND_CHANGED:Boolean = false;
        public static var BACKGROUND_CHANGED_CASTER:String = "";
        public static var PLAY_DEAD_ANIMATION:String = "";
        public static var PLAY_DEAD_TEAM:String = "";
        public static var PLAY_DEAD_NUMBER:int = 0;
        public static var COPY_SKILL_ID_SAVE:String = "";
        public static var COPY_SKILL_ID:String = "";
        public static var COPY_SKILL_TEXT:String = "";
        public static var SKILL_USED_ID:String = "";
        public static var SKILL_USED_TYPE:int = 0;
        public static var HP_RECOVER_AFTER:int = 0;
        public static var CP_RECOVER_AFTER:int = 0;
        public static var CAPTURE_RANGE_START:int = 0;
        public static var CAPTURE_RANGE_END:int = 0;
        public static var CAPTURED_AT:int = -1;
        public static var DH_MODE:int = -1;
        public static var CRYSTAL_BLOCK:Boolean = false;
        public static var S_C:Boolean = false;
        public static var CHARACTER_REVIVED:Array = [false, false, false];
        public static var CHARACTER_TEAM_REVIVED:Array = [false, false, false];
        public static var CHARACTER_ICM:Array = [false, false, false];
        public static var CHARACTER_TOAD:Array = [0, 0, 0];
        public static var CHARACTER_LEFT_REDUCE_CD:Array = [2, 2, 2];
        public static var CHARACTER_REDUCE_CD:Array = [8, 8, 8];
        public static var ENEMY_REVIVED:Array = [false, false, false];
        public static var ENEMY_TEAM_REVIVED:Array = [false, false, false];
        public static var ENEMY_ICM:Array = [false, false, false];
        public static var ENEMY_TOAD:Array = [0, 0, 0];
        public static var ENEMY_LEFT_REDUCE_CD:Array = [2, 2, 2];
        public static var ENEMY_REDUCE_CD:Array = [8, 8, 8];

        public var MATCH_STATE:int = 0;
        public var BATTLE_MODE:String = "";
        public var BATTLE_BACKGROUND:String = "";
        public var ORIGINAL_BATTLE_BACKGROUND:String = "";
        public var PLAYER_TEAM:Array = [];
        public var ENEMY_TEAM:Array = [];


        public static function getRandomEnemyTarget():*
        {
            var _local_1:int;
            var _local_2:Array = [];
            var _local_3:Array = [];
            while (_local_1 < BattleManager.getBattle().character_team_players.length)
            {
                if (!BattleManager.getBattle().character_team_players[_local_1].health_manager.isDead())
                {
                    if (((Boolean(BattleManager.getBattle().character_team_players[_local_1].effects_manager.hadEffect("sleep"))) || (Boolean(BattleManager.getBattle().character_team_players[_local_1].effects_manager.hadEffect("pet_sleep")))))
                    {
                        _local_3.push(_local_1);
                    }
                    else
                    {
                        _local_2.push(_local_1);
                    };
                };
                _local_1++;
            };
            if (_local_2.length > 0)
            {
                ENEMY_TARGET = _local_2[NumberUtil.randomInt(0, (_local_2.length - 1))];
            }
            else
            {
                ENEMY_TARGET = _local_3[NumberUtil.randomInt(0, (_local_3.length - 1))];
            };
        }

        public static function getRandomPlayerTarget():*
        {
            var _local_1:int;
            var _local_2:Array = [];
            var _local_3:Array = [];
            while (_local_1 < BattleManager.getBattle().enemy_team_players.length)
            {
                if (!BattleManager.getBattle().enemy_team_players[_local_1].health_manager.isDead())
                {
                    if (((Boolean(BattleManager.getBattle().enemy_team_players[_local_1].effects_manager.hadEffect("sleep"))) || (Boolean(BattleManager.getBattle().enemy_team_players[_local_1].effects_manager.hadEffect("pet_sleep")))))
                    {
                        _local_3.push(_local_1);
                    }
                    else
                    {
                        _local_2.push(_local_1);
                    };
                };
                _local_1++;
            };
            if (_local_2.length > 0)
            {
                PLAYER_TARGET = _local_2[NumberUtil.randomInt(0, (_local_2.length - 1))];
            }
            else
            {
                PLAYER_TARGET = _local_3[NumberUtil.randomInt(0, (_local_3.length - 1))];
            };
        }

        public static function resetVarsForNextTurn():*
        {
            PLAY_DEAD_ANIMATION = "";
            ATTACKER_TYPE = "";
            ATTACK_FROM = "";
            REDUCED_HP_AS_DAMAGE = false;
            IS_DISPERSED = false;
            GENJUTSU_REBOUND = false;
            SWITCH_ATTACK_MODELS = false;
            IS_SELF_SKILL = false;
            IS_GENJUTSU = false;
            SHOW_DAMAGE_ZERO = false;
            CAN_NOT_DODGE = false;
            SKILL_USED_TYPE = 0;
            HP_RECOVER_AFTER = 0;
            CP_RECOVER_AFTER = 0;
        }

        public static function calculateDodge(_arg_1:Object, _arg_2:Object):void
        {
            var _local_3:int = int(_arg_2.getAccuracy());
            var _local_4:int = int(_arg_1.getDodgeRate());
            var _local_5:int = (_local_4 - _local_3);
            var _local_6:int = NumberUtil.getRandomInt();
            _arg_1.IS_DODGED = ((_local_5 >= _local_6) ? true : false);
        }

        public static function getCalculateDodge(_arg_1:Object, _arg_2:Object, _arg_3:String):Boolean
        {
            var _local_4:int = int(_arg_2.getAccuracy());
            var _local_5:int = _arg_1.getDodgeRate();
            var _local_6:int = SkillLibrary.getExtremeHitChance(_arg_3);
            _local_5 = (_local_5 - _local_6);
            var _local_7:int = (_local_5 - _local_4);
            var _local_8:int = NumberUtil.getRandomInt();
            _arg_1.IS_DODGED = ((_local_7 >= _local_8) ? true : false);
            return (_arg_1.IS_DODGED);
        }

        public static function calculateCritical(_arg_1:Object, _arg_2:Object):void
        {
            var _local_3:int = int(_arg_2.getCriticalChance());
            if (((BattleVars.SKILL_USED_ID == "skill_1062") && (_local_3 < 50)))
            {
                _local_3 = 70;
            }
            else
            {
                if (((BattleVars.SKILL_USED_ID == "skill_6060") && (_local_3 < 50)))
                {
                    _local_3 = 60;
                };
            };
            var _local_4:int = NumberUtil.getRandomInt();
            IS_CRITICAL = ((_local_3 >= _local_4) ? true : false);
        }

        public static function checkPurify(_arg_1:*):Boolean
        {
            var _local_4:Boolean;
            var _local_2:int = int(_arg_1.getPurify());
            var _local_3:int = NumberUtil.getRandomInt();
            if (_local_2 >= _local_3)
            {
                _arg_1.effects_manager.purifyPlayer();
                return (true);
            };
            return (false);
        }

        public static function checkCombustion(_arg_1:*):*
        {
            var _local_2:int = int(_arg_1.getCombustionChance());
            var _local_3:int = NumberUtil.getRandomInt();
            IS_COMBUSTION = ((_local_2 >= _local_3) ? true : false);
            if (IS_COMBUSTION)
            {
                _arg_1.effects_manager.showCombustion();
            };
        }


        public function reset():*
        {
            GF.clearArray(this.PLAYER_TEAM);
            GF.clearArray(this.ENEMY_TEAM);
            this.PLAYER_TEAM = [];
            this.ENEMY_TEAM = [];
        }

        public function addPlayerToTeam(_arg_1:String, _arg_2:String):*
        {
            switch (_arg_1)
            {
                case "player":
                    if (this.PLAYER_TEAM.length == 3)
                    {
                        return;
                    };
                    this.PLAYER_TEAM.push(_arg_2);
                    return;
                case "enemy":
                    if (this.ENEMY_TEAM.length == 3)
                    {
                        return;
                    };
                    this.ENEMY_TEAM.push(_arg_2);
                    return;
            };
        }

        public function destroy():*
        {
            this.reset();
        }


    }
}//package Combat

