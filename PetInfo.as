// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.PetInfo

package Storage
{
    import flash.display.MovieClip;

    public class PetInfo extends MovieClip 
    {

        private static var data:* = {};
        private static var _constructed:* = false;

        public var main:*;

        public function PetInfo(_arg_1:*)
        {
            this.main = _arg_1;
        }

        public static function constructData(_arg_1:*):*
        {
            var _local_2:*;
            PetInfo.data = {};
            for each (_local_2 in _arg_1)
            {
                PetInfo.data[_local_2.id] = PetInfo.prefix(_local_2);
            };
            _constructed = true;
            _local_2 = null;
        }

        public static function getPetStats(_arg_1:String):*
        {
            if (data.hasOwnProperty(_arg_1))
            {
                if (((Boolean(data[_arg_1].hasOwnProperty("pet_hp"))) && (int(data[_arg_1].pet_hp) == 0)))
                {
                    data[_arg_1].pet_hp = (60 + (int(data[_arg_1].pet_level) * 40));
                    data[_arg_1].pet_cp = (60 + (int(data[_arg_1].pet_level) * 40));
                    data[_arg_1].pet_agility = (9 + int(data[_arg_1].pet_level));
                };
                if (!data[_arg_1].hasOwnProperty("pet_combustion"))
                {
                    data[_arg_1].pet_combustion = 0;
                };
                if (!data[_arg_1].hasOwnProperty("pet_accuracy"))
                {
                    data[_arg_1].pet_accuracy = 10;
                };
                if (!data[_arg_1].hasOwnProperty("pet_name"))
                {
                    data[_arg_1].pet_id = "pet_00Error";
                    data[_arg_1].pet_name = "";
                    data[_arg_1].pet_hp = 999999;
                    data[_arg_1].pet_cp = 999999;
                    data[_arg_1].pet_dodge = 1000;
                    data[_arg_1].pet_agility = 10;
                    data[_arg_1].description = "ERROR";
                    data[_arg_1].size_x = 0.65;
                    data[_arg_1].size_y = 0.65;
                };
                return (data[_arg_1]);
            };
            return (PetInfo.prefix());
        }

        private static function prefix(_arg_1:*=null):*
        {
            return ({
                "pet_id":(((!(_arg_1 == null)) && ("id" in _arg_1)) ? _arg_1.id : null),
                "pet_level":(((!(_arg_1 == null)) && ("level" in _arg_1)) ? _arg_1.level : null),
                "pet_name":(((!(_arg_1 == null)) && ("name" in _arg_1)) ? _arg_1.name : null),
                "pet_rank":(((!(_arg_1 == null)) && ("rank" in _arg_1)) ? _arg_1.rank : null),
                "pet_hp":(((!(_arg_1 == null)) && ("hp" in _arg_1)) ? _arg_1.hp : null),
                "pet_cp":(((!(_arg_1 == null)) && ("cp" in _arg_1)) ? _arg_1.cp : null),
                "pet_dodge":(((!(_arg_1 == null)) && ("dodge" in _arg_1)) ? _arg_1.dodge : null),
                "pet_critical":(((!(_arg_1 == null)) && ("critical" in _arg_1)) ? _arg_1.critical : null),
                "pet_purify":(((!(_arg_1 == null)) && ("purify" in _arg_1)) ? _arg_1.purify : null),
                "pet_accuracy":(((!(_arg_1 == null)) && ("accuracy" in _arg_1)) ? _arg_1.accuracy : null),
                "pet_agility":(((!(_arg_1 == null)) && ("agility" in _arg_1)) ? _arg_1.agility : null),
                "description":(((!(_arg_1 == null)) && ("description" in _arg_1)) ? _arg_1.description : null),
                "pet_emblem":(((!(_arg_1 == null)) && ("emblem" in _arg_1)) ? _arg_1.emblem : null),
                "pet_combine":(((!(_arg_1 == null)) && ("combine" in _arg_1)) ? _arg_1.combine : false),
                "pet_combine_gold":(((!(_arg_1 == null)) && ("combine_gold" in _arg_1)) ? _arg_1.combine_gold : null),
                "size_x":(((!(_arg_1 == null)) && ("size_x" in _arg_1)) ? _arg_1.size_x : null),
                "size_y":(((!(_arg_1 == null)) && ("size_y" in _arg_1)) ? _arg_1.size_y : null),
                "attacks":(((!(_arg_1 == null)) && ("attacks" in _arg_1)) ? _arg_1.attacks : null),
                "multi_hit":(((!(_arg_1 == null)) && ("multi_hit" in _arg_1)) ? _arg_1.multi_hit : null),
                "anims":(((!(_arg_1 == null)) && ("anims" in _arg_1)) ? _arg_1.anims : null)
            });
        }

        public static function getCopy(_arg_1:*):*
        {
            return (JSON.parse(JSON.stringify(PetInfo.getPetStats(_arg_1))));
        }

        public static function getEncyIds():*
        {
            var item:* = undefined;
            var items:* = [];
            for (item in data)
            {
                if (!((data[item].hasOwnProperty("pet_na")) && (data[item].pet_na == true)))
                {
                    items.push(item);
                };
            };
            return (items.sort(function (_arg_1:*, _arg_2:*):*
            {
                return (int(_arg_1.split("_")[1]) - int(_arg_2.split("_")[1]));
            }));
        }

        public static function getCombinePet():*
        {
            var item:* = undefined;
            var items:* = [];
            for (item in data)
            {
                if (!((data[item].hasOwnProperty("pet_combine")) && (data[item].pet_combine == false)))
                {
                    items.push(item);
                };
            };
            return (items.sort(function (_arg_1:*, _arg_2:*):*
            {
                return (int(_arg_1.split("_")[1]) - int(_arg_2.split("_")[1]));
            }));
        }

        public static function get constructed():*
        {
            return (PetInfo._constructed == true);
        }


    }
}//package Storage

