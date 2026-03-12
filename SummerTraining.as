// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.SummerTraining

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import Popups.Confirmation;
    import id.ninjasage.EventHandler;
    import Storage.GameData;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import Storage.Character;
    import com.utils.GF;

    public dynamic class SummerTraining extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var rewardData:Array = [];
        private var price:int;
        private var selectedBuy:int;
        private var confirmation:Confirmation;
        private var eventHandler:EventHandler;
        private var main:*;

        public function SummerTraining(_arg_1:*, _arg_2:*)
        {
            var _local_3:Object = GameData.get("summer2025");
            var _local_4:int;
            while (_local_4 < _local_3.training.length)
            {
                this.rewardData.push({
                    "skillId":_local_3.training[_local_4].id,
                    "skillPrice":_local_3.training[_local_4].price,
                    "skillName":_local_3.training[_local_4].name
                });
                _local_4++;
            };
            super();
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.initUI();
        }

        private function initUI():void
        {
            var _local_2:MovieClip;
            this.eventHandler.addListener(this.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            var _local_1:int;
            while (_local_1 < this.rewardData.length)
            {
                _local_2 = this.panelMC.contentMC[("Item_" + _local_1)];
                _local_2.skillName.text = this.rewardData[_local_1].skillName;
                NinjaSage.loadItemIcon(_local_2.iconMC, this.rewardData[_local_1].skillId);
                _local_1++;
            };
            this.panelMC.contentMC["Item_0"].tick.visible = false;
            this.panelMC.contentMC["Item_1"].tick.visible = false;
            this.main.initButton(this.panelMC.contentMC["Item_0"].skill.buyBtn_1.buyBtn, this.showConfirmation, "Buy");
            this.main.initButton(this.panelMC.contentMC["Item_0"].skill.buyBtn_2.buyBtn, this.showConfirmation, "Buy");
            this.panelMC.contentMC["Item_0"].skill.price_1.text = this.rewardData[0].skillPrice[0];
            this.panelMC.contentMC["Item_0"].skill.price_2.text = this.rewardData[0].skillPrice[1];
            if (Character.hasSkill(this.rewardData[0].skillId))
            {
                this.panelMC.contentMC["Item_0"].tick.visible = true;
                this.panelMC.contentMC["Item_0"].skill.buyBtn_1.buyBtn.visible = false;
                this.panelMC.contentMC["Item_0"].skill.buyBtn_2.buyBtn.visible = false;
            };
            this.main.initButton(this.panelMC.contentMC["Item_1"].skill.buyBtn_1.buyBtn, this.showConfirmation, "Buy");
            this.main.initButton(this.panelMC.contentMC["Item_1"].skill.buyBtn_2.buyBtn, this.showConfirmation, "Buy");
            this.panelMC.contentMC["Item_1"].skill.price_1.text = this.rewardData[1].skillPrice[0];
            this.panelMC.contentMC["Item_1"].skill.price_2.text = this.rewardData[1].skillPrice[1];
            if (Character.hasSkill(this.rewardData[1].skillId))
            {
                this.panelMC.contentMC["Item_1"].tick.visible = true;
                this.panelMC.contentMC["Item_1"].skill.buyBtn_1.buyBtn.visible = false;
                this.panelMC.contentMC["Item_1"].skill.buyBtn_2.buyBtn.visible = false;
            };
            if (Character.account_type == 1)
            {
                this.panelMC.contentMC["Item_0"].skill.getEmblemBtn.visible = false;
                this.panelMC.contentMC["Item_0"].skill.buyBtn_1.visible = false;
                this.panelMC.contentMC["Item_1"].skill.getEmblemBtn.visible = false;
                this.panelMC.contentMC["Item_1"].skill.buyBtn_1.visible = false;
            }
            else
            {
                this.panelMC.contentMC["Item_0"].skill.getEmblemBtn.visible = true;
                this.panelMC.contentMC["Item_0"].skill.buyBtn_2.visible = false;
                this.main.initButton(this.panelMC.contentMC["Item_0"].skill.getEmblemBtn, this.openRecharge, "GET EMBLEM");
                this.panelMC.contentMC["Item_1"].skill.getEmblemBtn.visible = true;
                this.panelMC.contentMC["Item_1"].skill.buyBtn_2.visible = false;
                this.main.initButton(this.panelMC.contentMC["Item_1"].skill.getEmblemBtn, this.openRecharge, "GET EMBLEM");
            };
        }

        private function showConfirmation(e:MouseEvent):void
        {
            this.selectedBuy = e.currentTarget.parent.parent.parent.name.replace("Item_", "");
            var target:int = ((e.currentTarget.parent.name == "buyBtn_2") ? 1 : 0);
            this.confirmation = new Confirmation();
            this.price = this.rewardData[this.selectedBuy].skillPrice[target];
            this.confirmation.txtMc.txt.text = (((("Confirm buying " + this.rewardData[this.selectedBuy].skillName) + " for ") + this.price) + " tokens?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function (_arg_1:MouseEvent):*
            {
                GF.removeAllChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.buyPackage);
            this.panelMC.addChild(this.confirmation);
        }

        private function buyPackage(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            this.main.loading(true);
            this.main.amf_manager.service("SummerEvent2025.buySkill", [Character.char_id, Character.sessionkey, this.selectedBuy], this.buyResponse);
        }

        private function buyResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.giveReward(1, this.rewardData[this.selectedBuy].skillId, "summer");
                Character.updateSkills(this.rewardData[this.selectedBuy].skillId, true);
                Character.account_tokens = (int(Character.account_tokens) - this.price);
                if (this.selectedBuy > 0)
                {
                    Character.updateSkills(this.rewardData[0].skillId, false);
                };
                this.initUI();
                this.main.HUD.setBasicData();
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
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.rewardData = [];
            this.main = null;
            this.eventHandler = null;
            this.confirmation = null;
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
        }


    }
}//package id.ninjasage.features

