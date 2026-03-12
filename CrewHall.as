// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.CrewHall

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Popups.Confirmation;
    import Managers.AppManager;
    import Storage.Character;
    import flash.events.MouseEvent;
    import id.ninjasage.Crew;
    import com.utils.GF;
    import flash.text.TextFieldType;
    import id.ninjasage.Util;
    import Managers.NinjaSage;

    public dynamic class CrewHall extends MovieClip 
    {

        private const RENAME_PRICE_TOKEN:int = 3000;
        private const MAX_TOTAL_MEMBERS:int = 40;

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var confirmation:Confirmation;
        private var memberRequest:Array;
        private var crewMembers:Array;
        private var crewData:Object;
        private var crewVillage:*;
        private var charData:Object;
        private var currentPageMember:int = 1;
        private var totalPageMember:int = 0;
        private var currentPageRequest:int = 1;
        private var totalPageRequest:int = 0;
        private var selectedMemberId:int = -1;
        private var selectedRequestId:int = -1;
        private var totalDonation:Number;
        private var selectedDonation:String;
        private var currentTab:String;

        public function CrewHall(_arg_1:*, _arg_2:*)
        {
            this.main = AppManager.getInstance().main;
            this.panelMC = _arg_2.panelMC;
            this.crewVillage = _arg_1;
            this.eventHandler = new EventHandler();
            this.crewData = Character.crew_data;
            this.charData = Character.crew_char_data;
            this.crewVillage.panelMC.visible = false;
            this.panelMC.addFrameScript(0, this.frame1, 11, this.onInitProfile, 16, this.onInitAnnouncement, 21, this.onInitMember, 26, this.onInitHistory);
            this.panelMC.gotoAndPlay(2);
        }

        private function initTab():void
        {
            this.eventHandler.removeListener(this.panelMC.panelMc.profileBtn, MouseEvent.CLICK, this.changeCategory);
            this.eventHandler.removeListener(this.panelMC.panelMc.announcementBtn, MouseEvent.CLICK, this.changeCategory);
            this.eventHandler.removeListener(this.panelMC.panelMc.memberListBtn, MouseEvent.CLICK, this.changeCategory);
            this.eventHandler.removeListener(this.panelMC.panelMc.logBtn, MouseEvent.CLICK, this.changeCategory);
            this.eventHandler.removeListener(this.panelMC.panelMc.closeBtn, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.panelMc.profileBtn, MouseEvent.CLICK, this.changeCategory);
            this.eventHandler.addListener(this.panelMC.panelMc.announcementBtn, MouseEvent.CLICK, this.changeCategory);
            this.eventHandler.addListener(this.panelMC.panelMc.memberListBtn, MouseEvent.CLICK, this.changeCategory);
            this.eventHandler.addListener(this.panelMC.panelMc.logBtn, MouseEvent.CLICK, this.changeCategory);
            this.eventHandler.addListener(this.panelMC.panelMc.closeBtn, MouseEvent.CLICK, this.closePanel);
            this.panelMC.panelMc.profileBtn.gotoAndStop("unselect");
            this.panelMC.panelMc.announcementBtn.gotoAndStop("unselect");
            this.panelMC.panelMc.memberListBtn.gotoAndStop("unselect");
            this.panelMC.panelMc.logBtn.gotoAndStop("unselect");
        }

        private function initProfile():void
        {
            this.currentTab = "profile";
            this.panelMC.gotoAndStop("profile");
            this.initTab();
            this.panelMC.panelMc.profileBtn.gotoAndStop("select");
            this.panelMC.panelMc.donateMc.gotoAndStop("idle");
            this.panelMC.panelMc.addMemberMc.gotoAndStop("idle");
            this.panelMC.panelMc.managementMc.gotoAndStop("idle");
            this.panelMC.panelMc.recruitMc.gotoAndStop("idle");
            this.panelMC.panelMc.rewardMc.gotoAndStop("idle");
            this.panelMC.panelMc.donateTokenMc.gotoAndStop("idle");
            this.panelMC.panelMc.quitMC.gotoAndStop("idle");
            this.panelMC.panelMc.detailMC.gotoAndStop("idle");
            this.panelMC.panelMc.detailMC2.gotoAndStop("idle");
            this.panelMC.panelMc.nameTxt.text = this.crewData.name;
            this.panelMC.panelMc.idTxt.text = this.crewData.id;
            this.panelMC.panelMc.masterNameTxt.text = ((("[" + this.crewData.master_id) + "] ") + this.crewData.master_name);
            this.panelMC.panelMc.elderNameTxt.text = ((this.crewData.elder_id == 0) ? "-" : ((("[" + this.crewData.elder_id) + "] ") + this.crewData.elder_name));
            this.panelMC.panelMc.memberTxt.text = ((this.crewData.members + "/") + this.crewData.max_members);
            this.panelMC.panelMc.goldTxt.text = this.crewData.golds;
            this.panelMC.panelMc.tokenTxt.text = this.crewData.tokens;
            this.panelMC.panelMc.teahouseMc.gotoAndStop(("level_" + this.crewData.tea_house));
            this.panelMC.panelMc.KushiDangoMc.gotoAndStop(("level_" + this.crewData.kushi_dango));
            this.panelMC.panelMc.bathhouseMc.gotoAndStop(("level_" + this.crewData.bath_house));
            this.panelMC.panelMc.trainingMc.gotoAndStop(("level_" + this.crewData.training_centre));
            this.panelMC.panelMc.teahouseLv.text = (("[Level " + this.crewData.tea_house) + "]");
            this.panelMC.panelMc.KushiDangoLv.text = (("[Level " + this.crewData.kushi_dango) + "]");
            this.panelMC.panelMc.bathhouseLv.text = (("[Level " + this.crewData.bath_house) + "]");
            this.panelMC.panelMc.trainingLv.text = (("[Level " + this.crewData.training_centre) + "]");
            this.panelMC.panelMc.teahouseDes.text = (("+" + this.crewVillage.buildingData.teahouseBtn.amount[this.crewData.tea_house]) + this.crewVillage.buildingData.teahouseBtn.description);
            this.panelMC.panelMc.KushiDangoDes.text = (("+" + this.crewVillage.buildingData.KushiDangoBtn.amount[this.crewData.kushi_dango]) + this.crewVillage.buildingData.KushiDangoBtn.description);
            this.panelMC.panelMc.bathhouseDes.text = (("+" + this.crewVillage.buildingData.bathhouseBtn.amount[this.crewData.bath_house]) + this.crewVillage.buildingData.bathhouseBtn.description);
            this.panelMC.panelMc.trainingDes.text = (("+" + this.crewVillage.buildingData.trainingBtn.amount[this.crewData.training_centre]) + this.crewVillage.buildingData.trainingBtn.description);
            this.panelMC.panelMc.dismissBtn.visible = false;
            this.panelMC.panelMc.managementBtn.visible = false;
            this.panelMC.panelMc.inviteBtn.visible = false;
            this.panelMC.panelMc.quitBtn.visible = true;
            if (((this.crewData.master_id == Character.char_id) || (this.crewData.elder_id == Character.char_id)))
            {
                this.panelMC.panelMc.dismissBtn.visible = true;
                this.panelMC.panelMc.managementBtn.visible = true;
                this.panelMC.panelMc.inviteBtn.visible = true;
                this.panelMC.panelMc.quitBtn.visible = false;
            };
            this.eventHandler.addListener(this.panelMC.panelMc.rewardBtn, MouseEvent.CLICK, this.showRewardDamageRank);
            this.eventHandler.addListener(this.panelMC.panelMc.faqBtn, MouseEvent.CLICK, this.showDamageBonusFaq);
            this.eventHandler.addListener(this.panelMC.panelMc.inviteBtn, MouseEvent.CLICK, this.openInviteMember);
            this.eventHandler.addListener(this.panelMC.panelMc.managementBtn, MouseEvent.CLICK, this.openManagement);
            this.eventHandler.addListener(this.panelMC.panelMc.donateGoldBtn, MouseEvent.CLICK, this.openDonate);
            this.eventHandler.addListener(this.panelMC.panelMc.donateTokenBtn, MouseEvent.CLICK, this.openDonate);
            this.eventHandler.addListener(this.panelMC.panelMc.quitBtn, MouseEvent.CLICK, this.firstConfirmationQuitDismiss);
            this.eventHandler.addListener(this.panelMC.panelMc.dismissBtn, MouseEvent.CLICK, this.firstConfirmationQuitDismiss);
        }

        private function openInviteMember(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMc.recruitMc.gotoAndStop("show");
            this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.closeBtn, MouseEvent.CLICK, this.closeInviteMember);
            this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.btn_requestlist, MouseEvent.CLICK, this.initRequestMember);
            this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.inviteBtn, MouseEvent.CLICK, this.sendInviteRequest);
            this.panelMC.panelMc.recruitMc.panelMc.charIdTxt.restrict = "0-9";
        }

        private function initRequestMember(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMc.recruitMc.gotoAndStop("accept_request_list");
            this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.closeBtn, MouseEvent.CLICK, this.closeInviteMember);
            this.main.loading(true);
            Crew.instance.getMemberRequests(this.initRequestMemberData);
        }

        private function initRequestMemberData(_arg_1:Object, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("requests"))))
            {
                this.memberRequest = _arg_1.requests;
                this.panelMC.panelMc.recruitMc.panelMc.pageTxt.text = ((this.currentPageRequest + " / ") + this.totalPageRequest);
                this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.closeBtn, MouseEvent.CLICK, this.closeRequestMember);
                this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.prevPageBtn, MouseEvent.CLICK, this.changePageRequest);
                this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.nextPageBtn, MouseEvent.CLICK, this.changePageRequest);
                this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.btn_accept, MouseEvent.CLICK, this.acceptMember);
                this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.btn_reject, MouseEvent.CLICK, this.rejectMember);
                this.eventHandler.addListener(this.panelMC.panelMc.recruitMc.panelMc.btn_rejectall, MouseEvent.CLICK, this.rejectAllMember);
                this.currentPageRequest = 1;
                this.totalPageRequest = Math.ceil((this.memberRequest.length / 8));
                this.renderCrewRequest();
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getError("unknown error");
        }

        private function renderCrewRequest():void
        {
            var _local_2:*;
            var _local_3:*;
            var _local_1:* = 0;
            while (_local_1 < 8)
            {
                _local_2 = this.panelMC.panelMc.recruitMc.panelMc[("request_" + _local_1)];
                _local_2.visible = false;
                _local_2.gotoAndStop("idle");
                _local_3 = (_local_1 + int((int((this.currentPageRequest - 1)) * 8)));
                if (this.memberRequest.length > _local_3)
                {
                    _local_2.visible = true;
                    _local_2.idTxt.text = this.memberRequest[_local_3].char_id;
                    _local_2.NameTxt.text = this.memberRequest[_local_3].name;
                    _local_2.lvTxt.text = this.memberRequest[_local_3].level;
                    _local_2.buttonMode = true;
                    _local_2.metaData = {"charId":this.memberRequest[_local_3].char_id};
                    this.eventHandler.addListener(_local_2, MouseEvent.CLICK, this.selectRequestMember);
                };
                _local_1++;
            };
            this.totalPageRequest = Math.max(Math.ceil((this.memberRequest.length / 8)), 1);
            this.updatePageTextRequest();
        }

        private function selectRequestMember(_arg_1:MouseEvent):void
        {
            this.resetSelectedRequestMember();
            var _local_2:int = _arg_1.currentTarget.name.replace("request_", "");
            this.panelMC.panelMc.recruitMc.panelMc[("request_" + _local_2)].gotoAndStop("selected");
            this.selectedRequestId = _arg_1.currentTarget.metaData.charId;
        }

        private function resetSelectedRequestMember():void
        {
            var _local_1:* = 0;
            while (_local_1 < 8)
            {
                this.panelMC.panelMc.recruitMc.panelMc[("request_" + _local_1)].gotoAndStop("idle");
                this.selectedRequestId = -1;
                _local_1++;
            };
        }

        private function acceptMember(_arg_1:MouseEvent):void
        {
            if (this.selectedRequestId < 0)
            {
                this.main.getNotice("Please select a member");
                return;
            };
            this.main.loading(true);
            Crew.instance.acceptMember(this.selectedRequestId, this.onAcceptMemberRes);
        }

        private function onAcceptMemberRes(_arg_1:Object, _arg_2:*):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("result"))))
            {
                this.main.getNotice("Member accepted");
                this.selectedRequestId = -1;
                this.initRequestMember(null);
                this.resetSelectedRequestMember();
                this.panelMC.panelMc.memberTxt.text = ((this.crewData.members + "/") + this.crewData.max_members);
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getNotice("Failed to accept the member. Please try again later");
        }

        private function rejectMember(_arg_1:MouseEvent):void
        {
            if (this.selectedRequestId < 0)
            {
                this.main.getNotice("Please select a member");
                return;
            };
            this.main.loading(true);
            Crew.instance.rejectMember(this.selectedRequestId, this.onRejectMemberRes);
        }

        private function onRejectMemberRes(_arg_1:Object, _arg_2:*):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("result"))))
            {
                this.main.getNotice("Member rejected");
                this.selectedRequestId = -1;
                this.initRequestMember(null);
                this.resetSelectedRequestMember();
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getNotice("Failed to accept the member. Please try again later");
        }

        private function rejectAllMember(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            Crew.instance.rejectMembers(this.onRejectAllMemberRes);
        }

        private function onRejectAllMemberRes(_arg_1:Object, _arg_2:*):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("result"))))
            {
                this.main.getNotice("All Member rejected");
                this.selectedRequestId = -1;
                this.initRequestMember(null);
                this.resetSelectedRequestMember();
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getNotice("Failed to accept the member. Please try again later");
        }

        private function changePageRequest(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "nextPageBtn":
                    if (this.totalPageRequest > this.currentPageRequest)
                    {
                        this.currentPageRequest++;
                        this.renderCrewRequest();
                    };
                    break;
                case "prevPageBtn":
                    if (this.currentPageRequest > 1)
                    {
                        this.currentPageRequest--;
                        this.renderCrewRequest();
                    };
            };
            this.updatePageTextRequest();
        }

        private function updatePageTextRequest():void
        {
            this.panelMC.panelMc.recruitMc.panelMc.pageTxt.text = ((this.currentPageRequest + "/") + this.totalPageRequest);
        }

        private function closeRequestMember(_arg_1:MouseEvent):void
        {
            this.selectedRequestId = -1;
            this.resetSelectedRequestMember();
            this.panelMC.panelMc.recruitMc.gotoAndStop("show");
        }

        private function sendInviteRequest(_arg_1:MouseEvent):void
        {
            if (this.panelMC.panelMc.recruitMc.panelMc.charIdTxt.text == "")
            {
                this.main.getNotice("Char ID can't be empty!");
                return;
            };
            Crew.instance.inviteCharacter(this.panelMC.panelMc.recruitMc.panelMc.charIdTxt.text, this.onInviteRequestSent);
        }

        private function onInviteRequestSent(_arg_1:Object, _arg_2:*=null):void
        {
            if ((("status" in _arg_1) && (_arg_1.status == "ok")))
            {
                this.main.giveMessage("invitation has been sent");
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Unable to send invitation.\n" + _arg_1.errorMessage));
            };
        }

        private function closeInviteMember(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMc.recruitMc.gotoAndStop("idle");
        }

        private function openManagement(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMc.managementMc.gotoAndStop("show");
            this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.visible = false;
            if (this.crewData.master_id != Character.char_id)
            {
                this.panelMC.panelMc.managementMc.panelMc.btn_renameCrew.visible = false;
            };
            this.eventHandler.addListener(this.panelMC.panelMc.managementMc.panelMc.btn_increaseMember, MouseEvent.CLICK, this.openIncreaseMember);
            this.eventHandler.addListener(this.panelMC.panelMc.managementMc.panelMc.btn_renameCrew, MouseEvent.CLICK, this.renameCrew);
            this.eventHandler.addListener(this.panelMC.panelMc.managementMc.panelMc.btn_close, MouseEvent.CLICK, this.closeCrewManagement);
        }

        public function renameCrew(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.visible = true;
            this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.warningTxt.text = (("Attention:\n- Rename Crew Cost " + this.RENAME_PRICE_TOKEN) + " Tokens\n- Rename Crew Will Cost Crew Tokens\n- 30 Days Cooldown After Rename\n- Crew Rename is Closed 7 Days Before Final Day");
            this.eventHandler.addListener(this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.btn_close, MouseEvent.CLICK, this.closeCrewRename);
            this.eventHandler.addListener(this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.btn_confirm, MouseEvent.CLICK, this.crewRenameConfirmation);
        }

        public function crewRenameConfirmation(e:MouseEvent):void
        {
            this.confirmation = null;
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (("Are you sure that you want to change your clan name to " + this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.nameTxt.text) + " ?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():*
            {
                GF.removeAllChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onCrewRename);
            this.panelMC.addChild(this.confirmation);
        }

        public function onCrewRename(_arg_1:MouseEvent):void
        {
            this.closeConfirmation(null);
            this.main.loading(true);
            Crew.instance.renameCrew(this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.nameTxt.text, this.onCrewRenameRes);
        }

        public function onCrewRenameRes(_arg_1:Object, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (_arg_1 == null)
            {
                this.main.showMessage("Crew Name Successfully Renamed!");
                this.closeCrewRename();
                this.refreshData();
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            this.main.getNotice("Failed to rename crew. Please try again later");
        }

        public function closeCrewRename(_arg_1:MouseEvent=null):void
        {
            this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.nameTxt.text = "";
            this.panelMC.panelMc.managementMc.panelMc.crewRenameMC.visible = false;
        }

        public function closeCrewManagement(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMc.managementMc.gotoAndStop("idle");
        }

        private function openIncreaseMember(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMc.addMemberMc.gotoAndStop("show");
            var _local_2:* = Math.min(Math.max((this.MAX_TOTAL_MEMBERS - this.crewData.max_members), 0), 10);
            var _local_3:* = (this.crewData.max_members + _local_2);
            var _local_4:* = (_local_3 * 10);
            this.panelMC.panelMc.addMemberMc.panelMc.txt_MemberSlotUpgrade.text = _local_3;
            this.panelMC.panelMc.addMemberMc.panelMc.txt_TokenRequired.text = _local_4;
            this.panelMC.panelMc.addMemberMc.panelMc.txt_YourToken.text = this.crewData.tokens;
            this.eventHandler.addListener(this.panelMC.panelMc.addMemberMc.panelMc.closeBtn, MouseEvent.CLICK, this.closeIncreaseMember);
            this.eventHandler.addListener(this.panelMC.panelMc.addMemberMc.panelMc.getMoreBtn, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.panelMC.panelMc.addMemberMc.panelMc.btn_BuyMemberSlot, MouseEvent.CLICK, this.onIncreaseMember);
        }

        private function onIncreaseMember(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            Crew.instance.increaseMaxMembers(this.onIncreasedMember);
        }

        private function onIncreasedMember(_arg_1:*, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getError("unknown error");
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("max_members"))))
            {
                this.main.giveMessage(("You've successfuly upgrade max member to " + _arg_1.max_members));
                this.refreshData();
            };
        }

        private function closeIncreaseMember(_arg_1:MouseEvent):void
        {
            this.eventHandler.removeListener(this.panelMC.panelMc.addMemberMc.panelMc.closeBtn, MouseEvent.CLICK, this.closeIncreaseMember);
            this.eventHandler.removeListener(this.panelMC.panelMc.addMemberMc.panelMc.getMoreBtn, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.removeListener(this.panelMC.panelMc.addMemberMc.panelMc.btn_BuyMemberSlot, MouseEvent.CLICK, this.onIncreaseMember);
            this.panelMC.panelMc.addMemberMc.gotoAndStop("idle");
        }

        private function openDonate(_arg_1:MouseEvent):void
        {
            this.selectedDonation = ((_arg_1.currentTarget.name == "donateGoldBtn") ? "gold" : "token");
            if (this.selectedDonation == "gold")
            {
                this.panelMC.panelMc.donateMc.gotoAndStop("show");
                this.panelMC.panelMc.donateMc.panelMc.donateGoldTxt.restrict = "0-9";
                this.panelMC.panelMc.donateMc.panelMc.clanGoldTxt.text = this.crewData.golds;
                this.panelMC.panelMc.donateMc.panelMc.goldTxt.text = Character.character_gold;
                this.eventHandler.addListener(this.panelMC.panelMc.donateMc.panelMc.closeBtn, MouseEvent.CLICK, this.closeDonation);
                this.eventHandler.addListener(this.panelMC.panelMc.donateMc.panelMc.donateBtn, MouseEvent.CLICK, this.onDonate);
            }
            else
            {
                this.panelMC.panelMc.donateTokenMc.gotoAndStop("show");
                this.panelMC.panelMc.donateTokenMc.panelMc.donateGoldTxt.restrict = "0-9";
                this.panelMC.panelMc.donateTokenMc.panelMc.clanGoldTxt.text = this.crewData.tokens;
                this.panelMC.panelMc.donateTokenMc.panelMc.goldTxt.text = Character.account_tokens;
                this.eventHandler.addListener(this.panelMC.panelMc.donateTokenMc.panelMc.closeBtn, MouseEvent.CLICK, this.closeDonation);
                this.eventHandler.addListener(this.panelMC.panelMc.donateTokenMc.panelMc.donateBtn, MouseEvent.CLICK, this.onDonate);
            };
        }

        private function onDonate(_arg_1:MouseEvent):void
        {
            this.totalDonation = ((this.selectedDonation == "gold") ? int(this.panelMC.panelMc.donateMc.panelMc.donateGoldTxt.text) : int(this.panelMC.panelMc.donateTokenMc.panelMc.donateGoldTxt.text));
            if (this.totalDonation < 1)
            {
                this.main.getNotice("Amount need to be more than 0");
                return;
            };
            this.main.loading(true);
            if ((this.selectedDonation == "gold"))
            {
                Crew.instance.donateGolds(this.totalDonation, this.onDonated);
            }
            else
            {
                Crew.instance.donateTokens(this.totalDonation, this.onDonated);
            };
        }

        private function onDonated(_arg_1:*, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getError("unknown error");
                return;
            };
            if (((!(_arg_1 === null)) && ((_arg_1.hasOwnProperty("t")) || (_arg_1.hasOwnProperty("g")))))
            {
                if (this.selectedDonation == "gold")
                {
                    Character.character_gold = String(Number(_arg_1.g));
                    this.main.getNotice("Golds has been donated!");
                }
                else
                {
                    Character.account_tokens = int(Number(_arg_1.t));
                    this.main.getNotice("Tokens has been donated!");
                };
                this.main.HUD.setBasicData();
            };
            this.closeDonation(null);
            this.refreshData();
        }

        private function closeDonation(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMc.donateMc.gotoAndStop("idle");
            this.panelMC.panelMc.donateTokenMc.gotoAndStop("idle");
        }

        private function initAnnouncement():void
        {
            this.currentTab = "announcement";
            this.panelMC.gotoAndStop("announcement");
            this.initTab();
            this.panelMC.panelMc.announcementBtn.gotoAndStop("select");
            this.panelMC.panelMc.saveBtn.visible = false;
            this.panelMC.panelMc.announcementTxt.text = this.crewData.announcement;
            this.panelMC.panelMc.announcementTxt.type = TextFieldType.DYNAMIC;
            this.panelMC.panelMc.announcementTxt.selectable = true;
            if (((this.crewData.master_id == Character.char_id) || (this.crewData.elder_id == Character.char_id)))
            {
                this.panelMC.panelMc.announcementTxt.type = TextFieldType.INPUT;
                this.panelMC.panelMc.saveBtn.visible = true;
                this.eventHandler.addListener(this.panelMC.panelMc.saveBtn, MouseEvent.CLICK, this.saveAnnouncementReq);
            };
        }

        private function saveAnnouncementReq(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            Crew.instance.updateAnnouncement(this.panelMC.panelMc.announcementTxt.text, this.onUpdatedAnnouncement);
        }

        private function onUpdatedAnnouncement(_arg_1:Object, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getError("unknown error");
            };
            this.crewData.announcement = this.panelMC.panelMc.announcementTxt.text;
            this.panelMC.panelMc.announcementTxt.text = ((this.crewData.announcement) ? this.crewData.announcement : "");
            this.main.showMessage("Announcement has been updated!");
            this.refreshData();
        }

        private function initMember():void
        {
            this.currentTab = "member";
            this.panelMC.gotoAndStop("member_list");
            this.initTab();
            this.panelMC.panelMc.memberListBtn.gotoAndStop("select");
            this.panelMC.panelMc.recruitMc.gotoAndStop("idle");
            this.main.loading(true);
            Crew.instance.getMembersInfo(this.initMemberData);
        }

        private function initMemberData(_arg_1:Object, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("members"))))
            {
                this.crewMembers = _arg_1.members;
                this.panelMC.panelMc.totalMemberTxt.text = ((this.crewMembers.length + "/") + this.crewData.max_members);
                this.panelMC.panelMc.pageTxt.text = ((this.currentPageMember + " / ") + this.totalPageMember);
                this.eventHandler.addListener(this.panelMC.panelMc.prevPageBtn, MouseEvent.CLICK, this.changePageMember);
                this.eventHandler.addListener(this.panelMC.panelMc.nextPageBtn, MouseEvent.CLICK, this.changePageMember);
                this.eventHandler.addListener(this.panelMC.panelMc.removeBtn, MouseEvent.CLICK, this.kickMemberConfirmation);
                this.eventHandler.addListener(this.panelMC.panelMc.promoteBtn, MouseEvent.CLICK, this.promoteMemberConfirmation);
                this.eventHandler.addListener(this.panelMC.panelMc.promoteElderBtn, MouseEvent.CLICK, this.promoteElderConfirmation);
                if (((!(this.crewData.master_id == Character.char_id)) && (!(this.crewData.elder_id == Character.char_id))))
                {
                    this.panelMC.panelMc.removeBtn.visible = false;
                };
                if (this.crewData.master_id != Character.char_id)
                {
                    this.panelMC.panelMc.promoteBtn.visible = false;
                    this.panelMC.panelMc.promoteElderBtn.visible = false;
                };
                this.currentPageMember = 1;
                this.totalPageMember = Math.max(Math.ceil((this.crewMembers.length / 12)), 1);
                this.renderCrewMember();
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getError("unknown error");
        }

        private function renderCrewMember():void
        {
            var _local_2:*;
            var _local_1:* = 0;
            while (_local_1 < 12)
            {
                _local_2 = (_local_1 + int((int((this.currentPageMember - 1)) * 12)));
                this.panelMC.panelMc[("member_" + _local_1)].visible = false;
                this.panelMC.panelMc[("member_" + _local_1)].gotoAndStop("idle");
                if (this.crewMembers.length > _local_2)
                {
                    this.panelMC.panelMc[("member_" + _local_1)].visible = true;
                    this.panelMC.panelMc[("member_" + _local_1)].nameTxt.text = this.crewMembers[_local_2].name;
                    this.panelMC.panelMc[("member_" + _local_1)].role.gotoAndStop(this.crewMembers[_local_2].role);
                    this.panelMC.panelMc[("member_" + _local_1)].staminaTxt.text = this.crewMembers[_local_2].stamina;
                    this.panelMC.panelMc[("member_" + _local_1)].damageTxt.text = this.crewMembers[_local_2].damage;
                    this.panelMC.panelMc[("member_" + _local_1)].killedTxt.text = this.crewMembers[_local_2].boss_kill;
                    this.panelMC.panelMc[("member_" + _local_1)].donationGoldTxt.text = this.crewMembers[_local_2].gold_donated;
                    this.panelMC.panelMc[("member_" + _local_1)].donationTokenTxt.text = this.crewMembers[_local_2].token_donated;
                    this.panelMC.panelMc[("member_" + _local_1)].buttonMode = true;
                    this.panelMC.panelMc[("member_" + _local_1)].metaData = {"charId":this.crewMembers[_local_2].char_id};
                    this.eventHandler.addListener(this.panelMC.panelMc[("member_" + _local_1)], MouseEvent.CLICK, this.selectCrewMember);
                };
                _local_1++;
            };
            this.totalPageMember = Math.ceil((this.crewMembers.length / 12));
            this.updatePageText();
        }

        private function selectCrewMember(_arg_1:MouseEvent):void
        {
            this.resetSelectedCrewMember();
            var _local_2:int = _arg_1.currentTarget.name.replace("member_", "");
            this.panelMC.panelMc[("member_" + _local_2)].gotoAndStop("selected");
            this.selectedMemberId = _arg_1.currentTarget.metaData.charId;
        }

        private function kickMemberConfirmation(_arg_1:MouseEvent):void
        {
            if (this.selectedMemberId < 1)
            {
                this.main.getNotice("Please select a member to kick");
                return;
            };
            this.confirmation = null;
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure that you want to kick this member from your crew?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.closeConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onRemoveMember);
            this.panelMC.addChild(this.confirmation);
        }

        private function onRemoveMember(_arg_1:MouseEvent):void
        {
            this.closeConfirmation(null);
            this.main.loading(true);
            Crew.instance.kickMember(this.selectedMemberId, this.onRemoveMemberRes);
        }

        private function onRemoveMemberRes(_arg_1:Object, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            this.main.showMessage("Member has been kicked");
            this.refreshData();
        }

        private function promoteMemberConfirmation(_arg_1:MouseEvent):void
        {
            if (this.selectedMemberId < 1)
            {
                this.main.getNotice("Please select a member to promote");
                return;
            };
            this.confirmation = null;
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure that you want to promote this member as Crew Master?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.closeConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onPromoteMember);
            this.panelMC.addChild(this.confirmation);
        }

        private function onPromoteMember(_arg_1:MouseEvent):void
        {
            this.closeConfirmation(null);
            this.main.loading(true);
            Crew.instance.changeCrewMaster(this.selectedMemberId, this.onPromoteMemberRes);
        }

        private function onPromoteMemberRes(_arg_1:Object, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            this.main.getNotice("Member has been promoted to Crew Master");
            this.crewVillage.destroy();
            this.destroy();
        }

        private function promoteElderConfirmation(_arg_1:MouseEvent):void
        {
            if (this.selectedMemberId < 1)
            {
                this.main.getNotice("Please select a member to promote to elder");
                return;
            };
            this.confirmation = null;
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure that you want to promote this member as Crew Elder?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.closeConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onPromoteElder);
            this.panelMC.addChild(this.confirmation);
        }

        private function onPromoteElder(_arg_1:MouseEvent):void
        {
            this.closeConfirmation(null);
            this.main.loading(true);
            Crew.instance.promoteElder(this.selectedMemberId, this.onPromoteElderRes);
        }

        private function onPromoteElderRes(_arg_1:Object, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            this.main.getNotice("Member has been promoted to Crew Elder");
            this.closePanel(null);
        }

        private function resetSelectedCrewMember():void
        {
            var _local_1:* = 0;
            while (_local_1 < 12)
            {
                this.panelMC.panelMc[("member_" + _local_1)].gotoAndStop("idle");
                this.selectedMemberId = -1;
                _local_1++;
            };
        }

        private function changePageMember(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "nextPageBtn":
                    if (this.totalPageMember > this.currentPageMember)
                    {
                        this.currentPageMember++;
                        this.renderCrewMember();
                    };
                    break;
                case "prevPageBtn":
                    if (this.currentPageMember > 1)
                    {
                        this.currentPageMember--;
                        this.renderCrewMember();
                    };
            };
            this.updatePageText();
        }

        private function updatePageText():void
        {
            this.panelMC.panelMc.pageTxt.text = ((this.currentPageMember + "/") + this.totalPageMember);
        }

        private function initHistory():void
        {
            this.currentTab = "history";
            this.panelMC.gotoAndStop("history");
            this.initTab();
            this.panelMC.panelMc.logBtn.gotoAndStop("select");
            Crew.instance.getHistory(this.onGetLatestHistory);
        }

        private function onGetLatestHistory(_arg_1:*, _arg_2:*=null):void
        {
            this.setHistoryInfo((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("histories"))) ? _arg_1.histories : ""));
        }

        private function setHistoryInfo(_arg_1:*):void
        {
            var _local_2:Object;
            var _local_3:String;
            var _local_4:int;
            if (!(_arg_1 is Array))
            {
                _local_2 = _arg_1.split("<br />");
                _local_3 = "";
                _local_3 = (_local_2[(_local_2.length - 1)] + "<br />");
                _local_4 = (int(_local_2.length) - 2);
                while (_local_4 > 0)
                {
                    _local_3 = ((_local_3 + _local_2[_local_4]) + "<br />");
                    _local_4--;
                };
                this.panelMC.panelMc.historyTxt.htmlText = _local_3;
            }
            else
            {
                if ((_arg_1 is Array))
                {
                    this.panelMC.panelMc.historyTxt.htmlText = _arg_1.join("<br/>");
                }
                else
                {
                    this.panelMC.panelMc.historyTxt.htmlText = _arg_1;
                };
            };
            this.eventHandler.addListener(this.panelMC.panelMc.btn_next, MouseEvent.CLICK, this.onLatestInfo);
            this.eventHandler.addListener(this.panelMC.panelMc.btn_prev, MouseEvent.CLICK, this.onOldestInfo);
        }

        private function onOldestInfo(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMc.historyTxt.scrollV = (this.panelMC.panelMc.historyTxt.scrollV - 10);
        }

        private function onLatestInfo(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMc.historyTxt.scrollV = (this.panelMC.panelMc.historyTxt.scrollV + 10);
        }

        private function firstConfirmationQuitDismiss(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMc.quitMC.gotoAndStop("show");
            if (this.crewData.master_id == Character.char_id)
            {
                this.panelMC.panelMc.quitMC.titleTxt.text = "Type DISBAND to Confirm";
            }
            else
            {
                this.panelMC.panelMc.quitMC.titleTxt.text = "Type QUIT to Confirm";
            };
            this.panelMC.panelMc.quitMC.warningTxt.text = "Attention:\n- Must Type in Upper Case\n- Can't Quit/Disband Crew on Final Day";
            this.eventHandler.addListener(this.panelMC.panelMc.quitMC.btn_close, MouseEvent.CLICK, this.closeQuitConfirm);
            this.eventHandler.addListener(this.panelMC.panelMc.quitMC.btn_confirm, MouseEvent.CLICK, this.quitAMF);
        }

        private function quitAMF(_arg_1:MouseEvent):void
        {
            var _local_2:String = this.panelMC.panelMc.quitMC.quitTxt.text;
            if (this.crewData.master_id == Character.char_id)
            {
                if (_local_2 == "DISBAND")
                {
                    this.secondQuitConfirm();
                }
                else
                {
                    this.main.showMessage("Wrong confirmation text");
                };
            }
            else
            {
                if (_local_2 == "QUIT")
                {
                    this.secondQuitConfirm();
                }
                else
                {
                    this.main.showMessage("Wrong confirmation text");
                };
            };
        }

        private function secondQuitConfirm():void
        {
            this.confirmation = null;
            this.confirmation = new Confirmation();
            if (this.crewData.master_id == Character.char_id)
            {
                this.confirmation.txtMc.txt.text = "Are you sure that you want to disband this crew?";
            };
            this.confirmation.txtMc.txt.text = "Are you sure that you want to quit from your crew?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.closeConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onQuitAMF);
            this.main.loader.addChild(this.confirmation);
        }

        private function onQuitAMF(_arg_1:MouseEvent):void
        {
            this.closeConfirmation(null);
            this.main.loading(true);
            Crew.instance.quitFromCrew(this.onGetQuitRes);
        }

        private function onGetQuitRes(_arg_1:Object, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Error: " + _arg_1.errorMessage));
                return;
            };
            Crew.instance.destroy();
            this.crewVillage.destroy();
            this.destroy();
        }

        private function closeQuitConfirm(_arg_1:MouseEvent):void
        {
            this.confirmation = null;
            this.eventHandler.removeListener(this.panelMC.panelMc.quitMC.btn_close, MouseEvent.CLICK, this.closeQuitConfirm);
            this.eventHandler.removeListener(this.panelMC.panelMc.quitMC.btn_confirm, MouseEvent.CLICK, this.quitAMF);
            this.panelMC.panelMc.quitMC.gotoAndStop("idle");
        }

        private function closeConfirmation(_arg_1:MouseEvent):void
        {
            this.eventHandler.removeListener(this.confirmation.btn_close, MouseEvent.CLICK, this.closeConfirmation);
            this.eventHandler.removeListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onQuitAMF);
            this.eventHandler.removeListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onRemoveMember);
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
        }

        private function showRewardDamageRank(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMc.detailMC.gotoAndStop("damageRank");
            var _local_2:MovieClip = this.panelMC.panelMc.detailMC.panelMC;
            var _local_3:Array = ["1", "2", "3", "4", "5", "6-10"];
            var _local_4:Array = ["lbl_first_prize_1", "lbl_secon_1", "lbl_third_1", "lbl_forth_1", "lbl_5th_1", "lbl_6th_1"];
            var _local_5:Array = ["lbl_first_prize_2", "lbl_second_2", "lbl_third_2", "lbl_forth_2", "lbl_5th_2", "lbl_6th_2"];
            var _local_6:int;
            while (_local_6 < 6)
            {
                _local_2[_local_4[_local_6]].text = (this.crewVillage.tokenPoolData[_local_3[_local_6]].token + "% of token pool");
                _local_2[_local_5[_local_6]].text = (Util.formatNumberWithDot(this.crewVillage.tokenPoolData[_local_3[_local_6]].merit) + " Merit");
                _local_6++;
            };
            _local_2.lbl_date.text = ("Total Token Pool: 0 + " + this.crewVillage.tokenPoolData.base);
            Crew.instance.getTokenPool(this.onTokenPoolRes);
            this.eventHandler.addListener(this.panelMC.panelMc.detailMC.panelMC.closeBtn, MouseEvent.CLICK, this.closeRewards);
            this.eventHandler.addListener(this.panelMC.panelMc.detailMC.panelMC.nextBtn, MouseEvent.CLICK, this.showRewardDamageBonus);
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
                this.panelMC.panelMc.detailMC.panelMC.lbl_date.text = ((("Total Token Pool: " + _arg_1.t) + " + ") + this.crewVillage.tokenPoolData.base);
                return;
            };
        }

        private function showRewardDamageBonus(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            this.panelMC.panelMc.detailMC.gotoAndStop("damageBonus");
            this.eventHandler.addListener(this.panelMC.panelMc.detailMC.panelMC.closeBtn, MouseEvent.CLICK, this.closeRewards);
            this.eventHandler.addListener(this.panelMC.panelMc.detailMC.panelMC.prevBtn, MouseEvent.CLICK, this.showRewardDamageRank);
            _local_2 = 0;
            while (_local_2 < this.crewVillage.rewardData.phase_1.length)
            {
                NinjaSage.loadItemIcon(this.panelMC.panelMc.detailMC.panelMC[("IconMc0_" + _local_2)], this.crewVillage.rewardData.phase_1[_local_2]);
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < this.crewVillage.rewardData.phase_2.length)
            {
                NinjaSage.loadItemIcon(this.panelMC.panelMc.detailMC.panelMC[("IconMc_" + _local_2)], this.crewVillage.rewardData.phase_2[_local_2]);
                _local_2++;
            };
        }

        private function closeRewards(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            if (this.panelMC.panelMc.detailMC.currentLabel == "damageBonus")
            {
                _local_2 = 0;
                while (_local_2 < this.crewVillage.rewardData.phase_1.length)
                {
                    GF.removeAllChild(this.panelMC.panelMc.detailMC.panelMC[("IconMc0_" + _local_2)].rewardIcon.iconHolder);
                    GF.removeAllChild(this.panelMC.panelMc.detailMC.panelMC[("IconMc0_" + _local_2)].skillIcon.iconHolder);
                    _local_2++;
                };
                _local_2 = 0;
                while (_local_2 < this.crewVillage.rewardData.phase_2.length)
                {
                    GF.removeAllChild(this.panelMC.panelMc.detailMC.panelMC[("IconMc_" + _local_2)].rewardIcon.iconHolder);
                    GF.removeAllChild(this.panelMC.panelMc.detailMC.panelMC[("IconMc_" + _local_2)].skillIcon.iconHolder);
                    _local_2++;
                };
            };
            this.eventHandler.removeListener(this.panelMC.panelMc.detailMC.panelMC.closeBtn, MouseEvent.CLICK, this.closeRewards);
            this.eventHandler.removeListener(this.panelMC.panelMc.detailMC.panelMC.prevBtn, MouseEvent.CLICK, this.showRewardDamageRank);
            this.eventHandler.removeListener(this.panelMC.panelMc.detailMC.panelMC.nextBtn, MouseEvent.CLICK, this.showRewardDamageBonus);
            this.panelMC.panelMc.detailMC.gotoAndStop("idle");
        }

        private function showDamageBonusFaq(_arg_1:MouseEvent):void
        {
            if (this.crewVillage.damageBonusData.length == 0)
            {
                this.main.showMessage("Coming Soon");
                return;
            };
            this.panelMC.panelMc.detailMC2.gotoAndStop("damageBonus");
            var _local_2:MovieClip = this.panelMC.panelMc.detailMC2.panelMC;
            var _local_3:int = 1;
            while (_local_3 <= this.crewVillage.damageBonusData.length)
            {
                _local_2[("dmg" + _local_3)].text = Util.formatNumberWithDot(this.crewVillage.damageBonusData[(_local_3 - 1)].damage);
                _local_2[("lbl_tot" + _local_3)].text = this.crewVillage.damageBonusData[(_local_3 - 1)].description;
                _local_3++;
            };
            this.eventHandler.addListener(this.panelMC.panelMc.detailMC2.panelMC.closeBtn, MouseEvent.CLICK, this.closeDamageBonusFaq);
        }

        private function closeDamageBonusFaq(_arg_1:MouseEvent):void
        {
            this.eventHandler.removeListener(this.panelMC.panelMc.detailMC2.panelMC.closeBtn, MouseEvent.CLICK, this.closeDamageBonusFaq);
            this.panelMC.panelMc.detailMC2.gotoAndStop("idle");
        }

        private function changeCategory(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "profileBtn":
                    this.initProfile();
                    return;
                case "announcementBtn":
                    this.initAnnouncement();
                    return;
                case "memberListBtn":
                    this.initMember();
                    return;
                case "logBtn":
                    this.initHistory();
                    return;
            };
        }

        private function refreshData():void
        {
            Crew.instance.getCrewData(this.onRefreshData);
        }

        private function onRefreshData(_arg_1:*, _arg_2:*=null):void
        {
            this.main.loading(false);
            if ((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("crew"))) && (_arg_1.hasOwnProperty("char"))))
            {
                Character.crew_data = _arg_1.crew;
                Character.crew_char_data = _arg_1.char;
                this.crewData = _arg_1.crew;
                this.charData = _arg_1.char;
                switch (this.currentTab)
                {
                    case "profile":
                        this.initProfile();
                        return;
                    case "announcement":
                        this.initAnnouncement();
                        return;
                    case "member":
                        this.initMember();
                        return;
                    case "history":
                        this.initHistory();
                        return;
                };
                return;
            };
            if (_arg_2 != null)
            {
                this.main.removeLoadedPanel("Panels.CrewVillage");
                this.main.showMessage("Unable to the refresh data");
                this.destroy();
            };
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
            if (((this.crewVillage) && (this.crewVillage.panelMC)))
            {
                this.crewVillage.panelMC.visible = true;
            };
            this.destroy();
        }

        public function destroy():*
        {
            this.eventHandler.removeAllEventListeners();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.main = null;
            this.eventHandler = null;
            this.crewVillage = null;
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
        }

        private function frame1():void
        {
            this.panelMC.stop();
        }

        private function onInitProfile():void
        {
            this.panelMC.stop();
            this.initProfile();
        }

        private function onInitAnnouncement():void
        {
            this.panelMC.stop();
        }

        private function onInitMember():void
        {
            this.panelMC.stop();
        }

        private function onInitHistory():void
        {
            this.panelMC.stop();
        }


    }
}//package id.ninjasage.features

