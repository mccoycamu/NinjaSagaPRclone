// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.MekkorvathPackage

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Managers.PreviewManager;
    import br.com.stimuli.loading.BulkLoader;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.OutfitManager;
    import com.utils.GF;
    import Managers.NinjaSage;
    import Storage.SkillLibrary;
    import Storage.PetInfo;
    import Storage.Library;
    import Storage.AnimationLibrary;
    import flash.events.Event;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;

    public dynamic class MekkorvathPackage extends MovieClip 
    {

        private const packageTitle:String = "Mekkorvath Package";
        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var previewMC:PreviewManager;
        private var loaderSwf:BulkLoader;
        private var item_hair:String;
        private var item_set:String;
        private var item_back:String;
        private var item_wpn:String;
        private var item_acc:String;
        private var item_skill:Array;
        private var item_pet:String;
        private var item_animation:String;
        private var selectedSkill:String;
        private var selectedPet:String;
        private var selectedPackage:int = 0;
        private var currentSet:int = 0;
        private var petInfo:Object;
        private var rewardPane:RewardScrollPane;
        private var previewAnimType:String;
        private var isOutfitFileld:Boolean = false;

        private var outfits:Array = [];
        private var gender:int = Character.character_gender;
        private var packageData:Array = [];
        private const tabButton:Array = ["mcHairstyle", "mcSet", "mcBackItem", "mcWeapon", "mcAccessory", "mcPet", "mcAnimation"];
        private const skillButton:Array = ["mcSkill0", "mcSkill1", "mcSkill2"];

        public function MekkorvathPackage(_arg_1:*, _arg_2:*)
        {
            this.main = _arg_1;
            this.panelMC = _arg_2;
            this.eventHandler = new EventHandler();
            this.rewardPane = new RewardScrollPane();
            this.loaderSwf = BulkLoader.createUniqueNamedLoader(12);
            this.setRewardData();
            this.initUI();
        }

        private function setRewardData():void
        {
            var _local_3:Object;
            var _local_4:int;
            this.packageData = [];
            var _local_1:Array = ((Character.event_data.packages) ? Character.event_data.packages.content : []);
            var _local_2:int;
            while (_local_2 < _local_1.length)
            {
                _local_3 = _local_1[_local_2];
                this.packageData.push({
                    "packageName":_local_3.name,
                    "packagePrice":_local_3.price,
                    "packageReward":[],
                    "packageOutfit":{
                        "package_hair":[],
                        "package_set":[],
                        "package_back":_local_3.outfits.back,
                        "package_weapon":_local_3.outfits.weapon,
                        "package_pet":_local_3.outfits.pet,
                        "package_accessory":_local_3.outfits.accessory,
                        "package_skill":_local_3.outfits.skill,
                        "package_animation":_local_3.outfits.ani
                    }
                });
                _local_4 = 0;
                while (_local_4 < _local_3.outfits.hair.length)
                {
                    this.packageData[_local_2].packageOutfit.package_hair.push(_local_3.outfits.hair[_local_4].replace("%s", this.gender));
                    this.packageData[_local_2].packageOutfit.package_set.push(_local_3.outfits.set[_local_4].replace("%s", this.gender));
                    _local_4++;
                };
                _local_4 = 0;
                while (_local_4 < _local_3.rewards.length)
                {
                    this.packageData[_local_2].packageReward.push(_local_3.rewards[_local_4].replace("%s", this.gender));
                    _local_4++;
                };
                _local_2++;
            };
        }

        private function initUI():void
        {
            this.main.handleVillageHUDVisibility(false);
            this.panelMC.panelMC.pet_mc.x = (this.panelMC.panelMC.pet_mc.x + 60);
            this.panelMC.panelMC.pet_mc.y = (this.panelMC.panelMC.pet_mc.y + 70);
            this.panelMC.panelMC.genderChange.gotoAndStop((Character.character_gender + 1));
            this.panelMC.panelMC.genderChange.buttonMode = true;
            this.panelMC.panelMC.previewSkill.visible = false;
            this.panelMC.panelMC.previewPet.visible = false;
            this.panelMC.panelMC.previewIdle.visible = false;
            this.panelMC.panelMC.previewIdle.char_mc.gotoAndStop(1);
            this.panelMC.panelMC.txt_eventDate.text = Character.event_data.packages.date;
            this.panelMC.panelMC.scrollPaneHolder.addChild(this.rewardPane.getRewardPane());
            this.eventHandler.addListener(this.panelMC.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.panelMC.btn_set_0, MouseEvent.CLICK, this.selectSetNumber);
            this.eventHandler.addListener(this.panelMC.panelMC.btn_set_1, MouseEvent.CLICK, this.selectSetNumber);
            this.eventHandler.addListener(this.panelMC.panelMC.btn_set_2, MouseEvent.CLICK, this.selectSetNumber);
            this.eventHandler.addListener(this.panelMC.panelMC.genderChange, MouseEvent.CLICK, this.handleChangeGender);
            this.eventHandler.addListener(this.panelMC.panelMC.btn_buy, MouseEvent.CLICK, this.buyPack);
            var _local_1:int;
            while (_local_1 < this.packageData.length)
            {
                this.panelMC.panelMC[("item_" + _local_1)].highlight.visible = false;
                this.panelMC.panelMC[("item_" + _local_1)].iconMc.gotoAndStop((_local_1 + 1));
                this.panelMC.panelMC[("item_" + _local_1)].txt_packageName.text = this.packageData[_local_1].packageName;
                this.panelMC.panelMC[("item_" + _local_1)].txt_packagePrice.text = this.packageData[_local_1].packagePrice;
                this.panelMC.panelMC[("item_" + _local_1)].buttonMode = true;
                this.eventHandler.addListener(this.panelMC.panelMC[("item_" + _local_1)], MouseEvent.CLICK, this.selectPackage);
                _local_1++;
            };
            this.panelMC.panelMC[("item_" + this.selectedPackage)].highlight.visible = true;
            this.panelMC.panelMC.txt_title.text = Character.event_data.packages.name;
            this.panelMC.panelMC.txt_packageName.text = this.packageData[this.selectedPackage].packageName;
            this.updateRewardPane();
            this.selectPackage();
            this.loadIconPreview();
            this.initTooltipRightSide();
        }

        private function handleChangeGender(_arg_1:MouseEvent):void
        {
            this.gender = ((this.gender == 1) ? 0 : 1);
            this.panelMC.panelMC.genderChange.gotoAndStop((this.gender + 1));
            this.setRewardData();
            this.setUsedOutfit();
            this.loadIconPreview();
            this.updateRewardPane();
        }

        private function selectSetNumber(_arg_1:MouseEvent):void
        {
            this.currentSet = _arg_1.currentTarget.name.replace("btn_set_", "");
            this.setUsedOutfit();
            this.loadIconPreview();
        }

        private function selectPackage(_arg_1:MouseEvent=null):void
        {
            this.selectedPackage = ((_arg_1) ? _arg_1.currentTarget.name.replace("item_", "") : 0);
            var _local_2:int;
            while (_local_2 < 3)
            {
                this.panelMC.panelMC[("btn_set_" + _local_2)].visible = false;
                if (this.packageData[this.selectedPackage].packageOutfit.package_hair[_local_2])
                {
                    this.panelMC.panelMC[("btn_set_" + _local_2)].visible = true;
                };
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < this.packageData.length)
            {
                this.panelMC.panelMC[("item_" + _local_2)].highlight.visible = false;
                _local_2++;
            };
            this.panelMC.panelMC[("item_" + this.selectedPackage)].highlight.visible = true;
            this.panelMC.panelMC.txt_packageName.text = this.packageData[this.selectedPackage].packageName;
            this.updateRewardPane();
            this.setUsedOutfit();
            this.loadIconPreview();
        }

        private function updateRewardPane():void
        {
            this.rewardPane.updateRewardPane({
                "rewards":this.packageData[this.selectedPackage].packageReward,
                "item_per_line":2,
                "width":null,
                "height":515,
                "x":105,
                "y":110,
                "scroll_direction":"vertical"
            });
        }

        private function loadIconPreview():void
        {
            this.resetIconMc();
            var _local_1:OutfitManager = new OutfitManager();
            if (this.item_wpn == null)
            {
                GF.removeAllChild(this.panelMC.panelMC.char_mc.weapon);
            };
            GF.removeAllChild(this.panelMC.panelMC.char_mc.back_hair);
            _local_1.fillOutfit(this.panelMC.panelMC.char_mc, this.item_wpn, this.item_back, this.item_set, this.item_hair, ("face_01_" + this.gender), "null|null", "null|null");
            this.outfits.push(_local_1);
            var _local_2:Array = [this.item_hair, this.item_set, this.item_back, this.item_wpn, this.item_acc];
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (_local_2[_local_3] != null)
                {
                    this.panelMC.panelMC[this.tabButton[_local_3]].visible = true;
                    NinjaSage.loadItemIcon(this.panelMC.panelMC[this.tabButton[_local_3]], _local_2[_local_3]);
                };
                _local_3++;
            };
            _local_3 = 0;
            while (_local_3 < this.item_skill.length)
            {
                if (this.item_skill[_local_3] != null)
                {
                    this.panelMC.panelMC[this.skillButton[_local_3]].visible = true;
                    NinjaSage.loadItemIcon(this.panelMC.panelMC[this.skillButton[_local_3]], this.item_skill[_local_3]);
                    this.eventHandler.addListener(this.panelMC.panelMC[this.skillButton[_local_3]], MouseEvent.CLICK, this.handlePreview);
                };
                _local_3++;
            };
            if (this.item_pet != null)
            {
                if (this.item_pet == null)
                {
                    return;
                };
                this.panelMC.panelMC.mcPet.visible = true;
                NinjaSage.loadItemIcon(this.panelMC.panelMC.mcPet, this.item_pet);
                this.panelMC.panelMC.pet_mc.scaleX = 1.2;
                this.panelMC.panelMC.pet_mc.scaleY = 1.2;
                NinjaSage.loadIconSWF("pets", this.item_pet, this.panelMC.panelMC.pet_mc, this.item_pet);
                this.eventHandler.addListener(this.panelMC.panelMC.mcPet, MouseEvent.CLICK, this.handlePreview);
            };
            if (this.item_animation != null)
            {
                this.panelMC.panelMC.mcAnimation.visible = true;
                NinjaSage.loadItemIcon(this.panelMC.panelMC.mcAnimation, this.item_animation);
                this.eventHandler.addListener(this.panelMC.panelMC.mcAnimation, MouseEvent.CLICK, this.previewAnimation);
            };
            this.panelMC.panelMC.mcBasicAtk.visible = (!(this.item_wpn == null));
            this.eventHandler.addListener(this.panelMC.panelMC.mcBasicAtk, MouseEvent.CLICK, this.previewAnimation);
            NinjaSage.showDynamicTooltip(this.panelMC.panelMC.mcBasicAtk, "Exclusive Weapon Basic Attack");
        }

        private function resetIconMc():void
        {
            var _local_1:int;
            while (_local_1 < this.tabButton.length)
            {
                GF.removeAllChild(this.panelMC.panelMC[this.tabButton[_local_1]].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.panelMC[this.tabButton[_local_1]].skillIcon.iconHolder);
                this.panelMC.panelMC[this.tabButton[_local_1]].visible = false;
                _local_1++;
            };
            _local_1 = 0;
            while (_local_1 < this.skillButton.length)
            {
                GF.removeAllChild(this.panelMC.panelMC[this.skillButton[_local_1]].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.panelMC[this.skillButton[_local_1]].skillIcon.iconHolder);
                this.panelMC.panelMC[this.skillButton[_local_1]].visible = false;
                this.eventHandler.removeListener(this.panelMC.panelMC[this.skillButton[_local_1]], MouseEvent.CLICK, this.handlePreview);
                _local_1++;
            };
            GF.removeAllChild(this.panelMC.panelMC.pet_mc);
            this.eventHandler.removeListener(this.panelMC.panelMC.mcPet, MouseEvent.CLICK, this.handlePreview);
        }

        private function setUsedOutfit():void
        {
            var _local_1:int = ((this.packageData[this.selectedPackage].packageOutfit.package_hair.length > 1) ? this.currentSet : 0);
            var _local_2:int = ((this.packageData[this.selectedPackage].packageOutfit.package_set.length > 1) ? this.currentSet : 0);
            var _local_3:int = ((this.packageData[this.selectedPackage].packageOutfit.package_back.length > 1) ? this.currentSet : 0);
            var _local_4:int = ((this.packageData[this.selectedPackage].packageOutfit.package_weapon.length > 1) ? this.currentSet : 0);
            var _local_5:int = ((this.packageData[this.selectedPackage].packageOutfit.package_accessory.length > 1) ? this.currentSet : 0);
            var _local_6:int = ((this.packageData[this.selectedPackage].packageOutfit.package_pet.length > 1) ? this.currentSet : 0);
            var _local_7:int = ((this.packageData[this.selectedPackage].packageOutfit.package_animation.length > 1) ? this.currentSet : 0);
            this.item_hair = this.packageData[this.selectedPackage].packageOutfit.package_hair[_local_1];
            this.item_set = this.packageData[this.selectedPackage].packageOutfit.package_set[_local_2];
            this.item_back = this.packageData[this.selectedPackage].packageOutfit.package_back[_local_3];
            this.item_wpn = this.packageData[this.selectedPackage].packageOutfit.package_weapon[_local_4];
            this.item_acc = this.packageData[this.selectedPackage].packageOutfit.package_accessory[_local_5];
            this.item_pet = this.packageData[this.selectedPackage].packageOutfit.package_pet[_local_6];
            this.item_skill = this.packageData[this.selectedPackage].packageOutfit.package_skill;
            this.item_animation = this.packageData[this.selectedPackage].packageOutfit.package_animation[_local_7];
        }

        private function initTooltipRightSide():void
        {
            var _local_2:Array;
            var _local_3:Object;
            var _local_4:int;
            var _local_5:String;
            var _local_6:String;
            var _local_7:String;
            var _local_1:int;
            while (_local_1 < this.packageData.length)
            {
                _local_2 = [];
                _local_3 = {};
                _local_4 = 0;
                while (_local_4 < this.packageData[_local_1].packageReward.length)
                {
                    _local_6 = this.packageData[_local_1].packageReward[_local_4];
                    _local_7 = _local_6.split("_")[0];
                    if (_local_7 == "skill")
                    {
                        _local_3 = SkillLibrary.getSkillInfo(_local_6);
                        _local_2.push(_local_3.skill_name);
                    }
                    else
                    {
                        if (_local_7 == "pet")
                        {
                            _local_3 = PetInfo.getPetStats(_local_6);
                            _local_2.push(_local_3.pet_name);
                        }
                        else
                        {
                            if (_local_7 == "tokens")
                            {
                                _local_3 = (_local_6.split("_")[1] + " Tokens");
                                _local_2.push(_local_3);
                            }
                            else
                            {
                                if (_local_7 == "emblem")
                                {
                                    _local_3 = "Permanent Emblem";
                                    _local_2.push(_local_3);
                                }
                                else
                                {
                                    _local_3 = Library.getItemInfo(_local_6);
                                    _local_2.push(_local_3.item_name);
                                };
                            };
                        };
                    };
                    _local_4++;
                };
                _local_5 = (this.packageData[_local_1].packageName + "\n\nThis package contains these following items: \n\n");
                NinjaSage.showDynamicTooltip(this.panelMC.panelMC[("item_" + _local_1)].iconMc, (_local_5 + _local_2.join("\n")));
                _local_1++;
            };
        }

        private function previewAnimation(_arg_1:MouseEvent):void
        {
            var _local_2:OutfitManager;
            this.previewAnimType = _arg_1.currentTarget.name;
            this.panelMC.panelMC.previewIdle.visible = true;
            if (!this.isOutfitFileld)
            {
                _local_2 = new OutfitManager();
                _local_2.fillOutfit(this.panelMC.panelMC.previewIdle.char_mc, this.item_wpn, this.item_back, this.item_set, this.item_hair, ("face_01_" + this.gender), "null|null", "null|null");
                this.outfits.push(_local_2);
                this.isOutfitFileld = true;
            };
            this.eventHandler.addListener(this.panelMC.panelMC.previewIdle.exitBtn, MouseEvent.CLICK, this.closePreviewAnimation);
            this.eventHandler.addListener(this.panelMC.panelMC.previewIdle.replayBtn, MouseEvent.CLICK, this.playAnimationPreview);
            this.playAnimationPreview();
        }

        private function playAnimationPreview(_arg_1:MouseEvent=null):void
        {
            if (this.previewAnimType == "mcAnimation")
            {
                NinjaSage.addStandByFrameScript(this.panelMC.panelMC.previewIdle.char_mc, AnimationLibrary.getAnimation(this.item_animation).label);
                this.panelMC.panelMC.previewIdle.char_mc.gotoAndPlay(AnimationLibrary.getAnimation(this.item_animation).label);
            }
            else
            {
                NinjaSage.addStandByFrameScript(this.panelMC.panelMC.previewIdle.char_mc, Library.getItemInfo(this.item_wpn).attack_type);
                this.panelMC.panelMC.previewIdle.char_mc.gotoAndPlay(Library.getItemInfo(this.item_wpn).attack_type);
            };
        }

        private function closePreviewAnimation(_arg_1:MouseEvent):void
        {
            this.panelMC.panelMC.previewIdle.visible = false;
            this.panelMC.panelMC.previewIdle.char_mc.gotoAndStop(1);
        }

        private function handlePreview(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.name == "mcPet")
            {
                this.loadPetAndPreview(this.item_pet);
            }
            else
            {
                this.loadSkillAndPreview(this.item_skill[_arg_1.currentTarget.name.replace("mcSkill", "")]);
            };
        }

        private function loadSkillAndPreview(_arg_1:String):void
        {
            this.main.loading(true);
            this.resetPreviewHolder();
            this.selectedSkill = _arg_1;
            var _local_2:* = (("skills/" + this.selectedSkill) + ".swf");
            var _local_3:* = this.loaderSwf.add(_local_2);
            _local_3.addEventListener(BulkLoader.COMPLETE, this.completePreviewSkill);
            this.loaderSwf.start();
        }

        public function completePreviewSkill(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            var _local_3:Object = SkillLibrary.getSkillInfo(this.selectedSkill);
            var _local_4:MovieClip = _arg_1.target.content[this.selectedSkill];
            _local_4.gotoAndStop(1);
            var _local_5:Array = [this.item_wpn, this.item_back, this.item_set, this.item_hair, ("face_01_" + this.gender), "null|null", "null|null"];
            this.previewMC = new PreviewManager(this.main, _local_4, _local_3, _local_5);
            try
            {
                _arg_1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
            this.main.loading(false);
            this.showPreviewSkill();
        }

        public function showPreviewSkill():void
        {
            this.panelMC.panelMC.previewSkill.visible = true;
            this.panelMC.panelMC.previewSkill.skillMc.addChild(this.previewMC.preview_mc);
            this.previewMC.preview_mc.gotoAndPlay(2);
            this.eventHandler.addListener(this.panelMC.panelMC.previewSkill.exitBtn, MouseEvent.CLICK, this.closePreview);
            this.eventHandler.addListener(this.panelMC.panelMC.previewSkill.replayBtn, MouseEvent.CLICK, this.handleReplay);
        }

        public function handleReplay(_arg_1:MouseEvent):void
        {
            this.previewMC.preview_mc.gotoAndPlay(2);
        }

        public function loadPetAndPreview(_arg_1:String):void
        {
            this.main.loading(true);
            this.resetPreviewHolder();
            var _local_2:* = (("pets/" + _arg_1) + ".swf");
            var _local_3:* = this.loaderSwf.add(_local_2);
            this.selectedPet = _arg_1;
            _local_3.addEventListener(BulkLoader.COMPLETE, this.onCompletePetLoaded);
            this.loaderSwf.start();
        }

        private function onCompletePetLoaded(_arg_1:Event):void
        {
            _arg_1.currentTarget.removeEventListener(_arg_1.type, arguments.callee);
            this.petInfo = PetInfo.getPetStats(this.selectedPet);
            var _local_3:MovieClip = _arg_1.target.content[this.selectedPet];
            _local_3.gotoAndStop(1);
            this.previewMC = new PreviewManager(this.main, _local_3, this.petInfo);
            try
            {
                _arg_1.target.loader.unloadAndStop(true);
            }
            catch(e)
            {
            };
            this.main.loading(false);
            this.showPreviewPet();
        }

        private function showPreviewPet():void
        {
            this.panelMC.panelMC.previewPet.visible = true;
            this.panelMC.panelMC.previewPet.petMc.addChild(this.previewMC.preview_mc);
            this.panelMC.panelMC.previewPet.petMc.scaleX = 1.2;
            this.panelMC.panelMC.previewPet.petMc.scaleY = 1.2;
            this.previewMC.preview_mc.gotoAndPlay("standby");
            var _local_1:int = (this.previewMC.preview_mc.currentLabels.length - 4);
            var _local_2:int = 1;
            while (_local_2 <= _local_1)
            {
                this.panelMC.panelMC.previewPet[("attack_0" + _local_2)].visible = true;
                this.main.initButton(this.panelMC.panelMC.previewPet[("attack_0" + _local_2)], this.playSkillAnimation, ("Skill " + _local_2));
                this.main.initButton(this.panelMC.panelMC.previewPet.dodge, this.playSkillAnimation, "Dodge");
                this.main.initButton(this.panelMC.panelMC.previewPet.hit, this.playSkillAnimation, "Hit");
                this.main.initButton(this.panelMC.panelMC.previewPet.dead, this.playSkillAnimation, "Dead");
                _local_2++;
            };
            this.eventHandler.addListener(this.panelMC.panelMC.previewPet.exitBtn, MouseEvent.CLICK, this.closePreview);
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
            this.previewMC.preview_mc.gotoAndPlay(_local_2);
        }

        private function closePreview(_arg_1:MouseEvent):void
        {
            this.resetPreviewHolder();
            this.panelMC.panelMC.previewSkill.visible = false;
            this.panelMC.panelMC.previewPet.visible = false;
        }

        private function resetPreviewHolder():void
        {
            if (this.previewMC)
            {
                this.previewMC.destroy();
            };
            var _local_1:int = 1;
            while (_local_1 <= 6)
            {
                this.panelMC.panelMC.previewPet[("attack_0" + _local_1)].visible = false;
                _local_1++;
            };
            GF.removeAllChild(this.panelMC.panelMC.previewSkill.skillMc);
            GF.removeAllChild(this.panelMC.panelMC.previewPet.petMc);
            this.petInfo = null;
            this.previewMC = null;
        }

        private function buyPack(_arg_1:MouseEvent):void
        {
            navigateToURL(new URLRequest("https://ninjasage.id/merchants"));
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            this.main.handleVillageHUDVisibility(true);
            var _local_1:int;
            while (_local_1 < 4)
            {
                this.panelMC.panelMC[("item_" + _local_1)].buttonMode = false;
                _local_1++;
            };
            GF.destroyArray(this.outfits);
            this.resetIconMc();
            this.resetPreviewHolder();
            this.eventHandler.removeAllEventListeners();
            this.loaderSwf.clear();
            this.rewardPane.destroy();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            OutfitManager.clearStaticMc();
            this.packageData = [];
            this.rewardPane = null;
            this.petInfo = null;
            this.loaderSwf = null;
            this.main = null;
            this.eventHandler = null;
            this.previewMC = null;
            this.outfits = null;
            GF.removeAllChild(this.panelMC.panelMC.scrollPaneHolder);
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
        }


    }
}//package id.ninjasage.features

