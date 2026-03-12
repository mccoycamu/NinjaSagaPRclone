// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.Leaderboard

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import com.utils.GF;
    import Managers.OutfitManager;
    import flash.utils.getDefinitionByName;
    import flash.system.System;

    public dynamic class Leaderboard extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var currentPage:int = 1;
        private var totalPage:int = 0;
        private var main:*;
        private var response:Object;
        private var eventHandler:EventHandler;

        private var leaderboardData:Object = {};
        private var rewardData:Object = {};
        private var tabArray:Array = [];
        private var target:int = 0;

        public function Leaderboard(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.panelMC.rewardMC.visible = false;
            this.getLeaderboardData();
        }

        private function getLeaderboardData(_arg_1:MouseEvent=null):*
        {
            var _local_2:String;
            if (_arg_1)
            {
                this.target = _arg_1.currentTarget.name.replace("tab", "");
                _local_2 = this.tabArray[this.target][0];
            }
            else
            {
                _local_2 = null;
            };
            this.main.loading(true);
            this.main.amf_manager.service("LeaderboardService.getData", [Character.char_id, Character.sessionkey, _local_2], this.leaderboardResponse);
        }

        private function leaderboardResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.leaderboardData = this.response.data;
                this.rewardData = this.response.rewards;
                if (this.tabArray.length < 1)
                {
                    this.tabArray = this.response.categories;
                    this.target = (this.tabArray.length - 1);
                };
                this.currentPage = 1;
                this.panelMC.titleTxt.text = this.response.title;
                this.panelMC.playerKillTxt.text = this.response.kill_text;
                this.panelMC.timerMC.txt.text = "";
                if (this.response.freeze)
                {
                    this.panelMC.timerMC.txt.text = this.response.freeze;
                };
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
                    this.destroy();
                }
                else
                {
                    this.main.getError(_arg_1.error);
                    this.destroy();
                };
            };
            this.initButton();
            this.upperRank();
            this.lowerRank();
        }

        private function initButton():*
        {
            var _local_1:* = 0;
            while (_local_1 < 5)
            {
                this.panelMC[("tab" + _local_1)].visible = false;
                this.panelMC[("tab" + _local_1)].gotoAndStop(1);
                _local_1++;
            };
            this.panelMC[("tab" + this.target)].gotoAndStop(3);
            _local_1 = 0;
            while (_local_1 < this.tabArray.length)
            {
                this.panelMC[("tab" + _local_1)].visible = true;
                this.panelMC[("tab" + _local_1)].txt.text = this.tabArray[_local_1][1];
                this.panelMC[("tab" + _local_1)].buttonMode = true;
                this.eventHandler.addListener(this.panelMC[("tab" + _local_1)], MouseEvent.ROLL_OVER, this.overFunction);
                this.eventHandler.addListener(this.panelMC[("tab" + _local_1)], MouseEvent.ROLL_OUT, this.outFunction);
                this.eventHandler.addListener(this.panelMC[("tab" + _local_1)], MouseEvent.CLICK, this.getLeaderboardData);
                _local_1++;
            };
            NinjaSage.showDynamicTooltip(this.panelMC.btn_help, "Leaderboard points will be frozen after the timer ends.");
            this.eventHandler.addListener(this.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btnReward, MouseEvent.CLICK, this.openLeaderboardReward);
            this.eventHandler.addListener(this.panelMC.btnPrev, MouseEvent.CLICK, this.changePage, false, 0, true);
            this.eventHandler.addListener(this.panelMC.btnNext, MouseEvent.CLICK, this.changePage, false, 0, true);
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
                    this.panelMC[("rankInfoMc" + _local_1)].nameTxt.htmlText = Character.colorifyText(this.response.data[_local_1].char_id, this.response.data[_local_1].name);
                    this.panelMC[("rankInfoMc" + _local_1)].killTxt.text = this.response.data[_local_1].kill;
                    this.panelMC[("rankInfoMc" + _local_1)].rankTxt.text = (_local_1 + 1);
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
                _local_2 = (_local_1 + int((int((this.currentPage - 1)) * 7)));
                if (this.response.data.length > _local_2)
                {
                    this.panelMC[("rankInfoMc" + _local_1)].visible = true;
                    this.panelMC[("rankInfoMc" + _local_1)].nameTxt.htmlText = Character.colorifyText(this.response.data[_local_2].char_id, this.response.data[_local_2].name);
                    this.panelMC[("rankInfoMc" + _local_1)].killTxt.text = this.response.data[_local_2].kill;
                    this.panelMC[("rankInfoMc" + _local_1)].rankTxt.text = (_local_2 + 1);
                    this.panelMC[("rankInfoMc" + _local_1)].charRankMc.gotoAndStop(this.response.data[_local_2].rank);
                    this.panelMC[("rankInfoMc" + _local_1)].buttonMode = true;
                    this.panelMC[("rankInfoMc" + _local_1)].metaData = {"charId":this.response.data[_local_2].char_id};
                    this.eventHandler.addListener(this.panelMC[("rankInfoMc" + _local_1)], MouseEvent.CLICK, this.openFriendProfile);
                }
                else
                {
                    this.panelMC[("rankInfoMc" + _local_1)].visible = false;
                };
                _local_1++;
            };
            this.totalPage = Math.ceil((this.response.data.length / 7));
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
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.lowerRank();
                    };
                    break;
                case "btnPrev":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.lowerRank();
                    };
            };
            this.updatePageText();
        }

        private function updatePageText():*
        {
            this.panelMC.pageTxt.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function openLeaderboardReward(e:MouseEvent):*
        {
            var k:* = undefined;
            var categoryList:Array;
            var i:* = undefined;
            var rank:* = undefined;
            var currentReward:Array;
            var j:int;
            var rewardId:String;
            this.panelMC.rewardMC.visible = true;
            this.eventHandler.addListener(this.panelMC.rewardMC, MouseEvent.CLICK, this.closeLeaderboardReward);
            var keys:* = [];
            for (k in this.rewardData)
            {
                keys.push(k);
            };
            keys.sort(function (_arg_1:*, _arg_2:*):*
            {
                var _local_3:* = ((_arg_1 is String) ? int(_arg_1.split("-")[0]) : _arg_1);
                var _local_4:* = ((_arg_2 is String) ? int(_arg_2.split("-")[0]) : _arg_2);
                if (_local_3 < _local_4)
                {
                    return (-1);
                };
                if (_local_3 > _local_4)
                {
                    return (1);
                };
                return (0);
            });
            categoryList = keys;
            i = 0;
            for each (rank in categoryList)
            {
                this.panelMC.rewardMC[("lbl_name_" + i)].text = ("Rewards Rank " + rank);
                currentReward = ((this.rewardData[rank]) ? this.rewardData[rank] : []);
                j = 0;
                while (j < 4)
                {
                    this.panelMC.rewardMC[((("iconMc" + i) + "_") + j)].visible = false;
                    this.panelMC.rewardMC[((("iconMc" + i) + "_") + j)].amountTxt.visible = false;
                    if (j < currentReward.length)
                    {
                        rewardId = currentReward[j].replace("%s", Character.character_gender);
                        this.panelMC.rewardMC[((("iconMc" + i) + "_") + j)].visible = true;
                        NinjaSage.loadItemIcon(this.panelMC.rewardMC[((("iconMc" + i) + "_") + j)], rewardId);
                        this.panelMC.rewardMC[((("iconMc" + i) + "_") + j)].ownedTxt.visible = false;
                        if (Character.hasSkill(rewardId) > 0)
                        {
                            this.panelMC.rewardMC[((("iconMc" + i) + "_") + j)].ownedTxt.visible = true;
                            this.panelMC.rewardMC[((("iconMc" + i) + "_") + j)].ownedTxt.text = "Owned";
                        };
                        if (Character.isItemOwned(rewardId) > 0)
                        {
                            this.panelMC.rewardMC[((("iconMc" + i) + "_") + j)].ownedTxt.visible = true;
                            this.panelMC.rewardMC[((("iconMc" + i) + "_") + j)].ownedTxt.text = "Owned";
                        };
                    };
                    j = (j + 1);
                };
                i++;
            };
        }

        private function closeLeaderboardReward(_arg_1:MouseEvent):*
        {
            var _local_3:int;
            this.panelMC.rewardMC.visible = false;
            var _local_2:int;
            while (_local_2 < 4)
            {
                _local_3 = 0;
                while (_local_3 < 4)
                {
                    GF.removeAllChild(this.panelMC.rewardMC[((("iconMc" + _local_2) + "_") + _local_3)].rewardIcon.iconHolder);
                    GF.removeAllChild(this.panelMC.rewardMC[((("iconMc" + _local_2) + "_") + _local_3)].skillIcon.iconHolder);
                    _local_3++;
                };
                _local_2++;
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
            this.destroy();
        }

        private function destroy():*
        {
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            this.closeLeaderboardReward(null);
            var _local_1:* = 0;
            while (_local_1 < 10)
            {
                GF.removeAllChild(this.panelMC[("rankInfoMc" + _local_1)].headHolder);
                _local_1++;
            };
            this.leaderboardData = [];
            this.tabArray = [];
            this.rewardData = null;
            this.eventHandler = null;
            this.main = null;
            this.response = null;
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
            System.gc();
        }


    }
}//package id.ninjasage.features

