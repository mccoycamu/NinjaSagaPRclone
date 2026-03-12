// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.TalentPanel

package Panels
{
    import flash.display.MovieClip;
    import Popups.TalentBoost;
    import flash.text.TextField;
    import Popups.TalentLvlUP;
    import Popups.TalentSkillInfo;
    import com.abrahamyan.liquid.ToolTip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Storage.TalentInfo;
    import Storage.TalentSkillDescriptions;
    import com.utils.GF;
    import Managers.NinjaSage;
    import Storage.TalentSkillLevel;

    public class TalentPanel extends MovieClip 
    {

        public var BloodlineMC:MovieClip;
        public var SecretMC_1:MovieClip;
        public var SecretMC_2:MovieClip;
        public var boost_mc:TalentBoost;
        public var btnBPMission:MovieClip;
        public var btnConvertBP:MovieClip;
        public var btnExit:MovieClip;
        public var btnReset:MovieClip;
        public var confirmBox:MovieClip;
        public var lbl_bloodline:TextField;
        public var lvl_up_mc:TalentLvlUP;
        public var skill_info_mc:TalentSkillInfo;
        public var yourBPTxt:TextField;
        public var main:*;
        public var tooltip:ToolTip;
        public var talent_skill:Array;
        public var tooltipExtreme:Object;
        public var tooltipSecret1:Object;
        public var tooltipSecret2:Object;
        public var eventHandler:EventHandler;
        private var ref:String;

        public function TalentPanel(_arg_1:*)
        {
            this.tooltipExtreme = {};
            this.tooltipSecret1 = {};
            this.tooltipSecret2 = {};
            this.main = _arg_1;
            this.tooltip = ToolTip.getInstance();
            this.eventHandler = new EventHandler();
            this.addChild(this.tooltip);
            this.loadEverything();
        }

        public function fetchTalents(_arg_1:*):*
        {
            this.main.amf_manager.service("TalentService.getTalentSkills", [Character.char_id, Character.sessionkey], _arg_1);
        }

        public function setTalentSkills(_arg_1:*):*
        {
            this.talent_skill = _arg_1;
        }

        public function loadEverything():*
        {
            this.main.loading(true);
            this.fetchTalents(this.onGotInfo);
        }

        public function onGotInfo(_arg_1:Object):*
        {
            this.main.loading(false);
            if (!_arg_1.hasOwnProperty("data"))
            {
                this.main.getNotice("Unable to get talent data");
                this.destroy();
                return;
            };
            this.setTalentSkills(_arg_1.data);
            this.addButtonListeners();
            this.setTexts();
            this.initMovieClips();
        }

        public function setTexts():*
        {
            this.yourBPTxt.text = String(Character.character_tp);
        }

        public function showConfirmationBox(_arg_1:*, _arg_2:*):*
        {
            this.confirmBox.visible = true;
            this.confirmBox.gotoAndStop("show");
            this.confirmBox.displayTxt.text = _arg_1;
            this.confirmBox.yesBtn.addEventListener(MouseEvent.CLICK, _arg_2);
            this.eventHandler.addListener(this.confirmBox.noBtn, MouseEvent.CLICK, this.closeConfirmBox);
        }

        public function closeConfirmBox(_arg_1:MouseEvent):*
        {
            this.confirmBox.visible = false;
        }

        public function initMovieClips():*
        {
            this.main.handleVillageHUDVisibility(false);
            this.lvl_up_mc.visible = false;
            this.boost_mc.visible = false;
            this.skill_info_mc.visible = false;
            if (Character.character_talent_1 != null)
            {
                this.BloodlineMC.gotoAndStop(Character.character_talent_1);
                this.fillUP();
            }
            else
            {
                this.BloodlineMC.gotoAndStop(1);
                this.main.initButton(this.BloodlineMC.btnDiscover, this.openDiscoverTalent, "Discover");
            };
            if (Character.character_talent_2 != null)
            {
                this.SecretMC_1.gotoAndStop("SecSkill_1");
                this.fillUPSecret();
            }
            else
            {
                this.SecretMC_1.gotoAndStop(1);
                this.main.initButton(this.SecretMC_1.btnDiscover, this.openDiscoverTalent, "Discover");
            };
            if (Character.character_talent_3 != null)
            {
                this.SecretMC_2.gotoAndStop("SecSkill_1");
                this.fillUPSecret2();
            }
            else
            {
                this.SecretMC_2.gotoAndStop(1);
                this.main.initButton(this.SecretMC_2.btnDiscover, this.openDiscoverTalent, "Discover");
            };
            this.confirmBox.gotoAndStop(1);
        }

        public function getCurrentSkillInfo(_arg_1:String, _arg_2:String):*
        {
            var _local_3:* = 0;
            while (_local_3 < this.talent_skill.length)
            {
                if (((this.talent_skill[_local_3].item_id == _arg_1) && (this.talent_skill[_local_3].talent_type == _arg_2)))
                {
                    return (this.talent_skill[_local_3]);
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
            if (("talent_link_skill_id" in _arg_1))
            {
                if (((_local_3 = this.getCurrentSkillInfo(_arg_1.talent_link_skill_id, _arg_2)) && (_local_3.item_level >= 5)))
                {
                    _local_5 = true;
                }
                else
                {
                    _local_5 = false;
                };
            };
            if ((("talent_link_skill_id2" in _arg_1) && (_local_5)))
            {
                if (((_local_4 = this.getCurrentSkillInfo(_arg_1.talent_link_skill_id2, _arg_2)) && (_local_4.item_level >= 5)))
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

        public function fillUP():*
        {
            var _local_1:* = undefined;
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            this.tooltipExtreme = {};
            var _local_5:* = TalentInfo.getTalentInfos(Character.character_talent_1);
            this.BloodlineMC.lbl_BLSkillName.text = _local_5.talent_name;
            var _local_6:* = 1;
            while (_local_6 < 7)
            {
                this.BloodlineMC[("skill_" + _local_6)].gotoAndStop("enable");
                this.BloodlineMC[("skill_" + _local_6)].typeIcon.gotoAndStop(1);
                _local_1 = ((("talent_" + Character.character_talent_1) + "_skill_") + _local_6);
                _local_2 = TalentSkillDescriptions.getTalentSkillDescriptions(_local_1);
                GF.removeAllChild(this.BloodlineMC[("skill_" + _local_6)].holder);
                this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtnDim.visible = false;
                this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtn.visible = false;
                this.BloodlineMC[("btnUpgrade_" + _local_6)].detailBtn.visible = false;
                this.BloodlineMC[("skillLvTxt_" + _local_6)].text = "Lv: 0/10";
                if (("talent_skill_id" in _local_2))
                {
                    if ((_local_3 = this.getCurrentSkillInfo(_local_2.talent_skill_id, Character.character_talent_1)))
                    {
                        this.BloodlineMC[("skillLvTxt_" + _local_6)].text = (("Lv. " + _local_3.item_level) + "/10");
                        if (_local_3.item_level < 10)
                        {
                            if (this.canLvlUP(_local_2, Character.character_talent_1))
                            {
                                NinjaSage.loadIconSWF("skills", _local_2.talent_skill_id, this.BloodlineMC[("skill_" + _local_6)].holder, "with_holder");
                                this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtn.visible = true;
                                this.main.initButton(this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtn, this.showNewLevelInfo);
                                this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtn.skill_id = _local_2.talent_skill_id;
                                this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtn.skill_level = _local_3.item_level;
                                this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtn.talent_skill_id = _local_1;
                            }
                            else
                            {
                                this.BloodlineMC[("skill_" + _local_6)].gotoAndStop("queston_mark");
                                this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtnDim.visible = true;
                            };
                        }
                        else
                        {
                            NinjaSage.loadIconSWF("skills", _local_2.talent_skill_id, this.BloodlineMC[("skill_" + _local_6)].holder, "with_holder");
                            this.BloodlineMC[("btnUpgrade_" + _local_6)].detailBtn.visible = true;
                            this.main.initButton(this.BloodlineMC[("btnUpgrade_" + _local_6)].detailBtn, this.showFullLevelInfo);
                            this.BloodlineMC[("btnUpgrade_" + _local_6)].detailBtn.skill_id = _local_2.talent_skill_id;
                            this.BloodlineMC[("btnUpgrade_" + _local_6)].detailBtn.talent_skill_id = _local_1;
                        };
                        _local_4 = TalentSkillLevel.getTalentSkillLevels(_local_2.talent_skill_id, _local_3.item_level);
                        this.BloodlineMC[("skill_" + String(_local_6))].metaData = {
                            "name":_local_4.talent_skill_name,
                            "description":_local_4.talent_skill_description,
                            "level":_local_3.item_level
                        };
                        this.eventHandler.addListener(this.BloodlineMC[("skill_" + String(_local_6))], MouseEvent.ROLL_OVER, this.toolTipTalent, false, 0, true);
                        this.eventHandler.addListener(this.BloodlineMC[("skill_" + String(_local_6))], MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                    }
                    else
                    {
                        this.BloodlineMC[("skillLvTxt_" + _local_6)].text = "Lv: 0/10";
                        if (this.canLvlUP(_local_2, Character.character_talent_1))
                        {
                            this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtn.visible = true;
                            this.main.initButton(this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtn, this.showNewLevelInfo);
                            this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtn.skill_id = _local_2.talent_skill_id;
                            this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtn.skill_level = 0;
                            this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtn.talent_skill_id = _local_1;
                            NinjaSage.loadIconSWF("skills", _local_2.talent_skill_id, this.BloodlineMC[("skill_" + _local_6)].holder, "with_holder");
                        }
                        else
                        {
                            this.BloodlineMC[("skill_" + _local_6)].gotoAndStop("queston_mark");
                            this.BloodlineMC[("btnUpgrade_" + _local_6)].addBtnDim.visible = true;
                        };
                        this.BloodlineMC[("skill_" + String(_local_6))].metaData = {
                            "name":_local_2.talent_skill_name,
                            "description":_local_2.talent_skill_description,
                            "level":0
                        };
                        this.eventHandler.addListener(this.BloodlineMC[("skill_" + String(_local_6))], MouseEvent.ROLL_OVER, this.toolTipTalent, false, 0, true);
                        this.eventHandler.addListener(this.BloodlineMC[("skill_" + String(_local_6))], MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                    };
                };
                _local_6++;
            };
        }

        public function fillUPSecret():*
        {
            var _local_1:* = undefined;
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            this.tooltipSecret1 = {};
            var _local_5:* = TalentInfo.getTalentInfos(Character.character_talent_2);
            this.SecretMC_1.SecSkillNameTxt.text = _local_5.talent_name;
            var _local_6:* = 1;
            while (_local_6 < 4)
            {
                this.SecretMC_1[("skill_" + _local_6)].gotoAndStop("enable");
                this.SecretMC_1[("skill_" + _local_6)].typeIcon.gotoAndStop(1);
                _local_1 = ((("talent_" + Character.character_talent_2) + "_skill_") + _local_6);
                _local_2 = TalentSkillDescriptions.getTalentSkillDescriptions(_local_1);
                GF.removeAllChild(this.SecretMC_1[("skill_" + _local_6)].holder);
                this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtnDim.visible = false;
                this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtn.visible = false;
                this.SecretMC_1[("btnUpgrade_" + _local_6)].detailBtn.visible = false;
                this.SecretMC_1[("skillLvTxt_" + _local_6)].text = "Lv: 0/10";
                if (("talent_skill_id" in _local_2))
                {
                    if ((_local_3 = this.getCurrentSkillInfo(_local_2.talent_skill_id, Character.character_talent_2)))
                    {
                        this.SecretMC_1[("skillLvTxt_" + _local_6)].text = (("Lv. " + _local_3.item_level) + "/10");
                        if (_local_3.item_level < 10)
                        {
                            if (this.canLvlUP(_local_2, Character.character_talent_2))
                            {
                                NinjaSage.loadIconSWF("skills", _local_2.talent_skill_id, this.SecretMC_1[("skill_" + _local_6)].holder, "with_holder");
                                this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtn.visible = true;
                                this.main.initButton(this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtn, this.showNewLevelInfo);
                                this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtn.skill_id = _local_2.talent_skill_id;
                                this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtn.skill_level = _local_3.item_level;
                                this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtn.talent_skill_id = _local_1;
                            }
                            else
                            {
                                this.SecretMC_1[("skill_" + _local_6)].gotoAndStop("queston_mark");
                                this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtnDim.visible = true;
                            };
                        }
                        else
                        {
                            NinjaSage.loadIconSWF("skills", _local_2.talent_skill_id, this.SecretMC_1[("skill_" + _local_6)].holder, "with_holder");
                            this.SecretMC_1[("btnUpgrade_" + _local_6)].detailBtn.visible = true;
                            this.main.initButton(this.SecretMC_1[("btnUpgrade_" + _local_6)].detailBtn, this.showFullLevelInfo);
                            this.SecretMC_1[("btnUpgrade_" + _local_6)].detailBtn.skill_id = _local_2.talent_skill_id;
                            this.SecretMC_1[("btnUpgrade_" + _local_6)].detailBtn.talent_skill_id = _local_1;
                        };
                        _local_4 = TalentSkillLevel.getTalentSkillLevels(_local_2.talent_skill_id, _local_3.item_level);
                        this.SecretMC_1[("skill_" + String(_local_6))].metaData = {
                            "name":_local_4.talent_skill_name,
                            "description":_local_4.talent_skill_description,
                            "level":_local_3.item_level
                        };
                        this.eventHandler.addListener(this.SecretMC_1[("skill_" + String(_local_6))], MouseEvent.ROLL_OVER, this.toolTipTalent, false, 0, true);
                        this.eventHandler.addListener(this.SecretMC_1[("skill_" + String(_local_6))], MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                    }
                    else
                    {
                        this.SecretMC_1[("skillLvTxt_" + _local_6)].text = "Lv: 0/10";
                        if (this.canLvlUP(_local_2, Character.character_talent_2))
                        {
                            this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtn.visible = true;
                            this.main.initButton(this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtn, this.showNewLevelInfo);
                            this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtn.skill_id = _local_2.talent_skill_id;
                            this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtn.skill_level = 0;
                            this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtn.talent_skill_id = _local_1;
                            NinjaSage.loadIconSWF("skills", _local_2.talent_skill_id, this.SecretMC_1[("skill_" + _local_6)].holder, "with_holder");
                        }
                        else
                        {
                            this.SecretMC_1[("skill_" + _local_6)].gotoAndStop("queston_mark");
                            this.SecretMC_1[("btnUpgrade_" + _local_6)].addBtnDim.visible = true;
                        };
                        this.SecretMC_1[("skill_" + String(_local_6))].metaData = {
                            "name":_local_2.talent_skill_name,
                            "description":_local_2.talent_skill_description,
                            "level":0
                        };
                        this.eventHandler.addListener(this.SecretMC_1[("skill_" + String(_local_6))], MouseEvent.ROLL_OVER, this.toolTipTalent, false, 0, true);
                        this.eventHandler.addListener(this.SecretMC_1[("skill_" + String(_local_6))], MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                    };
                };
                _local_6++;
            };
        }

        public function fillUPSecret2():*
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            this.tooltipSecret2 = {};
            var _local_5:* = TalentInfo.getTalentInfos(Character.character_talent_3);
            this.SecretMC_2.SecSkillNameTxt.text = _local_5.talent_name;
            var _local_6:* = 1;
            while (_local_6 < 4)
            {
                this.SecretMC_2[("skill_" + _local_6)].gotoAndStop("enable");
                this.SecretMC_2[("skill_" + _local_6)].typeIcon.gotoAndStop(1);
                _local_1 = ((("talent_" + Character.character_talent_3) + "_skill_") + _local_6);
                _local_2 = TalentSkillDescriptions.getTalentSkillDescriptions(_local_1);
                GF.removeAllChild(this.SecretMC_2[("skill_" + _local_6)].holder);
                this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtnDim.visible = false;
                this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtn.visible = false;
                this.SecretMC_2[("btnUpgrade_" + _local_6)].detailBtn.visible = false;
                this.SecretMC_2[("skillLvTxt_" + _local_6)].text = "Lv: 0/10";
                if (("talent_skill_id" in _local_2))
                {
                    if ((_local_3 = this.getCurrentSkillInfo(_local_2.talent_skill_id, Character.character_talent_3)))
                    {
                        this.SecretMC_2[("skillLvTxt_" + _local_6)].text = (("Lv. " + _local_3.item_level) + "/10");
                        if (_local_3.item_level < 10)
                        {
                            if (this.canLvlUP(_local_2, Character.character_talent_3))
                            {
                                NinjaSage.loadIconSWF("skills", _local_2.talent_skill_id, this.SecretMC_2[("skill_" + _local_6)].holder, "with_holder");
                                this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtn.visible = true;
                                this.main.initButton(this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtn, this.showNewLevelInfo);
                                this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtn.skill_id = _local_2.talent_skill_id;
                                this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtn.skill_level = _local_3.item_level;
                                this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtn.talent_skill_id = _local_1;
                            }
                            else
                            {
                                this.SecretMC_2[("skill_" + _local_6)].gotoAndStop("queston_mark");
                                this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtnDim.visible = true;
                            };
                        }
                        else
                        {
                            NinjaSage.loadIconSWF("skills", _local_2.talent_skill_id, this.SecretMC_2[("skill_" + _local_6)].holder, "with_holder");
                            this.SecretMC_2[("btnUpgrade_" + _local_6)].detailBtn.visible = true;
                            this.main.initButton(this.SecretMC_2[("btnUpgrade_" + _local_6)].detailBtn, this.showFullLevelInfo);
                            this.SecretMC_2[("btnUpgrade_" + _local_6)].detailBtn.skill_id = _local_2.talent_skill_id;
                            this.SecretMC_2[("btnUpgrade_" + _local_6)].detailBtn.talent_skill_id = _local_1;
                        };
                        _local_4 = TalentSkillLevel.getTalentSkillLevels(_local_2.talent_skill_id, _local_3.item_level);
                        this.SecretMC_2[("skill_" + String(_local_6))].metaData = {
                            "name":_local_4.talent_skill_name,
                            "description":_local_4.talent_skill_description,
                            "level":_local_3.item_level
                        };
                        this.eventHandler.addListener(this.SecretMC_2[("skill_" + String(_local_6))], MouseEvent.ROLL_OVER, this.toolTipTalent, false, 0, true);
                        this.eventHandler.addListener(this.SecretMC_2[("skill_" + String(_local_6))], MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                    }
                    else
                    {
                        this.SecretMC_2[("skillLvTxt_" + _local_6)].text = "Lv: 0/10";
                        if (this.canLvlUP(_local_2, Character.character_talent_3))
                        {
                            this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtn.visible = true;
                            this.main.initButton(this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtn, this.showNewLevelInfo);
                            this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtn.skill_id = _local_2.talent_skill_id;
                            this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtn.skill_level = 0;
                            this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtn.talent_skill_id = _local_1;
                            NinjaSage.loadIconSWF("skills", _local_2.talent_skill_id, this.SecretMC_2[("skill_" + _local_6)].holder, "with_holder");
                        }
                        else
                        {
                            this.SecretMC_2[("skill_" + _local_6)].gotoAndStop("queston_mark");
                            this.SecretMC_2[("btnUpgrade_" + _local_6)].addBtnDim.visible = true;
                        };
                        this.SecretMC_2[("skill_" + String(_local_6))].metaData = {
                            "name":_local_2.talent_skill_name,
                            "description":_local_2.talent_skill_description,
                            "level":0
                        };
                        this.eventHandler.addListener(this.SecretMC_2[("skill_" + String(_local_6))], MouseEvent.ROLL_OVER, this.toolTipTalent, false, 0, true);
                        this.eventHandler.addListener(this.SecretMC_2[("skill_" + String(_local_6))], MouseEvent.ROLL_OUT, this.toolTiponOut, false, 0, true);
                    };
                };
                _local_6++;
            };
        }

        public function reloadTalentInfo(_arg_1:String):*
        {
            this.ref = _arg_1;
            this.fetchTalents(this.reloadTalentBox);
        }

        public function reloadTalentBox(_arg_1:*):*
        {
            if (!_arg_1.hasOwnProperty("data"))
            {
                this.destroy();
                return;
            };
            this.setTalentSkills(_arg_1.data);
            if (this.ref == "SecretMC_2")
            {
                this.fillUPSecret2();
            }
            else
            {
                if (this.ref == "SecretMC_1")
                {
                    this.fillUPSecret();
                }
                else
                {
                    this.fillUP();
                };
            };
        }

        internal function toolTipTalent(_arg_1:*):*
        {
            var _local_2:* = _arg_1.currentTarget.metaData;
            var _local_3:* = ((((_local_2.name + "\n(Level ") + _local_2.level) + ")\n\n") + _local_2.description);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_3);
        }

        internal function toolTiponOut(_arg_1:MouseEvent):void
        {
            this.tooltip.hide();
        }

        public function showNewLevelInfo(_arg_1:MouseEvent):*
        {
            this.lvl_up_mc.visible = true;
            this.lvl_up_mc.init(this);
            this.lvl_up_mc.setInfo(_arg_1.currentTarget.skill_id, _arg_1.currentTarget.talent_skill_id, _arg_1.currentTarget.skill_level, _arg_1.currentTarget.parent.parent.name);
        }

        public function showFullLevelInfo(_arg_1:MouseEvent):*
        {
            this.skill_info_mc.visible = true;
            this.skill_info_mc.init(this);
            this.skill_info_mc.setInfo(_arg_1.currentTarget.skill_id, _arg_1.currentTarget.talent_skill_id);
        }

        public function addButtonListeners():*
        {
            this.main.initButton(this.btnBPMission, this.openTPTraining, "TP Training");
            this.main.initButton(this.btnConvertBP, this.openTPBoost, "Boost TP");
            this.main.initButton(this.btnReset, this.openResetTP, "Reset");
            this.main.initButton(this.btnExit, this.closeThis);
        }

        public function closeThis(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("TalentService.getTalentSkills", [Character.char_id, Character.sessionkey], this.onGotInfo2);
        }

        public function onGotInfo2(_arg_1:Object):*
        {
            this.main.loading(false);
            this.talent_skill = _arg_1.data;
            Character.character_talent_skills = "";
            var _local_2:* = 0;
            while (_local_2 < this.talent_skill.length)
            {
                if (Character.character_talent_skills == "")
                {
                    Character.character_talent_skills = ((this.talent_skill[_local_2].item_id + ":") + this.talent_skill[_local_2].item_level);
                }
                else
                {
                    Character.character_talent_skills = ((((Character.character_talent_skills + ",") + this.talent_skill[_local_2].item_id) + ":") + this.talent_skill[_local_2].item_level);
                };
                _local_2++;
            };
            this.main.HUD.setBasicData();
            this.main.HUD.loadFrame();
            this.destroy();
        }

        public function removeIcon():*
        {
            var _local_1:* = 1;
            this.BloodlineMC.gotoAndStop(6);
            this.SecretMC_1.gotoAndStop(6);
            this.SecretMC_2.gotoAndStop(6);
            while (_local_1 < 7)
            {
                GF.removeAllChild(this.BloodlineMC[("skill_" + _local_1)].holder);
                _local_1++;
            };
            var _local_2:* = 1;
            while (_local_2 < 4)
            {
                GF.removeAllChild(this.SecretMC_1[("skill_" + _local_2)].holder);
                GF.removeAllChild(this.SecretMC_2[("skill_" + _local_2)].holder);
                _local_2++;
            };
            if (NinjaSage.loader != null)
            {
                NinjaSage.loader.removeAll();
            };
        }

        public function openTPTraining(_arg_1:MouseEvent):*
        {
            this.main.loadExternalSwfPanel("MissionRoom", "MissionRoom");
            this.destroy();
        }

        public function openTPBoost(_arg_1:MouseEvent):*
        {
            this.boost_mc.visible = true;
            this.boost_mc.init(this);
        }

        public function openResetTP(_arg_1:MouseEvent):*
        {
            this.main.loadPanel("Panels.ResetTalent");
            this.destroy();
        }

        public function openDiscoverTalent(_arg_1:MouseEvent):*
        {
            this.main.loadPanel("Panels.TalentShop");
            this.destroy();
        }

        public function clearMain():*
        {
        }

        public function destroy():*
        {
            this.main.handleVillageHUDVisibility(true);
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            if (NinjaSage.loader != null)
            {
                NinjaSage.clearLoader();
            };
            this.removeIcon();
            this.removeChild(this.tooltip);
            this.tooltip = null;
            GF.removeAllChild(this);
            this.main = null;
            parent.removeChild(this);
        }


    }
}//package Panels

