// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.PvpLeaderboard

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import Storage.Character;
    import com.utils.GF;
    import Managers.OutfitManager;
    import flash.utils.getDefinitionByName;
    import flash.system.System;

    public dynamic class PvpLeaderboard extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var curr_page:* = 1;
        private var last_page:* = 0;
        private var total_page:* = 0;
        private var main:*;
        private var character:*;
        private var response:*;
        private var eventHandler:*;
        private var target:* = 0;

        public function PvpLeaderboard(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.panelMC.rewardMC.visible = false;
            this.panelMC.btnReward.visible = false;
            this.initButton();
            this.getLeaderboardData();
        }

        private function initButton():*
        {
            this.eventHandler.addListener(this.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btnReward, MouseEvent.CLICK, this.openLeaderboardReward);
            this.eventHandler.addListener(this.panelMC.btnPrev, MouseEvent.CLICK, this.changePage, false, 0, true);
            this.eventHandler.addListener(this.panelMC.btnNext, MouseEvent.CLICK, this.changePage, false, 0, true);
        }

        private function getLeaderboardData(_arg_1:MouseEvent=null):*
        {
            this.curr_page = 1;
            this.panelMC.titleTxt.text = "PvP Leaderboard";
            this.main.loading(true);
            this.main.amf_manager.service("PvPService.getLeaderboard", [Character.char_id, Character.sessionkey], this.leaderboardResponse);
        }

        private function leaderboardResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
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
            this.currentCharacterRank();
            this.upperRank();
            this.lowerRank();
        }

        private function currentCharacterRank():void
        {
            this.panelMC.userInfoMc.trophiesTxt.text = this.response.trophy;
            this.panelMC.userInfoMc.nameTxt.htmlText = Character.colorifyText(Character.char_id, Character.character_name);
            this.panelMC.userInfoMc.rankTxt.text = String(this.response.pos);
            this.panelMC.userInfoMc.bgMC.gotoAndStop(1);
            this.panelMC.userInfoMc.charRankMc.gotoAndStop(String(Character.character_rank));
        }

        private function upperRank():*
        {
            var _local_2:*;
            var _local_3:*;
            var _local_1:* = 0;
            while (_local_1 < 3)
            {
                _local_2 = (_local_1 + int((int((1 - 1)) * 3)));
                if (this.response.data.length > _local_2)
                {
                    this.panelMC[("rankInfoMc" + _local_1)].visible = true;
                    this.panelMC[("rankInfoMc" + _local_1)].nameTxt.htmlText = Character.colorifyText(this.response.data[_local_1].id, this.response.data[_local_1].name);
                    this.panelMC[("rankInfoMc" + _local_1)].trophiesTxt.text = this.response.data[_local_1].trophy;
                    this.panelMC[("rankInfoMc" + _local_1)].charRankMc.gotoAndStop(this.response.data[_local_1].rank);
                    this.panelMC[("rankInfoMc" + _local_1)].buttonMode = true;
                    this.panelMC[("rankInfoMc" + _local_1)].metaData = {"charId":this.response.data[_local_1].char_id};
                    this.eventHandler.addListener(this.panelMC[("rankInfoMc" + _local_1)], MouseEvent.CLICK, this.openFriendProfile);
                    _local_3 = this.getPlayerHead(_local_1);
                    _local_3.scaleX = 1.7;
                    _local_3.scaleY = 1.7;
                    _local_3.x = (_local_3.x + 10);
                    _local_3.y = (_local_3.y - 20);
                    GF.removeAllChild(this.panelMC[("rankInfoMc" + _local_1)].headHolder);
                    this.panelMC[("rankInfoMc" + _local_1)].headHolder.addChild(_local_3);
                }
                else
                {
                    this.panelMC[("rankInfoMc" + _local_1)].visible = false;
                };
                _local_1++;
            };
        }

        private function lowerRank():*
        {
            var _local_2:*;
            var _local_1:* = 3;
            while (_local_1 < 10)
            {
                _local_2 = (_local_1 + int((int((this.curr_page - 1)) * 7)));
                if (this.response.data.length > _local_2)
                {
                    this.panelMC[("rankInfoMc" + _local_1)].visible = true;
                    this.panelMC[("rankInfoMc" + _local_1)].nameTxt.htmlText = Character.colorifyText(this.response.data[_local_2].id, this.response.data[_local_2].name);
                    this.panelMC[("rankInfoMc" + _local_1)].trophiesTxt.text = this.response.data[_local_2].trophy;
                    this.panelMC[("rankInfoMc" + _local_1)].rankTxt.text = (_local_2 + 1);
                    this.panelMC[("rankInfoMc" + _local_1)].charRankMc.gotoAndStop(this.response.data[_local_2].rank);
                    this.panelMC[("rankInfoMc" + _local_1)].buttonMode = true;
                    this.panelMC[("rankInfoMc" + _local_1)].metaData = {"charId":this.response.data[_local_2].char_id};
                    if (this.response.data[_local_2].char_id == Character.char_id)
                    {
                        this.panelMC[("rankInfoMc" + _local_1)].bgMC.gotoAndStop("player");
                    }
                    else
                    {
                        this.panelMC[("rankInfoMc" + _local_1)].bgMC.gotoAndStop("normal");
                    };
                    this.eventHandler.addListener(this.panelMC[("rankInfoMc" + _local_1)], MouseEvent.CLICK, this.openFriendProfile);
                }
                else
                {
                    this.panelMC[("rankInfoMc" + _local_1)].visible = false;
                };
                _local_1++;
            };
            this.total_page = Math.ceil((this.response.data.length / 7));
            this.updatePageText();
        }

        private function getPlayerHead(_arg_1:*):*
        {
            var _local_2:*;
            if (_local_2)
            {
                _local_2.destroy();
                _local_2 = null;
            };
            _local_2 = new OutfitManager();
            var _local_3:* = new CharHead();
            _local_2.fillHead(_local_3, this.response.data[_arg_1].sets.hair_style, this.response.data[_arg_1].sets.face, this.response.data[_arg_1].sets.hair_color, this.response.data[_arg_1].sets.skin_color);
            return (_local_3);
        }

        private function openFriendProfile(_arg_1:MouseEvent):*
        {
            var _local_2:* = (getDefinitionByName("Panels.UI_Friend_Profile") as Class);
            var _local_3:* = new _local_2(this.main, _arg_1.currentTarget.metaData.charId, true);
            this.main.loader.addChild(_local_3);
        }

        private function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btnNext":
                    if (this.total_page > this.curr_page)
                    {
                        this.curr_page++;
                        this.lowerRank();
                    };
                    break;
                case "btnPrev":
                    if (this.curr_page > 1)
                    {
                        this.curr_page--;
                        this.lowerRank();
                    };
            };
            this.updatePageText();
        }

        private function updatePageText():*
        {
            this.panelMC.pageTxt.text = ((this.curr_page + "/") + this.total_page);
        }

        private function openLeaderboardReward(_arg_1:MouseEvent):*
        {
            this.rewardMC.visible = true;
            this.eventHandler.addListener(this.rewardMC, MouseEvent.CLICK, this.closeLeaderboardReward);
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        private function destroy():*
        {
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            var _local_1:* = 0;
            while (_local_1 < 10)
            {
                GF.removeAllChild(this.panelMC[("rankInfoMc" + _local_1)].headHolder);
                _local_1++;
            };
            this.eventHandler = null;
            this.main = null;
            this.response = null;
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

