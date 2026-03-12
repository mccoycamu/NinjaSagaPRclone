// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.TalentInfo

package Storage
{
    public class TalentInfo 
    {


        public static function getTalentInfos(_arg_1:String):*
        {
            return (GameData.get("talent_info")[_arg_1]);
        }


    }
}//package Storage

