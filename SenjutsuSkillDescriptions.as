// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.SenjutsuSkillDescriptions

package Storage
{
    import flash.display.MovieClip;

    public class SenjutsuSkillDescriptions extends MovieClip 
    {

        public var main:*;

        public function SenjutsuSkillDescriptions(_arg_1:*)
        {
            this.main = _arg_1;
        }

        public static function getSenjutsuSkillDescriptions(_arg_1:String):*
        {
            var _local_2:* = {};
            switch (_arg_1)
            {
                case "senjutsu_other_skill_1":
                    _local_2.id = "skill_3500";
                    _local_2.name = "Senjutsu: Super Charges";
                    _local_2.description = "Restore self HP and CP.";
                    _local_2.order = 1;
                    break;
                case "senjutsu_other_skill_2":
                    _local_2.id = "skill_3000";
                    _local_2.name = "Senjutsu: Sage Mode";
                    _local_2.description = "Strengthen Senjutsu's power and allows casting Senjutsu without costing SP.";
                    _local_2.order = 2;
                    break;
                case "senjutsu_toad_skill_1":
                    _local_2.id = "skill_3001";
                    _local_2.name = "Senjutsu: Mountains Flavor";
                    _local_2.description = "Absorbing natural power from the mountains to increase HP cap and all attack damage.";
                    _local_2.order = 1;
                    break;
                case "senjutsu_toad_skill_2":
                    _local_2.id = "skill_3002";
                    _local_2.name = "Senjutsu: Toad Oil";
                    _local_2.description = "Spit out a special toad oil at target to decrease target's agility.";
                    _local_2.link1 = "skill_3001";
                    _local_2.order = 2;
                    break;
                case "senjutsu_toad_skill_3":
                    _local_2.id = "skill_3003";
                    _local_2.name = "Senjutsu: Toad Fire Curse";
                    _local_2.description = "Cast out fire balls around the target and hit the target with a big explosion (extra damage will be done to those who is under the Toad Oil effect)";
                    _local_2.link1 = "skill_3001";
                    _local_2.order = 3;
                    break;
                case "senjutsu_toad_skill_4":
                    _local_2.id = "skill_3004";
                    _local_2.name = "Senjutsu: Shield of Toad";
                    _local_2.description = "A shield made of toad's oil which can sustain a certain amount of damage.";
                    _local_2.link1 = "skill_3002";
                    _local_2.order = 4;
                    break;
                case "senjutsu_toad_skill_5":
                    _local_2.id = "skill_3005";
                    _local_2.name = "Senjutsu: Ishikawa Goemon";
                    _local_2.description = "Summon a little toad which can steal and use a skill from the target with a lick of its tongue (PvP Jutsu) (Not applicable on Talent skills and Senjutsu)";
                    _local_2.link1 = "skill_3002";
                    _local_2.order = 5;
                    break;
                case "senjutsu_toad_skill_6":
                    _local_2.id = "skill_3006";
                    _local_2.name = "Senjutsu: Toad Spirit";
                    _local_2.description = "Aided with the spirit of toad, player has a higher chance to cast critical hits and accuracy when HP is low.";
                    _local_2.link1 = "skill_3003";
                    _local_2.order = 6;
                    break;
                case "senjutsu_toad_skill_7":
                    _local_2.id = "skill_3007";
                    _local_2.name = "Senjutsu: Special Pipe";
                    _local_2.description = "Exhale a thick blanket of smoke and hit the target with the pipe.";
                    _local_2.link1 = "skill_3003";
                    _local_2.order = 7;
                    break;
                case "senjutsu_toad_skill_8":
                    _local_2.id = "skill_3008";
                    _local_2.name = "Senjutsu: Secret Sake of Toad";
                    _local_2.description = "Drink the special sake to increase all attack damage.";
                    _local_2.link1 = "skill_3004";
                    _local_2.link2 = "skill_3005";
                    _local_2.order = 8;
                    break;
                case "senjutsu_toad_skill_9":
                    _local_2.id = "skill_3009";
                    _local_2.name = "Senjutsu: Power of Toad";
                    _local_2.description = "Summon a huge toad and attack the enemy.";
                    _local_2.link1 = "skill_3006";
                    _local_2.link2 = "skill_3007";
                    _local_2.order = 9;
                    break;
                case "senjutsu_toad_skill_10":
                    _local_2.id = "skill_3010";
                    _local_2.name = "Senjutsu: Pneuma Toad Bomb";
                    _local_2.description = "Infused with potent power, player casts out a ball of all target. (PvP Jutsu)";
                    _local_2.link1 = "skill_3008";
                    _local_2.link2 = "skill_3009";
                    _local_2.order = 10;
                    break;
                case "senjutsu_snake_skill_1":
                    _local_2.id = "skill_3101";
                    _local_2.name = "Senjutsu: Earth Flavor";
                    _local_2.description = "Trained to master natural power from snake cavern, less CP consumption while using skill and skill cooldown is shorter when skill is first used.";
                    _local_2.order = 1;
                    break;
                case "senjutsu_snake_skill_2":
                    _local_2.id = "skill_3102";
                    _local_2.name = "Senjutsu: Toxic Fangs";
                    _local_2.description = "Special toxic sprayed at target and poison target.";
                    _local_2.order = 2;
                    break;
                case "senjutsu_snake_skill_3":
                    _local_2.id = "skill_3103";
                    _local_2.name = "Senjutsu: Snake Swallow";
                    _local_2.description = "A big snake sprang out from the ground under target, and decrease the target’s maximum limit of CP.";
                    _local_2.link1 = "skill_3101";
                    _local_2.link2 = "skill_3102";
                    _local_2.order = 3;
                    break;
                case "senjutsu_snake_skill_4":
                    _local_2.id = "skill_3104";
                    _local_2.name = "Senjutsu: Seven Snake Attack";
                    _local_2.description = "Summon lots of snakes to attack target. This Senjutsu hits target with high accuracy.";
                    _local_2.link1 = "skill_3103";
                    _local_2.order = 4;
                    break;
                case "senjutsu_snake_skill_5":
                    _local_2.id = "skill_3105";
                    _local_2.name = "Senjutsu: Snake Mark";
                    _local_2.description = "Marked target with a serpent (debuff) causing target unable to use talent and senjutsu skill.";
                    _local_2.link1 = "skill_3103";
                    _local_2.order = 5;
                    break;
                case "senjutsu_snake_skill_6":
                    _local_2.id = "skill_3106";
                    _local_2.name = "Senjutsu: Special Snake Scales";
                    _local_2.description = "Use scales to make a shield; if enemy attack player, enemy will get HP, CP and SP damages.";
                    _local_2.link1 = "skill_3104";
                    _local_2.order = 6;
                    break;
                case "senjutsu_snake_skill_7":
                    _local_2.id = "skill_3107";
                    _local_2.name = "Senjutsu: Shedding";
                    _local_2.description = "Shed like a snake, player can ignore all damage and effect based on the amount of SP.";
                    _local_2.link1 = "skill_3105";
                    _local_2.order = 7;
                    break;
                case "senjutsu_snake_skill_8":
                    _local_2.id = "skill_3108";
                    _local_2.name = "Senjutsu: Psychedelic Sound";
                    _local_2.description = "Confuse enemy with sonic vibration forcing target to use weapon attack only. (PvP Jutsu)";
                    _local_2.link1 = "skill_3104";
                    _local_2.link2 = "skill_3105";
                    _local_2.order = 8;
                    break;
                case "senjutsu_snake_skill_9":
                    _local_2.id = "skill_3109";
                    _local_2.name = "Senjutsu: Snakes Shadow";
                    _local_2.description = "Summon the eight shadowed snakes to put target under chaotic illusion for alternate turns.";
                    _local_2.link1 = "skill_3108";
                    _local_2.order = 9;
                    break;
                case "senjutsu_snake_skill_10":
                    _local_2.id = "skill_3110";
                    _local_2.name = "Senjutsu: Dragon Sublimation";
                    _local_2.description = "Player transform into a dragon and drain target's HP to convert it as his own SP. (PvP Jutsu)";
                    _local_2.link1 = "skill_3109";
                    _local_2.order = 10;
                    break;
                default:
                    return (false);
            };
            return (_local_2);
        }


    }
}//package Storage

