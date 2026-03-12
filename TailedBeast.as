// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.TailedBeast

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import com.abrahamyan.liquid.ToolTip;
    import br.com.stimuli.loading.BulkLoader;
    import Storage.GameData;
    import id.ninjasage.EventHandler;
    import flash.display.Loader;
    import flash.events.Event;
    import Storage.PetInfo;
    import flash.events.MouseEvent;
    import flash.utils.getDefinitionByName;
    import Storage.Character;
    import com.utils.GF;
    import flash.system.System;

    public dynamic class TailedBeast extends MovieClip 
    {

        public var btn_buy:SimpleButton;
        public var item_5:MovieClip;
        public var item_6:MovieClip;
        public var item_7:MovieClip;
        public var item_8:MovieClip;
        public var item_9:MovieClip;
        public var item_0:MovieClip;
        public var item_1:MovieClip;
        public var item_2:MovieClip;
        public var item_3:MovieClip;
        public var item_4:MovieClip;
        public var pet_mc:MovieClip;
        public var priceMC:MovieClip;
        public var pet_name:TextField;
        public var pet_desc:TextField;
        public var pet_gendesc:TextField;
        public var btn_close:SimpleButton;
        public var btn_petshop:SimpleButton;
        public var btn_recharge:SimpleButton;
        public var skill_1:MovieClip;
        public var skill_2:MovieClip;
        public var skill_3:MovieClip;
        public var skill_4:MovieClip;
        public var skill_5:MovieClip;
        public var skill_6:MovieClip;
        public var main:*;
        public var tooltip:ToolTip;
        public var curr_page:int = 1;
        public var pets:Array = [];
        public var pets_cost:Array = [];
        public var pet_mcs:Array;
        public var pet_icons:Array;
        public var pet_info:Array;
        public var pet_skills_mcs:Array;
        public var array_info_holder:Array;
        public var selected_pet_index:int = -1;
        public var selected_pet_slot_index:int = -1;
        public var display_pet_number:int = 0;
        private var confirmation:*;
        private var self:TailedBeast;
        private var eventHandler:*;
        private var loaderSwf:BulkLoader;

        public function TailedBeast(_arg_1:*)
        {
            var _local_2:* = GameData.get("tailed_beast");
            var _local_3:int;
            while (_local_3 < _local_2.pets.length)
            {
                this.pets.push(_local_2.pets[_local_3].id);
                this.pets_cost.push(_local_2.pets[_local_3].price);
                _local_3++;
            };
            this.pet_mcs = [];
            this.pet_info = [];
            this.pet_skills_mcs = [];
            this.array_info_holder = [];
            this.pet_icons = [];
            super();
            this.main = _arg_1;
            this.eventHandler = new EventHandler();
            this.loaderSwf = BulkLoader.getLoader("assets");
            this.main.handleVillageHUDVisibility(false);
            this.main.loading(true);
            this.self = this;
            this.init();
        }

        public function init():*
        {
            this.tooltip = ToolTip.getInstance();
            this.display_pet_number = 0;
            this.curr_page = 1;
            this.setupButtons();
            this.setupSlots();
            this.setupSkills();
            this.displayPets();
        }

        public function displayPets(param1:*=0):*
        {
            var pet_swf:* = undefined;
            var holder:* = undefined;
            var loadItem:* = undefined;
            pet_swf = undefined;
            holder = undefined;
            var loader:Loader;
            var display_pet_nr:* = param1;
            if (display_pet_nr == 0)
            {
                this.pet_mcs = [];
                this.pet_info = [];
                this.pet_icons = [];
                this.pet_skills_mcs = [];
                this.array_info_holder = [];
            };
            var cp:* = (display_pet_nr + ((int(this.curr_page) - 1) * 3));
            if (this.pets.length > cp)
            {
                pet_swf = this.pets[cp];
                holder = this[("item_" + cp)];
                this.crframe = 0;
                addEventListener(Event.ENTER_FRAME, this.checkLoading);
                loadItem = this.loaderSwf.add((("pets/" + pet_swf) + ".swf"));
                loadItem.addEventListener(BulkLoader.COMPLETE, function (_arg_1:Event):*
                {
                    petLoaded(_arg_1, pet_swf, holder);
                });
                this.loaderSwf.start();
            }
            else
            {
                this.onSelectPet(0);
                this.main.loading(false);
            };
        }

        public function checkLoading(_arg_1:Event):*
        {
            this.crframe++;
            if (this.crframe > 5)
            {
                removeEventListener(Event.ENTER_FRAME, this.checkLoading);
                this.displayPets(this.display_pet_number);
            };
        }

        public function petLoaded(param1:*, param2:*, param3:*):void
        {
            var pskills:Array;
            var c_array_info_holder:Array;
            pskills = null;
            var csk_mc:* = undefined;
            c_array_info_holder = null;
            var info:* = undefined;
            var e:* = param1;
            var pet_swf:* = param2;
            var holder:* = param3;
            removeEventListener(Event.ENTER_FRAME, this.checkLoading);
            var butn:* = e.target.content["PetStaticFullBody"];
            butn.scaleX = 1.8;
            butn.scaleY = 1.8;
            var head:* = e.target.content["icon"];
            this.pet_icons.push(head);
            holder.visible = true;
            this.pet_mcs.push(butn);
            var pet_infos:* = PetInfo.getPetStats(pet_swf);
            this.pet_info.push(pet_infos);
            pskills = [];
            c_array_info_holder = [];
            info = PetInfo.getPetStats(pet_swf);
            var s:* = 0;
            while (s < 6)
            {
                try
                {
                    csk_mc = e.target.content[("Skill_" + s)];
                    if (info)
                    {
                        pskills.push(csk_mc);
                        c_array_info_holder.push([info.attacks[s].name, info.attacks[s].level, info.attacks[s].description, info.attacks[s].cooldown]);
                    }
                    else
                    {
                        pskills.push(null);
                        c_array_info_holder.push([null, null, null]);
                    };
                }
                catch(e)
                {
                    pskills.push(null);
                    c_array_info_holder.push([null, null, null]);
                };
                s++;
            };
            if (e.target.content[pet_swf])
            {
                e.target.content[pet_swf].gotoAndStop(1);
            };
            this.array_info_holder.push(c_array_info_holder);
            this.pet_skills_mcs.push(pskills);
            this.display_pet_number++;
            this.displayPets(this.display_pet_number);
        }

        internal function openRecharge(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Recharge");
        }

        internal function openPetShop(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.PetShop");
        }

        public function setupSlots(_arg_1:Boolean=true):*
        {
            var _local_2:* = 0;
            while (_local_2 < 10)
            {
                if (_arg_1)
                {
                    this.eventHandler.addListener(this[("item_" + _local_2)], MouseEvent.CLICK, this.onSelectPet);
                };
                _local_2++;
            };
        }

        public function onSelectPet(_arg_1:*=null):*
        {
            var _local_3:*;
            if (this.selected_pet_slot_index != -1)
            {
                this[("item_" + this.selected_pet_slot_index)];
            };
            if ((_arg_1 is MouseEvent))
            {
                this.selected_pet_slot_index = int(_arg_1.currentTarget.name.replace("item_", ""));
            }
            else
            {
                this.selected_pet_slot_index = _arg_1;
            };
            this.selected_pet_index = (this.selected_pet_slot_index + int((int((this.curr_page - 1)) * 4)));
            this.pet_name.text = this.pet_info[this.selected_pet_index].pet_name;
            this.pet_desc.text = this.pet_info[this.selected_pet_index].description;
            this.pet_gendesc.text = (((("The Legendary Pet - " + this.pet_info[this.selected_pet_index].pet_name) + " Has Been Unleashed in the Fire Village!\nGet ") + this.pet_info[this.selected_pet_index].pet_name) + " Now and Unleash Its Full Power!");
            if (this.pet_info[this.selected_pet_index].pet_name == "Slebew")
            {
                this.btn_buy.visible = false;
                this.priceMC.visible = false;
                this.btn_recharge.visible = true;
                this.eventHandler.addListener(this.btn_recharge, MouseEvent.CLICK, this.openRecharge);
            }
            else
            {
                if (this.pet_info[this.selected_pet_index].pet_name == "Jyubi")
                {
                    this.btn_buy.visible = false;
                    this.priceMC.visible = false;
                    this.btn_recharge.visible = false;
                }
                else
                {
                    this.btn_buy.visible = true;
                    this.priceMC.visible = true;
                };
            };
            if (this.pet_mc.numChildren > 0)
            {
                this.pet_mc.removeChildAt(0);
            };
            this.pet_mc.addChild(this.pet_mcs[this.selected_pet_index]);
            var _local_2:* = 1;
            while (_local_2 < 7)
            {
                this[("skill_" + _local_2)].gotoAndStop(1);
                if (this[("skill_" + _local_2)].numChildren == 6)
                {
                    this[("skill_" + _local_2)].removeChildAt(5);
                };
                if (this.pet_skills_mcs[this.selected_pet_index][(_local_2 - 1)] != null)
                {
                    this[("skill_" + _local_2)].addChild(this.pet_skills_mcs[this.selected_pet_index][(_local_2 - 1)]);
                };
                _local_2++;
            };
            if ((_local_3 = this.pets_cost[this.selected_pet_index]).indexOf("token_") >= 0)
            {
                this.priceMC.gotoAndStop(2);
                this.priceMC.txt_token.text = _local_3.split("_")[1];
            }
            else
            {
                this.priceMC.gotoAndStop(1);
                this.priceMC.txt_gold.text = _local_3.split("_")[1];
            };
        }

        public function setupSkills():*
        {
            var _local_1:* = 1;
            while (_local_1 < 7)
            {
                this[("skill_" + _local_1)].gotoAndStop(1);
                if (this[("skill_" + _local_1)].numChildren == 6)
                {
                    this[("skill_" + _local_1)].removeChildAt(5);
                };
                this.eventHandler.addListener(this[("skill_" + _local_1)], MouseEvent.MOUSE_OUT, this.onOutPetSkill, false, 0, true);
                this.eventHandler.addListener(this[("skill_" + _local_1)], MouseEvent.MOUSE_OVER, this.onOverPetSkill, false, 0, true);
                _local_1++;
            };
        }

        public function onOverPetSkill(_arg_1:MouseEvent):*
        {
            var _local_2:* = undefined;
            var _local_3:* = (int(_arg_1.currentTarget.name.replace("skill_", "")) - 1);
            if ((((this.array_info_holder.length > this.selected_pet_index) && (this.array_info_holder[this.selected_pet_index].length > _local_3)) && (!(this.array_info_holder[this.selected_pet_index][_local_3][0] == null))))
            {
                _local_2 = (((((((("" + this.array_info_holder[this.selected_pet_index][_local_3][0]) + "\n(Skill)\n") + "\nLevel: ") + this.array_info_holder[this.selected_pet_index][_local_3][1]) + "\nCooldown:") + this.array_info_holder[this.selected_pet_index][_local_3][3]) + "\n\n") + this.array_info_holder[this.selected_pet_index][_local_3][2]);
                stage.addChild(this.tooltip);
                this.tooltip.followMouse = true;
                this.tooltip.fixedWidth = 350;
                this.tooltip.multiLine = true;
                this.tooltip.show(_local_2);
            };
        }

        public function onOutPetSkill(_arg_1:MouseEvent):*
        {
            this.tooltip.hide();
        }

        public function setupButtons():*
        {
            this.btn_recharge.visible = false;
            this.eventHandler.addListener(this.btn_buy, MouseEvent.CLICK, this.buyConfirmation);
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
        }

        public function onClosePop(_arg_1:MouseEvent):*
        {
            if (this.popup != null)
            {
                this.popup.visible = false;
                this.popup = false;
            };
        }

        protected function buyConfirmation(e:MouseEvent):*
        {
            this.confirmation = (getDefinitionByName("Popups.Confirmation") as Class);
            this.confirmation = new this.confirmation();
            this.confirmation.txtMc.txt.text = (("Are you sure want to buy " + this.pet_info[this.selected_pet_index].pet_name) + "?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function (_arg_1:MouseEvent):*
            {
                removeChild(self.confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onBuyAMF);
            addChild(this.confirmation);
        }

        public function onBuyAMF(_arg_1:MouseEvent):*
        {
            removeChild(this.confirmation);
            this.main.loading(true);
            var _local_2:Array = [Character.char_id, Character.sessionkey, this.pets[this.selected_pet_index]];
            this.main.amf_manager.service("PetService.executeService", ["buyPet", _local_2], this.onBuyAMFResponse);
        }

        public function onBuyAMFResponse(_arg_1:Object):*
        {
            var _local_2:* = undefined;
            this.main.loading(false);
            if (_arg_1.status > 0)
            {
                if (_arg_1.status > 1)
                {
                    this.main.getNotice(_arg_1.result);
                    return;
                };
                this.main.giveReward(1, this.pets[this.selected_pet_index]);
                if ((_local_2 = this.pets_cost[this.selected_pet_index]).indexOf("token_") >= 0)
                {
                    Character.account_tokens = (Character.account_tokens - int(_local_2.split("_")[1]));
                }
                else
                {
                    Character.character_gold = String((Number(Character.character_gold) - int(_local_2.split("_")[1])));
                };
                this.main.HUD.setBasicData();
            }
            else
            {
                this.main.getError(_arg_1.error);
            };
        }

        public function closePanel(_arg_1:MouseEvent=null):*
        {
            this.main.handleVillageHUDVisibility(true);
            this.main.HUD.setBasicData();
            this.tooltip.destroy();
            this.eventHandler.removeAllEventListeners();
            this.loaderSwf.removeAll();
            this.pets = [];
            this.pets_cost = [];
            this.eventHandler = null;
            this.tooltip = null;
            this.main = null;
            this.loaderSwf = null;
            this.self = null;
            GF.removeAllChild(this);
            System.gc();
        }


    }
}//package Panels

