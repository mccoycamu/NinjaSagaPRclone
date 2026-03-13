// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.PetModel

package Combat
{
    import flash.display.MovieClip;
    import Storage.PetInfo;
    import com.utils.GF;
    import flash.events.Event;
    import com.utils.NumberUtil;
    import id.ninjasage.Log;
    import Managers.NinjaSage;

    public class PetModel 
    {

        public var pet_team:String;
        public var pet_number:int;
        public var player_identification:String;
        public var pet_data:*;
        public var pet_info:*;
        public var object_mc:MovieClip;
        public var object_head:MovieClip;
        public var theft_mode:Boolean = false;
        public var unyielding_mode:Boolean = false;
        public var debuff_resist:Boolean = false;
        public var IS_BLOCK_DAMAGE:Boolean = false;
        public var IS_DODGED:Boolean = false;
        public var IS_CHAOS:Boolean = false;
        public var pet_movieclip_holder:String;
        public var health_manager:HealthManager;
        public var effects_manager:EffectsManager;
        public var attack_results:Array = [];
        public var attack_result:Object = {
            "damage":0,
            "effects":[],
            "multi_hit":false,
            "self_target":false
        };
        private var destroyed:* = false;

        public function PetModel(_arg_1:String, _arg_2:int, _arg_3:String, _arg_4:*)
        {
            this.pet_team = _arg_1;
            this.pet_number = _arg_2;
            this.player_identification = _arg_3;
            this.pet_data = _arg_4;
            this.health_manager = new HealthManager((this.pet_team + "_pet"), this.pet_number);
            this.effects_manager = new EffectsManager((this.pet_team + "_pet"), this.pet_number);
            this.pet_movieclip_holder = ((this.pet_team == "player") ? "charPetMc_" : "enemyPetMc_");
            BattleManager.getBattle()[(this.pet_movieclip_holder + this.pet_number)].charMc.scaleX = ((this.pet_team == "player") ? -1 : 1);
            BattleManager.getMain().loadPetSWF(this.player_identification, this.onPetLoaded);
        }

        public function getPetMovieClipHolder():*
        {
            return (BattleManager.getBattle()[(this.pet_movieclip_holder + this.pet_number)]);
        }

        public function onPetLoaded(_arg_1:Event):*
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            this.pet_info = PetInfo.getCopy(this.pet_data.pet_swf);
            this.pet_info.pet_level = this.pet_data.pet_level;
            this.pet_info.pet_name = this.pet_data.pet_name;
            this.pet_info.pet_hp = (60 + (int(this.pet_info.pet_level) * 40));
            this.pet_info.pet_max_hp = this.pet_info.pet_hp;
            this.pet_info.pet_cp = (60 + (int(this.pet_info.pet_level) * 40));
            this.pet_info.pet_max_cp = this.pet_info.pet_cp;
            this.pet_info.pet_agility = (9 + int(this.pet_info.pet_level));
            this.pet_info.team = this.pet_team;
            this.pet_info.num = this.pet_number;
            this.pet_info.pet_skills = "";
            this.pet_info.skills_available = this.pet_data.pet_skills.split(",");
            this.pet_info.curr_skill_cooldowns = [0, 0, 0, 0, 0, 0];
            this.object_mc = _arg_1.target.content[this.player_identification];
            this.object_mc.gotoAndStop(1);
            {
                this.object_mc.stopAllMovieClips();
            };
            this.object_head = _arg_1.target.content["pet_head"];
            this.setFrameScript();
            this.object_mc.scaleX = (this.pet_info.size_x * BattleVars.PET_SCALE);
            this.object_mc.scaleY = (this.pet_info.size_y * BattleVars.PET_SCALE);
            GF.removeAllChild(this.getPetMovieClipHolder().charMc);
            this.getPetMovieClipHolder().charMc.addChild(this.object_mc);
            this.getPetMovieClipHolder().charMc.character_model = this;
            this.getPetMovieClipHolder().visible = true;
            this.health_manager.fillHealth(this.pet_info);
            try
            {
                _arg_1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
        }

        public function viceRapidCooldown(_arg_1:int, _arg_2:String):*
        {
            var _local_3:* = 1;
            while (_local_3 < this.pet_info.curr_skill_cooldowns.length)
            {
                this.pet_info.curr_skill_cooldowns[_local_3] = (int(this.pet_info.curr_skill_cooldowns[_local_3]) + _arg_1);
                _local_3++;
            };
            Effects.showEffectInfo(this.getPlayerTeam(), this.getPlayerNumber(), _arg_2);
        }

        public function randomOblivion(_arg_1:int, _arg_2:String="", _arg_3:int=0):*
        {
            var _local_4:* = NumberUtil.randomInt(0, (this.pet_info.curr_skill_cooldowns.length - 1));
            if (this.pet_info.curr_skill_cooldowns[_local_4] == 0)
            {
                this.pet_info.curr_skill_cooldowns[_local_4] = _arg_1;
                Effects.showEffectInfo(this.getPlayerTeam(), this.getPlayerNumber(), _arg_2);
            }
            else
            {
                if (_arg_3 < this.pet_info.curr_skill_cooldowns.length)
                {
                    this.randomOblivion(_arg_1, _arg_2, ++_arg_3);
                }
                else
                {
                    this.pet_info.curr_skill_cooldowns[_local_4] = _arg_1;
                    Effects.showEffectInfo(this.getPlayerTeam(), this.getPlayerNumber(), _arg_2);
                };
            };
        }

        public function resetCooldowns(_arg_1:int=0):*
        {
            var _local_2:* = NumberUtil.randomInt(0, (this.pet_info.curr_skill_cooldowns.length - 1));
            if (this.pet_info.curr_skill_cooldowns[_local_2] > 0)
            {
                this.pet_info.curr_skill_cooldowns[_local_2] = 0;
            }
            else
            {
                if (_arg_1 < this.pet_info.curr_skill_cooldowns.length)
                {
                    this.resetCooldowns(++_arg_1);
                };
            };
        }

        public function targetIsSleeping():*
        {
            var target:int;
            var target_model:* = undefined;
            try
            {
                target = ((this.pet_team == "player") ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET);
                target_model = ((this.pet_team == "player") ? BattleManager.getBattle().enemy_team_players[target] : BattleManager.getBattle().character_team_players[target]);
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
            var _local_13:*;
            if (_arg_1)
            {
                _local_13 = 0;
                while (_local_13 < this.pet_info.curr_skill_cooldowns.length)
                {
                    if (this.pet_info.curr_skill_cooldowns[_local_13] > 0)
                    {
                        this.pet_info.curr_skill_cooldowns[_local_13]--;
                    };
                    _local_13++;
                };
            };
            var _local_3:* = NumberUtil.randomInt(0, (this.pet_info.curr_skill_cooldowns.length - 1));
            if (((int(this.pet_info.curr_skill_cooldowns[_local_3]) > 0) || (this.pet_info.skills_available[_local_3] == 0)))
            {
                return (this.getAttack(false, (_arg_2 + 1)));
            };
            this.pet_info.curr_skill_cooldowns[_local_3] = this.pet_info.attacks[_local_3].cooldown;
            if (this.pet_team == "player")
            {
                BattleVars.getRandomPlayerTarget();
            };
            if (this.pet_team == "enemy")
            {
                BattleVars.getRandomEnemyTarget();
            };
            var _local_4:Boolean = this.targetIsSleeping();
            var _local_5:* = ((this.pet_team == "player") ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET);
            var _local_6:* = ((this.pet_team == "player") ? "enemy" : "player");
            BattleManager.getBattle().setDefender(_local_6, _local_5);
            var _local_7:* = Math.round((3 * this.pet_info.pet_level));
            var _local_8:Object = this.pet_info.attacks[_local_3];
            var _local_9:* = Math.floor((_local_8.dmg * _local_7));
            if ((("is_static" in _local_8) && (Boolean(_local_8.is_static))))
            {
                _local_9 = Math.floor(_local_8.dmg);
            };
            var _local_10:* = _local_8.effects;
            var _local_11:Boolean = (("is_self_skill" in _local_8) ? Boolean(_local_8.is_self_skill) : false);
            var _local_12:Boolean = (("multi_hit" in _local_8) ? Boolean(_local_8.multi_hit) : false);
            if (((_local_4) && (!(_local_11))))
            {
                if (_arg_2 > 20)
                {
                    BattleManager.startRun();
                    return ([0, [], false, false]);
                };
                this.pet_info.curr_skill_cooldowns[_local_3] = 0;
                return (this.getAttack(false, (_arg_2 + 1)));
            };
            _local_10 = BattleManager.getBattle().checkForDisperse(_local_10);
            this.gotoAttackPos(_local_5, _local_8.posType);
            this.attack_results = [_local_9, _local_10, _local_12, _local_11];
            this.attack_result = {
                "damage":_local_9,
                "effects":_local_10,
                "multi_hit":_local_12,
                "self_target":_local_11
            };
            this.object_mc.gotoAndPlay(_local_8.animation);
            if (BattleManager.getBattle().showGUI)
            {
                BattleManager.giveMessage(_local_8.name);
            };
            return (_local_8);
        }

        public function standByFrameEnd():*
        {
            this.object_mc.x = 0;
            this.object_mc.y = 0;
            this.object_mc.gotoAndPlay("standby");
        }

        public function attackHit():*
        {
            BattleManager.getBattle().hitByPet();
        }

        public function attackFinish():*
        {
            this.standByFrameEnd();
            BattleManager.getBattle().petAttacked();
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
        }

        public function addFullScreen():*
        {
            this.object_mc.fullScreenEffect.x = 0;
            this.object_mc.fullScreenEffect.y = 0;
            this.object_mc.fullScreenEffect.scaleX = 2;
            this.object_mc.fullScreenEffect.scaleY = 2;
            BattleManager.getMain().loader.addChild(this.object_mc.fullScreenEffect);
        }

        public function removeFullScreen():*
        {
            BattleManager.getMain().loader.removeChild(this.object_mc.fullScreenEffect);
        }

        public function setFrameScript():void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_1:int;
            while (_local_1 < this.pet_info.attacks.length)
            {
                _local_2 = 0;
                while (_local_2 < this.pet_info.attacks[_local_1].anims.hit.length)
                {
                    this.object_mc.addFrameScript(this.pet_info.attacks[_local_1].anims.hit[_local_2], this.attackHit);
                    _local_2++;
                };
                if (this.pet_info.attacks[_local_1].anims.hasOwnProperty("fullscreen"))
                {
                    this.object_mc.addFrameScript(this.pet_info.attacks[_local_1].anims.fullscreen.add, this.addFullScreen);
                    this.object_mc.addFrameScript(this.pet_info.attacks[_local_1].anims.fullscreen.remove, this.removeFullScreen);
                };
                _local_3 = (NinjaSage.getLabelFrames(this.object_mc, this.pet_info.attacks[_local_1].animation).end - 1);
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
            while (_local_1 < this.pet_info.attacks.length)
            {
                _local_2 = 0;
                while (_local_2 < this.pet_info.attacks[_local_1].anims.hit.length)
                {
                    this.object_mc.addFrameScript(this.pet_info.attacks[_local_1].anims.hit[_local_2], null);
                    _local_2++;
                };
                _local_3 = (NinjaSage.getLabelFrames(this.object_mc, this.pet_info.attacks[_local_1].animation).end - 1);
                this.object_mc.addFrameScript(_local_3, null);
                if (this.pet_info.attacks[_local_1].anims.hasOwnProperty("fullscreen"))
                {
                    this.object_mc.addFrameScript(this.pet_info.attacks[_local_1].anims.fullscreen.add, null);
                    this.object_mc.addFrameScript(this.pet_info.attacks[_local_1].anims.fullscreen.remove, null);
                };
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

        public function gotoAttackPos(_arg_1:*, _arg_2:*=""):*
        {
            if (_arg_2 == "startpos")
            {
                return;
            };
            switch (_arg_2)
            {
                case BattleVars.Position_MELEE_1:
                    if (this.pet_info.team != "player_pet")
                    {
                        this.object_mc.x = -540;
                    };
                    if (this.pet_info.team == "player_pet")
                    {
                        this.object_mc.x = 540;
                        break;
                    };
                    break;
                case BattleVars.Position_MELEE_2:
                    if (this.pet_info.team != "player_pet")
                    {
                        this.object_mc.x = -440;
                    };
                    if (this.pet_info.team == "player_pet")
                    {
                        this.object_mc.x = 440;
                        break;
                    };
                    break;
                case BattleVars.Position_MELEE_3:
                    if (this.pet_info.team != "player_pet")
                    {
                        this.object_mc.x = -410;
                    };
                    if (this.pet_info.team == "player_pet")
                    {
                        this.object_mc.x = 410;
                        break;
                    };
                    break;
                case BattleVars.Position_MELEE_4:
                    if (this.pet_info.team != "player_pet")
                    {
                        this.object_mc.x = -325;
                    };
                    if (this.pet_info.team == "player_pet")
                    {
                        this.object_mc.x = 325;
                        break;
                    };
                    break;
                case BattleVars.Position_MELEE_5:
                    if (this.pet_info.team != "player_pet")
                    {
                        this.object_mc.x = -665;
                    };
                    if (this.pet_info.team == "player_pet")
                    {
                        this.object_mc.x = 665;
                        break;
                    };
                    break;
                case BattleVars.Position_RANGE_1:
                    if (this.pet_info.team != "player_pet")
                    {
                        this.object_mc.x = -240;
                    };
                    if (this.pet_info.team == "player_pet")
                    {
                        this.object_mc.x = 240;
                        break;
                    };
                    break;
                case BattleVars.Position_RANGE_2:
                    if (this.pet_info.team != "player_pet")
                    {
                        this.object_mc.x = -140;
                    };
                    if (this.pet_info.team == "player_pet")
                    {
                        this.object_mc.x = 140;
                        break;
                    };
                    break;
                case BattleVars.Position_RANGE_3:
                    if (this.pet_info.team != "player_pet")
                    {
                        this.object_mc.x = 20;
                    };
                    if (this.pet_info.team == "player_pet")
                    {
                        this.object_mc.x = -20;
                        break;
                    };
                    break;
                case BattleVars.Position_RANGE_4:
                    if (this.pet_info.team != "player_pet")
                    {
                        this.object_mc.x = 185;
                    };
                    if (this.pet_info.team == "player_pet")
                    {
                        this.object_mc.x = -185;
                        break;
                    };
            };
            if (this.pet_info.team == "player_pet")
            {
                if (this.pet_info.num > 0)
                {
                    this.object_mc.x = (this.object_mc.x + 140);
                };
                if (_arg_1 > 0)
                {
                    this.object_mc.x = (this.object_mc.x + 140);
                };
                if (((this.pet_info.num == 1) && (_arg_1 == 0)))
                {
                    this.object_mc.y = (this.object_mc.y + 80);
                };
                if (((this.pet_info.num == 2) && (_arg_1 == 0)))
                {
                    this.object_mc.y = (this.object_mc.y - 80);
                };
                if (((this.pet_info.num == 0) && (_arg_1 == 1)))
                {
                    this.object_mc.y = (this.object_mc.y - 80);
                };
                if (((this.pet_info.num == 0) && (_arg_1 == 2)))
                {
                    this.object_mc.y = (this.object_mc.y + 80);
                };
                if (((this.pet_info.num == 1) && (_arg_1 == 2)))
                {
                    this.object_mc.y = (this.object_mc.y + 160);
                };
                if (((this.pet_info.num == 2) && (_arg_1 == 1)))
                {
                    this.object_mc.y = (this.object_mc.y - 160);
                };
            }
            else
            {
                if (this.pet_info.num > 0)
                {
                    this.object_mc.x = (this.object_mc.x - 140);
                };
                if (_arg_1 > 0)
                {
                    this.object_mc.x = (this.object_mc.x - 140);
                };
                if (((this.pet_info.num == 1) && (_arg_1 == 0)))
                {
                    this.object_mc.y = (this.object_mc.y + 80);
                };
                if (((this.pet_info.num == 2) && (_arg_1 == 0)))
                {
                    this.object_mc.y = (this.object_mc.y - 80);
                };
                if (((this.pet_info.num == 0) && (_arg_1 == 1)))
                {
                    this.object_mc.y = (this.object_mc.y - 80);
                };
                if (((this.pet_info.num == 0) && (_arg_1 == 2)))
                {
                    this.object_mc.y = (this.object_mc.y + 80);
                };
                if (((this.pet_info.num == 1) && (_arg_1 == 2)))
                {
                    this.object_mc.y = (this.object_mc.y + 160);
                };
                if (((this.pet_info.num == 2) && (_arg_1 == 1)))
                {
                    this.object_mc.y = (this.object_mc.y - 160);
                };
            };
        }

        public function handleChaos():*
        {
            BattleManager.startRun();
        }

        public function getAccuracy():int
        {
            var _local_1:int = int(this.pet_info.pet_accuracy);
            var _local_2:Array = this.effects_manager.getActiveBuff("accuracy");
            var _local_3:Array = this.effects_manager.getActiveDebuff("accuracy");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "accuracy");
            return (BattleManager.modifyChance(_local_3, "RM", _local_1, "accuracy"));
        }

        public function getDodgeRate():int
        {
            var _local_1:int = int(this.pet_info.pet_dodge);
            var _local_2:Array = this.effects_manager.getActiveBuff("dodge");
            var _local_3:Array = this.effects_manager.getActiveDebuff("dodge");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "dodge");
            return (BattleManager.modifyChance(_local_3, "RM", _local_1, "dodge"));
        }

        public function getCombustionChance():int
        {
            var _local_1:Number = Number(this.pet_info.pet_combustion);
            var _local_2:Array = this.effects_manager.getActiveBuff("combustion");
            var _local_3:Array = this.effects_manager.getActiveDebuff("combustion");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1);
            return (BattleManager.modifyChance(_local_3, "RM", _local_1));
        }

        public function getCriticalChance():int
        {
            var _local_1:Number = Number(this.pet_info.pet_critical);
            var _local_2:Array = this.effects_manager.getActiveBuff("critical");
            var _local_3:Array = this.effects_manager.getActiveDebuff("critical");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "critical");
            return (BattleManager.modifyChance(_local_3, "RM", _local_1, "critical"));
        }

        public function getPurify():int
        {
            var _local_1:Number = Number(this.pet_info.pet_purify);
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

        public function getAgility():Number
        {
            return (Number(this.pet_info.pet_agility));
        }

        public function getHead():MovieClip
        {
            return (this.object_head);
        }

        public function getLevel():int
        {
            return (this.pet_info.pet_level);
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
            return (true);
        }

        public function isEnemy():Boolean
        {
            return (false);
        }

        public function isNpc():Boolean
        {
            return (false);
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
            return (this.pet_team);
        }

        public function getPlayerNumber():int
        {
            return (this.pet_number);
        }

        public function destroy():*
        {
            var _local_2:*;
            if (this.destroyed)
            {
                return;
            };
            this.destroyed = true;
            Log.info(this, "destroy", this.player_identification);
            var _local_1:* = BattleManager.getBattle();
            if (((_local_1) && ((this.pet_movieclip_holder + this.pet_number) in _local_1)))
            {
                _local_2 = _local_1[(this.pet_movieclip_holder + this.pet_number)];
                if (((!(this.object_mc == null)) && (_local_2.charMc.contains(this.object_mc))))
                {
                    _local_2.charMc.removeChild(this.object_mc);
                };
                GF.removeAllChild(_local_2.charMc);
                _local_2.charMc.character_model = null;
                if (("skillMc" in _local_2))
                {
                    GF.removeAllChild(_local_2.skillMc);
                };
                GF.removeAllChild(_local_2);
                _local_1 = null;
                _local_2 = null;
            };
            this.clearFrameScript();
            this.pet_team = null;
            this.pet_number = null;
            this.player_identification = null;
            this.pet_data = null;
            this.pet_info = null;
            GF.removeAllChild(this.object_head);
            GF.removeAllChild(this.object_mc);
            this.object_head = null;
            this.object_mc = null;
            this.pet_movieclip_holder = null;
            this.health_manager.destroy();
            this.health_manager = null;
            this.effects_manager.destroy();
            this.effects_manager = null;
            GF.clearArray(this.attack_results);
            this.attack_results = null;
            this.attack_result = null;
        }


    }
}//package Combat

