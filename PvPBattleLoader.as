// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.pvp.battle.PvPBattleLoader

package id.ninjasage.pvp.battle
{
    import flash.display.MovieClip;
    import id.ninjasage.multiplayer.battle.Battle;
    import flash.events.IEventDispatcher;
    import id.ninjasage.pvp.PvPSocket;
    import id.ninjasage.Log;
    import id.ninjasage.multiplayer.battle.CharacterManager;
    import id.ninjasage.multiplayer.battle.CharacterModel;
    import flash.events.Event;
    import com.utils.GF;

    public class PvPBattleLoader 
    {

        private static const BG_LINKAGE:String = "BattleBG";
        private static const MAX_TEAM_SIZE:int = 3;
        private static const UI_ELEMENTS_TO_HIDE:Array = ["char_hpcp", "atbBar", "effectLogMC", "atk_turnTimerTxt", "btn_openLog"];
        private static const ACTION_BAR_ELEMENTS:Array = ["enemyMcInfo_0", "enemyMcInfo_1", "enemyMcInfo_2", "btn_senjutsu", "btn_ninjutsu"];
        private static const CHARACTER_PREFIXES:Array = ["charMc_", "charPetMc_", "enemyMc_", "enemyPetMc_", "scrollDisplayMc_"];

        private var _backgroundMC:MovieClip;
        private var _battle:Battle;
        private var _main:*;
        private var _destroyed:Boolean = false;
        private var _loadTarget:IEventDispatcher;

        public function PvPBattleLoader(_arg_1:Battle, _arg_2:*)
        {
            this._battle = _arg_1;
            this._main = _arg_2;
        }

        public function loadPlayer():*
        {
            PvPSocket.getInstance().on("Battle.getPlayerInfo", this.onPlayerInfo);
            PvPSocket.getInstance().emit("Battle.getPlayerInfo", {
                "battle_id":PvPBattleManager.getBattleID(),
                "char_id":PvPBattleManager.getPlayerTeam()[0]
            });
        }

        public function onPlayerInfo(_arg_1:Object):void
        {
            Log.info(this, "onPlayerInfo", JSON.stringify(_arg_1));
            PvPSocket.getInstance().off("Battle.getPlayerInfo", this.onPlayerInfo);
            var _local_2:* = "player";
            var _local_3:* = 0;
            var _local_4:CharacterManager = new CharacterManager(_arg_1);
            PvPBattleManager.addCharacterManager(_local_2, _local_3, _local_4);
            var _local_5:CharacterModel = new CharacterModel(_local_2, _local_3);
            var _local_6:PvPActionManager = new PvPActionManager(_local_2, _local_3, _arg_1.id);
            _local_5.setup(_local_4, this._battle);
            _local_4.setModel(_local_5);
            _local_4.setActionManager(_local_6);
            this.loadEnemy();
        }

        public function loadEnemy():*
        {
            PvPSocket.getInstance().on("Battle.getPlayerInfo", this.onEnemyInfo);
            PvPSocket.getInstance().emit("Battle.getPlayerInfo", {
                "battle_id":PvPBattleManager.getBattleID(),
                "char_id":PvPBattleManager.getEnemyTeam()[0]
            });
        }

        public function onEnemyInfo(_arg_1:Object):void
        {
            Log.info(this, "onEnemyInfo", JSON.stringify(_arg_1));
            PvPSocket.getInstance().off("Battle.getPlayerInfo", this.onEnemyInfo);
            var _local_2:* = "enemy";
            var _local_3:* = 0;
            var _local_4:CharacterManager = new CharacterManager(_arg_1);
            PvPBattleManager.addCharacterManager(_local_2, _local_3, _local_4);
            var _local_5:CharacterModel = new CharacterModel(_local_2, _local_3);
            var _local_6:PvPActionManager = new PvPActionManager(_local_2, _local_3, _arg_1.id);
            _local_5.setup(_local_4, this._battle);
            _local_4.setModel(_local_5);
            _local_4.setActionManager(_local_6);
            PvPBattleManager.AGILITY_BAR_MANAGER.setup();
            PvPBattleManager.BATTLE_HANDLER.setup();
        }

        public function loadBackground(_arg_1:String=null):void
        {
            if (this._destroyed)
            {
                Log.warning("PvPBattleLoader", "loadBackground", "Loader is destroyed");
                return;
            };
            var _local_2:String = ((_arg_1) || (PvPBattleManager.getBackground()));
            if (((!(_local_2)) || (_local_2.length == 0)))
            {
                Log.warning("PvPBattleLoader", "loadBackground", "No background ID specified");
                return;
            };
            this.removeLoadListener();
            this._main.loadSwf("mission", _local_2, this.handleBackgroundLoad);
        }

        private function removeLoadListener():void
        {
            if (this._loadTarget)
            {
                try
                {
                    this._loadTarget.removeEventListener(Event.COMPLETE, this.handleBackgroundLoad);
                }
                catch(e:Error)
                {
                };
                this._loadTarget = null;
            };
        }

        private function handleBackgroundLoad(_arg_1:Event):void
        {
            if (this._destroyed)
            {
                return;
            };
            this._loadTarget = (_arg_1.target as IEventDispatcher);
            if (this._loadTarget)
            {
                this._loadTarget.removeEventListener(Event.COMPLETE, this.handleBackgroundLoad);
            };
            this.clearLoadedBackground();
            if (((!(_arg_1.target)) || (!(_arg_1.target.content))))
            {
                Log.error("PvPBattleLoader", "handleBackgroundLoad", "Invalid load event target");
                this._loadTarget = null;
                return;
            };
            this._backgroundMC = _arg_1.target.content[BG_LINKAGE];
            if (!this._backgroundMC)
            {
                Log.warning("PvPBattleLoader", "handleBackgroundLoad", ("Background MC not found: " + BG_LINKAGE));
                this._loadTarget = null;
                return;
            };
            this._backgroundMC.gotoAndStop(1);
            this._backgroundMC.width = (this._backgroundMC.width + 100);
            if (((this._battle) && (this._battle.bgHolder)))
            {
                this._battle.bgHolder.addChild(this._backgroundMC);
            };
            if (_arg_1.target.loader)
            {
                _arg_1.target.loader.unloadAndStop(true);
            };
            this._loadTarget = null;
        }

        public function clearLoadedBackground():void
        {
            if (this._backgroundMC)
            {
                if ((((this._battle) && (this._battle.bgHolder)) && (this._backgroundMC.parent == this._battle.bgHolder)))
                {
                    this._battle.bgHolder.removeChild(this._backgroundMC);
                }
                else
                {
                    if (this._backgroundMC.parent)
                    {
                        this._backgroundMC.parent.removeChild(this._backgroundMC);
                    };
                };
                this._backgroundMC.cacheAsBitmap = false;
                GF.removeAllChild(this._backgroundMC);
                this._backgroundMC = null;
                Log.debug("PvPBattleLoader", "clearLoadedBackground", "Background destroyed");
            };
        }

        public function hideEverything():void
        {
            var senjutsuTransition:* = undefined;
            var charHpcp:MovieClip;
            if (((!(this._battle)) || (this._destroyed)))
            {
                return;
            };
            var isSpectator:Boolean = PvPBattleManager.getIsSpectator();
            this.hideUIElements(isSpectator);
            this.hideActionBarElements();
            this.hideCharacterElements();
            this.disableSenjutsuButton();
            if (((isSpectator) && (this._battle.hasOwnProperty("char_hpcp"))))
            {
                charHpcp = (this._battle.char_hpcp as MovieClip);
                if (charHpcp)
                {
                    charHpcp.visible = false;
                };
            };
            senjutsuTransition = PvPBattleManager.getBattle().senjutsuTransition;
            senjutsuTransition.addFrameScript((senjutsuTransition.totalFrames - 1), function ():*
            {
                senjutsuTransition.gotoAndStop(1);
            });
        }

        public function disableSenjutsuButton():void
        {
            if (((!(this._battle)) || (this._destroyed)))
            {
                return;
            };
            PvPBattleManager.getMain().initButtonDisable(this._battle["char_hpcp"]["btn_activate_senjutsu"], null);
        }

        private function hideUIElements(_arg_1:Boolean=false):void
        {
            var _local_2:String;
            var _local_3:*;
            var _local_4:*;
            for each (_local_2 in UI_ELEMENTS_TO_HIDE)
            {
                if (this._battle.hasOwnProperty(_local_2))
                {
                    _local_3 = this._battle[_local_2];
                    if (_local_3)
                    {
                        _local_3.visible = false;
                    };
                };
            };
            if (_arg_1)
            {
                if (this._battle.hasOwnProperty("btn_UI_Gear"))
                {
                    _local_4 = this._battle.btn_UI_Gear;
                    if (_local_4)
                    {
                        _local_4.visible = false;
                    };
                };
            };
        }

        private function hideActionBarElements():void
        {
            var _local_2:String;
            var _local_3:*;
            if (!this._battle.hasOwnProperty("actionBar"))
            {
                return;
            };
            var _local_1:* = this._battle.actionBar;
            if (!_local_1)
            {
                return;
            };
            _local_1.visible = false;
            for each (_local_2 in ACTION_BAR_ELEMENTS)
            {
                if (_local_1.hasOwnProperty(_local_2))
                {
                    _local_3 = _local_1[_local_2];
                    if (_local_3)
                    {
                        _local_3.visible = false;
                    };
                };
            };
        }

        private function hideCharacterElements():void
        {
            var _local_2:String;
            var _local_3:String;
            var _local_4:*;
            var _local_1:int;
            while (_local_1 < MAX_TEAM_SIZE)
            {
                for each (_local_2 in CHARACTER_PREFIXES)
                {
                    _local_3 = (_local_2 + String(_local_1));
                    if (this._battle.hasOwnProperty(_local_3))
                    {
                        _local_4 = this._battle[_local_3];
                        if (_local_4)
                        {
                            _local_4.visible = false;
                        };
                    };
                };
                _local_1++;
            };
        }

        public function destroy():void
        {
            if (this._destroyed)
            {
                return;
            };
            PvPSocket.getInstance().off("Battle.getPlayerInfo", this.onPlayerInfo);
            PvPSocket.getInstance().off("Battle.getPlayerInfo", this.onEnemyInfo);
            this._destroyed = true;
            this.removeLoadListener();
            this.clearLoadedBackground();
            this._battle = null;
            this._main = null;
        }


    }
}//package id.ninjasage.pvp.battle

