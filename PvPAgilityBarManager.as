// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.pvp.battle.PvPAgilityBarManager

package id.ninjasage.pvp.battle
{
    import flash.display.MovieClip;
    import id.ninjasage.multiplayer.battle.Battle;
    import id.ninjasage.Log;
    import id.ninjasage.pvp.PvPSocket;
    import id.ninjasage.multiplayer.battle.CharacterManager;
    import id.ninjasage.multiplayer.battle.CharacterModel;
    import flash.display.Sprite;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;
    import gs.TweenLite;
    import gs.easing.Linear;
    import com.utils.GF;

    public class PvPAgilityBarManager 
    {

        private static const INITIAL_DELAY_MS:int = 500;
        private static const ACTION_BAR_DIVIDER:int = 20;
        private static const ACTION_BAR_WIDTH:int = 600;
        private static const HEAD_Y_PLAYER:int = -30;
        private static const HEAD_Y_ENEMY:int = 7;
        private static const HEAD_SCALE:Number = 0.5;
        private static const TEAM_PLAYER:String = "player";
        private static const TEAM_ENEMY:String = "enemy";

        private var _actionBar:MovieClip;
        private var _playersMcHolders:Object;
        private var _teamHeadMcAgility:Array;
        private var _battle:Battle;
        private var _isRunning:Boolean = false;
        private var _enableActions:Boolean = false;
        private var _turns:int = 0;
        private var _destroyed:Boolean = false;
        private var _timeoutId:uint = 0;
        private var _headOriginalParents:Array;
        private var _toRepeatNumber:int = 0;
        private var _calcType:String = "Integer";
        private var _plusXNextRound:Array;
        private var _lastAmbushIndex:int = -1;
        private var _ambushTeam:String = "";
        private var _ambushNum:int = -1;
        private var _sortIndices:Object = {};

        public function PvPAgilityBarManager()
        {
            this._teamHeadMcAgility = [];
            this._playersMcHolders = {};
            this._headOriginalParents = [];
            this._plusXNextRound = [0, 0, 0, 0, 0, 0];
            this._battle = PvPBattleManager.getBattle();
            if (!this._battle)
            {
                Log.warning("PvPAgilityBarManager", "constructor", "Battle not initialized");
                return;
            };
            if (!this.initializeActionBar())
            {
                return;
            };
            if (!this.initializePlayerHolders())
            {
                return;
            };
        }

        public function setup():void
        {
            this.setupHeadsAndAgility();
            this._actionBar.visible = true;
            PvPSocket.getInstance().on("Battle.startAttackBar", this.onStartAttackBar);
        }

        public function onStartAttackBar(_arg_1:Object):void
        {
            var _local_5:String;
            var _local_6:int;
            var _local_7:Boolean;
            var _local_8:CharacterManager;
            var _local_9:*;
            var _local_10:Object;
            var _local_11:Object;
            var _local_12:int;
            var _local_13:Object;
            var _local_2:Object = {};
            var _local_3:int = this._teamHeadMcAgility.length;
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                _local_10 = this._teamHeadMcAgility[_local_4];
                if (_local_10)
                {
                    _local_2[int(_local_10.id)] = _local_10;
                };
                _local_4++;
            };
            for (_local_5 in this._sortIndices)
            {
                delete this._sortIndices[_local_5];
            };
            _local_6 = 0;
            _local_7 = PvPBattleManager.getIsSpectator();
            for (_local_9 in _arg_1.x)
            {
                _local_11 = _arg_1.x[_local_9];
                _local_12 = int(_local_11.i);
                this._sortIndices[_local_12] = _local_6++;
                _local_8 = PvPBattleManager.getCharacterManagerByID(_local_11.i);
                if (_local_8)
                {
                    _local_8.updateStats({"agility":_local_11.a});
                };
                if (_local_7)
                {
                    _local_13 = _local_2[_local_12];
                    if (_local_13)
                    {
                        _local_13.x = ((this._turns == 0) ? _local_11.p : _local_11.s);
                    };
                };
            };
            if (_local_6 > 0)
            {
                this._teamHeadMcAgility.sort(this.sortAgilityHeads);
            };
            this.startRun(INITIAL_DELAY_MS, _arg_1);
        }

        private function sortAgilityHeads(_arg_1:Object, _arg_2:Object):int
        {
            var _local_3:Object = this._sortIndices[int(_arg_1.id)];
            var _local_4:Object = this._sortIndices[int(_arg_2.id)];
            var _local_5:int = ((_local_3 != null) ? int(_local_3) : 9999);
            var _local_6:int = ((_local_4 != null) ? int(_local_4) : 9999);
            return (_local_5 - _local_6);
        }

        private function initializeActionBar():Boolean
        {
            this._actionBar = this._battle.atbBar;
            if (!this._actionBar)
            {
                Log.warning("PvPAgilityBarManager", "initializeActionBar", "Action bar not found");
                return (false);
            };
            return (true);
        }

        private function initializePlayerHolders():Boolean
        {
            this._playersMcHolders = {
                "enemy_0":this._battle.enemyMc_0,
                "player_0":this._battle.charMc_0,
                "player_pet_0":this._battle.charPetMc_0,
                "enemy_pet_0":this._battle.enemyPetMc_0
            };
            return (true);
        }

        public function setupHeadsAndAgility():void
        {
            var _local_2:String;
            var _local_3:MovieClip;
            var _local_4:CharacterManager;
            var _local_5:MovieClip;
            var _local_6:*;
            var _local_7:Boolean;
            var _local_8:int;
            var _local_1:int;
            for (_local_2 in this._playersMcHolders)
            {
                _local_3 = (this._playersMcHolders[_local_2] as MovieClip);
                if (_local_3)
                {
                    _local_4 = this.getCharacterManager(_local_3);
                    if (_local_4)
                    {
                        _local_5 = _local_4.getCharacterModel().getHead();
                        if (_local_5)
                        {
                            _local_6 = _local_5.parent;
                            this._headOriginalParents.push(_local_6);
                            _local_7 = (_local_2.indexOf(TEAM_PLAYER) >= 0);
                            this.configureHead(_local_5, _local_4.getCharacterModel(), _local_7);
                            _local_8 = int(_local_4.getAgility());
                            if (_local_8 > _local_1)
                            {
                                _local_1 = _local_8;
                            };
                            this._teamHeadMcAgility.push({
                                "team":_local_4.getPlayerTeam(),
                                "num":_local_4.getPlayerNumber(),
                                "id":_local_4.getID(),
                                "agility":_local_8,
                                "headMc":_local_5,
                                "x":_local_5.x
                            });
                        };
                    };
                };
            };
            this.addHeadsToActionBar();
        }

        private function getCharacterManager(_arg_1:MovieClip):CharacterManager
        {
            var _local_2:* = int(_arg_1.name.split("_")[1]);
            if (_arg_1.name.indexOf("charMc_") >= 0)
            {
                return (PvPBattleManager.CHARACTER_MANAGERS["player"][_local_2]);
            };
            if (_arg_1.name.indexOf("enemyMc_") >= 0)
            {
                return (PvPBattleManager.CHARACTER_MANAGERS["enemy"][_local_2]);
            };
            return (null);
        }

        private function configureHead(_arg_1:MovieClip, _arg_2:CharacterModel, _arg_3:Boolean):void
        {
            _arg_1.x = 0;
            _arg_1.y = ((_arg_3) ? HEAD_Y_PLAYER : HEAD_Y_ENEMY);
            _arg_1.scaleX = ((_arg_2.isCharacter()) ? HEAD_SCALE : -(HEAD_SCALE));
            _arg_1.scaleY = HEAD_SCALE;
        }

        private function addHeadsToActionBar():void
        {
            var _local_3:MovieClip;
            if (((!(this._actionBar)) || (!(this._actionBar.hasOwnProperty("holder")))))
            {
                return;
            };
            var _local_1:Sprite = (this._actionBar.holder as Sprite);
            var _local_2:int;
            while (_local_2 < this._teamHeadMcAgility.length)
            {
                _local_3 = (this._teamHeadMcAgility[_local_2].headMc as MovieClip);
                if (((_local_3) && (!(_local_3.parent == _local_1))))
                {
                    if (_local_3.parent)
                    {
                        _local_3.parent.removeChild(_local_3);
                    };
                    _local_1.addChild(_local_3);
                };
                _local_2++;
            };
        }

        public function startRun(delayMs:int=0, data:*=null):void
        {
            var animation:* = undefined;
            if (this._timeoutId > 0)
            {
                clearTimeout(this._timeoutId);
                this._timeoutId = 0;
            };
            if (delayMs > 0)
            {
                this._timeoutId = setTimeout(this.startRun, delayMs, 0);
                return;
            };
            if (((!(PvPBattleManager.BATTLE_VARS.matchRunning)) || (this._destroyed)))
            {
                Log.debug("PvPAgilityBarManager", "startRun", "Match not running or destroyed, aborting");
                return;
            };
            if (((this._turns == 0) && (!(PvPBattleManager.getIsSpectator()))))
            {
                animation = new Animation(this._battle, true);
                animation.addFrameScript((animation.totalFrames - 1), function ():void
                {
                    animation.destroy();
                    PvPBattleManager.getMain().loader.removeChild(animation);
                    animation.addFrameScript((animation.totalFrames - 1), null);
                    run(data);
                });
                PvPBattleManager.getMain().loader.addChild(animation);
                animation.gotoAndPlay(1);
            }
            else
            {
                this.run(data);
            };
        }

        public function run(_arg_1:*=null):*
        {
            this._turns++;
            this.updateAgilityToActionBar();
            this.checkAmbush();
        }

        public function updateAgilityToActionBar():void
        {
            var _local_2:*;
            var _local_3:int;
            var _local_5:String;
            var _local_6:int;
            var _local_1:int;
            var _local_4:int;
            while (_local_4 < this._teamHeadMcAgility.length)
            {
                _local_5 = (this._teamHeadMcAgility[_local_4].team as String);
                _local_6 = (this._teamHeadMcAgility[_local_4].num as int);
                _local_2 = PvPBattleManager.CHARACTER_MANAGERS[_local_5][_local_6];
                if (_local_2)
                {
                    _local_3 = int(_local_2.getAgility());
                    this._teamHeadMcAgility[_local_4].agility = _local_3;
                    if (_local_3 > _local_1)
                    {
                        _local_1 = _local_3;
                    };
                };
                _local_4++;
            };
            this._toRepeatNumber = Math.floor((_local_1 / ACTION_BAR_DIVIDER));
        }

        public function checkAmbush():void
        {
            var _local_1:Array;
            var _local_2:MovieClip;
            var _local_3:Number;
            var _local_4:*;
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_15:String;
            var _local_16:int;
            var _local_17:MovieClip;
            var _local_18:*;
            var _local_19:Number;
            var _local_20:*;
            var _local_21:Number;
            var _local_8:Number = -1;
            var _local_9:Boolean;
            var _local_10:Number = ACTION_BAR_WIDTH;
            var _local_11:Array = [];
            var _local_12:uint;
            var _local_13:Number = 0;
            var _local_14:uint;
            while (_local_14 < this._teamHeadMcAgility.length)
            {
                _local_13 = (this._teamHeadMcAgility[_local_14].x as Number);
                _local_3 = int(this._teamHeadMcAgility[_local_14].agility);
                _local_15 = (this._teamHeadMcAgility[_local_14].team as String);
                _local_16 = (this._teamHeadMcAgility[_local_14].num as int);
                _local_4 = PvPBattleManager.CHARACTER_MANAGERS[_local_15][_local_16];
                _local_17 = (this._teamHeadMcAgility[_local_14].headMc as MovieClip);
                if (this._lastAmbushIndex == _local_14)
                {
                    this._lastAmbushIndex = -1;
                    _local_17.x = this._plusXNextRound[_local_14];
                    _local_13 = this._plusXNextRound[_local_14];
                    this._plusXNextRound[_local_14] = 0;
                };
                _local_5 = _local_13;
                _local_7 = _local_3;
                if (this._toRepeatNumber > 2)
                {
                    if (this._calcType == "Integer")
                    {
                        _local_7 = Math.floor((_local_3 / this._toRepeatNumber));
                    }
                    else
                    {
                        _local_7 = Number(Number((_local_3 / this._toRepeatNumber)).toFixed(1));
                    };
                };
                _local_6 = (_local_5 + _local_7);
                if (this._plusXNextRound[_local_14] > 0)
                {
                    _local_6 = (_local_6 + this._plusXNextRound[_local_14]);
                    this._plusXNextRound[_local_14] = 0;
                };
                _local_11.push({
                    "team":_local_15,
                    "num":_local_16,
                    "x":_local_6
                });
                if (_local_6 > _local_8)
                {
                    _local_8 = _local_6;
                    _local_12 = _local_14;
                };
                _local_14++;
            };
            _local_14 = 0;
            while (_local_14 < _local_11.length)
            {
                _local_18 = _local_11[_local_14];
                _local_19 = _local_18.x;
                _local_20 = this._teamHeadMcAgility[_local_14];
                if (_local_19 >= _local_10)
                {
                    if (((!(_local_9)) && (_local_12 == _local_14)))
                    {
                        _local_9 = true;
                        this._lastAmbushIndex = _local_14;
                    };
                    this._plusXNextRound[_local_14] = (_local_19 - _local_10);
                    _local_20.x = _local_10;
                }
                else
                {
                    _local_20.x = _local_19;
                };
                _local_14++;
            };
            if (_local_9)
            {
                this.stop();
                this._ambushTeam = (_local_11[_local_12].team as String);
                this._ambushNum = int(_local_11[_local_12].num);
                _local_14 = 0;
                while (_local_14 < _local_11.length)
                {
                    _local_20 = this._teamHeadMcAgility[_local_14];
                    _local_2 = (_local_20.headMc as MovieClip);
                    _local_21 = (_local_20.x as Number);
                    if (_local_2)
                    {
                        TweenLite.to(_local_2, 0.8, {
                            "x":_local_21,
                            "ease":Linear.easeNone,
                            "onComplete":this.onAmbush,
                            "onCompleteParams":[_local_2, _local_14, _local_12]
                        });
                    };
                    _local_14++;
                };
                return;
            };
            this.checkAmbush();
        }

        public function onAmbush(_arg_1:MovieClip, _arg_2:int, _arg_3:int):void
        {
            var _local_4:CharacterManager;
            var _local_5:Array;
            var _local_6:int;
            var _local_7:*;
            TweenLite.killTweensOf(_arg_1);
            if (_arg_3 == _arg_2)
            {
                Log.debug("PvPAgilityBarManager", "onAmbush", ((("Ambush triggered by " + this._ambushTeam) + "_") + this._ambushNum));
                _local_4 = PvPBattleManager.CHARACTER_MANAGERS[this._ambushTeam][this._ambushNum];
                _local_5 = [];
                _local_6 = 0;
                while (_local_6 < this._teamHeadMcAgility.length)
                {
                    _local_7 = this._teamHeadMcAgility[_local_6];
                    _local_5.push({
                        "team":_local_7.team,
                        "num":_local_7.num,
                        "id":_local_7.id,
                        "x":_local_7.x
                    });
                    _local_6++;
                };
                PvPSocket.getInstance().emit("Battle.ambush", {
                    "battle_id":PvPBattleManager.getBattleID(),
                    "team":this._ambushTeam,
                    "num":this._ambushNum,
                    "char_id":_local_4.getID(),
                    "x":_local_5
                });
            };
        }

        public function stop():void
        {
            this._isRunning = false;
            this._enableActions = false;
            if (this._timeoutId > 0)
            {
                clearTimeout(this._timeoutId);
                this._timeoutId = 0;
            };
        }

        public function get isRunning():Boolean
        {
            return (this._isRunning);
        }

        public function get enableActions():Boolean
        {
            return (this._enableActions);
        }

        public function set enableActions(_arg_1:Boolean):void
        {
            this._enableActions = _arg_1;
        }

        public function get turns():int
        {
            return (this._turns);
        }

        public function destroy():void
        {
            var _local_1:*;
            var _local_2:int;
            var _local_3:*;
            var _local_4:MovieClip;
            if (this._destroyed)
            {
                return;
            };
            this._destroyed = true;
            this.stop();
            PvPSocket.getInstance().off("Battle.startAttackBar", this.onStartAttackBar);
            this._sortIndices = {};
            if (((this._actionBar) && (this._actionBar.hasOwnProperty("holder"))))
            {
                _local_1 = this._actionBar.holder;
                if (_local_1)
                {
                    _local_2 = 0;
                    while (_local_2 < this._teamHeadMcAgility.length)
                    {
                        _local_3 = this._teamHeadMcAgility[_local_2];
                        if (((_local_3) && (_local_3.length > 1)))
                        {
                            _local_4 = (_local_3[1] as MovieClip);
                            if (_local_4)
                            {
                                TweenLite.killTweensOf(_local_4);
                                if (_local_4.parent == _local_1)
                                {
                                    _local_1.removeChild(_local_4);
                                };
                                _local_4 = null;
                            };
                        };
                        _local_2++;
                    };
                    GF.removeAllChild(_local_1);
                };
            };
            if (this._teamHeadMcAgility)
            {
                _local_2 = 0;
                while (_local_2 < this._teamHeadMcAgility.length)
                {
                    this._teamHeadMcAgility[_local_2] = null;
                    _local_2++;
                };
                this._teamHeadMcAgility = [];
            };
            if (this._headOriginalParents)
            {
                this._headOriginalParents = [];
            };
            this._playersMcHolders = null;
            this._actionBar = null;
            this._battle = null;
        }


    }
}//package id.ninjasage.pvp.battle

