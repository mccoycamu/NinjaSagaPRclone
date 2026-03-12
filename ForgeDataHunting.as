// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.ForgeDataHunting

package Storage
{
    public class ForgeDataHunting 
    {

        private static var data:*;
        private static var _constructed:* = false;


        public static function constructData(_arg_1:*):*
        {
            var _local_2:*;
            if (_constructed)
            {
                return;
            };
            ForgeDataHunting.data = {};
            for each (_local_2 in _arg_1)
            {
                ForgeDataHunting.data[_local_2.item] = {
                    "item_materials":_local_2.requirements.materials,
                    "item_mat_price":_local_2.requirements.qty
                };
            };
            _constructed = true;
        }

        public static function getItemByCategory(_arg_1:*="wpn"):*
        {
            var _local_3:*;
            var _local_2:* = [];
            for (_local_3 in data)
            {
                if (_local_3.indexOf((_arg_1 + "_")) >= 0)
                {
                    _local_2.push(_local_3);
                };
            };
            return (_local_2);
        }

        public static function getForgeItems(_arg_1:String):*
        {
            if (data.hasOwnProperty(_arg_1))
            {
                return (data[_arg_1]);
            };
            return ({
                "item_materials":[],
                "item_mat_price":[]
            });
        }


    }
}//package Storage

