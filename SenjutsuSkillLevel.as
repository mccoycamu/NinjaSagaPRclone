// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.SenjutsuSkillLevel

package Storage
{
    import id.ninjasage.Util;

    public class SenjutsuSkillLevel 
    {

        private static var data:* = {};
        private static var _constructed:* = false;


        public static function constructData(_arg_1:*):*
        {
            var _local_2:*;
            var _local_3:*;
            SenjutsuSkillLevel.data = {};
            for (_local_2 in _arg_1)
            {
                _local_3 = _arg_1[_local_2];
                SenjutsuSkillLevel.data[_local_3.id] = _local_3;
            };
            _constructed = true;
            _arg_1 = null;
        }

        public static function getSenjutsuSkillLevels(_arg_1:String, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + String(_arg_2));
            if (!SenjutsuSkillLevel.data.hasOwnProperty(_local_3))
            {
                return (false);
            };
            var _local_4:* = SenjutsuSkillLevel.data[_local_3];
            SenjutsuSkillLevel.mutateEffects(_local_4);
            return (_local_4);
        }

        public static function getCopy(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = SenjutsuSkillLevel.getSenjutsuSkillLevels(_arg_1, _arg_2);
            if (_local_3)
            {
                return (Util.copy(_local_3));
            };
            return ({});
        }

        private static function mutateEffects(_arg_1:*):*
        {
            if (!_arg_1.hasOwnProperty("effects"))
            {
                _arg_1.effects = [];
                return;
            };
            var _local_2:* = 0;
            while (_local_2 < _arg_1.effects.length)
            {
                if (_arg_1.effects[_local_2].effect.indexOf("_faint") >= 0)
                {
                    _arg_1.effects[_local_2].duration--;
                };
                if (!("duration" in _arg_1.effects[_local_2]))
                {
                    _arg_1.effects[_local_2].duration = 0;
                };
                if (!("calc_type" in _arg_1.effects[_local_2]))
                {
                    _arg_1.effects[_local_2].calc_type = "percent";
                };
                if (!("amount" in _arg_1.effects[_local_2]))
                {
                    _arg_1.effects[_local_2].amount = 0;
                };
                if (!("amount_prc" in _arg_1.effects[_local_2]))
                {
                    _arg_1.effects[_local_2].amount_prc = 0;
                };
                if (!("amount_hp" in _arg_1.effects[_local_2]))
                {
                    _arg_1.effects[_local_2].amount_hp = 0;
                };
                if (!("amount_cp" in _arg_1.effects[_local_2]))
                {
                    _arg_1.effects[_local_2].amount_cp = 0;
                };
                if (!("amount_protection" in _arg_1.effects[_local_2]))
                {
                    _arg_1.effects[_local_2].amount_protection = 0;
                };
                if (!("reduce_type" in _arg_1.effects[_local_2]))
                {
                    _arg_1.effects[_local_2].reduce_type = "MAX";
                };
                if (!("no_disperse" in _arg_1.effects[_local_2]))
                {
                    _arg_1.effects[_local_2].no_disperse = false;
                };
                _local_2++;
            };
        }

        public static function get constructed():*
        {
            return (SenjutsuSkillLevel._constructed == true);
        }


    }
}//package Storage

