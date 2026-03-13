// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.EnemyModel

package Combat
{
    import flash.display.MovieClip;
    import Storage.EnemyInfo;
    import com.utils.GF;
    import flash.utils.setTimeout;
    import flash.events.Event;
    import com.utils.NumberUtil;
    import id.ninjasage.Log;
    import Managers.NinjaSage;

    public class EnemyModel 
    {

        public var player_team:String;
        public var player_number:int;
        public var player_identification:String;
        public var movieclip_holder:String;
        public var enemy_info:*;
        public var health_manager:HealthManager;
        public var effects_manager:EffectsManager;
        public var object_mc:MovieClip;
        public var object_head:MovieClip;
        public var theft_mode:Boolean = false;
        public var unyielding_mode:Boolean = false;
        public var debuff_resist:Boolean = false;
        public var IS_BLOCK_DAMAGE:Boolean = false;
        public var IS_DODGED:Boolean = false;
        public var IS_CHAOS:Boolean = false;
        private var mode:String;
        private var stage_mode:String;

        private var stage_element_list:Array = ["wind", "fire", "thunder", "earth", "water"];
        public var attack_results:Array = [];
        public var attack_result:Object = {
            "damage":0,
            "effects":[],
            "multi_hit":false,
            "self_target":false
        };

        public function EnemyModel(_arg_1:String, _arg_2:int, _arg_3:String)
        {
            this.player_team = _arg_1;
            this.player_number = _arg_2;
            this.player_identification = _arg_3;
            this.movieclip_holder = ((this.player_team == "player") ? "charMc_" : "enemyMc_");
            this.effects_manager = new EffectsManager(this.player_team, this.player_number);
            BattleManager.getBattle()[(this.movieclip_holder + this.player_number)].charMc.scaleX = ((this.player_team == "player") ? -1 : 1);
            BattleManager.getMain().loadEnemySWF(this.player_identification, this.onEnemyLoaded);
        }

        public function onEnemyLoaded(_arg_1:Event):*
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            this.enemy_info = EnemyInfo.getCopy(this.player_identification);
            this.enemy_info.curr_skill_cooldowns = [];
            this.enemy_info.used_skill_order = [];
            this.enemy_info.order_used_count = 0;
            this.enemy_info.next_skill = -1;
            var _local_3:int;
            while (_local_3 < this.enemy_info.attacks.length)
            {
                this.enemy_info.curr_skill_cooldowns.push(0);
                this.enemy_info.used_skill_order.push(false);
                _local_3++;
            };
            this.object_mc = _arg_1.target.content[this.player_identification];
            this.object_mc.gotoAndStop(1);
            {
                this.object_mc.stopAllMovieClips();
            };
            this.object_head = _arg_1.target.content["enemy_head"];
            this.setFrameScript();
            this.object_mc.scaleX = (this.enemy_info.size_x * BattleVars.ENEMY_SCALE);
            this.object_mc.scaleY = (this.enemy_info.size_y * BattleVars.ENEMY_SCALE);
            GF.removeAllChild(BattleManager.getBattle()[(this.movieclip_holder + this.player_number)].charMc);
            BattleManager.getBattle()[(this.movieclip_holder + this.player_number)].charMc.addChild(this.object_mc);
            BattleManager.getBattle()[(this.movieclip_holder + this.player_number)].charMc.character_model = this;
            this.health_manager = new HealthManager(this.player_team, this.player_number);
            this.health_manager.fillHealth(this.enemy_info);
            var _local_4:int = (this.player_number + 1);
            if (this.player_team != "player")
            {
                setTimeout(BattleManager.loadEnemyTeam, 100, _local_4);
            }
            else
            {
                setTimeout(BattleManager.loadPlayerTeam, 100, _local_4);
            };
            try
            {
                _arg_1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
        }

        public function findSkillByOrder():int
        {
            var _local_3:int;
            var _local_4:int;
            if (!this.enemy_info.attacks[0].hasOwnProperty("order"))
            {
                return (-1);
            };
            var _local_1:int;
            var _local_2:Array = this.enemy_info.attacks;
            if (this.enemy_info.order_used_count == _local_2.length)
            {
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    this.enemy_info.used_skill_order[_local_3] = false;
                    _local_3++;
                };
                this.enemy_info.order_used_count = 0;
            };
            _local_3 = 0;
            while (_local_3 < _local_2.length)
            {
                _local_4 = 0;
                while (_local_4 < _local_2.length)
                {
                    _local_1 = int(_local_2[_local_4].order);
                    if ((((_local_1 == _local_3) && (this.enemy_info.curr_skill_cooldowns[_local_4] < 1)) && (!(this.enemy_info.used_skill_order[_local_4]))))
                    {
                        this.enemy_info.used_skill_order[_local_4] = true;
                        this.enemy_info.order_used_count++;
                        return (_local_4);
                    };
                    _local_4++;
                };
                _local_3++;
            };
            return (-1);
        }

        public function viceRapidCooldown(cooldown:int, effectName:String):*
        {
            var text:String;
            var s:* = undefined;
            var total:int = cooldown;
            text = effectName;
            try
            {
                s = 1;
                while (s < this.enemy_info.curr_skill_cooldowns.length)
                {
                    this.enemy_info.curr_skill_cooldowns[s] = (int(this.enemy_info.curr_skill_cooldowns[s]) + total);
                    s++;
                };
                Effects.showEffectInfo(this.getPlayerTeam(), this.getPlayerNumber(), text, false);
            }
            catch(e)
            {
                Effects.showEffectInfo(this.getPlayerTeam(), this.getPlayerNumber(), text, false);
            };
        }

        public function randomOblivion(cooldown:int, effectName:String="", counter:int=0):*
        {
            var text:String;
            var rand_skill_id:* = undefined;
            var amount:int = cooldown;
            text = effectName;
            var retries:int = counter;
            try
            {
                rand_skill_id = NumberUtil.randomInt(0, (this.enemy_info.curr_skill_cooldowns.length - 1));
                if (this.enemy_info.curr_skill_cooldowns[rand_skill_id] == 0)
                {
                    this.enemy_info.curr_skill_cooldowns[rand_skill_id] = amount;
                    Effects.showEffectInfo(this.getPlayerTeam(), this.getPlayerNumber(), text, false);
                }
                else
                {
                    if (retries < this.enemy_info.curr_skill_cooldowns.length)
                    {
                        retries = (retries + 1);
                        this.randomOblivion(amount, text, retries);
                    }
                    else
                    {
                        this.enemy_info.curr_skill_cooldowns[rand_skill_id] = amount;
                        Effects.showEffectInfo(this.getPlayerTeam(), this.getPlayerNumber(), text, false);
                    };
                };
            }
            catch(e)
            {
                Effects.showEffectInfo(this.getPlayerTeam(), this.getPlayerNumber(), text, false);
            };
        }

        public function setModes(_arg_1:String, _arg_2:String):Boolean
        {
            this.stage_mode = _arg_1;
            this.mode = _arg_2;
            var _local_3:int;
            while (_local_3 < this.enemy_info.curr_skill_cooldowns.length)
            {
                this.enemy_info.curr_skill_cooldowns[_local_3] = 0;
                _local_3++;
            };
            if (!this.isDead())
            {
                this.object_mc.gotoAndPlay(25);
                return (true);
            };
            return (false);
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

        public function getAttack(_arg_1:Boolean=true, _arg_2:int=0):*
        {
            var _local_15:int;
            var _local_16:int;
            var _local_17:int;
            var _local_3:* = 0;
            while (_local_3 < this.enemy_info.curr_skill_cooldowns.length)
            {
                if (((this.enemy_info.curr_skill_cooldowns[_local_3] > 0) && (_arg_1)))
                {
                    this.enemy_info.curr_skill_cooldowns[_local_3]--;
                };
                _local_3++;
            };
            var _local_4:int = this.findSkillByOrder();
            var _local_5:* = NumberUtil.randomInt(0, (this.enemy_info.attacks.length - 1));
            if (_local_4 != -1)
            {
                _local_5 = _local_4;
            };
            if ((((this.enemy_info.combo_skill) && (this.enemy_info.next_skill >= 0)) && (this.enemy_info.curr_skill_cooldowns[this.enemy_info.next_skill] < 1)))
            {
                _local_5 = this.enemy_info.next_skill;
                this.enemy_info.next_skill = -1;
            };
            if (this.enemy_info.attacks[_local_5].hasOwnProperty("next_skill"))
            {
                this.enemy_info.next_skill = this.enemy_info.attacks[_local_5].next_skill;
            };
            _local_5 = (((this.enemy_info.hasOwnProperty("priority")) && (!(this.enemy_info.priority == null))) ? this.getSkillByPrioritySet() : _local_5);
            if (this.player_identification == "ene_98")
            {
                _local_15 = this.stage_element_list.indexOf(this.mode);
                _local_16 = ((_local_15 >= 0) ? _local_15 : 0);
                _local_17 = NumberUtil.randomInt(0, ((_local_16 + 1) - 1));
                _local_5 = (_local_17 * 3);
            };
            if (this.enemy_info.curr_skill_cooldowns[_local_5] > 0)
            {
                if (++_arg_2 <= 15)
                {
                    return (this.getAttack(false, _arg_2));
                };
                _local_5 = 0;
            };
            this.enemy_info.curr_skill_cooldowns[_local_5] = this.enemy_info.attacks[_local_5].cooldown;
            if (this.player_team == "player")
            {
                BattleVars.getRandomPlayerTarget();
                BattleManager.getBattle().setDefender("enemy", BattleVars.PLAYER_TARGET);
            }
            else
            {
                BattleVars.getRandomEnemyTarget();
                BattleManager.getBattle().setDefender("player", BattleVars.ENEMY_TARGET);
            };
            var _local_6:* = BattleManager.getBattle().getDefender();
            var _local_7:* = Math.round((20 + ((this.getLevel() / 2) * (1 + (0.06 * this.getLevel())))));
            var _local_8:Object = this.enemy_info.attacks[_local_5];
            var _local_9:* = Math.floor((_local_8.dmg * _local_7));
            if ((("is_static" in _local_8) && (Boolean(_local_8.is_static))))
            {
                _local_9 = Math.floor(_local_8.dmg);
            };
            var _local_10:* = (("multi_hit" in _local_8) ? _local_8.multi_hit : false);
            var _local_11:Boolean = (("is_self_skill" in _local_8) ? Boolean(_local_8.is_self_skill) : false);
            var _local_12:Boolean = this.targetIsSleeping();
            if (((_local_12) && (!(_local_11))))
            {
                _arg_2++;
                this.enemy_info.curr_skill_cooldowns[_local_5] = 0;
                if (_arg_2 > 15)
                {
                    BattleManager.startRun();
                    return ([0, [], false, false]);
                };
                return (this.getAttack(false, _arg_2));
            };
            var _local_13:* = _local_8.effects;
            _local_13 = BattleManager.getBattle().checkForDisperse(_local_13);
            var _local_14:int = ((this.player_team == "player") ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET);
            this.gotoAttackPos(_local_8, _local_14, _local_10);
            this.attack_results = [_local_9, _local_13, _local_10, _local_11];
            this.attack_result = {
                "damage":_local_9,
                "effects":_local_13,
                "multi_hit":_local_10,
                "self_target":_local_11
            };
            this.object_mc.gotoAndPlay(_local_8.animation);
            return (_local_8);
        }

        private function getSkillByPrioritySet(_arg_1:int=1):*
        {
            var _local_5:*;
            var _local_6:int;
            var _local_7:int;
            var _local_2:Array = this.enemy_info.priority[_arg_1];
            var _local_3:Array = _local_2.concat();
            while (_local_3.length > 0)
            {
                _local_6 = NumberUtil.randomInt(0, (_local_3.length - 1));
                _local_7 = (_local_3[_local_6] - 1);
                if (this.enemy_info.curr_skill_cooldowns[_local_7] > 0)
                {
                    _local_3.splice(_local_6, 1);
                }
                else
                {
                    return (_local_7);
                };
            };
            var _local_4:int;
            for (_local_5 in this.enemy_info.priority)
            {
                _local_4++;
            };
            if (_arg_1 >= _local_4)
            {
                return (0);
            };
            return (this.getSkillByPrioritySet((_arg_1 + 1)));
        }

        public function getLevel():int
        {
            return (this.enemy_info.enemy_level);
        }

        public function handleChaos():*
        {
            BattleManager.startRun();
        }

        public function getAccuracy():int
        {
            var _local_1:int = int(this.enemy_info.enemy_accuracy);
            var _local_2:Array = this.effects_manager.getActiveBuff("accuracy");
            var _local_3:Array = this.effects_manager.getActiveDebuff("accuracy");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "accuracy");
            return (BattleManager.modifyChance(_local_3, "RM", _local_1, "accuracy"));
        }

        public function getDodgeRate():int
        {
            var _local_4:Number;
            var _local_1:int = int(this.enemy_info.enemy_dodge);
            var _local_2:Array = this.effects_manager.getActiveBuff("dodge");
            var _local_3:Array = this.effects_manager.getActiveDebuff("dodge");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "dodge");
            _local_1 = BattleManager.modifyChance(_local_3, "RM", _local_1, "dodge");
            if (this.player_identification == "ene_98")
            {
                if (((this.mode == "wind") && (this.stage_mode == "wind")))
                {
                    _local_1 = (_local_1 + 40);
                };
            };
            if ((((_local_4 = BattleManager.getBattle().attacker_model.effects_manager.getIgnoreDodgeBySenjutsu()) > 0) && (BattleVars.SKILL_USED_ID == "skill_3104")))
            {
                _local_1 = (_local_1 - _local_4);
            };
            return (_local_1);
        }

        public function getCombustionChance():int
        {
            var _local_1:Number = Number(this.enemy_info.enemy_combustion);
            var _local_2:Array = this.effects_manager.getActiveBuff("combustion");
            var _local_3:Array = this.effects_manager.getActiveDebuff("combustion");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1);
            _local_1 = BattleManager.modifyChance(_local_3, "RM", _local_1);
            if (this.player_identification == "ene_98")
            {
                if (((this.mode == "fire") && (this.stage_mode == "fire")))
                {
                    _local_1 = (_local_1 + 50);
                };
            };
            return (_local_1);
        }

        public function getCriticalChance():int
        {
            var _local_1:Number = Number(this.enemy_info.enemy_critical);
            var _local_2:Array = this.effects_manager.getActiveBuff("critical");
            var _local_3:Array = this.effects_manager.getActiveDebuff("critical");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "critical");
            _local_1 = BattleManager.modifyChance(_local_3, "RM", _local_1, "critical");
            if (this.player_identification == "ene_98")
            {
                if (((this.mode == "thunder") && (this.stage_mode == "thunder")))
                {
                    _local_1 = (_local_1 + 40);
                };
            };
            return (_local_1);
        }

        public function getPurify():int
        {
            var _local_1:Number = Number(this.enemy_info.enemy_purify);
            var _local_2:Array = this.effects_manager.getActiveBuff("purify");
            var _local_3:Array = this.effects_manager.getActiveDebuff("purify");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "purify");
            return (BattleManager.modifyChance(_local_3, "RM", _local_1, "purify"));
        }

        public function getReactiveForce():int
        {
            var _local_1:Number = Number(this.enemy_info.enemy_reactive);
            var _local_2:Array = this.effects_manager.getActiveBuff("reactive");
            var _local_3:Array = this.effects_manager.getActiveDebuff("reactive");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "reactive_force");
            return (BattleManager.modifyChance(_local_3, "RM", _local_1, "reactive_force"));
        }

        public function getHead():MovieClip
        {
            return (this.object_head);
        }

        public function getAttackResults():Array
        {
            return (this.attack_results);
        }

        public function getAttackResult():Object
        {
            return (this.attack_result);
        }

        public function reloadInfo():*
        {
        }

        public function playDodge():*
        {
            this.object_mc.gotoAndPlay("dodge");
        }

        public function playHit():*
        {
            this.object_mc.gotoAndPlay("hit");
        }

        public function playWin():*
        {
        }

        public function playRun():*
        {
        }

        public function playDead():*
        {
            this.object_mc.gotoAndPlay("dead");
        }

        public function getPlayerTeam():String
        {
            return (this.player_team);
        }

        public function getPlayerNumber():int
        {
            return (this.player_number);
        }

        public function getAgility():Number
        {
            var _local_1:int = int(this.enemy_info.enemy_agility);
            var _local_2:Array = this.effects_manager.getActiveBuff("agility");
            var _local_3:Array = this.effects_manager.getActiveDebuff("agility");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1);
            _local_1 = BattleManager.modifyChance(_local_3, "RM", _local_1);
            return (int(Math.max(_local_1, Math.round(((this.enemy_info.enemy_agility * 25) / 100)))));
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
            return (true);
        }

        public function isNpc():Boolean
        {
            return (false);
        }

        public function reduceHealth(_arg_1:int):*
        {
            this.health_manager.reduceHealth(_arg_1);
        }

        public function playAnimation(_arg_1:String):*
        {
            this.object_mc.gotoAndPlay(_arg_1);
        }

        public function standByFrameEnd():*
        {
            this.object_mc.x = 0;
            this.object_mc.y = 0;
            this.object_mc.gotoAndPlay("standby");
        }

        public function attackHit():*
        {
            BattleManager.getBattle().hitPlayer();
        }

        public function attackFinish():*
        {
            this.standByFrameEnd();
            BattleManager.getBattle().enemyAttacked();
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
            this.object_mc.stop();
            BattleManager.getBattle().enemyDead();
        }

        public function addFullScreen():*
        {
            try
            {
                this.object_mc.fullScreenEffect.x = 0;
                this.object_mc.fullScreenEffect.y = 0;
                this.object_mc.fullScreenEffect.scaleX = 1;
                this.object_mc.fullScreenEffect.scaleY = 1;
                BattleManager.getMain().loader.addChild(this.object_mc.fullScreenEffect);
            }
            catch(e)
            {
            };
        }

        public function removeFullScreen():*
        {
            try
            {
                BattleManager.getMain().loader.removeChild(this.object_mc.fullScreenEffect);
            }
            catch(e)
            {
            };
        }

        public function setFrameScript():void
        {
            var j:int;
            var finishFrame:int;
            var i:int;
            while (i < this.enemy_info.attacks.length)
            {
                j = 0;
                while (j < this.enemy_info.attacks[i].anims.hit.length)
                {
                    this.object_mc.addFrameScript(this.enemy_info.attacks[i].anims.hit[j], this.attackHit);
                    j = (j + 1);
                };
                if (this.enemy_info.attacks[i].anims.hasOwnProperty("fullscreen"))
                {
                    this.object_mc.addFrameScript(this.enemy_info.attacks[i].anims.fullscreen.add, this.addFullScreen);
                    this.object_mc.addFrameScript(this.enemy_info.attacks[i].anims.fullscreen.remove, this.removeFullScreen);
                };
                finishFrame = (NinjaSage.getLabelFrames(this.object_mc, this.enemy_info.attacks[i].animation).end - 1);
                this.object_mc.addFrameScript(finishFrame, this.attackFinish);
                i = (i + 1);
            };
            this.object_mc.addFrameScript((NinjaSage.getLabelFrames(this.object_mc, "standby").end - 1), this.standByFrameEnd);
            this.object_mc.addFrameScript((NinjaSage.getLabelFrames(this.object_mc, "dodge").end - 1), this.dodgeFrame);
            this.object_mc.addFrameScript((NinjaSage.getLabelFrames(this.object_mc, "hit").end - 1), this.attackedFrame);
            this.object_mc.addFrameScript((NinjaSage.getLabelFrames(this.object_mc, "dead").end - 1), this.deadFrame);
            if (this.player_identification == "ene_98")
            {
                var stopAnimation:Function = function ():*
                {
                    object_mc.elementeffect.stop();
                };
                var updateElementAnim:Function = function ():*
                {
                    object_mc.elementeffect.gotoAndStop(mode);
                };
                this.object_mc.addFrameScript(0, updateElementAnim);
            };
            this.object_mc.gotoAndPlay("standby");
        }

        public function clearFrameScript():void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_1:int;
            while (_local_1 < this.enemy_info.attacks.length)
            {
                _local_2 = 0;
                while (_local_2 < this.enemy_info.attacks[_local_1].anims.hit.length)
                {
                    this.object_mc.addFrameScript(this.enemy_info.attacks[_local_1].anims.hit[_local_2], null);
                    _local_2++;
                };
                if (this.enemy_info.attacks[_local_1].anims.hasOwnProperty("fullscreen"))
                {
                    this.object_mc.addFrameScript(this.enemy_info.attacks[_local_1].anims.fullscreen.add, null);
                    this.object_mc.addFrameScript(this.enemy_info.attacks[_local_1].anims.fullscreen.remove, null);
                };
                _local_3 = (NinjaSage.getLabelFrames(this.object_mc, this.enemy_info.attacks[_local_1].animation).end - 1);
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
            Log.debug(this, "destroy", this.enemy_info.enemy_id);
            var _local_1:* = BattleManager.getBattle();
            var _local_2:* = (this.movieclip_holder + this.player_number);
            if (_local_1 != null)
            {
                if (((_local_1) && (_local_2 in _local_1)))
                {
                    if (("character_model" in _local_1[_local_2].charMc))
                    {
                        _local_1[_local_2].charMc.character_model = null;
                    };
                    if (((!(this.object_mc == null)) && (_local_1[_local_2].charMc.contains(this.object_mc))))
                    {
                        _local_1[_local_2].charMc.removeChild(this.object_mc);
                    };
                };
                GF.removeAllChild(_local_1[_local_2].charMc);
                if (("skillMc" in _local_1[_local_2]))
                {
                    GF.removeAllChild(_local_1[_local_2].skillMc);
                };
                _local_1[_local_2] = null;
            };
            this.clearFrameScript();
            GF.removeAllChild(this.object_head);
            GF.removeAllChild(this.object_mc);
            this.object_head = null;
            this.object_mc = null;
            GF.clearArray(this.attack_results);
            this.enemy_info = null;
            this.health_manager.destroy();
            this.health_manager = null;
            this.stage_element_list = null;
            this.attack_results = null;
            this.attack_result = null;
            this.player_team = null;
            this.player_number = null;
            this.player_identification = null;
            this.movieclip_holder = null;
            this.effects_manager.destroy();
            this.effects_manager = null;
            _local_1 = null;
            _local_2 = null;
        }


    }
}//package Combat

