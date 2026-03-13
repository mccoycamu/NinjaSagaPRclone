// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.HealthManager

package Combat
{
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import com.utils.NumberUtil;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.filters.GlowFilter;
    import flash.events.MouseEvent;

    public class HealthManager 
    {

        public var player_team:String;
        public var player_number:int;
        public var play_dead_animation:Boolean = false;
        public var played_dead_animation:Boolean = false;
        public var player_info:*;
        public var current_hp:int = 0;
        public var max_hp:int = 0;
        public var original_max_hp:int = 0;
        public var current_cp:int = 0;
        public var max_cp:int = 0;
        public var original_max_cp:int = 0;
        public var current_sp:int = 0;
        public var max_sp:int = 0;
        public var amount_shield:int = 0;
        public var original_max_sp:int = 0;
        public var status_change:Object;
        public var temp_damage_taken:int = 0;
        public var triggered:Boolean = false;
        public var dh_notice:Boolean = false;
        private var rox:int = 1337;
        public var no_cp_cost:Boolean = false;
        public var temp_skill_cp_cost:int = 0;
        public var effectAddMaxHP:Object = {};
        public var effectDecreaseMaxHP:Object = {};
        public var effectAddMaxCP:Object = {};
        public var effectDecreaseMaxCP:Object = {};
        public var effectAddMaxSP:Object = {};
        private var eventHandler:*;

        public function HealthManager(param1:String, param2:int)
        {
            this.rox = Math.round((Math.random() * 2147483647));
            this.player_team = param1;
            this.eventHandler = new EventHandler();
            this.player_number = param2;
            this.status_change = {
                "increase_hp":0,
                "decrease_hp":0,
                "increase_cp":0,
                "decrease_cp":0,
                "increase_sp":0,
                "decrease_sp":0
            };
            this.initMaxStatusEffect();
        }

        private function initMaxStatusEffect():void
        {
            this.effectAddMaxHP = {
                "domain_expansion":{
                    "original_hp":0,
                    "increase_hp":0
                },
                "self_love":{
                    "original_hp":0,
                    "increase_hp":0
                }
            };
            this.effectDecreaseMaxHP = {
                "disable_weapon_effect":{
                    "original_hp":0,
                    "modifier_hp":0
                },
                "unwell":{
                    "original_hp":0,
                    "modifier_hp":0
                }
            };
            this.effectAddMaxCP = {
                "domain_expansion":{
                    "original_cp":0,
                    "increase_cp":0
                },
                "self_love":{
                    "original_cp":0,
                    "increase_cp":0
                },
                "wider":{
                    "original_cp":0,
                    "increase_cp":0
                }
            };
            this.effectDecreaseMaxCP = {"disable_weapon_effect":{
                    "original_cp":0,
                    "modifier_cp":0
                }};
            this.effectAddMaxSP = {"N/A":{
                    "original_sp":0,
                    "increase_sp":0
                }};
        }

        public function fillHealth(param1:*):*
        {
            this.player_info = param1;
            this.fillPlayerInfo();
        }

        public function capHealthAndCP():void
        {
            if (this.getCurrentHP() > this.getMaxHP())
            {
                this.setCurrentHP(this.getMaxHP());
            };
            if (this.getCurrentCP() > this.getMaxCP())
            {
                this.setCurrentCP(this.getMaxCP());
            };
        }

        public function chargePlayer(param1:int=25, param2:String="Charge"):void
        {
            var _loc7_:*;
            var _loc3_:* = this.getMovieClipHolder().charMc.character_model;
            var _loc4_:int;
            if (param2 == "Charge")
            {
                _loc7_ = _loc3_.effects_manager;
                _loc4_ = (_loc4_ + _loc7_.getIncreaseChargeCPByTalent());
                _loc4_ = (_loc4_ + _loc7_.getIncreaseChargeCPByEquippedSet());
                _loc4_ = (_loc4_ + _loc7_.getIncreaseChargeCPByEffect());
                _loc4_ = (_loc4_ - _loc7_.getDecreaseChargeCPByEffect());
                param1 = int((param1 + ((param1 * _loc4_) / 100)));
            };
            var _loc5_:int = int(Math.round(((this.max_cp * param1) / 100)));
            var _loc6_:String = ((param2 == "Charge") ? "Charge + " : "+ ");
            this.addCP(_loc5_, _loc6_);
            if (param2 == "Charge")
            {
                _loc3_.effects_manager.checkRecoverHPAfterCharge(_loc5_);
            };
        }

        public function getSkillCpCost(param1:*):void
        {
            var _loc2_:* = this.getMovieClipHolder().charMc.character_model;
            var _loc3_:EffectsManager = _loc2_.effects_manager;
            var _loc4_:int = (("skill_cp_cost" in param1) ? int(param1.skill_cp_cost) : int(param1.talent_skill_cp_cost));
            var _loc5_:int = _loc4_;
            var _loc6_:Array = _loc3_.getActiveBuff("cp_costing");
            var _loc7_:Array = _loc3_.getActiveDebuff("cp_costing");
            var _loc8_:Array = _loc3_.getEquippedSetForEffects("cp_costing");
            _loc5_ = BattleManager.modifyChance(_loc6_, "RM", _loc5_);
            _loc5_ = BattleManager.modifyChance(_loc7_, "ADD", _loc5_);
            _loc5_ = BattleManager.modifyChance(_loc8_, "RM", _loc5_);
            var _loc9_:int = _loc3_.getCpReductionBySenjutsu();
            if (_loc9_ > 0)
            {
                _loc5_ = int((_loc5_ - Math.floor(((_loc5_ * _loc9_) / 100))));
            };
            this.temp_skill_cp_cost = ((this.no_cp_cost) ? int(Math.max(_loc5_, 0)) : 0);
        }

        public function getSkillCpAmount(param1:*, param2:Boolean=false):int
        {
            var _loc3_:* = this.getMovieClipHolder().charMc.character_model;
            var _loc4_:EffectsManager = _loc3_.effects_manager;
            var _loc5_:int = (("skill_cp_cost" in param1) ? int(param1.skill_cp_cost) : int(param1.talent_skill_cp_cost));
            var _loc6_:int = _loc5_;
            var _loc7_:Array = _loc4_.getActiveBuff("cp_costing");
            var _loc8_:Array = _loc4_.getActiveDebuff("cp_costing");
            var _loc9_:Array = _loc4_.getEquippedSetForEffects("cp_costing");
            _loc6_ = BattleManager.modifyChance(_loc7_, "RM", _loc6_);
            _loc6_ = BattleManager.modifyChance(_loc8_, "ADD", _loc6_);
            _loc6_ = BattleManager.modifyChance(_loc9_, "RM", _loc6_);
            if ((!(param2)))
            {
                if (((_loc4_.hadEffect("excitation")) || (_loc4_.hadEffect("boundless"))))
                {
                    _loc6_ = 0;
                };
            };
            var _loc10_:int = _loc4_.getCpReductionBySenjutsu();
            if (_loc10_ > 0)
            {
                _loc6_ = int((_loc6_ - Math.floor(((_loc6_ * _loc10_) / 100))));
            };
            return (Math.max(_loc6_, 0));
        }

        public function hasEnoughCPForSkill(param1:*):*
        {
            var _loc2_:int = this.getSkillCpAmount(param1);
            if (this.getCurrentCP() >= _loc2_)
            {
                return (true);
            };
            return (false);
        }

        public function getSkillSpAmount(param1:*, param2:Boolean=false):int
        {
            var _loc3_:* = this.getMovieClipHolder().charMc.character_model;
            var _loc4_:* = param1.sp_cost;
            if (((Boolean(_loc3_.effects_manager.hadEffect("sage_mode"))) || (Boolean(_loc3_.effects_manager.hadEffect("boundless")))))
            {
                _loc4_ = 0;
            };
            if (_loc4_ < 0)
            {
                _loc4_ = 0;
            };
            return (_loc4_);
        }

        public function hasEnoughSPForSkill(param1:*):Boolean
        {
            var _loc2_:int = this.getSkillSpAmount(param1, true);
            if (this.getCurrentSP() >= _loc2_)
            {
                return (true);
            };
            return (false);
        }

        public function setCurrentHP(param1:*=100):*
        {
            var enemyId:String;
            var hp:* = param1;
            try
            {
                enemyId = this.getMovieClipHolder().charMc.character_model.player_identification;
                if (((enemyId == "ene_9001") || (enemyId == "ene_2086")))
                {
                    this.current_hp = (0x01 ^ this.rox);
                    return;
                };
            }
            catch(e:Error)
            {
            };
            this.current_hp = (hp ^ this.rox);
        }

        public function getCurrentHP():int
        {
            return (this.current_hp ^ this.rox);
        }

        public function getMaxHP():int
        {
            return (this.max_hp);
        }

        public function setCurrentCP(param1:*=0):*
        {
            this.current_cp = (param1 ^ this.rox);
        }

        public function getCurrentCP():int
        {
            return (this.current_cp ^ this.rox);
        }

        public function getMaxCP():int
        {
            return (this.max_cp);
        }

        public function getCurrentSP():int
        {
            return (this.current_sp);
        }

        public function getMaxSP():int
        {
            return (this.max_sp);
        }

        public function isDead():Boolean
        {
            var isTrue:Boolean;
            try
            {
                isTrue = ((this.getCurrentHP() <= 0) ? true : false);
            }
            catch(error)
            {
                isTrue = false;
            };
            return (isTrue);
        }

        public function playDeadAnimation():*
        {
            if (((!(this.isDead())) || (this.played_dead_animation)))
            {
                return;
            };
            var _loc1_:* = this.getMovieClipHolder().charMc.character_model;
            var _loc2_:* = this.getPetMovieClipHolder().charMc.character_model;
            _loc1_.playAnimation("dead");
            if (_loc2_ != undefined)
            {
                _loc2_.health_manager.setCurrentHP(0);
            };
            this.played_dead_animation = true;
        }

        public function checkActivateICM():*
        {
            return (false);
        }

        public function checkActivateUnyielding():Boolean
        {
            var _loc3_:Object;
            var _loc4_:Boolean;
            BattleManager.getBattle().agility_bar_manager.stopRun();
            var _loc1_:Object = this.getMovieClipHolder().charMc.character_model;
            var _loc2_:* = (this.player_team == "player");
            if ((!(_loc1_.isCharacter())))
            {
                return (false);
            };
            if ((!(_loc1_.character_manager.hasTalentSkill("skill_1050"))))
            {
                return (false);
            };
            if (this.getCurrentHP() <= 0)
            {
                _loc3_ = _loc1_.effects_manager.getActivateUnyielding();
                _loc4_ = Boolean(_loc1_.unyielding_mode);
                if (("effects" in _loc3_))
                {
                    if ((!(_loc4_)))
                    {
                        this.setCurrentHP(1);
                        BattleVars.OVERLOAD_MODE = false;
                        this.play_dead_animation = false;
                        this.played_dead_animation = false;
                        BattleManager.getBattle().activateUnyielding(_loc1_);
                        return (true);
                    };
                    if ((!(this.played_dead_animation)))
                    {
                        this.playDeadAnimation();
                    };
                }
                else
                {
                    if (((!(this.played_dead_animation)) && (!(_loc1_.isCharacter()))))
                    {
                        this.playDeadAnimation();
                    };
                };
            };
            return (false);
        }

        public function checkReviveEOM():Boolean
        {
            var _loc3_:Object;
            var _loc4_:Boolean;
            var _loc1_:* = this.getMovieClipHolder().charMc.character_model;
            var _loc2_:* = (this.player_team == "player");
            if ((!(_loc1_.isCharacter())))
            {
                return (false);
            };
            if ((!(_loc1_.character_manager.hasTalentSkill("skill_1023"))))
            {
                return (false);
            };
            if (this.getCurrentHP() <= 0)
            {
                _loc3_ = _loc1_.effects_manager.getActivateEOMRevive();
                _loc4_ = ((_loc2_) ? Boolean(BattleVars.CHARACTER_REVIVED[this.player_number]) : Boolean(BattleVars.ENEMY_REVIVED[this.player_number]));
                if (("effects" in _loc3_))
                {
                    if ((!(_loc4_)))
                    {
                        this.setCurrentHP(1);
                        this.play_dead_animation = false;
                        this.played_dead_animation = false;
                        BattleVars.OVERLOAD_MODE = false;
                        BattleManager.getBattle().revivePlayer(_loc1_);
                        return (true);
                    };
                    if ((!(this.played_dead_animation)))
                    {
                        this.playDeadAnimation();
                    };
                }
                else
                {
                    if (((!(this.played_dead_animation)) && (!(_loc1_.isCharacter()))))
                    {
                        this.playDeadAnimation();
                    };
                };
            };
            return (false);
        }

        public function addHealth(param1:int, param2:String="HP +"):void
        {
            var _loc5_:String;
            if (((this.getCurrentHP() <= 0) && (!(param2 == "Revived HP +"))))
            {
                return;
            };
            var _loc3_:* = this.getMovieClipHolder().charMc.character_model;
            if (param1 < 0)
            {
                param1 = ((~(param1)) + 1);
            };
            var _loc4_:Array = ["internal_injury", "pet_internal_injury", "hanyaoni", "suffocate", "unyielding"];
            for each (_loc5_ in _loc4_)
            {
                if (_loc3_.effects_manager.hadEffect(_loc5_))
                {
                    return;
                };
            };
            if (param2 == "Absorb HP +")
            {
                param1 = int((param1 / 2));
            };
            this.setCurrentHP((this.getCurrentHP() + param1));
            var _loc6_:* = ((param2 + param1.toString()) + " HP");
            this.createDisplay(_loc6_, "Health");
            if (this.getCurrentHP() > this.max_hp)
            {
                this.setCurrentHP(this.max_hp);
            };
            this.updateHealthBar();
        }

        public function addSP(param1:String="turn", param2:int=0):void
        {
            var _loc3_:int = param2;
            var _loc4_:* = this.getMovieClipHolder().charMc.character_model;
            if (_loc3_ < 0)
            {
                _loc3_ = ((~(_loc3_)) + 1);
            };
            if (_loc4_.effects_manager.hadEffect("sage_mode"))
            {
                return;
            };
            if (param2 < 0)
            {
                param2 = 0;
            };
            switch (param1)
            {
                case "turn":
                default:
                    _loc3_ = Math.round((this.max_sp * 0.1));
                    break;
                case "attacked":
                    _loc3_ = Math.round((param2 * 0.3));
                    break;
                case "SP +":
                    _loc3_ = param2;
                    break;
                    this.createDisplay((param1 + param2.toString()));
            };
            this.current_sp = (this.current_sp + _loc3_);
            if (this.current_sp > this.max_sp)
            {
                this.current_sp = this.max_sp;
            };
            this.updateHealthBar();
        }

        public function getRecoverWhenCPReducedByTalent():*
        {
            var _loc1_:* = this.getMovieClipHolder().charMc.character_model;
            var _loc2_:int;
            _loc2_ = (_loc2_ + _loc1_.effects_manager.getRecoverWhenCPReducedByTalent());
            if (_loc2_ > 0)
            {
                this.addHealth(_loc2_);
            };
        }

        public function addCP(param1:int, param2:String="CP +"):void
        {
            var _loc3_:* = this.getMovieClipHolder().charMc.character_model;
            if (((Boolean(_loc3_.effects_manager.hadEffect("domain_expansion"))) || (Boolean(_loc3_.effects_manager.hadEffect("meridian_injury")))))
            {
                return;
            };
            if (param1 < 0)
            {
                param1 = ((~(param1)) + 1);
            };
            this.setCurrentCP((this.getCurrentCP() + param1));
            if (this.getCurrentCP() > this.max_cp)
            {
                this.setCurrentCP(this.max_cp);
            };
            var _loc4_:* = ((param2 + param1.toString()) + " CP");
            this.createDisplay(_loc4_, "CP");
            this.updateHealthBar();
        }

        private function deadReset(param1:Object):void
        {
            param1.effects_manager.clearAllEffect();
            this.amount_shield = 0;
            this.temp_skill_cp_cost = 0;
            this.temp_damage_taken = 0;
        }

        public function reduceHealth(param1:int, param2:String="-"):void
        {
            var _loc6_:*;
            var _loc7_:*;
            var _loc8_:int;
            var _loc9_:Object;
            var _loc10_:Object;
            var _loc3_:* = this.getMovieClipHolder().charMc.character_model;
            var _loc4_:* = this.getPetMovieClipHolder().charMc.character_model;
            if (param1 < 0)
            {
                param1 = ((~(param1)) + 1);
            };
            if (param2 == "-")
            {
                param1 = int(_loc3_.effects_manager.checkReduceHealthEffects(_loc3_, param1));
            };
            this.temp_damage_taken = (this.temp_damage_taken + param1);
            BattleManager.getBattle().total_damage = param1;
            if ((((_loc3_.effects_manager.hadEffect("unyielding")) || (param1 < 0)) || ((param1 == 0) && (BattleVars.IS_SELF_SKILL))))
            {
                return;
            };
            if (((Character.mission_id == "ninja_tutor_s1c2_4") && (_loc3_.player_identification == "ene_356")))
            {
                _loc6_ = BattleManager.getBattle()["enemyMc_1"].charMc.character_model;
                _loc7_ = BattleManager.getBattle()["enemyMc_2"].charMc.character_model;
                if (((!(_loc6_.isDead())) || (!(_loc7_.isDead()))))
                {
                    BattleManager.showMessage("Seems you have to slay the monsters first...");
                    return;
                };
            }
            else
            {
                if (((Character.is_thanksgiving_event) && (_loc3_.player_identification == "ene_2074")))
                {
                    _loc6_ = BattleManager.getBattle()["enemyMc_1"].charMc.character_model;
                    _loc7_ = BattleManager.getBattle()["enemyMc_2"].charMc.character_model;
                    if (((!(_loc6_.isDead())) || (!(_loc7_.isDead()))))
                    {
                        BattleManager.showMessage("You must kill male & female Kappa first.");
                        return;
                    };
                };
            };
            if (((((BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.DRAGON_HUNT_MATCH) && (BattleVars.DH_MODE == 2)) && (BattleManager.getBattle().checkSealEnemy())) && (this.player_team == "enemy")))
            {
                if ((!(this.dh_notice)))
                {
                    BattleManager.getNotice("The dragon is now capturable");
                    this.dh_notice = true;
                };
            };
            if (((param2 == "-") && (this.amount_shield > 0)))
            {
                _loc8_ = param1;
                param1 = (param1 - this.amount_shield);
                this.amount_shield = (this.amount_shield - _loc8_);
                if (this.amount_shield > 0)
                {
                    this.createDisplay(("Shield: " + this.amount_shield.toString()));
                    return;
                };
                this.amount_shield = 0;
            };
            this.setCurrentHP((this.getCurrentHP() - param1));
            if (this.getCurrentHP() < 0)
            {
                this.setCurrentHP(0);
            };
            if (param2 == "-")
            {
                _loc3_.effects_manager.checkDeductAttackerCP();
                _loc3_.effects_manager.checkInstantDeductAttackerHP();
                _loc3_.effects_manager.checkRecoverEnemyHPAfterDidDamage();
                _loc3_.effects_manager.checkRecoverHpIfUserIsUnderBloodlust();
                _loc3_.effects_manager.checkReduceWindCD();
                _loc3_.effects_manager.checkRestoreCPAfterDealtDamage(param1);
                _loc3_.effects_manager.checkRecoverHPAfterHealthDeduct(param1);
                _loc3_.effects_manager.checkRecoverHPAfterAttacked(_loc3_);
                if (BattleVars.ATTACK_TYPE == "weapon")
                {
                    _loc3_.effects_manager.checkKekkaiReduceHpCp();
                };
            };
            if (((BattleVars.IS_CRITICAL) && (param2 == "-")))
            {
                param2 = "Critical -";
            };
            if (this.player_team == "enemy")
            {
                BattleManager.getBattle().addToTotalDamageDoneToEnemies(param1);
                BattleManager.getBattle().showTotalDamageHint();
            };
            this.createDisplay(((param2 + param1.toString()) + " HP"));
            this.updateHealthBar();
            if (this.isDead())
            {
                this.deadReset(_loc3_);
                if (this.player_team == "enemy")
                {
                    BattleManager.getBattle().agility_bar_manager.checkForBattleStatus();
                };
                if ((((Boolean(_loc3_.isPet())) || (Boolean(_loc3_.isEnemy()))) && (!(this.play_dead_animation))))
                {
                    this.play_dead_animation = true;
                    BattleVars.PLAY_DEAD_ANIMATION = ((_loc3_.isPet()) ? "PET" : "ENEMY&NPC");
                    BattleVars.PLAY_DEAD_TEAM = this.player_team;
                    BattleVars.PLAY_DEAD_NUMBER = this.player_number;
                };
                if (((Boolean(_loc3_.isCharacter())) && (!(this.play_dead_animation))))
                {
                    _loc9_ = _loc3_.effects_manager.getActivateUnyielding();
                    _loc10_ = _loc3_.effects_manager.getActivateEOMRevive();
                    if (((!("effects" in _loc9_)) && (!("effects" in _loc10_))))
                    {
                        if (_loc4_ != undefined)
                        {
                            _loc4_.health_manager.setCurrentHP(0);
                        };
                        this.play_dead_animation = true;
                        BattleVars.PLAY_DEAD_ANIMATION = "CHAR";
                        BattleVars.PLAY_DEAD_TEAM = this.player_team;
                        BattleVars.PLAY_DEAD_NUMBER = this.player_number;
                    };
                };
            };
            var _loc5_:* = (Math.floor(((this.max_hp * 40) / 100)) >= this.getCurrentHP());
            if ((((Character.is_jounin_stage_5_1) && (_loc5_)) && (_loc3_.player_identification == "ene_101")))
            {
                Character.is_jounin_stage_5_1 = false;
                BattleVars.MATCH_RUNNING = false;
                BattleManager.getMain().continueStage5Jounin();
            };
        }

        public function reduceCP(param1:int, param2:String="CP -"):void
        {
            var _loc8_:Array;
            var _loc9_:Object;
            var _loc3_:int = this.getCurrentCP();
            var _loc4_:Object = this.getMovieClipHolder().charMc.character_model;
            var _loc5_:Object = _loc4_.effects_manager;
            var _loc6_:int = int(_loc5_.getUseChanceToUseSkillWithoutCP());
            var _loc7_:Array = _loc5_.getAllCharacterSetEffects();
            if (param1 < 0)
            {
                param1 = ((~(param1)) + 1);
            };
            if (_loc5_.hadEffect("cannot_reduced_cp"))
            {
                return;
            };
            if (this.getCurrentCP() < 0)
            {
                this.setCurrentCP(0);
            };
            this.no_cp_cost = ((param2 == "skill") && (Boolean(_loc5_.noCPCostFromTalent())));
            param1 = ((this.no_cp_cost) ? 0 : param1);
            if (param2 == "")
            {
                this.updateHealthBar();
                return;
            };
            if (((param2 == "skill") || (param2 == "talent")))
            {
                _loc5_.checkConsumeCPToHealth(this, param1);
                for each (_loc8_ in _loc7_)
                {
                    for each (_loc9_ in _loc8_)
                    {
                        if (_loc9_.effect == "reduce_cp_consumption")
                        {
                            param1 = (param1 - ((_loc9_.calc_type == "percent") ? Math.floor(((_loc9_.amount * param1) / 100)) : _loc9_.cost_cp));
                        }
                        else
                        {
                            if ((((_loc9_.effect == "reduce_cp_consumption_prc") && ("chance" in _loc9_)) && (_loc9_.chance >= NumberUtil.getRandomInt())))
                            {
                                param1 = 0;
                            };
                        };
                    };
                };
            };
            this.setCurrentCP(Math.max((this.getCurrentCP() - param1), 0));
            this.createDisplay((((param2 == "skill") || (param2 == "talent")) ? (("- " + param1) + " CP") : ((param2 + param1) + " CP")));
            _loc5_.activateMeridianKekkai(param1, param2, _loc3_);
            this.updateHealthBar();
        }

        public function reduceSP(param1:int, param2:String="SP -"):*
        {
            var _loc3_:* = this.getMovieClipHolder().charMc.character_model;
            this.current_sp = (this.current_sp - param1);
            if (this.current_sp < 0)
            {
                this.current_sp = 0;
            };
            if (param2 == "")
            {
                this.updateHealthBar();
                return;
            };
            this.createDisplay((param2 + param1.toString()));
            this.updateHealthBar();
        }

        public function reduceHpFromDebuff(param1:Object, param2:String):void
        {
            var _loc3_:int = int(param1.amount);
            if ((("prev_effect" in param1) && (param1.prev_effect == "kill_instant_under")))
            {
                param2 = "Instant Kill HP -";
            };
            if (("new_amount_percent" in param1))
            {
                _loc3_ = int(param1.amount_hp);
            };
            if (param1.calc_type == "percent")
            {
                _loc3_ = ((param1.reduce_type == "MAX") ? int(Math.floor(((_loc3_ * this.max_hp) / 100))) : int(Math.floor(((_loc3_ * this.getCurrentHP()) / 100))));
            };
            this.reduceHealth(_loc3_, param2);
        }

        public function reduceCPFromDebuff(param1:Object, param2:String):void
        {
            var _loc6_:Object;
            var _loc7_:Object;
            var _loc3_:EffectsManager = this.getMovieClipHolder().charMc.character_model.effects_manager;
            var _loc4_:int = int(param1.amount);
            if (_loc3_.hadEffect("cannot_reduced_cp"))
            {
                return;
            };
            if (this.getCurrentCP() < 0)
            {
                this.setCurrentCP(0);
            };
            if (param1.amount_cp > _loc4_)
            {
                _loc4_ = int(param1.amount_cp);
            };
            if (param1.calc_type == "percent")
            {
                _loc4_ = ((param1.reduce_type == "MAX") ? int(Math.floor(((_loc4_ * this.max_cp) / 100))) : int(Math.floor(((_loc4_ * this.getCurrentCP()) / 100))));
            };
            this.reduceCP(_loc4_, param2);
            var _loc5_:int = (this.getCurrentCP() - _loc4_);
            if (((param1.effect == "drain_cp_stun") && (_loc5_ < 1)))
            {
                _loc6_ = {
                    "effect":"stun",
                    "effect_name":"Stun",
                    "duration_deduct":"after_effect",
                    "duration":param1.amount_stun
                };
                _loc3_.addDebuff(_loc6_);
            }
            else
            {
                if (((param1.effect == "drain_cp_injury") && (_loc5_ < 1)))
                {
                    _loc7_ = {
                        "effect":"meridian_injury",
                        "effect_name":"Meridian Injury",
                        "duration_deduct":"after_attack",
                        "duration":param1.amount_injury
                    };
                    _loc3_.addDebuff(_loc7_);
                };
            };
        }

        public function createDisplay(param1:String, param2:String=""):*
        {
            var _loc3_:Object = ((param2 == "") ? this.getMovieClipHolder() : this.getCharacterForDisplayEffect());
            Effects.showMcAndPlay(_loc3_, param1);
        }

        private function getCharacterForDisplayEffect():Object
        {
            var _loc1_:String = (((this.player_team == "enemy") || (this.player_team == "enemy_pet")) ? "enemyMc_" : "charMc_");
            return (BattleManager.getBattle()[(_loc1_ + this.player_number)]);
        }

        public function getMovieClipHolder():Object
        {
            var _loc1_:String = ((this.player_team == "player_pet") ? "charPetMc_" : ((this.player_team == "enemy") ? "enemyMc_" : ((this.player_team == "enemy_pet") ? "enemyPetMc_" : "charMc_")));
            return (BattleManager.getBattle()[(_loc1_ + this.player_number)]);
        }

        public function getPetMovieClipHolder():*
        {
            var _loc1_:String = "charPetMc_";
            if (this.player_team == "enemy")
            {
                _loc1_ = "enemyPetMc_";
            };
            return (BattleManager.getBattle()[(_loc1_ + this.player_number)]);
        }

        public function fillPlayerInfo():void
        {
            var _loc2_:String;
            var _loc1_:* = this.getMovieClipHolder();
            _loc1_.visible = true;
            if (("character_level" in this.player_info))
            {
                _loc2_ = ((("Lv." + this.player_info.character_level) + " ") + this.player_info.character_name);
                _loc1_.nameTxt.htmlText = ((this.player_info.character_id == Character.char_id) ? _loc2_ : Character.colorifyText(this.player_info.character_id, _loc2_));
                if (("character_rank" in this.player_info))
                {
                    _loc1_.rankMC.gotoAndStop(this.player_info.character_rank);
                };
            }
            else
            {
                if (("pet_level" in this.player_info))
                {
                    _loc1_.txtmc.nameTxt.text = ((("Lv." + this.player_info.pet_level) + " ") + this.player_info.pet_name);
                }
                else
                {
                    if (("enemy_hp" in this.player_info))
                    {
                        _loc1_.rankMC.visible = false;
                        _loc1_.nameTxt.text = ((("Lv." + this.player_info.enemy_level) + " ") + this.player_info.enemy_name);
                    }
                    else
                    {
                        _loc1_.rankMC.gotoAndStop(this.player_info.npc_rank);
                        _loc1_.nameTxt.text = ((("Lv." + this.player_info.npc_level) + " ") + this.player_info.npc_name);
                    };
                };
            };
            this.updateHealthBarDisplay();
        }

        public function updateHealthBarDisplay():void
        {
            var _loc1_:* = this.getMovieClipHolder();
            var _loc2_:* = _loc1_.charMc.character_model;
            if (("character_hp" in this.player_info))
            {
                this.setPlayerStats(this.player_info.character_hp, this.player_info.character_cp, this.player_info.character_sp);
            }
            else
            {
                if (("pet_level" in this.player_info))
                {
                    this.setPlayerStats(this.player_info.pet_hp, this.player_info.pet_cp);
                }
                else
                {
                    if (("enemy_hp" in this.player_info))
                    {
                        this.setPlayerStats(this.player_info.enemy_hp, this.player_info.enemy_cp, this.player_info.enemy_sp);
                    }
                    else
                    {
                        this.setPlayerStats(this.player_info.npc_hp, this.player_info.npc_cp);
                    };
                };
            };
            if ((((Character.is_jounin_stage_5_2) && (this.player_team == "enemy")) && (_loc2_.player_identification == "ene_101")))
            {
                this.setCurrentHP(Math.floor((this.max_hp * 0.4)));
            };
            if (((this.player_team == "player") && (BattleManager.getMain().remainingStatus.length > 0)))
            {
                this.updateRemainingStatus();
            };
            _loc1_.hpBar.scaleX = (this.getCurrentHP() / this.max_hp);
            if (((this.player_team == "player") && (this.player_number == 0)))
            {
                this.fillMainHealthBarInfo();
            };
        }

        private function setPlayerStats(param1:int, param2:int, param3:int=0):void
        {
            this.max_hp = (this.original_max_hp = param1);
            this.max_cp = (this.original_max_cp = param2);
            this.max_sp = (this.original_max_sp = param3);
            this.setCurrentHP(param1);
            this.setCurrentCP(param2);
        }

        private function updateRemainingStatus():void
        {
            var _loc1_:* = BattleManager.getMain().remainingStatus[this.player_number];
            this.setCurrentHP(int(_loc1_.remaining_hp));
            this.setCurrentCP(int(_loc1_.remaining_cp));
            this.current_sp = int(_loc1_.remaining_sp);
            this.player_info.character_hp = int(_loc1_.remaining_hp);
            this.player_info.character_cp = int(_loc1_.remaining_cp);
            this.player_info.character_sp = int(_loc1_.remaining_sp);
            BattleVars.CHARACTER_REVIVED[this.player_number] = _loc1_.remaining_eom;
            this.checkRemainingStatusFromEffect(_loc1_);
            if (this.isDead())
            {
                this.playDeadAnimation();
            };
        }

        private function checkRemainingStatusFromEffect(param1:Object):void
        {
            var _loc2_:* = this.getMovieClipHolder();
            var _loc3_:* = _loc2_.charMc.character_model;
            if (_loc3_ != undefined)
            {
                if (_loc3_.isCharacter())
                {
                    _loc3_.unyielding_mode = param1.remaining_unyielding;
                };
            };
        }

        public function updateHealthBar():*
        {
            var _loc1_:* = this.getMovieClipHolder();
            _loc1_.hpBar.scaleX = (this.getCurrentHP() / this.max_hp);
            var _loc2_:TextField = (_loc1_.getChildByName("hpText") as TextField);
            if (_loc2_ == null)
            {
                _loc2_ = new TextField();
                _loc2_.name = "hpText";
                _loc2_.autoSize = "left";
                _loc2_.mouseEnabled = false;
                var _loc3_:TextFormat = new TextFormat();
                _loc3_.font = "Arial";
                _loc3_.size = 10;
                _loc3_.bold = true;
                _loc3_.color = 0xFFFFFF;
                _loc2_.defaultTextFormat = _loc3_;
                _loc2_.filters = [new GlowFilter(0, 1, 2, 2, 10)];
                _loc1_.addChild(_loc2_);
            };
            _loc2_.visible = Battle.SHOW_HP_TEXT;
            if (Battle.SHOW_HP_TEXT)
            {
                _loc2_.text = ((this.getCurrentHP() + "/") + this.max_hp);
                _loc2_.x = (_loc1_.hpBar.x + (((_loc1_.hpBar.width / _loc1_.hpBar.scaleX) - _loc2_.width) / 2));
                _loc2_.y = ((_loc1_.hpBar.y + ((_loc1_.hpBar.height - _loc2_.height) / 2)) + 1);
            };
            if (((this.player_team == "player") && (this.player_number == 0)))
            {
                BattleManager.getBattle()["char_hpcp"].txt_hp.text = ((this.getCurrentHP() + "/") + this.max_hp);
                BattleManager.getBattle()["char_hpcp"].txt_cp.text = ((this.getCurrentCP() + "/") + this.max_cp);
                BattleManager.getBattle()["char_hpcp"].txt_sp.text = ((this.getCurrentSP() + "/") + this.max_sp);
                BattleManager.getBattle()["char_hpcp"].hpBar.scaleX = (this.getCurrentHP() / this.max_hp);
                BattleManager.getBattle()["char_hpcp"].cpBar.scaleX = (this.getCurrentCP() / this.max_cp);
                BattleManager.getBattle()["char_hpcp"].spBar.scaleX = (this.getCurrentSP() / this.max_sp);
                if (_loc1_.charMc.character_model.character_info.character_rank > 7)
                {
                    this.isSenjutsuActive();
                };
            };
        }

        public function isSenjutsuActive():*
        {
            var _loc1_:* = this.getMovieClipHolder().charMc.character_model;
            var _loc2_:String = "disableButton";
            if (this.current_sp == this.max_sp)
            {
                _loc2_ = "enableButton";
            };
            if (_loc1_.effects_manager.hadEffect("unyielding"))
            {
                _loc2_ = "disableButton";
            };
            if (_loc2_ == "enableButton")
            {
                BattleManager.getMain().enableButton(BattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"]);
                this.eventHandler.addListener(BattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"], MouseEvent.CLICK, this.useSageMode);
            }
            else
            {
                BattleManager.getMain().disableButton(BattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"]);
                this.eventHandler.removeListener(BattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"], MouseEvent.CLICK, this.useSageMode);
            };
        }

        public function useSageMode(param1:*):*
        {
            if (this.current_sp != this.max_sp)
            {
                return;
            };
            var _loc2_:* = this.getMovieClipHolder().charMc.character_model;
            var _loc3_:Object = {
                "effect":"sage_mode",
                "effect_name":"Sage Mode",
                "duration_deduct":"after_attack",
                "calc_type":"percent",
                "is_passive":false,
                "duration":5,
                "amount":5
            };
            BattleTimer.stopTurnTimer();
            _loc2_.effects_manager.addBuff(_loc3_);
            BattleManager.getBattle().actionBar.visible = false;
            this.reduceSP(this.max_sp, "SP -");
            BattleManager.getBattle().copySkill("skill_3000");
        }

        public function fillMainHealthBarInfo():*
        {
            BattleManager.getBattle()["char_hpcp"].visible = true;
            BattleManager.getMain().initButtonDisable(BattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"], this.useSageMode);
            BattleManager.getBattle()["char_hpcp"].txt_hp.text = ((this.player_info.character_hp + "/") + this.player_info.character_max_hp);
            BattleManager.getBattle()["char_hpcp"].txt_cp.text = ((this.player_info.character_cp + "/") + this.player_info.character_max_cp);
            BattleManager.getBattle()["char_hpcp"].txt_sp.text = ((0 + "/") + this.player_info.character_max_sp);
            BattleManager.getBattle()["char_hpcp"].txt_xp.text = ((this.player_info.character_xp + "/") + String(BattleManager.getMain().stat_manager.calculate_xp(int(this.player_info.character_level))));
            BattleManager.getBattle()["char_hpcp"].txt_lvl.text = this.player_info.character_level;
            BattleManager.getBattle()["char_hpcp"].txt_name.text = this.player_info.character_name;
            BattleManager.getBattle()["char_hpcp"].hpBar.scaleX = (this.player_info.character_hp / this.player_info.character_max_hp);
            BattleManager.getBattle()["char_hpcp"].cpBar.scaleX = (this.player_info.character_cp / this.player_info.character_max_cp);
            BattleManager.getBattle()["char_hpcp"].spBar.scaleX = (0 / this.player_info.character_max_sp);
            BattleManager.getBattle()["char_hpcp"].xpBar.scaleX = Math.max(Math.min((this.player_info.character_xp / BattleManager.getMain().stat_manager.calculate_xp(int(this.player_info.character_level))), 1), 0);
        }

        public function destroy():*
        {
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.player_info = null;
            this.player_team = null;
            this.player_number = null;
            this.play_dead_animation = null;
            this.played_dead_animation = null;
            this.current_hp = null;
            this.max_hp = null;
            this.original_max_hp = null;
            this.current_cp = null;
            this.max_cp = null;
            this.current_sp = null;
            this.max_sp = null;
            this.amount_shield = null;
            this.original_max_cp = null;
            this.effectAddMaxCP = null;
            this.effectAddMaxHP = null;
            this.effectAddMaxSP = null;
            this.effectDecreaseMaxCP = null;
            this.effectDecreaseMaxHP = null;
            this.status_change = null;
            this.rox = 0;
        }


    }
}//package Combat

