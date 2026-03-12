// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.ClanMemberRequest

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import id.ninjasage.Clan;
    import Storage.Character;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.net.URLRequest;
    import id.ninjasage.Util;
    import id.ninjasage.Log;
    import flash.geom.ColorTransform;
    import Popups.Confirmation;
    import flash.utils.setTimeout;
    import com.utils.GF;

    public class ClanMemberRequest extends MovieClip 
    {

        public var btn_accept:SimpleButton;
        public var btn_close:SimpleButton;
        public var btn_next:SimpleButton;
        public var btn_prev:SimpleButton;
        public var btn_reject:SimpleButton;
        public var btn_rejectAll:SimpleButton;
        public var btn_invite_member:SimpleButton;
        public var member_0:MovieClip;
        public var member_1:MovieClip;
        public var member_2:MovieClip;
        public var member_3:MovieClip;
        public var member_4:MovieClip;
        public var member_5:MovieClip;
        public var member_6:MovieClip;
        public var member_7:MovieClip;
        public var addMemberMC:MovieClip;
        public var txt_page:TextField;
        public var main:*;
        public var clan_village:*;
        public var clan_hall:*;
        public var member_sel_slot:int = -1;
        public var member_sel_idx:int = -1;
        public var current_page:* = 0;
        public var total_page:* = 0;
        public var search:* = "";
        public var charData:*;
        public var charSets:*;
        public var color_1:*;
        public var color_2:*;
        public var char_id:*;
        internal var pop:*;

        public var eventHandler:* = new EventHandler();
        public var members:Array = [];

        public function ClanMemberRequest(_arg_1:*, _arg_2:*, _arg_3:*)
        {
            this.main = _arg_1;
            this.clan_village = _arg_2;
            this.clan_hall = _arg_3;
            this.addButtonListeners();
            this.clearMemberTable();
            this.updatePageText();
            this.getMembersTable();
            this.addMemberMC.visible = false;
        }

        public function updatePageText():*
        {
            this.txt_page.text = ((this.current_page + " / ") + this.total_page);
        }

        public function clearMemberTable(_arg_1:Boolean=false):*
        {
            var _local_2:* = 0;
            while (_local_2 < 8)
            {
                this[("member_" + _local_2)].gotoAndStop(1);
                if (!this[("member_" + _local_2)].hasEventListener(MouseEvent.CLICK))
                {
                    this.eventHandler.addListener(this[("member_" + _local_2)], MouseEvent.CLICK, this.onSelectMember);
                };
                this[("member_" + _local_2)].visible = _arg_1;
                _local_2++;
            };
        }

        public function onSelectMember(_arg_1:MouseEvent):*
        {
            if (this.member_sel_slot != -1)
            {
                this[("member_" + this.member_sel_slot)].gotoAndStop(1);
            };
            var _local_2:* = int(_arg_1.currentTarget.name.replace("member_", ""));
            this.member_sel_slot = _local_2;
            this.member_sel_idx = (_local_2 + ((this.current_page - 1) * 8));
            _arg_1.currentTarget.gotoAndStop(2);
        }

        public function getMembersTable():*
        {
            this.main.loading(true);
            Clan.instance.getMemberRequests(this.onGetMembersRes);
        }

        public function onGetMembersRes(_arg_1:*, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("requests"))))
            {
                this.members = _arg_1.requests;
                this.current_page = 1;
                this.total_page = Math.ceil((_arg_1.total / 8));
                this.displayMembers();
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getError("unknown error");
        }

        public function displayMembers():*
        {
            var _local_1:* = undefined;
            var _local_2:* = undefined;
            var _local_3:* = undefined;
            var _local_4:* = undefined;
            this.updatePageText();
            this.clearMemberTable();
            this.member_sel_idx = -1;
            var _local_5:* = 0;
            while (_local_5 < 8)
            {
                _local_1 = (_local_5 + ((this.current_page - 1) * 8));
                if (this.members.length > _local_1)
                {
                    this[("member_" + _local_5)].gotoAndStop(1);
                    this[("member_" + _local_5)].visible = true;
                    this[("member_" + _local_5)].member_id.text = this.members[_local_1].char_id;
                    this[("member_" + _local_5)].member_name.text = this.members[_local_1].name;
                    this[("member_" + _local_5)].member_level.text = this.members[_local_1].level;
                    this[("member_" + _local_5)].emblemMc.visible = false;
                    if (this.members[_local_1].emblem == 1)
                    {
                        this[("member_" + _local_5)].emblemMc.visible = true;
                    };
                    this[("member_" + _local_5)].element_1.gotoAndStop(1);
                    this[("member_" + _local_5)].element_2.gotoAndStop(1);
                    this[("member_" + _local_5)].element_3.gotoAndStop(1);
                    this[("member_" + _local_5)].element_4.gotoAndStop(1);
                    this[("member_" + _local_5)].element_5.gotoAndStop(1);
                    _local_2 = this.members[_local_1].element_1;
                    _local_3 = this.members[_local_1].element_2;
                    _local_4 = this.members[_local_1].element_3;
                    if (([("element_" + _local_2)] in this[("member_" + _local_5)]))
                    {
                        this[("member_" + _local_5)][("element_" + _local_2)].gotoAndStop(2);
                    };
                    if (([("element_" + _local_3)] in this[("member_" + _local_5)]))
                    {
                        this[("member_" + _local_5)][("element_" + _local_3)].gotoAndStop(2);
                    };
                    if (([("element_" + _local_4)] in this[("member_" + _local_5)]))
                    {
                        this[("member_" + _local_5)][("element_" + _local_4)].gotoAndStop(2);
                    };
                }
                else
                {
                    this[("member_" + _local_5)].visible = false;
                };
                _local_5++;
            };
        }

        public function addButtonListeners():*
        {
            this.eventHandler.addListener(this.btn_accept, MouseEvent.CLICK, this.onAcceptReq);
            this.eventHandler.addListener(this.btn_reject, MouseEvent.CLICK, this.onRejectReq);
            this.eventHandler.addListener(this.btn_rejectAll, MouseEvent.CLICK, this.onRejectAllReq);
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.onClosePanel);
            this.eventHandler.addListener(this.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.btn_invite_member, MouseEvent.CLICK, this.onInviteMember);
        }

        public function onInviteMember(_arg_1:MouseEvent):*
        {
            this.addMemberMC.visible = true;
            this.addMemberMC.characterInfo.visible = false;
            this.addMemberMC.btn_invite_member.visible = false;
            this.eventHandler.addListener(this.addMemberMC.btn_search, MouseEvent.CLICK, this.searchCharacter);
            this.eventHandler.addListener(this.addMemberMC.btn_close, MouseEvent.CLICK, this.closePanelInvite);
        }

        public function searchCharacter(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.addMemberMC.char_id = this.addMemberMC.search.text;
            this.addMemberMC.characterInfo.visible = false;
            this.addMemberMC.btn_invite_member.visible = false;
            this.main.amf_manager.service("CharacterService.getInfo", [Character.char_id, Character.sessionkey, this.addMemberMC.search.text], this.searchCallback);
        }

        public function searchCallback(_arg_1:*):*
        {
            var _local_4:Loader;
            this.main.loading(false);
            if (((_arg_1.status > 1) && (_arg_1.result)))
            {
                this.main.getNotice(_arg_1.result);
                return;
            };
            if (((!(_arg_1.result)) && (_arg_1.status > 1)))
            {
                this.main.getNotice("Unknown error");
                return;
            };
            this.char_id = this.addMemberMC.char_id;
            this.addMemberMC.btn_invite_member.visible = true;
            this.eventHandler.addListener(this.addMemberMC.btn_invite_member, MouseEvent.CLICK, this.sendInviteRequest);
            var _local_2:* = _arg_1.character_data;
            this.charData = _local_2;
            this.charSets = _arg_1.character_sets;
            this.addMemberMC.characterInfo.visible = true;
            this.addMemberMC.characterInfo.lvlMC.txt_lvl.text = _local_2.character_level;
            this.addMemberMC.characterInfo.txt_name.text = _local_2.character_name;
            this.addMemberMC.characterInfo.rankMC.gotoAndStop(_local_2.character_rank);
            this.addMemberMC.characterInfo.element_1.gotoAndStop((int(_local_2.character_element_1) + 1));
            this.addMemberMC.characterInfo.element_2.gotoAndStop((int(_local_2.character_element_2) + 1));
            if (_arg_1.account_type == 0)
            {
                this.addMemberMC.characterInfo.element_3.gotoAndStop(1);
            }
            else
            {
                this.addMemberMC.characterInfo.element_3.gotoAndStop((int(_local_2.character_element_3) + 1));
            };
            this.addMemberMC.characterInfo.emblemMC.gotoAndStop((int(_arg_1.account_type) + 1));
            this.addMemberMC.characterInfo.talent_1.gotoAndStop(4);
            this.addMemberMC.characterInfo.talent_2.gotoAndStop(4);
            this.addMemberMC.characterInfo.talent_3.gotoAndStop(4);
            var _local_3:Loader = new Loader();
            this.eventHandler.addListener(_local_3.contentLoaderInfo, Event.COMPLETE, this.onCompleteHair);
            _local_3.load(new URLRequest(Util.url((("items/" + this.charSets.hairstyle) + ".swf"))));
            this.eventHandler.addListener((_local_4 = new Loader()).contentLoaderInfo, Event.COMPLETE, this.onCompleteFace);
            _local_4.load(new URLRequest(Util.url((("items/" + this.charSets.face) + ".swf"))));
        }

        public function onCompleteHair(param1:*):*
        {
            var back_hair:Class;
            var e:* = param1;
            var hair:Class = (e.target.applicationDomain.getDefinition("hair") as Class);
            this.addMemberMC.hairMC = new (hair)();
            var hair_mc:* = [];
            if (this.addMemberMC.characterInfo.holder["hair"].numChildren > 0)
            {
                this.addMemberMC.characterInfo.holder["hair"].removeChildAt(0);
            };
            this.addMemberMC.characterInfo.holder["hair"].addChild(this.addMemberMC.hairMC);
            hair_mc.push(this.addMemberMC.hairMC);
            this.addHairColor(0);
            try
            {
                back_hair = (e.target.applicationDomain.getDefinition("back_hair") as Class);
                this.addMemberMC.backHairMC = new (back_hair)();
                if (this.addMemberMC.characterInfo.holder["back_hair"].numChildren > 0)
                {
                    this.addMemberMC.characterInfo.holder["back_hair"].removeChildAt(0);
                };
                this.addMemberMC.characterInfo.holder["back_hair"].addChild(this.addMemberMC.backHairMC);
                hair_mc.push(this.addMemberMC.backHairMC);
                this.addHairColor(1);
            }
            catch(e:Error)
            {
                Log.error(this, "hair model error ", e);
            };
        }

        public function onCompleteFace(param1:*):*
        {
            var ClassDefinition:Class;
            var butn:MovieClip;
            var e:* = param1;
            try
            {
                ClassDefinition = (e.target.applicationDomain.getDefinition("face") as Class);
                butn = new (ClassDefinition)();
                while (this.addMemberMC.characterInfo.holder["face"].numChildren > 0)
                {
                    this.addMemberMC.characterInfo.holder["face"].removeChildAt(0);
                };
                this.addMemberMC.characterInfo.holder["face"].addChild(butn);
            }
            catch(e)
            {
                Log.error(this, "face model error", e);
            };
        }

        public function addHairColor(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:ColorTransform = new ColorTransform();
            var _local_4:ColorTransform = new ColorTransform();
            var _local_5:* = (_local_2 = this.charSets.hair_color).split("|");
            _local_3.color = _local_5[0];
            _local_4.color = _local_5[1];
            this.color_1 = _local_5[0];
            this.color_2 = _local_5[1];
            if (_arg_1 == 0)
            {
                if (_local_5[0] != "null")
                {
                    this.addMemberMC.hairMC.hair_color_1.transform.colorTransform = _local_3;
                };
                if (_local_5[1] != "null")
                {
                    this.addMemberMC.hairMC.hair_color_2.transform.colorTransform = _local_4;
                };
            }
            else
            {
                if (_local_5[0] != "null")
                {
                    this.addMemberMC.backHairMC.hair_color_1.transform.colorTransform = _local_3;
                };
                if (_local_5[1] != "null")
                {
                    this.addMemberMC.backHairMC.hair_color_2.transform.colorTransform = _local_4;
                };
            };
        }

        internal function killEverythingInvite():void
        {
            this.addMemberMC.btn_close.removeEventListener(MouseEvent.CLICK, this.closePanelInvite);
            this.addMemberMC.btn_search.removeEventListener(MouseEvent.CLICK, this.closePanelInvite);
            this.addMemberMC.characterInfo.element_1.removeEventListener(MouseEvent.CLICK, this.closePanelInvite);
            this.addMemberMC.characterInfo.element_2.removeEventListener(MouseEvent.CLICK, this.closePanelInvite);
            this.addMemberMC.characterInfo.element_3.removeEventListener(MouseEvent.CLICK, this.closePanelInvite);
            this.addMemberMC.characterInfo.element_3.removeEventListener(MouseEvent.CLICK, this.closePanelInvite);
            this.addMemberMC.characterInfo.emblemMC.removeEventListener(MouseEvent.CLICK, this.closePanelInvite);
            this.addMemberMC.main = null;
        }

        internal function closePanelInvite(_arg_1:MouseEvent):void
        {
            this.killEverythingInvite();
            parent.removeChild(this);
        }

        public function sendInviteRequest(_arg_1:MouseEvent):*
        {
            if (this.char_id == "")
            {
                this.main.getNotice("No char_id!");
                return;
            };
            Clan.instance.inviteCharacter(this.char_id, this.onInviteRequestSent);
        }

        public function onInviteRequestSent(_arg_1:Object, _arg_2:*=null):*
        {
            if (_arg_1 == "ok")
            {
                this.main.giveMessage("Invitation has been sent");
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Unable to send Invitation.\n" + _arg_1.errorMessage));
            };
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

        public function onRejectMembersResConf(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            Clan.instance.rejectMembers(this.onRejectMemberRes);
        }

        public function onRejectAllReq(param1:MouseEvent):*
        {
            var e:MouseEvent = param1;
            this.pop = new Confirmation();
            this.pop.txtMc.txt.text = "Are you sure that you want to reject all requests?";
            this.eventHandler.addListener(this.pop.btn_close, MouseEvent.CLICK, function ():*
            {
                removeChild(pop);
                this.pop = null;
            });
            this.eventHandler.addListener(this.pop.btn_confirm, MouseEvent.CLICK, this.onRejectMembersResConf);
            addChild(this.pop);
        }

        public function onRejectMemberResConf(_arg_1:MouseEvent):*
        {
            var _local_2:* = this.members[this.member_sel_idx].char_id;
            this.main.loading(true);
            Clan.instance.rejectMember(_local_2, this.onRejectMemberRes);
        }

        public function onRejectReq(param1:MouseEvent):*
        {
            var e:MouseEvent = param1;
            if (this.member_sel_idx == -1)
            {
                this.main.getNotice("Please select a member first!");
            }
            else
            {
                this.pop = new Confirmation();
                this.pop.txtMc.txt.text = "Are you sure that you want to reject this request?";
                this.eventHandler.addListener(this.pop.btn_close, MouseEvent.CLICK, function ():*
                {
                    removeChild(pop);
                });
                this.eventHandler.addListener(this.pop.btn_confirm, MouseEvent.CLICK, this.onRejectMemberResConf);
                addChild(this.pop);
            };
        }

        public function onRejectMemberRes(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("result"))))
            {
                this.main.getNotice("Member has been rejected");
                this.clearMemberTable();
                setTimeout(this.getMembersTable, 1000);
                this.member_sel_idx = -1;
                this.clan_hall.displayTab("general");
                this.clan_village.setDisplay();
                removeChild(this.pop);
                this.pop = null;
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getNotice("Failed to reject the request. Please try again later");
        }

        public function onAcceptMembersResConf(_arg_1:MouseEvent):*
        {
            var _local_2:* = this.members[this.member_sel_idx].char_id;
            this.main.loading(true);
            Clan.instance.acceptMember(_local_2, this.onAcceptMemberRes);
        }

        public function onAcceptReq(param1:MouseEvent):*
        {
            var e:MouseEvent = param1;
            if (this.member_sel_idx == -1)
            {
                this.main.getNotice("Please select a member first!");
            }
            else
            {
                this.pop = new Confirmation();
                this.pop.txtMc.txt.text = "Are you sure that you want to accept this request?";
                this.eventHandler.addListener(this.pop.btn_close, MouseEvent.CLICK, function ():*
                {
                    removeChild(pop);
                });
                this.eventHandler.addListener(this.pop.btn_confirm, MouseEvent.CLICK, this.onAcceptMembersResConf);
                addChild(this.pop);
            };
        }

        public function onAcceptMemberRes(_arg_1:Object, _arg_2:*):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("result"))))
            {
                this.main.getNotice("Member accepted");
                this.clearMemberTable();
                setTimeout(this.getMembersTable, 1000);
                this.member_sel_idx = -1;
                this.clan_hall.displayTab("general");
                this.clan_village.setDisplay();
                removeChild(this.pop);
                this.pop = null;
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(("Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getNotice("Failed to accept the member. Please try again later");
        }

        public function onClosePanel(_arg_1:MouseEvent):*
        {
            parent.removeChild(this);
            this.clan_hall.displayTab("general");
            this.clan_village.setDisplay();
            this.destroy();
        }

        public function destroy():*
        {
            GF.clearArray(this.members);
            this.pop = null;
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.main = null;
            this.clan_hall = null;
            this.clan_village = null;
            GF.removeAllChild(this);
        }


    }
}//package Panels

