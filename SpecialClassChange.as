// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.SpecialClassChange

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import flash.filters.ColorMatrixFilter;
    import com.utils.CreateFilter;
    import Storage.Character;
    import flash.events.MouseEvent;
    import com.utils.GF;
    import Storage.SkillLibrary;
    import Managers.NinjaSage;

    public class SpecialClassChange extends MovieClip 
    {

        private static var CLASS_BTN_NAME_ARR:Array = ["select_info", "select_surprise", "select_perceive", "select_attack", "select_heal"];
        private static var CLASS_SKILL_ARR:Array = ["skill_4002", "skill_4004", "skill_4001", "skill_4003", "skill_4000"];

        private var CLASS_NAME_ARR:Array = ["Intelligence Class", "Surprise Attack Class", "Sensor Class", "Heavy Attack Class", "Medical Class"];
        public var panelMC:MovieClip;
        private var dimFilter:ColorMatrixFilter;
        private var EXAM_SPECIAL_JOUNIN_ARR:Array;
        private var skillArr:Array;
        private var curClass:uint = 0;
        private var orgClass:int;
        private var isEmblem:*;
        private var langArr:Array;
        private var price:Array;
        private var changeClassPrice:int;
        private var currentSelectId:int = -1;
        private var main:*;
        private var tooltip:*;

        public function SpecialClassChange(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.dimFilter = CreateFilter.getSaturationFilter(0);
            this.skillArr = [];
            this.price = [2000, 3000];
            super();
            this.tooltip = new skillToolTip();
            this.tooltip.gotoAndStop(1);
            this.tooltip.scaleX = 0.8;
            this.tooltip.scaleY = 0.8;
            this.langArr = ["Class Exchange Platform", "Please select ONE of the following classes (except current selection)", "Class skill can be used ONCE for each battle.", "Emblem Ninjas cost 2000 tokens while Free Ninjas cost 3000 tokens respectively for following class changes.", "Intelligence Class", "Assault Class", "Sensation Class", "Offense Class", "Medical Class", "Learnt", "", "Class change requires learning fee. Are you sure?", "Require:", 'Do you want to change from "[oldClassName]" to "[newClassName]"? ', "Current Class", "New Class", "<font size='14'>How to change class?<br><br>Make sure you have achieved the following requirements before any class changes including:<br>i) you have reached LV60 or above;<br>ii) you have completed the \"Special Jounin Exam\" and<br>iii) you have selected your chosen class</font>"];
            this.isEmblem = Character.account_type;
            if (this.isEmblem == 1)
            {
                this.changeClassPrice = this.price[0];
            }
            else
            {
                this.changeClassPrice = this.price[1];
            };
            this.onShow();
        }

        public function onShow():void
        {
            this.panelMC.stop();
            var _local_1:MovieClip = this.panelMC.panelMC;
            _local_1.addFrameScript(36, this.stopList);
            _local_1["showPopupConfirmMc"].visible = false;
            _local_1["showPopupMc"].visible = false;
            _local_1["btnClose"].addEventListener(MouseEvent.CLICK, this.hide);
            _local_1["titleTxt"].text = this.langArr[0];
            _local_1["displayTxt"].htmlText = this.langArr[2];
            _local_1["displayTxt2"].visible = false;
            this.main.initButton(_local_1["btnComfirm"], this.gotoConfirmClass, "Change");
            this.main.initButtonDisable(_local_1["btnComfirm"], this.gotoConfirmClass, "Change");
            _local_1["btnComfirm"].filters = [this.dimFilter];
            this.updateClassIcon();
        }

        public function stopList():void
        {
            var _local_1:MovieClip = this.panelMC.panelMC;
            _local_1.stop();
            var _local_2:* = 0;
            while (_local_2 < 5)
            {
                if (_local_1[CLASS_BTN_NAME_ARR[_local_2]].id == -1)
                {
                    _local_1[CLASS_BTN_NAME_ARR[_local_2]].filters = [this.dimFilter];
                    _local_1[("skillLearned_txt_" + this.orgClass)].visible = true;
                    _local_1[("skillLearned_txt_" + this.orgClass)].text = this.langArr[9];
                }
                else
                {
                    _local_1[("arrow_" + _local_2)].visible = true;
                };
                _local_2++;
            };
        }

        public function hide(_arg_1:MouseEvent=null):void
        {
            this.destroy();
        }

        private function updateClassIcon():void
        {
            var _local_1:int;
            var _local_2:Object;
            this.panelMC["panelMC"].gotoAndPlay("show");
            var _local_3:* = 0;
            while (_local_3 < CLASS_SKILL_ARR.length)
            {
                if (Character.character_class == CLASS_SKILL_ARR[_local_3])
                {
                    this.orgClass = _local_3;
                };
                _local_3++;
            };
            var _local_4:MovieClip = this.panelMC["panelMC"];
            _local_1 = 0;
            while (_local_1 < 5)
            {
                _local_4[("arrow_" + _local_1)].visible = false;
                _local_4[("skillLearned_txt_" + _local_1)].visible = false;
                _local_4[CLASS_BTN_NAME_ARR[_local_1]].gotoAndStop(1);
                if (_local_1 != this.orgClass)
                {
                    _local_4[CLASS_BTN_NAME_ARR[_local_1]]["classTitle"].text = this.langArr[(4 + _local_1)];
                    _local_4[CLASS_BTN_NAME_ARR[_local_1]]["highlightMC"].visible = false;
                    _local_4[CLASS_BTN_NAME_ARR[_local_1]].addEventListener(MouseEvent.CLICK, this.changeClass);
                    _local_4[CLASS_BTN_NAME_ARR[_local_1]].addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverClassBtn);
                    _local_4[CLASS_BTN_NAME_ARR[_local_1]].addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutClassBtn);
                    _local_4[CLASS_BTN_NAME_ARR[_local_1]].addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveClassBtn);
                    _local_4[CLASS_BTN_NAME_ARR[_local_1]].thisType = (_local_1 + 1);
                    _local_4[CLASS_BTN_NAME_ARR[_local_1]].id = (_local_1 + 1);
                }
                else
                {
                    _local_4[CLASS_BTN_NAME_ARR[_local_1]]["classTitle"].text = this.langArr[(4 + _local_1)];
                    _local_4[CLASS_BTN_NAME_ARR[_local_1]]["highlightMC"].visible = false;
                    _local_4[CLASS_BTN_NAME_ARR[_local_1]].thisType = (_local_1 + 1);
                    _local_4[CLASS_BTN_NAME_ARR[_local_1]].id = -1;
                };
                _local_1++;
            };
        }

        private function changeClass(_arg_1:MouseEvent=null):void
        {
            var _local_2:uint;
            var _local_3:MovieClip = this.panelMC["panelMC"];
            _local_3["btnComfirm"].filters = null;
            this.curClass = _arg_1.currentTarget.thisType;
            _local_2 = 0;
            while (_local_2 < 5)
            {
                if (_local_3[CLASS_BTN_NAME_ARR[_local_2]].id != -1)
                {
                    if (this.curClass == (_local_2 + 1))
                    {
                        if (_local_3[CLASS_BTN_NAME_ARR[_local_2]].hasEventListener(MouseEvent.CLICK))
                        {
                            _local_3[CLASS_BTN_NAME_ARR[_local_2]].removeEventListener(MouseEvent.CLICK, this.changeClass);
                        };
                        _local_3[CLASS_BTN_NAME_ARR[_local_2]].gotoAndStop(3);
                        _local_3[CLASS_BTN_NAME_ARR[_local_2]]["highlightMC"].visible = true;
                    }
                    else
                    {
                        if (!_local_3[CLASS_BTN_NAME_ARR[_local_2]].hasEventListener(MouseEvent.CLICK))
                        {
                            _local_3[CLASS_BTN_NAME_ARR[_local_2]].addEventListener(MouseEvent.CLICK, this.changeClass);
                        };
                        this.enableButton(_local_3[CLASS_BTN_NAME_ARR[_local_2]], this.changeClass, null);
                        _local_3[CLASS_BTN_NAME_ARR[_local_2]]["highlightMC"].visible = false;
                        _local_3[CLASS_BTN_NAME_ARR[_local_2]].filters = null;
                    };
                };
                _local_2++;
            };
            if (!_local_3["btnComfirm"].hasEventListener(MouseEvent.CLICK))
            {
                this.enableButton(_local_3["btnComfirm"], this.gotoConfirmClass, "Change");
            };
        }

        private function gotoConfirmClass(_arg_1:MouseEvent=null):void
        {
            this.currentSelectId = this.curClass;
            this.onShowConfirmPopup();
        }

        public function onShowConfirmPopup():void
        {
            this.panelMC["panelMC"]["showPopupConfirmMc"].visible = true;
            var _local_1:* = this.panelMC["panelMC"]["showPopupConfirmMc"]["panel"];
            _local_1["oldClass"].gotoAndStop(1);
            _local_1["newClass"].gotoAndStop(1);
            _local_1["btnClose"].addEventListener(MouseEvent.CLICK, this.hideConfirmPopup);
            _local_1["btnOk"].addEventListener(MouseEvent.CLICK, this.confirmedChangeClass);
            _local_1["oldClassTxt"].text = this.langArr[14];
            _local_1["newClassTxt"].text = this.langArr[15];
            _local_1["detailTxt"].text = this.langArr[13].replace("[oldClassName]", this.langArr[(4 + this.orgClass)]).replace("[newClassName]", this.langArr[(3 + this.currentSelectId)]);
            _local_1["newClass"]["icon"].gotoAndStop(this.currentSelectId);
            _local_1["newClass"]["classIcon"].gotoAndStop(this.currentSelectId);
            _local_1["newClass"]["classTitle"].text = this.langArr[(3 + this.currentSelectId)];
            _local_1["oldClass"]["icon"].gotoAndStop((1 + this.orgClass));
            _local_1["oldClass"]["classIcon"].gotoAndStop((1 + this.orgClass));
            _local_1["oldClass"]["classTitle"].text = this.langArr[(4 + this.orgClass)];
            _local_1["oldClass"]["highlightMC"].visible = false;
            _local_1["oldClass"].filters = [this.dimFilter];
            _local_1["skillLearned_txt_1"].text = this.langArr[9];
        }

        private function hideConfirmPopup(_arg_1:MouseEvent=null):void
        {
            this.panelMC["panelMC"]["showPopupConfirmMc"].visible = false;
        }

        private function confirmedChangeClass(_arg_1:MouseEvent):void
        {
            this.hideConfirmPopup();
            this.onShowPopup();
        }

        public function onShowPopup():void
        {
            this.panelMC.panelMC["showPopupMc"].visible = true;
            var _local_1:* = this.panelMC.panelMC.showPopupMc["panel"];
            _local_1["btnClose"].addEventListener(MouseEvent.CLICK, this.hidePopup);
            _local_1["btnOk"].addEventListener(MouseEvent.CLICK, this.confirmedPayToken);
            _local_1["detailTxt_1"].text = this.langArr[3];
            _local_1["detailTxt_2"].text = this.langArr[11];
            _local_1["tokenReauire"].text = this.langArr[12];
            _local_1["tokenAmount"].text = this.changeClassPrice;
        }

        private function hidePopup(_arg_1:MouseEvent):void
        {
            this.panelMC["panelMC"]["showPopupMc"].visible = false;
        }

        private function confirmedPayToken(_arg_1:MouseEvent):void
        {
            this.panelMC["panelMC"]["showPopupMc"].visible = false;
            if (Character.account_tokens < this.changeClassPrice)
            {
                this.main.showMessage("Token is not enough!");
                return;
            };
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.changeSpecialClass", [Character.char_id, Character.sessionkey, CLASS_SKILL_ARR[(this.curClass - 1)]], this.getBuyResponse);
        }

        private function getBuyResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.character_class = CLASS_SKILL_ARR[(this.curClass - 1)];
                Character.account_tokens = (Character.account_tokens - this.changeClassPrice);
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

        private function enableButton(_arg_1:*, _arg_2:Function, _arg_3:String=null):void
        {
            _arg_1.stop();
            _arg_1["clickMask"].buttonMode = true;
            _arg_1.gotoAndStop(1);
            if (!_arg_1.hasEventListener(MouseEvent.MOUSE_OUT))
            {
                _arg_1.addEventListener(MouseEvent.MOUSE_OUT, this.mouseOutEffect);
            };
            if (!_arg_1.hasEventListener(MouseEvent.MOUSE_OVER))
            {
                _arg_1.addEventListener(MouseEvent.MOUSE_OVER, this.mouseOverEffect);
            };
            if (!_arg_1.hasEventListener(MouseEvent.CLICK))
            {
                _arg_1.addEventListener(MouseEvent.CLICK, _arg_2);
            };
            if (((!(_arg_3 == null)) && (!(_arg_3 == ""))))
            {
                _arg_1["txt"].text = _arg_3;
            };
            _arg_1.filters = null;
        }

        private function mouseOutEffect(_arg_1:MouseEvent=null):void
        {
            _arg_1.currentTarget.gotoAndStop(1);
        }

        private function mouseOverEffect(_arg_1:MouseEvent=null):void
        {
            _arg_1.currentTarget.gotoAndStop(2);
        }

        private function mouseOutClassBtn(_arg_1:MouseEvent=null):void
        {
            var _local_2:uint = _arg_1.currentTarget.thisType;
            _arg_1.currentTarget.gotoAndStop(1);
            GF.removeAllChild(this.panelMC["panelMC"][("tooltipHolder" + _local_2)]);
        }

        private function mouseOverClassBtn(_arg_1:MouseEvent=null):void
        {
            var _local_2:uint = _arg_1.currentTarget.thisType;
            _arg_1.currentTarget.gotoAndStop(2);
            var _local_3:* = CLASS_SKILL_ARR[(_local_2 - 1)];
            var _local_4:* = SkillLibrary.getSkillInfo(_local_3);
            var _local_5:* = -1;
            if (_local_3 == "skill_4000")
            {
                _local_5 = (1000 + ((int(Character.character_lvl) - 60) * 70));
                this.tooltip.healTxt.text = _local_5;
                Character.recolor(this.tooltip.healTxt, 0xFF00);
            }
            else
            {
                if (_local_3 == "skill_4004")
                {
                    _local_5 = (700 + ((int(Character.character_lvl) - 60) * 64));
                    this.tooltip.healTxt.text = _local_5;
                    Character.recolor(this.tooltip.healTxt, 0xFF0000);
                }
                else
                {
                    this.tooltip.healTxt.text = "-";
                    Character.recolor(this.tooltip.healTxt, 0xFFFFFF);
                };
            };
            this.tooltip.classMC.gotoAndStop((_local_2 + 1));
            this.tooltip.cooldownTxt.text = "-";
            this.tooltip.skillNameTxt.text = _local_4.skill_name;
            this.tooltip.currskillTxt.text = _local_4.skill_description.replace("[valamount]", _local_5);
            this.tooltip.iconMC.gotoAndStop(1);
            GF.removeAllChild(this.tooltip.iconMC.iconHolder);
            NinjaSage.loadIconSWF("skills", _local_3, this.tooltip.iconMC.iconHolder, "icon");
            if (_local_2 != 5)
            {
                this.tooltip.damageIcon.visible = true;
                this.tooltip.healIcon.visible = false;
            }
            else
            {
                this.tooltip.damageIcon.visible = false;
                this.tooltip.healIcon.visible = true;
            };
            this.panelMC["panelMC"][("tooltipHolder" + _local_2)].addChild(this.tooltip);
        }

        private function mouseMoveClassBtn(_arg_1:MouseEvent=null):void
        {
            var _local_2:uint = _arg_1.currentTarget.thisType;
        }

        public function destroy():*
        {
            GF.removeAllChild(this.tooltip.iconMC.iconHolder);
            GF.removeAllChild(this.tooltip);
            NinjaSage.clearLoader();
            this.main.removeExternalSwfPanel();
            this.langArr = [];
            this.tooltip = null;
            this.dimFilter = null;
            this.main = null;
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

