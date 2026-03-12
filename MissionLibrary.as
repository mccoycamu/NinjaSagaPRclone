// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.MissionLibrary

package Storage
{
    import flash.display.MovieClip;

    public class MissionLibrary extends MovieClip 
    {

        private static var data:* = {};
        private static var _constructed:* = false;

        public var main:*;

        public function MissionLibrary(_arg_1:*)
        {
            this.main = _arg_1;
        }

        public static function constructData(_arg_1:*):*
        {
            var _local_2:*;
            MissionLibrary.data = {};
            for each (_local_2 in _arg_1)
            {
                MissionLibrary.data[_local_2.id] = MissionLibrary.prefix(_local_2);
            };
            _constructed = true;
            _local_2 = null;
        }

        public static function getMissionInfo(_arg_1:String):*
        {
            if (data.hasOwnProperty(_arg_1))
            {
                return (data[_arg_1]);
            };
            return (MissionLibrary.prefix());
        }

        public static function getCopy(_arg_1:*):*
        {
            return (JSON.parse(JSON.stringify(MissionLibrary.getMissionInfo(_arg_1))));
        }

        private static function prefix(_arg_1:*=null):*
        {
            return ({
                "msn_id":(((!(_arg_1 == null)) && ("id" in _arg_1)) ? _arg_1.id : "null"),
                "msn_enemy":(((!(_arg_1 == null)) && ("enemies" in _arg_1)) ? _arg_1.enemies : []),
                "msn_bg":(((!(_arg_1 == null)) && ("bg" in _arg_1)) ? _arg_1.bg : "null"),
                "msn_grade":(((!(_arg_1 == null)) && ("grade" in _arg_1)) ? _arg_1.grade : "a"),
                "msn_name":(((!(_arg_1 == null)) && ("name" in _arg_1)) ? _arg_1.name : "null"),
                "msn_description":(((!(_arg_1 == null)) && ("description" in _arg_1)) ? _arg_1.description : "null"),
                "msn_level":(((!(_arg_1 == null)) && ("level" in _arg_1)) ? _arg_1.level : 1),
                "msn_premium":(((!(_arg_1 == null)) && ("premium" in _arg_1)) ? _arg_1.premium : false),
                "msn_dialog":(((!(_arg_1 == null)) && ("dialog" in _arg_1)) ? _arg_1.dialog : []),
                "msn_visible":(((!(_arg_1 == null)) && ("visible" in _arg_1)) ? _arg_1.visible : false),
                "msn_rewards":(((!(_arg_1 == null)) && ("rewards" in _arg_1)) ? _arg_1.rewards : [])
            });
        }

        public static function getMissionIds(grade:*):*
        {
            var item:* = undefined;
            var items:* = [];
            for (item in data)
            {
                if (data[item].msn_grade == grade)
                {
                    if (!((data[item].hasOwnProperty("visible")) && (data[item].visible == true)))
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

        public static function get constructed():*
        {
            return (MissionLibrary._constructed == true);
        }


    }
}//package Storage

