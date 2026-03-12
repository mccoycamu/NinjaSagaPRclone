// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Friendship_Shop

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import Popups.Confirmation;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class Friendship_Shop extends MovieClip 
    {

        private const FRIENDSHIP_KUNAI:String = "material_1002";

        public var btn_close:SimpleButton;
        public var btn_fk0:MovieClip;
        public var btn_fk1:MovieClip;
        public var btn_fk2:MovieClip;
        public var btn_fk3:MovieClip;
        public var btn_fk4:MovieClip;
        public var btn_fk5:MovieClip;
        public var btn_fk6:MovieClip;
        public var btn_fk7:MovieClip;
        public var btn_fk8:MovieClip;
        public var btn_fk9:MovieClip;
        public var iconMc0:MovieClip;
        public var iconMc1:MovieClip;
        public var iconMc2:MovieClip;
        public var iconMc3:MovieClip;
        public var iconMc4:MovieClip;
        public var iconMc5:MovieClip;
        public var iconMc6:MovieClip;
        public var iconMc7:MovieClip;
        public var iconMc8:MovieClip;
        public var iconMc9:MovieClip;
        public var banner:MovieClip;
        public var txt_kunai:TextField;
        public var btn_get_kunai:SimpleButton;
        public var main:*;
        private var eventHandler:EventHandler;
        private var confirmation:Confirmation;
        private var rewardData:Array;
        private var selectedExchange:int;

        public function Friendship_Shop(_arg_1:*)
        {
            this.main = _arg_1;
            this.eventHandler = new EventHandler();
            this.rewardData = [];
            this.getData();
        }

        private function getData():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.getItems", [Character.char_id, Character.sessionkey], this.onGetData);
        }

        private function onGetData(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.rewardData = _arg_1.items;
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
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.btn_get_kunai, MouseEvent.CLICK, this.closePanel);
            this.main.initButton(this.banner, this.closePanel, "Challenge Friend");
            var _local_1:* = "Receive a 'Friendship Kunai' After Winning Challenge Friends!";
            NinjaSage.showDynamicTooltip(this.btn_get_kunai, _local_1);
            NinjaSage.showDynamicTooltip(this.banner, _local_1);
            this.txt_kunai.text = Character.getMaterialAmount(this.FRIENDSHIP_KUNAI);
            var _local_2:int;
            while (_local_2 < this.rewardData.length)
            {
                this[("btn_fk" + _local_2)].metaData = {"id":this.rewardData[_local_2].id};
                this.main.initButton(this[("btn_fk" + _local_2)], this.exchangeConfirmation, this.rewardData[_local_2].price);
                this[("iconMc" + _local_2)].amtTxt.visible = false;
                this[("iconMc" + _local_2)].ownedTxt.visible = false;
                NinjaSage.loadItemIcon(this[("iconMc" + _local_2)], this.rewardData[_local_2].item);
                _local_2++;
            };
        }

        private function exchangeConfirmation(e:MouseEvent):void
        {
            this.selectedExchange = e.currentTarget.metaData.id;
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure want to exchange this reward?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():*
            {
                GF.removeAllChild(confirmation);
                confirmation = null;
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.exchangeItem);
            this.addChild(this.confirmation);
        }

        private function exchangeItem(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            this.main.loading(true);
            this.main.amf_manager.service("FriendService.buyItem", [Character.char_id, Character.sessionkey, this.selectedExchange], this.exchangeResponse);
        }

        private function exchangeResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.addRewards(_arg_1.reward);
                Character.replaceMaterials(this.FRIENDSHIP_KUNAI, _arg_1.kunai);
                this.main.giveReward(1, _arg_1.reward);
                this.main.HUD.setBasicData();
                this.txt_kunai.text = Character.getMaterialAmount(this.FRIENDSHIP_KUNAI);
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            GF.removeAllChild(this.confirmation);
            GF.removeAllChild(this);
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.rewardData = null;
            this.confirmation = null;
            this.main = null;
            System.gc();
        }


    }
}//package Panels

