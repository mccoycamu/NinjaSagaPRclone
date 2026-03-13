// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.CharacterManager

package Combat
{
    import id.ninjasage.multiplayer.battle.base.CharacterManagerBase;
    import com.utils.NumberUtil;
    import Storage.Character;

    public class CharacterManager extends CharacterManagerBase 
    {

        public function CharacterManager(_arg_1:*)
        {
            super(_arg_1);
        }

        override public function getMaxHP():int
        {
            var _local_1:Object = this.character_model.character_info;
            return (("character_hp" in _local_1) ? _local_1.character_max_hp : 0);
        }

        override public function getMaxCP():int
        {
            var _local_1:Object = this.character_model.character_info;
            return (("character_cp" in _local_1) ? _local_1.character_max_cp : 0);
        }

        override public function getClanBuildingLevel(_arg_1:String):int
        {
            if (((!(this.character.hasOwnProperty("clan"))) || (this.character.clan == null)))
            {
                return (0);
            };
            return (int(this.character.clan[_arg_1]));
        }

        override public function getAgility():int
        {
            return (StatsManager.getAgility(this));
        }

        override public function recalculateHP():int
        {
            return (StatsManager.recalculateHp(this));
        }

        override public function recalculateCP():int
        {
            return (StatsManager.recalculateCp(this));
        }

        override public function getPurify():int
        {
            return (StatsManager.getPurify(this));
        }

        override public function checkBlockDamage():int
        {
            return (StatsManager.getBlockChance(this));
        }

        override public function checkIgnoreBlockDamage():int
        {
            return (StatsManager.getIgnoreBlockChance(this));
        }

        override public function checkConvertDamage():Boolean
        {
            var _local_1:int = StatsManager.getConvertChance(this);
            var _local_2:int = NumberUtil.getRandomInt();
            return ((_local_1 > 0) && (_local_1 >= _local_2));
        }

        public function checkConvertDamageCP():Boolean
        {
            var _local_1:int = StatsManager.getConvertChanceCP(this);
            var _local_2:int = NumberUtil.getRandomInt();
            return ((_local_1 > 0) && (_local_1 >= _local_2));
        }

        public function isActionsManagerLoaded():Boolean
        {
            return (this.character_model.actions_manager.all_loaded);
        }

        public function getAllCharacterInfo():Object
        {
            var _local_1:* = this.character.character_data;
            var _local_2:* = this.character.character_sets;
            var _local_3:* = this.character.character_points;
            var _local_4:* = _local_1.character_class;
            var _local_5:* = BattleManager.getMain();
            if (((this.character_model.getPlayerTeam() == "player") && (this.character_model.getPlayerNumber() == 0)))
            {
                _local_4 = this.checkSpecialJouninExam(_local_4, _local_5);
            };
            return ({
                "character_id":_local_1.character_id,
                "character_name":_local_1.character_name,
                "character_level":_local_1.character_level,
                "character_rank":_local_1.character_rank,
                "character_xp":_local_1.character_xp,
                "character_hp":StatsManager.getHp(this),
                "character_max_hp":StatsManager.getHp(this),
                "character_cp":StatsManager.getCp(this),
                "character_max_cp":StatsManager.getCp(this),
                "character_sp":StatsManager.getSp(this),
                "character_max_sp":StatsManager.getSp(this),
                "original_character_max_cp":StatsManager.getCp(this),
                "hair_color":_local_2.hair_color,
                "skin_color":_local_2.skin_color,
                "character_face":_local_2.face,
                "character_hair":_local_2.hairstyle,
                "character_weapon":_local_2.weapon,
                "character_accessory":_local_2.accessory,
                "character_back_item":_local_2.back_item,
                "character_set":_local_2.clothing,
                "character_equipped_skills":_local_2.skills,
                "character_class":_local_4,
                "character_agility":0,
                "character_dodge":0,
                "character_critical":0,
                "character_accuracy":0
            });
        }

        private function checkSpecialJouninExam(_arg_1:*, _arg_2:*):*
        {
            if (((_arg_2.is_special_jounin_exam_s1c2) && (Character.mission_id == "special_jounin_s1c2_3")))
            {
                Character.character_class = "skill_4002";
                return ("skill_4002");
            };
            if (((_arg_2.is_special_jounin_exam_s2c2) && (Character.mission_id == "special_jounin_s2c2_3")))
            {
                Character.character_class = "skill_4004";
                return ("skill_4004");
            };
            if (((_arg_2.is_special_jounin_exam_s3c2) && (Character.mission_id == "special_jounin_s3c2_2")))
            {
                Character.character_class = "skill_4001";
                return ("skill_4001");
            };
            if (_arg_2.is_special_jounin_exam_s4c2)
            {
                Character.character_class = "skill_4003";
                return ("skill_4003");
            };
            if (_arg_2.is_special_jounin_exam_s5c2)
            {
                Character.character_class = "skill_4000";
                return ("skill_4000");
            };
            if ((((_arg_2.is_special_jounin_exam_s6c1) || (_arg_2.is_special_jounin_exam_s6c2)) || (_arg_2.is_special_jounin_exam_s6c3)))
            {
                Character.character_class = null;
                return (null);
            };
            return (_arg_1);
        }

        override public function destroy():*
        {
            super.destroy();
            this.character = null;
            this.character_model = null;
        }


    }
}//package Combat

