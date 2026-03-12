// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.SenjutsuInfo

package Storage
{
    public class SenjutsuInfo 
    {


        public static function getSenjutsuInfo(_arg_1:String):*
        {
            var _local_2:* = {};
            switch (_arg_1)
            {
                case "other":
                    _local_2.name = "Other";
                    _local_2.description = "Other";
                    _local_2.premium = false;
                    _local_2.token = 1000000;
                    _local_2.gold = 0;
                    break;
                case "toad":
                    _local_2.name = "Toad Sage Mode";
                    _local_2.description = "The sage mode come from the Toad Hill, learn it from the Old Huge Toad, toad senjutsu can make our body become stronger and damage become more powerful.";
                    _local_2.premium = false;
                    _local_2.token = 0;
                    _local_2.gold = 2000000;
                    break;
                case "snake":
                    _local_2.name = "Snake Sage Mode";
                    _local_2.description = "The sage mode come from the Snake Cave, learn it from the Snake God, snake sage can make help for your skill using.";
                    _local_2.premium = false;
                    _local_2.token = 0;
                    _local_2.gold = 2000000;
                    break;
                default:
                    return (false);
            };
            return (_local_2);
        }


    }
}//package Storage

