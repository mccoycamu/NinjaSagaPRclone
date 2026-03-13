// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.AgilityBarManager

package Combat
{
    import flash.display.MovieClip;
    import flash.utils.setTimeout;
    import Storage.Character;
    import com.utils.NumberUtil;
    import gs.TweenLite;
    import gs.easing.Linear;
    import id.ninjasage.Log;
    import com.utils.GF;

    public class AgilityBarManager 
    {

        public var action_bar:*;
        public var players_mc_holders:Object;
        public var team_headMc_agility:Array = [];
        public var plus_x_next_round:Array = [0, 0, 0, 0, 0, 0];
        public var calc_type:String = "Number";
        public var ambush_team:String = "";
        public var ambush_num:int = -1;
        public var action_bar_width:int = 600;
        public var action_bar_divider:int = 20;
        public var to_repeat_number:int = 0;
        public var last_ambush_index:int = -1;
        public var turns:int = 0;
        public var player_turns:int = 7;
        public var is_running:Boolean = false;
        public var enable_actions:Boolean = false;
        private var destroyed:* = false;

        public function AgilityBarManager()
        {
            var _local_1:* = BattleManager.getBattle();
            this.action_bar = _local_1["atbBar"];
            this.players_mc_holders = {
                "enemy_0":_local_1["enemyMc_0"],
                "player_0":_local_1["charMc_0"],
                "player_1":_local_1["charMc_1"],
                "enemy_1":_local_1["enemyMc_1"],
                "player_2":_local_1["charMc_2"],
                "enemy_2":_local_1["enemyMc_2"],
                "player_pet_0":_local_1["charPetMc_0"],
                "enemy_pet_0":_local_1["enemyPetMc_0"],
                "player_pet_1":_local_1["charPetMc_1"],
                "enemy_pet_1":_local_1["enemyPetMc_1"],
                "player_pet_2":_local_1["charPetMc_2"],
                "enemy_pet_2":_local_1["enemyPetMc_2"]
            };
            this.setupHeadsAndAgility();
            this.action_bar.visible = true;
            this.startRun(500);
        }

        public function setupHeadsAndAgility():*
        {
            var _local_1:* = undefined;
            var _local_2:MovieClip;
            var _local_3:String;
            var _local_4:* = undefined;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int = -30;
            for (_local_3 in this.players_mc_holders)
            {
                if (("character_model" in this.players_mc_holders[_local_3].charMc))
                {
                    _local_1 = this.players_mc_holders[_local_3].charMc.character_model;
                    _local_2 = _local_1.getHead();
                    _local_7 = -30;
                    if (_local_3.indexOf("player") == -1)
                    {
                        _local_7 = 7;
                    };
                    if (_local_1.isCharacter())
                    {
                    };
                    if (((!(_local_1.isCharacter())) && (_local_3.indexOf("player") == -1)))
                    {
                    };
                    _local_2.x = 0;
                    _local_2.y = _local_7;
                    _local_2.scaleX = ((!(_local_1.isCharacter())) ? -0.5 : 0.5);
                    _local_2.scaleY = ((!(_local_1.isCharacter())) ? 0.5 : 0.5);
                    _local_5 = int(_local_1.getAgility());
                    if (_local_5 > _local_6)
                    {
                        _local_6 = _local_5;
                    };
                    this.team_headMc_agility.push([_local_3, _local_2, _local_5, _local_1, _local_2.x]);
                };
            };
            this.to_repeat_number = Math.floor((_local_6 / this.action_bar_divider));
            _local_4 = 0;
            while (_local_4 < this.team_headMc_agility.length)
            {
                _local_2 = this.team_headMc_agility[_local_4][1];
                this.action_bar.holder.addChild(_local_2);
                _local_4++;
            };
        }

        public function startRun(_arg_1:int=0):*
        {
            var _local_2:* = undefined;
            if (_arg_1 > 0)
            {
                setTimeout(this.startRun, _arg_1, 0);
                return;
            };
            if (this.enable_actions)
            {
                this.enable_actions = false;
                BattleManager.getBattle().character_team_players[0].actions_manager.greyOutActions(false);
            };
            if (this.turns == 0)
            {
                if (!this.checkAllActionsManagerLoaded())
                {
                    setTimeout(this.startRun, 200);
                    return;
                };
                (_local_2 = new Animation(BattleManager.getBattle(), false)).gotoAndPlay(1);
                BattleManager.getMain().loader.addChild(_local_2);
                BattleManager.getMain().loading(false);
            };
            BattleManager.getBattle()["btn_UI_Gear"].visible = false;
            BattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"].visible = false;
            if (!BattleVars.MATCH_RUNNING)
            {
                return;
            };
            BattleManager.getBattle().hideDragonHuntHint();
            BattleManager.getBattle().checkPlayDeadAnimation();
            var _local_3:Boolean = this.checkActivateUnyielding();
            var _local_4:Boolean = ((_local_3) ? false : this.checkReviveEOM());
            var _local_5:String = (((!(_local_3)) && (!(_local_4))) ? this.checkForBattleStatus() : "");
            if (((!(_local_3)) && (!(_local_4))))
            {
                if (_local_5 == "")
                {
                    this.turns++;
                    this.is_running = true;
                    this.updateAgilityToActionBar();
                    this.checkAmbush();
                }
                else
                {
                    if (_local_5 == "LOST")
                    {
                        BattleManager.getBattle().endBattle(false);
                    }
                    else
                    {
                        if (_local_5 == "WON")
                        {
                            this.playWinAnimationToSelfAndTeammates();
                            BattleManager.getBattle().endBattle(true);
                        };
                    };
                };
            };
        }

        public function checkForEndGame():*
        {
            var _local_1:String = this.checkForBattleStatus();
            if (_local_1 == "LOST")
            {
                this.startRun();
            }
            else
            {
                if (_local_1 == "WON")
                {
                    this.startRun();
                };
            };
        }

        public function checkAllActionsManagerLoaded():Boolean
        {
            var _local_1:* = undefined;
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < BattleManager.getBattle().character_team_players.length)
            {
                _local_1 = BattleManager.getBattle().character_team_players[_local_2];
                if (((Boolean(_local_1.isCharacter())) && (!(_local_1.character_manager.isActionsManagerLoaded()))))
                {
                    return (false);
                };
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < BattleManager.getBattle().enemy_team_players.length)
            {
                _local_1 = BattleManager.getBattle().enemy_team_players[_local_2];
                if (((Boolean(_local_1.isCharacter())) && (!(_local_1.character_manager.isActionsManagerLoaded()))))
                {
                    return (false);
                };
                _local_2++;
            };
            return (true);
        }

        public function playWinAnimationToSelfAndTeammates():*
        {
            var _local_1:int;
            while (_local_1 < BattleManager.getBattle().character_team_players.length)
            {
                if (!BattleManager.getBattle().character_team_players[_local_1].health_manager.isDead())
                {
                    BattleManager.getBattle().character_team_players[_local_1].playWin();
                };
                _local_1++;
            };
        }

        public function checkForBattleStatus():String
        {
            var _local_6:int;
            var _local_1:Battle = BattleManager.getBattle();
            var _local_2:Boolean = (((Character.is_jounin_stage_4) || (Character.is_jounin_stage_5_1)) || (Character.is_jounin_stage_5_2));
            var _local_3:int;
            while (_local_3 < _local_1.character_team_players.length)
            {
                if (((_local_1.character_team_players[_local_3].health_manager.isDead()) && ((_local_2) || (_local_3 == 0))))
                {
                    return ("LOST");
                };
                _local_3++;
            };
            var _local_4:int;
            var _local_5:Array = [];
            _local_3 = 0;
            while (_local_3 < _local_1.enemy_team_players.length)
            {
                if (_local_1.enemy_team_players[_local_3].health_manager.isDead())
                {
                    if (BattleVars.PLAYER_TARGET == _local_3)
                    {
                        _local_1.resetTargetArrows();
                        BattleVars.PLAYER_TARGET = -1;
                    };
                    _local_4++;
                }
                else
                {
                    _local_5.push(_local_3);
                    if (BattleVars.PLAYER_TARGET == -1)
                    {
                        BattleVars.MASTER_PLAYER_TARGET = _local_3;
                        BattleVars.PLAYER_TARGET = _local_3;
                        _local_1.showTargetArrow();
                    };
                };
                _local_3++;
            };
            if (_local_4 == _local_1.enemy_team_players.length)
            {
                return ("WON");
            };
            if (((_local_2) && (_local_1.enemy_team_players[0].health_manager.isDead())))
            {
                return ("WON");
            };
            if (((_local_5.length > 0) && (BattleVars.PLAYER_TARGET == -1)))
            {
                _local_6 = NumberUtil.randomInt(0, (_local_5.length - 1));
                BattleVars.PLAYER_TARGET = _local_5[_local_6];
                BattleVars.MASTER_PLAYER_TARGET = BattleVars.PLAYER_TARGET;
                _local_1.showTargetArrow();
            }
            else
            {
                if (_local_5.length == 0)
                {
                    BattleVars.PLAYER_TARGET = 0;
                };
            };
            return ("");
        }

        public function checkReviveEOM():Boolean
        {
            var _local_1:Boolean;
            var _local_2:int;
            while (_local_2 < BattleManager.getBattle().character_team_players.length)
            {
                if (BattleManager.getBattle().character_team_players[_local_2].health_manager.checkReviveEOM())
                {
                    _local_1 = true;
                    break;
                };
                _local_2++;
            };
            if (!_local_1)
            {
                _local_2 = 0;
                while (_local_2 < BattleManager.getBattle().enemy_team_players.length)
                {
                    if (BattleManager.getBattle().enemy_team_players[_local_2].health_manager.checkReviveEOM())
                    {
                        _local_1 = true;
                        break;
                    };
                    _local_2++;
                };
            };
            return (_local_1);
        }

        public function checkActivateUnyielding():Boolean
        {
            var _local_3:*;
            var _local_1:Boolean;
            var _local_2:int;
            while (_local_2 < BattleManager.getBattle().character_team_players.length)
            {
                _local_3 = BattleManager.getBattle().character_team_players[_local_2];
                if (!_local_3.isCharacter)
                {
                    return (false);
                };
                if (_local_3.health_manager.checkActivateUnyielding())
                {
                    _local_1 = true;
                    break;
                };
                _local_2++;
            };
            if (!_local_1)
            {
                _local_2 = 0;
                while (_local_2 < BattleManager.getBattle().enemy_team_players.length)
                {
                    _local_3 = BattleManager.getBattle().enemy_team_players[_local_2];
                    if (!_local_3.isCharacter)
                    {
                        return (false);
                    };
                    if (_local_3.health_manager.checkActivateUnyielding())
                    {
                        _local_1 = true;
                        break;
                    };
                    _local_2++;
                };
            };
            return (_local_1);
        }

        public function checkMemekKudaActivation():Boolean
        {
            var _local_1:Boolean;
            var _local_2:int;
            while (_local_2 < BattleManager.getBattle().character_team_players.length)
            {
                if (BattleManager.getBattle().character_team_players[_local_2].health_manager.checkActivateICM())
                {
                    _local_1 = true;
                    break;
                };
                _local_2++;
            };
            if (!_local_1)
            {
                _local_2 = 0;
                while (_local_2 < BattleManager.getBattle().enemy_team_players.length)
                {
                    if (BattleManager.getBattle().enemy_team_players[_local_2].health_manager.checkActivateICM())
                    {
                        _local_1 = true;
                        break;
                    };
                    _local_2++;
                };
            };
            return (_local_1);
        }

        public function checkICMActivation():Boolean
        {
            var _local_1:Boolean;
            var _local_2:int;
            while (_local_2 < BattleManager.getBattle().character_team_players.length)
            {
                if (BattleManager.getBattle().character_team_players[_local_2].health_manager.checkActivateICM())
                {
                    _local_1 = true;
                    break;
                };
                _local_2++;
            };
            if (!_local_1)
            {
                _local_2 = 0;
                while (_local_2 < BattleManager.getBattle().enemy_team_players.length)
                {
                    if (BattleManager.getBattle().enemy_team_players[_local_2].health_manager.checkActivateICM())
                    {
                        _local_1 = true;
                        break;
                    };
                    _local_2++;
                };
            };
            return (_local_1);
        }

        public function stopRun():*
        {
            this.is_running = false;
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
            var _local_15:Array;
            var _local_16:Number;
            var _local_17:Array;
            var _local_18:Number;
            var _local_8:Number = -1;
            var _local_9:Boolean;
            var _local_10:Number = this.action_bar_width;
            var _local_11:Array = [];
            var _local_12:uint;
            var _local_13:Number = 0;
            var _local_14:uint;
            while (_local_14 < this.team_headMc_agility.length)
            {
                _local_1 = this.team_headMc_agility[_local_14][0].split("_");
                if (_local_1.length == 3)
                {
                    _local_1 = [(_local_1[0] + "_pet"), _local_1[2]];
                };
                _local_13 = this.team_headMc_agility[_local_14][4];
                _local_3 = int(this.team_headMc_agility[_local_14][2]);
                _local_4 = this.team_headMc_agility[_local_14][3];
                if (this.last_ambush_index == _local_14)
                {
                    this.last_ambush_index = -1;
                    this.team_headMc_agility[_local_14][1].x = this.plus_x_next_round[_local_14];
                    _local_13 = this.plus_x_next_round[_local_14];
                    this.plus_x_next_round[_local_14] = 0;
                };
                _local_5 = _local_13;
                _local_7 = _local_3;
                if (this.to_repeat_number > 2)
                {
                    _local_7 = Number(Number((_local_3 / this.to_repeat_number)).toFixed(1));
                    if (this.calc_type == "Integer")
                    {
                        _local_7 = Math.floor((_local_3 / this.to_repeat_number));
                    };
                };
                _local_6 = (_local_5 + _local_7);
                if (this.plus_x_next_round[_local_14] > 0)
                {
                    _local_6 = (_local_6 + this.plus_x_next_round[_local_14]);
                    this.plus_x_next_round[_local_14] = 0;
                };
                if (_local_4.isDead())
                {
                    this.team_headMc_agility[_local_14][1].x = 0;
                    _local_6 = 0;
                };
                _local_11.push([_local_1[0], _local_1[1], _local_6]);
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
                _local_15 = _local_11[_local_14];
                _local_16 = _local_15[2];
                _local_17 = this.team_headMc_agility[_local_14];
                if (_local_16 >= _local_10)
                {
                    if (((!(_local_9)) && (_local_12 == _local_14)))
                    {
                        _local_9 = true;
                        this.last_ambush_index = _local_14;
                    };
                    this.plus_x_next_round[_local_14] = (_local_16 - _local_10);
                    _local_17[4] = _local_10;
                }
                else
                {
                    _local_17[4] = _local_16;
                };
                _local_14++;
            };
            if (_local_9)
            {
                this.stopRun();
                this.ambush_team = _local_11[_local_12][0];
                this.ambush_num = _local_11[_local_12][1];
                _local_14 = 0;
                while (_local_14 < _local_11.length)
                {
                    _local_15 = _local_11[_local_14];
                    _local_17 = this.team_headMc_agility[_local_14];
                    _local_2 = _local_17[1];
                    _local_18 = _local_17[4];
                    TweenLite.to(_local_2, 0.8, {
                        "x":_local_18,
                        "ease":Linear.easeNone,
                        "onComplete":this.onAmbush,
                        "onCompleteParams":[_local_2, _local_14, _local_12]
                    });
                    _local_14++;
                };
                return;
            };
            this.checkAmbush();
        }

        public function onAmbush(_arg_1:*, _arg_2:*, _arg_3:*):*
        {
            TweenLite.killTweensOf(_arg_1);
            if (_arg_3 == _arg_2)
            {
                BattleManager.getBattle().setupViewForAmbush(this.ambush_team, this.ambush_num);
                if (((this.ambush_team == "player") && (this.ambush_num == 0)))
                {
                    this.player_turns--;
                };
            };
        }

        public function updateAgilityToActionBar():*
        {
            var _local_1:* = undefined;
            var _local_2:MovieClip;
            var _local_3:int;
            var _local_4:int;
            var _local_5:Array = [];
            this.calc_type = "Number";
            var _local_6:* = 0;
            while (_local_6 < this.team_headMc_agility.length)
            {
                _local_1 = this.team_headMc_agility[_local_6][3];
                _local_3 = int(_local_1.getAgility());
                if (_local_3 > _local_4)
                {
                    _local_4 = _local_3;
                };
                this.team_headMc_agility[_local_6][2] = _local_3;
                _local_5.push(_local_3);
                _local_6++;
            };
            this.to_repeat_number = Math.floor((_local_4 / this.action_bar_divider));
        }

        public function destroy():*
        {
            var _local_1:*;
            var _local_2:int;
            if (this.destroyed)
            {
                return;
            };
            this.destroyed = true;
            Log.debug(this, "destroy");
            this.stopRun();
            GF.removeAllChild(this.action_bar.holder);
            this.action_bar = null;
            for each (_local_1 in this.players_mc_holders)
            {
                GF.removeAllChild(this.players_mc_holders[_local_1]);
                this.players_mc_holders[_local_1] = null;
            };
            this.players_mc_holders = null;
            _local_2 = 0;
            while (_local_2 < this.team_headMc_agility.length)
            {
                TweenLite.killTweensOf(this.team_headMc_agility[_local_2][1]);
                GF.removeAllChild(this.team_headMc_agility[_local_2][1]);
                _local_2++;
            };
            GF.clearArray(this.team_headMc_agility);
            this.plus_x_next_round = null;
            this.team_headMc_agility = null;
        }


    }
}//package Combat

