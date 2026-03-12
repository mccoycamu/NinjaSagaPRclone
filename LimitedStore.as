// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.LimitedStore

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import Popups.Confirmation;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Storage.SkillLibrary;
    import Managers.NinjaSage;
    import com.utils.GF;
    import flash.utils.setTimeout;
    import flash.utils.clearTimeout;
    import flash.system.System;

    public dynamic class LimitedStore extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var rewardsArray:Array;
        private var skillList:Array;
        private var priceArray:Array;
        private var priceArray0:Array;
        private var priceArray1:Array;
        private var priceArray2:Array;
        private var priceArray3:Array;
        private var typeMC:MovieClip;
        private var target:int;
        private var target2:int;
        private var currentPage:int = 1;
        private var totalPage:int = 1;
        private var confirmation:Confirmation;
        private var selected_skill_id:String;
        private var price:int;
        private var limitedstore_timestamp:* = null;
        private var discount:String;
        private var eventHandler:EventHandler;
        private var timeout:*;
        private var refreshCost:int;
        private var refreshCount:int;

        public function LimitedStore(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.panelMC.panel.listMC.visible = false;
            this.loadAmf();
        }

        private function loadAmf():*
        {
            this.rewardsArray = [];
            this.priceArray0 = [];
            this.priceArray1 = [];
            this.priceArray2 = [];
            this.priceArray3 = [];
            this.skillList = [];
            this.refreshCost = 0;
            this.refreshCount = 0;
            this.main.loading(true);
            this.main.amf_manager.service("MysteriousMarket.getPackageData", [Character.char_id, Character.sessionkey], this.eventDataResponse);
        }

        private function eventDataResponse(_arg_1:Object):*
        {
            var _local_2:*;
            var _local_3:*;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.limitedstore_timestamp = _arg_1.end_time;
                this.discount = _arg_1.discounts;
                this.refreshCost = _arg_1.refresh_cost;
                this.refreshCount = _arg_1.refresh_count;
                _local_2 = 0;
                for each (_local_3 in _arg_1.items)
                {
                    this.rewardsArray.push(_local_3.code);
                    this[("priceArray" + _local_2)] = _local_3.prices;
                    _local_2++;
                };
                this.onShow();
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

        private function onShow():*
        {
            this.eventHandler.addListener(this.panelMC.panel.closeBtn, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.panel.btn_skill_list, MouseEvent.CLICK, this.openSkillList);
            this.eventHandler.addListener(this.panelMC.panel.btn_refresh, MouseEvent.CLICK, this.refreshConfirmation);
            this.panelMC.panel.leftone.visible = false;
            this.panelMC.panel.twoboxupdateleft.visible = false;
            this.panelMC.panel.threeboxupdateleft.visible = false;
            this.panelMC.panel.fourboxupdateleft.visible = false;
            if (this.rewardsArray.length == 1)
            {
                this.panelMC.panel.leftone.visible = true;
                this.typeMC = this.panelMC.panel.leftone;
            }
            else
            {
                if (this.rewardsArray.length == 2)
                {
                    this.panelMC.panel.twoboxupdateleft.visible = true;
                    this.typeMC = this.panelMC.panel.twoboxupdateleft;
                }
                else
                {
                    if (this.rewardsArray.length == 3)
                    {
                        this.panelMC.panel.threeboxupdateleft.visible = true;
                        this.typeMC = this.panelMC.panel.threeboxupdateleft;
                    }
                    else
                    {
                        if (this.rewardsArray.length == 4)
                        {
                            this.panelMC.panel.fourboxupdateleft.visible = true;
                            this.typeMC = this.panelMC.panel.fourboxupdateleft;
                        };
                    };
                };
            };
            this.panelMC.panel.notopen.visible = false;
            this.panelMC.panel.noneTxt.visible = false;
            this.panelMC.panel.bgnotopen.visible = false;
            this.showRewards();
            this.updateTimeleft();
            if (this.rewardsArray.length < 1)
            {
                this.panelMC.panel.notopen.visible = true;
                this.panelMC.panel.noneTxt.visible = true;
                this.panelMC.panel.bgnotopen.visible = true;
                this.panelMC.panel.noneTxt.text = "Mysterious Market is currently closed, please come back later.";
            };
            this.panelMC.panel.txt_refresh_count.text = ("Refresh x" + String(this.refreshCount));
        }

        private function showRewards():*
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            var _local_5:*;
            this.panelMC.panel.tokenTxt.text = String(Character.account_tokens);
            this.panelMC.panel.emblemleftTxt.text = (("Emblem " + String(this.discount)) + "% OFF");
            this.main.initButton(this.panelMC.panel.getMoreBtn, this.openRecharge, "");
            var _local_1:* = 0;
            while (_local_1 < this.rewardsArray.length)
            {
                _local_2 = this.rewardsArray[_local_1];
                _local_3 = _local_2.split("_");
                if (_local_3[0] != "skill")
                {
                    _local_5 = this.typeMC[("Item_" + _local_1)].Icon_0.rewardIcon.iconHolder;
                    this.typeMC[("Item_" + _local_1)].Icon_0.skillIcon.visible = false;
                    this.typeMC[("Item_" + _local_1)].Icon_0.rewardIcon.colorType.gotoAndStop("special");
                }
                else
                {
                    this.typeMC[("Item_" + _local_1)].Icon_0.rewardIcon.visible = false;
                    this.typeMC[("Item_" + _local_1)].Icon_0.skillIcon.gotoAndStop("enable");
                    _local_5 = this.typeMC[("Item_" + _local_1)].Icon_0.skillIcon.iconHolder;
                };
                _local_4 = SkillLibrary.getSkillInfo(_local_2);
                this.typeMC[("Item_" + _local_1)].skillName.text = _local_4.skill_name;
                this.typeMC[("Item_" + _local_1)].skill["price_1"].text = this[("priceArray" + _local_1)][0];
                this.typeMC[("Item_" + _local_1)].skill["price_2"].text = this[("priceArray" + _local_1)][1];
                this.typeMC[("Item_" + _local_1)].skill["buyBtn_1"].visible = true;
                this.typeMC[("Item_" + _local_1)].skill["buyBtn_2"].visible = true;
                if (((!(_local_1 == 0)) && (!(Character.hasSkill(this.rewardsArray[(_local_1 - 1)])))))
                {
                    this.main.initButtonDisable(this.typeMC[("Item_" + _local_1)].skill["buyBtn_1"].buyBtn_1, this.showConfirmation, "Buy");
                    this.main.initButtonDisable(this.typeMC[("Item_" + _local_1)].skill["buyBtn_2"].buyBtn_1, this.showConfirmation, "Buy");
                }
                else
                {
                    this.main.initButton(this.typeMC[("Item_" + _local_1)].skill["buyBtn_1"].buyBtn_1, this.showConfirmation, "Buy");
                    this.main.initButton(this.typeMC[("Item_" + _local_1)].skill["buyBtn_2"].buyBtn_1, this.showConfirmation, "Buy");
                };
                this.typeMC[("Item_" + _local_1)].tick.visible = false;
                if (this.hasSkill(this.rewardsArray[_local_1]) > 0)
                {
                    this.typeMC[("Item_" + _local_1)].tick.visible = true;
                    this.typeMC[("Item_" + _local_1)].skill["buyBtn_1"].visible = false;
                    this.typeMC[("Item_" + _local_1)].skill["buyBtn_2"].visible = false;
                    this.typeMC[("Item_" + _local_1)].skill.getEmblemBtn.visible = false;
                };
                if (Character.account_type == 1)
                {
                    this.typeMC[("Item_" + _local_1)].skill.getEmblemBtn.visible = false;
                    this.typeMC[("Item_" + _local_1)].skill["buyBtn_1"].visible = false;
                }
                else
                {
                    this.typeMC[("Item_" + _local_1)].skill.getEmblemBtn.visible = true;
                    this.typeMC[("Item_" + _local_1)].skill["buyBtn_2"].visible = false;
                    this.main.initButton(this.typeMC[("Item_" + _local_1)].skill.getEmblemBtn, this.openRecharge, "GET EMBLEM");
                };
                NinjaSage.loadItemIcon(_local_5, _local_2, "icon");
                _local_1++;
            };
        }

        private function showConfirmation(e:MouseEvent):*
        {
            this.target = e.currentTarget.parent.parent.parent.name.replace("Item_", "");
            this.target2 = e.currentTarget.parent.name.replace("buyBtn_", "");
            var itemid:* = this.rewardsArray[this.target];
            var getSkillInfo:* = SkillLibrary.getSkillInfo(itemid);
            this.selected_skill_id = this.rewardsArray[this.target];
            this.confirmation = new Confirmation();
            if (this.target == 0)
            {
                this.price = this[("priceArray" + this.target)][(this.target2 - 1)];
                this.confirmation.txtMc.txt.text = (((("Confirm buying " + getSkillInfo.skill_name) + " for ") + this.price) + " Tokens ?");
            }
            else
            {
                if (this.target == 1)
                {
                    this.price = this[("priceArray" + this.target)][(this.target2 - 1)];
                    this.confirmation.txtMc.txt.text = (((("Confirm buying " + getSkillInfo.skill_name) + " for ") + this.price) + " Tokens ?");
                }
                else
                {
                    if (this.target == 2)
                    {
                        this.price = this[("priceArray" + this.target)][(this.target2 - 1)];
                        this.confirmation.txtMc.txt.text = (((("Confirm buying " + getSkillInfo.skill_name) + " for ") + this.price) + " Tokens ?");
                    }
                    else
                    {
                        if (this.target == 3)
                        {
                            this.price = this[("priceArray" + this.target)][(this.target2 - 1)];
                            this.confirmation.txtMc.txt.text = (((("Confirm buying " + getSkillInfo.skill_name) + " for ") + this.price) + " Tokens ?");
                        };
                    };
                };
            };
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function (_arg_1:MouseEvent):*
            {
                GF.removeAllChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.buyPackage);
            this.panelMC.addChild(this.confirmation);
        }

        private function buyPackage(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
            this.main.amf_manager.service("MysteriousMarket.buyPackage", [Character.char_id, Character.sessionkey, this.selected_skill_id], this.buyPackageResponse);
        }

        private function buyPackageResponse(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                this.main.giveReward(1, this.selected_skill_id);
                Character.updateSkills(this.selected_skill_id, true);
                if (this.target > 0)
                {
                    Character.updateSkills(this.rewardsArray[(this.target - 1)], false);
                };
                Character.account_tokens = (Character.account_tokens - int(this.price));
                this.main.HUD.setBasicData();
                this.showRewards();
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

        private function openSkillList(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("MysteriousMarket.getAllPackagesList", [Character.char_id, Character.sessionkey], this.openSkillListResponse);
        }

        private function openSkillListResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.skillList = _arg_1.packages;
                this.panelMC.panel.listMC.visible = true;
                this.eventHandler.addListener(this.panelMC.panel.listMC.btn_close, MouseEvent.CLICK, this.closeSkillList);
                this.eventHandler.addListener(this.panelMC.panel.listMC.btnPrevPage, MouseEvent.CLICK, this.changePage);
                this.eventHandler.addListener(this.panelMC.panel.listMC.btnNextPage, MouseEvent.CLICK, this.changePage);
                this.panelMC.panel.listMC.txt_title.text = "Limited Store Skills";
                this.panelMC.panel.listMC.txt_ownedSkillTotal.text = (((this.getTotalOwnedSkills() + " / ") + this.skillList.length) + " Skills Owned");
                this.currentPage = 1;
                this.totalPage = Math.max(1, Math.ceil((this.skillList.length / 15)));
                this.updatePageNumber();
                this.showSkillList();
            }
            else
            {
                this.main.showMessage(_arg_1.result);
            };
        }

        private function showSkillList():*
        {
            var _local_2:*;
            var _local_1:int;
            while (_local_1 < 15)
            {
                _local_2 = (_local_1 + int((int((this.currentPage - 1)) * 15)));
                this.panelMC.panel.listMC[("skill_" + _local_1)].visible = false;
                this.panelMC.panel.listMC[("skill_" + _local_1)].amountTxt.text = "";
                this.panelMC.panel.listMC[("skill_" + _local_1)].ownedTxt.text = "";
                if (this.skillList.length > _local_2)
                {
                    this.panelMC.panel.listMC[("skill_" + _local_1)].visible = true;
                    NinjaSage.loadItemIcon(this.panelMC.panel.listMC[("skill_" + _local_1)], this.skillList[_local_2].advanced_skill);
                    if (this.skillList[_local_2].owned)
                    {
                        this.panelMC.panel.listMC[("skill_" + _local_1)].ownedTxt.text = "Owned";
                    };
                };
                _local_1++;
            };
        }

        private function getTotalOwnedSkills():int
        {
            var _local_1:int;
            var _local_2:int;
            while (_local_2 < this.skillList.length)
            {
                if (this.skillList[_local_2].owned)
                {
                    _local_1++;
                };
                _local_2++;
            };
            return (_local_1);
        }

        private function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btnNextPage":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.showSkillList();
                    };
                    break;
                case "btnPrevPage":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.showSkillList();
                    };
                    break;
            };
            this.updatePageNumber();
        }

        private function updatePageNumber():*
        {
            this.panelMC.panel.listMC.txt_page.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function closeSkillList(_arg_1:MouseEvent):*
        {
            this.panelMC.panel.listMC.visible = false;
            var _local_2:int;
            while (_local_2 < 15)
            {
                GF.removeAllChild(this.panelMC.panel.listMC[("skill_" + _local_2)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.panel.listMC[("skill_" + _local_2)].skillIcon.iconHolder);
                _local_2++;
            };
        }

        private function refreshConfirmation(_arg_1:MouseEvent):*
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (("Are you sure that you want to refresh the skill for " + this.refreshCost) + " tokens?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.removeConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.refreshSkill);
            this.panelMC.addChild(this.confirmation);
        }

        private function removeConfirmation(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
        }

        private function refreshSkill(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            this.main.loading(true);
            this.main.amf_manager.service("MysteriousMarket.refreshPackage", [Character.char_id, Character.sessionkey], this.onSkillRefreshed);
        }

        private function onSkillRefreshed(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage("Store refreshed");
                Character.account_tokens = (Character.account_tokens - this.refreshCost);
                this.main.HUD.setBasicData();
                this.loadAmf();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function openRecharge(_arg_1:MouseEvent):*
        {
            this.main.loadPanel("Panels.Recharge");
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

        private function updateTimeleft():*
        {
            if (this.limitedstore_timestamp == null)
            {
                return;
            };
            var _local_1:* = 86400;
            var _local_2:* = 3600;
            var _local_3:* = 60;
            var _local_4:* = this.limitedstore_timestamp;
            var _local_5:* = Math.floor((_local_4 / _local_1));
            var _local_6:* = Math.floor(((_local_4 - (_local_5 * _local_1)) / _local_2));
            var _local_7:* = Math.floor((((_local_4 - (_local_5 * _local_1)) - (_local_6 * _local_2)) / _local_3));
            this.panelMC.panel.leftdayTxt.text = _local_5;
            this.panelMC.panel.lefthourTxt.text = _local_6;
            this.panelMC.panel.leftminTxt.text = _local_7;
            this.timeout = setTimeout(this.updateTimeleft, 10000);
            this.limitedstore_timestamp = (this.limitedstore_timestamp - 10);
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            var _local_2:* = 0;
            while (_local_2 < this.rewardsArray.length)
            {
                GF.removeAllChild(this.typeMC[("Item_" + _local_2)].Icon_0.rewardIcon.iconHolder);
                GF.removeAllChild(this.typeMC[("Item_" + _local_2)].Icon_0.skillIcon.iconHolder);
                _local_2++;
            };
            this.destroy();
        }

        public function destroy():*
        {
            if (this.timeout)
            {
                clearTimeout(this.timeout);
            };
            NinjaSage.clearLoader();
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            this.main.clearEvents();
            this.main = null;
            this.eventHandler = null;
            this.typeMC = null;
            this.target = null;
            this.target2 = null;
            this.confirmation = null;
            this.selected_skill_id = null;
            this.price = null;
            this.limitedstore_timestamp = null;
            this.discount = null;
            this.refreshCost = null;
            this.refreshCount = null;
            this.skillList = null;
            GF.clearArray(this.rewardsArray);
            GF.clearArray(this.priceArray0);
            GF.clearArray(this.priceArray1);
            GF.clearArray(this.priceArray2);
            GF.clearArray(this.priceArray3);
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

