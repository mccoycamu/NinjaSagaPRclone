// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.pvp.battle.PvPBattleManager

package id.ninjasage.pvp.battle
{
    import id.ninjasage.multiplayer.battle.Battle;
    import id.ninjasage.multiplayer.EffectOverlay;
    import id.ninjasage.pvp.PvP;
    import id.ninjasage.Log;
    import id.ninjasage.multiplayer.battle.CharacterManager;
    import Managers.NinjaSage;

    public class PvPBattleManager 
    {

        private static var _instance:PvPBattleManager;
        private static var _battle:Battle;
        private static var _battleLoader:PvPBattleLoader;
        private static var _battleVars:PvPBattleVars;
        private static var _agilityBarManager:PvPAgilityBarManager;
        private static var _battleHandler:PvPBattleHandler;
        private static var _battleTooltip:PvPBattleTooltip;
        private static var _effectOverlay:EffectOverlay;
        private static var _main:*;
        private static var _pvp:PvP;
        private static var _isHost:Boolean = false;
        private static var _isSpectator:Boolean = false;
        private static var _characterManagers:* = {
            "player":[],
            "enemy":[]
        };

        public function PvPBattleManager()
        {
            if (_instance)
            {
                throw (new Error("PvPBattleManager is a singleton. Use getInstance() instead."));
            };
        }

        public static function getInstance():PvPBattleManager
        {
            if (!_instance)
            {
                _instance = new (PvPBattleManager)();
            };
            return (_instance);
        }

        public static function init(_arg_1:PvP, _arg_2:String):void
        {
            if (!_arg_1)
            {
                Log.error("PvPBattleManager", "init", "PvP instance is null");
                return;
            };
            if (((!(_arg_2)) || (_arg_2.length == 0)))
            {
                Log.warning("PvPBattleManager", "init", "No background ID provided, using default");
                _arg_2 = "mission_1011";
            };
            _pvp = _arg_1;
            _battle = _arg_1.battleUI;
            _main = _arg_1.main;
            if (!_main)
            {
                Log.error("PvPBattleManager", "init", "Main instance is null");
                return;
            };
            if (_battleVars)
            {
                _battleVars.reset();
            }
            else
            {
                _battleVars = new PvPBattleVars();
            };
            _battleVars.battleMode = "PVP";
            _battleVars.battleBackground = _arg_2;
            _battleVars.originalBattleBackground = _arg_2;
            if (!_battleTooltip)
            {
                _battleTooltip = new PvPBattleTooltip();
            };
            if (((!(_effectOverlay)) && (_battle)))
            {
                _effectOverlay = new EffectOverlay(_battle);
                _effectOverlay.init();
            };
            if (!_battleLoader)
            {
                _battleLoader = new PvPBattleLoader(_battle, _main);
            };
            _battleVars.matchRunning = true;
        }

        public static function initiateBattle(_arg_1:PvP, _arg_2:Object):void
        {
            var _local_4:String;
            var _local_5:String;
            if (((!(_arg_1)) || (!(_arg_2))))
            {
                Log.error("PvPBattleManager", "initiateBattle", "Invalid parameters");
                return;
            };
            Log.info("PvPBattleManager", "initiateBattle", "Starting PvP battle");
            _isSpectator = ((_arg_1.spectatorMode) || ((_arg_2.hasOwnProperty("spectator")) && (_arg_2.spectator === true)));
            if (!_isSpectator)
            {
                _local_4 = ((_arg_2.hostId) || (_arg_2.host_char_id));
                if (((_local_4) && (_arg_1.character)))
                {
                    _isHost = (String(_local_4) == String(_arg_1.character.getID()));
                };
            }
            else
            {
                _isHost = false;
                _local_5 = ((_arg_2.hostId) || (_arg_2.host_char_id));
                if (((_local_5) && (_arg_1.character)))
                {
                    _arg_1.character.setCharId(int(_local_5));
                };
            };
            var _local_3:String = (((_arg_2.background) || (_arg_2.stage)) || ("mission_1011"));
            init(_arg_1, _local_3);
            if (!_battleVars)
            {
                Log.error("PvPBattleManager", "initiateBattle", "Battle vars not initialized");
                return;
            };
            _battleVars.battleId = ((_arg_2.battleId) || (""));
            setupTeams(_arg_2);
            _battleLoader.loadBackground();
            _battleLoader.hideEverything();
            _battleLoader.loadPlayer();
            if (!_agilityBarManager)
            {
                _agilityBarManager = new PvPAgilityBarManager();
                _battleHandler = new PvPBattleHandler();
            };
            _pvp.visible = false;
            _main.loader.addChild(_battle);
        }

        private static function setupTeams(_arg_1:Object):void
        {
            var _local_6:Array;
            var _local_7:int;
            var _local_8:Array;
            var _local_2:String = ((_arg_1.hostId) || (_arg_1.host_char_id));
            var _local_3:String = ((_arg_1.enemyId) || (_arg_1.enemy_char_id));
            if (((!(_local_2)) || (!(_local_3))))
            {
                Log.warning("PvPBattleManager", "setupTeams", "Missing hostId or enemyId in payload");
                return;
            };
            var _local_4:String = ((_isHost) ? _local_2 : _local_3);
            var _local_5:String = ((_isHost) ? _local_3 : _local_2);
            if (_local_4)
            {
                _battleVars.addPlayerToTeam("player", _local_4);
            };
            if (_local_5)
            {
                _battleVars.addPlayerToTeam("enemy", _local_5);
            };
            if (((_arg_1.playerTeam) && (_arg_1.playerTeam is Array)))
            {
                _local_6 = (_arg_1.playerTeam as Array);
                _local_7 = 0;
                while (_local_7 < _local_6.length)
                {
                    _battleVars.addPlayerToTeam("player", _local_6[_local_7]);
                    _local_7++;
                };
            };
            if (((_arg_1.enemyTeam) && (_arg_1.enemyTeam is Array)))
            {
                _local_8 = (_arg_1.enemyTeam as Array);
                _local_7 = 0;
                while (_local_7 < _local_8.length)
                {
                    _battleVars.addPlayerToTeam("enemy", _local_8[_local_7]);
                    _local_7++;
                };
            };
        }

        public static function endBattle(_arg_1:Object=null):void
        {
            Log.info("PvPBattleManager", "endBattle", "Ending PvP battle");
            _battleVars.matchRunning = false;
            destroyBattle();
        }

        public static function hideEverything():void
        {
            if (_battleLoader)
            {
                _battleLoader.hideEverything();
            };
        }

        public static function addPlayerToTeam(_arg_1:String, _arg_2:String):void
        {
            var _local_3:Boolean;
            if (_battleVars)
            {
                _local_3 = _battleVars.addPlayerToTeam(_arg_1, _arg_2);
                if (!_local_3)
                {
                    Log.warning("PvPBattleManager", "addPlayerToTeam", ((("Failed to add character " + _arg_2) + " to team ") + _arg_1));
                };
            };
        }

        public static function getBackground():String
        {
            return ((_battleVars) ? _battleVars.battleBackground : "");
        }

        public static function getPlayerTeam():Array
        {
            return ((_battleVars) ? _battleVars.playerTeam : []);
        }

        public static function getEnemyTeam():Array
        {
            return ((_battleVars) ? _battleVars.enemyTeam : []);
        }

        public static function getMain():*
        {
            return (_main);
        }

        public static function getBattle():Battle
        {
            return (_battle);
        }

        public static function getBattleID():String
        {
            return ((_battleVars) ? _battleVars.battleId : "");
        }

        public static function getIsHost():Boolean
        {
            return (_isHost);
        }

        public static function getIsSpectator():Boolean
        {
            return (_isSpectator);
        }

        public static function getCharacterManagerByID(_arg_1:String):CharacterManager
        {
            var _local_3:Array;
            var _local_4:CharacterManager;
            var _local_5:int;
            var _local_2:int = int(_arg_1);
            _local_3 = _characterManagers["player"];
            _local_5 = 0;
            while (_local_5 < _local_3.length)
            {
                _local_4 = (_local_3[_local_5] as CharacterManager);
                if (((_local_4) && (_local_4.getID() == _local_2)))
                {
                    return (_local_4);
                };
                _local_5++;
            };
            _local_3 = _characterManagers["enemy"];
            _local_5 = 0;
            while (_local_5 < _local_3.length)
            {
                _local_4 = (_local_3[_local_5] as CharacterManager);
                if (((_local_4) && (_local_4.getID() == _local_2)))
                {
                    return (_local_4);
                };
                _local_5++;
            };
            return (null);
        }

        public static function loadBackground():void
        {
            if (_battleLoader)
            {
                _battleLoader.loadBackground();
            };
        }

        public static function loading(_arg_1:Boolean):void
        {
            if (((_main) && (_main.hasOwnProperty("loading"))))
            {
                _main.loading(_arg_1);
            };
        }

        public static function destroyBattle():void
        {
            var team:* = undefined;
            var num:* = undefined;
            var characterManager:CharacterManager;
            Log.debug("PvPBattleManager", "destroyBattle", "Destroying battle resources");
            if (((_main) && (_main.loader.contains(_battle))))
            {
                try
                {
                    _main.loader.removeChild(_battle);
                }
                catch(e:Error)
                {
                    Log.warning("PvPBattleManager", "destroyBattle", ("Error removing battle from main loader: " + e.message));
                };
            };
            if (_battle)
            {
                try
                {
                    _battle.clearBattleField();
                }
                catch(e:Error)
                {
                    Log.warning("PvPBattleManager", "destroyBattle", ("Error clearing battle field: " + e.message));
                };
                try
                {
                    _battle.destroy();
                }
                catch(e:Error)
                {
                    Log.warning("PvPBattleManager", "destroyBattle", ("Error destroying battle: " + e.message));
                };
                _battle = null;
            };
            if (_battleLoader)
            {
                try
                {
                    _battleLoader.destroy();
                }
                catch(e:Error)
                {
                    Log.warning("PvPBattleManager", "destroyBattle", ("Error destroying battle loader: " + e.message));
                };
                _battleLoader = null;
            };
            if (_battleVars)
            {
                _battleVars.matchRunning = false;
                try
                {
                    _battleVars.destroy();
                }
                catch(e:Error)
                {
                    Log.warning("PvPBattleManager", "destroyBattle", ("Error destroying battle vars: " + e.message));
                };
                _battleVars = null;
            };
            if (_effectOverlay)
            {
                try
                {
                    _effectOverlay.destroy();
                }
                catch(e:Error)
                {
                    Log.warning("PvPBattleManager", "destroyBattle", ("Error destroying effect overlay: " + e.message));
                };
                _effectOverlay = null;
            };
            if (_agilityBarManager)
            {
                _agilityBarManager.destroy();
                _agilityBarManager = null;
            };
            if (_battleHandler)
            {
                _battleHandler.destroy();
                _battleHandler = null;
            };
            if (_characterManagers)
            {
                for (team in _characterManagers)
                {
                    for (num in _characterManagers[team])
                    {
                        characterManager = _characterManagers[team][num];
                        if (characterManager)
                        {
                            characterManager.destroy();
                        };
                    };
                    _characterManagers[team] = [];
                };
            };
            if (_pvp)
            {
                _pvp.visible = true;
                _pvp.goToLobby();
            };
            if (_battleTooltip)
            {
                _battleTooltip.destroy();
                _battleTooltip = null;
            };
            if (_main)
            {
                _main.getLoader("combat").removeAll();
                _main.getLoader("assets").removeAll();
                _main.getLoader("specialclass").removeAll();
                _main.getLoader("skills").removeAll();
                _main.getLoader("talents").removeAll();
            };
            if ((((_pvp) && (_pvp.character)) && (_isSpectator)))
            {
                _pvp.character.revertCharId();
            };
            NinjaSage.clearLoader();
            _main = null;
            _pvp = null;
            _isHost = false;
            _isSpectator = false;
        }

        public static function get BATTLE():Battle
        {
            return (_battle);
        }

        public static function get BATTLE_LOADER():PvPBattleLoader
        {
            return (_battleLoader);
        }

        public static function get BATTLE_VARS():PvPBattleVars
        {
            return (_battleVars);
        }

        public static function get MAIN():*
        {
            return (_main);
        }

        public static function get PVP():PvP
        {
            return (_pvp);
        }

        public static function get IS_HOST():Boolean
        {
            return (_isHost);
        }

        public static function get ROOM_INFO():*
        {
            return (_pvp.roomInfo);
        }

        public static function get CHARACTER_MANAGERS():*
        {
            return (_characterManagers);
        }

        public static function get AGILITY_BAR_MANAGER():*
        {
            return (_agilityBarManager);
        }

        public static function get BATTLE_HANDLER():PvPBattleHandler
        {
            return (_battleHandler);
        }

        public static function addCharacterManager(_arg_1:String, _arg_2:int, _arg_3:CharacterManager):void
        {
            _characterManagers[_arg_1][_arg_2] = _arg_3;
        }

        public static function get BATTLE_TOOLTIP():PvPBattleTooltip
        {
            return (_battleTooltip);
        }

        public static function get EFFECT_OVERLAY():EffectOverlay
        {
            return (_effectOverlay);
        }


    }
}//package id.ninjasage.pvp.battle

