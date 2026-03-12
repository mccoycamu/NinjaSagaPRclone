// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.Social

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import br.com.stimuli.loading.BulkLoader;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import Storage.Character;
    import Managers.OutfitManager;
    import flash.utils.getDefinitionByName;
    import com.adobe.crypto.CUCSG;
    import Storage.MissionLibrary;
    import Combat.BattleManager;
    import Combat.BattleVars;
    import com.utils.GF;
    import flash.events.Event;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.display.Sprite;
    import flash.display.GradientType;

    public dynamic class Social extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var currentPage:int = 1;
        private var totalPage:int = 1;
        private var friendData:Object;
        private var friendRequestData:Object;
        private var friendRecommendationData:Object;
        private var addFriendData:Object;
        private var isRecruitable:Boolean = true;
        private var totalFriendRequest:int;
        private var totalFriend:int;
        private var limitFriend:int;
        private var outfits:Array = [];
        private var selectedFriendIndex:int;
        private var selectedFriendId:int;
        private var originalOverlayIndex:int;
        private var tabArray:Array = ["allfriend", "favorite", "request", "recommendation"];
        private var currentTab:String;
        private var acceptRejectButton:String;
        private var selectMode:Boolean = false;
        private var selectedIdArray:Array = [];
        private var loaderSwf:BulkLoader;

        public function Social(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.loaderSwf = BulkLoader.createUniqueNamedLoader(10, BulkLoader.LOG_INFO);
            this.initUI();
        }

        private function initUI():void
        {
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btn_Friendship_Shop, MouseEvent.CLICK, this.openFriendshipShop);
            this.eventHandler.addListener(this.panelMC.friendListMC.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.friendListMC.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.friendRequestMC.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.friendRequestMC.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.friendRecommendationMC.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.friendRecommendationMC.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.friendRequestMC.btn_acceptAll, MouseEvent.CLICK, this.handleAcceptRejectFriendRequest);
            this.eventHandler.addListener(this.panelMC.friendRequestMC.btn_rejectAll, MouseEvent.CLICK, this.handleAcceptRejectFriendRequest);
            this.eventHandler.addListener(this.panelMC.friendListMC.allowMC, MouseEvent.CLICK, this.handleAllowRecruit);
            this.eventHandler.addListener(this.panelMC.friendListMC.btn_removeRecruit, MouseEvent.CLICK, this.removeRecruitedSquad);
            this.eventHandler.addListener(this.panelMC.friendListMC.searchBtn, MouseEvent.CLICK, this.onSearch);
            this.eventHandler.addListener(this.panelMC.friendListMC.clearSearch, MouseEvent.CLICK, this.onSearchClear);
            this.eventHandler.addListener(this.panelMC.friendListMC.btn_unfriend, MouseEvent.CLICK, this.handleUnfriend);
            this.eventHandler.addListener(this.panelMC.friendListMC.btn_AddFriend, MouseEvent.CLICK, this.handleAddFriend);
            NinjaSage.showDynamicTooltip(this.panelMC.friendListMC.allowHint, "Allow your friend to recruit this character");
            NinjaSage.showDynamicTooltip(this.panelMC.friendListMC.clearSearch, "Clear search");
            this.hideTabContent();
            this.getFriendList();
            this.resetSelectedTab();
            this.checkRecruited();
            this.currentTab = "allfriend";
            var _local_1:int;
            while (_local_1 < this.tabArray.length)
            {
                this.eventHandler.addListener(this.panelMC[("btn_" + this.tabArray[_local_1])], MouseEvent.CLICK, this.changeTab);
                this.eventHandler.addListener(this.panelMC[("btn_" + this.tabArray[_local_1])], MouseEvent.MOUSE_OVER, this.over);
                this.eventHandler.addListener(this.panelMC[("btn_" + this.tabArray[_local_1])], MouseEvent.MOUSE_OUT, this.out);
                _local_1++;
            };
            this.panelMC[("btn_" + this.currentTab)].gotoAndStop(3);
        }

        private function getFriendList():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.friends", [Character.char_id, Character.sessionkey, this.currentPage], this.friendListResponse);
        }

        private function getFriendFavorite():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.getFavorite", [Character.char_id, Character.sessionkey, this.currentPage], this.friendListResponse);
        }

        private function getFriendRequest():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.friendRequests", [Character.char_id, Character.sessionkey, this.currentPage], this.friendRequestResponse);
        }

        private function getFriendRecommendation():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.getRecommendations", [Character.char_id, Character.sessionkey, this.currentPage], this.friendRecommendationResponse);
        }

        private function friendListResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.friendData = _arg_1.friends;
                this.isRecruitable = ((_arg_1.hasOwnProperty("recruitable")) ? _arg_1.recruitable : this.isRecruitable);
                this.currentPage = _arg_1.page.current;
                this.totalPage = _arg_1.page.total;
                this.limitFriend = _arg_1.limit;
                this.totalFriend = _arg_1.total;
                this.renderFriendList();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function renderFriendList():void
        {
            var _local_3:OutfitManager;
            var _local_1:MovieClip = this.panelMC.friendListMC;
            _local_1.visible = true;
            _local_1.overlay.visible = false;
            _local_1.txt_total_friend.text = ((("Friend(s) : " + this.totalFriend) + "/") + this.limitFriend);
            _local_1.allowMC.tick.visible = this.isRecruitable;
            _local_1.txt_page.text = ((this.currentPage + "/") + this.totalPage);
            if (!this.selectMode)
            {
                _local_1.btn_cancel.visible = false;
                _local_1.btn_unfriendAll.visible = false;
                _local_1.btn_unfriendSelected.visible = false;
                _local_1.tick.visible = false;
                _local_1.btn_unfriend.visible = true;
                _local_1.btn_AddFriend.visible = true;
                _local_1.btn_removeRecruit.visible = true;
            }
            else
            {
                _local_1.btn_cancel.visible = true;
                _local_1.btn_unfriendAll.visible = true;
                _local_1.btn_unfriendSelected.visible = true;
                _local_1.tick.visible = true;
                _local_1.tick.tick.visible = this.checkIfCurrentPageIsAllSelected();
                _local_1.btn_unfriend.visible = false;
                _local_1.btn_AddFriend.visible = false;
                _local_1.btn_removeRecruit.visible = false;
            };
            var _local_2:int;
            while (_local_2 < 8)
            {
                _local_1[("friend_" + _local_2)].visible = false;
                if (this.friendData[_local_2])
                {
                    _local_1[("friend_" + _local_2)].visible = true;
                    _local_3 = new OutfitManager();
                    this.outfits.push(_local_3);
                    _local_3.fillHead(_local_1[("friend_" + _local_2)].holder, this.friendData[_local_2].sets.hairstyle, this.friendData[_local_2].sets.face, this.friendData[_local_2].sets.hair_color, this.friendData[_local_2].sets.skin_color);
                    if (!this.selectMode)
                    {
                        _local_1[("friend_" + _local_2)].tick.visible = false;
                        _local_1[("friend_" + _local_2)].btn_recruit.visible = true;
                        _local_1[("friend_" + _local_2)].btn_option.visible = true;
                    }
                    else
                    {
                        _local_1[("friend_" + _local_2)].btn_recruit.visible = false;
                        _local_1[("friend_" + _local_2)].btn_option.visible = false;
                        _local_1[("friend_" + _local_2)].tick.visible = true;
                        _local_1[("friend_" + _local_2)].tick.tick.visible = (!(this.selectedIdArray.indexOf(this.friendData[_local_2].id) == -1));
                        this.eventHandler.addListener(_local_1[("friend_" + _local_2)].tick, MouseEvent.CLICK, this.handleTickUnfriend);
                    };
                    _local_1[("friend_" + _local_2)].optionMC.visible = false;
                    _local_1[("friend_" + _local_2)].txt_name.htmlText = Character.colorifyText(this.friendData[_local_2].id, this.friendData[_local_2].char.name);
                    this.changeBorderColor(_local_1[("friend_" + _local_2)], this.friendData[_local_2].id);
                    _local_1[("friend_" + _local_2)].txt_lvl.htmlText = ("Lv. " + this.friendData[_local_2].char.level);
                    _local_1[("friend_" + _local_2)].rankMC.gotoAndStop(this.friendData[_local_2].char.rank);
                    _local_1[("friend_" + _local_2)].emblemMC.gotoAndStop((int(this.friendData[_local_2].account_type) + 1));
                    _local_1[("friend_" + _local_2)].btn_option.metaData = {"data":this.friendData[_local_2]};
                    _local_1[("friend_" + _local_2)].btn_recruit.metaData = {"data":this.friendData[_local_2]};
                    this.eventHandler.addListener(_local_1[("friend_" + _local_2)].btn_recruit, MouseEvent.CLICK, this.handleRecruit);
                    this.eventHandler.addListener(_local_1[("friend_" + _local_2)].btn_option, MouseEvent.CLICK, this.openFriendOption);
                };
                _local_2++;
            };
        }

        private function openFriendOption(_arg_1:MouseEvent):void
        {
            this.selectedFriendId = _arg_1.currentTarget.metaData.data.id;
            this.selectedFriendIndex = _arg_1.currentTarget.parent.name.replace("friend_", "");
            var _local_2:MovieClip = this.panelMC.friendListMC;
            _local_2.overlay.visible = true;
            _local_2[("friend_" + this.selectedFriendIndex)].optionMC.visible = true;
            this.originalOverlayIndex = _local_2[("friend_" + this.selectedFriendIndex)].parent.getChildIndex(_local_2[("friend_" + this.selectedFriendIndex)]);
            _local_2.overlay.parent.setChildIndex(_local_2[("friend_" + this.selectedFriendIndex)], (_local_2.overlay.parent.numChildren - 1));
            this.eventHandler.addListener(_local_2.overlay, MouseEvent.CLICK, this.closeFriendOption);
            _local_2[("friend_" + this.selectedFriendIndex)].optionMC.btn_favorite.visible = (this.currentTab == "allfriend");
            _local_2[("friend_" + this.selectedFriendIndex)].optionMC.btn_unfavorite.visible = (this.currentTab == "favorite");
            this.eventHandler.addListener(_local_2[("friend_" + this.selectedFriendIndex)].optionMC.btn_profile, MouseEvent.CLICK, this.openFriendProfile);
            this.eventHandler.addListener(_local_2[("friend_" + this.selectedFriendIndex)].optionMC.btn_favorite, MouseEvent.CLICK, this.setFavorite);
            this.eventHandler.addListener(_local_2[("friend_" + this.selectedFriendIndex)].optionMC.btn_unfavorite, MouseEvent.CLICK, this.removeFavorite);
            this.eventHandler.addListener(_local_2[("friend_" + this.selectedFriendIndex)].optionMC.btn_battle, MouseEvent.CLICK, this.startFriendBerantem);
            this.eventHandler.addListener(_local_2[("friend_" + this.selectedFriendIndex)].optionMC.btn_unfriend, MouseEvent.CLICK, this.unfriendCharacter);
        }

        private function openFriendProfile(_arg_1:MouseEvent):void
        {
            if (((this.currentTab == "request") || (this.currentTab == "recommendation")))
            {
                this.selectedFriendId = _arg_1.currentTarget.metaData.data.id;
            };
            var _local_2:Class = (getDefinitionByName("Panels.UI_Friend_Profile") as Class);
            var _local_3:Boolean = (((this.currentTab == "allfriend") || (this.currentTab == "favorite")) ? false : true);
            _local_3 = ((_arg_1.currentTarget.parent.name == "addFriendMC") ? true : _local_3);
            var _local_4:MovieClip = new _local_2(this.main, this.selectedFriendId, _local_3);
            this.main.loader.addChild(_local_4);
        }

        private function startFriendBerantem(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            if (int(Character.character_lvl) < 10)
            {
                this.main.showMessage("You must be at least Lv. 10 to Challenge your friend");
            }
            else
            {
                this.main.loading(true);
                _local_2 = CUCSG.hash(((Character.char_id + this.selectedFriendId.toString()) + Character.sessionkey));
                this.main.amf_manager.service("FriendService.startBerantem", [Character.char_id, this.selectedFriendId.toString(), _local_2, Character.sessionkey], this.startFriendBerantemRes);
            };
        }

        private function startFriendBerantemRes(_arg_1:Object):void
        {
            var _local_2:Object;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.is_friend_berantem = true;
                Character.battle_code = _arg_1.battle_code;
                Character.mission_id = "temen_berantem";
                _local_2 = MissionLibrary.getMissionInfo(Character.mission_id);
                this.main.combat = this.main.loadPanel("Combat.Battle", true);
                BattleManager.init(this.main.combat, this.main, BattleVars.FRIENDLY_MATCH, _local_2.msn_bg);
                BattleManager.addPlayerToTeam("player", ("char_" + Character.char_id));
                BattleManager.addPlayerToTeam("enemy", ("char_" + _arg_1.friend_id));
                BattleManager.startBattle();
                this.closePanel(null);
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function setFavorite(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.setFavorite", [Character.char_id, Character.sessionkey, this.selectedFriendId], this.setFavoriteResponse);
        }

        private function setFavoriteResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function removeFavorite(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.removeFavorite", [Character.char_id, Character.sessionkey, this.selectedFriendId], this.removeFavoriteResponse);
        }

        private function removeFavoriteResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                this.getFriendFavorite();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function unfriendCharacter(_arg_1:MouseEvent):void
        {
            var _local_2:* = ((_arg_1.currentTarget.name == "btn_unfriendSelected") ? this.selectedIdArray : this.selectedFriendId);
            if (((_local_2 is Array) && (_local_2.length == 0)))
            {
                this.main.showMessage("Please select at least one friend to unfriend");
                return;
            };
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.removeFriend", [Character.char_id, Character.sessionkey, _local_2], this.unfriendCharacterResponse);
        }

        private function unfriendCharacterResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                if ((this.currentTab == "allfriend"))
                {
                    this.getFriendList();
                }
                else
                {
                    this.getFriendFavorite();
                };
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function closeFriendOption(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = this.panelMC.friendListMC;
            _local_2.overlay.visible = false;
            _local_2[("friend_" + this.selectedFriendIndex)].optionMC.visible = false;
            _local_2[("friend_" + this.selectedFriendIndex)].parent.setChildIndex(_local_2[("friend_" + this.selectedFriendIndex)], this.originalOverlayIndex);
        }

        private function onSearch(_arg_1:MouseEvent):void
        {
            var _local_2:* = this.panelMC.friendListMC.searchTxt.text;
            if (((!(_local_2 == null)) && (!(_local_2 == ""))))
            {
                this.handleSearchAmf();
            }
            else
            {
                this.main.showMessage("Type Friend ID or Name!");
            };
        }

        private function handleSearchAmf():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.search", [Character.char_id, Character.sessionkey, this.panelMC.friendListMC.searchTxt.text], this.friendListResponse);
        }

        private function onSearchClear(_arg_1:MouseEvent):void
        {
            if ((this.currentTab == "allfriend"))
            {
                this.getFriendList();
            }
            else
            {
                this.getFriendFavorite();
            };
            this.panelMC.friendListMC.searchTxt.text = "";
        }

        private function handleAllowRecruit(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.recruitable", [Character.char_id, Character.sessionkey], this.allowRecruitRes);
        }

        private function allowRecruitRes(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.panelMC.friendListMC.allowMC.tick.visible = _arg_1.recruitable;
                this.isRecruitable = _arg_1.recruitable;
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function handleRecruit(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.recruitFriend", [Character.char_id, Character.sessionkey, _arg_1.currentTarget.metaData.data.id], this.recruitResponse);
        }

        private function recruitResponse(_arg_1:Object):void
        {
            var _local_2:String;
            var _local_3:String;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                _local_2 = _arg_1.recruiters[1];
                _local_3 = CUCSG.hash(_arg_1.recruiters[0][0]);
                if (_local_2 == _local_3)
                {
                    Character.character_recruit_ids = _arg_1.recruiters[0];
                    this.main.showMessage("Friend Recruited");
                    this.checkRecruited();
                    this.main.HUD.setBasicData();
                }
                else
                {
                    this.main.getError(204);
                };
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function checkRecruited():void
        {
            if (Character.character_recruit_ids.length == 0)
            {
                this.panelMC.friendListMC.btn_removeRecruit.visible = false;
            }
            else
            {
                this.panelMC.friendListMC.btn_removeRecruit.visible = true;
            };
        }

        private function removeRecruitedSquad(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.removeRecruitments", [Character.char_id, Character.sessionkey], this.removeRecruitedSquadRes);
        }

        private function removeRecruitedSquadRes(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                Character.character_recruit_ids = [];
                this.main.HUD.setBasicData();
                this.checkRecruited();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function friendRecommendationResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.friendRequestData = _arg_1.recommendations;
                this.currentPage = _arg_1.page.current;
                this.totalPage = _arg_1.page.total;
                this.renderFriendRecommendationList();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function friendRequestResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.friendRequestData = _arg_1.invitations;
                this.currentPage = _arg_1.page.current;
                this.totalPage = _arg_1.page.total;
                this.totalFriendRequest = _arg_1.total;
                this.renderFriendRequestList();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function handleUnfriend(_arg_1:MouseEvent):void
        {
            this.selectMode = true;
            var _local_2:MovieClip = this.panelMC.friendListMC;
            _local_2.tick.visible = false;
            this.eventHandler.addListener(_local_2.btn_unfriendSelected, MouseEvent.CLICK, this.unfriendCharacter);
            this.eventHandler.addListener(_local_2.btn_unfriendAll, MouseEvent.CLICK, this.unfriendAllConfirmation);
            this.eventHandler.addListener(_local_2.btn_cancel, MouseEvent.CLICK, this.cancelUnfriend);
            this.eventHandler.addListener(_local_2.tick, MouseEvent.CLICK, this.selectAllListUnfriend);
            if ((this.currentTab == "allfriend"))
            {
                this.getFriendList();
            }
            else
            {
                this.getFriendFavorite();
            };
        }

        private function cancelUnfriend(_arg_1:MouseEvent):void
        {
            this.selectMode = false;
            this.selectedIdArray = [];
            if ((this.currentTab == "allfriend"))
            {
                this.getFriendList();
            }
            else
            {
                this.getFriendFavorite();
            };
        }

        private function handleTickUnfriend(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = this.panelMC.friendListMC;
            var _local_3:int = _arg_1.currentTarget.parent.name.replace("friend_", "");
            _local_2[("friend_" + _local_3)].tick.tick.visible = (!(_local_2[("friend_" + _local_3)].tick.tick.visible));
            if (_local_2[("friend_" + _local_3)].tick.tick.visible)
            {
                this.selectedIdArray.push(this.friendData[_local_3].id);
            }
            else
            {
                this.selectedIdArray.splice(this.selectedIdArray.indexOf(this.friendData[_local_3].id), 1);
            };
            _local_2.tick.tick.visible = this.checkIfCurrentPageIsAllSelected();
        }

        private function selectAllListUnfriend(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = this.panelMC.friendListMC;
            var _local_3:int;
            while (_local_3 < 8)
            {
                if ((((!(_local_2.tick.tick.visible)) && (this.friendData[_local_3])) && (this.selectedIdArray.indexOf(this.friendData[_local_3].id) == -1)))
                {
                    _local_2[("friend_" + _local_3)].tick.tick.visible = true;
                    this.selectedIdArray.push(this.friendData[_local_3].id);
                };
                if ((((_local_2.tick.tick.visible) && (this.friendData[_local_3])) && (!(this.selectedIdArray.indexOf(this.friendData[_local_3].id) == -1))))
                {
                    _local_2[("friend_" + _local_3)].tick.tick.visible = false;
                    this.selectedIdArray.splice(this.selectedIdArray.indexOf(this.friendData[_local_3].id), 1);
                };
                _local_3++;
            };
            _local_2.tick.tick.visible = this.checkIfCurrentPageIsAllSelected();
        }

        private function checkIfCurrentPageIsAllSelected():Boolean
        {
            var _local_1:int;
            while (_local_1 < 8)
            {
                if (((this.friendData[_local_1]) && (this.selectedIdArray.indexOf(this.friendData[_local_1].id) == -1)))
                {
                    return (false);
                };
                _local_1++;
            };
            return (true);
        }

        private function unfriendAllConfirmation(_arg_1:MouseEvent):void
        {
            this.panelMC.friendListMC.confirmationMc.visible = true;
            this.panelMC.friendListMC.confirmationMc.btn_confirm.addEventListener(MouseEvent.CLICK, this.unfriendAll);
            this.panelMC.friendListMC.confirmationMc.btn_close.addEventListener(MouseEvent.CLICK, this.closeUnfriendAll);
        }

        private function closeUnfriendAll(_arg_1:MouseEvent=null):void
        {
            this.panelMC.friendListMC.confirmationMc.visible = false;
            this.panelMC.friendListMC.confirmationMc.txt_reset.text = "";
        }

        private function unfriendAll(_arg_1:MouseEvent):void
        {
            if (this.panelMC.friendListMC.confirmationMc.txt_reset.text != "UNFRIEND ALL")
            {
                this.main.getNotice("Wrong Input! Must Type UNFRIEND ALL in Uppercase");
                return;
            };
            this.closeUnfriendAll();
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.unfriendAll", [Character.char_id, Character.sessionkey], this.onUnfriendAll);
        }

        private function onUnfriendAll(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                if ((this.currentTab == "allfriend"))
                {
                    this.getFriendList();
                }
                else
                {
                    this.getFriendFavorite();
                };
                this.main.showMessage(_arg_1.result);
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function renderFriendRequestList():void
        {
            var _local_3:OutfitManager;
            var _local_1:MovieClip = this.panelMC.friendRequestMC;
            _local_1.visible = true;
            _local_1.txt_total_request.text = ("Request(s) : " + this.totalFriendRequest);
            _local_1.txt_page.text = ((this.currentPage + "/") + this.totalPage);
            _local_1.btn_select.visible = false;
            _local_1.tick.visible = false;
            var _local_2:int;
            while (_local_2 < 4)
            {
                _local_1[("request_" + _local_2)].visible = false;
                if (this.friendRequestData[_local_2])
                {
                    _local_1[("request_" + _local_2)].visible = true;
                    _local_3 = new OutfitManager();
                    this.outfits.push(_local_3);
                    _local_3.fillHead(_local_1[("request_" + _local_2)].holder, this.friendRequestData[_local_2].sets.hairstyle, this.friendRequestData[_local_2].sets.face, this.friendRequestData[_local_2].sets.hair_color, this.friendRequestData[_local_2].sets.skin_color);
                    _local_1[("request_" + _local_2)].tick.visible = false;
                    _local_1[("request_" + _local_2)].txt_name.htmlText = Character.colorifyText(this.friendRequestData[_local_2].id, this.friendRequestData[_local_2].char.name);
                    _local_1[("request_" + _local_2)].txt_lvl.htmlText = ("Lv. " + this.friendRequestData[_local_2].char.level);
                    _local_1[("request_" + _local_2)].rankMC.gotoAndStop(this.friendRequestData[_local_2].char.rank);
                    _local_1[("request_" + _local_2)].emblemMC.gotoAndStop((int(this.friendRequestData[_local_2].account_type) + 1));
                    _local_1[("request_" + _local_2)].btn_accept.metaData = {"data":this.friendRequestData[_local_2]};
                    _local_1[("request_" + _local_2)].btn_reject.metaData = {"data":this.friendRequestData[_local_2]};
                    _local_1[("request_" + _local_2)].btn_profile.metaData = {"data":this.friendRequestData[_local_2]};
                    this.eventHandler.addListener(_local_1[("request_" + _local_2)].btn_accept, MouseEvent.CLICK, this.handleAcceptRejectFriendRequest);
                    this.eventHandler.addListener(_local_1[("request_" + _local_2)].btn_reject, MouseEvent.CLICK, this.handleAcceptRejectFriendRequest);
                    this.eventHandler.addListener(_local_1[("request_" + _local_2)].btn_profile, MouseEvent.CLICK, this.openFriendProfile);
                };
                _local_2++;
            };
        }

        private function handleAcceptRejectFriendRequest(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.acceptRejectButton = _arg_1.currentTarget.name;
            if (this.acceptRejectButton == "btn_accept")
            {
                this.main.amf_manager.service("FriendService.acceptFriend", [Character.char_id, Character.sessionkey, _arg_1.currentTarget.metaData.data.id], this.acceptRejectResponse);
            }
            else
            {
                if (this.acceptRejectButton == "btn_reject")
                {
                    this.main.amf_manager.service("FriendService.removeFriend", [Character.char_id, Character.sessionkey, _arg_1.currentTarget.metaData.data.id], this.acceptRejectResponse);
                }
                else
                {
                    if (this.acceptRejectButton == "btn_acceptAll")
                    {
                        this.main.amf_manager.service("FriendService.acceptAll", [Character.char_id, Character.sessionkey], this.acceptRejectResponse);
                    }
                    else
                    {
                        if (this.acceptRejectButton == "btn_rejectAll")
                        {
                            this.main.amf_manager.service("FriendService.removeAll", [Character.char_id, Character.sessionkey], this.acceptRejectResponse);
                        };
                    };
                };
            };
        }

        private function acceptRejectResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                if (((this.acceptRejectButton == "btn_acceptAll") || (this.acceptRejectButton == "btn_rejectAll")))
                {
                    this.currentPage = 1;
                };
                this.getFriendRequest();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function renderFriendRecommendationList():void
        {
            var _local_3:OutfitManager;
            var _local_1:MovieClip = this.panelMC.friendRecommendationMC;
            _local_1.visible = true;
            _local_1.txt_page.text = ((this.currentPage + "/") + this.totalPage);
            var _local_2:int;
            while (_local_2 < 5)
            {
                _local_1[("recommend_" + _local_2)].visible = false;
                if (this.friendRequestData[_local_2])
                {
                    _local_1[("recommend_" + _local_2)].visible = true;
                    _local_3 = new OutfitManager();
                    this.outfits.push(_local_3);
                    _local_3.fillHead(_local_1[("recommend_" + _local_2)].holder, this.friendRequestData[_local_2].sets.hairstyle, this.friendRequestData[_local_2].sets.face, this.friendRequestData[_local_2].sets.hair_color, this.friendRequestData[_local_2].sets.skin_color);
                    _local_1[("recommend_" + _local_2)].txt_name.htmlText = Character.colorifyText(this.friendRequestData[_local_2].id, this.friendRequestData[_local_2].char.name);
                    _local_1[("recommend_" + _local_2)].txt_lvl.htmlText = ("Lv. " + this.friendRequestData[_local_2].char.level);
                    _local_1[("recommend_" + _local_2)].rankMC.gotoAndStop(this.friendRequestData[_local_2].char.rank);
                    _local_1[("recommend_" + _local_2)].emblemMC.gotoAndStop((int(this.friendRequestData[_local_2].account_type) + 1));
                    _local_1[("recommend_" + _local_2)].btn_addFriend.metaData = {"data":this.friendRequestData[_local_2]};
                    _local_1[("recommend_" + _local_2)].btn_profile.metaData = {"data":this.friendRequestData[_local_2]};
                    this.eventHandler.addListener(_local_1[("recommend_" + _local_2)].btn_addFriend, MouseEvent.CLICK, this.handleAddFriendSend);
                    this.eventHandler.addListener(_local_1[("recommend_" + _local_2)].btn_profile, MouseEvent.CLICK, this.openFriendProfile);
                };
                _local_2++;
            };
        }

        private function handleAddFriend(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = this.panelMC.addFriendMC;
            _local_2.visible = true;
            _local_2.btn_profile.visible = false;
            _local_2.btn_addFriend.visible = false;
            _local_2.contentMC.visible = false;
            this.eventHandler.addListener(_local_2.btn_close, MouseEvent.CLICK, this.closeAddFriend);
            this.eventHandler.addListener(_local_2.btn_search, MouseEvent.CLICK, this.handleAddFriendSearch);
            this.eventHandler.addListener(_local_2.btn_profile, MouseEvent.CLICK, this.openFriendProfile);
            this.eventHandler.addListener(_local_2.btn_addFriend, MouseEvent.CLICK, this.handleAddFriendSend);
            this.eventHandler.addListener(_local_2.clearSearch, MouseEvent.CLICK, this.handleAddFriendSearchClear);
        }

        private function handleAddFriendSearch(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.getInfo", [Character.char_id, Character.sessionkey, this.panelMC.addFriendMC.search.text], this.searchAddFriendResponse);
        }

        private function searchAddFriendResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.addFriendData = _arg_1;
                this.panelMC.addFriendMC.btn_profile.visible = true;
                this.panelMC.addFriendMC.btn_addFriend.visible = true;
                this.selectedFriendId = this.panelMC.addFriendMC.search.text;
                this.renderAddFriend();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function renderAddFriend():void
        {
            var _local_6:int;
            var _local_1:MovieClip = this.panelMC.addFriendMC;
            _local_1.contentMC.visible = true;
            var _local_2:OutfitManager = new OutfitManager();
            this.outfits.push(_local_2);
            _local_2.fillHead(_local_1.contentMC.holder, this.addFriendData.character_sets.hairstyle, this.addFriendData.character_sets.face, this.addFriendData.character_sets.hair_color, this.addFriendData.character_sets.skin_color);
            _local_1.contentMC.txt_name.htmlText = Character.colorifyText(this.addFriendData.character_data.character_id, this.addFriendData.character_data.character_name);
            _local_1.contentMC.txt_lvl.htmlText = ("Lv. " + this.addFriendData.character_data.character_level);
            _local_1.contentMC.rankMC.gotoAndStop(this.addFriendData.character_data.character_rank);
            _local_1.contentMC.emblemMC.gotoAndStop((int(this.addFriendData.account_type) + 1));
            _local_1.contentMC.element_1.gotoAndStop((int(this.addFriendData.character_data.character_element_1) + 1));
            _local_1.contentMC.element_2.gotoAndStop((int(this.addFriendData.character_data.character_element_2) + 1));
            if (((this.addFriendData.character_data.character_element_3 == 0) || (this.addFriendData.account_type == 0)))
            {
                _local_1.contentMC.element_3.gotoAndStop(1);
            }
            else
            {
                _local_1.contentMC.element_3.gotoAndStop((int(this.addFriendData.character_data.character_element_3) + 1));
            };
            var _local_3:int = 1;
            while (_local_3 < 4)
            {
                if (this.addFriendData.character_data[("character_talent_" + _local_3)] == null)
                {
                    _local_6 = ((_local_3 == 1) ? 3 : 4);
                    _local_1.contentMC[("talent_" + _local_3)].gotoAndStop(_local_6);
                }
                else
                {
                    _local_1.contentMC[("talent_" + _local_3)].gotoAndStop(this.addFriendData.character_data[("character_talent_" + _local_3)]);
                };
                _local_3++;
            };
            var _local_4:String = ((this.addFriendData.character_data.character_senjutsu) ? this.addFriendData.character_data.character_senjutsu : "learnSenjutsu");
            _local_1.contentMC.senjutsuMC.gotoAndStop(_local_4);
            var _local_5:String = ((this.addFriendData.character_data.character_class) ? this.addFriendData.character_data.character_class : "classNull");
            _local_1.contentMC.classMC.gotoAndStop(_local_5);
            GF.removeAllChild(_local_1.contentMC.petMC.holder);
            if ((("pet_swf" in this.addFriendData.pet_data) && (!(this.addFriendData.pet_data.pet_swf == null))))
            {
                NinjaSage.loadIconSWF("pets", this.addFriendData.pet_data.pet_swf, _local_1.contentMC.petMC.holder, "PetStaticFullBody");
                _local_1.contentMC.petMC.holder.scaleX = 0.8;
                _local_1.contentMC.petMC.holder.scaleY = 0.8;
            };
            GF.removeAllChild(this.panelMC.addFriendMC.contentMC.clanLogoHolder);
            if (this.addFriendData.clan != null)
            {
                if (this.addFriendData.clan.banner != null)
                {
                    this.loaderSwf.removeAll();
                    this.loaderSwf.add(this.addFriendData.clan.banner, {"id":"clanBanner"});
                    this.loaderSwf.addEventListener(BulkLoader.COMPLETE, this.onClanLogoLoaded);
                    this.loaderSwf.start();
                };
            };
        }

        private function onClanLogoLoaded(_arg_1:Event):void
        {
            this.loaderSwf.removeEventListener(BulkLoader.COMPLETE, this.onClanLogoLoaded);
            GF.removeAllChild(this.panelMC.addFriendMC.contentMC.clanLogoHolder);
            this.panelMC.addFriendMC.contentMC.clanLogoHolder.addChild(this.loaderSwf.getContent("clanBanner", true));
            NinjaSage.showDynamicTooltip(this.panelMC.addFriendMC.contentMC.clanLogoHolder, ((("[" + this.addFriendData.clan.id) + "] ") + this.addFriendData.clan.name));
            this.panelMC.addFriendMC.contentMC.clanLogoHolder.scaleX = 0.5;
            this.panelMC.addFriendMC.contentMC.clanLogoHolder.scaleY = 0.5;
        }

        private function handleAddFriendSend(_arg_1:MouseEvent):void
        {
            this.selectedFriendId = ((this.currentTab == "recommendation") ? _arg_1.currentTarget.metaData.data.id : this.selectedFriendId);
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.addFriend", [Character.char_id, Character.sessionkey, this.selectedFriendId], this.addFriendResponse);
        }

        private function addFriendResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function handleAddFriendSearchClear(_arg_1:MouseEvent):void
        {
            this.panelMC.addFriendMC.search.text = "";
        }

        private function closeAddFriend(_arg_1:MouseEvent):void
        {
            this.panelMC.addFriendMC.visible = false;
            this.panelMC.addFriendMC.search.text = "";
        }

        private function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                    };
                    break;
                case "btn_prev":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                    };
            };
            switch (this.currentTab)
            {
                case "allfriend":
                    this.getFriendList();
                    return;
                case "favorite":
                    this.getFriendFavorite();
                    return;
                case "request":
                    this.getFriendRequest();
                    return;
                case "recommendation":
                    this.getFriendRecommendation();
                    return;
            };
        }

        private function hideTabContent():void
        {
            this.panelMC.addFriendMC.visible = false;
            this.panelMC.friendRecommendationMC.visible = false;
            this.panelMC.friendRequestMC.visible = false;
            this.panelMC.friendListMC.visible = false;
            this.panelMC.friendListMC.overlay.visible = false;
            this.panelMC.friendListMC.confirmationMc.visible = false;
        }

        private function changeTab(_arg_1:MouseEvent):void
        {
            this.currentPage = 1;
            this.resetSelectedTab();
            this.hideTabContent();
            _arg_1.currentTarget.gotoAndStop(3);
            switch (_arg_1.currentTarget.name)
            {
                case "btn_allfriend":
                    this.currentTab = "allfriend";
                    this.getFriendList();
                    return;
                case "btn_favorite":
                    this.currentTab = "favorite";
                    this.getFriendFavorite();
                    return;
                case "btn_request":
                    this.currentTab = "request";
                    this.getFriendRequest();
                    return;
                case "btn_recommendation":
                    this.currentTab = "recommendation";
                    this.getFriendRecommendation();
                    return;
            };
        }

        private function over(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        private function out(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
        }

        private function resetSelectedTab():void
        {
            var _local_1:int;
            while (_local_1 < this.tabArray.length)
            {
                this.panelMC[("btn_" + this.tabArray[_local_1])].gotoAndStop(1);
                _local_1++;
            };
        }

        private function changeBorderColor(_arg_1:MovieClip, _arg_2:int):void
        {
            var _local_4:ColorTransform;
            var _local_3:uint = this.getCharacterColor(_arg_2);
            this.removeGradient(_arg_1.bg);
            if (_local_3 != 0)
            {
                _local_4 = new ColorTransform();
                _local_4.color = _local_3;
                _arg_1.border.transform.colorTransform = _local_4;
                this.applyGradient(_arg_1.bg, [_local_3, _local_3], [0, 0.4], [0, 0xFF]);
            }
            else
            {
                _arg_1.border.transform.colorTransform = new ColorTransform();
            };
        }

        private function getCharacterColor(_arg_1:int):uint
        {
            return ((Character.rgb_data[_arg_1]) ? uint(("0x" + Character.rgb_data[_arg_1].substr(1))) : 0);
        }

        private function applyGradient(_arg_1:MovieClip, _arg_2:Array, _arg_3:Array, _arg_4:Array):void
        {
            var _local_5:* = _arg_1.parent;
            var _local_6:Object = _arg_1.getBounds(_arg_1.parent);
            var _local_7:Matrix = new Matrix();
            _local_7.createGradientBox(_local_6.width, _local_6.height, 0, _local_6.x, _local_6.y);
            var _local_8:Sprite = new Sprite();
            _local_8.name = (_arg_1.parent.name + "_gradient");
            _local_8.graphics.beginGradientFill(GradientType.LINEAR, _arg_2, _arg_3, _arg_4, _local_7);
            _local_8.graphics.drawRect(_local_6.x, _local_6.y, _local_6.width, _local_6.height);
            _local_8.graphics.endFill();
            var _local_9:int = _local_5.getChildIndex(_arg_1);
            _local_5.addChildAt(_local_8, (_local_9 + 1));
            _local_8.mask = _arg_1;
        }

        private function removeGradient(_arg_1:MovieClip):void
        {
            if (_arg_1.parent.getChildByName((_arg_1.parent.name + "_gradient")) != null)
            {
                _arg_1.parent.removeChild(_arg_1.parent.getChildByName((_arg_1.parent.name + "_gradient")));
            };
        }

        private function openFriendshipShop(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Friendship_Shop");
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():*
        {
            GF.destroyArray(this.outfits);
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.main = null;
            this.outfits = null;
            this.friendData = null;
            this.friendRequestData = null;
            this.friendRecommendationData = null;
            this.tabArray = null;
            this.currentTab = null;
            this.acceptRejectButton = null;
            this.selectedIdArray = null;
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
            this.loaderSwf.clear();
            this.loaderSwf = null;
            this.addFriendData = null;
        }


    }
}//package id.ninjasage.features

