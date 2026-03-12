// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.SpecialDeals

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import Popups.Confirmation;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class SpecialDeals extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var main:*;
        private var confirmation:Confirmation;
        private var eventHandler:EventHandler;
        private var currentPage:int = 1;
        private var totalPage:int = 1;
        private var price:int;
        private var target:int;

        private var packData:Array = [];
        private var rewardPaneList:Array = [];

        public function SpecialDeals(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.getData();
        }

        private function getData():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("SpecialDeals.getDeals", [Character.char_id, Character.sessionkey], this.getDataResponse);
        }

        private function getDataResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.packData = _arg_1.deals;
                this.initUI();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
                this.destroy();
            };
        }

        private function initUI():void
        {
            this.main.handleVillageHUDVisibility(false);
            var _local_1:int;
            while (_local_1 < 4)
            {
                this.rewardPaneList.push(new RewardScrollPane());
                this.panelMC[("item_" + _local_1)].scrollPaneHolder.addChild(this.rewardPaneList[_local_1].getRewardPane());
                _local_1++;
            };
            this.currentPage = 1;
            this.totalPage = Math.max(1, Math.ceil((this.packData.length / 4)));
            this.panelMC.tokenMc.tokenTxt.text = String(Character.account_tokens);
            this.eventHandler.addListener(this.panelMC.closeBtn, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btnNextPage, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btnPrevPage, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.tokenMc.plusTokens, MouseEvent.CLICK, this.openRecharge);
            this.renderPacks();
            this.updatePageText();
        }

        private function renderPacks():void
        {
            var _local_2:int;
            var _local_1:int;
            while (_local_1 < 4)
            {
                this.panelMC[("item_" + _local_1)].visible = false;
                _local_2 = (_local_1 + int((int((this.currentPage - 1)) * 4)));
                if (this.packData.length > _local_2)
                {
                    this.panelMC[("item_" + _local_1)].visible = true;
                    this.panelMC[("item_" + _local_1)].nameTxt.text = this.packData[_local_2].name;
                    this.panelMC[("item_" + _local_1)].endTxt.text = this.packData[_local_2].end;
                    this.panelMC[("item_" + _local_1)].buyBtn.metaData = {"index":_local_2};
                    this.main.initButton(this.panelMC[("item_" + _local_1)].buyBtn, this.showConfirmation, this.packData[_local_2].price);
                    this.rewardPaneList[_local_1].updateRewardPane({
                        "rewards":this.packData[_local_2].items,
                        "item_per_line":2,
                        "width":365,
                        "height":null,
                        "x":125,
                        "y":140,
                        "scroll_direction":"horizontal",
                        "scroll_visible":false
                    });
                };
                _local_1++;
            };
        }

        private function updatePageText():void
        {
            this.panelMC.pageTxt.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function changePage(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btnNextPage":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.renderPacks();
                    };
                    break;
                case "btnPrevPage":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.renderPacks();
                    };
            };
            this.updatePageText();
        }

        private function showConfirmation(_arg_1:MouseEvent):void
        {
            this.target = this.packData[_arg_1.currentTarget.metaData.index].id;
            this.price = this.packData[_arg_1.currentTarget.metaData.index].price;
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (((("Are you sure that you want to buy " + this.packData[_arg_1.currentTarget.metaData.index].name) + " for ") + this.price) + " tokens?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.removeConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.buyPackage);
            this.panelMC.addChild(this.confirmation);
        }

        private function removeConfirmation(_arg_1:MouseEvent):*
        {
            this.eventHandler.removeListener(this.confirmation.btn_close, MouseEvent.CLICK, this.removeConfirmation);
            this.eventHandler.removeListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.buyPackage);
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
        }

        private function buyPackage(_arg_1:MouseEvent):void
        {
            this.removeConfirmation(null);
            this.main.amf_manager.service("SpecialDeals.buy", [Character.char_id, Character.sessionkey, this.target], this.buyResponse);
        }

        private function buyResponse(_arg_1:Object):void
        {
            if (_arg_1.status == 1)
            {
                this.main.showMessage("You have successfully bought this package!");
                Character.addRewards(_arg_1.rewards);
                this.main.giveReward(1, _arg_1.rewards, "independence");
                Character.account_tokens = (int(Character.account_tokens) - this.price);
                this.main.HUD.setBasicData();
                this.panelMC.tokenMc.tokenTxt.text = String(Character.account_tokens);
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function openRecharge(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Recharge");
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.main.handleVillageHUDVisibility(true);
            this.eventHandler.removeAllEventListeners();
            GF.destroyArray(this.rewardPaneList);
            this.rewardPaneList = null;
            this.eventHandler = null;
            this.confirmation = null;
            this.packData = null;
            this.main = null;
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
            System.gc();
        }


    }
}//package id.ninjasage.features

