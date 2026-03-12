// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.PetVilla

package Panels
{
    import flash.display.MovieClip;
    import com.abrahamyan.liquid.ToolTip;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import Storage.Character;
    import com.utils.GF;
    import Managers.NinjaSage;
    import Popups.Confirmation;
    import Managers.ExpManager;
    import id.ninjasage.Log;
    import flash.system.System;

    public dynamic class PetVilla extends MovieClip 
    {

        public var panel:MovieClip;
        public var main:*;
        public var tooltip:ToolTip;
        public var all_pets:Array;
        public var filtered_pets:Array;
        public var curr_page:int = 1;
        public var total_page:int = 1;
        public var selected_pet_index:int = -1;
        public var selected_pet_slot_index:int = -1;
        public var crframe:* = 0;
        public var display_pet_number:int = 0;
        public var slots:Array;
        private var trainPetSlot1:PetTraining;
        private var trainPetSlot2:PetTraining;
        private var trainPetSlot3:PetTraining;
        private var trainPetSlot4:PetTraining;
        private var trainPetSlotArr:Array;
        public var trained_pet:*;
        public var skipPrice:int = 0;
        public var confirmation:*;
        private var buySlotMethod:String;

        public var eventHandler:* = new EventHandler();
        public var pets:Array = [];
        public var array_info_holder:Array = [];

        public function PetVilla(_arg_1:*)
        {
            this.pet_mcs = [];
            super();
            this.trainPetSlot1 = new PetTraining();
            this.trainPetSlot2 = new PetTraining();
            this.trainPetSlot3 = new PetTraining();
            this.trainPetSlot4 = new PetTraining();
            this.trainPetSlotArr = [this.trainPetSlot1, this.trainPetSlot2, this.trainPetSlot3, this.trainPetSlot4];
            this.main = _arg_1;
            this.setDefaultUI();
        }

        public function setDefaultUI():*
        {
            this.main.handleVillageHUDVisibility(false);
            this.panel.popUpUnlockMC.visible = false;
            this.panel.popUpCompleteMC.visible = false;
            this.panel.heyaDarenMC.visible = false;
            this.panel.btnHide.tick.visible = true;
            this.eventHandler.addListener(this.panel.btnClose, MouseEvent.CLICK, this.onClose, false, 0, true);
            this.eventHandler.addListener(this.panel.btnPrevPage, MouseEvent.CLICK, this.changePage, false, 0, true);
            this.eventHandler.addListener(this.panel.btnNextPage, MouseEvent.CLICK, this.changePage, false, 0, true);
            this.eventHandler.addListener(this.panel.btnHide, MouseEvent.CLICK, this.hideMaxLevelPets, false, 0, true);
            this.main.initButton(this.panel.convertBtn, this.openRecharge);
            this.main.initButton(this.panel.getMoreBtn, this.openRecharge);
            this.init();
        }

        public function init():*
        {
            this.panel.goldTxt.text = String(Character.character_gold);
            this.panel.tokenTxt.text = String(Character.account_tokens);
            this.panel.titleTxt.text = "Pet Villa";
            this.getPets();
        }

        public function getPets():*
        {
            this.main.loading(true);
            var _local_1:Array = [Character.char_id, Character.sessionkey];
            this.main.amf_manager.service("PetService.executeService", ["getVillaData", _local_1], this.onGetPets);
        }

        public function onGetPets(_arg_1:Object):*
        {
            var _local_2:*;
            this.main.loading(false);
            if (_arg_1.status > 0)
            {
                if (_arg_1.status > 1)
                {
                    this.main.getNotice(_arg_1.result);
                    return;
                };
                this.slots = _arg_1.slots;
                this.all_pets = _arg_1.pets;
                this.filtered_pets = [];
                _local_2 = 0;
                while (_local_2 < this.all_pets.length)
                {
                    if (this.all_pets[_local_2].pet_level < Character.character_lvl)
                    {
                        this.filtered_pets.push(this.all_pets[_local_2]);
                    };
                    _local_2++;
                };
                this.pets = ((this.panel.btnHide.tick.visible) ? this.filtered_pets : this.all_pets);
                this.curr_page = 1;
                this.total_page = Math.ceil((this.pets.length / 6));
                this.displayPets();
                this.displaySlots();
                this.updatePageText();
            }
            else
            {
                this.main.getError(_arg_1.error);
            };
        }

        private function hideMaxLevelPets(_arg_1:MouseEvent):void
        {
            this.panel.btnHide.tick.visible = (!(this.panel.btnHide.tick.visible));
            this.pets = ((this.panel.btnHide.tick.visible) ? this.filtered_pets : this.all_pets);
            this.curr_page = 1;
            this.total_page = Math.ceil((this.pets.length / 6));
            this.displayPets();
            this.updatePageText();
        }

        public function findPet(_arg_1:int):*
        {
            var _local_2:* = 0;
            while (_local_2 < this.pets.length)
            {
                if (this.pets[_local_2].pet_id == _arg_1)
                {
                    return (this.pets[_local_2]);
                };
                _local_2++;
            };
            return (null);
        }

        public function displaySlots():*
        {
            var _local_2:*;
            var _local_3:uint;
            var _local_1:* = 0;
            while (_local_1 < 4)
            {
                if (this.slots[_local_1].status == 0)
                {
                    this.panel[("roomMC_" + _local_1)].gotoAndStop("lock");
                    this.panel[("roomMC_" + _local_1)].readyTxt.text = "Slot Locked";
                    this.main.initButton(this.panel[("roomMC_" + _local_1)].functionBtn, this.buySlotPopup, "Buy Slot");
                }
                else
                {
                    if (this.slots[_local_1].status == 1)
                    {
                        this.panel[("roomMC_" + _local_1)].gotoAndStop("waiting");
                    }
                    else
                    {
                        if (this.slots[_local_1].status == 2)
                        {
                            _local_2 = this.findPet(this.slots[_local_1].pet_id);
                            if (_local_2 == null)
                            {
                                _local_1++;
                                continue;
                            };
                            this.panel[("roomMC_" + _local_1)].gotoAndStop("normal");
                            GF.removeAllChild(this.panel[("roomMC_" + _local_1)].iconHolder);
                            NinjaSage.loadIconSWF("pets", _local_2.pet_swf, this.panel[("roomMC_" + _local_1)].iconHolder, "PetStaticFullBody");
                            this.panel[("roomMC_" + _local_1)].petNameTxt.text = _local_2.pet_name;
                            this.panel[("roomMC_" + _local_1)].lvMC.txt.text = _local_2.pet_level;
                            _local_3 = this.getTrainData((_local_2.pet_level + 1), "second");
                            this.panel[("roomMC_" + _local_1)].functionBtn.metaData = {
                                "pet_id":this.slots[_local_1].pet_id,
                                "skip_price":this.slots[_local_1].skip_price
                            };
                            this.panel[("roomMC_" + _local_1)].cancelBtn.metaData = {"pet_id":this.slots[_local_1].pet_id};
                            this.main.initButton(this.panel[("roomMC_" + _local_1)].functionBtn, this.skipTrainingConfirmation, "Skip");
                            this.main.initButton(this.panel[("roomMC_" + _local_1)].cancelBtn, this.cancelTrainingConfirmation, "Cancel");
                            this.trainPetSlotArr[_local_1].startTimer(_local_2.pet_id, this["panel"][("roomMC_" + _local_1)], this.slots[_local_1].completed_at, _local_3, this.onTrainPetTick, this.onTrainPetComplete);
                        }
                        else
                        {
                            if (this.slots[_local_1].status == 3)
                            {
                                _local_2 = this.findPet(this.slots[_local_1].pet_id);
                                if (_local_2 == null)
                                {
                                    _local_1++;
                                    continue;
                                };
                                this.panel[("roomMC_" + _local_1)].gotoAndStop("done");
                                GF.removeAllChild(this.panel[("roomMC_" + _local_1)].iconHolder);
                                NinjaSage.loadIconSWF("pets", _local_2.pet_swf, this.panel[("roomMC_" + _local_1)].iconHolder, "PetStaticFullBody");
                                this.panel[("roomMC_" + _local_1)].functionBtn.visible = true;
                                this.panel[("roomMC_" + _local_1)].petNameTxt.text = _local_2.pet_name;
                                this.panel[("roomMC_" + _local_1)].lvMC.txt.text = _local_2.pet_level;
                                this.panel[("roomMC_" + _local_1)].functionBtn.metaData = {"pet_id":this.slots[_local_1].pet_id};
                                this.main.initButton(this.panel[("roomMC_" + _local_1)].functionBtn, this.onCheckoutPet, "OK");
                            }
                            else
                            {
                                this.panel[("roomMC_" + _local_1)].gotoAndStop("lock");
                                this.panel[("roomMC_" + _local_1)].readyTxt.text = "Slot Locked";
                            };
                        };
                    };
                };
                _local_1++;
            };
        }

        public function skipTrainingConfirmation(e:MouseEvent):*
        {
            this.skipPrice = e.currentTarget.metaData.skip_price;
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (("Are you sure to checkout this pet early, it costs " + this.skipPrice) + " tokens ?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():*
            {
                removeChild(confirmation);
            });
            this.confirmation.btn_confirm.metaData = {"pet_id":e.currentTarget.metaData.pet_id};
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.skipTraining);
            addChild(this.confirmation);
        }

        public function skipTraining(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            var _local_2:Array = [Character.char_id, Character.sessionkey, _arg_1.currentTarget.metaData.pet_id];
            this.main.amf_manager.service("PetService.executeService", ["skipTraining", _local_2], this.onSkipTrain);
        }

        public function onSkipTrain(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                Character.account_tokens = (Character.account_tokens - this.skipPrice);
                this.init();
                this.main.HUD.setBasicData();
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

        public function cancelTrainingConfirmation(e:MouseEvent):*
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure to cancel pet training? gold spent will not returned";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():*
            {
                removeChild(confirmation);
            });
            this.confirmation.btn_confirm.metaData = {"pet_id":e.currentTarget.metaData.pet_id};
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.cancelTraining);
            addChild(this.confirmation);
        }

        public function cancelTraining(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            var _local_2:Array = [Character.char_id, Character.sessionkey, _arg_1.currentTarget.metaData.pet_id];
            this.main.amf_manager.service("PetService.executeService", ["cancelTraining", _local_2], this.onCancelTrain);
        }

        public function onCancelTrain(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                this.init();
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

        public function onError(_arg_1:*):*
        {
        }

        public function displayPets(_arg_1:*=null):*
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:String;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:Boolean;
            var _local_10:Boolean;
            var _local_11:int;
            while (_local_11 < 6)
            {
                _local_2 = (_local_11 + int((int((this.curr_page - 1)) * 6)));
                if (this.pets.length > _local_2)
                {
                    this.panel[("petMC_" + _local_11)].gotoAndStop("normal");
                    this.panel[("petMC_" + _local_11)].visible = true;
                    GF.removeAllChild(this.panel[("petMC_" + _local_11)].iconHolder);
                    NinjaSage.loadIconSWF("pets", this.pets[_local_2].pet_swf, this.panel[("petMC_" + _local_11)].iconHolder, "PetStaticFullBody");
                    this.panel[("petMC_" + _local_11)].nameTxt.text = this.pets[_local_2].pet_name;
                    this.panel[("petMC_" + _local_11)].lvMC.txt.text = this.pets[_local_2].pet_level;
                    _local_3 = this.pets[_local_2].pet_level;
                    if (_local_3 >= int(Character.character_lvl))
                    {
                        this.panel[("petMC_" + _local_11)].lvCapTxt.visible = true;
                        this.panel[("petMC_" + _local_11)].lvCapTxt.text = "Max. Reached";
                        this.panel[("petMC_" + _local_11)].trainTimeTxt.visible = false;
                        this.panel[("petMC_" + _local_11)].hourTxt.visible = false;
                        this.panel[("petMC_" + _local_11)].lvMC1.visible = false;
                        this.panel[("petMC_" + _local_11)].lvMC2.visible = false;
                        this.panel[("petMC_" + _local_11)].arrowMc.visible = false;
                        this.panel[("petMC_" + _local_11)].trainBtn.visible = false;
                        this.panel[("petMC_" + _local_11)].xpMC.xpTxt.text = ((this.pets[_local_2].pet_xp + "/") + ExpManager.calculate_pet_xp(int(_local_3)));
                        this.panel[("petMC_" + _local_11)].xpMC.xpBar.scaleX = (this.pets[_local_2].pet_xp / ExpManager.calculate_pet_xp(int(_local_3)));
                    }
                    else
                    {
                        this.panel[("petMC_" + _local_11)].lvCapTxt.visible = false;
                        this.panel[("petMC_" + _local_11)].trainTimeTxt.visible = true;
                        this.panel[("petMC_" + _local_11)].hourTxt.visible = true;
                        this.panel[("petMC_" + _local_11)].lvMC1.visible = true;
                        this.panel[("petMC_" + _local_11)].lvMC2.visible = true;
                        this.panel[("petMC_" + _local_11)].arrowMc.visible = true;
                        this.panel[("petMC_" + _local_11)].trainBtn.visible = true;
                        this.panel[("petMC_" + _local_11)].lvMC1.txt.text = _local_3;
                        this.panel[("petMC_" + _local_11)].lvMC2.txt.text = (int(_local_3) + 1);
                        this.panel[("petMC_" + _local_11)].xpMC.xpTxt.text = ((this.pets[_local_2].pet_xp + "/") + ExpManager.calculate_pet_xp(int(_local_3)));
                        this.panel[("petMC_" + _local_11)].xpMC.xpBar.scaleX = (this.pets[_local_2].pet_xp / ExpManager.calculate_pet_xp(int(_local_3)));
                        this.panel[("petMC_" + _local_11)].hourTxt.text = this.pets[_local_2].train_time_text;
                        this.panel[("petMC_" + _local_11)].trainBtn.metaData = {"pet_id":this.pets[_local_2].pet_id};
                        this.main.initButton(this.panel[("petMC_" + _local_11)].trainBtn, this.onClickTrainPet, this.pets[_local_2].train_gold);
                    };
                }
                else
                {
                    this.panel[("petMC_" + _local_11)].gotoAndStop("noPet");
                    this.main.initButton(this.panel[("petMC_" + _local_11)].buyPetBtn, this.openPetShop, "Buy a Pet");
                };
                _local_11++;
            };
        }

        public function onClickTrainPet(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            var _local_2:Array = [Character.char_id, Character.sessionkey, _arg_1.currentTarget.metaData.pet_id];
            this.main.amf_manager.service("PetService.executeService", ["trainPet", _local_2], this.trainPetResponse);
        }

        public function trainPetResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                this.init();
            }
            else
            {
                if (_arg_1.status == 0)
                {
                    this.main.getError(_arg_1.error);
                }
                else
                {
                    this.main.showMessage(_arg_1.result);
                    return;
                };
            };
        }

        public function onCheckoutPet(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.trained_pet = _arg_1.currentTarget.metaData.pet_id;
            var _local_2:Array = [Character.char_id, Character.sessionkey, _arg_1.currentTarget.metaData.pet_id];
            this.main.amf_manager.service("PetService.executeService", ["checkoutPet", _local_2], this.checkoutPetResponse);
        }

        public function checkoutPetResponse(_arg_1:Object):*
        {
            var _local_2:*;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.panel.popUpCompleteMC.panel.lvCapMC.visible = false;
                _local_2 = this.findPet(this.trained_pet);
                this.panel.popUpCompleteMC.visible = true;
                GF.removeAllChild(this.panel.popUpCompleteMC.panel.iconHolder);
                NinjaSage.loadIconSWF("pets", _local_2.pet_swf, this.panel.popUpCompleteMC.panel.iconHolder, "PetStaticFullBody");
                this.panel.popUpCompleteMC.panel.titleTxt.text = "Training Completed";
                this.panel.popUpCompleteMC.panel.displayTxt.text = "Your pet's training is completed";
                this.panel.popUpCompleteMC.panel.petNameTxt.text = _local_2.pet_name;
                this.panel.popUpCompleteMC.panel.lvMC.txt.text = (_local_2.pet_level + 1);
                if (_local_2.pet_level >= Character.character_lvl)
                {
                    this.panel.popUpCompleteMC.panel.lvCapMC.visible = true;
                };
                this.main.initButton(this.panel.popUpCompleteMC.panel.okBtn, this.closePopupComplete, "OK");
            }
            else
            {
                if (_arg_1.status == 0)
                {
                    this.main.getError(_arg_1.error);
                }
                else
                {
                    this.main.showMessage(_arg_1.result);
                    return;
                };
            };
        }

        public function buySlotPopup(_arg_1:MouseEvent):*
        {
            this.panel.popUpUnlockMC.visible = true;
            var _local_2:MovieClip = this.panel.popUpUnlockMC.panel;
            _local_2.titleTxt.text = "Buy Room Slot";
            _local_2.displayTxt.text = "You can buy slot using token, friendship kunai or buy emblem to instantly unlock all room";
            _local_2.inviteFdBtn.visible = false;
            _local_2.fkMC.visible = false;
            _local_2.typeMC_0.gotoAndStop("token");
            _local_2.typeMC_0.typeTxt.text = "Token";
            this.main.initButton(_local_2.typeMC_0.itemTokenBtn, this.onBuySlot, "400");
            _local_2.typeMC_1.gotoAndStop("fk");
            _local_2.typeMC_1.typeTxt.text = "Friendship Kunai";
            this.main.initButton(_local_2.typeMC_1.itemFKBtn, this.onBuySlot, "300");
            _local_2.typeMC_2.gotoAndStop("emblem");
            _local_2.typeMC_2.typeTxt.text = "Ninja Emblem";
            this.main.initButton(_local_2.typeMC_2.itemEmblemBtn, this.openRecharge, "Get Now!");
            this.eventHandler.addListener(_local_2.btnClose, MouseEvent.CLICK, this.closePopup, false, 0, true);
        }

        public function onBuySlot(_arg_1:MouseEvent):void
        {
            var _local_2:String;
            switch (_arg_1.currentTarget.name)
            {
                case "itemTokenBtn":
                    _local_2 = "tokens";
                    break;
                case "itemFKBtn":
                    _local_2 = "kunai";
                    break;
                default:
                    return;
            };
            this.buySlotMethod = _local_2;
            var _local_3:Array = [Character.char_id, Character.sessionkey, _local_2];
            this.main.loading(true);
            this.main.amf_manager.service("PetService.executeService", ["unlockSlots", _local_3], this.onBuyAMFResponse);
        }

        public function onBuyAMFResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage("Slot Succesfully Unlocked!");
                if ((this.buySlotMethod == "tokens"))
                {
                    Character.account_tokens = (Character.account_tokens - 400);
                }
                else
                {
                    Character.removeMaterials("material_1002", 300);
                };
                this.init();
            }
            else
            {
                if (_arg_1.status == 0)
                {
                    this.main.getError(_arg_1.error);
                }
                else
                {
                    this.main.showMessage(_arg_1.result);
                    return;
                };
            };
        }

        public function changePage(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btnNextPage":
                    if (this.total_page > this.curr_page)
                    {
                        this.curr_page++;
                        this.displayPets();
                    };
                    break;
                case "btnPrevPage":
                    if (this.curr_page > 1)
                    {
                        this.curr_page--;
                        this.displayPets();
                    };
            };
            this.updatePageText();
        }

        public function updatePageText():*
        {
            this.panel.pageTxt.text = ((this.curr_page + "/") + this.total_page);
        }

        internal function openRecharge(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Recharge");
        }

        internal function openSocial(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Social");
        }

        internal function openPetShop(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.PetShop");
            this.onClose(null);
        }

        public function closePopup(_arg_1:MouseEvent):*
        {
            this.panel.popUpUnlockMC.visible = false;
        }

        public function closePopupComplete(_arg_1:MouseEvent):*
        {
            this.panel.popUpCompleteMC.visible = false;
            this.init();
        }

        public function onClose(_arg_1:MouseEvent):*
        {
            this.main.handleVillageHUDVisibility(true);
            this.main.HUD.setBasicData();
            var _local_2:* = 0;
            var _local_3:* = 0;
            while (_local_2 < 4)
            {
                GF.removeAllChild(this.panel[("roomMC_" + _local_2)].iconHolder);
                _local_2++;
            };
            while (_local_3 < 6)
            {
                GF.removeAllChild(this.panel[("petMC_" + _local_3)].iconHolder);
                _local_3++;
            };
            GF.removeAllChild(this.panel.popUpCompleteMC.panel.iconHolder);
            parent.removeChild(this);
            this.eventHandler.removeAllEventListeners();
            NinjaSage.clearLoader();
            if (this.tooltip)
            {
                this.tooltip.destroy();
            };
            GF.destroyArray(this.trainPetSlotArr);
            GF.removeAllChild(this.panel);
            GF.clearArray(this.pets);
            GF.clearArray(this.array_info_holder);
            GF.clearArray(this.slots);
            this.trainPetSlotArr = null;
            this.tooltip = null;
            this.main = null;
            this.pets = null;
            this.array_info_holder = null;
            this.slots = null;
            this.eventHandler = null;
            Log.debug(this, "DESTROY");
            System.gc();
        }

        private function getTrainData(_arg_1:uint, _arg_2:String):*
        {
            if (_arg_2 == "second")
            {
                return (Number(((_arg_1 - 1) * 1440)));
            };
            if (_arg_2 == "gold")
            {
                return ((_arg_1 - 1) * 2000);
            };
            return (0);
        }

        private function onTrainPetTick(_arg_1:int):void
        {
            if (!this.slots)
            {
                return;
            };
            var _local_2:* = 0;
            while (_local_2 < this.slots.length)
            {
                if (this.slots[_local_2].pet_id == _arg_1)
                {
                    this.slots[_local_2].completed_at--;
                };
                _local_2++;
            };
        }

        private function onTrainPetComplete(_arg_1:int):void
        {
            this.slots[_arg_1].status = 3;
            this.clearAllTrainPetSlot();
            this.displaySlots();
        }

        private function clearAllTrainPetSlot():void
        {
            var _local_1:uint;
            while (_local_1 < this.trainPetSlotArr.length)
            {
                this.trainPetSlotArr[_local_1].stopTimer();
                _local_1++;
            };
        }


    }
}//package Panels

