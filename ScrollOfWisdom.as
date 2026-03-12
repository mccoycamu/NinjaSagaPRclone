// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ScrollOfWisdom

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.GameData;
    import Storage.Character;
    import flash.events.MouseEvent;
    import com.utils.GF;
    import Managers.NinjaSage;
    import flash.system.System;

    public dynamic class ScrollOfWisdom extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var selectedElementSkill:Array;
        private var currentPage:int = 1;
        private var totalPage:int = 1;
        private var selectedElementType:int;
        private var elementName:String;
        private var wind_skills:Array;
        private var water_skills:Array;
        private var fire_skills:Array;
        private var thunder_skills:Array;
        private var earth_skills:Array;
        private var main:*;
        private var eventHandler:EventHandler;
        private var response:Object;

        public function ScrollOfWisdom(_arg_1:*, _arg_2:*)
        {
            var _local_3:* = GameData.get("sow");
            this.wind_skills = _local_3.wind;
            this.fire_skills = _local_3.fire;
            this.thunder_skills = _local_3.thunder;
            this.earth_skills = _local_3.earth;
            this.water_skills = _local_3.water;
            super();
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.getData();
        }

        private function getData():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("ScrollOfWisdom.getData", [Character.char_id, Character.sessionkey], this.onGetData);
        }

        private function onGetData(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.initUI();
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

        private function initUI():*
        {
            var _local_2:*;
            this.eventHandler.addListener(this.panelMC.panel.btnClose, MouseEvent.CLICK, this.closePanel);
            this.panelMC.panel.titleTxt.text = "Secret Scroll of Wisdom";
            this.panelMC.panel.subTitleTxt.text = "With Secret Scroll of Wisdom, you can instantly learn ALL skills from one element (not including upgrade token skills and event skills)";
            this.panelMC.panel.titleTxt2.text = "You have";
            this.panelMC.panel.essenceNum.text = this.response.scrolls;
            this.panelMC.panel.warningTxt.text = "Using Secret Scroll of Wisdom will not affect the skills you have learnt.";
            this.panelMC.panel.claimBtn.visible = false;
            this.panelMC.panel.popupConfirmMc.visible = false;
            this.panelMC.panel.popUpGetReward.visible = false;
            this.panelMC.panel.helpMc.visible = false;
            var _local_1:* = 1;
            while (_local_1 < 6)
            {
                this.panelMC.panel[("tab" + _local_1)].skillIcon.gotoAndStop(_local_1);
                this.panelMC.panel[("tab" + _local_1)].upgradeBtn.visible = false;
                this.panelMC.panel[("tab" + _local_1)].claimBtn.visible = false;
                this.panelMC.panel[("tab" + _local_1)].IconMc.visible = false;
                this.panelMC.panel[("tab" + _local_1)].NumMc.visible = false;
                this.panelMC.panel[("tab" + _local_1)].tickIcon.visible = false;
                this.panelMC.panel[("tab" + _local_1)].learnedTxt.visible = false;
                this.eventHandler.addListener(this.panelMC.panel[("tab" + _local_1)].btnHelp, MouseEvent.CLICK, this.openHelp);
                _local_2 = 1;
                while (_local_2 < 4)
                {
                    if (_local_1 == int(Character[("character_element_" + _local_2)]))
                    {
                        this.panelMC.panel[("tab" + _local_1)].IconMc.visible = true;
                        this.panelMC.panel[("tab" + _local_1)].NumMc.visible = true;
                        this.panelMC.panel[("tab" + _local_1)].claimBtn.visible = true;
                        this.panelMC.panel[("tab" + _local_1)].lockTxt.visible = false;
                        this.main.initButton(this.panelMC.panel[("tab" + _local_1)].claimBtn, this.showConfirmation, "Learn");
                    };
                    _local_2++;
                };
                this.checkAllSkillOwned(_local_1);
                _local_1++;
            };
        }

        private function checkAllSkillOwned(_arg_1:int):*
        {
            var _local_2:Array = this.getElement(_arg_1);
            var _local_3:int;
            var _local_4:* = 0;
            while (_local_4 < _local_2.length)
            {
                if (this.hasSkill(_local_2[_local_4]) > 0)
                {
                    _local_3++;
                };
                _local_4++;
            };
            if (_local_2.length == _local_3)
            {
                this.panelMC.panel[("tab" + _arg_1)].tickIcon.visible = true;
                this.panelMC.panel[("tab" + _arg_1)].learnedTxt.visible = true;
                this.panelMC.panel[("tab" + _arg_1)].IconMc.visible = false;
                this.panelMC.panel[("tab" + _arg_1)].NumMc.visible = false;
                this.panelMC.panel[("tab" + _arg_1)].claimBtn.visible = false;
            };
        }

        private function showConfirmation(_arg_1:MouseEvent):*
        {
            this.panelMC.panel.popupConfirmMc.visible = true;
            this.selectedElementType = _arg_1.currentTarget.parent.name.replace("tab", "");
            this.main.initButton(this.panelMC.panel.popupConfirmMc.panel.btnClose, this.closeConfirmation, "Cancel");
            this.main.initButton(this.panelMC.panel.popupConfirmMc.panel.okMc, this.claimAllSkill, "Confirm");
        }

        private function claimAllSkill(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("ScrollOfWisdom.claimSkill", [Character.char_id, Character.sessionkey, this.selectedElementType], this.claimResponse);
        }

        private function claimResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.character_skills = _arg_1.skills;
                Character.removeEssentials("essential_10", 1);
                this.response.scrolls--;
                this.initUI();
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
            this.closeConfirmation();
        }

        private function closeConfirmation(_arg_1:*=null):*
        {
            this.panelMC.panel.popupConfirmMc.visible = false;
        }

        private function openHelp(_arg_1:MouseEvent):*
        {
            this.panelMC.panel.helpMc.visible = true;
            this.selectedElementType = _arg_1.currentTarget.parent.name.replace("tab", "");
            this.selectedElementSkill = this.getElement(this.selectedElementType);
            this.panelMC.panel.helpMc.panel.titleTxt.text = ("Ninjutsu - " + this.elementName);
            this.panelMC.panel.helpMc.panel.skillNumTxt.text = (("Total " + this.selectedElementSkill.length) + " Skills");
            this.panelMC.panel.helpMc.panel.skillTypeIcon.gotoAndStop(this.elementName.toLowerCase());
            this.eventHandler.addListener(this.panelMC.panel.helpMc.panel.btnPrevPage, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.panel.helpMc.panel.btnNextPage, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.panel.helpMc.panel.btnClose, MouseEvent.CLICK, this.closeHelp);
            this.totalPage = Math.ceil((this.selectedElementSkill.length / 15));
            this.showSkillIcon();
        }

        private function closeHelp(_arg_1:MouseEvent):*
        {
            this.panelMC.panel.helpMc.visible = false;
            this.currentPage = 1;
            this.totalPage = 1;
            var _local_2:* = 0;
            while (_local_2 < 15)
            {
                GF.removeAllChild(this.panelMC.panel.helpMc.panel[("skill" + _local_2)].iconHolder);
                _local_2++;
            };
        }

        private function showSkillIcon():*
        {
            var _local_2:*;
            var _local_1:* = 0;
            while (_local_1 < 15)
            {
                GF.removeAllChild(this.panelMC.panel.helpMc.panel[("skill" + _local_1)].iconHolder);
                _local_2 = (_local_1 + int((int((this.currentPage - 1)) * 15)));
                if (this.selectedElementSkill.length > _local_2)
                {
                    this.panelMC.panel.helpMc.panel[("skill" + _local_1)].visible = true;
                    this.panelMC.panel.helpMc.panel[("skill" + _local_1)].cdTxt.visible = ((this.hasSkill(this.selectedElementSkill[_local_2]) > 0) ? true : false);
                    NinjaSage.loadItemIcon(this.panelMC.panel.helpMc.panel[("skill" + _local_1)].iconHolder, this.selectedElementSkill[_local_2], "icon");
                }
                else
                {
                    this.panelMC.panel.helpMc.panel[("skill" + _local_1)].visible = false;
                };
                _local_1++;
            };
            this.updatePageNumber();
        }

        private function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btnNextPage":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.showSkillIcon();
                    };
                    break;
                case "btnPrevPage":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.showSkillIcon();
                    };
            };
            this.updatePageNumber();
        }

        private function updatePageNumber():*
        {
            this.panelMC.panel.helpMc.panel.pageTxt.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function getElement(_arg_1:int):*
        {
            switch (_arg_1)
            {
                case 1:
                    this.elementName = "Wind";
                    return (this.wind_skills);
                case 2:
                    this.elementName = "Fire";
                    return (this.fire_skills);
                case 3:
                    this.elementName = "Lightning";
                    return (this.thunder_skills);
                case 4:
                    this.elementName = "Earth";
                    return (this.earth_skills);
                case 5:
                    this.elementName = "Water";
                    return (this.water_skills);
            };
        }

        private function hasSkill(_arg_1:*):*
        {
            var _local_2:* = [];
            if (Character.character_skills != "")
            {
                if (Character.character_skills.indexOf(",") >= 0)
                {
                    _local_2 = Character.character_skills.split(",");
                }
                else
                {
                    _local_2 = [Character.character_skills];
                };
            };
            var _local_3:* = 0;
            var _local_4:* = 0;
            while (_local_4 < _local_2.length)
            {
                if (_arg_1 == _local_2[_local_4])
                {
                    _local_3 = 1;
                    break;
                };
                _local_4++;
            };
            return (_local_3);
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():*
        {
            var _local_1:* = 0;
            while (_local_1 < 15)
            {
                GF.removeAllChild(this.panelMC.panel.helpMc.panel[("skill" + _local_1)].iconHolder);
                this.panelMC.panel.helpMc.panel[("skill" + _local_1)].tooltip = null;
                _local_1++;
            };
            this.wind_skills = [];
            this.fire_skills = [];
            this.thunder_skills = [];
            this.earth_skills = [];
            this.water_skills = [];
            this.selectedElementSkill = [];
            NinjaSage.clearLoader();
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.main = null;
            this.response = null;
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

