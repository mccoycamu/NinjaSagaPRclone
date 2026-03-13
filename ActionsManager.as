// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.ActionsManager

package Combat
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import gs.TweenLite;
    import Storage.Character;
    import flash.utils.getDefinitionByName;
    import Storage.SenjutsuSkillLevel;
    import Storage.ArenaBuffs;
    import id.ninjasage.Log;
    import Storage.SkillLibrary;
    import com.utils.GF;
    import flash.events.Event;
    import Managers.OutfitManager;
    import Storage.TalentSkillLevel;
    import com.utils.NumberUtil;

    public class ActionsManager 
    {

        public var player_team:*;
        public var player_number:*;
        public var player_model:*;
        public var action_bar:*;
        public var character_skills_mc:*;
        public var character_talent_skills:*;
        public var character_talent_skills_mc:*;
        public var character_talent_passive_skills_mc:*;
        public var character_senjutsu_skills:*;
        public var character_senjutsu_skills_mc:*;
        public var character_senjutsu_passive_skills_mc:*;
        public var equipped_skills:*;
        public var loading_skill_number:* = 0;
        public var loading_skill_id:* = "";
        public var confirmation_mc:*;
        public var last_used_skill_mc:*;
        public var shadow_war_effect_applied:Boolean = false;
        public var all_loaded:* = false;
        public var can_use_class_skill:* = false;
        public var can_use_talent_skill:* = false;
        public var intelligence_class_used:* = false;
        public var class_skill:* = null;
        public var class_skill_id:* = null;
        private var eventHandler:*;

        private var character_talent_skills_info:* = [];
        private var character_senjutsu_skills_info:* = [];
        public var loadeds:* = [];
        private var outfits:* = [];
        public var skill_icons:Array = [];
        public var talent_icons:Array = [];
        public var senjutsu_icons:Array = [];
        public var specialclass_icon:MovieClip = null;

        public function ActionsManager(_arg_1:String, _arg_2:int, _arg_3:*)
        {
            this.eventHandler = new EventHandler();
            this.player_team = _arg_1;
            this.player_number = _arg_2;
            this.player_model = _arg_3;
            this.character_skills_mc = [];
            this.character_talent_skills = [];
            this.character_senjutsu_skills = [];
            this.character_senjutsu_skills_mc = [];
            this.character_senjutsu_passive_skills_mc = [];
            this.character_talent_skills_mc = [];
            this.character_talent_passive_skills_mc = [];
        }

        public function init():*
        {
            if (this.isMainPlayerOrControllable())
            {
                this.fillActionBar();
            }
            else
            {
                this.getEquippedSkillsAndLoad();
            };
        }

        public function fillActionBar():*
        {
            var _local_1:* = "actionBar";
            if (this.player_number == 1)
            {
                _local_1 = "actionBar1";
            };
            if (this.player_number == 2)
            {
                _local_1 = "actionBar2";
            };
            this.action_bar = BattleManager.getBattle()[_local_1];
            this.hideTalents();
            this.addButtonListeners();
            this.getEquippedSkillsAndLoad();
        }

        public function hideTalents():*
        {
            var i:* = 0;
            this.setActionBarVisible(false);
            this.action_bar["starMC"].visible = false;
            this.action_bar["boardMC"].visible = false;
            this.action_bar["bloodline_Logo"].visible = true;
            this.action_bar["btnClassSkill_1"].visible = false;
            while (i < 12)
            {
                if (i < 8)
                {
                    this.action_bar[("senjutsu_" + i)].visible = false;
                    this.action_bar[("senjutsu_" + i)].filled = false;
                };
                this.action_bar[("pass_" + i)].visible = false;
                i++;
            };
            i = 0;
            while (i < 4)
            {
                this.action_bar[("bl_" + i)].filled = false;
                this.action_bar[("bl_" + i)].visible = true;
                this.action_bar[("se_" + String((int(i) + 4)))].filled = false;
                this.action_bar[("se_" + String((int(i) + 4)))].visible = true;
                i++;
            };
            if (this.player_model.character_manager.getTalentType(1) != "")
            {
                try
                {
                    this.action_bar["bloodline_Logo"].gotoAndStop(this.player_model.character_manager.getTalentType(1));
                }
                catch(e)
                {
                };
            };
            if (this.action_bar["btn_senjutsu"].visible)
            {
                this.eventHandler.addListener(this.action_bar["btn_senjutsu"], MouseEvent.CLICK, this.toggleSenjutsu);
                this.eventHandler.addListener(this.action_bar["btn_ninjutsu"], MouseEvent.CLICK, this.toggleSenjutsu);
            };
        }

        public function hideSenjutsu():*
        {
            this.action_bar["btn_senjutsu"].visible = true;
            this.action_bar["btn_ninjutsu"].visible = false;
            var _local_1:* = 0;
            while (_local_1 < 8)
            {
                this.action_bar[("senjutsu_" + _local_1)].visible = false;
                this.action_bar[("skill_" + _local_1)].visible = true;
                TweenLite.killTweensOf(this.action_bar[("senjutsu_" + _local_1)]);
                _local_1++;
            };
        }

        public function showSenjutsu():*
        {
            this.action_bar["btn_senjutsu"].visible = false;
            this.action_bar["btn_ninjutsu"].visible = true;
            if (Character.senjutsu_animation)
            {
                BattleManager.getBattle()["senjutsuTransition"].gotoAndPlay(2);
            };
            BattleManager.getBattle().setChildIndex(BattleManager.getBattle()["senjutsuTransition"], (BattleManager.getBattle().numChildren - 1));
            var _local_1:* = 0;
            while (_local_1 < 8)
            {
                this.action_bar[("skill_" + _local_1)].visible = false;
                this.action_bar[("senjutsu_" + _local_1)].visible = true;
                this.action_bar[("senjutsu_" + _local_1)].rotationY = 180;
                TweenLite.killTweensOf(this.action_bar[("senjutsu_" + _local_1)]);
                TweenLite.to(this.action_bar[("senjutsu_" + _local_1)], 1, {"rotationY":0});
                _local_1++;
            };
        }

        public function addButtonListeners():*
        {
            this.eventHandler.addListener(this.action_bar["btnAttack"], MouseEvent.CLICK, this.onWeaponAttack);
            this.eventHandler.addListener(this.action_bar["btnDodge"], MouseEvent.CLICK, this.onDodgeTurn);
            this.eventHandler.addListener(this.action_bar["btnCharge"], MouseEvent.CLICK, this.onChargeUsed);
            if (("btnRun" in this.action_bar))
            {
                this.eventHandler.addListener(this.action_bar["btnRun"], MouseEvent.CLICK, this.onRun);
            };
        }

        public function toggleSenjutsu(_arg_1:MouseEvent):*
        {
            if (this.action_bar["senjutsu_1"].visible)
            {
                this.hideSenjutsu();
            }
            else
            {
                this.showSenjutsu();
            };
        }

        public function handleChaos():*
        {
            var _local_1:int = int(Math.floor((Math.random() * 2)));
            BattleTimer.stopTurnTimer();
            if (_local_1 == 0)
            {
                this.onWeaponAttack(null, true);
            }
            else
            {
                this.onChargeUsed(null, true);
            };
        }

        public function handleTease():*
        {
            this.onWeaponAttack(null, true);
        }

        public function isAbleToUseWeaponAttack():Boolean
        {
            return ((((Boolean(this.player_model.effects_manager.hadEffect("barrier"))) || (Boolean(this.player_model.effects_manager.hadEffect("dismantle")))) || (Boolean(this.player_model.effects_manager.hadEffect("pet_dismantle")))) ? false : true);
        }

        public function onWeaponAttack(_arg_1:*=null, _arg_2:Boolean=false, _arg_3:Boolean=false):*
        {
            var _local_4:* = (_arg_1 is MouseEvent);
            if (!this.isAbleToUseWeaponAttack())
            {
                if (_arg_3)
                {
                    this.onDodgeTurn();
                }
                else
                {
                    if (_arg_2)
                    {
                        this.onChargeUsed(null, true, true);
                    }
                    else
                    {
                        if (_local_4)
                        {
                            BattleManager.getMain().showMessage("You can not attack with weapon.");
                        }
                        else
                        {
                            this.onChargeUsed(null, true, true);
                        };
                    };
                };
                return;
            };
            if (_local_4)
            {
                if (_arg_1.currentTarget.enabled)
                {
                    if (this.player_model.IS_CHAOS)
                    {
                        this.player_model.handleChaos();
                        return;
                    };
                };
            };
            if ((_arg_1 is MouseEvent))
            {
                BattleTimer.stopTurnTimer();
                this.hideSenjutsu();
                Character.battle_logs.push({"_":"weapon"});
            };
            this.player_model.attackWithWeapon();
            this.setActionBarVisible(false);
        }

        public function setActionBarVisible(_arg_1:Boolean=true):*
        {
            BattleManager.getBattle()["btn_UI_Gear"].visible = false;
            try
            {
                BattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"].visible = _arg_1;
                this.action_bar.visible = _arg_1;
            }
            catch(e)
            {
            };
        }

        public function onDodgeTurn(_arg_1:MouseEvent=null):*
        {
            if ((_arg_1 is MouseEvent))
            {
                BattleTimer.stopTurnTimer();
                this.hideSenjutsu();
                Character.battle_logs.push({"_":"skip"});
            };
            BattleManager.startRun();
            this.setActionBarVisible(false);
        }

        public function isAbleToUseCharge():Boolean
        {
            return (((((Boolean(this.player_model.effects_manager.hadEffect("charge_disable"))) || (Boolean(this.player_model.effects_manager.hadEffect("pet_charge_disable")))) || (Boolean(this.player_model.effects_manager.hadEffect("meridian_seal")))) || (Boolean(this.player_model.effects_manager.hadEffect("domain_expansion")))) ? false : true);
        }

        public function onChargeUsed(_arg_1:MouseEvent=null, _arg_2:Boolean=false, _arg_3:Boolean=false):*
        {
            if ((_arg_1 is MouseEvent))
            {
                BattleTimer.stopTurnTimer();
                this.hideSenjutsu();
                Character.battle_logs.push({"_":"charge"});
            };
            var _local_4:* = (_arg_1 is MouseEvent);
            if (!this.isAbleToUseCharge())
            {
                if (_arg_3)
                {
                    this.onDodgeTurn();
                }
                else
                {
                    if (_arg_2)
                    {
                        this.onWeaponAttack(null, true, true);
                    }
                    else
                    {
                        if (_local_4)
                        {
                            BattleManager.getMain().showMessage("You can not charge.");
                        }
                        else
                        {
                            this.onDodgeTurn();
                        };
                    };
                };
                return;
            };
            if (_local_4)
            {
                if (!_arg_1.currentTarget.enabled)
                {
                    if (this.player_model.IS_CHAOS)
                    {
                        this.player_model.handleChaos();
                        return;
                    };
                    BattleManager.getMain().showMessage("You can not charge.");
                    return;
                };
            };
            this.setActionBarVisible(false);
            this.player_model.chargePlayer();
        }

        public function onRun(_arg_1:MouseEvent=null):*
        {
            this.confirmation_mc = new ((getDefinitionByName("Popups.Confirmation") as Class))();
            this.eventHandler.addListener(this.confirmation_mc.btn_confirm, MouseEvent.CLICK, this.onRunConfirm);
            this.eventHandler.addListener(this.confirmation_mc.btn_close, MouseEvent.CLICK, this.onRunClose);
            BattleManager.getBattle().addChild(this.confirmation_mc);
        }

        public function onRunConfirm(_arg_1:MouseEvent):*
        {
            this.playRunAnimation();
            this.onRunClose(_arg_1);
            BattleTimer.stopTurnTimer();
            BattleManager.getBattle().resetGameModes();
            BattleManager.getBattle()._main.battleRewards("0", "0", "Run", false);
        }

        public function playRunAnimation():*
        {
            var _local_1:int;
            while (_local_1 < BattleManager.getBattle().character_team_players.length)
            {
                if (!BattleManager.getBattle().character_team_players[_local_1].health_manager.isDead())
                {
                    BattleManager.getBattle().character_team_players[_local_1].playRun();
                };
                _local_1++;
            };
        }

        public function onRunClose(_arg_1:MouseEvent):*
        {
            BattleManager.getBattle().removeChild(this.confirmation_mc);
            this.confirmation_mc = null;
        }

        public function getEquippedSkillsAndLoad():*
        {
            this.equipped_skills = this.player_model.character_manager.getEquippedSkills();
            this.loadEquippedSkills();
        }

        public function loadEquippedSkills():*
        {
            if (this.equipped_skills.length > this.loading_skill_number)
            {
                this.loading_skill_id = this.equipped_skills[this.loading_skill_number];
                BattleManager.getMain().loadSkillSWF(this.loading_skill_id, this.onSkillSWFLoaded);
            }
            else
            {
                this.getTalentSkillsAndLoad();
            };
        }

        public function getTalentSkillsAndLoad():*
        {
            var _local_4:*;
            this.equipped_skills = [];
            this.loading_skill_number = 0;
            this.loading_skill_id = "";
            var _local_1:* = this.player_model.character_manager.getTalentsSkills();
            var _local_2:* = [];
            var _local_3:* = 0;
            while (_local_3 < _local_1.length)
            {
                if (_local_1[_local_3] != null)
                {
                    _local_4 = _local_1[_local_3].split(":");
                    _local_2.push({
                        "item_id":_local_4[0],
                        "item_level":_local_4[1]
                    });
                };
                _local_3++;
            };
            this.loadTalentSkills(_local_2);
        }

        public function loadTalentSkills(_arg_1:*=0):*
        {
            if ((_arg_1 is Array))
            {
                this.equipped_skills = _arg_1;
                this.addToTalentSkillsArray();
            };
            if (this.equipped_skills.length > this.loading_skill_number)
            {
                this.loading_skill_id = this.equipped_skills[this.loading_skill_number].item_id;
                BattleManager.getMain().loadSkillSWF(this.loading_skill_id, this.onTalentSkillSWFLoaded);
            }
            else
            {
                if (this.player_model.character_info.character_class != null)
                {
                    try
                    {
                        this.class_skill_id = this.player_model.character_info.character_class;
                        this.can_use_class_skill = true;
                        this.can_use_talent_skill = true;
                        if (this.class_skill_id == "skill_4002")
                        {
                            this.can_use_class_skill = false;
                        };
                        if (this.class_skill_id != null)
                        {
                            BattleManager.getMain().loadSkillSWF(this.class_skill_id, this.onClassSkillSWFLoaded);
                        };
                    }
                    catch(e)
                    {
                    };
                }
                else
                {
                    this.getSenjutsuSkillAndLoad();
                };
            };
        }

        public function getSenjutsuSkillAndLoad():*
        {
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            this.equipped_skills = [];
            this.loading_skill_number = 0;
            this.loading_skill_id = "";
            var _local_1:* = {};
            var _local_2:* = this.player_model.character_manager.getSenjutsuSkills();
            var _local_3:* = this.player_model.character_manager.getEquippedSenjutsuSkills();
            var _local_4:* = [];
            var _local_5:* = [];
            _local_6 = 0;
            while (_local_6 < _local_2.length)
            {
                if (_local_2[_local_6] != null)
                {
                    _local_7 = _local_2[_local_6].split(":");
                    _local_1[_local_7[0]] = int(_local_7[1]);
                    _local_8 = SenjutsuSkillLevel.getSenjutsuSkillLevels(_local_7[0], this.player_model.character_manager.getSenjutsuLevel(_local_7[0]));
                    if (((_local_8) && (_local_8.cooldown == 0)))
                    {
                        _local_4.push({
                            "item_id":_local_7[0],
                            "item_level":_local_7[1]
                        });
                        _local_5.push(((_local_7[0] + ":") + _local_7[1]));
                    };
                };
                _local_6++;
            };
            _local_6 = 0;
            while (_local_6 < _local_3.length)
            {
                if (!((_local_3[_local_6] == null) || (!(_local_1.hasOwnProperty(_local_3[_local_6])))))
                {
                    _local_4.push({
                        "item_id":_local_3[_local_6],
                        "item_level":_local_1[_local_3[_local_6]]
                    });
                    _local_5.push(((_local_3[_local_6] + ":") + _local_1[_local_3[_local_6]]));
                };
                _local_6++;
            };
            this.character_senjutsu_skills.push(_local_5.join(","));
            this.loadSenjutsuSkills(_local_4);
        }

        public function loadSenjutsuSkills(_arg_1:*=0):*
        {
            if ((_arg_1 is Array))
            {
                this.equipped_skills = _arg_1;
            };
            if (this.equipped_skills.length > this.loading_skill_number)
            {
                this.loading_skill_id = this.equipped_skills[this.loading_skill_number].item_id;
                BattleManager.getMain().loadSkillSWF(this.loading_skill_id, this.onSenjutsuSkillSWFLoaded);
            }
            else
            {
                this.all_loaded = true;
                this.reloadInfo();
            };
        }

        public function checkEffectForShadowWar():*
        {
            var rank_squad_gua:* = undefined;
            var rank_squad_target:* = undefined;
            var squad_gua:* = undefined;
            var squad_target:* = undefined;
            var squad_rank_1:* = undefined;
            var applied_effect:* = undefined;
            var effect:* = undefined;
            var effect_type:* = undefined;
            try
            {
                this.shadow_war_effect_applied = true;
                rank_squad_gua = Character.shadow_war_battle_data.ranks[0];
                rank_squad_target = Character.shadow_war_battle_data.ranks[1];
                squad_gua = Character.getSquadName(Character.shadow_war_battle_data.player);
                squad_target = Character.getSquadName(Character.shadow_war_battle_data.enemy);
                squad_rank_1 = Character.getSquadName(Character.shadow_war_battle_data.rank_1);
                if (((rank_squad_gua > 1) && (rank_squad_target > 1)))
                {
                    return;
                };
                applied_effect = undefined;
                effect = ArenaBuffs.getArenaBuff(squad_rank_1);
                effect_type = "";
                if (((!(squad_gua == squad_rank_1)) && (squad_target == squad_rank_1)))
                {
                    applied_effect = effect.buff.effect;
                    effect_type = "Buff";
                }
                else
                {
                    if (squad_gua == squad_rank_1)
                    {
                        applied_effect = effect.debuff.effect;
                        effect_type = "Debuff";
                    };
                };
                var _local_2:* = this.player_model.effects_manager;
                (_local_2[("add" + effect_type)](applied_effect));
            }
            catch(e)
            {
                this.shadow_war_effect_applied = false;
                Log.error(this, "sw:effect", e);
            };
        }

        public function checkUseIntelligenceClass():*
        {
            var _local_1:SkillHandler;
            var _local_2:int;
            var _local_3:String;
            var _local_4:MovieClip;
            var _local_5:MovieClip;
            if (((this.player_team == "player") && (this.player_number == 0)))
            {
                if (!Character.intel_class_animation)
                {
                    this.intelligence_class_used = true;
                };
                if (((this.class_skill_id == "skill_4002") && (!(this.intelligence_class_used))))
                {
                    this.setActionBarVisible(false);
                    this.intelligence_class_used = true;
                    _local_1 = this.class_skill;
                    _local_2 = this.getTarget();
                    _local_3 = this.getEnemyTeam();
                    _local_4 = BattleManager.getBattle().getObjectHolder(this.player_team, this.player_number);
                    _local_5 = BattleManager.getBattle().getObjectHolder(_local_3, _local_2);
                    BattleManager.getBattle().playTheSkillAnimation(_local_1.skill_mc, _local_5, _local_4);
                };
            };
            return (false);
        }

        public function disableAttackClass():*
        {
            this.action_bar["btnClassSkill_1"].cdTxt.text = "";
            BattleManager.getMain().disableButton(this.action_bar["btnClassSkill_1"].holder);
        }

        public function reduceCooldownToHeavyAttackClass():*
        {
            if ((((this.class_skill_id == "skill_4003") && (this.class_skill.getCurrentCooldown() > 0)) && (this.can_use_class_skill)))
            {
                this.class_skill.setCurrentCooldown((this.class_skill.getCurrentCooldown() - 1));
                this.action_bar["btnClassSkill_1"].cdTxt.text = this.class_skill.getCurrentCooldown();
                if (this.class_skill.getCurrentCooldown() == 0)
                {
                    this.action_bar["btnClassSkill_1"].cdTxt.text = "";
                    BattleManager.getMain().enableButton(this.action_bar["btnClassSkill_1"].holder);
                    this.eventHandler.addListener(this.action_bar["btnClassSkill_1"], MouseEvent.CLICK, this.onUseClassSkill);
                };
            };
            return (false);
        }

        public function canUseExceptionalSkill(_arg_1:Object):Boolean
        {
            var _local_2:Boolean;
            if (((this.player_team == "player") && (this.player_number == 0)))
            {
                if (((this.class_skill_id == "skill_4001") && (this.can_use_class_skill)))
                {
                    _local_2 = true;
                }
                else
                {
                    if (((_arg_1.character_manager.hasTalentSkill("skill_1059")) && (this.can_use_talent_skill)))
                    {
                        _local_2 = true;
                    }
                    else
                    {
                        _local_2 = false;
                    };
                };
            };
            return (_local_2);
        }

        public function disableAllButClassSkill():*
        {
            this.greyOutActions();
            BattleManager.getBattle().agility_bar_manager.enable_actions = true;
        }

        public function greyOutActions(_arg_1:Boolean=true):void
        {
            var _local_2:int;
            while (_local_2 < 4)
            {
                this.toggleActionBarItem(("bl_" + _local_2), _arg_1, this.useTalentSkill);
                this.toggleActionBarItem(("se_" + (_local_2 + 4)), _arg_1, this.useTalentSkill);
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < this.character_skills_mc.length)
            {
                if (this.character_skills_mc[_local_2] != null)
                {
                    this.toggleActionBarItem(("skill_" + _local_2), _arg_1, this.onUseSkill);
                };
                _local_2++;
            };
            if (this.class_skill_id != "skill_4001")
            {
                this.toggleActionBarItem("btnClassSkill_1", _arg_1, this.onUseClassSkill);
            };
            if (this.player_model.character_info.character_rank > 7)
            {
                this.toggleSenjutsuButtons(_arg_1);
            };
            if (this.player_model.IS_CHAOS)
            {
                this.toggleActionBarItem("btnAttack", false, this.onWeaponAttack);
                this.toggleActionBarItem("btnCharge", false, this.onChargeUsed);
            }
            else
            {
                this.toggleActionBarItem("btnAttack", _arg_1, this.onWeaponAttack);
                this.toggleActionBarItem("btnCharge", _arg_1, this.onChargeUsed);
            };
        }

        private function toggleActionBarItem(_arg_1:String, _arg_2:Boolean, _arg_3:Function=null):void
        {
            var _local_4:String = ((_arg_2) ? "disable" : "enable");
            var _local_5:* = this.action_bar[_arg_1];
            if ((_local_5 is MovieClip))
            {
                if (_local_5.item_id == "skill_1059")
                {
                    if (_local_5.cdTxt.text == "")
                    {
                        _local_4 = "enable";
                        _arg_2 = false;
                    };
                };
            };
            if (_arg_3 != null)
            {
                if (_arg_2)
                {
                    _local_5.enabled = false;
                    this.eventHandler.removeListener(_local_5, MouseEvent.CLICK, _arg_3);
                }
                else
                {
                    _local_5.enabled = true;
                    this.eventHandler.addListener(_local_5, MouseEvent.CLICK, _arg_3);
                };
            };
            this.helpForActionBar(_local_4, _arg_1);
        }

        private function toggleSenjutsuButtons(_arg_1:Boolean):void
        {
            var _local_2:String = ((_arg_1) ? "initButtonDisable" : "initButton");
            var _local_3:* = BattleManager.getMain();
            (_local_3[_local_2](BattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"], this.player_model.health_manager.useSageMode));
            this.toggleActionBarItem("btn_senjutsu", _arg_1, this.toggleSenjutsu);
            this.toggleActionBarItem("btn_ninjutsu", _arg_1, this.toggleSenjutsu);
        }

        public function reloadInfo():*
        {
            this.player_model.reloadInfo();
        }

        public function addToTalentSkillsArray():*
        {
            var _local_1:* = "";
            var _local_2:* = 0;
            while (_local_2 < this.equipped_skills.length)
            {
                if (_local_1 == "")
                {
                    _local_1 = ((this.equipped_skills[_local_2].item_id + ":") + this.equipped_skills[_local_2].item_level);
                }
                else
                {
                    _local_1 = ((((_local_1 + ",") + this.equipped_skills[_local_2].item_id) + ":") + this.equipped_skills[_local_2].item_level);
                };
                _local_2++;
            };
            this.character_talent_skills.push(_local_1);
        }

        public function onSkillSWFLoaded(_arg_1:Event):*
        {
            this.loadeds.push({
                "_":this.loading_skill_id,
                "__":_arg_1.target[((("by" + "tes") + "Loa") + "ded")]
            });
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            var _local_3:MovieClip = _arg_1.target.content[this.loading_skill_id];
            _local_3.gotoAndStop(1);
            {
                _local_3.stopAllMovieClips();
            };
            var _local_4:Object = SkillLibrary.getCopy(this.loading_skill_id);
            _local_4.skill_id = this.loading_skill_id;
            var _local_5:SkillHandler = new SkillHandler(_local_3, this.player_team, this.player_number, _local_4);
            var _local_6:MovieClip = _arg_1.target.content["icon"];
            this.skill_icons.push(_local_6);
            try
            {
                _arg_1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
            if (this.isMainPlayerOrControllable())
            {
                GF.removeAllChild(this.action_bar[("skill_" + this.loading_skill_number)].holder);
                this.action_bar[("skill_" + this.loading_skill_number)].holder.addChild(_local_6);
                this.action_bar[("skill_" + this.loading_skill_number)].item_id = this.loading_skill_id;
                this.action_bar[("skill_" + this.loading_skill_number)].is_talent = false;
                this.action_bar[("skill_" + this.loading_skill_number)].is_passive = false;
                this.eventHandler.addListener(this.action_bar[("skill_" + this.loading_skill_number)], MouseEvent.CLICK, this.onUseSkill);
                this.eventHandler.addListener(this.action_bar[("skill_" + this.loading_skill_number)], MouseEvent.MOUSE_OVER, BattleTooltip.showTooltip);
                this.eventHandler.addListener(this.action_bar[("skill_" + this.loading_skill_number)], MouseEvent.MOUSE_OUT, BattleTooltip.hideTooltip);
            };
            this.character_skills_mc.push(_local_5);
            this.loading_skill_number++;
            this.loadEquippedSkills();
        }

        public function onClassSkillSWFLoaded(_arg_1:Event):*
        {
            var _local_7:SkillHandler;
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            var _local_3:* = undefined;
            var _local_4:MovieClip;
            var _local_5:MovieClip = new MovieClip();
            var _local_6:Class;
            try
            {
            }
            catch(e:ReferenceError)
            {
            };
            if (_arg_1.target.content[this.class_skill_id])
            {
                _local_3 = SkillLibrary.getCopy(this.class_skill_id);
                _local_3.skill_id = this.class_skill_id;
                _local_5 = _arg_1.target.content[this.class_skill_id];
                _local_5.gotoAndStop(1);
                {
                    _local_5.stopAllMovieClips();
                };
                _local_7 = new SkillHandler(_local_5, this.player_team, this.player_number, _local_3);
                if (this.class_skill_id == "skill_4002")
                {
                    this.checkFillOutfit(_local_7);
                };
            };
            this.class_skill = _local_7;
            if (this.class_skill_id == "skill_4003")
            {
                _local_7.setCurrentCooldown(_local_7.skill_info.skill_cooldown);
            };
            if (this.isMainPlayerOrControllable())
            {
                if (this.class_skill_id == "skill_4003")
                {
                    this.action_bar["btnClassSkill_1"].cdTxt.text = String(_local_7.skill_info.skill_cooldown);
                    BattleManager.getMain().disableButton(this.action_bar["btnClassSkill_1"].holder);
                };
                this.action_bar["btnClassSkill_1"].visible = true;
                _local_4 = _arg_1.target.content["icon"];
                this.specialclass_icon = _local_4;
                GF.removeAllChild(this.action_bar["btnClassSkill_1"].holder);
                this.action_bar["btnClassSkill_1"].holder.addChild(_local_4);
                this.action_bar["btnClassSkill_1"].item_id = this.class_skill_id;
                this.action_bar["btnClassSkill_1"].is_class = true;
                this.action_bar["btnClassSkill_1"].is_passive = false;
                if (this.class_skill_id != "skill_4003")
                {
                    this.eventHandler.addListener(this.action_bar["btnClassSkill_1"], MouseEvent.CLICK, this.onUseClassSkill);
                };
                this.eventHandler.addListener(this.action_bar["btnClassSkill_1"], MouseEvent.MOUSE_OVER, BattleTooltip.showTooltip);
                this.eventHandler.addListener(this.action_bar["btnClassSkill_1"], MouseEvent.MOUSE_OUT, BattleTooltip.hideTooltip);
            };
            this.getSenjutsuSkillAndLoad();
        }

        public function onTalentSkillSWFLoaded(_arg_1:Event):*
        {
            var _local_3:int;
            var _local_4:Boolean;
            var _local_5:Array;
            var _local_17:SkillHandler;
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            var _local_6:* = undefined;
            var _local_7:OutfitManager;
            var _local_8:MovieClip;
            var _local_9:* = undefined;
            var _local_10:* = undefined;
            var _local_11:* = undefined;
            var _local_12:String;
            var _local_13:MovieClip = new MovieClip();
            var _local_14:Class;
            var _local_15:* = false;
            var _local_16:* = null;
            if (!_arg_1.target.content[this.loading_skill_id])
            {
                _local_15 = true;
            };
            if (((this.loading_skill_id == "skill_1023") || (this.loading_skill_id == "skill_1050")))
            {
                _local_15 = true;
            };
            _local_6 = TalentSkillLevel.getTalentSkillLevels(this.loading_skill_id, this.player_model.character_manager.getTalentLevel(this.loading_skill_id));
            _local_6.skill_id = this.loading_skill_id;
            if (_arg_1.target.content[this.loading_skill_id])
            {
                _local_13 = _arg_1.target.content[this.loading_skill_id];
                _local_13.gotoAndStop(1);
                {
                    _local_13.stopAllMovieClips();
                };
                _local_17 = new SkillHandler(_local_13, this.player_team, this.player_number, _local_6);
            };
            _local_3 = int(this.loading_skill_id.replace("skill_", ""));
            _local_4 = (_local_6.type == "secret");
            _local_5 = this.getTalentSkillsMC();
            if (((_local_4) && (_local_5.length < 4)))
            {
                if (_local_5.length == 2)
                {
                    this.addTalentSkillMcToArray(null);
                    this.addTalentSkillMcToArray(null);
                }
                else
                {
                    this.addTalentSkillMcToArray(null);
                };
            };
            if (this.isMainPlayerOrControllable())
            {
                _local_8 = _arg_1.target.content["icon"];
                this.talent_icons.push(_local_8);
                if (_local_15)
                {
                    this.action_bar["starMC"].visible = true;
                    this.action_bar["boardMC"].visible = true;
                    _local_9 = 0;
                    while (_local_9 < 12)
                    {
                        if (this.action_bar[("pass_" + _local_9)].visible == false)
                        {
                            this.action_bar[("pass_" + _local_9)].visible = true;
                            GF.removeAllChild(this.action_bar[("pass_" + _local_9)].holder);
                            this.action_bar[("pass_" + _local_9)].holder.addChild(_local_8);
                            this.action_bar[("pass_" + _local_9)].holder.skill_id = this.loading_skill_id;
                            this.action_bar[("pass_" + _local_9)].item_id = this.loading_skill_id;
                            this.action_bar[("pass_" + _local_9)].is_talent = true;
                            this.action_bar[("pass_" + _local_9)].is_passive = true;
                            this.eventHandler.addListener(this.action_bar[("pass_" + _local_9)], MouseEvent.MOUSE_OVER, BattleTooltip.showTooltip);
                            this.eventHandler.addListener(this.action_bar[("pass_" + _local_9)], MouseEvent.MOUSE_OUT, BattleTooltip.hideTooltip);
                            break;
                        };
                        _local_9++;
                    };
                }
                else
                {
                    _local_10 = ((_local_4) ? 4 : 0);
                    _local_11 = ((_local_4) ? 8 : 4);
                    _local_12 = ((_local_4) ? "se_" : "bl_");
                    while (_local_10 < _local_11)
                    {
                        if (this.action_bar[(_local_12 + _local_10)].filled == false)
                        {
                            _local_16 = (_local_12 + _local_10);
                            this.action_bar[_local_16].filled = true;
                            GF.removeAllChild(this.action_bar[_local_16].holder);
                            this.action_bar[_local_16].holder.addChild(_local_8);
                            this.action_bar[_local_16].cdTxt.text = "";
                            this.action_bar[_local_16].item_id = this.loading_skill_id;
                            this.action_bar[_local_16].movieclip_id = _local_17;
                            this.action_bar[_local_16].is_talent = true;
                            this.action_bar[_local_16].is_passive = false;
                            this.action_bar[_local_16].is_secondary = _local_4;
                            this.eventHandler.addListener(this.action_bar[_local_16], MouseEvent.CLICK, this.useTalentSkill);
                            this.eventHandler.addListener(this.action_bar[_local_16], MouseEvent.MOUSE_OVER, BattleTooltip.showTooltip);
                            this.eventHandler.addListener(this.action_bar[_local_16], MouseEvent.MOUSE_OUT, BattleTooltip.hideTooltip);
                            break;
                        };
                        _local_10++;
                    };
                };
            };
            if (!_local_15)
            {
                this.addTalentSkillMcToArray(_local_17, _local_16);
            };
            if (_local_15)
            {
                this.addTalentPassiveSkillMcToArray(this.equipped_skills[this.loading_skill_number]);
            };
            this.loading_skill_number++;
            try
            {
                _arg_1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
            this.loadTalentSkills();
        }

        public function onSenjutsuSkillSWFLoaded(_arg_1:Event):*
        {
            var _local_3:int;
            var _local_13:SkillHandler;
            var _local_14:*;
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            var _local_4:* = undefined;
            var _local_5:OutfitManager;
            var _local_6:MovieClip;
            var _local_7:* = undefined;
            var _local_8:String;
            var _local_9:MovieClip = new MovieClip();
            var _local_10:Class;
            var _local_11:* = false;
            var _local_12:* = null;
            try
            {
            }
            catch(e:ReferenceError)
            {
            };
            _local_4 = SenjutsuSkillLevel.getSenjutsuSkillLevels(this.loading_skill_id, this.player_model.character_manager.getSenjutsuLevel(this.loading_skill_id));
            _local_4.skill_id = this.loading_skill_id;
            _local_11 = (_local_4.cooldown == 0);
            if (((_arg_1.target.content[this.loading_skill_id]) && (!(_local_11))))
            {
                _local_9 = _arg_1.target.content[this.loading_skill_id];
                _local_9.gotoAndStop(1);
                {
                    _local_9.stopAllMovieClips();
                };
                _local_13 = new SkillHandler(_local_9, this.player_team, this.player_number, _local_4);
            };
            _local_3 = int(this.loading_skill_id.replace("skill_", ""));
            if (this.isMainPlayerOrControllable())
            {
                _local_6 = _arg_1.target.content["icon"];
                this.senjutsu_icons.push(_local_6);
                if (_local_11)
                {
                    this.action_bar["starMC"].visible = true;
                    this.action_bar["boardMC"].visible = true;
                    _local_7 = 0;
                    while (_local_7 < 12)
                    {
                        if (this.action_bar[("pass_" + _local_7)].visible == false)
                        {
                            this.action_bar[("pass_" + _local_7)].visible = true;
                            GF.removeAllChild(this.action_bar[("pass_" + _local_7)].holder);
                            this.action_bar[("pass_" + _local_7)].holder.addChild(_local_6);
                            this.action_bar[("pass_" + _local_7)].holder.skill_id = this.loading_skill_id;
                            this.action_bar[("pass_" + _local_7)].item_id = this.loading_skill_id;
                            this.action_bar[("pass_" + _local_7)].is_senjutsu = true;
                            this.action_bar[("pass_" + _local_7)].is_passive = true;
                            this.eventHandler.addListener(this.action_bar[("pass_" + _local_7)], MouseEvent.MOUSE_OVER, BattleTooltip.showTooltip);
                            this.eventHandler.addListener(this.action_bar[("pass_" + _local_7)], MouseEvent.MOUSE_OUT, BattleTooltip.hideTooltip);
                            break;
                        };
                        _local_7++;
                    };
                }
                else
                {
                    _local_14 = 0;
                    while (_local_14 < 8)
                    {
                        _local_12 = ("senjutsu_" + _local_14);
                        if (this.action_bar[_local_12].filled == false)
                        {
                            this.action_bar[_local_12].filled = true;
                            GF.removeAllChild(this.action_bar[_local_12].holder);
                            this.action_bar[_local_12].holder.addChild(_local_6);
                            this.action_bar[_local_12].cdTxt.text = "";
                            this.action_bar[_local_12].item_id = this.loading_skill_id;
                            this.action_bar[_local_12].movieclip_id = _local_13;
                            this.action_bar[_local_12].is_senjutsu = true;
                            this.action_bar[_local_12].is_passive = false;
                            this.eventHandler.addListener(this.action_bar[_local_12], MouseEvent.CLICK, this.useSenjutsuSkill);
                            this.eventHandler.addListener(this.action_bar[_local_12], MouseEvent.MOUSE_OVER, BattleTooltip.showTooltip);
                            this.eventHandler.addListener(this.action_bar[_local_12], MouseEvent.MOUSE_OUT, BattleTooltip.hideTooltip);
                            break;
                        };
                        _local_14++;
                    };
                };
            };
            if (!_local_11)
            {
                this.addSenjutsuSkillMcToArray(_local_13, _local_12);
            }
            else
            {
                this.addSenjutsuPassiveSkillMcToArray(this.equipped_skills[this.loading_skill_number]);
            };
            try
            {
                _arg_1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
            this.loading_skill_number++;
            this.loadSenjutsuSkills();
        }

        public function addTalentSkillMcToArray(_arg_1:SkillHandler, _arg_2:*=null):*
        {
            this.character_talent_skills_mc.push(_arg_1);
            if (((!(_arg_1 == null)) && (!(_arg_2 == null))))
            {
                this.character_talent_skills_info.push({
                    "mc_index":(this.character_talent_skills_mc.length - 1),
                    "action_bar_prefix":_arg_2,
                    "skill_index":this.loading_skill_id.replace("skill_10", "")
                });
            };
        }

        public function addTalentPassiveSkillMcToArray(_arg_1:*):*
        {
            this.character_talent_passive_skills_mc.push(_arg_1);
        }

        public function getTalentPassiveSkills():*
        {
            return (this.character_talent_passive_skills_mc);
        }

        public function getTalentSkillsMC():*
        {
            return (this.character_talent_skills_mc);
        }

        public function addSenjutsuSkillMcToArray(_arg_1:SkillHandler, _arg_2:*=null):*
        {
            this.character_senjutsu_skills_mc.push(_arg_1);
            if (((!(_arg_1 == null)) && (!(_arg_2 == null))))
            {
                this.character_senjutsu_skills_info.push({
                    "mc_index":(this.character_senjutsu_skills_mc.length - 1),
                    "action_bar_prefix":_arg_2,
                    "skill_index":this.loading_skill_id.replace("skill_30", "")
                });
            };
        }

        public function addSenjutsuPassiveSkillMcToArray(_arg_1:*):*
        {
            this.character_senjutsu_passive_skills_mc.push(_arg_1);
        }

        public function getSenjutsuPassiveSkills():*
        {
            return (this.character_senjutsu_passive_skills_mc);
        }

        public function getSenjutsuSkillsMC():*
        {
            return (this.character_senjutsu_skills_mc);
        }

        public function getTarget():int
        {
            if (this.player_team == "player")
            {
                return (BattleVars.PLAYER_TARGET);
            };
            return (BattleVars.ENEMY_TARGET);
        }

        public function getEnemyTeam():String
        {
            if (this.player_team == "player")
            {
                return ("enemy");
            };
            return ("player");
        }

        public function onUseClassSkill(_arg_1:*):*
        {
            if (!this.can_use_class_skill)
            {
                return (false);
            };
            var _local_2:* = (_arg_1 is MouseEvent);
            if (_local_2)
            {
                if (!_arg_1.currentTarget.enabled)
                {
                    BattleManager.showMessage("Cannot use any skill");
                    return (false);
                };
            };
            var _local_3:SkillHandler = this.class_skill;
            var _local_4:int = this.getTarget();
            if (this.player_model.effects_manager.hadEffect("unyielding"))
            {
                if (_local_2)
                {
                    BattleManager.showMessage("Cannot use any skill, under Unyielding Effect");
                };
                return (false);
            };
            if ((((this.player_model.IS_CHAOS) && (!(_local_2))) && (!(this.class_skill_id == "skill_4001"))))
            {
                this.handleChaos();
                return (false);
            };
            var _local_5:String = this.getEnemyTeam();
            var _local_6:MovieClip = BattleManager.getBattle().getObjectHolder(this.player_team, this.player_number);
            var _local_7:MovieClip = BattleManager.getBattle().getObjectHolder(_local_5, _local_4);
            this.checkFillOutfit(_local_3);
            if (this.class_skill_id == "skill_4004")
            {
                _local_3.setPositionAndAttack(this.player_team, _local_4, this.player_number, false);
            };
            if (BattleManager.getBattle().showGUI)
            {
                BattleManager.giveMessage(_local_3.skill_info.skill_name);
            };
            BattleManager.getBattle().playTheSkillAnimation(_local_3.skill_mc, _local_7, _local_6);
            this.setActionBarVisible(false);
            this.can_use_class_skill = false;
            this.helpForActionBar("disable", "btnClassSkill_1");
            if ((_arg_1 is MouseEvent))
            {
                BattleTimer.stopTurnTimer();
                this.eventHandler.removeListener(this.action_bar["btnClassSkill_1"], MouseEvent.CLICK, this.onUseClassSkill);
                this.hideSenjutsu();
                Character.battle_logs.push({
                    "_":"special-class",
                    "__":_local_3.skill_info.skill_id
                });
            };
            return (true);
        }

        public function onUseSkill(_arg_1:*, _arg_2:Boolean=false):Boolean
        {
            var _local_3:int;
            if ((_arg_1 is MouseEvent))
            {
                if (!_arg_1.currentTarget.enabled)
                {
                    BattleManager.showMessage("Cannot use any skill");
                    return (false);
                };
                _local_3 = _arg_1.currentTarget.name.replace("skill_", "");
            }
            else
            {
                _local_3 = _arg_1;
            };
            var _local_4:SkillHandler = this.character_skills_mc[_local_3];
            if (((_arg_2) && (!(_local_4.skill_info.skill_target == "Self"))))
            {
                return (false);
            };
            if (!this.player_model.effects_manager.canPlayerUseSkill(this.player_team, this.player_number, _local_4.skill_info, _arg_1))
            {
                return (false);
            };
            var _local_5:int = this.getTarget();
            var _local_6:Boolean = _local_4.setPositionAndAttack(this.player_team, _local_5, this.player_number, false);
            var _local_7:Boolean = this.player_model.health_manager.hasEnoughCPForSkill(_local_4.skill_info);
            if (_local_6)
            {
                if (_local_7)
                {
                    this.checkFillOutfit(_local_4);
                    this.playTheSkill(_local_4);
                    this.setActionBarVisible(false);
                    if ((_arg_1 is MouseEvent))
                    {
                        BattleTimer.stopTurnTimer();
                        Character.battle_logs.push({
                            "_":"skill",
                            "__":_local_4.skill_info.skill_id
                        });
                    };
                    return (true);
                };
                if (!(_arg_1 is MouseEvent))
                {
                    this.onChargeUsed();
                    return (true);
                };
                BattleManager.showMessage("Not enough chakra");
            }
            else
            {
                if ((_arg_1 is MouseEvent))
                {
                    BattleManager.showMessage("Skill is under cooldown");
                };
            };
            return (false);
        }

        public function checkFillOutfit(_arg_1:*):void
        {
            if (((_arg_1.isOutfitFilled()) || (Character.is_stickman)))
            {
                return;
            };
            var _local_2:* = this.player_model.character_manager;
            var _local_3:* = this.player_model.character_info;
            _arg_1.fillOutfit(_local_2.getWeapon(), _local_2.getBackItem(), _local_2.getClothing(), _local_2.getHair(), _local_2.getFace(), _local_3.hair_color, _local_3.skin_color);
        }

        public function playTheSkill(_arg_1:SkillHandler):*
        {
            this.last_used_skill_mc = _arg_1;
            var _local_2:String = _arg_1.skill_info.skill_id;
            var _local_3:* = SkillLibrary.getCopy(_local_2);
            var _local_4:Boolean = ((_local_3.skill_target == "Self") ? true : false);
            var _local_5:Boolean = ((_local_3.skill_type == "7") ? true : false);
            var _local_6:Boolean = ((_local_3.skill_type == "6") ? true : false);
            var _local_7:int = this.getTarget();
            var _local_8:String = this.getEnemyTeam();
            var _local_9:MovieClip = BattleManager.getBattle().getObjectHolder(this.player_team, this.player_number);
            var _local_10:MovieClip = BattleManager.getBattle().getObjectHolder(_local_8, _local_7);
            if (_local_6)
            {
                this.reduceHPForUsingTaijutsu();
            };
            var _local_11:int = int(this.player_model.health_manager.getSkillCpAmount(_local_3));
            this.player_model.health_manager.reduceCP(_local_11, "skill");
            this.player_model.health_manager.getSkillCpCost(_local_3);
            if (BattleManager.getBattle().showGUI)
            {
                BattleManager.giveMessage(_local_3.skill_name);
            };
            BattleManager.getBattle().playTheSkillAnimation(_arg_1.skill_mc, _local_10, _local_9);
        }

        public function reduceHPForUsingTaijutsu():*
        {
            var _local_1:Number = 5;
            var _local_2:Number = Number(this.player_model.effects_manager.getReduceTaijutsuImprove());
            if (_local_2 > 0)
            {
                _local_1 = (_local_1 - ((_local_2 * 5) / 100));
            };
            var _local_3:int = int(this.player_model.health_manager.getMaxHP());
            this.player_model.health_manager.reduceHealth(Math.floor(((_local_3 * _local_1) / 100)), "Taijutsu HP -");
        }

        public function useTalentSkill(_arg_1:*, _arg_2:Boolean=false):*
        {
            var _local_6:String;
            var _local_8:Boolean;
            var _local_11:int;
            var _local_3:* = (_arg_1 is MouseEvent);
            var _local_4:* = -1;
            if ((_arg_1 is MouseEvent))
            {
                if (!_arg_1.currentTarget.enabled)
                {
                    if (_arg_1.currentTarget.item_id != "skill_1059")
                    {
                        BattleManager.showMessage("Cannot use any skill");
                        return (false);
                    };
                };
                _local_4 = this.action_bar[_arg_1.currentTarget.name].movieclip_id;
            }
            else
            {
                _local_4 = this.character_talent_skills_mc[_arg_1];
            };
            var _local_5:SkillHandler = _local_4;
            if ((((_local_6 = _local_5.skill_info.skill_id) == "skill_1029") && (this.player_number > 0)))
            {
                if (_local_3)
                {
                    BattleManager.showMessage("This skill can be used by primary player/enemy only!");
                };
                return (false);
            };
            var _local_7:* = int(_local_6.replace("skill_10", ""));
            if (this.player_model.effects_manager.hadEffect("snake_mark"))
            {
                if (_local_3)
                {
                    BattleManager.showMessage("Cannot use Talent and Senjutsu under Snake Mark");
                };
                return (false);
            };
            if (((!(this.player_model.effects_manager.hadEffect("extreme_mode"))) && (_local_6 == "skill_1005")))
            {
                if (_local_3)
                {
                    BattleManager.showMessage("This skill requires extreme mode!");
                };
                return (false);
            };
            if (this.player_model.effects_manager.hadEffect("barrier"))
            {
                if (_local_3)
                {
                    BattleManager.showMessage("Under barrier!");
                };
                return (false);
            };
            if (this.player_model.effects_manager.hadEffect("tease"))
            {
                if (_local_3)
                {
                    BattleManager.showMessage("Under Tease!");
                };
                return (false);
            };
            if ((((_local_8 = ((this.player_team == "player") ? Boolean(BattleVars.CHARACTER_REVIVED[this.player_number]) : Boolean(BattleVars.ENEMY_REVIVED[this.player_number]))) && (_local_7 >= 18)) && (_local_7 <= 23)))
            {
                if (_local_3)
                {
                    BattleManager.showMessage("Died once, cannot use Eye of Mirror for this battle..");
                };
                return (false);
            };
            if (this.player_model.effects_manager.hadEffect("unyielding"))
            {
                if (_local_3)
                {
                    BattleManager.showMessage("Cannot use any skill, under Unyielding Effect");
                };
                return (false);
            };
            var _local_9:Boolean = ((this.player_team == "player") ? Boolean(BattleVars.CHARACTER_TEAM_REVIVED[this.player_number]) : Boolean(BattleVars.ENEMY_TEAM_REVIVED[this.player_number]));
            var _local_10:Boolean = this.isOneOrMoreTeammateDead();
            if ((((_local_11 = ((this.player_team == "player") ? int(BattleManager.getBattle().character_team_players.length) : int(BattleManager.getBattle().enemy_team_players.length))) == 1) && (_local_7 == 29)))
            {
                if (_local_3)
                {
                    BattleManager.showMessage("Cannot Revive, Teammates not found!");
                };
                return (false);
            };
            if (((_local_7 == 29) && (!(_local_3))))
            {
                return (false);
            };
            if (((!(_local_10)) && (_local_7 == 29)))
            {
                if (_local_3)
                {
                    BattleManager.showMessage("A teammate needs to die in order to use this skill!");
                };
                return (false);
            };
            if ((((_local_9) && (_local_7 >= 24)) && (_local_7 <= 29)))
            {
                if (_local_3)
                {
                    BattleManager.showMessage("Died once, cannot use Orochi for this battle..");
                };
                return (false);
            };
            var _local_12:int = this.getTarget();
            var _local_13:String = this.getEnemyTeam();
            var _local_14:* = TalentSkillLevel.getCopy(_local_6, this.player_model.character_manager.getTalentLevel(_local_6));
            if (_arg_2)
            {
                if (_local_14.skill_target != "Self")
                {
                    return (false);
                };
            };
            var _local_15:* = _local_5.setPositionAndAttack(this.player_team, _local_12, this.player_number, false);
            _local_14.talent_skill_cp_cost = Math.round((_local_14.talent_skill_cp_cost * this.player_model.character_manager.getLevel()));
            var _local_16:* = this.player_model.health_manager.hasEnoughCPForSkill(_local_14);
            if (_local_15)
            {
                if (_local_16)
                {
                    this.checkFillOutfit(_local_5);
                    this.playTheTalentSkill(_local_5);
                    this.setActionBarVisible(false);
                    if ((_arg_1 is MouseEvent))
                    {
                        BattleTimer.stopTurnTimer();
                        this.hideSenjutsu();
                        Character.battle_logs.push({
                            "_":"talent",
                            "__":_local_6
                        });
                    };
                    return (true);
                };
                if (!_local_3)
                {
                    this.onChargeUsed();
                    return (true);
                };
                BattleManager.showMessage("Not enough chakra");
            }
            else
            {
                if (_local_3)
                {
                    BattleManager.showMessage("Talent skill is under cooldown");
                };
            };
            return (false);
        }

        public function useSenjutsuSkill(_arg_1:*=null, _arg_2:*=null):*
        {
            var _local_3:* = (_arg_1 is MouseEvent);
            var _local_4:* = -1;
            var _local_5:Boolean = true;
            if ((_arg_1 is MouseEvent))
            {
                _local_4 = this.action_bar[_arg_1.currentTarget.name].movieclip_id;
            }
            else
            {
                _local_4 = this.character_senjutsu_skills_mc[_arg_1];
            };
            var _local_6:String = _local_4.skill_info.skill_id;
            var _local_7:Object = SkillLibrary.getSkillInfo(_local_6);
            if (!(_local_5 = Boolean(this.player_model.effects_manager.canPlayerUseSkill(this.player_team, this.player_number, _local_7, _arg_1))))
            {
                return (false);
            };
            var _local_8:int = this.getTarget();
            var _local_9:* = SenjutsuSkillLevel.getCopy(_local_6, this.player_model.character_manager.getSenjutsuLevel(_local_6));
            if (this.player_model.effects_manager.hadEffect("snake_mark"))
            {
                if (_local_3)
                {
                    BattleManager.showMessage("Cannot use Talent and Senjutsu under Snake Mark");
                };
                return (false);
            };
            if (_arg_2)
            {
                if (_local_9.target != "Self")
                {
                    return (false);
                };
            };
            if (_local_4.setPositionAndAttack(this.player_team, _local_8, this.player_number, false))
            {
                if (this.player_model.health_manager.hasEnoughSPForSkill(_local_9))
                {
                    this.checkFillOutfit(_local_4);
                    this.playTheSenjutsuSkill(_local_4);
                    this.setActionBarVisible(false);
                    if (_local_3)
                    {
                        BattleTimer.stopTurnTimer();
                        this.hideSenjutsu();
                        Character.battle_logs.push({
                            "_":"senjutsu",
                            "__":_local_6
                        });
                    };
                    return (true);
                };
                if (!_local_3)
                {
                    this.onWeaponAttack(null, true);
                    return (true);
                };
                BattleManager.showMessage("Not enough SP");
            }
            else
            {
                if (_local_3)
                {
                    BattleManager.showMessage("Senjutsu skill is under cooldown");
                };
            };
            return (false);
        }

        public function isOneOrMoreTeammateDead():*
        {
            var _local_1:* = [];
            if (this.player_team == "player")
            {
                _local_1 = BattleManager.getBattle().character_team_players;
            }
            else
            {
                _local_1 = BattleManager.getBattle().enemy_team_players;
            };
            var _local_2:* = (_local_1.length - 1);
            if (_local_2 == 0)
            {
                return (false);
            };
            var _local_3:* = 0;
            var _local_4:int;
            while (_local_4 < _local_1.length)
            {
                if (_local_1[_local_4].isDead())
                {
                    _local_3++;
                };
                _local_4++;
            };
            _local_1 = null;
            return ((_local_3 > 0) ? true : false);
        }

        public function playTheTalentSkill(_arg_1:*):*
        {
            var _local_2:int = this.getTarget();
            var _local_3:String = this.getEnemyTeam();
            var _local_4:MovieClip = BattleManager.getBattle().getObjectHolder(this.player_team, this.player_number);
            var _local_5:MovieClip = BattleManager.getBattle().getObjectHolder(_local_3, _local_2);
            var _local_6:String = _arg_1.skill_info.skill_id;
            var _local_7:* = TalentSkillLevel.getCopy(_local_6, this.player_model.character_manager.getTalentLevel(_local_6));
            _local_7.talent_skill_cp_cost = Math.round((_local_7.talent_skill_cp_cost * this.player_model.character_manager.getLevel()));
            var _local_8:int = int(this.player_model.health_manager.getSkillCpAmount(_local_7));
            this.player_model.health_manager.reduceCP(_local_8, "talent");
            this.player_model.health_manager.getSkillCpCost(_local_7);
            if (BattleManager.getBattle().showGUI)
            {
                BattleManager.giveMessage(_local_7.talent_skill_name);
            };
            BattleManager.getBattle().playTheSkillAnimation(_arg_1.skill_mc, _local_5, _local_4);
        }

        public function playTheSenjutsuSkill(_arg_1:*):*
        {
            var _local_2:int = this.getTarget();
            var _local_3:String = this.getEnemyTeam();
            var _local_4:MovieClip = BattleManager.getBattle().getObjectHolder(this.player_team, this.player_number);
            var _local_5:MovieClip = BattleManager.getBattle().getObjectHolder(_local_3, _local_2);
            var _local_6:String = _arg_1.skill_info.skill_id;
            var _local_7:* = SenjutsuSkillLevel.getCopy(_local_6, this.player_model.character_manager.getSenjutsuLevel(_local_6));
            var _local_8:int = int(this.player_model.health_manager.getSkillSpAmount(_local_7));
            this.player_model.health_manager.reduceSP(_local_8, "SP -");
            if (BattleManager.getBattle().showGUI)
            {
                BattleManager.giveMessage(_local_7.name);
            };
            BattleManager.getBattle().playTheSkillAnimation(_arg_1.skill_mc, _local_5, _local_4);
        }

        public function reduceRandomSkillCoolDown(_arg_1:int, _arg_2:int=0):*
        {
            var _local_3:Array = this.character_skills_mc;
            var _local_4:int = int(_local_3.length);
            var _local_5:int = NumberUtil.randomInt(0, (_local_3.length - 1));
            var _local_6:Boolean = true;
            if (((!(_local_3[_local_5] == null)) && (_local_3[_local_5].getCurrentCooldown() > 0)))
            {
                _local_6 = false;
                _local_3[_local_5].setCurrentCooldown((_local_3[_local_5].getCurrentCooldown() - _arg_1));
                if (_local_3[_local_5].getCurrentCooldown() < 0)
                {
                    _local_3[_local_5].setCurrentCooldown(0);
                };
            };
            if (_local_6)
            {
                if (_arg_2 < _local_4)
                {
                    this.reduceRandomSkillCoolDown(_arg_1, ++_arg_2);
                };
            };
        }

        public function rewindCooldown(_arg_1:int, _arg_2:Boolean=true, _arg_3:Boolean=false):*
        {
            var _local_4:Array = this.character_skills_mc;
            var _local_5:Array = this.character_talent_skills_mc;
            var _local_6:int;
            if (_arg_2)
            {
                while (_local_6 < _local_4.length)
                {
                    if (_local_4[_local_6] != null)
                    {
                        _local_4[_local_6].setCurrentCooldown((int(_local_4[_local_6].getCurrentCooldown()) - _arg_1));
                        if (_local_4[_local_6].getCurrentCooldown() < 0)
                        {
                            _local_4[_local_6].setCurrentCooldown(0);
                        };
                    };
                    _local_6++;
                };
            };
            _local_6 = 0;
            if (_arg_3)
            {
                while (_local_6 < _local_5.length)
                {
                    if (_local_5[_local_6] != null)
                    {
                        _local_5[_local_6].setCurrentCooldown((int(_local_5[_local_6].getCurrentCooldown()) - _arg_1));
                        if (_local_5[_local_6].getCurrentCooldown() < 0)
                        {
                            _local_5[_local_6].setCurrentCooldown(0);
                        };
                    };
                    _local_6++;
                };
            };
            Effects.showEffectInfo(this.player_team, this.player_number, ("Rewind Cooldown " + _arg_1), false);
            this.updateSkillsCooldownDisplay(0);
        }

        public function increaseSkillTypeCds(_arg_1:int, _arg_2:int):*
        {
            var _local_3:* = undefined;
            var _local_4:Array = this.character_skills_mc;
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                if (_local_4[_local_5] != null)
                {
                    _local_3 = _local_4[_local_5].skill_info;
                    if (int(_local_3.skill_type) == _arg_2)
                    {
                        _local_4[_local_5].setCurrentCooldown((int(_local_4[_local_5].getCurrentCooldown()) + _arg_1));
                    };
                };
                _local_5++;
            };
            var _local_6:* = "Wind";
            if (_arg_2 == 2)
            {
                _local_6 = "Fire";
            };
            if (_arg_2 == 3)
            {
                _local_6 = "Lightning";
            };
            if (_arg_2 == 4)
            {
                _local_6 = "Earth";
            };
            if (_arg_2 == 5)
            {
                _local_6 = "Water";
            };
            Effects.showEffectInfo(this.player_team, this.player_number, (((_local_6 + " +") + String(_arg_1)) + " CD"));
            this.updateSkillsCooldownDisplay(0);
        }

        public function viceRapidCooldown(_arg_1:int, _arg_2:String):*
        {
            var _local_3:Array = this.character_skills_mc;
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                if (_local_3[_local_4] != null)
                {
                    _local_3[_local_4].setCurrentCooldown((int(_local_3[_local_4].getCurrentCooldown()) + _arg_1));
                };
                _local_4++;
            };
            Effects.showEffectInfo(this.player_team, this.player_number, _arg_2);
            this.updateSkillsCooldownDisplay(0);
        }

        public function setCooldown(_arg_1:int, _arg_2:String):*
        {
            var _local_5:*;
            var _local_6:*;
            var _local_3:* = "";
            var _local_4:Array = this.character_skills_mc;
            _local_5 = 0;
            _local_5 = 0;
            while (_local_5 < _local_4.length)
            {
                _local_6 = SkillLibrary.getSkillInfo(_local_4[_local_5].skill_info.skill_id);
                if (_local_6.skill_id == _arg_2)
                {
                    _local_4[_local_5].setCurrentCooldown((int(_local_4[_local_5].getCurrentCooldown()) + _arg_1));
                };
                _local_5++;
            };
            Effects.showEffectInfo(this.player_team, this.player_number, "+ Cooldown ");
            this.updateSkillsCooldownDisplay(0);
        }

        public function rapidGenjutusuCooldown(_arg_1:int):*
        {
            var _local_2:Array = this.character_skills_mc;
            var _local_3:* = 0;
            while (_local_3 < _local_2.length)
            {
                if (_local_2[_local_3] != null)
                {
                    if (_local_2[_local_3].skill_info.skill_type == "7")
                    {
                        _local_2[_local_3].setCurrentCooldown((int(_local_2[_local_3].getCurrentCooldown()) - _arg_1));
                        if (_local_2[_local_3].getCurrentCooldown() < 0)
                        {
                            _local_2[_local_3].setCurrentCooldown(0);
                        };
                    };
                };
                _local_3++;
            };
            Effects.showEffectInfo(this.player_team, this.player_number, "Genjutsu Cooldown!");
            this.updateSkillsCooldownDisplay(0);
        }

        public function reduceElementSkillsCD(_arg_1:int=1, _arg_2:int=0):*
        {
            var _local_3:String;
            var _local_4:* = undefined;
            var _local_5:Array = this.character_skills_mc;
            var _local_6:* = 0;
            while (_local_6 < _local_5.length)
            {
                if (_local_5[_local_6] != null)
                {
                    _local_3 = _local_5[_local_6].skill_info.skill_id;
                    _local_4 = SkillLibrary.getSkillInfo(_local_3);
                    if (((!(_arg_2 == 0)) && (int(_local_4.skill_type) == _arg_2)))
                    {
                        _local_5[_local_6].setCurrentCooldown((int(_local_5[_local_6].getCurrentCooldown()) - _arg_1));
                        if (_local_5[_local_6].getCurrentCooldown() < 0)
                        {
                            _local_5[_local_6].setCurrentCooldown(0);
                        };
                    };
                };
                _local_6++;
            };
        }

        public function randomOblivion(_arg_1:int, _arg_2:String):*
        {
            var _local_3:Array = this.character_skills_mc;
            var _local_4:int = NumberUtil.randomInt(0, (_local_3.length - 1));
            if (_local_3[_local_4] == null)
            {
                return (this.randomOblivion(_arg_1, _arg_2));
            };
            _local_3[_local_4].setCurrentCooldown((int(_local_3[_local_4].getCurrentCooldown()) + _arg_1));
            Effects.showEffectInfo(this.player_team, this.player_number, _arg_2, false);
            this.updateSkillsCooldownDisplay(0);
        }

        public function setCooldownFromEffect(_arg_1:int, _arg_2:String):*
        {
            var _local_3:Array = this.character_skills_mc.concat(this.character_talent_skills_mc, this.character_senjutsu_skills_mc);
            _local_3 = this.removeEmptyIndices(_local_3);
            _arg_1 = (_arg_1 + 1);
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                if (_local_3[_local_4] != null)
                {
                    _local_3[_local_4].setCurrentCooldown((int(_local_3[_local_4].getCurrentCooldown()) + _arg_1));
                };
                _local_4++;
            };
            Effects.showEffectInfo(this.player_team, this.player_number, _arg_2);
            this.updateSkillsCooldownDisplay(0);
        }

        public function setSingleCooldownFromEffect(_arg_1:int, _arg_2:String):*
        {
            var _local_3:Array = this.character_skills_mc.concat(this.character_talent_skills_mc, this.character_senjutsu_skills_mc);
            _local_3 = this.removeEmptyIndices(_local_3);
            _arg_1 = (_arg_1 + 1);
            var _local_4:int = int(Math.floor((Math.random() * _local_3.length)));
            _local_3[_local_4].setCurrentCooldown((int(_local_3[_local_4].getCurrentCooldown()) + _arg_1));
            Effects.showEffectInfo(this.player_team, this.player_number, _arg_2);
            this.updateSkillsCooldownDisplay(0);
        }

        internal function removeEmptyIndices(_arg_1:Array):Array
        {
            var _local_3:*;
            var _local_2:Array = [];
            for each (_local_3 in _arg_1)
            {
                if (_local_3 !== undefined)
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public function updateSkillsCooldownDisplay(_arg_1:int=1, _arg_2:int=0):*
        {
            var _local_3:String;
            var _local_4:* = undefined;
            var _local_5:Boolean;
            var _local_6:Array = this.character_skills_mc;
            var _local_7:* = 0;
            var _local_8:Array = [];
            while (_local_7 < _local_6.length)
            {
                if (_local_6[_local_7] != null)
                {
                    _local_6[_local_7].setCurrentCooldown((int(_local_6[_local_7].getCurrentCooldown()) - _arg_1));
                    if (_local_6[_local_7].getCurrentCooldown() < 0)
                    {
                        _local_6[_local_7].setCurrentCooldown(0);
                    };
                    this.helpForActionBar("disable", ("skill_" + _local_7));
                    _local_3 = _local_6[_local_7].skill_info.skill_id;
                    _local_4 = SkillLibrary.getSkillInfo(_local_3);
                    if (_local_6[_local_7].getCurrentCooldown() == 0)
                    {
                        _local_8.push(_local_3);
                    };
                    if (((!(_arg_2 == 0)) && (!(_local_4.skill_type == _arg_2))))
                    {
                        _local_6[_local_7].setCurrentCooldown((int(_local_6[_local_7].getCurrentCooldown()) + _arg_1));
                    }
                    else
                    {
                        _local_5 = ((Boolean(this.player_model.effects_manager.hadEffect("restriction"))) && (int(_local_4.skill_type) < 6));
                        _local_5 = (((Boolean(this.player_model.effects_manager.hadEffect("pet_restriction"))) && (int(_local_4.skill_type) < 6)) || (_local_5));
                        _local_5 = (((Boolean(this.player_model.effects_manager.hadEffect("ecstasy"))) && (int(_local_4.skill_type) < 6)) || (_local_5));
                        _local_5 = (((Boolean(this.player_model.effects_manager.hadEffect("pet_ecstasy"))) && (int(_local_4.skill_type) < 6)) || (_local_5));
                        _local_5 = ((((Boolean(this.player_model.effects_manager.hadEffect("snake_mark"))) && (int(_local_4.skill_type) == 9)) || (int((_local_4.skill_type == 11)))) || (_local_5));
                        _local_5 = ((Boolean(this.player_model.effects_manager.hadEffect("meridian_seal"))) || (_local_5));
                        _local_5 = ((Boolean(this.player_model.effects_manager.hadEffect("barrier"))) || (_local_5));
                        if (((_local_6[_local_7].getCurrentCooldown() == 0) && (!(_local_5))))
                        {
                            this.helpForActionBar("enable", ("skill_" + _local_7));
                        };
                        try
                        {
                            this.action_bar[("skill_" + String(_local_7))].cdTxt.text = ((_local_6[_local_7].getCurrentCooldown() == 0) ? "" : _local_6[_local_7].getCurrentCooldown());
                        }
                        catch(e)
                        {
                        };
                    };
                };
                _local_7++;
            };
            this.player_model.character_manager.getSkillsWithCooldown(_local_8);
        }

        public function updateSenjutsuSkillsCooldownDisplay(_arg_1:int=1):*
        {
            var _local_3:*;
            var _local_2:* = 0;
            while (_local_2 < this.character_senjutsu_skills_mc.length)
            {
                _local_3 = this.character_senjutsu_skills_mc[_local_2];
                if (_local_3 != null)
                {
                    _local_3.setCurrentCooldown(Math.max(0, (int(this.character_senjutsu_skills_mc[_local_2].getCurrentCooldown()) - _arg_1)));
                    if (_local_3.getCurrentCooldown() == 0)
                    {
                        this.helpForActionBar("enable", ("senjutsu_" + _local_2));
                    }
                    else
                    {
                        this.helpForActionBar("disable", ("senjutsu_" + _local_2));
                    };
                    try
                    {
                        this.action_bar[("senjutsu_" + _local_2)].cdTxt.text = ((_local_3.getCurrentCooldown() == 0) ? "" : _local_3.getCurrentCooldown());
                    }
                    catch(e)
                    {
                    };
                };
                _local_2++;
            };
        }

        public function helpForActionBar(action:String, buttonName:String):void
        {
            var buttonHolder:* = undefined;
            try
            {
                if (this.isMainPlayerOrControllable())
                {
                    buttonHolder = this.action_bar[buttonName].holder;
                    if (action == "disable")
                    {
                        BattleManager.getMain().disableButton(buttonHolder);
                    }
                    else
                    {
                        if (action == "enable")
                        {
                            BattleManager.getMain().enableButton(buttonHolder);
                        };
                    };
                };
            }
            catch(e:Error)
            {
            };
        }

        public function updateTalentSkillsCooldownDisplay(_arg_1:int=1):*
        {
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            var _local_2:* = 0;
            while (_local_2 < this.character_talent_skills_info.length)
            {
                _local_3 = this.character_talent_skills_info[_local_2].mc_index;
                _local_4 = this.character_talent_skills_info[_local_2].action_bar_prefix;
                _local_5 = this.character_talent_skills_info[_local_2].skill_index;
                _local_6 = this.character_talent_skills_mc[_local_3];
                _local_6.setCurrentCooldown(Math.max(0, (int(this.character_talent_skills_mc[_local_3].getCurrentCooldown()) - _arg_1)));
                if (_local_6.skill_info.skill_id == "skill_1059")
                {
                    if (_local_6.getCurrentCooldown() == 0)
                    {
                        this.helpForActionBar("enable", _local_4);
                        this.can_use_talent_skill = true;
                    }
                    else
                    {
                        this.helpForActionBar("disable", _local_4);
                        this.can_use_talent_skill = false;
                    };
                };
                if (_local_6.getCurrentCooldown() == 0)
                {
                    this.helpForActionBar("enable", _local_4);
                }
                else
                {
                    this.helpForActionBar("disable", _local_4);
                };
                if ((((this.player_team == "player") && (BattleVars.CHARACTER_REVIVED[this.player_number])) || ((this.player_team == "enemy") && (BattleVars.ENEMY_REVIVED[this.player_number]))))
                {
                    if (((_local_5 >= 18) && (_local_5 <= 23)))
                    {
                        this.greyOutPassiveEOMSkills();
                    };
                };
                if ((((this.player_team == "player") && (BattleVars.CHARACTER_TEAM_REVIVED[this.player_number])) || ((this.player_team == "enemy") && (BattleVars.ENEMY_TEAM_REVIVED[this.player_number]))))
                {
                    if (((_local_5 >= 24) && (_local_5 <= 29)))
                    {
                        this.greyOutPassiveOrochiSkills();
                    };
                };
                this.action_bar[_local_4].cdTxt.text = ((_local_6.getCurrentCooldown() == 0) ? "" : _local_6.getCurrentCooldown());
                _local_2++;
            };
        }

        public function greyOutPassiveOrochiSkills():*
        {
            var _local_1:* = undefined;
            var _local_2:* = undefined;
            try
            {
                _local_1 = 0;
                while (_local_1 < 12)
                {
                    if (this.action_bar[("pass_" + _local_1)].visible)
                    {
                        _local_2 = int(this.action_bar[("pass_" + _local_1)].holder.skill_id.replace("skill_10", ""));
                        if (((_local_2 >= 24) && (_local_2 <= 29)))
                        {
                            this.helpForActionBar("disable", ("pass_" + _local_1));
                        };
                    };
                    _local_1++;
                };
            }
            catch(e)
            {
            };
            _local_1 = 0;
            while (_local_1 < 4)
            {
                try
                {
                    this.eventHandler.removeListener(this.action_bar[("bl_" + _local_1)], MouseEvent.CLICK, this.useTalentSkill);
                }
                catch(e)
                {
                };
                this.helpForActionBar("disable", ("bl_" + _local_1));
                _local_1++;
            };
        }

        public function greyOutPassiveEOMSkills():*
        {
            var _local_1:* = undefined;
            var _local_2:* = undefined;
            try
            {
                _local_1 = 0;
                while (_local_1 < 12)
                {
                    if (this.action_bar[("pass_" + _local_1)].visible)
                    {
                        _local_2 = int(this.action_bar[("pass_" + _local_1)].holder.skill_id.replace("skill_10", ""));
                        if (((_local_2 >= 18) && (_local_2 <= 23)))
                        {
                            this.helpForActionBar("disable", ("pass_" + _local_1));
                        };
                    };
                    _local_1++;
                };
            }
            catch(e)
            {
            };
            _local_1 = 0;
            while (_local_1 < 4)
            {
                try
                {
                    this.eventHandler.removeListener(this.action_bar[("bl_" + _local_1)], MouseEvent.CLICK, this.useTalentSkill);
                }
                catch(e)
                {
                };
                this.helpForActionBar("disable", ("bl_" + _local_1));
                _local_1++;
            };
        }

        public function greyOutPassiveSaintSkills():*
        {
            var _local_1:* = 0;
            while (_local_1 < 4)
            {
                try
                {
                    this.eventHandler.removeListener(this.action_bar[("bl_" + _local_1)], MouseEvent.CLICK, this.useTalentSkill);
                }
                catch(e)
                {
                };
                this.helpForActionBar("disable", ("bl_" + _local_1));
                _local_1++;
            };
        }

        public function getTalentSkillsMCSkills():*
        {
            if (((this.character_talent_skills is Array) && (this.character_talent_skills.length > 0)))
            {
                return (this.character_talent_skills[0]);
            };
            return ("");
        }

        public function getSenjutsuSkillsMCSkills():*
        {
            if (((this.character_senjutsu_skills is Array) && (this.character_senjutsu_skills.length > 0)))
            {
                return (this.character_senjutsu_skills[0]);
            };
            return ("");
        }

        public function isMainPlayerOrControllable():Boolean
        {
            if (((this.player_team == "player") && (this.player_number == 0)))
            {
                return (true);
            };
            return ((Character.teammate_controllable) && (this.player_team == "player"));
        }

        public function destroy():*
        {
            var _local_1:int;
            Log.debug(this, "destroy");
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            GF.destroyArray(this.character_skills_mc);
            GF.destroyArray(this.character_talent_skills);
            GF.destroyArray(this.character_talent_skills_mc);
            GF.destroyArray(this.character_talent_passive_skills_mc);
            GF.destroyArray(this.character_talent_skills_info);
            GF.destroyArray(this.character_senjutsu_skills);
            GF.destroyArray(this.character_senjutsu_skills_mc);
            GF.destroyArray(this.character_senjutsu_passive_skills_mc);
            GF.destroyArray(this.character_senjutsu_skills_info);
            GF.destroyArray(this.outfits);
            GF.destroyArray([this.class_skill]);
            GF.clearArray(this.loadeds);
            GF.removeAllChild(this.player_model);
            GF.removeAllChild(this.specialclass_icon);
            GF.removeAllChildArray(this.skill_icons);
            GF.removeAllChildArray(this.talent_icons);
            GF.removeAllChildArray(this.senjutsu_icons);
            if (this.action_bar != null)
            {
                this.action_bar.cacheAsBitmap = false;
                _local_1 = 0;
                while (_local_1 < 8)
                {
                    TweenLite.killTweensOf(this.action_bar[("senjutsu_" + _local_1)]);
                    TweenLite.killTweensOf(this.action_bar[("skill_" + _local_1)]);
                    delete this.action_bar[("skill_" + _local_1)].movieclip_id;
                    this.action_bar[("skill_" + _local_1)].cacheAsBitmap = false;
                    delete this.action_bar[("senjutsu_" + _local_1)].movieclip_id;
                    this.action_bar[("senjutsu_" + _local_1)].cacheAsBitmap = false;
                    GF.removeAllChild(this.action_bar[("senjutsu_" + _local_1)].holder);
                    GF.removeAllChild(this.action_bar[("skill_" + _local_1)].holder);
                    _local_1++;
                };
                _local_1 = 0;
                while (_local_1 < 4)
                {
                    delete this.action_bar[("bl_" + _local_1)].movieclip_id;
                    this.action_bar[("bl_" + _local_1)].cacheAsBitmap = false;
                    delete this.action_bar[("se_" + int((_local_1 + 4)))].movieclip_id;
                    this.action_bar[("se_" + int((_local_1 + 4)))].cacheAsBitmap = false;
                    GF.removeAllChild(this.action_bar[("bl_" + _local_1)].holder);
                    GF.removeAllChild(this.action_bar[("se_" + int((_local_1 + 4)))].holder);
                    if (((("enemyMcInfo_" + String(_local_1)) in this.action_bar) && (("skill_" + String((_local_1 + 1))) in this.action_bar[("enemyMcInfo_" + String(_local_1))])))
                    {
                        GF.removeAllChild(this.action_bar[("enemyMcInfo_" + _local_1)][("skill_" + int((_local_1 + 1)))].holder);
                    };
                    _local_1++;
                };
                _local_1 = 0;
                while (_local_1 < 12)
                {
                    GF.removeAllChild(this.action_bar[("pass_" + _local_1)].holder);
                    delete this.action_bar[("pass_" + _local_1)].holder.skill_id;
                    delete this.action_bar[("pass_" + _local_1)].item_id;
                    delete this.action_bar[("pass_" + _local_1)].is_senjutsu;
                    delete this.action_bar[("pass_" + _local_1)].is_passive;
                    _local_1++;
                };
                this.action_bar["btnClassSkill_1"].cacheAsBitmap = false;
                GF.removeAllChild(this.action_bar["btnClassSkill_1"].holder);
            };
            GF.removeAllChild(this.action_bar);
            this.outfits = null;
            this.player_team = null;
            this.player_number = null;
            this.player_model = null;
            this.action_bar = null;
            this.character_skills_mc = null;
            this.character_talent_skills = null;
            this.character_talent_skills_mc = null;
            this.character_talent_skills_info = null;
            this.character_talent_passive_skills_mc = null;
            this.character_senjutsu_skills = null;
            this.character_senjutsu_skills_mc = null;
            this.character_senjutsu_skills_info = null;
            this.character_senjutsu_passive_skills_mc = null;
            this.equipped_skills = null;
            this.loading_skill_number = null;
            this.loading_skill_id = null;
            this.confirmation_mc = null;
            this.last_used_skill_mc = null;
            this.all_loaded = null;
            this.can_use_class_skill = null;
            this.can_use_talent_skill = null;
            this.intelligence_class_used = null;
            this.class_skill = null;
            this.class_skill_id = null;
            this.skill_icons = null;
            this.talent_icons = null;
            this.senjutsu_icons = null;
            this.specialclass_icon = null;
            this.loadeds = null;
        }


    }
}//package Combat

