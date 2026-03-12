// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.RedeemTicket

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import Storage.PetInfo;
    import com.utils.GF;
    import Popups.Confirmation;
    import flash.system.System;

    public dynamic class RedeemTicket extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:*;
        private var selectedReward:int = -1;
        private var selectedRewardName:String;
        private var selectedDragonBall:int = -1;
        private var selectedDragonBallMaterial:String = null;
        private var rewardList:*;
        private var dragonBall:Array = ["material_819", "material_820", "material_821", "material_822", "material_823"];
        private var dragonBallTier:Array = [{"materialId":["material_775:2", "material_776:2", "material_777:2", "material_778:2", "material_779:2", "material_780:2", "material_781:2"]}, {"materialId":["material_782:2", "material_783:2", "material_784:2", "material_785:2", "material_786:2", "material_787:2", "material_788:2"]}, {"materialId":["material_789:2", "material_790:2", "material_791:2", "material_792:2", "material_793:2", "material_794:2", "material_795:2"]}, {"materialId":["material_796:2", "material_797:2", "material_798:2", "material_799:2", "material_800:2", "material_801:2", "material_802:2"]}, {"materialId":["material_803:2", "material_804:2", "material_805:2", "material_806:2", "material_807:2", "material_808:2", "material_809:2"]}];
        private var confirmation:*;
        private var currentPage:int = 1;
        private var totalPage:int = 0;
        private var amount:int = 1;
        private var price:int = 1;
        private var cost:int = 1;
        private var ownedTicket:int;

        public function RedeemTicket(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.getBasicData();
        }

        private function getBasicData():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("RedeemTicket.getData", [Character.char_id, Character.sessionkey], this.basicDataResponse);
        }

        private function basicDataResponse(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                this.rewardList = _arg_1.exchanges;
                this.ownedTicket = _arg_1.tickets;
                this.onShow();
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
            this.main.loading(false);
        }

        private function onShow():*
        {
            var _local_1:* = this.panelMC;
            this.initButton();
            this.initUI();
            _local_1.qtyMC.visible = false;
            _local_1.dbSelectMC.visible = false;
            _local_1.txt_ticket.text = this.ownedTicket;
            _local_1.titleTxt.text = "Redeem Ticket Rewards Selection";
            _local_1.displayTxt2.text = "Please select ONE rewards below: ";
            _local_1.displayTxt.text = "*Make sure you choose the reward wisely\n*Exchanged Reward Cannot Be Undone\n*Price Shown is per 1 ticket\n*Redeem Ticket Can Only Be Obtained From Recharge";
        }

        private function initUI():*
        {
            var _local_3:*;
            var _local_1:* = this.panelMC;
            var _local_2:* = 0;
            while (_local_2 < 5)
            {
                _local_3 = (_local_2 + int((int((this.currentPage - 1)) * 5)));
                if (this.rewardList.length > _local_3)
                {
                    _local_1[("item" + _local_2)].visible = true;
                    _local_1[("arrow_" + _local_2)].visible = true;
                    _local_1[("item" + _local_2)].gotoAndStop(this.rewardList[_local_3].code);
                    _local_1[("item" + _local_2)].itemType.highlightMC.gotoAndStop("unselected");
                    _local_1[("item" + _local_2)].buttonMode = true;
                    _local_1[("item" + _local_2)].itemType.descTxt.text = (((this.rewardList[_local_3].qty + "\n") + _local_1[("item" + _local_2)].itemType.nameTxt.text) + "(s)");
                    _local_1[("item" + _local_2)].reward_name = (_local_1[("item" + _local_2)].itemType.nameTxt.text + "(s)");
                    _local_1[("item" + _local_2)].selected_reward = _local_3;
                    this.eventHandler.addListener(_local_1[("item" + _local_2)], MouseEvent.CLICK, this.onClick);
                }
                else
                {
                    _local_1[("item" + _local_2)].visible = false;
                    _local_1[("arrow_" + _local_2)].visible = false;
                };
                _local_2++;
            };
            this.updatePageNumber();
            this.totalPage = Math.ceil((this.rewardList.length / 5));
        }

        private function onClick(_arg_1:MouseEvent):*
        {
            var _local_2:* = 0;
            while (_local_2 < 5)
            {
                this.panelMC[("item" + _local_2)].itemType.highlightMC.gotoAndStop("unselected");
                _local_2++;
            };
            this.selectedReward = _arg_1.currentTarget.selected_reward;
            this.selectedRewardName = _arg_1.currentTarget.reward_name;
            _arg_1.currentTarget.itemType.highlightMC.gotoAndStop("selected");
        }

        private function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "nextBtn":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.initUI();
                    };
                    break;
                case "prevBtn":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.initUI();
                    };
            };
            this.updatePageNumber();
        }

        private function updatePageNumber():*
        {
            if (this.currentPage == 1)
            {
                this.panelMC.prevBtn.visible = false;
            }
            else
            {
                this.panelMC.prevBtn.visible = true;
            };
            if (this.currentPage == this.totalPage)
            {
                this.panelMC.nextBtn.visible = false;
            }
            else
            {
                this.panelMC.nextBtn.visible = true;
            };
        }

        private function initButton():*
        {
            this.eventHandler.addListener(this.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.prevBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.nextBtn, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.buyTokens, MouseEvent.CLICK, this.closePanel);
            this.main.initButton(this.panelMC.btnConfirm, this.openBuyQuantity, "Select");
        }

        private function openBuyQuantity(_arg_1:MouseEvent):*
        {
            var _local_2:int;
            var _local_3:*;
            var _local_4:*;
            if (this.selectedReward < 0)
            {
                this.main.showMessage("Please Select 1");
                return;
            };
            if (this.ownedTicket < 1)
            {
                if (this.rewardList[this.selectedReward].code != "pet")
                {
                    this.main.showMessage("You don't have Redeem Ticket");
                    return;
                };
            };
            if (this.rewardList[this.selectedReward].code == "dragon_ball")
            {
                this.panelMC.dbSelectMC.visible = true;
                this.panelMC.dbSelectMC.txt_title.text = "Select Dragon Ball";
                this.panelMC.dbSelectMC.txt_notice.text = "Note: you will get all the dragon ball from selected color";
                this.cost = 2;
                this.resetSelectedDragonBall();
                this.eventHandler.addListener(this.panelMC.dbSelectMC.btnClose, MouseEvent.CLICK, this.closeDragonBallSelect);
                this.main.initButton(this.panelMC.dbSelectMC.buyBtn, this.openConfirmation, "Exchange");
                _local_2 = 0;
                while (_local_2 < this.dragonBall.length)
                {
                    NinjaSage.loadItemIcon(this.panelMC.dbSelectMC[("iconMC" + _local_2)], this.dragonBall[_local_2]);
                    this.eventHandler.addListener(this.panelMC.dbSelectMC[("iconMC" + _local_2)], MouseEvent.CLICK, this.selectDragonBall);
                    _local_2++;
                };
            }
            else
            {
                _local_3 = this.panelMC.qtyMC;
                this.panelMC.qtyMC.visible = true;
                if (this.rewardList[this.selectedReward].hasOwnProperty("swf"))
                {
                    _local_3.nextBtn.visible = false;
                    _local_3.prevBtn.visible = false;
                    _local_3.iconMC.visible = false;
                    _local_3.petIcon.visible = true;
                    _local_4 = PetInfo.getPetStats(this.rewardList[this.selectedReward].swf);
                    _local_3.petIcon.nameTxt.text = ("Pet " + _local_4.pet_name);
                    _local_3.petIcon.descTxt.text = _local_4.description;
                    _local_3.petIcon.dateTxt.text = ("Pet will be refreshed in " + this.rewardList[this.selectedReward].expiry);
                    GF.removeAllChild(_local_3.petIcon.iconMc.iconHolder);
                    NinjaSage.loadIconSWF("pets", this.rewardList[this.selectedReward].swf, _local_3.petIcon.iconMc.iconHolder, "with_holder");
                }
                else
                {
                    _local_3.nextBtn.visible = true;
                    _local_3.prevBtn.visible = true;
                    _local_3.iconMC.visible = true;
                    _local_3.petIcon.visible = false;
                };
                this.eventHandler.addListener(_local_3.nextBtn, MouseEvent.CLICK, this.changeAmount);
                this.eventHandler.addListener(_local_3.prevBtn, MouseEvent.CLICK, this.changeAmount);
                this.eventHandler.addListener(_local_3.btnClose, MouseEvent.CLICK, this.closeQuantity);
                this.main.initButton(_local_3.buyBtn, this.openConfirmation, "Exchange");
                this.price = this.rewardList[this.selectedReward].qty;
                this.cost = (this.price * this.amount);
                _local_3.iconMC.gotoAndStop(this.rewardList[this.selectedReward].code);
                _local_3.iconMC.itemType.highlightMC.gotoAndStop(1);
                _local_3.amountTxt.text = this.amount;
                _local_3.iconMC.itemType.descTxt.text = ((this.cost + " ") + this.selectedRewardName);
            };
        }

        private function changeAmount(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name;
            var _local_3:* = this.panelMC.qtyMC;
            if (((this.amount <= 1) && (!(_local_2 == "nextBtn"))))
            {
                return;
            };
            if (((this.amount >= this.ownedTicket) && (_local_2 == "nextBtn")))
            {
                this.main.showMessage("Cannot exceed owned ticket");
                return;
            };
            if (_local_2 == "nextBtn")
            {
                this.amount = (this.amount + 1);
            }
            else
            {
                this.amount--;
            };
            this.cost = (this.price * this.amount);
            _local_3.amountTxt.text = this.amount;
            _local_3.iconMC.itemType.descTxt.text = ((this.cost + " ") + this.selectedRewardName);
        }

        private function selectDragonBall(_arg_1:MouseEvent):void
        {
            var _local_2:int = _arg_1.currentTarget.name.replace("iconMC", "");
            this.resetSelectedDragonBall();
            this.panelMC.dbSelectMC[("iconMC" + _local_2)].tick.visible = true;
            this.selectedDragonBall = _local_2;
            this.selectedDragonBallMaterial = this.dragonBall[this.selectedDragonBall];
        }

        private function resetSelectedDragonBall():void
        {
            var _local_1:int;
            while (_local_1 < this.dragonBall.length)
            {
                this.panelMC.dbSelectMC[("iconMC" + _local_1)].tick.visible = false;
                _local_1++;
            };
        }

        private function exchangeTicket(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            this.main.loading(true);
            this.main.amf_manager.service("RedeemTicket.exchange", [Character.char_id, Character.sessionkey, this.rewardList[this.selectedReward].code, this.amount, this.selectedDragonBallMaterial], this.onExchange);
        }

        private function onExchange(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage((((this.cost + " ") + this.selectedRewardName) + " Obtained"));
                if (_arg_1.materials.material_2063 > 0)
                {
                    Character.replaceMaterials("material_2063", _arg_1.materials.material_2063);
                };
                if (_arg_1.materials.material_1002 > 0)
                {
                    Character.replaceMaterials("material_1002", _arg_1.materials.material_1002);
                };
                if (_arg_1.materials.material_874 > 0)
                {
                    Character.replaceMaterials("material_874", _arg_1.materials.material_874);
                };
                if (_arg_1.materials.material_69 > 0)
                {
                    Character.replaceMaterials("material_69", _arg_1.materials.material_69);
                };
                if (_arg_1.materials.material_939 > 0)
                {
                    Character.replaceMaterials("material_939", _arg_1.materials.material_939);
                };
                if (_arg_1.materials.material_941 > 0)
                {
                    Character.replaceMaterials("material_941", _arg_1.materials.material_941);
                };
                Character.account_tokens = _arg_1.currencies.tokens;
                Character.character_gold = _arg_1.currencies.gold;
                Character.character_tp = _arg_1.currencies.tp;
                Character.character_ss = _arg_1.currencies.ss;
                Character.character_prestige = _arg_1.currencies.prestige;
                Character.character_merit = _arg_1.currencies.merit;
                Character.character_pvp_point = _arg_1.currencies.pvp_points;
                this.main.HUD.setBasicData();
                this.panelMC.txt_ticket.text = _arg_1.materials.material_2063;
                GF.removeAllChild(this.confirmation);
                if (this.rewardList[this.selectedReward].hasOwnProperty("swf"))
                {
                    this.main.giveReward(1, this.rewardList[this.selectedReward].swf);
                };
                if (this.rewardList[this.selectedReward].code == "dragon_ball")
                {
                    Character.addRewards(this.dragonBallTier[this.selectedDragonBall].materialId);
                    this.main.giveReward(1, this.dragonBallTier[this.selectedDragonBall].materialId);
                };
                this.closeDragonBallSelect();
                this.closeQuantity();
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

        private function closeQuantity(_arg_1:MouseEvent=null):*
        {
            this.panelMC.qtyMC.visible = false;
            GF.removeAllChild(this.panelMC.qtyMC.petIcon.iconMc.iconHolder);
            this.amount = 1;
            this.price = 1;
            this.cost = 1;
        }

        private function closeDragonBallSelect(_arg_1:MouseEvent=null):*
        {
            this.panelMC.dbSelectMC.visible = false;
            this.selectedDragonBall = -1;
            this.selectedDragonBallMaterial = null;
            var _local_2:int;
            while (_local_2 < 5)
            {
                this.panelMC.dbSelectMC[("iconMC" + _local_2)].tick.visible = false;
                GF.removeAllChild(this.panelMC.dbSelectMC[("iconMC" + _local_2)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.dbSelectMC[("iconMC" + _local_2)].skillIcon.iconHolder);
                _local_2++;
            };
        }

        private function openConfirmation(e:MouseEvent):*
        {
            if (((this.rewardList[this.selectedReward].code == "dragon_ball") && (this.selectedDragonBall == -1)))
            {
                this.main.showMessage("Please select at least 1 dragon ball package");
                return;
            };
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (((((("Are You Sure That You Want To Exchange " + this.amount) + " Ticket To Redeem ") + this.cost) + " ") + this.selectedRewardName) + " ?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():*
            {
                GF.removeAllChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.exchangeTicket);
            this.panelMC.addChild(this.confirmation);
        }

        private function openRecharge(_arg_1:MouseEvent):*
        {
            this.main.loadPanel("Panels.Recharge");
        }

        private function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():*
        {
            this.main.removeExternalSwfPanel();
            this.eventHandler.removeAllEventListeners();
            this.dragonBall = [];
            this.dragonBallTier = [];
            this.main = null;
            this.eventHandler = null;
            this.confirmation = null;
            this.currentPage = 1;
            this.totalPage = 0;
            this.amount = 1;
            this.price = 1;
            this.cost = 1;
            this.selectedReward = -1;
            this.selectedRewardName = null;
            GF.clearArray(this.rewardList);
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

