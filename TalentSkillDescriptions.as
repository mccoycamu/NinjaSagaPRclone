// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.TalentSkillDescriptions

package Storage
{
    public class TalentSkillDescriptions 
    {


        public static function getTalentSkillDescriptions(_arg_1:String):*
        {
            return (GameData.get("talent_description")[_arg_1]);
        }


    }
}//package Storage

