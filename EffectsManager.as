// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.EffectsManager

package Combat
{
    import flash.events.MouseEvent;
    import com.utils.NumberUtil;
    import id.ninjasage.Util;
    import Storage.TalentSkillLevel;
    import Storage.SenjutsuSkillLevel;
    import Storage.WeaponBuffs;
    import Storage.BackItemBuffs;
    import Storage.AccessoryBuffs;
    import flash.display.MovieClip;
    import com.utils.GF;

    public class EffectsManager 
    {

        public var user_team:String;
        public var user_number:int;
        public var has_added_health_from_debuff:Boolean = false;
        public var has_added_cp_from_debuff:Boolean = false;
        public var has_added_health_from_buff:Boolean = false;
        public var has_added_cp_from_buff:Boolean = false;
        public var model:* = null;
        private var lastDisableWeaponState:Boolean = false;

        private var allSetEffects:* = [];
        public var user_buffs:Array = [];
        public var user_debuffs:Array = [];
        public var dataBuff:Array = [];
        public var dataDebuff:Array = [];
        public var all_buffs_name_array:Array = [];
        public var all_debuffs_name_array:Array = [];
        public var tempt_skills_used_for_senjutsu:Array = [false];
        public var cooldownListFromSenjutsu:Array = [""];
        public var tempt_skills_used_for_talent:Array = [false];
        public var cooldownListFromTalent:Array = [""];

        public function EffectsManager(_arg_1:String, _arg_2:int)
        {
            var _local_3:Object;
            var _local_4:Object;
            var _local_5:Object;
            super();
            this.user_team = _arg_1;
            this.user_number = _arg_2;
            var _local_6:Object = this.getAllBuffs();
            for each (_local_3 in _local_6)
            {
                this.user_buffs[_local_3.effect] = Effects.copyEffect(_local_3);
                this.all_buffs_name_array.push(_local_3.effect);
            };
            _local_4 = this.getAllDebuffs();
            for each (_local_5 in _local_4)
            {
                this.user_debuffs[_local_5.effect] = Effects.copyEffect(_local_5);
                this.all_debuffs_name_array.push(_local_5.effect);
            };
            Effects.init();
        }

        public function hadEffect(_arg_1:String):Boolean
        {
            var _local_4:Object;
            var _local_2:Array = this.dataBuff.concat(this.dataDebuff);
            var _local_3:Boolean;
            for each (_local_4 in _local_2)
            {
                if (((_arg_1 == _local_4.effect) && (_local_4.duration > 0)))
                {
                    _local_3 = true;
                    break;
                };
            };
            return (_local_3);
        }

        public function getEffect(_arg_1:String):Object
        {
            var _local_3:Object;
            var _local_2:Array = this.dataBuff.concat(this.dataDebuff);
            for each (_local_3 in _local_2)
            {
                if (((_arg_1 == _local_3.effect) && (_local_3.duration > 0)))
                {
                    return (_local_3);
                };
            };
            return ({});
        }

        public function resetHasAddedHpCpEffects():*
        {
            this.has_added_health_from_debuff = false;
            this.has_added_cp_from_debuff = false;
            this.has_added_health_from_buff = false;
            this.has_added_cp_from_buff = false;
        }

        public function showCombustion():*
        {
            Effects.showEffectInfo(this.user_team, this.user_number, "Combustion");
        }

        public function purifyPlayer(_arg_1:String="Purify", _arg_2:String=""):*
        {
            var _local_5:int;
            var _local_6:Object;
            var _local_3:Object = this.getCurrentModel();
            var _local_4:Array = this.dataDebuff;
            this.checkRecoverHPAfterPurified();
            _local_3.health_manager.createDisplay(_arg_1);
            if (_arg_2 === "sensation")
            {
                this.dataDebuff = [];
                return;
            };
            if (_local_4.length > 0)
            {
                _local_5 = (_local_4.length - 1);
                while (_local_5 >= 0)
                {
                    _local_6 = _local_4[_local_5];
                    if (!Effects.doesEffectCannotPurified(_local_6.effect))
                    {
                        _local_4.splice(_local_5, 1);
                    };
                    _local_5--;
                };
            };
        }

        public function canPlayerUseSkill(_arg_1:String, _arg_2:int, _arg_3:*, _arg_4:*):*
        {
            var _local_5:* = (_arg_4 is MouseEvent);
            var _local_6:Boolean = ((this.hadEffect("restriction")) || (this.hadEffect("pet_restriction")));
            var _local_7:Boolean = ((this.hadEffect("ecstasy")) || (this.hadEffect("pet_ecstasy")));
            var _local_8:Boolean = this.hadEffect("meridian_seal");
            var _local_9:Boolean = this.hadEffect("snake_mark");
            var _local_10:Boolean = this.hadEffect("barrier");
            var _local_11:Boolean = this.hadEffect("unyielding");
            if (((_arg_3.skill_type < 6) && (_local_6)))
            {
                if (_local_5)
                {
                    BattleManager.getMain().showMessage("Cannot use that while restricted.");
                };
                return (false);
            };
            if (((_arg_3.skill_type == 9) || ((_arg_3.skill_type == 11) && (_local_9))))
            {
                if (_local_5)
                {
                    BattleManager.getMain().showMessage("Cannot use that while under Snake Mark.");
                };
                return (false);
            };
            if (((_arg_3.skill_type < 6) && (_local_7)))
            {
                if (_local_5)
                {
                    BattleManager.getMain().showMessage("Cannot use that while under Ecstasy.");
                };
                return (false);
            };
            if (_local_8)
            {
                if (_local_5)
                {
                    BattleManager.getMain().showMessage("Cannot use that while under Meridian Seal.");
                };
                return (false);
            };
            if (_local_10)
            {
                if (_local_5)
                {
                    BattleManager.getMain().showMessage("Cannot use that while under Barrier.");
                };
                return (false);
            };
            if (_local_11)
            {
                if (_local_5)
                {
                    BattleManager.getMain().showMessage("Cannot use that while under unyielding.");
                };
                return (false);
            };
            return (true);
        }

        public function checkPassiveEffectsAfterBeingHit(_arg_1:*, _arg_2:*, _arg_3:Boolean=true):*
        {
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:String;
            var _local_11:int;
            var _local_12:Array;
            var _local_13:int;
            var _local_14:Object;
            var _local_4:Object;
            var _local_5:Object;
            var _local_6:Array;
            _local_7 = 0;
            _local_8 = 0;
            _local_9 = 0;
            _local_10 = null;
            _local_11 = undefined;
            _local_12 = null;
            _local_13 = undefined;
            if (_arg_1.isCharacter())
            {
                _local_4 = _arg_1.effects_manager.getEffect("pet_stubborn_recover_cp");
                _local_5 = _arg_1.effects_manager.getEffect("attacker_disorient");
                _local_6 = _arg_1.effects_manager.getAllCharacterSetEffects();
                _local_7 = 0;
                _local_8 = 0;
                _local_9 = 0;
                _local_10 = "";
                if (_arg_1.effects_manager.hadEffect("pet_stubborn_recover_cp"))
                {
                    _local_7 = int(_local_4.duration);
                    _local_8 = (("chance" in _local_4) ? int(_local_4.chance) : 100);
                    _local_9 = int(_local_4.amount);
                    _local_10 = String(_local_4.calc_type);
                    this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "instant_cp_recover", true, false, "Stubborn");
                };
                _local_11 = 0;
                while (_local_11 < _local_6.length)
                {
                    _local_12 = _local_6[_local_11];
                    _local_13 = 0;
                    while (_local_13 < _local_12.length)
                    {
                        _local_14 = _local_12[_local_13];
                        _local_7 = int(_local_14.duration);
                        _local_8 = int(_local_14.chance);
                        _local_9 = int(_local_14.amount);
                        _local_10 = String(_local_14.calc_type);
                        switch (_local_14.effect)
                        {
                            case "concentration_when_attacked":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_1, _local_8, _local_7, _local_9, _local_10, "concentration", false, true, "Concentration", false, true);
                                break;
                            case "attacker_chaos":
                            case "chaos_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "chaos");
                                break;
                            case "attacker_restrict":
                            case "restrict_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "restriction");
                                break;
                            case "attacker_petrify":
                            case "petrify_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "petrify");
                                break;
                            case "attacker_fear":
                            case "fear_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "fear");
                                break;
                            case "attacker_stun":
                            case "stun_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "stun");
                                break;
                            case "attacker_freeze":
                            case "freeze_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "frozen", true, true, "Frozen");
                                break;
                            case "attacker_blind":
                            case "blind_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "blind", true, true, "Blind");
                                break;
                            case "attacker_poison":
                            case "poison_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "poison", true, true, "Poison");
                                break;
                            case "attacker_slow":
                            case "slow_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "slow", true, true, "Slow");
                                break;
                            case "attacker_burn":
                            case "burn_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "burn", true, false, "Burn");
                                break;
                            case "attacker_bleeding":
                            case "bleeding_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "bleeding", true, false, "Bleeding");
                                break;
                            case "attacker_numb":
                            case "numb_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "numb", true, false, "Numb");
                                break;
                            case "attacker_weaken":
                            case "weaken_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "weaken", true, false, "Weaken");
                                break;
                            case "attacker_concentration":
                            case "concentration_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_1, _local_8, _local_7, _local_9, _local_10, "concentration", false, false, "Concentration");
                                break;
                            case "absorb_attacker_hp_present":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "insta_drain_hp", true, true, "Drain HP");
                                break;
                            case "absorb_hp_attacker":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_1, _local_8, _local_7, _local_9, _local_10, "insta_drain_hp", true, true, "Absorb HP");
                                break;
                            case "stubborn_recover_cp":
                                this.checkPassiveEffectToActiveAfterBeingHit(_arg_2, _local_8, _local_7, _local_9, _local_10, "instant_cp_recover", true, false, "CP +");
                                break;
                        };
                        _local_13++;
                    };
                    _local_11++;
                };
            };
        }

        public function checkPassiveEffectToActiveAfterBeingHit(_arg_1:*, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:String, _arg_6:String, _arg_7:Boolean=true, _arg_8:Boolean=false, _arg_9:String="", _arg_10:Boolean=false, _arg_11:Boolean=false):*
        {
            var _local_12:Object;
            var _local_13:int = NumberUtil.getRandomInt();
            if (_arg_2 >= _local_13)
            {
                _local_12 = {
                    "passive":_arg_10,
                    "type":((_arg_7) ? "Debuff" : "Buff"),
                    "target":((_arg_7) ? "enemy" : "player"),
                    "effect":_arg_6,
                    "amount":_arg_4,
                    "amount_hp":_arg_4,
                    "amount_cp":_arg_4,
                    "amount_prc":_arg_4,
                    "amount_protection":_arg_4,
                    "duration":_arg_3,
                    "calc_type":_arg_5,
                    "switch_att_def":_arg_8,
                    "effect_name":_arg_9,
                    "reduce_type":"MAX",
                    "no_disperse":false
                };
                if (_arg_7)
                {
                    _arg_1.effects_manager.addDebuff(_local_12);
                };
                if (!_arg_7)
                {
                    _arg_1.effects_manager.addBuff(_local_12);
                };
            };
        }

        public function getCanBeEffectForEffectName(_arg_1:String):Array
        {
            if (_arg_1 == "dodge")
            {
                return (["increase_dodge", "dodge_increase"]);
            };
            if (_arg_1 == "accuracy")
            {
                return (["increase_accuracy", "accuracy_increase", "aqua_regia"]);
            };
            if (_arg_1 == "critical")
            {
                return (["increase_critical", "critical_increase"]);
            };
            if (_arg_1 == "agility")
            {
                return (["increase_agility", "agility_increase"]);
            };
            if (_arg_1 == "purify")
            {
                return (["increase_purify", "purify_increase", "aqua_regia"]);
            };
            if (_arg_1 == "combustion")
            {
                return (["increase_combustion", "combustion_increase"]);
            };
            if (_arg_1 == "reactive_force")
            {
                return (["increase_reactive", "reactive_increase", "weapon_reactive_force", "reflect"]);
            };
            if (_arg_1 == "cp_costing")
            {
                return (["reduce_cp_cost"]);
            };
            return ([]);
        }

        public function getCanBeEffectForDebuffEffectName(_arg_1:String):Array
        {
            if (_arg_1 == "dodge")
            {
                return (["decrease_dodge", "dodge_decrease"]);
            };
            if (_arg_1 == "accuracy")
            {
                return (["decrease_accuracy", "accuracy_decrease"]);
            };
            if (_arg_1 == "critical")
            {
                return (["decrease_critical", "critical_decrease"]);
            };
            if (_arg_1 == "agility")
            {
                return (["decrease_agility", "agility_decrease"]);
            };
            if (_arg_1 == "purify")
            {
                return (["decrease_purify", "purify_decrease"]);
            };
            if (_arg_1 == "comubstion")
            {
                return (["decrease_combustion", "combustion_decrease"]);
            };
            if (_arg_1 == "reactive_force")
            {
                return (["decrease_reactive", "reactive_decrease"]);
            };
            return ([]);
        }

        public function getEquippedSetForEffects(_arg_1:String, _arg_2:Boolean=true):Array
        {
            var _local_8:int;
            var _local_9:String;
            var _local_3:Array = this.getAllCharacterSetEffects();
            var _local_4:Array = this.getCanBeEffectForDebuffEffectName(_arg_1);
            if (_arg_2)
            {
                _local_4 = this.getCanBeEffectForEffectName(_arg_1);
            };
            var _local_5:Array = [];
            var _local_6:Array = [];
            var _local_7:int;
            while (_local_7 < _local_3.length)
            {
                _local_5 = _local_3[_local_7];
                _local_8 = 0;
                while (_local_8 < _local_5.length)
                {
                    for each (_local_9 in _local_4)
                    {
                        if (_local_5[_local_8].effect == _local_9)
                        {
                            _local_6.push(_local_5[_local_8]);
                        };
                    };
                    _local_8++;
                };
                _local_7++;
            };
            return (_local_6);
        }

        public function checkRecoverHpIfUserIsUnderBloodlust():*
        {
            var _local_5:Object;
            var _local_6:Array;
            var _local_1:int;
            var _local_2:int;
            var _local_3:* = BattleManager.getBattle().getAttacker();
            var _local_4:* = BattleManager.getBattle().getDefender();
            var _local_7:* = _local_4.effects_manager.getEffect("bloodlust");
            if (_local_7.duration > 0)
            {
                if (_local_7.next_turn == true)
                {
                    _local_7.next_turn = false;
                    return;
                };
                if ((_local_1 = int(Math.floor(((_local_7.amount * BattleManager.getTotalDamage()) / 100)))) > 0)
                {
                    _local_3.health_manager.addHealth(_local_1, "BloodlustMC ");
                };
            };
        }

        public function checkForIncreasePurifyFromHPPercentage():*
        {
            var _local_5:Object;
            var _local_6:Array;
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:* = this.getCurrentModel();
            if (!_local_4.isCharacter())
            {
                return (_local_1);
            };
            _local_2 = int(_local_4.health_manager.getMaxCP());
            _local_3 = int(_local_4.health_manager.getCurrentCP());
            var _local_7:* = (_local_3 <= (_local_2 / 2));
            var _local_8:Object = _local_4.effects_manager.getEffect("cp_shield_and_increase_purify");
            if (((_local_4.effects_manager.hadEffect("cp_shield_and_increase_purify")) && (_local_7)))
            {
                _local_1 = (_local_1 + 100);
            };
            return (_local_1);
        }

        public function checkKekkaiReduceHpCp():*
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:* = BattleManager.getBattle().getAttacker();
            var _local_7:* = BattleManager.getBattle().getDefender();
            var _local_8:Object = _local_7.effects_manager.getEffect("kekkai");
            if (_local_8.duration > 0)
            {
                _local_1 = int(_local_7.health_manager.getMaxHP());
                _local_2 = int(_local_7.health_manager.getMaxCP());
                _local_3 = int(Math.floor(((_local_1 * _local_8.amount) / 100)));
                _local_4 = int(Math.floor(((_local_2 * _local_8.amount) / 100)));
                if (_local_3 > 0)
                {
                    _local_7.health_manager.reduceHealth(_local_3, "Kekkai HP -");
                };
                if (_local_4 > 0)
                {
                    _local_7.health_manager.reduceCP(_local_4, "Kekkai CP -");
                };
            };
        }

        public function checkCapture():*
        {
            var _local_6:Object;
            var _local_1:* = BattleManager.getBattle().getDefender();
            var _local_2:* = BattleManager.getBattle().getAttacker();
            var _local_3:Object = _local_2.effects_manager.getCaptureChanceFromSilhouette();
            var _local_4:int = NumberUtil.getRandomInt();
            var _local_5:Boolean = this.hasDebuffResist(_local_1);
            if (((_local_3.chance >= _local_4) && (!(_local_5))))
            {
                _local_6 = {
                    "effect":"capture",
                    "amount":_local_3.amount,
                    "duration":(_local_3.duration - 1),
                    "calc_type":"percent"
                };
                _local_1.effects_manager.addDebuff(_local_6);
            };
        }

        public function checkLavaShield():void
        {
            var _local_3:Object;
            var _local_4:Object;
            var _local_5:Object;
            var _local_1:Object = BattleManager.getBattle().getDefender();
            var _local_2:Object = BattleManager.getBattle().getAttacker();
            if (_local_1.effects_manager.hadEffect("lava_shield"))
            {
                _local_3 = new Object();
                _local_3.effect = "fire_faint";
                _local_3.duration = 2;
                _local_3.calc_type = "percent";
                _local_3.amount = _local_1.effects_manager.getEffect("lava_shield").amount;
                _local_2.effects_manager.addDebuff(_local_3);
                _local_4 = new Object();
                _local_4.effect = "earth_faint";
                _local_4.duration = 2;
                _local_4.calc_type = "percent";
                _local_4.amount = _local_1.effects_manager.getEffect("lava_shield").amount;
                _local_2.effects_manager.addDebuff(_local_4);
                _local_5 = new Object();
                _local_5.effect = "numb";
                _local_5.duration = 3;
                _local_5.calc_type = "number";
                _local_5.amount = _local_1.effects_manager.getEffect("lava_shield").amount_numb;
                _local_2.effects_manager.addDebuff(_local_5);
            };
        }

        public function checkReduceWindCD():*
        {
            var _local_1:* = BattleManager.getBattle().getDefender();
            var _local_2:Object = _local_1.effects_manager.getEffect("reduce_wind_cd");
            if (_local_2.duration > 0)
            {
                _local_1.actions_manager.reduceElementSkillsCD(_local_2.amount, 1);
                Effects.showEffectInfo(this.user_team, this.user_number, ("Reduce Wind CD " + _local_2.amount));
            };
        }

        public function checkRecoverEnemyHPAfterDidDamage():void
        {
            var _local_1:Object = BattleManager.getBattle().getAttacker();
            var _local_2:Object = _local_1.effects_manager;
            var _local_3:int;
            if (((_local_2.hadEffect("bloodfeed")) || (_local_2.hadEffect("pet_bloodfeed"))))
            {
                _local_3 = int((_local_3 + Math.floor(((BattleManager.getTotalDamage() * _local_2.getEffect("bloodfeed").amount) / 100))));
            };
            if (_local_2.hadEffect("kyubi_cloak"))
            {
                _local_3 = int((_local_3 + Math.floor(((BattleManager.getTotalDamage() * _local_2.getEffect("kyubi_cloak").amount_bloodfeed) / 100))));
            };
            if (_local_3 > 0)
            {
                _local_1.health_manager.addHealth(_local_3, "BloodfeedMC ");
            };
        }

        public function checkRecoverHPAfterPurified():void
        {
            var _local_4:Array;
            var _local_5:Object;
            var _local_6:int;
            var _local_7:int;
            var _local_1:Object = this.getCurrentModel();
            if (((!(_local_1)) || (!(_local_1.isCharacter()))))
            {
                return;
            };
            var _local_2:Array = this.getAllCharacterSetEffects();
            if (((!(_local_2)) || (_local_2.length == 0)))
            {
                return;
            };
            var _local_3:int;
            for each (_local_4 in _local_2)
            {
                for each (_local_5 in _local_4)
                {
                    if (((_local_5) && (_local_5.effect == "recover_hp_after_purify")))
                    {
                        _local_3 = (_local_3 + _local_5.amount);
                    };
                };
            };
            if (((_local_3 > 0) && (_local_1.health_manager)))
            {
                _local_6 = _local_1.health_manager.getMaxHP();
                _local_7 = int(Math.floor(((_local_6 * _local_3) / 100)));
                _local_1.health_manager.addHealth(_local_7, "Recovered HP +");
            };
        }

        public function checkStunAfterDidDamage(_arg_1:String="critical_buff_n_received_stun"):*
        {
            var _local_2:* = undefined;
            var _local_3:* = BattleManager.getBattle().getAttacker();
            var _local_4:* = BattleManager.getBattle().getDefender().effects_manager;
            var _local_5:* = _local_4.getEffect(_arg_1);
            var _local_6:* = _local_4.hadEffect(_arg_1);
            if (_local_6)
            {
                (_local_2 = {}).effect = "stun";
                _local_2.effect_name = "Stun";
                _local_2.duration_deduct = "after_attack";
                _local_2.calc_type = "percent";
                _local_2.reduce_type = "MAX";
                _local_2.passive = false;
                _local_2.type = "Debuff";
                _local_2.target = "enemy";
                _local_2.switch_att_def = false;
                _local_2.no_disperse = false;
                _local_2.amount = _local_5.amount;
                _local_2.amount_hp = _local_5.amount;
                _local_2.amount_cp = _local_5.amount;
                _local_2.amount_protection = (("amount_protection" in _local_5) ? _local_5.amount_protection : _local_5.amount);
                _local_2.amount_prc = _local_5.amount;
                _local_2.duration = 1;
                _local_3.effects_manager.addDebuff(_local_2);
            };
        }

        public function checkBurnAfterDidDamage(_arg_1:String="fire_wall"):*
        {
            var _local_2:* = undefined;
            var _local_3:* = BattleManager.getBattle().getAttacker();
            var _local_4:* = BattleManager.getBattle().getDefender().effects_manager;
            var _local_5:* = _local_4.getEffect(_arg_1);
            var _local_6:* = _local_4.hadEffect(_arg_1);
            if (_local_6)
            {
                (_local_2 = {}).effect = "fire_wall_burn";
                _local_2.effect_name = "Burn";
                _local_2.duration_deduct = "after_attack";
                _local_2.calc_type = "percent";
                _local_2.reduce_type = "MAX";
                _local_2.passive = false;
                _local_2.type = "Debuff";
                _local_2.target = "enemy";
                _local_2.switch_att_def = false;
                _local_2.no_disperse = false;
                _local_2.amount = _local_5.amount;
                _local_2.amount_hp = _local_5.amount;
                _local_2.amount_cp = _local_5.amount;
                _local_2.amount_protection = (("amount_protection" in _local_5) ? _local_5.amount_protection : _local_5.amount);
                _local_2.amount_prc = _local_5.amount;
                _local_2.duration = _local_5.amount_duration;
                _local_3.effects_manager.addDebuff(_local_2);
            };
            if (_arg_1 == "fire_wall")
            {
                this.checkBurnAfterDidDamage("pet_fire_wall");
            };
        }

        public function checkBleedingAfterDidDamage(_arg_1:String="attacker_bleeding"):void
        {
            var _local_7:Object;
            var _local_2:Object = BattleManager.getBattle();
            var _local_3:Object = _local_2.getAttacker();
            var _local_4:Object = _local_2.getDefender();
            var _local_5:Object = _local_4.effects_manager;
            var _local_6:Object = _local_5.getEffect(_arg_1);
            if (((_local_6) && (_local_6.duration > 0)))
            {
                _local_7 = {
                    "effect":"bleeding",
                    "effect_name":"bleeding",
                    "duration_deduct":"after_attack",
                    "calc_type":"percent",
                    "reduce_type":"MAX",
                    "passive":false,
                    "type":"Debuff",
                    "target":"enemy",
                    "switch_att_def":false,
                    "no_disperse":false,
                    "amount":_local_6.amount,
                    "amount_hp":(("amount_hp" in _local_6) ? _local_6.amount_hp : 0),
                    "amount_cp":(("amount_cp" in _local_6) ? _local_6.amount_cp : 0),
                    "amount_protection":(("amount_protection" in _local_6) ? _local_6.amount_protection : 0),
                    "amount_prc":(("amount_prc" in _local_6) ? _local_6.amount_prc : 0),
                    "duration":_local_6.amount_duration
                };
                _local_3.effects_manager.addDebuff(_local_7);
            };
            if (_arg_1 == "attacker_bleeding")
            {
                this.checkBurnAfterDidDamage("pet_attacker_bleeding");
            };
        }

        public function checkBurnAfterCritical(_arg_1:Object):void
        {
            var _local_4:Array;
            var _local_5:Object;
            var _local_2:Object = BattleManager.getBattle().getAttacker();
            if (!_local_2.isCharacter())
            {
                return;
            };
            var _local_3:Array = _local_2.effects_manager.getAllCharacterSetEffects();
            for each (_local_4 in _local_3)
            {
                for each (_local_5 in _local_4)
                {
                    if (_local_5.effect == "hemorrhage")
                    {
                        _arg_1.effects_manager.addDebuff(_local_5);
                        return;
                    };
                };
            };
        }

        public function checkStunAfterCritical(_arg_1:Object):void
        {
            var _local_4:Array;
            var _local_5:Object;
            var _local_2:Object = BattleManager.getBattle().getAttacker();
            if (!_local_2.isCharacter())
            {
                return;
            };
            var _local_3:Array = _local_2.effects_manager.getAllCharacterSetEffects();
            for each (_local_4 in _local_3)
            {
                for each (_local_5 in _local_4)
                {
                    if (_local_5.effect == "stun_when_crit")
                    {
                        this.checkPassiveEffectToActiveAfterBeingHit(_arg_1, 100, 1, _local_5.amount, "", "stun", true, true, "Stun", false, false);
                        return;
                    };
                };
            };
        }

        public function checkConcentrationAfterCritical(_arg_1:Object):void
        {
            var _local_3:Array;
            var _local_4:Object;
            if (!_arg_1.isCharacter())
            {
                return;
            };
            var _local_2:Array = _arg_1.effects_manager.getAllCharacterSetEffects();
            for each (_local_3 in _local_2)
            {
                for each (_local_4 in _local_3)
                {
                    if (_local_4.effect == "concentration_when_crit")
                    {
                        this.checkPassiveEffectToActiveAfterBeingHit(_arg_1, 100, _local_4.duration, _local_4.amount, "", "concentration", false, true, "Concentration", false, false);
                        return;
                    };
                };
            };
        }

        public function checkRecoverHPAfterCritical(_arg_1:Object):void
        {
            var _local_4:Array;
            var _local_5:Object;
            var _local_6:Number;
            if (!_arg_1.isCharacter())
            {
                return;
            };
            var _local_2:Array = _arg_1.effects_manager.getAllCharacterSetEffects();
            var _local_3:Number = _arg_1.health_manager.getMaxHP();
            for each (_local_4 in _local_2)
            {
                for each (_local_5 in _local_4)
                {
                    if (_local_5.effect == "recover_hp_after_critical")
                    {
                        _local_6 = ((_local_5.calc_type == "percent") ? Math.floor(((_local_3 * _local_5.amount) / 100)) : _local_5.amount);
                        _arg_1.health_manager.addHealth(_local_6);
                        return;
                    };
                };
            };
        }

        public function checkDisorientAttacker(_arg_1:String="attacker_disorient"):*
        {
            var _local_2:* = undefined;
            var _local_3:* = BattleManager.getBattle().getAttacker();
            var _local_4:* = BattleManager.getBattle().getDefender().effects_manager;
            var _local_5:* = _local_4.getEffect(_arg_1);
            var _local_6:* = _local_4.hadEffect(_arg_1);
            var _local_7:int;
            if (_local_6)
            {
                (_local_2 = {}).effect = "disorient_2";
                _local_2.effect_name = "Disorient";
                _local_2.duration_deduct = "after_attack";
                _local_2.calc_type = "percent";
                _local_2.reduce_type = "MAX";
                _local_2.passive = false;
                _local_2.type = "Debuff";
                _local_2.target = "enemy";
                _local_2.switch_att_def = false;
                _local_2.no_disperse = false;
                _local_2.amount = _local_5.amount;
                _local_2.amount_hp = _local_5.amount;
                _local_2.amount_cp = _local_5.amount;
                _local_2.amount_protection = 0;
                _local_2.amount_prc = _local_5.amount;
                _local_2.duration = _local_5.amount_duration;
                _local_2.chance = (("chance" in _local_5) ? _local_5.chance : 100);
                _local_7 = NumberUtil.getRandomInt();
                if (_local_2.chance >= _local_7)
                {
                    _local_3.effects_manager.addDebuff(_local_2);
                };
            };
        }

        public function checkTheft():void
        {
            var _local_6:int;
            var _local_1:int;
            var _local_2:int;
            var _local_3:Object = BattleManager.getBattle().getAttacker();
            var _local_4:Object = this.getCurrentModel();
            var _local_5:Object = _local_3.effects_manager.getEffect("theft");
            if (_local_5.duration > 0)
            {
                _local_1 = NumberUtil.getRandomInt();
                if (_local_5.chance >= _local_1)
                {
                    _local_6 = int(_local_3.health_manager.getMaxHP());
                    _local_2 = (_local_2 + _local_5.amount);
                    if (_local_5.calc_type == "percent")
                    {
                        _local_2 = int(Math.floor(((_local_2 * _local_6) / 100)));
                    };
                    if (!_local_3.theft_mode)
                    {
                        _local_3.health_manager.reduceHealth(_local_2, "Theft -");
                        _local_3.theft_mode = true;
                    };
                    _local_4.health_manager.addHealth(_local_2, "Theft +");
                };
            };
        }

        public function checkReduceHPAttacker(_arg_1:String="reduce_hp_attacker"):*
        {
            var _local_2:* = undefined;
            var _local_3:* = BattleManager.getBattle().getAttacker();
            var _local_4:* = BattleManager.getBattle().getDefender().effects_manager;
            var _local_5:* = _local_4.getEffect(_arg_1);
            var _local_6:* = _local_4.hadEffect(_arg_1);
            var _local_7:int;
            if (_local_6)
            {
                (_local_5 = {}).effect = "reduce_hp";
                _local_5.effect_name = "Reduce HP";
                _local_5.duration_deduct = "immediately";
                _local_5.calc_type = _local_5.calc_type;
                _local_5.reduce_type = "MAX";
                _local_5.passive = false;
                _local_5.type = "Debuff";
                _local_5.target = "enemy";
                _local_5.switch_att_def = false;
                _local_5.no_disperse = false;
                _local_5.amount = _local_5.amount;
                _local_5.amount_hp = _local_5.amount;
                _local_5.amount_cp = _local_5.amount;
                _local_5.amount_protection = 0;
                _local_5.amount_prc = _local_5.amount;
                _local_5.duration = _local_5.amount_duration;
                _local_5.chance = (("chance" in _local_5) ? _local_5.chance : 100);
                _local_7 = NumberUtil.getRandomInt();
                if (_local_5.chance >= _local_7)
                {
                    _local_3.effects_manager.addDebuff(_local_5);
                };
            };
        }

        public function checkSlowAttacker(_arg_1:String="slow_attacker"):*
        {
            var _local_2:* = undefined;
            var _local_3:* = BattleManager.getBattle().getAttacker();
            var _local_4:* = BattleManager.getBattle().getDefender().effects_manager;
            var _local_5:* = _local_4.getEffect(_arg_1);
            var _local_6:* = _local_4.hadEffect(_arg_1);
            var _local_7:int;
            if (_local_6)
            {
                (_local_2 = {}).effect = "slow";
                _local_2.effect_name = "Slow";
                _local_2.duration_deduct = "immediately";
                _local_2.calc_type = _local_5.calc_type;
                _local_2.reduce_type = "MAX";
                _local_2.passive = false;
                _local_2.type = "Debuff";
                _local_2.target = "enemy";
                _local_2.switch_att_def = false;
                _local_2.no_disperse = false;
                _local_2.amount = _local_5.amount;
                _local_2.amount_hp = _local_5.amount;
                _local_2.amount_cp = _local_5.amount;
                _local_2.amount_protection = 0;
                _local_2.amount_prc = _local_5.amount;
                _local_2.duration = _local_5.amount_duration;
                _local_2.chance = (("chance" in _local_5) ? _local_5.chance : 100);
                _local_7 = NumberUtil.getRandomInt();
                if (_local_2.chance >= _local_7)
                {
                    _local_3.effects_manager.addDebuff(_local_2);
                };
            };
        }

        public function checkStrengthenAfterDodgedTheAttack():*
        {
            var _local_1:Array;
            var _local_2:Array = this.getAllCharacterSetEffects();
            var _local_3:Object = {};
            var _local_4:* = 0;
            var _local_5:* = 0;
            while (_local_5 < _local_2.length)
            {
                _local_1 = _local_2[_local_5];
                _local_4 = 0;
                while (_local_4 < _local_1.length)
                {
                    if (_local_1[_local_4].effect == "dodge_damage_bonus")
                    {
                        _local_3.effect = "power_up";
                        _local_3.type = "Buff";
                        _local_3.target = "self";
                        _local_3.effect_name = "Strengthen";
                        _local_3.duration_deduct = "after_attack";
                        _local_3.amount = _local_1[_local_4].amount;
                        _local_3.duration = _local_1[_local_4].duration;
                        _local_3.calc_type = "percent";
                        _local_3.chance = 100;
                        _local_3.effect_description = "Increase all attack damage by x% for y turns.";
                    };
                    _local_4++;
                };
                _local_5++;
            };
            if (_local_3.effect)
            {
                this.addBuff(_local_3);
            };
        }

        public function checkAbsorbDamage(_arg_1:Object, _arg_2:int):int
        {
            if (_arg_2 < 0)
            {
                return (0);
            };
            var _local_3:Array;
            var _local_4:* = undefined;
            var _local_5:Array = this.getAllCharacterSetEffects();
            var _local_6:int = NumberUtil.getRandomInt();
            var _local_7:int;
            var _local_8:* = 0;
            while (_local_8 < _local_5.length)
            {
                _local_3 = _local_5[_local_8];
                _local_4 = 0;
                while (_local_4 < _local_3.length)
                {
                    if (_local_3[_local_4].effect == "absorb_damage_to_hp")
                    {
                        if (_local_3[_local_4].chance >= _local_6)
                        {
                            if (_local_3[_local_4].calc_type == "percent")
                            {
                                _local_7 = int((_local_7 + Math.floor(((_arg_2 * _local_3[_local_4].amount) / 100))));
                            }
                            else
                            {
                                _local_7 = (_local_7 + int(_local_3[_local_4].amount));
                            };
                            _arg_1.health_manager.addHealth(_local_7, "Absorb HP +");
                        };
                    };
                    _local_4++;
                };
                _local_8++;
            };
            var _local_9:* = (_arg_2 - _local_7);
            if (_local_9 == 0)
            {
                BattleVars.SHOW_DAMAGE_ZERO = true;
            };
            return (_local_9);
        }

        public function checkDamageToHealth(_arg_1:*, _arg_2:int):*
        {
            if (_arg_2 < 0)
            {
                _arg_2 = 0;
            };
            var _local_3:Array;
            var _local_4:* = undefined;
            var _local_5:Array = this.getAllCharacterSetEffects();
            var _local_6:int = NumberUtil.getRandomInt();
            var _local_7:int;
            var _local_8:* = 0;
            while (_local_8 < _local_5.length)
            {
                _local_3 = _local_5[_local_8];
                _local_4 = 0;
                while (_local_4 < _local_3.length)
                {
                    if (_local_3[_local_4].effect == "absorb_damage_to_hp")
                    {
                        if (_local_3[_local_4].chance >= _local_6)
                        {
                            if (_local_3[_local_4].calc_type == "percent")
                            {
                                _local_7 = int((_local_7 + Math.floor(((_local_3[_local_4].amount * _arg_2) / 100))));
                            }
                            else
                            {
                                _local_7 = (_local_7 + int(_local_3[_local_4].amount));
                            };
                            _arg_1.health_manager.addHealth(_local_7, "Absorb HP +");
                        };
                    };
                    _local_4++;
                };
                _local_8++;
            };
        }

        public function checkDamageToCP(_arg_1:*, _arg_2:int):void
        {
            var _local_3:Array;
            var _local_4:* = undefined;
            var _local_5:Array = this.getAllCharacterSetEffects();
            var _local_6:int = NumberUtil.getRandomInt();
            var _local_7:int;
            var _local_8:* = 0;
            while (_local_8 < _local_5.length)
            {
                _local_3 = _local_5[_local_8];
                _local_4 = 0;
                while (_local_4 < _local_3.length)
                {
                    if (((_local_3[_local_4].effect == "absorb_damage_to_cp") || (_local_3[_local_4].effect == "convert_damage_taken_cp")))
                    {
                        if (_local_3[_local_4].chance >= _local_6)
                        {
                            if (_local_3[_local_4].calc_type == "percent")
                            {
                                _local_7 = int((_local_7 + Math.floor(((_local_3[_local_4].amount * _arg_2) / 100))));
                            }
                            else
                            {
                                _local_7 = (_local_7 + int(_local_3[_local_4].amount));
                            };
                            _arg_1.health_manager.addCP(_local_7, "Recover CP +");
                        };
                    };
                    _local_4++;
                };
                _local_8++;
            };
        }

        public function checkConsumeCPToHealth(_arg_1:HealthManager, _arg_2:int):*
        {
            var _local_3:Array;
            var _local_4:* = undefined;
            var _local_5:Array = this.getAllCharacterSetEffects();
            var _local_6:int;
            var _local_7:* = 0;
            while (_local_7 < _local_5.length)
            {
                _local_3 = _local_5[_local_7];
                _local_4 = 0;
                while (_local_4 < _local_3.length)
                {
                    if (((_local_3[_local_4].effect == "cp_consume_to_hp") || (_local_3[_local_4].effect == "recover_hp_by_cp_cost")))
                    {
                        if (_local_3[_local_4].calc_type == "percent")
                        {
                            _local_6 = int((_local_6 + Math.floor(((_local_3[_local_4].amount * _arg_2) / 100))));
                        }
                        else
                        {
                            _local_6 = (_local_6 + int(_local_3[_local_4].amount));
                        };
                        _arg_1.addHealth(_local_6, "CP Consume HP +");
                    };
                    _local_4++;
                };
                _local_7++;
            };
        }

        public function wakePlayer():*
        {
            this.getEffect("sleep").duration = 0;
            this.getEffect("pet_sleep").duration = 0;
        }

        public function hasDebuffResist(_arg_1:*):Boolean
        {
            if ((((Boolean(_arg_1.effects_manager.hadEffect("unyielding"))) || (Boolean(_arg_1.effects_manager.hadEffect("debuff_resist")))) || (Boolean(_arg_1.effects_manager.hadEffect("pet_debuff_resist")))))
            {
                return (true);
            };
            return (false);
        }

        public function checkRandomLock():*
        {
            var _local_1:Object = this.hadEffect("random_debuff");
            var _local_2:Object = this.getEffect("random_debuff");
            if (!_local_1)
            {
                return;
            };
            var _local_3:Object = BattleManager.getBattle().getAttacker();
            if (this.hasDebuffResist(_local_3))
            {
                Effects.showEffectResisted(_local_3.getPlayerTeam(), _local_3.getPlayerNumber());
                return;
            };
            var _local_4:Array = ["stun", "restriction", "meridian_seal", "sleep"];
            var _local_5:Array = ["Stun", "Restriction", "Meridian Seal", "Sleep"];
            var _local_6:int = NumberUtil.randomInt(0, (_local_4.length - 1));
            var _local_7:String = _local_4[_local_6];
            var _local_8:Object = {
                "effect":_local_7,
                "duration":_local_2.amount
            };
            _local_3.effects_manager.addDebuff(_local_8);
        }

        public function checkRandomS16(_arg_1:Object):*
        {
            var _local_2:Object = this.getCurrentModel();
            var _local_3:Object = BattleManager.getBattle().getDefender();
            if (this.hasDebuffResist(_local_2))
            {
                Effects.showEffectResisted(_local_3.getPlayerTeam(), _local_3.getPlayerNumber());
                return;
            };
            var _local_4:Array = ["stun", "barrier", "chaos"];
            var _local_5:Array = ["Stun", "Barrier", "Chaos"];
            var _local_6:int = NumberUtil.randomInt(0, (_local_4.length - 1));
            var _local_7:String = _local_4[_local_6];
            var _local_8:Object = {
                "effect":_local_7,
                "duration":_arg_1.amount
            };
            _local_2.effects_manager.addDebuff(_local_8);
        }

        private function capitalizeFirstLetter(_arg_1:String):String
        {
            return (_arg_1.charAt(0).toUpperCase() + _arg_1.slice(1));
        }

        public function checkDeductAttackerCP():*
        {
            var _local_1:* = BattleManager.getBattle().getAttacker();
            var _local_2:* = BattleManager.getBattle().getDefender();
            var _local_3:int = int(_local_1.health_manager.getMaxCP());
            var _local_4:int;
            if (_local_2.effects_manager.hadEffect("reduce_attacker_cp"))
            {
                _local_4 = int((_local_4 + Math.floor(((_local_3 * _local_2.effects_manager.getEffect("reduce_attacker_cp").amount_cp) / 100))));
            };
            if (_local_2.effects_manager.hadEffect("dec_cp_attacker"))
            {
                _local_4 = int((_local_4 + Math.floor(((_local_3 * _local_2.effects_manager.getEffect("dec_cp_attacker").amount) / 100))));
            };
            if (_local_1.effects_manager.hadEffect("conduction"))
            {
                _local_4 = int((_local_4 + Math.floor(((_local_3 * _local_1.effects_manager.getEffect("conduction").amount) / 100))));
            };
            if (_local_1.effects_manager.hadEffect("pet_conduction"))
            {
                _local_4 = int((_local_4 + Math.floor(((_local_3 * _local_1.effects_manager.getEffect("pet_conduction").amount) / 100))));
            };
            if (_local_4 > 0)
            {
                _local_1.health_manager.reduceCP(_local_4, "Reduce CP -");
            };
        }

        public function checkInstantDeductAttackerHP():*
        {
            var _local_4:Object;
            var _local_1:Object = BattleManager.getBattle().getAttacker();
            var _local_2:Object = BattleManager.getBattle().getDefender();
            var _local_3:int;
            if (_local_2.effects_manager.hadEffect("instant_reduce_hp_attacker"))
            {
                _local_4 = _local_2.effects_manager.getEffect("instant_reduce_hp_attacker");
                _local_3 = (_local_3 + _local_4.amount);
                if (_local_4.calc_type == "percent")
                {
                    _local_3 = int((_local_3 + Math.floor(((_local_1.health_manager.getMaxHP() * _local_3) / 100))));
                };
            };
            if (_local_3 > 0)
            {
                _local_1.health_manager.reduceHealth(_local_3, "Reduce HP -");
            };
        }

        public function getIncreaseCriticalByPassiveEffects(_arg_1:String):Number
        {
            var _local_7:*;
            var _local_2:Array = [];
            var _local_3:Array = this.getAllCharacterSetEffects();
            var _local_4:Number = 0;
            var _local_5:Array = ["attacker_critical_damage_bonus", "mortal"];
            var _local_6:* = 0;
            while (_local_6 < _local_3.length)
            {
                _local_2 = _local_3[_local_6];
                _local_7 = 0;
                while (_local_7 < _local_2.length)
                {
                    if (Util.in_array(_local_2[_local_7].effect, _local_5))
                    {
                        if (_local_2[_local_7].calc_type == _arg_1)
                        {
                            _local_4 = (_local_4 + Math.floor(_local_2[_local_7].amount));
                        };
                    };
                    _local_7++;
                };
                _local_6++;
            };
            return (_local_4);
        }

        public function noCPCostFromTalent():Boolean
        {
            var _local_2:Number;
            var _local_1:Object = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (false);
            };
            if (_local_1.character_manager.hasTalentSkill("skill_1057"))
            {
                _local_2 = TalentSkillLevel.getTalentSkillLevels("skill_1057", _local_1.character_manager.getTalentLevel("skill_1057")).chance;
                if (_local_2 >= NumberUtil.getRandomInt())
                {
                    _local_1.health_manager.createDisplay("Future Vision");
                    return (true);
                };
            };
            return (false);
        }

        public function getCooldownReduceFromTalent(_arg_1:String):Boolean
        {
            var _local_5:Number;
            var _local_2:Object = this.getCurrentModel();
            var _local_3:Boolean;
            if (!_local_2.isCharacter())
            {
                return (false);
            };
            if (_local_2.character_manager.hasTalentSkill("skill_1057"))
            {
                _local_5 = TalentSkillLevel.getTalentSkillLevels("skill_1057", _local_2.character_manager.getTalentLevel("skill_1057")).cooldown_chance;
                if (_local_5 >= NumberUtil.getRandomInt())
                {
                    _local_3 = true;
                };
            };
            var _local_4:* = this.checkTempForTalent(_arg_1);
            if (((_local_3) && (_local_4)))
            {
                _local_2.health_manager.createDisplay("Cooldown Reduction");
                return (true);
            };
            return (false);
        }

        public function getCpReductionBySenjutsu():Number
        {
            var _local_1:Object = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            var _local_2:int;
            if (_local_1.character_manager.hasSenjutsuSkill("skill_3101"))
            {
                _local_2 = (_local_2 + SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3101", _local_1.character_manager.getSenjutsuLevel("skill_3101")).reduce_cp_cost);
            };
            return (Math.round(_local_2));
        }

        public function getCooldownReduceMemekKuda(_arg_1:String):int
        {
            var _local_2:* = this.getCurrentModel();
            var _local_3:int;
            if (!_local_2.isCharacter())
            {
                return (_local_3);
            };
            var _local_4:Array = this.getPassiveSenjutsuSkills();
            var _local_5:Boolean;
            var _local_6:* = 0;
            while (_local_6 < _local_4.length)
            {
                if (_local_4[_local_6].item_id == "skill_3101")
                {
                    _local_3 = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3101", _local_2.character_manager.getSenjutsuLevel("skill_3101")).cooldown_decrease;
                    _local_5 = true;
                };
                _local_6++;
            };
            var _local_7:* = this.checkTempForSenjutsu(_arg_1);
            if (((_local_5) && (_local_7)))
            {
                _local_2.health_manager.createDisplay("Cooldown Reduction");
            }
            else
            {
                _local_3 = 0;
            };
            return (_local_3);
        }

        public function checkTempForSenjutsu(_arg_1:*):Boolean
        {
            var _local_2:* = this.getCurrentModel();
            var _local_3:Array = _local_2.character_manager.getEquippedSkills();
            var _local_4:Boolean;
            var _local_5:* = 0;
            while (_local_5 < this.cooldownListFromSenjutsu.length)
            {
                if ((((!(this.cooldownListFromSenjutsu[_local_5] == _arg_1)) && (!(this.tempt_skills_used_for_senjutsu[_local_5]))) && (this.cooldownListFromSenjutsu.indexOf(_arg_1) < 0)))
                {
                    _local_4 = true;
                };
                _local_5++;
            };
            if (_local_4)
            {
                this.cooldownListFromSenjutsu.push(_arg_1);
                this.tempt_skills_used_for_senjutsu.push(true);
            };
            return (_local_4);
        }

        public function checkTempForTalent(_arg_1:*):Boolean
        {
            var _local_2:* = this.getCurrentModel();
            var _local_3:Array = _local_2.character_manager.getEquippedSkills();
            var _local_4:Boolean;
            var _local_5:* = 0;
            while (_local_5 < this.cooldownListFromTalent.length)
            {
                if ((((!(this.cooldownListFromTalent[_local_5] == _arg_1)) && (!(this.tempt_skills_used_for_talent[_local_5]))) && (this.cooldownListFromTalent.indexOf(_arg_1) < 0)))
                {
                    _local_4 = true;
                };
                _local_5++;
            };
            if (_local_4)
            {
                this.cooldownListFromTalent.push(_arg_1);
                this.tempt_skills_used_for_talent.push(true);
            };
            return (_local_4);
        }

        public function getIncreaseChargeCPByEquippedSet():Number
        {
            var _local_6:*;
            var _local_1:Array;
            var _local_2:Array = this.getAllCharacterSetEffects();
            var _local_3:Number = 0;
            var _local_4:Array = ["charge_cp_bonus", "increase_cp_charge"];
            var _local_5:* = 0;
            while (_local_5 < _local_2.length)
            {
                _local_1 = _local_2[_local_5];
                _local_6 = 0;
                while (_local_6 < _local_1.length)
                {
                    if (Util.in_array(_local_1[_local_6].effect, _local_4))
                    {
                        _local_3 = (_local_3 + _local_1[_local_6].amount);
                    };
                    _local_6++;
                };
                _local_5++;
            };
            return (_local_3);
        }

        public function getIncreaseChargeCPByEffect():Number
        {
            var _local_3:Object;
            var _local_1:Object = this.getCurrentModel();
            var _local_2:int;
            if (_local_1.effects_manager.hadEffect("increase_charge_master"))
            {
                _local_3 = _local_1.effects_manager.getEffect("increase_charge_master");
                _local_2 = (_local_2 + _local_3.amount);
            };
            return (_local_2);
        }

        public function getDecreaseChargeCPByEffect():Number
        {
            var _local_1:* = this.getCurrentModel();
            var _local_2:Number = 0;
            var _local_3:* = _local_1.effects_manager;
            var _local_4:Array = _local_3.user_debuffs;
            var _local_5:Boolean = _local_3.hadEffect("decrease_charge");
            if (_local_5)
            {
                _local_2 = (_local_2 + _local_4["decrease_charge"].amount);
            };
            return (_local_2);
        }

        public function checkRecoverHPAfterCharge(_arg_1:int):*
        {
            var _local_2:Array;
            var _local_3:* = undefined;
            var _local_4:Array = this.getAllCharacterSetEffects();
            var _local_5:* = this.getCurrentModel();
            var _local_6:int = int(_local_5.health_manager.getMaxHP());
            var _local_7:int;
            var _local_8:* = 0;
            while (_local_8 < _local_4.length)
            {
                _local_2 = _local_4[_local_8];
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    if (((_local_2[_local_3].effect == "charge_hp_recover") || (_local_2[_local_3].effect == "increase_hp_charge")))
                    {
                        _local_7 = int(_local_2[_local_3].amount);
                        if (_local_2[_local_3].calc_type == "percent")
                        {
                            _local_7 = int(Math.floor(((_local_7 * _local_6) / 100)));
                        };
                    };
                    _local_3++;
                };
                _local_8++;
            };
            if (_local_7 > 0)
            {
                _local_5.health_manager.addHealth(_local_7, "Charge HP Recover +");
            };
        }

        public function checkAddHPAfterDodge():*
        {
            var _local_1:Array;
            var _local_2:* = undefined;
            var _local_3:Array = this.getAllCharacterSetEffects();
            var _local_4:* = this.getCurrentModel();
            var _local_5:* = _local_4.health_manager.getMaxHP();
            var _local_6:int;
            var _local_7:* = 0;
            while (_local_7 < _local_3.length)
            {
                _local_1 = _local_3[_local_7];
                _local_2 = 0;
                while (_local_2 < _local_1.length)
                {
                    if (_local_1[_local_2].effect == "recover_hp_after_dodge")
                    {
                        _local_6 = int(_local_1[_local_2].amount);
                        if (_local_1[_local_2].calc_type == "percent")
                        {
                            _local_6 = int(Math.floor(((_local_6 * _local_5) / 100)));
                        };
                    };
                    _local_2++;
                };
                _local_7++;
            };
            if (_local_6 > 0)
            {
                _local_4.health_manager.addHealth(_local_6, "HP Recover +");
            };
        }

        public function checkAddHealthAfterGotDebuff():*
        {
            var _local_1:Array;
            var _local_2:* = undefined;
            if (this.has_added_health_from_debuff)
            {
                return;
            };
            var _local_3:* = this.getCurrentModel();
            var _local_4:int;
            var _local_5:int = int(_local_3.health_manager.getMaxHP());
            var _local_6:Array = this.getAllCharacterSetEffects();
            var _local_7:* = 0;
            while (_local_7 < _local_6.length)
            {
                _local_1 = _local_6[_local_7];
                _local_2 = 0;
                while (_local_2 < _local_1.length)
                {
                    if (_local_1[_local_2].effect == "recover_hp_debuff")
                    {
                        if (_local_1[_local_2].calc_type == "percent")
                        {
                            _local_4 = int((_local_4 + Math.floor(((_local_5 * _local_1[_local_2].amount) / 100))));
                        }
                        else
                        {
                            _local_4 = (_local_4 + _local_1[_local_2].amount);
                        };
                        this.has_added_health_from_debuff = true;
                    };
                    if (_local_1[_local_2].effect == "recover_hp_cp_debuff")
                    {
                        if (_local_1[_local_2].calc_type == "percent")
                        {
                            _local_4 = int((_local_4 + Math.floor(((_local_5 * _local_1[_local_2].amount) / 100))));
                        }
                        else
                        {
                            _local_4 = (_local_4 + _local_1[_local_2].amount);
                        };
                        this.has_added_health_from_debuff = true;
                    };
                    _local_2++;
                };
                _local_7++;
            };
            if (_local_4)
            {
                _local_3.health_manager.addHealth(_local_4, "Recovered HP +");
            };
        }

        public function checkAddCPAfterGotDebuff():*
        {
            var _local_1:Array;
            var _local_2:* = undefined;
            if (this.has_added_cp_from_debuff)
            {
                return;
            };
            var _local_3:* = this.getCurrentModel();
            var _local_4:int;
            var _local_5:int = int(_local_3.health_manager.getMaxCP());
            var _local_6:Array = this.getAllCharacterSetEffects();
            var _local_7:* = 0;
            while (_local_7 < _local_6.length)
            {
                _local_1 = _local_6[_local_7];
                _local_2 = 0;
                while (_local_2 < _local_1.length)
                {
                    if (_local_1[_local_2].effect == "recover_cp_debuff")
                    {
                        if (_local_1[_local_2].calc_type == "percent")
                        {
                            _local_4 = int((_local_4 + Math.floor(((_local_5 * _local_1[_local_2].amount) / 100))));
                        }
                        else
                        {
                            _local_4 = (_local_4 + _local_1[_local_2].amount);
                        };
                        this.has_added_cp_from_debuff = true;
                    };
                    if (_local_1[_local_2].effect == "recover_hp_cp_debuff")
                    {
                        if (_local_1[_local_2].calc_type == "percent")
                        {
                            _local_4 = int((_local_4 + Math.floor(((_local_5 * _local_1[_local_2].amount) / 100))));
                        }
                        else
                        {
                            _local_4 = (_local_4 + _local_1[_local_2].amount);
                        };
                        this.has_added_cp_from_debuff = true;
                    };
                    _local_2++;
                };
                _local_7++;
            };
            if (_local_4)
            {
                _local_3.health_manager.addCP(_local_4, "Recovered CP +");
            };
        }

        public function checkAddHealthAfterGotBuff():*
        {
            var _local_1:Array;
            var _local_2:* = undefined;
            if (this.has_added_health_from_buff)
            {
                return;
            };
            var _local_3:* = this.getCurrentModel();
            var _local_4:int;
            var _local_5:int = int(_local_3.health_manager.getMaxHP());
            var _local_6:Array = this.getAllCharacterSetEffects();
            var _local_7:* = 0;
            while (_local_7 < _local_6.length)
            {
                _local_1 = _local_6[_local_7];
                _local_2 = 0;
                while (_local_2 < _local_1.length)
                {
                    if (_local_1[_local_2].effect == "recover_hp_buff")
                    {
                        if (_local_1[_local_2].calc_type == "percent")
                        {
                            _local_4 = int((_local_4 + Math.floor(((_local_5 * _local_1[_local_2].amount) / 100))));
                        }
                        else
                        {
                            _local_4 = (_local_4 + _local_1[_local_2].amount);
                        };
                        this.has_added_health_from_buff = true;
                    };
                    if (_local_1[_local_2].effect == "recover_hp_cp_buff")
                    {
                        if (_local_1[_local_2].calc_type == "percent")
                        {
                            _local_4 = int((_local_4 + Math.floor(((_local_5 * _local_1[_local_2].amount) / 100))));
                        }
                        else
                        {
                            _local_4 = (_local_4 + _local_1[_local_2].amount);
                        };
                        this.has_added_health_from_buff = true;
                    };
                    _local_2++;
                };
                _local_7++;
            };
            if (_local_4)
            {
                _local_3.health_manager.addHealth(_local_4, "Recovered HP +");
            };
        }

        public function checkAddCPAfterGotBuff():*
        {
            var _local_1:Array;
            var _local_2:* = undefined;
            if (this.has_added_cp_from_buff)
            {
                return;
            };
            var _local_3:* = this.getCurrentModel();
            var _local_4:int;
            var _local_5:int = int(_local_3.health_manager.getMaxCP());
            var _local_6:Array = this.getAllCharacterSetEffects();
            var _local_7:* = 0;
            while (_local_7 < _local_6.length)
            {
                _local_1 = _local_6[_local_7];
                _local_2 = 0;
                while (_local_2 < _local_1.length)
                {
                    if (_local_1[_local_2].effect == "recover_cp_buff")
                    {
                        if (_local_1[_local_2].calc_type == "percent")
                        {
                            _local_4 = int((_local_4 + Math.floor(((_local_5 * _local_1[_local_2].amount) / 100))));
                        }
                        else
                        {
                            _local_4 = (_local_4 + _local_1[_local_2].amount);
                        };
                        this.has_added_cp_from_buff = true;
                    };
                    if (_local_1[_local_2].effect == "recover_hp_cp_buff")
                    {
                        if (_local_1[_local_2].calc_type == "percent")
                        {
                            _local_4 = int((_local_4 + Math.floor(((_local_5 * _local_1[_local_2].amount) / 100))));
                        }
                        else
                        {
                            _local_4 = (_local_4 + _local_1[_local_2].amount);
                        };
                        this.has_added_cp_from_buff = true;
                    };
                    _local_2++;
                };
                _local_7++;
            };
            if (_local_4)
            {
                _local_3.health_manager.addCP(_local_4, "Recovered CP +");
            };
        }

        public function getAllCharacterSetEffects():Array
        {
            var _local_1:Boolean = this.hadEffect("disable_weapon_effect");
            if (((this.allSetEffects.length < 1) || (!(_local_1 == this.lastDisableWeaponState))))
            {
                if (_local_1)
                {
                    this.allSetEffects = [this.getCharacterBackItemEffects(), this.getCharacterAccessoryEffects()];
                }
                else
                {
                    this.allSetEffects = [this.getCharacterWeaponEffects(), this.getCharacterBackItemEffects(), this.getCharacterAccessoryEffects()];
                };
                this.lastDisableWeaponState = _local_1;
            };
            return (this.allSetEffects);
        }

        private function getSetEffects():Array
        {
            var _local_1:Array = this.getCharacterWeaponEffects().concat(this.getCharacterBackItemEffects()).concat(this.getCharacterAccessoryEffects());
            return ((_local_1.length > 0) ? _local_1 : []);
        }

        public function getCharacterWeaponEffects():*
        {
            var effect:* = undefined;
            var wpnId:String;
            if (this.hadEffect("disable_weapon_effect"))
            {
                return ([]);
            };
            var charMc:* = this.getCurrentModel();
            try
            {
                wpnId = String(charMc.character_manager.getWeapon());
                effect = ((WeaponBuffs.getCopy(wpnId).effects == null) ? [] : WeaponBuffs.getCopy(wpnId).effects);
                return (effect);
            }
            catch(e)
            {
                return ([]);
            };
        }

        public function getCharacterBackItemEffects():*
        {
            var effect:* = undefined;
            var backItemId:String;
            var charMc:* = this.getCurrentModel();
            try
            {
                backItemId = String(charMc.character_manager.getBackItem());
                effect = ((BackItemBuffs.getCopy(backItemId).effects == null) ? [] : BackItemBuffs.getCopy(backItemId).effects);
                return (effect);
            }
            catch(e)
            {
                return ([]);
            };
        }

        public function getCharacterAccessoryEffects():*
        {
            var effect:* = undefined;
            var accId:String;
            var charMc:* = this.getCurrentModel();
            try
            {
                accId = String(charMc.character_manager.getAccessory());
                effect = ((AccessoryBuffs.getCopy(accId).effects == null) ? [] : AccessoryBuffs.getCopy(accId).effects);
                return (effect);
            }
            catch(e)
            {
                return ([]);
            };
        }

        public function isBurnImmune():Boolean
        {
            var _local_1:Array;
            var _local_2:* = undefined;
            var _local_3:Array = this.getAllCharacterSetEffects();
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4];
                _local_2 = 0;
                while (_local_2 < _local_1.length)
                {
                    if (((_local_1[_local_2].effect == "burn_protection") || (_local_1[_local_2].effect == "immune_burn")))
                    {
                        return (true);
                    };
                    _local_2++;
                };
                _local_4++;
            };
            return (false);
        }

        public function increaseRecoverByEffects(_arg_1:int, _arg_2:String):int
        {
            var _local_3:Array;
            var _local_9:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:Array = this.getAllCharacterSetEffects();
            var _local_7:Object = this.checkIncreaseRecoverItemFromTalent();
            if (_local_7 != null)
            {
                _local_9 = 0;
                while (_local_9 < _local_7.length)
                {
                    if (((_local_7[_local_9].effect == "item_restore_hp_bonus") && (_arg_2 == "hp")))
                    {
                        _local_5 = int(Math.floor(((_arg_1 * _local_7[_local_9].amount) / 100)));
                        _arg_1 = (_arg_1 + _local_5);
                    };
                    if (((_local_7[_local_9].effect == "item_restore_cp_bonus") && (_arg_2 == "cp")))
                    {
                        _local_5 = int(Math.floor(((_arg_1 * _local_7[_local_9].amount) / 100)));
                        _arg_1 = (_arg_1 + _local_5);
                    };
                    _local_9++;
                };
            };
            var _local_8:* = 0;
            while (_local_8 < _local_6.length)
            {
                _local_3 = _local_6[_local_8];
                _local_4 = 0;
                while (_local_4 < _local_3.length)
                {
                    if (((_local_3[_local_4].effect == "item_restore_hp_bonus") && (_arg_2 == "hp")))
                    {
                        _local_5 = int(Math.floor(((_arg_1 * _local_3[_local_4].amount) / 100)));
                        _arg_1 = (_arg_1 + _local_5);
                    };
                    if (((_local_3[_local_4].effect == "item_restore_cp_bonus") && (_arg_2 == "cp")))
                    {
                        _local_5 = int(Math.floor(((_arg_1 * _local_3[_local_4].amount) / 100)));
                        _arg_1 = (_arg_1 + _local_5);
                    };
                    _local_4++;
                };
                _local_8++;
            };
            return (_arg_1);
        }

        public function handleLightMatter():Boolean
        {
            var _local_1:Object = this.getCurrentModel();
            var _local_2:Number = 0;
            if (!_local_1.isCharacter())
            {
                return (false);
            };
            if (_local_1.character_manager.hasTalentSkill("skill_1113"))
            {
                _local_2 = TalentSkillLevel.getTalentSkillLevels("skill_1113", _local_1.character_manager.getTalentLevel("skill_1113")).internal_injury_chance;
            };
            return (NumberUtil.getChance(_local_2));
        }

        public function handleDarkMatter():Boolean
        {
            var _local_1:Object = this.getCurrentModel();
            var _local_2:Number = 0;
            if (!_local_1.isCharacter())
            {
                return (false);
            };
            if (_local_1.character_manager.hasTalentSkill("skill_1116"))
            {
                _local_2 = TalentSkillLevel.getTalentSkillLevels("skill_1116", _local_1.character_manager.getTalentLevel("skill_1116")).disable_chance;
            };
            return (NumberUtil.getChance(_local_2));
        }

        public function checkDecreaseDamageFromOnmyouji(_arg_1:Object):Number
        {
            var _local_2:Number = 0;
            if (_arg_1.character_manager.hasTalentSkill("skill_1014"))
            {
                _local_2 = (_local_2 + TalentSkillLevel.getTalentSkillLevels("skill_1014", _arg_1.character_manager.getTalentLevel("skill_1014")).reduce_damage_taken);
            };
            return (_local_2);
        }

        public function checkDecreaseDamageFromOrochi(_arg_1:Object):Number
        {
            var _local_2:Number = 0;
            if (_arg_1.character_manager.hasTalentSkill("skill_1024"))
            {
                _local_2 = (_local_2 + TalentSkillLevel.getTalentSkillLevels("skill_1024", _arg_1.character_manager.getTalentLevel("skill_1024")).reduce_damage_taken);
            };
            return (_local_2);
        }

        public function checkDecreaseDamageFromCarapace(_arg_1:Object):Number
        {
            var _local_2:Number = 0;
            if (_arg_1.character_manager.hasTalentSkill("skill_1051"))
            {
                _local_2 = (_local_2 + TalentSkillLevel.getTalentSkillLevels("skill_1051", _arg_1.character_manager.getTalentLevel("skill_1051")).reduce_damage_taken);
            };
            return (_local_2);
        }

        public function checkIncreaseDamageFromChakraConvergence(_arg_1:Object):Number
        {
            var _local_2:Number = 0;
            if (_arg_1.character_manager.hasTalentSkill("skill_1058"))
            {
                _local_2 = (_local_2 + TalentSkillLevel.getTalentSkillLevels("skill_1058", _arg_1.character_manager.getTalentLevel("skill_1058")).amount);
            };
            if (_local_2 > 0)
            {
                _local_2 = Math.floor(((_arg_1.health_manager.temp_skill_cp_cost * _local_2) / 100));
            };
            return (_local_2);
        }

        public function checkIncreaseDamageFromUltimateEvolution(_arg_1:Object):Number
        {
            var _local_3:*;
            var _local_2:Number = 0;
            if (_arg_1.character_manager.hasTalentSkill("skill_1055"))
            {
                _local_3 = _arg_1.health_manager.getMaxCP();
                _local_2 = (_local_2 + TalentSkillLevel.getTalentSkillLevels("skill_1055", _arg_1.character_manager.getTalentLevel("skill_1055")).increase_damage);
                _local_2 = Math.round(((_local_3 * _local_2) / 100));
            };
            return (_local_2);
        }

        public function checkIncreaseDamageFromMarionette(_arg_1:Object):Number
        {
            var _local_2:Number = 0;
            if (_arg_1.character_manager.hasTalentSkill("skill_1102"))
            {
                _local_2 = (_local_2 + TalentSkillLevel.getTalentSkillLevels("skill_1102", _arg_1.character_manager.getTalentLevel("skill_1102")).increase_damage);
            };
            return (_local_2);
        }

        public function checkIncreaseDamageFromExtrimities(_arg_1:Object):Number
        {
            var _local_2:Number = 0;
            if (_arg_1.character_manager.hasTalentSkill("skill_1001"))
            {
                _local_2 = (_local_2 + TalentSkillLevel.getTalentSkillLevels("skill_1001", _arg_1.character_manager.getTalentLevel("skill_1001")).amount_increase);
            };
            return (_local_2);
        }

        public function checkIncreaseDamageFromExplosiveLava(_arg_1:Object):Number
        {
            var _local_2:Number = 0;
            if (_arg_1.character_manager.hasTalentSkill("skill_1039"))
            {
                _local_2 = (_local_2 + TalentSkillLevel.getTalentSkillLevels("skill_1039", _arg_1.character_manager.getTalentLevel("skill_1039")).amount);
            };
            return (_local_2);
        }

        public function checkIncreaseDamageFromMountainFlavor(_arg_1:Object):Number
        {
            var _local_3:Object;
            var _local_2:Number = 0;
            if (_arg_1.character_manager.hasSenjutsuSkill("skill_3001"))
            {
                _local_3 = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3001", _arg_1.character_manager.getSenjutsuLevel("skill_3001"));
                _local_2 = (_local_2 + _local_3.increase_damage);
            };
            return (_local_2);
        }

        private function getPassiveEffect():*
        {
            var _local_1:Array = [];
        }

        private function getActiveEffect():*
        {
            var _local_1:Array = [];
        }

        private function getCriticalEffect():*
        {
            var _local_1:Array = [];
        }

        public function calculateDamage(_arg_1:int, _arg_2:Object, _arg_3:Boolean=false):int
        {
            _arg_1 = this.increaseDamage(_arg_1, _arg_2, _arg_3);
            _arg_1 = this.increaseFromPassiveEffects_Clan(_arg_1, this.getCurrentModel());
            _arg_1 = this.calculateCriticalDamage(_arg_1);
            return (this.decreaseDamage(_arg_1, _arg_2));
        }

        public function increaseDamage(_arg_1:int, _arg_2:Object, _arg_3:Boolean=false):int
        {
            var _local_8:int;
            var _local_9:Object;
            var _local_10:Object;
            var _local_11:Object;
            var _local_12:Object;
            var _local_13:int;
            var _local_14:Array;
            var _local_15:int;
            var _local_16:Array;
            var _local_17:int;
            var _local_18:Array;
            var _local_19:int;
            var _local_20:Array;
            var _local_21:int;
            var _local_22:Array;
            var _local_23:int;
            var _local_24:int;
            var _local_4:Object = this.getCurrentModel();
            var _local_5:int = this.increaseDamageFromPassive_Buff(_local_4).additive;
            var _local_6:Array = this.increaseDamageFromPassive_Buff(_local_4).multiplicative;
            _arg_1 = (_arg_1 + _local_5);
            var _local_7:int = 1;
            for each (_local_8 in _local_6)
            {
                _arg_1 = int((_arg_1 + Math.round(((_arg_1 * _local_8) / 100))));
                _local_7++;
            };
            _local_9 = this.increaseDamageFromActive_Buff_Attacker(_local_4);
            _local_10 = this.increaseDamageFromActive_Buff_Defender(_arg_2);
            _local_11 = this.increaseDamageFromActive_Debuff_Attacker(_local_4);
            _local_12 = this.increaseDamageFromActive_Debuff_Defender(_arg_2);
            _local_13 = _local_9.additive;
            _local_14 = _local_9.multiplicative;
            _local_15 = _local_10.additive;
            _local_16 = _local_10.multiplicative;
            _local_17 = _local_11.additive;
            _local_18 = _local_11.multiplicative;
            _local_19 = _local_12.additive;
            _local_20 = _local_12.multiplicative;
            _local_21 = (((_local_13 + _local_15) + _local_17) + _local_19);
            _local_22 = _local_14.concat(_local_16).concat(_local_18).concat(_local_20);
            _arg_1 = (_arg_1 + _local_21);
            _local_23 = 1;
            for each (_local_24 in _local_22)
            {
                _arg_1 = int((_arg_1 + Math.round(((_arg_1 * _local_24) / 100))));
                _local_23++;
            };
            return (_arg_1);
        }

        private function calculateCriticalDamage(_arg_1:int):int
        {
            var _local_6:Object;
            var _local_8:Object;
            var _local_9:int;
            var _local_10:int;
            if (!BattleVars.IS_CRITICAL)
            {
                return (_arg_1);
            };
            var _local_2:Object = this.getCurrentModel();
            var _local_3:int = 50;
            var _local_4:int = _local_3;
            var _local_5:int;
            if (this.hadEffect("decrease_critical_damage"))
            {
                _local_6 = this.getEffect("decrease_critical_damage");
                if (((_local_6) && (_local_6.amount)))
                {
                    _local_4 = (_local_4 - _local_6.amount);
                };
            };
            if (this.hadEffect("critical_buff_n_received_stun"))
            {
                _local_6 = this.getEffect("critical_buff_n_received_stun");
                if (((_local_6) && (_local_6.amount)))
                {
                    _local_4 = (_local_4 + _local_6.amount);
                };
            };
            if (this.hadEffect("pet_mortal"))
            {
                _local_6 = this.getEffect("pet_mortal");
                if (((_local_6) && (_local_6.amount)))
                {
                    _local_4 = (_local_4 + _local_6.amount);
                };
            };
            if (_local_2.isCharacter())
            {
                _local_8 = _local_2.character_manager;
                _local_4 = (_local_4 + Math.round((_local_8.getLightningAttributes() * 0.8)));
                _local_9 = this.getIncreaseCriticalByPassiveEffects("percent");
                _local_10 = this.getIncreaseCriticalByPassiveEffects("number");
                _local_4 = (_local_4 + Math.round(_local_9));
                _local_5 = (_local_5 + Math.round(_local_10));
            };
            var _local_7:Number = (1 + (_local_4 / 100));
            return (Math.round(((_arg_1 * _local_7) + _local_5)));
        }

        private function increaseFromPassiveEffects_Clan(_arg_1:int, _arg_2:Object):int
        {
            if (!_arg_2.isCharacter())
            {
                return (_arg_1);
            };
            if (BattleManager.BATTLE_VARS.BATTLE_MODE != "CLAN")
            {
                return (_arg_1);
            };
            var _local_3:* = _arg_2.characterClanData;
            return (Math.round(((_local_3.training_hall * 0.3) + int(1))) * _arg_1);
        }

        private function increaseFromPassiveEffects_Element_Multiplicative(_arg_1:Object):Array
        {
            var _local_2:Array = [];
            var _local_3:int = BattleVars.SKILL_USED_TYPE;
            var _local_4:Object = _arg_1.character_manager;
            var _local_5:Number = (0.4 * _local_4.getFireAttributes());
            _local_2.push(_local_5);
            switch (_local_3)
            {
                case 1:
                    _local_2.push(_local_4.getWindAttributes());
                    break;
                case 2:
                    _local_2.push(_local_4.getFireAttributes());
                    break;
                case 3:
                    _local_2.push(_local_4.getLightningAttributes());
                    break;
                case 4:
                    _local_2.push(_local_4.getEarthAttributes());
                    break;
                case 5:
                    _local_2.push(_local_4.getWaterAttributes());
                    break;
            };
            return (_local_2);
        }

        private function increaseFromPassiveEffects_Gear_Additive(_arg_1:Object):int
        {
            var _local_5:Array;
            var _local_6:Object;
            var _local_2:Array = _arg_1.effects_manager.getPassiveEffect();
            var _local_3:Array = _arg_1.effects_manager.getAllCharacterSetEffects();
            var _local_4:int;
            for each (_local_5 in _local_3)
            {
                for each (_local_6 in _local_5)
                {
                    if (((_local_6.calc_type == "number") && (_local_6.effect == "damage_increase")))
                    {
                        _local_4 = (_local_4 + _local_6.amount);
                    }
                    else
                    {
                        if (_local_6.effect == "power_up_by_hp")
                        {
                            _local_4 = (_local_4 + this.applyPowerUpByHP(_arg_1, _local_6));
                        };
                    };
                };
            };
            return (_local_4);
        }

        private function decreaseFromPassiveEffects_Gear_Additive(_arg_1:Object):int
        {
            var _local_5:Array;
            var _local_6:Object;
            var _local_2:Array = _arg_1.effects_manager.getPassiveEffect();
            var _local_3:Array = _arg_1.effects_manager.getAllCharacterSetEffects();
            var _local_4:int;
            for each (_local_5 in _local_3)
            {
                for each (_local_6 in _local_5)
                {
                    if (((_local_6.calc_type == "number") && (_local_6.effect == "damage_reduce")))
                    {
                        _local_4 = (_local_4 + _local_6.amount);
                    };
                };
            };
            return (_local_4);
        }

        private function increaseFromPassiveEffects_Gear_Multiplicative(_arg_1:Object):Array
        {
            var _local_4:Array;
            var _local_5:Object;
            var _local_2:Array = _arg_1.effects_manager.getAllCharacterSetEffects();
            var _local_3:Array = [];
            for each (_local_4 in _local_2)
            {
                for each (_local_5 in _local_4)
                {
                    if ((((_local_5.calc_type == "percent") && (!(_local_5.effect == "power_up_by_hp"))) && (_local_5.effect == "damage_increase")))
                    {
                        _local_3.push(_local_5.amount);
                    };
                };
            };
            return (_local_3);
        }

        private function decreaseFromPassiveEffects_Gear_Multiplicative(_arg_1:Object):Array
        {
            var _local_4:Array;
            var _local_5:Object;
            var _local_2:Array = _arg_1.effects_manager.getAllCharacterSetEffects();
            var _local_3:Array = [];
            for each (_local_4 in _local_2)
            {
                for each (_local_5 in _local_4)
                {
                    if (((_local_5.calc_type == "percent") && (_local_5.effect == "damage_reduce")))
                    {
                        _local_3.push(_local_5.amount);
                    };
                };
            };
            return (_local_3);
        }

        private function increaseFromPassiveEffects_Talent_Additive(_arg_1:Object):int
        {
            var _local_2:int;
            _local_2 = (_local_2 + _arg_1.effects_manager.checkIncreaseDamageFromChakraConvergence(_arg_1));
            return (_local_2 + _arg_1.effects_manager.checkIncreaseDamageFromUltimateEvolution(_arg_1));
        }

        private function decreaseFromPassiveEffects_Talent_Additive(_arg_1:Object):int
        {
            return (0);
        }

        private function increaseFromPassiveEffects_Talent_Multiplicative(_arg_1:Object):Array
        {
            var _local_2:Array = [];
            var _local_3:int = _arg_1.effects_manager.checkIncreaseDamageFromMarionette(_arg_1);
            if (_local_3 > 0)
            {
                _local_2.push(_local_3);
            };
            if (((BattleVars.SKILL_USED_TYPE == 6) || ((BattleVars.SKILL_USED_ID.split("_")[1] >= 1000) && (int(BattleVars.SKILL_USED_ID.split("_")[1]) <= 1005))))
            {
                _local_2.push(_arg_1.effects_manager.checkIncreaseDamageFromExtrimities(_arg_1));
            };
            if (((BattleVars.SKILL_USED_TYPE == 2) || (BattleVars.SKILL_USED_TYPE == 4)))
            {
                _local_2.push(_arg_1.effects_manager.checkIncreaseDamageFromExplosiveLava(_arg_1));
            };
            return (_local_2);
        }

        private function decreaseFromPassiveEffects_Talent_Multiplicative(_arg_1:Object):Array
        {
            var _local_2:Array = [];
            var _local_3:int = _arg_1.effects_manager.checkDecreaseDamageFromOnmyouji(_arg_1);
            var _local_4:int = _arg_1.effects_manager.checkDecreaseDamageFromOrochi(_arg_1);
            var _local_5:int = _arg_1.effects_manager.checkDecreaseDamageFromCarapace(_arg_1);
            if (_local_3 > 0)
            {
                _local_2.push(_local_3);
            };
            if (_local_4 > 0)
            {
                _local_2.push(_local_4);
            };
            if (_local_5 > 0)
            {
                _local_2.push(_local_5);
            };
            return (_local_2);
        }

        private function increaseFromPassiveEffects_Senjutsu_Additive(_arg_1:Object):int
        {
            return (0);
        }

        private function decreaseFromPassiveEffects_Senjutsu_Additive(_arg_1:Object):int
        {
            return (0);
        }

        private function increaseFromPassiveEffects_Senjutsu_Multiplicative(_arg_1:Object):Array
        {
            var _local_2:Array = [];
            _local_2.push(this.checkIncreaseDamageFromMountainFlavor(_arg_1));
            return (_local_2);
        }

        private function decreaseFromPassiveEffects_Senjutsu_Multiplicative(_arg_1:Object):Array
        {
            return ([]);
        }

        private function increaseDamageFromPassive_Buff(_arg_1:Object):Object
        {
            var _local_2:int;
            var _local_3:Array = [];
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:Array = [];
            var _local_8:Array = [];
            var _local_9:Array = [];
            var _local_10:Array = [];
            if (_arg_1.isCharacter())
            {
                _local_4 = this.increaseFromPassiveEffects_Gear_Additive(_arg_1);
                _local_5 = this.increaseFromPassiveEffects_Talent_Additive(_arg_1);
                _local_6 = this.increaseFromPassiveEffects_Senjutsu_Additive(_arg_1);
                _local_7 = this.increaseFromPassiveEffects_Element_Multiplicative(_arg_1);
                _local_8 = this.increaseFromPassiveEffects_Gear_Multiplicative(_arg_1);
                _local_9 = this.increaseFromPassiveEffects_Talent_Multiplicative(_arg_1);
                _local_10 = this.increaseFromPassiveEffects_Senjutsu_Multiplicative(_arg_1);
            };
            _local_2 = ((_local_4 + _local_5) + _local_6);
            _local_3 = _local_7.concat(_local_8).concat(_local_9).concat(_local_10);
            return ({
                "additive":_local_2,
                "multiplicative":_local_3
            });
        }

        private function decreaseDamageFromPassive_Buff(_arg_1:Object):Object
        {
            var _local_2:int;
            var _local_3:Array = [];
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:Array = [];
            var _local_8:Array = [];
            var _local_9:Array = [];
            if (_arg_1.isCharacter())
            {
                _local_4 = this.decreaseFromPassiveEffects_Gear_Additive(_arg_1);
                _local_5 = this.decreaseFromPassiveEffects_Talent_Additive(_arg_1);
                _local_6 = this.decreaseFromPassiveEffects_Senjutsu_Additive(_arg_1);
                _local_7 = this.decreaseFromPassiveEffects_Gear_Multiplicative(_arg_1);
                _local_8 = this.decreaseFromPassiveEffects_Talent_Multiplicative(_arg_1);
                _local_9 = this.decreaseFromPassiveEffects_Senjutsu_Multiplicative(_arg_1);
            };
            _local_2 = ((_local_4 + _local_5) + _local_6);
            _local_3 = _local_7.concat(_local_8).concat(_local_9);
            return ({
                "additive":_local_2,
                "multiplicative":_local_3
            });
        }

        private function increaseDamageFromActive_Buff_Attacker(_arg_1:Object):Object
        {
            var _local_6:Object;
            var _local_7:Boolean;
            var _local_8:Boolean;
            var _local_2:Array = ["solar_might", "kyubi_cloak", "dodge_damage_bonus", "tolerance", "shukaku_blessing", "rampage", "extreme_mode", "senjutsu_strengthen", "sage_mode", "invincible", "unyielding", "pet_frenzy", "power_up", "inquisitor", "domain_expansion", "strengthen", "strengthen_special", "pet_strengthen", "stealth", "rage", "taijutsu_strengthen", "pet_lightning_armor", "lightning_armor", "power_up_battle"];
            var _local_3:Array = _arg_1.effects_manager.getActiveEffects();
            var _local_4:int;
            var _local_5:Array = [];
            for each (_local_6 in _local_3)
            {
                if (_local_2.indexOf(_local_6.effect) != -1)
                {
                    switch (_local_6.effect)
                    {
                        case "senjutsu_strengthen":
                            _local_4 = int((_local_4 + Math.round(((_arg_1.health_manager.getMaxSP() * _local_6.amount) / 100))));
                            break;
                        case "extreme_mode":
                            _local_7 = (BattleVars.SKILL_USED_TYPE == 6);
                            _local_8 = ((BattleVars.SKILL_USED_ID.split("_")[1] >= 1000) && (int(BattleVars.SKILL_USED_ID.split("_")[1]) <= 1005));
                            if (((_local_7 == false) && (_local_8 == false))) break;
                            _local_5.push(_local_6.amount);
                            break;
                        default:
                            if (_local_6.calc_type == "number")
                            {
                                _local_4 = (_local_4 + _local_6.amount);
                            }
                            else
                            {
                                if (_local_6.calc_type == "percent")
                                {
                                    _local_5.push(_local_6.amount);
                                };
                            };
                    };
                };
            };
            return ({
                "additive":_local_4,
                "multiplicative":_local_5
            });
        }

        private function increaseDamageFromActive_Buff_Defender(_arg_1:Object):Object
        {
            var _local_6:Object;
            var _local_2:Array = ["rage"];
            var _local_3:Array = _arg_1.effects_manager.getActiveEffects();
            var _local_4:int;
            var _local_5:Array = [];
            for each (_local_6 in _local_3)
            {
                if (_local_2.indexOf(_local_6.effect) != -1)
                {
                    if (_local_6.calc_type == "number")
                    {
                        _local_4 = (_local_4 + _local_6.amount);
                    }
                    else
                    {
                        if (_local_6.calc_type == "percent")
                        {
                            _local_5.push(_local_6.amount);
                        };
                    };
                };
            };
            return ({
                "additive":_local_4,
                "multiplicative":_local_5
            });
        }

        private function decreaseDamageFromActive_Buff_Attacker(_arg_1:Object):Object
        {
            var _local_6:Object;
            var _local_2:Array = ["none"];
            var _local_3:Array = _arg_1.effects_manager.getActiveEffects();
            var _local_4:int;
            var _local_5:Array = [];
            for each (_local_6 in _local_3)
            {
                if (_local_2.indexOf(_local_6.effect) != -1)
                {
                    if (_local_6.calc_type == "number")
                    {
                        _local_4 = (_local_4 + _local_6.amount);
                    }
                    else
                    {
                        if (_local_6.calc_type == "percent")
                        {
                            _local_5.push(_local_6.amount);
                        };
                    };
                };
            };
            return ({
                "additive":_local_4,
                "multiplicative":_local_5
            });
        }

        private function decreaseDamageFromActive_Buff_Defender(_arg_1:Object):Object
        {
            var _local_6:Object;
            var _local_2:Array = ["emberstep_demonic", "preservation", "tolerance", "wolfram", "invincible", "unyielding", "self_love", "protection", "pet_protection", "stealth", "guard", "pet_guard", "plus_protection"];
            var _local_3:Array = _arg_1.effects_manager.getActiveEffects();
            var _local_4:int;
            var _local_5:Array = [];
            for each (_local_6 in _local_3)
            {
                if (_local_2.indexOf(_local_6.effect) != -1)
                {
                    switch (_local_6.effect)
                    {
                        case "stealth":
                            if (_local_6.calc_type == "percent")
                            {
                                _local_5.push(_local_6.amount_protection);
                            }
                            else
                            {
                                _local_4 = (_local_4 + _local_6.amount_protection);
                            };
                            break;
                        case "plus_protection":
                            if (_local_6.new_amount == undefined) break;
                            if (_local_6.calc_type == "percent")
                            {
                                _local_5.push(_local_6.new_amount);
                            }
                            else
                            {
                                _local_4 = (_local_4 + _local_6.new_amount);
                            };
                            break;
                        default:
                            if (_local_6.calc_type == "number")
                            {
                                _local_4 = (_local_4 + _local_6.amount);
                            }
                            else
                            {
                                if (_local_6.calc_type == "percent")
                                {
                                    _local_5.push(_local_6.amount);
                                };
                            };
                    };
                };
            };
            return ({
                "additive":_local_4,
                "multiplicative":_local_5
            });
        }

        private function increaseDamageFromActive_Debuff_Attacker(_arg_1:Object):Object
        {
            var _local_6:Object;
            var _local_2:Array = ["none"];
            var _local_3:Array = _arg_1.effects_manager.getActiveEffects();
            var _local_4:int;
            var _local_5:Array = [];
            for each (_local_6 in _local_3)
            {
                if (_local_2.indexOf(_local_6.effect) != -1)
                {
                    if (_local_6.calc_type == "number")
                    {
                        _local_4 = (_local_4 + _local_6.amount);
                    }
                    else
                    {
                        if (_local_6.calc_type == "percent")
                        {
                            _local_5.push(_local_6.amount);
                        };
                    };
                };
            };
            return ({
                "additive":_local_4,
                "multiplicative":_local_5
            });
        }

        private function increaseDamageFromActive_Debuff_Defender(_arg_1:Object):Object
        {
            var _local_6:Object;
            var _local_2:Array = ["chill", "bleeding", "pet_bleeding", "vulnerable", "expose_defence"];
            var _local_3:Array = _arg_1.effects_manager.getActiveEffects();
            var _local_4:int;
            var _local_5:Array = [];
            for each (_local_6 in _local_3)
            {
                if (_local_2.indexOf(_local_6.effect) != -1)
                {
                    switch (_local_6.effect)
                    {
                        case "chill":
                            _local_5.push(80);
                            break;
                        case "petrify":
                            _local_5.push(100);
                            break;
                        default:
                            if (_local_6.calc_type == "number")
                            {
                                _local_4 = (_local_4 + _local_6.amount);
                            }
                            else
                            {
                                if (_local_6.calc_type == "percent")
                                {
                                    _local_5.push(_local_6.amount);
                                };
                            };
                    };
                };
            };
            return ({
                "additive":_local_4,
                "multiplicative":_local_5
            });
        }

        private function decreaseDamageFromActive_Debuff_Attacker(_arg_1:Object):Object
        {
            var _local_6:Object;
            var _local_2:Array = ["holdback", "infection", "vulnerable", "weaken", "pet_weaken", "ecstasy", "pet_ecstasy", "dark_curse", "embrace"];
            var _local_3:Array = _arg_1.effects_manager.getActiveEffects();
            var _local_4:int;
            var _local_5:Array = [];
            for each (_local_6 in _local_3)
            {
                if (_local_2.indexOf(_local_6.effect) != -1)
                {
                    switch (_local_6.effect)
                    {
                        case "infection":
                            _local_5.push(_local_6.amount_reduce);
                            break;
                        case "petrify":
                            _local_5.push(100);
                            break;
                        default:
                            if (_local_6.calc_type == "number")
                            {
                                _local_4 = (_local_4 + _local_6.amount);
                            }
                            else
                            {
                                if (_local_6.calc_type == "percent")
                                {
                                    _local_5.push(_local_6.amount);
                                };
                            };
                    };
                };
            };
            return ({
                "additive":_local_4,
                "multiplicative":_local_5
            });
        }

        private function decreaseDamageFromActive_Debuff_Defender(_arg_1:Object):Object
        {
            var _local_6:Object;
            var _local_2:Array = ["preservation", "petrify", "frozen", "chill", "tolerance", "wolfram", "invincible", "unyielding", "self_love", "protection", "pet_protection", "stealth", "guard", "pet_guard", "plus_protection"];
            var _local_3:Array = _arg_1.effects_manager.getActiveEffects();
            var _local_4:int;
            var _local_5:Array = [];
            for each (_local_6 in _local_3)
            {
                if (_local_2.indexOf(_local_6.effect) != -1)
                {
                    switch (_local_6.effect)
                    {
                        case "chill":
                            _local_5.push(80);
                            break;
                        case "petrify":
                            _local_5.push(100);
                            break;
                        default:
                            if (_local_6.calc_type == "number")
                            {
                                _local_4 = (_local_4 + _local_6.amount);
                            }
                            else
                            {
                                if (_local_6.calc_type == "percent")
                                {
                                    _local_5.push(_local_6.amount);
                                };
                            };
                    };
                };
            };
            return ({
                "additive":_local_4,
                "multiplicative":_local_5
            });
        }

        private function increaseDamageFromCritical_Buff():Object
        {
            var _local_5:Object;
            var _local_1:Array = ["concentration", "reflexes"];
            var _local_2:Array = this.getActiveEffects();
            var _local_3:int;
            var _local_4:Array = [];
            for each (_local_5 in _local_2)
            {
                if (_local_1.indexOf(_local_5.effect) != -1)
                {
                    if (_local_5.calc_type == "number")
                    {
                        _local_3 = (_local_3 + _local_5.amount);
                    }
                    else
                    {
                        if (_local_5.calc_type == "percent")
                        {
                            _local_4.push(_local_5.amount);
                        };
                    };
                };
            };
            return ({
                "additive":_local_3,
                "multiplicative":_local_4
            });
        }

        public function decreaseDamage(_arg_1:int, _arg_2:Object):int
        {
            var _local_7:int;
            var _local_8:Object;
            var _local_9:Object;
            var _local_10:Object;
            var _local_11:Object;
            var _local_12:int;
            var _local_13:Array;
            var _local_14:int;
            var _local_15:Array;
            var _local_16:int;
            var _local_17:Array;
            var _local_18:int;
            var _local_19:Array;
            var _local_20:int;
            var _local_21:Array;
            var _local_22:int;
            var _local_23:int;
            var _local_3:Object = this.getCurrentModel();
            var _local_4:int = this.decreaseDamageFromPassive_Buff(_arg_2).additive;
            var _local_5:Array = this.decreaseDamageFromPassive_Buff(_arg_2).multiplicative;
            _arg_1 = (_arg_1 - _local_4);
            var _local_6:int = 1;
            for each (_local_7 in _local_5)
            {
                _arg_1 = int((_arg_1 - Math.round(((_arg_1 * _local_7) / 100))));
                _local_6++;
            };
            _local_8 = this.decreaseDamageFromActive_Buff_Attacker(_local_3);
            _local_9 = this.decreaseDamageFromActive_Buff_Defender(_arg_2);
            _local_10 = this.decreaseDamageFromActive_Debuff_Attacker(_local_3);
            _local_11 = this.decreaseDamageFromActive_Debuff_Defender(_arg_2);
            _local_12 = _local_8.additive;
            _local_13 = _local_8.multiplicative;
            _local_14 = _local_9.additive;
            _local_15 = _local_9.multiplicative;
            _local_16 = _local_10.additive;
            _local_17 = _local_10.multiplicative;
            _local_18 = _local_11.additive;
            _local_19 = _local_11.multiplicative;
            _local_20 = (((_local_12 + _local_14) + _local_16) + _local_18);
            _local_21 = _local_13.concat(_local_15).concat(_local_17).concat(_local_19);
            _arg_1 = (_arg_1 - _local_20);
            _local_22 = 1;
            for each (_local_23 in _local_21)
            {
                _arg_1 = int((_arg_1 - Math.round(((_arg_1 * _local_23) / 100))));
                _local_22++;
            };
            return (_arg_1);
        }

        private function applyPowerUpByHP(_arg_1:Object, _arg_2:Object):int
        {
            var _local_3:int = int(_arg_1.health_manager.getMaxHP());
            var _local_4:int = int(_arg_1.health_manager.getCurrentHP());
            if (_arg_2.calc_type === "percent")
            {
                return ((_arg_2.reduce_type != "MAX") ? int(Math.floor(((_local_4 * _arg_2.amount) / 100))) : int(Math.floor(((_local_3 * _arg_2.amount) / 100))));
            };
            return (_arg_2.amount);
        }

        public function checkSereneMind():Boolean
        {
            var _local_3:Array;
            var _local_4:Object;
            var _local_1:Array = this.getAllCharacterSetEffects();
            var _local_2:Boolean;
            for each (_local_3 in _local_1)
            {
                for each (_local_4 in _local_3)
                {
                    if (((_local_4.effect == "serene_mind_item") && (_local_4.chance >= NumberUtil.getRandomInt())))
                    {
                        _local_2 = true;
                        break;
                    };
                };
            };
            if (this.hadEffect("serene_mind"))
            {
                _local_2 = true;
            };
            return (_local_2);
        }

        public function dealCounterSkill():Boolean
        {
            var _local_1:* = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (false);
            };
            if (!_local_1.effects_manager.hadEffect("counter_effect"))
            {
                return (false);
            };
            if (_local_1.character_manager.getSpecificSkill("skill_7036"))
            {
                BattleVars.COPY_SKILL_ID_SAVE = "skill_7038";
                return (true);
            };
            if (_local_1.character_manager.getSpecificSkill("skill_7037"))
            {
                BattleVars.COPY_SKILL_ID_SAVE = "skill_7039";
                return (true);
            };
            return (false);
        }

        public function checkIncreaseDamageForToad(_arg_1:*):int
        {
            var _local_9:Array;
            var _local_2:int = _arg_1;
            var _local_3:* = this.getCurrentModel();
            if (!_local_3.isCharacter())
            {
                return (_local_2);
            };
            var _local_4:Array = this.getSenjutsuSkills(_local_3);
            var _local_5:int = _local_3.health_manager.getCurrentHP();
            var _local_6:int = _local_3.health_manager.getMaxHP();
            var _local_7:int = (_local_6 - _local_5);
            var _local_8:* = 0;
            while (_local_8 < _local_4.length)
            {
                _local_9 = _local_4[_local_8].split(":");
                if (_local_9[0] == "skill_3009")
                {
                    _arg_1 = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3009", _local_3.character_manager.getSenjutsuLevel("skill_3009")).hp_requirement;
                    _local_2 = int((_local_2 + Math.round(((_local_7 * _arg_1) / 100))));
                };
                _local_8++;
            };
            return (_local_2);
        }

        public function checkBackgroundChangeFinish():void
        {
            var _local_1:Object = this.getCurrentModel();
            var _local_2:Object = _local_1.effects_manager.getEffect("domain_expansion");
            if (!_local_2)
            {
                return;
            };
            if (_local_1.effects_manager.hadEffect("domain_expansion"))
            {
                return;
            };
            if (BattleVars.BACKGROUND_CHANGED_CASTER != ((this.user_team + "_") + this.user_number))
            {
                return;
            };
            if (BattleManager.BATTLE_VARS.ORIGINAL_BATTLE_BACKGROUND == BattleManager.BATTLE_VARS.BATTLE_BACKGROUND)
            {
                return;
            };
            BattleManager.BATTLE_VARS.BATTLE_BACKGROUND = BattleManager.BATTLE_VARS.ORIGINAL_BATTLE_BACKGROUND;
            BattleManager.loadBackground();
        }

        public function decreaseDamageByEffect(_arg_1:int, _arg_2:Object, _arg_3:*=null):*
        {
            var _local_4:int = int(_arg_2.amount);
            if (((_arg_2.effect == "stealth") && (((!("no_protect")) in _arg_2) || (_arg_2.no_protect == false))))
            {
                _arg_2.no_protect = true;
                if ((_local_4 = int(_arg_2.amount_protection)) == 100)
                {
                    BattleVars.SHOW_DAMAGE_ZERO = true;
                };
            };
            if (_arg_2.effect == "unyielding")
            {
                BattleVars.SHOW_DAMAGE_ZERO = false;
                _arg_1 = int((_arg_1 - Math.floor(((_arg_1 * 100) / 100))));
            };
            if (_arg_2.effect == "plus_protection")
            {
                if (_arg_2.new_amount != undefined)
                {
                    _local_4 = int(_arg_2.new_amount);
                    if (_arg_3 != null)
                    {
                        BattleManager.getBattle().addToResetNewAmountOnNextTurn(_arg_2, _arg_3.getPlayerTeam(), _arg_3.getPlayerNumber());
                    }
                    else
                    {
                        _arg_2.new_amount = undefined;
                    };
                };
            };
            if (_arg_2.calc_type == "percent")
            {
                _arg_1 = int((_arg_1 - Math.floor(((_arg_1 * _local_4) / 100))));
            }
            else
            {
                _arg_1 = (_arg_1 - _local_4);
            };
            if (_arg_1 < 0)
            {
                _arg_1 = 0;
            };
            return (_arg_1);
        }

        public function increaseDamageByEffect(_arg_1:int, _arg_2:Object):*
        {
            if (_arg_2.effect == "chill")
            {
                if (_arg_2.calc_type == "percent")
                {
                    _arg_1 = int((_arg_1 + Math.floor(((_arg_1 * _arg_2.bleeding_amount) / 100))));
                }
                else
                {
                    _arg_1 = (_arg_1 + _arg_2.bleeding_amount);
                };
            }
            else
            {
                if (_arg_2.calc_type == "percent")
                {
                    _arg_1 = int((_arg_1 + Math.floor(((_arg_1 * _arg_2.amount) / 100))));
                }
                else
                {
                    _arg_1 = (_arg_1 + _arg_2.amount);
                };
            };
            return (_arg_1);
        }

        public function addElementalDamage(_arg_1:int, _arg_2:int, _arg_3:Object):int
        {
            var _local_4:Object = this.getCurrentModel();
            var _local_5:Object = _local_4.character_manager;
            var _local_6:int = _local_5.getWindAttributes();
            var _local_7:int = _local_5.getFireAttributes();
            var _local_8:int = _local_5.getLightningAttributes();
            var _local_9:int = _local_5.getEarthAttributes();
            var _local_10:int = _local_5.getWaterAttributes();
            var _local_11:Object = {};
            switch (_arg_2)
            {
                case 5:
                    if (((_arg_3.player_identification == "ene_2102") || (_arg_3.player_identification == "ene_2104")))
                    {
                        _arg_1 = (_arg_1 + _arg_1);
                    };
                    break;
                case 6:
                    if (_arg_3.player_identification == "ene_2103")
                    {
                        _arg_1 = int((_arg_1 / 2));
                    }
                    else
                    {
                        if (((_arg_3.player_identification == "ene_2106") || (_arg_3.player_identification == "ene_2105")))
                        {
                            _arg_1 = (_arg_1 + _arg_1);
                        };
                    };
                    break;
                case 7:
                    if (_arg_3.player_identification == "ene_2102")
                    {
                        _arg_1 = int((_arg_1 / 2));
                    };
                    break;
            };
            return (_arg_1);
        }

        public function reviveTeammates(_arg_1:*):*
        {
            var _local_2:* = this.getCurrentModel();
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int = int(_arg_1.revive_prc);
            var _local_8:int = int(_arg_1.revive_sacrifice_prc);
            var _local_9:int;
            var _local_10:* = null;
            if (this.user_team == "player")
            {
                while (_local_9 < BattleManager.getBattle().character_team_players.length)
                {
                    _local_10 = BattleManager.getBattle().character_team_players[_local_9];
                    if (_local_2 == _local_10)
                    {
                        BattleVars.CHARACTER_TEAM_REVIVED[_local_9] = true;
                        _local_10.health_manager.reduceHealth(Math.floor(((_local_10.health_manager.getCurrentHP() * _local_8) / 100)), "Revive HP -");
                    }
                    else
                    {
                        if (_local_10.health_manager.getCurrentHP() <= 0)
                        {
                            _local_10.effects_manager.purifyPlayer("");
                            _local_4 = int(Math.floor(((_local_10.health_manager.getMaxHP() * _local_7) / 100)));
                            _local_5 = int(Math.floor(((_local_10.health_manager.getMaxCP() * _local_7) / 100)));
                            _local_10.health_manager.addHealth(_local_4, "Revived HP +");
                            _local_10.health_manager.addCP(_local_5, "Revived CP +");
                            _local_10.health_manager.play_dead_animation = false;
                            _local_10.health_manager.played_dead_animation = false;
                            if (_local_10.isCharacter())
                            {
                                _local_10.gotoAndPlay("standby");
                            }
                            else
                            {
                                _local_10.standByFrameEnd();
                            };
                        };
                    };
                    _local_9++;
                };
            }
            else
            {
                if (this.user_team == "enemy")
                {
                    while (_local_9 < BattleManager.getBattle().enemy_team_players.length)
                    {
                        _local_10 = BattleManager.getBattle().enemy_team_players[_local_9];
                        if (_local_2 == _local_10)
                        {
                            BattleVars.ENEMY_TEAM_REVIVED[_local_9] = true;
                            _local_10.health_manager.reduceHealth(Math.floor(((_local_10.health_manager.getCurrentHP() * _local_8) / 100)), "Revive HP -");
                        }
                        else
                        {
                            if (_local_10.health_manager.getCurrentHP() <= 0)
                            {
                                _local_4 = int(Math.floor(((_local_10.health_manager.getMaxHP() * _local_7) / 100)));
                                _local_5 = int(Math.floor(((_local_10.health_manager.getMaxCP() * _local_7) / 100)));
                                _local_10.health_manager.addHealth(_local_4, "Revived HP +");
                                _local_10.health_manager.addCP(_local_5, "Revived CP +");
                                _local_10.health_manager.play_dead_animation = false;
                                _local_10.health_manager.played_dead_animation = false;
                                if (_local_10.isCharacter())
                                {
                                    _local_10.gotoAndPlay("standby");
                                }
                                else
                                {
                                    _local_10.object_mc.standByFrameEnd();
                                };
                            };
                        };
                        _local_9++;
                    };
                };
            };
        }

        public function shuffleArray(_arg_1:Array):Array
        {
            var _local_2:Number = 0;
            var _local_3:Array = new Array(_arg_1.length);
            var _local_4:int;
            while (_local_4 < _local_3.length)
            {
                _local_2 = NumberUtil.randomInt(0, (_arg_1.length - 1));
                _local_3[_local_4] = _arg_1[_local_2];
                _arg_1.splice(_local_2, 1);
                _local_4++;
            };
            return (_local_3);
        }

        public function isTalentBuff(_arg_1:String):*
        {
            var _local_2:Array = ["unyielding", "titan_mode", "overload_mode", "taijutsu_strengthen", "extreme_mode", "increase_silhouette_chance", "lava_shield", "illuminated_chakra_mode"];
            return (Util.in_array(_arg_1, _local_2));
        }

        public function checkIncreaseElementCooldown(_arg_1:String):int
        {
            var _local_2:Array = ["increase_wind_cd", "increase_fire_cd", "increase_lightning_cd", "increase_earth_cd", "increase_water_cd"];
            return (_local_2.indexOf(_arg_1) + 1);
        }

        private function handleInstantEffect(effect:Object, model:Object):void
        {
            var attacker:Object;
            var masterModel:Object;
            var effectEnemy:Array;
            var currentHP:int;
            var maxHP:int;
            var elementIndex:int;
            var display:String;
            var addHealth:Number;
            var target:Object;
            var amount:int;
            var extra_hp:Object;
            var amountHP:int;
            var amountCP:int;
            var message:String;
            var totalAmount:int;
            var isMasterBuff:Boolean;
            var totalDamage:int;
            var targetMaxHP:* = undefined;
            var getIncreaseHeal:Function = function (_arg_1:Object, _arg_2:int):int
            {
                var _local_3:int = ((_arg_1.isCharacter()) ? _arg_1.character_manager.getWaterAttributes() : 0);
                var _local_4:int;
                if (_local_3 > 0)
                {
                    _local_4 = int(Math.round(((_arg_2 * _local_3) / 100)));
                };
                return (_local_4);
            };
            var handlePetOceanAtmosphere:Function = function (_arg_1:*, _arg_2:*, _arg_3:*):*
            {
                var _local_4:Object = _arg_2.effects_manager;
                _arg_1.effect = "ocean_atmosphere";
                _local_4.addBuff(_arg_1);
                _local_4.checkAddHealthAfterGotBuff();
                _local_4.checkAddCPAfterGotBuff();
            };
            var addEffect:Function = function (_arg_1:Object, _arg_2:Object, _arg_3:String):*
            {
                if (_arg_3 == "buff")
                {
                    _arg_2.effects_manager.addBuff(_arg_1);
                }
                else
                {
                    _arg_2.effects_manager.addDebuff(_arg_1);
                };
            };
            var handlePetFlameEater:Function = function (_arg_1:*, _arg_2:*):*
            {
                if (((Boolean(_arg_2.effects_manager.hadEffect("burn"))) || (Boolean(_arg_2.effects_manager.hadEffect("pet_burn")))))
                {
                    _arg_2.effects_manager.getEffect("burn").duration = 0;
                    _arg_2.effects_manager.getEffect("pet_burn").duration = 0;
                    _arg_1.new_amount_percent = true;
                    _arg_2.health_manager.reduceHpFromDebuff(_arg_1, "HP -");
                    Effects.showEffectInfo(_arg_2.effects_manager.user_team, _arg_2.effects_manager.user_number, "Flame Eater", false);
                }
                else
                {
                    _arg_2.health_manager.reduceHpFromDebuff(_arg_1, "HP -");
                };
            };
            var handleInstantReduceHp:Function = function (_arg_1:*, _arg_2:*):*
            {
                var _local_3:Object = _arg_2.effects_manager.getEffect("slow");
                var _local_4:Object = _arg_2.effects_manager.hadEffect("slow");
                if ((("oil_increase" in _local_3) && (_local_3.oil_increase)))
                {
                    if (((_local_4) && ("oil_increase" in _arg_1)))
                    {
                        _arg_1.amount = _arg_1.oil_increase;
                        _arg_2.effects_manager.removeEffect("slow");
                    };
                };
                _arg_2.health_manager.reduceHpFromDebuff(_arg_1, "Reduce HP -");
                _arg_2.health_manager.reduceCPFromDebuff(_arg_1, "Reduce CP -");
            };
            var team:String = model.getPlayerTeam();
            attacker = BattleManager.getBattle().getAttacker();
            var defender:Object = BattleManager.getBattle().getDefender();
            masterModel = BattleManager.getBattle().master_model;
            switch (effect.effect)
            {
                case "steal_buff":
                    effectEnemy = model.effects_manager.dataBuff;
                    attacker.effects_manager.dataBuff = attacker.effects_manager.dataBuff.concat(effectEnemy);
                    model.effects_manager.dataBuff = [];
                    Effects.showEffectInfo(this.user_team, this.user_number, "Steal Buff");
                    return;
                case "instant_kill":
                    model.health_manager.reduceHealth(model.health_manager.getCurrentHP(), "Instant Kill -");
                    model.health_manager.createDisplay("EZ");
                    return;
                case "add_debuff_duration":
                    model.effects_manager.handleAddDebuffDuration(effect);
                    return;
                case "add_buff_duration":
                    model.effects_manager.handleAddBuffDuration(effect);
                    return;
                case "kill_instant_under":
                    currentHP = model.health_manager.getCurrentHP();
                    maxHP = model.health_manager.getMaxHP();
                    if (currentHP < Math.floor(((maxHP * effect.amount) / 100)))
                    {
                        model.health_manager.reduceHealth(currentHP, "Instant Kill -");
                    };
                    return;
                case "increase_wind_cd":
                case "increase_fire_cd":
                case "increase_lightning_cd":
                case "increase_earth_cd":
                case "increase_water_cd":
                    elementIndex = this.checkIncreaseElementCooldown(effect.effect);
                    if (model.isCharacter())
                    {
                        model.actions_manager.increaseSkillTypeCds(effect.amount, elementIndex);
                    };
                    return;
                case "revive_teammates":
                    this.reviveTeammates(effect);
                    return;
                case "self_disperse_all":
                    BattleVars.IS_DISPERSED = true;
                    model.effects_manager.clearAllEffect();
                    model.health_manager.createDisplay("Purify");
                    model.effects_manager.resetMaxStats(model);
                    model.effects_manager.checkBackgroundChangeFinish();
                    return;
                case "pet_ocean_atmosphere":
                    (handlePetOceanAtmosphere(effect, model, NumberUtil.getRandomInt()));
                    return;
                case "add_cooldown":
                    if (model.isCharacter())
                    {
                        model.actions_manager.viceRapidCooldown((effect.amount + 1), "Cooldown + ");
                    }
                    else
                    {
                        model.viceRapidCooldown((effect.amount + 1), "Cooldown + ");
                    };
                    return;
                case "add_cooldown_player":
                    if (model.isCharacter())
                    {
                        model.actions_manager.viceRapidCooldown((effect.amount + 1), "Cooldown + ");
                    };
                    return;
                case "reduce_cd":
                case "rapid_cooldown":
                case "pet_rapid_cooldown":
                    model.actions_manager.rewindCooldown(effect.amount, ("Reduce CD " + effect.amount));
                    this.checkAddHealthAfterGotBuff();
                    this.checkAddCPAfterGotBuff();
                    return;
                case "attack_reduce_gen_cooldown":
                    model.actions_manager.rapidGenjutusuCooldown(effect.amount);
                    this.checkAddHealthAfterGotBuff();
                    this.checkAddCPAfterGotBuff();
                    return;
                case "pet_oil_bottle":
                    model.resetCooldowns();
                    Effects.showEffectInfo(model.effects_manager.user_team, model.effects_manager.user_number, "Reset Cooldown");
                    return;
                case "pet_flame_eater":
                    (handlePetFlameEater(effect, model));
                    return;
                case "pet_reduce_cd_random":
                    model.actions_manager.reduceRandomSkillCoolDown(effect.amount);
                    Effects.showEffectInfo(model.effects_manager.user_team, model.effects_manager.user_number, "Reduce Cooldown", false);
                    return;
                case "random_add_cooldown":
                case "pet_random_add_cooldown":
                case "oblivion":
                    display = "Add Cooldown";
                    if (effect.effect == "oblivion")
                    {
                        display = "Oblivion";
                    };
                    if (model.isCharacter())
                    {
                        model.actions_manager.randomOblivion(effect.amount, display);
                    }
                    else
                    {
                        model.randomOblivion(effect.amount, display);
                    };
                    return;
                case "set_all_cooldown":
                    if (model.isCharacter())
                    {
                        model.actions_manager.setCooldownFromEffect(effect.amount, "Add Cooldown");
                    };
                    return;
                case "set_single_cooldown":
                    if (model.isCharacter())
                    {
                        model.actions_manager.setSingleCooldownFromEffect(effect.amount, "Add Cooldown");
                    };
                    return;
                case "instant_reduce_cp":
                case "insta_reduce_max_cp":
                case "drain_cp_injury":
                    addHealth = attacker.effects_manager.getRecoverWhenHPReducedByTalent();
                    if (addHealth > 0)
                    {
                        attacker.health_manager.addHealth(addHealth);
                    };
                    model.health_manager.reduceCPFromDebuff(effect, "Reduce CP -");
                    return;
                case "toad_fire":
                    (handleInstantReduceHp(effect, model));
                    return;
                case "instant_reduce_hp":
                case "insta_reduce_max_hp":
                    model.health_manager.reduceHpFromDebuff(effect, "Reduce HP -");
                    return;
                case "instant_drain_sp":
                    this.drainSP(effect, attacker, model);
                    return;
                case "absorb_hp_to_sp":
                    this.absorbHpToSP(model, attacker, effect);
                    return;
                case "insta_reduce_max_hpcp":
                    addHealth = attacker.effects_manager.getRecoverWhenHPReducedByTalent();
                    if (addHealth > 0)
                    {
                        attacker.health_manager.addHealth(addHealth);
                    };
                    model.health_manager.reduceHpFromDebuff(effect, "Reduce HP -");
                    model.health_manager.reduceCPFromDebuff(effect, "Reduce CP -");
                    return;
                case "plague":
                    model.health_manager.reduceHpFromDebuff(effect, "Plague HP -");
                    model.health_manager.reduceCPFromDebuff(effect, "Plague CP -");
                    return;
                case "insta_drain_hp":
                case "drain_hp_with_attack":
                case "current_hp_drain":
                case "hp_drain":
                case "pet_hp_drain":
                    target = ((effect.effect.split("_")[0] == "pet") ? masterModel : attacker);
                    addHealth = target.effects_manager.getRecoverWhenHPReducedByTalent();
                    if (addHealth > 0)
                    {
                        target.health_manager.addHealth(addHealth);
                    };
                    this.drainHP(model, target, effect);
                    return;
                case "current_cp_drain":
                case "drain_cp_with_attack":
                case "cp_drain":
                case "drain_cp_stun":
                case "pet_cp_drain":
                    target = ((effect.effect.split("_")[0] == "pet") ? masterModel : attacker);
                    addHealth = target.effects_manager.getRecoverWhenHPReducedByTalent();
                    if (addHealth > 0)
                    {
                        target.health_manager.addHealth(addHealth);
                    };
                    this.drainCP(model, target, effect);
                    return;
                case "drain_HpCp":
                case "pet_drain_HpCp":
                    target = ((effect.effect.split("_")[0] == "pet") ? masterModel : attacker);
                    addHealth = target.effects_manager.getRecoverWhenHPReducedByTalent();
                    if (addHealth > 0)
                    {
                        target.health_manager.addHealth(addHealth);
                    };
                    this.drainHP(model, target, effect);
                    this.drainCP(model, target, effect);
                    return;
                case "shield":
                    model.health_manager.createDisplay(("Shield: " + effect.amount.toString()));
                    model.health_manager.amount_shield = effect.amount;
                    return;
                case "senju_mark":
                    model.health_manager.createDisplay(("Shield of Senju: " + effect.amount.toString()));
                    model.health_manager.amount_shield = effect.amount;
                    return;
                case "heal":
                case "pet_heal":
                case "kira_kuin":
                    amount = effect.amount;
                    extra_hp = new Object();
                    if (effect.calc_type == "percent")
                    {
                        amount = int(Math.floor(((model.health_manager.getMaxHP() * amount) / 100)));
                    };
                    if ((extra_hp = this.getEffect("plus_extra_hp")).duration > 0)
                    {
                        amount = int((amount + Math.floor(((amount * extra_hp.amount) / 100))));
                    };
                    amount = (amount + getIncreaseHeal(model, amount));
                    model.health_manager.addHealth(amount, "HealMC ");
                    return;
                case "recover_hp_cp":
                case "hpcp_up":
                    amountHP = 0;
                    amountCP = 0;
                    if ((("checkSageMode" in effect) && (model.effects_manager.hadEffect("sage_mode"))))
                    {
                        effect.amount = (effect.amount + 15);
                    };
                    if (effect.calc_type == "percent")
                    {
                        amountHP = int(Math.floor(((model.health_manager.getMaxHP() * effect.amount) / 100)));
                        amountCP = int(Math.floor(((model.health_manager.getMaxCP() * effect.amount) / 100)));
                    }
                    else
                    {
                        amountHP = effect.amount;
                        amountCP = effect.amount;
                    };
                    amountHP = (amountHP + getIncreaseHeal(model, amountHP));
                    model.health_manager.addHealth(amountHP, "Recover HP +");
                    model.health_manager.addCP(amountCP, "Recover CP +");
                    return;
                case "recover_hp":
                case "wellness":
                    amount = effect.amount;
                    if (effect.calc_type == "percent")
                    {
                        amount = int(Math.floor(((model.health_manager.getMaxHP() * effect.amount) / 100)));
                    };
                    amount = (amount + getIncreaseHeal(model, amount));
                    model.health_manager.addHealth(amount, "Recover HP +");
                    return;
                case "recover_cp":
                    amount = effect.amount;
                    if (effect.calc_type == "percent")
                    {
                        amount = int(Math.floor(((model.health_manager.getMaxCP() * effect.amount) / 100)));
                    };
                    model.health_manager.addCP(amount, "Recover CP +");
                    return;
                case "instant_cp_recover":
                    message = "Insta Recover CP +";
                    amount = int(effect.amount);
                    totalAmount = 0;
                    target = (("is_master_buff" in effect) ? masterModel : model);
                    switch (effect.effect_name)
                    {
                        case "Attack Recover CP":
                            message = "CP +";
                            break;
                        case "Stubborn Recover CP":
                            message = "Stubborn Recover CP +";
                            totalAmount = BattleManager.getTotalDamage();
                            break;
                        default:
                            totalAmount = target.health_manager.getMaxCP();
                    };
                    if (effect.calc_type == "percent")
                    {
                        amount = int(Math.floor(((totalAmount * amount) / 100)));
                    };
                    target.health_manager.addCP(amount, message);
                    return;
                case "instant_hp_recover":
                    message = "Insta Recover HP +";
                    amount = effect.amount;
                    isMasterBuff = ("is_master_buff" in effect);
                    totalDamage = 0;
                    target = ((isMasterBuff == true) ? masterModel : model);
                    targetMaxHP = target.health_manager.getMaxHP();
                    if (effect.effect_name == "Attack Recover HP")
                    {
                        message = "HP +";
                    };
                    amount = int(effect.amount);
                    if (effect.calc_type == "percent")
                    {
                        amount = int(Math.floor(((targetMaxHP * amount) / 100)));
                    };
                    amount = (amount + getIncreaseHeal(model, amount));
                    target.health_manager.addHealth(amount, message);
                    return;
                case "insta_consume_all_cp":
                    model.health_manager.reduceCP(model.health_manager.getMaxCP(), "CP -");
                    return;
                case "lock":
                    currentHP = int(model.health_manager.getCurrentHP());
                    maxHP = int(model.health_manager.getMaxHP());
                    if (currentHP >= Math.ceil((maxHP / 2)))
                    {
                        effect.effect = "weaken";
                        effect.calc_type = "percent";
                        effect.duration = effect.duration;
                        effect.amount = effect.amount;
                    }
                    else
                    {
                        effect.effect = "locked";
                        effect.add_in_array = true;
                        effect.duration = effect.duration;
                    };
                    model.effects_manager.addDebuff(effect);
                    return;
                case "sacrifice_self_health":
                    amount = (model.health_manager.getCurrentHP() - 1);
                    model.health_manager.reduceHealth(amount, "Sacrifice -");
                    return;
                case "double_cp_consumption":
                    effect.effect = "cp_cost";
                    this.addDebuff(effect);
                    return;
                case "damage_to_hp":
                    if (defender.IS_DODGED)
                    {
                        return;
                    };
                    amount = int(Math.floor(((BattleManager.getTotalDamage() * effect.amount) / 100)));
                    model.health_manager.addHealth(amount, "Convert +");
                    return;
            };
        }

        public function handlingTransform(_arg_1:int):void
        {
            var _local_3:Object;
            var _local_4:int;
            var _local_5:int;
            var _local_2:Object = this.getCurrentModel();
            if (this.hadEffect("transform"))
            {
                _local_3 = this.getEffect("transform");
                _local_4 = NumberUtil.getRandomInt();
                _local_5 = _local_3.amount;
                if (_local_3.calc_type == "percent")
                {
                    _local_5 = int(((_arg_1 * _local_5) / 100));
                };
                _local_2.health_manager.reduceCP(_local_5, "Transform -");
            };
        }

        public function drainHP(_arg_1:Object, _arg_2:Object, _arg_3:Object):void
        {
            var _local_11:Object;
            var _local_4:* = undefined;
            if ((("switch_att_def" in _arg_3) && (Boolean(_arg_3.switch_att_def))))
            {
                _local_4 = _arg_1;
                _arg_1 = _arg_2;
                _arg_2 = _local_4;
            };
            var _local_5:int = int(_arg_1.health_manager.getCurrentHP());
            var _local_6:int = int(_arg_1.health_manager.getMaxHP());
            var _local_7:int = int(_arg_2.health_manager.getCurrentHP());
            var _local_8:int = int(_arg_2.health_manager.getMaxHP());
            var _local_9:Boolean = ((_arg_3.reduce_type == "MAX") ? true : false);
            var _local_10:int = int(Math.floor(((_arg_3.amount * _local_5) / 100)));
            if (((_local_9) && (_arg_3.effect.indexOf("current") == -1)))
            {
                _local_10 = int(Math.floor(((_arg_3.amount * _local_6) / 100)));
            };
            if (_local_7 > 0)
            {
                _local_11 = _arg_2.effects_manager;
                if (!((_local_11.hadEffect("unyielding")) || (_local_11.hadEffect("negate"))))
                {
                    _arg_2.health_manager.addHealth(_local_10, "HP Drain +");
                }
                else
                {
                    _arg_2.health_manager.createDisplay("Buff Resisted");
                };
                _arg_1.health_manager.reduceHealth(_local_10, "HP Drain -");
            };
        }

        public function drainCP(_arg_1:*, _arg_2:*, _arg_3:Object):*
        {
            var _local_5:int;
            var _local_6:int;
            var _local_9:Boolean;
            var _local_10:int;
            var _local_11:Object;
            var _local_4:* = undefined;
            if ((("switch_att_def" in _arg_3) && (Boolean(_arg_3.switch_att_def))))
            {
                _local_4 = _arg_1;
                _arg_1 = _arg_2;
                _arg_2 = _local_4;
            };
            _local_5 = int(_arg_1.health_manager.getCurrentCP());
            _local_6 = int(_arg_1.health_manager.getMaxCP());
            var _local_7:int = int(_arg_2.health_manager.getCurrentCP());
            var _local_8:int = int(_arg_2.health_manager.getMaxCP());
            _local_9 = ((_arg_3.reduce_type == "MAX") ? true : false);
            _local_10 = int(Math.floor(((_arg_3.amount * _local_5) / 100)));
            if (_local_9)
            {
                _local_10 = int(Math.floor(((_arg_3.amount * _local_6) / 100)));
            };
            _local_11 = _arg_2.effects_manager;
            if (!((_local_11.hadEffect("unyielding")) || (_local_11.hadEffect("negate"))))
            {
                _arg_2.health_manager.addCP(_local_10, "CP Drain +");
            }
            else
            {
                _arg_2.health_manager.createDisplay("Buff Resisted");
            };
            if (_arg_3.effect == "drain_cp_stun")
            {
                _arg_1.health_manager.reduceCPFromDebuff(_arg_3, "CP Drain -");
            }
            else
            {
                _arg_1.health_manager.reduceCP(_local_10, "CP Drain -");
            };
        }

        public function drainSP(_arg_1:*, _arg_2:*, _arg_3:Object):*
        {
            var _local_4:*;
            var _local_5:int;
            var _local_6:int;
            var _local_10:int;
            var _local_11:int;
            _local_4 = undefined;
            if ((("switch_att_def" in _arg_3) && (Boolean(_arg_3.switch_att_def))))
            {
                _local_4 = _arg_1;
                _arg_1 = _arg_2;
                _arg_2 = _local_4;
            };
            _local_5 = _arg_1.health_manager.getCurrentSP();
            _local_6 = _arg_1.health_manager.getMaxSP();
            if (_local_6 == 0)
            {
                return;
            };
            var _local_7:int = _arg_2.health_manager.getCurrentSP();
            var _local_8:int = _arg_2.health_manager.getMaxSP();
            var _local_9:Boolean = ((_arg_3.reduce_type == "MAX") ? true : false);
            _local_10 = int(Math.floor(((_arg_3.amount * _local_5) / 100)));
            _local_11 = int((_local_10 / 2));
            _arg_2.health_manager.addSP("Drain SP +", _local_11);
            _arg_1.health_manager.reduceSP(_local_10, "Drain SP -");
        }

        public function absorbHpToSP(_arg_1:*, _arg_2:*, _arg_3:Object):*
        {
            var _local_4:*;
            var _local_5:int;
            var _local_6:int;
            var _local_10:int;
            var _local_11:int;
            _local_4 = undefined;
            if ((("switch_att_def" in _arg_3) && (Boolean(_arg_3.switch_att_def))))
            {
                _local_4 = _arg_1;
                _arg_1 = _arg_2;
                _arg_2 = _local_4;
            };
            _local_5 = _arg_1.health_manager.getCurrentHP();
            _local_6 = _arg_1.health_manager.getMaxHP();
            if (_local_6 == 0)
            {
                return;
            };
            var _local_7:int = _arg_2.health_manager.getCurrentSP();
            var _local_8:int = _arg_2.health_manager.getMaxSP();
            var _local_9:Boolean = ((_arg_3.reduce_type == "MAX") ? true : false);
            _local_10 = int(Math.floor(((_arg_3.amount * _local_5) / 100)));
            _local_11 = int((_local_10 / 2));
            _arg_2.health_manager.addSP("Absorb SP +", _local_11);
            _arg_1.health_manager.reduceHealth(_local_10, "Absorb HP -");
        }

        public function addEffect(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:int, _arg_5:String="", _arg_6:int=0, _arg_7:int=100, _arg_8:String="immediately"):void
        {
            var _local_9:Object;
            _local_9 = new Object();
            _local_9.effect = _arg_2;
            _local_9.effect_name = _arg_3;
            _local_9.amount = _arg_4;
            _local_9.calc_type = _arg_5;
            _local_9.duration = _arg_6;
            _local_9.chance = _arg_7;
            _local_9.duration_deduct = _arg_8;
            _local_9.type = _arg_1;
            var _local_10:* = this;
            (_local_10[("add" + _arg_1)](_local_9));
        }

        public function addBuff(_arg_1:Object, _arg_2:Object=null):void
        {
            var _local_3:Array;
            var _local_4:Object;
            var _local_5:Object;
            var _local_6:Object;
            var _local_7:Object;
            var _local_8:Object;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            _local_3 = Effects.immediately_affected_effects;
            _local_4 = ((_arg_2 != null) ? _arg_2 : this.getCurrentModel());
            _local_5 = _local_4.health_manager;
            if (((this.hadEffect("negate")) && (!(_arg_1.effect == "sensation"))))
            {
                _local_5.createDisplay("Buff Negated");
                return;
            };
            if (this.hadEffect("unyielding"))
            {
                _local_5.createDisplay("Buff Resisted");
                return;
            };
            if (((this.hadEffect("titan_mode")) && (_arg_1.effect == "titan_mode")))
            {
                return;
            };
            if (((this.hadEffect("emberstep_demonic")) && (_arg_1.effect == "emberstep_demonic")))
            {
                return;
            };
            if (((this.hadEffect("overload")) && (_arg_1.effect == "overload")))
            {
                return;
            };
            if (_local_3.indexOf(_arg_1.effect) >= 0)
            {
                this.handleInstantEffect(_arg_1, _local_4);
                return;
            };
            for each (_local_7 in this.getAllBuffs())
            {
                if (_local_7.effect == _arg_1.effect)
                {
                    _arg_1.effect_name = _local_7.effect_name;
                    break;
                };
            };
            if (this.replaceEffect(_arg_1, "Buff"))
            {
                return;
            };
            _local_8 = this.cloneEffect(_arg_1);
            this.dataBuff.push(_local_8);
            if (Effects.doesEffectChangeBackground(_arg_1.effect))
            {
                BattleManager.BATTLE_VARS.BATTLE_BACKGROUND = _arg_1.background_id;
                BattleVars.BACKGROUND_CHANGED_CASTER = ((this.user_team + "_") + this.user_number);
                if (!BattleVars.BACKGROUND_CHANGED)
                {
                    BattleVars.BACKGROUND_CHANGED = true;
                    BattleManager.loadBackground();
                };
            };
            if (Effects.doesEffectIncreaseMaxHealth(_arg_1.effect))
            {
                _local_9 = int(_local_5.getMaxHP());
                _local_10 = int(_local_5.getCurrentHP());
                _local_5.effectAddMaxHP[_arg_1.effect].original_hp = _local_9;
                if (_arg_1.calc_type == "percent")
                {
                    _local_5.effectAddMaxHP[_arg_1.effect].increase_hp = Math.floor(((_local_9 * _arg_1.amount_hp) / 100));
                    _local_5.max_hp = (_local_5.max_hp + _local_5.effectAddMaxHP[_arg_1.effect].increase_hp);
                    _local_5.setCurrentHP((_local_10 + Math.floor(((_local_10 * _arg_1.amount_hp) / 100))));
                }
                else
                {
                    _local_5.effectAddMaxHP[_arg_1.effect].increase_hp = _arg_1.amount_hp;
                    _local_5.max_hp = (_local_5.max_hp + _arg_1.amount_hp);
                    _local_5.setCurrentHP((_local_10 + _arg_1.amount_hp));
                };
                _local_5.updateHealthBar();
            };
            if (Effects.doesEffectIncreaseMaxCP(_arg_1.effect))
            {
                _local_11 = int(_local_5.getMaxCP());
                _local_12 = int(_local_5.getCurrentCP());
                _local_5.effectAddMaxCP[_arg_1.effect].original_cp = _local_11;
                if (_arg_1.amount_cp > 0)
                {
                    _arg_1.amount = _arg_1.amount_cp;
                };
                if (_arg_1.calc_type == "percent")
                {
                    _local_5.effectAddMaxCP[_arg_1.effect].increase_cp = Math.floor(((_local_11 * _arg_1.amount) / 100));
                    _local_5.max_cp = (_local_5.max_cp + _local_5.effectAddMaxCP[_arg_1.effect].increase_cp);
                    _local_5.setCurrentCP((_local_12 + Math.floor(((_local_12 * _arg_1.amount) / 100))));
                }
                else
                {
                    _local_5.effectAddMaxCP[_arg_1.effect].increase_cp = _arg_1.amount;
                    _local_5.max_cp = (_local_5.max_cp + _local_5.effectAddMaxCP[_arg_1.effect].increase_cp);
                    _local_5.setCurrentCP((_local_12 + _arg_1.amount));
                };
                if (_arg_1.effect == "wider")
                {
                    _local_5.original_max_cp = _local_5.max_cp;
                };
                _local_5.updateHealthBar();
            };
            if (Effects.doesEffectIncreaseMaxSP(_arg_1.effect))
            {
                _local_13 = int(_local_5.getMaxSP());
                _local_14 = int(_local_5.getCurrentSP());
                if (_arg_1.calc_type == "percent")
                {
                    _local_5.effectAddMaxSP[_arg_1.effect].increase_sp = Math.floor(((_local_13 * _arg_1.amount) / 100));
                    _local_5.max_sp = (_local_5.max_sp + _local_5.effectAddMaxSP[_arg_1.effect].increase_sp);
                    _local_5.setCurrentSP((_local_14 + ((_local_13 * _arg_1.amount) / 100)));
                }
                else
                {
                    _local_5.effectAddMaxSP[_arg_1.effect].increase_sp = _arg_1.amount;
                    _local_5.max_sp = (_local_5.max_sp + _local_5.effectAddMaxSP[_arg_1.effect].increase_sp);
                    _local_5.setCurrentSP((_local_14 + _arg_1.amount));
                };
            };
            Effects.showEffectAdded(this.user_team, this.user_number, _arg_1);
            _local_5.updateHealthBar();
        }

        public function checkForPowerofToad(_arg_1:*):void
        {
            var _local_2:Object;
            var _local_3:Object;
            var _local_4:Object;
            var _local_5:int;
            var _local_6:int;
            _local_2 = this.getCurrentModel();
            if (!_local_2.isCharacter())
            {
                return;
            };
            if (BattleVars.SKILL_USED_ID != "skill_3009")
            {
                return;
            };
            _local_3 = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3009", _local_2.character_manager.getSenjutsuLevel("skill_3009"));
            _local_4 = _local_2.health_manager;
            _local_5 = _local_4.getMaxHP();
            _local_6 = int((_local_5 * (_local_3.amount / 100)));
            _arg_1.health_manager.reduceHealth(_local_6, "Power of Toad -");
        }

        public function checkForShedding():Boolean
        {
            var _local_1:Object;
            var _local_2:Object;
            var _local_4:Object;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (false);
            };
            if (!_local_1.character_manager.hasSenjutsuSkill("skill_3107"))
            {
                return (false);
            };
            _local_2 = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3107", _local_1.character_manager.getSenjutsuLevel("skill_3107"));
            var _local_3:int = _local_2.sp_req;
            _local_4 = _local_1.health_manager;
            _local_5 = _local_4.getCurrentSP();
            _local_6 = _local_4.getMaxSP();
            _local_7 = int(((_local_5 / _local_6) * 100));
            if (((_local_7 > _local_2.sp_req) || (_local_1.effects_manager.hadEffect("sage_mode"))))
            {
                return ((NumberUtil.getRandomInt() <= _local_2.trigger_chance) ? true : false);
            };
            return (false);
        }

        public function checkForSnakeShadow(_arg_1:Object):void
        {
            var _local_2:Object;
            if (_arg_1.effects_manager.hadEffect("snake_shadow"))
            {
                _local_2 = _arg_1.effects_manager.getEffect("snake_shadow");
                if ((((_local_2.duration == 5) || (_local_2.duration == 3)) || (_local_2.duration == 1)))
                {
                    _arg_1.effects_manager.addEffect("Debuff", "chaos", "Chaos", 0, "", _local_2.chaos_duration, 100);
                };
            };
        }

        public function addDebuff(_arg_1:Object, _arg_2:Object=null, _arg_3:Boolean=true):void
        {
            var _local_4:Object;
            var _local_5:Object;
            var _local_6:Array;
            var _local_7:Object;
            var _local_8:Object;
            var _local_9:Array;
            var _local_10:Array;
            var _local_11:Array;
            var _local_12:Array;
            var _local_13:Object;
            var _local_14:Array;
            var _local_15:String;
            var _local_16:*;
            var _local_17:*;
            var _local_18:int;
            var _local_19:int;
            var _local_20:int;
            var _local_21:int;
            var _local_22:int;
            var _local_23:int;
            _local_4 = ((_arg_2 != null) ? _arg_2 : this.getCurrentModel());
            _local_6 = Effects.immediately_affected_effects;
            _local_7 = _local_4.health_manager;
            if (_arg_1.effect == "random_s16")
            {
                this.checkRandomS16(_arg_1);
                return;
            };
            if (_arg_1.effect != "time_stop")
            {
                if (_local_4.debuff_resist)
                {
                    _local_7.createDisplay("Crystal Resisted");
                    return;
                };
                _local_14 = ["debuff_resist", "pet_debuff_resist", "bless", "unyielding"];
                for each (_local_15 in _local_14)
                {
                    if (this.hadEffect(_local_15))
                    {
                        _local_7.createDisplay("Debuff Resisted");
                        return;
                    };
                };
            };
            if (_local_6.indexOf(_arg_1.effect) >= 0)
            {
                this.handleInstantEffect(_arg_1, _local_4);
                return;
            };
            for each (_local_8 in this.getAllDebuffs())
            {
                if (_local_8.effect == _arg_1.effect)
                {
                    if ((("add_in_array" in _local_8) && (_local_8.add_in_array)))
                    {
                        _arg_1.add_in_array = true;
                    };
                    _arg_1.effect_name = _local_8.effect_name;
                    break;
                };
            };
            _local_9 = ["burn", "inflict_burn", "pet_burn", "fire_wall_burn", "hemorrhage", "burning"];
            if (((_local_9.indexOf(_arg_1.effect) >= 0) && (this.isBurnImmune())))
            {
                Effects.showEffectInfo(this.user_team, this.user_number, "Burn Immune");
                return;
            };
            _local_10 = ["bleeding", "inflict_bleeding", "pet_bleeding", "attacker_bleeding", "pet_attacker_bleeding", "bleeding_attacker"];
            if (((_local_10.indexOf(_arg_1.effect) >= 0) && (this.hadEffect("bleeding_protection"))))
            {
                Effects.showEffectInfo(this.user_team, this.user_number, "Bleeding Immune");
                return;
            };
            _local_11 = ["poison", "inflict_poison", "pet_poison"];
            if (((_local_11.indexOf(_arg_1.effect) >= 0) && (this.getResistPoisonPrcByTalent())))
            {
                Effects.showEffectInfo(this.user_team, this.user_number, "Poison Immune");
                return;
            };
            _local_12 = ["internal_injury", "hanyaoni", "suffocate"];
            if (((_local_12.indexOf(_arg_1.effect) >= 0) && (this.hadEffect("vigor"))))
            {
                Effects.showEffectInfo(this.user_team, this.user_number, "Internal Injury Immune");
                return;
            };
            if (_arg_1.effect === "parasite")
            {
                _arg_1.from_team = BattleManager.getBattle().attacker_model.getPlayerTeam();
                _arg_1.from_number = BattleManager.getBattle().attacker_model.getPlayerNumber();
            };
            _local_11 = ["poison", "inflict_poison", "pet_poison", "poison_attacker"];
            if (_local_11.indexOf(_arg_1.effect) >= 0)
            {
                BattleManager.getBattle().attacker_model.effects_manager.getChanceToInflictChaosByTalent(_local_4);
            };
            if (this.replaceEffect(_arg_1, "Debuff"))
            {
                return;
            };
            _local_13 = this.cloneEffect(_arg_1);
            this.dataDebuff.push(_local_13);
            if (((_local_13.effect == "disable_weapon_effect") && (_local_4.isCharacter())))
            {
                _local_7.effectDecreaseMaxHP.disable_weapon_effect.original_hp = _local_7.original_max_hp;
                _local_7.effectDecreaseMaxCP.disable_weapon_effect.original_cp = _local_7.original_max_cp;
                _local_7.max_hp = _local_4.character_manager.recalculateHP();
                _local_7.max_cp = _local_4.character_manager.recalculateCP();
                _local_7.max_hp = (_local_7.max_hp + _local_7.effectAddMaxHP.domain_expansion.increase_hp);
                _local_7.max_hp = (_local_7.max_hp + _local_7.effectAddMaxHP.self_love.increase_hp);
                _local_7.max_hp = (_local_7.max_hp - _local_7.effectDecreaseMaxHP.unwell.modifier_hp);
                _local_7.max_cp = (_local_7.max_cp + _local_7.effectAddMaxCP.domain_expansion.increase_cp);
                _local_7.max_cp = (_local_7.max_cp + _local_7.effectAddMaxCP.self_love.increase_cp);
                _local_7.max_cp = (_local_7.max_cp + _local_7.effectAddMaxCP.wider.increase_cp);
                _local_16 = _local_7.getMaxHP();
                _local_17 = _local_7.getMaxCP();
                _local_7.effectDecreaseMaxHP.disable_weapon_effect.modifier_hp = (_local_7.original_max_hp - _local_16);
                _local_7.effectDecreaseMaxCP.disable_weapon_effect.modifier_cp = (_local_7.original_max_cp - _local_17);
                if (_local_7.getCurrentHP() > _local_7.getMaxHP())
                {
                    _local_7.setCurrentHP(_local_7.max_hp);
                };
                if (_local_7.getCurrentCP() > _local_7.getMaxCP())
                {
                    _local_7.setCurrentCP(_local_7.max_cp);
                };
                _local_7.updateHealthBar();
            };
            if (Effects.doesEffectDecreaseMaxCP(_arg_1.effect))
            {
                _local_18 = _local_7.getCurrentCP();
                _local_19 = _local_7.getMaxCP();
                if (_arg_1.calc_type == "percent")
                {
                    _local_7.status_change.decrease_cp = Math.floor(((_local_19 * _arg_1.amount) / 100));
                }
                else
                {
                    _local_7.status_change.decrease_cp = (_local_19 - _arg_1.amount);
                };
                _local_7.max_cp = (_local_7.max_cp - _local_7.status_change.decrease_cp);
                if (_local_7.getCurrentCP() > _local_7.getMaxCP())
                {
                    _local_7.setCurrentCP(_local_7.getMaxCP());
                };
                _local_7.updateHealthBar();
            };
            if (Effects.doesEffectDecreaseMaxHP(_arg_1.effect))
            {
                _local_20 = _local_7.getCurrentHP();
                _local_21 = _local_7.getMaxHP();
                if (_arg_1.calc_type == "percent")
                {
                    _local_7.status_change.decrease_hp = Math.floor(((_local_21 * _arg_1.amount) / 100));
                }
                else
                {
                    _local_7.status_change.decrease_hp = (_local_21 - _arg_1.amount);
                };
                _local_7.max_hp = (_local_7.max_hp - _local_7.status_change.decrease_hp);
                if (_arg_1.effect == "unwell")
                {
                    _local_7.effectDecreaseMaxHP.unwell.modifier_hp = _local_7.status_change.decrease_hp;
                    _local_7.original_max_hp = _local_7.max_hp;
                };
                if (_local_7.getCurrentHP() > _local_7.getMaxHP())
                {
                    _local_7.setCurrentHP(_local_7.getMaxHP());
                };
                _local_7.updateHealthBar();
            };
            if (Effects.doesEffectDecreaseSP(_arg_1.effect))
            {
                _local_22 = _local_7.getCurrentSP();
                _local_23 = _local_7.getMaxSP();
                if (_arg_1.calc_type == "percent")
                {
                    _local_7.status_change.decrease_sp = Math.floor(((_local_23 * _arg_1.amount) / 100));
                }
                else
                {
                    _local_7.status_change.decrease_sp = (_local_23 - _arg_1.amount);
                };
                _local_7.max_sp = (_local_7.max_sp - _local_7.status_change.decrease_sp);
                if (_local_7.getCurrentSP() > _local_7.getMaxSP())
                {
                    _local_7.setCurrentSP(_local_7.getMaxSP());
                };
                _local_7.updateHealthBar();
            };
            if (((_arg_1.effect === "meridian_cut_off") || (_arg_1.effect === "pet_meridian_cut_off")))
            {
                _local_18 = _local_7.getCurrentCP();
                _local_19 = _local_7.getMaxCP();
                _local_7.max_cp = Math.floor(((_local_19 * _arg_1.amount) / 100));
                if (_local_18 > _local_7.max_cp)
                {
                    _local_7.setCurrentCP(_local_7.max_cp);
                };
                _local_7.updateHealthBar();
            };
            if (_arg_1.effect === "decrease_max_cp")
            {
                _arg_1.amount_change = _arg_1.amount_change;
            };
            Effects.showEffectAdded(this.user_team, this.user_number, _arg_1);
        }

        private function cloneEffect(_arg_1:Object):Object
        {
            var _local_2:Object;
            var _local_3:String;
            var _local_4:String;
            _local_2 = new Object();
            for (_local_3 in _arg_1)
            {
                _local_2[_local_3] = _arg_1[_local_3];
            };
            _local_4 = Effects.getEffectDeductType(_local_2.effect);
            if (_local_4 === "after_attack")
            {
                _local_2.duration++;
            };
            return (_local_2);
        }

        private function replaceEffect(_arg_1:Object, _arg_2:String):Boolean
        {
            var _local_3:Object;
            for each (_local_3 in this[("data" + _arg_2)])
            {
                if (_local_3.effect == _arg_1.effect)
                {
                    _local_3.calc_type = _arg_1.calc_type;
                    _local_3.amount = _arg_1.amount;
                    _local_3.chaos_duration = ((_arg_1.hasOwnProperty("chaos_duration")) ? _arg_1.chaos_duration : 0);
                    _local_3.oil_increase = ((_arg_1.hasOwnProperty("oil_increase")) ? _arg_1.oil_increase : false);
                    _local_3.duration = (((_arg_1.hasOwnProperty("add_in_array")) || ((_arg_1.hasOwnProperty("passive")) && (_arg_1.passive == true))) ? _arg_1.duration : (_arg_1.duration + 1));
                    Effects.showEffectAdded(this.user_team, this.user_number, _arg_1);
                    return (true);
                };
            };
            return (false);
        }

        public function handleAddDebuffDuration(_arg_1:Object):void
        {
            var _local_2:Array;
            var _local_3:int;
            var _local_4:int;
            var _local_5:Object;
            _local_2 = this.getActiveDebuff();
            _local_3 = NumberUtil.getRandomInt();
            if (_arg_1.chance >= _local_3)
            {
                _local_4 = 0;
                while (_local_4 < _local_2[1].length)
                {
                    _local_5 = _local_2[0][_local_2[1][_local_4]];
                    if (_local_5 != null)
                    {
                        _local_5.duration = (_local_5.duration + _arg_1.amount);
                    };
                    _local_4++;
                };
            };
        }

        public function handleAddBuffDuration(_arg_1:Object):void
        {
            var _local_2:Array;
            var _local_3:int;
            var _local_4:int;
            var _local_5:Object;
            _local_2 = this.getActiveBuff();
            _local_3 = NumberUtil.getRandomInt();
            if (_arg_1.chance >= _local_3)
            {
                _local_4 = 0;
                while (_local_4 < _local_2[1].length)
                {
                    _local_5 = _local_2[0][_local_2[1][_local_4]];
                    if (_local_5 != null)
                    {
                        _local_5.duration = (_local_5.duration + _arg_1.amount);
                    };
                    _local_4++;
                };
            };
        }

        public function showActiveEffects():String
        {
            var _local_1:Array;
            var _local_2:String;
            var _local_3:Boolean;
            var _local_4:Boolean;
            var _local_5:Boolean;
            var _local_6:Boolean;
            var _local_8:Array;
            var _local_9:*;
            var _local_10:String;
            var _local_11:Boolean;
            var _local_12:Boolean;
            var _local_13:Boolean;
            var _local_14:String;
            var _local_15:int;
            _local_1 = [];
            _local_2 = "";
            _local_3 = false;
            _local_4 = false;
            _local_5 = false;
            _local_6 = false;
            var _local_7:* = this.getCurrentModel();
            _local_8 = this.getActiveEffects();
            for each (_local_9 in _local_8)
            {
                _local_10 = _local_9.effect_name;
                _local_11 = Util.checkInArray(_local_9.effect, Effects.dont_need_show_duration);
                _local_12 = Util.checkInArray(_local_9.effect, Effects.need_to_show_minus_duration);
                _local_13 = Util.checkInArray(_local_9.effect, Effects.dont_need_to_show);
                _local_1 = this.handleEffectIfImmediately(_local_9, _local_1);
                if (_local_9.duration < 1)
                {
                    _local_9.duration = 0;
                }
                else
                {
                    _local_14 = ((_local_9.effect_name + " ") + _local_9.duration);
                    if (!_local_13)
                    {
                        if (_local_11)
                        {
                            _local_14 = _local_9.effect_name;
                        }
                        else
                        {
                            if (_local_12)
                            {
                                _local_14 = ((_local_9.effect_name + " ") + (_local_9.duration - 1));
                                if ((_local_9.duration - 1) == 0) continue;
                            };
                            if (Effects.doesEffectSkipTurns(_local_9.effect))
                            {
                                _local_3 = true;
                            };
                            Effects.showEffectInfo(this.user_team, this.user_number, _local_14, false);
                        };
                    };
                };
            };
            if (this.dataBuff.length > 0)
            {
                this.checkAddHealthAfterGotBuff();
                this.checkAddCPAfterGotBuff();
            };
            if (this.dataDebuff.length > 0)
            {
                this.checkAddHealthAfterGotDebuff();
                this.checkAddCPAfterGotDebuff();
            };
            if (_local_1.length > 0)
            {
                _local_15 = 0;
                while (_local_15 < _local_1.length)
                {
                    _local_2 = _local_1[_local_15];
                    if (Effects.doesEffectSkipTurns(_local_1[_local_15]))
                    {
                        _local_3 = true;
                    }
                    else
                    {
                        if (((_local_2 == "chaos") || (_local_2 == "pet_chaos")))
                        {
                            _local_4 = true;
                        }
                        else
                        {
                            if (_local_2 == "barrier")
                            {
                                _local_5 = true;
                            }
                            else
                            {
                                if (((_local_2 == "meridian_seal") || (_local_2 == "pet_meridian_seal")))
                                {
                                    _local_6 = true;
                                };
                            };
                        };
                    };
                    _local_15++;
                };
            };
            if (_local_3)
            {
                _local_2 = "stun";
            }
            else
            {
                if (_local_4)
                {
                    _local_2 = "chaos";
                }
                else
                {
                    if (_local_5)
                    {
                        _local_2 = "barrier";
                    }
                    else
                    {
                        if (_local_6)
                        {
                            _local_2 = "meridian_seal";
                        };
                    };
                };
            };
            return (_local_2);
        }

        public function checkPassiveEffects():*
        {
            var _local_1:Object;
            var _local_2:CharacterManager;
            var _local_3:String;
            var _local_4:String;
            var _local_5:String;
            var _local_6:Array;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_12:int;
            var _local_13:int;
            var _local_14:int;
            var _local_15:int;
            var _local_16:Array;
            var _local_17:Object;
            _local_1 = this.getCurrentModel();
            if (!("character_manager" in _local_1))
            {
                return;
            };
            _local_2 = _local_1.character_manager;
            _local_3 = _local_2.getWeapon();
            _local_4 = _local_2.getBackItem();
            _local_5 = _local_2.getAccessory();
            _local_6 = this.gatherItemEffects(_local_3, _local_4, _local_5);
            _local_7 = _local_1.health_manager.getCurrentHP();
            _local_8 = _local_1.health_manager.getMaxHP();
            _local_9 = _local_1.health_manager.getCurrentCP();
            _local_10 = _local_1.health_manager.getMaxCP();
            var _local_11:int = _local_1.health_manager.getCurrentSP();
            _local_12 = _local_1.health_manager.getMaxSP();
            _local_13 = this.checkRecoverHPFromTalent();
            _local_14 = this.checkRecoverCPFromTalent();
            _local_15 = 0;
            for each (_local_16 in _local_6)
            {
                for each (_local_17 in _local_16)
                {
                    switch (_local_17.effect)
                    {
                        case "sp_recover":
                            _local_15 = (_local_15 + this.calculateRecovery(_local_17, _local_12));
                            break;
                        case "hp_recover":
                        case "recover_hp_every_turn":
                            _local_13 = (_local_13 + this.calculateHPRecovery(_local_17, _local_7, _local_8));
                            break;
                        case "hp_recover_below":
                            _local_13 = (_local_13 + this.handleHPRecoveryBelow(_local_17, _local_7, _local_8));
                            break;
                        case "hp_recover_below_cp":
                            _local_13 = (_local_13 + this.handleHPRecoveryBelowCP(_local_17, _local_9, _local_10, _local_8));
                            break;
                        case "cp_recover_below":
                            _local_14 = (_local_14 + this.handleCPRecoveryBelow(_local_17, _local_9, _local_10));
                            break;
                        case "cp_recover":
                            _local_14 = (_local_14 + this.calculateRecovery(_local_17, _local_10));
                            break;
                        case "hp_cp_recover":
                            _local_13 = (_local_13 + this.calculateHPRecovery(_local_17, _local_7, _local_8));
                            _local_14 = (_local_14 + ((_local_17.calc_type == "number") ? int(_local_17.amount_cp) : Math.floor(((_local_10 * _local_17.amount_cp) / 100))));
                            break;
                        case "rewind":
                            this.handleRewind(_local_17, _local_1);
                            break;
                        case "recover_hp_debuff":
                        case "recover_cp_debuff":
                        case "recover_hp_cp_debuff":
                            this.handleDebuffRecovery(_local_17, _local_13, _local_14, _local_8, _local_10);
                            break;
                        case "attribute_change":
                            this.handleAttributeChange(_local_17, _local_7, _local_8, _local_1);
                            break;
                        case "dodge_change":
                            this.handleDodgeChange(_local_17, _local_7, _local_8, _local_1);
                            break;
                        case "power_up_when":
                            this.handlePowerUp(_local_17, _local_7, _local_8, _local_1);
                            break;
                        case "agility_up_when":
                            this.handleAgilityUp(_local_17, _local_7, _local_8, _local_1);
                            break;
                    };
                };
            };
            if (_local_7 < (_local_8 / 2))
            {
                _local_13 = int((_local_13 + Math.floor(((this.getRecoverHPPercectByTalent() * _local_8) / 100))));
            };
            this.applyEffects(_local_1, _local_13, _local_14, _local_15);
        }

        private function gatherItemEffects(_arg_1:String, _arg_2:String, _arg_3:String):Array
        {
            var _local_4:Array;
            _local_4 = [];
            if (!this.hadEffect("disable_weapon_effect"))
            {
                _local_4.push(((WeaponBuffs.getCopy(_arg_1).effects) || ([])));
            };
            if (_arg_2 !== "back_item_00")
            {
                _local_4.push(((BackItemBuffs.getCopy(_arg_2).effects) || ([])));
            };
            if (_arg_3 !== "accessory_00")
            {
                _local_4.push(((AccessoryBuffs.getCopy(_arg_3).effects) || ([])));
            };
            return (_local_4);
        }

        private function filterActiveDebuffs(_arg_1:Array):Array
        {
            var _local_2:Array;
            var _local_3:int;
            var _local_4:Object;
            _local_2 = [];
            _local_3 = 0;
            while (_local_3 < _arg_1[1].length)
            {
                _local_4 = _arg_1[0][_arg_1[1][_local_3]];
                if (_local_4.duration > 0)
                {
                    _local_2.push(_local_4);
                };
                _local_3++;
            };
            return (_local_2);
        }

        private function calculateRecovery(_arg_1:Object, _arg_2:int):int
        {
            return ((_arg_1.calc_type == "number") ? int(_arg_1.amount) : int(Math.floor(((_arg_2 * _arg_1.amount) / 100))));
        }

        private function calculateHPRecovery(_arg_1:Object, _arg_2:int, _arg_3:int):int
        {
            var _local_4:int;
            var _local_5:int;
            _local_4 = NumberUtil.getRandomInt();
            if ((("chance" in _arg_1) && (_arg_1.chance >= _local_4)))
            {
                if (("hp_requirement" in _arg_1))
                {
                    _local_5 = int(Math.round(((_arg_2 / _arg_3) * 100)));
                    if (_local_5 < _arg_1.hp_requirement)
                    {
                        return (Math.floor(((int(_arg_1.amount) * _arg_3) / 100)));
                    };
                }
                else
                {
                    return ((_arg_1.calc_type == "number") ? int(_arg_1.amount) : int(Math.floor(((int(_arg_1.amount) * _arg_3) / 100))));
                };
            };
            return (0);
        }

        private function handleHPRecoveryBelow(_arg_1:Object, _arg_2:int, _arg_3:int):int
        {
            var _local_4:Boolean;
            _local_4 = (_arg_2 <= Math.floor(((_arg_3 * _arg_1.active_when) / 100)));
            return ((_local_4) ? this.calculateRecovery(_arg_1, _arg_3) : 0);
        }

        private function handleHPRecoveryBelowCP(_arg_1:Object, _arg_2:int, _arg_3:int, _arg_4:int):int
        {
            var _local_5:Boolean;
            _local_5 = (_arg_2 <= Math.floor(((_arg_3 * _arg_1.active_when) / 100)));
            return ((_local_5) ? this.calculateRecovery(_arg_1, _arg_4) : 0);
        }

        private function handleCPRecoveryBelow(_arg_1:Object, _arg_2:int, _arg_3:int):int
        {
            var _local_4:Boolean;
            _local_4 = (_arg_2 <= Math.floor(((_arg_3 * _arg_1.active_when) / 100)));
            return ((_local_4) ? this.calculateRecovery(_arg_1, _arg_3) : 0);
        }

        private function handleRewind(_arg_1:Object, _arg_2:*):void
        {
            var _local_3:int;
            _local_3 = NumberUtil.getRandomInt();
            if (((!("chance" in _arg_1)) || (_arg_1.chance >= _local_3)))
            {
                _arg_2.actions_manager.rewindCooldown(int(_arg_1.amount));
            };
        }

        private function handleDebuffRecovery(_arg_1:Object, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            if (this.dataDebuff.length > 0)
            {
                if (_arg_1.calc_type == "number")
                {
                    if (((_arg_1.effect == "recover_hp_debuff") || (_arg_1.effect == "recover_hp_cp_debuff")))
                    {
                        _arg_2 = (_arg_2 + int(_arg_1.amount));
                    };
                    if (((_arg_1.effect == "recover_cp_debuff") || (_arg_1.effect == "recover_hp_cp_debuff")))
                    {
                        _arg_3 = (_arg_3 + int(_arg_1.amount));
                    };
                }
                else
                {
                    if (((_arg_1.effect == "recover_hp_debuff") || (_arg_1.effect == "recover_hp_cp_debuff")))
                    {
                        _arg_2 = int((_arg_2 + Math.floor(((int(_arg_1.amount) * _arg_4) / 100))));
                    };
                    if (((_arg_1.effect == "recover_cp_debuff") || (_arg_1.effect == "recover_hp_cp_debuff")))
                    {
                        _arg_3 = int((_arg_3 + Math.floor(((int(_arg_1.amount) * _arg_5) / 100))));
                    };
                };
            };
        }

        private function handleAttributeChange(_arg_1:Object, _arg_2:int, _arg_3:int, _arg_4:Object):void
        {
            if (Math.floor(((_arg_2 / _arg_3) * 100)) < _arg_1.chance)
            {
                this.checkPassiveEffectToActiveAfterBeingHit(_arg_4, 100, _arg_1.duration, _arg_1.amount, "number", "kontol_jembut_memek", false, false, "Increase Crit Chance", false, true);
            };
        }

        private function handleDodgeChange(_arg_1:Object, _arg_2:int, _arg_3:int, _arg_4:Object):void
        {
            if (Math.floor(((_arg_2 / _arg_3) * 100)) < _arg_1.chance)
            {
                this.checkPassiveEffectToActiveAfterBeingHit(_arg_4, 100, _arg_1.duration, _arg_1.amount, "number", "deka_kontol", false, false, "Increase Dodge Chance", false, true);
            };
        }

        private function handleAgilityUp(_arg_1:Object, _arg_2:int, _arg_3:int, _arg_4:Object):void
        {
            var _local_5:Object;
            if (Math.floor(((_arg_2 / _arg_3) * 100)) < _arg_1.chance)
            {
                _local_5 = {
                    "effect_name":"Agility Increase",
                    "effect":"increase_agility",
                    "duration":2,
                    "duration_deduct":"immediately",
                    "amount":10,
                    "calc_type":"percent"
                };
                _arg_4.effects_manager.addBuff(_local_5);
            };
        }

        private function handlePowerUp(_arg_1:Object, _arg_2:int, _arg_3:int, _arg_4:Object):void
        {
            var _local_5:Object;
            if (Math.floor(((_arg_2 / _arg_3) * 100)) < _arg_1.chance)
            {
                _local_5 = {
                    "effect_name":"Strengthen",
                    "effect":"power_up",
                    "duration":3,
                    "duration_deduct":"after_attack",
                    "amount":30,
                    "calc_type":"percent"
                };
                _arg_4.effects_manager.addBuff(_local_5);
            };
        }

        private function applyEffects(_arg_1:*, _arg_2:int, _arg_3:int, _arg_4:int):void
        {
            if (_arg_4 > 0)
            {
                _arg_1.health_manager.addSP("SP +", _arg_4);
            };
            if (_arg_2 > 0)
            {
                _arg_1.health_manager.addHealth(_arg_2, " HP +");
            };
            if (_arg_3 > 0)
            {
                _arg_1.health_manager.addCP(_arg_3, " CP +");
            };
        }

        public function deductDurationOfEffects():void
        {
            var _local_2:Array;
            var _local_3:int;
            var _local_4:Object;
            var _local_5:Object;
            var _local_6:String;
            var _local_7:String;
            var _local_1:Object = this.getCurrentModel();
            _local_2 = this.dataBuff.concat(this.dataDebuff);
            _local_3 = (_local_2.length - 1);
            while (_local_3 >= 0)
            {
                _local_5 = _local_2[_local_3];
                if (((_local_5.hasOwnProperty("duration")) && (typeof(_local_5.duration) === "number")))
                {
                    _local_6 = Effects.getEffectDeductType(_local_5.effect);
                    if (_local_6 !== "never")
                    {
                        if (((_local_6 === "after_attack") && (_local_5.duration === 1)))
                        {
                            _local_2.splice(_local_3, 1);
                        }
                        else
                        {
                            if (_local_5.duration > 0)
                            {
                                _local_5.duration--;
                            }
                            else
                            {
                                _local_2.splice(_local_3, 1);
                            };
                        };
                    };
                };
                _local_3--;
            };
            this.dataBuff = [];
            this.dataDebuff = [];
            for each (_local_4 in _local_2)
            {
                _local_7 = (((((_local_4.type === "Buff") || (_local_4.is_master_buff)) || (_local_4.is_buff)) || ((_local_4.is_self) && (!(_local_4.is_debuff)))) ? "buff" : "debuff");
                if (_local_7 === "debuff")
                {
                    this.dataDebuff.push(_local_4);
                }
                else
                {
                    this.dataBuff.push(_local_4);
                };
            };
        }

        public function removeEffect(_arg_1:String):void
        {
            var _local_2:Array;
            var _local_3:int;
            var _local_4:Object;
            var _local_5:Object;
            var _local_6:String;
            _local_2 = this.dataBuff.concat(this.dataDebuff);
            _local_3 = (_local_2.length - 1);
            while (_local_3 >= 0)
            {
                _local_5 = _local_2[_local_3];
                if (_local_5.effect == _arg_1)
                {
                    _local_2.splice(_local_3, 1);
                };
                _local_3--;
            };
            this.dataBuff = [];
            this.dataDebuff = [];
            for each (_local_4 in _local_2)
            {
                _local_6 = (((((_local_4.type === "Buff") || (_local_4.is_master_buff)) || (_local_4.is_buff)) || ((_local_4.is_self) && (!(_local_4.is_debuff)))) ? "buff" : "debuff");
                if (_local_6 === "debuff")
                {
                    this.dataDebuff.push(_local_4);
                }
                else
                {
                    this.dataBuff.push(_local_4);
                };
            };
        }

        public function checkMeridianCutOffFinish():void
        {
            var _local_1:*;
            _local_1 = this.getCurrentModel();
            this.updateMaxCP(_local_1.effects_manager.getEffect("meridian_cut_off"));
            this.updateMaxCP(_local_1.effects_manager.getEffect("pet_meridian_cut_off"));
        }

        private function updateMaxCP(_arg_1:Object):void
        {
            var _local_2:*;
            if ((((_arg_1) && (_arg_1.duration == 0)) && (_arg_1.remove_effect)))
            {
                _arg_1.remove_effect = false;
                _local_2 = this.getCurrentModel();
                _local_2.health_manager.max_cp = _local_2.health_manager.original_max_cp;
                _local_2.health_manager.updateHealthBar();
            };
        }

        public function recalculatingHPCP():void
        {
            var _local_1:*;
        }

        public function checkIncreaseMaxHPCPFinish():void
        {
            var _local_1:Object;
            var _local_2:Object;
            var _local_3:Boolean;
            var _local_4:Boolean;
            var _local_5:Boolean;
            _local_1 = this.getCurrentModel();
            _local_2 = _local_1.effects_manager;
            _local_3 = _local_2.hadEffect("self_love");
            _local_4 = _local_2.hadEffect("domain_expansion");
            _local_5 = _local_2.hadEffect("disable_weapon_effect");
            if (!_local_5)
            {
                this.resetMaxStats(_local_1, "disable_weapon_effect", "decrease");
            };
            if (!_local_4)
            {
                this.resetMaxStats(_local_1, "domain_expansion", "increase");
            };
            if (!_local_3)
            {
                this.resetMaxStats(_local_1, "self_love", "increase");
            }
            else
            {
                this.handleSelfLoveEffect(_local_1, _local_2);
            };
            _local_1.health_manager.capHealthAndCP();
            _local_1.health_manager.updateHealthBar();
        }

        private function handleSelfLoveEffect(_arg_1:Object, _arg_2:Object):void
        {
            var _local_3:Object;
            _local_3 = _arg_2.getEffect("self_love");
            if (_local_3.duration == 1)
            {
                this.addDebuffs(_arg_1, "stun", 1, 0);
                this.addDebuffs(_arg_1, "bleeding", 1, 100);
            };
        }

        private function addDebuffs(_arg_1:Object, _arg_2:String, _arg_3:int, _arg_4:int):void
        {
            var _local_5:Object;
            _local_5 = {
                "effect":_arg_2,
                "duration":_arg_3,
                "amount":_arg_4
            };
            _arg_1.effects_manager.addDebuff(_local_5);
        }

        private function resetMaxStats(_arg_1:Object, _arg_2:String, _arg_3:String):void
        {
            if (_arg_3 == "increase")
            {
                _arg_1.health_manager.max_hp = (_arg_1.health_manager.max_hp - _arg_1.health_manager.effectAddMaxHP[_arg_2].increase_hp);
                _arg_1.health_manager.max_cp = (_arg_1.health_manager.max_cp - _arg_1.health_manager.effectAddMaxCP[_arg_2].increase_cp);
                _arg_1.health_manager.effectAddMaxHP[_arg_2].increase_hp = 0;
                _arg_1.health_manager.effectAddMaxCP[_arg_2].increase_cp = 0;
            }
            else
            {
                _arg_1.health_manager.max_hp = (_arg_1.health_manager.max_hp + _arg_1.health_manager.effectDecreaseMaxHP[_arg_2].modifier_hp);
                _arg_1.health_manager.max_cp = (_arg_1.health_manager.max_cp + _arg_1.health_manager.effectDecreaseMaxCP[_arg_2].modifier_cp);
                _arg_1.health_manager.effectDecreaseMaxHP[_arg_2].modifier_hp = 0;
                _arg_1.health_manager.effectDecreaseMaxCP[_arg_2].modifier_cp = 0;
            };
        }

        public function checkDecreaseMaxCPFinish():void
        {
            var _local_1:*;
            var _local_2:Object;
            var _local_3:Boolean;
            var _local_4:String;
            _local_1 = this.getCurrentModel();
            _local_2 = _local_1.effects_manager.getEffect("decrease_max_cp");
            _local_3 = false;
            for (_local_4 in _local_2)
            {
                if (_local_2[_local_4] > 0)
                {
                    _local_3 = true;
                    break;
                };
            };
            if (((((_local_2) && (_local_2.duration == 0)) && (_local_2.remove_effect)) || (!(_local_3))))
            {
                _local_2.remove_effect = false;
                _local_1.health_manager.max_cp = (_local_1.health_manager.max_cp + _local_1.health_manager.status_change.decrease_cp);
                _local_1.health_manager.status_change.decrease_cp = 0;
            };
            if (_local_1.health_manager.getCurrentCP() > _local_1.health_manager.max_cp)
            {
                _local_1.health_manager.setCurrentCP(_local_1.health_manager.max_cp);
            };
            _local_1.health_manager.updateHealthBar();
        }

        public function checkPurifyOnRoundStart():void
        {
            var _local_1:Object;
            var _local_2:Object;
            _local_1 = this.getEffect("debuff_clear_next_turn");
            _local_2 = this.getEffect("illuminated_chakra_mode");
            if ((((_local_1) && (_local_1.duration > 0)) || ((_local_2) && (_local_2.duration > 0))))
            {
                this.purifyPlayer("Debuff Clear");
                this.checkAddCPAfterGotBuff();
                this.checkAddHealthAfterGotBuff();
            };
        }

        public function checkPeace():*
        {
            var _local_1:*;
            var _local_2:int;
            var _local_3:int;
            var _local_4:Array;
            var _local_5:int;
            var _local_6:*;
            var _local_7:Object;
            _local_1 = this.getCurrentModel();
            _local_2 = 0;
            _local_3 = int(_local_1.health_manager.getMaxCP());
            _local_4 = ((this.user_team == "player") ? BattleManager.getBattle().character_team_players : BattleManager.getBattle().enemy_team_players);
            _local_5 = 0;
            while (_local_5 < _local_4.length)
            {
                _local_6 = _local_4[_local_5];
                _local_7 = _local_6.effects_manager.getEffect("peace");
                if (((_local_7) && (_local_7.duration > 1)))
                {
                    _local_2 = this.increaseOrDecreaseByObject(_local_2, _local_3, _local_7, "amount_cp");
                    _local_1.health_manager.addCP(_local_2, ((("Peace" + " ") + (_local_7.duration - 1)) + " | CP +"));
                };
                _local_5++;
            };
        }

        public function isUnderLockDebuffs():Boolean
        {
            var _local_1:String;
            for each (_local_1 in Effects.lock_effects)
            {
                if (this.hadEffect(_local_1))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function setModel(_arg_1:*):*
        {
            this.model = _arg_1;
        }

        public function getCurrentModel():*
        {
            var _local_1:MovieClip;
            if (this.model != null)
            {
                return (this.model);
            };
            _local_1 = this.getMovieClipHolder();
            return (_local_1.charMc.character_model);
        }

        public function getAccuracyBelowHP():void
        {
            var _local_1:Object;
            var _local_2:int;
            var _local_3:Object;
            var _local_4:int;
            var _local_5:int;
            var _local_6:Array;
            var _local_7:Array;
            var _local_8:Object;
            var _local_9:int;
            _local_1 = this.getCurrentModel();
            _local_2 = 0;
            _local_3 = _local_1.health_manager;
            _local_4 = _local_3.getCurrentHP();
            _local_5 = _local_3.getMaxHP();
            _local_6 = _local_1.effects_manager.getAllCharacterSetEffects();
            for each (_local_7 in _local_6)
            {
                for each (_local_8 in _local_7)
                {
                    if (_local_8.effect == "accuracy_up_below_hp")
                    {
                        _local_9 = int(((_local_5 * _local_8.chance) / 100));
                        if (_local_4 < _local_9)
                        {
                            _local_2 = (_local_2 + _local_8.chance);
                            _local_1.effects_manager.addEffect("Buff", "increase_accuracy", "Increase Accuracy", _local_8.amount, "percent", 1, 100);
                        };
                    };
                };
            };
        }

        public function getCriticalAndAccuracyWhenHPBelow():void
        {
            var _local_1:Object;
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:Object;
            var _local_6:Object;
            var _local_7:Object;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return;
            };
            _local_2 = _local_1.health_manager.getMaxHP();
            _local_3 = _local_1.health_manager.getCurrentHP();
            _local_4 = int(Math.round(((_local_3 / _local_2) * 100)));
            if (_local_1.character_manager.hasSenjutsuSkill("skill_3006"))
            {
                _local_5 = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3006", _local_1.character_manager.getSenjutsuLevel("skill_3006"));
                if (_local_4 <= _local_5.hp_condition)
                {
                    _local_6 = {
                        "effect":"toad_concentration",
                        "effect_name":"Concentration",
                        "duration":1,
                        "amount":_local_5.amount
                    };
                    _local_7 = {
                        "effect":"toad_attention",
                        "effect_name":"Attention",
                        "duration":1,
                        "amount":_local_5.increase_accuracy
                    };
                    _local_1.effects_manager.addBuff(_local_6);
                    _local_1.effects_manager.addBuff(_local_7);
                };
            };
        }

        public function getActivateIlluminatedChakraMode():Object
        {
            var _local_1:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return ({});
            };
            if (!_local_1.character_manager.hasTalentSkill("skill_100001"))
            {
                return ({});
            };
            return (TalentSkillLevel.getTalentSkillLevels("skill_100001", _local_1.character_manager.getTalentLevel("skill_100001")));
        }

        public function getActivateUnyielding():Object
        {
            var _local_2:*;
            var _local_1:Object;
            _local_2 = this.getCurrentModel();
            if (!_local_2.isCharacter())
            {
                return ({});
            };
            if (!_local_2.character_manager.hasTalentSkill("skill_1050"))
            {
                return ({});
            };
            return (TalentSkillLevel.getTalentSkillLevels("skill_1050", _local_2.character_manager.getTalentLevel("skill_1050")));
        }

        public function getActivateEOMRevive():Object
        {
            var _local_2:*;
            var _local_1:Object;
            _local_2 = this.getCurrentModel();
            if (!_local_2.isCharacter())
            {
                return ({});
            };
            if (!_local_2.character_manager.hasTalentSkill("skill_1023"))
            {
                return ({});
            };
            return (TalentSkillLevel.getTalentSkillLevels("skill_1023", _local_2.character_manager.getTalentLevel("skill_1023")));
        }

        public function checkStealJutsu():Boolean
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:Array;
            var _local_4:int;
            var _local_5:String;
            var _local_6:int;
            _local_1 = this.getCurrentModel();
            _local_2 = BattleManager.getBattle().defender_model;
            if (((((!(_local_2.isCharacter())) || (_local_2.effects_manager.hadEffect("unyielding"))) || (_local_2.effects_manager.hadEffect("debuff_resist"))) || (!(_local_1.character_manager.hasSenjutsuSkill("skill_3005")))))
            {
                return (false);
            };
            _local_3 = this.checkEnemiesSkill(_local_2);
            if (_local_3.length == 0)
            {
                return (false);
            };
            _local_4 = int(Math.floor((Math.random() * _local_3.length)));
            _local_5 = _local_3[_local_4];
            if (_local_5 == null)
            {
                return (false);
            };
            _local_6 = int(SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3005", _local_1.character_manager.getSenjutsuLevel("skill_3005")).setCooldown);
            _local_2.actions_manager.setCooldown((_local_6 + 1), _local_5);
            BattleVars.COPY_SKILL_ID_SAVE = _local_5;
            return (true);
        }

        public function checkEnemiesSkill(_arg_1:*):Array
        {
            var _local_2:Array;
            _local_2 = _arg_1.getSkillsCooldown();
            if (_local_2 == null)
            {
                _local_2 = _arg_1.character_manager.getEquippedSkills();
            };
            return (_local_2);
        }

        public function checkCopySkill(_arg_1:String):Boolean
        {
            var _local_2:*;
            var _local_3:Boolean;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            _local_2 = this.getCurrentModel();
            if (!_local_2.isCharacter())
            {
                return (false);
            };
            _local_3 = ((this.user_team == "player") ? Boolean(BattleVars.CHARACTER_REVIVED[this.user_number]) : Boolean(BattleVars.ENEMY_REVIVED[this.user_number]));
            if (((_local_3) || (this.isUnderLockDebuffs())))
            {
                return (false);
            };
            if (!_local_2.character_manager.hasTalentSkill("skill_1018"))
            {
                return (false);
            };
            _local_4 = _local_2.character_manager.getTalentLevel("skill_1018");
            _local_5 = int(TalentSkillLevel.getTalentSkillLevels("skill_1018", _local_4).chance);
            _local_6 = NumberUtil.getRandomInt();
            if (((_local_5 > 0) && (_local_5 >= _local_6)))
            {
                BattleVars.COPY_SKILL_ID_SAVE = _arg_1;
                return (true);
            };
            BattleVars.COPY_SKILL_ID_SAVE = "";
            return (false);
        }

        public function checkRecoverHPFromTalent():int
        {
            var _local_1:*;
            var _local_2:int;
            var _local_3:int;
            var _local_5:*;
            var _local_6:int;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            _local_2 = 0;
            _local_3 = 0;
            var _local_4:* = 0;
            if (_local_1.character_manager.hasTalentSkill("skill_1045"))
            {
                _local_3 = (_local_3 + TalentSkillLevel.getTalentSkillLevels("skill_1045", _local_1.character_manager.getTalentLevel("skill_1045")).amount);
            };
            if (_local_1.character_manager.hasTalentSkill("skill_1046"))
            {
                _local_5 = TalentSkillLevel.getTalentSkillLevels("skill_1046", _local_1.character_manager.getTalentLevel("skill_1046"));
                _local_6 = int(((_local_1.health_manager.getCurrentHP() / _local_1.health_manager.getMaxHP()) * 100));
                _local_2 = _local_5.chance;
                if (_local_2 > _local_6)
                {
                    _local_3 = (_local_3 + _local_5.amount);
                };
            };
            if (_local_1.character_manager.hasTalentSkill("skill_1051"))
            {
                _local_3 = (_local_3 + TalentSkillLevel.getTalentSkillLevels("skill_1051", _local_1.character_manager.getTalentLevel("skill_1051")).amount);
            };
            return (Math.round(_local_3));
        }

        public function checkRecoverCPFromTalent():int
        {
            var _local_1:*;
            var _local_2:int;
            var _local_3:int;
            var _local_5:*;
            var _local_6:int;
            var _local_7:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            if (!_local_1.character_manager.hasTalentSkill("skill_1052"))
            {
                return (0);
            };
            _local_2 = 0;
            _local_3 = 0;
            var _local_4:* = 0;
            _local_5 = ((_local_1.health_manager.getCurrentCP() / _local_1.health_manager.getMaxCP()) * 100);
            _local_6 = _local_1.health_manager.getMaxCP();
            _local_7 = TalentSkillLevel.getTalentSkillLevels("skill_1052", _local_1.character_manager.getTalentLevel("skill_1052"));
            _local_2 = (_local_2 + _local_7.chance);
            if (_local_2 > _local_5)
            {
                _local_3 = int((_local_3 + ((_local_6 * _local_7.amount) / 100)));
            };
            return (Math.round(_local_3));
        }

        public function checkIncreaseRecoverItemFromTalent():Array
        {
            var _local_1:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return ([]);
            };
            if (!_local_1.character_manager.hasTalentSkill("skill_1045"))
            {
                return ([]);
            };
            return (TalentSkillLevel.getTalentSkillLevels("skill_1045", _local_1.character_manager.getTalentLevel("skill_1045")).effects);
        }

        public function checkReboundEffects():Boolean
        {
            var _local_1:Object;
            var _local_2:Boolean;
            var _local_3:int;
            var _local_4:int;
            _local_1 = this.getCurrentModel();
            _local_2 = ((this.user_team == "player") ? Boolean(BattleVars.CHARACTER_REVIVED[this.user_number]) : Boolean(BattleVars.ENEMY_REVIVED[this.user_number]));
            if (!_local_1.isCharacter())
            {
                return (false);
            };
            if (!_local_1.character_manager.hasTalentSkill("skill_1019"))
            {
                return (false);
            };
            _local_3 = int(TalentSkillLevel.getTalentSkillLevels("skill_1019", _local_1.character_manager.getTalentLevel("skill_1019")).chance);
            _local_4 = NumberUtil.getRandomInt();
            var _local_5:Object = ((_local_3 >= _local_4) && (!(_local_2)));
            return ((_local_3 >= _local_4) && (!(_local_2)));
        }

        public function getReduceTaijutsuImprove():Number
        {
            var _local_1:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            if (!_local_1.character_manager.hasTalentSkill("skill_1001"))
            {
                return (0);
            };
            return (Number(TalentSkillLevel.getTalentSkillLevels("skill_1001", _local_1.character_manager.getTalentLevel("skill_1001")).amount_deduct));
        }

        public function getIncreaseDamageForTaijutsu():Number
        {
            var _local_1:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            if (!_local_1.character_manager.hasTalentSkill("skill_1001"))
            {
                return (0);
            };
            return (Number(TalentSkillLevel.getTalentSkillLevels("skill_1001", _local_1.character_manager.getTalentLevel("skill_1001")).amount_increase));
        }

        public function getDebuffResistByTalent():void
        {
            var _local_1:Object;
            var _local_2:int;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return;
            };
            if (_local_1.character_manager.hasTalentSkill("skill_1110"))
            {
                _local_2 = TalentSkillLevel.getTalentSkillLevels("skill_1110", _local_1.character_manager.getTalentLevel("skill_1110")).resist_debuff_chance;
                if (_local_2 >= NumberUtil.getRandomInt())
                {
                    _local_1.debuff_resist = true;
                };
            };
        }

        public function getIncreaseDamageByTalent(_arg_1:int):int
        {
            var _local_2:*;
            var _local_3:int;
            var _local_4:int;
            var _local_5:*;
            _local_2 = this.getCurrentModel();
            if (!_local_2.isCharacter())
            {
                return (0);
            };
            _local_3 = 0;
            _local_4 = 0;
            if (_local_2.character_manager.hasTalentSkill("skill_100001"))
            {
                _local_4 = (_local_4 + TalentSkillLevel.getTalentSkillLevels("skill_100001", _local_2.character_manager.getTalentLevel("skill_100001")).increase_damage);
                _local_3 = int((_local_3 + Math.round(((_arg_1 * _local_4) / 100))));
            }
            else
            {
                if (_local_2.character_manager.hasTalentSkill("skill_1055"))
                {
                    _local_5 = _local_2.health_manager.getMaxCP();
                    _local_4 = (_local_4 + TalentSkillLevel.getTalentSkillLevels("skill_1055", _local_2.character_manager.getTalentLevel("skill_1055")).increase_damage);
                    _local_3 = int((_local_3 + Math.round(((_local_5 * _local_4) / 100))));
                }
                else
                {
                    if (_local_2.character_manager.hasTalentSkill("skill_1102"))
                    {
                        _local_4 = (_local_4 + TalentSkillLevel.getTalentSkillLevels("skill_1102", _local_2.character_manager.getTalentLevel("skill_1102")).increase_damage);
                        _local_3 = int((_local_3 + Math.round(((_arg_1 * _local_4) / 100))));
                    };
                };
            };
            return (_local_3);
        }

        public function getIncreaseDamageBySenjutsu(_arg_1:int):int
        {
            var _local_2:Object;
            var _local_3:int;
            var _local_4:Object;
            _local_2 = this.getCurrentModel();
            if (!_local_2.isCharacter())
            {
                return (0);
            };
            _local_3 = 0;
            if (_local_2.character_manager.hasSenjutsuSkill("skill_3001"))
            {
                _local_4 = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3001", _local_2.character_manager.getSenjutsuLevel("skill_3001"));
                _local_3 = int((_local_3 + Math.round(((_arg_1 * _local_4.increase_damage) / 100))));
            };
            return (Math.round(_local_3));
        }

        public function getReduceDamageTakenByTalent():Number
        {
            var _local_1:*;
            var _local_2:Array;
            var _local_3:Number;
            var _local_4:String;
            var _local_5:int;
            var _local_6:Number;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            _local_2 = ["skill_1014", "skill_1024", "skill_1051"];
            _local_3 = 0;
            for each (_local_4 in _local_2)
            {
                if (_local_1.character_manager.hasTalentSkill(_local_4))
                {
                    _local_5 = _local_1.character_manager.getTalentLevel(_local_4);
                    _local_6 = Number(TalentSkillLevel.getTalentSkillLevels(_local_4, _local_5).reduce_damage_taken);
                    _local_3 = (_local_3 + _local_6);
                    break;
                };
            };
            return (_local_3);
        }

        public function calculateChanceFromTalent_Wolfram(_arg_1:int):void
        {
            var _local_2:*;
            var _local_3:Number;
            var _local_4:int;
            var _local_5:Object;
            var _local_6:Object;
            _local_2 = this.getCurrentModel();
            if (!_local_2.isCharacter())
            {
                return;
            };
            if (!_local_2.character_manager.hasTalentSkill("skill_1107"))
            {
                return;
            };
            _local_3 = NumberUtil.getRandomInt();
            _local_4 = _local_2.character_manager.getTalentLevel("skill_1107");
            _local_5 = TalentSkillLevel.getTalentSkillLevels("skill_1107", _local_4);
            if (((_local_5.chance >= _local_3) && (_arg_1 > _local_5.damage_count)))
            {
                _local_6 = {
                    "passive":false,
                    "type":"Buff",
                    "target":"self",
                    "is_debuff":false,
                    "effect":"wolfram",
                    "effect_name":"Wolfram",
                    "duration_deduct":"after_attack",
                    "duration":1,
                    "amount":_local_5.reduce_damage_taken,
                    "calc_type":"percent"
                };
                _local_2.effects_manager.addBuff(_local_6);
            };
        }

        internal function calculateInsectPurify(_arg_1:int, _arg_2:int):int
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            _local_3 = int(((1 * _arg_2) / 100));
            _local_4 = int((_local_3 * (_arg_2 / _arg_1)));
            _local_5 = (_arg_2 + _local_4);
            return (Math.round(_local_5));
        }

        public function getIncreasePurifyByTalent():Number
        {
            var _local_1:*;
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:Number;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            if (_local_1.character_manager.hasTalentSkill("skill_1051"))
            {
                _local_2 = _local_1.health_manager.getMaxCP();
                _local_3 = TalentSkillLevel.getTalentSkillLevels("skill_1051", _local_1.character_manager.getTalentLevel("skill_1051")).purify_chance_on;
                _local_4 = Math.round((_local_2 / _local_3));
                return (_local_4);
            };
            if (_local_1.character_manager.hasTalentSkill("skill_1102"))
            {
                _local_5 = _local_1.health_manager.getMaxHP();
                _local_3 = TalentSkillLevel.getTalentSkillLevels("skill_1102", _local_1.character_manager.getTalentLevel("skill_1102")).purify_chance_on;
                _local_4 = Math.round((_local_5 / _local_3));
                return (_local_4);
            };
            if (_local_1.character_manager.hasTalentSkill("skill_1061"))
            {
                _local_4 = TalentSkillLevel.getTalentSkillLevels("skill_1061", _local_1.character_manager.getTalentLevel("skill_1061")).increase_purify_chance;
                return (_local_4);
            };
            return (0);
        }

        public function getIncreaseAgilityByTalent():Number
        {
            var _local_1:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            if (_local_1.character_manager.hasTalentSkill("skill_1003"))
            {
                return (Number(TalentSkillLevel.getTalentSkillLevels("skill_1003", _local_1.character_manager.getTalentLevel("skill_1003")).increase_agility));
            };
            return (0);
        }

        public function getIncreaseMaxHPByTalent(_arg_1:int):Number
        {
            var _local_2:*;
            var _local_3:int;
            var _local_4:Number;
            _local_2 = this.getCurrentModel();
            if (!_local_2.isCharacter())
            {
                return (0);
            };
            _local_3 = _local_2.health_manager.getMaxCP();
            _local_4 = 0;
            if (_local_2.character_manager.hasTalentSkill("skill_1003"))
            {
                _local_4 = (_local_4 + ((_arg_1 * TalentSkillLevel.getTalentSkillLevels("skill_1003", _local_2.character_manager.getTalentLevel("skill_1003")).increase_max_hp) / 100));
            }
            else
            {
                if (_local_2.character_manager.hasTalentSkill("skill_1046"))
                {
                    _local_4 = (_local_4 + TalentSkillLevel.getTalentSkillLevels("skill_1046", _local_2.character_manager.getTalentLevel("skill_1046")).increase_max_hp);
                }
                else
                {
                    if (_local_2.character_manager.hasTalentSkill("skill_1052"))
                    {
                        _local_4 = (_local_4 + ((_local_3 * TalentSkillLevel.getTalentSkillLevels("skill_1052", _local_2.character_manager.getTalentLevel("skill_1052")).increase_max_hp) / 100));
                    };
                };
            };
            return (int(_local_4));
        }

        public function getIncreaseMaxHPBySenjutsu(_arg_1:int):Number
        {
            var _local_2:Object;
            var _local_3:int;
            var _local_4:Object;
            _local_2 = this.getCurrentModel();
            if (!_local_2.isCharacter())
            {
                return (0);
            };
            _local_3 = 0;
            if (_local_2.character_manager.hasSenjutsuSkill("skill_3001"))
            {
                _local_4 = SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3001", _local_2.character_manager.getSenjutsuLevel("skill_3001"));
                _local_3 = int((_local_3 + Math.floor(((_arg_1 * _local_4.increase_max_hp) / 100))));
            };
            return (_local_3);
        }

        public function getIncreaseMaxCPByTalent():Number
        {
            var _local_1:*;
            var _local_2:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            _local_2 = 0;
            if (_local_1.character_manager.hasTalentSkill("skill_1010"))
            {
                _local_2 = Number(TalentSkillLevel.getTalentSkillLevels("skill_1010", _local_1.character_manager.getTalentLevel("skill_1010")).increase_max_cp);
            };
            if (_local_1.character_manager.hasTalentSkill("skill_1061"))
            {
                _local_2 = Number(TalentSkillLevel.getTalentSkillLevels("skill_1061", _local_1.character_manager.getTalentLevel("skill_1061")).increase_max_cp);
            };
            if (_local_1.character_manager.hasTalentSkill("skill_100001"))
            {
                _local_2 = Number(TalentSkillLevel.getTalentSkillLevels("skill_100001", _local_1.character_manager.getTalentLevel("skill_100001")).increase_max_cp);
            };
            return (_local_2);
        }

        public function getIncreaseAccuracyByTalent():Number
        {
            var _local_1:Object;
            var _local_2:int;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            _local_2 = 0;
            if (_local_1.character_manager.hasTalentSkill("skill_1006"))
            {
                _local_2 = Number(TalentSkillLevel.getTalentSkillLevels("skill_1006", _local_1.character_manager.getTalentLevel("skill_1006")).increase_accuracy);
            };
            return (_local_2);
        }

        public function getIncreaseDodgeByTalent():Number
        {
            var _local_1:Object;
            var _local_2:int;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            _local_2 = 0;
            if (_local_1.character_manager.hasTalentSkill("skill_1006"))
            {
                _local_2 = Number(TalentSkillLevel.getTalentSkillLevels("skill_1006", _local_1.character_manager.getTalentLevel("skill_1006")).increase_dodge);
            };
            return (_local_2);
        }

        public function getIgnoreDodgeBySenjutsu():Number
        {
            var _local_1:Object;
            var _local_2:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            _local_2 = 0;
            if (_local_1.character_manager.hasSenjutsuSkill("skill_3104"))
            {
                _local_2 = (_local_2 + SenjutsuSkillLevel.getSenjutsuSkillLevels("skill_3104", _local_1.character_manager.getSenjutsuLevel("skill_3104")).ignore_dodge);
            };
            return (Math.round(_local_2));
        }

        public function getChanceToInflictChaosByTalent(_arg_1:Object):*
        {
            var _local_2:Object;
            var _local_3:Object;
            var _local_4:Object;
            var _local_7:Object;
            var _local_8:int;
            var _local_9:Object;
            var _local_10:Object;
            _local_2 = this.getCurrentModel();
            _local_3 = BattleManager.getBattle().getAttacker();
            _local_4 = BattleManager.getBattle().getDefender();
            var _local_5:int;
            var _local_6:Boolean;
            if (_arg_1 == _local_3)
            {
                _local_2 = _local_4;
            };
            if (!_local_2.isCharacter())
            {
                return;
            };
            if (_local_2.character_manager.hasTalentSkill("skill_1101"))
            {
                _local_7 = TalentSkillLevel.getTalentSkillLevels("skill_1101", _local_2.character_manager.getTalentLevel("skill_1101"));
                _local_8 = NumberUtil.getRandomInt();
                if (_local_7.chance >= _local_8)
                {
                    _local_9 = {
                        "effect":"chaos",
                        "add_in_array":true,
                        "duration_deduct":"immediately",
                        "duration":_local_7.chaos_duration
                    };
                    _arg_1.effects_manager.addDebuff(_local_9);
                    _local_10 = {
                        "isTrue":true,
                        "amount":_local_7.hp_recover
                    };
                    _local_2.ultimate_string = _local_10;
                };
            };
        }

        public function getRecoverWhenHPReducedByTalent():Number
        {
            var _local_1:*;
            var _local_2:int;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            _local_1 = this.getCurrentModel();
            _local_2 = 0;
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            if (_local_1.character_manager.hasTalentSkill("skill_1054"))
            {
                _local_3 = TalentSkillLevel.getTalentSkillLevels("skill_1054", _local_1.character_manager.getTalentLevel("skill_1054"));
                _local_4 = _local_3.chance;
                _local_5 = NumberUtil.getRandomInt();
                if (_local_4 >= _local_5)
                {
                    _local_2 = (_local_2 + _local_3.recover_hp);
                };
            };
            return (_local_2);
        }

        public function getReboundAsDamageByTalent():Number
        {
            var _local_1:*;
            var _local_2:int;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            _local_2 = 0;
            if (_local_1.character_manager.hasTalentSkill("skill_1007"))
            {
                _local_2 = Number(TalentSkillLevel.getTalentSkillLevels("skill_1007", _local_1.character_manager.getTalentLevel("skill_1007")).receive_damage_prc);
            };
            return (_local_2);
        }

        public function getStunChanceAfterReboundByTalent():Number
        {
            var _local_1:*;
            var _local_2:int;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            _local_2 = 0;
            if (_local_1.character_manager.hasTalentSkill("skill_1007"))
            {
                _local_2 = Number(TalentSkillLevel.getTalentSkillLevels("skill_1007", _local_1.character_manager.getTalentLevel("skill_1007")).stun_chance);
            };
            return (_local_2);
        }

        public function getResistStunPrcByTalent():Number
        {
            var _local_1:*;
            var _local_2:int;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            _local_2 = 0;
            if (_local_1.character_manager.hasTalentSkill("skill_1014"))
            {
                _local_2 = Number(TalentSkillLevel.getTalentSkillLevels("skill_1014", _local_1.character_manager.getTalentLevel("skill_1014")).increase_resist_stun);
            };
            return (_local_2);
        }

        public function getResistPoisonPrcByTalent():Number
        {
            var _local_1:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            if (!_local_1.character_manager.hasTalentSkill("skill_1025"))
            {
                return (0);
            };
            return (100);
        }

        public function getIncreaseChargeCPByTalent():Number
        {
            var _local_1:*;
            var _local_2:int;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            _local_2 = 0;
            if (_local_1.character_manager.hasTalentSkill("skill_1010"))
            {
                _local_2 = Number(TalentSkillLevel.getTalentSkillLevels("skill_1010", _local_1.character_manager.getTalentLevel("skill_1010")).increase_charge);
            };
            return (_local_2);
        }

        public function getReboundDamageChanceFromTalent():int
        {
            var _local_1:Object;
            var _local_2:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            if (!_local_1.character_manager.hasTalentSkill("skill_1015"))
            {
                return (0);
            };
            _local_2 = TalentSkillLevel.getTalentSkillLevels("skill_1015", _local_1.character_manager.getTalentLevel("skill_1015"));
            return (_local_2.chance_to_rebound);
        }

        public function getReboundDamageFromTalent():int
        {
            var _local_1:Object;
            var _local_2:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            if (!_local_1.character_manager.hasTalentSkill("skill_1015"))
            {
                return (0);
            };
            _local_2 = TalentSkillLevel.getTalentSkillLevels("skill_1015", _local_1.character_manager.getTalentLevel("skill_1015"));
            return (_local_2.amount_rebound);
        }

        public function getReboundAndReboundAmountChance():Array
        {
            var _local_2:*;
            var _local_3:*;
            var _local_1:* = undefined;
            _local_2 = this.getCurrentModel();
            if (!_local_2.isCharacter())
            {
                return ([0, 0]);
            };
            if (!_local_2.character_manager.hasTalentSkill("skill_1015"))
            {
                return ([0, 0]);
            };
            _local_3 = TalentSkillLevel.getTalentSkillLevels("skill_1015", _local_2.character_manager.getTalentLevel("skill_1015"));
            return ([_local_3.chance_to_rebound, _local_3.amount_rebound]);
        }

        public function getRecoverHPAfterDealingDmgByTalent():Array
        {
            var _local_2:*;
            var _local_3:*;
            var _local_1:Object;
            _local_2 = this.getCurrentModel();
            if (!_local_2.isCharacter())
            {
                return ([0, 0]);
            };
            if (!_local_2.character_manager.hasTalentSkill("skill_1025"))
            {
                return ([0, 0]);
            };
            _local_3 = TalentSkillLevel.getTalentSkillLevels("skill_1025", _local_2.character_manager.getTalentLevel("skill_1025"));
            return ([_local_3.chance_to_recover, _local_3.amount_recover_hp]);
        }

        public function getRecoverHPFromPassive():Object
        {
            var _local_1:*;
            var _local_2:Array;
            var _local_3:Array;
            var _local_4:Object;
            var _local_5:*;
            var _local_6:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return ({});
            };
            _local_2 = _local_1.effects_manager.getAllCharacterSetEffects();
            _local_3 = [];
            _local_4 = {};
            _local_5 = 0;
            while (_local_5 < _local_2.length)
            {
                _local_3 = _local_2[_local_5];
                _local_6 = 0;
                while (_local_6 < _local_3.length)
                {
                    if (_local_3[_local_6].effect == "bloodfeed_attack")
                    {
                        _local_4 = _local_3[_local_6];
                    };
                    _local_6++;
                };
                _local_5++;
            };
            return (_local_4);
        }

        public function getRecoverHPPercectByTalent():Number
        {
            var _local_1:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            if (!_local_1.character_manager.hasTalentSkill("skill_1024"))
            {
                return (0);
            };
            return (Number(TalentSkillLevel.getTalentSkillLevels("skill_1024", _local_1.character_manager.getTalentLevel("skill_1024")).recover_after_half_hp));
        }

        public function getUseChanceToUseSkillWithoutCP():int
        {
            var _local_1:*;
            var _local_2:int;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            _local_2 = 0;
            if (_local_1.character_manager.hasTalentSkill("skill_100001"))
            {
                _local_2 = int(TalentSkillLevel.getTalentSkillLevels("skill_100001", _local_1.character_manager.getTalentLevel("skill_100001")).chance_to_use_skill_no_cp);
            };
            return (_local_2);
        }

        public function getCooldownDecreaseForSkills():int
        {
            var _local_1:*;
            var _local_2:int;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            _local_2 = 0;
            if (_local_1.character_manager.hasTalentSkill("skill_100001"))
            {
                _local_2 = int(TalentSkillLevel.getTalentSkillLevels("skill_100001", _local_1.character_manager.getTalentLevel("skill_100001")).cooldown_decrease);
            };
            return (_local_2);
        }

        public function getCaptureChanceFromSilhouette():Object
        {
            var _local_1:*;
            var _local_2:Object;
            var _local_3:*;
            var _local_4:Object;
            var _local_5:int;
            _local_1 = this.getCurrentModel();
            if (((!(_local_1.isCharacter())) || (!(_local_1.character_manager.hasTalentSkill("skill_1036")))))
            {
                return ({
                    "chance":0,
                    "amount":0,
                    "duration":0
                });
            };
            _local_2 = _local_1.effects_manager.getEffect("increase_silhouette_chance");
            _local_3 = TalentSkillLevel.getTalentSkillLevels("skill_1036", _local_1.character_manager.getTalentLevel("skill_1036"));
            _local_4 = {
                "chance":_local_3.chance,
                "amount":_local_3.amount,
                "duration":_local_3.duration
            };
            _local_5 = 0;
            if (_local_1.effects_manager.hadEffect("increase_silhouette_chance"))
            {
                _local_5 = (_local_5 + _local_2.amount);
            };
            _local_4.chance = (_local_4.chance + _local_5);
            return (_local_4);
        }

        public function getChanceToRecoverPercentHPCP():Object
        {
            var _local_1:Object;
            var _local_2:*;
            _local_1 = this.getCurrentModel();
            if (((!(_local_1.isCharacter())) || (!(_local_1.character_manager.hasTalentSkill("skill_1033")))))
            {
                return ({
                    "chance":0,
                    "amount":0
                });
            };
            _local_2 = TalentSkillLevel.getTalentSkillLevels("skill_1033", _local_1.character_manager.getTalentLevel("skill_1033"));
            return ({
                "chance":_local_2.chance,
                "amount":_local_2.amount
            });
        }

        public function getWeakenEnemyChanceByAttack():Object
        {
            var _local_1:Object;
            var _local_2:Object;
            _local_1 = this.getCurrentModel();
            if (((!(_local_1.isCharacter())) || (!(_local_1.character_manager.hasTalentSkill("skill_1030")))))
            {
                return ({
                    "chance":0,
                    "amount":0,
                    "duration":0
                });
            };
            _local_2 = TalentSkillLevel.getTalentSkillLevels("skill_1030", _local_1.character_manager.getTalentLevel("skill_1030"));
            return ({
                "chance":_local_2.chance,
                "amount":_local_2.amount,
                "duration":_local_2.duration
            });
        }

        public function getFreezeEnemyChanceByAttack():Object
        {
            var _local_1:Object;
            var _local_2:Object;
            _local_1 = this.getCurrentModel();
            if (((!(_local_1.isCharacter())) || (!(_local_1.character_manager.hasTalentSkill("skill_1042")))))
            {
                return ({
                    "chance":0,
                    "duration":0
                });
            };
            _local_2 = TalentSkillLevel.getTalentSkillLevels("skill_1042", _local_1.character_manager.getTalentLevel("skill_1042"));
            return ({
                "chance":_local_2.chance,
                "duration":_local_2.duration
            });
        }

        public function getIncreaseFireJutsuDamage():Number
        {
            var _local_1:*;
            var _local_2:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            if (!_local_1.character_manager.hasTalentSkill("skill_1039"))
            {
                return (0);
            };
            _local_2 = TalentSkillLevel.getTalentSkillLevels("skill_1039", _local_1.character_manager.getTalentLevel("skill_1039"));
            return (Number(_local_2.amount));
        }

        public function getIncreaseEarthJutsuDamage():Number
        {
            var _local_1:*;
            var _local_2:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            if (!_local_1.character_manager.hasTalentSkill("skill_1039"))
            {
                return (0);
            };
            _local_2 = TalentSkillLevel.getTalentSkillLevels("skill_1039", _local_1.character_manager.getTalentLevel("skill_1039"));
            return (Number(_local_2.amount));
        }

        public function getRecoverCPAmountFromDealtDmg():int
        {
            var _local_1:*;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return (0);
            };
            if (!_local_1.character_manager.hasTalentSkill("skill_1066"))
            {
                return (0);
            };
            return (TalentSkillLevel.getTalentSkillLevels("skill_1066", _local_1.character_manager.getTalentLevel("skill_1066")).restore_cp_prc);
        }

        public function getPassiveSkills():Array
        {
            var _local_1:*;
            var _local_2:Array;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return ([]);
            };
            _local_2 = _local_1.actions_manager.getTalentPassiveSkills();
            if ((_local_2 is Array))
            {
                return (_local_2);
            };
            return ([]);
        }

        public function getPassiveSenjutsuSkills():Array
        {
            var _local_1:*;
            var _local_2:Array;
            _local_1 = this.getCurrentModel();
            if (!_local_1.isCharacter())
            {
                return ([]);
            };
            _local_2 = _local_1.actions_manager.getSenjutsuPassiveSkills();
            if ((_local_2 is Array))
            {
                return (_local_2);
            };
            return ([]);
        }

        public function getSenjutsuSkills(_arg_1:*):Array
        {
            var _local_2:Array;
            var _local_3:Array;
            var _local_4:*;
            _local_2 = [];
            if (!_arg_1.isCharacter())
            {
                return (_local_2);
            };
            _local_3 = _arg_1.character_manager.getSenjutsuSkills();
            _local_4 = 0;
            while (_local_4 < _local_3.length)
            {
                _local_2.push(_local_3[_local_4]);
                _local_4++;
            };
            return (_local_2);
        }

        public function checkRestoreCPAfterDealtDamage(_arg_1:int):*
        {
            var _local_2:*;
            var _local_3:int;
            _local_2 = BattleManager.getBattle().getAttacker();
            _local_3 = int(_local_2.effects_manager.getRecoverCPAmountFromDealtDmg());
            if (_local_3 > 0)
            {
                _arg_1 = int(Math.floor(((_local_3 * _arg_1) / 100)));
                _local_2.health_manager.addCP(_arg_1, "Restore CP +");
            };
        }

        public function checkWeakenEnemy():void
        {
            var _local_1:Object;
            var _local_2:Object;
            var _local_3:int;
            var _local_4:Object;
            _local_1 = BattleManager.getBattle().getAttacker();
            _local_2 = _local_1.effects_manager.getWeakenEnemyChanceByAttack();
            _local_3 = NumberUtil.getRandomInt();
            if (_local_2.chance > _local_3)
            {
                _local_4 = {
                    "effect":"weaken",
                    "duration":_local_2.duration,
                    "amount":_local_2.amount
                };
                this.addDebuff(_local_4);
            };
        }

        public function checkFreezeEnemy():void
        {
            var _local_1:Object;
            var _local_2:Object;
            var _local_3:int;
            var _local_4:Object;
            _local_1 = BattleManager.getBattle().getAttacker();
            _local_2 = _local_1.effects_manager.getFreezeEnemyChanceByAttack();
            _local_3 = NumberUtil.getRandomInt();
            if (_local_2.chance > _local_3)
            {
                _local_4 = {
                    "effect":"frozen",
                    "duration":_local_2.duration,
                    "amount":80
                };
                this.addDebuff(_local_4);
            };
        }

        public function checkRecoverHPAfterHealthDeduct(_arg_1:int):*
        {
            var _local_2:*;
            var _local_3:Array;
            var _local_4:Object;
            var _local_5:int;
            var _local_6:int;
            _local_2 = BattleManager.getBattle().getAttacker();
            if (!_local_2.isCharacter())
            {
                return (0);
            };
            _local_3 = _local_2.effects_manager.getRecoverHPAfterDealingDmgByTalent();
            _local_4 = _local_2.effects_manager.getRecoverHPFromPassive();
            _local_5 = NumberUtil.getRandomInt();
            _local_6 = 0;
            if (_local_3[0] > _local_5)
            {
                _local_6 = int(Math.floor(((_local_3[1] * _arg_1) / 100)));
                _local_2.health_manager.addHealth(_local_6, "Dmg Dealt HP +");
            };
            if (((_local_4.effect == "bloodfeed_attack") && (BattleVars.ATTACK_TYPE == "weapon")))
            {
                if ((("chance" in _local_4) && (_local_4.chance >= _local_5)))
                {
                    _local_6 = int(Math.floor(((_local_4.amount * _arg_1) / 100)));
                    _local_2.health_manager.addHealth(_local_6, "Bloodfeed +");
                };
            };
        }

        public function checkRecoverHPAfterAttacked(_arg_1:Object):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:Array;
            var _local_5:Array;
            var _local_6:*;
            if (!_arg_1.isCharacter())
            {
                return;
            };
            _local_2 = NumberUtil.getRandomInt();
            _local_3 = 0;
            _local_4 = this.getAllCharacterSetEffects();
            for each (_local_5 in _local_4)
            {
                for each (_local_6 in _local_5)
                {
                    if (_local_6.effect == "recover_hp_when_attacked")
                    {
                        if (_local_6.chance >= _local_2)
                        {
                            _local_3 = _local_6.amount;
                            if (_local_6.calc_type == "percent")
                            {
                                _local_3 = int(Math.round(((_arg_1.health_manager.getMaxHP() * _local_3) / 100)));
                            };
                            _arg_1.health_manager.addHealth(_local_3, "Recovered HP +");
                            return;
                        };
                    };
                };
            };
        }

        public function checkReboundAfterHPDeduct(_arg_1:int):void
        {
            var _local_2:*;
            var _local_3:*;
            _local_2 = this.getCurrentModel();
            _local_3 = BattleManager.getBattle().getAttacker();
            this.handleReactiveForce(_local_2, _local_3, _arg_1);
            this.handleReboundDamage(_local_2, _local_3, _arg_1);
        }

        private function handleReactiveForce(_arg_1:Object, _arg_2:Object, _arg_3:int):void
        {
            var _local_4:Number;
            var _local_5:Array;
            var _local_6:*;
            var _local_7:int;
            var _local_8:Array;
            var _local_9:Array;
            var _local_10:int;
            var _local_11:int;
            var _local_12:*;
            _local_4 = 0;
            _local_5 = null;
            _local_6 = undefined;
            _local_7 = 30;
            if (_arg_1.isCharacter())
            {
                _local_4 = (_arg_1.character_manager.getEarthAttributes() * 0.4);
                _local_5 = this.getEquippedSetForEffects("reactive_force");
                _local_4 = BattleManager.modifyChance(_local_5, "ADD", _local_4, "reactive_force");
            }
            else
            {
                _local_4 = Number(_arg_1.getReactiveForce());
            };
            _local_8 = _arg_1.effects_manager.getActiveBuff("reactive");
            _local_9 = _arg_1.effects_manager.getActiveDebuff("reactive");
            _local_4 = BattleManager.modifyChance(_local_8, "ADD", _local_4, "reactive_force");
            _local_4 = BattleManager.modifyChance(_local_9, "RM", _local_4, "reactive_force");
            if (_local_8.length > 0)
            {
                _local_11 = 0;
                while (_local_11 < _local_8[0].length)
                {
                    _local_12 = _local_8[0][_local_8[1][_local_11]];
                    if (_local_12.effect == "reactive_force")
                    {
                        _local_7 = int(_local_12.amount_reactive);
                        _local_4 = (_local_4 + int(_local_12.amount));
                    };
                    _local_11++;
                };
            };
            _local_10 = NumberUtil.getRandomInt();
            if (_local_4 > _local_10)
            {
                _local_6 = Math.floor(((_local_7 * _arg_3) / 100));
                _arg_2.health_manager.reduceHealth(_local_6, "Reactive Force HP -");
            };
        }

        private function handleReboundDamage(_arg_1:Object, _arg_2:Object, _arg_3:int):void
        {
            var _local_4:Array;
            var _local_5:int;
            var _local_6:int;
            _local_4 = this.getReboundAndReboundAmountChance();
            _local_5 = NumberUtil.getRandomInt();
            if (_local_4[0] > _local_5)
            {
                _local_6 = int(_local_4[1]);
                _arg_3 = int(Math.floor(((_local_6 * _arg_3) / 100)));
                _arg_2.health_manager.reduceHealth(_arg_3, "Rebound HP -");
            };
        }

        public function checkReactiveChanceDrop(_arg_1:Number):Number
        {
            var _local_2:Object;
            var _local_3:Array;
            var _local_4:Array;
            var _local_5:int;
            _local_2 = null;
            _local_3 = this.user_debuffs;
            _local_4 = this.all_debuffs_name_array;
            _local_5 = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_3[_local_4[_local_5]];
                if (((this.hadEffect(_local_2.effect)) && (Effects.doesEffectLowerReactiveForceChance(_local_2.effect))))
                {
                    _arg_1 = (_arg_1 - _local_2.amount);
                };
                _local_5++;
            };
            return (_arg_1);
        }

        public function activateMeridianKekkai(_arg_1:int, _arg_2:String, _arg_3:*):void
        {
            var _local_4:Array;
            var _local_5:Boolean;
            var _local_6:String;
            _local_4 = ["skill", "talent", "CP -", "CP Reduce -", "Flaming -", "Suffocate -", "Prison -", "Reduce HP & CP -"];
            _local_5 = false;
            for each (_local_6 in _local_4)
            {
                if (_arg_2 === _local_6)
                {
                    _local_5 = true;
                    break;
                };
            };
            if (!_local_5)
            {
                this.checkForReboundAsDamage(_arg_1, _arg_3);
            };
        }

        public function checkForReboundAsDamage(_arg_1:int, _arg_2:int):*
        {
            var _local_3:int;
            var _local_4:Object;
            var _local_5:*;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:*;
            var _local_10:*;
            var _local_12:Boolean;
            var _local_13:*;
            _local_3 = 0;
            _local_4 = null;
            _local_5 = this.getCurrentModel();
            if (!_local_5.isCharacter())
            {
                return (0);
            };
            _local_6 = NumberUtil.getRandomInt();
            _local_7 = this.getReboundAsDamageByTalent();
            _local_8 = this.getStunChanceAfterReboundByTalent();
            _local_9 = BattleManager.getBattle().getAttacker();
            var _local_11:int = int((_local_10 = _local_5).health_manager.getCurrentCP());
            if (!_local_9.effects_manager.hasDebuffResist(_local_9))
            {
                if (_local_7 > 0)
                {
                    _local_13 = Math.round(((_local_7 * _arg_2) / 100));
                    _local_3 = int(Math.round(((_local_7 * _arg_1) / 100)));
                    _local_3 = ((_local_13 > _local_3) ? _local_3 : _local_13);
                    if (_local_3 > 0)
                    {
                        _local_9.health_manager.reduceHealth(_local_3, "Meridian Kekkai HP -");
                    };
                };
                _local_12 = Boolean(_local_9.effects_manager.getAcceptChance("stun"));
                if (((((_local_3 > 0) && (_local_8 >= _local_6)) && (_local_12)) && (!(_local_9.debuff_resist))))
                {
                    _local_4 = new Object();
                    _local_4.effect = "stun";
                    _local_4.effect_name = "Stun";
                    _local_4.duration = 1;
                    _local_4.chance = 100;
                    _local_9.effects_manager.addDebuff(_local_4);
                };
            };
        }

        public function getAcceptChance(_arg_1:String):Boolean
        {
            var _local_2:*;
            var _local_3:int;
            var _local_4:Number;
            var _local_5:int;
            _local_2 = this.getCurrentModel();
            _local_3 = 0;
            _local_4 = 0;
            if (((_arg_1 == "stun") || (_arg_1 == "pet_stun")))
            {
                _local_3 = ((_local_2.isCharacter()) ? 0 : 30);
                _local_4 = Number(_local_2.effects_manager.getResistStunPrcByTalent());
                _local_3 = (_local_3 + _local_4);
            };
            _local_5 = NumberUtil.getRandomInt();
            return (((_local_3 > 0) && (_local_3 >= _local_5)) ? false : true);
        }

        public function handleEffectIfImmediately(_arg_1:Object, _arg_2:Array):Array
        {
            var _local_3:*;
            var _local_4:Object;
            var _local_5:String;
            var _local_6:String;
            var _local_7:Boolean;
            var _local_8:Object;
            var _local_9:Object;
            var _local_10:Object;
            var _local_11:String;
            if (_arg_1.duration === 0)
            {
                return (_arg_2);
            };
            _local_3 = this.getCurrentModel();
            _local_4 = _local_3.health_manager;
            _local_5 = (((_arg_1) && (_arg_1.effect_name)) ? String(_arg_1.effect_name) : "");
            _local_6 = _arg_1.effect;
            _local_7 = _local_3.effects_manager.hadEffect("skip_turn");
            _local_8 = {
                "hp":_local_4.getMaxHP(),
                "cp":_local_4.getMaxCP(),
                "sp":_local_4.getMaxSP()
            };
            _local_9 = {
                "hp":{
                    "inc":0,
                    "dec":0
                },
                "cp":{
                    "inc":0,
                    "dec":0
                },
                "sp":{
                    "inc":0,
                    "dec":0
                }
            };
            switch (_local_6)
            {
                case "infection":
                case "inquisitor":
                    if (Effects.doesEffectDecreaseHealth(_local_6))
                    {
                        _local_9.hp.dec = this.calculateEffectAmount(0, _local_8.hp, _arg_1, "amount_reduce");
                    };
                    break;
                case "chill":
                    if (Effects.doesEffectDecreaseHealth(_local_6))
                    {
                        _local_9.hp.dec = this.calculateEffectAmount(0, _local_8.hp, _arg_1, "frostbite_amount");
                    };
                    break;
                case "parasite":
                    this.parasiteDrain(_arg_1);
                    break;
                default:
                    _local_10 = {
                        "hp":{
                            "dec":((Effects.doesEffectDecreaseHealth(_local_6)) && (!(_local_7))),
                            "inc":((Effects.doesEffectIncreaseHealth(_local_6)) && (!(_local_7)))
                        },
                        "cp":{
                            "dec":Effects.doesEffectDecreaseCP(_local_6),
                            "inc":Effects.doesEffectIncreaseCP(_local_6)
                        },
                        "sp":{"dec":Effects.doesEffectDecreaseSP(_local_6)}
                    };
                    for (_local_11 in _local_10)
                    {
                        if (_local_10[_local_11].dec)
                        {
                            _local_9[_local_11].dec = (_local_9[_local_11].dec + this.calculateEffectAmount(0, _local_8[_local_11], _arg_1, ((_local_11 === "cp") ? "amount_cp" : "amount")));
                        };
                        if (_local_10[_local_11].inc)
                        {
                            _local_9[_local_11].inc = (_local_9[_local_11].inc + this.calculateEffectAmount(0, _local_8[_local_11], _arg_1, ((_local_11 === "cp") ? "amount_cp" : "amount")));
                        };
                    };
            };
            if (_local_9.hp.inc > 0)
            {
                _local_4.addHealth(_local_9.hp.inc, (_local_5 + " +"));
            };
            if (_local_9.cp.inc > 0)
            {
                _local_4.addCP(_local_9.cp.inc, (_local_5 + " +"));
            };
            if (_local_9.hp.dec > 0)
            {
                _local_4.reduceHealth(_local_9.hp.dec, (_local_5 + " -"));
            };
            if (_local_9.cp.dec > 0)
            {
                _local_4.reduceCP(_local_9.cp.dec, (_local_5 + " -"));
            };
            if (_local_9.sp.dec > 0)
            {
                _local_4.reduceSP(_local_9.sp.dec, (_local_5 + " -"));
            };
            if (_arg_1.add_in_array === true)
            {
                _arg_2.push(_arg_1.effect);
            };
            return (_arg_2);
        }

        private function calculateEffectAmount(_arg_1:int, _arg_2:int, _arg_3:Object, _arg_4:String="amount"):int
        {
            return (this.increaseOrDecreaseByObject(_arg_1, _arg_2, _arg_3, _arg_4));
        }

        public function increaseOrDecreaseByObject(_arg_1:int, _arg_2:int, _arg_3:Object, _arg_4:String="amount"):int
        {
            var _local_5:Number;
            var _local_6:Boolean;
            if (!_arg_3)
            {
                return (_arg_1);
            };
            _local_6 = (_arg_3.calc_type == "percent");
            if (_arg_4 == "amount_cp")
            {
                _local_5 = ((_arg_3.amount_cp) || (0));
            }
            else
            {
                if (_arg_4 == "frostbite_amount")
                {
                    _local_5 = ((_local_6) ? ((_arg_3.frostbite_amount) || (0)) : 0);
                }
                else
                {
                    if (_arg_4 == "amount_reduce")
                    {
                        _local_5 = ((_local_6) ? ((_arg_3.amount_reduce) || (0)) : 0);
                    }
                    else
                    {
                        _local_5 = ((_arg_3.amount) || (0));
                    };
                };
            };
            return (_arg_1 + ((_local_6) ? Math.floor(((_local_5 * _arg_2) / 100)) : int(_local_5)));
        }

        public function checkPreventDeath(_arg_1:*, _arg_2:int):int
        {
            var _local_8:Object;
            var _local_9:*;
            var _local_3:* = BattleManager.getBattle().getAttacker();
            var _local_4:int = int(_arg_1.health_manager.getCurrentCP());
            var _local_5:int = int(_arg_1.health_manager.getMaxCP());
            var _local_6:Array = this.dataBuff;
            var _local_7:Array = this.dataDebuff;
            _local_9 = _arg_2;
            if ((_local_8 = this.getEffect("unyielding")).duration > 0)
            {
                if (_local_9 <= 0)
                {
                    _local_9 = 0;
                };
            };
            return (_local_9);
        }

        public function checkUnyielding(_arg_1:*):*
        {
            var _local_3:Object;
            var _local_2:Array = this.dataBuff;
            if ((_local_3 = this.getEffect("unyielding")).duration > 0)
            {
            };
        }

        public function checkReduceHealthEffects(_arg_1:*, _arg_2:int):int
        {
            var _local_3:*;
            var _local_4:int;
            var _local_5:*;
            var _local_6:*;
            var _local_7:int;
            var _local_11:Object;
            var _local_12:Object;
            var _local_13:Object;
            var _local_14:Object;
            var _local_15:Object;
            var _local_16:Object;
            var _local_17:Object;
            var _local_18:Object;
            var _local_19:int;
            var _local_20:Object;
            var _local_21:Object;
            var _local_22:int;
            var _local_23:Array;
            var _local_24:*;
            var _local_25:int;
            var _local_26:int;
            var _local_27:int;
            var _local_28:int;
            var _local_29:int;
            var _local_30:int;
            _local_3 = undefined;
            _local_4 = 0;
            if (BattleVars.CAN_NOT_DODGE)
            {
                return (_arg_2);
            };
            _local_5 = BattleManager.getBattle().getAttacker();
            _local_6 = BattleManager.getBattle().getDefender();
            _local_7 = int(_arg_1.health_manager.getCurrentCP());
            var _local_8:int = int(_arg_1.health_manager.getMaxCP());
            var _local_9:* = _local_6.effects_manager.getAllCharacterSetEffects();
            var _local_10:Array;
            if ((((_local_11 = this.getEffect("damage_absorption")).duration > 0) && (!(BattleVars.REDUCED_HP_AS_DAMAGE))))
            {
                _local_3 = Math.floor(((_arg_2 * _local_11.amount) / 100));
                _arg_2 = (_arg_2 - _local_3);
                _arg_1.health_manager.addHealth(_local_3, "DamageAbsorption ");
                if (_arg_2 <= 0)
                {
                    return (0);
                };
            };
            if ((((_local_12 = this.getEffect("liquidation_armor")).duration > 0) && (!(BattleVars.REDUCED_HP_AS_DAMAGE))))
            {
                _local_3 = Math.floor(((_arg_2 * _local_12.amount) / 100));
                _arg_2 = (_arg_2 - _local_3);
                _arg_1.health_manager.addHealth(_local_3, "LiquidationArmor ");
                if (_arg_2 <= 0)
                {
                    return (0);
                };
            };
            if ((_local_14 = this.getEffect("venom_spread")).duration > 0)
            {
                _local_25 = _local_5.health_manager.getMaxHP();
                _local_26 = _local_5.health_manager.getMaxCP();
                _local_27 = _local_5.health_manager.getMaxSP();
                _local_28 = int(Math.floor(((_local_25 * _local_14.amount) / 100)));
                _local_29 = int(Math.floor(((_local_26 * _local_14.amount) / 100)));
                _local_30 = int(Math.floor(((_local_27 * _local_14.amount) / 100)));
                _local_5.health_manager.reduceHealth(_local_28, "HP - ");
                _local_5.health_manager.reduceCP(_local_29, "CP - ");
                _local_5.health_manager.reduceSP(_local_30, "SP - ");
            };
            if ((_local_15 = this.getEffect("pet_serene_mind")).duration > 0)
            {
                _local_5.health_manager.reduceHealth(_arg_2, "Pet Serene Mind -");
                return (0);
            };
            if ((((_local_16 = this.getEffect("breakthrough")).duration > 0) && (!(BattleVars.REDUCED_HP_AS_DAMAGE))))
            {
                _local_4 = int(Math.floor(((_local_16.amount * _arg_2) / 100)));
                _arg_2 = (_arg_2 - _local_4);
                _local_5.health_manager.reduceHealth(_local_4, "Breakthrough -");
                if (_arg_2 <= 0)
                {
                    return (0);
                };
            };
            if ((_local_17 = this.getEffect("rage")).duration > 0)
            {
                _local_5.health_manager.reduceHealth(_arg_2, "Rage -");
            };
            _local_18 = this.getEffect("cp_shield");
            _local_19 = 0;
            if (((_local_18.duration > 0) && (!(BattleVars.REDUCED_HP_AS_DAMAGE))))
            {
                _local_19 = int(Math.floor(((_arg_2 * _local_18.amount) / 100)));
                _local_19 = int(Math.floor((_arg_2 / _local_18.amount)));
                if (_local_7 >= _local_19)
                {
                    _local_7 = (_local_7 - _local_19);
                    _arg_2 = 0;
                    _arg_1.health_manager.createDisplay("0");
                    _arg_1.health_manager.reduceCP(_local_19, "CP Shield -");
                };
            };
            _local_20 = this.getEffect("pet_cp_shield");
            _local_19 = 0;
            if (((_local_20.duration > 0) && (!(BattleVars.REDUCED_HP_AS_DAMAGE))))
            {
                _local_19 = int(Math.floor(((_arg_2 * _local_18.amount) / 100)));
                _local_19 = int(Math.floor((_arg_2 / _local_18.amount)));
                if (_local_7 >= _local_19)
                {
                    _local_7 = (_local_7 - _local_19);
                    _arg_2 = 0;
                    _arg_1.health_manager.createDisplay("0");
                    _arg_1.health_manager.reduceCP(_local_19, "CP Shield -");
                };
            };
            _local_21 = this.getEffect("cp_shield_and_increase_purify");
            _local_19 = 0;
            if (((_local_21.duration > 0) && (!(BattleVars.REDUCED_HP_AS_DAMAGE))))
            {
                _local_19 = int(Math.floor(((_arg_2 * 2) / 100)));
                _local_19 = int(Math.floor((_arg_2 / 2)));
                if (_local_7 >= _local_19)
                {
                    _local_7 = (_local_7 - _local_19);
                    _arg_2 = 0;
                    _arg_1.health_manager.createDisplay("0");
                    _arg_1.health_manager.reduceCP(_local_19, "CP Shield -");
                };
            };
            _local_22 = 0;
            _local_23 = this.getCharacterWeaponEffects();
            if (BattleVars.REDUCED_HP_AS_DAMAGE)
            {
                _local_23 = [];
            };
            _local_24 = 0;
            while (_local_24 < _local_23.length)
            {
                if (((_local_23[_local_24].effect == "cp_shield_weapon") && (!(_arg_1.effects_manager.hadEffect("unyielding")))))
                {
                    if (_arg_1.health_manager.getCurrentCP() > 0)
                    {
                        _local_22 = int(Math.floor(((_arg_2 * _local_23[_local_24].amount) / 100)));
                        _local_19 = int(Math.floor((_local_22 / _local_23[_local_24].amount_cp)));
                        if (_local_7 >= _local_19)
                        {
                            _arg_2 = (_arg_2 - _local_22);
                            _arg_1.health_manager.reduceCP(int((_local_22 / 2)), "Weapon CP Shield -");
                            if (_arg_2 <= 0)
                            {
                                _arg_1.health_manager.createDisplay("0");
                                return (0);
                            };
                        };
                    };
                };
                _local_24++;
            };
            return (int(_arg_2));
        }

        public function parasiteDrain(_arg_1:*):*
        {
            var _local_2:int;
            var _local_3:*;
            var _local_4:*;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            _local_2 = 0;
            _local_3 = BattleManager.getBattle().getObjectHolder(_arg_1.from_team, _arg_1.from_number).charMc.character_model;
            _local_4 = BattleManager.getBattle().getAttacker();
            _local_5 = int(_local_4.health_manager.getMaxHP());
            _local_6 = int(_local_4.health_manager.getCurrentHP());
            if ((_local_7 = int(_local_3.health_manager.getCurrentHP())) > 0)
            {
                if (_arg_1.calc_type == "percent")
                {
                    _local_2 = int(Math.floor(((_arg_1.amount * _local_6) / 100)));
                    if (_arg_1.reduce_type == "MAX")
                    {
                        _local_2 = int(Math.floor(((_arg_1.amount * _local_5) / 100)));
                    };
                    _local_3.health_manager.addHealth(_local_2, "Parasite +");
                    _local_4.health_manager.reduceHealth(_local_2, "Parasite -");
                }
                else
                {
                    _local_3.health_manager.addHealth(_arg_1.amount, "Parasite +");
                    _local_4.health_manager.reduceHealth(_arg_1.amount, "Parasite -");
                };
            };
        }

        public function getMovieClipHolder():*
        {
            var _local_1:String;
            _local_1 = "charMc_";
            if (this.user_team == "player_pet")
            {
                _local_1 = "charPetMc_";
            };
            if (this.user_team == "enemy")
            {
                _local_1 = "enemyMc_";
            };
            if (this.user_team == "enemy_pet")
            {
                _local_1 = "enemyPetMc_";
            };
            return (BattleManager.getBattle()[(_local_1 + this.user_number)]);
        }

        public function getActiveBuff(_arg_1:String=""):Array
        {
            var _local_2:Array;
            var _local_3:Array;
            var _local_4:Object;
            var _local_5:String;
            _local_2 = [];
            _local_3 = this.getEnabledBuffsFor(_arg_1);
            for each (_local_4 in this.dataBuff)
            {
                for each (_local_5 in _local_3)
                {
                    if (_local_4.effect == _local_5)
                    {
                        _local_2.push(_local_4);
                    };
                };
            };
            return (_local_2);
        }

        public function getActiveDebuff(_arg_1:String=""):Array
        {
            var _local_2:Array;
            var _local_3:Array;
            var _local_4:Object;
            var _local_5:String;
            _local_2 = [];
            _local_3 = this.getEnabledDebuffsFor(_arg_1);
            for each (_local_4 in this.dataDebuff)
            {
                for each (_local_5 in _local_3)
                {
                    if (_local_4.effect == _local_5)
                    {
                        _local_2.push(_local_4);
                    };
                };
            };
            return (_local_2);
        }

        public function clearAllEffect():void
        {
            this.dataBuff = [];
            this.dataDebuff = [];
        }

        public function getActiveEffects(_arg_1:String=""):Array
        {
            var _local_2:*;
            return (this.dataBuff.concat(this.dataDebuff));
        }

        public function getEnabledBuffsFor(_arg_1:*):Array
        {
            if (_arg_1 == "")
            {
                return (this.all_buffs_name_array);
            };
            if (_arg_1 == "accuracy")
            {
                return (["aqua_regia", "increase_accuracy", "unyielding", "invincible", "attention", "pet_attention", "toad_attention", "lightning_armor", "pet_lightning_armor", "kontol_memek_jembut", "solar_might"]);
            };
            if (_arg_1 == "dodge")
            {
                return (["invincible", "pet_energize", "energize", "reflexes", "flexible", "pet_flexible", "peace", "overwhelm", "meditation", "evade", "deka_kontol"]);
            };
            if (_arg_1 == "cp_costing")
            {
                return (["reduce_cp_consumption", "excitation", "pet_ocean_atmosphere", "ocean_atmosphere", "boundless"]);
            };
            if (_arg_1 == "critical")
            {
                return (["pet_energize", "energize", "concentration", "pet_concentration", "toad_concentration", "lightning_armor", "pet_lightning_armor", "pet_frenzy", "kontol_jembut_memek", "critical_buff_n_received_stun"]);
            };
            if (_arg_1 == "combustion")
            {
                return (["pet_energize", "energize"]);
            };
            if (_arg_1 == "purify")
            {
                return (["aqua_regia", "pet_energize", "energize"]);
            };
            if (_arg_1 == "reactive")
            {
                return (["reactive_force"]);
            };
            if (_arg_1 == "agility")
            {
                return (["increase_agility"]);
            };
            return ([]);
        }

        public function getEnabledDebuffsFor(_arg_1:*):Array
        {
            if (_arg_1 == "")
            {
                return (this.all_debuffs_name_array);
            };
            if (_arg_1 == "accuracy")
            {
                return (["darkness", "blind", "pet_blind"]);
            };
            if (_arg_1 == "dodge")
            {
                return (["silhouette", "darkness", "disorient", "pet_disorient", "disorient_2", "pet_numb", "numb", "conduction", "pet_conduction", "dark_curse", "embrace"]);
            };
            if (_arg_1 == "combustion")
            {
                return (["pet_disorient", "disorient_2", "disorient", "decrease_combustion_chance"]);
            };
            if (_arg_1 == "purify")
            {
                return (["pet_disorient", "disorient", "disorient_2", "decrease_purify_active", "embrace", "muddy", "pet_muddy", "clarify"]);
            };
            if (_arg_1 == "cp_costing")
            {
                return (["cp_cost", "transform"]);
            };
            if (_arg_1 == "critical")
            {
                return (["isolate", "pet_disorient", "disorient", "disorient_2", "dark_curse", "decrease_critical_chance", "distract", "pet_distract"]);
            };
            if (_arg_1 == "reactive")
            {
                return (["decrease_reactive_chance", "disorient", "disorient_2", "pet_disorient", "weak_body"]);
            };
            if (_arg_1 == "agility")
            {
                return (["slow", "pet_slow", "slow_oil"]);
            };
            return ([]);
        }

        public function getAllBuffs():Object
        {
            return (Effects.all_buffs);
        }

        public function getAllDebuffs():Object
        {
            return (Effects.all_debuffs);
        }

        public function destroy():*
        {
            var _local_1:*;
            GF.clearArray(this.all_buffs_name_array);
            GF.clearArray(this.all_debuffs_name_array);
            GF.clearArray(this.allSetEffects);
            Effects.destroy();
            this.dataBuff = null;
            this.dataDebuff = null;
            this.allSetEffects = null;
            this.all_buffs_name_array = null;
            this.all_debuffs_name_array = null;
            this.user_team = null;
            this.user_number = null;
            this.cooldownListFromSenjutsu = null;
            this.cooldownListFromTalent = null;
            this.tempt_skills_used_for_senjutsu = null;
            this.tempt_skills_used_for_talent = null;
            for each (_local_1 in this.user_buffs)
            {
                this.user_buffs[_local_1] = null;
            };
            this.user_buffs = null;
            for each (_local_1 in this.user_debuffs)
            {
                this.user_debuffs[_local_1] = null;
            };
            this.user_debuffs = null;
            _local_1 = null;
            this.all_debuffs_name_array = null;
            this.model = null;
        }


    }
}//package Combat

