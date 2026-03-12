// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.pvp.battle.PvPActionManager

package id.ninjasage.pvp.battle
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Popups.Confirmation;
    import id.ninjasage.Log;
    import Storage.SkillLibrary;
    import com.utils.GF;
    import flash.events.MouseEvent;
    import Managers.OutfitManager;
    import Storage.TalentSkillLevel;
    import Storage.SenjutsuSkillLevel;
    import id.ninjasage.pvp.PvPSocket;
    import gs.TweenLite;
    import Storage.Character;

    public class PvPActionManager 
    {

        private var _destroyed:Boolean = false;
        private var _team:String;
        private var _playerNumber:int;
        private var _actionBar:MovieClip;
        private var _equippedSkills:Array = [];
        private var _loading_skill_id:String = "";
        private var _loading_skill_number:int = 0;
        private var _loading_active_skill_index:int = 0;
        private var _eventHandler:EventHandler;
        private var _skill_icons:Array = [];
        private var _talent_icons:Array = [];
        private var _senjutsu_icons:Array = [];
        private var _charId:Number = 0;
        private var _character_skills_mc:Array = [];
        private var _character_senjutsu_skills_mc:Array = [];
        private var _character_talent_skills_mc:Array = [];
        private var _character_talent_passive_skills_mc:Array = [];
        private var _character_senjutsu_passive_skills_mc:Array = [];
        private var _character_talent_skills_info:Array = [];
        private var _character_senjutsu_skills_info:Array = [];
        private var _special_skill_id:String = "";
        private var _special_skill_handler:PvPSkillHandler = null;
        private var _special_skill_icon:MovieClip = null;
        private var _copy_skill_id:String = "";
        private var _copy_skill_handler:PvPSkillHandler = null;
        private var _cooldown_info:Object = {};
        private var _confirmation:Confirmation = null;

        public function PvPActionManager(_arg_1:String="player", _arg_2:int=0, _arg_3:Number=0)
        {
            this._team = _arg_1;
            this._playerNumber = _arg_2;
            this._charId = _arg_3;
            this._eventHandler = new EventHandler();
            this.fillActionBar();
        }

        public function fillActionBar():*
        {
            var _local_1:* = "actionBar";
            if (this._playerNumber == 1)
            {
                _local_1 = "actionBar1";
            };
            if (this._playerNumber == 2)
            {
                _local_1 = "actionBar2";
            };
            this._actionBar = PvPBattleManager.getBattle()[_local_1];
            if (PvPBattleManager.PVP.character.getID() === this._charId)
            {
                this.hideTalents();
                this.addButtonListeners();
                this.checkSwitchSenjutsuNinjutsu();
                this.checkScrollsDisplay();
            };
            this.getEquippedSkillsAndLoad();
        }

        public function getEquippedSkillsAndLoad():*
        {
            this._equippedSkills = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getEquippedSkills();
            this.loadEquippedSkills();
        }

        public function loadEquippedSkills():*
        {
            if (this._equippedSkills.length > this._loading_skill_number)
            {
                this._loading_skill_id = this._equippedSkills[this._loading_skill_number];
                PvPBattleManager.getMain().loadSkillSWF(this._loading_skill_id, this.onSkillSWFLoaded);
            }
            else
            {
                Log.debug(this, (this._team + this._playerNumber), "Completed loading basic skills");
                this.getTalentSkillsAndLoad();
            };
        }

        public function onSkillSWFLoaded(_arg_1:*):void
        {
            var _local_7:*;
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            var _local_3:MovieClip = _arg_1.target.content[this._loading_skill_id];
            _local_3.gotoAndStop(1);
            {
                _local_3.stopAllMovieClips();
            };
            var _local_4:Object = SkillLibrary.getCopy(this._loading_skill_id);
            _local_4.skill_id = this._loading_skill_id;
            var _local_5:PvPSkillHandler = new PvPSkillHandler(_local_3, this._team, this._playerNumber, _local_4);
            var _local_6:MovieClip = _arg_1.target.content["icon"];
            this._skill_icons.push(_local_6);
            try
            {
                _arg_1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
            if (PvPBattleManager.PVP.character.getID() === this._charId)
            {
                _local_7 = this._actionBar[("skill_" + this._loading_skill_number)];
                GF.removeAllChild(_local_7.holder);
                _local_7.holder.addChild(_local_6);
                _local_7.item_id = this._loading_skill_id;
                _local_7.is_talent = false;
                _local_7.is_passive = false;
                this._eventHandler.addListener(_local_7, MouseEvent.CLICK, this.onUseSkill);
                this._eventHandler.addListener(_local_7, MouseEvent.MOUSE_OVER, PvPBattleManager.BATTLE_TOOLTIP.showTooltip);
                this._eventHandler.addListener(_local_7, MouseEvent.MOUSE_OUT, PvPBattleManager.BATTLE_TOOLTIP.hideTooltip);
            };
            this._character_skills_mc.push(_local_5);
            this._loading_skill_number++;
            this.loadEquippedSkills();
        }

        public function getTalentSkillsAndLoad():*
        {
            var _local_4:*;
            this._equippedSkills = [];
            this._loading_skill_number = 0;
            this._loading_active_skill_index = 0;
            this._loading_skill_id = "";
            var _local_1:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getTalentsSkills();
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

        public function loadTalentSkills(_arg_1:Array=null):*
        {
            if ((_arg_1 is Array))
            {
                this._equippedSkills = _arg_1;
                this._special_skill_id = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getSpecialClass();
                Log.debug(this, "loadTalentSkills", (this._team + this._playerNumber), this._special_skill_id);
            };
            if (this._equippedSkills.length > this._loading_skill_number)
            {
                this._loading_skill_id = this._equippedSkills[this._loading_skill_number].item_id;
                PvPBattleManager.getMain().loadSkillSWF(this._loading_skill_id, this.onTalentSkillSWFLoaded);
            }
            else
            {
                if (this._special_skill_id != null)
                {
                    PvPBattleManager.getMain().loadSkillSWF(this._special_skill_id, this.onClassSkillSWFLoaded);
                }
                else
                {
                    Log.debug(this, (this._team + this._playerNumber), "Completed loading talent skills");
                    this.getSenjutsuSkillAndLoad();
                };
            };
        }

        public function onClassSkillSWFLoaded(_arg_1:*):*
        {
            var _local_6:PvPSkillHandler;
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            var _local_3:* = undefined;
            var _local_4:MovieClip;
            var _local_5:MovieClip = new MovieClip();
            if (_arg_1.target.content[this._special_skill_id])
            {
                _local_3 = SkillLibrary.getCopy(this._special_skill_id);
                _local_3.skill_id = this._special_skill_id;
                _local_5 = _arg_1.target.content[this._special_skill_id];
                _local_5.gotoAndStop(1);
                {
                    _local_5.stopAllMovieClips();
                };
                _local_6 = new PvPSkillHandler(_local_5, this._team, this._playerNumber, _local_3);
                if (this._special_skill_id == "skill_4002")
                {
                    this.checkFillOutfit(_local_6);
                };
            };
            this._special_skill_handler = _local_6;
            if (this._special_skill_id == "skill_4003")
            {
                _local_6.setCurrentCooldown(_local_6.skill_info.skill_cooldown);
            };
            if (PvPBattleManager.PVP.character.getID() == this._charId)
            {
                this._actionBar["btnClassSkill_1"].visible = true;
                _local_4 = _arg_1.target.content["icon"];
                this._special_skill_icon = _local_4;
                GF.removeAllChild(this._actionBar["btnClassSkill_1"].holder);
                this._actionBar["btnClassSkill_1"].holder.addChild(_local_4);
                this._actionBar["btnClassSkill_1"].item_id = this._special_skill_id;
                this._actionBar["btnClassSkill_1"].is_class = true;
                this._actionBar["btnClassSkill_1"].is_passive = false;
                if (this._special_skill_id != "skill_4002")
                {
                    this._eventHandler.addListener(this._actionBar["btnClassSkill_1"], MouseEvent.CLICK, this.onUseClassSkill);
                };
                this._eventHandler.addListener(this._actionBar["btnClassSkill_1"], MouseEvent.MOUSE_OVER, PvPBattleManager.BATTLE_TOOLTIP.showTooltip);
                this._eventHandler.addListener(this._actionBar["btnClassSkill_1"], MouseEvent.MOUSE_OUT, PvPBattleManager.BATTLE_TOOLTIP.hideTooltip);
            };
            this.getSenjutsuSkillAndLoad();
        }

        public function onTalentSkillSWFLoaded(_arg_1:*):*
        {
            var _local_3:int;
            var _local_4:Boolean;
            var _local_5:Array;
            var _local_16:PvPSkillHandler;
            var _local_17:*;
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
            if (!_arg_1.target.content[this._loading_skill_id])
            {
                _local_15 = true;
            };
            if (((this._loading_skill_id == "skill_1023") || (this._loading_skill_id == "skill_1050")))
            {
                _local_15 = true;
            };
            _local_6 = TalentSkillLevel.getTalentSkillLevels(this._loading_skill_id, PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getTalentLevel(this._loading_skill_id));
            _local_6.skill_id = this._loading_skill_id;
            if (_arg_1.target.content[this._loading_skill_id])
            {
                _local_13 = _arg_1.target.content[this._loading_skill_id];
                _local_13.gotoAndStop(1);
                {
                    _local_13.stopAllMovieClips();
                };
                _local_16 = new PvPSkillHandler(_local_13, this._team, this._playerNumber, _local_6);
            };
            _local_3 = int(this._loading_skill_id.replace("skill_", ""));
            _local_4 = (_local_6.type == "secret");
            if (PvPBattleManager.PVP.character.getID() == this._charId)
            {
                _local_8 = _arg_1.target.content["icon"];
                this._talent_icons.push(_local_8);
                if (_local_15)
                {
                    this._actionBar["starMC"].visible = true;
                    this._actionBar["boardMC"].visible = true;
                    _local_9 = 0;
                    while (_local_9 < 12)
                    {
                        if (this._actionBar[("pass_" + _local_9)].visible == false)
                        {
                            this._actionBar[("pass_" + _local_9)].visible = true;
                            GF.removeAllChild(this._actionBar[("pass_" + _local_9)].holder);
                            this._actionBar[("pass_" + _local_9)].holder.addChild(_local_8);
                            this._actionBar[("pass_" + _local_9)].holder.skill_id = this._loading_skill_id;
                            this._actionBar[("pass_" + _local_9)].item_id = this._loading_skill_id;
                            this._actionBar[("pass_" + _local_9)].is_talent = true;
                            this._actionBar[("pass_" + _local_9)].is_passive = true;
                            this._eventHandler.addListener(this._actionBar[("pass_" + _local_9)], MouseEvent.MOUSE_OVER, PvPBattleManager.BATTLE_TOOLTIP.showTooltip);
                            this._eventHandler.addListener(this._actionBar[("pass_" + _local_9)], MouseEvent.MOUSE_OUT, PvPBattleManager.BATTLE_TOOLTIP.hideTooltip);
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
                        if (this._actionBar[(_local_12 + _local_10)].filled == false)
                        {
                            _local_17 = (_local_12 + _local_10);
                            this._actionBar[_local_17].filled = true;
                            GF.removeAllChild(this._actionBar[_local_17].holder);
                            this._actionBar[_local_17].holder.addChild(_local_8);
                            this._actionBar[_local_17].cdTxt.text = "";
                            this._actionBar[_local_17].item_id = this._loading_skill_id;
                            this._actionBar[_local_17].skill_index = this._loading_active_skill_index;
                            this._actionBar[_local_17].is_talent = true;
                            this._actionBar[_local_17].is_passive = false;
                            this._actionBar[_local_17].is_secondary = _local_4;
                            this._eventHandler.addListener(this._actionBar[_local_17], MouseEvent.CLICK, this.useTalentSkill);
                            this._eventHandler.addListener(this._actionBar[_local_17], MouseEvent.MOUSE_OVER, PvPBattleManager.BATTLE_TOOLTIP.showTooltip);
                            this._eventHandler.addListener(this._actionBar[_local_17], MouseEvent.MOUSE_OUT, PvPBattleManager.BATTLE_TOOLTIP.hideTooltip);
                            this._loading_active_skill_index++;
                            break;
                        };
                        _local_10++;
                    };
                };
            };
            if (!_local_15)
            {
                this.addTalentSkillMcToArray(_local_16, _local_17);
            };
            if (_local_15)
            {
                this.addTalentPassiveSkillMcToArray(this._equippedSkills[this._loading_skill_number]);
            };
            this._loading_skill_number++;
            try
            {
                _arg_1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
            this.loadTalentSkills();
        }

        public function getSenjutsuSkillAndLoad():*
        {
            var _local_7:*;
            var _local_8:*;
            this._equippedSkills = [];
            this._loading_skill_number = 0;
            this._loading_active_skill_index = 0;
            this._loading_skill_id = "";
            var _local_1:* = {};
            var _local_2:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber];
            var _local_3:* = _local_2.getSenjutsuSkills();
            var _local_4:* = _local_2.getEquippedSenjutsuSkills();
            var _local_5:* = [];
            var _local_6:* = 0;
            while (_local_6 < _local_3.length)
            {
                if (_local_3[_local_6] != null)
                {
                    _local_7 = _local_3[_local_6].split(":");
                    _local_1[_local_7[0]] = int(_local_7[1]);
                    _local_8 = SenjutsuSkillLevel.getSenjutsuSkillLevels(_local_7[0], _local_2.getSenjutsuLevel(_local_7[0]));
                    _local_5.push({
                        "item_id":_local_7[0],
                        "item_level":_local_7[1]
                    });
                };
                _local_6++;
            };
            this.loadSenjutsuSkills(_local_5);
        }

        public function loadSenjutsuSkills(_arg_1:Array=null):*
        {
            if ((_arg_1 is Array))
            {
                this._equippedSkills = _arg_1;
            };
            if (this._equippedSkills.length > this._loading_skill_number)
            {
                this._loading_skill_id = this._equippedSkills[this._loading_skill_number].item_id;
                PvPBattleManager.getMain().loadSkillSWF(this._loading_skill_id, this.onSenjutsuSkillSWFLoaded);
            }
            else
            {
                Log.debug(this, (this._team + this._playerNumber), "Completed loading senjutsu skills");
                PvPSocket.getInstance().emit("Battle.readyToFight", {
                    "battle_id":PvPBattleManager.getBattleID(),
                    "char_id":this._charId,
                    "team":this._team,
                    "num":this._playerNumber
                });
            };
        }

        public function onSenjutsuSkillSWFLoaded(_arg_1:*):*
        {
            var _local_3:int;
            var _local_12:PvPSkillHandler;
            var _local_13:*;
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
            _local_4 = SenjutsuSkillLevel.getSenjutsuSkillLevels(this._loading_skill_id, PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getSenjutsuLevel(this._loading_skill_id));
            _local_4.skill_id = this._loading_skill_id;
            _local_11 = (_local_4.cooldown == 0);
            if (((_arg_1.target.content[this._loading_skill_id]) && (!(_local_11))))
            {
                _local_9 = _arg_1.target.content[this._loading_skill_id];
                _local_9.gotoAndStop(1);
                {
                    _local_9.stopAllMovieClips();
                };
                _local_12 = new PvPSkillHandler(_local_9, this._team, this._playerNumber, _local_4);
            };
            _local_3 = int(this._loading_skill_id.replace("skill_", ""));
            if (PvPBattleManager.PVP.character.getID() == this._charId)
            {
                _local_6 = _arg_1.target.content["icon"];
                this._senjutsu_icons.push(_local_6);
                if (_local_11)
                {
                    this._actionBar["starMC"].visible = true;
                    this._actionBar["boardMC"].visible = true;
                    _local_7 = 0;
                    while (_local_7 < 12)
                    {
                        if (this._actionBar[("pass_" + _local_7)].visible == false)
                        {
                            this._actionBar[("pass_" + _local_7)].visible = true;
                            GF.removeAllChild(this._actionBar[("pass_" + _local_7)].holder);
                            this._actionBar[("pass_" + _local_7)].holder.addChild(_local_6);
                            this._actionBar[("pass_" + _local_7)].holder.skill_id = this._loading_skill_id;
                            this._actionBar[("pass_" + _local_7)].item_id = this._loading_skill_id;
                            this._actionBar[("pass_" + _local_7)].is_senjutsu = true;
                            this._actionBar[("pass_" + _local_7)].is_passive = true;
                            this._eventHandler.addListener(this._actionBar[("pass_" + _local_7)], MouseEvent.MOUSE_OVER, PvPBattleManager.BATTLE_TOOLTIP.showTooltip);
                            this._eventHandler.addListener(this._actionBar[("pass_" + _local_7)], MouseEvent.MOUSE_OUT, PvPBattleManager.BATTLE_TOOLTIP.hideTooltip);
                            break;
                        };
                        _local_7++;
                    };
                }
                else
                {
                    _local_13 = 0;
                    while (_local_13 < 8)
                    {
                        _local_14 = ("senjutsu_" + _local_13);
                        if (this._actionBar[_local_14].filled == false)
                        {
                            this._actionBar[_local_14].filled = true;
                            GF.removeAllChild(this._actionBar[_local_14].holder);
                            this._actionBar[_local_14].holder.addChild(_local_6);
                            this._actionBar[_local_14].cdTxt.text = "";
                            this._actionBar[_local_14].item_id = this._loading_skill_id;
                            this._actionBar[_local_14].skill_index = this._loading_active_skill_index;
                            this._actionBar[_local_14].is_senjutsu = true;
                            this._actionBar[_local_14].is_passive = false;
                            this._eventHandler.addListener(this._actionBar[_local_14], MouseEvent.CLICK, this.useSenjutsuSkill);
                            this._eventHandler.addListener(this._actionBar[_local_14], MouseEvent.MOUSE_OVER, PvPBattleManager.BATTLE_TOOLTIP.showTooltip);
                            this._eventHandler.addListener(this._actionBar[_local_14], MouseEvent.MOUSE_OUT, PvPBattleManager.BATTLE_TOOLTIP.hideTooltip);
                            this._loading_active_skill_index++;
                            break;
                        };
                        _local_13++;
                    };
                };
            };
            if (!_local_11)
            {
                this.addSenjutsuSkillMcToArray(_local_12, _local_14);
            }
            else
            {
                this.addSenjutsuPassiveSkillMcToArray(this._equippedSkills[this._loading_skill_number]);
            };
            try
            {
                _arg_1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
            this._loading_skill_number++;
            this.loadSenjutsuSkills();
        }

        public function addTalentSkillMcToArray(_arg_1:PvPSkillHandler, _arg_2:*=null):*
        {
            this._character_talent_skills_mc.push(_arg_1);
            if (((!(_arg_1 == null)) && (!(_arg_2 == null))))
            {
                this._character_talent_skills_info.push({
                    "mc_index":(this._character_talent_skills_mc.length - 1),
                    "action_bar_prefix":_arg_2,
                    "skill_index":this._loading_skill_id.replace("skill_10", "")
                });
            };
        }

        public function addTalentPassiveSkillMcToArray(_arg_1:*):*
        {
            if (PvPBattleManager.PVP.character.getID() != this._charId)
            {
                return;
            };
            this._character_talent_passive_skills_mc.push(_arg_1);
        }

        public function getTalentPassiveSkills():*
        {
            return (this._character_talent_passive_skills_mc);
        }

        public function getTalentSkillsMC():*
        {
            return (this._character_talent_skills_mc);
        }

        public function addSenjutsuSkillMcToArray(_arg_1:PvPSkillHandler, _arg_2:*=null):*
        {
            this._character_senjutsu_skills_mc.push(_arg_1);
            if (((!(_arg_1 == null)) && (!(_arg_2 == null))))
            {
                this._character_senjutsu_skills_info.push({
                    "mc_index":(this._character_senjutsu_skills_mc.length - 1),
                    "action_bar_prefix":_arg_2,
                    "skill_index":this._loading_skill_id.replace("skill_30", "")
                });
            };
        }

        public function addSenjutsuPassiveSkillMcToArray(_arg_1:*):*
        {
            this._character_senjutsu_passive_skills_mc.push(_arg_1);
        }

        public function getSenjutsuPassiveSkills():*
        {
            return (this._character_senjutsu_passive_skills_mc);
        }

        public function getSenjutsuSkillsMC():*
        {
            return (this._character_senjutsu_skills_mc);
        }

        public function showActionBar():void
        {
            this._actionBar.visible = true;
        }

        public function hideActionBar():void
        {
            this._actionBar.visible = false;
            PvPBattleManager.getBattle().atk_turnTimerTxt.visible = false;
        }

        public function checkSwitchSenjutsuNinjutsu():*
        {
            var _local_1:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber];
            if (_local_1.getRank() < 8)
            {
                return;
            };
            this._actionBar["btn_senjutsu"].visible = true;
            this._actionBar["btn_ninjutsu"].visible = false;
        }

        public function checkScrollsDisplay():*
        {
            var _local_3:int;
            var _local_1:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber];
            if (_local_1.getScrolls() <= 0)
            {
                return;
            };
            var _local_2:MovieClip = PvPBattleManager.getBattle()[("scrollDisplayMc_" + this._playerNumber)];
            if (_local_2)
            {
                _local_2.visible = true;
                _local_3 = 1;
                while (_local_3 <= 5)
                {
                    _local_2[("scroll_" + _local_3)].gotoAndStop(1);
                    _local_3++;
                };
            };
        }

        public function hideTalents():*
        {
            var i:* = 0;
            this._actionBar.visible = false;
            this._actionBar["starMC"].visible = false;
            this._actionBar["boardMC"].visible = false;
            this._actionBar["bloodline_Logo"].visible = true;
            this._actionBar["btnClassSkill_1"].visible = false;
            while (i < 12)
            {
                if (i < 8)
                {
                    this._actionBar[("senjutsu_" + i)].visible = false;
                    this._actionBar[("senjutsu_" + i)].filled = false;
                };
                this._actionBar[("pass_" + i)].visible = false;
                i++;
            };
            i = 0;
            while (i < 4)
            {
                this._actionBar[("bl_" + i)].filled = false;
                this._actionBar[("bl_" + i)].visible = true;
                this._actionBar[("se_" + String((int(i) + 4)))].filled = false;
                this._actionBar[("se_" + String((int(i) + 4)))].visible = true;
                i++;
            };
            if (PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getTalentType(1) != "")
            {
                try
                {
                    this._actionBar["bloodline_Logo"].gotoAndStop(PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getTalentType(1));
                }
                catch(e)
                {
                };
            };
            if (PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getRank() >= 8)
            {
                this._eventHandler.addListener(this._actionBar["btn_senjutsu"], MouseEvent.CLICK, this.toggleSenjutsu);
                this._eventHandler.addListener(this._actionBar["btn_ninjutsu"], MouseEvent.CLICK, this.toggleSenjutsu);
            };
        }

        public function hideSenjutsu():*
        {
            this._actionBar["btn_senjutsu"].visible = true;
            this._actionBar["btn_ninjutsu"].visible = false;
            var _local_1:* = 0;
            while (_local_1 < 8)
            {
                this._actionBar[("senjutsu_" + _local_1)].visible = false;
                this._actionBar[("skill_" + _local_1)].visible = true;
                TweenLite.killTweensOf(this._actionBar[("senjutsu_" + _local_1)]);
                _local_1++;
            };
        }

        public function showSenjutsu():*
        {
            this._actionBar["btn_senjutsu"].visible = false;
            this._actionBar["btn_ninjutsu"].visible = true;
            if (Character.senjutsu_animation)
            {
                PvPBattleManager.getBattle()["senjutsuTransition"].gotoAndPlay(2);
            };
            PvPBattleManager.getBattle().setChildIndex(PvPBattleManager.getBattle()["senjutsuTransition"], (PvPBattleManager.getBattle().numChildren - 1));
            var _local_1:* = 0;
            while (_local_1 < 8)
            {
                this._actionBar[("skill_" + _local_1)].visible = false;
                this._actionBar[("senjutsu_" + _local_1)].visible = true;
                this._actionBar[("senjutsu_" + _local_1)].rotationY = 180;
                TweenLite.killTweensOf(this._actionBar[("senjutsu_" + _local_1)]);
                TweenLite.to(this._actionBar[("senjutsu_" + _local_1)], 1, {"rotationY":0});
                _local_1++;
            };
        }

        public function checkFillOutfit(_arg_1:*):void
        {
            if (((_arg_1.isOutfitFilled()) || (Character.is_stickman)))
            {
                return;
            };
            var _local_2:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber];
            _arg_1.fillOutfit(_local_2.getWeapon(), _local_2.getBackItem(), _local_2.getClothing(), _local_2.getHair(), _local_2.getFace(), _local_2.getHairColor(), _local_2.getSkinColor());
        }

        public function addButtonListeners():*
        {
            this._eventHandler.addListener(this._actionBar["btnAttack"], MouseEvent.CLICK, this.onWeaponAttack);
            this._eventHandler.addListener(this._actionBar["btnDodge"], MouseEvent.CLICK, this.onDodgeTurn);
            this._eventHandler.addListener(this._actionBar["btnCharge"], MouseEvent.CLICK, this.onChargeUsed);
            if (("btnRun" in this._actionBar))
            {
                this._eventHandler.addListener(this._actionBar["btnRun"], MouseEvent.CLICK, this.onRun);
            };
        }

        public function onUseClassSkill(_arg_1:MouseEvent):void
        {
            Log.info(this, "onUseClassSkill", _arg_1);
            PvPSocket.getInstance().emit("Battle.action.skill", {
                "battle_id":PvPBattleManager.getBattleID(),
                "skill_id":this._special_skill_handler.skill_info.skill_id
            });
            this.hideActionBar();
        }

        public function onUseSkill(_arg_1:MouseEvent):void
        {
            Log.info(this, "onUseSkill", _arg_1);
            var _local_2:* = _arg_1.currentTarget.name.replace("skill_", "");
            var _local_3:* = this._character_skills_mc[_local_2];
            PvPSocket.getInstance().emit("Battle.action.skill", {
                "battle_id":PvPBattleManager.getBattleID(),
                "skill_id":_local_3.skill_info.skill_id
            });
            this.hideActionBar();
        }

        public function useTalentSkill(_arg_1:MouseEvent):void
        {
            Log.info(this, "useTalentSkill", _arg_1);
            var _local_2:* = this._actionBar[_arg_1.currentTarget.name].skill_index;
            var _local_3:* = this._character_talent_skills_mc[_local_2];
            PvPSocket.getInstance().emit("Battle.action.skill", {
                "battle_id":PvPBattleManager.getBattleID(),
                "skill_id":_local_3.skill_info.skill_id
            });
            this.hideActionBar();
        }

        public function useSenjutsuSkill(_arg_1:MouseEvent):void
        {
            Log.info(this, "useSenjutsuSkill", _arg_1);
            var _local_2:* = this._actionBar[_arg_1.currentTarget.name].skill_index;
            var _local_3:* = this._character_senjutsu_skills_mc[_local_2];
            PvPSocket.getInstance().emit("Battle.action.skill", {
                "battle_id":PvPBattleManager.getBattleID(),
                "skill_id":_local_3.skill_info.skill_id
            });
            this.hideActionBar();
        }

        public function updateSageModeButton():void
        {
            var _local_1:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber];
            if (_local_1.getRank() < 8)
            {
                return;
            };
            if (_local_1.getCurrentSP() >= _local_1.getMaxSP())
            {
                PvPBattleManager.getMain().initButton(PvPBattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"], this.useSageMode);
            }
            else
            {
                PvPBattleManager.getMain().initButtonDisable(PvPBattleManager.getBattle()["char_hpcp"]["btn_activate_senjutsu"], this.useSageMode);
            };
        }

        public function useSageMode(_arg_1:MouseEvent):void
        {
            Log.info(this, "useSageMode", _arg_1);
            if (!this._actionBar.visible)
            {
                return;
            };
            PvPSocket.getInstance().emit("Battle.action.skill", {
                "battle_id":PvPBattleManager.getBattleID(),
                "skill_id":"skill_3000"
            });
            this.hideActionBar();
        }

        public function updateSkillsCooldownDisplay(_arg_1:Object):void
        {
            var _local_2:int;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            this._cooldown_info = _arg_1;
            _local_2 = 0;
            while (_local_2 < this._character_skills_mc.length)
            {
                if (_arg_1.hasOwnProperty(this._character_skills_mc[_local_2].skill_info.skill_id))
                {
                    _local_3 = _arg_1[this._character_skills_mc[_local_2].skill_info.skill_id].cd;
                    if (_local_3 != 0)
                    {
                        this._actionBar[("skill_" + _local_2)].cdTxt.text = _local_3;
                        PvPBattleManager.getMain().disableButton(this._actionBar[("skill_" + _local_2)].holder);
                    }
                    else
                    {
                        this._actionBar[("skill_" + _local_2)].cdTxt.text = "";
                        PvPBattleManager.getMain().enableButton(this._actionBar[("skill_" + _local_2)].holder);
                    };
                    if (_local_3 == -1)
                    {
                        this._actionBar[("skill_" + _local_2)].cdTxt.text = "";
                        PvPBattleManager.getMain().disableButton(this._actionBar[("skill_" + _local_2)].holder);
                    };
                };
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < this._character_senjutsu_skills_mc.length)
            {
                if (_arg_1.hasOwnProperty(this._character_senjutsu_skills_mc[_local_2].skill_info.skill_id))
                {
                    _local_3 = _arg_1[this._character_senjutsu_skills_mc[_local_2].skill_info.skill_id].cd;
                    if (_local_3 != 0)
                    {
                        this._actionBar[("senjutsu_" + _local_2)].cdTxt.text = _local_3;
                        PvPBattleManager.getMain().disableButton(this._actionBar[("senjutsu_" + _local_2)].holder);
                    }
                    else
                    {
                        this._actionBar[("senjutsu_" + _local_2)].cdTxt.text = "";
                        PvPBattleManager.getMain().enableButton(this._actionBar[("senjutsu_" + _local_2)].holder);
                    };
                    if (_local_3 == -1)
                    {
                        this._actionBar[("senjutsu_" + _local_2)].cdTxt.text = "";
                        PvPBattleManager.getMain().disableButton(this._actionBar[("senjutsu_" + _local_2)].holder);
                    };
                };
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < this._character_talent_skills_info.length)
            {
                _local_4 = this._character_talent_skills_info[_local_2].action_bar_prefix;
                _local_5 = this._character_talent_skills_info[_local_2].mc_index;
                _local_6 = this._character_talent_skills_mc[_local_5];
                if (_arg_1.hasOwnProperty(_local_6.skill_info.skill_id))
                {
                    _local_3 = _arg_1[_local_6.skill_info.skill_id].cd;
                    if (_local_3 != 0)
                    {
                        this._actionBar[_local_4].cdTxt.text = _local_3;
                        PvPBattleManager.getMain().disableButton(this._actionBar[_local_4].holder);
                    }
                    else
                    {
                        this._actionBar[_local_4].cdTxt.text = "";
                        PvPBattleManager.getMain().enableButton(this._actionBar[_local_4].holder);
                    };
                    if (_local_3 == -1)
                    {
                        this._actionBar[_local_4].cdTxt.text = "";
                        PvPBattleManager.getMain().disableButton(this._actionBar[_local_4].holder);
                    };
                };
                _local_2++;
            };
            if (this._special_skill_handler)
            {
                if (_arg_1.hasOwnProperty(this._special_skill_handler.skill_info.skill_id))
                {
                    _local_3 = _arg_1[this._special_skill_handler.skill_info.skill_id].cd;
                    if (_local_3 != 0)
                    {
                        this._actionBar["btnClassSkill_1"].cdTxt.text = _local_3;
                        PvPBattleManager.getMain().disableButton(this._actionBar["btnClassSkill_1"].holder);
                    }
                    else
                    {
                        this._actionBar["btnClassSkill_1"].cdTxt.text = "";
                        PvPBattleManager.getMain().enableButton(this._actionBar["btnClassSkill_1"].holder);
                    };
                    if (_local_3 == -1)
                    {
                        this._actionBar["btnClassSkill_1"].cdTxt.text = "";
                        PvPBattleManager.getMain().disableButton(this._actionBar["btnClassSkill_1"].holder);
                    };
                };
            };
        }

        public function updateScrollsDisplay():void
        {
            var _local_4:int;
            var _local_1:* = PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber];
            if (_local_1.getScrolls() <= 0)
            {
                return;
            };
            var _local_2:MovieClip = PvPBattleManager.getBattle()[("scrollDisplayMc_" + this._playerNumber)];
            var _local_3:* = _local_1.getScrolls();
            _local_2.visible = true;
            if (((_local_2) && (_local_3)))
            {
                _local_4 = 1;
                while (_local_4 <= 5)
                {
                    _local_2[("scroll_" + _local_4)].gotoAndStop(2);
                    if (_local_4 <= _local_3)
                    {
                        _local_2[("scroll_" + _local_4)].gotoAndStop(1);
                    };
                    _local_4++;
                };
            };
        }

        public function getCooldownInfo(_arg_1:String):Object
        {
            return (this._cooldown_info[_arg_1]);
        }

        public function hideCharacterMc():void
        {
            var _local_1:* = PvPBattleManager.getBattle().getObjectHolder(this._team, this._playerNumber).charMc;
            var _local_2:* = PvPBattleManager.getBattle().getObjectHolder(this._team, this._playerNumber).skillMc;
            _local_1.visible = false;
            _local_2.visible = true;
            OutfitManager.removeChildsFromMovieClips(_local_2);
        }

        public function showCharacterMc():void
        {
            PvPBattleManager.getBattle().getObjectHolder(this._team, this._playerNumber).charMc.visible = true;
            PvPBattleManager.getBattle().getObjectHolder(this._team, this._playerNumber).skillMc.visible = false;
        }

        public function onWeaponAttack(_arg_1:MouseEvent):void
        {
            Log.info(this, "onWeaponAttack", _arg_1);
            PvPSocket.getInstance().emit("Battle.action.weapon", {"battle_id":PvPBattleManager.getBattleID()});
            this.hideActionBar();
        }

        public function onDodgeTurn(_arg_1:MouseEvent):void
        {
            Log.info(this, "onDodgeTurn", _arg_1);
            PvPSocket.getInstance().emit("Battle.action.dodge", {"battle_id":PvPBattleManager.getBattleID()});
            PvPBattleManager.BATTLE_HANDLER.stopTurnTimer();
            this.hideActionBar();
        }

        public function onChargeUsed(_arg_1:MouseEvent):void
        {
            Log.info(this, "onChargeUsed", _arg_1);
            PvPSocket.getInstance().emit("Battle.action.charge", {"battle_id":PvPBattleManager.getBattleID()});
            this.hideActionBar();
        }

        public function onRun(_arg_1:MouseEvent):void
        {
            this._confirmation = new Confirmation();
            this._confirmation.txtMc.txt.text = "Are you sure you want to run?";
            this._eventHandler.addListener(this._confirmation.btn_confirm, MouseEvent.CLICK, this.onRunConfirm);
            this._eventHandler.addListener(this._confirmation.btn_close, MouseEvent.CLICK, this.onRunClose);
            PvPBattleManager.getMain().loader.addChild(this._confirmation);
        }

        public function onRunClose(_arg_1:MouseEvent):void
        {
            Log.info(this, "onRunClose", _arg_1);
            GF.removeAllChild(this._confirmation);
            this._confirmation = null;
        }

        public function onRunConfirm(_arg_1:MouseEvent):void
        {
            Log.info(this, "onRunConfirm", _arg_1);
            this.onRunClose(null);
            PvPSocket.getInstance().emit("Battle.action.run", {"battle_id":PvPBattleManager.getBattleID()});
            this.hideActionBar();
        }

        public function toggleSenjutsu(_arg_1:MouseEvent):*
        {
            if (this._actionBar["senjutsu_1"].visible)
            {
                this.hideSenjutsu();
            }
            else
            {
                this.showSenjutsu();
            };
        }

        public function playCopySkill(_arg_1:String):void
        {
            this._copy_skill_id = _arg_1;
            PvPBattleManager.getMain().loadSkillSWF(_arg_1, this.copySkillSWFLoaded);
        }

        public function copySkillSWFLoaded(_arg_1:*):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            var _local_3:Object = SkillLibrary.getCopy(this._copy_skill_id);
            if (_local_3.skill_type == "9")
            {
                _local_3 = TalentSkillLevel.getTalentSkillLevels(this._copy_skill_id, PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getTalentLevel(this._copy_skill_id));
            };
            if (_local_3.skill_type == "11")
            {
                _local_3 = SenjutsuSkillLevel.getSenjutsuSkillLevels(this._copy_skill_id, PvPBattleManager.CHARACTER_MANAGERS[this._team][this._playerNumber].getSenjutsuLevel(this._copy_skill_id));
            };
            _local_3.skill_id = this._copy_skill_id;
            if (this._copy_skill_handler)
            {
                this._copy_skill_handler.destroy();
                this._copy_skill_handler = null;
            };
            var _local_4:* = _arg_1.target.content[this._copy_skill_id];
            _local_4.gotoAndStop(1);
            {
                _local_4.stopAllMovieClips();
            };
            this._copy_skill_handler = new PvPSkillHandler(_local_4, this._team, this._playerNumber, _local_3);
            this.playSkill(this._copy_skill_id);
        }

        public function playSkill(_arg_1:String):void
        {
            var _local_2:* = this.getSkillHandlerByID(_arg_1);
            if (!_local_2)
            {
                Log.error(this, "playSkill", "Skill handler not found:", _arg_1);
                return;
            };
            this.hideCharacterMc();
            this.checkFillOutfit(_local_2);
            _local_2.setPositionAndAttack(this._team, this._playerNumber, this._playerNumber, false);
            var _local_3:* = PvPBattleManager.getBattle().getObjectHolder(this._team, this._playerNumber).skillMc;
            _local_3.addChild(_local_2.skill_mc);
            _local_2.skill_mc.gotoAndPlay(1);
        }

        public function getSkillHandlerByID(_arg_1:String):PvPSkillHandler
        {
            var _local_3:*;
            var _local_4:*;
            if (((this._special_skill_handler) && (this._special_skill_handler.skill_info.skill_id == _arg_1)))
            {
                return (this._special_skill_handler);
            };
            if (((this._copy_skill_handler) && (this._copy_skill_handler.skill_info.skill_id == _arg_1)))
            {
                return (this._copy_skill_handler);
            };
            var _local_2:Array = [this._character_skills_mc, this._character_talent_skills_mc, this._character_senjutsu_skills_mc];
            for each (_local_3 in _local_2)
            {
                for each (_local_4 in _local_3)
                {
                    if (_local_4.skill_info.skill_id == _arg_1)
                    {
                        return (_local_4);
                    };
                };
            };
            return (null);
        }

        public function getActionBar():MovieClip
        {
            return (this._actionBar);
        }

        public function destroy():void
        {
            if (this._destroyed)
            {
                return;
            };
            if (this._eventHandler)
            {
                this._eventHandler.removeAllEventListeners();
                this._eventHandler = null;
            };
            if (this._character_skills_mc)
            {
                GF.destroyArray(this._character_skills_mc);
            };
            if (this._character_talent_skills_mc)
            {
                GF.destroyArray(this._character_talent_skills_mc);
            };
            if (this._character_senjutsu_skills_mc)
            {
                GF.destroyArray(this._character_senjutsu_skills_mc);
            };
            if (this._special_skill_handler)
            {
                this._special_skill_handler.destroy();
                this._special_skill_handler = null;
            };
            if (this._skill_icons)
            {
                GF.destroyArray(this._skill_icons);
                this._skill_icons = null;
            };
            if (this._talent_icons)
            {
                GF.destroyArray(this._talent_icons);
                this._talent_icons = null;
            };
            if (this._senjutsu_icons)
            {
                GF.destroyArray(this._senjutsu_icons);
                this._senjutsu_icons = null;
            };
            if (this._special_skill_icon)
            {
                GF.removeAllChild(this._special_skill_icon);
                this._special_skill_icon = null;
            };
            if (this._character_talent_passive_skills_mc)
            {
                GF.clearArray(this._character_talent_passive_skills_mc);
                this._character_talent_passive_skills_mc = null;
            };
            if (this._character_senjutsu_passive_skills_mc)
            {
                GF.clearArray(this._character_senjutsu_passive_skills_mc);
                this._character_senjutsu_passive_skills_mc = null;
            };
            if (this._character_talent_skills_info)
            {
                GF.clearArray(this._character_talent_skills_info);
                this._character_talent_skills_info = null;
            };
            if (this._character_senjutsu_skills_info)
            {
                GF.clearArray(this._character_senjutsu_skills_info);
                this._character_senjutsu_skills_info = null;
            };
            if (this._copy_skill_handler)
            {
                this._copy_skill_handler.destroy();
                this._copy_skill_handler = null;
            };
            this._equippedSkills = null;
            this._cooldown_info = null;
            this._character_senjutsu_passive_skills_mc = null;
            this._character_skills_mc = null;
            this._character_talent_skills_mc = null;
            this._loading_skill_id = null;
            this._special_skill_id = null;
            this._team = null;
            this._actionBar = null;
            this._destroyed = true;
        }


    }
}//package id.ninjasage.pvp.battle

