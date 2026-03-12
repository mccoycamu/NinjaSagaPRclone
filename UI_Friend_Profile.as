// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.UI_Friend_Profile

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import com.abrahamyan.liquid.ToolTip;
    import id.ninjasage.EventHandler;
    import Managers.OutfitManager;
    import flash.events.MouseEvent;
    import Storage.Character;
    import br.com.stimuli.loading.BulkLoader;
    import Managers.StatManager;
    import com.utils.GF;
    import Managers.NinjaSage;
    import Storage.Library;
    import Storage.PetInfo;
    import flash.system.System;
    import Storage.WeaponBuffs;
    import Storage.BackItemBuffs;
    import Storage.AccessoryBuffs;
    import Storage.SkillLibrary;
    import flash.utils.getDefinitionByName;
    import Combat.BattleVars;

    public class UI_Friend_Profile extends MovieClip 
    {

        public static var check_talent:Boolean = false;
        public static var check_senjutsu:Boolean = false;

        public var bgSkill:MovieClip;
        public var btn_detail:SimpleButton;
        public var btn_rename:SimpleButton;
        public var clanLogoHolder:MovieClip;
        public var classMC:MovieClip;
        public var txt_accuracy:TextField;
        public var btn_close:SimpleButton;
        public var btn_unfriend:SimpleButton;
        public var btn_AddFriend:SimpleButton;
        public var char_mc:MovieClip;
        public var cpBar:MovieClip;
        public var element_1:MovieClip;
        public var element_2:MovieClip;
        public var element_3:MovieClip;
        public var emblemMC:MovieClip;
        public var hpBar:MovieClip;
        public var rankMC:MovieClip;
        public var talent_1:MovieClip;
        public var talent_2:MovieClip;
        public var talent_3:MovieClip;
        public var skill_1:MovieClip;
        public var skill_2:MovieClip;
        public var skill_3:MovieClip;
        public var skill_4:MovieClip;
        public var skill_5:MovieClip;
        public var skill_6:MovieClip;
        public var skill_7:MovieClip;
        public var skill_8:MovieClip;
        public var detailMC:MovieClip;
        public var txt_agility:TextField;
        public var txt_cp:TextField;
        public var txt_crit:TextField;
        public var txt_dodge:TextField;
        public var txt_earth:TextField;
        public var txt_fire:TextField;
        public var txt_free:TextField;
        public var txt_hp:TextField;
        public var txt_id:TextField;
        public var txt_lightning:TextField;
        public var txt_lvl:TextField;
        public var txt_name:TextField;
        public var txt_purify:TextField;
        public var txt_water:TextField;
        public var txt_wind:TextField;
        public var txt_xp:TextField;
        public var xpBar:MovieClip;
        public var profileTitle:TextField;
        public var main:*;
        public var char_id:*;
        private var clan:*;
        private var character:*;
        private var sets:*;
        private var pets:*;
        private var points:*;
        private var inventory:*;
        private var self:UI_Friend_Profile;
        private var tooltip:ToolTip;
        private var skillInformations:Array = [];
        private var confirmation:*;
        public var eventHandler:* = new EventHandler();
        public var outfit_manager:*;
        public var is_sw:Boolean = false;
        private var destroyed:* = false;

        public function UI_Friend_Profile(_arg_1:*, _arg_2:String, _arg_3:Boolean=false)
        {
            this.self = this;
            this.main = _arg_1;
            this.is_sw = _arg_3;
            this.outfit_manager = new OutfitManager();
            this.char_id = _arg_2;
            this.tooltip = ToolTip.getInstance();
            this.eventHandler.addListener(this.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.btn_detail, MouseEvent.CLICK, this.openDetail);
            this.detailMC.visible = false;
            this.btn_unfriend.visible = false;
            this.btn_AddFriend.visible = false;
            this.loadProfile();
        }

        public static function talentPurifyByTalent(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1061:1":1,
                "skill_1061:2":2,
                "skill_1061:3":3,
                "skill_1061:4":4,
                "skill_1061:5":5,
                "skill_1061:6":6,
                "skill_1061:7":7,
                "skill_1061:8":8,
                "skill_1061:9":9,
                "skill_1061:10":10
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function talentPurifyByLvlCP(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1051:1":1100,
                "skill_1051:2":1050,
                "skill_1051:3":1000,
                "skill_1051:4":950,
                "skill_1051:5":900,
                "skill_1051:6":850,
                "skill_1051:7":800,
                "skill_1051:8":750,
                "skill_1051:9":725,
                "skill_1051:10":700
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function talentPurifyByLvlHP(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1102:1":1100,
                "skill_1102:2":1075,
                "skill_1102:3":1050,
                "skill_1102:4":1025,
                "skill_1102:5":1000,
                "skill_1102:6":975,
                "skill_1102:7":950,
                "skill_1102:8":900,
                "skill_1102:9":800,
                "skill_1102:10":700
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function talentMaxHPFixedByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1046:1":100,
                "skill_1046:2":200,
                "skill_1046:3":300,
                "skill_1046:4":400,
                "skill_1046:5":450,
                "skill_1046:6":500,
                "skill_1046:7":550,
                "skill_1046:8":600,
                "skill_1046:9":650,
                "skill_1046:10":800
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (int(0));
        }

        public static function talentMaxHPByMaxCP(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1052:1":5,
                "skill_1052:2":6,
                "skill_1052:3":6,
                "skill_1052:4":7,
                "skill_1052:5":7,
                "skill_1052:6":8,
                "skill_1052:7":8,
                "skill_1052:8":9,
                "skill_1052:9":9,
                "skill_1052:10":10
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (int(0));
        }


        public function loadProfile():*
        {
            this.main.loading(true);
            try
            {
                this.main.amf_manager.service("CharacterService.getInfo", [Character.char_id, Character.sessionkey, this.char_id], this.friendProfileCallback);
            }
            catch(e:Error)
            {
                this.main.loading(false);
            };
        }

        public function friendProfileCallback(_arg_1:Object):*
        {
            var _local_4:*;
            var _local_5:*;
            this.main.loading(false);
            if (_arg_1.status > 1)
            {
                this.main.getNotice(_arg_1.result);
                return;
            };
            if (_arg_1.status == 0)
            {
                this.main.getError(_arg_1.error);
                return;
            };
            if (_arg_1.clan != null)
            {
                if (_arg_1.clan.banner != null)
                {
                    _local_4 = BulkLoader.getLoader("assets");
                    this.clan = _arg_1.clan;
                    _local_4.add(_arg_1.clan.banner, {"id":"clanBanner"});
                    _local_4.addEventListener(BulkLoader.COMPLETE, this.onClanLogoLoaded);
                    _local_4.start();
                    _local_4 = null;
                }
                else
                {
                    this.clanLogoHolder.visible = false;
                };
            };
            if (this.char_id != Character.char_id)
            {
                _local_5 = ((_arg_1.hasOwnProperty("friend")) && (_arg_1.friend === true));
                this.btn_unfriend.visible = _local_5;
                if (!_local_5)
                {
                    this.btn_AddFriend.visible = true;
                    this.btn_AddFriend.x = (this.btn_AddFriend.x - 150);
                };
                this.eventHandler.addListener(this.btn_unfriend, MouseEvent.CLICK, this.unfriendConfirmation);
                this.eventHandler.addListener(this.btn_AddFriend, MouseEvent.CLICK, this.sendFriendRequest);
            };
            var _local_2:* = _arg_1.character_data;
            if (_local_2.character_class != null)
            {
                this.classMC.gotoAndStop(_local_2.character_class);
            }
            else
            {
                this.classMC.gotoAndStop("classNull");
            };
            if ((((_local_2.character_level < 60) && (_local_2.character_class == null)) && (_local_2.character_rank < 7)))
            {
                this.classMC.visible = false;
            };
            this.classMC.changeClassBtn.visible = false;
            this.character = _arg_1.character_data;
            this.sets = _arg_1.character_sets;
            this.points = _arg_1.character_points;
            this.inventory = _arg_1.character_inventory;
            this.pets = _arg_1.pet_data;
            this.profileTitle.text = (_local_2.character_name + "'s Profile");
            this.txt_id.text = ("ID  " + this.char_id);
            this.eventHandler.addListener(this.txt_id, MouseEvent.CLICK, this.onCopyText);
            this.txt_name.htmlText = Character.colorifyText(this.char_id, _local_2.character_name);
            this.eventHandler.addListener(this.txt_name, MouseEvent.CLICK, this.onCopyText);
            this.txt_lvl.text = ("Lv. " + _local_2.character_level);
            this.rankMC.gotoAndStop(_local_2.character_rank);
            this.element_1.gotoAndStop((int(_local_2.character_element_1) + 1));
            this.element_2.gotoAndStop((int(_local_2.character_element_2) + 1));
            this.element_3.gotoAndStop((int(_local_2.character_element_3) + 1));
            this.txt_wind.text = String(this.points.atrrib_wind);
            this.txt_fire.text = String(this.points.atrrib_fire);
            this.txt_lightning.text = String(this.points.atrrib_lightning);
            this.txt_water.text = String(this.points.atrrib_water);
            this.txt_earth.text = String(this.points.atrrib_earth);
            var _local_3:* = new StatManager(this.main).calculate_xp(int(_local_2.character_level));
            this.txt_hp.text = ((this.calculate_stats_with_data("hp") + " / ") + this.calculate_stats_with_data("hp"));
            this.txt_cp.text = ((this.calculate_stats_with_data("cp") + " / ") + this.calculate_stats_with_data("cp"));
            this.txt_agility.text = this.calculate_stats_with_data("agility");
            this.txt_crit.text = (this.calculate_stats_with_data("critical") + "%");
            this.txt_dodge.text = (this.calculate_stats_with_data("dodge") + "%");
            this.txt_purify.text = (this.calculate_stats_with_data("purify") + "%");
            this.txt_accuracy.text = (this.calculate_stats_with_data("accuracy") + "%");
            this.txt_xp.text = ((_local_2.character_xp + " / ") + _local_3);
            this.xpBar.scaleX = (int(_local_2.character_xp) / int(_local_3));
            this.emblemMC.gotoAndStop((int(_arg_1.account_type) + 1));
            if (_local_2.character_talent_1)
            {
                this.talent_1.gotoAndStop(_local_2.character_talent_1);
            }
            else
            {
                this.talent_1.gotoAndStop(3);
            };
            if (_local_2.character_talent_2)
            {
                this.talent_2.gotoAndStop(_local_2.character_talent_2);
            }
            else
            {
                this.talent_2.gotoAndStop(4);
            };
            if (_local_2.character_talent_3)
            {
                this.talent_3.gotoAndStop(_local_2.character_talent_3);
            }
            else
            {
                this.talent_3.gotoAndStop(4);
            };
            this.outfit_manager.fillOutfit(this.char_mc, this.sets.weapon, this.sets.back_item, this.sets.clothing, this.sets.hairstyle, this.sets.face, this.sets.hair_color, this.sets.skin_color);
            if (this.is_sw)
            {
                this.hideSkills();
            }
            else
            {
                this.loadSkills();
            };
        }

        internal function openDetail(_arg_1:MouseEvent):*
        {
            var _local_4:*;
            var _local_5:*;
            this.detailMC.visible = true;
            this.detailMC.nicknameTxt.text = this.character.character_name;
            var _local_2:Array = [this.sets.hairstyle, this.sets.clothing, this.sets.back_item, this.sets.weapon, this.sets.accessory];
            var _local_3:* = 0;
            while (_local_3 < 5)
            {
                GF.removeAllChild(this.detailMC[("item" + _local_3)].iconHolder);
                if (_local_2[_local_3].split("_")[1] != "00")
                {
                    this.detailMC[("item" + _local_3)].visible = true;
                    NinjaSage.loadIconSWF("items", _local_2[_local_3], this.detailMC[("item" + _local_3)].iconHolder, "icon");
                    _local_4 = Library.getItemInfo(_local_2[_local_3]);
                    this.detailMC[("item" + _local_3)].tooltip = _local_4;
                    this.detailMC[("item" + _local_3)].item_type = _local_4.item_id.split("_")[0];
                    this.eventHandler.addListener(this.detailMC[("item" + _local_3)], MouseEvent.ROLL_OVER, this.tooltipOnHover, false, 0, true);
                    this.eventHandler.addListener(this.detailMC[("item" + _local_3)], MouseEvent.ROLL_OUT, this.tooltipOnOut, false, 0, true);
                }
                else
                {
                    this.detailMC[("item" + _local_3)].visible = false;
                };
                _local_3++;
            };
            if ((("pet_swf" in this.pets) && (!(this.pets.pet_swf == null))))
            {
                GF.removeAllChild(this.detailMC["item5"].iconHolder);
                GF.removeAllChild(this.detailMC.petMc.charMc);
                this.detailMC.petTxt.text = this.pets.pet_name;
                NinjaSage.loadIconSWF("pets", this.pets.pet_swf, this.detailMC.item5.iconHolder, "icon");
                NinjaSage.loadIconSWF("pets", this.pets.pet_swf, this.detailMC.petMc.charMc, this.pets.pet_swf);
                _local_5 = PetInfo.getPetStats(this.pets.pet_swf);
                _local_5.pet_level_player = this.pets.pet_level;
                this.detailMC["item5"].tooltip = _local_5;
                this.detailMC["item5"].item_type = _local_5.pet_id.split("_")[0];
                this.eventHandler.addListener(this.detailMC["item5"], MouseEvent.ROLL_OVER, this.tooltipOnHover, false, 0, true);
                this.eventHandler.addListener(this.detailMC["item5"], MouseEvent.ROLL_OUT, this.tooltipOnOut, false, 0, true);
                this.detailMC.petMc.charMc.scaleX = 1.2;
                this.detailMC.petMc.charMc.scaleY = 1.2;
            }
            else
            {
                this.detailMC["item5"].visible = false;
            };
            this.outfit_manager.fillOutfit(this.detailMC.char_mc, this.sets.weapon, this.sets.back_item, this.sets.clothing, this.sets.hairstyle, this.sets.face, this.sets.hair_color, this.sets.skin_color);
            this.eventHandler.addListener(this.detailMC.closeBtn, MouseEvent.CLICK, this.closeDetail);
        }

        internal function closeDetail(_arg_1:MouseEvent):*
        {
            this.detailMC.visible = false;
            var _local_2:* = 0;
            while (_local_2 < 6)
            {
                GF.removeAllChild(this.detailMC[("item" + _local_2)].iconHolder);
                _local_2++;
            };
            GF.removeAllChild(this.detailMC.petMc.charMc);
            System.gc();
        }

        internal function onCopyText(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name;
            switch (_local_2)
            {
                case "txt_id":
                    System.setClipboard(this.txt_id.text.replace("ID  ", ""));
                    this.main.showMessage("ID Copied!");
                    return;
                case "txt_name":
                    System.setClipboard(this.txt_name.text);
                    this.main.showMessage("Nickname Copied!");
                    return;
            };
        }

        private function onClanLogoLoaded(_arg_1:*):*
        {
            BulkLoader.getLoader("assets").removeEventListener(BulkLoader.COMPLETE, this.onClanLogoLoaded);
            this.clanLogoHolder.addChild(BulkLoader.getLoader("assets").getContent("clanBanner", true));
            NinjaSage.showDynamicTooltip(this.clanLogoHolder, ((("[" + this.clan.id) + "] ") + this.clan.name));
            this.clanLogoHolder.scaleX = 0.5;
            this.clanLogoHolder.scaleY = 0.5;
        }

        protected function calculate_stats(_arg_1:*):*
        {
            return (StatManager.calculate_stats_with_data(_arg_1, this.character.character_level, this.points.atrrib_earth, this.points.atrrib_water, this.points.atrrib_wind, this.points.atrrib_lightning, this.sets.weapon, this.sets.accessory, this.sets.back_item));
        }

        public function calculate_stats_with_data(_arg_1:String, _arg_2:*=0, _arg_3:*=0, _arg_4:*=0, _arg_5:*=0, _arg_6:*=0, _arg_7:*="", _arg_8:*="", _arg_9:*=""):*
        {
            var _local_10:Number = NaN;
            var _local_11:* = undefined;
            var _local_12:* = undefined;
            var _local_13:* = undefined;
            var _local_14:* = undefined;
            var _local_15:* = undefined;
            var _local_16:* = undefined;
            var _local_17:* = undefined;
            check_talent = false;
            check_senjutsu = false;
            if (((_arg_7 == "") || (_arg_2 == 0)))
            {
                check_talent = true;
                check_senjutsu = true;
                _arg_2 = this.character.character_level;
                _arg_3 = this.points.atrrib_earth;
                _arg_4 = this.points.atrrib_water;
                _arg_5 = this.points.atrrib_wind;
                _arg_6 = this.points.atrrib_lightning;
                _arg_7 = this.sets.weapon;
                _arg_9 = this.sets.accessory;
                _arg_8 = this.sets.back_item;
            };
            var _local_18:* = ((WeaponBuffs.getWeaponBuff(_arg_7).effects == null) ? [] : WeaponBuffs.getWeaponBuff(_arg_7).effects);
            var _local_19:* = ((BackItemBuffs.getBackItemBuff(_arg_8).effects == null) ? [] : BackItemBuffs.getBackItemBuff(_arg_8).effects);
            var _local_20:* = ((AccessoryBuffs.getAccessoryBuff(_arg_9).effects == null) ? [] : AccessoryBuffs.getAccessoryBuff(_arg_9).effects);
            var _local_21:Array = [_local_18, _local_19, _local_20];
            if (_arg_1 == "hp")
            {
                _local_11 = ((60 + (int(_arg_2) * 40)) + (_arg_3 * 30));
                return (this.checkEquippedSetNew("hp", _local_11, _local_21));
            };
            if (_arg_1 == "cp")
            {
                _local_12 = (_local_10 = ((60 + (int(_arg_2) * 40)) + (_arg_4 * 30)));
                return (this.checkEquippedSetNew("cp", _local_12, _local_21));
            };
            if (_arg_1 == "agility")
            {
                _local_13 = ((int(9) + int(_arg_2)) + int(_arg_5));
                return (_local_13 = this.checkEquippedSetNew("agility", _local_13, _local_21));
            };
            if (_arg_1 == "critical")
            {
                _local_14 = (5 + (_arg_6 * 0.4));
                return ((_local_14 = this.checkEquippedSetNew("critical", _local_14, _local_21)).toFixed(1));
            };
            if (_arg_1 == "dodge")
            {
                _local_15 = (5 + (_arg_5 * 0.4));
                return ((_local_15 = this.checkEquippedSetNew("dodge", _local_15, _local_21)).toFixed(1));
            };
            if (_arg_1 == "purify")
            {
                _local_16 = (0 + (_arg_4 * 0.4));
                return ((_local_16 = this.checkEquippedSetNew("purify", _local_16, _local_21)).toFixed(1));
            };
            if (_arg_1 == "accuracy")
            {
                _local_17 = 0;
                return ((_local_17 = this.checkEquippedSetNew("accuracy", _local_17, _local_21)).toFixed(1));
            };
        }

        private function applyEffects(_arg_1:Number, _arg_2:Array, _arg_3:Array, _arg_4:Array):Number
        {
            var _local_5:Object;
            var _local_6:Array;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_7:int;
            while (_local_7 < _arg_2.length)
            {
                _local_6 = _arg_2[_local_7];
                _local_8 = 0;
                while (_local_8 < _local_6.length)
                {
                    _local_5 = _local_6[_local_8];
                    if (((_arg_3.indexOf(_local_5.effect) >= 0) || (_arg_4.indexOf(_local_5.effect) >= 0)))
                    {
                        _local_9 = int(_local_5.amount);
                        if (((_local_5.hasOwnProperty("calc_type")) && (!(_local_5.calc_type == null))))
                        {
                            _local_10 = ((_local_5.calc_type == "number") ? _local_9 : int(Math.floor(((_local_9 * _arg_1) / 100))));
                        }
                        else
                        {
                            _local_10 = _local_9;
                        };
                        if (_arg_3.indexOf(_local_5.effect) >= 0)
                        {
                            _arg_1 = (_arg_1 + _local_10);
                        };
                        if (_arg_4.indexOf(_local_5.effect) >= 0)
                        {
                            _arg_1 = (_arg_1 - _local_10);
                        };
                    };
                    _local_8++;
                };
                _local_7++;
            };
            return (_arg_1);
        }

        private function applyMaxEffects(_arg_1:Number, _arg_2:Array, _arg_3:String, _arg_4:String):Number
        {
            var _local_5:Object;
            var _local_6:Array;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_7:int;
            while (_local_7 < _arg_2.length)
            {
                _local_6 = _arg_2[_local_7];
                _local_8 = 0;
                while (_local_8 < _local_6.length)
                {
                    _local_5 = _local_6[_local_8];
                    if (((_local_5.effect == _arg_3) || (_local_5.effect == _arg_4)))
                    {
                        _local_9 = int(_local_5.amount);
                        _local_10 = ((_local_5.calc_type == "number") ? _local_9 : int(Math.floor(((_local_9 * _arg_1) / 100))));
                        if (_local_5.effect == _arg_3)
                        {
                            _arg_1 = (_arg_1 + _local_10);
                        }
                        else
                        {
                            _arg_1 = (_arg_1 - _local_10);
                        };
                    };
                    _local_8++;
                };
                _local_7++;
            };
            return (_arg_1);
        }

        public function checkEquippedSetNew(_arg_1:*, _arg_2:*, _arg_3:*):*
        {
            var _local_4:Object = {
                "agility":{
                    "inc":["agility_increase", "increase_agility"],
                    "dec":["agility_decrease", "decrease_agility"]
                },
                "critical":{
                    "inc":["critical_increase", "increase_critical"],
                    "dec":["critical_decrease", "decrease_critical"]
                },
                "dodge":{
                    "inc":["dodge_increase", "increase_dodge"],
                    "dec":["dodge_decrease", "decrease_dodge"]
                },
                "purify":{
                    "inc":["purify_increase", "increase_purify"],
                    "dec":["decrease_purify", "decrease_purify"]
                },
                "accuracy":{
                    "inc":["accuracy_increase", "increase_accuracy"],
                    "dec":["accuracy_decrease", "decrease_accuracy"]
                }
            };
            switch (_arg_1)
            {
                case "hp":
                    _arg_2 = this.getMaximumHPByMaxCPFromTalent(_arg_2);
                    _arg_2 = this.getMaximumHPFixedFromTalent(_arg_2);
                    _arg_2 = this.getMaximumHPFromTalent(_arg_2);
                    _arg_2 = this.getMaximumHPFromSenjutsu(_arg_2);
                    _arg_2 = this.applyMaxEffects(_arg_2, _arg_3, "max_hp_increase", "max_hp_decrease");
                    break;
                case "cp":
                    _arg_2 = this.getMaximumCPFromTalent(_arg_2);
                    _arg_2 = this.applyMaxEffects(_arg_2, _arg_3, "max_cp_increase", "max_cp_decrease");
                    break;
                case "agility":
                    _arg_2 = this.getAgilityRateFromTalent(_arg_2);
                    _arg_2 = this.applyEffects(_arg_2, _arg_3, _local_4.agility.inc, _local_4.agility.dec);
                    break;
                case "critical":
                    _arg_2 = this.getCriticalRateFromTalent(_arg_2);
                    _arg_2 = this.applyEffects(_arg_2, _arg_3, _local_4.critical.inc, _local_4.critical.dec);
                    break;
                case "dodge":
                    _arg_2 = this.getDodgeFromTalent(_arg_2);
                    _arg_2 = this.applyEffects(_arg_2, _arg_3, _local_4.dodge.inc, _local_4.dodge.dec);
                    break;
                case "purify":
                    _arg_2 = this.getPurifyRateFromTalent(_arg_2);
                    _arg_2 = this.getPurifyRateFromTalentByCP(_arg_2);
                    _arg_2 = this.getPurifyRateFromTalentByHP(_arg_2);
                    _arg_2 = this.applyEffects(_arg_2, _arg_3, _local_4.purify.inc, _local_4.purify.dec);
                    break;
                case "accuracy":
                    _arg_2 = this.getAccuracyFromTalent(_arg_2);
                    _arg_2 = this.applyEffects(_arg_2, _arg_3, _local_4.accuracy.inc, _local_4.accuracy.dec);
                    break;
            };
            return (_arg_2);
        }

        public function checkEquippedSet(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*, _arg_5:*):*
        {
            var _local_6:* = 0;
            if (_arg_1 == "hp")
            {
                if (_arg_3 != null)
                {
                    _arg_2 = this.maxHpIncrease(_arg_2, _arg_3);
                    _arg_2 = this.maxHpDecrease(_arg_2, _arg_3);
                };
                if (_arg_4 != null)
                {
                    _arg_2 = this.maxHpIncrease(_arg_2, _arg_4);
                    _arg_2 = this.maxHpDecrease(_arg_2, _arg_4);
                };
                if (_arg_5 != null)
                {
                    _arg_2 = this.maxHpIncrease(_arg_2, _arg_5);
                    _arg_2 = this.maxHpDecrease(_arg_2, _arg_5);
                };
                if (check_talent)
                {
                    _arg_2 = this.getMaximumHPFromTalent(_arg_2);
                };
                if (check_senjutsu)
                {
                    _arg_2 = this.getMaximumHPFromSenjutsu(_arg_2);
                };
            }
            else
            {
                if (_arg_1 == "cp")
                {
                    if (_arg_3 != null)
                    {
                        _arg_2 = this.maxCpIncrease(_arg_2, _arg_3);
                        _arg_2 = this.maxCpDecrease(_arg_2, _arg_3);
                    };
                    if (_arg_4 != null)
                    {
                        _arg_2 = this.maxCpIncrease(_arg_2, _arg_4);
                        _arg_2 = this.maxCpDecrease(_arg_2, _arg_4);
                    };
                    if (_arg_5 != null)
                    {
                        _arg_2 = this.maxCpIncrease(_arg_2, _arg_5);
                        _arg_2 = this.maxCpDecrease(_arg_2, _arg_5);
                    };
                    if (check_talent)
                    {
                        _arg_2 = this.getMaximumCPFromTalent(_arg_2);
                    };
                }
                else
                {
                    if (_arg_1 == "agility")
                    {
                        if (_arg_3 != null)
                        {
                            _arg_2 = this.checkIncreaseAgility(_arg_2, _arg_3);
                            _arg_2 = this.checkDecreaseAgility(_arg_2, _arg_3);
                        };
                        if (_arg_4 != null)
                        {
                            _arg_2 = this.checkIncreaseAgility(_arg_2, _arg_4);
                            _arg_2 = this.checkDecreaseAgility(_arg_2, _arg_4);
                        };
                        if (_arg_5 != null)
                        {
                            _arg_2 = this.checkIncreaseAgility(_arg_2, _arg_5);
                            _arg_2 = this.checkDecreaseAgility(_arg_2, _arg_5);
                        };
                        if (check_talent)
                        {
                            _arg_2 = this.getAgilityRateFromTalent(_arg_2);
                        };
                    }
                    else
                    {
                        if (_arg_1 == "critical")
                        {
                            if (_arg_3 != null)
                            {
                                _arg_2 = this.checkIncreaseCritical(_arg_2, _arg_3);
                                _arg_2 = this.checkDecreaseCritical(_arg_2, _arg_3);
                            };
                            if (_arg_4 != null)
                            {
                                _arg_2 = this.checkIncreaseCritical(_arg_2, _arg_4);
                                _arg_2 = this.checkDecreaseCritical(_arg_2, _arg_4);
                            };
                            if (_arg_5 != null)
                            {
                                _arg_2 = this.checkIncreaseCritical(_arg_2, _arg_5);
                                _arg_2 = this.checkDecreaseCritical(_arg_2, _arg_5);
                            };
                            if (check_talent)
                            {
                                _arg_2 = this.getCriticalRateFromTalent(_arg_2);
                            };
                        }
                        else
                        {
                            if (_arg_1 == "dodge")
                            {
                                if (_arg_3 != null)
                                {
                                    _arg_2 = this.checkIncreaseDodge(_arg_2, _arg_3);
                                    _arg_2 = this.checkDecreaseDodge(_arg_2, _arg_3);
                                };
                                if (_arg_4 != null)
                                {
                                    _arg_2 = this.checkIncreaseDodge(_arg_2, _arg_4);
                                    _arg_2 = this.checkDecreaseDodge(_arg_2, _arg_4);
                                };
                                if (_arg_5 != null)
                                {
                                    _arg_2 = this.checkIncreaseDodge(_arg_2, _arg_5);
                                    _arg_2 = this.checkDecreaseDodge(_arg_2, _arg_5);
                                };
                                if (check_talent)
                                {
                                    _arg_2 = this.getDodgeFromTalent(_arg_2);
                                };
                            }
                            else
                            {
                                if (_arg_1 == "purify")
                                {
                                    if (_arg_3 != null)
                                    {
                                        _arg_2 = this.checkIncreasePurify(_arg_2, _arg_3);
                                        _arg_2 = this.checkDecreasePurify(_arg_2, _arg_3);
                                    };
                                    if (_arg_4 != null)
                                    {
                                        _arg_2 = this.checkIncreasePurify(_arg_2, _arg_4);
                                        _arg_2 = this.checkDecreasePurify(_arg_2, _arg_4);
                                    };
                                    if (_arg_5 != null)
                                    {
                                        _arg_2 = this.checkIncreasePurify(_arg_2, _arg_5);
                                        _arg_2 = this.checkDecreasePurify(_arg_2, _arg_5);
                                    };
                                    if (check_talent)
                                    {
                                        _arg_2 = this.getPurifyRateFromTalent(_arg_2);
                                        _arg_2 = this.getPurifyRateFromTalentByCP(_arg_2);
                                        _arg_2 = this.getPurifyRateFromTalentByHP(_arg_2);
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (_arg_2);
        }

        public function maxHpIncrease(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "max_hp_increase")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 + _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "max_hp_increase")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "max_hp_increase")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            return (_arg_1);
        }

        public function maxHpDecrease(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "max_hp_decrease")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 - _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "max_hp_decrease")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "max_hp_decrease")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            return (_arg_1);
        }

        public function maxCpIncrease(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "max_cp_increase")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 + _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "max_cp_increase")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "max_cp_increase")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            return (_arg_1);
        }

        public function maxCpDecrease(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "max_cp_decrease")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 - _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "max_cp_decrease")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "max_cp_decrease")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            return (_arg_1);
        }

        public function checkIncreaseAgility(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "agility_increase")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 + _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "agility_increase")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "agility_increase")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect4" in _arg_2))
            {
                if (_arg_2.effect4 == "agility_increase")
                {
                    _local_3 = _arg_2.amount4;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            return (_arg_1);
        }

        public function checkDecreaseAgility(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "agility_decrease")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 - _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "agility_decrease")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "agility_decrease")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            return (_arg_1);
        }

        public function checkIncreaseCritical(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "critical_increase")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 + _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "critical_increase")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "critical_increase")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            return (_arg_1);
        }

        public function checkDecreaseCritical(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "critical_decrease")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 - _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "critical_decrease")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "critical_decrease")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            return (_arg_1);
        }

        public function getDodgeFromTalent(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:* = 0;
            var _local_4:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [this.inventory.char_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                if ((_local_2 = _local_4[_local_5].split(":"))[0] == "skill_1006")
                {
                    _local_3 = _local_2[1];
                };
                _local_5++;
            };
            return (_arg_1 + int(_local_3));
        }

        public function getCriticalDamageFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentCriticalDamageByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public function talentCriticalDamageByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1009:1":0.1,
                "skill_1009:2":0.2,
                "skill_1009:3":0.3,
                "skill_1009:4":0.4,
                "skill_1009:5":0.5,
                "skill_1009:6":0.6,
                "skill_1009:7":0.7,
                "skill_1009:8":0.8,
                "skill_1009:9":0.9,
                "skill_1009:10":1
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public function getExtraChargeCPFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentExtraCPByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public function talentExtraCPByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1010:1":3,
                "skill_1010:2":5,
                "skill_1010:3":8,
                "skill_1010:4":10,
                "skill_1010:5":13,
                "skill_1010:6":15,
                "skill_1010:7":18,
                "skill_1010:8":20,
                "skill_1010:9":23,
                "skill_1010:10":25
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public function getExtraDamageForTaijutsuFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentExtraDmgTaijutsuByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public function talentExtraDmgTaijutsuByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1001:1":1,
                "skill_1001:2":1.5,
                "skill_1001:3":2.4,
                "skill_1001:4":3.7,
                "skill_1001:5":5.4,
                "skill_1001:6":7.6,
                "skill_1001:7":10.1,
                "skill_1001:8":13,
                "skill_1001:9":16.1,
                "skill_1001:10":20
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public function getReduceHPForTaijutsuFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentExtraReduceDmgTaijutsuByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public function talentExtraReduceDmgTaijutsuByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1001:1":10,
                "skill_1001:2":20,
                "skill_1001:3":30,
                "skill_1001:4":40,
                "skill_1001:5":50,
                "skill_1001:6":60,
                "skill_1001:7":70,
                "skill_1001:8":80,
                "skill_1001:9":90,
                "skill_1001:10":100
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public function getCopyJutsuPrcFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentCopyJutsuPrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public function talentCopyJutsuPrcByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1018:1":1,
                "skill_1018:2":2,
                "skill_1018:3":3,
                "skill_1018:4":5,
                "skill_1018:5":7,
                "skill_1018:6":10,
                "skill_1018:7":13,
                "skill_1018:8":16,
                "skill_1018:9":21,
                "skill_1018:10":25
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public function getCopyGenjutsuPrcFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentCopyGenjutsuPrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public function talentCopyGenjutsuPrcByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1019:1":1,
                "skill_1019:2":2,
                "skill_1019:3":3,
                "skill_1019:4":5,
                "skill_1019:5":8,
                "skill_1019:6":11,
                "skill_1019:7":15,
                "skill_1019:8":19,
                "skill_1019:9":24,
                "skill_1019:10":30
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public function getHPCPRevivePrcFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentHPCPRevivePrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public function talentHPCPRevivePrcByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1023:1":2,
                "skill_1023:2":3,
                "skill_1023:3":5,
                "skill_1023:4":7,
                "skill_1023:5":11,
                "skill_1023:6":15,
                "skill_1023:7":20,
                "skill_1023:8":26,
                "skill_1023:9":32,
                "skill_1023:10":40
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public function getReboundChanceFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentReboundChanceByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public function talentReboundChanceByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1007:1":13,
                "skill_1007:2":19,
                "skill_1007:3":25,
                "skill_1007:4":31,
                "skill_1007:5":37,
                "skill_1007:6":44,
                "skill_1007:7":51,
                "skill_1007:8":58,
                "skill_1007:9":64,
                "skill_1007:10":71
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public function getStunChanceFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentStunChanceByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public function talentStunChanceByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1007:1":5,
                "skill_1007:2":12,
                "skill_1007:3":18,
                "skill_1007:4":22,
                "skill_1007:5":28,
                "skill_1007:6":34,
                "skill_1007:7":40,
                "skill_1007:8":46,
                "skill_1007:9":52,
                "skill_1007:10":60
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public function getReduceDamagePercentFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentReduceDamagePrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public function talentReduceDamagePrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1014:1":1,
                "skill_1014:2":1,
                "skill_1014:3":1,
                "skill_1014:4":2,
                "skill_1014:5":2,
                "skill_1014:6":3,
                "skill_1014:7":3,
                "skill_1014:8":4,
                "skill_1014:9":4,
                "skill_1014:10":5,
                "skill_1024:1":1,
                "skill_1024:2":2,
                "skill_1024:3":3,
                "skill_1024:4":4,
                "skill_1024:5":5,
                "skill_1024:6":6,
                "skill_1024:7":7,
                "skill_1024:8":8,
                "skill_1024:9":9,
                "skill_1024:10":10
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public function getHPRecoverPercentUnder50PRCFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentHPRPUnder50PrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public function talentHPRPUnder50PrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1024:1":1,
                "skill_1024:2":1,
                "skill_1024:3":1,
                "skill_1024:4":2,
                "skill_1024:5":2,
                "skill_1024:6":2,
                "skill_1024:7":3,
                "skill_1024:8":3,
                "skill_1024:9":3,
                "skill_1024:10":4
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public function getReboundDamagePercentAndAmountFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = undefined;
            var _local_3:Array = [0, 0];
            var _local_4:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [this.inventory.char_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_1 = _local_4[_local_5].split(":");
                _local_2 = this.talentReboundDamagePrcAndAmtByLvl(_local_1[0], _local_1[1]);
                _local_3[0] = (_local_3[0] + _local_2[0]);
                _local_3[1] = (_local_3[1] + _local_2[1]);
                _local_5++;
            };
            return (_local_3);
        }

        public function talentReboundDamagePrcAndAmtByLvl(_arg_1:*, _arg_2:*):Array
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1015:1":[1, 3],
                "skill_1015:2":[3, 5],
                "skill_1015:3":[5, 7],
                "skill_1015:4":[7, 10],
                "skill_1015:5":[9, 14],
                "skill_1015:6":[11, 18],
                "skill_1015:7":[13, 22],
                "skill_1015:8":[15, 28],
                "skill_1015:9":[17, 36],
                "skill_1015:10":[19, 50]
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return ([0, 0]);
        }

        public function getStunResistPercentFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentStunResistPrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public function talentStunResistPrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1014:1":1,
                "skill_1014:2":2,
                "skill_1014:3":3,
                "skill_1014:4":4,
                "skill_1014:5":6,
                "skill_1014:6":8,
                "skill_1014:7":11,
                "skill_1014:8":14,
                "skill_1014:9":17,
                "skill_1014:10":20
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public function getChanceToRecoverHPByAttackFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentRecoverHPPrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public function talentRecoverHPPrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1025:1":2,
                "skill_1025:2":4,
                "skill_1025:3":6,
                "skill_1025:4":8,
                "skill_1025:5":10,
                "skill_1025:6":12,
                "skill_1025:7":14,
                "skill_1025:8":16,
                "skill_1025:9":18,
                "skill_1025:10":20
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public function getPoisonResistPercentFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [this.inventory.char_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + this.talentPoisonResistPrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public function talentPoisonResistPrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1025:1":100,
                "skill_1025:2":100,
                "skill_1025:3":100,
                "skill_1025:4":100,
                "skill_1025:5":100,
                "skill_1025:6":100,
                "skill_1025:7":100,
                "skill_1025:8":100,
                "skill_1025:9":100,
                "skill_1025:10":100
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public function getCriticalRateFromTalent(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:int;
            var _local_4:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [this.inventory.char_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + this.talentCriticalByLvl(_local_2[0], _local_2[1]));
                _local_5++;
            };
            return (_arg_1 + int(_local_3));
        }

        public function talentCriticalByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1009:1":1,
                "skill_1009:2":1,
                "skill_1009:3":1,
                "skill_1009:4":2,
                "skill_1009:5":2,
                "skill_1009:6":3,
                "skill_1009:7":3,
                "skill_1009:8":4,
                "skill_1009:9":4,
                "skill_1009:10":5
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public function getAccuracyFromTalent(_arg_1:int):*
        {
            var _local_2:* = undefined;
            var _local_3:int;
            var _local_4:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [this.inventory.char_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + this.talentAccuracyByLvl(_local_2[0], _local_2[1]));
                _local_5++;
            };
            _arg_1 = (_arg_1 + _local_3);
            return (int(_arg_1));
        }

        public function talentAccuracyByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1006:1":1,
                "skill_1006:2":2,
                "skill_1006:3":3,
                "skill_1006:4":4,
                "skill_1006:5":5,
                "skill_1006:6":6,
                "skill_1006:7":7,
                "skill_1006:8":8,
                "skill_1006:9":9,
                "skill_1006:10":10
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public function getPurifyRateFromTalent(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:* = 0;
            var _local_4:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [this.inventory.char_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentPurifyByTalent(_local_2[0], _local_2[1]));
                _local_5++;
            };
            return (_arg_1 + _local_3);
        }

        public function getPurifyRateFromTalentByCP(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:* = 0;
            var _local_4:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [this.inventory.char_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentPurifyByLvlCP(_local_2[0], _local_2[1]));
                _local_5++;
            };
            var _local_6:int = int(Math.round((this.calculate_stats_with_data("cp") / _local_3)));
            return (_arg_1 + _local_6);
        }

        public function getPurifyRateFromTalentByHP(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:* = 0;
            var _local_4:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [this.inventory.char_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentPurifyByLvlHP(_local_2[0], _local_2[1]));
                _local_5++;
            };
            var _local_6:int = int(Math.round((this.calculate_stats_with_data("hp") / _local_3)));
            return (_arg_1 + _local_6);
        }

        public function getAgilityRateFromTalent(_arg_1:int):int
        {
            var _local_5:int;
            var _local_6:int;
            var _local_7:String;
            var _local_2:Array = [{
                "key":"skill_1003:1",
                "value":1
            }, {
                "key":"skill_1003:2",
                "value":2
            }, {
                "key":"skill_1003:3",
                "value":3
            }, {
                "key":"skill_1003:4",
                "value":4
            }, {
                "key":"skill_1003:5",
                "value":6
            }, {
                "key":"skill_1003:6",
                "value":8
            }, {
                "key":"skill_1003:7",
                "value":11
            }, {
                "key":"skill_1003:8",
                "value":14
            }, {
                "key":"skill_1003:9",
                "value":17
            }, {
                "key":"skill_1003:10",
                "value":20
            }];
            if (((this.inventory.char_talent_skills == null) || (this.inventory.char_talent_skills == "")))
            {
                return (_arg_1);
            };
            var _local_3:Array = ((this.inventory.char_talent_skills.indexOf(",") >= 0) ? this.inventory.char_talent_skills.split(",") : [this.inventory.char_talent_skills]);
            var _local_4:int;
            _local_5 = 0;
            while (_local_5 < _local_3.length)
            {
                _local_7 = String(_local_3[_local_5]);
                _local_6 = 0;
                while (_local_6 < _local_2.length)
                {
                    if (_local_2[_local_6].key == _local_7)
                    {
                        _local_4 = (_local_4 + int(_local_2[_local_6].value));
                        break;
                    };
                    _local_6++;
                };
                _local_5++;
            };
            return (_arg_1 + Math.floor(((_arg_1 * _local_4) / 100)));
        }

        public function getMaximumCPFromTalent(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:int;
            var _local_4:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [this.inventory.char_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + this.talentMaxCPByLvl(_local_4[_local_5], _arg_1));
                _local_5++;
            };
            return (int((int(_arg_1) + int(_local_3))));
        }

        public function talentMaxCPByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = {
                "skill_1010:1":2,
                "skill_1010:2":4,
                "skill_1010:3":6,
                "skill_1010:4":8,
                "skill_1010:5":10,
                "skill_1010:6":12,
                "skill_1010:7":14,
                "skill_1010:8":16,
                "skill_1010:9":18,
                "skill_1010:10":20
            };
            if ((_arg_1 in _local_3))
            {
                return (Math.floor(((_arg_2 * _local_3[_arg_1]) / 100)));
            };
            return (int(0));
        }

        public function getMaximumHPFixedFromTalent(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:int;
            var _local_4:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [this.inventory.char_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentMaxHPFixedByLvl(_local_2[0], _local_2[1]));
                _local_5++;
            };
            return (_arg_1 + _local_3);
        }

        public function getMaximumHPByMaxCPFromTalent(_arg_1:int):*
        {
            var _local_2:* = undefined;
            var _local_3:* = 0;
            var _local_4:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [this.inventory.char_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentMaxHPByMaxCP(_local_2[0], _local_2[1]));
                _local_5++;
            };
            var _local_6:int = int(Math.round(((this.calculate_stats_with_data("cp") * _local_3) / 100)));
            return (_arg_1 + _local_6);
        }

        public function getMaximumHPFromTalent(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:int;
            var _local_4:Array = [];
            if (this.inventory.char_talent_skills != "")
            {
                if (this.inventory.char_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = this.inventory.char_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [this.inventory.char_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + this.talentMaxHPByLvl(_local_4[_local_5], _arg_1));
                _local_5++;
            };
            return (int((int(_arg_1) + int(_local_3))));
        }

        public function talentMaxHPByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = {
                "skill_1003:1":1,
                "skill_1003:2":2,
                "skill_1003:3":3,
                "skill_1003:4":4,
                "skill_1003:5":5,
                "skill_1003:6":6,
                "skill_1003:7":7,
                "skill_1003:8":8,
                "skill_1003:9":9,
                "skill_1003:10":10
            };
            if ((_arg_1 in _local_3))
            {
                return (Math.floor(((_arg_2 * _local_3[_arg_1]) / 100)));
            };
            return (int(0));
        }

        public function getMaximumHPFromSenjutsu(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:int;
            var _local_4:Array = [];
            if (this.inventory.char_senjutsu_skills != "")
            {
                if (this.inventory.char_senjutsu_skills.indexOf(",") >= 0)
                {
                    _local_4 = this.inventory.char_senjutsu_skills.split(",");
                }
                else
                {
                    _local_4 = [this.inventory.char_senjutsu_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + this.senjutsuMaxHPByLvl(_local_4[_local_5], _arg_1));
                _local_5++;
            };
            return (int((int(_arg_1) + int(_local_3))));
        }

        public function senjutsuMaxHPByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = {
                "skill_3001:1":5,
                "skill_3001:2":5,
                "skill_3001:3":6,
                "skill_3001:4":6,
                "skill_3001:5":7,
                "skill_3001:6":8,
                "skill_3001:7":9,
                "skill_3001:8":10,
                "skill_3001:9":11,
                "skill_3001:10":12
            };
            if ((_arg_1 in _local_3))
            {
                return (Math.floor(((_arg_2 * _local_3[_arg_1]) / 100)));
            };
            return (int(0));
        }

        public function checkIncreaseDodge(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "dodge_increase")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 + _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "dodge_increase")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "dodge_increase")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            return (_arg_1);
        }

        public function checkDecreaseDodge(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "dodge_decrease")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 - _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "dodge_decrease")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "dodge_decrease")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            return (_arg_1);
        }

        public function checkIncreasePurify(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "purify_increase")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 + _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "purify_increase")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "purify_increase")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            return (_arg_1);
        }

        public function checkDecreasePurify(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "purify_decrease")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 - _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "purify_decrease")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "purify_decrease")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            return (_arg_1);
        }

        private function hideSkills():void
        {
            this.bgSkill.visible = false;
            var _local_1:* = 1;
            while (_local_1 < 9)
            {
                this[("skill_" + _local_1)].visible = false;
                _local_1++;
            };
        }

        protected function loadSkills():*
        {
            var _local_3:*;
            var _local_1:* = this.sets.skills.split(",");
            var _local_2:* = 1;
            while (_local_2 < 9)
            {
                if (_local_2 <= _local_1.length)
                {
                    _local_3 = SkillLibrary.getSkillInfo(_local_1[(_local_2 - 1)]);
                    if (_local_3.item_id == "null")
                    {
                        return;
                    };
                    this[("skill_" + _local_2)].tooltip = _local_3;
                    this[("skill_" + _local_2)].item_type = _local_3.skill_id.split("_")[0];
                    this.eventHandler.addListener(this[("skill_" + _local_2)], MouseEvent.ROLL_OVER, this.tooltipOnHover, false, 0, true);
                    this.eventHandler.addListener(this[("skill_" + _local_2)], MouseEvent.ROLL_OUT, this.tooltipOnOut, false, 0, true);
                    NinjaSage.loadIconSWF("skills", _local_1[(_local_2 - 1)], this[("skill_" + _local_2)]);
                };
                _local_2++;
            };
        }

        protected function unfriendConfirmation(e:MouseEvent):*
        {
            this.confirmation = (getDefinitionByName("Popups.Confirmation") as Class);
            this.confirmation = new this.confirmation();
            this.confirmation.txtMc.txt.text = (("Are you sure want to unfriend " + this.character.character_name) + "?");
            this.confirmation.btn_close.addEventListener(MouseEvent.CLICK, function (_arg_1:MouseEvent):*
            {
                removeChild(self.confirmation);
            });
            this.confirmation.btn_confirm.addEventListener(MouseEvent.CLICK, this.unfriendCharacter);
            addChild(this.confirmation);
        }

        protected function unfriendCharacter(param1:MouseEvent):void
        {
            try
            {
                removeChild(this.confirmation);
                this.main.amf_manager.service("FriendService.removeFriend", [Character.char_id, Character.sessionkey, this.char_id], this.unfriendCallback);
            }
            catch(e:Error)
            {
                this.main.loading(false);
            };
        }

        public function unfriendCallback(_arg_1:Object):*
        {
            if (_arg_1.status > 1)
            {
                this.main.getNotice(_arg_1.result);
                return;
            };
            if (_arg_1.status == 0)
            {
                this.main.getError(_arg_1.error);
                return;
            };
            this.main.giveMessage(_arg_1.result);
            this.closePanel(null);
        }

        public function sendFriendRequest(_arg_1:MouseEvent):*
        {
            this.main.amf_manager.service("FriendService.addFriend", [Character.char_id, Character.sessionkey, this.char_id], this.onFriendRequestSent);
        }

        public function onFriendRequestSent(_arg_1:Object):*
        {
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
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

        private function tooltipOnHover(_arg_1:MouseEvent):*
        {
            var _local_2:*;
            switch (_arg_1.currentTarget.item_type)
            {
                case "skill":
                    _local_2 = (((((((((((("" + _arg_1.currentTarget.tooltip.skill_name) + "\n(Skill)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.skill_level) + '\n<font color="#ff0000">Damage: ') + _arg_1.currentTarget.tooltip.skill_damage) + '</font>\n<font color="#0000ff">CP Cost: ') + _arg_1.currentTarget.tooltip.skill_cp_cost) + '</font>\n<font color="#ffcc00">Cooldown: ') + _arg_1.currentTarget.tooltip.skill_cooldown) + "</font>\n\n") + _arg_1.currentTarget.tooltip.skill_description);
                    break;
                case "wpn":
                    _local_2 = (((((((("" + _arg_1.currentTarget.tooltip.item_name) + "\n(Weapon)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.item_level) + '\n<font color="#ff0000">Damage: ') + _arg_1.currentTarget.tooltip.item_damage) + "</font>\n\n") + _arg_1.currentTarget.tooltip.item_description);
                    break;
                case "back":
                    _local_2 = (((((("" + _arg_1.currentTarget.tooltip.item_name) + "\n(Back Item)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.item_level) + "\n\n") + _arg_1.currentTarget.tooltip.item_description);
                    break;
                case "set":
                    _local_2 = (((((("" + _arg_1.currentTarget.tooltip.item_name) + "\n(Clothes)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.item_level) + "\n\n") + _arg_1.currentTarget.tooltip.item_description);
                    break;
                case "hair":
                    _local_2 = (((((("" + _arg_1.currentTarget.tooltip.item_name) + "\n(Hairstyle)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.item_level) + "\n\n") + _arg_1.currentTarget.tooltip.item_description);
                    break;
                case "accessory":
                    _local_2 = (((((("" + _arg_1.currentTarget.tooltip.item_name) + "\n(Accessory)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.item_level) + "\n\n") + _arg_1.currentTarget.tooltip.item_description);
                    break;
                case "pet":
                    _local_2 = (((((("" + _arg_1.currentTarget.tooltip.pet_name) + "\n(Pet)\n") + "\nLevel ") + _arg_1.currentTarget.tooltip.pet_level_player) + "\n\n") + _arg_1.currentTarget.tooltip.description);
                    break;
            };
            this.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_2);
        }

        internal function tooltipOnOut(_arg_1:MouseEvent):void
        {
            this.tooltip.hide();
        }

        internal function closePanel(_arg_1:MouseEvent):void
        {
            if (this.destroyed)
            {
                return;
            };
            this.destroyed = true;
            parent.removeChild(this);
            this.outfit_manager.destroy();
            this.outfit_manager = null;
            if (!BattleVars.MATCH_RUNNING)
            {
                BulkLoader.getLoader("assets").removeAll();
            };
            GF.removeAllChild(this.char_mc);
            this.char_mc = null;
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.tooltip.destroy();
            this.clan = null;
            this.character = null;
            this.sets = null;
            this.pets = null;
            this.points = null;
            this.inventory = null;
            this.skillInformations = [];
            this.confirmation = null;
            this.tooltip = null;
            this.self = null;
            this.main = null;
            var _local_2:* = 1;
            while (_local_2 < 9)
            {
                GF.removeAllChild(this[("skill_" + _local_2)].iconHolder);
                _local_2++;
            };
            NinjaSage.clearDynamicTooltip(this.clanLogoHolder);
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            System.gc();
            GF.removeAllChild(this);
        }


    }
}//package Panels

