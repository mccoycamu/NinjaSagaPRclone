// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.NpcInfo

package Storage
{
    import flash.display.MovieClip;

    public class NpcInfo extends MovieClip 
    {

        private static var data:* = {};
        private static var _constructed:* = false;

        public var main:*;

        public function NpcInfo(_arg_1:*)
        {
            this.main = _arg_1;
        }

        public static function constructData(_arg_1:*):*
        {
            var _local_2:*;
            NpcInfo.data = {};
            for each (_local_2 in _arg_1)
            {
                NpcInfo.data[_local_2.id] = NpcInfo.prefix(_local_2);
            };
            _constructed = true;
            _local_2 = null;
        }

        public static function getNpcStats(_arg_1:String):*
        {
            if (data.hasOwnProperty(_arg_1))
            {
                if (!data[_arg_1].hasOwnProperty("npc_max_hp"))
                {
                    data[_arg_1].npc_max_hp = data[_arg_1].npc_hp;
                };
                if (!data[_arg_1].hasOwnProperty("npc_combustion"))
                {
                    data[_arg_1].npc_combustion = 5;
                };
                if (!data[_arg_1].hasOwnProperty("npc_accuracy"))
                {
                    data[_arg_1].npc_accuracy = 5;
                };
                if (!data[_arg_1].hasOwnProperty("npc_name"))
                {
                    data[_arg_1].npc_id = "ene_00Error";
                    data[_arg_1].npc_name = "";
                    data[_arg_1].npc_hp = 999999;
                    data[_arg_1].npc_cp = 999999;
                    data[_arg_1].npc_dodge = 1000;
                    data[_arg_1].npc_agility = 10;
                    data[_arg_1].description = "ERROR";
                    data[_arg_1].skillDmg1 = 10001;
                    data[_arg_1].skillDmg2 = 10002;
                    data[_arg_1].skillDmg3 = 10003;
                    data[_arg_1].skillDmg4 = 10004;
                    data[_arg_1].skillDmg5 = 10005;
                    data[_arg_1].size_x = 0.65;
                    data[_arg_1].size_y = 0.65;
                };
                return (data[_arg_1]);
            };
            return (NpcInfo.prefix());
        }

        private static function prefix(_arg_1:*=null):*
        {
            return ({
                "npc_id":(((!(_arg_1 == null)) && ("id" in _arg_1)) ? _arg_1.id : null),
                "npc_level":(((!(_arg_1 == null)) && ("level" in _arg_1)) ? _arg_1.level : null),
                "npc_name":(((!(_arg_1 == null)) && ("name" in _arg_1)) ? _arg_1.name : null),
                "npc_rank":(((!(_arg_1 == null)) && ("rank" in _arg_1)) ? _arg_1.rank : null),
                "npc_hp":(((!(_arg_1 == null)) && ("hp" in _arg_1)) ? _arg_1.hp : null),
                "npc_cp":(((!(_arg_1 == null)) && ("cp" in _arg_1)) ? _arg_1.cp : null),
                "npc_dodge":(((!(_arg_1 == null)) && ("dodge" in _arg_1)) ? _arg_1.dodge : null),
                "npc_critical":(((!(_arg_1 == null)) && ("critical" in _arg_1)) ? _arg_1.critical : null),
                "npc_purify":(((!(_arg_1 == null)) && ("purify" in _arg_1)) ? _arg_1.purify : null),
                "npc_accuracy":(((!(_arg_1 == null)) && ("accuracy" in _arg_1)) ? _arg_1.accuracy : null),
                "npc_agility":(((!(_arg_1 == null)) && ("agility" in _arg_1)) ? _arg_1.agility : null),
                "description":(((!(_arg_1 == null)) && ("description" in _arg_1)) ? _arg_1.description : null),
                "size_x":(((!(_arg_1 == null)) && ("size_x" in _arg_1)) ? _arg_1.size_x : null),
                "size_y":(((!(_arg_1 == null)) && ("size_y" in _arg_1)) ? _arg_1.size_y : null),
                "anims":(((!(_arg_1 == null)) && ("anims" in _arg_1)) ? _arg_1.anims : null),
                "attacks":(((!(_arg_1 == null)) && ("attacks" in _arg_1)) ? _arg_1.attacks : null),
                "na":(((!(_arg_1 == null)) && ("na" in _arg_1)) ? _arg_1.na : false)
            });
        }

        public static function getEncyIds():*
        {
            var item:* = undefined;
            var items:* = [];
            for (item in data)
            {
                if (!((data[item].hasOwnProperty("npc_na")) && (data[item].npc_na == true)))
                {
                    items.push(item);
                };
            };
            return (items.sort(function (_arg_1:*, _arg_2:*):*
            {
                return (int(_arg_1.split("_")[1]) - int(_arg_2.split("_")[1]));
            }));
        }

        public static function getCopy(_arg_1:*):*
        {
            return (JSON.parse(JSON.stringify(NpcInfo.getNpcStats(_arg_1))));
        }

        public static function get constructed():*
        {
            return (NpcInfo._constructed == true);
        }


    }
}//package Storage

