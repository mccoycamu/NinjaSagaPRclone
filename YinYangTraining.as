// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.YinYangTraining

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import Popups.Confirmation;
    import id.ninjasage.EventHandler;
    import Storage.GameData;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaSage;
    import com.utils.GF;

    public dynamic class YinYangTraining extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var trainingData:Array = [];
        private var selectedBuySkill:int = -1;
        private var response:Object;
        private var confirmation:Confirmation;
        private var eventHandler:EventHandler;
        private var main:*;

        public function YinYangTraining(_arg_1:*, _arg_2:*)
        {
            var _local_3:Object = GameData.get("yinyang2025");
            var _local_4:int;
            while (_local_4 < _local_3.training.length)
            {
                this.trainingData.push({
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
            this.panelMC.tokenTxt.text = Character.account_tokens;
            this.panelMC.txt_title.text = "Get Now!";
            this.eventHandler.addListener(this.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.getMoreBtn, MouseEvent.CLICK, this.openRecharge);
            var _local_1:int;
            while (_local_1 < 2)
            {
                NinjaSage.loadItemIcon(this.panelMC[("Icon_" + _local_1)], this.trainingData[_local_1].skillId);
                this.panelMC[("skillName" + _local_1)].text = this.trainingData[_local_1].skillName;
                this.panelMC[("box" + _local_1)]["price_0"].text = this.trainingData[_local_1].skillPrice[0];
                this.panelMC[("box" + _local_1)]["price_1"].text = this.trainingData[_local_1].skillPrice[1];
                this.eventHandler.addListener(this.panelMC[("box" + _local_1)].buyBtn_0, MouseEvent.CLICK, this.showConfirmationSkill);
                this.eventHandler.addListener(this.panelMC[("box" + _local_1)].buyBtn_1, MouseEvent.CLICK, this.showConfirmationSkill);
                if (Character.account_type == 1)
                {
                    this.panelMC[("box" + _local_1)].getEmblemBtn.visible = false;
                    this.panelMC[("box" + _local_1)].buyBtn_0.visible = false;
                    this.panelMC[("box" + _local_1)].buyBtn_1.visible = true;
                }
                else
                {
                    this.panelMC[("box" + _local_1)].getEmblemBtn.visible = true;
                    this.panelMC[("box" + _local_1)].buyBtn_0.visible = true;
                    this.panelMC[("box" + _local_1)].buyBtn_1.visible = false;
                };
                this.panelMC[("tick" + _local_1)].visible = false;
                if (((Character.hasSkill(this.trainingData[_local_1].skillId) > 0) || (Character.hasSkill(this.trainingData[1].skillId))))
                {
                    this.panelMC[("box" + _local_1)].buyBtn_0.visible = false;
                    this.panelMC[("box" + _local_1)].buyBtn_1.visible = false;
                    this.panelMC[("tick" + _local_1)].visible = true;
                };
                _local_1++;
            };
        }

        private function showConfirmationSkill(e:MouseEvent):void
        {
            this.confirmation = new Confirmation();
            this.selectedBuySkill = e.currentTarget.parent.name.replace("box", "");
            this.confirmation.txtMc.txt.text = (((("Confirm buying " + this.trainingData[this.selectedBuySkill].skillName) + " for ") + this.trainingData[this.selectedBuySkill].skillPrice[Character.account_type]) + " tokens ?");
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
            this.main.loading(true);
            this.main.amf_manager.service("YinYangEvent.buySkill", [Character.char_id, Character.sessionkey, this.selectedBuySkill], this.buyResponse);
        }

        private function buyResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.giveReward(1, this.trainingData[this.selectedBuySkill].skillId, "anniversary");
                Character.updateSkills(this.trainingData[this.selectedBuySkill].skillId, true);
                if (this.selectedBuySkill > 0)
                {
                    Character.updateSkills(this.trainingData[(this.selectedBuySkill - 1)].skillId, false);
                };
                Character.account_tokens = (int(Character.account_tokens) - this.trainingData[this.selectedBuySkill].skillPrice[Character.account_type]);
                this.panelMC.tokenTxt.text = Character.account_tokens;
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
            this.trainingData = [];
            this.main = null;
            this.eventHandler = null;
            this.response = null;
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
        }


    }
}//package id.ninjasage.features

