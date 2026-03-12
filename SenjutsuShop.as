// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.SenjutsuShop

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import com.abrahamyan.liquid.ToolTip;
    import flash.events.MouseEvent;
    import Storage.Character;
    import Storage.SenjutsuInfo;
    import Storage.SenjutsuSkillDescriptions;
    import com.utils.GF;
    import Managers.NinjaSage;
    import flash.system.System;

    public dynamic class SenjutsuShop extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var tooltip:ToolTip;
        private var selectedSkillArray:Array;
        private var selectedSenjutsu:String;
        private var toadSkillArray:Array = ["skill_3001", "skill_3002", "skill_3003", "skill_3004", "skill_3005", "skill_3006", "skill_3007", "skill_3008", "skill_3009", "skill_3010"];
        private var snakeSkillArray:Array = ["skill_3101", "skill_3102", "skill_3103", "skill_3104", "skill_3105", "skill_3106", "skill_3107", "skill_3108", "skill_3109", "skill_3110"];
        private var toolTipInfoHolder:Array;

        public function SenjutsuShop(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.tooltip = ToolTip.getInstance();
            this.panelMC.gotoAndPlay(2);
            this.panelMC.addFrameScript(0, this.frame1, 4, this.hideVillage, 59, this.frame60, 63, this.frame64, 68, this.frame69, 73, this.frame74);
        }

        private function onShowTutorial():*
        {
            var _local_1:* = this.panelMC.panelMC;
            _local_1.txtTitle.text = "Sage Mode Shop";
            _local_1.lbl_table_desc.text = "Description";
            _local_1.lbl_table_require.text = "Requirement";
            _local_1.lbl_table_youhave.text = "You Can Have";
            _local_1.lbl_table_toad.text = "Toad Sage Mode";
            _local_1.lbl_table_snake.text = "Snake Sage Mode";
            _local_1.lbl_table_other.text = "Common Senjutsu";
            _local_1.txtToadDesc.text = "Senjutsu skill that learn from Toad Elder. Focusing on Physical Strength";
            _local_1.txReqToad.text = "- Level: 80\n- Pass Ninja Tutor Exam";
            _local_1.txtHaveToad.text = "1 of the Sage Mode only";
            _local_1.txtSnakeDesc.text = "Senjutsu skill that learn from Snake Elder. Focusing on Ninjutsu";
            _local_1.txReqSnake.text = "- Level: 80\n- Pass Ninja Tutor Exam";
            _local_1.txtHaveSnake.text = "1 of the Sage Mode only";
            _local_1.txtOtherDesc.text = "None";
            _local_1.txReqOther.text = "- Level: 80\n- Pass Ninja Tutor Exam";
            _local_1.txtHaveOther.text = "No Limit";
            this.eventHandler.addListener(_local_1.btnClose, MouseEvent.CLICK, this.closePanel);
            this.main.initButton(_local_1.btnEnter, this.onShowSelectSenjutsu, "Enter");
        }

        private function onShowSelectSenjutsu(_arg_1:MouseEvent=null):*
        {
            this.panelMC.gotoAndStop("show");
            var _local_2:* = this.panelMC.panelMC;
            if (Character.character_senjutsu == null)
            {
                _local_2.isToad.visible = false;
                _local_2.isSnake.visible = false;
            }
            else
            {
                if (Character.character_senjutsu == "toad")
                {
                    _local_2.isToad.gotoAndStop("show");
                    _local_2.isToad.visible = true;
                    _local_2.isSnake.visible = false;
                }
                else
                {
                    _local_2.isSnake.gotoAndStop("show");
                    _local_2.isToad.visible = false;
                    _local_2.isSnake.visible = true;
                };
            };
            this.eventHandler.addListener(_local_2.btnClose, MouseEvent.CLICK, this.closePanel);
            this.main.initButton(_local_2.btnToad, this.selectSenjutsuMode, "Toad Sage Mode");
            this.main.initButton(_local_2.btnSnake, this.selectSenjutsuMode, "Snake Sage Mode");
        }

        private function selectSenjutsuMode(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name.replace("btn", "");
            this.selectedSenjutsu = _local_2.toLowerCase();
            this.initSenjutsuUI();
        }

        private function initSenjutsuUI():*
        {
            this.panelMC.gotoAndStop(this.selectedSenjutsu);
            var _local_1:* = this.panelMC.panelMC;
            _local_1.confirmBox.gotoAndStop(1);
            var _local_2:* = SenjutsuInfo.getSenjutsuInfo(this.selectedSenjutsu);
            if (this.selectedSenjutsu == "toad")
            {
                if (Character.character_senjutsu != null)
                {
                    _local_1.txtLearnedDesc.text = "Learned";
                    _local_1.btnLearnToad.visible = false;
                }
                else
                {
                    _local_1.txtLearnedDesc.visible = false;
                    _local_1.btnLearnToad.visible = true;
                    this.main.initButton(_local_1.btnLearnToad, this.learnSenjutsuConfirmation, "Learn");
                };
                this.selectedSkillArray = this.toadSkillArray;
            }
            else
            {
                if (Character.character_senjutsu != null)
                {
                    _local_1.txtLearnedDesc.text = "Learned";
                    _local_1.btnLearnSnake.visible = false;
                }
                else
                {
                    _local_1.txtLearnedDesc.visible = false;
                    _local_1.btnLearnSnake.visible = true;
                    this.main.initButton(_local_1.btnLearnSnake, this.learnSenjutsuConfirmation, "Learn");
                };
                this.selectedSkillArray = this.snakeSkillArray;
            };
            _local_1.txtTitle.text = ((this.selectedSenjutsu.charAt(0).toUpperCase() + this.selectedSenjutsu.substring(1)) + " Sage Mode");
            _local_1.txtSs.text = String(Character.character_ss);
            _local_1.goldTxt.text = Character.character_gold;
            _local_1.txtTypeName.text = _local_2.name;
            _local_1.txtTypeDesc.text = _local_2.description;
            _local_1.txtRequest.text = "Requirement";
            _local_1.txtRequestDesc.text = "- Level: 80\n- Pass Ninja Tutor Exam";
            this.eventHandler.addListener(_local_1.btnClose, MouseEvent.CLICK, this.closeSkillTree);
            this.main.initButton(_local_1.getMoreBtn2, this.openHeadquarter, "");
            this.main.initButton(_local_1.btnReset, this.openResetSenjutsu, "Reset");
            this.loadSenjutsuSkillTree();
        }

        private function loadSenjutsuSkillTree():*
        {
            var _local_3:*;
            var _local_4:*;
            this.toolTipInfoHolder = [];
            var _local_1:* = this.panelMC.panelMC;
            var _local_2:* = 0;
            while (_local_2 < 10)
            {
                _local_1[("skill_" + _local_2)].gotoAndStop("enable");
                _local_3 = ((("senjutsu_" + this.selectedSenjutsu) + "_skill_") + int((_local_2 + 1)));
                _local_4 = SenjutsuSkillDescriptions.getSenjutsuSkillDescriptions(_local_3);
                GF.removeAllChild(_local_1[("skill_" + _local_2)].holder);
                NinjaSage.loadIconSWF("skills", this.selectedSkillArray[_local_2], _local_1[("skill_" + _local_2)].holder, "with_holder");
                this.toolTipInfoHolder.push([_local_4.name, _local_4.description]);
                this.eventHandler.addListener(_local_1[("skill_" + _local_2)], MouseEvent.ROLL_OVER, this.toolTiponOver);
                this.eventHandler.addListener(_local_1[("skill_" + _local_2)], MouseEvent.ROLL_OUT, this.toolTiponOut);
                _local_2++;
            };
        }

        private function learnSenjutsuConfirmation(_arg_1:MouseEvent):*
        {
            this.panelMC.panelMC.confirmBox.gotoAndStop("show");
            var _local_2:* = SenjutsuInfo.getSenjutsuInfo(this.selectedSenjutsu);
            var _local_3:* = this.panelMC.panelMC.confirmBox.panelMC;
            _local_3.okBtn.visible = false;
            var _local_4:* = ((_local_2.token == 0) ? (_local_2.gold + " Gold") : (_local_2.token + " Tokens"));
            _local_3.displayTxt.text = (((((("Are you sure you want to use " + _local_4) + " to learn ") + this.selectedSenjutsu.charAt(0).toUpperCase()) + this.selectedSenjutsu.substring(1)) + " Sage Mode?") + " You can only learn 1 Sage Mode at a time.");
            this.eventHandler.addListener(_local_3.yesBtn, MouseEvent.CLICK, this.buySelectedSenjutsu);
            this.eventHandler.addListener(_local_3.noBtn, MouseEvent.CLICK, this.closeConfirmationBox);
        }

        private function buySelectedSenjutsu(_arg_1:MouseEvent):*
        {
            this.main.amf_manager.service("SenjutsuService.discoverSenjutsu", [Character.char_id, Character.sessionkey, this.selectedSenjutsu], this.onBuySenjutsuResponse);
        }

        private function onBuySenjutsuResponse(_arg_1:Object):*
        {
            this.panelMC.panelMC.confirmBox.gotoAndStop("idle");
            var _local_2:* = SenjutsuInfo.getSenjutsuInfo(this.selectedSenjutsu);
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                if (_local_2.token == 0)
                {
                    Character.character_gold = String((Number(Character.character_gold) - Number(_local_2.gold)));
                }
                else
                {
                    Character.account_tokens = (Number(Character.account_tokens) - Number(_local_2.token));
                };
                this.panelMC.panelMC.txtLearnedDesc.visible = true;
                this.panelMC.panelMC.txtLearnedDesc.text = "Learned";
                if (this.selectedSenjutsu == "toad")
                {
                    this.panelMC.panelMC.btnLearnToad.visible = false;
                }
                else
                {
                    this.panelMC.panelMC.btnLearnSnake.visible = false;
                };
                Character.character_senjutsu = _arg_1.type;
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

        private function toolTiponOver(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name;
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

        private function openHeadquarter(_arg_1:MouseEvent):*
        {
            this.main.loadExternalSwfPanel("Headquarter", "Headquarter");
        }

        private function openResetSenjutsu(_arg_1:MouseEvent):*
        {
            this.main.loadExternalSwfPanel("ResetSenjutsu", "ResetSenjutsu");
        }

        private function closeConfirmationBox(_arg_1:MouseEvent):*
        {
            this.panelMC.panelMC.confirmBox.gotoAndStop("idle");
        }

        private function closeSkillTree(_arg_1:MouseEvent):*
        {
            var _local_2:* = 0;
            while (_local_2 < 10)
            {
                GF.removeAllChild(this.panelMC.panelMC[("skill_" + _local_2)].holder);
                _local_2++;
            };
            this.onShowSelectSenjutsu();
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        private function destroy():*
        {
            this.main.handleVillageHUDVisibility(true);
            if (this.tooltip)
            {
                this.tooltip.destroy();
                this.tooltip = null;
            };
            this.main.removeExternalSwfPanel();
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.selectedSenjutsu = null;
            this.selectedSkillArray = null;
            this.main = null;
            GF.clearArray(this.toadSkillArray);
            GF.clearArray(this.snakeSkillArray);
            GF.clearArray(this.toolTipInfoHolder);
            GF.removeAllChild(this.panelMC);
            System.gc();
        }

        internal function frame1():*
        {
            this.panelMC.stop();
        }

        internal function hideVillage():*
        {
            this.main.handleVillageHUDVisibility(false);
        }

        internal function frame60():*
        {
            this.onShowTutorial();
            this.panelMC.stop();
        }

        internal function frame64():*
        {
            this.panelMC.confirmBox.gotoAndStop(1);
            this.panelMC.stop();
        }

        internal function frame69():*
        {
            this.panelMC.stop();
        }

        internal function frame74():*
        {
            this.panelMC.stop();
        }


    }
}//package id.ninjasage.features

