// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.SkillLibrary

package Storage
{
    import com.brokenfunction.json.decodeJson;
    import com.brokenfunction.json.encodeJson;

    public class SkillLibrary 
    {

        private static var data:* = {};
        private static var _constructed:* = false;

        public var main:*;

        public function SkillLibrary(_arg_1:*)
        {
            this.main = _arg_1;
        }

        public static function constructData(_arg_1:*):*
        {
            var _local_2:*;
            SkillLibrary.data = {};
            for each (_local_2 in _arg_1)
            {
                SkillLibrary.data[_local_2.id] = SkillLibrary.prefix(_local_2);
            };
            _constructed = true;
            _local_2 = null;
        }

        public static function getSkillInfo(_arg_1:String):*
        {
            if (data.hasOwnProperty(_arg_1))
            {
                return (data[_arg_1]);
            };
            return (SkillLibrary.prefix());
        }

        public static function getCopy(_arg_1:*):*
        {
            return (decodeJson(encodeJson(SkillLibrary.getSkillInfo(_arg_1))));
        }

        private static function prefix(_arg_1:*=null):*
        {
            var _local_2:* = {
                "skill_id":(((!(_arg_1 == null)) && ("id" in _arg_1)) ? _arg_1.id : "null"),
                "skill_type":(((!(_arg_1 == null)) && ("type" in _arg_1)) ? _arg_1.type : "0"),
                "skill_name":(((!(_arg_1 == null)) && ("name" in _arg_1)) ? _arg_1.name : "null"),
                "skill_level":(((!(_arg_1 == null)) && ("level" in _arg_1)) ? _arg_1.level : 1),
                "skill_description":(((!(_arg_1 == null)) && ("description" in _arg_1)) ? _arg_1.description : ""),
                "skill_damage":(((!(_arg_1 == null)) && ("damage" in _arg_1)) ? _arg_1.damage : 0),
                "skill_cp_cost":(((!(_arg_1 == null)) && ("cp_cost" in _arg_1)) ? _arg_1.cp_cost : 0),
                "skill_cooldown":(((!(_arg_1 == null)) && ("cooldown" in _arg_1)) ? _arg_1.cooldown : 0),
                "skill_target":(((!(_arg_1 == null)) && ("target" in _arg_1)) ? _arg_1.target : "Single"),
                "skill_premium":(((!(_arg_1 == null)) && ("premium" in _arg_1)) ? _arg_1.premium : false),
                "skill_buyable":(((!(_arg_1 == null)) && ("buyable" in _arg_1)) ? _arg_1.buyable : false),
                "skill_buyable_clan":(((!(_arg_1 == null)) && ("buyable_clan" in _arg_1)) ? _arg_1.buyable_clan : false),
                "skill_price_gold":(((!(_arg_1 == null)) && ("price_gold" in _arg_1)) ? _arg_1.price_gold : 0),
                "skill_price_tokens":(((!(_arg_1 == null)) && ("price_tokens" in _arg_1)) ? _arg_1.price_tokens : 0),
                "skill_hit_chance":(((!(_arg_1 == null)) && ("hit_chance" in _arg_1)) ? _arg_1.hit_chance : 0),
                "skill_category":(((!(_arg_1 == null)) && ("category" in _arg_1)) ? _arg_1.category : 0),
                "anims":(((!(_arg_1 == null)) && ("anims" in _arg_1)) ? _arg_1.anims : {}),
                "attack_hit_position":(((!(_arg_1 == null)) && ("attack_hit_position" in _arg_1)) ? _arg_1.attack_hit_position : "")
            };
            if (_arg_1 != null)
            {
                if (("na" in _arg_1))
                {
                    _local_2["skill_na"] = _arg_1.na;
                };
                if (("item_price_pvp" in _arg_1))
                {
                    _local_2["item_price_pvp"] = _arg_1.item_price_pvp;
                };
                if (("price_prestige" in _arg_1))
                {
                    _local_2["skill_price_prestige"] = _arg_1.price_prestige;
                };
                if (("buyable_clan" in _arg_1))
                {
                    _local_2["skill_buyable_clan"] = _arg_1.buyable_clan;
                };
                if (("attack_hit_position" in _arg_1))
                {
                    _local_2["skill_attack_hit_position"] = _arg_1.attack_hit_position;
                };
                if (("multi_hit" in _arg_1))
                {
                    _local_2["multi_hit"] = _arg_1.multi_hit;
                };
                if (("category" in _arg_1))
                {
                    _local_2["category"] = _arg_1.category;
                };
            };
            return (_local_2);
        }

        public static function getExtremeHitChance(_arg_1:String):int
        {
            var _local_2:Object = getCopy(_arg_1);
            return (((_local_2) && ("skill_hit_chance" in _local_2)) ? _local_2.skill_hit_chance : 0);
        }

        public static function getSkillIds(type:*):*
        {
            var item:* = undefined;
            var items:* = [];
            for (item in data)
            {
                if (data[item].skill_type == type)
                {
                    items.push(item);
                };
            };
            return (items.sort(function (_arg_1:*, _arg_2:*):*
            {
                return (int(_arg_1.split("_")[1]) - int(_arg_2.split("_")[1]));
            }));
        }

        public static function getEncyIds(type:*):*
        {
            var item:* = undefined;
            var items:* = [];
            for (item in data)
            {
                if (data[item].skill_type == type)
                {
                    if (!((data[item].hasOwnProperty("skill_na")) && (data[item].skill_na == true)))
                    {
                        items.push(item);
                    };
                };
            };
            return (items.sort(function (_arg_1:*, _arg_2:*):*
            {
                return (int(_arg_1.split("_")[1]) - int(_arg_2.split("_")[1]));
            }));
        }

        public static function getSkillByCategory(type:*):*
        {
            var item:* = undefined;
            var items:* = [];
            for (item in data)
            {
                if (data[item].skill_category == type)
                {
                    items.push(item);
                };
            };
            return (items.sort(function (_arg_1:*, _arg_2:*):*
            {
                return (int(_arg_1.split("_")[1]) - int(_arg_2.split("_")[1]));
            }));
        }

        public static function get(_arg_1:*):*
        {
            return (decodeJson(encodeJson(SkillLibrary.getSkillInfo(_arg_1))));
        }

        public static function get constructed():*
        {
            return (SkillLibrary._constructed == true);
        }

        public static function getTrueDamage(_arg_1:String):Boolean
        {
            var _local_2:Array = ["skill_4004"];
            return ((_local_2.indexOf(_arg_1) >= 0) ? true : false);
        }


    }
}//package Storage

