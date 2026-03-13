// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.CharacterModel

package Combat
{
    import id.ninjasage.multiplayer.battle.base.CharacterModelBase;
    import flash.display.MovieClip;
    import NinjaSage_fla.Symbol42_64;
    import Storage.Character;
    import Managers.OutfitManager;
    import com.utils.GF;
    import flash.utils.setTimeout;
    import Storage.WeaponBuffs;
    import Managers.NinjaSage;
    import com.utils.NumberUtil;
    import flash.utils.getDefinitionByName;
    import id.ninjasage.Log;

    public class CharacterModel extends CharacterModelBase 
    {

        public var shadow:MovieClip;
        public var throw02Mc:Symbol42_64;
        public var back:MovieClip;
        public var back_hair:MovieClip;
        public var head:MovieClip;
        public var hitAreaMc:MovieClip;
        public var holderMc:MovieClip;
        public var left_hand:MovieClip;
        public var left_lower_arm:MovieClip;
        public var left_lower_leg:MovieClip;
        public var left_shoe:MovieClip;
        public var left_upper_arm:MovieClip;
        public var left_upper_leg:MovieClip;
        public var lower_body:MovieClip;
        public var right_hand:MovieClip;
        public var right_lower_arm:MovieClip;
        public var right_lower_leg:MovieClip;
        public var right_shoe:MovieClip;
        public var right_upper_arm:MovieClip;
        public var right_upper_leg:MovieClip;
        public var skirt:MovieClip;
        public var upper_body:MovieClip;
        public var weapon:MovieClip;
        public var character_id:int;
        public var attack_results:Array;
        public var attack_result:Object;
        public var for_exam:Boolean;
        public var library:*;
        public var character_manager:CharacterManager;
        public var pet_model:PetModel = null;
        public var IS_DODGED:Boolean = false;
        public var IS_BLOCK_DAMAGE:Boolean = false;
        public var health_manager:HealthManager;
        public var actions_manager:ActionsManager;
        public var theft_mode:Boolean = false;
        public var unyielding_mode:Boolean = false;
        public var ultimate_string:Object;
        public var debuff_resist:Boolean = false;
        public var effects_manager:EffectsManager;
        public var are_random_skills_set:Boolean = false;
        public var random_skills:Array;
        public var IS_CHAOS:Boolean = false;
        public var outfits:* = [];
        private var isTooltipSkillLoaded:Array = [];
        public var action_type:String = "start";

        public function CharacterModel(_arg_1:String="", _arg_2:int=0, _arg_3:String="", _arg_4:Boolean=false)
        {
            addFrameScript(339, this.frame340);
            super();
            if (((((_arg_1 == "") && (_arg_2 == 0)) && (_arg_3 == "")) && (_arg_4 == false)))
            {
                return;
            };
            this.attack_result = {
                "damage":0,
                "effects":[],
                "multi_hit":false,
                "self_target":false
            };
            this.attack_result = {};
            this.random_skills = [];
            this.player_team = _arg_1;
            this.player_number = _arg_2;
            this.player_identification = _arg_3;
            this.for_exam = _arg_4;
            if (!this.for_exam)
            {
                this.health_manager = new HealthManager(this.player_team, this.player_number);
                this.actions_manager = new ActionsManager(this.player_team, this.player_number, this);
                this.effects_manager = new EffectsManager(this.player_team, this.player_number);
                this.library = BattleManager.getMain().getLibrary();
            };
            this.character_id = int(this.player_identification.replace("char_", ""));
            this.handlePlayerParentObjects();
            this.setScalingAndSaveStartingPosition();
            this.setModelFramescript();
            if (BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.SHADOWWAR_MATCH)
            {
                BattleManager.getMain().amf_manager.service("ShadowWar.executeService", ["getEnemyInfo", [Character.char_id, Character.sessionkey, this.character_id]], this.handleCharacterData);
            }
            else
            {
                BattleManager.getMain().amf_manager.service("CharacterService.getInfo", [Character.char_id, Character.sessionkey, this.character_id, BattleManager.BATTLE_VARS.BATTLE_MODE], this.handleCharacterData);
            };
        }

        public function handleCharacterData(_arg_1:Object):*
        {
            var _local_2:OutfitManager;
            var _local_3:* = undefined;
            var _local_4:int;
            var _local_5:int;
            _arg_1.char_id = this.character_id;
            this.characterAnimations = {
                "dodge":(((_arg_1.character_sets.hasOwnProperty("anims")) && (_arg_1.character_sets.anims.hasOwnProperty("dodge"))) ? _arg_1.character_sets.anims.dodge : "ani_1"),
                "standby":(((_arg_1.character_sets.hasOwnProperty("anims")) && (_arg_1.character_sets.anims.hasOwnProperty("standby"))) ? _arg_1.character_sets.anims.standby : "ani_5"),
                "win":(((_arg_1.character_sets.hasOwnProperty("anims")) && (_arg_1.character_sets.anims.hasOwnProperty("win"))) ? _arg_1.character_sets.anims.win : "ani_7"),
                "dead":(((_arg_1.character_sets.hasOwnProperty("anims")) && (_arg_1.character_sets.anims.hasOwnProperty("dead"))) ? _arg_1.character_sets.anims.dead : "ani_3"),
                "charge":(((_arg_1.character_sets.hasOwnProperty("anims")) && (_arg_1.character_sets.anims.hasOwnProperty("charge"))) ? _arg_1.character_sets.anims.charge : "ani_9"),
                "hit":(((_arg_1.character_sets.hasOwnProperty("anims")) && (_arg_1.character_sets.anims.hasOwnProperty("hit"))) ? _arg_1.character_sets.anims.hit : "ani_10"),
                "run":(((_arg_1.character_sets.hasOwnProperty("anims")) && (_arg_1.character_sets.anims.hasOwnProperty("run"))) ? _arg_1.character_sets.anims.run : "ani_11")
            };
            if (((("pet_id" in _arg_1.pet_data) && (!(_arg_1.pet_data == null))) && (!(this.for_exam))))
            {
                _local_5 = (_local_5 + 200);
                _local_3 = _arg_1.pet_data;
                this.pet_model = new PetModel(this.getPlayerTeam(), this.getPlayerNumber(), _arg_1.pet_data.pet_swf, _local_3);
            };
            if (!this.for_exam)
            {
                this.character_manager = new CharacterManager(_arg_1);
                this.character_manager.setModel(this);
                this.character_info = this.character_manager.getAllCharacterInfo();
                _local_2 = new OutfitManager();
                if (!Character.is_stickman)
                {
                    _local_2.fillOutfit(this, this.character_manager.getWeapon(), this.character_manager.getBackItem(), this.character_manager.getClothing(), this.character_manager.getHair(), this.character_manager.getFace(), this.character_info.hair_color, this.character_info.skin_color);
                };
                this.outfits.push(_local_2);
                GF.removeAllChild(this.getMovieClipHolder().charMc);
                this.getMovieClipHolder().charMc.addChild(this);
                this.getMovieClipHolder().charMc.character_model = this;
                this.getMovieClipHolder().visible = true;
                this.health_manager.fillHealth(this.character_info);
                _local_4 = (this.player_number + 1);
                if (this.player_team == "player")
                {
                    setTimeout(BattleManager.loadPlayerTeam, _local_5, _local_4);
                };
                if (this.player_team != "player")
                {
                    setTimeout(BattleManager.loadEnemyTeam, _local_5, _local_4);
                };
                this.actions_manager.init();
            }
            else
            {
                this.weapon.visible = false;
                _local_2 = new OutfitManager();
                if (!Character.is_stickman)
                {
                    _local_2.fillOutfit(this, null, null, Character.character_set, Character.character_hair, Character.character_face, Character.character_color_hair, Character.character_color_skin);
                };
                this.outfits.push(_local_2);
            };
        }

        public function reloadInfo():*
        {
            this.character_info = this.character_manager.getAllCharacterInfo();
            this.health_manager.fillHealth(this.character_info);
        }

        public function get characterClanData():Object
        {
            return (this.character_manager.character.clan);
        }

        public function getAccuracy():int
        {
            var _local_1:int;
            var _local_2:Array = this.effects_manager.getActiveBuff("accuracy");
            var _local_3:Array = this.effects_manager.getEquippedSetForEffects("accuracy");
            var _local_4:Array = this.effects_manager.getEquippedSetForEffects("accuracy", false);
            var _local_5:Array = this.effects_manager.getActiveDebuff("accuracy");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "accuracy");
            _local_1 = BattleManager.modifyChance(_local_3, "ADD", _local_1, "accuracy");
            _local_1 = BattleManager.modifyChance(_local_5, "RM", _local_1, "accuracy");
            _local_1 = BattleManager.modifyChance(_local_4, "RM", _local_1, "accuracy");
            var _local_6:int = this.effects_manager.getIncreaseAccuracyByTalent();
            if (_local_6 > 0)
            {
                _local_1 = (_local_1 + _local_6);
            };
            return (_local_1);
        }

        public function getDodgeRate():int
        {
            var _local_1:int = Math.round((int(5) + Math.round((this.character_manager.getWindAttributes() * 0.4))));
            var _local_2:Array = this.effects_manager.getActiveBuff("dodge");
            var _local_3:Array = this.effects_manager.getEquippedSetForEffects("dodge");
            var _local_4:Array = this.effects_manager.getEquippedSetForEffects("dodge", false);
            var _local_5:Array = this.effects_manager.getActiveDebuff("dodge");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "dodge");
            _local_1 = BattleManager.modifyChance(_local_3, "ADD", _local_1, "dodge");
            _local_1 = BattleManager.modifyChance(_local_5, "RM", _local_1, "dodge");
            _local_1 = BattleManager.modifyChance(_local_4, "RM", _local_1, "dodge");
            _local_1 = (_local_1 + this.effects_manager.getIncreaseDodgeByTalent());
            return (_local_1 - ((BattleVars.SKILL_USED_ID == "skill_3104") ? this.effects_manager.getIgnoreDodgeBySenjutsu() : 0));
        }

        public function getCombustionChance():int
        {
            var _local_1:Number = Math.ceil((this.character_manager.getFireAttributes() * 0.4));
            var _local_2:Array = this.effects_manager.getActiveBuff("combustion");
            var _local_3:Array = this.effects_manager.getEquippedSetForEffects("combustion");
            var _local_4:Array = this.effects_manager.getEquippedSetForEffects("combustion", false);
            var _local_5:Array = this.effects_manager.getActiveDebuff("combustion");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1);
            _local_1 = BattleManager.modifyChance(_local_3, "ADD", _local_1);
            _local_1 = BattleManager.modifyChance(_local_5, "RM", _local_1);
            return (BattleManager.modifyChance(_local_4, "RM", _local_1));
        }

        public function getCriticalChance():int
        {
            var _local_1:Number = Math.round((int(5) + Math.round((this.character_manager.getLightningAttributes() * 0.4))));
            var _local_2:Array = this.effects_manager.getActiveBuff("critical");
            var _local_3:Array = this.effects_manager.getEquippedSetForEffects("critical");
            var _local_4:Array = this.effects_manager.getActiveDebuff("critical");
            var _local_5:Array = this.effects_manager.getEquippedSetForEffects("critical", false);
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "critical");
            _local_1 = BattleManager.modifyChance(_local_3, "ADD", _local_1, "critical");
            _local_1 = BattleManager.modifyChance(_local_4, "RM", _local_1, "critical");
            return (BattleManager.modifyChance(_local_5, "RM", _local_1, "critical"));
        }

        public function getPurifyChance():int
        {
            var _local_1:Number = Math.ceil((this.character_manager.getWaterAttributes() * 0.4));
            var _local_2:Array = this.effects_manager.getActiveBuff("purify");
            var _local_3:Array = this.effects_manager.getEquippedSetForEffects("purify");
            var _local_4:Array = this.effects_manager.getEquippedSetForEffects("purify", false);
            var _local_5:Array = this.effects_manager.getActiveDebuff("purify");
            _local_1 = BattleManager.modifyChance(_local_2, "ADD", _local_1, "purify");
            _local_1 = BattleManager.modifyChance(_local_3, "ADD", _local_1, "purify");
            _local_1 = BattleManager.modifyChance(_local_5, "RM", _local_1, "purify");
            return (BattleManager.modifyChance(_local_4, "RM", _local_1, "purify"));
        }

        public function getMovieClipHolder():*
        {
            return (BattleManager.getBattle()[(this.movieclip_holder + this.player_number)]);
        }

        public function attackWithWeapon():*
        {
            var _local_1:* = this.library.getItemInfo(this.character_manager.getWeapon());
            var _local_2:* = "attack_01";
            if (("attack_type" in _local_1))
            {
                _local_2 = _local_1.attack_type;
            };
            var _local_3:int = ((this.player_team == "player") ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET);
            var _local_4:Array = [];
            var _local_5:Object = this.calculateAttackPosition(_local_3, _local_2, _local_4);
            this.x = _local_5.x;
            this.y = _local_5.y;
            this.gotoAndPlay(_local_2);
        }

        override public function handleHitFrame():*
        {
            var _local_1:* = this.library.getItemInfo(this.character_manager.getWeapon());
            var _local_2:* = ((WeaponBuffs.getCopy(this.character_manager.getWeapon()).effects == null) ? [] : WeaponBuffs.getCopy(this.character_manager.getWeapon()).effects);
            var _local_3:Array = ((this.effects_manager.hadEffect("disable_weapon_effect")) ? [] : _local_2);
            _local_3 = BattleManager.getBattle().checkForDisperse(_local_3);
            var _local_4:String = ((this.player_team == "player") ? "enemy" : "player");
            var _local_5:int = ((this.player_team == "player") ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET);
            BattleManager.getBattle().setDefender(_local_4, _local_5);
            var _local_6:int = int(_local_1.item_damage);
            this.attack_results = [_local_6, _local_3, false];
            this.attack_result = {
                "damage":_local_6,
                "effects":_local_3,
                "multi_hit":false,
                "self_target":false
            };
            BattleManager.getBattle().weaponAttack();
            this.health_manager.chargePlayer(5, "Weapon");
        }

        public function checkBlockDamage():int
        {
            return (this.character_manager.checkBlockDamage());
        }

        public function checkIgnoreBlockDamage():int
        {
            return (this.character_manager.checkIgnoreBlockDamage());
        }

        public function checkConvertDamage():Boolean
        {
            return (this.character_manager.checkConvertDamage());
        }

        public function checkConvertDamageCP():Boolean
        {
            return (this.character_manager.checkConvertDamageCP());
        }

        public function getAttackResults():Array
        {
            return (this.attack_results);
        }

        public function getAttackResult():Object
        {
            return (this.attack_result);
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
            };
            return (false);
        }

        public function getSkillsCooldown():*
        {
            return (this.skills_with_cooldown);
        }

        public function handleRandomSkill(param1:*, param2:*):*
        {
            var curr_skill_mc:* = undefined;
            var skill_holder:* = param1;
            var num:* = param2;
            var character_skills_mc:Array = this.actions_manager.character_skills_mc;
            if (!this.are_random_skills_set)
            {
                this.are_random_skills_set = true;
                try
                {
                    this.random_skills = this.getRandomSequence(0, (character_skills_mc.length - 1));
                }
                catch(e)
                {
                    random_skills = [];
                };
            };
            if (this.random_skills.length > num)
            {
                skill_holder.visible = true;
                skill_holder.cdTxt.text = ((character_skills_mc[this.random_skills[num]].getCurrentCooldown() > 0) ? character_skills_mc[this.random_skills[num]].getCurrentCooldown() : "");
                if (!this.isTooltipSkillLoaded[num])
                {
                    GF.removeAllChild(skill_holder.holder);
                    NinjaSage.loadIconSWF("skills", character_skills_mc[this.random_skills[num]].skill_info.skill_id, skill_holder.holder, "icon");
                    this.isTooltipSkillLoaded[num] = true;
                };
            }
            else
            {
                skill_holder.visible = false;
            };
        }

        internal function copyClip(_arg_1:MovieClip):*
        {
            var _local_2:Class = Object(_arg_1).constructor;
            return (new (_local_2)());
        }

        public function getAttack(_arg_1:int=0, _arg_2:int=-1):*
        {
            var _local_3:* = undefined;
            var _local_4:Boolean;
            var _local_5:Boolean;
            var _local_6:Array = this.actions_manager.character_skills_mc;
            var _local_7:Array = this.actions_manager.character_talent_skills_mc;
            var _local_8:Array = this.actions_manager.character_senjutsu_skills_mc;
            var _local_9:SkillHandler = this.actions_manager.class_skill;
            var _local_10:int = 1;
            var _local_11:int = -1;
            if (_local_6.length > 0)
            {
                _local_10 = 2;
            };
            if (((_local_7.length > 0) && (_local_6.length > 0)))
            {
                _local_10 = (NumberUtil.randomInt(0, 3) + 2);
            };
            if (((!(_arg_2 == -1)) && (_arg_1 < 5)))
            {
                _local_10 = _arg_2;
            };
            if (_arg_1 > 10)
            {
                _local_10 = 1;
            };
            if (this.player_team == "player")
            {
                BattleVars.getRandomPlayerTarget();
            };
            if (this.player_team == "enemy")
            {
                BattleVars.getRandomEnemyTarget();
            };
            var _local_12:int = ((this.player_team == "player") ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET);
            var _local_13:Boolean = this.targetIsSleeping();
            if (((_local_10 == 1) && (_local_13)))
            {
                _local_10 = 6;
            };
            if (_local_10 == 1)
            {
                this.actions_manager.onWeaponAttack();
            }
            else
            {
                if (_local_10 == 2)
                {
                    _local_11 = NumberUtil.randomInt(0, (_local_6.length - 1));
                    if ((_local_3 = _local_6[_local_11]) == null)
                    {
                        this.getAttack((_arg_1 + 1), 2);
                        return;
                    };
                    if ((_local_4 = Boolean(_local_3.setPositionAndAttack(this.player_team, this.player_number, _local_12, false))))
                    {
                        if (!(_local_5 = this.actions_manager.onUseSkill(_local_11, _local_13)))
                        {
                            this.getAttack((_arg_1 + 1), 2);
                        };
                    }
                    else
                    {
                        this.getAttack((_arg_1 + 1), 2);
                    };
                }
                else
                {
                    if (_local_10 == 3)
                    {
                        _local_11 = NumberUtil.randomInt(0, (_local_7.length - 1));
                        if ((_local_3 = _local_7[_local_11]) == null)
                        {
                            this.getAttack((_arg_1 + 1), 3);
                            return;
                        };
                        if ((_local_4 = Boolean(_local_3.setPositionAndAttack(this.player_team, this.player_number, _local_12, false))))
                        {
                            if (!(_local_5 = this.actions_manager.useTalentSkill(_local_11, _local_13)))
                            {
                                this.getAttack((_arg_1 + 1), 3);
                            };
                        }
                        else
                        {
                            this.getAttack((_arg_1 + 1), 3);
                        };
                    }
                    else
                    {
                        if (_local_10 == 4)
                        {
                            _local_11 = NumberUtil.randomInt(0, (_local_8.length - 1));
                            if ((_local_3 = _local_8[_local_11]) == null)
                            {
                                this.getAttack((_arg_1 + 1), 4);
                                return;
                            };
                            if ((_local_4 = Boolean(_local_3.setPositionAndAttack(this.player_team, this.player_number, _local_12, false))))
                            {
                                if (!(_local_5 = this.actions_manager.useSenjutsuSkill(_local_11, _local_13)))
                                {
                                    this.getAttack((_arg_1 + 1), 4);
                                };
                            }
                            else
                            {
                                this.getAttack((_arg_1 + 1), 4);
                            };
                        }
                        else
                        {
                            if (_local_10 == 5)
                            {
                                if ((_local_3 = _local_9) == null)
                                {
                                    this.getAttack(0, 1);
                                    return;
                                };
                                if ((_local_4 = Boolean(_local_3.setPositionAndAttack(this.player_team, this.player_number, _local_12, false))))
                                {
                                    if (!(_local_5 = this.actions_manager.onUseClassSkill(null)))
                                    {
                                        this.getAttack(0, 1);
                                    };
                                }
                                else
                                {
                                    this.getAttack(0, 1);
                                };
                            }
                            else
                            {
                                if (_local_10 == 6)
                                {
                                    this.actions_manager.onChargeUsed();
                                };
                            };
                        };
                    };
                };
            };
        }

        public function handleChaos():*
        {
            this.actions_manager.handleChaos();
        }

        public function handleTease():*
        {
            this.actions_manager.handleTease();
        }

        public function chargePlayer():*
        {
            this.gotoAndPlay(this.getFrameLabel("charge"));
            this.health_manager.chargePlayer();
        }

        override public function weaponAttackFinished():*
        {
            this.gotoStandby();
            BattleManager.getBattle().weaponAttackFinish();
        }

        override public function setScalingAndSaveStartingPosition():*
        {
            if (!this.for_exam)
            {
                BattleManager.getBattle()[(this.movieclip_holder + this.player_number)].charMc.scaleX = ((this.player_team == "player") ? -1 : 1);
            };
            super.setScalingAndSaveStartingPosition();
        }

        public function isDead():Boolean
        {
            return (this.health_manager.isDead());
        }

        public function getAgility():Number
        {
            return (this.character_manager.getAgility());
        }

        public function getPurify():Number
        {
            return (this.character_manager.getPurify());
        }

        public function getHead():MovieClip
        {
            var _local_1:MovieClip = new ((getDefinitionByName("CharHead") as Class))();
            var _local_2:OutfitManager = new OutfitManager();
            _local_2.fillHead(_local_1, this.character_manager.getHair(), this.character_manager.getFace(), this.character_info.hair_color, this.character_info.skin_color);
            this.outfits.push(_local_2);
            return (_local_1);
        }

        public function getLevel():int
        {
            return (this.character_info.character_level);
        }

        public function reduceHealth(_arg_1:int):*
        {
            this.health_manager.reduceHealth(_arg_1);
        }

        override public function chargeAnimationFinished():*
        {
            this.gotoStandby();
            BattleManager.getBattle().agility_bar_manager.startRun();
        }

        override public function playAnimation(_arg_1:String):*
        {
            if (((_arg_1 == "hit") || (_arg_1 == "dodge")))
            {
                this.effects_manager.wakePlayer();
            };
            var _local_2:String = this.getFrameLabel(_arg_1);
            this.gotoAndPlay(_local_2);
        }

        override public function destroy():*
        {
            var _local_3:*;
            Log.info(this, "destroy", this.player_identification);
            this.characterAnimations = null;
            this.library = null;
            this.character_info = null;
            this.unyielding_mode = null;
            this.ultimate_string = null;
            this.theft_mode = null;
            this.IS_CHAOS = null;
            this.attack_result = null;
            this.isTooltipSkillLoaded = null;
            this.attack_results = null;
            this.skills_with_cooldown = null;
            this.random_skills = null;
            var _local_1:* = BattleManager.getBattle();
            var _local_2:String = (this.movieclip_holder + String(this.player_number));
            if (((_local_1) && (_local_2 in _local_1)))
            {
                _local_3 = _local_1[_local_2];
                _local_3.charMc.character_model = null;
                GF.removeAllChild(_local_3);
                _local_3 = null;
            };
            _local_1 = null;
            _local_2 = null;
            if (this.pet_model)
            {
                this.pet_model.destroy();
            };
            this.pet_model = null;
            GF.destroyArray(this.outfits);
            this.outfits = null;
            if (this.character_manager)
            {
                this.character_manager.destroy();
            };
            this.character_manager = null;
            if (this.health_manager)
            {
                this.health_manager.destroy();
            };
            this.health_manager = null;
            if (this.actions_manager)
            {
                this.actions_manager.destroy();
            };
            this.actions_manager = null;
            if (this.effects_manager)
            {
                this.effects_manager.destroy();
            };
            this.effects_manager = null;
            super.destroy();
            GF.removeAllChild(this);
        }

        internal function frame340():*
        {
            this.stop();
        }


    }
}//package Combat

