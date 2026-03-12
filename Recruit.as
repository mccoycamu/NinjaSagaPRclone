// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.Recruit

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import Storage.GameData;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import com.utils.GF;
    import Managers.NinjaSage;
    import Storage.Character;
    import com.adobe.crypto.CUCSG;
    import flash.system.System;

    public class Recruit extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var npcInfo:Object = GameData.get("recruit");
        private var npcDetail:Array;
        private var npcIdx:int;
        private var curr_page:int = 1;
        private var last_page:int = 0;
        private var total_page:int = 0;
        private var main:*;
        private var eventHandler:EventHandler;
        private var target:int = 0;

        public function Recruit(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.initButton();
            this.setNpcUI();
        }

        private function initButton():*
        {
            var _local_1:* = 0;
            while (_local_1 < 2)
            {
                this.panelMC[("tab" + _local_1)].visible = false;
                this.panelMC[("tab" + _local_1)].gotoAndStop(1);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.npcInfo.npcs.length)
            {
                this.panelMC[("tab" + _local_1)].visible = true;
                this.panelMC[("tab" + _local_1)].txt.text = this.npcInfo.npcs[_local_1].tab_name;
                this.panelMC[("tab" + _local_1)].buttonMode = true;
                this.eventHandler.addListener(this.panelMC[("tab" + _local_1)], MouseEvent.ROLL_OVER, this.overFunction);
                this.eventHandler.addListener(this.panelMC[("tab" + _local_1)], MouseEvent.ROLL_OUT, this.outFunction);
                this.eventHandler.addListener(this.panelMC[("tab" + _local_1)], MouseEvent.CLICK, this.setNpcUI);
                _local_1++;
            };
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btn_prev, MouseEvent.CLICK, this.changePage, false, 0, true);
            this.eventHandler.addListener(this.panelMC.btn_next, MouseEvent.CLICK, this.changePage, false, 0, true);
        }

        private function setNpcUI(_arg_1:MouseEvent=null):*
        {
            var _local_2:*;
            var _local_3:*;
            if ((_arg_1 is MouseEvent))
            {
                this.target = _arg_1.currentTarget.name.replace("tab", "");
                this.curr_page = 1;
                _local_2 = 0;
                while (_local_2 < this.npcInfo.npcs.length)
                {
                    this.panelMC[("tab" + _local_2)].gotoAndStop(1);
                    _local_2++;
                };
                _arg_1.currentTarget.gotoAndStop(3);
            }
            else
            {
                this.panelMC.tab0.gotoAndStop(3);
            };
            if (this.npcInfo.npcs[this.target].type == "Classic")
            {
                this.npcDetail = this.npcInfo.npcs[0].detail;
            }
            else
            {
                this.npcDetail = this.npcInfo.npcs[1].detail;
            };
            _local_2 = 0;
            while (_local_2 < 4)
            {
                _local_3 = (_local_2 + int((int((this.curr_page - 1)) * 4)));
                GF.removeAllChild(this.panelMC[("npcMC" + _local_2)].holder);
                if (this.npcDetail.length > _local_3)
                {
                    this.panelMC[("npcMC" + _local_2)].visible = true;
                    this.panelMC[("npcMC" + _local_2)].nameTxt.text = this.npcDetail[_local_3].name;
                    this.panelMC[("npcMC" + _local_2)].lvlTxt.text = ("Lv. " + String(this.npcDetail[_local_3].level));
                    this.panelMC[("npcMC" + _local_2)].rankMC.gotoAndStop(this.npcDetail[_local_3].rank);
                    NinjaSage.loadIconSWF("npcs", this.npcDetail[_local_3].id, this.panelMC[("npcMC" + _local_2)].holder, "StaticFullBody");
                    if (this.npcDetail[_local_3].premium)
                    {
                        this.panelMC[("npcMC" + _local_2)].emblemMC.visible = true;
                    }
                    else
                    {
                        this.panelMC[("npcMC" + _local_2)].emblemMC.visible = false;
                    };
                    if (((this.npcDetail[_local_3].price_token == 0) && (this.npcDetail[_local_3].price_gold > 0)))
                    {
                        this.panelMC[("npcMC" + _local_2)].priceMC.gotoAndStop(1);
                        this.panelMC[("npcMC" + _local_2)].priceMC.txt_gold.text = this.npcDetail[_local_3].price_gold;
                    }
                    else
                    {
                        this.panelMC[("npcMC" + _local_2)].priceMC.gotoAndStop(2);
                        this.panelMC[("npcMC" + _local_2)].priceMC.txt_token.text = this.npcDetail[_local_3].price_token;
                    };
                    this.eventHandler.addListener(this.panelMC[("npcMC" + _local_2)].btn_recruit, MouseEvent.CLICK, this.onRecruitAmf);
                }
                else
                {
                    this.panelMC[("npcMC" + _local_2)].visible = false;
                };
                _local_2++;
            };
            this.total_page = Math.ceil((this.npcDetail.length / 4));
            this.updatePageText();
        }

        private function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.total_page > this.curr_page)
                    {
                        this.curr_page++;
                        this.setNpcUI();
                    };
                    break;
                case "btn_prev":
                    if (this.curr_page > 1)
                    {
                        this.curr_page--;
                        this.setNpcUI();
                    };
            };
            this.updatePageText();
        }

        private function updatePageText():*
        {
            this.panelMC.txt_page.text = ((this.curr_page + "/") + this.total_page);
        }

        private function onRecruitAmf(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.parent.name.replace("npcMC", "");
            this.npcIdx = (int(_local_2) + int((int((this.curr_page - 1)) * 4)));
            if (((this.npcDetail[this.npcIdx].premium) && (Character.account_type == 0)))
            {
                this.main.showMessage("You need to be premium user to recruit this NPC!");
                return;
            };
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.recruitTeammate", [Character.char_id, Character.sessionkey, this.npcDetail[this.npcIdx].id], this.onRecruitAmfRes);
        }

        private function onRecruitAmfRes(_arg_1:Object):*
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                _local_2 = _arg_1.recruiters[1];
                _local_3 = CUCSG.hash(_arg_1.recruiters[0][0]);
                if (_local_2 == _local_3)
                {
                    if (((this.npcDetail[this.npcIdx].price_token == 0) && (this.npcDetail[this.npcIdx].price_gold > 0)))
                    {
                        Character.character_gold = String((int(Character.character_gold) - int(this.npcDetail[this.npcIdx].price_gold)));
                    }
                    else
                    {
                        Character.account_tokens = (int(Character.account_tokens) - int(this.npcDetail[this.npcIdx].price_token));
                    };
                    Character.character_recruit_ids = _arg_1.recruiters[0];
                    this.main.HUD.setBasicData();
                    this.main.showMessage("Successfully recruited teammate!");
                }
                else
                {
                    this.main.getError(204);
                };
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getNotice(_arg_1.error);
                };
            };
        }

        private function overFunction(_arg_1:MouseEvent):*
        {
            if (_arg_1.currentTarget.currentFrame == 3)
            {
                return;
            };
            _arg_1.currentTarget.gotoAndStop(2);
        }

        private function outFunction(_arg_1:MouseEvent):*
        {
            if (_arg_1.currentTarget.currentFrame == 3)
            {
                return;
            };
            _arg_1.currentTarget.gotoAndStop(1);
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.main.HUD.setBasicData();
            this.destroy();
        }

        public function destroy():*
        {
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            this.eventHandler = null;
            this.main = null;
            this.npcInfo = null;
            this.npcDetail = null;
            var _local_1:* = 0;
            while (_local_1 < 4)
            {
                GF.removeAllChild(this.panelMC[("npcMC" + _local_1)].holder);
                _local_1++;
            };
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

