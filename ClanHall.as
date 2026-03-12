// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.ClanHall

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import id.ninjasage.Clan;
    import Popups.ClanDonateGolds;
    import Popups.ClanDonateTokens;
    import Popups.ClanIncreaseMembers;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import Popups.Confirmation;
    import Managers.OutfitManager;
    import flash.text.TextFieldType;
    import flash.utils.getDefinitionByName;
    import br.com.stimuli.loading.BulkLoader;
    import id.ninjasage.Log;
    import com.utils.GF;

    public class ClanHall extends MovieClip 
    {

        public var clanManagementMC:MovieClip;
        public var quitMC:MovieClip;
        public var announcementMC:MovieClip;
        public var btn_announcement:MovieClip;
        public var sendOnigiriMC:MovieClip;
        public var btn_close:SimpleButton;
        public var btn_general:MovieClip;
        public var btn_history:MovieClip;
        public var btn_members:MovieClip;
        public var generalMC:MovieClip;
        public var historyMC:MovieClip;
        public var membersMC:MovieClip;
        public var clanLogoHolder:MovieClip;
        public var main:*;
        public var clan_village:*;
        internal var quit_pop:*;
        internal var quit_clan:*;
        public var current_page:int = 1;
        public var total_page:int = 1;
        public var max_amount:int = 1000;
        public var amount:int = 100;
        public var price:int = 10;
        public var cost:int = 0;
        public var tax:int;
        public var total:int;
        public var selected_member_index:* = -1;
        public var friendProfile:*;
        public var confirmation:*;

        public var eventHandler:* = new EventHandler();
        public var clan_data:* = Character.clan_data;
        public var char_data:* = Character.clan_char_data;
        public var upgrade_info:Array = [];
        public var members:Array = [];

        public function ClanHall(_arg_1:*, _arg_2:*)
        {
            this.sendOnigiriMC.visible = false;
            this.quitMC.visible = false;
            this.clanLogoHolder.visible = false;
            this.clanManagementMC.visible = false;
            this.main = _arg_1;
            this.clan_village = _arg_2;
            this.addButtonListeners();
            this.hideAllMCs();
            this.addClanLogo();
            this.upgrade_info = [];
            this.upgrade_info.push(["No boosts", "+10 Stamina every 30 minutes", "+20 Stamina every 30 minutes", "+30 Stamina every 30 minutes"]);
            this.upgrade_info.push(["No boosts", "+30% maximum HP", "+60% maximum HP", "+90% maximum HP"]);
            this.upgrade_info.push(["No boosts", "+30% maximum CP", "+60% maximum CP", "+90% maximum CP"]);
            this.upgrade_info.push(["No boosts", "+30% damage for all attacks", "+60% damage for all attacks", "+90% damage for all attacks"]);
            this.displayTab("general");
        }

        public function addButtonListeners():*
        {
            this.resetBtns();
            this.eventHandler.addListener(this.btn_general, MouseEvent.CLICK, this.onGeneralTab);
            this.eventHandler.addListener(this.btn_announcement, MouseEvent.CLICK, this.onAnnouncementTab);
            this.eventHandler.addListener(this.btn_members, MouseEvent.CLICK, this.onMembersTab);
            this.eventHandler.addListener(this.btn_history, MouseEvent.CLICK, this.onHistoryTab);
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.getClanStatusReq);
        }

        public function closeThis(_arg_1:MouseEvent):*
        {
            parent.removeChild(this);
        }

        public function resetBtns():*
        {
            this.btn_general.gotoAndStop(2);
            this.btn_announcement.gotoAndStop(2);
            this.btn_members.gotoAndStop(2);
            this.btn_history.gotoAndStop(2);
        }

        public function hideAllMCs():*
        {
            this.generalMC.visible = false;
            this.historyMC.visible = false;
            this.announcementMC.visible = false;
            this.membersMC.visible = false;
        }

        public function onGeneralTab(_arg_1:MouseEvent):*
        {
            this.displayTab("general");
        }

        public function onAnnouncementTab(_arg_1:MouseEvent):*
        {
            this.displayTab("announcement");
        }

        public function onMembersTab(_arg_1:MouseEvent):*
        {
            this.displayTab("members");
        }

        public function onHistoryTab(_arg_1:MouseEvent):*
        {
            this.displayTab("history");
        }

        public function displayTab(_arg_1:*):*
        {
            this.resetBtns();
            this.hideAllMCs();
            switch (_arg_1)
            {
                case "general":
                    this.btn_general.gotoAndStop(1);
                    this.generalMC.visible = true;
                    this.setGeneralInfo();
                    return;
                case "announcement":
                    this.btn_announcement.gotoAndStop(1);
                    this.announcementMC.visible = true;
                    this.setAnnouncementInfo();
                    return;
                case "members":
                    this.btn_members.gotoAndStop(1);
                    this.membersMC.visible = true;
                    this.getAndSetMembersInfo();
                    return;
                case "history":
                    this.btn_history.gotoAndStop(1);
                    this.fetchLatestHistory();
                    return;
            };
        }

        public function fetchLatestHistory():*
        {
            Clan.instance.getHistory(this.onGetLatestHistory);
        }

        public function onGetLatestHistory(_arg_1:*, _arg_2:*=null):*
        {
            this.historyMC.visible = true;
            this.setHistoryInfo((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("histories"))) ? _arg_1.histories : ""));
        }

        public function setHistoryInfo(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            this.clanLogoHolder.visible = false;
            if (!_arg_1)
            {
                return;
            };
            if (_arg_1.indexOf("<br />") >= 0)
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
                this.historyMC.historyTxt.htmlText = _local_3;
            }
            else
            {
                this.historyMC.historyTxt.htmlText = _arg_1;
            };
            this.eventHandler.addListener(this.historyMC.btn_next, MouseEvent.CLICK, this.onLatestInfo);
            this.eventHandler.addListener(this.historyMC.btn_prev, MouseEvent.CLICK, this.onOldestInfo);
        }

        public function onOldestInfo(_arg_1:MouseEvent):*
        {
            this.historyMC.historyTxt.scrollV = (this.historyMC.historyTxt.scrollV - 10);
        }

        public function onLatestInfo(_arg_1:MouseEvent):*
        {
            this.historyMC.historyTxt.scrollV = (this.historyMC.historyTxt.scrollV + 10);
        }

        public function setGeneralInfo():*
        {
            this.clanLogoHolder.visible = true;
            this.generalMC.clan_name.text = this.clan_data.name;
            this.generalMC.clan_id.text = ((this.clan_data.id > 0) ? this.clan_data.id : "-R-");
            this.generalMC.clan_master.text = this.clan_data.master_name;
            if (this.clan_data.elder_name == null)
            {
                this.generalMC.clan_elder.text = "-";
            }
            else
            {
                this.generalMC.clan_elder.text = this.clan_data.elder_name;
            };
            this.generalMC.clan_tokens.text = this.clan_data.tokens;
            this.generalMC.clan_golds.text = this.clan_data.golds;
            this.generalMC.ramenmc.gotoAndStop((this.clan_data.ramen + 1));
            this.generalMC.ramenlvl.text = ("Level " + this.clan_data.ramen);
            this.generalMC.ramendesc.text = this.upgrade_info[0][this.clan_data.ramen];
            this.generalMC.templemc.gotoAndStop((this.clan_data.temple + 1));
            this.generalMC.templelvl.text = ("Level " + this.clan_data.temple);
            this.generalMC.templedesc.text = this.upgrade_info[2][this.clan_data.temple];
            this.generalMC.hotspringmc.gotoAndStop((this.clan_data.hot_spring + 1));
            this.generalMC.hotspringlvl.text = ("Level " + this.clan_data.hot_spring);
            this.generalMC.hotspringdesc.text = this.upgrade_info[1][this.clan_data.hot_spring];
            this.generalMC.traininghallmc.gotoAndStop((this.clan_data.training_hall + 1));
            this.generalMC.traininghalllvl.text = ("Level " + this.clan_data.training_hall);
            this.generalMC.traininghalldesc.text = this.upgrade_info[3][this.clan_data.training_hall];
            if (((!(this.clan_data.master_id == Character.char_id)) && (!(this.clan_data.elder_id == Character.char_id))))
            {
                this.generalMC.btn_invite.visible = false;
                this.generalMC.btn_manage.visible = false;
            };
            this.eventHandler.addListener(this.generalMC.btn_invite, MouseEvent.CLICK, this.inviteMembers);
            this.eventHandler.addListener(this.generalMC.btn_quit, MouseEvent.CLICK, this.quitClanConfirm);
            this.eventHandler.addListener(this.generalMC.btn_gold, MouseEvent.CLICK, this.donateGold);
            this.eventHandler.addListener(this.generalMC.btn_token, MouseEvent.CLICK, this.doneteTokens);
            this.eventHandler.addListener(this.generalMC.btn_manage, MouseEvent.CLICK, this.clanManagement);
        }

        public function donateGold(_arg_1:MouseEvent):*
        {
            var _local_2:* = new ClanDonateGolds(this.main, this.clan_village, this);
            addChild(_local_2);
        }

        public function doneteTokens(_arg_1:MouseEvent):*
        {
            var _local_2:* = new ClanDonateTokens(this.main, this.clan_village, this);
            addChild(_local_2);
        }

        public function increaseMembers(_arg_1:MouseEvent):*
        {
            var _local_2:* = new ClanIncreaseMembers(this.main, this.clan_village, this);
            addChild(_local_2);
        }

        public function inviteMembers(_arg_1:MouseEvent):*
        {
            var _local_2:* = new ClanMemberRequest(this.main, this.clan_village, this);
            addChild(_local_2);
        }

        public function clanManagement(_arg_1:MouseEvent):*
        {
            this.clanManagementMC.visible = true;
            this.clanManagementMC.clanRenameMC.visible = false;
            if (this.clan_data.master_id != Character.char_id)
            {
                this.clanManagementMC.btn_renameClan.visible = false;
                this.clanManagementMC.btn_swapMaster.visible = false;
            };
            this.eventHandler.addListener(this.clanManagementMC.btn_increaseMember, MouseEvent.CLICK, this.increaseMembers);
            this.eventHandler.addListener(this.clanManagementMC.btn_changeBanner, MouseEvent.CLICK, this.changeBanner);
            this.eventHandler.addListener(this.clanManagementMC.btn_renameClan, MouseEvent.CLICK, this.renameClan);
            this.eventHandler.addListener(this.clanManagementMC.btn_swapMaster, MouseEvent.CLICK, this.swapMasterConfirmation);
            this.eventHandler.addListener(this.clanManagementMC.btn_close, MouseEvent.CLICK, this.closeManagement);
        }

        public function changeBanner(_arg_1:MouseEvent):*
        {
            navigateToURL(new URLRequest((("https://ninjasage.id/player/clan/" + this.clan_data.id) + "/banner")));
        }

        public function renameClan(_arg_1:MouseEvent):*
        {
            this.clanManagementMC.clanRenameMC.visible = true;
            this.clanManagementMC.clanRenameMC.warningTxt.text = "Attention:\n- Rename Clan Cost 3000 Tokens\n- Rename Clan Will Cost Clan Tokens\n- 30 Days Cooldown After Rename\n- Clan Rename is Closed 7 Days Before Final Day";
            this.eventHandler.addListener(this.clanManagementMC.clanRenameMC.btn_close, MouseEvent.CLICK, this.closeClanRename);
            this.eventHandler.addListener(this.clanManagementMC.clanRenameMC.btn_confirm, MouseEvent.CLICK, this.clanRenameConfirmation);
        }

        public function clanRenameConfirmation(e:MouseEvent):*
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (("Are you sure that you want to change your clan name to " + this.clanManagementMC.clanRenameMC.nameTxt.text) + " ?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():*
            {
                removeChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onClanRename);
            addChild(this.confirmation);
        }

        public function onClanRename(_arg_1:MouseEvent):*
        {
            removeChild(this.confirmation);
            this.main.loading(true);
            Clan.instance.renameClan(this.clanManagementMC.clanRenameMC.nameTxt.text, this.onClanRenameRes);
        }

        public function onClanRenameRes(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1 == "ok")))
            {
                this.main.showMessage("Clan Name Successfully Renamed!");
                this.closeClanRename();
                this.displayTab("general");
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
                return;
            };
        }

        public function closeClanRename(_arg_1:MouseEvent=null):*
        {
            this.clanManagementMC.clanRenameMC.nameTxt.text = "";
            this.clanManagementMC.visible = false;
            this.confirmation = null;
        }

        public function swapMasterConfirmation(e:MouseEvent):*
        {
            if (this.clan_data.elder_name == null)
            {
                this.main.showMessage("Your clan don't have elder");
                return;
            };
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure that you want to swap master and elder?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():*
            {
                removeChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onSwapMaster);
            addChild(this.confirmation);
        }

        public function onSwapMaster(_arg_1:MouseEvent):*
        {
            removeChild(this.confirmation);
            this.main.loading(true);
            Clan.instance.swapMaster(this.onSwapMasterRes);
        }

        public function onSwapMasterRes(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            this.refreshData();
            this.main.showMessage("Elder Successfully Promoted to Master!");
            this.closeManagement();
            this.displayTab("general");
        }

        public function closeManagement(_arg_1:MouseEvent=null):*
        {
            this.clanManagementMC.visible = false;
            this.confirmation = null;
        }

        public function quitClanConfirm(_arg_1:MouseEvent):*
        {
            this.quitMC.visible = true;
            if (((this.clan_data.master_id == Character.char_id) && (this.clan_data.elder_id == null)))
            {
                this.quitMC.titleTxt.text = "Type DISBAND to Confirm";
            }
            else
            {
                this.quitMC.titleTxt.text = "Type QUIT to Confirm";
            };
            this.quitMC.warningTxt.text = "Attention:\n- Must Type in Upper Case\n- Can't Quit/Disband Clan on Final Day";
            this.eventHandler.addListener(this.quitMC.btn_close, MouseEvent.CLICK, this.closeQuitConfirm, false, 0, true);
            this.eventHandler.addListener(this.quitMC.btn_confirm, MouseEvent.CLICK, this.quitAMF, false, 0, true);
        }

        public function closeQuitConfirm(_arg_1:MouseEvent):*
        {
            this.quitMC.visible = false;
        }

        public function quitAMF(_arg_1:MouseEvent):*
        {
            var _local_2:* = this.quitMC.quitTxt.text;
            if (((this.clan_data.master_id == Character.char_id) && (this.clan_data.elder_id == null)))
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

        public function secondQuitConfirm():*
        {
            this.quit_clan = new Confirmation();
            if (((this.clan_data.master_id == Character.char_id) && (this.clan_data.elder_id == null)))
            {
                this.quit_clan.txtMc.txt.text = "Are you sure that you want to disband this clan?";
            };
            this.quit_clan.txtMc.txt.text = "Are you sure that you want to quit from your clan?";
            this.eventHandler.addListener(this.quit_clan.btn_close, MouseEvent.CLICK, this.onRemoveQuitClan);
            this.eventHandler.addListener(this.quit_clan.btn_confirm, MouseEvent.CLICK, this.onQuitAMF, false, 0, true);
            addChild(this.quit_clan);
        }

        public function onRemoveQuitClan(_arg_1:*=null):*
        {
            if (this.quit_clan)
            {
                removeChild(this.quit_clan);
            };
            this.quit_clan = null;
        }

        public function onQuitAMF(_arg_1:MouseEvent):*
        {
            this.onRemoveQuitClan();
            this.main.loading(true);
            Clan.instance.quitFromClan(this.onGetQuitRes);
        }

        public function onGetQuitRes(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Error: " + _arg_1.errorMessage));
                return;
            };
            OutfitManager.removeChildsFromMovieClips(this.main.loader);
            this.main.removeLoadedPanel("Panels.ClanVillage");
            this.main.loadPanel("Panels.Village");
            this.main.loadPanel("Panels.HUD");
            this.destroy();
        }

        public function setAnnouncementInfo():*
        {
            this.clanLogoHolder.visible = false;
            this.announcementMC.announcementTxt.text = ((!(this.clan_data.announcement)) ? "" : this.clan_data.announcement);
            this.announcementMC.btn_save.visible = false;
            this.announcementMC.btn_publish.visible = false;
            this.announcementMC.announcementTxt.selectable = false;
            this.announcementMC.announcementTxt.type = TextFieldType.DYNAMIC;
            if (((this.clan_data.master_id == Character.char_id) || (this.clan_data.elder_id == Character.char_id)))
            {
                this.announcementMC.announcementTxt.selectable = true;
                this.announcementMC.announcementTxt.type = TextFieldType.INPUT;
                this.announcementMC.btn_save.visible = true;
                this.announcementMC.btn_publish.visible = true;
                this.eventHandler.addListener(this.announcementMC.btn_save, MouseEvent.CLICK, this.saveAnnouncementReq);
                this.eventHandler.addListener(this.announcementMC.btn_publish, MouseEvent.CLICK, this.publishAnnouncement);
            };
        }

        public function saveAnnouncementReq(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            Clan.instance.updateAnnouncement(this.announcementMC.announcementTxt.text, this.onUpdatedAnnouncement);
        }

        public function onUpdatedAnnouncement(_arg_1:Object, _arg_2:*=null):*
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
            if (this.clan_village != null)
            {
                this.clan_data.announcement = this.announcementMC.announcementTxt.text;
                this.announcementMC.announcementTxt.text = ((this.clan_data.announcement) ? this.clan_data.announcement : "");
                this.main.getNotice("Announcement has been updated!");
                this.refreshData();
            };
        }

        public function publishAnnouncement(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            Clan.instance.publishAnnouncement(this.onPublishedAnnouncement);
        }

        public function onPublishedAnnouncement(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (_arg_1 == "ok")
            {
                this.main.showMessage("The announcement has been published to your members mailbox");
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getNotice("Unable to publish the announcement. Please try again later");
            };
        }

        public function getAndSetMembersInfo():*
        {
            this.main.loading(true);
            this.clanLogoHolder.visible = false;
            Clan.instance.getMembersInfo(this.showMembersInfo);
        }

        public function showMembersInfo(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("members"))))
            {
                this.members = _arg_1.members;
                this.current_page = 1;
                this.total_page = Math.ceil((this.members.length / 12));
                this.displayMembers();
                this.membersMC.txt_total_members.text = this.members.length;
                this.membersMC.txt_page.text = ((this.current_page + " / ") + this.total_page);
                this.eventHandler.addListener(this.membersMC.btn_next, MouseEvent.CLICK, this.changePage);
                this.eventHandler.addListener(this.membersMC.btn_prev, MouseEvent.CLICK, this.changePage);
                if (((!(this.clan_data.master_id == Character.char_id)) && (!(this.clan_data.elder_id == Character.char_id))))
                {
                    this.membersMC.btn_remove.visible = false;
                    this.membersMC.btn_promote.visible = false;
                    this.membersMC.btn_send.visible = false;
                };
                this.membersMC.btn_profile.visible = false;
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getError("unknown error");
        }

        public function updatePageText():*
        {
            this.membersMC.txt_page.text = ((this.current_page + " / ") + this.total_page);
        }

        public function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.total_page > this.current_page)
                    {
                        this.current_page++;
                        this.displayMembers();
                        break;
                    };
                    break;
                case "btn_prev":
                    if (this.current_page > 1)
                    {
                        this.current_page--;
                        this.displayMembers();
                    };
            };
            this.updatePageText();
        }

        public function displayMembers():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            while (_local_2 < 12)
            {
                _local_1 = (_local_2 + ((this.current_page - 1) * 12));
                if (this.members.length > _local_1)
                {
                    this.membersMC[("member_" + _local_2)].gotoAndStop(1);
                    this.membersMC[("member_" + _local_2)].visible = true;
                    if (((this.members[_local_1].char_id == Character.char_id) && (this.membersMC[("member_" + _local_2)].hasEventListener(MouseEvent.CLICK))))
                    {
                        this.membersMC[("member_" + _local_2)].removeEventListener(MouseEvent.CLICK, this.selectMember);
                    };
                    this.eventHandler.addListener(this.membersMC[("member_" + _local_2)], MouseEvent.CLICK, this.selectMember);
                    this.membersMC[("member_" + _local_2)].member_name.text = this.members[_local_1].name;
                    this.membersMC[("member_" + _local_2)].member_level.text = this.members[_local_1].level;
                    this.membersMC[("member_" + _local_2)].member_stamina.text = this.members[_local_1].stamina;
                    this.membersMC[("member_" + _local_2)].member_reputation.text = this.members[_local_1].reputation;
                    this.membersMC[("member_" + _local_2)].member_gold_donated.text = this.members[_local_1].gold_donated;
                    this.membersMC[("member_" + _local_2)].member_token_donated.text = this.members[_local_1].token_donated;
                }
                else
                {
                    this.membersMC[("member_" + _local_2)].visible = false;
                };
                _local_2++;
            };
        }

        public function resetOtherMembersMc():*
        {
            var _local_1:* = 0;
            while (_local_1 < 12)
            {
                this.membersMC[("member_" + _local_1)].gotoAndStop(1);
                _local_1++;
            };
        }

        public function selectMember(_arg_1:MouseEvent):*
        {
            this.resetOtherMembersMc();
            this.membersMC.btn_profile.visible = true;
            var _local_2:* = int(_arg_1.currentTarget.name.replace("member_", ""));
            _arg_1.currentTarget.gotoAndStop(2);
            this.selected_member_index = (_local_2 + ((this.current_page - 1) * 12));
            if (!this.membersMC.btn_remove.hasEventListener(MouseEvent.CLICK))
            {
                if (((this.clan_data.master_id == Character.char_id) || (this.clan_data.elder_id == Character.char_id)))
                {
                    this.eventHandler.addListener(this.membersMC.btn_remove, MouseEvent.CLICK, this.removeMember);
                };
            };
            if (!this.membersMC.btn_promote.hasEventListener(MouseEvent.CLICK))
            {
                if (((this.clan_data.master_id == Character.char_id) || (this.clan_data.elder_id == Character.char_id)))
                {
                    this.eventHandler.addListener(this.membersMC.btn_promote, MouseEvent.CLICK, this.onPromoteElder);
                };
            };
            if (!this.membersMC.btn_send.hasEventListener(MouseEvent.CLICK))
            {
                if (((this.clan_data.master_id == Character.char_id) || (this.clan_data.elder_id == Character.char_id)))
                {
                    this.eventHandler.addListener(this.membersMC.btn_send, MouseEvent.CLICK, this.getOnigiriLimit);
                };
            };
            if (!this.membersMC.btn_profile.hasEventListener(MouseEvent.CLICK))
            {
                this.eventHandler.addListener(this.membersMC.btn_profile, MouseEvent.CLICK, this.checkProfile);
            };
        }

        public function checkProfile(_arg_1:MouseEvent):*
        {
            if (this.friendProfile)
            {
                this.friendProfile.closePanel(null);
                this.friendProfile = null;
            };
            var _local_2:* = (getDefinitionByName("Panels.UI_Friend_Profile") as Class);
            this.friendProfile = new _local_2(this.main, this.members[this.selected_member_index].char_id, true);
            this.main.loader.addChild(this.friendProfile);
        }

        public function getOnigiriLimit(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            Clan.instance.getOnigiriInfo(this.members[this.selected_member_index].char_id, this.openOnigiri);
        }

        public function openOnigiri(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (((_arg_1 == null) && (!(_arg_2 == null))))
            {
                this.main.getError("");
                return;
            };
            if ((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("info"))) && (_arg_1.hasOwnProperty("onigiri"))))
            {
                this.sendOnigiriMC.visible = true;
                this.sendOnigiriMC.member_name.text = this.members[this.selected_member_index].name;
                this.sendOnigiriMC.onigiri_limit.text = _arg_1.info;
                this.max_amount = (40000 - int(_arg_1.onigiri));
                this.sendOnigiriMC.char_tokens.text = Character.account_tokens;
                this.eventHandler.addListener(this.sendOnigiriMC.btn_close, MouseEvent.CLICK, this.closeOnigiri);
                this.eventHandler.addListener(this.sendOnigiriMC.btnNext, MouseEvent.CLICK, this.changeAmount);
                this.eventHandler.addListener(this.sendOnigiriMC.btnPrev, MouseEvent.CLICK, this.changeAmount);
                this.cost = (this.price * this.amount);
                this.tax = (this.cost * 0.1);
                this.total = (this.cost + this.tax);
                this.sendOnigiriMC.tax.text = (((("Price: " + this.cost) + " + ") + this.tax) + " Tax");
                this.sendOnigiriMC.numTxt.text = this.amount;
                this.sendOnigiriMC.tokenCost.text = this.total;
                this.eventHandler.addListener(this.sendOnigiriMC.btn_send, MouseEvent.CLICK, this.sendOnigiri);
            };
        }

        internal function changeAmount(_arg_1:MouseEvent):void
        {
            var _local_2:* = _arg_1.currentTarget.name;
            if (((this.amount <= 100) && (!(_local_2 == "btnNext"))))
            {
                return;
            };
            if (((this.amount == this.max_amount) && (_local_2 == "btnNext")))
            {
                return;
            };
            if (_local_2 == "btnNext")
            {
                this.amount = (this.amount + 100);
            }
            else
            {
                this.amount = (this.amount - 100);
            };
            this.cost = (this.price * this.amount);
            this.tax = (this.cost * 0.1);
            this.total = (this.cost + this.tax);
            this.sendOnigiriMC.tax.text = (((("Price: " + this.cost) + " + ") + this.tax) + " Tax");
            this.sendOnigiriMC.numTxt.text = this.amount;
            this.sendOnigiriMC.tokenCost.text = this.total;
            this.eventHandler.addListener(this.sendOnigiriMC.btn_send, MouseEvent.CLICK, this.sendOnigiri);
        }

        public function sendOnigiri(_arg_1:MouseEvent):*
        {
            if (((Character.account_type == 0) && (Character.emblem_duration == -1)))
            {
                this.main.giveMessage("Must be Permanent Emblem User!");
            };
            this.main.loading(true);
            Clan.instance.giveOnigiri(this.members[this.selected_member_index].char_id, this.amount, this.onSendOnigiri);
        }

        public function onSendOnigiri(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("info"))))
            {
                this.main.giveMessage((_arg_1.amount + " Onigiri Successfully Sent!"));
                this.sendOnigiriMC.onigiri_limit.text = _arg_1.info;
                Character.account_tokens = int((int(Character.account_tokens) - _arg_1.price));
                this.sendOnigiriMC.char_tokens.text = Character.account_tokens;
                return;
            };
            if (_arg_2 != null)
            {
                this.main.giveMessage("Unknown error");
            };
        }

        private function addClanLogo():*
        {
            var _local_1:*;
            if (Character.clan_banner != null)
            {
                _local_1 = BulkLoader.getLoader("assets");
                _local_1.add(Character.clan_banner, {"id":"clanBanner"});
                this.eventHandler.addListener(_local_1, BulkLoader.COMPLETE, this.onClanLogoLoaded);
                _local_1.start();
                _local_1 = null;
            }
            else
            {
                this.clanLogoHolder.visible = false;
            };
        }

        private function onClanLogoLoaded(_arg_1:*):*
        {
            BulkLoader.getLoader("assets").removeEventListener(BulkLoader.COMPLETE, this.onClanLogoLoaded);
            this.clanLogoHolder.addChild(BulkLoader.getLoader("assets").getContent("clanBanner", true));
            this.clanLogoHolder.scaleX = 1;
            this.clanLogoHolder.scaleY = 1;
        }

        public function removeMember(e:MouseEvent):*
        {
            if (this.selected_member_index == -1)
            {
                this.main.getNotice("Select a member first!");
                return;
            };
            this.quit_pop = new Confirmation();
            this.quit_pop.txtMc.txt.text = (("Are you sure that you want to remove " + this.members[this.selected_member_index].name) + " from your clan?");
            this.eventHandler.addListener(this.quit_pop.btn_close, MouseEvent.CLICK, function ():*
            {
                removeChild(quit_pop);
            });
            this.eventHandler.addListener(this.quit_pop.btn_confirm, MouseEvent.CLICK, this.onRemoveMember);
            addChild(this.quit_pop);
        }

        public function onRemoveMember(_arg_1:MouseEvent):*
        {
            removeChild(this.quit_pop);
            this.main.loading(true);
            Clan.instance.kickMember(this.members[this.selected_member_index].char_id, this.onRemoveMemberRes);
        }

        public function onRemoveMemberRes(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            Clan.instance.getClanData(this.onGetClanResNew);
        }

        internal function getClanStatusReq(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            Clan.instance.getSeason(this.onGetClanStatusRes);
        }

        public function onGetClanStatusRes(_arg_1:Object, _arg_2:*):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (((!(_arg_2 == null)) || (_arg_1 == null)))
            {
                this.main.getNotice("Clan server is unreachable.\nProbably maintenance.\nPlease try again later");
                return;
            };
            if (((_arg_1) && (_arg_1.hasOwnProperty("timestamp"))))
            {
                Character.clan_timestamp = _arg_1.timestamp;
            };
            if (((_arg_1) && (_arg_1.hasOwnProperty("season"))))
            {
                Character.clan_season = _arg_1.season;
            };
            this.main.loading(true);
            Clan.instance.getClanData(this.onGetClanResNew);
        }

        public function onGetClanResNew(_arg_1:*, _arg_2:*=null):*
        {
            this.main.loading(false);
            if ((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("clan"))) && (_arg_1.hasOwnProperty("char"))))
            {
                Character.clan_data = _arg_1.clan;
                Character.clan_char_data = _arg_1.char;
                if (this.clan_village != null)
                {
                    this.clan_village.clan_data = _arg_1.clan;
                    this.clan_village.char_data = _arg_1.char;
                    this.clan_village.setDisplay();
                };
                this.main.loadPanel("Panels.ClanVillage");
                this.destroy();
                return;
            };
            if (_arg_2 != null)
            {
                this.main.removeLoadedPanel("Panels.ClanVillage");
                this.main.getError("Error");
                this.destroy();
            };
        }

        public function onGetClanRes(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status > 0)
            {
                if (_arg_1.status == 1)
                {
                    Character.clan_data = _arg_1.clan_data;
                    Character.clan_char_data = _arg_1.char_data;
                    this.main.loadPanel("Panels.ClanVillage");
                };
            }
            else
            {
                this.main.getError(_arg_1.error);
            };
            this.destroy();
        }

        public function onPromoteElder(_arg_1:MouseEvent):*
        {
            if (this.selected_member_index == -1)
            {
                this.main.getNotice("Select a member first!");
                return;
            };
            this.main.loading(true);
            Clan.instance.promoteElder(this.members[this.selected_member_index].char_id, this.onPromoteElderRes);
        }

        public function onPromoteElderRes(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getError();
                return;
            };
            this.main.giveMessage((this.members[this.selected_member_index].name + " is promoted as elder!"));
            this.refreshData();
        }

        public function refreshData():*
        {
            Clan.instance.getClanData(this.onRefreshData);
        }

        public function onRefreshData(_arg_1:*, _arg_2:*=null):*
        {
            this.main.loading(false);
            if ((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("clan"))) && (_arg_1.hasOwnProperty("char"))))
            {
                Character.clan_data = _arg_1.clan;
                Character.clan_char_data = _arg_1.char;
                if (this.clan_village != null)
                {
                    this.clan_village.clan_data = _arg_1.clan;
                    this.clan_village.char_data = _arg_1.char;
                    this.clan_village.setDisplay();
                };
                return;
            };
            if (_arg_2 != null)
            {
                this.main.removeLoadedPanel("Panels.ClanVillage");
                this.main.getError("Error");
                this.destroy();
            };
        }

        internal function closeOnigiri(_arg_1:MouseEvent):void
        {
            this.sendOnigiriMC.visible = false;
        }

        public function destroy():*
        {
            Log.debug(this, "DESTROY");
            if (this.eventHandler == null)
            {
                return;
            };
            if (this.friendProfile)
            {
                this.friendProfile.closePanel(null);
                this.friendProfile = null;
            };
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.main = null;
            this.clan_village = null;
            this.confirmation = null;
            GF.removeAllChild(this);
        }


    }
}//package Panels

