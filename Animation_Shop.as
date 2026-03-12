// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.Animation_Shop

package Panels
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Popups.Confirmation;
    import Storage.AnimationLibrary;
    import Managers.OutfitManager;
    import Storage.Character;
    import Managers.NinjaSage;
    import flash.events.MouseEvent;
    import com.utils.GF;

    public dynamic class Animation_Shop extends MovieClip 
    {

        public var panelMC:MovieClip;
        private var selectedAnimData:Object;
        private var categoryData:Array;
        private var currentTab:String;
        private var currentPage:int = 1;
        private var totalPage:int = 1;
        private var response:Object;
        private var main:*;
        private var eventHandler:EventHandler;
        private var confirmation:Confirmation;

        private var outfits:Array = [];
        private var animationShopData:Object = {
            "standby":AnimationLibrary.getCategory("standby"),
            "dodge":AnimationLibrary.getCategory("dodge"),
            "win":AnimationLibrary.getCategory("win"),
            "dead":AnimationLibrary.getCategory("dead")
        };
        private var tabButtons:Array = ["standby", "dodge", "win", "dead"];

        public function Animation_Shop(_arg_1:*)
        {
            this.main = _arg_1;
            this.eventHandler = new EventHandler();
            this.initUI();
        }

        private function initUI():void
        {
            var _local_2:OutfitManager;
            this.initTabButtons();
            this.panelMC[("btn_" + this.tabButtons[0])].gotoAndStop(3);
            this.categoryData = this.animationShopData[this.tabButtons[0]];
            this.currentTab = this.tabButtons[0];
            this.currentPage = 1;
            this.totalPage = Math.ceil((this.categoryData.length / 8));
            if (!Character.is_stickman)
            {
                _local_2 = new OutfitManager();
                _local_2.fillOutfit(this.panelMC.char_mc, Character.character_weapon, Character.character_back_item, Character.character_set, Character.character_hair, Character.character_face, Character.character_color_hair, Character.character_color_skin);
                this.outfits.push(_local_2);
            };
            var _local_1:String = AnimationLibrary.getAnimation(Character.equipped_animations[this.currentTab]).label;
            NinjaSage.addStandByFrameScript(this.panelMC.char_mc, _local_1);
            this.panelMC.char_mc.gotoAndPlay(_local_1);
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btn_getGold, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.panelMC.btn_getToken, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.panelMC.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btn_prev, MouseEvent.CLICK, this.changePage);
            this.panelMC.txt_gold.text = Character.character_gold;
            this.panelMC.txt_token.text = Character.account_tokens;
            this.updatePageText();
            this.renderAnimationList();
        }

        private function renderAnimationList():void
        {
            var _local_2:int;
            var _local_1:int;
            while (_local_1 < 8)
            {
                _local_2 = (_local_1 + int((int((this.currentPage - 1)) * 8)));
                this.panelMC[("anim_" + _local_1)].visible = false;
                if (this.categoryData.length > _local_2)
                {
                    this.panelMC[("anim_" + _local_1)].visible = true;
                    this.panelMC[("anim_" + _local_1)].emblemMC.visible = false;
                    this.panelMC[("anim_" + _local_1)].equippedTxt.visible = false;
                    this.panelMC[("anim_" + _local_1)].pose.gotoAndStop(this.categoryData[_local_2].label);
                    this.panelMC[("anim_" + _local_1)].metaData = {"animation_data":this.categoryData[_local_2]};
                    this.eventHandler.addListener(this.panelMC[("anim_" + _local_1)].clickmask, MouseEvent.CLICK, this.onPlayAnimation);
                    NinjaSage.showDynamicTooltip(this.panelMC[("anim_" + _local_1)].clickmask, this.categoryData[_local_2].name);
                    if (this.categoryData[_local_2].premium)
                    {
                        this.panelMC[("anim_" + _local_1)].emblemMC.visible = true;
                    };
                    if ((((this.categoryData[_local_2].price > 0) && (this.categoryData[_local_2].buyable)) && (!(this.hasAnimation(this.categoryData[_local_2].id)))))
                    {
                        this.panelMC[("anim_" + _local_1)].btn_buy.visible = true;
                        this.panelMC[("anim_" + _local_1)].btn_equip.visible = false;
                        this.panelMC[("anim_" + _local_1)].overlay.visible = true;
                        this.main.initButton(this.panelMC[("anim_" + _local_1)].btn_buy, this.buyConfirmation, this.categoryData[_local_2].price);
                    }
                    else
                    {
                        if ((((this.categoryData[_local_2].price == 0) && (!(this.categoryData[_local_2].buyable))) && (!(this.hasAnimation(this.categoryData[_local_2].id)))))
                        {
                            this.panelMC[("anim_" + _local_1)].btn_buy.visible = false;
                            this.panelMC[("anim_" + _local_1)].overlay.visible = true;
                            this.panelMC[("anim_" + _local_1)].btn_equip.visible = false;
                        }
                        else
                        {
                            this.panelMC[("anim_" + _local_1)].btn_buy.visible = false;
                            this.panelMC[("anim_" + _local_1)].overlay.visible = false;
                            if (((this.hasAnimation(this.categoryData[_local_2].id)) && (Character.equipped_animations[this.currentTab] == this.categoryData[_local_2].id)))
                            {
                                this.panelMC[("anim_" + _local_1)].equippedTxt.visible = true;
                                this.panelMC[("anim_" + _local_1)].btn_equip.visible = false;
                            }
                            else
                            {
                                this.panelMC[("anim_" + _local_1)].btn_equip.visible = true;
                                this.panelMC[("anim_" + _local_1)].equippedTxt.visible = false;
                                this.eventHandler.addListener(this.panelMC[("anim_" + _local_1)].btn_equip, MouseEvent.CLICK, this.onEquipAnimation);
                            };
                        };
                    };
                };
                _local_1++;
            };
        }

        private function onPlayAnimation(_arg_1:MouseEvent):void
        {
            var _local_3:Object;
            var _local_2:Object = _arg_1.currentTarget.parent.metaData.animation_data;
            if (((_local_2.hasOwnProperty("loop")) && (_local_2.loop)))
            {
                NinjaSage.addStandByFrameScript(this.panelMC.char_mc, _local_2.label);
            }
            else
            {
                _local_3 = NinjaSage.getLabelFrames(this.panelMC.char_mc, _local_2.label);
                this.panelMC.char_mc.addFrameScript((_local_3.end - 1), this.stopAnimation);
            };
            this.panelMC.char_mc.gotoAndPlay(_local_2.label);
        }

        private function stopAnimation():void
        {
            this.panelMC.char_mc.stop();
        }

        private function buyConfirmation(e:MouseEvent):void
        {
            this.selectedAnimData = e.currentTarget.parent.metaData.animation_data;
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (((("Are you sure want to buy " + this.selectedAnimData.name) + " animation for ") + this.selectedAnimData.price) + " tokens?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function (_arg_1:MouseEvent):*
            {
                GF.removeAllChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onBuyAnimation);
            this.panelMC.addChild(this.confirmation);
        }

        private function onBuyAnimation(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.confirmation);
            if (((Character.account_type == 0) && (this.selectedAnimData.premium)))
            {
                this.openRecharge(_arg_1);
                return;
            };
            if (Character.account_tokens < this.selectedAnimData.price)
            {
                this.main.showMessage("You don't have enough tokens to buy this animation");
                return;
            };
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.buyAnimation", [Character.char_id, Character.sessionkey, this.selectedAnimData.id], this.buyResponse);
        }

        private function buyResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.character_animations = (Character.character_animations + ("," + this.selectedAnimData.id));
                Character.account_tokens = (Character.account_tokens - this.selectedAnimData.price);
                this.panelMC.txt_gold.text = Character.character_gold;
                this.panelMC.txt_token.text = Character.account_tokens;
                this.main.HUD.setBasicData();
                this.renderAnimationList();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function onEquipAnimation(_arg_1:MouseEvent):void
        {
            this.selectedAnimData = _arg_1.currentTarget.parent.metaData.animation_data;
            this.main.loading(true);
            this.main.amf_manager.service("CharacterService.useAnimation", [Character.char_id, Character.sessionkey, this.selectedAnimData.id], this.equipResponse);
        }

        private function equipResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.equipped_animations[this.currentTab] = this.selectedAnimData.id;
                this.renderAnimationList();
            }
            else
            {
                this.main.showMessage(((_arg_1.hasOwnProperty("result")) ? _arg_1.result : "Unknown Error"));
            };
        }

        private function hasAnimation(_arg_1:String):Boolean
        {
            return (!(Character.character_animations.indexOf(_arg_1) == -1));
        }

        private function updatePageText():void
        {
            this.panelMC.txt_page.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function changePage(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.renderAnimationList();
                    };
                    break;
                case "btn_prev":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.renderAnimationList();
                    };
            };
            this.updatePageText();
        }

        private function initTabButtons():void
        {
            var _local_1:int;
            while (_local_1 < this.tabButtons.length)
            {
                this.panelMC[("btn_" + this.tabButtons[_local_1])].gotoAndStop(1);
                NinjaSage.showDynamicTooltip(this.panelMC[("btn_" + this.tabButtons[_local_1])], NinjaSage.capitalizeFirstLetter(this.tabButtons[_local_1]));
                this.eventHandler.addListener(this.panelMC[("btn_" + this.tabButtons[_local_1])], MouseEvent.MOUSE_OVER, this.onTabButtonOver);
                this.eventHandler.addListener(this.panelMC[("btn_" + this.tabButtons[_local_1])], MouseEvent.MOUSE_OUT, this.onTabButtonOut);
                this.eventHandler.addListener(this.panelMC[("btn_" + this.tabButtons[_local_1])], MouseEvent.CLICK, this.onTabButtonClick);
                _local_1++;
            };
        }

        private function onTabButtonOver(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame != 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        private function onTabButtonOut(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame != 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
        }

        private function onTabButtonClick(_arg_1:MouseEvent):void
        {
            this.initTabButtons();
            _arg_1.currentTarget.gotoAndStop(3);
            this.currentTab = _arg_1.currentTarget.name.replace("btn_", "");
            this.categoryData = this.animationShopData[this.currentTab];
            this.currentPage = 1;
            this.totalPage = Math.ceil((this.categoryData.length / 8));
            this.renderAnimationList();
            this.updatePageText();
        }

        private function openRecharge(_arg_1:MouseEvent):void
        {
            if ((_arg_1.currentTarget.name == "btn_getGold"))
            {
                this.main.loadExternalSwfPanel("Headquarter", "Headquarter");
            }
            else
            {
                this.main.loadPanel("Panels.Recharge");
            };
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            GF.destroyArray(this.outfits);
            this.outfits = [];
            this.animationShopData = null;
            this.categoryData = null;
            this.tabButtons = null;
            this.currentTab = null;
            this.currentPage = null;
            this.totalPage = null;
            this.confirmation = null;
            this.selectedAnimData = null;
            this.main = null;
            GF.removeAllChild(this.panelMC.char_mc);
            GF.removeAllChild(this);
            this.panelMC = null;
        }


    }
}//package Panels

