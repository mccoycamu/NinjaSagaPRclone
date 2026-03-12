// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.CharacterSelect

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import id.ninjasage.EventHandler;
    import flash.events.MouseEvent;
    import Managers.OutfitManager;
    import Storage.Character;
    import Storage.Library;
    import Storage.SkillLibrary;
    import com.utils.GF;
    import flash.system.System;
    import br.com.stimuli.loading.BulkLoader;
    import com.adobe.crypto.CUCSG;
    import id.ninjasage.Log;

    public class CharacterSelect extends MovieClip 
    {

        public var btn_delete:SimpleButton;
        public var btn_play:SimpleButton;
        public var btn_upgrade:SimpleButton;
        public var btn_logout:SimpleButton;
        public var slot_0:MovieClip;
        public var slot_1:MovieClip;
        public var slot_2:MovieClip;
        public var slot_3:MovieClip;
        public var slot_4:MovieClip;
        public var slot_5:MovieClip;
        public var txt_account:TextField;
        public var txt_version:TextField;
        public var main:*;
        public var eventHandler:EventHandler = new EventHandler();

        public function CharacterSelect(param1:*)
        {
            this.main = param1;
            this.eventHandler.addListener(this.btn_logout, MouseEvent.CLICK, this.logOut);
            OutfitManager.removeChildsFromMovieClips(this.main.loader);
            this.main.loading(true);
            param1.amf_manager.service("SystemLogin.getAllCharacters", [Character.account_id, Character.sessionkey], this.charResponse);
        }

        internal function charResponse(param1:Object):void
        {
            this.main.loading(false);
            var _loc2_:*;
            var _loc3_:*;
            if (param1.status == 1)
            {
                this.setButtons(false);
                _loc2_ = param1.total_characters;
                Character.account_type = param1.account_type;
                Character.account_tokens = param1.tokens;
                Character.emblem_duration = param1.emblem_duration;
                this.txt_version.text = Character.build_num;
                if (_loc2_ > 6)
                {
                    _loc2_ = 6;
                };
                if (Character.account_type == 0)
                {
                    this.txt_account.text = "Free User";
                }
                else
                {
                    if (Character.account_type == 1)
                    {
                        this.txt_account.text = "Premium User";
                    };
                };
                this.clearSlots();
                _loc3_ = 0;
                while (_loc3_ < _loc2_)
                {
                    Character.char_ids[_loc3_] = param1.account_data[_loc3_].char_id;
                    Character.character_names[_loc3_] = param1.account_data[_loc3_].character_name;
                    Character.character_lvls[_loc3_] = param1.account_data[_loc3_].character_level;
                    Character.character_xps[_loc3_] = param1.account_data[_loc3_].character_xp;
                    Character.character_genders[_loc3_] = param1.account_data[_loc3_].character_gender;
                    Character.character_ranks[_loc3_] = param1.account_data[_loc3_].character_rank;
                    Character.character_element_1s[_loc3_] = param1.account_data[_loc3_].character_element_1;
                    Character.character_element_2s[_loc3_] = param1.account_data[_loc3_].character_element_2;
                    Character.character_element_3s[_loc3_] = param1.account_data[_loc3_].character_element_3;
                    Character.character_talent_1s[_loc3_] = param1.account_data[_loc3_].character_talent_1;
                    Character.character_talent_2s[_loc3_] = param1.account_data[_loc3_].character_talent_2;
                    Character.character_talent_3s[_loc3_] = param1.account_data[_loc3_].character_talent_3;
                    Character.character_golds[_loc3_] = param1.account_data[_loc3_].character_gold;
                    Character.character_tps[_loc3_] = param1.account_data[_loc3_].character_tp;
                    Character.character_prestiges[_loc3_] = param1.account_data[_loc3_].character_prestige;
                    this[("slot_" + _loc3_)].buttonMode = true;
                    this.eventHandler.addListener(this[("slot_" + _loc3_)], MouseEvent.CLICK, this.selectChar);
                    this.eventHandler.addListener(this[("slot_" + _loc3_)], MouseEvent.MOUSE_OVER, this.over);
                    this.eventHandler.addListener(this[("slot_" + _loc3_)], MouseEvent.MOUSE_OUT, this.out);
                    this[("slot_" + _loc3_)]["btn_create"].visible = false;
                    this[("slot_" + _loc3_)]["txt_name"].text = param1.account_data[_loc3_].character_name;
                    this[("slot_" + _loc3_)]["txt_lvl"].text = ("Level  " + param1.account_data[_loc3_].character_level);
                    if (param1.account_data[_loc3_].character_gender == 0)
                    {
                        this[("slot_" + _loc3_)]["txt_gender"].text = "Male";
                    }
                    else
                    {
                        this[("slot_" + _loc3_)]["txt_gender"].text = "Female";
                    };
                    _loc3_++;
                };
            }
            else
            {
                if (param1.status == 2)
                {
                    _loc2_ = param1.total_characters;
                    Character.account_type = param1.account_type;
                    Character.account_tokens = param1.tokens;
                    this.txt_version.text = Character.build_num;
                    if (Character.account_type == 0)
                    {
                        this.txt_account.text = "Free User";
                    }
                    else
                    {
                        if (Character.account_type == 1)
                        {
                            this.txt_account.text = "Premium User";
                        };
                    };
                    this.clearSlots();
                }
                else
                {
                    this.main.getError(param1.error);
                };
            };
        }

        internal function setButtons(param1:Boolean):void
        {
            if (param1)
            {
                this.btn_play.visible = true;
                this.eventHandler.addListener(this.btn_play, MouseEvent.CLICK, this.playGame);
                this.btn_delete.visible = true;
                this.eventHandler.addListener(this.btn_delete, MouseEvent.CLICK, this.deleteChar);
                if (Character.account_type == 0)
                {
                    this.btn_upgrade.visible = true;
                    this.eventHandler.addListener(this.btn_upgrade, MouseEvent.CLICK, this.upgradeAccount);
                }
                else
                {
                    this.btn_upgrade.visible = false;
                };
            }
            else
            {
                this.btn_play.visible = false;
                this.btn_upgrade.visible = false;
                this.btn_delete.visible = false;
            };
        }

        internal function arrangeItemsByLevel(param1:*):*
        {
            var _loc2_:*;
            var _loc3_:*;
            var _loc4_:* = [];
            var _loc5_:* = [];
            if (param1 != "")
            {
                if (param1.indexOf(",") >= 0)
                {
                    _loc4_ = param1.split(",");
                }
                else
                {
                    _loc4_ = [param1];
                };
                _loc2_ = 0;
                while (_loc2_ < _loc4_.length)
                {
                    _loc3_ = _loc4_[_loc2_].split(":");
                    _loc5_.push({
                        "level":Library.getItemInfo(_loc3_[0]).item_level,
                        "item_id":_loc3_[0],
                        "item_amount":_loc3_[1]
                    });
                    _loc2_++;
                };
                _loc5_.sortOn("level", (Array.DESCENDING | Array.NUMERIC));
                if (_loc5_[0].item_id.indexOf("hair") >= 0)
                {
                    param1 = _loc5_[0].item_id;
                }
                else
                {
                    param1 = ((_loc5_[0].item_id + ":") + _loc5_[0].item_amount);
                };
                _loc2_ = 1;
                while (_loc2_ < _loc5_.length)
                {
                    if (_loc5_[_loc2_].item_id.indexOf("hair") >= 0)
                    {
                        param1 = ((param1 + ",") + _loc5_[_loc2_].item_id);
                    }
                    else
                    {
                        param1 = ((((param1 + ",") + _loc5_[_loc2_].item_id) + ":") + _loc5_[_loc2_].item_amount);
                    };
                    _loc2_++;
                };
                return (param1);
            };
            return ("");
        }

        internal function arrangeByLevel(param1:*):*
        {
            var _loc2_:*;
            var _loc3_:* = [];
            var _loc4_:* = [];
            if (param1 != "")
            {
                if (param1.indexOf(",") >= 0)
                {
                    _loc3_ = param1.split(",");
                }
                else
                {
                    _loc3_ = [param1];
                };
                _loc2_ = 0;
                while (_loc2_ < _loc3_.length)
                {
                    _loc4_.push({
                        "level":SkillLibrary.getSkillInfo(_loc3_[_loc2_]).skill_level,
                        "skill_id":_loc3_[_loc2_]
                    });
                    _loc2_++;
                };
                _loc4_.sortOn("level", (Array.DESCENDING | Array.NUMERIC));
                param1 = _loc4_[0].skill_id;
                _loc2_ = 1;
                while (_loc2_ < _loc4_.length)
                {
                    param1 = ((param1 + ",") + _loc4_[_loc2_].skill_id);
                    _loc2_++;
                };
                return (param1);
            };
            return ("");
        }

        internal function playGame(param1:MouseEvent):void
        {
            this.main.loading(true);
            this.main.amf_manager.service("SystemLogin.getCharacterData", [Character.char_id, Character.sessionkey], this.getLoginResponse);
        }

        internal function logOut(param1:MouseEvent):void
        {
            this.main.loadPanel("Managers.LoginManager");
            GF.removeAllChild(this);
            this.destroy();
        }

        internal function getLoginResponse(param1:Object):*
        {
            var _loc2_:*;
            var _loc3_:int;
            this.main.loading(false);
            if (param1.status == 1)
            {
                Character.character_weapon = param1.character_sets.weapon;
                Character.character_back_item = param1.character_sets.back_item;
                Character.character_accessory = param1.character_sets.accessory;
                Character.character_set = param1.character_sets.clothing;
                Character.character_hair = param1.character_sets.hairstyle;
                Character.character_skill_set = param1.character_sets.skills;
                Character.character_color_hair = param1.character_sets.hair_color;
                Character.character_color_skin = param1.character_sets.skin_color;
                Character.character_face = param1.character_sets.face;
                Character.equipped_animations = ((param1.character_sets.hasOwnProperty("anims")) ? param1.character_sets.anims : {});
                Character.equipped_animations = {
                    "dodge":((Character.equipped_animations.hasOwnProperty("dodge")) ? Character.equipped_animations.dodge : "ani_1"),
                    "standby":((Character.equipped_animations.hasOwnProperty("standby")) ? Character.equipped_animations.standby : "ani_5"),
                    "win":((Character.equipped_animations.hasOwnProperty("win")) ? Character.equipped_animations.win : "ani_7"),
                    "dead":((Character.equipped_animations.hasOwnProperty("dead")) ? Character.equipped_animations.dead : "ani_3"),
                    "charge":((Character.equipped_animations.hasOwnProperty("charge")) ? Character.equipped_animations.charge : "ani_9"),
                    "hit":((Character.equipped_animations.hasOwnProperty("hit")) ? Character.equipped_animations.hit : "ani_10"),
                    "run":((Character.equipped_animations.hasOwnProperty("run")) ? Character.equipped_animations.run : "ani_11")
                };
                Character.character_pet = "";
                if (("pet_swf" in param1.pet_data))
                {
                    Character.character_pet = param1.pet_data.pet_swf;
                    Character.character_pet_id = param1.pet_data.pet_id;
                };
                Character.pet_count = ((param1.hasOwnProperty("pet_count")) ? int(param1.pet_count) : 0);
                Character.character_equipped_skills = param1.character_sets.skills;
                Character.character_equipped_senjutsu_skills = param1.character_sets.senjutsu_skills;
                Character.character_weapons = this.arrangeItemsByLevel(param1.character_inventory.char_weapons);
                Character.character_back_items = this.arrangeItemsByLevel(param1.character_inventory.char_back_items);
                Character.character_accessories = this.arrangeItemsByLevel(param1.character_inventory.char_accessories);
                Character.character_sets = this.arrangeItemsByLevel(param1.character_inventory.char_sets);
                Character.character_hairs = this.arrangeItemsByLevel(param1.character_inventory.char_hairs);
                Character.character_skills = this.arrangeByLevel(param1.character_inventory.char_skills);
                Character.character_talent_skills = param1.character_inventory.char_talent_skills;
                Character.character_senjutsu_skills = param1.character_inventory.char_senjutsu_skills;
                Character.character_materials = param1.character_inventory.char_materials;
                Character.character_essentials = param1.character_inventory.char_essentials;
                Character.character_consumables = ((param1.character_inventory.hasOwnProperty("char_items")) ? param1.character_inventory.char_items : "");
                Character.character_animations = ((param1.character_inventory.hasOwnProperty("char_animations")) ? param1.character_inventory.char_animations : "");
                Character.character_animations = (Character.character_animations + ",ani_1,ani_3,ani_5,ani_7,ani_9,ani_10,ani_11");
                Character.slot_weapons = param1.character_slots.weapons;
                Character.slot_back_items = param1.character_slots.back_items;
                Character.slot_accessories = param1.character_slots.accessories;
                Character.slot_hairs = param1.character_slots.hairstyles;
                Character.slot_sets = param1.character_slots.clothing;
                Character.atrrib_wind = param1.character_points.atrrib_wind;
                Character.atrrib_fire = param1.character_points.atrrib_fire;
                Character.atrrib_lightning = param1.character_points.atrrib_lightning;
                Character.atrrib_water = param1.character_points.atrrib_water;
                Character.atrrib_earth = param1.character_points.atrrib_earth;
                Character.atrrib_free = param1.character_points.atrrib_free;
                Character.welcome_status = param1.events.welcome_bonus;
                Character.character_recruit_ids = this.createArrayForRecruiters(param1.recruiters);
                Character.character_recruit_npc_amount = this.createArrayForRecruiterData(param1.recruit_data);
                Character.has_notification = param1.has_unread_mails;
                Character.character_class = param1.character_data.character_class;
                Character.character_senjutsu = param1.character_data.character_senjutsu;
                Character.character_ss = param1.character_data.character_ss;
                Character.features = param1.features;
                Character.character_pvp_point = param1.character_data.character_pvp_points;
                Character.character_merit = param1.character_data.character_merit;
                if (param1.clan != null)
                {
                    Character.clan_id = param1.clan.id;
                    Character.clan_name = param1.clan.name;
                    Character.clan_banner = param1.clan.banner;
                }
                else
                {
                    Character.clan_id = null;
                    Character.clan_name = null;
                    Character.clan_banner = null;
                };
                this.main.loadPanel("Panels.Village");
                this.main.loadPanel("Panels.HUD");
                this.main.startBgm();
                if (("announcements" in param1))
                {
                    _loc2_ = this.main.loadPanel("Panels.News", true);
                    _loc2_.visible = (!(param1.announcements == ""));
                    _loc2_.txt.htmlText = param1.announcements;
                    _loc2_ = null;
                };
                if (Character.banners.length > 0)
                {
                    _loc3_ = 0;
                    while (_loc3_ < Character.banners.length)
                    {
                        this.main.getPromotion(Character.banners[_loc3_]);
                        _loc3_++;
                    };
                };
                GF.removeAllChild(this);
                this.destroy();
                System.gc();
            };
        }

        internal function loadCharAsset():*
        {
            var _loc2_:*;
            var _loc1_:* = BulkLoader.getLoader("assets");
            for each (_loc2_ in [Character.character_weapon, Character.character_set, Character.character_back_item, Character.character_face, Character.character_hair])
            {
                _loc1_.add((("items/" + _loc2_) + ".swf"));
            };
            _loc1_.start();
            _loc1_ = null;
        }

        public function createArrayForRecruiters(param1:Array):*
        {
            var _loc2_:*;
            var _loc3_:*;
            var _loc4_:*;
            var _loc5_:Array = [];
            if (param1.length > 0)
            {
                _loc2_ = param1[1];
                if (param1[0].length > 0)
                {
                    _loc4_ = 0;
                    while (_loc4_ < param1[0].length)
                    {
                        _loc5_.push(param1[0][_loc4_].recruited_char_id);
                        _loc4_++;
                    };
                };
                _loc3_ = CUCSG.hash(_loc5_[0]);
                if (_loc2_ != _loc3_)
                {
                    this.main.getError(204);
                };
            };
            return (_loc5_);
        }

        public function createArrayForRecruiterData(param1:Array):*
        {
            var _loc2_:*;
            var _loc3_:Array = [];
            if (param1.length > 0)
            {
                _loc2_ = 0;
                while (_loc2_ < param1.length)
                {
                    _loc3_.push({
                        "recruiter_id":param1[_loc2_].recruiter_id,
                        "amount":param1[_loc2_].amount
                    });
                    _loc2_++;
                };
            };
            return (_loc3_);
        }

        internal function over(param1:MouseEvent):void
        {
            if (param1.currentTarget.currentFrame !== 3)
            {
                param1.currentTarget.gotoAndStop(2);
            };
        }

        internal function out(param1:MouseEvent):void
        {
            if (param1.currentTarget.currentFrame !== 3)
            {
                param1.currentTarget.gotoAndStop(1);
            };
        }

        internal function deleteChar(param1:MouseEvent):void
        {
            this.main.loadPanel("Popups.CharacterDelete");
        }

        internal function upgradeAccount(param1:MouseEvent):void
        {
            this.main.loadPanel("Popups.EmblemUpgrade");
        }

        internal function selectChar(param1:MouseEvent):void
        {
            this["slot_0"].gotoAndStop(1);
            this["slot_1"].gotoAndStop(1);
            this["slot_2"].gotoAndStop(1);
            this["slot_3"].gotoAndStop(1);
            this["slot_4"].gotoAndStop(1);
            this["slot_5"].gotoAndStop(1);
            param1.currentTarget.gotoAndStop(3);
            var _loc2_:* = param1.currentTarget.name.split("_");
            _loc2_ = _loc2_[1];
            Character.char_id = Character.char_ids[_loc2_];
            Character.character_name = Character.character_names[_loc2_];
            Character.character_lvl = Character.character_lvls[_loc2_];
            Character.character_xp = Character.character_xps[_loc2_];
            Character.character_gender = Character.character_genders[_loc2_];
            Character.character_rank = Character.character_ranks[_loc2_];
            Character.character_element_1 = Character.character_element_1s[_loc2_];
            Character.character_element_2 = Character.character_element_2s[_loc2_];
            Character.character_element_3 = Character.character_element_3s[_loc2_];
            Character.character_talent_1 = Character.character_talent_1s[_loc2_];
            Character.character_talent_2 = Character.character_talent_2s[_loc2_];
            Character.character_talent_3 = Character.character_talent_3s[_loc2_];
            Character.character_gold = Character.character_golds[_loc2_];
            Character.character_tp = Character.character_tps[_loc2_];
            Character.character_prestige = Character.character_prestiges[_loc2_];
            Character.selected_char = _loc2_;
            this.setButtons(true);
        }

        internal function clearSlots():void
        {
            var _loc1_:* = 0;
            while (_loc1_ < 6)
            {
                this[("slot_" + _loc1_)].gotoAndStop(1);
                this[("slot_" + _loc1_)]["btn_create"].visible = true;
                this.eventHandler.addListener(this[("slot_" + _loc1_)]["btn_create"], MouseEvent.CLICK, this.createChar);
                this[("slot_" + _loc1_)]["txt_name"].text = "Create Character";
                this[("slot_" + _loc1_)]["txt_lvl"].text = "";
                this[("slot_" + _loc1_)]["txt_gender"].text = "";
                _loc1_++;
            };
            this.setButtons(false);
        }

        internal function createChar(param1:MouseEvent):void
        {
            if (((Character.account_type == 0) && (!(param1.currentTarget.parent.name === "slot_0"))))
            {
                this.main.loadPanel("Popups.EmblemUpgrade");
            }
            else
            {
                this.main.loadPanel("Panels.CharacterCreate");
                this.destroy();
                parent.removeChild(this);
            };
        }

        public function destroy():*
        {
            Log.debug(this, "DESTROY");
            GF.removeAllChild(this);
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            this.main = null;
        }


    }
}//package Panels

