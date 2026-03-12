// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.DragonGacha

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import Storage.GameData;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class DragonGacha extends MovieClip 
    {

        private static const MATERIAL_GACHA:String = "material_773";
        private static const TITLE_GACHA:String = "Dragon Gacha Draw";
        private static const SUBTITLE_GACHA:String = "Permanent Feature";

        private const PRICE_COINS:Array = [1, 2];
        private const PRICE_TOKENS:Array = [25, 50, 250];

        public var panelMC:MovieClip;
        private var main:*;
        private var character:*;
        private var eventHandler:*;
        private var selectedGacha:String;
        private var playType:String;
        private var playQty:int;
        private var topRewardData:Array;
        private var middleRewardData:Array;
        private var bottomRewardData:Array;
        private var currentPageTop:int = 1;
        private var totalPageTop:int = 1;
        private var currentPageMiddle:int = 1;
        private var totalPageMiddle:int = 1;
        private var currentPageBottom:int = 1;
        private var totalPageBottom:int = 1;
        private var currentPageHistory:int = 1;
        private var totalPageHistory:int = 1;
        private var historyData:Array;

        public function DragonGacha(_arg_1:*, _arg_2:*)
        {
            var _local_3:* = GameData.get("dragon_gacha");
            this.topRewardData = this.fillRewards(_local_3.top);
            this.middleRewardData = this.fillRewards(_local_3.mid);
            this.bottomRewardData = this.fillRewards(_local_3.common);
            super();
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.getEventData();
            this.initUI();
        }

        private function fillRewards(_arg_1:Array):Array
        {
            var _local_2:Array = [];
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                _local_2.push(_arg_1[_local_3].replace("%s", Character.character_gender));
                _local_3++;
            };
            return (_local_2);
        }

        private function getEventData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("DragonHuntEvent.getGachaData", [Character.char_id, Character.sessionkey, Character.account_id], this.eventDataResponse);
        }

        private function eventDataResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.panelMC.panelMC.tokenTxt.text = String(Character.account_tokens);
                this.panelMC.panelMC.IconTxt.text = _arg_1.coin;
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
                };
            };
        }

        private function initUI():void
        {
            this.main.handleVillageHUDVisibility(false);
            this.eventHandler.addListener(this.panelMC.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            this.panelMC.panelMC.popupPrizeListMC.visible = false;
            this.panelMC.panelMC.popupWorldHistoryMC.visible = false;
            this.panelMC.panelMC.popUpGetReward.visible = false;
            this.panelMC.panelMC.popUpGetReward.gotoAndStop(1);
            this.panelMC.panelMC.titleTxt.text = TITLE_GACHA;
            this.panelMC.panelMC.dateTxt.text = SUBTITLE_GACHA;
            this.main.initButton(this.panelMC.panelMC.getMoreBtn, this.openRecharge, "Get More");
            this.main.initButton(this.panelMC.panelMC.historyBtn, this.openHistory, "Global History");
            var _local_1:int;
            while (_local_1 < 3)
            {
                this.eventHandler.addListener(this.panelMC.panelMC[("List_" + _local_1)][("btn_change_icon" + _local_1)], MouseEvent.CLICK, this.showPrizeList);
                _local_1++;
            };
            this.gachaButtonHandler(true);
        }

        private function playGacha(_arg_1:MouseEvent):void
        {
            this.selectedGacha = _arg_1.currentTarget.name;
            this.gachaButtonHandler(false);
            this.playType = "";
            switch (this.selectedGacha)
            {
                case "ticket_1Btn":
                    this.playType = "coins";
                    this.playQty = 1;
                    break;
                case "token_1Btn":
                    this.playType = "tokens";
                    this.playQty = 1;
                    break;
                case "token_2Btn":
                    this.playType = "tokens";
                    this.playQty = 2;
                    break;
                case "ticket_2Btn":
                    this.playType = "coins";
                    this.playQty = 2;
                    break;
                case "token_6Btn":
                    this.playType = "tokens";
                    this.playQty = 6;
                    break;
            };
            this.main.amf_manager.service("DragonHuntEvent.getGachaRewards", [Character.char_id, Character.sessionkey, this.playType, this.playQty], this.getGachaRewardsRes);
        }

        private function getGachaRewardsRes(_arg_1:Object):void
        {
            var _local_2:int;
            if (_arg_1.status == 1)
            {
                if (this.playType == "coins")
                {
                    Character.removeMaterials(MATERIAL_GACHA, this.playQty);
                }
                else
                {
                    _local_2 = ((this.selectedGacha == "token_1Btn") ? 0 : ((this.selectedGacha == "token_2Btn") ? 1 : 2));
                    Character.account_tokens = (Character.account_tokens - this.PRICE_TOKENS[_local_2]);
                };
                Character.addRewards(_arg_1.rewards);
                this.panelMC.panelMC.tokenTxt.text = Character.account_tokens;
                this.panelMC.panelMC.IconTxt.text = String(_arg_1.coin);
                this.main.HUD.setBasicData();
                this.playGetRewardAnimation(_arg_1.rewards);
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
            this.gachaButtonHandler(true);
        }

        private function playGetRewardAnimation(_arg_1:Array):void
        {
            this.panelMC.panelMC.popUpGetReward.addFrameScript(13, this.stopReward);
            this.panelMC.panelMC.popUpGetReward.visible = true;
            this.eventHandler.addListener(this.panelMC.panelMC.popUpGetReward.panelMC.btnOk, MouseEvent.CLICK, this.closeGetReward);
            this.eventHandler.addListener(this.panelMC.panelMC.popUpGetReward.bg, MouseEvent.CLICK, this.closeGetReward);
            this.panelMC.panelMC.popUpGetReward.panelMC.titleTxt.text = "Congratulations";
            var _local_2:String = ((this.selectedGacha == "token_6Btn") ? "six" : "one");
            this.panelMC.panelMC.popUpGetReward.panelMC.gotoAndStop(_local_2);
            var _local_3:int = ((this.panelMC.panelMC.popUpGetReward.panelMC.currentLabel == "six") ? 6 : 1);
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                NinjaSage.loadItemIcon(this.panelMC.panelMC.popUpGetReward.panelMC[("IconMC" + _local_4)], _arg_1[_local_4]);
                _local_4++;
            };
            this.panelMC.panelMC.popUpGetReward.gotoAndPlay(1);
        }

        public function stopReward():void
        {
            this.panelMC.panelMC.popUpGetReward.stop();
        }

        private function closeGetReward(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMC.popUpGetReward.visible = false;
            this.panelMC.panelMC.popUpGetReward.gotoAndStop(1);
            this.eventHandler.removeListener(this.panelMC.panelMC.popUpGetReward.panelMC.btnOk, MouseEvent.CLICK, this.closeGetReward);
            this.eventHandler.removeListener(this.panelMC.panelMC.popUpGetReward.bg, MouseEvent.CLICK, this.closeGetReward);
            var _local_2:int = ((this.panelMC.panelMC.popUpGetReward.panelMC.currentLabel == "six") ? 6 : 1);
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                GF.removeAllChild(this.panelMC.panelMC.popUpGetReward.panelMC[("IconMC" + _local_3)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.panelMC.popUpGetReward.panelMC[("IconMC" + _local_3)].skillIcon.iconHolder);
                _local_3++;
            };
        }

        private function showPrizeList(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMC.popupPrizeListMC.visible = true;
            this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.rank1PrevBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.rank1NextBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.rank2PrevBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.rank2NextBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.rank3PrevBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.rank3NextBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.panelMC.popupPrizeListMC.panelMC.btnClose, MouseEvent.CLICK, this.closePrizeList);
            this.panelMC.panelMC.popupPrizeListMC.panelMC.titleTxt.text = "Reward List";
            this.totalPageTop = Math.ceil((this.topRewardData.length / 12));
            this.totalPageMiddle = Math.ceil((this.middleRewardData.length / 12));
            this.totalPageBottom = Math.ceil((this.bottomRewardData.length / 12));
            this.updatePageNumber();
            this.showRewardsTop();
            this.showRewardsMiddle();
            this.showRewardsBottom();
        }

        private function closePrizeList(_arg_1:MouseEvent):*
        {
            this.panelMC.panelMC.popupPrizeListMC.visible = false;
            this.currentPageTop = 1;
            this.currentPageMiddle = 1;
            this.currentPageBottom = 1;
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < 12)
            {
                this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_2)].rewardIcon.tooltip = null;
                this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_2)].skillIcon.tooltip = null;
                this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_2)].rewardIcon.tooltip = null;
                this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_2)].skillIcon.tooltip = null;
                this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_2)].rewardIcon.tooltip = null;
                this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_2)].skillIcon.tooltip = null;
                GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_2)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_2)].skillIcon.iconHolder);
                GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_2)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_2)].skillIcon.iconHolder);
                GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_2)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_2)].skillIcon.iconHolder);
                _local_2++;
            };
            System.gc();
        }

        private function openHistory(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("DragonHuntEvent.getGlobalGachaHistory", [Character.char_id, Character.sessionkey], this.historyResponse);
        }

        private function historyResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.historyData = _arg_1.histories;
                this.initHistory();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function initHistory():void
        {
            this.panelMC.panelMC.popupWorldHistoryMC.visible = true;
            this.panelMC.panelMC.popupWorldHistoryMC.panelMC.titleTxt.text = "Global Prize History";
            this.eventHandler.addListener(this.panelMC.panelMC.popupWorldHistoryMC.panelMC.btnClose, MouseEvent.CLICK, this.closeHistory);
            this.eventHandler.addListener(this.panelMC.panelMC.popupWorldHistoryMC.panelMC.btn_next, MouseEvent.CLICK, this.changePageHistory);
            this.eventHandler.addListener(this.panelMC.panelMC.popupWorldHistoryMC.panelMC.btn_prev, MouseEvent.CLICK, this.changePageHistory);
            this.totalPageHistory = Math.max(1, Math.ceil((this.historyData.length / 7)));
            this.updatePageNumberHistory();
            this.renderHistoryList();
        }

        private function renderHistoryList():void
        {
            var _local_2:int;
            var _local_1:int;
            while (_local_1 < 7)
            {
                _local_2 = (_local_1 + int((int((this.currentPageHistory - 1)) * 7)));
                this.panelMC.panelMC.popupWorldHistoryMC.panelMC[("item_" + _local_1)].visible = false;
                if (this.historyData.length > _local_2)
                {
                    this.panelMC.panelMC.popupWorldHistoryMC.panelMC[("item_" + _local_1)].visible = true;
                    this.panelMC.panelMC.popupWorldHistoryMC.panelMC[("item_" + _local_1)].rankTxt.text = String((_local_2 + 1));
                    this.panelMC.panelMC.popupWorldHistoryMC.panelMC[("item_" + _local_1)].nameTxt.text = ((("[" + this.historyData[_local_2].id) + "] ") + this.historyData[_local_2].name);
                    this.panelMC.panelMC.popupWorldHistoryMC.panelMC[("item_" + _local_1)].levelTxt.text = this.historyData[_local_2].level;
                    this.panelMC.panelMC.popupWorldHistoryMC.panelMC[("item_" + _local_1)].detailTxt.text = (((this.historyData[_local_2].obtained_at + " | Draw ") + this.historyData[_local_2].spin) + "x");
                    NinjaSage.loadItemIcon(this.panelMC.panelMC.popupWorldHistoryMC.panelMC[("item_" + _local_1)].iconMC, this.historyData[_local_2].reward);
                };
                _local_1++;
            };
        }

        private function changePageHistory(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.totalPageHistory > this.currentPageHistory)
                    {
                        this.currentPageHistory++;
                        this.renderHistoryList();
                    };
                    break;
                case "btn_prev":
                    if (this.currentPageHistory > 1)
                    {
                        this.currentPageHistory--;
                        this.renderHistoryList();
                    };
                    break;
            };
            this.updatePageNumberHistory();
        }

        private function updatePageNumberHistory():void
        {
            this.panelMC.panelMC.popupWorldHistoryMC.panelMC.pageTxt.text = ((this.currentPageHistory + "/") + this.totalPageHistory);
        }

        private function closeHistory(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMC.popupWorldHistoryMC.visible = false;
            this.currentPageHistory = 1;
            this.totalPageHistory = 1;
            this.eventHandler.removeListener(this.panelMC.panelMC.popupWorldHistoryMC.panelMC.btnClose, MouseEvent.CLICK, this.closeHistory);
            this.eventHandler.removeListener(this.panelMC.panelMC.popupWorldHistoryMC.panelMC.btn_next, MouseEvent.CLICK, this.changePageHistory);
            this.eventHandler.removeListener(this.panelMC.panelMC.popupWorldHistoryMC.panelMC.btn_prev, MouseEvent.CLICK, this.changePageHistory);
            var _local_2:int;
            while (_local_2 < 7)
            {
                this.panelMC.panelMC.popupWorldHistoryMC.panelMC[("item_" + _local_2)].iconMC.rewardIcon.tooltip = null;
                this.panelMC.panelMC.popupWorldHistoryMC.panelMC[("item_" + _local_2)].iconMC.skillIcon.tooltip = null;
                GF.removeAllChild(this.panelMC.panelMC.popupWorldHistoryMC.panelMC[("item_" + _local_2)].iconMC.rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.panelMC.popupWorldHistoryMC.panelMC[("item_" + _local_2)].iconMC.skillIcon.iconHolder);
                _local_2++;
            };
        }

        private function showRewardsTop():void
        {
            var _local_2:int;
            var _local_1:int;
            while (_local_1 < 12)
            {
                _local_2 = (_local_1 + int((int((this.currentPageTop - 1)) * 12)));
                this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].visible = false;
                if (this.topRewardData.length > _local_2)
                {
                    this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].visible = true;
                    this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].amountTxt.visible = false;
                    this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].ownedTxt.visible = false;
                    if (Character.hasSkill(this.topRewardData[_local_2]) > 0)
                    {
                        this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].ownedTxt.visible = true;
                        this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].ownedTxt.text = "Owned";
                    };
                    if (Character.isItemOwned(this.topRewardData[_local_2]) > 0)
                    {
                        this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].ownedTxt.visible = true;
                        this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].ownedTxt.text = "Owned";
                    };
                    GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].rewardIcon.iconHolder);
                    GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].skillIcon.iconHolder);
                    NinjaSage.loadItemIcon(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)], this.topRewardData[_local_2]);
                };
                _local_1++;
            };
        }

        private function showRewardsMiddle():void
        {
            var _local_2:int;
            var _local_1:int;
            while (_local_1 < 12)
            {
                _local_2 = (_local_1 + int((int((this.currentPageMiddle - 1)) * 12)));
                this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].visible = false;
                if (this.middleRewardData.length > _local_2)
                {
                    this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].visible = true;
                    this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].amountTxt.visible = false;
                    this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].ownedTxt.visible = false;
                    if (Character.hasSkill(this.middleRewardData[_local_2]) > 0)
                    {
                        this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].ownedTxt.visible = true;
                        this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].ownedTxt.text = "Owned";
                    };
                    if (Character.isItemOwned(this.middleRewardData[_local_2]) > 0)
                    {
                        this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].ownedTxt.visible = true;
                        this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].ownedTxt.text = "Owned";
                    };
                    GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].rewardIcon.iconHolder);
                    GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].skillIcon.iconHolder);
                    NinjaSage.loadItemIcon(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)], this.middleRewardData[_local_2]);
                };
                _local_1++;
            };
        }

        private function showRewardsBottom():void
        {
            var _local_2:int;
            var _local_1:int;
            while (_local_1 < 12)
            {
                _local_2 = (_local_1 + int((int((this.currentPageBottom - 1)) * 12)));
                this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].visible = false;
                if (this.bottomRewardData.length > _local_2)
                {
                    this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].visible = true;
                    this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].amountTxt.visible = false;
                    this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].ownedTxt.visible = false;
                    if (Character.hasSkill(this.bottomRewardData[_local_2]) > 0)
                    {
                        this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].ownedTxt.visible = true;
                        this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].ownedTxt.text = "Owned";
                    };
                    if (Character.isItemOwned(this.bottomRewardData[_local_2]) > 0)
                    {
                        this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].ownedTxt.visible = true;
                        this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].ownedTxt.text = "Owned";
                    };
                    GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].rewardIcon.iconHolder);
                    GF.removeAllChild(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].skillIcon.iconHolder);
                    NinjaSage.loadItemIcon(this.panelMC.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)], this.bottomRewardData[_local_2]);
                };
                _local_1++;
            };
        }

        private function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "rank1NextBtn":
                    if (this.totalPageTop > this.currentPageTop)
                    {
                        this.currentPageTop++;
                        this.showRewardsTop();
                    };
                    break;
                case "rank1PrevBtn":
                    if (this.currentPageTop > 1)
                    {
                        this.currentPageTop--;
                        this.showRewardsTop();
                    };
                    break;
                case "rank2NextBtn":
                    if (this.totalPageMiddle > this.currentPageMiddle)
                    {
                        this.currentPageMiddle++;
                        this.showRewardsMiddle();
                    };
                    break;
                case "rank2PrevBtn":
                    if (this.currentPageMiddle > 1)
                    {
                        this.currentPageMiddle--;
                        this.showRewardsMiddle();
                    };
                    break;
                case "rank3NextBtn":
                    if (this.totalPageBottom > this.currentPageBottom)
                    {
                        this.currentPageBottom++;
                        this.showRewardsBottom();
                    };
                    break;
                case "rank3PrevBtn":
                    if (this.currentPageBottom > 1)
                    {
                        this.currentPageBottom--;
                        this.showRewardsBottom();
                    };
                    break;
            };
            this.updatePageNumber();
        }

        private function updatePageNumber():*
        {
            if (this.currentPageTop == 1)
            {
                this.panelMC.panelMC.popupPrizeListMC.panelMC.rank1PrevBtn.visible = false;
            }
            else
            {
                this.panelMC.panelMC.popupPrizeListMC.panelMC.rank1PrevBtn.visible = true;
            };
            if (this.currentPageMiddle == 1)
            {
                this.panelMC.panelMC.popupPrizeListMC.panelMC.rank2PrevBtn.visible = false;
            }
            else
            {
                this.panelMC.panelMC.popupPrizeListMC.panelMC.rank2PrevBtn.visible = true;
            };
            if (this.currentPageBottom == 1)
            {
                this.panelMC.panelMC.popupPrizeListMC.panelMC.rank3PrevBtn.visible = false;
            }
            else
            {
                this.panelMC.panelMC.popupPrizeListMC.panelMC.rank3PrevBtn.visible = true;
            };
            if (this.totalPageTop == this.currentPageTop)
            {
                this.panelMC.panelMC.popupPrizeListMC.panelMC.rank1NextBtn.visible = false;
            }
            else
            {
                this.panelMC.panelMC.popupPrizeListMC.panelMC.rank1NextBtn.visible = true;
            };
            if (this.totalPageMiddle == this.currentPageMiddle)
            {
                this.panelMC.panelMC.popupPrizeListMC.panelMC.rank2NextBtn.visible = false;
            }
            else
            {
                this.panelMC.panelMC.popupPrizeListMC.panelMC.rank2NextBtn.visible = true;
            };
            if (this.totalPageBottom == this.currentPageBottom)
            {
                this.panelMC.panelMC.popupPrizeListMC.panelMC.rank3NextBtn.visible = false;
            }
            else
            {
                this.panelMC.panelMC.popupPrizeListMC.panelMC.rank3NextBtn.visible = true;
            };
        }

        private function gachaButtonHandler(_arg_1:Boolean=true):void
        {
            var _local_2:String = ((_arg_1) ? "initButton" : "initButtonDisable");
            var _local_3:* = this.main;
            (_local_3[_local_2](this.panelMC.panelMC.ticket_1Btn, this.playGacha, this.PRICE_COINS[0]));
            _local_3 = this.main;
            (_local_3[_local_2](this.panelMC.panelMC.ticket_2Btn, this.playGacha, this.PRICE_COINS[1]));
            _local_3 = this.main;
            (_local_3[_local_2](this.panelMC.panelMC.token_1Btn, this.playGacha, this.PRICE_TOKENS[0]));
            _local_3 = this.main;
            (_local_3[_local_2](this.panelMC.panelMC.token_2Btn, this.playGacha, this.PRICE_TOKENS[1]));
            _local_3 = this.main;
            (_local_3[_local_2](this.panelMC.panelMC.token_6Btn, this.playGacha, this.PRICE_TOKENS[2]));
        }

        private function openRecharge(_arg_1:MouseEvent):void
        {
            if ((_arg_1.currentTarget.name == "getMoreBtn"))
            {
                this.main.loadPanel("Panels.Recharge");
            }
            else
            {
                this.main.loadExternalSwfPanel("Headquarter", "Headquarter");
            };
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.main.handleVillageHUDVisibility(true);
            this.main.HUD.setBasicData();
            this.main.removeExternalSwfPanel();
            this.eventHandler.removeAllEventListeners();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.closePrizeList(null);
            this.topRewardData = [];
            this.middleRewardData = [];
            this.bottomRewardData = [];
            this.historyData = [];
            this.main = null;
            this.character = null;
            this.eventHandler = null;
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

