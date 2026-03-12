// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.DailyGacha

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class DailyGacha extends MovieClip 
    {

        private static const MATERIAL_GACHA:String = "material_874";

        private const PRICE_COINS:Array = [1, 3];
        private const PRICE_TOKENS:Array = [50, 100, 250];

        public var panelMC:MovieClip;
        private var main:*;
        private var character:*;
        private var eventHandler:*;
        private var selectedGacha:String;
        private var playType:String;
        private var playQty:int;
        private var topRewardData:Array = [];
        private var middleRewardData:Array = [];
        private var bottomRewardData:Array = [];
        private var currentPageMiddle:int = 1;
        private var totalPageMiddle:int = 0;
        private var currentPageBottom:int = 1;
        private var totalPageBottom:int = 0;
        private var currentPageHistory:int = 1;
        private var totalPageHistory:int = 1;
        private var bonusData:Array = [];
        private var historyData:Array;

        public function DailyGacha(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.getEventData();
            this.initUI();
        }

        private function getEventData():void
        {
            this.main.loading(false);
            this.main.amf_manager.service("ChristmasEvent2021.getData", [Character.sessionkey, Character.char_id, Character.account_id], this.eventDataResponse);
        }

        private function eventDataResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.panelMC.tokenTxt.text = String(Character.account_tokens);
                this.panelMC.IconTxt.text = _arg_1.coin;
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

        private function initUI():void
        {
            this.main.handleVillageHUDVisibility(false);
            this.panelMC.popupPrizeListMC.visible = false;
            this.panelMC.bonusMC.visible = false;
            this.panelMC.btnSkip.tick.visible = false;
            this.panelMC.historyMC.visible = false;
            this.panelMC.machineMC.gotoAndStop("idle");
            this.panelMC.titleTxt.text = "Daily Lucky Draw";
            this.main.initButton(this.panelMC.getMoreBtn, this.openRecharge, "Get More");
            this.main.initButton(this.panelMC.btnPanelMc.ticketBtn_1, this.playGacha, this.PRICE_COINS[0]);
            this.main.initButton(this.panelMC.btnPanelMc.tokenBtn_1, this.playGacha, this.PRICE_TOKENS[0]);
            this.main.initButton(this.panelMC.btnPanelMc.tokenBtn_2, this.playGacha, this.PRICE_TOKENS[2]);
            this.main.initButton(this.panelMC.btnPanelMc.ticketBtn_3, this.playGacha, this.PRICE_COINS[1]);
            this.main.initButton(this.panelMC.btnPanelMc.tokenBtn_3, this.playGacha, this.PRICE_TOKENS[1]);
            this.main.initButton(this.panelMC.btnPanelMc.prizelistBtn, this.showPrizeList, "Prize List");
            this.main.initButton(this.panelMC.btnPanelMc.historyBtn, this.openBonusRewards, "Bonus Reward");
            this.main.initButton(this.panelMC.btnPanelMc.worldBtn, this.openHistory, "Global History");
            this.main.initButton(this.panelMC.btnPanelMc.personalBtn, this.openHistory, "Personal History");
            this.eventHandler.addListener(this.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btnSkip, MouseEvent.CLICK, this.skipAnimation);
        }

        private function playGacha(_arg_1:MouseEvent):void
        {
            this.selectedGacha = _arg_1.currentTarget.name;
            if (this.panelMC.btnSkip.tick.visible)
            {
                this.sendAmf();
                this.main.initButtonDisable(this.panelMC.btnPanelMc.ticketBtn_1, this.playGacha, this.PRICE_COINS[0]);
                this.main.initButtonDisable(this.panelMC.btnPanelMc.tokenBtn_1, this.playGacha, this.PRICE_TOKENS[0]);
                this.main.initButtonDisable(this.panelMC.btnPanelMc.tokenBtn_2, this.playGacha, this.PRICE_TOKENS[2]);
                this.main.initButtonDisable(this.panelMC.btnPanelMc.ticketBtn_3, this.playGacha, this.PRICE_COINS[1]);
                this.main.initButtonDisable(this.panelMC.btnPanelMc.tokenBtn_3, this.playGacha, this.PRICE_TOKENS[1]);
                return;
            };
            this.panelMC.machineMC.addFrameScript(88, this.sendAmf, 95, this.stopMachine);
            this.panelMC.machineMC.gotoAndPlay("draw");
            this.main.initButtonDisable(this.panelMC.btnPanelMc.ticketBtn_1, this.playGacha, this.PRICE_COINS[0]);
            this.main.initButtonDisable(this.panelMC.btnPanelMc.tokenBtn_1, this.playGacha, this.PRICE_TOKENS[0]);
            this.main.initButtonDisable(this.panelMC.btnPanelMc.tokenBtn_2, this.playGacha, this.PRICE_TOKENS[2]);
            this.main.initButtonDisable(this.panelMC.btnPanelMc.ticketBtn_3, this.playGacha, this.PRICE_COINS[1]);
            this.main.initButtonDisable(this.panelMC.btnPanelMc.tokenBtn_3, this.playGacha, this.PRICE_TOKENS[1]);
        }

        private function stopMachine():*
        {
            this.panelMC.machineMC.gotoAndStop("idle");
        }

        private function sendAmf():*
        {
            this.playType = "";
            switch (this.selectedGacha)
            {
                case "ticketBtn_1":
                    this.playType = "coins";
                    this.playQty = 1;
                    break;
                case "tokenBtn_1":
                    this.playType = "tokens";
                    this.playQty = 1;
                    break;
                case "tokenBtn_2":
                    this.playType = "tokens";
                    this.playQty = 6;
                    break;
                case "ticketBtn_3":
                    this.playType = "coins";
                    this.playQty = 3;
                    break;
                case "tokenBtn_3":
                    this.playType = "tokens";
                    this.playQty = 3;
                    break;
            };
            this.main.amf_manager.service("ChristmasEvent2021.getGachaRewards", [Character.sessionkey, Character.char_id, this.playType, this.playQty], this.getGachaRewardsRes);
        }

        private function getGachaRewardsRes(_arg_1:Object):void
        {
            var _local_2:String;
            var _local_3:int;
            if (_arg_1.status == 1)
            {
                if (this.playType == "coins")
                {
                    Character.removeMaterials(MATERIAL_GACHA, this.playQty);
                }
                else
                {
                    _local_2 = this.selectedGacha.replace("tokenBtn_", "");
                    _local_3 = ((int(_local_2) == 1) ? 0 : ((int(_local_2) == 2) ? 2 : 1));
                    Character.account_tokens = (Character.account_tokens - this.PRICE_TOKENS[_local_3]);
                };
                Character.addRewards(_arg_1.rewards);
                this.main.giveReward(1, _arg_1.rewards, "moyai");
                this.panelMC.tokenTxt.text = String(Character.account_tokens);
                this.panelMC.IconTxt.text = String(_arg_1.coin);
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
            this.main.initButton(this.panelMC.btnPanelMc.ticketBtn_1, this.playGacha, this.PRICE_COINS[0]);
            this.main.initButton(this.panelMC.btnPanelMc.tokenBtn_1, this.playGacha, this.PRICE_TOKENS[0]);
            this.main.initButton(this.panelMC.btnPanelMc.tokenBtn_2, this.playGacha, this.PRICE_TOKENS[2]);
            this.main.initButton(this.panelMC.btnPanelMc.ticketBtn_3, this.playGacha, this.PRICE_COINS[1]);
            this.main.initButton(this.panelMC.btnPanelMc.tokenBtn_3, this.playGacha, this.PRICE_TOKENS[1]);
        }

        private function openBonusRewards(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("ChristmasEvent2021.getBonusRewards", [Character.sessionkey, Character.char_id, Character.account_id], this.openBonusRewardsRes);
        }

        private function openBonusRewardsRes(_arg_1:Object):void
        {
            var _local_2:int;
            var _local_3:*;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.bonusData = _arg_1.data;
                this.panelMC.bonusMC.visible = true;
                this.eventHandler.addListener(this.panelMC.bonusMC.btn_close, MouseEvent.CLICK, this.closeBonusRewards);
                this.panelMC.bonusMC.txt_draws.text = (("You've drawn " + _arg_1.total_spins) + " times !");
                _local_2 = 0;
                while (_local_2 < this.bonusData.length)
                {
                    _local_3 = (((_arg_1.data[_local_2].claimed == false) && (_arg_1.total_spins >= int(this.bonusData[_local_2].req))) ? true : false);
                    this.panelMC.bonusMC[("btn_claim_" + _local_2)].visible = _local_3;
                    this.panelMC.bonusMC[("txt_draw_" + _local_2)].text = (this.bonusData[_local_2].req + " Draws");
                    if (_local_3)
                    {
                        this.eventHandler.addListener(this.panelMC.bonusMC[("btn_claim_" + _local_2)], MouseEvent.CLICK, this.onClaimBonusRequest);
                    };
                    _local_2++;
                };
                this.showRewardsBonus();
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

        private function showRewardsBonus():void
        {
            var _local_2:int;
            var _local_1:int;
            while (_local_1 < this.bonusData.length)
            {
                this.panelMC.bonusMC[("iconMc" + _local_1)].visible = true;
                this.panelMC.bonusMC[("iconMc" + _local_1)].amountTxt.visible = false;
                this.panelMC.bonusMC[("iconMc" + _local_1)].ownedTxt.visible = false;
                if (Character.hasSkill(this.bonusData[_local_1].id) > 0)
                {
                    this.panelMC.bonusMC[("iconMc" + _local_1)].ownedTxt.visible = true;
                    this.panelMC.bonusMC[("iconMc" + _local_1)].ownedTxt.text = "Owned";
                };
                if (Character.isItemOwned(this.bonusData[_local_1].id) > 0)
                {
                    this.panelMC.bonusMC[("iconMc" + _local_1)].ownedTxt.visible = true;
                    this.panelMC.bonusMC[("iconMc" + _local_1)].ownedTxt.text = "Owned";
                };
                _local_2 = this.bonusData[_local_1].id.split(":")[1];
                if (_local_2 > 1)
                {
                    this.panelMC.bonusMC[("iconMc" + _local_1)].amountTxt.visible = true;
                    this.panelMC.bonusMC[("iconMc" + _local_1)].amountTxt.text = ("x" + String(_local_2));
                };
                NinjaSage.loadItemIcon(this.panelMC.bonusMC[("iconMc" + _local_1)], this.bonusData[_local_1].id);
                _local_1++;
            };
        }

        private function onClaimBonusRequest(_arg_1:MouseEvent):void
        {
            var _local_2:int = int(_arg_1.currentTarget.name.replace("btn_claim_", ""));
            this.main.amf_manager.service("ChristmasEvent2021.claimBonusGachaRewards", [Character.sessionkey, Character.char_id, _local_2], this.onClaimBonusResponse);
        }

        private function onClaimBonusResponse(_arg_1:Object):void
        {
            if (_arg_1.status > 0)
            {
                if (_arg_1.status == 1)
                {
                    this.panelMC.bonusMC.visible = false;
                    Character.addRewards(_arg_1.reward);
                    this.main.HUD.setBasicData();
                    this.main.giveReward(1, _arg_1.reward, "moyai");
                    this.panelMC.tokenTxt.text = String(Character.account_tokens);
                }
                else
                {
                    this.main.showMessage(_arg_1.result);
                };
            }
            else
            {
                this.main.getError(_arg_1.error);
            };
        }

        private function closeBonusRewards(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            while (_local_2 < 8)
            {
                this.panelMC.bonusMC[("iconMc" + _local_2)].rewardIcon.tooltip = null;
                this.panelMC.bonusMC[("iconMc" + _local_2)].skillIcon.tooltip = null;
                GF.removeAllChild(this.panelMC.bonusMC[("iconMc" + _local_2)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.bonusMC[("iconMc" + _local_2)].skillIcon.iconHolder);
                _local_2++;
            };
            this.panelMC.bonusMC.visible = false;
            System.gc();
        }

        private function showPrizeList(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("ChristmasEvent2021.getRewardList", [Character.sessionkey, Character.char_id], this.prizeListResponse);
        }

        private function prizeListResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.topRewardData = _arg_1.top;
                this.middleRewardData = _arg_1.mid;
                this.bottomRewardData = _arg_1.common;
                this.panelMC.popupPrizeListMC.visible = true;
                this.eventHandler.addListener(this.panelMC.popupPrizeListMC.panelMC.prevBtn_1, MouseEvent.CLICK, this.changePage);
                this.eventHandler.addListener(this.panelMC.popupPrizeListMC.panelMC.nextBtn_1, MouseEvent.CLICK, this.changePage);
                this.eventHandler.addListener(this.panelMC.popupPrizeListMC.panelMC.prevBtn_2, MouseEvent.CLICK, this.changePage);
                this.eventHandler.addListener(this.panelMC.popupPrizeListMC.panelMC.nextBtn_2, MouseEvent.CLICK, this.changePage);
                this.eventHandler.addListener(this.panelMC.popupPrizeListMC.panelMC.btnClose, MouseEvent.CLICK, this.closePrizeList);
                this.panelMC.popupPrizeListMC.panelMC.titleTxt.text = "Reward List";
                this.panelMC.popupPrizeListMC.panelMC.dec1Txt.text = "Biggest Prize";
                this.panelMC.popupPrizeListMC.panelMC.dec2Txt.text = "Medium Prize";
                this.panelMC.popupPrizeListMC.panelMC.dec3Txt.text = "Consolation Prize";
                this.showRewardsTop();
                this.showRewardsMiddle();
                this.showRewardsBottom();
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

        private function closePrizeList(_arg_1:MouseEvent):*
        {
            this.panelMC.popupPrizeListMC.visible = false;
            this.currentPageMiddle = 1;
            this.currentPageBottom = 1;
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < 2)
            {
                this.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_2)].rewardIcon.tooltip = null;
                this.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_2)].skillIcon.tooltip = null;
                GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_2)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_2)].skillIcon.iconHolder);
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < 10)
            {
                this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_2)].rewardIcon.tooltip = null;
                this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_2)].skillIcon.tooltip = null;
                GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_2)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_2)].skillIcon.iconHolder);
                GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_2)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_2)].skillIcon.iconHolder);
                _local_2++;
            };
            System.gc();
        }

        private function openHistory(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            var _local_2:* = _arg_1.currentTarget.name;
            if (_local_2 == "personalBtn")
            {
                this.panelMC.historyMC.titleTxt.text = "Personal Prize History";
                this.main.amf_manager.service("ChristmasEvent2021.getPersonalGachaHistory", [Character.char_id, Character.sessionkey], this.historyResponse);
            }
            else
            {
                this.panelMC.historyMC.titleTxt.text = "Global Prize History";
                this.main.amf_manager.service("ChristmasEvent2021.getGlobalGachaHistory", [Character.char_id, Character.sessionkey], this.historyResponse);
            };
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
            this.panelMC.historyMC.visible = true;
            this.eventHandler.addListener(this.panelMC.historyMC.btnClose, MouseEvent.CLICK, this.closeHistory);
            this.eventHandler.addListener(this.panelMC.historyMC.btn_next, MouseEvent.CLICK, this.changePageHistory);
            this.eventHandler.addListener(this.panelMC.historyMC.btn_prev, MouseEvent.CLICK, this.changePageHistory);
            this.totalPageHistory = Math.max(1, Math.ceil((this.historyData.length / 10)));
            this.updatePageNumberHistory();
            this.renderHistoryList();
        }

        private function renderHistoryList():void
        {
            var _local_2:int;
            var _local_1:int;
            while (_local_1 < 10)
            {
                _local_2 = (_local_1 + int((int((this.currentPageHistory - 1)) * 10)));
                this.panelMC.historyMC[("history_" + _local_1)].visible = false;
                this.panelMC.historyMC[("history_" + _local_1)].coinIcon.visible = false;
                this.panelMC.historyMC[("history_" + _local_1)].tokenIcon.visible = false;
                if (this.historyData.length > _local_2)
                {
                    this.panelMC.historyMC[("history_" + _local_1)].visible = true;
                    this.panelMC.historyMC[("history_" + _local_1)].rankTxt.text = String((_local_2 + 1));
                    this.panelMC.historyMC[("history_" + _local_1)].nameTxt.text = ((("[" + this.historyData[_local_2].id) + "] ") + this.historyData[_local_2].name);
                    this.panelMC.historyMC[("history_" + _local_1)].levelTxt.text = this.historyData[_local_2].level;
                    this.panelMC.historyMC[("history_" + _local_1)].detailTxt.text = (((this.historyData[_local_2].obtained_at + " | Draw ") + this.historyData[_local_2].spin) + "x");
                    if ((this.historyData[_local_2].currency == 1))
                    {
                        this.panelMC.historyMC[("history_" + _local_1)].tokenIcon.visible = true;
                    }
                    else
                    {
                        this.panelMC.historyMC[("history_" + _local_1)].coinIcon.visible = true;
                    };
                    NinjaSage.loadItemIcon(this.panelMC.historyMC[("history_" + _local_1)].iconMC, this.historyData[_local_2].reward);
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
            this.panelMC.historyMC.pageTxt.text = ((this.currentPageHistory + "/") + this.totalPageHistory);
        }

        private function closeHistory(_arg_1:MouseEvent):void
        {
            this.panelMC.historyMC.visible = false;
            this.currentPageHistory = 1;
            this.totalPageHistory = 1;
            this.eventHandler.removeListener(this.panelMC.historyMC.btnClose, MouseEvent.CLICK, this.closeHistory);
            this.eventHandler.removeListener(this.panelMC.historyMC.btn_next, MouseEvent.CLICK, this.changePageHistory);
            this.eventHandler.removeListener(this.panelMC.historyMC.btn_prev, MouseEvent.CLICK, this.changePageHistory);
            var _local_2:int;
            while (_local_2 < 10)
            {
                this.panelMC.historyMC[("history_" + _local_2)].iconMC.rewardIcon.tooltip = null;
                this.panelMC.historyMC[("history_" + _local_2)].iconMC.skillIcon.tooltip = null;
                GF.removeAllChild(this.panelMC.historyMC[("history_" + _local_2)].iconMC.rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.historyMC[("history_" + _local_2)].iconMC.skillIcon.iconHolder);
                _local_2++;
            };
        }

        private function showRewardsTop():void
        {
            var _local_1:int;
            while (_local_1 < this.topRewardData.length)
            {
                this.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].visible = true;
                this.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].amountTxt.visible = false;
                this.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].ownedTxt.visible = false;
                if (Character.hasSkill(this.topRewardData[_local_1]) > 0)
                {
                    this.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].ownedTxt.visible = true;
                    this.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].ownedTxt.text = "Owned";
                };
                if (Character.isItemOwned(this.topRewardData[_local_1]) > 0)
                {
                    this.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].ownedTxt.visible = true;
                    this.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)].ownedTxt.text = "Owned";
                };
                NinjaSage.loadItemIcon(this.panelMC.popupPrizeListMC.panelMC[("IconMc0_" + _local_1)], this.topRewardData[_local_1]);
                _local_1++;
            };
        }

        private function showRewardsMiddle():void
        {
            var _local_2:int;
            var _local_1:int;
            while (_local_1 < 10)
            {
                _local_2 = (_local_1 + int((int((this.currentPageMiddle - 1)) * 10)));
                this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].visible = false;
                if (this.middleRewardData.length > _local_2)
                {
                    this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].visible = true;
                    this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].amountTxt.visible = false;
                    this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].ownedTxt.visible = false;
                    if (Character.hasSkill(this.middleRewardData[_local_2]) > 0)
                    {
                        this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].ownedTxt.visible = true;
                        this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].ownedTxt.text = "Owned";
                    };
                    if (Character.isItemOwned(this.middleRewardData[_local_2]) > 0)
                    {
                        this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].ownedTxt.visible = true;
                        this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].ownedTxt.text = "Owned";
                    };
                    GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].rewardIcon.iconHolder);
                    GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)].skillIcon.iconHolder);
                    NinjaSage.loadItemIcon(this.panelMC.popupPrizeListMC.panelMC[("IconMc1_" + _local_1)], this.middleRewardData[_local_2]);
                };
                _local_1++;
            };
            this.updatePageNumber();
            this.totalPageMiddle = Math.ceil((this.middleRewardData.length / 10));
        }

        private function showRewardsBottom():void
        {
            var _local_2:int;
            var _local_1:int;
            while (_local_1 < 10)
            {
                _local_2 = (_local_1 + int((int((this.currentPageBottom - 1)) * 10)));
                this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].visible = false;
                if (this.bottomRewardData.length > _local_2)
                {
                    this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].visible = true;
                    this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].amountTxt.visible = false;
                    this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].ownedTxt.visible = false;
                    if (Character.hasSkill(this.bottomRewardData[_local_2]) > 0)
                    {
                        this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].ownedTxt.visible = true;
                        this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].ownedTxt.text = "Owned";
                    };
                    if (Character.isItemOwned(this.bottomRewardData[_local_2]) > 0)
                    {
                        this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].ownedTxt.visible = true;
                        this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].ownedTxt.text = "Owned";
                    };
                    GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].rewardIcon.iconHolder);
                    GF.removeAllChild(this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)].skillIcon.iconHolder);
                    NinjaSage.loadItemIcon(this.panelMC.popupPrizeListMC.panelMC[("IconMc2_" + _local_1)], this.bottomRewardData[_local_2]);
                };
                _local_1++;
            };
            this.updatePageNumber();
            this.totalPageBottom = Math.ceil((this.bottomRewardData.length / 10));
        }

        private function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "nextBtn_1":
                    if (this.totalPageMiddle > this.currentPageMiddle)
                    {
                        this.currentPageMiddle++;
                        this.showRewardsMiddle();
                    };
                    return;
                case "prevBtn_1":
                    if (this.currentPageMiddle > 1)
                    {
                        this.currentPageMiddle--;
                        this.showRewardsMiddle();
                    };
                    return;
                case "nextBtn_2":
                    if (this.totalPageBottom > this.currentPageBottom)
                    {
                        this.currentPageBottom++;
                        this.showRewardsBottom();
                    };
                    return;
                case "prevBtn_2":
                    if (this.currentPageBottom > 1)
                    {
                        this.currentPageBottom--;
                        this.showRewardsBottom();
                    };
                    return;
            };
        }

        private function updatePageNumber():*
        {
            if (this.currentPageMiddle == 1)
            {
                this.panelMC.popupPrizeListMC.panelMC.prevBtn_1.visible = false;
            }
            else
            {
                this.panelMC.popupPrizeListMC.panelMC.prevBtn_1.visible = true;
            };
            if (this.currentPageBottom == 1)
            {
                this.panelMC.popupPrizeListMC.panelMC.prevBtn_2.visible = false;
            }
            else
            {
                this.panelMC.popupPrizeListMC.panelMC.prevBtn_2.visible = true;
            };
            if (this.totalPageMiddle == this.currentPageMiddle)
            {
                this.panelMC.popupPrizeListMC.panelMC.nextBtn_1.visible = false;
            }
            else
            {
                this.panelMC.popupPrizeListMC.panelMC.nextBtn_1.visible = true;
            };
            if (this.totalPageBottom == this.currentPageBottom)
            {
                this.panelMC.popupPrizeListMC.panelMC.nextBtn_2.visible = false;
            }
            else
            {
                this.panelMC.popupPrizeListMC.panelMC.nextBtn_2.visible = true;
            };
        }

        private function skipAnimation(_arg_1:MouseEvent):void
        {
            this.panelMC.btnSkip.tick.visible = (!(this.panelMC.btnSkip.tick.visible));
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
            this.eventHandler.removeAllEventListeners();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.main.removeExternalSwfPanel();
            this.closeBonusRewards(null);
            this.closePrizeList(null);
            this.bonusData = [];
            this.topRewardData = [];
            this.middleRewardData = [];
            this.bottomRewardData = [];
            this.main = null;
            this.character = null;
            this.eventHandler = null;
            this.panelMC.stopAllMovieClips();
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

