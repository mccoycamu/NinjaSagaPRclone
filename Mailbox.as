// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Mailbox

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import Popups.Confirmation;
    import Storage.Character;
    import com.utils.GF;
    import Managers.NinjaSage;

    public class Mailbox extends MovieClip 
    {

        public var btn_close:SimpleButton;
        public var contentMc:MovieClip;
        public var listMc:MovieClip;
        public var main:*;
        public var curr_page:* = 1;
        public var total_page:* = 1;
        public var current_mail:*;
        public var confirmation:*;

        public var eventHandler:* = new EventHandler();
        public var mails:Array = [];
        public var rws:Array = [];

        public function Mailbox(_arg_1:*)
        {
            this.main = _arg_1;
            this.gotoAndStop(1);
            this.addButtonListeners();
            this.setDisplay();
            this.getMails();
            this.updatePageText();
        }

        public function updatePageText():*
        {
            this.listMc.txt_page.text = ((this.curr_page + "/") + this.total_page);
        }

        public function addButtonListeners():*
        {
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.onClose);
            this.eventHandler.addListener(this.listMc.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.listMc.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.listMc.btn_claim, MouseEvent.CLICK, this.confirmationMessage);
            this.eventHandler.addListener(this.listMc.btn_delete, MouseEvent.CLICK, this.confirmationMessage);
        }

        public function setDisplay():*
        {
            var _local_1:* = 0;
            while (_local_1 < 4)
            {
                this.listMc[("mail_" + _local_1)].visible = false;
                this.eventHandler.removeListener(this.listMc[("mail_" + _local_1)], MouseEvent.CLICK, this.openMailInfo);
                this.eventHandler.addListener(this.listMc[("mail_" + _local_1)], MouseEvent.CLICK, this.openMailInfo);
                _local_1++;
            };
        }

        public function confirmationMessage(e:MouseEvent):*
        {
            var name:* = e.currentTarget.name.replace("btn_", "");
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (("Are you sure that you want to " + name) + " all mail that contain rewards?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():*
            {
                removeChild(confirmation);
            });
            if (name == "claim")
            {
                this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onClaimAll);
            }
            else
            {
                this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onDeleteAll);
            };
            addChild(this.confirmation);
        }

        public function onClaimAll(_arg_1:MouseEvent):*
        {
            removeChild(this.confirmation);
            this.main.amf_manager.service("MailService.executeService", ["claimAllRewards", [Character.char_id, Character.sessionkey]], this.claimAllResponse);
        }

        public function onDeleteAll(_arg_1:MouseEvent):*
        {
            removeChild(this.confirmation);
            this.main.amf_manager.service("MailService.executeService", ["deleteAllMails", [Character.char_id, Character.sessionkey]], this.onResponse);
        }

        public function onResponse(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                this.backToMails();
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

        public function claimAllResponse(_arg_1:Object=null):*
        {
            if (_arg_1.status == 1)
            {
                if (_arg_1.rewards != "")
                {
                    this.main.giveReward(1, _arg_1.rewards);
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.showMessage(_arg_1.result);
                };
                this.backToMails();
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

        public function deleteMail(_arg_1:MouseEvent):*
        {
            var _local_2:* = this.current_mail.mail_id;
            this.main.loading(true);
            var _local_3:Array = [Character.char_id, Character.sessionkey, _local_2];
            this.main.amf_manager.service("MailService.executeService", ["deleteMail", _local_3], this.onDeleteMail);
        }

        public function onDeleteMail(_arg_1:Object):*
        {
            this.main.loading(false);
            if (("result" in _arg_1))
            {
                this.main.getNotice(_arg_1.result);
            }
            else
            {
                this.main.getNotice("Mail has been deleted!");
            };
            this.backToMails();
        }

        public function backToMails(_arg_1:MouseEvent=null):*
        {
            this.gotoAndStop(1);
            this.setDisplay();
            this.getMails();
            this.updatePageText();
            this.addButtonListeners();
        }

        public function acceptFriendRequest(_arg_1:MouseEvent):*
        {
            this.eventHandler.removeListener(this.contentMc.actionHolder.btn_acceptinvite, MouseEvent.CLICK, this.acceptFriendRequest);
            var _local_2:* = this.current_mail.mail_id;
            this.main.loading(true);
            var _local_3:Array = [Character.char_id, Character.sessionkey, _local_2];
            this.main.amf_manager.service("MailService.executeService", ["acceptFriendRequest", _local_3], this.onFriendAccepted);
        }

        public function onFriendAccepted(_arg_1:Object):*
        {
            this.main.loading(false);
            this.main.getNotice(_arg_1.result);
            this.backToMails();
        }

        public function acceptClanInvitation(_arg_1:MouseEvent):*
        {
            this.eventHandler.removeListener(this.contentMc.actionHolder.btn_acceptinvite, MouseEvent.CLICK, this.acceptFriendRequest);
            var _local_2:* = this.current_mail.mail_id;
            this.main.loading(true);
            var _local_3:Array = [Character.char_id, Character.sessionkey, _local_2];
            this.main.amf_manager.service("MailService.executeService", ["acceptInvitation", _local_3], this.onClanAccpeted);
        }

        public function onClanAccpeted(_arg_1:Object):*
        {
            this.main.loading(false);
            this.main.getNotice(_arg_1.result);
            this.backToMails();
        }

        public function openMailInfo(param1:MouseEvent):*
        {
            var e:MouseEvent = param1;
            var m:* = int(e.currentTarget.name.replace("mail_", ""));
            m = (m + ((int(this.curr_page) - 1) * 4));
            this.current_mail = this.mails[m];
            var params:Array = [Character.char_id, Character.sessionkey, this.current_mail.mail_id];
            this.main.amf_manager.service("MailService.executeService", ["openMail", params], function (_arg_1:*):*
            {
            });
            this.gotoAndStop(2);
            this.contentMc.btn_claim.visible = false;
            this.eventHandler.addListener(this.contentMc.backBtn, MouseEvent.CLICK, this.backToMails);
            this.eventHandler.addListener(this.contentMc.deleteBtn, MouseEvent.CLICK, this.deleteMail);
            this.contentMc.titleTxt.text = this.current_mail.mail_title;
            this.contentMc.senderTxt.text = this.current_mail.mail_sender;
            this.contentMc.dateTxt.text = this.current_mail.sent_date;
            this.contentMc.bodyTxt.text = this.current_mail.mail_body;
            this.contentMc.btn_claim.visible = false;
            this.contentMc.actionHolder.x = 305;
            this.contentMc.actionHolder.y = 365;
            if (this.current_mail.mail_type == 2)
            {
                this.contentMc.actionHolder.gotoAndStop(2);
                this.eventHandler.addListener(this.contentMc.actionHolder.btn_acceptinvite, MouseEvent.CLICK, this.acceptFriendRequest);
            }
            else
            {
                if (((this.current_mail.mail_type == 3) || (this.current_mail.mail_type == 6)))
                {
                    this.contentMc.actionHolder.gotoAndStop(1);
                    this.eventHandler.addListener(this.contentMc.actionHolder.btn_acceptinvite, MouseEvent.CLICK, this.acceptClanInvitation);
                }
                else
                {
                    if (this.current_mail.mail_type == 4)
                    {
                        this.contentMc.actionHolder.gotoAndStop(5);
                        this.displayRewardIcons();
                        this.contentMc.actionHolder.x = 400;
                        this.contentMc.actionHolder.y = 260;
                    }
                    else
                    {
                        if (this.current_mail.mail_type == 5)
                        {
                            this.contentMc.actionHolder.gotoAndStop(5);
                            this.displayRewardIcons(true);
                        }
                        else
                        {
                            this.contentMc.actionHolder.visible = false;
                        };
                    };
                };
            };
            Character.has_notification = false;
            this.main.HUD.checkNotification();
        }

        public function claimRewards(_arg_1:MouseEvent):*
        {
            var _local_2:* = this.current_mail.mail_id;
            this.main.loading(true);
            var _local_3:Array = [Character.char_id, Character.sessionkey, _local_2];
            this.main.amf_manager.service("MailService.executeService", ["claimReward", _local_3], this.onClaimMailRewards);
        }

        public function onClaimMailRewards(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status != 1)
            {
                if (_arg_1.status == 0)
                {
                    this.main.getError(_arg_1.error);
                }
                else
                {
                    this.main.getNotice(_arg_1.result);
                };
                return;
            };
            var _local_2:* = 0;
            while (_local_2 < 13)
            {
                GF.removeAllChild(this.contentMc.actionHolder[("rewardIcon_" + _local_2)].iconMc.rewardIcon.iconHolder);
                GF.removeAllChild(this.contentMc.actionHolder[("rewardIcon_" + _local_2)].iconMc.skillIcon.iconHolder);
                _local_2++;
            };
            Character.addRewards(_arg_1.rewards);
            this.main.giveReward(1, _arg_1.rewards);
            this.main.HUD.setBasicData();
            this.backToMails();
        }

        public function displayRewardIcons(_arg_1:Boolean=false):*
        {
            var _local_6:String;
            var _local_7:int;
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            this.rws = [this.current_mail.mail_rewards];
            if (this.current_mail.mail_rewards.indexOf(",") >= 0)
            {
                this.rws = this.current_mail.mail_rewards.split(",");
            };
            this.contentMc.btn_claim.visible = false;
            if (_arg_1)
            {
                this.contentMc.actionHolder.x = 370;
                this.contentMc.actionHolder.y = 260;
                if (int(this.current_mail.mail_claimed) == 0)
                {
                    this.contentMc.btn_claim.visible = true;
                }
                else
                {
                    this.contentMc.btn_claim.visible = false;
                };
                this.eventHandler.addListener(this.contentMc.btn_claim, MouseEvent.CLICK, this.claimRewards);
            }
            else
            {
                this.contentMc.actionHolder.x = 330;
                this.contentMc.actionHolder.y = 388;
            };
            var _local_5:* = 0;
            while (_local_5 < 13)
            {
                this.contentMc.actionHolder[("rewardIcon_" + _local_5)].visible = false;
                if (this.rws.length > _local_5)
                {
                    this.contentMc.actionHolder[("rewardIcon_" + _local_5)].visible = true;
                    this.contentMc.actionHolder[("rewardIcon_" + _local_5)].amountTxt.visible = false;
                    this.contentMc.actionHolder[("rewardIcon_" + _local_5)].iconMc.ownedTxt.visible = false;
                    this.contentMc.actionHolder[("rewardIcon_" + _local_5)].iconMc.amtTxt.text = "";
                    _local_6 = this.rws[_local_5].split(":")[0];
                    _local_7 = this.rws[_local_5].split(":")[1];
                    if (_local_7 > 0)
                    {
                        this.contentMc.actionHolder[("rewardIcon_" + _local_5)].iconMc.amtTxt.text = ("x" + this.rws[_local_5].split(":")[1]);
                    };
                    if (Character.hasSkill(_local_6) > 0)
                    {
                        this.contentMc.actionHolder[("rewardIcon_" + _local_5)].iconMc.ownedTxt.visible = true;
                        this.contentMc.actionHolder[("rewardIcon_" + _local_5)].iconMc.ownedTxt.text = "Owned";
                    };
                    if (Character.isItemOwned(_local_6) > 0)
                    {
                        this.contentMc.actionHolder[("rewardIcon_" + _local_5)].iconMc.ownedTxt.visible = true;
                        this.contentMc.actionHolder[("rewardIcon_" + _local_5)].iconMc.ownedTxt.text = "Owned";
                    };
                    NinjaSage.loadItemIcon(this.contentMc.actionHolder[("rewardIcon_" + _local_5)].iconMc, _local_6);
                };
                _local_5++;
            };
        }

        public function getMails():*
        {
            this.main.loading(true);
            var _local_1:Array = [Character.char_id, Character.sessionkey];
            this.main.amf_manager.service("MailService.executeService", ["getMails", _local_1], this.onGetMails);
        }

        public function onGetMails(_arg_1:Object):*
        {
            this.mails = _arg_1.mails;
            this.curr_page = 1;
            this.total_page = Math.ceil((this.mails.length / 4));
            if (this.total_page > 0)
            {
                this.updatePageText();
            };
            this.displayMails();
        }

        public function displayMails():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            while (_local_2 < 4)
            {
                this.listMc[("mail_" + _local_2)].visible = false;
                _local_1 = (_local_2 + ((int(this.curr_page) - 1) * 4));
                if (this.mails.length > _local_1)
                {
                    this.listMc[("mail_" + _local_2)].visible = true;
                    this.listMc[("mail_" + _local_2)].new_mc.visible = false;
                    this.listMc[("mail_" + _local_2)].titleTxt.text = this.mails[_local_1].mail_title;
                    this.listMc[("mail_" + _local_2)].senderTxt.text = this.mails[_local_1].mail_sender;
                    this.listMc[("mail_" + _local_2)].dateTxt.text = this.mails[_local_1].sent_date;
                    if (this.mails[_local_1].mail_viewed == 0)
                    {
                        this.listMc[("mail_" + _local_2)].new_mc.visible = true;
                    };
                };
                _local_2++;
            };
            this.main.loading(false);
        }

        public function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.total_page > this.curr_page)
                    {
                        this.curr_page++;
                        this.displayMails();
                        break;
                    };
                    break;
                case "btn_prev":
                    if (this.curr_page > 1)
                    {
                        this.curr_page--;
                        this.displayMails();
                        break;
                    };
            };
            this.updatePageText();
        }

        public function onClose(_arg_1:MouseEvent):*
        {
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.main = null;
            parent.removeChild(this);
        }


    }
}//package Panels

