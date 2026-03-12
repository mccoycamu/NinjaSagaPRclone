// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.GiveawayCenter

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import flash.utils.clearTimeout;
    import flash.utils.getDefinitionByName;
    import flash.utils.setTimeout;
    import com.utils.GF;

    public dynamic class GiveawayCenter extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var eventHandler:EventHandler;
        private var selectedTabIndex:int;
        private var currentPage:int;
        private var currentPageHistory:int;
        private var currentPageWinner:int;
        private var totalPage:int;
        private var totalPageHistory:int;
        private var totalPageWinner:int;
        private var response:Object;
        private var historyData:Object;
        private var timestamp:*;
        private var timeout:*;
        private var main:*;

        public function GiveawayCenter(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.getData();
        }

        private function getData(_arg_1:MouseEvent=null):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("GiveawayService.get", [Character.char_id, Character.sessionkey], this.giveawayResponse);
        }

        private function giveawayResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.initUI();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
                this.destroy();
            };
        }

        private function initUI():void
        {
            this.panelMC.historyMC.visible = false;
            this.panelMC.winnerMC.visible = false;
            this.panelMC.rewardMC.gotoAndStop(1);
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btnPrev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btnNext, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btn_history, MouseEvent.CLICK, this.openHistory);
            this.eventHandler.addListener(this.panelMC.btn_refresh, MouseEvent.CLICK, this.getData);
            this.eventHandler.addListener(this.panelMC.btn_join, MouseEvent.CLICK, this.joinGiveaway);
            this.selectedTabIndex = -1;
            this.currentPage = 1;
            this.totalPage = Math.max(1, Math.ceil((this.response.giveaways.length / 3)));
            if (this.response.giveaways.length > 0)
            {
                this.resetSelectedTab();
                this.renderTabPage();
                this.selectGiveaway();
                this.updatePageButton();
                this.panelMC["tab0"].gotoAndStop(3);
            }
            else
            {
                this.hideEverything();
            };
        }

        private function hideEverything():void
        {
            var _local_1:int;
            while (_local_1 < 3)
            {
                this.panelMC[("tab" + _local_1)].visible = false;
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < 4)
            {
                this.panelMC[("task_" + _local_1)].visible = false;
                _local_1++;
            };
            this.panelMC.btnPrev.visible = false;
            this.panelMC.btnNext.visible = false;
            this.panelMC.rewardMC.visible = false;
            this.panelMC.timestamp.visible = false;
            this.panelMC.giveawayTitleTxt.visible = false;
            this.panelMC.giveawayDescriptionTxt.visible = false;
            this.panelMC.btn_join.visible = false;
            this.panelMC.participantsTxt.visible = false;
            this.panelMC.requirementTxt.visible = false;
            this.panelMC.prizeTxt.visible = false;
        }

        private function renderTabPage():void
        {
            var _local_2:int;
            var _local_1:int;
            while (_local_1 < 3)
            {
                _local_2 = (_local_1 + int((int((this.currentPage - 1)) * 3)));
                this.panelMC[("tab" + _local_1)].visible = false;
                if (this.response.giveaways.length > _local_2)
                {
                    this.panelMC[("tab" + _local_1)].visible = true;
                    this.panelMC[("tab" + _local_1)].metaData = {"index":_local_2};
                    this.panelMC[("tab" + _local_1)].txt.text = ("Giveaway #" + this.response.giveaways[_local_2].id);
                    this.panelMC[("tab" + _local_1)].gotoAndStop(1);
                    if (this.selectedTabIndex == _local_2)
                    {
                        this.panelMC[("tab" + _local_1)].gotoAndStop(3);
                    };
                    this.eventHandler.addListener(this.panelMC[("tab" + _local_1)], MouseEvent.CLICK, this.selectGiveaway);
                    this.eventHandler.addListener(this.panelMC[("tab" + _local_1)], MouseEvent.MOUSE_OVER, this.hoverOver);
                    this.eventHandler.addListener(this.panelMC[("tab" + _local_1)], MouseEvent.MOUSE_OUT, this.hoverOut);
                };
                _local_1++;
            };
        }

        private function resetSelectedTab():void
        {
            var _local_1:int;
            while (_local_1 < 3)
            {
                this.panelMC[("tab" + _local_1)].gotoAndStop(1);
                _local_1++;
            };
        }

        private function selectGiveaway(_arg_1:MouseEvent=null):void
        {
            this.selectedTabIndex = ((_arg_1) ? _arg_1.currentTarget.metaData.index : 0);
            if (_arg_1)
            {
                this.resetSelectedTab();
                _arg_1.currentTarget.gotoAndStop(3);
            };
            var _local_2:Object = this.response.giveaways[this.selectedTabIndex];
            this.panelMC.rewardMC.gotoAndStop(_local_2.prizes.length);
            var _local_3:int;
            while (_local_3 < _local_2.prizes.length)
            {
                this.panelMC.rewardMC[("iconMC" + _local_3)].amountTxt.text = ((_local_2.prizes[_local_3].split(":")[1] != null) ? ("x" + _local_2.prizes[_local_3].split(":")[1]) : "");
                this.panelMC.rewardMC[("iconMC" + _local_3)].ownedTxt.visible = false;
                if (Character.hasSkill(_local_2.prizes[_local_3]) > 0)
                {
                    this.panelMC.rewardMC[("iconMC" + _local_3)].ownedTxt.visible = true;
                    this.panelMC.rewardMC[("iconMC" + _local_3)].ownedTxt.text = "Owned";
                };
                if (Character.isItemOwned(_local_2.prizes[_local_3]) > 0)
                {
                    this.panelMC.rewardMC[("iconMC" + _local_3)].ownedTxt.visible = true;
                    this.panelMC.rewardMC[("iconMC" + _local_3)].ownedTxt.text = "Owned";
                };
                NinjaSage.loadItemIcon(this.panelMC.rewardMC[("iconMC" + _local_3)], _local_2.prizes[_local_3]);
                _local_3++;
            };
            this.panelMC.giveawayTitleTxt.text = _local_2.title;
            this.panelMC.giveawayDescriptionTxt.text = _local_2.desc;
            this.panelMC.participantsTxt.visible = _local_2.hasOwnProperty("participants");
            this.panelMC.participantsTxt.text = ("Participants: " + _local_2.participants);
            this.timestamp = _local_2.timestamp;
            if ((((_local_2.hasOwnProperty("winners")) && (!(_local_2.winners == null))) && (_local_2.winners.length > 0)))
            {
                this.currentPageWinner = 1;
                this.totalPageWinner = Math.max(1, Math.ceil((_local_2.winners.length / 10)));
                this.eventHandler.addListener(this.panelMC.winnerMC.btnPrev, MouseEvent.CLICK, this.changePageWinner);
                this.eventHandler.addListener(this.panelMC.winnerMC.btnNext, MouseEvent.CLICK, this.changePageWinner);
                this.updatePageButtonWinner();
                this.renderWinner();
            }
            else
            {
                this.panelMC.winnerMC.visible = false;
                this.panelMC.requirementTxt.visible = true;
                this.panelMC.endedTxt.visible = false;
                this.panelMC.remainingTimeTxt.visible = true;
                this.panelMC.timestamp.visible = true;
                this.panelMC.btn_join.visible = ((_local_2.joined) ? false : true);
                this.panelMC.joinedTxt.visible = _local_2.joined;
                _local_3 = 0;
                while (_local_3 < 4)
                {
                    this.panelMC[("task_" + _local_3)].visible = false;
                    if (_local_2.requirements.length > _local_3)
                    {
                        this.panelMC[("task_" + _local_3)].visible = true;
                        this.panelMC[("task_" + _local_3)].taskName.text = _local_2.requirements[_local_3].name;
                        this.panelMC[("task_" + _local_3)].taskRequirement.text = ((_local_2.requirements[_local_3].progress + "/") + _local_2.requirements[_local_3].total);
                        this.panelMC[("task_" + _local_3)].tick.visible = (_local_2.requirements[_local_3].progress >= _local_2.requirements[_local_3].total);
                    };
                    _local_3++;
                };
            };
            if (this.timeout)
            {
                clearTimeout(this.timeout);
            };
            this.updateTimeleft();
        }

        private function renderWinner():void
        {
            var _local_3:int;
            var _local_1:Object = this.response.giveaways[this.selectedTabIndex];
            this.panelMC.winnerMC.visible = true;
            this.panelMC.requirementTxt.visible = false;
            this.panelMC.btn_join.visible = false;
            this.panelMC.endedTxt.visible = true;
            this.panelMC.remainingTimeTxt.visible = false;
            this.panelMC.timestamp.visible = false;
            this.panelMC.joinedTxt.visible = _local_1.joined;
            var _local_2:int;
            while (_local_2 < 4)
            {
                this.panelMC[("task_" + _local_2)].visible = false;
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < 10)
            {
                _local_3 = (_local_2 + int((int((this.currentPageWinner - 1)) * 10)));
                this.panelMC.winnerMC[("winner" + _local_2)].visible = false;
                if (_local_1.winners.length > _local_3)
                {
                    this.panelMC.winnerMC[("winner" + _local_2)].visible = true;
                    this.panelMC.winnerMC[("winner" + _local_2)].txt.text = ((("[" + _local_1.winners[_local_3].id) + "] ") + _local_1.winners[_local_3].name);
                    this.panelMC.winnerMC[("winner" + _local_2)].metaData = {"charId":_local_1.winners[_local_3].id};
                    this.eventHandler.addListener(this.panelMC.winnerMC[("winner" + _local_2)], MouseEvent.CLICK, this.openFriendProfile);
                };
                _local_2++;
            };
        }

        private function openFriendProfile(_arg_1:MouseEvent):*
        {
            var _local_2:Class = (getDefinitionByName("Panels.UI_Friend_Profile") as Class);
            var _local_3:MovieClip = new _local_2(this.main, _arg_1.currentTarget.metaData.charId, true);
            this.main.loader.addChild(_local_3);
        }

        private function changePageWinner(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btnNext":
                    if (this.totalPageWinner > this.currentPageWinner)
                    {
                        this.currentPageWinner++;
                        this.renderWinner();
                    };
                    break;
                case "btnPrev":
                    if (this.currentPageWinner > 1)
                    {
                        this.currentPageWinner--;
                        this.renderWinner();
                    };
            };
            this.updatePageButtonWinner();
        }

        private function updatePageButtonWinner():void
        {
            if (this.currentPageWinner == 1)
            {
                this.panelMC.winnerMC.btnPrev.visible = false;
                this.panelMC.winnerMC.btnNext.visible = true;
            }
            else
            {
                if (this.currentPageWinner == this.totalPageWinner)
                {
                    this.panelMC.winnerMC.btnPrev.visible = true;
                    this.panelMC.winnerMC.btnNext.visible = false;
                }
                else
                {
                    this.panelMC.winnerMC.btnPrev.visible = true;
                    this.panelMC.winnerMC.btnNext.visible = true;
                };
            };
            if (this.totalPageWinner == 1)
            {
                this.panelMC.winnerMC.btnPrev.visible = false;
                this.panelMC.winnerMC.btnNext.visible = false;
            };
        }

        private function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btnNext":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.renderTabPage();
                    };
                    break;
                case "btnPrev":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.renderTabPage();
                    };
            };
            this.updatePageButton();
        }

        private function updatePageButton():void
        {
            if (this.currentPage == 1)
            {
                this.panelMC.btnPrev.visible = false;
                this.panelMC.btnNext.visible = true;
            }
            else
            {
                if (this.currentPage == this.totalPage)
                {
                    this.panelMC.btnPrev.visible = true;
                    this.panelMC.btnNext.visible = false;
                }
                else
                {
                    this.panelMC.btnPrev.visible = true;
                    this.panelMC.btnNext.visible = true;
                };
            };
            if (this.totalPage == 1)
            {
                this.panelMC.btnPrev.visible = false;
                this.panelMC.btnNext.visible = false;
            };
        }

        private function openHistory(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("GiveawayService.history", [Character.char_id, Character.sessionkey], this.historyResponse);
        }

        private function historyResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.historyData = _arg_1.giveaway;
                this.initHistoryUI();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function initHistoryUI():void
        {
            this.panelMC.historyMC.visible = true;
            var _local_1:MovieClip = this.panelMC.historyMC;
            this.currentPageHistory = 1;
            this.totalPageHistory = Math.max(1, Math.ceil((this.historyData.length / 4)));
            this.eventHandler.addListener(_local_1.btnClose, MouseEvent.CLICK, this.closeHistory);
            this.eventHandler.addListener(_local_1.btnPrev, MouseEvent.CLICK, this.changePageHistory);
            this.eventHandler.addListener(_local_1.btnNext, MouseEvent.CLICK, this.changePageHistory);
            this.renderHistory();
            this.updatePageNumber();
        }

        private function renderHistory():void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_1:MovieClip = this.panelMC.historyMC;
            var _local_2:int;
            while (_local_2 < 4)
            {
                _local_3 = (_local_2 + int((int((this.currentPageHistory - 1)) * 4)));
                _local_1[("history" + _local_2)].visible = false;
                if (this.historyData.length > _local_3)
                {
                    _local_1[("history" + _local_2)].visible = true;
                    _local_1[("history" + _local_2)].titleTxt.text = this.historyData[_local_3].title;
                    _local_1[("history" + _local_2)].descTxt.text = this.historyData[_local_3].description;
                    _local_1[("history" + _local_2)].dateTxt.text = this.historyData[_local_3].ended_at;
                    _local_4 = 0;
                    while (_local_4 < 5)
                    {
                        _local_1[("history" + _local_2)][("iconMc0_" + _local_4)].visible = false;
                        if (this.historyData[_local_3].prizes[_local_4])
                        {
                            _local_1[("history" + _local_2)][("iconMc0_" + _local_4)].visible = true;
                            _local_1[("history" + _local_2)][("iconMc0_" + _local_4)].amountTxt.text = ((this.historyData[_local_3].prizes[_local_4].split(":")[1] != null) ? ("x" + this.historyData[_local_3].prizes[_local_4].split(":")[1]) : "");
                            _local_1[("history" + _local_2)][("iconMc0_" + _local_4)].ownedTxt.visible = false;
                            if (Character.hasSkill(this.historyData[_local_3].prizes[_local_4]) > 0)
                            {
                                _local_1[("history" + _local_2)][("iconMc0_" + _local_4)].ownedTxt.visible = true;
                                _local_1[("history" + _local_2)][("iconMc0_" + _local_4)].ownedTxt.text = "Owned";
                            };
                            if (Character.isItemOwned(this.historyData[_local_3].prizes[_local_4]) > 0)
                            {
                                _local_1[("history" + _local_2)][("iconMc0_" + _local_4)].ownedTxt.visible = true;
                                _local_1[("history" + _local_2)][("iconMc0_" + _local_4)].ownedTxt.text = "Owned";
                            };
                            NinjaSage.loadItemIcon(_local_1[("history" + _local_2)][("iconMc0_" + _local_4)], this.historyData[_local_3].prizes[_local_4]);
                        };
                        _local_4++;
                    };
                };
                _local_2++;
            };
        }

        private function changePageHistory(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btnNext":
                    if (this.totalPageHistory > this.currentPageHistory)
                    {
                        this.currentPageHistory++;
                        this.renderHistory();
                    };
                    break;
                case "btnPrev":
                    if (this.currentPageHistory > 1)
                    {
                        this.currentPageHistory--;
                        this.renderHistory();
                    };
            };
            this.updatePageNumber();
        }

        private function updatePageNumber():void
        {
            this.panelMC.historyMC.pageTxt.text = ((this.currentPageHistory + "/") + this.totalPageHistory);
        }

        private function closeHistory(_arg_1:MouseEvent):void
        {
            this.panelMC.historyMC.visible = false;
        }

        private function joinGiveaway(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("GiveawayService.participate", [Character.char_id, Character.sessionkey, this.response.giveaways[this.selectedTabIndex].id], this.joinResponse);
        }

        private function joinResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response.giveaways[this.selectedTabIndex].joined = 1;
                this.panelMC.btn_join.visible = false;
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function updateTimeleft():void
        {
            if (this.timestamp == null)
            {
                return;
            };
            var _local_1:* = 86400;
            var _local_2:* = 3600;
            var _local_3:* = 60;
            var _local_4:* = this.timestamp;
            var _local_5:* = Math.floor((_local_4 / _local_1));
            var _local_6:* = Math.floor(((_local_4 - (_local_5 * _local_1)) / _local_2));
            var _local_7:* = Math.floor((((_local_4 - (_local_5 * _local_1)) - (_local_6 * _local_2)) / _local_3));
            this.panelMC.timestamp.dayTxt.text = _local_5;
            this.panelMC.timestamp.hourTxt.text = _local_6;
            this.panelMC.timestamp.minTxt.text = _local_7;
            this.timeout = setTimeout(this.updateTimeleft, 10000);
            this.timestamp = (this.timestamp - 10);
            if (this.timestamp < 0)
            {
                this.timestamp = 0;
            };
            this.response.giveaways[this.selectedTabIndex].timestamp = this.timestamp;
        }

        public function hoverOver(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        public function hoverOut(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            if (this.timeout)
            {
                clearTimeout(this.timeout);
            };
            this.main.removeExternalSwfPanel();
            this.eventHandler.removeAllEventListeners();
            this.main = null;
            this.eventHandler = null;
            this.timestamp = null;
            this.response = null;
            this.historyData = null;
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
        }


    }
}//package id.ninjasage.features

