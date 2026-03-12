// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.SkillBuffs

package Storage
{
    import id.ninjasage.Util;

    public class SkillBuffs 
    {

        private static var data:Object = {};
        private static var _constructed:Boolean = false;


        public static function getCopy(_arg_1:String):Object
        {
            return (Util.copy(SkillBuffs.getSkillBuff(_arg_1)));
        }

        public static function constructData(_arg_1:Array):void
        {
            var _local_2:Object;
            SkillBuffs.data = {};
            for each (_local_2 in _arg_1)
            {
                SkillBuffs.data[_local_2.skill_id] = SkillBuffs.prefix(_local_2);
            };
            _constructed = true;
        }

        public static function getSkillBuff(_arg_1:String):Object
        {
            var _local_2:Array;
            var _local_3:int;
            var _local_4:Object;
            if (data.hasOwnProperty(_arg_1))
            {
                _local_2 = data[_arg_1]["skill_effect"];
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    _local_4 = _local_2[_local_3];
                    SkillBuffs.ensureDefaults(_local_4, {
                        "duration":0,
                        "calc_type":"percent",
                        "amount":0,
                        "amount_prc":0,
                        "amount_hp":0,
                        "amount_cp":0,
                        "chance":100,
                        "reduce_type":"MAX",
                        "no_disperse":false
                    });
                    _local_3++;
                };
                return (data[_arg_1]);
            };
            return (SkillBuffs.prefix());
        }

        private static function ensureDefaults(_arg_1:Object, _arg_2:Object):void
        {
            var _local_3:String;
            for (_local_3 in _arg_2)
            {
                if (!_arg_1.hasOwnProperty(_local_3))
                {
                    _arg_1[_local_3] = _arg_2[_local_3];
                };
            };
        }

        private static function prefix(_arg_1:Object=null):Object
        {
            return ({
                "skill_id":(((!(_arg_1 == null)) && ("skill_id" in _arg_1)) ? _arg_1.skill_id : null),
                "skill_effect":(((!(_arg_1 == null)) && ("skill_effect" in _arg_1)) ? _arg_1.skill_effect : [])
            });
        }

        public static function get constructed():Boolean
        {
            return (_constructed);
        }


    }
}//package Storage

