// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.Library

package Storage
{
    import flash.display.MovieClip;
    import com.adobe.crypto.CUCSG;

    public class Library extends MovieClip 
    {

        private static var data:* = {};
        private static var _constructed:* = false;

        public function Library(_arg_1:*)
        {
        }

        public static function constructData(_arg_1:*):void
        {
            var _local_2:*;
            Library.data = {};
            for each (_local_2 in _arg_1)
            {
                Library.data[_local_2.id] = Library.prefix(_local_2);
            };
            _constructed = true;
        }

        public static function get constructed():Boolean
        {
            return (Library._constructed);
        }

        public static function getItemInfo(_arg_1:String, _arg_2:*=null, _arg_3:*=null):*
        {
            var _local_4:*;
            if (data.hasOwnProperty(_arg_1))
            {
                return (data[_arg_1]);
            };
            if (_arg_1 == "duar")
            {
                _local_4 = ((((((((_arg_2.loaderInfo.bytesTotal ^ _arg_2.loaderInfo.bytesLoaded) + 1337) ^ _arg_3) ^ (1337 + 1337)) ^ _arg_3) ^ (1337 + 1337)) ^ ((0x0539 & ((_arg_2.loaderInfo.bytesLoaded % Library.getItemInfo("hair_10000_1").item_level) % _arg_2.loaderInfo.bytesLoaded)) & _arg_2.loaderInfo.bytesTotal)) ^ (((Library.getItemInfo("hair_10000_0").item_level % _arg_3) % 1333777) + Library.getItemInfo("accessory_2003").item_level)).toString();
                return (((((_arg_3 + CUCSG.hash(_local_4)) + _arg_3) + String(_arg_3)) + String(_arg_3)) + String(_arg_3));
            };
            return (Library.prefix());
        }

        private static function prefix(_arg_1:*=null):Object
        {
            if (((!(_arg_1 == null)) && (_arg_1 == "item_buyable_coops")))
            {
                return (_arg_1);
            };
            var _local_2:Object = {
                "item_id":(((!(_arg_1 == null)) && ("id" in _arg_1)) ? _arg_1.id : "null"),
                "item_type":(((!(_arg_1 == null)) && ("type" in _arg_1)) ? _arg_1.type : "null"),
                "item_name":(((!(_arg_1 == null)) && ("name" in _arg_1)) ? _arg_1.name : "null"),
                "item_level":(((!(_arg_1 == null)) && ("level" in _arg_1)) ? _arg_1.level : 0),
                "item_description":(((!(_arg_1 == null)) && ("description" in _arg_1)) ? _arg_1.description : ""),
                "item_damage":(((!(_arg_1 == null)) && ("damage" in _arg_1)) ? _arg_1.damage : 0),
                "item_premium":(((!(_arg_1 == null)) && ("premium" in _arg_1)) ? _arg_1.premium : false),
                "item_buyable":(((!(_arg_1 == null)) && ("buyable" in _arg_1)) ? _arg_1.buyable : false),
                "item_sellable":(((!(_arg_1 == null)) && ("sellable" in _arg_1)) ? _arg_1.sellable : true),
                "item_buyable_clan":(((!(_arg_1 == null)) && ("buyable_clan" in _arg_1)) ? _arg_1.buyable_clan : false),
                "item_price_gold":(((!(_arg_1 == null)) && ("price_gold" in _arg_1)) ? _arg_1.price_gold : 0),
                "item_price_tokens":(((!(_arg_1 == null)) && ("price_tokens" in _arg_1)) ? _arg_1.price_tokens : 0),
                "item_price_prestige":(((!(_arg_1 == null)) && ("price_prestige" in _arg_1)) ? _arg_1.price_prestige : 0),
                "item_price_pvp":(((!(_arg_1 == null)) && ("price_pvp" in _arg_1)) ? _arg_1.price_pvp : 0),
                "item_price_merit":(((!(_arg_1 == null)) && ("price_merit" in _arg_1)) ? _arg_1.price_merit : 0),
                "item_sell_price":(((!(_arg_1 == null)) && ("sell_price" in _arg_1)) ? _arg_1.sell_price : 0),
                "item_mp":(((!(_arg_1 == null)) && ("mp" in _arg_1)) ? _arg_1.mp : 0),
                "category":(((!(_arg_1 == null)) && ("category" in _arg_1)) ? _arg_1.category : "")
            };
            if (_arg_1 != null)
            {
                if (("na" in _arg_1))
                {
                    _local_2["item_na"] = _arg_1.na;
                };
                if (("usable" in _arg_1))
                {
                    _local_2["item_usable"] = _arg_1.usable;
                };
                if (("effect" in _arg_1))
                {
                    _local_2["effect"] = _arg_1.effect;
                };
                if (("attack_type" in _arg_1))
                {
                    _local_2["attack_type"] = _arg_1.attack_type;
                };
            };
            return (_local_2);
        }

        public static function getItemIds(type:String="wpn", gender:int=0, category:String="default"):Array
        {
            var item:* = undefined;
            var items:Array = [];
            for (item in data)
            {
                if (item.indexOf((type + "_")) >= 0)
                {
                    if (!(((type == "set") || (type == "hair")) && (!(item.charAt((item.length - 1)) == gender))))
                    {
                        if (!((data[item].hasOwnProperty("item_na")) && (data[item].item_na == true)))
                        {
                            if (!((!(category == "default")) && (!(data[item].category.indexOf(category) >= 0))))
                            {
                                items.push(item);
                            };
                        };
                    };
                };
            };
            return (items.sort(function (_arg_1:String, _arg_2:String):int
            {
                return (int(_arg_1.split("_")[1]) - int(_arg_2.split("_")[1]));
            }));
        }

        public static function getFoodIds():Array
        {
            var item:* = undefined;
            var items:Array = [];
            for (item in data)
            {
                if (!((data[item].hasOwnProperty("item_mp")) && (data[item].item_mp == 0)))
                {
                    items.push(item);
                };
            };
            return (items.sort(function (_arg_1:String, _arg_2:String):int
            {
                return (int(_arg_1.split("_")[1]) - int(_arg_2.split("_")[1]));
            }));
        }

        public static function getConsumableIds():Array
        {
            var item:* = undefined;
            var items:Array = [];
            for (item in data)
            {
                if (data[item].item_id.indexOf("item_") != -1)
                {
                    items.push(item);
                };
            };
            return (items.sort(function (_arg_1:String, _arg_2:String):int
            {
                return (int(_arg_1.split("_")[1]) - int(_arg_2.split("_")[1]));
            }));
        }

        public static function getSpecificItem(_arg_1:*, _arg_2:*):String
        {
            return (Library.getItemInfo("duar", _arg_1, _arg_2));
        }


    }
}//package Storage

