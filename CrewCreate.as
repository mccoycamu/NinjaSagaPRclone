// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.CrewCreate

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Popups.Confirmation;
    import id.ninjasage.Crew;
    import Storage.GameData;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import com.utils.GF;
    import id.ninjasage.Util;

    public dynamic class CrewCreate extends MovieClip 
    {

        private const CREATE_PRICE:int = 1000;

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var confirmation:Confirmation;
        private var rewardData:Object = Crew.instance.getRewardData();
        private var tokenPoolData:Object;
        private var crewDataOriginal:Array;
        private var crewData:Array;
        private var selectedCrewId:int = -1;
        private var currentPage:int = 1;
        private var totalPage:int = 0;

        public function CrewCreate(_arg_1:*, _arg_2:*)
        {
            var _local_3:Object = GameData.get("crew");
            this.tokenPoolData = _local_3.token_pool;
            super();
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.initButton();
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

        private function initUI():void
        {
            this.panelMC.requestMemberListMc.visible = false;
            this.panelMC.detailMC.gotoAndStop("idle");
            this.panelMC.lbl_create.text = "Create Crew";
            this.panelMC.lbl_enter.text = "Enter Crew Name: ";
            this.panelMC.lbl_fees.text = this.CREATE_PRICE;
            this.panelMC.lbl_token.text = "Tokens";
            this.panelMC.lbl_requestclan.text = "Request Join Crew";
            this.panelMC.lbl_requestclan_description.text = "Select a crew to apply for membership";
            this.panelMC.lbl_clanranking.text = "Crew Reward";
            this.panelMC.lbl_clanranking_description.text = "Shows a reward of current season";
            this.panelMC.lbl_clanShop.text = "Crew Shop";
        }

        private function initButton():void
        {
            this.eventHandler.addListener(this.panelMC.closeBtn, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.createClanBtn, MouseEvent.CLICK, this.createCrewConfirmation);
            this.eventHandler.addListener(this.panelMC.btn_requestmembership, MouseEvent.CLICK, this.openCrewList);
            this.eventHandler.addListener(this.panelMC.rewardBtn, MouseEvent.CLICK, this.showRewardDamageRank);
            this.eventHandler.addListener(this.panelMC.btn_clanshop, MouseEvent.CLICK, this.openCrewShop);
            this.eventHandler.addListener(this.panelMC.getMoreBtn, MouseEvent.CLICK, this.openRecharge);
        }

        private function openCrewList(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            Crew.instance.getCrewsForRequest(this.onGetCrewsRes);
        }

        public function onGetCrewsRes(_arg_1:*, _arg_2:*=null):void
        {
            var _local_3:int;
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("crews"))))
            {
                this.crewDataOriginal = _arg_1.crews;
                _local_3 = 0;
                while (_local_3 < this.crewDataOriginal.length)
                {
                    this.crewDataOriginal[_local_3].ranking = (_local_3 + 1);
                    _local_3++;
                };
                this.crewData = this.crewDataOriginal;
                this.initCrewList();
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Server Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getError("unknown error");
        }

        private function getSearchedCrew(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            _local_2 = String(((this.panelMC.requestMemberListMc.searchTxt.text) || (""))).replace(/^\s+|\s+$/g, "");
            var _local_3:Number = parseInt(_local_2);
            if (((isNaN(_local_3)) || (_local_3 <= 0)))
            {
                this.main.getNotice("Please enter a valid crew ID");
                return;
            };
            if (!this.searchCrew(_local_3.toString()))
            {
                this.main.loading(true);
                Crew.instance.searchCrewsForRequest(_local_3.toString(), this.onGetSearchRes);
            };
        }

        public function searchCrew(searchId:String=null):Boolean
        {
            var searchTerm:String;
            var searchText:String = this.panelMC.requestMemberListMc.searchTxt.text;
            if (((!(searchText)) && (!(searchId))))
            {
                return (false);
            };
            searchTerm = ((searchId) || (searchText)).toLowerCase();
            this.crewData = this.crewDataOriginal.filter(function (_arg_1:Object, _arg_2:int, _arg_3:Array):Boolean
            {
                return (((_arg_1) && (_arg_1.id)) && (String(_arg_1.id).toLowerCase() === searchTerm));
            });
            this.updateSearchResults();
            return (this.crewData.length > 0);
        }

        private function onGetSearchRes(_arg_1:Object, _arg_2:*=null):void
        {
            var _local_4:String;
            this.main.loading(false);
            if (_arg_2)
            {
                this.main.getNotice("Search failed. Please try again later.");
                return;
            };
            if ((((!(_arg_1)) || (!(_arg_1.crews))) || (!(_arg_1.crews.length))))
            {
                _local_4 = (((_arg_1) && (_arg_1.errorMessage)) ? ("Error: " + _arg_1.errorMessage) : "Crew not found. Please check the ID and try again.");
                this.main.getNotice(_local_4);
                this.resetSearch();
                return;
            };
            var _local_3:Object = _arg_1.crews[0];
            if (!_local_3.hasOwnProperty("ranking"))
            {
                _local_3.ranking = 1;
            };
            this.crewData = [_local_3];
            this.updateSearchResults(1);
        }

        private function updateSearchResults(_arg_1:int=-1):void
        {
            this.currentPage = 1;
            this.totalPage = ((_arg_1 > 0) ? _arg_1 : int(Math.ceil((this.crewData.length / 8))));
            this.updatePageNumber();
            this.displayCrewList();
        }

        private function initCrewList():void
        {
            this.panelMC.requestMemberListMc.visible = true;
            NinjaSage.showDynamicTooltip(this.panelMC.requestMemberListMc.backBtn, "Clear search");
            this.eventHandler.addListener(this.panelMC.requestMemberListMc.closeBtn, MouseEvent.CLICK, this.closeCrewList);
            this.eventHandler.addListener(this.panelMC.requestMemberListMc.backBtn, MouseEvent.CLICK, this.clearSearch);
            this.eventHandler.addListener(this.panelMC.requestMemberListMc.prevPageBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.requestMemberListMc.nextPageBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.requestMemberListMc.searchBtn, MouseEvent.CLICK, this.getSearchedCrew);
            this.eventHandler.addListener(this.panelMC.requestMemberListMc.btn_sendrequest, MouseEvent.CLICK, this.onRequestReq);
            this.totalPage = Math.ceil((this.crewData.length / 8));
            this.updatePageNumber();
            this.displayCrewList();
        }

        private function displayCrewList():void
        {
            var _local_2:int;
            var _local_1:int;
            while (_local_1 < 8)
            {
                _local_2 = (_local_1 + int((int((this.currentPage - 1)) * 8)));
                this.panelMC.requestMemberListMc[("clan_" + _local_1)].visible = false;
                this.panelMC.requestMemberListMc[("clan_" + _local_1)].metaData = {};
                this.panelMC.requestMemberListMc[("clan_" + _local_1)].gotoAndStop("idle");
                if (this.crewData.length > _local_2)
                {
                    this.panelMC.requestMemberListMc[("clan_" + _local_1)].visible = true;
                    this.panelMC.requestMemberListMc[("clan_" + _local_1)].rankingTxt.text = this.crewData[_local_2].ranking;
                    this.panelMC.requestMemberListMc[("clan_" + _local_1)].idTxt.text = (("[" + this.crewData[_local_2].id) + "]");
                    this.panelMC.requestMemberListMc[("clan_" + _local_1)].nameTxt.text = this.crewData[_local_2].name;
                    this.panelMC.requestMemberListMc[("clan_" + _local_1)].totalMemberTxt.text = ((this.crewData[_local_2].members + "/") + this.crewData[_local_2].max_members);
                    this.panelMC.requestMemberListMc[("clan_" + _local_1)].metaData = {"crew_data":this.crewData[_local_2]};
                    if (this.selectedCrewId == this.crewData[_local_2].id)
                    {
                        this.panelMC.requestMemberListMc[("clan_" + _local_1)].gotoAndStop("selected");
                    };
                    this.eventHandler.addListener(this.panelMC.requestMemberListMc[("clan_" + _local_1)], MouseEvent.CLICK, this.selectCrew);
                };
                _local_1++;
            };
            this.updatePageNumber();
            this.totalPage = Math.ceil((this.crewData.length / 8));
        }

        private function selectCrew(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            while (_local_2 < 8)
            {
                this.panelMC.requestMemberListMc[("clan_" + _local_2)].gotoAndStop("idle");
                _local_2++;
            };
            _arg_1.currentTarget.gotoAndStop("selected");
            this.selectedCrewId = _arg_1.currentTarget.metaData.crew_data.id;
            this.panelMC.requestMemberListMc.lbl_request_remark.text = (("Send a request to " + _arg_1.currentTarget.metaData.crew_data.name) + " crew?");
        }

        private function onRequestReq(_arg_1:MouseEvent):void
        {
            if (this.selectedCrewId == -1)
            {
                this.main.getNotice("Please select a crew first!");
            }
            else
            {
                this.main.loading(true);
                Crew.instance.sendRequestToCrew(this.selectedCrewId, this.onRequestToCrewRes);
            };
        }

        private function onRequestToCrewRes(_arg_1:Object, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("data"))))
            {
                this.main.getNotice(_arg_1.data.result);
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getError("unknown error");
        }

        private function changePage(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "nextPageBtn":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.displayCrewList();
                    };
                    return;
                case "prevPageBtn":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.displayCrewList();
                    };
                    return;
            };
        }

        private function clearSearch(_arg_1:MouseEvent):void
        {
            this.resetSearch();
        }

        private function resetSearch():void
        {
            this.crewData = this.crewDataOriginal;
            this.panelMC.requestMemberListMc.searchTxt.text = "";
            this.currentPage = 1;
            this.totalPage = Math.ceil((this.crewData.length / 8));
            this.updatePageNumber();
            this.displayCrewList();
        }

        private function updatePageNumber():void
        {
            this.panelMC.requestMemberListMc.pageTxt.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function closeCrewList(_arg_1:MouseEvent):void
        {
            this.panelMC.requestMemberListMc.visible = false;
            var _local_2:int;
            while (_local_2 < 8)
            {
                this.panelMC.requestMemberListMc[("clan_" + _local_2)].metaData = {};
                _local_2++;
            };
            this.crewDataOriginal = [];
            this.crewData = [];
        }

        private function createCrewConfirmation(e:MouseEvent):void
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (((("Are you sure want to create " + this.panelMC["clanNameInput"].text) + " crew for ") + this.CREATE_PRICE) + " tokens?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():void
            {
                GF.removeAllChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onCreateCrewReq);
            this.panelMC.addChild(this.confirmation);
        }

        private function onCreateCrewReq(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            if (this.panelMC["clanNameInput"].text == "")
            {
                this.main.getNotice("Crew name should not be empty!");
            }
            else
            {
                this.main.loading(true);
                Crew.instance.createCrew(this.panelMC.clanNameInput.text, this.onCreateCrewRes);
            };
        }

        private function onCreateCrewRes(_arg_1:Object, _arg_2:*=null):void
        {
            this.main.loading(false);
            if ((("status" in _arg_1) && (_arg_1.status == "ok")))
            {
                Character.account_tokens = (Character.account_tokens - this.CREATE_PRICE);
                this.main.HUD.setBasicData();
                Crew.instance.getCrewData(this.onGetCrewData);
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getError("");
            };
        }

        private function onGetCrewData(_arg_1:*, _arg_2:*=null):void
        {
            if ((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("crew"))) && (_arg_1.hasOwnProperty("char"))))
            {
                Character.crew_data = _arg_1.crew;
                Character.crew_char_data = _arg_1.char;
                this.main.loadExternalSwfPanel("CrewVillage", "CrewVillage");
                this.destroy();
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            this.closePanel(null);
        }

        private function showRewardDamageRank(_arg_1:MouseEvent):void
        {
            this.panelMC.detailMC.gotoAndStop("damageRank");
            var _local_2:MovieClip = this.panelMC.detailMC.panelMC;
            var _local_3:Array = ["1", "2", "3", "4", "5", "6-10"];
            var _local_4:Array = ["lbl_first_prize_1", "lbl_secon_1", "lbl_third_1", "lbl_forth_1", "lbl_5th_1", "lbl_6th_1"];
            var _local_5:Array = ["lbl_first_prize_2", "lbl_second_2", "lbl_third_2", "lbl_forth_2", "lbl_5th_2", "lbl_6th_2"];
            var _local_6:int;
            while (_local_6 < 6)
            {
                _local_2[_local_4[_local_6]].text = (this.tokenPoolData[_local_3[_local_6]].token + "% of token pool");
                _local_2[_local_5[_local_6]].text = (Util.formatNumberWithDot(this.tokenPoolData[_local_3[_local_6]].merit) + " Merit");
                _local_6++;
            };
            _local_2.lbl_date.text = ("Total Token Pool: 0 + " + this.tokenPoolData.base);
            Crew.instance.getTokenPool(this.onTokenPoolRes);
            this.eventHandler.addListener(this.panelMC.detailMC.panelMC.closeBtn, MouseEvent.CLICK, this.closeRewards);
            this.eventHandler.addListener(this.panelMC.detailMC.panelMC.nextBtn, MouseEvent.CLICK, this.showRewardDamageBonus);
        }

        private function onTokenPoolRes(_arg_1:Object, _arg_2:*=null):void
        {
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("t"))))
            {
                this.panelMC.detailMC.panelMC.lbl_date.text = ((("Total Token Pool: " + _arg_1.t) + " + ") + this.tokenPoolData.base);
                return;
            };
        }

        private function showRewardDamageBonus(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            this.panelMC.detailMC.gotoAndStop("damageBonus");
            this.eventHandler.addListener(this.panelMC.detailMC.panelMC.closeBtn, MouseEvent.CLICK, this.closeRewards);
            this.eventHandler.addListener(this.panelMC.detailMC.panelMC.prevBtn, MouseEvent.CLICK, this.showRewardDamageRank);
            _local_2 = 0;
            while (_local_2 < this.rewardData.phase_1.length)
            {
                NinjaSage.loadItemIcon(this.panelMC.detailMC.panelMC[("IconMc0_" + _local_2)], this.rewardData.phase_1[_local_2]);
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < this.rewardData.phase_2.length)
            {
                NinjaSage.loadItemIcon(this.panelMC.detailMC.panelMC[("IconMc_" + _local_2)], this.rewardData.phase_2[_local_2]);
                _local_2++;
            };
        }

        private function closeRewards(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            if (this.panelMC.detailMC.currentLabel == "damageBonus")
            {
                _local_2 = 0;
                while (_local_2 < this.rewardData.phase_1.length)
                {
                    GF.removeAllChild(this.panelMC.detailMC.panelMC[("IconMc0_" + _local_2)].rewardIcon.iconHolder);
                    GF.removeAllChild(this.panelMC.detailMC.panelMC[("IconMc0_" + _local_2)].skillIcon.iconHolder);
                    _local_2++;
                };
                _local_2 = 0;
                while (_local_2 < this.rewardData.phase_2.length)
                {
                    GF.removeAllChild(this.panelMC.detailMC.panelMC[("IconMc_" + _local_2)].rewardIcon.iconHolder);
                    GF.removeAllChild(this.panelMC.detailMC.panelMC[("IconMc_" + _local_2)].skillIcon.iconHolder);
                    _local_2++;
                };
            };
            this.eventHandler.removeListener(this.panelMC.detailMC.panelMC.closeBtn, MouseEvent.CLICK, this.closeRewards);
            this.eventHandler.removeListener(this.panelMC.detailMC.panelMC.prevBtn, MouseEvent.CLICK, this.showRewardDamageRank);
            this.eventHandler.removeListener(this.panelMC.detailMC.panelMC.nextBtn, MouseEvent.CLICK, this.showRewardDamageBonus);
            this.panelMC.detailMC.gotoAndStop("idle");
        }

        private function openRecharge(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Recharge");
        }

        private function openCrewShop(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.ClanShop");
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.eventHandler.removeAllEventListeners();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.main = null;
            this.character = null;
            this.eventHandler = null;
            this.rewardData = null;
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
        }


    }
}//package id.ninjasage.features

