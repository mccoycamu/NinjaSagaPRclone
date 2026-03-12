// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.SenjutsuLevelLearnRequirements

package Storage
{
    public class SenjutsuLevelLearnRequirements 
    {


        public static function getSkillRequirements(_arg_1:int=0):*
        {
            var _local_2:Object = new Object();
            switch (_arg_1)
            {
                case 1:
                    _local_2.ss = 5;
                    break;
                case 2:
                    _local_2.ss = 10;
                    break;
                case 3:
                    _local_2.ss = 25;
                    break;
                case 4:
                    _local_2.ss = 50;
                    break;
                case 5:
                    _local_2.ss = 100;
                    break;
                case 6:
                    _local_2.ss = 200;
                    break;
                case 7:
                    _local_2.ss = 300;
                    break;
                case 8:
                    _local_2.ss = 450;
                    break;
                case 9:
                    _local_2.ss = 600;
                    break;
                case 10:
                    _local_2.ss = 800;
                    break;
                default:
                    return (false);
            };
            return (_local_2);
        }


    }
}//package Storage

