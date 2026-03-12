// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Managers.ExamManager

package Managers
{
    import id.ninjasage.features.exam.specialjounin.stage1.chapter2.Mission_205;
    import id.ninjasage.features.exam.specialjounin.stage2.chapter2.Mission_206;
    import id.ninjasage.features.exam.specialjounin.stage3.chapter2.Mission_207;
    import id.ninjasage.features.exam.specialjounin.stage4.chapter2.Mission_208;
    import id.ninjasage.features.exam.specialjounin.stage5.chapter2.Mission_209;
    import id.ninjasage.features.exam.specialjounin.stage6.chapter1.Mission_210;
    import id.ninjasage.features.exam.specialjounin.stage6.chapter2.Mission_211;
    import id.ninjasage.features.exam.specialjounin.stage6.chapter3.Mission_212;
    import id.ninjasage.features.exam.ninjatutor.stage1.chapter2.Mission_259;
    import id.ninjasage.features.exam.ninjatutor.stage2.chapter2.Mission_260;
    import id.ninjasage.features.exam.ninjatutor.stage3.chapter2.Mission_261;
    import id.ninjasage.features.exam.ninjatutor.stage4.chapter2.Mission_262;
    import id.ninjasage.features.exam.ninjatutor.stage5.chapter2.Mission_263;
    import id.ninjasage.features.exam.ninjatutor.stage6.chapter1.Mission_264;
    import id.ninjasage.features.exam.ninjatutor.stage6.chapter2.Mission_265;
    import id.ninjasage.features.exam.smission.stage4.Mission_277;
    import id.ninjasage.features.exam.smission.stage5.Mission_278;
    import id.ninjasage.features.exam.chunin.stage1.Mission_55;
    import id.ninjasage.features.exam.chunin.stage2.Mission_56;
    import id.ninjasage.features.exam.chunin.stage3.Mission_57;
    import id.ninjasage.features.exam.chunin.stage4.Mission_58;
    import id.ninjasage.features.exam.chunin.stage5.Mission_59;
    import id.ninjasage.features.exam.jounin.stage1.Mission_132;
    import id.ninjasage.features.exam.jounin.stage2.Mission_133;
    import id.ninjasage.features.exam.jounin.stage3.Mission_134;
    import id.ninjasage.features.exam.jounin.stage4.Mission_135;
    import id.ninjasage.features.exam.jounin.stage5.Mission_136;
    import id.ninjasage.features.exam.chunin.stage2.*;
    import id.ninjasage.features.exam.jounin.stage4.*;
    import id.ninjasage.features.exam.chunin.stage1.*;
    import id.ninjasage.features.exam.chunin.stage3.*;
    import id.ninjasage.features.exam.specialjounin.stage6.chapter3.*;
    import id.ninjasage.features.exam.jounin.stage1.*;
    import id.ninjasage.features.exam.specialjounin.stage6.chapter2.*;
    import id.ninjasage.features.exam.ninjatutor.stage2.chapter2.*;
    import id.ninjasage.features.exam.jounin.stage2.*;
    import id.ninjasage.features.exam.ninjatutor.stage1.chapter2.*;
    import id.ninjasage.features.exam.jounin.stage5.*;
    import id.ninjasage.features.exam.specialjounin.stage2.chapter2.*;
    import id.ninjasage.features.exam.ninjatutor.stage6.chapter2.*;
    import id.ninjasage.features.exam.chunin.stage5.*;
    import id.ninjasage.features.exam.ninjatutor.stage5.chapter2.*;
    import id.ninjasage.features.exam.jounin.stage3.*;
    import id.ninjasage.features.exam.specialjounin.stage3.chapter2.*;
    import id.ninjasage.features.exam.specialjounin.stage5.chapter2.*;
    import id.ninjasage.features.exam.specialjounin.stage6.chapter1.*;
    import id.ninjasage.features.exam.ninjatutor.stage4.chapter2.*;
    import id.ninjasage.features.exam.specialjounin.stage4.chapter2.*;
    import id.ninjasage.features.exam.chunin.stage4.*;
    import id.ninjasage.features.exam.ninjatutor.stage6.chapter1.*;
    import id.ninjasage.features.exam.ninjatutor.stage3.chapter2.*;
    import id.ninjasage.features.exam.specialjounin.stage1.chapter2.*;
    import id.ninjasage.features.exam.smission.stage5.*;
    import id.ninjasage.features.exam.smission.stage4.*;

    public class ExamManager 
    {

        public static const SPJ_CLASS_LIST:Object = {
            "1_2":Mission_205,
            "2_2":Mission_206,
            "3_2":Mission_207,
            "4_2":Mission_208,
            "5_2":Mission_209,
            "6_1":Mission_210,
            "6_2":Mission_211,
            "6_3":Mission_212
        };
        public static const NINJATUTOR_CLASS_LIST:Object = {
            "1_2":Mission_259,
            "2_2":Mission_260,
            "3_2":Mission_261,
            "4_2":Mission_262,
            "5_2":Mission_263,
            "6_1":Mission_264,
            "6_2":Mission_265
        };
        public static const GRADE_S_CLASS_LIST:Object = {
            "4":Mission_277,
            "5":Mission_278
        };


        public static function getChuninExamClass(_arg_1:int):Class
        {
            switch (_arg_1)
            {
                case 1:
                    return (Mission_55);
                case 2:
                    return (Mission_56);
                case 3:
                    return (Mission_57);
                case 4:
                    return (Mission_58);
                case 5:
                    return (Mission_59);
                default:
                    return (null);
            };
        }

        public static function getJouninExamClass(_arg_1:int):Class
        {
            switch (_arg_1)
            {
                case 1:
                    return (Mission_132);
                case 2:
                    return (Mission_133);
                case 3:
                    return (Mission_134);
                case 4:
                    return (Mission_135);
                case 5:
                    return (Mission_136);
                default:
                    return (null);
            };
        }

        public static function getSpecialJouninExamClass(_arg_1:int, _arg_2:int):Class
        {
            return (SPJ_CLASS_LIST[((_arg_1 + "_") + _arg_2)]);
        }

        public static function getNinjaTutorExamClass(_arg_1:int, _arg_2:int):Class
        {
            return (NINJATUTOR_CLASS_LIST[((_arg_1 + "_") + _arg_2)]);
        }

        public static function getGradeSClass(_arg_1:int):Class
        {
            return (GRADE_S_CLASS_LIST[_arg_1]);
        }


    }
}//package Managers

