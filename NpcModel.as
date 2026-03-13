// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.NpcModel

package Combat
{
    import flash.display.MovieClip;
    import Storage.NpcInfo;
    import com.utils.GF;
    import flash.utils.setTimeout;
    import flash.events.Event;
    import com.utils.NumberUtil;
    import id.ninjasage.Log;
    import Managers.NinjaSage;

    public class NpcModel 
    {

        public var player_team:String;
        public var player_number:int;
        public var player_identification:String;
        public var npc_info:*;
        public var object_mc:MovieClip;
        public var object_head:MovieClip;
        public var npc_movieclip_holder:String;
        public var theft_mode:Boolean = false;
        public var unyielding_mode:Boolean = false;
        public var debuff_resist:Boolean = false;
        public var attack_results:Array = [];
        public var attack_result:Object = {
            "damage":0,
            "effects":[],
            "multi_hit":false,
            "self_target":false
        };
        public var IS_BLOCK_DAMAGE:Boolean = false;
        public var IS_DODGED:Boolean = false;
        public var IS_CHAOS:Boolean = false;
        public var health_manager:HealthManager;
        public var effects_manager:EffectsManager;

        public function NpcModel(_arg_1:String, _arg_2:int, _arg_3:String)
        {
            this.player_team = _arg_1;
            this.player_number = _arg_2;
            this.player_identification = _arg_3;
            this.npc_movieclip_holder = ((this.player_team == "player") ? "charMc_" : "enemyMc_");
            BattleManager.getBattle()[(this.npc_movieclip_holder + this.player_number)].charMc.scaleX = ((this.player_team == "player") ? -1 : 1);
            this.health_manager = new HealthManager(this.player_team, this.player_number);
            this.effects_manager = new EffectsManager(this.player_team, this.player_number);
            BattleManager.getMain().loadNpcSWF(this.player_identification, this.onNpcLoaded);
        }

        public function onNpcLoaded(_arg_1:Event):*
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            this.npc_info = NpcInfo.getCopy(this.player_identification);
            this.npc_info.curr_skill_cooldowns = [0, 0, 0, 0, 0, 0, 0];
            this.object_mc = _arg_1.target.content[this.player_identification];
            this.object_mc.gotoAndStop(1);
            {
                this.object_mc.stopAllMovieClips();
            };
            this.object_head = _arg_1.target.content["npc_head"];
            this.setFrameScript();
            this.object_mc.scaleX = (this.npc_info.size_x * BattleVars.NPC_SCALE);
            this.object_mc.scaleY = (this.npc_info.size_y * BattleVars.NPC_SCALE);
            this.health_manager.fillHealth(this.npc_info);
            GF.removeAllChild(BattleManager.getBattle()[(this.npc_movieclip_holder + this.player_number)].charMc);
            BattleManager.getBattle()[(this.npc_movieclip_holder + this.player_number)].charMc.addChild(this.object_mc);
            BattleManager.getBattle()[(this.npc_movieclip_holder + this.player_number)].charMc.character_model = this;
            var _local_3:int = (this.player_number + 1);
            setTimeout(BattleManager.loadPlayerTeam, 100, _local_3);
            try
            {
                _arg_1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
        }

        public function getAgility():Number
        {
            return (Number(this.npc_info.npc_agility));
        }

        public function getHead():MovieClip
        {
            return (this.object_head);
        }

        public function findSkillByOrder():*
        {
            var _local_1:int;
            var _local_2:int = -1;
            var _local_3:Array = this.npc_info.attacks;
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = int(_local_3[_local_4].order);
                if (this.npc_info.curr_skill_cooldowns[_local_1] < 1)
                {
                    _local_2 = _local_1;
                    break;
                };
                _local_4++;
            };
            return (_local_2);
        }

        public function viceRapidCooldown(_arg_1:int, _arg_2:String):*
        {
            var _local_3:* = 1;
            while (_local_3 < this.npc_info.curr_skill_cooldowns.length)
            {
                this.npc_info.curr_skill_cooldowns[_local_3] = (int(this.npc_info.curr_skill_cooldowns[_local_3]) + _arg_1);
                _local_3++;
            };
            Effects.showEffectInfo(this.getPlayerTeam(), this.getPlayerNumber(), _arg_2, false);
        }

        public function randomOblivion(_arg_1:int, _arg_2:String="", _arg_3:int=0):*
        {
            var _local_4:* = NumberUtil.randomInt(0, (this.npc_info.curr_skill_cooldowns.length - 1));
            if (this.npc_info.curr_skill_cooldowns[_local_4] == 0)
            {
                this.npc_info.curr_skill_cooldowns[_local_4] = _arg_1;
                Effects.showEffectInfo(this.getPlayerTeam(), this.getPlayerNumber(), _arg_2, false);
            }
            else
            {
                if (_arg_3 < this.npc_info.curr_skill_cooldowns.length)
                {
                    this.randomOblivion(_arg_1, _arg_2, ++_arg_3);
                }
                else
                {
                    this.npc_info.curr_skill_cooldowns[_local_4] = _arg_1;
                    Effects.showEffectInfo(this.getPlayerTeam(), this.getPlayerNumber(), _arg_2, false);
                };
            };
        }

        public function targetIsSleeping():*
        {
            var target:int;
            var target_model:* = undefined;
            try
            {
                target = ((this.player_team == "player") ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET);
                target_model = ((this.player_team == "player") ? BattleManager.getBattle().enemy_team_players[target] : BattleManager.getBattle().character_team_players[target]);
                if (((Boolean(target_model.effects_manager.hadEffect("sleep"))) || (Boolean(target_model.effects_manager.hadEffect("pet_sleep")))))
                {
                    return (true);
                };
            }
            catch(e)
            {
                Log.error(this, "targetIsSleeping", e);
            };
            return (false);
        }

        public function getAttack(_arg_1:Boolean=true):*
        {
            var _local_2:* = 0;
            while (_local_2 < this.npc_info.curr_skill_cooldowns.length)
            {
                if (((this.npc_info.curr_skill_cooldowns[_local_2] > 0) && (_arg_1)))
                {
                    this.npc_info.curr_skill_cooldowns[_local_2]--;
                };
                _local_2++;
            };
            var _local_3:int = -1;
            var _local_4:* = NumberUtil.randomInt(0, (this.npc_info.attacks.length - 1));
            if (_local_3 != -1)
            {
                _local_4 = _local_3;
            };
            if (this.npc_info.curr_skill_cooldowns[_local_4] > 0)
            {
                return (this.getAttack(false));
            };
            if (this.player_team == "player")
            {
                BattleVars.getRandomPlayerTarget();
            };
            this.npc_info.curr_skill_cooldowns[_local_4] = this.npc_info.attacks[_local_4].cooldown;
            BattleManager.getBattle().setDefender("enemy", BattleVars.PLAYER_TARGET);
            var _local_5:* = BattleManager.getBattle().getDefender();
            var _local_6:* = Math.round((20 + ((_local_5.getLevel() / 2) * (1 + (0.06 * _local_5.getLevel())))));
            var _local_7:Object = this.npc_info.attacks[_local_4];
            var _local_8:* = Math.floor((_local_7.dmg * _local_6));
            if ((("is_static" in _local_7) && (Boolean(_local_7.is_static))))
            {
                _local_8 = Math.floor(_local_7.dmg);
            };
            var _local_9:* = _local_7.multi_hit;
            var _local_10:* = _local_7.effects;
            _local_10 = BattleManager.getBattle().checkForDisperse(_local_10);
            var _local_11:Boolean = ((_local_7.dmg == 0) ? true : false);
            var _local_12:Boolean = this.targetIsSleeping();
            if (((_local_12) && (!(_local_11))))
            {
                BattleManager.startRun();
                return ([0, [], false, false]);
            };
            this.gotoAttackPos(_local_7, BattleVars.PLAYER_TARGET, _local_9);
            this.attack_results = [_local_8, _local_10, _local_9, _local_11];
            this.attack_result = {
                "damage":_local_8,
                "effects":_local_10,
                "multi_hit":_local_9,
                "self_target":_local_11
            };
            this.object_mc.gotoAndPlay(_local_7.animation);
            return (_local_7);
        }

        public function handleChaos():*
        {
            BattleManager.startRun();
        }

        public function getAccuracy():int
        {
            var _local_1:int = int(this.npc_info.npc_accuracy);
            var _local_2:Array = this.effects_manager.getActiveBuff("accuracy");
            var _local_3:Array = this.effects_manager.getActiveDebuff("accuracy");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "accuracy");
            return (BattleManager.modifyChance(_local_3, "RM", _local_1, "accuracy"));
        }

        public function getDodgeRate():int
        {
            var _local_4:Number;
            var _local_1:int = int(this.npc_info.npc_dodge);
            var _local_2:Array = this.effects_manager.getActiveBuff("dodge");
            var _local_3:Array = this.effects_manager.getActiveDebuff("dodge");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "dodge");
            _local_1 = BattleManager.modifyChance(_local_3, "RM", _local_1, "dodge");
            if ((((_local_4 = BattleManager.getBattle().attacker_model.effects_manager.getIgnoreDodgeBySenjutsu()) > 0) && (BattleVars.SKILL_USED_ID == "skill_3104")))
            {
                _local_1 = (_local_1 - _local_4);
            };
            return (_local_1);
        }

        public function getCombustionChance():int
        {
            var _local_1:Number = Number(this.npc_info.npc_combustion);
            var _local_2:Array = this.effects_manager.getActiveBuff("combustion");
            var _local_3:Array = this.effects_manager.getActiveDebuff("combustion");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1);
            return (BattleManager.modifyChance(_local_3, "RM", _local_1));
        }

        public function getCriticalChance():int
        {
            var _local_1:Number = Number(this.npc_info.npc_critical);
            var _local_2:Array = this.effects_manager.getActiveBuff("critical");
            var _local_3:Array = this.effects_manager.getActiveDebuff("critical");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "critical");
            return (BattleManager.modifyChance(_local_3, "RM", _local_1, "critical"));
        }

        public function getPurify():int
        {
            var _local_1:Number = Number(this.npc_info.npc_purify);
            var _local_2:Array = this.effects_manager.getActiveBuff("purify");
            var _local_3:Array = this.effects_manager.getActiveDebuff("purify");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "purify");
            return (BattleManager.modifyChance(_local_3, "RM", _local_1, "purify"));
        }

        public function getReactiveForce():int
        {
            return (0);
        }

        public function getAttackResults():Array
        {
            return (this.attack_results);
        }

        public function getAttackResult():Object
        {
            return (this.attack_result);
        }

        public function getLevel():int
        {
            return (this.npc_info.npc_level);
        }

        public function isCharacter():Boolean
        {
            return (false);
        }

        public function isDead():Boolean
        {
            return (this.health_manager.isDead());
        }

        public function isPet():Boolean
        {
            return (false);
        }

        public function isEnemy():Boolean
        {
            return (false);
        }

        public function isNpc():Boolean
        {
            return (true);
        }

        public function checkBlockDamage():Boolean
        {
            return (false);
        }

        public function checkConvertDamage():Boolean
        {
            return (false);
        }

        public function checkConvertDamageCP():Boolean
        {
            return (false);
        }

        public function reduceHealth(_arg_1:int):*
        {
            this.health_manager.reduceHealth(_arg_1);
        }

        public function playWin():*
        {
        }

        public function playRun():*
        {
        }

        public function playAnimation(_arg_1:String):*
        {
            this.object_mc.gotoAndPlay(_arg_1);
        }

        public function getPlayerTeam():String
        {
            return (this.player_team);
        }

        public function getPlayerNumber():int
        {
            return (this.player_number);
        }

        public function standByFrameEnd():*
        {
            this.object_mc.x = 0;
            this.object_mc.y = 0;
            this.object_mc.gotoAndPlay("standby");
        }

        public function attackHit():*
        {
            BattleManager.getBattle().hitEnemyNpc();
        }

        public function attackFinish():*
        {
            this.standByFrameEnd();
            BattleManager.getBattle().npcAttacked();
        }

        public function dodgeFrame():*
        {
            this.standByFrameEnd();
        }

        public function attackedFrame():*
        {
            this.standByFrameEnd();
        }

        public function deadFrame():*
        {
            this.object_mc.gotoAndStop((this.object_mc.totalFrames - 1));
            BattleManager.getBattle().enemyDead();
        }

        public function setFrameScript():void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_1:int;
            while (_local_1 < this.npc_info.attacks.length)
            {
                _local_2 = 0;
                while (_local_2 < this.npc_info.attacks[_local_1].anims.hit.length)
                {
                    this.object_mc.addFrameScript(this.npc_info.attacks[_local_1].anims.hit[_local_2], this.attackHit);
                    _local_2++;
                };
                _local_3 = (NinjaSage.getLabelFrames(this.object_mc, this.npc_info.attacks[_local_1].animation).end - 1);
                this.object_mc.addFrameScript(_local_3, this.attackFinish);
                _local_1++;
            };
            this.object_mc.addFrameScript((NinjaSage.getLabelFrames(this.object_mc, "standby").end - 1), this.standByFrameEnd);
            this.object_mc.addFrameScript((NinjaSage.getLabelFrames(this.object_mc, "dodge").end - 1), this.dodgeFrame);
            this.object_mc.addFrameScript((NinjaSage.getLabelFrames(this.object_mc, "hit").end - 1), this.attackedFrame);
            this.object_mc.addFrameScript((NinjaSage.getLabelFrames(this.object_mc, "dead").end - 1), this.deadFrame);
            this.object_mc.gotoAndPlay("standby");
        }

        public function clearFrameScript():void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_1:int;
            while (_local_1 < this.npc_info.attacks.length)
            {
                _local_2 = 0;
                while (_local_2 < this.npc_info.attacks[_local_1].anims.hit.length)
                {
                    this.object_mc.addFrameScript(this.npc_info.attacks[_local_1].anims.hit[_local_2], null);
                    _local_2++;
                };
                _local_3 = (NinjaSage.getLabelFrames(this.object_mc, this.npc_info.attacks[_local_1].animation).end - 1);
                this.object_mc.addFrameScript(_local_3, null);
                _local_1++;
            };
            this.object_mc.addFrameScript((NinjaSage.getLabelFrames(this.object_mc, "standby").end - 1), null);
            this.object_mc.addFrameScript((NinjaSage.getLabelFrames(this.object_mc, "dodge").end - 1), null);
            this.object_mc.addFrameScript((NinjaSage.getLabelFrames(this.object_mc, "hit").end - 1), null);
            this.object_mc.addFrameScript((NinjaSage.getLabelFrames(this.object_mc, "dead").end - 1), null);
            {
                this.object_mc.stopAllMovieClips();
            };
        }

        public function gotoAttackPos(_arg_1:Object, _arg_2:int, _arg_3:Boolean):*
        {
            if (_arg_1.posType == BattleVars.Position_START)
            {
                this.object_mc.x = 0;
                this.object_mc.y = 0;
                return;
            };
            switch (_arg_1.posType)
            {
                case BattleVars.Position_MELEE_1:
                    this.object_mc.x = -470;
                    break;
                case BattleVars.Position_MELEE_2:
                    this.object_mc.x = -420;
                    break;
                case BattleVars.Position_MELEE_3:
                    this.object_mc.x = -370;
                    break;
                case BattleVars.Position_RANGE_1:
                    this.object_mc.x = -220;
                    break;
                case BattleVars.Position_RANGE_2:
                    this.object_mc.x = -120;
                    break;
                case BattleVars.Position_RANGE_3:
                    this.object_mc.x = 20;
            };
            if (((this.player_number > 0) && (!(_arg_3))))
            {
                this.object_mc.x = (this.object_mc.x - 130);
            };
            if (((_arg_2 > 0) && (!(_arg_3))))
            {
                this.object_mc.x = (this.object_mc.x - 130);
            };
            if (((this.player_number == 1) && (_arg_2 == 0)))
            {
                this.object_mc.y = (this.object_mc.y + 80);
            };
            if (((this.player_number == 2) && (_arg_2 == 0)))
            {
                this.object_mc.y = (this.object_mc.y - 80);
            };
            if (((this.player_number == 0) && (_arg_2 == 1)))
            {
                this.object_mc.y = (this.object_mc.y - 80);
            };
            if (((this.player_number == 0) && (_arg_2 == 2)))
            {
                this.object_mc.y = (this.object_mc.y + 80);
            };
            if (((this.player_number == 1) && (_arg_2 == 2)))
            {
                this.object_mc.y = (this.object_mc.y + 160);
            };
            if (((this.player_number == 2) && (_arg_2 == 1)))
            {
                this.object_mc.y = (this.object_mc.y - 160);
            };
            if (_arg_3)
            {
                this.object_mc.y = 0;
            };
        }

        public function destroy():*
        {
            var _local_1:* = (this.npc_movieclip_holder + this.player_number);
            Log.debug(this, "destroy", this.npc_info.npc_id, _local_1);
            var _local_2:* = BattleManager.getBattle();
            if (((!(this.object_mc == null)) && (!(_local_2 == null))))
            {
                if ((((_local_2) && (_local_1 in _local_2)) && (_local_2[_local_1].charMc.contains(this.object_mc))))
                {
                    _local_2[_local_1].charMc.removeChild(this.object_mc);
                };
                _local_2[_local_1].charMc.character_model = null;
                GF.removeAllChild(_local_2[_local_1].charMc);
                if (("skillMc" in _local_2[_local_1]))
                {
                    GF.removeAllChild(_local_2[_local_1].skillMc);
                };
                _local_2[_local_1] = null;
                this.clearFrameScript();
                GF.removeAllChild(this.object_head);
                GF.removeAllChild(this.object_mc);
                this.object_head = null;
                this.object_mc = null;
            };
            GF.clearArray(this.attack_results);
            this.npc_info = null;
            this.attack_results = null;
            this.attack_result = null;
            this.player_team = null;
            this.player_number = null;
            this.player_identification = null;
            this.npc_movieclip_holder = null;
            this.health_manager.destroy();
            this.health_manager = null;
            this.effects_manager.destroy();
            this.effects_manager = null;
            _local_2 = null;
            _local_1 = null;
        }


    }
}//package Combat

