// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.PetLearnRequirements

package Storage
{
    public class PetLearnRequirements 
    {


        public static function getSkillRequirements(_arg_1:int=0):*
        {
            var _local_2:Object = new Object();
            switch (_arg_1)
            {
                case 2:
                    _local_2.golds = 10000;
                    _local_2.tokens = 50;
                    _local_2.material_01 = 0;
                    _local_2.material_02 = 0;
                    _local_2.material_03 = 0;
                    _local_2.material_04 = 0;
                    _local_2.material_05 = 0;
                    break;
                case 3:
                    _local_2.golds = 20000;
                    _local_2.tokens = 80;
                    _local_2.material_01 = 5;
                    _local_2.material_02 = 0;
                    _local_2.material_03 = 0;
                    _local_2.material_04 = 0;
                    _local_2.material_05 = 0;
                    break;
                case 4:
                    _local_2.golds = 30000;
                    _local_2.tokens = 120;
                    _local_2.material_01 = 6;
                    _local_2.material_02 = 4;
                    _local_2.material_03 = 2;
                    _local_2.material_04 = 0;
                    _local_2.material_05 = 0;
                    break;
                case 5:
                    _local_2.golds = 40000;
                    _local_2.tokens = 150;
                    _local_2.material_01 = 8;
                    _local_2.material_02 = 6;
                    _local_2.material_03 = 4;
                    _local_2.material_04 = 0;
                    _local_2.material_05 = 0;
                    break;
                case 6:
                    _local_2.golds = 50000;
                    _local_2.tokens = 200;
                    _local_2.material_01 = 10;
                    _local_2.material_02 = 8;
                    _local_2.material_03 = 6;
                    _local_2.material_04 = 4;
                    _local_2.material_05 = 2;
                    break;
                default:
                    return (false);
            };
            return (_local_2);
        }


    }
}//package Storage

