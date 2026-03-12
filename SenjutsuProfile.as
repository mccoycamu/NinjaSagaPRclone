// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.SenjutsuProfile

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import com.abrahamyan.liquid.ToolTip;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Storage.SenjutsuSkillDescriptions;
    import com.utils.GF;
    import Managers.NinjaSage;
    import Storage.SenjutsuSkillLevel;
    import Storage.SenjutsuLevelLearnRequirements;
    import flash.system.System;

    public dynamic class SenjutsuProfile extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var currentPage:int = 1;
        private var totalPage:int = 1;
        private var selectedCategorySkill:Array;
        private var selectedCategoryType:String;
        private var tooltip:ToolTip;
        private var selectedBuySS:int;
        private var upgradeSkillId:String;
        private var upgradePrice:int;
        private var upgradeSkillLevel:int;
        private var removingSkill:Boolean = false;
        private var openType:String;
        private var maxEquipableSlot:int;
        private var isMax:Boolean = false;
        private var upgradeBtnData:Object;

        private var senjutsuSkills:Array = [];
        private var senjutsuOther:Array = [];
        private var iconCollection:Array = [];
        private var toolTipInfoHolder:Array = [];
        private var senjutsuEquippedSkills:Array = [];
        private var sageScrollShop:Array = [];

        public function SenjutsuProfile(_arg_1:*, _arg_2:*, _arg_3:*="equip")
        {
            this.sageScrollShop = [{
                "price":20,
                "amount":10
            }, {
                "price":100,
                "amount":55
            }, {
                "price":200,
                "amount":120
            }, {
                "price":400,
                "amount":250
            }];
            super();
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.openType = _arg_3;
            this.eventHandler = new EventHandler();
            this.tooltip = ToolTip.getInstance();
            this.main.handleVillageHUDVisibility(false);
            this.getSenjutsuFromAmf();
        }

        private function getSenjutsuFromAmf():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("SenjutsuService.getSenjutsuSkills", [Character.char_id, Character.sessionkey], this.onAmfResponse);
        }

        private function onAmfResponse(_arg_1:Object):*
        {
            var _local_2:*;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.senjutsuSkills = [];
                this.senjutsuOther = [];
                this.toolTipInfoHolder = [];
                _local_2 = 0;
                while (_local_2 < _arg_1.data.length)
                {
                    if (_arg_1.data[_local_2].type == Character.character_senjutsu)
                    {
                        this.senjutsuSkills.push(_arg_1.data[_local_2]);
                    }
                    else
                    {
                        this.senjutsuOther.push(_arg_1.data[_local_2]);
                    };
                    _local_2++;
                };
                this.getBasicData();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                    this.destroy();
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function getBasicData():*
        {
            if (Character.character_senjutsu != null)
            {
                this.selectedCategorySkill = this.senjutsuSkills;
                this.selectedCategoryType = Character.character_senjutsu;
            }
            else
            {
                this.selectedCategorySkill = this.senjutsuOther;
                this.selectedCategoryType = "other";
            };
            if (this.openType == "equip")
            {
                this.panelMC.gotoAndStop("install_toad_snake");
                this.setEquipModeButton();
                this.initEquipUI();
            }
            else
            {
                if (Character.character_senjutsu == null)
                {
                    this.panelMC.gotoAndStop("install_toad_snake");
                }
                else
                {
                    this.panelMC.gotoAndStop(("show_" + Character.character_senjutsu));
                    this.initBasicUpgradeUI();
                };
            };
        }

        private function initBasicUpgradeUI():*
        {
            this.panelMC.panelMC.upgradeSenjutsuMc.gotoAndStop("idle");
            this.panelMC.panelMC.confirmBox.gotoAndStop("idle");
            this.panelMC.panelMC.getSsMc.gotoAndStop("idle");
            this.panelMC.panelMC.txtTitle.text = ((Character.character_senjutsu.charAt(0).toUpperCase() + Character.character_senjutsu.substring(1)) + " Sage");
            this.panelMC.panelMC.txtSs.text = String(Character.character_ss);
            this.main.initButton(this.panelMC.panelMC.btnConvert, this.buySageScroll, "Boost SS");
            this.main.initButton(this.panelMC.panelMC.btnTraining, this.openMissionRoom, "SS Training");
            this.main.initButton(this.panelMC.panelMC.btnReset, this.openResetSenjutsu, "Reset");
            this.eventHandler.addListener(this.panelMC.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            if (Character.character_senjutsu == "toad")
            {
                this.panelMC.panelMC.txtTreeName.text = "Toad Sage Mode";
                this.panelMC.panelMC.txtTreeDesc.text = "The sage mode come from the Toad Hill, learn it from the Old Huge Toad. Toad Senjutsu can make our body become stronger and damage become more higher.";
            }
            else
            {
                this.panelMC.panelMC.txtTreeName.text = "Snake Sage Mode";
                this.panelMC.panelMC.txtTreeDesc.text = "The sage mode come from the Snake Cave, learn it from the Snake God. Snake Senjutsu can make help for you skill usage.";
            };
            this.loadSkillTree();
        }

        private function loadSkillTree():*
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_1:* = 0;
            while (_local_1 < 10)
            {
                _local_2 = ((("senjutsu_" + this.selectedCategoryType) + "_skill_") + int((_local_1 + 1)));
                _local_3 = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(_local_2);
                GF.removeAllChild(this.panelMC.panelMC[("skill_" + _local_1)].skill.holder);
                this.panelMC.panelMC[("skill_" + _local_1)].skill.gotoAndStop("enable");
                this.panelMC.panelMC[("skill_" + _local_1)].McSenjutsu_lv.txtSkillLevel.text = "--/--";
                this.panelMC.panelMC[("skill_" + _local_1)].btnUpgrade.visible = false;
                _local_4 = this.getCurrentSkillInfo(_local_3.id, Character.character_senjutsu);
                if (_local_4)
                {
                    this.panelMC.panelMC[("skill_" + _local_1)].McSenjutsu_lv.txtSkillLevel.text = (("Lv. " + _local_4.level) + "/10");
                    if (_local_4.level < 10)
                    {
                        if (this.canLvlUP(_local_3, Character.character_senjutsu))
                        {
                            this.panelMC.panelMC[("skill_" + _local_1)].skill.gotoAndStop("enable");
                            NinjaSage.loadIconSWF("skills", _local_3.id, this.panelMC.panelMC[("skill_" + _local_1)].skill.holder, "with_holder");
                            this.panelMC.panelMC[("skill_" + _local_1)].btnUpgrade.visible = true;
                            this.main.initButton(this.panelMC.panelMC[("skill_" + _local_1)].btnUpgrade, this.showNewLevelInfo, "");
                            this.panelMC.panelMC[("skill_" + _local_1)].btnUpgrade.id = _local_3.id;
                            this.panelMC.panelMC[("skill_" + _local_1)].btnUpgrade.level = _local_4.level;
                            this.panelMC.panelMC[("skill_" + _local_1)].btnUpgrade.skill_target = _local_2;
                        }
                        else
                        {
                            this.panelMC.panelMC[("skill_" + _local_1)].skill.gotoAndStop("question_mark");
                        };
                    }
                    else
                    {
                        NinjaSage.loadIconSWF("skills", _local_3.id, this.panelMC.panelMC[("skill_" + _local_1)].skill.holder, "with_holder");
                        this.eventHandler.addListener(this.panelMC.panelMC[("skill_" + _local_1)], MouseEvent.CLICK, this.showFullLevelInfo);
                        this.panelMC.panelMC[("skill_" + _local_1)].btnUpgrade.visible = false;
                        this.panelMC.panelMC[("skill_" + _local_1)].id = _local_3.id;
                        this.panelMC.panelMC[("skill_" + _local_1)].skill_target = _local_2;
                    };
                    _local_5 = SenjutsuSkillLevel.getSenjutsuSkillLevels(_local_4.id, _local_4.level);
                    this.toolTipInfoHolder.push([_local_5.name, _local_4.level, _local_5.damage, _local_5.sp_cost, _local_5.cooldown, _local_5.description]);
                    this.eventHandler.addListener(this.panelMC.panelMC[("skill_" + _local_1)].skill, MouseEvent.ROLL_OVER, this.toolTiponOverUpgrade);
                    this.eventHandler.addListener(this.panelMC.panelMC[("skill_" + _local_1)].skill, MouseEvent.ROLL_OUT, this.toolTiponOut);
                }
                else
                {
                    this.panelMC.panelMC[("skill_" + _local_1)].McSenjutsu_lv.txtSkillLevel.text = "Lv. 0/10";
                    if (this.canLvlUP(_local_3, Character.character_senjutsu))
                    {
                        this.panelMC.panelMC[("skill_" + _local_1)].skill.gotoAndStop("enable");
                        NinjaSage.loadIconSWF("skills", _local_3.id, this.panelMC.panelMC[("skill_" + _local_1)].skill.holder, "with_holder");
                        this.panelMC.panelMC[("skill_" + _local_1)].btnUpgrade.visible = true;
                        this.main.initButton(this.panelMC.panelMC[("skill_" + _local_1)].btnUpgrade, this.showNewLevelInfo, "");
                        this.panelMC.panelMC[("skill_" + _local_1)].btnUpgrade.id = _local_3.id;
                        this.panelMC.panelMC[("skill_" + _local_1)].btnUpgrade.level = 0;
                        this.panelMC.panelMC[("skill_" + _local_1)].btnUpgrade.skill_target = _local_2;
                    }
                    else
                    {
                        this.panelMC.panelMC[("skill_" + _local_1)].skill.gotoAndStop("question_mark");
                    };
                    _local_5 = SenjutsuSkillLevel.getSenjutsuSkillLevels(_local_3.id, _local_3.level);
                    this.toolTipInfoHolder.push([_local_3.name, _local_3.description]);
                    this.eventHandler.addListener(this.panelMC.panelMC[("skill_" + _local_1)].skill, MouseEvent.ROLL_OVER, this.toolTiponOverNotLearned);
                    this.eventHandler.addListener(this.panelMC.panelMC[("skill_" + _local_1)].skill, MouseEvent.ROLL_OUT, this.toolTiponOut);
                };
                _local_1++;
            };
        }

        private function showNewLevelInfo(_arg_1:MouseEvent):*
        {
            this.upgradeBtnData = _arg_1.currentTarget;
            this.panelMC.panelMC.upgradeSenjutsuMc.gotoAndStop("upgrade");
            var _local_2:MovieClip = this.panelMC.panelMC.upgradeSenjutsuMc.panelMC;
            this.main.initButton(_local_2.btnUpgrade, this.upgradeConfirmation, "Upgrade");
            this.main.initButton(_local_2.btnTrainMax, this.setMaxTrue, "Upgrade Max");
            this.eventHandler.addListener(_local_2.btnClose, MouseEvent.CLICK, this.closeUpgradePanel);
            this.setUpgradeInfo();
        }

        private function setUpgradeInfo():*
        {
            var _local_5:*;
            var _local_6:*;
            var _local_7:*;
            var _local_8:*;
            var _local_9:int;
            var _local_10:*;
            var _local_11:*;
            var _local_1:* = this.panelMC.panelMC.upgradeSenjutsuMc.panelMC;
            _local_1.skill_icon.gotoAndStop("enable");
            GF.removeAllChild(_local_1.skill_icon.holder);
            NinjaSage.loadIconSWF("skills", this.upgradeBtnData.id, _local_1.skill_icon.holder, "with_holder");
            this.upgradeSkillLevel = ((this.upgradeBtnData.level == 0) ? 1 : int(this.upgradeBtnData.level));
            var _local_2:* = SenjutsuSkillLevel.getSenjutsuSkillLevels(this.upgradeBtnData.id, this.upgradeSkillLevel);
            var _local_3:* = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(this.upgradeBtnData.skill_target);
            var _local_4:* = SenjutsuLevelLearnRequirements.getSkillRequirements(((this.upgradeBtnData.level == 0) ? 1 : int((this.upgradeSkillLevel + 1))));
            this.upgradePrice = _local_4.ss;
            this.upgradeSkillId = this.upgradeBtnData.id;
            if (this.upgradeSkillLevel < 10)
            {
                if (this.isMax)
                {
                    _local_8 = 0;
                    _local_9 = int(Character.character_ss);
                    _local_10 = ((this.upgradeBtnData.level == 0) ? 0 : int(this.upgradeBtnData.level));
                    while (_local_10 < 10)
                    {
                        _local_7 = (_local_10 + 1);
                        _local_11 = SenjutsuLevelLearnRequirements.getSkillRequirements(_local_7).ss;
                        if ((_local_8 + _local_11) > _local_9)
                        {
                            _local_7 = _local_10;
                            break;
                        };
                        _local_8 = (_local_8 + _local_11);
                        _local_10++;
                    };
                    this.upgradeSkillLevel = _local_7;
                    this.upgradePrice = _local_8;
                };
                _local_5 = SenjutsuSkillLevel.getSenjutsuSkillLevels(this.upgradeBtnData.id, ((this.isMax) ? this.upgradeSkillLevel : int((this.upgradeSkillLevel + 1))));
                _local_6 = ((_local_5.cooldown == 0) ? "(Passive Skill)" : "(Active Skill)");
                _local_1.txtSubName.text = _local_6;
                _local_1.currDamageTxt.text = _local_2.damage;
                _local_1.currSPTxt.text = _local_2.sp_cost;
                _local_1.currCooldownTxt.text = _local_2.cooldown;
                _local_1.currskillTxt.text = _local_2.description;
                _local_1.nextDamageTxt.text = _local_5.damage;
                _local_1.nextSPTxt.text = _local_5.sp_cost;
                _local_1.nextCooldownTxt.text = _local_5.cooldown;
                _local_1.nextskillTxt.text = _local_5.description;
            }
            else
            {
                _local_5 = SenjutsuSkillLevel.getSenjutsuSkillLevels(this.upgradeBtnData.id, this.upgradeSkillLevel);
                _local_1.currDamageTxt.text = "0";
                _local_1.currSPTxt.text = "0";
                _local_1.currCooldownTxt.text = "0";
                _local_1.currskillTxt.text = "";
                _local_1.nextDamageTxt.text = _local_5.damage;
                _local_1.nextSPTxt.text = _local_5.sp_cost;
                _local_1.nextCooldownTxt.text = _local_5.cooldown;
                _local_1.nextskillTxt.text = _local_5.description;
            };
            _local_1.txtSenjutsuName.text = _local_5.name;
            _local_1.txtSenjutsuDesc.text = _local_3.description;
            _local_1.lbl_char_ss.text = "You have ";
            _local_1.ssTxt.text = String(Character.character_ss);
            _local_1.txtCurrLv.text = ("Level " + String(this.upgradeBtnData.level));
            _local_1.nextSkillLv.text = ("Level " + String(((this.isMax) ? this.upgradeSkillLevel : int((this.upgradeBtnData.level + 1)))));
            _local_1.txtCurrDamage.text = "Damage";
            _local_1.txtCurrSP.text = "SP Cost";
            _local_1.txtCurrCooldown.text = "Cooldown";
            _local_1.lbl_nextDamage.text = "Damage";
            _local_1.lbl_nextSP.text = "SP Cost";
            _local_1.lbl_nextCooldown.text = "Cooldown";
            _local_1.lbl_ss_cost.text = "Upgrade Cost: ";
            _local_1.bpPrice.text = (this.upgradePrice + " SS");
        }

        public function setMaxTrue(_arg_1:MouseEvent):void
        {
            this.isMax = (!(this.isMax));
            var _local_2:String = ((this.isMax) ? "Normal" : "Upgrade Max");
            var _local_3:MovieClip = this.panelMC.panelMC.upgradeSenjutsuMc.panelMC;
            this.main.initButton(_local_3.btnTrainMax, this.setMaxTrue, _local_2);
            this.setUpgradeInfo();
        }

        private function showFullLevelInfo(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget;
            this.panelMC.panelMC.upgradeSenjutsuMc.gotoAndStop("maximumLevel");
            var _local_3:* = this.panelMC.panelMC.upgradeSenjutsuMc.panelMC;
            _local_3.skill_icon.gotoAndStop("enable");
            GF.removeAllChild(_local_3.skill_icon.holder);
            NinjaSage.loadIconSWF("skills", _local_2.id, _local_3.skill_icon.holder, "with_holder");
            var _local_4:* = SenjutsuSkillLevel.getSenjutsuSkillLevels(_local_2.id, "10");
            var _local_5:* = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(_local_2.skill_target);
            var _local_6:* = ((_local_4.cooldown == 0) ? "(Passive Skill)" : "(Active Skill)");
            _local_3.txtSenjutsuName.text = _local_4.name;
            _local_3.txtSubName.text = _local_6;
            _local_3.txtSenjutsuDesc.text = _local_5.description;
            _local_3.txtCurrLv.text = "Level 10";
            _local_3.txtCurrDamage.text = "Damage";
            _local_3.txtCurrSP.text = "SP Cost";
            _local_3.txtCurrCooldown.text = "Cooldown";
            _local_3.currDamageTxt.text = _local_4.damage;
            _local_3.currSPTxt.text = _local_4.sp_cost;
            _local_3.currCooldownTxt.text = _local_4.cooldown;
            _local_3.currskillTxt.text = _local_4.description;
            this.eventHandler.addListener(_local_3.btnClose, MouseEvent.CLICK, this.closeUpgradePanel);
        }

        private function upgradeConfirmation(_arg_1:MouseEvent):*
        {
            var _local_2:* = this.panelMC.panelMC.confirmBox;
            _local_2.gotoAndStop("show");
            _local_2.okBtn.visible = false;
            _local_2.displayTxt.text = ((((("Are you sure want to use " + this.upgradePrice) + " SS to Upgrade ") + this.panelMC.panelMC.upgradeSenjutsuMc.panelMC.txtSenjutsuName.text) + " to level ") + this.upgradeSkillLevel);
            this.eventHandler.addListener(_local_2.yesBtn, MouseEvent.CLICK, this.upgradeAMF);
            this.eventHandler.addListener(_local_2.noBtn, MouseEvent.CLICK, this.closeConfirmationBox);
        }

        private function upgradeAMF(_arg_1:MouseEvent):*
        {
            this.main.amf_manager.service("SenjutsuService.upgradeSkill", [Character.char_id, Character.sessionkey, this.upgradeSkillId, ((this.isMax) ? 1 : 0)], this.onUpgradedSenjutsu);
        }

        private function onUpgradedSenjutsu(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                Character.character_ss = int(String((int(Character.character_ss) - _arg_1.spent_ss)));
                this.panelMC.panelMC.confirmBox.gotoAndStop("idle");
                this.panelMC.panelMC.upgradeSenjutsuMc.gotoAndStop("idle");
                this.isMax = false;
                this.getSenjutsuFromAmf();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function closeUpgradePanel(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.panelMC.panelMC.upgradeSenjutsuMc.panelMC.skill_icon.holder);
            this.isMax = false;
            this.panelMC.panelMC.upgradeSenjutsuMc.gotoAndStop("idle");
        }

        private function closeConfirmationBox(_arg_1:MouseEvent):*
        {
            this.panelMC.panelMC.confirmBox.displayTxt.text = "";
            this.panelMC.panelMC.confirmBox.gotoAndStop("idle");
        }

        public function getCurrentSkillInfo(_arg_1:String, _arg_2:String):*
        {
            var _local_3:* = 0;
            while (_local_3 < this.senjutsuSkills.length)
            {
                if (((this.senjutsuSkills[_local_3].id == _arg_1) && (this.senjutsuSkills[_local_3].type == _arg_2)))
                {
                    return (this.senjutsuSkills[_local_3]);
                };
                _local_3++;
            };
            return (false);
        }

        public function canLvlUP(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            var _local_5:* = true;
            if (("link1" in _arg_1))
            {
                if (((_local_3 = this.getCurrentSkillInfo(_arg_1.link1, _arg_2)) && (_local_3.level >= 5)))
                {
                    _local_5 = true;
                }
                else
                {
                    _local_5 = false;
                };
            };
            if ((("link2" in _arg_1) && (_local_5)))
            {
                if (((_local_4 = this.getCurrentSkillInfo(_arg_1.link2, _arg_2)) && (_local_4.level >= 5)))
                {
                    _local_5 = true;
                }
                else
                {
                    _local_5 = false;
                };
            };
            return (_local_5);
        }

        private function initEquipUI():*
        {
            if (((Character.character_equipped_senjutsu_skills == null) || (Character.character_equipped_senjutsu_skills == "")))
            {
                this.senjutsuEquippedSkills = [];
            }
            else
            {
                this.senjutsuEquippedSkills = Character.character_equipped_senjutsu_skills.split(",");
            };
            this.panelMC.txtTitle.text = ((Character.character_senjutsu != null) ? ((Character.character_senjutsu.charAt(0).toUpperCase() + Character.character_senjutsu.substring(1)) + " Sage") : "Sage");
            this.panelMC.txtSkillName.text = "";
            this.panelMC.txtSkillDesc.text = "";
            this.panelMC.pageTxt.text = "1/1";
            this.panelMC.tagOther.gotoAndStop("unselect");
            this.totalPage = Math.ceil((this.selectedCategorySkill.length / 8));
            this.checkEquipableSlot();
            if (Character.character_senjutsu == null)
            {
                this.panelMC.tagBackgroundMc.gotoAndStop("other");
                this.selectedCategorySkill = this.senjutsuOther;
                this.selectedCategoryType = "other";
            };
            this.loadSenjutsuSkill();
            this.loadEquippedSkills();
        }

        private function checkEquipableSlot():*
        {
            if (int(Character.character_lvl) >= 80)
            {
                this.maxEquipableSlot = (int(((int(Character.character_lvl) - 80) / 10)) + 4);
            };
            var _local_1:* = 0;
            while (_local_1 < 8)
            {
                this.panelMC[("skill_" + _local_1)].gotoAndStop("enable");
                _local_1++;
            };
            _local_1 = (int(((int(Character.character_lvl) - 80) / 10)) + 4);
            while (_local_1 < 8)
            {
                this.panelMC[("skill_" + _local_1)].gotoAndStop("disable");
                _local_1++;
            };
        }

        private function loadSenjutsuSkill():*
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            var _local_6:*;
            this.toolTipInfoHolder = [];
            var _local_1:* = 0;
            while (_local_1 < 8)
            {
                _local_2 = (_local_1 + int((int((this.currentPage - 1)) * 8)));
                if (this.selectedCategorySkill.length > _local_2)
                {
                    this.panelMC[("learnedSenjutsu_" + _local_1)].visible = true;
                    _local_3 = this.getSenjutsuSkillOrder(this.selectedCategorySkill[_local_2].id, this.selectedCategorySkill[_local_2].type);
                    _local_4 = ((("senjutsu_" + this.selectedCategoryType) + "_skill_") + _local_3);
                    _local_5 = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(_local_4);
                    _local_6 = SenjutsuSkillLevel.getSenjutsuSkillLevels(this.selectedCategorySkill[_local_2].id, this.selectedCategorySkill[_local_2].level);
                    this.panelMC[("learnedSenjutsu_" + _local_1)].Senjutsu.gotoAndStop("enable");
                    this.panelMC[("learnedSenjutsu_" + _local_1)].txtSkillName.text = _local_5.name;
                    this.panelMC[("learnedSenjutsu_" + _local_1)].lvMc.txtLevel.text = this.selectedCategorySkill[_local_2].level;
                    if (!this.removingSkill)
                    {
                        GF.removeAllChild(this.panelMC[("learnedSenjutsu_" + _local_1)].Senjutsu.holder);
                        NinjaSage.loadIconSWF("skills", this.selectedCategorySkill[_local_2].id, this.panelMC[("learnedSenjutsu_" + _local_1)].Senjutsu.holder, "with_holder");
                    };
                    this.toolTipInfoHolder.push([_local_6.name, this.selectedCategorySkill[_local_2].level, _local_6.damage, _local_6.sp_cost, _local_6.cooldown, _local_6.description]);
                    if (this.checkEquipped(this.selectedCategorySkill[_local_2].id))
                    {
                        this.panelMC[("learnedSenjutsu_" + _local_1)].btnEquip.visible = false;
                        this.panelMC[("learnedSenjutsu_" + _local_1)].txtSkillEquipped.visible = true;
                        this.panelMC[("learnedSenjutsu_" + _local_1)].txtSkillEquipped.text = "Equipped";
                    }
                    else
                    {
                        this.panelMC[("learnedSenjutsu_" + _local_1)].btnEquip.visible = true;
                        this.panelMC[("learnedSenjutsu_" + _local_1)].txtSkillEquipped.visible = false;
                        this.main.initButton(this.panelMC[("learnedSenjutsu_" + _local_1)].btnEquip, this.equipSkill, "Equip");
                    };
                    if (_local_6.cooldown == 0)
                    {
                        this.panelMC[("learnedSenjutsu_" + _local_1)].btnEquip.visible = false;
                        this.panelMC[("learnedSenjutsu_" + _local_1)].txtSkillEquipped.visible = true;
                        this.panelMC[("learnedSenjutsu_" + _local_1)].txtSkillEquipped.text = "Passive";
                    };
                    this.eventHandler.addListener(this.panelMC[("learnedSenjutsu_" + _local_1)], MouseEvent.CLICK, this.showRightInfo);
                    this.eventHandler.addListener(this.panelMC[("learnedSenjutsu_" + _local_1)].Senjutsu, MouseEvent.ROLL_OVER, this.toolTiponOver);
                    this.eventHandler.addListener(this.panelMC[("learnedSenjutsu_" + _local_1)].Senjutsu, MouseEvent.ROLL_OUT, this.toolTiponOut);
                }
                else
                {
                    this.panelMC[("learnedSenjutsu_" + _local_1)].visible = false;
                };
                _local_1++;
            };
            this.removingSkill = false;
            this.updatePageNumber();
            this.totalPage = Math.ceil((this.selectedCategorySkill.length / 8));
        }

        private function getSenjutsuSkillOrder(_arg_1:String, _arg_2:String):int
        {
            var _local_5:*;
            var _local_6:*;
            var _local_3:* = ((_arg_2 == "other") ? 3 : 11);
            var _local_4:* = 1;
            while (_local_4 < 11)
            {
                _local_5 = ((("senjutsu_" + _arg_2) + "_skill_") + _local_4);
                _local_6 = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(_local_5);
                if (_local_6.id == _arg_1)
                {
                    return (_local_4);
                };
                _local_4++;
            };
            return (1);
        }

        private function showRightInfo(_arg_1:MouseEvent):*
        {
            var _local_2:int = _arg_1.currentTarget.name.replace("learnedSenjutsu_", "");
            var _local_3:int = (_local_2 + int((int((this.currentPage - 1)) * 8)));
            var _local_4:* = this.getSenjutsuSkillOrder(this.selectedCategorySkill[_local_3].id, this.selectedCategorySkill[_local_3].type);
            var _local_5:* = ((("senjutsu_" + this.selectedCategoryType) + "_skill_") + _local_4);
            var _local_6:* = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(_local_5);
            this.panelMC.txtSkillName.text = _local_6.name;
            this.panelMC.txtSkillDesc.text = _local_6.description;
        }

        private function checkEquipped(_arg_1:*):*
        {
            var _local_2:*;
            if (_arg_1 != null)
            {
                _local_2 = 0;
                while (_local_2 < this.senjutsuEquippedSkills.length)
                {
                    if (this.senjutsuEquippedSkills[_local_2] == _arg_1)
                    {
                        return (true);
                    };
                    _local_2++;
                };
                return (false);
            };
            return (false);
        }

        private function equipSkill(_arg_1:MouseEvent):*
        {
            if (((this.senjutsuEquippedSkills.length >= this.maxEquipableSlot) || (this.senjutsuEquippedSkills.length >= 8)))
            {
                return;
            };
            var _local_2:int = _arg_1.currentTarget.parent.name.replace("learnedSenjutsu_", "");
            var _local_3:int = (_local_2 + int((int((this.currentPage - 1)) * 8)));
            this.panelMC[("learnedSenjutsu_" + _local_2)].btnEquip.visible = false;
            this.panelMC[("learnedSenjutsu_" + _local_2)].txtSkillEquipped.visible = true;
            this.panelMC[("learnedSenjutsu_" + _local_2)].txtSkillEquipped.text = "Equipped";
            this.senjutsuEquippedSkills.push(this.selectedCategorySkill[_local_3].id);
            this.loadEquippedSkills();
        }

        private function loadEquippedSkills():*
        {
            var _local_1:* = 0;
            while (_local_1 < this.senjutsuEquippedSkills.length)
            {
                this.panelMC[("skill_" + _local_1)].gotoAndStop("enable");
                GF.removeAllChild(this.panelMC[("skill_" + _local_1)].holder);
                NinjaSage.loadIconSWF("skills", this.senjutsuEquippedSkills[_local_1], this.panelMC[("skill_" + _local_1)].holder, "with_holder");
                _local_1++;
            };
        }

        private function removeEquippedSkill(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name.replace("btnClearSkill_", "");
            if (_local_2 >= this.senjutsuEquippedSkills.length)
            {
                return;
            };
            var _local_3:* = 0;
            while (_local_3 < 8)
            {
                GF.removeAllChild(this.panelMC[("skill_" + _local_3)].holder);
                _local_3++;
            };
            this.senjutsuEquippedSkills.splice(_local_2, 1);
            this.removingSkill = true;
            this.loadSenjutsuSkill();
            this.loadEquippedSkills();
        }

        private function updatePageNumber():*
        {
            this.panelMC.pageTxt.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function setEquipModeButton():*
        {
            this.panelMC.confirmBox.gotoAndStop(1);
            this.main.initButton(this.panelMC.btnReset, this.openResetSenjutsu, "Reset");
            this.eventHandler.addListener(this.panelMC.tagToad, MouseEvent.CLICK, this.changeCategory);
            this.eventHandler.addListener(this.panelMC.tagSnake, MouseEvent.CLICK, this.changeCategory);
            this.eventHandler.addListener(this.panelMC.tagOther, MouseEvent.CLICK, this.changeCategory);
            this.eventHandler.addListener(this.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btnNextPage, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btnPrevPage, MouseEvent.CLICK, this.changePage);
            if (Character.character_senjutsu == "toad")
            {
                this.panelMC.tagSnake.visible = false;
                this.panelMC.tagToad.buttonMode = true;
                this.panelMC.tagToad.gotoAndStop("select");
                this.panelMC.tagBackgroundMc.gotoAndStop("toad");
            }
            else
            {
                if (Character.character_senjutsu == "snake")
                {
                    this.panelMC.tagToad.visible = false;
                    this.panelMC.tagSnake.buttonMode = true;
                    this.panelMC.tagSnake.gotoAndStop("select");
                    this.panelMC.tagBackgroundMc.gotoAndStop("snake");
                }
                else
                {
                    this.panelMC.tagToad.visible = false;
                    this.panelMC.tagSnake.visible = false;
                    this.panelMC.tagBackgroundMc.gotoAndStop("other");
                };
            };
            this.panelMC.tagOther.buttonMode = true;
            var _local_1:* = 0;
            while (_local_1 < 8)
            {
                this.eventHandler.addListener(this.panelMC[("btnClearSkill_" + _local_1)], MouseEvent.CLICK, this.removeEquippedSkill);
                _local_1++;
            };
        }

        private function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btnNextPage":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.loadSenjutsuSkill();
                    };
                    break;
                case "btnPrevPage":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.loadSenjutsuSkill();
                    };
            };
            this.updatePageNumber();
        }

        private function changeCategory(_arg_1:MouseEvent):*
        {
            this.panelMC.tagToad.gotoAndStop("unselect");
            this.panelMC.tagSnake.gotoAndStop("unselect");
            this.panelMC.tagOther.gotoAndStop("unselect");
            _arg_1.currentTarget.gotoAndStop("select");
            var _local_2:* = _arg_1.currentTarget.name.replace("tag", "");
            if (_local_2 == "Toad")
            {
                this.panelMC.tagBackgroundMc.gotoAndStop("toad");
                this.selectedCategorySkill = this.senjutsuSkills;
                this.selectedCategoryType = Character.character_senjutsu;
            }
            else
            {
                if (_local_2 == "Snake")
                {
                    this.panelMC.tagBackgroundMc.gotoAndStop("snake");
                    this.selectedCategorySkill = this.senjutsuSkills;
                    this.selectedCategoryType = Character.character_senjutsu;
                }
                else
                {
                    this.panelMC.tagBackgroundMc.gotoAndStop("other");
                    this.selectedCategorySkill = this.senjutsuOther;
                    this.selectedCategoryType = "other";
                };
            };
            this.currentPage = 1;
            this.totalPage = Math.ceil((this.selectedCategorySkill.length / 8));
            this.updatePageNumber();
            this.loadSenjutsuSkill();
        }

        private function toolTiponOver(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.parent.name;
            _local_2 = _local_2.replace("learnedSenjutsu_", "");
            var _local_3:* = (((((((((((((((((((((("" + "<b>") + this.toolTipInfoHolder[_local_2][0]) + "</b>") + "\n(Senjutsu Skill)\n\nLevel: ") + this.toolTipInfoHolder[_local_2][1]) + "\n") + '<font color="#ff0000">') + "Damage: ") + this.toolTipInfoHolder[_local_2][2]) + "</font>") + "\n") + '<font color="#ff5300">') + "SP Cost: ") + this.toolTipInfoHolder[_local_2][3]) + "</font>") + "\n") + '<font color="#666666">') + "Cooldown: ") + this.toolTipInfoHolder[_local_2][4]) + "</font>") + "\n\n") + this.toolTipInfoHolder[_local_2][5]);
            this.main.stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_3);
        }

        private function toolTiponOverUpgrade(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.parent.name;
            _local_2 = _local_2.replace("skill_", "");
            var _local_3:* = (((((((((((((((((((((("" + "<b>") + this.toolTipInfoHolder[_local_2][0]) + "</b>") + "\n(Senjutsu Skill)\n\nLevel: ") + this.toolTipInfoHolder[_local_2][1]) + "\n") + '<font color="#ff0000">') + "Damage: ") + this.toolTipInfoHolder[_local_2][2]) + "</font>") + "\n") + '<font color="#ff5300">') + "SP Cost: ") + this.toolTipInfoHolder[_local_2][3]) + "</font>") + "\n") + '<font color="#666666">') + "Cooldown: ") + this.toolTipInfoHolder[_local_2][4]) + "</font>") + "\n\n") + this.toolTipInfoHolder[_local_2][5]);
            this.main.stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_3);
        }

        private function toolTiponOverNotLearned(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.parent.name;
            _local_2 = _local_2.replace("skill_", "");
            var _local_3:* = ((((("" + "<b>") + this.toolTipInfoHolder[_local_2][0]) + "</b>") + "\n\n") + this.toolTipInfoHolder[_local_2][1]);
            this.main.stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_3);
        }

        private function toolTiponOut(_arg_1:MouseEvent):*
        {
            this.tooltip.hide();
        }

        private function buySageScroll(_arg_1:MouseEvent):*
        {
            this.panelMC.panelMC.getSsMc.gotoAndStop("show");
            this.panelMC.panelMC.getSsMc.confirmBox.gotoAndStop(1);
            var _local_2:* = this.panelMC.panelMC.getSsMc.panelMC;
            _local_2.txtTitle.text = "Buy Sage Scroll";
            _local_2.yourTokenTxt.text = String(Character.account_tokens);
            _local_2.yourSSTxt.text = String(Character.character_ss);
            _local_2.lbl_question.text = "What is Sage Scroll?";
            _local_2.lbl_answer.text = "Sage Scroll (SS) is used to level up a senjutsu skill";
            var _local_3:* = 0;
            while (_local_3 < 4)
            {
                _local_2[("p" + _local_3)].gotoAndStop((_local_3 + _local_3));
                _local_2[("p" + _local_3)].highlight.gotoAndStop("idle");
                _local_2[("p" + _local_3)].ssTxt.text = this.sageScrollShop[_local_3].amount;
                _local_2[("p" + _local_3)].tokenTxt.text = this.sageScrollShop[_local_3].price;
                this.eventHandler.addListener(_local_2[("p" + _local_3)], MouseEvent.CLICK, this.setSelectedBuySS);
                _local_3++;
            };
            this.main.initButton(_local_2.convertBtn, this.openConfirmationBuySS, "Convert");
            this.eventHandler.addListener(_local_2.btnClose, MouseEvent.CLICK, this.closeBuySageScroll);
        }

        private function closeBuySageScroll(_arg_1:MouseEvent):*
        {
            var _local_2:* = 0;
            while (_local_2 < 4)
            {
                this.panelMC.panelMC.getSsMc.panelMC[("p" + _local_2)].highlight.gotoAndStop("idle");
                _local_2++;
            };
            this.panelMC.panelMC.getSsMc.gotoAndStop("idle");
        }

        private function setSelectedBuySS(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name.replace("p", "");
            var _local_3:* = 0;
            while (_local_3 < 4)
            {
                this.panelMC.panelMC.getSsMc.panelMC[("p" + _local_3)].highlight.gotoAndStop("idle");
                _local_3++;
            };
            _arg_1.currentTarget.highlight.gotoAndStop("show");
            this.selectedBuySS = _local_2;
        }

        private function openConfirmationBuySS(_arg_1:MouseEvent):*
        {
            var _local_2:*;
            if (this.selectedBuySS >= 0)
            {
                _local_2 = this.panelMC.panelMC.getSsMc.confirmBox;
                _local_2.gotoAndStop("show");
                _local_2.okBtn.visible = false;
                _local_2.displayTxt.text = (((("Are you sure want to buy " + this.sageScrollShop[this.selectedBuySS].amount) + " SS for ") + this.sageScrollShop[this.selectedBuySS].price) + " tokens");
                this.eventHandler.addListener(_local_2.yesBtn, MouseEvent.CLICK, this.buySageScrollAMF);
                this.eventHandler.addListener(_local_2.noBtn, MouseEvent.CLICK, this.closeConfirmationBoxSS);
            }
            else
            {
                this.main.showMessage("Select a package before convert");
            };
        }

        private function closeConfirmationBoxSS(_arg_1:MouseEvent):*
        {
            this.panelMC.panelMC.getSsMc.confirmBox.displayTxt.text = "";
            this.panelMC.panelMC.getSsMc.confirmBox.gotoAndStop("idle");
        }

        private function buySageScrollAMF(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("SenjutsuService.buyPackageSS", [Character.char_id, Character.sessionkey, this.selectedBuySS], this.onSageScrollBought);
        }

        private function onSageScrollBought(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.panelMC.panelMC.getSsMc.confirmBox.gotoAndStop("idle");
                Character.account_tokens = (int(Character.account_tokens) - int(this.sageScrollShop[this.selectedBuySS].price));
                Character.character_ss = int(_arg_1.ss);
                this.panelMC.panelMC.getSsMc.panelMC.yourTokenTxt.text = String(Character.account_tokens);
                this.panelMC.panelMC.getSsMc.panelMC.yourSSTxt.text = String(Character.character_ss);
                this.panelMC.panelMC.txtSs.text = String(Character.character_ss);
                this.main.showMessage(_arg_1.result);
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function openMissionRoom(_arg_1:MouseEvent):*
        {
            this.main.loadExternalSwfPanel("MissionRoom", "MissionRoom");
        }

        private function openResetSenjutsu(_arg_1:MouseEvent):*
        {
            this.main.loadExternalSwfPanel("ResetSenjutsu", "ResetSenjutsu");
            this.destroy();
        }

        private function openHelp(_arg_1:MouseEvent):*
        {
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            if (this.openType == "equip")
            {
                this.main.loading(true);
                this.main.amf_manager.service("SenjutsuService.equipSkill", [Character.char_id, Character.sessionkey, this.senjutsuEquippedSkills], this.onSenjutsuSkillEquipped);
            }
            else
            {
                this.destroy();
            };
        }

        private function onSenjutsuSkillEquipped(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.character_equipped_senjutsu_skills = _arg_1.skills;
                this.destroy();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        public function destroy():*
        {
            if (this.tooltip)
            {
                this.tooltip.destroy();
            };
            this.main.handleVillageHUDVisibility(true);
            this.main.removeExternalSwfPanel();
            this.currentPage = 1;
            this.totalPage = 1;
            this.selectedCategorySkill = null;
            this.selectedCategoryType = null;
            this.tooltip = null;
            this.selectedBuySS = 0;
            this.upgradeSkillId = null;
            this.upgradePrice = 0;
            this.upgradeSkillLevel = 0;
            this.removingSkill = false;
            this.openType = null;
            this.sageScrollShop = null;
            this.senjutsuSkills = null;
            this.senjutsuOther = null;
            this.iconCollection = null;
            this.toolTipInfoHolder = null;
            this.senjutsuEquippedSkills = null;
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

