// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.AnimationLibrary

package Storage
{
    public class AnimationLibrary 
    {

        private static var data:* = {};
        private static var _constructed:* = false;


        public static function constructData(_arg_1:*):*
        {
            var _local_2:*;
            AnimationLibrary.data = {};
            for each (_local_2 in _arg_1)
            {
                AnimationLibrary.data[_local_2.id] = AnimationLibrary.prefix(_local_2);
            };
            _constructed = true;
            _local_2 = null;
        }

        public static function get constructed():*
        {
            return (AnimationLibrary._constructed == true);
        }

        public static function getAnimation(_arg_1:String):*
        {
            if (data.hasOwnProperty(_arg_1))
            {
                return (data[_arg_1]);
            };
            return (AnimationLibrary.prefix());
        }

        private static function prefix(_arg_1:*=null):*
        {
            return ({
                "id":(((!(_arg_1 == null)) && ("id" in _arg_1)) ? _arg_1.id : ""),
                "name":(((!(_arg_1 == null)) && ("name" in _arg_1)) ? _arg_1.name : ""),
                "price":(((!(_arg_1 == null)) && ("price" in _arg_1)) ? _arg_1.price : 0),
                "buyable":(((!(_arg_1 == null)) && ("buyable" in _arg_1)) ? _arg_1.buyable : false),
                "premium":(((!(_arg_1 == null)) && ("premium" in _arg_1)) ? _arg_1.premium : false),
                "loop":(((!(_arg_1 == null)) && ("loop" in _arg_1)) ? _arg_1.loop : false),
                "category":(((!(_arg_1 == null)) && ("category" in _arg_1)) ? _arg_1.category : ""),
                "label":(((!(_arg_1 == null)) && ("label" in _arg_1)) ? _arg_1.label : "")
            });
        }

        public static function getCategory(category:String):Array
        {
            var item:* = undefined;
            var items:* = [];
            for (item in data)
            {
                if (((data[item].hasOwnProperty("category")) && (data[item].category == category)))
                {
                    items.push(data[item]);
                };
            };
            return (items.sort(function (_arg_1:*, _arg_2:*):*
            {
                return (int(_arg_1.id.split("_")[1]) - int(_arg_2.id.split("_")[1]));
            }));
        }


    }
}//package Storage

