// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ResetSkill

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import com.utils.GF;

    public class ResetSkill extends MovieClip 
    {

        public var panelMC:MovieClip;
        public var eventHandler:EventHandler;
        public var main:*;
        public var quantity:*;
        public var cost:*;
        public var selectedSkill_1:*;
        public var selectedSkill_2:*;
        public var selectedSkill_3:*;
        public var selectedSkill:*;
        public var elementSelected:*;
        public var gan:*;
        public var matCheck:*;

        public function ResetSkill(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.quantity = 1;
            this.cost = 200;
            this.selectedSkill_1 = 0;
            this.selectedSkill_2 = 0;
            this.selectedSkill_3 = 0;
            this.gan = 0;
            this.selectedSkill = [];
            this.elementSelected = [];
            this.panelMC.panel.panelIcon.gotoAndStop(1);
            this.panelMC.panel.buyItemMC.visible = false;
            this.panelMC.panel.buyItemMC.prevBtn.visible = false;
            this.panelMC.panel.buyItemMC.nextBtn.visible = false;
            this.panelMC.panel.confirmationMc.visible = false;
            this.panelMC.panel.panelMC.btn_reset.visible = false;
            this.panelMC.panel.panelMC.btn_resetemblem.visible = false;
            this.panelMC.panel.titleTxt.text = "Reset Element Jutsu";
            this.panelMC.panel.essenceSkillTxt.text = 0;
            this.panelMC.panel.tokenTxt.text = Character.account_tokens;
            this.panelMC.panel.subTitle.text = "Reset Element Jutsu";
            this.panelMC.panel.descTxt.text = "You can reset all the Elements Ninjutsu once you have enough Ninja Seal Gan.";
            this.panelMC.panel.panelMC.freeuserMc.extremeTxt.text = "5";
            this.panelMC.panel.panelMC.emblemuserMc.extremeTxt.text = "1";
            this.eventHandler.addListener(this.panelMC.panel.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.panel.btn_getessence, MouseEvent.CLICK, this.buyItem);
            this.eventHandler.addListener(this.panelMC.panel.btn_gettoken, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.panelMC.panel.btn_cancel, MouseEvent.CLICK, this.removeSelectedSkill);
            this.eventHandler.addListener(this.panelMC.panel.panelMC.emblemBtn, MouseEvent.CLICK, this.emblemUpgrade);
            this.loadBasicData();
            this.eventHandler.addListener(this.panelMC.panel.secretMc.skill_1, MouseEvent.CLICK, this.getSelectedSkill);
            this.eventHandler.addListener(this.panelMC.panel.secretMc.skill_2, MouseEvent.CLICK, this.getSelectedSkill);
            this.eventHandler.addListener(this.panelMC.panel.secretMc.skill_3, MouseEvent.CLICK, this.getSelectedSkill);
        }

        public function loadBasicData():void
        {
            this.panelMC.panel.ResetTypeMc.gotoAndStop(6);
            this.panelMC.panel.essenceSkillTxt.text = this.getMaterial();
            this.panelMC.panel.ResetTypeMc.resetTypeIcon.gotoAndStop(1);
            this.panelMC.panel.secretMc.visible = true;
            this.panelMC.panel.academyBtn.visible = false;
            this.panelMC.panel.secretMc.gotoAndStop(6);
            this.panelMC.panel.secretMc.skill_1.gotoAndStop(1);
            this.panelMC.panel.secretMc.skill_2.gotoAndStop(1);
            this.panelMC.panel.secretMc.skill_3.gotoAndStop(1);
            this.panelMC.panel.secretMc.skill_1.skill.gotoAndStop((int(Character.character_element_1) + 1));
            this.panelMC.panel.secretMc.skill_2.skill.gotoAndStop((int(Character.character_element_2) + 1));
            if (Character.character_element_3)
            {
                this.panelMC.panel.secretMc.skill_3.skill.gotoAndStop((int(Character.character_element_3) + 1));
            }
            else
            {
                this.panelMC.panel.secretMc.skill_3.skill.gotoAndStop(1);
            };
            this.panelMC.panel.panelMC.freeuserMc.gotoAndStop(1);
            this.panelMC.panel.panelMC.emblemuserMc.gotoAndStop(1);
            this.panelMC.panel.ResetTypeMc.resetTypeIcon.gotoAndStop(6);
            this.panelMC.panel.ResetTypeMc.resetTypeIcon.btnLearnSkill1.gotoAndStop(1);
            this.panelMC.panel.ResetTypeMc.resetTypeIcon.btnLearnSkill2.gotoAndStop(1);
            this.panelMC.panel.ResetTypeMc.resetTypeIcon.btnLearnSkill3.gotoAndStop(1);
            if (int(Character.account_type) == 0)
            {
                this.panelMC.panel.panelMC.btn_reset.visible = true;
            };
            if (((int(Character.account_type) == 1) && (int(Character.emblem_duration) > 0)))
            {
                this.panelMC.panel.panelMC.btn_resetemblem.visible = true;
            };
            if (((int(Character.account_type) == 1) && (int(Character.emblem_duration) == -1)))
            {
                this.panelMC.panel.panelMC.btn_resetemblem.visible = true;
                this.eventHandler.removeListener(this.panelMC.panel.panelMC.emblemBtn, MouseEvent.CLICK, this.emblemUpgrade);
            };
            this.matCheck = this.getMaterial();
            if (this.matCheck < 5)
            {
                this.eventHandler.addListener(this.panelMC.panel.panelMC.btn_reset, MouseEvent.CLICK, this.buyItem);
            }
            else
            {
                this.eventHandler.addListener(this.panelMC.panel.panelMC.btn_reset, MouseEvent.CLICK, this.confirmation);
            };
            if (this.matCheck < 1)
            {
                this.eventHandler.addListener(this.panelMC.panel.panelMC.btn_resetemblem, MouseEvent.CLICK, this.buyItem);
            }
            else
            {
                this.eventHandler.addListener(this.panelMC.panel.panelMC.btn_resetemblem, MouseEvent.CLICK, this.confirmation);
            };
        }

        public function openRecharge(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Recharge");
        }

        public function emblemUpgrade(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Popups.EmblemUpgrade");
        }

        public function closePanel(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.main.handleVillageHUDVisibility(true);
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            this.eventHandler = null;
            this.main = null;
            GF.removeAllChild(this.panelMC);
        }

        public function buyItem(_arg_1:MouseEvent):*
        {
            this.panelMC.panel.titleTxt.text = "Reset Jutsu";
            this.panelMC.panel.buyItemMC.titleTxt.text = "Buy More Seal Gan";
            this.panelMC.panel.buyItemMC.itemNameTxt.text = "Ninja Seal Gan";
            this.eventHandler.removeListener(this.panelMC.panel.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.removeListener(this.panelMC.panel.panelMC.btn_reset, MouseEvent.CLICK, this.confirmation);
            this.eventHandler.removeListener(this.panelMC.panel.panelMC.btn_resetemblem, MouseEvent.CLICK, this.confirmation);
            this.eventHandler.removeListener(this.panelMC.panel.panelMC.btn_reset, MouseEvent.CLICK, this.buyItem);
            this.eventHandler.removeListener(this.panelMC.panel.panelMC.btn_resetemblem, MouseEvent.CLICK, this.buyItem);
            this.panelMC.panel.buyItemMC.visible = true;
            this.panelMC.panel.buyItemMC.itemMC.gotoAndStop(5);
            this.panelMC.panel.buyItemMC.itemMC.IconMc.gotoAndStop(1);
            this.panelMC.panel.buyItemMC.itemMC.IconMc.itemMC.gotoAndStop(1);
            this.panelMC.panel.buyItemMC.numTxt.text = this.quantity;
            this.panelMC.panel.buyItemMC.TokenCost.txt_token.text = this.cost;
            this.eventHandler.addListener(this.panelMC.panel.buyItemMC.btn_buy, MouseEvent.CLICK, this.buyMaterial);
            this.eventHandler.addListener(this.panelMC.panel.buyItemMC.btnClose, MouseEvent.CLICK, this.closeReset);
            this.eventHandler.addListener(this.panelMC.panel.buyItemMC.btnNext, MouseEvent.CLICK, this.addQuantity);
            this.eventHandler.addListener(this.panelMC.panel.buyItemMC.btnPrev, MouseEvent.CLICK, this.subQuantity);
        }

        public function confirmation(_arg_1:MouseEvent):*
        {
            this.eventHandler.removeListener(this.panelMC.panel.panelMC.btn_reset, MouseEvent.CLICK, this.buyItem);
            this.eventHandler.removeListener(this.panelMC.panel.panelMC.btn_resetemblem, MouseEvent.CLICK, this.buyItem);
            this.eventHandler.removeListener(this.panelMC.panel.buyItemMC.btn_buy, MouseEvent.CLICK, this.buyItem);
            this.eventHandler.removeListener(this.panelMC.panel.btn_close, MouseEvent.CLICK, this.closePanel);
            this.panelMC.panel.confirmationMc.visible = true;
            this.eventHandler.addListener(this.panelMC.panel.confirmationMc.btn_confirm, MouseEvent.CLICK, this.resetAmf);
            this.eventHandler.addListener(this.panelMC.panel.confirmationMc.btn_close, MouseEvent.CLICK, this.closeReset);
        }

        public function closeReset(_arg_1:MouseEvent):*
        {
            this.panelMC.panel.buyItemMC.visible = false;
            this.panelMC.panel.confirmationMc.visible = false;
            this.eventHandler.addListener(this.panelMC.panel.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.removeListener(this.panelMC.panel.buyItemMC.btnClose, MouseEvent.CLICK, this.closeReset);
            this.eventHandler.removeListener(this.panelMC.panel.confirmationMc.btn_close, MouseEvent.CLICK, this.closeReset);
            this.eventHandler.removeListener(this.panelMC.panel.buyItemMC.btn_buy, MouseEvent.CLICK, this.closeReset);
        }

        public function addQuantity(_arg_1:MouseEvent):*
        {
            this.quantity = (int(this.quantity) + 1);
            this.cost = int((200 * this.quantity));
            this.panelMC.panel.buyItemMC.numTxt.text = this.quantity;
            this.panelMC.panel.buyItemMC.TokenCost.txt_token.text = this.cost;
        }

        public function subQuantity(_arg_1:MouseEvent):*
        {
            if (this.quantity <= 1)
            {
                return;
            };
            this.quantity = (int(this.quantity) - 1);
            this.cost = (int(this.cost) - 200);
            this.panelMC.panel.buyItemMC.numTxt.text = this.quantity;
            this.panelMC.panel.buyItemMC.TokenCost.txt_token.text = this.cost;
        }

        public function getSelectedSkill(_arg_1:MouseEvent):*
        {
            this.panelMC.panel.ResetTypeMc.resetTypeIcon.gotoAndStop(6);
            var _local_2:String = String(_arg_1.currentTarget.name.replace("skill_", ""));
            if (this.selectedSkill.length < 3)
            {
                this.selectedSkill.push(_local_2);
                this.panelMC.panel.ResetTypeMc.resetTypeIcon[("btnLearnSkill" + _local_2)].gotoAndStop((int(Character[("character_element_" + _local_2)]) + 1));
                this.elementSelected.push(Character[("character_element_" + _local_2)]);
            };
        }

        public function removeSelectedSkill(_arg_1:MouseEvent):*
        {
            this.selectedSkill = [];
            this.elementSelected = [];
            this.panelMC.panel.ResetTypeMc.resetTypeIcon.btnLearnSkill1.gotoAndStop(1);
            this.panelMC.panel.ResetTypeMc.resetTypeIcon.btnLearnSkill2.gotoAndStop(1);
            this.panelMC.panel.ResetTypeMc.resetTypeIcon.btnLearnSkill3.gotoAndStop(1);
        }

        public function resetAmf(_arg_1:MouseEvent):*
        {
            var _local_2:* = this.panelMC.panel.confirmationMc.txt_reset.text;
            if (_local_2 == "RESET")
            {
                this.main.loading(true);
                this.main.amf_manager.service("CharacterService.resetElements", [Character.char_id, Character.sessionkey, this.elementSelected], this.resetElement);
            }
            else
            {
                if (_local_2 != "RESET")
                {
                    this.main.giveMessage("Wrong Input! Must Type RESET in Uppercase");
                    return;
                };
            };
        }

        public function resetElement(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.getNotice("Your Element Has Resetted");
                Character.resetBattleInfo(this.main);
                this.main.removeAllChildsFromLoader();
                this.main.removeAllLoadedPanels();
                this.main.loadPanel("Panels.CharacterSelect");
                this.destroy();
            }
            else
            {
                if (_arg_1.status == 0)
                {
                    this.main.giveMessage("Please Select Element First!");
                    return;
                };
                this.main.getError(_arg_1.error);
            };
        }

        public function getMaterial():*
        {
            var _local_1:* = undefined;
            var _local_2:Array = [];
            if (Character.character_materials != "")
            {
                if (Character.character_materials.indexOf(",") >= 0)
                {
                    _local_2 = Character.character_materials.split(",");
                }
                else
                {
                    _local_2 = [Character.character_materials];
                };
            };
            var _local_3:* = 0;
            while (_local_3 < _local_2.length)
            {
                if ((_local_1 = _local_2[_local_3].split(":"))[0] == "material_1001")
                {
                    return (_local_1[1]);
                };
                _local_3++;
            };
            return (0);
        }

        public function buyMaterial(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.buyGanMaterial", [Character.sessionkey, Character.char_id, this.quantity], this.buyMaterialRes);
        }

        public function buyMaterialRes(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.giveMessage((this.quantity + " Essence Gan Succesfully Bought!"));
                this.panelMC.panel.essenceSkillTxt.text = _arg_1.gan;
                this.panelMC.panel.tokenTxt.text = (int(Character.account_tokens) - this.cost);
                Character.addMaterials(("material_1001:" + _arg_1.gan));
                Character.account_tokens = (Character.account_tokens - this.cost);
                this.loadBasicData();
            }
            else
            {
                if (_arg_1.status == 2)
                {
                    this.main.giveMessage("You Don't Have Enough Token");
                    return;
                };
                this.main.getError(_arg_1.error);
            };
        }


    }
}//package id.ninjasage.features

