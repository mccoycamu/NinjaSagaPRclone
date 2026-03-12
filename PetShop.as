// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.PetShop

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import br.com.stimuli.loading.BulkLoader;
    import com.abrahamyan.liquid.ToolTip;
    import Popups.Confirmation;
    import Managers.PreviewManager;
    import Storage.GameData;
    import Storage.Character;
    import flash.events.MouseEvent;
    import flash.events.ErrorEvent;
    import Storage.PetInfo;
    import flash.events.Event;
    import com.utils.GF;
    import id.ninjasage.Util;
    import Managers.NinjaSage;

    public class PetShop extends MovieClip 
    {

        public var panelMC:MovieClip;
        public var preview:MovieClip;
        public var buyGold:SimpleButton;
        public var buyTokens:SimpleButton;
        public var txt_title:TextField;
        public var txt_gold:TextField;
        public var txt_token:TextField;
        public var eventHandler:EventHandler;
        private var petData:Array;
        private var petDataOriginal:Array;
        private var petInfo:Object;
        private var loaderSwf:BulkLoader;
        private var itemIndex:int = 0;
        private var itemLoading:int = 0;
        private var itemCount:int = 0;
        private var currentPage:int = 1;
        private var totalPage:int = 1;
        private var selectedPetIndex:int = -1;
        private var isLoading:Boolean;
        private var firstLoad:Boolean = true;
        private var petIconMCArray:Array;
        private var petStaticMCArray:Array;
        private var petSkillIconMCArray:Array;
        public var tooltip:ToolTip;
        public var confirmation:Confirmation;
        public var petMCPreview:PreviewManager;
        private var main:*;

        public function PetShop(_arg_1:*)
        {
            var _local_2:* = GameData.get("pet_shop");
            this.petData = [];
            this.petDataOriginal = [];
            this.petIconMCArray = [];
            this.petSkillIconMCArray = [];
            this.petStaticMCArray = [];
            this.petMCPreview = null;
            var _local_3:int;
            while (_local_3 < _local_2.pets.length)
            {
                this.petData.push({
                    "petId":_local_2.pets[_local_3].id,
                    "petPrice":_local_2.pets[_local_3].price
                });
                this.petDataOriginal.push({
                    "petId":_local_2.pets[_local_3].id,
                    "petPrice":_local_2.pets[_local_3].price
                });
                _local_3++;
            };
            this.gotoAndStop(1);
            this.addFrameScript(23, this.stopEntrance);
            this.main = _arg_1;
            this.tooltip = ToolTip.getInstance();
            this.loaderSwf = BulkLoader.createUniqueNamedLoader(9);
            this.eventHandler = new EventHandler();
            this.main.loading(true);
            this.initUI();
            this.initButton();
        }

        private function initUI():void
        {
            this.main.handleVillageHUDVisibility(false);
            this.totalPage = Math.max(Math.ceil((this.petData.length / 9)), 1);
            this.panelMC.txt_goToPage.restrict = "0-9";
            this.txt_gold.text = Character.character_gold;
            this.txt_token.text = String(Character.account_tokens);
            this.panelMC.txt_goToPage.visible = false;
            this.panelMC.btn_to_page.visible = false;
            this.updatePageNumber();
            this.resetPreviewHolder();
            this.resetSelectedPetHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.loadSwf();
        }

        private function initButton():void
        {
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.buyGold, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.buyTokens, MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this.panelMC.btn_prev, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btn_next, MouseEvent.CLICK, this.changePage);
            this.eventHandler.addListener(this.panelMC.btn_to_page, MouseEvent.CLICK, this.goToPage);
            this.eventHandler.addListener(this.panelMC.btn_search, MouseEvent.CLICK, this.searchItem);
            this.eventHandler.addListener(this.panelMC.btn_clearSearch, MouseEvent.CLICK, this.onSearchClear);
        }

        private function loadSwf():void
        {
            var _local_1:*;
            var _local_2:*;
            var _local_3:*;
            this.isLoading = true;
            if (this.itemIndex < this.itemLoading)
            {
                _local_1 = this.petData[this.itemIndex].petId;
                _local_2 = (("pets/" + _local_1) + ".swf");
                _local_3 = this.loaderSwf.add(_local_2);
                _local_3.addEventListener(BulkLoader.COMPLETE, this.completeIcon);
                _local_3.addEventListener(BulkLoader.ERROR, this.onItemLoadError);
                this.loaderSwf.start();
            }
            else
            {
                if (this.firstLoad)
                {
                    this.main.loading(false);
                    this.gotoAndPlay(1);
                    this.firstLoad = false;
                };
                if (this.petData.length > 0)
                {
                    this.selectPet(0);
                };
                this.isLoading = false;
                return;
            };
        }

        private function onItemLoadError(_arg_1:ErrorEvent):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.COMPLETE, this.completeIcon);
            this.petIconMCArray[this.itemCount] = null;
            this.itemIndex++;
            this.itemCount++;
            this.loadSwf();
        }

        private function completeIcon(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.ERROR, this.onItemLoadError);
            var _local_3:Class;
            var _local_4:MovieClip;
            _local_4 = _arg_1.target.content.icon;
            if (!Character.play_items_animation)
            {
                _local_4.stopAllMovieClips();
            };
            this.petIconMCArray.push(_local_4);
            this.panelMC[("item_" + this.itemCount)].iconMc.iconHolder.addChild(_local_4);
            this.panelMC[("item_" + this.itemCount)].gotoAndStop(1);
            this.panelMC[("item_" + this.itemCount)].visible = true;
            var _local_5:String = this.petData[this.itemIndex].petId;
            _arg_1.target.content[_local_5].gotoAndStop(1);
            var _local_6:Object = PetInfo.getPetStats(_local_5);
            var _local_7:Array = [];
            var _local_8:int;
            while (_local_8 < _local_6.attacks.length)
            {
                _local_4 = _arg_1.target.content[("Skill_" + _local_8)];
                if (!Character.play_items_animation)
                {
                    _local_4.stopAllMovieClips();
                };
                _local_7.push(_local_4);
                _local_8++;
            };
            this.petSkillIconMCArray.push(_local_7);
            _local_4 = _arg_1.target.content.PetStaticFullBody;
            if (!Character.play_items_animation)
            {
                _local_4.stopAllMovieClips();
            };
            this.petStaticMCArray.push(_local_4);
            this.panelMC[("item_" + this.itemCount)].emblemMC.visible = ((_local_6.pet_emblem) ? true : false);
            this.panelMC[("item_" + this.itemCount)].tooltip = _local_6;
            this.panelMC[("item_" + this.itemCount)].item_type = "pet";
            this.panelMC[("item_" + this.itemCount)].lvlTxt.text = _local_6.pet_level;
            this.eventHandler.addListener(this.panelMC[("item_" + this.itemCount)], MouseEvent.MOUSE_OVER, this.toolTiponOver);
            this.eventHandler.addListener(this.panelMC[("item_" + this.itemCount)], MouseEvent.MOUSE_OUT, this.toolTiponOut);
            this.eventHandler.addListener(this.panelMC[("item_" + this.itemCount)], MouseEvent.CLICK, this.selectPet);
            this.itemIndex++;
            this.itemCount++;
            this.loadSwf();
        }

        private function selectPet(_arg_1:*):void
        {
            var _local_2:int = ((_arg_1 is MouseEvent) ? _arg_1.currentTarget.name.replace("item_", "") : _arg_1);
            this.resetSelectedPetHolder();
            this.selectedPetIndex = (_local_2 + int((int((this.currentPage - 1)) * 9)));
            var _local_3:Object = this.panelMC[("item_" + _local_2)].tooltip;
            if (this.petData[this.selectedPetIndex].petPrice.indexOf("gold_") >= 0)
            {
                this.panelMC.priceMC.gotoAndStop(1);
                this.panelMC.priceMC.txt_gold.text = this.petData[this.selectedPetIndex].petPrice.replace("gold_", "");
            }
            else
            {
                this.panelMC.priceMC.gotoAndStop(2);
                this.panelMC.priceMC.txt_token.text = this.petData[this.selectedPetIndex].petPrice.replace("token_", "");
            };
            this.panelMC.priceMC.visible = true;
            this.panelMC.btn_buy.visible = true;
            this.panelMC.btn_preview.visible = true;
            this.panelMC.pet_name.visible = true;
            this.panelMC.btn_buy.metaData = {"pet_data":_local_3};
            this.eventHandler.addListener(this.panelMC.btn_buy, MouseEvent.CLICK, this.openBuyConfirmation);
            this.eventHandler.addListener(this.panelMC.btn_preview, MouseEvent.CLICK, this.loadPreviewSwf);
            this.panelMC.pet_name.text = _local_3.pet_name;
            this.panelMC.pet_mc.addChild(this.petStaticMCArray[_local_2]);
            var _local_4:int;
            while (_local_4 < this.petSkillIconMCArray[_local_2].length)
            {
                this.panelMC[("skill_" + _local_4)].gotoAndStop(3);
                this.panelMC[("skill_" + _local_4)].iconHolder.addChild(this.petSkillIconMCArray[_local_2][_local_4]);
                this.panelMC[("skill_" + _local_4)].tooltip = _local_3.attacks[_local_4];
                this.panelMC[("skill_" + _local_4)].item_type = "skill";
                this.eventHandler.addListener(this.panelMC[("skill_" + _local_4)], MouseEvent.MOUSE_OVER, this.toolTiponOver);
                this.eventHandler.addListener(this.panelMC[("skill_" + _local_4)], MouseEvent.MOUSE_OUT, this.toolTiponOut);
                _local_4++;
            };
        }

        private function openBuyConfirmation(e:MouseEvent):void
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (("Are you sure that you want to buy " + e.currentTarget.metaData.pet_data.pet_name) + " ?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, function ():*
            {
                GF.removeAllChild(confirmation);
            });
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.buyPetAMF);
            addChild(this.confirmation);
        }

        private function buyPetAMF(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.confirmation);
            this.main.loading(true);
            var _local_2:Array = [Character.char_id, Character.sessionkey, this.petData[this.selectedPetIndex].petId];
            this.main.amf_manager.service("PetService.executeService", ["buyPet", _local_2], this.onBuyPetAMF);
        }

        private function onBuyPetAMF(_arg_1:Object):void
        {
            var _local_2:String;
            var _local_3:Number;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.giveReward(1, this.petData[this.selectedPetIndex].petId);
                if (this.petData[this.selectedPetIndex].petPrice.indexOf("gold_") >= 0)
                {
                    _local_2 = this.petData[this.selectedPetIndex].petPrice.replace("gold_", "");
                    _local_3 = Util.convertToNumber(_local_2);
                    Character.character_gold = String((Number(Character.character_gold) - Number(_local_3)));
                }
                else
                {
                    _local_2 = this.petData[this.selectedPetIndex].petPrice.replace("token_", "");
                    _local_3 = Util.convertToNumber(_local_2);
                    Character.account_tokens = (Character.account_tokens - _local_3);
                };
                this.txt_gold.text = Character.character_gold;
                this.txt_token.text = String(Character.account_tokens);
                this.main.HUD.setBasicData();
            }
            else
            {
                if (((_arg_1.status > 1) && (_arg_1.hasOwnProperty("result"))))
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        private function loadPreviewSwf(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            this.resetPreviewHolder();
            var _local_2:* = this.petData[this.selectedPetIndex].petId;
            var _local_3:* = (("pets/" + _local_2) + ".swf");
            var _local_4:* = this.loaderSwf.add(_local_3);
            _local_4.addEventListener(BulkLoader.COMPLETE, this.onCompletePetLoaded);
            _local_4.addEventListener(BulkLoader.ERROR, this.onPetLoadError);
            this.loaderSwf.start();
        }

        private function onPetLoadError(_arg_1:ErrorEvent):void
        {
            this.main.loading(false);
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.COMPLETE, this.onCompletePetLoaded);
            this.loaderSwf.removeAll();
            this.updatePageNumber();
            this.resetSelectedPetHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.loadSwf();
        }

        private function onCompletePetLoaded(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            _arg_1.currentTarget.removeEventListener(BulkLoader.ERROR, this.onPetLoadError);
            this.petInfo = PetInfo.getPetStats(this.petData[this.selectedPetIndex].petId);
            var _local_3:MovieClip = _arg_1.target.content[this.petInfo.pet_id];
            this.petMCPreview = new PreviewManager(this.main, _local_3, this.petInfo);
            try
            {
                _arg_1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
            this.main.loading(false);
            this.showPreview();
        }

        private function showPreview():void
        {
            this.preview.visible = true;
            this.preview.petMc.addChild(this.petMCPreview.preview_mc);
            this.petMCPreview.preview_mc.gotoAndPlay("standby");
            var _local_1:int = (this.petMCPreview.preview_mc.currentLabels.length - 4);
            var _local_2:int = 1;
            while (_local_2 <= _local_1)
            {
                this.preview[("attack_0" + _local_2)].visible = true;
                this.main.initButton(this.preview[("attack_0" + _local_2)], this.playSkillAnimation, ("Skill " + _local_2));
                this.main.initButton(this.preview.dodge, this.playSkillAnimation, "Dodge");
                this.main.initButton(this.preview.hit, this.playSkillAnimation, "Hit");
                this.main.initButton(this.preview.dead, this.playSkillAnimation, "Dead");
                _local_2++;
            };
            this.eventHandler.addListener(this.preview.exitBtn, MouseEvent.CLICK, this.closePreview);
        }

        private function playSkillAnimation(_arg_1:MouseEvent):void
        {
            var _local_4:String;
            var _local_2:String = _arg_1.currentTarget.name;
            var _local_3:int = (int(_arg_1.currentTarget.name.replace("attack_", "")) - 1);
            if (_local_3 != -1)
            {
                _local_4 = this.petInfo.attacks[_local_3].name;
                this.main.showMessage(_local_4);
                _local_4 = null;
            };
            this.petMCPreview.preview_mc.gotoAndPlay(_local_2);
        }

        private function resetPreviewHolder():void
        {
            if (this.petMCPreview)
            {
                this.petMCPreview.destroy();
            };
            var _local_1:int = 1;
            while (_local_1 <= 6)
            {
                this.preview[("attack_0" + _local_1)].visible = false;
                _local_1++;
            };
            this.petInfo = null;
            this.petMCPreview = null;
        }

        private function closePreview(_arg_1:MouseEvent):void
        {
            this.resetPreviewHolder();
            GF.removeAllChild(this.preview.petMc);
            this.preview.visible = false;
        }

        private function goToPage(_arg_1:MouseEvent):void
        {
            if ((((this.panelMC.txt_goToPage.text == "") || (this.panelMC.txt_goToPage.text < 1)) || (this.panelMC.txt_goToPage.text > this.totalPage)))
            {
                return;
            };
            this.currentPage = int(this.panelMC.txt_goToPage.text);
            this.updatePageNumber();
            this.resetPreviewHolder();
            this.resetSelectedPetHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.loadSwf();
        }

        private function searchItem(_arg_1:MouseEvent):void
        {
            var _local_6:Object;
            var _local_8:Object;
            var _local_9:String;
            var _local_2:Array = [];
            var _local_3:String = this.panelMC.txt_search.text.toLowerCase();
            var _local_4:Array = this.petDataOriginal;
            var _local_5:int = _local_4.length;
            var _local_7:int;
            while (_local_7 < _local_5)
            {
                _local_6 = _local_4[_local_7];
                _local_8 = PetInfo.getPetStats(_local_6.petId);
                _local_9 = _local_8["pet_name"].toLowerCase();
                if (_local_9.indexOf(_local_3) >= 0)
                {
                    _local_2.push({
                        "petId":_local_6.petId,
                        "petPrice":_local_6.petPrice
                    });
                };
                _local_7++;
            };
            this.petData = _local_2;
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.petData.length / 9)), 1);
            this.updatePageNumber();
            this.resetPreviewHolder();
            this.resetSelectedPetHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.loadSwf();
        }

        private function onSearchClear(_arg_1:MouseEvent=null):void
        {
            this.panelMC.txt_search.text = "";
            this.panelMC.txt_goToPage.text = "";
            this.petData = this.petDataOriginal;
            this.currentPage = 1;
            this.totalPage = Math.max(Math.ceil((this.petData.length / 9)), 1);
            this.updatePageNumber();
            this.resetPreviewHolder();
            this.resetSelectedPetHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.loadSwf();
        }

        private function changePage(_arg_1:MouseEvent):void
        {
            if (this.isLoading)
            {
                return;
            };
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                    }
                    else
                    {
                        return;
                    };
                    break;
                case "btn_prev":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                    }
                    else
                    {
                        return;
                    };
            };
            this.resetPreviewHolder();
            this.resetSelectedPetHolder();
            this.resetIconHolder();
            this.resetRecursiveProperty();
            this.updatePageNumber();
            if (this.loaderSwf.itemsLoaded >= 18)
            {
                this.loaderSwf.removeAll();
            };
            this.loadSwf();
        }

        private function updatePageNumber():void
        {
            this.panelMC.txt_page.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function hoverOver(_arg_1:Event):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        private function hoverOut(_arg_1:Event):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
        }

        private function toolTiponOver(e:MouseEvent):void
        {
            var tooltipData:Object;
            var desc:String;
            var itemType:String;
            var mc:MovieClip = (e.currentTarget as MovieClip);
            if (!mc.tooltipCache)
            {
                var formatDesc:Function = function (_arg_1:String, _arg_2:String, _arg_3:String="", _arg_4:String="", _arg_5:String=""):String
                {
                    return (((((((_arg_1 + "\n(") + _arg_2) + ")\n") + ((_arg_3) ? ("\nLevel: " + _arg_3) : "")) + ((_arg_4) ? ("\n" + _arg_4) : "")) + "\n\n") + _arg_5);
                };
                tooltipData = mc.tooltip;
                if (!tooltipData)
                {
                    return;
                };
                itemType = mc.item_type;
                switch (itemType)
                {
                    case "pet":
                        e.currentTarget.gotoAndStop(2);
                        desc = formatDesc(tooltipData.pet_name, "Pet", tooltipData.pet_level, "", tooltipData.description);
                        break;
                    case "skill":
                        desc = formatDesc(tooltipData.name, "Skill", tooltipData.level, (('<font color="#ffcc00">Cooldown: ' + tooltipData.cooldown) + "</font>"), tooltipData.description);
                        break;
                    default:
                        desc = "";
                };
                mc.tooltipCache = desc;
            };
            stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(mc.tooltipCache);
        }

        private function toolTiponOut(_arg_1:MouseEvent):void
        {
            _arg_1.currentTarget.gotoAndStop(1);
            this.tooltip.hide();
        }

        private function resetSelectedPetHolder():void
        {
            GF.removeAllChild(this.panelMC.pet_mc);
            this.panelMC.btn_buy.metaData = {};
            this.preview.visible = false;
            this.panelMC.priceMC.visible = false;
            this.panelMC.btn_buy.visible = false;
            this.panelMC.btn_preview.visible = false;
            this.panelMC.pet_name.visible = false;
            this.eventHandler.removeListener(this.panelMC.btn_preview, MouseEvent.CLICK, this.loadPreviewSwf);
            this.eventHandler.removeListener(this.panelMC.btn_buy, MouseEvent.CLICK, this.openBuyConfirmation);
            var _local_1:int;
            while (_local_1 < 6)
            {
                delete this.panelMC[("skill_" + _local_1)].tooltip;
                delete this.panelMC[("skill_" + _local_1)].tooltipCache;
                delete this.panelMC[("skill_" + _local_1)].item_type;
                this.panelMC[("skill_" + _local_1)].gotoAndStop(1);
                this.eventHandler.removeListener(this.panelMC[("skill_" + _local_1)], MouseEvent.MOUSE_OVER, this.toolTiponOver);
                this.eventHandler.removeListener(this.panelMC[("skill_" + _local_1)], MouseEvent.MOUSE_OUT, this.toolTiponOut);
                GF.removeAllChild(this.panelMC[("skill_" + _local_1)].iconHolder);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < 9)
            {
                this.panelMC[("item_" + _local_1)].gotoAndStop(1);
                _local_1++;
            };
        }

        private function resetIconHolder():void
        {
            var _local_2:int;
            var _local_1:int;
            while (_local_1 < this.petIconMCArray.length)
            {
                GF.removeAllChild(this.petIconMCArray[_local_1]);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.petStaticMCArray.length)
            {
                GF.removeAllChild(this.petStaticMCArray[_local_1]);
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.petSkillIconMCArray.length)
            {
                _local_2 = 0;
                while (_local_2 < this.petSkillIconMCArray[_local_1].length)
                {
                    GF.removeAllChild(this.petSkillIconMCArray[_local_1][_local_2]);
                    _local_2++;
                };
                _local_1++;
            };
            this.petIconMCArray = [];
            this.petSkillIconMCArray = [];
            this.petStaticMCArray = [];
            _local_1 = 0;
            while (_local_1 < 9)
            {
                GF.removeAllChild(this.panelMC[("item_" + _local_1)].iconMc.iconHolder);
                this.panelMC[("item_" + _local_1)].gotoAndStop(1);
                this.panelMC[("item_" + _local_1)].visible = false;
                this.panelMC[("item_" + _local_1)].lockMc.visible = false;
                this.panelMC[("item_" + _local_1)].emblemMC.visible = false;
                this.panelMC[("item_" + _local_1)].amtTxt.visible = false;
                delete this.panelMC[("item_" + _local_1)].tooltip;
                delete this.panelMC[("item_" + _local_1)].tooltipCache;
                delete this.panelMC[("item_" + _local_1)].item_type;
                this.eventHandler.removeListener(this.panelMC[("item_" + _local_1)], MouseEvent.MOUSE_OVER, this.toolTiponOver);
                this.eventHandler.removeListener(this.panelMC[("item_" + _local_1)], MouseEvent.MOUSE_OUT, this.toolTiponOut);
                _local_1++;
            };
        }

        private function resetRecursiveProperty():void
        {
            this.itemLoading = (this.currentPage * 9);
            if (this.petData.length < this.itemLoading)
            {
                this.itemLoading = this.petData.length;
            };
            this.itemIndex = ((this.currentPage - 1) * 9);
            this.itemCount = 0;
        }

        private function openRecharge(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Recharge");
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function stopEntrance():void
        {
            this.stop();
        }

        public function destroy():void
        {
            this.main.handleVillageHUDVisibility(true);
            this.main.clearEvents();
            this.resetIconHolder();
            this.resetSelectedPetHolder();
            this.resetPreviewHolder();
            this.resetRecursiveProperty();
            this.eventHandler.removeAllEventListeners();
            this.loaderSwf.clear();
            this.tooltip.destroy();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.confirmation = null;
            this.tooltip = null;
            this.loaderSwf = null;
            this.main = null;
            this.petData = [];
            this.petDataOriginal = [];
            GF.removeAllChild(this);
        }


    }
}//package Panels

