// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.ArenaBuffs

package Storage
{
    import flash.display.MovieClip;

    public class ArenaBuffs extends MovieClip 
    {

        private static var data:* = {};
        private static var cachedData:* = {};
        private static var _constructed:* = false;

        public var main:*;

        public function ArenaBuffs(_arg_1:*)
        {
            this.main = _arg_1;
        }

        public static function constructData(_arg_1:*):*
        {
            var _local_2:*;
            ArenaBuffs.data = {};
            for each (_local_2 in _arg_1)
            {
                ArenaBuffs.data[_local_2.id] = ArenaBuffs.prefix(_local_2);
            };
            _constructed = true;
            _local_2 = null;
        }

        public static function getArenaBuff(_arg_1:String):*
        {
            if (data.hasOwnProperty(_arg_1))
            {
                return (data[_arg_1]);
            };
            return (ArenaBuffs.prefix());
        }

        private static function prefix(_arg_1:*=null):*
        {
            return ({
                "id":(((!(_arg_1 == null)) && ("id" in _arg_1)) ? _arg_1.id : null),
                "buff":(((!(_arg_1 == null)) && ("buff" in _arg_1)) ? _arg_1.buff : null),
                "debuff":(((!(_arg_1 == null)) && ("debuff" in _arg_1)) ? _arg_1.debuff : null)
            });
        }

        public static function clearCached():*
        {
            ArenaBuffs.cachedData = {};
        }

        public static function getCopy(_arg_1:String):*
        {
            var _local_3:*;
            var _local_2:* = null;
            if ((_arg_1 in ArenaBuffs.cachedData))
            {
                _local_2 = ArenaBuffs.cachedData[_arg_1];
            }
            else
            {
                _local_2 = JSON.parse(JSON.stringify(ArenaBuffs.getArenaBuff(_arg_1)));
                ArenaBuffs.cachedData[_arg_1] = _local_2;
            };
            if (_local_2.effects != null)
            {
                _local_3 = 0;
                while (_local_3 < _local_2["effects"].length)
                {
                    if (!("duration" in _local_2["effects"][_local_3]))
                    {
                        _local_2["effects"][_local_3].duration = 0;
                    };
                    if (!("calc_type" in _local_2["effects"][_local_3]))
                    {
                        _local_2["effects"][_local_3].calc_type = "percent";
                    };
                    if (!("amount" in _local_2["effects"][_local_3]))
                    {
                        _local_2["effects"][_local_3].amount = 0;
                    };
                    if (!("amount_prc" in _local_2["effects"][_local_3]))
                    {
                        _local_2["effects"][_local_3].amount_prc = 0;
                    };
                    if (!("amount_hp" in _local_2["effects"][_local_3]))
                    {
                        _local_2["effects"][_local_3].amount_hp = 0;
                    };
                    if (!("amount_cp" in _local_2["effects"][_local_3]))
                    {
                        _local_2["effects"][_local_3].amount_cp = 0;
                    };
                    if (!("chance" in _local_2["effects"][_local_3]))
                    {
                        _local_2["effects"][_local_3].chance = 100;
                    };
                    if (!("reduce_type" in _local_2["effects"][_local_3]))
                    {
                        _local_2["effects"][_local_3].reduce_type = "MAX";
                    };
                    if (!("no_disperse" in _local_2["effects"][_local_3]))
                    {
                        _local_2["effects"][_local_3].no_disperse = false;
                    };
                    _local_3++;
                };
            }
            else
            {
                _local_2.effects = [];
            };
            return (_local_2);
        }

        public static function get constructed():*
        {
            return (ArenaBuffs._constructed == true);
        }


    }
}//package Storage

