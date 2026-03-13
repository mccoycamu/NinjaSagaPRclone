// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.Battle

package Combat
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import Storage.Character;
    import com.utils.NumberUtil;
    import id.ninjasage.Util;
    import Storage.SkillLibrary;
    import Storage.SkillBuffs;
    import Storage.TalentSkillLevel;
    import Managers.OutfitManager;
    import Storage.SenjutsuSkillLevel;
    import Combat.BattleVars;
    import flash.utils.setTimeout;
    import flash.events.Event;
    import Storage.Library;
    import flash.geom.Point;
    import com.hurlant.util.Base64;
    import com.adobe.crypto.CUCSG;
    import amf.amfConnect;
    import com.hurlant.util.Hex;
    import com.hurlant.crypto.hash.MD5;
    import id.ninjasage.Clan;
    import id.ninjasage.Crew;
    import flash.utils.getDefinitionByName;
    import Popups.ClanBattleResults;
    import id.ninjasage.Log;
    import com.utils.GF;
    import Storage.WeaponBuffs;
    import Storage.AccessoryBuffs;
    import Storage.BackItemBuffs;

    public class Battle extends MovieClip 
    {

        public static var SHOW_HP_TEXT:Boolean = false;

        public var atk_turnTimerTxt:MovieClip;
        public var btn_WorldChat:SimpleButton;
        public var dh_hint:MovieClip;
        public var logo:MovieClip;
        public var rekrut:TextField;
        public var senjutsuTransition:SenjutsuTransition;
        public var sushiMc:MovieClip;
        public var teamMc:MovieClip;
        public var teamTxt:TextField;
        public var totalDamageHint:MovieClip;
        public var versionTxt:TextField;
        public var woodFrame:MovieClip;
        public var actionBar:MovieClip;
        public var actionBar1:MovieClip;
        public var actionBar2:MovieClip;
        public var atbBar:MovieClip;
        public var bgHolder:MovieClip;
        public var btnOption:SimpleButton;
        public var btn_UI_Gear:SimpleButton;
        public var charMc_0:CharHpHolder;
        public var charMc_1:CharHpHolder;
        public var charMc_2:CharHpHolder;
        public var charPetMc_0:CharPetHpHolder;
        public var charPetMc_1:CharPetHpHolder;
        public var charPetMc_2:CharPetHpHolder;
        public var char_hpcp:MovieClip;
        public var enemyMcInfo_0:MovieClip;
        public var enemyMcInfo_1:MovieClip;
        public var enemyMcInfo_2:MovieClip;
        public var enemyMc_0:MovieClip;
        public var enemyMc_1:MovieClip;
        public var enemyMc_2:MovieClip;
        public var enemyPetMc_0:EnemyPetHpHolder;
        public var enemyPetMc_1:EnemyPetHpHolder;
        public var enemyPetMc_2:EnemyPetHpHolder;
        public var scrollDisplayMc_0:ScrollScript;
        public var scrollDisplayMc_1:ScrollScript;
        public var scrollDisplayMc_2:ScrollScript;
        public var character_team_players:Array = [];
        public var enemy_team_players:Array = [];
        public var agility_bar_manager:AgilityBarManager;
        public var attacker_model:*;
        public var defender_model:*;
        public var master_model:*;
        public var animation:*;
        public var base_damage:int;
        public var total_damage:int;
        public var total_damage_done:Number = 0;
        public var defender_models:Array = [];
        public var attacker_models:Array = [];
        public var reset_new_amount_objects:Array = [];
        public var reset_next_turn_objects:Array = [];
        public var _main:*;
        public var gear:* = null;
        public var option:* = null;
        public var world_chat:* = null;
        public var battle_stages_fllw:* = ["wind", "fire", "thunder", "earth", "water"];
        public var can_set_elements:Boolean = false;
        public var current_round:* = 0;
        public var type_disperse:String = "";
        public var copySkillMC:SkillHandler;
        public var showGUI:Boolean = true;
        private var eventHandler:*;
        private var outfits:* = [];
        private var destroyed:* = false;

        public function Battle(param1:*)
        {
            this._main = param1;
            this.eventHandler = new EventHandler();
        }

        public function setupView():*
        {
            BattleManager.loadBackground();
            BattleManager.hideEverything();
            BattleManager.loadPlayerTeam();
            BattleManager.playBgm();
        }

        public function setupAgilityBar():*
        {
            this.eventHandler.addListener(this["enemyMc_0"], MouseEvent.CLICK, this.onTargetChange);
            this.eventHandler.addListener(this["enemyMc_1"], MouseEvent.CLICK, this.onTargetChange);
            this.eventHandler.addListener(this["enemyMc_2"], MouseEvent.CLICK, this.onTargetChange);
            this.eventHandler.addListener(this["btn_WorldChat"], MouseEvent.CLICK, this.openWorldChat);
            this.eventHandler.addListener(this["btn_UI_Gear"], MouseEvent.CLICK, this.onOpenGear);
            this.eventHandler.addListener(this["btnOption"], MouseEvent.CLICK, this.openSettings);
            this.eventHandler.addListener(this["logo"], MouseEvent.CLICK, this.hideUI);
            this.showTargetArrow();
            this.agility_bar_manager = new AgilityBarManager();
            try
            {
                stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
                stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
            }
            catch(e)
            {
            };
        }

        public function toggleFastForward():void
        {
            if (stage.frameRate == 24)
            {
                stage.frameRate = 60;
                BattleManager.getMain().showMessage("Fast Forward: ON");
            }
            else
            {
                stage.frameRate = 24;
                BattleManager.getMain().showMessage("Fast Forward: OFF");
            };
        }

        public function toggleHpText():void
        {
            SHOW_HP_TEXT = (!(SHOW_HP_TEXT));
            BattleManager.getMain().showMessage(("HP Text: " + ((SHOW_HP_TEXT) ? "ON" : "OFF")));
            var _loc1_:* = 0;
            while (_loc1_ < this.character_team_players.length)
            {
                if (((this.character_team_players[_loc1_]) && (this.character_team_players[_loc1_].health_manager)))
                {
                    this.character_team_players[_loc1_].health_manager.updateHealthBar();
                };
                _loc1_++;
            };
            _loc1_ = 0;
            while (_loc1_ < this.enemy_team_players.length)
            {
                if (((this.enemy_team_players[_loc1_]) && (this.enemy_team_players[_loc1_].health_manager)))
                {
                    this.enemy_team_players[_loc1_].health_manager.updateHealthBar();
                };
                _loc1_++;
            };
        }

        public function cycleTarget():void
        {
            var _loc1_:int = int(BattleVars.PLAYER_TARGET);
            var _loc2_:int;
            var _loc3_:Boolean;
            while (_loc2_ < 3)
            {
                if (++_loc1_ > 2)
                {
                    _loc1_ = 0;
                };
                if (((this.enemy_team_players[_loc1_]) && (!(this.enemy_team_players[_loc1_].isDead()))))
                {
                    _loc3_ = true;
                    break;
                };
                _loc2_++;
            };
            if (_loc3_)
            {
                BattleVars.MASTER_PLAYER_TARGET = _loc1_;
                BattleVars.PLAYER_TARGET = _loc1_;
                this.resetTargetArrows();
                this.showTargetArrow();
            };
        }

        public function onKeyDown(param1:KeyboardEvent):void
        {
            if (BattleManager.getBattle() != this)
            {
                try
                {
                    stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
                }
                catch(e)
                {
                };
                return;
            };
            if (param1.keyCode == 70)
            {
                this.toggleFastForward();
                return;
            };
            if (param1.keyCode == 72)
            {
                this.toggleHpText();
                return;
            };
            if (param1.keyCode == 67)
            {
                this.hideUI(null);
                return;
            };
            if (param1.keyCode == 9)
            {
                param1.preventDefault();
                this.cycleTarget();
                return;
            };
            if (((((!(this.attacker_model)) || (!(this.attacker_model.isCharacter()))) || (!(this.attacker_model.getPlayerTeam() == "player"))) || (!(this.attacker_model.getPlayerNumber() == 0))))
            {
                return;
            };
            if ((((!(this.actionBar.visible)) && (!(this.actionBar1.visible))) && (!(this.actionBar2.visible))))
            {
                return;
            };
            switch (param1.keyCode)
            {
                case 81:
                default:
                    this.attacker_model.actions_manager.onChargeUsed(new MouseEvent(MouseEvent.CLICK));
                    return;
                case 87:
                    this.attacker_model.actions_manager.onWeaponAttack(new MouseEvent(MouseEvent.CLICK));
                    return;
            };
        }

        public function openWorldChat(param1:MouseEvent):*
        {
            this.world_chat = this._main.loadPanel("Panels.WorldChat", true);
        }

        public function onOpenGear(param1:MouseEvent):*
        {
            this.gear = this._main.loadPanel("Panels.Battle_UI_Gear", true);
        }

        public function openSettings(param1:MouseEvent):*
        {
            this.option = this._main.loadPanel("Panels.UI_Option", true);
            this.option.panel.btn_change.visible = false;
            this.option.setOnBattle();
        }

        public function setRandomStage():*
        {
            var _loc1_:* = Math.floor((Math.random() * 5));
            var _loc2_:* = this.battle_stages_fllw[_loc1_];
            if (Character.stage_mode == _loc2_)
            {
                this.setRandomStage();
                return;
            };
            this.setStageBGTo(_loc2_);
        }

        public function setStageBGTo(param1:*):*
        {
            Character.stage_mode = param1;
            switch (param1)
            {
                case "wind":
                default:
                    BattleLoader.bg_holder.gotoAndStop("bg_1");
                    break;
                case "fire":
                    BattleLoader.bg_holder.gotoAndStop("bg_2");
                    break;
                case "thunder":
                    BattleLoader.bg_holder.gotoAndStop("bg_3");
                    break;
                case "earth":
                    BattleLoader.bg_holder.gotoAndStop("bg_4");
                    break;
                case "water":
                    BattleLoader.bg_holder.gotoAndStop("bg_5");
            };
            BattleLoader.bg_holder.bgMC.anim.addFrameScript((BattleLoader.bg_holder.bgMC.anim.totalFrames - 1), function ():void
            {
                BattleLoader.bg_holder.bgMC.anim.stop();
            });
            BattleLoader.bg_holder.bgMC.anim.play();
            if (this.can_set_elements)
            {
                this.setElementsForStage4();
            };
        }

        public function setElementsForStage4():*
        {
            var _loc1_:*;
            this.can_set_elements = true;
            var _loc2_:Array = [];
            if (Character.stage_mode == "wind")
            {
                _loc2_ = ["wind", "fire", "thunder"];
            }
            else
            {
                if (Character.stage_mode == "fire")
                {
                    _loc2_ = ["fire", "thunder", "earth"];
                }
                else
                {
                    if (Character.stage_mode == "thunder")
                    {
                        _loc2_ = ["thunder", "earth", "water"];
                    }
                    else
                    {
                        if (Character.stage_mode == "earth")
                        {
                            _loc2_ = ["earth", "water", "wind"];
                        }
                        else
                        {
                            if (Character.stage_mode == "water")
                            {
                                _loc2_ = ["water", "wind", "fire"];
                            };
                        };
                    };
                };
            };
            var _loc3_:* = [false, false, false];
            var _loc4_:* = 0;
            while (_loc4_ < _loc2_.length)
            {
                if ((!(_loc3_[_loc4_])))
                {
                    _loc1_ = this.enemy_team_players[_loc4_].setModes(Character.stage_mode, _loc2_[_loc4_]);
                    if (((!(_loc1_)) && (_loc4_ == 0)))
                    {
                        _loc3_[1] = true;
                        _loc1_ = this.enemy_team_players[1].setModes(Character.stage_mode, _loc2_[_loc4_]);
                        if ((!(_loc1_)))
                        {
                            _loc3_[2] = true;
                            this.enemy_team_players[2].setModes(Character.stage_mode, _loc2_[_loc4_]);
                        };
                    };
                    _loc3_[_loc4_] = true;
                };
                _loc4_++;
            };
        }

        public function onTargetChange(param1:MouseEvent):*
        {
            var _loc2_:int = int(param1.currentTarget.name.replace("enemyMc_", ""));
            var _loc3_:* = this.getObjectHolder("enemy", _loc2_).charMc.character_model;
            var _loc4_:Boolean;
            if (_loc3_.health_manager.getCurrentHP() > 0)
            {
                if (this.isMainPlayerOrControllable(this.agility_bar_manager.ambush_team, this.agility_bar_manager.ambush_num))
                {
                    if ((!(this.agility_bar_manager.is_running)))
                    {
                        _loc4_ = true;
                        BattleVars.MASTER_PLAYER_TARGET = _loc2_;
                        BattleVars.PLAYER_TARGET = _loc2_;
                    };
                };
            };
            if (_loc4_)
            {
                this.resetTargetArrows();
                this.showTargetArrow();
            };
        }

        public function showTargetArrow():*
        {
            this.getObjectHolder("enemy", BattleVars.PLAYER_TARGET).targetArrow.gotoAndPlay("show");
            var _loc1_:int = (this.numChildren - 2);
            this.setChildIndex(this.getObjectHolder("enemy", BattleVars.PLAYER_TARGET), _loc1_);
        }

        public function resetTargetArrows():*
        {
            var _loc1_:*;
            var _loc2_:int;
            while (_loc2_ < 3)
            {
                _loc1_ = this.getObjectHolder("enemy", _loc2_);
                _loc1_.targetArrow.gotoAndStop("idle");
                _loc2_++;
            };
        }

        public function addToResetNextTurnOnNextTurn(param1:Object, param2:String, param3:int):*
        {
            this.reset_next_turn_objects.push([param1, param2, param3]);
        }

        public function resetNextTurnOnNextTurn(param1:String, param2:int):*
        {
            var _loc3_:Array;
            var _loc4_:int;
            while (_loc4_ < this.reset_next_turn_objects.length)
            {
                _loc3_ = this.reset_next_turn_objects[_loc4_];
                if (((_loc3_[1] == param1) && (_loc3_[2] == param2)))
                {
                    _loc3_[0].next_turn = false;
                    this.reset_next_turn_objects.removeAt(_loc4_);
                    this.resetNextTurnOnNextTurn(param1, param2);
                    return;
                };
                _loc4_++;
            };
        }

        public function addToResetNewAmountOnNextTurn(param1:Object, param2:String, param3:int):*
        {
            this.reset_new_amount_objects.push([param1, param2, param3]);
        }

        public function resetNewAmountOnNextTurn(param1:String, param2:int):*
        {
            var _loc3_:Array;
            var _loc4_:int;
            while (_loc4_ < this.reset_new_amount_objects.length)
            {
                _loc3_ = this.reset_new_amount_objects[_loc4_];
                if (((_loc3_[1] == param1) && (_loc3_[2] == param2)))
                {
                    _loc3_[0].new_amount = undefined;
                    this.reset_new_amount_objects.removeAt(_loc4_);
                    this.resetNewAmountOnNextTurn(param1, param2);
                    return;
                };
                _loc4_++;
            };
        }

        public function resetVarsForNextTurn(param1:String, param2:int):*
        {
            this.resetNewAmountOnNextTurn(param1, param2);
            this.resetNextTurnOnNextTurn(param1, param2);
            BattleVars.resetVarsForNextTurn();
            this.total_damage = 0;
            this.hideActionBars();
            this.handleObjectLayers(param1, param2);
        }

        private function isUnderSkipTurnEffect(param1:*):*
        {
            var _loc2_:*;
            if (param1.effects_manager.hadEffect("skip_turn"))
            {
                _loc2_ = param1.effects_manager.getEffect("skip_turn");
                if (_loc2_.chance >= NumberUtil.getRandomInt())
                {
                    _loc2_.duration--;
                    return (true);
                };
            };
            return (false);
        }

        private function handleBlockDamage():void
        {
            if (((this.attacker_model == undefined) || (this.defender_model == undefined)))
            {
                return;
            };
            var _loc1_:Boolean;
            if ((!(this.attacker_model.isCharacter())))
            {
                return;
            };
            var _loc2_:int = int(this.defender_model.checkBlockDamage());
            var _loc3_:int;
            if (this.attacker_model.isCharacter())
            {
                _loc3_ = (_loc3_ + this.attacker_model.checkIgnoreBlockDamage());
            };
            var _loc4_:int = NumberUtil.getRandomInt();
            _loc2_ = (_loc2_ - _loc3_);
            if (((_loc2_ > 0) && (_loc2_ > _loc4_)))
            {
                _loc1_ = true;
                Effects.showEffectInfo(this.defender_model.getPlayerTeam(), this.defender_model.getPlayerNumber(), "Parry", false);
            };
            this.defender_model.IS_BLOCK_DAMAGE = _loc1_;
        }

        private function resetBattleVars():void
        {
            BattleVars.SKILL_USED_ID = "";
            BattleVars.ATTACK_TYPE = "";
            BattleVars.IS_SELF_SKILL = "";
            BattleVars.IS_CRITICAL = "";
            BattleVars.GENJUTSU_REBOUND = "";
        }

        public function setupViewForAmbush(param1:String, param2:int):void
        {
            var _loc7_:Object;
            this.resetBattleVars();
            this.attacker_model = this.getObjectHolder(param1, param2).charMc.character_model;
            this.attacker_model.effects_manager.checkForSnakeShadow(this.attacker_model);
            var _loc3_:Object = this.attacker_model;
            BattleVars.checkPurify(_loc3_);
            var _loc4_:Object = _loc3_.effects_manager;
            var _loc5_:Object = _loc3_.health_manager;
            _loc3_.debuff_resist = false;
            this.attacker_model.effects_manager.getCriticalAndAccuracyWhenHPBelow();
            this.attacker_model.effects_manager.getAccuracyBelowHP();
            this.attacker_model.IS_CHAOS = false;
            if (this.isUnderSkipTurnEffect(_loc3_))
            {
                BattleManager.startRun();
                return;
            };
            var _loc6_:String = _loc4_.showActiveEffects();
            _loc4_.deductDurationOfEffects();
            this.handleBlockDamage();
            BattleVars.checkCombustion(_loc3_);
            _loc4_.resetHasAddedHpCpEffects();
            this.resetVarsForNextTurn(param1, param2);
            _loc5_.addSP("turn");
            _loc4_.checkPurifyOnRoundStart();
            _loc4_.checkPassiveEffects();
            _loc4_.checkMeridianCutOffFinish();
            _loc4_.checkDecreaseMaxCPFinish();
            _loc4_.checkIncreaseMaxHPCPFinish();
            if (((!(_loc3_.isCharacter())) && (Boolean(_loc3_.isDead()))))
            {
                BattleManager.startRun();
                return;
            };
            if (((Boolean(_loc5_.checkActivateUnyielding())) || (Boolean(_loc5_.checkReviveEOM()))))
            {
                return;
            };
            if (((Boolean(_loc3_.isCharacter())) && (Boolean(_loc3_.isDead()))))
            {
                BattleManager.startRun();
                return;
            };
            if (_loc3_.isCharacter())
            {
                _loc7_ = _loc3_.actions_manager;
                _loc7_.updateSkillsCooldownDisplay();
                _loc7_.updateTalentSkillsCooldownDisplay();
                _loc7_.updateSenjutsuSkillsCooldownDisplay();
            };
            _loc4_.checkBackgroundChangeFinish();
            if (_loc6_ == "")
            {
                this.setActionsAvailable(param1, param2);
            }
            else
            {
                this.handleSkipTurns(_loc6_, param1, param2);
            };
        }

        public function setActionsAvailable(param1:String, param2:int, param3:String=""):void
        {
            if (this.isMainPlayerOrControllable(param1, param2))
            {
                this.handleVisibility(param2);
                BattleTimer.startTurnTimer();
                if (this.showGUI)
                {
                    this["btn_UI_Gear"].visible = true;
                };
                this["char_hpcp"]["btn_activate_senjutsu"].visible = (this.attacker_model.character_info.character_rank > 7);
                this["dh_hint"]["captureBtn"].visible = ((BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.DRAGON_HUNT_MATCH) || (Character.is_cny_event));
                if (param3 == "Exceptional Skill")
                {
                    this.handleExceptionalSkill();
                };
                this.checkShadowWarEffects();
                this.handleIntelligenceClass();
                if (((param1 == "player") && (param2 == 0)))
                {
                    this.handlePlayerTurn();
                };
            }
            else
            {
                this.handleNonControllableAttacker();
            };
        }

        private function handleVisibility(param1:int):void
        {
            var _loc2_:String = this.getActionBarName(param1);
            this[_loc2_].visible = true;
            this.setChildIndex(this[_loc2_], (this.numChildren - 1));
            if (this.showGUI)
            {
                this["btn_UI_Gear"].visible = true;
            };
            this["char_hpcp"]["btn_activate_senjutsu"].visible = (this.attacker_model.character_info.character_rank > 7);
            this["dh_hint"]["captureBtn"].visible = (BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.DRAGON_HUNT_MATCH);
        }

        private function handleExceptionalSkill():void
        {
            if (this.showGUI)
            {
                this["btn_UI_Gear"].visible = false;
            };
            this["dh_hint"]["captureBtn"].visible = false;
            this.attacker_model.actions_manager.disableAllButClassSkill();
        }

        private function checkShadowWarEffects():void
        {
            if (((BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.SHADOWWAR_MATCH) && (!(this.attacker_model.actions_manager.shadow_war_effect_applied))))
            {
                this.attacker_model.actions_manager.checkEffectForShadowWar();
            };
        }

        private function handleIntelligenceClass():void
        {
            this.attacker_model.actions_manager.checkUseIntelligenceClass();
            this.attacker_model.actions_manager.reduceCooldownToHeavyAttackClass();
        }

        private function getActionBarName(param1:int):String
        {
            return ((param1 == 1) ? "actionBar1" : ((param1 == 2) ? "actionBar2" : "actionBar"));
        }

        private function handlePlayerTurn():void
        {
            BattleVars.PLAYER_TARGET = BattleVars.MASTER_PLAYER_TARGET;
            this.resetTargetArrows();
            this.showTargetArrow();
            this.showDragonHuntHint();
            this.showTotalDamageHint();
            if (((Character.is_jounin_stage_4) && (++this.current_round > 1)))
            {
                this.current_round = 0;
                this.setRandomStage();
            };
        }

        private function handleNonControllableAttacker():void
        {
            var _loc1_:String = ((this.attacker_model.isPet()) ? "PET" : ((this.attacker_model.isNpc()) ? "NPC" : ((this.attacker_model.isEnemy()) ? "ENEMY" : "CHARACTER")));
            BattleVars.ATTACKER_TYPE = _loc1_;
            if (((_loc1_ == "PET") || (_loc1_ == "NPC")))
            {
                this.fillMasterModel();
            };
            this.attacker_model.getAttack();
        }

        public function handleSkipTurns(param1:String, param2:String, param3:int):*
        {
            var _loc4_:Boolean = Effects.doesEffectSkipTurns(param1);
            var _loc5_:Boolean = Boolean(this.attacker_model.isCharacter());
            var _loc6_:* = (!(["barrier", "chaos", "pet_chaos"].indexOf(param1) == -1));
            if ((((_loc5_) && ((_loc4_) || (_loc6_))) && (Boolean(this.attacker_model.actions_manager.canUseExceptionalSkill(this.attacker_model)))))
            {
                this.attacker_model.IS_CHAOS = ((param1 == "chaos") || (param1 == "pet_chaos"));
                return (this.setActionsAvailable(param2, param3, "Exceptional Skill"));
            };
            if (_loc4_)
            {
                this.agility_bar_manager.startRun();
                return;
            };
            if (_loc6_)
            {
                this.attacker_model.handleChaos();
                return;
            };
            if (param1 == "tease")
            {
                if (_loc5_)
                {
                    this.attacker_model.handleTease();
                }
                else
                {
                    this.agility_bar_manager.startRun();
                };
                return;
            };
            if (((_loc5_) && (Util.in_array(param1, ["barrier", "restriction", "pet_restriction", "meridian_seal"]))))
            {
                return (this.setActionsAvailable(param2, param3));
            };
            this.agility_bar_manager.startRun();
        }

        private function handleDisperse(param1:Array, param2:Object):Boolean
        {
            var _loc6_:int;
            var _loc3_:Boolean;
            var _loc4_:Array = param2.effects_manager.dataBuff;
            var _loc5_:int;
            while (_loc5_ < param1.length)
            {
                if (param1[_loc5_].effect == "disperse")
                {
                    if (("chance" in param1[_loc5_]))
                    {
                        _loc6_ = NumberUtil.getRandomInt();
                        if (param1[_loc5_].chance < _loc6_)
                        {
                            return (false);
                        };
                    };
                    _loc3_ = true;
                    param2.health_manager.createDisplay("Disperse");
                    this.removeEffect(_loc4_, "disperse");
                };
                _loc5_++;
            };
            return (_loc3_);
        }

        private function removeEffect(param1:Array, param2:String):void
        {
            var _loc3_:int;
            var _loc4_:Object;
            if (param1.length > 0)
            {
                _loc3_ = int((param1.length - 1));
                for (;_loc3_ >= 0;_loc3_--)
                {
                    _loc4_ = param1[_loc3_];
                    if (param2 == "disperse")
                    {
                        if (Effects.doesEffectCannotDisperse(_loc4_.effect)) continue;
                    }
                    else
                    {
                        if (param2 == "purify")
                        {
                            if (Effects.doesEffectCannotPurified(_loc4_.effect)) continue;
                        };
                    };
                    param1.splice(_loc3_, 1);
                };
            };
        }

        private function handlePurify(param1:Array, param2:Object):void
        {
            var _loc3_:int;
            var _loc4_:Array;
            if (param1.length == 0)
            {
                return;
            };
            if (((Boolean(param2.effects_manager.hadEffect("negate"))) && (!(param1[_loc3_].effect == "sensation"))))
            {
                return;
            };
            _loc3_ = 0;
            while (_loc3_ < param1.length)
            {
                if ((((param1[_loc3_].effect == "purify") || (param1[_loc3_].effect == "sensation")) || (param1[_loc3_].effect == "debuff_clear")))
                {
                    if ((("is_master_buff" in param1[_loc3_]) && (Boolean(param1[_loc3_].is_master_buff))))
                    {
                        param2 = BattleManager.getBattle().master_model;
                    };
                    if ((("target" in param1[_loc3_]) && (param1[_loc3_].target == "master")))
                    {
                        param2 = BattleManager.getBattle().master_model;
                    };
                    param2.effects_manager.checkRecoverHPAfterPurified();
                    param2.effects_manager.checkDecreaseMaxCPFinish();
                    _loc4_ = param2.effects_manager.dataDebuff;
                    param2.health_manager.createDisplay("Purify");
                    this.removeEffect(_loc4_, "purify");
                };
                _loc3_++;
            };
        }

        public function weaponAttack():*
        {
            BattleVars.ATTACK_TYPE = "weapon";
            this.attacker_model.action_type = "weapon";
            this.handleDamageAndEffects();
        }

        public function weaponAttackFinish():*
        {
            this.afterAttackChecks("weapon", false, true);
        }

        public function hitPlayer():*
        {
            this.handleDamageAndEffects();
        }

        public function hitByPet():*
        {
            this.handleDamageAndEffects();
        }

        public function hitEnemyNpc():*
        {
            this.handleDamageAndEffects();
        }

        public function handleDamageAndEffects():void
        {
            var _loc9_:Object;
            var _loc10_:Boolean;
            var _loc1_:Object = this.attacker_model.getAttackResult();
            var _loc2_:int = int(_loc1_.damage);
            var _loc3_:Array = _loc1_.effects;
            var _loc4_:Boolean = Boolean(_loc1_.multi_hit);
            var _loc5_:Boolean = Boolean(_loc1_.self_target);
            var _loc6_:Object = this.attacker_model;
            var _loc7_:* = (this.geetTarget(_loc5_) + "_model");
            var _loc8_:Array = [this[_loc7_]];
            this.fillPlayers("attacker");
            this.fillPlayers("defender");
            if (_loc4_)
            {
                _loc8_ = this[(_loc7_ + "s")];
            };
            this.handlePurify(_loc3_, _loc6_);
            if ((!(_loc5_)))
            {
                this.handlingDodge();
                for each (_loc9_ in _loc8_)
                {
                    if (_loc9_.IS_DODGED)
                    {
                        this.displayDodge(_loc9_);
                    }
                    else
                    {
                        _loc10_ = this.handleDisperse(_loc3_, _loc9_);
                        this.defender_model = _loc9_;
                        if (_loc10_)
                        {
                            _loc9_.IS_BLOCK_DAMAGE = false;
                        };
                        if ((!(_loc10_)))
                        {
                            _loc9_.effects_manager.getDebuffResistByTalent();
                        };
                        this.addInternalInjury(_loc3_, _loc9_);
                        this.handlingExtraEffects(BattleVars.SKILL_USED_ID);
                        this.handlingDamage(_loc9_, _loc2_);
                    };
                };
                this.handlingWeaponAttackEffect();
            };
            this.handlingEffect(_loc3_);
            _loc6_.theft_mode = false;
        }

        private function addInternalInjury(param1:Array, param2:Object):*
        {
            var _loc3_:Object;
            for each (_loc3_ in param1)
            {
                if ((!(_loc3_.is_passive)))
                {
                    if (_loc3_.effect == "internal_injury")
                    {
                        if ((!(param2.IS_DODGED)))
                        {
                            param2.effects_manager.addDebuff(_loc3_);
                        };
                    };
                };
            };
        }

        private function handlingWeaponAttackEffect():void
        {
            var _loc3_:Array;
            var _loc4_:Object;
            var _loc1_:String = "weapon";
            if (this.attacker_model.effects_manager.hadEffect("disable_weapon_effect"))
            {
                return;
            };
            var _loc2_:Array = this.attacker_model.effects_manager.getAllCharacterSetEffects();
            for each (_loc3_ in _loc2_)
            {
                for each (_loc4_ in _loc3_)
                {
                    if (Effects.doesEffectGoesToActiveAfterPassive(_loc4_.effect))
                    {
                        if (this.shouldActivateEffect(_loc4_, _loc1_))
                        {
                            this.handlePassiveToActiveEffect(_loc4_);
                        };
                    };
                };
            };
        }

        private function shouldActivateEffect(param1:Object, param2:String):Boolean
        {
            var _loc3_:int;
            if (("chance" in param1))
            {
                _loc3_ = NumberUtil.getRandomInt();
                return ((param1.chance >= _loc3_) && (BattleVars.ATTACK_TYPE == param2));
            };
            return (true);
        }

        private function handlingDodge():void
        {
            var _loc7_:Object;
            var _loc1_:Boolean;
            var _loc2_:Array = this.defender_models;
            var _loc3_:Array = ["skill_2058", "skill_2059", "skill_2060", "skill_4004", "skill_554", "skill_719", "skill_669", "skill_2146", "skill_2165", "skill_2179", "skill_2188", "skill_2203", "skill_2215", "skill_6063", "skill_6064", "skill_2219", "skill_2241", "skill_2303", "skill_2316"];
            var _loc4_:Array = ["skill_426", "skill_2222", "skill_431"];
            var _loc5_:Array = [];
            var _loc6_:int;
            while (_loc6_ < _loc2_.length)
            {
                _loc7_ = _loc2_[_loc6_];
                _loc1_ = BattleVars.getCalculateDodge(_loc7_, this.attacker_model, BattleVars.SKILL_USED_ID);
                _loc6_++;
            };
        }

        private function displayDodge(param1:Object):void
        {
            if (param1.IS_DODGED)
            {
                param1.playAnimation("dodge");
                param1.effects_manager.checkAddHPAfterDodge();
                param1.effects_manager.checkStrengthenAfterDodgedTheAttack();
                Effects.showEffectInfo(param1.getPlayerTeam(), param1.getPlayerNumber(), "Dodge", false);
            };
        }

        private function handlingEffects(param1:Array):void
        {
            var effect:Object;
            var typeEffect:String;
            var target:Array;
            var buffModel:Array;
            var debuffModel:Array;
            var effects:Array = param1;
            for each (effect in effects)
            {
                if ((!(effect.is_passive)))
                {
                    try
                    {
                        typeEffect = (((((Boolean(effect.is_self_buff)) || (Boolean(effect.is_master_buff))) || (Boolean(effect.is_buff))) || ((effect.is_self) && (!(effect.is_debuff)))) ? "buff" : "debuff");
                        if ((!((effect.effect == "internal_injury") && (!(effect.is_self_debuff)))))
                        {
                            if ((((Boolean(effect.is_self_buff)) && (Boolean(effect.is_debuff))) || (Boolean(effect.is_self_debuff))))
                            {
                                target = [this.attacker_model];
                                this.applyEffect(target, effect, "Debuff");
                            }
                            else
                            {
                                if (typeEffect == "buff")
                                {
                                    buffModel = [this.attacker_model];
                                    buffModel = ((effect.is_master_buff) ? [this.master_model] : buffModel);
                                    if (("multi_hit" in effect))
                                    {
                                        buffModel = ((effect.multi_hit) ? this.attacker_models : buffModel);
                                    };
                                    this.applyEffect(buffModel, effect, "Buff");
                                }
                                else
                                {
                                    debuffModel = [this.defender_model];
                                    if (("multi_hit" in effect))
                                    {
                                        debuffModel = ((effect.multi_hit) ? this.defender_models : debuffModel);
                                    }
                                    else
                                    {
                                        if (("is_master_debuff" in effect))
                                        {
                                            debuffModel = ((effect.is_master_debuff) ? [this.master_model] : debuffModel);
                                        };
                                    };
                                    this.applyEffect(debuffModel, effect, "Debuff");
                                };
                            };
                        };
                    }
                    catch(e:Error)
                    {
                    };
                };
            };
        }

        private function handlingEffect(param1:Array):void
        {
            var effect:Object;
            var effects:Array = param1;
            for each (effect in effects)
            {
                if ((!(effect.passive)))
                {
                    if ((!((effect.effect === "internal_injury") && (!(effect.target == "self")))))
                    {
                        try
                        {
                            this.setEffect(effect.target, effect);
                        }
                        catch(e:Error)
                        {
                        };
                    };
                };
            };
        }

        private function setEffect(param1:String, param2:Object):*
        {
            var _loc3_:Array;
            switch (param1)
            {
                case "self":
                default:
                    _loc3_ = ((param2.multi_hit) ? this.attacker_models : [this.attacker_model]);
                    break;
                case "enemy":
                    _loc3_ = ((param2.multi_hit) ? this.defender_models : [this.defender_model]);
                    break;
                case "master":
                    _loc3_ = [this.master_model];
            };
            this.applyEffect(_loc3_, param2, param2.type);
        }

        private function applyEffect(param1:Array, param2:Object, param3:String):*
        {
            var _loc5_:Object;
            var _loc4_:int;
            for (;_loc4_ < param1.length;_loc4_++)
            {
                _loc5_ = param1[_loc4_];
                if (param3 === "Debuff")
                {
                    if (_loc5_.isDead()) continue;
                    if (_loc5_.IS_DODGED) continue;
                    if (BattleVars.GENJUTSU_REBOUND)
                    {
                        _loc5_.health_manager.createDisplay("Genjutsu Rebound");
                        _loc5_ = this.attacker_model;
                    }
                    else
                    {
                        _loc5_.playAnimation("hit");
                    };
                };
                if (("chance" in param2))
                {
                    if (param2.chance >= NumberUtil.getRandomInt())
                    {
                        var _local_6:* = _loc5_.effects_manager;
                        (_local_6[("add" + param3)](param2, _loc5_));
                    };
                }
                else
                {
                    _local_6 = _loc5_.effects_manager;
                    (_local_6[("add" + param3)](param2, _loc5_));
                };
            };
        }

        private function handlingExtraEffects(param1:String):void
        {
            var _loc2_:Object;
            var _loc3_:Object = SkillLibrary.get(param1);
            var _loc4_:Array = SkillBuffs.getCopy(param1).skill_effect;
            if (_loc4_ == null)
            {
                _loc4_ = [];
            };
            _loc4_ = this.getElementalEffects(_loc4_, int(_loc3_.skill_type));
            _loc4_ = this.checkForDisperse(_loc4_);
            if (((param1 == "skill_236") && (Boolean(this.getAttacker().effects_manager.hadEffect("attention")))))
            {
                if (this.defender_model.IS_DODGED)
                {
                    return;
                };
                _loc2_ = {
                    "passive":false,
                    "type":"Debuff",
                    "target":"enemy",
                    "effect":"instant_reduce_hp",
                    "effect_name":"Instant Reduce HP",
                    "calc_type":"percent",
                    "reduce_type":"MAX",
                    "duration":0,
                    "amount":_loc4_[0].amount
                };
                this.defender_model.effects_manager.addDebuff(_loc2_);
            };
            if (((param1 == "skill_270") && (Boolean(this.getAttacker().effects_manager.hadEffect("plus_extra_hp")))))
            {
                _loc2_ = {
                    "passive":false,
                    "type":"Debuff",
                    "target":"enemy",
                    "effect":"weaken",
                    "effect_name":"Weaken",
                    "calc_type":"percent",
                    "duration":_loc4_[0].duration,
                    "amount":_loc4_[0].amount
                };
                this.defender_model.effects_manager.addDebuff(_loc2_);
            };
            if (((param1 == "skill_253") && (Boolean(this.getAttacker().effects_manager.hadEffect("plus_protection")))))
            {
                _loc2_ = {
                    "passive":false,
                    "type":"Debuff",
                    "target":"enemy",
                    "effect":"internal_injury",
                    "effect_name":"Internal Injury",
                    "duration":_loc4_[0].duration
                };
                this.defender_model.effects_manager.addDebuff(_loc2_);
            };
            if (((param1 == "skill_287") && (Boolean(this.getAttacker().effects_manager.hadEffect("reduce_wind_cd")))))
            {
                _loc2_ = {
                    "passive":false,
                    "type":"Debuff",
                    "target":"enemy",
                    "effect":"bleeding",
                    "effect_name":"Bleeding",
                    "calc_type":"percent",
                    "duration":_loc4_[0].duration,
                    "amount":_loc4_[0].amount
                };
                this.defender_model.effects_manager.addDebuff(_loc2_);
            };
        }

        private function handlingDamage(param1:Object, param2:int):void
        {
            if (param1.isDead())
            {
                return;
            };
            if (param2 <= 0)
            {
                return;
            };
            var _loc3_:Boolean = Boolean(param1.effects_manager.checkForShedding());
            if (_loc3_)
            {
                param1.health_manager.createDisplay("Shedding");
                return;
            };
            this.attacker_model.effects_manager.checkForPowerofToad(param1);
            var _loc4_:Boolean = Boolean(this.attacker_model.effects_manager.handleLightMatter());
            if (((_loc4_) && (!(param1.IS_BLOCK_DAMAGE))))
            {
                param1.effects_manager.addEffect("Debuff", "internal_injury", "Internal Injury", 0, "", 2, 100, "after_attack");
            };
            var _loc5_:Boolean = Boolean(this.attacker_model.effects_manager.handleDarkMatter());
            if (((_loc5_) && (!(param1.IS_BLOCK_DAMAGE))))
            {
                param1.effects_manager.addEffect("Debuff", "disable_weapon_effect", "Disable Weapon Effect", 0, "", 2, 100, "immediately");
            };
            if (BattleVars.SKILL_USED_ID == "skill_4004")
            {
                this.initiateAssaultClass(param1, param2);
                return;
            };
            if (param1.IS_BLOCK_DAMAGE)
            {
                Effects.showEffectInfo(param1.getPlayerTeam(), param1.getPlayerNumber(), "Damage Blocked", false);
                return;
            };
            var _loc6_:Object = param1.effects_manager;
            _loc6_.wakePlayer();
            if (BattleVars.SWITCH_ATTACK_MODELS)
            {
                param1 = this.attacker_model;
            };
            if (BattleVars.REDUCED_HP_AS_DAMAGE)
            {
                if ((!((Boolean(param1.debuff_resist)) || (Boolean(param1.effects_manager.hadEffect("debuff_resist"))))))
                {
                    BattleVars.REDUCED_HP_AS_DAMAGE = false;
                    param2 = (param2 + this.handleReduceHpAsDamage(BattleVars.SKILL_USED_ID, param1));
                    param1.health_manager.reduceHealth(param2, "HP-");
                    param1.playAnimation("hit");
                    _loc6_.wakePlayer();
                    param1.health_manager.addSP("attacked", param2);
                    param1.effects_manager.handlingTransform(param2);
                    this.total_damage = param2;
                    param1.effects_manager.checkReboundAfterHPDeduct(param2);
                    return;
                };
            };
            var _loc7_:int = int(BattleVars.SKILL_USED_ID.replace("skill_", ""));
            var _loc8_:Boolean = ((BattleVars.SKILL_USED_TYPE == 6) || ((_loc7_ > 999) && (_loc7_ < 1006)));
            var _loc9_:Boolean = BattleVars.IS_CRITICAL;
            if (((!(BattleVars.ATTACKER_TYPE == "PET")) && (!(BattleVars.IS_SELF_SKILL))))
            {
                _loc6_.checkRandomLock();
            };
            param2 = int(this.attacker_model.effects_manager.calculateDamage(param2, param1, _loc8_));
            param1.effects_manager.calculateChanceFromTalent_Wolfram(param2);
            _loc6_.checkBurnAfterDidDamage();
            _loc6_.checkLavaShield();
            _loc6_.checkCapture();
            _loc6_.checkBleedingAfterDidDamage();
            _loc6_.checkStunAfterDidDamage();
            _loc6_.checkDisorientAttacker();
            _loc6_.checkSlowAttacker();
            _loc6_.checkReduceHPAttacker();
            _loc6_.checkDamageToCP(param1, param2);
            if (((_loc9_) && (param2 > 0)))
            {
                _loc6_.checkBurnAfterCritical(param1);
                _loc6_.checkStunAfterCritical(param1);
                this.attacker_model.effects_manager.checkRecoverHPAfterCritical(this.attacker_model);
                this.attacker_model.effects_manager.checkConcentrationAfterCritical(this.attacker_model);
            };
            param2 = int(_loc6_.checkAbsorbDamage(param1, param2));
            if (((BattleVars.SKILL_USED_TYPE == 1) || (BattleVars.SKILL_USED_TYPE == 3)))
            {
                _loc6_.checkWeakenEnemy();
            };
            if (((BattleVars.SKILL_USED_TYPE == 1) || (BattleVars.SKILL_USED_TYPE == 5)))
            {
                _loc6_.checkFreezeEnemy();
            };
            param1.health_manager.addSP("attacked", param2);
            var _loc10_:Boolean = ((param2 === 0) ? true : false);
            if (this.checkForReboundDamage(this.attacker_model, param1, param2))
            {
                return;
            };
            param1.playAnimation("hit");
            param1.health_manager.reduceHealth(param2, "-");
            param1.effects_manager.handlingTransform(param2);
            param1.effects_manager.checkTheft();
            var _loc11_:Boolean = Boolean(param1.checkConvertDamage());
            if (_loc11_)
            {
                param1.health_manager.addHealth(param2, "Damage Converted HP +");
            };
            param1.effects_manager.checkReboundAfterHPDeduct(param2);
            _loc6_.checkPassiveEffectsAfterBeingHit(param1, this.attacker_model, _loc10_);
            this.total_damage = param2;
        }

        private function reboundDamage(param1:Object, param2:Object, param3:int, param4:String):void
        {
            param1.health_manager.reduceHealth(param3, param4);
            param2.playAnimation("hit");
            this.total_damage = param3;
        }

        private function checkForReboundDamage(param1:Object, param2:Object, param3:int):Boolean
        {
            var _loc4_:Boolean;
            if (param2.effects_manager.checkSereneMind())
            {
                this.reboundDamage(param1, param2, param3, "Serene Mind -");
                _loc4_ = true;
            };
            if (param1.effects_manager.hadEffect("confinement"))
            {
                this.reboundDamage(param1, param2, param3, "Confinement -");
                _loc4_ = true;
            };
            return (_loc4_);
        }

        private function initiateAssaultClass(param1:Object, param2:int):void
        {
            param1.health_manager.reduceHealth(param2, "HP -");
            param1.playAnimation("hit");
            param1.effects_manager.wakePlayer();
            param1.health_manager.addSP("attacked", param2);
            param1.effects_manager.handlingTransform(param2);
            this.total_damage = param2;
            param1.effects_manager.checkReboundAfterHPDeduct(param2);
        }

        private function addDamageAfterCritical(param1:int):int
        {
            var _loc4_:Object;
            var _loc2_:int = 50;
            if (this.attacker_model.effects_manager.hadEffect("decrease_critical_damage"))
            {
                _loc4_ = this.attacker_model.effects_manager.getEffect("decrease_critical_damage");
                _loc2_ = (_loc2_ - _loc4_.amount);
            };
            if (this.attacker_model.effects_manager.hadEffect("critical_buff_n_received_stun"))
            {
                _loc4_ = this.attacker_model.effects_manager.getEffect("critical_buff_n_received_stun");
                _loc2_ = (_loc2_ + _loc4_.amount);
            };
            if (this.attacker_model.effects_manager.hadEffect("pet_mortal"))
            {
                _loc4_ = this.attacker_model.effects_manager.getEffect("pet_mortal");
                _loc2_ = (_loc2_ + _loc4_.amount);
            };
            var _loc3_:int;
            if (this.attacker_model.isCharacter())
            {
                _loc2_ = (_loc2_ + Math.round((this.attacker_model.character_manager.getLightningAttributes() * 0.8)));
                _loc2_ = (_loc2_ + Math.round(this.attacker_model.effects_manager.getIncreaseCriticalByPassiveEffects("percent")));
                _loc3_ = (_loc3_ + Math.round(this.attacker_model.effects_manager.getIncreaseCriticalByPassiveEffects("number")));
            };
            return (int(((param1 * (1 + (_loc2_ / 100))) + _loc3_)));
        }

        private function getTarget():String
        {
            return ((BattleVars.IS_SELF_SKILL) ? "attacker" : "defender");
        }

        private function geetTarget(param1:Boolean):String
        {
            return ((param1) ? "attacker" : "defender");
        }

        public function handlePassiveToActiveEffect(param1:Object):*
        {
            var _loc2_:int;
            var _loc3_:int;
            if (param1.effect == "kill_instant_under")
            {
                _loc2_ = int(this.defender_model.health_manager.getCurrentHP());
                _loc3_ = int(this.defender_model.health_manager.getMaxHP());
                if (_loc2_ > Math.floor(((_loc3_ * param1.amount) / 100)))
                {
                    return;
                };
                param1.calc_type = "percent";
                param1.prev_effect = "kill_instant_under";
                param1.reduce_type = "MAX";
            };
            param1.effect = Effects.convertPassiveToActiveEffect(param1.effect);
            if (param1.type === "Debuff")
            {
                if ((!(this.defender_model.IS_DODGED)))
                {
                    this.defender_model.effects_manager.addDebuff(param1);
                };
            }
            else
            {
                if (param1.type === "Buff")
                {
                    this.attacker_model.effects_manager.addBuff(param1);
                };
            };
        }

        public function fillMasterModel():*
        {
            var _loc1_:String = String(this.attacker_model.getPlayerTeam());
            var _loc2_:int = (("pet_info" in this.attacker_model) ? int(this.attacker_model.getPlayerNumber()) : 0);
            if (_loc1_ == "player")
            {
                this.master_model = this.character_team_players[_loc2_];
            };
            if (_loc1_ == "enemy")
            {
                this.master_model = this.enemy_team_players[_loc2_];
            };
        }

        public function fillPlayers(param1:String):void
        {
            var _loc2_:Object = ((param1 == "defender") ? this.defender_model : this.attacker_model);
            var _loc3_:String = String(_loc2_.getPlayerTeam());
            if (param1 == "defender")
            {
                this.attacker_models = ((_loc3_ == "player") ? this.enemy_team_players : this.character_team_players);
            }
            else
            {
                this.defender_models = ((_loc3_ == "player") ? this.enemy_team_players : this.character_team_players);
            };
        }

        public function hideActionBars():*
        {
            this["actionBar"].visible = false;
            this["actionBar1"].visible = false;
            this["actionBar2"].visible = false;
        }

        public function getObjectHolder(param1:String, param2:int):*
        {
            if (param1 == "player")
            {
                return (this[("charMc_" + param2.toString())]);
            };
            if (param1 == "enemy")
            {
                return (this[("enemyMc_" + param2.toString())]);
            };
            if (param1 == "player_pet")
            {
                return (this[("charPetMc_" + param2.toString())]);
            };
            if (param1 == "enemy_pet")
            {
                return (this[("enemyPetMc_" + param2.toString())]);
            };
        }

        public function setDefender(param1:String, param2:int):void
        {
            var _loc3_:MovieClip = this.getObjectHolder(param1, param2);
            this.defender_model = _loc3_.charMc.character_model;
            BattleVars.calculateDodge(this.defender_model, this.attacker_model);
            BattleVars.calculateCritical(this.defender_model, this.attacker_model);
        }

        public function getDefender():*
        {
            return (this.defender_model);
        }

        public function getAttacker():*
        {
            return (this.attacker_model);
        }

        public function isMainPlayerOrControllable(param1:String, param2:int):Boolean
        {
            if (((param1 == "player") && (param2 == 0)))
            {
                return (true);
            };
            return (((Character.teammate_controllable) && (param1 == "player")) && (Boolean(this.character_team_players[param2].isCharacter())));
        }

        public function handleObjectLayers(param1:String, param2:int):*
        {
            var _loc3_:MovieClip = this.getObjectHolder(param1, param2);
            var _loc4_:int = (this.numChildren - 1);
            this.setChildIndex(_loc3_, _loc4_);
        }

        public function enemyAttacked():*
        {
            this.afterAttackChecks("", false, true);
        }

        public function petAttacked():*
        {
            this.afterAttackChecks("", false, true);
        }

        public function npcAttacked():*
        {
            this.afterAttackChecks("", false, true);
        }

        public function checkPlayDeadAnimation():*
        {
            var _loc1_:*;
            if (BattleVars.PLAY_DEAD_ANIMATION == "CHAR")
            {
                _loc1_ = this.getObjectHolder(BattleVars.PLAY_DEAD_TEAM, BattleVars.PLAY_DEAD_NUMBER).charMc.character_model;
                _loc1_.playAnimation("standby");
                _loc1_.health_manager.playDeadAnimation();
            };
            if (BattleVars.PLAY_DEAD_ANIMATION == "PET")
            {
                _loc1_ = this.getObjectHolder(BattleVars.PLAY_DEAD_TEAM, BattleVars.PLAY_DEAD_NUMBER).charMc.character_model;
                _loc1_.deadFrame();
                _loc1_.health_manager.playDeadAnimation();
            };
            if (BattleVars.PLAY_DEAD_ANIMATION == "ENEMY&NPC")
            {
                _loc1_ = this.getObjectHolder(BattleVars.PLAY_DEAD_TEAM, BattleVars.PLAY_DEAD_NUMBER).charMc.character_model;
                _loc1_.deadFrame();
                _loc1_.health_manager.playDeadAnimation();
            };
            BattleVars.PLAY_DEAD_ANIMATION = "";
        }

        public function getTalentSkills():*
        {
            var _loc1_:String;
            try
            {
                return (String(this.attacker_model.actions_manager.character_talent_skills[0]));
            }
            catch(e)
            {
                return ("");
            };
        }

        public function getSenjutsuSkills():*
        {
            var _loc1_:String;
            try
            {
                return (String(this.attacker_model.actions_manager.character_senjutsu_skills[0]));
            }
            catch(e)
            {
                return ("");
            };
        }

        public function hitByTalentSkill(param1:String, param2:int, param3:String):void
        {
            var fireFaint:Object;
            var team:String = param1;
            var num:int = param2;
            var skillId:String = param3;
            BattleVars.ATTACK_TYPE = "talent";
            BattleVars.SKILL_USED_ID = skillId;
            var isTrue:Boolean;
            var titan:Boolean = Boolean(this.attacker_model.effects_manager.hadEffect("titan_mode"));
            var emberstep_demonic:Boolean = Boolean(this.attacker_model.effects_manager.hadEffect("emberstep_demonic"));
            var targetTeam:String = ((team == "player") ? "enemy" : "player");
            var targetNum:int = ((team == "player") ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET);
            try
            {
                this.setDefender(targetTeam, targetNum);
            }
            catch(e:Error)
            {
            };
            var talentLevel:int = int(this.attacker_model.character_manager.getTalentLevel(skillId));
            var talent:Object = TalentSkillLevel.getCopy(skillId, talentLevel);
            talent.talent_skill_damage = Math.floor((talent.talent_skill_damage * this.attacker_model.character_manager.getLevel()));
            var skillTarget:Boolean = ((("skill_target" in talent) && (talent.skill_target == "Self")) ? true : false);
            var talentDamage:int = int(talent.talent_skill_damage);
            if (skillId == "skill_1022")
            {
                BattleVars.JUST_USED_TITAN = true;
            };
            if (((titan) && (skillId == "skill_1022")))
            {
                this.defender_model.IS_DODGED = false;
            }
            else
            {
                talent.effects = this.checkForDisperse(talent.effects);
                isTrue = (((int(skillId.replace("skill_", "")) > 999) && (int(skillId.replace("skill_", "")) < 1006)) ? true : false);
                switch (skillId)
                {
                    case "skill_1038":
                    default:
                        if (Boolean(this.defender_model.effects_manager.hadEffect("capture")))
                        {
                            talentDamage = Math.floor((talentDamage * 3));
                        };
                        break;
                    case "skill_1037":
                        if (Boolean(this.defender_model.effects_manager.hadEffect("silhouette")))
                        {
                            talent.effects[2].amount = Math.floor((talent.effects[2].amount * 3));
                        };
                        break;
                    case "skill_1041":
                        if (Boolean(this.defender_model.effects_manager.hadEffect("fire_faint")))
                        {
                            fireFaint = this.defender_model.effects_manager.getEffect("fire_faint");
                            talentDamage = int((talentDamage + Math.floor(((fireFaint.amount * talentDamage) / 100))));
                        };
                };
            };
            var isMultiHit:* = ((talent.target == "All") ? true : talent.multi_hit);
            this.attacker_model.attack_result = {
                "damage":talentDamage,
                "effects":talent.effects,
                "multi_hit":isMultiHit,
                "self_target":skillTarget
            };
            this.handleDamageAndEffects();
        }

        public function talentSkillAttackFinished(param1:String, param2:int, param3:String):*
        {
            var _loc4_:*;
            _loc4_ = this.getObjectHolder(param1, param2);
            _loc4_.charMc.visible = true;
            OutfitManager.removeChildsFromMovieClips(_loc4_.skillMc);
            this.clearCopySkillMC();
            this.afterAttackChecks(param3, false, true);
        }

        public function hitBySenjutsuSkill(param1:String, param2:int, param3:String):*
        {
            BattleVars.ATTACK_TYPE = "senjutsu";
            BattleVars.SKILL_USED_ID = param3;
            var _loc4_:String = this.getSenjutsuSkills();
            var _loc5_:String = ((param1 == "player") ? "enemy" : "player");
            var _loc6_:int = ((param1 == "player") ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET);
            this.setDefender(_loc5_, _loc6_);
            var _loc7_:* = SkillLibrary.getSkillInfo(param3);
            var _loc8_:* = this.attacker_model.character_manager.getSenjutsuLevel(_loc7_.skill_id);
            var _loc9_:* = SenjutsuSkillLevel.getCopy(param3, _loc8_);
            var _loc10_:Boolean = ((("target" in _loc9_) && (_loc9_.target == "Self")) ? true : false);
            var _loc11_:int = int(_loc9_.damage);
            var _loc12_:* = ((_loc9_.target == "All") ? true : _loc9_.multi_hit);
            BattleVars.SKILL_USED_TYPE = int(_loc7_.skill_type);
            this.attacker_model.action_type = _loc7_.skill_type;
            if (((Boolean(_loc9_.multi_hit)) && (_loc10_)))
            {
                BattleVars.SWITCH_ATTACK_MODELS = true;
            };
            this.attacker_model.attack_result = {
                "damage":_loc11_,
                "effects":_loc9_.effects,
                "multi_hit":_loc12_,
                "self_target":_loc10_
            };
            this.handleDamageAndEffects();
        }

        public function senjutsuSkillAttackFinished(param1:String, param2:int, param3:String):*
        {
            var _loc4_:*;
            _loc4_ = this.getObjectHolder(param1, param2);
            _loc4_.charMc.visible = true;
            OutfitManager.removeChildsFromMovieClips(_loc4_.skillMc);
            this.clearCopySkillMC();
            this.afterAttackChecks(param3, false, true);
        }

        public function checkDamageAfterCriticalAndCombustion(param1:*):int
        {
            var _loc2_:int;
            var _loc3_:Number = 0;
            var _loc4_:Number = 0;
            if (((BattleVars.CAN_NOT_DODGE) || (BattleVars.REDUCED_HP_AS_DAMAGE)))
            {
                return (param1);
            };
            if (this.attacker_model.isCharacter())
            {
                _loc3_ = (this.attacker_model.character_manager.getFireAttributes() * 0.4);
            };
            if (_loc3_ > 0)
            {
                param1 = (param1 + Math.floor(((param1 * _loc3_) / 100)));
            };
            if (BattleVars.IS_CRITICAL)
            {
                param1 = Math.floor((param1 * 1.5));
                if (this.attacker_model.effects_manager.hadEffect("decrease_critical_damage"))
                {
                    _loc2_ = int(this.attacker_model.effects_manager.getEffect("decrease_critical_damage").amount);
                    param1 = (param1 - Math.floor(((param1 * _loc2_) / 100)));
                };
                if (this.attacker_model.effects_manager.hadEffect("critical_buff_n_received_stun"))
                {
                    _loc2_ = int(this.attacker_model.effects_manager.getEffect("critical_buff_n_received_stun").amount);
                    param1 = (param1 + Math.floor(((param1 * _loc2_) / 100)));
                };
                if (this.attacker_model.effects_manager.hadEffect("pet_mortal"))
                {
                    _loc2_ = int(this.attacker_model.effects_manager.getEffect("pet_mortal").amount);
                    param1 = (param1 + Math.floor(((param1 * _loc2_) / 100)));
                };
                if (this.attacker_model.isCharacter())
                {
                    _loc4_ = Number(this.attacker_model.effects_manager.getIncreaseCriticalByPassiveEffects());
                    if (_loc4_ > 0)
                    {
                        param1 = (param1 + Math.floor(((param1 * _loc4_) / 100)));
                    };
                    _loc4_ = (this.attacker_model.character_manager.getLightningAttributes() * 0.8);
                    if (_loc4_ > 0)
                    {
                        param1 = (param1 + Math.floor(((param1 * _loc4_) / 100)));
                    };
                };
            };
            if (BattleVars.IS_COMBUSTION)
            {
                param1 = Math.floor((param1 * 1.3));
            };
            return (param1);
        }

        public function hitBySpecialSkill(param1:String, param2:int, param3:String):*
        {
            var _loc11_:String;
            var _loc4_:Number = NaN;
            var _loc5_:int;
            var _loc6_:int;
            var _loc7_:Number = NaN;
            BattleVars.ATTACK_TYPE = "class_skill";
            BattleVars.SKILL_USED_ID = param3;
            var _loc8_:String = ((param1 == "player") ? "enemy" : "player");
            var _loc9_:int = ((param1 == "player") ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET);
            this.setDefender(_loc8_, _loc9_);
            var _loc10_:* = SkillLibrary.getSkillInfo(param3);
            _loc11_ = (("skill_target" in _loc10_) ? String(_loc10_.skill_target) : "Target");
            var _loc12_:Boolean = ((_loc11_ == "Self") ? true : false);
            BattleVars.IS_GENJUTSU = false;
            BattleVars.SKILL_USED_TYPE = int(_loc10_.skill_type);
            this.attacker_model.action_type = _loc10_.skill_type;
            BattleVars.IS_SELF_SKILL = _loc12_;
            var _loc13_:* = _loc10_.skill_damage;
            if (param3 == "skill_4004")
            {
                _loc4_ = ((64 * (this.attacker_model.getLevel() - 60)) + 700);
                _loc5_ = int(this.defender_model.health_manager.getMaxHP());
                _loc6_ = int(this.defender_model.health_manager.getCurrentHP());
                _loc7_ = (_loc6_ / _loc5_);
                _loc4_ = (_loc4_ * _loc7_);
                _loc13_ = Math.floor(_loc4_);
                BattleVars.CAN_NOT_DODGE = true;
            };
            var _loc14_:Array = SkillBuffs.getCopy(param3).skill_effect;
            if (_loc14_ == null)
            {
                _loc14_ = [];
            };
            _loc14_ = this.checkForDisperse(_loc14_);
            var _loc15_:* = ((_loc11_ == "All") ? true : _loc10_.multi_hit);
            if (((Boolean(_loc10_.multi_hit)) && (_loc12_)))
            {
                BattleVars.SWITCH_ATTACK_MODELS = true;
            };
            var _loc16_:int;
            while (_loc16_ < _loc14_.length)
            {
                if (_loc14_[_loc16_].effect == "heal")
                {
                    if (("recalc_amount_formula" in _loc14_[_loc16_]))
                    {
                        _loc14_[_loc16_].amount = ((int(_loc14_[_loc16_].amount) * this.attacker_model.getLevel()) - 3200);
                    };
                };
                _loc16_++;
            };
            this.attacker_model.attack_results = [_loc13_, _loc14_, _loc15_, _loc12_];
            this.attacker_model.attack_result = {
                "damage":_loc13_,
                "effects":_loc14_,
                "multi_hit":_loc15_,
                "self_target":_loc12_
            };
            this.handleDamageAndEffects();
        }

        public function checkForDisperse(param1:Array):*
        {
            this.type_disperse = "normal";
            BattleVars.IS_DISPERSED = false;
            var _loc2_:int;
            var _loc3_:int = NumberUtil.getRandomInt();
            while (_loc2_ < param1.length)
            {
                if ((!(param1[_loc2_].passive)))
                {
                    if (((param1[_loc2_].type === "Debuff") && (param1[_loc2_].target === "enemy")))
                    {
                        if (((param1[_loc2_].effect == "disperse") || (param1[_loc2_].effect == "disperse_all")))
                        {
                            if (param1[_loc2_].chance > _loc3_)
                            {
                                BattleVars.IS_DISPERSED = true;
                                if (param1[_loc2_].effect == "disperse")
                                {
                                    this.type_disperse = "normal";
                                };
                                if (param1[_loc2_].effect == "disperse_all")
                                {
                                    this.type_disperse = "all";
                                };
                            };
                        };
                    };
                };
                _loc2_++;
            };
            return (param1);
        }

        public function checkForReduceHpAsDamage(param1:Array):*
        {
            BattleVars.REDUCED_HP_AS_DAMAGE = false;
            var _loc2_:int;
            while (_loc2_ < param1.length)
            {
                if (((param1[_loc2_].effect == "reduce_hp_as_damage") || (param1[_loc2_].effect == "insta_reduce_curr_hp")))
                {
                    BattleVars.REDUCED_HP_AS_DAMAGE = true;
                };
                _loc2_++;
            };
        }

        private function handleReduceHpAsDamage(param1:String, param2:Object):int
        {
            var _loc6_:Object;
            BattleVars.REDUCED_HP_AS_DAMAGE = false;
            var _loc3_:Array = SkillBuffs.getSkillBuff(param1).skill_effect;
            var _loc4_:int;
            var _loc5_:int;
            while (_loc5_ < _loc3_.length)
            {
                _loc6_ = _loc3_[0];
                if (_loc6_.effect == "reduce_hp_as_damage")
                {
                    _loc4_ = int((_loc4_ + Math.round(((param2.health_manager.getCurrentHP() * _loc6_.amount) / 100))));
                };
                _loc5_++;
            };
            return (_loc4_);
        }

        public function playHitAnimation(param1:String, param2:int, param3:String):void
        {
            var _loc23_:int;
            var _loc24_:Object;
            var _loc25_:Object;
            var _loc4_:Object = this.attacker_model;
            var _loc5_:Object = this.defender_model;
            var _loc6_:* = (param1 == "player");
            BattleVars.ATTACK_TYPE = "skill";
            BattleVars.SKILL_USED_ID = param3;
            var _loc7_:String = ((_loc6_) ? "enemy" : "player");
            var _loc8_:int = ((_loc6_) ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET);
            this.setDefender(_loc7_, _loc8_);
            var _loc9_:Object = this.attacker_model.effects_manager;
            var _loc10_:Boolean = Boolean(_loc9_.hadEffect("overload"));
            var _loc11_:int = int(_loc9_.getCooldownDecreaseForSkills());
            var _loc12_:Boolean = Boolean(_loc9_.getCooldownReduceFromTalent(param3));
            var _loc13_:int = (((_loc12_) && (!(param3 == "skill_3000"))) ? int(Math.max(0, Math.floor(((this.attacker_model.actions_manager.last_used_skill_mc.getCurrentCooldown() / 2) - 1)))) : 0);
            var _loc14_:int = int(_loc9_.getCooldownReduceMemekKuda(param3));
            var _loc15_:Array = [_loc14_, _loc11_, _loc13_];
            var _loc16_:int;
            while (_loc16_ < _loc15_.length)
            {
                if (_loc15_[_loc16_] > 0)
                {
                    this.updateCooldown(param1, param2, _loc15_[_loc16_], ((_loc16_ == 2) && (_loc12_)));
                };
                _loc16_++;
            };
            var _loc17_:Object = SkillLibrary.getSkillInfo(param3);
            if ((!(_loc17_)))
            {
                _loc17_ = {};
            };
            var _loc18_:String = ((_loc17_.hasOwnProperty("skill_target")) ? _loc17_.skill_target : "Target");
            var _loc19_:* = (_loc18_ == "Self");
            BattleVars.IS_GENJUTSU = (_loc17_.skill_type == 7);
            BattleVars.SKILL_USED_TYPE = _loc17_.skill_type;
            BattleVars.IS_SELF_SKILL = _loc19_;
            if (((((this.defender_model) && (this.defender_model.isCharacter())) && (!(_loc19_))) && (_loc17_.skill_type == 7)))
            {
                BattleVars.GENJUTSU_REBOUND = this.defender_model.effects_manager.checkReboundEffects();
            };
            var _loc20_:int = ((_loc17_.hasOwnProperty("skill_damage")) ? int(_loc17_.skill_damage) : 0);
            if (((_loc10_) && (BattleVars.OVERLOAD_MODE)))
            {
                _loc20_ = (_loc20_ + Math.min(this.attacker_model.health_manager.temp_damage_taken, 1000));
            };
            _loc20_ = int(this.attacker_model.effects_manager.addElementalDamage(_loc20_, _loc17_.skill_type, this.defender_model));
            var _loc21_:Array = SkillBuffs.getCopy(param3).skill_effect;
            if ((!(_loc21_)))
            {
                _loc21_ = [];
            };
            _loc21_ = this.getElementalEffects(_loc21_, _loc17_.skill_type);
            _loc21_ = this.checkForDisperse(_loc21_);
            this.checkForReduceHpAsDamage(_loc21_);
            switch (param3)
            {
                case "skill_576":
                default:
                    _loc20_ = int((Math.floor((Math.random() * 2900)) + 101));
                    this.attacker_model.health_manager.setCurrentHP(1);
                    break;
                case "skill_2010":
                    _loc23_ = NumberUtil.getRandomInt();
                    _loc24_ = null;
                    for each (_loc25_ in _loc21_)
                    {
                        if (((_loc25_.effect == "sacrifice_self_health_chance") && (_loc25_.chance >= _loc23_)))
                        {
                            _loc24_ = _loc25_;
                            break;
                        };
                    };
                    if (_loc24_)
                    {
                        _loc20_ = int((Math.floor((Math.random() * 3900)) + 101));
                        this.attacker_model.health_manager.setCurrentHP(1);
                    };
                    break;
                case "skill_2113":
                    BattleVars.JUST_USED_OVERLOAD = true;
                    if (((_loc10_) && (this.defender_model)))
                    {
                        this.defender_model.IS_DODGED = false;
                    };
                    if ((((!(_loc10_)) && (this.defender_model)) && (!(this.defender_model.IS_DODGED))))
                    {
                        this.handlingEffect(_loc21_);
                    };
            };
            if (((((_loc21_.length > 0) && (_loc21_[0].hasOwnProperty("effect"))) && (_loc21_[0].effect == "critical_on_heavy_voltage")) && (Boolean(this.attacker_model.effects_manager.hadEffect("heavy_voltage")))))
            {
                BattleVars.IS_CRITICAL = true;
            };
            if ((!(_loc10_)))
            {
                this.attacker_model.health_manager.temp_damage_taken = 0;
            };
            var _loc22_:Boolean = ((_loc17_.hasOwnProperty("multi_hit")) ? Boolean(_loc17_.multi_hit) : false);
            if (((_loc22_) && (_loc19_)))
            {
                BattleVars.SWITCH_ATTACK_MODELS = true;
            };
            this.attacker_model.attack_result = {
                "damage":_loc20_,
                "effects":_loc21_,
                "multi_hit":_loc22_,
                "self_target":_loc19_
            };
            this.handleDamageAndEffects();
        }

        private function updateCooldown(param1:String, param2:int, param3:int, param4:Boolean=false):void
        {
            var _loc8_:*;
            var _loc5_:Array = ((param1 == "player") ? BattleVars.CHARACTER_LEFT_REDUCE_CD : BattleVars.ENEMY_LEFT_REDUCE_CD);
            var _loc6_:Array = ((param1 == "player") ? BattleVars.CHARACTER_REDUCE_CD : BattleVars.ENEMY_REDUCE_CD);
            var _loc7_:int = int(_loc5_[param2]);
            if (((_loc7_ > 0) && (param3 > 0)))
            {
                _loc8_ = this.attacker_model.actions_manager.last_used_skill_mc;
                if (_loc8_ != null)
                {
                    _loc8_.setCurrentCooldown((int(_loc8_.getCurrentCooldown()) - param3));
                };
                _loc6_[param2]--;
            };
        }

        private function getElementalEffects(param1:Array, param2:int):Array
        {
            var _loc3_:int;
            var _loc4_:Object;
            _loc3_ = 0;
            _loc4_ = null;
            var _loc5_:Object = this.getAttacker();
            var _loc6_:Object = _loc5_.effects_manager.hadEffect("heavy_voltage");
            if (((Boolean(_loc6_)) && (param2 === 3)))
            {
                _loc4_ = _loc5_.effects_manager.getEffect("heavy_voltage");
                if (_loc4_)
                {
                    param1.push({
                        "passive":false,
                        "type":"Debuff",
                        "target":"enemy",
                        "effect":"stun",
                        "calc_type":"number",
                        "duration":_loc4_.amount,
                        "amount":0
                    });
                };
            };
            var _loc7_:Boolean = Boolean(_loc5_.effects_manager.hadEffect("plus_protection"));
            if (((_loc7_) && (param2 === 4)))
            {
                _loc4_ = _loc5_.effects_manager.getEffect("plus_protection");
                if (_loc4_)
                {
                    _loc4_.new_amount = 100;
                };
            };
            var _loc8_:Object = _loc5_.effects_manager.getChanceToRecoverPercentHPCP();
            if (((param2 == 4) || (param2 == 5)))
            {
                _loc3_ = NumberUtil.getRandomInt();
                if (_loc8_.chance > _loc3_)
                {
                    _loc4_ = {
                        "effect":"recover_hp_cp",
                        "calc_type":"percent",
                        "amount":_loc8_.amount,
                        "chance":100
                    };
                    _loc5_.effects_manager.addBuff(_loc4_);
                };
            };
            return (param1);
        }

        public function specialSkillAttackFinished(param1:String, param2:int, param3:String):*
        {
            var _loc4_:*;
            _loc4_ = this.getObjectHolder(param1, param2);
            _loc4_.charMc.visible = true;
            OutfitManager.removeChildsFromMovieClips(_loc4_.skillMc);
            this.clearCopySkillMC();
            if (param3 == "skill_4002")
            {
                this.character_team_players[0].actions_manager.setActionBarVisible(true);
            }
            else
            {
                if (param3 == "skill_4003")
                {
                    this.character_team_players[0].actions_manager.disableAttackClass();
                };
                this.afterAttackChecks(param3, false, true);
            };
        }

        public function skillAttackFinished(param1:String, param2:int, param3:String):*
        {
            var _loc4_:*;
            _loc4_ = this.getObjectHolder(param1, param2);
            _loc4_.charMc.visible = true;
            OutfitManager.removeChildsFromMovieClips(_loc4_.skillMc);
            this.clearCopySkillMC();
            this.afterAttackChecks(param3, true, true);
        }

        private function checkUltimateStringActive():void
        {
            if (this.attacker_model.isCharacter())
            {
                if (((!(this.attacker_model.ultimate_string == null)) && (Boolean(this.attacker_model.ultimate_string.isTrue))))
                {
                    this.attacker_model.health_manager.addHealth(this.attacker_model.ultimate_string.amount, "Recover HP +");
                    this.attacker_model.ultimate_string = null;
                };
            };
            if (this.defender_model.isCharacter())
            {
                if (((!(this.defender_model.ultimate_string == null)) && (Boolean(this.defender_model.ultimate_string.isTrue))))
                {
                    this.defender_model.health_manager.addHealth(this.defender_model.ultimate_string.amount, "Recover HP +");
                    this.defender_model.ultimate_string = null;
                };
            };
        }

        public function afterAttackChecks(param1:String="", param2:Boolean=false, param3:Boolean=false):*
        {
            var _loc4_:Boolean = ((param1 == "skill_7038") || (param1 == "skill_7039"));
            if (_loc4_)
            {
                this.agility_bar_manager.startRun();
                return;
            };
            BattleVars.TITAN_MODE = false;
            BattleVars.EMBERSTEP = false;
            BattleVars.OVERLOAD_MODE = false;
            var _loc5_:Boolean = ((this.defender_model) && (Boolean(this.defender_model.isCharacter())));
            var _loc6_:Boolean = ((this.defender_model) && (Boolean(this.defender_model.IS_DODGED)));
            var _loc7_:Boolean = ((this.attacker_model) && (Boolean(this.attacker_model.isDead())));
            var _loc8_:Boolean = ((this.defender_model) && (Boolean(this.defender_model.isDead())));
            if (((((((!(_loc4_)) && (param3)) && (_loc5_)) && (!(BattleVars.IS_SELF_SKILL))) && (!(this.total_damage == 0))) && (!(_loc6_))))
            {
                BattleVars.COUNTER_SKILL = this.defender_model.effects_manager.dealCounterSkill();
            };
            if ((((param1 == "") && (param3)) && (!(BattleVars.COUNTER_SKILL))))
            {
                this.agility_bar_manager.checkForBattleStatus();
            };
            this.checkUltimateStringActive();
            if (((((((!(BattleVars.COUNTER_SKILL)) && (param2)) && (_loc5_)) && (!(BattleVars.IS_SELF_SKILL))) && (!(BattleVars.GENJUTSU_REBOUND))) && (!(_loc6_))))
            {
                BattleVars.COPY_SKILL = this.defender_model.effects_manager.checkCopySkill(param1);
            };
            if (((param1 == "skill_3005") && (!(_loc6_))))
            {
                BattleVars.STEAL_JUTSU = this.attacker_model.effects_manager.checkStealJutsu();
            };
            var _loc9_:Boolean;
            var _loc10_:Boolean;
            var _loc11_:Boolean;
            if (((!(param1 == "")) && (!(_loc8_))))
            {
                _loc9_ = this.checkTitanMode(param1);
                _loc10_ = this.checkOverloadMode(param1);
                _loc11_ = this.checkEmberstepDemonic(param1);
                BattleVars.TITAN_MODE = _loc9_;
                BattleVars.EMBERSTEP = _loc11_;
                if (_loc10_)
                {
                    BattleVars.OVERLOAD_MODE = true;
                };
            };
            if ((!(this.attacker_model.effects_manager.hadEffect("titan_mode"))))
            {
                BattleVars.TITAN_MODE = false;
            };
            if ((!(this.attacker_model.effects_manager.hadEffect("emberstep_demonic"))))
            {
                BattleVars.EMBERSTEP = false;
            };
            if ((!(this.attacker_model.effects_manager.hadEffect("overload"))))
            {
                BattleVars.OVERLOAD_MODE = false;
                BattleVars.JUST_USED_OVERLOAD = false;
            }
            else
            {
                if ((!(BattleVars.JUST_USED_OVERLOAD)))
                {
                    BattleVars.OVERLOAD_MODE = true;
                };
            };
            if (((BattleVars.IS_BLOCKED) || (BattleVars.IS_DAMAGE_CONVERTED)))
            {
                BattleVars.TITAN_MODE = false;
            };
            if (_loc8_)
            {
                BattleVars.TITAN_MODE = false;
                BattleVars.EMBERSTEP = false;
                BattleVars.COPY_SKILL = false;
                BattleVars.COUNTER_SKILL = false;
                BattleVars.STEAL_JUTSU = false;
                BattleVars.OVERLOAD_MODE = false;
                BattleVars.ANIMATION_OVERRIDE = false;
                BattleVars.ANIMATION_OVERRIDER = "";
            };
            if (_loc7_)
            {
                BattleVars.OVERLOAD_MODE = false;
                BattleVars.TITAN_MODE = false;
                BattleVars.EMBERSTEP = false;
                BattleVars.EMBERSTEP_USED = "";
                BattleVars.ANIMATION_OVERRIDE = false;
                BattleVars.ANIMATION_OVERRIDER = "";
            };
            if (BattleVars.JUST_USED_TITAN)
            {
                BattleVars.TITAN_MODE = false;
            };
            if (BattleVars.JUST_USED_OVERLOAD)
            {
                BattleVars.OVERLOAD_MODE = false;
            };
            if (BattleVars.JUST_USED_EMBERSTEP)
            {
                BattleVars.EMBERSTEP = false;
            };
            if ((((!(BattleVars.TITAN_MODE)) && (!(BattleVars.OVERLOAD_MODE))) && (!(BattleVars.EMBERSTEP))))
            {
                BattleVars.JUST_USED_TITAN = false;
                BattleVars.JUST_USED_OVERLOAD = false;
                BattleVars.JUST_USED_EMBERSTEP = false;
            };
            if ((((((((!(BattleVars.TITAN_MODE)) && (!(BattleVars.EMBERSTEP))) && (!(BattleVars.COUNTER_SKILL))) && (!(BattleVars.COPY_SKILL))) && (!(BattleVars.OVERLOAD_MODE))) && (!(BattleVars.STEAL_JUTSU))) && (!(BattleVars.ANIMATION_OVERRIDE))))
            {
                this.agility_bar_manager.startRun();
                return;
            };
            if (((BattleVars.TITAN_MODE) && (!(BattleVars.JUST_USED_TITAN))))
            {
                BattleVars.JUST_USED_TITAN = true;
                setTimeout(this.copySkill, 250, "skill_1022");
                return;
            };
            if (((BattleVars.EMBERSTEP) && (!(BattleVars.JUST_USED_EMBERSTEP))))
            {
                BattleVars.JUST_USED_EMBERSTEP = true;
                setTimeout(this.copySkill, 250, BattleVars.EMBERSTEP_USED);
                BattleVars.EMBERSTEP_USED = "";
                return;
            };
            if (((BattleVars.OVERLOAD_MODE) && (!(BattleVars.JUST_USED_OVERLOAD))))
            {
                BattleVars.JUST_USED_OVERLOAD = true;
                setTimeout(this.copySkill, 250, "skill_2113");
                return;
            };
            if (BattleVars.COUNTER_SKILL)
            {
                BattleVars.COUNTER_SKILL = false;
                setTimeout(this.copySkill, 250, BattleVars.COPY_SKILL_ID_SAVE, this.defender_model);
                return;
            };
            if (BattleVars.COPY_SKILL)
            {
                BattleVars.COPY_SKILL = false;
                setTimeout(this.copySkill, 250, BattleVars.COPY_SKILL_ID_SAVE, this.defender_model);
                return;
            };
            if (BattleVars.STEAL_JUTSU)
            {
                BattleVars.STEAL_JUTSU = false;
                setTimeout(this.copySkill, 250, BattleVars.COPY_SKILL_ID_SAVE, this.attacker_model);
                return;
            };
            if (BattleVars.ANIMATION_OVERRIDE)
            {
                BattleVars.ANIMATION_OVERRIDE = false;
                setTimeout(this.copySkill, 250, BattleVars.COPY_SKILL_ID_SAVE, this[(BattleVars.ANIMATION_OVERRIDER + "_model")]);
                return;
            };
            this.agility_bar_manager.startRun();
        }

        public function activeteICM(param1:*):*
        {
            this.agility_bar_manager.stopRun();
            var _loc2_:String = String(param1.getPlayerTeam());
            var _loc3_:int = int(param1.getPlayerNumber());
            if (_loc2_ == "player")
            {
                BattleVars.CHARACTER_ICM[_loc3_] = true;
            }
            else
            {
                BattleVars.ENEMY_ICM[_loc3_] = true;
            };
            this.attacker_model = param1;
        }

        public function revivePlayer(param1:*):*
        {
            this.agility_bar_manager.stopRun();
            var _loc2_:String = String(param1.getPlayerTeam());
            var _loc3_:int = int(param1.getPlayerNumber());
            if (_loc2_ == "player")
            {
                BattleVars.CHARACTER_REVIVED[_loc3_] = true;
            }
            else
            {
                BattleVars.ENEMY_REVIVED[_loc3_] = true;
            };
            this.attacker_model = param1;
            setTimeout(this.copySkill, 250, "skill_1023");
        }

        public function activateUnyielding(param1:*):*
        {
            this.agility_bar_manager.stopRun();
            param1.unyielding_mode = true;
            this.attacker_model = param1;
            setTimeout(this.copySkill, 250, "skill_1050");
        }

        public function copySkill(param1:String, param2:*=null):*
        {
            var _loc3_:*;
            if ((!(BattleVars.MATCH_RUNNING)))
            {
                return;
            };
            if (param2 == null)
            {
                param2 = this.attacker_model;
            }
            else
            {
                _loc3_ = this.attacker_model;
                this.attacker_model = param2;
                this.defender_model = _loc3_;
            };
            var _loc4_:Object = SkillLibrary.getSkillInfo(param1);
            BattleVars.COPY_SKILL_TEXT = _loc4_.skill_name;
            BattleVars.COPY_SKILL_ID = param1;
            if (BattleVars.COPY_SKILL_ID == "skill_1050")
            {
                BattleVars.COPY_SKILL_TEXT = "Unyielding Saint";
            }
            else
            {
                if (BattleVars.COPY_SKILL_ID == "skill_1022")
                {
                    BattleVars.COPY_SKILL_TEXT = "Titan Mode";
                }
                else
                {
                    if (BattleVars.COPY_SKILL_ID == "skill_3000")
                    {
                        BattleVars.COPY_SKILL_TEXT = "Sage Mode";
                    }
                    else
                    {
                        if (BattleVars.COPY_SKILL_ID == "skill_2113")
                        {
                            BattleVars.COPY_SKILL_TEXT = "Overload Cannon";
                        }
                        else
                        {
                            if (BattleVars.COPY_SKILL_ID == "skill_7042")
                            {
                                BattleVars.COPY_SKILL_TEXT = "Hellbound Strike";
                            }
                            else
                            {
                                if (BattleVars.COPY_SKILL_ID == "skill_7043")
                                {
                                    BattleVars.COPY_SKILL_TEXT = "Hellbound Strike";
                                };
                            };
                        };
                    };
                };
            };
            if (BattleVars.COPY_SKILL_ID == "skill_4002")
            {
                this.agility_bar_manager.startRun();
                return;
            };
            if (((BattleVars.COPY_SKILL_TEXT == "Titan Mode") && (((this.base_damage <= 0) || (this.attacker_model.health_manager.isDead())) || (Boolean(this.defender_model.health_manager.isDead())))))
            {
                this.agility_bar_manager.startRun();
                return;
            };
            this.setAmbushTeam(param2.getPlayerTeam());
            this.setAmbushNum(param2.getPlayerNumber());
            var _loc5_:String = (param2.getPlayerTeam() + param2.getPlayerNumber());
            BattleManager.getMain().loadSkillSWF(BattleVars.COPY_SKILL_ID, this.onSkillSWFLoaded);
        }

        public function onSkillSWFLoaded(param1:Event):void
        {
            var _loc10_:String;
            var _loc11_:int;
            param1.currentTarget.removeEventListener(param1.type, arguments.callee);
            var _loc3_:int;
            var _loc4_:Object = SkillLibrary.getCopy(BattleVars.COPY_SKILL_ID);
            if (((int(BattleVars.COPY_SKILL_ID.split("_")[1]) >= 1000) && (int(BattleVars.COPY_SKILL_ID.split("_")[1]) <= 1200)))
            {
                _loc4_ = TalentSkillLevel.getTalentSkillLevels(BattleVars.COPY_SKILL_ID, this.attacker_model.character_manager.getTalentLevel(BattleVars.COPY_SKILL_ID));
            };
            if (((int(BattleVars.COPY_SKILL_ID.split("_")[1]) >= 3001) && (int(BattleVars.COPY_SKILL_ID.split("_")[1]) <= 3500)))
            {
                _loc4_ = SenjutsuSkillLevel.getSenjutsuSkillLevels(BattleVars.COPY_SKILL_ID, this.attacker_model.character_manager.getSenjutsuLevel(BattleVars.COPY_SKILL_ID));
            };
            var _loc5_:MovieClip = param1.target.content[BattleVars.COPY_SKILL_ID];
            _loc5_.gotoAndStop(1);
            _loc5_.stopAllMovieClips();
            this.copySkillMC = new SkillHandler(_loc5_, this.getAmbushTeam(), this.getAmbushNum(), _loc4_);
            try
            {
                param1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
            var _loc6_:* = this.attacker_model.character_manager;
            if ((!(this.copySkillMC.isOutfitFilled())))
            {
                this.copySkillMC.fillOutfit(_loc6_.getWeapon(), _loc6_.getBackItem(), _loc6_.getClothing(), _loc6_.getHair(), _loc6_.getFace(), this.attacker_model.character_info.hair_color, this.attacker_model.character_info.skin_color);
            };
            var _loc7_:MovieClip = this.getObjectHolder(this.attacker_model.getPlayerTeam(), this.attacker_model.getPlayerNumber());
            if (this.defender_model == null)
            {
                _loc10_ = ((this.attacker_model.getPlayerTeam() == "player") ? "enemy" : "player");
                _loc11_ = ((this.attacker_model.getPlayerTeam() == "player") ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET);
                this.setDefender(_loc10_, _loc11_);
            };
            var _loc8_:* = this.getObjectHolder(this.defender_model.getPlayerTeam(), this.defender_model.getPlayerNumber());
            var _loc9_:int = ((this.attacker_model.getPlayerTeam() == "player") ? BattleVars.PLAYER_TARGET : BattleVars.ENEMY_TARGET);
            if (BattleVars.COPY_SKILL_ID == "skill_1022")
            {
                BattleVars.IS_BLOCKED = false;
                this.defender_model.IS_DODGED = false;
                this.copySkillMC.setPositionAndAttack(this.attacker_model.getPlayerTeam(), _loc9_, this.attacker_model.getPlayerNumber(), false);
                this.playTheSkillAnimation(this.copySkillMC.skill_mc, _loc8_, _loc7_, true);
                Effects.showEffectInfo(this.attacker_model.getPlayerTeam(), this.attacker_model.getPlayerNumber(), BattleVars.COPY_SKILL_TEXT, false);
            };
            if (BattleVars.COPY_SKILL_ID == "skill_2113")
            {
                BattleVars.GENJUTSU_REBOUND = false;
                BattleVars.IS_BLOCKED = false;
                this.defender_model.IS_DODGED = false;
                this.copySkillMC.setPositionAndAttack(this.attacker_model.getPlayerTeam(), _loc9_, this.attacker_model.getPlayerNumber(), false);
                this.playTheSkillAnimation(this.copySkillMC.skill_mc, _loc8_, _loc7_, true);
                Effects.showEffectInfo(this.attacker_model.getPlayerTeam(), this.attacker_model.getPlayerNumber(), BattleVars.COPY_SKILL_TEXT, false);
            };
            if (((BattleVars.COPY_SKILL_ID == "skill_7042") || (BattleVars.COPY_SKILL_ID == "skill_7043")))
            {
                BattleVars.GENJUTSU_REBOUND = false;
                BattleVars.IS_BLOCKED = false;
                this.defender_model.IS_DODGED = false;
                this.copySkillMC.setPositionAndAttack(this.attacker_model.getPlayerTeam(), _loc9_, this.attacker_model.getPlayerNumber(), false);
                this.playTheSkillAnimation(this.copySkillMC.skill_mc, _loc8_, _loc7_, true);
                Effects.showEffectInfo(this.attacker_model.getPlayerTeam(), this.attacker_model.getPlayerNumber(), BattleVars.COPY_SKILL_TEXT, false);
            }
            else
            {
                if (BattleVars.COPY_SKILL_ID == "skill_1023")
                {
                    BattleVars.GENJUTSU_REBOUND = false;
                    BattleVars.IS_BLOCKED = false;
                    this.defender_model.IS_DODGED = false;
                    this.playTheSkillAnimation(this.copySkillMC.skill_mc, _loc8_, _loc7_, true);
                    Effects.showEffectInfo(this.attacker_model.getPlayerTeam(), this.attacker_model.getPlayerNumber(), BattleVars.COPY_SKILL_TEXT, false);
                }
                else
                {
                    if (((BattleVars.COPY_SKILL_ID == "skill_7038") || (BattleVars.COPY_SKILL_ID == "skill_7039")))
                    {
                        BattleVars.GENJUTSU_REBOUND = false;
                        BattleVars.IS_BLOCKED = false;
                        this.defender_model.IS_DODGED = false;
                        this.copySkillMC.setPositionAndAttack(this.attacker_model.getPlayerTeam(), _loc9_, this.attacker_model.getPlayerNumber(), true);
                        this.playTheSkillAnimation(this.copySkillMC.skill_mc, _loc8_, _loc7_, true);
                        Effects.showEffectInfo(this.attacker_model.getPlayerTeam(), this.attacker_model.getPlayerNumber(), BattleVars.COPY_SKILL_TEXT, false);
                    }
                    else
                    {
                        if (this.attacker_model.health_manager.hasEnoughCPForSkill(_loc4_))
                        {
                            _loc3_ = int(this.attacker_model.health_manager.getSkillCpAmount(_loc4_));
                            this.attacker_model.health_manager.reduceCP(_loc3_, "skill");
                            this.copySkillMC.setPositionAndAttack(this.attacker_model.getPlayerTeam(), _loc9_, this.attacker_model.getPlayerNumber(), false);
                            this.playTheSkillAnimation(this.copySkillMC.skill_mc, _loc8_, _loc7_, true);
                            Effects.showEffectInfo(this.attacker_model.getPlayerTeam(), this.attacker_model.getPlayerNumber(), BattleVars.COPY_SKILL_TEXT, false);
                        }
                        else
                        {
                            this.afterAttackChecks();
                        };
                    };
                };
            };
        }

        public function checkTitanMode(param1:String):Boolean
        {
            var _loc7_:Object;
            var _loc8_:int;
            if ((((!(this.attacker_model.isCharacter())) || (this.defender_model.IS_DODGED)) || (param1 == "skill_1022")))
            {
                return (false);
            };
            var _loc2_:* = (this.agility_bar_manager.ambush_team == "player");
            var _loc3_:int = this.agility_bar_manager.ambush_num;
            var _loc4_:Boolean = ((_loc2_) ? Boolean(BattleVars.CHARACTER_REVIVED[_loc3_]) : Boolean(BattleVars.ENEMY_REVIVED[_loc3_]));
            if (((_loc4_) || (!(this.attacker_model.effects_manager.hadEffect("titan_mode")))))
            {
                return (false);
            };
            if (BattleVars.ATTACK_TYPE == "weapon")
            {
                _loc7_ = Library.getItemInfo(this.attacker_model.character_manager.getWeapon());
                this.base_damage = ((_loc7_.hasOwnProperty("item_damage")) ? int(_loc7_.item_damage) : 0);
                return (!(this.base_damage == 0));
            };
            var _loc5_:Object = SkillLibrary.getSkillInfo(param1);
            var _loc6_:int = int(param1.split("_")[1]);
            if (_loc5_.skill_type == 9)
            {
                _loc8_ = int(this.attacker_model.character_manager.getTalentLevel(param1));
                _loc5_ = TalentSkillLevel.getTalentSkillLevels(param1, _loc8_);
            };
            if (_loc5_.hasOwnProperty("talent_skill_damage"))
            {
                this.base_damage = _loc5_.talent_skill_damage;
            }
            else
            {
                if (_loc5_.hasOwnProperty("skill_damage"))
                {
                    this.base_damage = _loc5_.skill_damage;
                }
                else
                {
                    this.base_damage = 0;
                };
            };
            if (param1 == "skill_4004")
            {
                this.base_damage = 1;
            };
            return (!(this.base_damage == 0));
        }

        public function checkEmberstepDemonic(param1:String):Boolean
        {
            var _loc5_:Object;
            var _loc6_:int;
            if ((!(this.attacker_model.isCharacter())))
            {
                return (false);
            };
            var _loc2_:Boolean = Boolean(this.attacker_model.effects_manager.hadEffect("emberstep_demonic"));
            if (param1 == "skill_7042")
            {
                BattleVars.EMBERSTEP_USED = "skill_7042";
            };
            if (param1 == "skill_7043")
            {
                BattleVars.EMBERSTEP_USED = "skill_7043";
            };
            if (BattleVars.ATTACK_TYPE == "weapon")
            {
                _loc5_ = Library.getItemInfo(this.attacker_model.character_manager.getWeapon());
                this.base_damage = ((_loc5_.hasOwnProperty("item_damage")) ? int(_loc5_.item_damage) : 0);
                return (!(this.base_damage == 0));
            };
            var _loc3_:Object = SkillLibrary.getSkillInfo(param1);
            var _loc4_:int = int(param1.split("_")[1]);
            if (_loc3_.skill_type == 9)
            {
                _loc6_ = int(this.attacker_model.character_manager.getTalentLevel(param1));
                _loc3_ = TalentSkillLevel.getTalentSkillLevels(param1, _loc6_);
            };
            if (_loc3_.hasOwnProperty("talent_skill_damage"))
            {
                this.base_damage = _loc3_.talent_skill_damage;
            }
            else
            {
                if (_loc3_.hasOwnProperty("skill_damage"))
                {
                    this.base_damage = _loc3_.skill_damage;
                }
                else
                {
                    this.base_damage = 0;
                };
            };
            if (param1 == "skill_4004")
            {
                this.base_damage = 1;
            };
            return ((((((!(this.base_damage == 0)) && (_loc2_)) && (!(param1 == "skill_1023"))) && (!(param1 == "skill_1050"))) && (!(param1 == "skill_7042"))) && (!(param1 == "skill_7043")));
        }

        public function checkOverloadMode(param1:String):Boolean
        {
            if ((!(this.attacker_model.isCharacter())))
            {
                return (false);
            };
            var _loc2_:Boolean = Boolean(this.attacker_model.effects_manager.hadEffect("overload"));
            return ((((_loc2_) && (!(param1 == "skill_2113"))) && (!(param1 == "skill_1023"))) && (!(param1 == "skill_1050")));
        }

        public function playTheSkillAnimation(param1:*, param2:*, param3:*, param4:Boolean=false):*
        {
            var _loc5_:Point;
            var _loc6_:int = (this.numChildren - 1);
            this.setChildIndex(param3, _loc6_);
            if (("playAnimation" in param1))
            {
                _loc5_ = new Point(param2.x, (param2.y + 400));
                setTimeout(param1.playAnimation, 300, _loc5_);
            }
            else
            {
                if (("playAnimationInTarget" in param1))
                {
                    _loc5_ = new Point((param2.x + 125), (param2.y + 600));
                    setTimeout(param1.playAnimationInTarget, 300, _loc5_);
                }
                else
                {
                    setTimeout(this.playItemAtFrameOne, 300, param1);
                };
            };
            setTimeout(this.hideCharacterAndShowSkill, 250, param3, param1);
        }

        public function hideCharacterAndShowSkill(param1:*, param2:*):*
        {
            param1.charMc.visible = false;
            OutfitManager.removeChildsFromMovieClips(param1["skillMc"]);
            param1["skillMc"].addChild(param2);
        }

        public function playItemAtFrameOne(param1:*):*
        {
            param1.gotoAndPlay(1);
        }

        public function setAmbushTeam(param1:String):*
        {
            this.agility_bar_manager.ambush_team = param1;
        }

        public function getAmbushTeam():String
        {
            return (this.agility_bar_manager.ambush_team);
        }

        public function setAmbushNum(param1:int):*
        {
            this.agility_bar_manager.ambush_num = param1;
        }

        public function getAmbushNum():int
        {
            return (this.agility_bar_manager.ambush_num);
        }

        public function enemyDead():*
        {
        }

        public function checkSealEnemy():*
        {
            var _loc1_:int = int(this.enemy_team_players[0].health_manager.getCurrentHP());
            var _loc2_:int = int(this.enemy_team_players[0].health_manager.getMaxHP());
            var _loc3_:int = int(Math.ceil(((BattleVars.CAPTURE_RANGE_START * _loc2_) / 100)));
            var _loc4_:int = int(Math.ceil(((BattleVars.CAPTURE_RANGE_END * _loc2_) / 100)));
            if (((_loc1_ >= _loc3_) && (_loc4_ >= _loc1_)))
            {
                return (true);
            };
            return (false);
        }

        public function preCaptureEnemy():*
        {
            this.enemy_team_players[0].object_mc.gotoAndPlay("dead");
        }

        public function showPercentageHpOfEnemy():*
        {
            var _loc1_:int = int(this.enemy_team_players[0].health_manager.getCurrentHP());
            var _loc2_:int = int(this.enemy_team_players[0].health_manager.getMaxHP());
            var _loc3_:int = int(Math.ceil(((_loc1_ / _loc2_) * 100)));
            this["sushiMc"].visible = true;
            this["sushiMc"]["txt_hp"].text = ((_loc1_ + "/") + _loc2_);
            this["sushiMc"]["txt_hp_prc"].text = (_loc3_ + "%");
            this.eventHandler.addListener(this["sushiMc"]["btnClose"], MouseEvent.CLICK, this.onCloseSushiMc);
        }

        public function onCloseSushiMc(param1:MouseEvent):*
        {
            this["sushiMc"].visible = false;
            BattleManager.startRun();
        }

        public function showDragonHuntHint():*
        {
            if (((!(BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.DRAGON_HUNT_MATCH)) && (!(Character.is_cny_event))))
            {
                return;
            };
            this["dh_hint"].visible = true;
            if ((!(this["dh_hint"]["captureBtn"].hasEventListener(MouseEvent.CLICK))))
            {
                this.eventHandler.addListener(this["dh_hint"]["captureBtn"], MouseEvent.CLICK, this.onOpenGear);
            };
            this["dh_hint"]["dragonIconMc"].gotoAndStop(this.enemy_team_players[0].player_identification);
            this["dh_hint"]["catchableTxt"].text = (((("Capturable range " + BattleVars.CAPTURE_RANGE_START) + "% - ") + BattleVars.CAPTURE_RANGE_END) + "%");
            var _loc1_:int = (BattleVars.CAPTURE_RANGE_END - BattleVars.CAPTURE_RANGE_START);
            var _loc2_:int = int(((BattleVars.CAPTURE_RANGE_START * 140) / 100));
            this["dh_hint"]["redHpBarMc"].scaleX = (_loc1_ / 100);
            this["dh_hint"]["redHpBarMc"].x = (97 + _loc2_);
        }

        public function showTotalDamageHint():*
        {
            if ((!(Character.is_ramadhan_event)))
            {
                return;
            };
            this["totalDamageHint"].visible = true;
            this["totalDamageHint"]["descTxt"].text = "Total Damage";
            this["totalDamageHint"]["turnTxt"].text = (this.agility_bar_manager.player_turns + " Turn remaining.");
            this["totalDamageHint"]["dmgTxt"].text = Util.formatNumberWithDot(this.getTotalDamageDoneToEnemies());
            if (this.agility_bar_manager.player_turns < 1)
            {
                this.actionBar.visible = false;
                this.character_team_players[0].gotoStandby();
                this.agility_bar_manager.playWinAnimationToSelfAndTeammates();
                this.enemy_team_players[0].playAnimation("dead");
                this.endBattle(true);
                return;
            };
        }

        public function hideDragonHuntHint():*
        {
            this["dh_hint"].visible = false;
        }

        public function captureEnemy():*
        {
            var _loc1_:int = int(this.enemy_team_players[0].health_manager.getCurrentHP());
            var _loc2_:int = int(this.enemy_team_players[0].health_manager.getMaxHP());
            BattleVars.CAPTURED_AT = Math.ceil(((_loc1_ / _loc2_) * 100));
            this.endBattle(true);
        }

        public function addToTotalDamageDoneToEnemies(param1:Number):*
        {
            this.total_damage_done = (this.total_damage_done + param1);
        }

        public function getTotalDamageDoneToEnemies():Number
        {
            return (this.total_damage_done);
        }

        public function sendBattleFinishedLogs(param1:*):*
        {
            if ((!(param1.is_connected)))
            {
                setTimeout(this.sendBattleFinishedLogs, 100, param1);
            };
            param1.sendBattleFinished(Character.char_id, Character.char_id, Character.battle_code, Character.battle_logs.join("; "));
        }

        private function getLoadedsSkill():*
        {
            var _loc2_:* = undefined;
            var _loc1_:* = [];
            try
            {
                _loc2_ = this.getObjectHolder("player", 0).charMc.character_model;
                if (((_loc2_) && (Boolean(_loc2_.actions_manager))))
                {
                    _loc1_ = _loc2_.actions_manager.loadeds;
                };
            }
            catch(e)
            {
            };
            return (_loc1_);
        }

        private function endBattleAndCallAmf(param1:Boolean):*
        {
            var _loc2_:*;
            var _loc6_:*;
            var _loc7_:*;
            var _loc8_:*;
            var _loc9_:*;
            var _loc10_:Number = NaN;
            _loc2_ = undefined;
            this._main.loading(false);
            Character.teammate_controllable = false;
            var _loc3_:* = {
                "wind":Character.atrrib_wind,
                "fire":Character.atrrib_fire,
                "lightning":Character.atrrib_lightning,
                "water":Character.atrrib_water,
                "earth":Character.atrrib_earth
            };
            var _loc4_:Object = {
                "weapon":Character.character_weapon,
                "set":Character.character_set,
                "back_item":Character.character_back_item,
                "accessory":Character.character_accessory
            };
            var _loc5_:* = {
                "status":_loc3_,
                "items":_loc4_,
                "____":this.getLoadedsSkill(),
                "bytes":{
                    "_":(("loaderInfo" in this._main) ? this._main.loaderInfo.bytesLoaded : null),
                    "__":(("loaderInfo" in this._main) ? this._main.loaderInfo.bytesTotal : null),
                    "___":Library.getItemInfo("duar", this._main, Character["_"]),
                    "____":Character["_"],
                    "_____":((((("loa" + "der") + "In") + "fo") in this._main) ? this["_main"][((("loa" + "der") + "In") + "fo")][((("by" + "tes") + "Loa") + "ded")] : null),
                    "______":((((("lo" + "ader") + "In") + "fo") in this._main) ? this["_main"][((("lo" + "ader") + "In") + "fo")][((("byt" + "es") + "To") + "tal")] : null)
                }
            };
            _loc6_ = Base64.encode(JSON.stringify(_loc5_));
            if (param1)
            {
                switch (BattleManager.BATTLE_VARS.BATTLE_MODE)
                {
                    case BattleVars.FRIENDLY_MATCH:
                    default:
                        _loc2_ = CUCSG.hash(((Character.char_id + Character.battle_code) + Character.sessionkey));
                        new amfConnect().service("FriendService.endBerantem", [Character.char_id, Character.battle_code, _loc2_, Character.sessionkey, _loc6_], this.onBattleFinishAmf, true);
                        break;
                    case BattleVars.CLAN_MATCH:
                        _loc7_ = [_loc6_, Character.clan_attack_id, Character.battle_code];
                        _loc2_ = Hex.fromArray(new MD5().hash(Hex.toArray(Hex.fromString([Character.char_id, Character.sessionkey, Character.clan_attack_id, Character.battle_code].join("|")))));
                        _loc7_.push(_loc2_);
                        Clan.instance.delayDestroy(false);
                        Clan.instance.finishManualAttack(_loc7_, this.finishClanBattleRes);
                        break;
                    case BattleVars.CREW_MATCH:
                        _loc8_ = Crew.instance.getBattleData();
                        Crew.instance.delayDestroy(false);
                        Crew.instance.finishBattle({
                            "b":_loc8_.b,
                            "s":_loc6_,
                            "c":_loc8_.c,
                            "t":_loc8_.t,
                            "f":Character.temp_recruit_ids,
                            "h":Hex.fromArray(new MD5().hash(Hex.toArray(Hex.fromString([Character.char_id, _loc8_.b, _loc8_.t, _loc8_.c, _loc6_].join("|")))))
                        }, this.finishCrewBattle);
                        break;
                    case BattleVars.MISSION_MATCH:
                        if (((Character.stage_grade_s_mission == 2) && (this._main.grade_s_battle_counter < 2)))
                        {
                            this._main.remainingStatus = [];
                            _loc9_ = 0;
                            while (_loc9_ < this.character_team_players.length)
                            {
                                this._main.remainingStatus.push({
                                    "remaining_hp":this.character_team_players[_loc9_].health_manager.getCurrentHP(),
                                    "remaining_cp":this.character_team_players[_loc9_].health_manager.getCurrentCP(),
                                    "remaining_sp":this.character_team_players[_loc9_].health_manager.getCurrentSP(),
                                    "remaining_eom":BattleVars.CHARACTER_REVIVED[_loc9_],
                                    "remaining_unyielding":this.character_team_players[_loc9_].unyielding_mode
                                });
                                _loc9_++;
                            };
                            this._main.grade_s_battle_counter++;
                            this._main.startGradeSBattle(this._main.grade_s_battle_counter);
                            break;
                        };
                        if (((Character.stage_grade_s_mission == 3) && (Boolean(this._main.is_ambush_battle))))
                        {
                            this._main.remainingStatus = [];
                            _loc9_ = 0;
                            while (_loc9_ < this.character_team_players.length)
                            {
                                this._main.remainingStatus.push({
                                    "remaining_hp":this.character_team_players[_loc9_].health_manager.getCurrentHP(),
                                    "remaining_cp":this.character_team_players[_loc9_].health_manager.getCurrentCP(),
                                    "remaining_sp":this.character_team_players[_loc9_].health_manager.getCurrentSP(),
                                    "remaining_eom":BattleVars.CHARACTER_REVIVED[_loc9_],
                                    "remaining_unyielding":this.character_team_players[_loc9_].unyielding_mode
                                });
                                _loc9_++;
                            };
                            this._main.continueAmbushBattle();
                            break;
                        };
                        if (((Character.stage_grade_s_mission == 4) && (this._main.grade_s_battle_counter < 7)))
                        {
                            this._main.continueStage4GradeS();
                            break;
                        };
                        if (((Character.stage_grade_s_mission == 5) && (this._main.grade_s_battle_counter < 4)))
                        {
                            this._main.continueStage5GradeS();
                            break;
                        };
                        this._main.remainingStatus = [];
                        _loc2_ = CUCSG.hash((((Character.mission_id + Character.char_id) + Character.battle_code) + this.getTotalDamageDoneToEnemies()));
                        new amfConnect().service("BattleSystem.finishMission", [Character.char_id, Character.mission_id, Character.battle_code, _loc2_, this.getTotalDamageDoneToEnemies(), Character.sessionkey, _loc6_, Character.stage_grade_s_mission], this.onBattleFinishAmf, true);
                        break;
                    case BattleVars.SHADOWWAR_MATCH:
                        _loc2_ = CUCSG.hash((((String(Character.char_id) + String(Character.battle_code)) + String(this.getTotalDamageDoneToEnemies())) + _loc6_));
                        new amfConnect().service("ShadowWar.executeService", ["finishBattle", [Character.char_id, Character.sessionkey, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc6_, _loc2_]], this.onBattleFinishAmf, true);
                        break;
                    case BattleVars.DRAGON_HUNT_MATCH:
                        _loc2_ = CUCSG.hash(((((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()) + BattleVars.DH_MODE.toString()) + BattleVars.CAPTURED_AT.toString()));
                        new amfConnect().service("DragonHuntEvent.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, _loc2_, this.getTotalDamageDoneToEnemies(), Character.sessionkey, _loc6_, BattleVars.DH_MODE, BattleVars.CAPTURED_AT], this.onBattleFinishAmf, true);
                        break;
                    case BattleVars.EVENT_MATCH:
                        if (Character.is_hunting_house)
                        {
                            _loc2_ = CUCSG.hash(((String(Character.hunting_zone) + String(Character.char_id)) + String(Character.battle_code)));
                            new amfConnect().service("HuntingHouse.finishHunting", [Character.char_id, Character.hunting_zone, Character.battle_code, _loc2_, Character.sessionkey, _loc6_], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_eudemon_garden)
                        {
                            _loc2_ = CUCSG.hash(((String(Character.eudemon_boss_num) + String(Character.char_id)) + String(Character.battle_code)));
                            new amfConnect().service("EudemonGarden.finishHunting", [Character.char_id, Character.eudemon_boss_num, Character.battle_code, _loc2_, Character.sessionkey, _loc6_], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_hanami_event)
                        {
                            if (this._main.sakura_battle_counter >= 2)
                            {
                                Character.is_hanami_event = false;
                                this._main.sakura_battle_counter = 0;
                                _loc2_ = CUCSG.hash((((Character.christmas_boss_num.toString() + Character.char_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()));
                                this._main.amf_manager.service("SakuraEvent2023.finishBattle", [Character.char_id, Character.christmas_boss_num, Character.battle_code, _loc2_, this.getTotalDamageDoneToEnemies(), Character.sessionkey, _loc6_], this.onBattleFinishAmf, true);
                                break;
                            };
                            this._main.sakura_battle_counter++;
                            this._main.startSakuraBattle(this._main.sakura_battle_counter);
                            break;
                        };
                        if (Character.is_salus_event)
                        {
                            _loc2_ = CUCSG.hash((((Character.christmas_boss_num.toString() + Character.char_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()));
                            new amfConnect().service("SalusEvent2023.finishBattle", [Character.char_id, Character.christmas_boss_num, Character.battle_code, _loc2_, this.getTotalDamageDoneToEnemies(), Character.sessionkey, _loc6_], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_monster_hunter_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("MonsterHunterEvent2023.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_thanksgiving_special_event)
                        {
                            if (this._main.thanksgiving_battle_counter >= 2)
                            {
                                Character.is_thanksgiving_special_event = false;
                                this._main.remainingStatus = [];
                                this._main.thanksgiving_battle_counter = 0;
                                _loc2_ = CUCSG.hash((((Character.christmas_boss_num.toString() + Character.char_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()));
                                new amfConnect().service("ThanksGivingEvent2023.finishExtremeBattle", [Character.char_id, Character.christmas_boss_num, Character.battle_code, _loc2_, this.getTotalDamageDoneToEnemies(), Character.sessionkey, _loc6_], this.onBattleFinishAmf, true);
                                break;
                            };
                            this._main.remainingStatus = [];
                            _loc9_ = 0;
                            while (_loc9_ < this.character_team_players.length)
                            {
                                this._main.remainingStatus.push({
                                    "remaining_hp":this.character_team_players[_loc9_].health_manager.getCurrentHP(),
                                    "remaining_cp":this.character_team_players[_loc9_].health_manager.getCurrentCP(),
                                    "remaining_sp":this.character_team_players[_loc9_].health_manager.getCurrentSP(),
                                    "remaining_eom":BattleVars.CHARACTER_REVIVED[_loc9_],
                                    "remaining_unyielding":this.character_team_players[_loc9_].unyielding_mode
                                });
                                _loc9_++;
                            };
                            this._main.thanksgiving_battle_counter++;
                            this._main.startThanksgivingBattle(this._main.thanksgiving_battle_counter);
                            break;
                        };
                        if (Character.is_valentine_special_event)
                        {
                            if (this._main.valentine_battle_counter >= 2)
                            {
                                Character.is_valentine_special_event = false;
                                this._main.remainingStatus = [];
                                this._main.valentine_battle_counter = 0;
                                _loc2_ = CUCSG.hash((((Character.christmas_boss_id.toString() + Character.char_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()));
                                new amfConnect().service("ValentineEvent2024.finishSpecialBattle", [Character.char_id.toString(), Character.christmas_boss_id, Character.battle_code, _loc2_, this.getTotalDamageDoneToEnemies().toString(), Character.sessionkey, _loc6_], this.onBattleFinishAmf, true);
                                break;
                            };
                            this._main.remainingStatus = [];
                            _loc9_ = 0;
                            while (_loc9_ < this.character_team_players.length)
                            {
                                this._main.remainingStatus.push({
                                    "remaining_hp":this.character_team_players[_loc9_].health_manager.getCurrentHP(),
                                    "remaining_cp":this.character_team_players[_loc9_].health_manager.getCurrentCP(),
                                    "remaining_sp":this.character_team_players[_loc9_].health_manager.getCurrentSP(),
                                    "remaining_eom":BattleVars.CHARACTER_REVIVED[_loc9_],
                                    "remaining_unyielding":this.character_team_players[_loc9_].unyielding_mode
                                });
                                _loc9_++;
                            };
                            this._main.valentine_battle_counter++;
                            this._main.startValentineBattle(this._main.valentine_battle_counter);
                            break;
                        };
                        if (Character.is_delivery_event)
                        {
                            if (this._main.is_ambush_battle)
                            {
                                this._main.remainingStatus = [];
                                _loc9_ = 0;
                                while (_loc9_ < this.character_team_players.length)
                                {
                                    this._main.remainingStatus.push({
                                        "remaining_hp":this.character_team_players[_loc9_].health_manager.getCurrentHP(),
                                        "remaining_cp":this.character_team_players[_loc9_].health_manager.getCurrentCP(),
                                        "remaining_sp":this.character_team_players[_loc9_].health_manager.getCurrentSP(),
                                        "remaining_eom":BattleVars.CHARACTER_REVIVED[_loc9_],
                                        "remaining_unyielding":this.character_team_players[_loc9_].unyielding_mode
                                    });
                                    _loc9_++;
                                };
                                this._main.continueAmbushBattle();
                                break;
                            };
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            _loc10_ = ((int(Character.char_id) + int(Character.character_lvl)) * (105 * this._main.ambushBattleData.current_engagement));
                            new amfConnect().service("DeliveryEvent2024.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, _loc10_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_summer_special_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("SummerEvent2024.finishSpecialBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_poseidon_event)
                        {
                            if (this._main.poseidon_battle_counter >= 2)
                            {
                                _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                                new amfConnect().service("PoseidonEvent2024.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                                break;
                            };
                            this._main.loadPoseidonDialogue("scene_2");
                            break;
                        };
                        if (Character.is_cny_event)
                        {
                            _loc2_ = CUCSG.hash((((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()) + BattleVars.CAPTURED_AT.toString()));
                            new amfConnect().service("ChineseNewYear2025.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, _loc2_, this.getTotalDamageDoneToEnemies(), Character.sessionkey, _loc6_, BattleVars.CAPTURED_AT], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_valentine_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("ValentineEvent2025.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_anniversary_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("AnniversaryEvent2025.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_anniversary_spenemy_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("AnniversaryEvent2025.finishSpecialBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_ramadhan_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("RamadhanEvent2025.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_easter_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("EasterEvent2025.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_world_master_games_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("WorldMasterGames2025.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_summer_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("SummerEvent2025.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_independence_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("IndependenceEvent2025.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_yinyang_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("YinYangEvent.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_halloween_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("HalloweenEvent2025.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_confronting_death_event)
                        {
                            if (this._main.confronting_death_battle_counter >= 2)
                            {
                                _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                                new amfConnect().service("ConfrontingDeathEvent2025.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                                break;
                            };
                            this._main.loadConfrontingDeathDialogue("scene_2");
                            break;
                        };
                        if (Character.is_thanksgiving_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("ThanksGivingEvent2025.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                            break;
                        };
                        if (Character.is_christmas_event)
                        {
                            _loc2_ = CUCSG.hash(((((Character.char_id.toString() + Character.christmas_boss_id.toString()) + Character.battle_code) + this.getTotalDamageDoneToEnemies().toString()) + _loc6_.toString()));
                            new amfConnect().service("ChristmasEvent2025.finishBattle", [Character.char_id, Character.christmas_boss_id, Character.battle_code, this.getTotalDamageDoneToEnemies(), _loc2_, _loc6_, Character.sessionkey], this.onBattleFinishAmf, true);
                        };
                        break;
                    case BattleVars.EXAM_MATCH:
                        Character.character_class = null;
                        if (this._main.is_ninja_tutor_exam_s1c2)
                        {
                            this._main.continueNinjaTutorExamS1C2();
                            break;
                        };
                        if (this._main.is_ninja_tutor_exam_s2c2)
                        {
                            this._main.continueNinjaTutorExamS2C2();
                            break;
                        };
                        if (this._main.is_ninja_tutor_exam_s3c2)
                        {
                            this._main.continueNinjaTutorExamS3C2();
                            break;
                        };
                        if (this._main.is_ninja_tutor_exam_s4c2)
                        {
                            this._main.continueNinjaTutorExamS4C2();
                            break;
                        };
                        if (this._main.is_ninja_tutor_exam_s5c2)
                        {
                            this._main.continueNinjaTutorExamS5C2();
                            break;
                        };
                        if (this._main.is_ninja_tutor_exam_s6c1)
                        {
                            this._main.continueNinjaTutorExamS6C1();
                            break;
                        };
                        if (this._main.is_ninja_tutor_exam_s6c2)
                        {
                            this._main.continueNinjaTutorExamS6C2();
                            break;
                        };
                        if (this._main.is_special_jounin_exam_s1c2)
                        {
                            this._main.continueSpecialJouninExamS1C2();
                            break;
                        };
                        if (this._main.is_special_jounin_exam_s2c2)
                        {
                            this._main.continueSpecialJouninExamS2C2();
                            break;
                        };
                        if (this._main.is_special_jounin_exam_s3c2)
                        {
                            this._main.continueSpecialJouninExamS3C2();
                            break;
                        };
                        if (this._main.is_special_jounin_exam_s4c2)
                        {
                            this._main.finishSpecialJouninExam();
                            break;
                        };
                        if (this._main.is_special_jounin_exam_s5c2)
                        {
                            this._main.finishSpecialJouninExam();
                            break;
                        };
                        if (this._main.is_special_jounin_exam_s6c1)
                        {
                            this._main.finishSpecialJouninExam();
                            break;
                        };
                        if (this._main.is_special_jounin_exam_s6c2)
                        {
                            this._main.finishSpecialJouninExam();
                            break;
                        };
                        if (this._main.is_special_jounin_exam_s6c3)
                        {
                            this._main.finishSpecialJouninExam();
                            break;
                        };
                        if (((Boolean(this._main.is_jounin_exam_stage2)) || (Character.mission_id == "jounin_stage2_4")))
                        {
                            this._main.continueJouninExamStage2();
                            break;
                        };
                        if (this._main.is_jounin_exam_stage5)
                        {
                            this._main.finishStage5Jounin();
                            break;
                        };
                        if (this._main.is_jounin_exam_stage4)
                        {
                            this._main.finishStage4Jounin();
                            break;
                        };
                        if (this._main.is_exam_stage5)
                        {
                            this._main.continueStage5();
                            break;
                        };
                        if (this._main.is_exam_stage4)
                        {
                            this._main.continueStage4();
                            break;
                        };
                        if (this._main.is_exam_stage3)
                        {
                            this._main.continueStage3();
                            break;
                        };
                        if (this._main.exam_enemy == "ene_31")
                        {
                            this._main.exam_enemy = "";
                            this._main.continueStage2(1);
                            break;
                        };
                        if (this._main.exam_enemy == "ene_36")
                        {
                            this._main.exam_enemy = "";
                            this._main.continueStage2(2);
                        };
                        break;
                    case BattleVars.TEST_MATCH:
                        this._main.battleRewards("0", "0", "Testing", false);
                };
            }
            else
            {
                if (((((((((((((((((((Boolean(this._main.is_jounin_exam_stage2)) || (Boolean(this._main.is_jounin_exam_stage5))) || (Boolean(this._main.is_jounin_exam_stage4))) || (Boolean(this._main.is_special_jounin_exam_s6c3))) || (Boolean(this._main.is_special_jounin_exam_s6c2))) || (Boolean(this._main.is_special_jounin_exam_s6c1))) || (Boolean(this._main.is_special_jounin_exam_s5c2))) || (Boolean(this._main.is_special_jounin_exam_s4c2))) || (Boolean(this._main.is_special_jounin_exam_s3c2))) || (Boolean(this._main.is_special_jounin_exam_s2c2))) || (Boolean(this._main.is_special_jounin_exam_s1c2))) || (Boolean(this._main.is_ninja_tutor_exam_s1c2))) || (Boolean(this._main.is_ninja_tutor_exam_s2c2))) || (Boolean(this._main.is_ninja_tutor_exam_s3c2))) || (Boolean(this._main.is_ninja_tutor_exam_s4c2))) || (Boolean(this._main.is_ninja_tutor_exam_s5c2))) || (Boolean(this._main.is_ninja_tutor_exam_s6c1))) || (Boolean(this._main.is_ninja_tutor_exam_s6c2))))
                {
                    this._main.exam_stage.showFailDialog();
                }
                else
                {
                    this._main.battleRewards("0", "0", "Lost", false);
                };
            };
            this.resetGameModes();
        }

        public function endBattle(param1:Boolean):*
        {
            BattleVars.MATCH_RUNNING = false;
            BattleTimer.stopTurnTimer();
            this._main.loading(false);
            this._main.battleCount++;
            setTimeout(this.endBattleAndCallAmf, 1200, param1);
        }

        public function onBattleFinishAmf(param1:Object=null):*
        {
            var _loc2_:*;
            var _loc3_:*;
            var _loc4_:*;
            Character.character_recruit_ids = [];
            if (param1 != null)
            {
                if (param1.status == 1)
                {
                    Character.character_xp = param1.xp;
                    _loc4_ = (int(param1.level) - int(Character.character_lvl));
                    Character.atrrib_free = _loc4_;
                    Character.character_lvl = param1.level;
                    if (BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.ARENA_MATCH)
                    {
                        _loc2_ = (getDefinitionByName("ShadowWarReward") as Class);
                        _loc3_ = new _loc2_(this._main, param1.trophies_got);
                        this._main.loader.addChild(_loc3_);
                    }
                    else
                    {
                        this._main.battleRewards(param1.result[0], param1.result[1], param1.result[2], param1.level_up, param1);
                        if (Character.is_confronting_death_event)
                        {
                            this._main.loadConfrontingDeathDialogue("scene_3");
                        };
                    };
                }
                else
                {
                    this._main.showMessage(((param1.hasOwnProperty("result")) ? param1.result : "Unknown Error"));
                    this._main.getError(((param1.hasOwnProperty("error")) ? param1.error : "2000"));
                };
            }
            else
            {
                if (BattleManager.BATTLE_VARS.BATTLE_MODE == BattleVars.ARENA_MATCH)
                {
                    _loc2_ = (getDefinitionByName("ShadowWarReward") as Class);
                    _loc3_ = new _loc2_(this._main, 0);
                    this._main.loader.addChild(_loc3_);
                }
                else
                {
                    this._main.battleRewards("0", "0", [], false);
                };
            };
        }

        public function hideUI(param1:MouseEvent):void
        {
            var _loc2_:int;
            this.showGUI = (!(this.showGUI));
            this.char_hpcp.visible = this.showGUI;
            this.atbBar.visible = this.showGUI;
            this.btn_UI_Gear.visible = this.showGUI;
            this.teamMc.visible = this.showGUI;
            this.teamTxt.visible = this.showGUI;
            this.rekrut.visible = this.showGUI;
            this.woodFrame.visible = this.showGUI;
            this.btn_WorldChat.visible = this.showGUI;
            this.btnOption.visible = this.showGUI;
            this.versionTxt.visible = this.showGUI;
            _loc2_ = 0;
            while (_loc2_ < this.character_team_players.length)
            {
                this[("charMc_" + _loc2_)].hpBar.visible = this.showGUI;
                this[("charMc_" + _loc2_)].rankMC.visible = this.showGUI;
                this[("charMc_" + _loc2_)].nameTxt.visible = this.showGUI;
                this[("charMc_" + _loc2_)].targetArrow.visible = this.showGUI;
                this[("charMc_" + _loc2_)].wood.visible = this.showGUI;
                if (((Boolean(this.character_team_players[_loc2_].hasOwnProperty("pet_model"))) && (!(this.character_team_players[_loc2_].pet_model == null))))
                {
                    this[("charPetMc_" + _loc2_)].hpBar.visible = this.showGUI;
                    this[("charPetMc_" + _loc2_)].txtmc.visible = this.showGUI;
                    this[("charPetMc_" + _loc2_)].wood.visible = this.showGUI;
                };
                _loc2_++;
            };
            _loc2_ = 0;
            while (_loc2_ < this.enemy_team_players.length)
            {
                this[("enemyMc_" + _loc2_)].hpBar.visible = this.showGUI;
                this[("enemyMc_" + _loc2_)].nameTxt.visible = this.showGUI;
                this[("enemyMc_" + _loc2_)].wood.visible = this.showGUI;
                this[("enemyMc_" + _loc2_)].targetArrow.visible = this.showGUI;
                this[("enemyMc_" + _loc2_)].rankMC.visible = ((this.enemy_team_players[_loc2_].isCharacter()) ? this.showGUI : false);
                if (((Boolean(this.enemy_team_players[_loc2_].hasOwnProperty("pet_model"))) && (!(this.enemy_team_players[_loc2_].pet_model == null))))
                {
                    this[("enemyPetMc_" + _loc2_)].hpBar.visible = this.showGUI;
                    this[("enemyPetMc_" + _loc2_)].txtmc.visible = this.showGUI;
                    this[("enemyPetMc_" + _loc2_)].wood.visible = this.showGUI;
                };
                _loc2_++;
            };
        }

        public function finishClanBattleRes(param1:Object, param2:*=null):*
        {
            var _loc3_:*;
            Character.character_recruit_ids = [];
            if (((!(param1 == null)) && (Boolean(param1.hasOwnProperty("gain")))))
            {
                _loc3_ = new ClanBattleResults(this._main);
                _loc3_.updateDisplay(param1);
                this.addChild(_loc3_);
            }
            else
            {
                this._main.getError("");
            };
            this.animation = new Animation(this, false);
            this.animation.gotoAndPlay(1);
            this._main.loader.addChild(this.animation);
            this.eventHandler.addListener(this.animation, Event.REMOVED_FROM_STAGE, this.animationRemoved);
        }

        public function finishCrewBattle(param1:*=null, param2:*=null):*
        {
            if (((!(param1 == null)) && (Boolean(param1.hasOwnProperty("data")))))
            {
                this._main.battleRewards("0", "0", [], false, param1);
            }
            else
            {
                this._main.battleRewards("0", "0", [], false);
            };
        }

        internal function animationRemoved(param1:Event):*
        {
            this.eventHandler.removeListener(this.animation, Event.REMOVED_FROM_STAGE, this.animationRemoved);
            this.animation = null;
        }

        public function resetGameModes():*
        {
            var _loc1_:* = null;
            if ((("_main" in this) && (!(this._main == null))))
            {
                _loc1_ = this._main;
            }
            else
            {
                if (BattleManager.MAIN != null)
                {
                    _loc1_ = BattleManager.MAIN;
                };
            };
            if (_loc1_)
            {
                _loc1_.is_ninja_tutor_exam_s1c2 = false;
                _loc1_.is_ninja_tutor_exam_s2c2 = false;
                _loc1_.is_ninja_tutor_exam_s3c2 = false;
                _loc1_.is_ninja_tutor_exam_s4c2 = false;
                _loc1_.is_ninja_tutor_exam_s5c2 = false;
                _loc1_.is_ninja_tutor_exam_s6c1 = false;
                _loc1_.is_ninja_tutor_exam_s6c2 = false;
                _loc1_.is_special_jounin_exam_s1c2 = false;
                _loc1_.is_special_jounin_exam_s2c2 = false;
                _loc1_.is_special_jounin_exam_s3c2 = false;
                _loc1_.is_special_jounin_exam_s4c2 = false;
                _loc1_.is_special_jounin_exam_s5c2 = false;
                _loc1_.is_special_jounin_exam_s6c1 = false;
                _loc1_.is_special_jounin_exam_s6c2 = false;
                _loc1_.is_special_jounin_exam_s6c3 = false;
                _loc1_.is_jounin_exam_stage2 = false;
                _loc1_.is_jounin_exam_stage3 = false;
                _loc1_.is_jounin_exam_stage4 = false;
                _loc1_.is_jounin_exam_stage5 = false;
                _loc1_.is_exam_stage2 = false;
                _loc1_.is_exam_stage3 = false;
                _loc1_.is_exam_stage4 = false;
                _loc1_.is_exam_stage5 = false;
            }
            else
            {
                Log.error(this, "resetGameModes: No main object found");
            };
            Character.temp_recruit_ids = [];
            BattleVars.BACKGROUND_CHANGED = false;
            BattleVars.BACKGROUND_CHANGED_CASTER = "";
            Character.is_jounin_stage_4 = false;
            Character.is_jounin_stage_5_1 = false;
            Character.is_jounin_stage_5_2 = false;
            Character.is_anniversary_event = false;
            Character.is_cny_event = false;
            Character.is_hunting_house = false;
            Character.is_friend_berantem = false;
            Character.is_easter_event = false;
            Character.is_valentine_event = false;
            Character.is_thanksgiving_event = false;
            Character.is_salus_event = false;
            Character.is_monster_hunter_event = false;
            Character.is_halloween_event = false;
            Character.is_halloween_special_event = false;
            Character.is_clan_war = false;
            Character.is_eudemon_garden = false;
            Character.is_hard_mode = false;
            Character.encyclopedia_battle.battle = false;
        }

        public function backToVillage():*
        {
            OutfitManager.removeChildsFromMovieClips(this._main.loader);
            this._main.loadPanel("Panels.Village");
            this._main.loadPanel("Panels.HUD");
        }

        public function backToClan():*
        {
            OutfitManager.removeChildsFromMovieClips(this._main.loader);
            this._main.loadPanel("Panels.Village");
            this._main.loadPanel("Panels.HUD");
            this._main.loadPanel("Panels.ClanVillage");
        }

        public function clearCopySkillMC():*
        {
            if (this.copySkillMC)
            {
                this.copySkillMC.destroy();
                this.copySkillMC = null;
            };
        }

        public function clearCombatUI():*
        {
            this.parent.removeChild(this);
        }

        public function destroy():*
        {
            if (this.destroyed)
            {
                return;
            };
            this.destroyed = true;
            Log.debug(this, "destroy");
            this.clearCopySkillMC();
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            if (this.gear)
            {
                this.gear.destroy();
            };
            if (this.option)
            {
                this.option.destroy();
            };
            if (this.world_chat)
            {
                this.world_chat.destroy();
            };
            this.world_chat = null;
            this.gear = null;
            this.option = null;
            this._main = null;
            this.agility_bar_manager.destroy();
            this.agility_bar_manager = null;
            this.attacker_model = null;
            this.defender_model = null;
            this.battle_stages_fllw = null;
            GF.removeAllChild(this.master_model);
            this.master_model = null;
            if ((this.defender_models is Array))
            {
                GF.destroyArray(this.defender_models);
            };
            this.defender_models = null;
            if ((this.attacker_models is Array))
            {
                GF.destroyArray(this.attacker_models);
            };
            this.attacker_models = null;
            GF.destroyArray(this.outfits);
            GF.clearArray(this.reset_new_amount_objects);
            GF.clearArray(this.reset_next_turn_objects);
            GF.clearArray(Character.battle_logs);
            GF.destroyArray(this.character_team_players);
            GF.destroyArray(this.enemy_team_players);
            this.reset_new_amount_objects = null;
            this.reset_next_turn_objects = null;
            this.character_team_players = null;
            this.enemy_team_players = null;
            GF.removeAllChild(this.bgHolder);
            GF.removeAllChild(this.actionBar);
            GF.removeAllChild(this.actionBar1);
            GF.removeAllChild(this.actionBar2);
            GF.removeAllChild(this.atbBar);
            GF.removeAllChild(this.char_hpcp);
            GF.removeAllChild(this.charMc_0);
            GF.removeAllChild(this.charMc_1);
            GF.removeAllChild(this.charMc_2);
            GF.removeAllChild(this.charPetMc_0);
            GF.removeAllChild(this.charPetMc_1);
            GF.removeAllChild(this.charPetMc_2);
            GF.removeAllChild(this.enemyMc_0);
            GF.removeAllChild(this.enemyMc_1);
            GF.removeAllChild(this.enemyMc_2);
            GF.removeAllChild(this.enemyPetMc_0);
            GF.removeAllChild(this.enemyPetMc_1);
            GF.removeAllChild(this.enemyPetMc_2);
            GF.removeAllChild(this.scrollDisplayMc_0);
            GF.removeAllChild(this.scrollDisplayMc_1);
            GF.removeAllChild(this.scrollDisplayMc_2);
            GF.removeAllChild(this.atk_turnTimerTxt);
            GF.removeAllChild(this.dh_hint);
            GF.removeAllChild(this.logo);
            GF.removeAllChild(this.senjutsuTransition);
            GF.removeAllChild(this.sushiMc);
            GF.removeAllChild(this.teamMc);
            GF.removeAllChild(this.totalDamageHint);
            GF.removeAllChild(this.woodFrame);
            this.bgHolder = null;
            this.actionBar = null;
            this.actionBar1 = null;
            this.actionBar2 = null;
            this.atbBar = null;
            this.char_hpcp = null;
            this.charMc_0 = null;
            this.charMc_1 = null;
            this.charMc_2 = null;
            this.charPetMc_0 = null;
            this.charPetMc_1 = null;
            this.charPetMc_2 = null;
            this.enemyMc_0 = null;
            this.enemyMc_1 = null;
            this.enemyMc_2 = null;
            this.enemyPetMc_0 = null;
            this.enemyPetMc_1 = null;
            this.enemyPetMc_2 = null;
            this.scrollDisplayMc_0 = null;
            this.scrollDisplayMc_1 = null;
            this.scrollDisplayMc_2 = null;
            this.dh_hint = null;
            this.logo = null;
            this.senjutsuTransition = null;
            this.sushiMc = null;
            this.teamMc = null;
            this.totalDamageHint = null;
            this.woodFrame = null;
            WeaponBuffs.clearCached();
            AccessoryBuffs.clearCached();
            BackItemBuffs.clearCached();
            Character.battle_logs = [];
            this.outfits = null;
            GF.removeAllChild(this);
            BattleTimer.destroy();
            this.atk_turnTimerTxt = null;
            BattleManager.destroyCombat();
        }


    }
}//package Combat

