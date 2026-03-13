// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.BattleManager

package Combat
{
    import Storage.Character;
    import flash.utils.setTimeout;

    public class BattleManager 
    {

        public static var BATTLE:Battle;
        public static var BATTLE_TOOLTIP:BattleTooltip;
        public static var BATTLE_LOADER:BattleLoader;
        public static var BATTLE_VARS:BattleVars;
        public static var MAIN:main;


        public static function init(_arg_1:Battle, _arg_2:main, _arg_3:String, _arg_4:String, _arg_5:String="BattleBG"):void
        {
            BATTLE = _arg_1;
            MAIN = _arg_2;
            if (BATTLE_TOOLTIP == null)
            {
                BATTLE_TOOLTIP = new BattleTooltip();
            };
            if (BATTLE_VARS)
            {
                BATTLE_VARS.reset();
            }
            else
            {
                BATTLE_VARS = new BattleVars();
            };
            BATTLE_VARS.BATTLE_MODE = _arg_3;
            BATTLE_VARS.BATTLE_BACKGROUND = _arg_4;
            BATTLE_VARS.ORIGINAL_BATTLE_BACKGROUND = _arg_4;
            if (BATTLE_LOADER == null)
            {
                BATTLE_LOADER = new BattleLoader();
            };
            BattleLoader.BG_Linkage = _arg_5;
            BattleVars.CHARACTER_REVIVED = [false, false, false];
            BattleVars.CHARACTER_TEAM_REVIVED = [false, false, false];
            BattleVars.CHARACTER_LEFT_REDUCE_CD = [2, 2, 2];
            BattleVars.CHARACTER_ICM = [false, false, false];
            BattleVars.ENEMY_REVIVED = [false, false, false];
            BattleVars.ENEMY_TEAM_REVIVED = [false, false, false];
            BattleVars.ENEMY_ICM = [false, false, false];
            BattleVars.ENEMY_LEFT_REDUCE_CD = [2, 2, 2];
            BattleVars.PLAYER_TEAM_LOADED = false;
            BattleVars.ENEMY_TEAM_LOADED = false;
            BattleVars.PLAYER_TARGET = 0;
            BattleVars.MASTER_PLAYER_TARGET = 0;
            BattleVars.ENEMY_TARGET = 0;
            BattleVars.MATCH_RUNNING = true;
        }

        public static function modifyChance(_arg_1:Array, _arg_2:String, _arg_3:int, _arg_4:String=""):int
        {
            var _local_6:Object;
            var _local_7:Boolean;
            var _local_5:int;
            _loop_1:
            for each (_local_6 in _arg_1)
            {
                _local_5 = _local_6.amount;
                _local_7 = false;
                switch (_local_6.effect)
                {
                    case "transform":
                    case "pet_frenzy":
                        _local_5 = _local_6.amount_cp;
                        break;
                    case "meditation":
                        _local_5 = _local_6.amount_dodge;
                        break;
                    case "slow":
                    case "slow_oil":
                        if (_local_6.calc_type == "number")
                        {
                            _arg_3 = (_arg_3 - _local_6.amount);
                        }
                        else
                        {
                            _arg_3 = int((_arg_3 - Math.floor(((_arg_3 * _local_5) / 100))));
                        };
                        continue _loop_1;
                    case "cp_cost":
                        if (_local_6.calc_type == "number")
                        {
                            _arg_3 = (_arg_3 + _local_5);
                        }
                        else
                        {
                            if (_local_6.calc_type == "added_percent")
                            {
                                _arg_3 = int((_arg_3 + Math.floor(((_local_5 * _arg_3) / 100))));
                            }
                            else
                            {
                                _arg_3 = Math.floor((_local_5 * _arg_3));
                            };
                        };
                        continue _loop_1;
                };
                if (_arg_2 == "ADD")
                {
                    if ((((((!(_arg_4 == "accuracy")) && (!(_arg_4 == "purify"))) && (!(_arg_4 == "dodge"))) && (!(_arg_4 == "critical"))) && (!(_arg_4 == "reactive_force"))))
                    {
                        _arg_3 = ((_local_6.calc_type == "percent") ? int((_arg_3 = int((_arg_3 + Math.round(((_arg_3 * _local_5) / 100)))))) : _arg_3 = (_arg_3 + _local_5));
                    }
                    else
                    {
                        if (((_local_6.effect == "aqua_regia") && (_arg_4 == "accuracy")))
                        {
                            _arg_3 = (_arg_3 + _local_6.increase_accuracy);
                        }
                        else
                        {
                            if (((_local_6.effect == "aqua_regia") && (_arg_4 == "purify")))
                            {
                                _arg_3 = (_arg_3 + _local_6.increase_purify);
                            }
                            else
                            {
                                _arg_3 = (_arg_3 + _local_5);
                            };
                        };
                    };
                }
                else
                {
                    if (_arg_2 == "RM")
                    {
                        if ((((((!(_arg_4 == "accuracy")) && (!(_arg_4 == "purify"))) && (!(_arg_4 == "dodge"))) && (!(_arg_4 == "critical"))) && (!(_arg_4 == "reactive_force"))))
                        {
                            _arg_3 = ((_local_6.calc_type == "percent") ? int((_arg_3 = int((_arg_3 - Math.round(((_arg_3 * _local_5) / 100)))))) : _arg_3 = (_arg_3 - _local_5));
                        }
                        else
                        {
                            _arg_3 = (_arg_3 - _local_5);
                        };
                    };
                };
                if (_arg_4 == "critical")
                {
                };
            };
            return (_arg_3);
        }

        public static function showMessage(_arg_1:String):*
        {
            MAIN.showMessage(_arg_1);
        }

        public static function giveMessage(_arg_1:String):void
        {
            MAIN.giveMessage(_arg_1);
        }

        public static function getNotice(_arg_1:String):void
        {
            MAIN.getNotice(_arg_1);
        }

        public static function startBattle():void
        {
            if (int(Character.character_rank) < 6)
            {
                Character.character_class = null;
            };
            MAIN.loading(true);
            var _local_1:int;
            var _local_2:Array = ((Character.temp_recruit_ids.length > 0) ? Character.temp_recruit_ids : Character.character_recruit_ids);
            _local_2 = ((BATTLE_VARS.BATTLE_MODE == BattleVars.CREW_MATCH) ? Character.temp_recruit_ids : _local_2);
            if (Character.is_independence_event)
            {
                if (Character.character_recruit_ids.length > 0)
                {
                    _local_2[1] = Character.character_recruit_ids[0];
                };
            };
            while (_local_1 < _local_2.length)
            {
                if (((((((!(MAIN.is_exam_stage3)) && (!(Character.is_clan_war))) && (!(MAIN.is_jounin_exam_stage2))) && (!(Character.is_ramadhan_event))) && (!(Character.is_hanami_event))) && (!(BATTLE_VARS.BATTLE_MODE == BattleVars.SHADOWWAR_MATCH))))
                {
                    addPlayerToTeam("player", _local_2[_local_1]);
                };
                _local_1++;
            };
            Character.battle_logs = [];
            BattleTooltip.reInitTooltip();
            BATTLE.setupView();
        }

        public static function hideEverything():void
        {
            BATTLE_LOADER.hideEverything();
        }

        public static function addPlayerToTeam(_arg_1:String, _arg_2:String):void
        {
            BATTLE_VARS.addPlayerToTeam(_arg_1, _arg_2);
        }

        public static function getBackgound():String
        {
            return (BATTLE_VARS.BATTLE_BACKGROUND);
        }

        public static function getPlayerTeam():Array
        {
            return (BATTLE_VARS.PLAYER_TEAM);
        }

        public static function getEnemyTeam():Array
        {
            return (BATTLE_VARS.ENEMY_TEAM);
        }

        public static function getMain():main
        {
            return (MAIN);
        }

        public static function getBattle():Battle
        {
            return (BATTLE);
        }

        public static function loadPlayerTeam(_arg_1:int=0):void
        {
            BATTLE_LOADER.loadPlayerTeam(_arg_1);
        }

        public static function loadEnemyTeam(_arg_1:int=0):void
        {
            BATTLE_LOADER.loadEnemyTeam(_arg_1);
            setTimeout(checkStartMatch, 100);
        }

        public static function checkStartMatch():*
        {
            if (((BattleVars.PLAYER_TEAM_LOADED) && (BattleVars.ENEMY_TEAM_LOADED)))
            {
                BattleVars.PLAYER_TEAM_LOADED = false;
                BattleVars.ENEMY_TEAM_LOADED = false;
                setTimeout(BATTLE.setupAgilityBar, 100);
            };
        }

        public static function loadBackground():void
        {
            BATTLE_LOADER.loadBackground();
        }

        public static function loading(_arg_1:*):void
        {
            MAIN.loading(_arg_1);
        }

        public static function startRun():void
        {
            BATTLE.agility_bar_manager.startRun();
        }

        public static function getTotalDamage():int
        {
            return (BATTLE.total_damage);
        }

        public static function playBgm():*
        {
            if (!MAIN)
            {
                return;
            };
            MAIN.stopAllBgm();
            MAIN.startBgm("battle");
        }

        public static function destroyCombat():*
        {
            if (BATTLE_LOADER)
            {
                BATTLE_LOADER.destroy();
            };
            if (BATTLE_VARS)
            {
                BATTLE_VARS.destroy();
            };
            if (BATTLE_TOOLTIP)
            {
                BATTLE_TOOLTIP.destroy();
            };
            BATTLE_VARS = null;
            BATTLE_LOADER = null;
            BATTLE_TOOLTIP = null;
            BATTLE = null;
            MAIN = null;
        }


    }
}//package Combat

