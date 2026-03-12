// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.PetCombination

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import br.com.stimuli.loading.BulkLoader;
    import com.abrahamyan.liquid.ToolTip;
    import Storage.PetInfo;
    import Storage.Character;
    import flash.events.MouseEvent;
    import flash.events.ErrorEvent;
    import com.utils.GF;
    import Managers.NinjaSage;
    import flash.events.Event;
    import flash.utils.setTimeout;
    import flash.geom.ColorTransform;
    import flash.utils.clearTimeout;

    public dynamic class PetCombination extends MovieClip 
    {

        private const BOOST_PRICE:int = 500;
        private const REQUIRED_LEVEL:int = 30;
        private const REQUIRED_MP:int = 100;

        public var panelMC:MovieClip;
        private var eventHandler:EventHandler;
        private var main:*;
        private var loaderSwf:BulkLoader = BulkLoader.createUniqueNamedLoader(12);
        private var tooltip:ToolTip;
        private var response:Object;
        private var combineResponse:Object;
        private var petList:Object;
        private var combinablePet:Array = PetInfo.getCombinePet();
        private var ownedPet:Array = [];
        private var currentPage:int = 1;
        private var totalPage:int = 1;
        private var petIndex:int = 0;
        private var petLoading:int = 0;
        private var petCount:int = 0;
        private var combinePrice:int = 0;
        private var currentSide:int;
        private var selectedPetLeft:Object = {};
        private var selectedPetRight:Object = {};
        private var isLoading:Boolean = false;
        private var timeout:*;

        public function PetCombination(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.tooltip = ToolTip.getInstance();
            this.panelMC.popupCombineFailed.visible = false;
            this.panelMC.popupCombineSuccess.visible = false;
            this.panelMC.popupMessageMc.visible = false;
            this.panelMC.popupSelectPet.visible = false;
            this.getData();
        }

        private function getData():void
        {
            this.main.loading(true);
            this.main.amf_manager.service("PetCombination.getData", [Character.char_id, Character.sessionkey], this.onGetEventData);
        }

        private function onGetEventData(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.response = _arg_1;
                this.updateTimeLeft();
                this.initUI();
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

        private function initUI():void
        {
            this.eventHandler.addListener(this.panelMC.btnClose, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btn_change_icon0, MouseEvent.CLICK, this.getPetList);
            this.eventHandler.addListener(this.panelMC.btn_change_icon1, MouseEvent.CLICK, this.getPetList);
            this.eventHandler.addListener(this.panelMC.combine_btn_mc, MouseEvent.CLICK, this.openCombineConfirmation);
            this.eventHandler.addListener(this.panelMC.reward_list_btn, MouseEvent.CLICK, this.openRewards);
            this.eventHandler.addListener(this.panelMC.successUpBtn, MouseEvent.CLICK, this.openBoostConfirmation);
            this.eventHandler.addListener(this.panelMC.getMoreBtn, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.panelMC.convertBtn, MouseEvent.CLICK, this.openRecharge);
            this.panelMC.combine_btn_mc.visible = false;
            this.panelMC.goldTxt.text = Character.character_gold;
            this.panelMC.tokenTxt.text = Character.account_tokens;
            this.panelMC.txt_required_gold.text = 0;
            this.panelMC.txt_required_token.text = this.BOOST_PRICE;
            if (this.response.boost > 0)
            {
                this.panelMC.successUpBtn.visible = false;
            };
        }

        private function getPetList(_arg_1:MouseEvent):void
        {
            this.currentSide = _arg_1.currentTarget.name.replace("btn_change_icon", "");
            this.main.loading(true);
            this.main.amf_manager.service("PetService.executeService", ["getPets", [Character.char_id, Character.sessionkey]], this.onGetPets);
        }

        private function onGetPets(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.panelMC.popupSelectPet.visible = true;
                this.petList = _arg_1.pets.sort(this.sortPetsByMPandLevel);
                this.initPetData();
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

        private function sortPetsByMPandLevel(_arg_1:Object, _arg_2:Object):int
        {
            if (_arg_1.pet_mp > _arg_2.pet_mp)
            {
                return (-1);
            };
            if (_arg_1.pet_mp < _arg_2.pet_mp)
            {
                return (1);
            };
            if (_arg_1.pet_level > _arg_2.pet_level)
            {
                return (-1);
            };
            if (_arg_1.pet_level < _arg_2.pet_level)
            {
                return (1);
            };
            return (0);
        }

        private function initPetData():void
        {
            this.eventHandler.addListener(this.panelMC.popupSelectPet.panel.btnClose, MouseEvent.CLICK, this.closePetList);
            this.eventHandler.addListener(this.panelMC.popupSelectPet.panel.btnConfirm, MouseEvent.CLICK, this.confirmPetSelect);
            this.eventHandler.addListener(this.panelMC.popupSelectPet.panel.btnPrevPage, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.popupSelectPet.panel.btnNextPage, MouseEvent.CLICK, this.changePage);
            var _local_1:int;
            while (_local_1 < this.petList.length)
            {
                if (this.combinablePet.indexOf(this.petList[_local_1].pet_swf) > -1)
                {
                    this.ownedPet.push(this.petList[_local_1]);
                };
                _local_1++;
            };
            this.currentPage = 1;
            this.totalPage = Math.ceil((this.ownedPet.length / 4));
            this.updatePageNumber();
            this.resetRecursiveProperty();
            this.resetIconHolder();
            this.loadPetSwf();
        }

        public function loadPetSwf():void
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            this.isLoading = true;
            if (this.petIndex < this.petLoading)
            {
                _local_1 = this.ownedPet[this.petIndex].pet_swf;
                _local_2 = (("pets/" + _local_1) + ".swf");
                _local_3 = this.loaderSwf.add(_local_2);
                _local_3.addEventListener(BulkLoader.COMPLETE, this.completeIcon);
                _local_3.addEventListener(BulkLoader.ERROR, this.onItemLoadError);
                this.loaderSwf.start();
            }
            else
            {
                this.isLoading = false;
                return;
            };
        }

        public function onItemLoadError(_arg_1:ErrorEvent):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.COMPLETE, this.completeIcon);
            this.petIndex++;
            this.petCount++;
            this.loadPetSwf();
        }

        public function completeIcon(_arg_1:Event):void
        {
            var _local_10:Array;
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.ERROR, this.onItemLoadError);
            var _local_3:int;
            while (_local_3 < 6)
            {
                GF.removeAllChild(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)][("skill_" + _local_3)].holder);
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)][("skill_" + _local_3)].tooltip = null;
                _local_3++;
            };
            GF.removeAllChild(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].iconMc_0.rewardIcon.iconHolder);
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].selectedMc.visible = false;
            var _local_4:MovieClip;
            var _local_5:Class;
            var _local_6:MovieClip;
            _local_4 = _arg_1.target.content["icon"];
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].iconMc_0.skillIcon.visible = false;
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].iconMc_0.rewardIcon.iconHolder.addChild(_local_4);
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].visible = true;
            var _local_7:* = this.ownedPet[this.petIndex].pet_swf;
            if (_arg_1.target.content[_local_7])
            {
                _arg_1.target.content[_local_7].gotoAndStop(1);
            };
            var _local_8:* = PetInfo.getPetStats(_local_7);
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].pet_name.text = this.ownedPet[this.petIndex].pet_name;
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].current_lvl.text = this.ownedPet[this.petIndex].pet_level;
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].current_gp.text = this.ownedPet[this.petIndex].pet_mp;
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].required_lvl.text = this.REQUIRED_LEVEL;
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].required_gp.text = this.REQUIRED_MP;
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].tick_0.visible = false;
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].tick_1.visible = false;
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].cross_0.visible = false;
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].cross_1.visible = false;
            if (this.ownedPet[this.petIndex].pet_level >= this.REQUIRED_LEVEL)
            {
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].tick_0.visible = true;
            }
            else
            {
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].cross_0.visible = true;
            };
            if (int(this.ownedPet[this.petIndex].pet_mp) >= this.REQUIRED_MP)
            {
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].tick_1.visible = true;
            }
            else
            {
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].cross_1.visible = true;
            };
            NinjaSage.showDynamicTooltip(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].pet_name, this.ownedPet[this.petIndex].pet_name);
            NinjaSage.showDynamicTooltip(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].iconMc_0, _local_8.pet_name);
            if (this.currentSide == 0)
            {
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].pet_selected.text = ((this.selectedPetRight.pet_id == this.ownedPet[this.petIndex].pet_id) ? "Selected" : "");
            }
            else
            {
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].pet_selected.text = ((this.selectedPetLeft.pet_id == this.ownedPet[this.petIndex].pet_id) ? "Selected" : "");
            };
            var _local_9:int;
            while (_local_9 < _local_8["attacks"].length)
            {
                _local_6 = _arg_1.target.content[("Skill_" + _local_9)];
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)][(("skill_" + _local_9) + "_lvTxt")].text = _local_8.attacks[_local_9].level;
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)][("skill_" + _local_9)].gotoAndStop("enable");
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)][("skill_" + _local_9)].holder.addChild(_local_6);
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)][("skill_" + _local_9)].tooltip = _local_8;
                this.eventHandler.addListener(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)][("skill_" + _local_9)], MouseEvent.ROLL_OVER, this.onOverPetSkill);
                this.eventHandler.addListener(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)][("skill_" + _local_9)], MouseEvent.ROLL_OUT, this.onOutPetSkill);
                _local_10 = this.ownedPet[this.petIndex].pet_skills.split(",");
                if (_local_10[_local_9] == 0)
                {
                    this.applyColorEffect(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)][("skill_" + _local_9)], 0.4, 0.4, 0.4);
                };
                _local_9++;
            };
            if (((this.ownedPet[this.petIndex].pet_level >= this.REQUIRED_LEVEL) && (this.ownedPet[this.petIndex].pet_mp >= this.REQUIRED_MP)))
            {
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)].pet_data = this.ownedPet[this.petIndex];
                this.eventHandler.addListener(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)], MouseEvent.CLICK, this.selectPet);
            }
            else
            {
                this.eventHandler.addListener(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + this.petCount)], MouseEvent.CLICK, this.selectPetError);
            };
            this.petIndex++;
            this.petCount++;
            this.loadPetSwf();
        }

        private function onOverPetSkill(_arg_1:MouseEvent):void
        {
            var _local_2:int = _arg_1.currentTarget.name.replace("skill_", "");
            var _local_3:String = (((((((("" + _arg_1.currentTarget.tooltip.attacks[_local_2].name) + "\n(Skill)\n") + "\nLevel: ") + _arg_1.currentTarget.tooltip.attacks[_local_2].level) + '\n<font color="#ffcc00">Cooldown: ') + _arg_1.currentTarget.tooltip.attacks[_local_2].cooldown) + "</font>\n\n") + _arg_1.currentTarget.tooltip.attacks[_local_2].description);
            this.main.stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_3);
        }

        private function onOutPetSkill(_arg_1:MouseEvent):void
        {
            this.tooltip.hide();
        }

        private function selectPetError(_arg_1:MouseEvent):*
        {
            this.main.showMessage("Pet is not mature enough");
        }

        private function selectPet(_arg_1:MouseEvent):void
        {
            var _local_2:int = _arg_1.currentTarget.name.replace("pet_selectInnerFrame", "");
            var _local_3:* = 0;
            while (_local_3 < 4)
            {
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_3)].selectedMc.visible = false;
                _local_3++;
            };
            if (this.currentSide == 0)
            {
                this.selectedPetLeft = _arg_1.currentTarget.pet_data;
            }
            else
            {
                this.selectedPetRight = _arg_1.currentTarget.pet_data;
            };
            this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_2)].selectedMc.visible = true;
        }

        private function confirmPetSelect(_arg_1:MouseEvent):void
        {
            if (this.currentSide == 0)
            {
                if (this.selectedPetLeft.pet_swf == null)
                {
                    this.main.showMessage("Please select a pet");
                    return;
                };
                if (this.selectedPetLeft.pet_id == this.selectedPetRight.pet_id)
                {
                    this.main.showMessage("Cannot select same pet to combine");
                    return;
                };
                this.eventHandler.addListener(this.panelMC.iconMc_0.petIcon, MouseEvent.ROLL_OVER, this.onOverTooltipSelectedPet);
                this.eventHandler.addListener(this.panelMC.iconMc_0.petIcon, MouseEvent.ROLL_OUT, this.onOutPetSkill);
                NinjaSage.loadIconSWF("pets", this.selectedPetLeft.pet_swf, this.panelMC.iconMc_0.petIcon.iconHolder, "icon");
            }
            else
            {
                if (this.selectedPetRight.pet_swf == null)
                {
                    this.main.showMessage("Please select a pet");
                    return;
                };
                if (this.selectedPetLeft.pet_id == this.selectedPetRight.pet_id)
                {
                    this.main.showMessage("Cannot select same pet to combine");
                    return;
                };
                this.eventHandler.addListener(this.panelMC.iconMc_1.petIcon, MouseEvent.ROLL_OVER, this.onOverTooltipSelectedPet);
                this.eventHandler.addListener(this.panelMC.iconMc_1.petIcon, MouseEvent.ROLL_OUT, this.onOutPetSkill);
                NinjaSage.loadIconSWF("pets", this.selectedPetRight.pet_swf, this.panelMC.iconMc_1.petIcon.iconHolder, "icon");
            };
            if (((!(this.selectedPetLeft.pet_swf == null)) && (!(this.selectedPetRight.pet_swf == null))))
            {
                this.panelMC.combine_btn_mc.visible = true;
            };
            var _local_2:int = PetInfo.getPetStats(this.selectedPetLeft.pet_swf).pet_combine_gold;
            var _local_3:int = PetInfo.getPetStats(this.selectedPetRight.pet_swf).pet_combine_gold;
            this.combinePrice = int((_local_2 + _local_3));
            this.panelMC.txt_required_gold.text = this.combinePrice;
            this.closePetList(null);
        }

        private function openCombineConfirmation(_arg_1:MouseEvent):void
        {
            this.panelMC.popupMessageMc.visible = true;
            this.eventHandler.addListener(this.panelMC.popupMessageMc.panel.btnClose, MouseEvent.CLICK, this.closeConfirmation);
            this.eventHandler.addListener(this.panelMC.popupMessageMc.panel.btn_cancel_mc, MouseEvent.CLICK, this.closeConfirmation);
            this.eventHandler.addListener(this.panelMC.popupMessageMc.panel.btn_ok_mc, MouseEvent.CLICK, this.combineAMF);
            this.panelMC.popupMessageMc.panel.decTxt.text = "If the combination process fails, the selected Pets and half of the Maturity Point (MP) will be returned.";
        }

        private function combineAMF(_arg_1:MouseEvent):void
        {
            this.closeConfirmation(null);
            this.main.loading(true);
            this.main.amf_manager.service("PetCombination.combinePet", [Character.char_id, Character.sessionkey, this.selectedPetLeft.pet_id, this.selectedPetRight.pet_id], this.combineAMFResponse);
        }

        private function combineAMFResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.combineResponse = _arg_1;
                Character.character_gold = String((Number(Character.character_gold) - Number(this.combinePrice)));
                this.main.HUD.setBasicData();
                if (!_arg_1.success)
                {
                    this.openCombineFailed();
                }
                else
                {
                    this.openCombineSuccess(_arg_1.pets);
                };
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

        private function closeConfirmation(_arg_1:MouseEvent):void
        {
            this.panelMC.popupMessageMc.visible = false;
            this.panelMC.popupMessageMc.panel.decTxt.text = "";
            this.eventHandler.removeListener(this.panelMC.popupMessageMc.panel.btnClose, MouseEvent.CLICK, this.closeConfirmation);
            this.eventHandler.removeListener(this.panelMC.popupMessageMc.panel.btn_cancel_mc, MouseEvent.CLICK, this.closeConfirmation);
            this.eventHandler.removeListener(this.panelMC.popupMessageMc.panel.btn_ok_mc, MouseEvent.CLICK, this.combineAMF);
            this.eventHandler.removeListener(this.panelMC.popupMessageMc.panel.btn_ok_mc, MouseEvent.CLICK, this.boostAMF);
        }

        private function openCombineFailed():void
        {
            this.panelMC.popupCombineFailed.visible = true;
            this.panelMC.popupCombineFailed.panel.titleTxt.text = "Combination Failed";
            this.panelMC.popupCombineFailed.panel.failTxt_0.text = (("-" + int((this.selectedPetLeft.pet_mp / 2))) + " MP");
            this.panelMC.popupCombineFailed.panel.failTxt_1.text = (("-" + int((this.selectedPetRight.pet_mp / 2))) + " MP");
            NinjaSage.loadIconSWF("pets", this.selectedPetLeft.pet_swf, this.panelMC.popupCombineFailed.panel.IconMc_0.rewardIcon.iconHolder, "icon");
            NinjaSage.loadIconSWF("pets", this.selectedPetRight.pet_swf, this.panelMC.popupCombineFailed.panel.IconMc_1.rewardIcon.iconHolder, "icon");
            this.eventHandler.addListener(this.panelMC.popupCombineFailed.panel.btnOk, MouseEvent.CLICK, this.closeCombineFailed);
        }

        private function closeCombineFailed(_arg_1:MouseEvent):void
        {
            this.panelMC.popupCombineFailed.visible = false;
            GF.removeAllChild(this.panelMC.popupCombineFailed.panel.IconMc_0.rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupCombineFailed.panel.IconMc_1.rewardIcon.iconHolder);
            this.eventHandler.removeListener(this.panelMC.popupCombineFailed.panel.btnOk, MouseEvent.CLICK, this.closeCombineFailed);
            this.clearCombine();
        }

        private function openCombineSuccess(_arg_1:String):void
        {
            this.panelMC.popupCombineSuccess.visible = true;
            this.panelMC.popupCombineSuccess.panel.titleTxt.text = "Combination Success";
            NinjaSage.loadItemIcon(this.panelMC.popupCombineSuccess.panel.IconMc.rewardIcon.iconHolder, _arg_1, "icon");
            this.eventHandler.addListener(this.panelMC.popupCombineSuccess.panel.btnOk, MouseEvent.CLICK, this.closeCombineSuccess);
        }

        private function closeCombineSuccess(_arg_1:MouseEvent):void
        {
            this.panelMC.popupCombineSuccess.visible = false;
            GF.removeAllChild(this.panelMC.popupCombineSuccess.panel.IconMc.rewardIcon.iconHolder);
            this.eventHandler.removeListener(this.panelMC.popupCombineSuccess.panel.btnOk, MouseEvent.CLICK, this.closeCombineSuccess);
            this.clearCombine();
        }

        private function clearCombine():void
        {
            this.panelMC.combine_btn_mc.visible = false;
            this.panelMC.txt_required_gold.text = 0;
            this.panelMC.goldTxt.text = Character.character_gold;
            this.panelMC.tokenTxt.text = Character.account_tokens;
            this.selectedPetLeft = {};
            this.selectedPetRight = {};
            GF.removeAllChild(this.panelMC.iconMc_0.petIcon.iconHolder);
            GF.removeAllChild(this.panelMC.iconMc_1.petIcon.iconHolder);
            this.eventHandler.removeListener(this.panelMC.iconMc_0.petIcon, MouseEvent.ROLL_OVER, this.onOverTooltipSelectedPet);
            this.eventHandler.removeListener(this.panelMC.iconMc_0.petIcon, MouseEvent.ROLL_OUT, this.onOutPetSkill);
            this.eventHandler.removeListener(this.panelMC.iconMc_1.petIcon, MouseEvent.ROLL_OVER, this.onOverTooltipSelectedPet);
            this.eventHandler.removeListener(this.panelMC.iconMc_1.petIcon, MouseEvent.ROLL_OUT, this.onOutPetSkill);
        }

        private function openBoostConfirmation(_arg_1:MouseEvent):void
        {
            this.panelMC.popupMessageMc.visible = true;
            this.eventHandler.addListener(this.panelMC.popupMessageMc.panel.btnClose, MouseEvent.CLICK, this.closeConfirmation);
            this.eventHandler.addListener(this.panelMC.popupMessageMc.panel.btn_cancel_mc, MouseEvent.CLICK, this.closeConfirmation);
            this.eventHandler.addListener(this.panelMC.popupMessageMc.panel.btn_ok_mc, MouseEvent.CLICK, this.boostAMF);
            this.panelMC.popupMessageMc.panel.decTxt.text = "Increase the combine rate? The boosted combine rate lasts for 3 hours.";
        }

        private function boostAMF(_arg_1:MouseEvent):void
        {
            this.closeConfirmation(null);
            this.main.loading(true);
            this.main.amf_manager.service("PetCombination.boostRate", [Character.char_id, Character.sessionkey], this.boostAMFResponse);
        }

        private function boostAMFResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                this.panelMC.successUpBtn.visible = false;
                Character.account_tokens = (Character.account_tokens - this.BOOST_PRICE);
                this.response.boost = _arg_1.boost;
                this.main.HUD.setBasicData();
                this.updateTimeLeft();
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

        private function onOverTooltipSelectedPet(_arg_1:MouseEvent):void
        {
            var _local_2:int = _arg_1.currentTarget.parent.name.replace("iconMc_", "");
            var _local_3:Object = ((_local_2 == 0) ? this.selectedPetLeft : this.selectedPetRight);
            var _local_4:String = ((((("" + _local_3.pet_name) + "\n\nLevel ") + _local_3.pet_level) + "\n\nMP ") + _local_3.pet_mp);
            stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_4);
        }

        private function closePetList(_arg_1:MouseEvent):void
        {
            var _local_3:int;
            this.panelMC.popupSelectPet.visible = false;
            this.ownedPet = [];
            this.currentPage = 1;
            var _local_2:int;
            while (_local_2 < 4)
            {
                _local_3 = 0;
                while (_local_3 < 6)
                {
                    GF.removeAllChild(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_2)][("skill_" + _local_3)].holder);
                    this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_2)][("skill_" + _local_3)].tooltip = null;
                    _local_3++;
                };
                GF.removeAllChild(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_2)].iconMc_0.rewardIcon.iconHolder);
                _local_2++;
            };
        }

        private function changePage(_arg_1:MouseEvent):void
        {
            if (this.isLoading)
            {
                return;
            };
            switch (_arg_1.currentTarget.name)
            {
                case "btnNextPage":
                    if (this.currentPage >= this.totalPage)
                    {
                        return;
                    };
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                    };
                    break;
                case "btnPrevPage":
                    if (this.currentPage <= 1)
                    {
                        return;
                    };
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                    };
                    break;
            };
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            this.loadPetSwf();
        }

        public function resetRecursiveProperty():void
        {
            this.petLoading = (this.currentPage * 4);
            if (this.ownedPet.length < this.petLoading)
            {
                this.petLoading = this.ownedPet.length;
            };
            this.petIndex = ((this.currentPage - 1) * 4);
            this.petCount = 0;
        }

        public function resetIconHolder():void
        {
            var _local_2:int;
            this.skillIconMC = [];
            var _local_1:* = 0;
            while (_local_1 < 4)
            {
                GF.removeAllChild(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)].iconMc_0.rewardIcon.iconHolder);
                NinjaSage.clearDynamicTooltip(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)].pet_name);
                NinjaSage.clearDynamicTooltip(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)].iconMc_0);
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)].visible = false;
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)].gotoAndStop(1);
                this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)].tooltip = null;
                this.eventHandler.removeListener(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)], MouseEvent.CLICK, this.selectPet);
                this.eventHandler.removeListener(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)], MouseEvent.CLICK, this.selectPetError);
                _local_2 = 0;
                while (_local_2 < 6)
                {
                    GF.removeAllChild(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)][("skill_" + _local_2)].holder);
                    this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)][("skill_" + _local_2)].tooltip = null;
                    this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)][(("skill_" + _local_2) + "_lvTxt")].text = "";
                    this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)][("skill_" + _local_2)].gotoAndStop("disable");
                    this.eventHandler.removeListener(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)][("skill_" + _local_2)], MouseEvent.ROLL_OVER, this.onOverPetSkill);
                    this.eventHandler.removeListener(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)][("skill_" + _local_2)], MouseEvent.ROLL_OUT, this.onOutPetSkill);
                    this.applyColorEffect(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)][("skill_" + _local_2)], 1, 1, 1);
                    _local_2++;
                };
                GF.removeAllChild(this.panelMC.popupSelectPet.panel[("pet_selectInnerFrame" + _local_1)].iconMc_0.rewardIcon.iconHolder);
                _local_1++;
            };
        }

        private function updatePageNumber():void
        {
            this.panelMC.popupSelectPet.panel.pageTxt.text = ((this.currentPage + "/") + this.totalPage);
        }

        public function updateTimeLeft():void
        {
            if (this.response.boost == null)
            {
                return;
            };
            var _local_1:* = 86400;
            var _local_2:* = 3600;
            var _local_3:* = 60;
            var _local_4:* = this.response.boost;
            var _local_5:* = Math.floor((_local_4 / _local_1));
            var _local_6:* = Math.floor(((_local_4 - (_local_5 * _local_1)) / _local_2));
            var _local_7:* = Math.floor((((_local_4 - (_local_5 * _local_1)) - (_local_6 * _local_2)) / _local_3));
            this.panelMC.timeTxt.text = ((((_local_5 + ":") + _local_6) + ":") + _local_7);
            this.timeout = setTimeout(this.updateTimeLeft, 10000);
            this.response.boost = (this.response.boost - 10);
        }

        public function applyColorEffect(_arg_1:MovieClip, _arg_2:Number, _arg_3:Number, _arg_4:Number):void
        {
            var _local_5:ColorTransform = new ColorTransform(_arg_2, _arg_3, _arg_4, 1, 1, 1, 1, 0);
            _arg_1.transform.colorTransform = _local_5;
        }

        private function openRewards(_arg_1:MouseEvent):void
        {
            this.main.loadExternalSwfPanel("DragonHuntReward", "DragonHuntReward");
        }

        private function openRecharge(_arg_1:MouseEvent):void
        {
            if ((_arg_1.currentTarget.name == "getMoreBtn"))
            {
                this.main.loadPanel("Panels.Recharge");
            }
            else
            {
                this.main.loadExternalSwfPanel("Headquarter", "Headquarter");
            };
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            if (this.timeout)
            {
                clearTimeout(this.timeout);
            };
            if (this.tooltip)
            {
                this.tooltip.destroy();
                this.tooltip = null;
            };
            this.loaderSwf.clear();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.clearCombine();
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.combinablePet = [];
            this.ownedPet = [];
            this.selectedPetLeft = null;
            this.selectedPetRight = null;
            this.loaderSwf = null;
            this.main = null;
            this.eventHandler = null;
            this.petList = null;
            this.selectedPet = null;
            this.response = null;
            this.combineResponse = null;
            GF.removeAllChild(this.panelMC);
        }


    }
}//package id.ninjasage.features

