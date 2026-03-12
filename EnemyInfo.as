// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Storage.EnemyInfo

package Storage
{
    import flash.display.MovieClip;

    public class EnemyInfo extends MovieClip 
    {

        private static var data:* = {};
        private static var _constructed:* = false;

        public var main:*;

        public function EnemyInfo(_arg_1:*)
        {
        }

        public static function constructData(_arg_1:*):*
        {
            var _local_2:*;
            EnemyInfo.data = {};
            for each (_local_2 in _arg_1)
            {
                EnemyInfo.data[_local_2.id] = EnemyInfo.prefix(_local_2);
            };
            _constructed = true;
            _local_2 = null;
        }

        public static function getEnemyStats(_arg_1:String):*
        {
            var _local_2:*;
            if (data.hasOwnProperty(_arg_1))
            {
                return (data[_arg_1]);
            };
            return (EnemyInfo.prefix());
        }

        private static function prefix(_arg_1:*=null):*
        {
            var _local_2:* = {
                "enemy_id":(((!(_arg_1 == null)) && ("id" in _arg_1)) ? _arg_1.id : "null"),
                "enemy_name":(((!(_arg_1 == null)) && ("name" in _arg_1)) ? _arg_1.name : "null"),
                "enemy_level":(((!(_arg_1 == null)) && ("level" in _arg_1)) ? _arg_1.level : 1),
                "description":(((!(_arg_1 == null)) && ("description" in _arg_1)) ? _arg_1.description : ""),
                "enemy_hp":(((!(_arg_1 == null)) && ("hp" in _arg_1)) ? _arg_1.hp : 0),
                "enemy_cp":(((!(_arg_1 == null)) && ("cp" in _arg_1)) ? _arg_1.cp : 0),
                "enemy_dodge":(((!(_arg_1 == null)) && ("dodge" in _arg_1)) ? _arg_1.dodge : 0),
                "enemy_critical":(((!(_arg_1 == null)) && ("critical" in _arg_1)) ? _arg_1.critical : 0),
                "enemy_critical_damage":(((!(_arg_1 == null)) && ("critical_damage" in _arg_1)) ? _arg_1.critical_damage : 0),
                "enemy_purify":(((!(_arg_1 == null)) && ("purify" in _arg_1)) ? _arg_1.purify : 0),
                "enemy_accuracy":(((!(_arg_1 == null)) && ("accuracy" in _arg_1)) ? _arg_1.accuracy : 0),
                "enemy_agility":(((!(_arg_1 == null)) && ("agility" in _arg_1)) ? _arg_1.agility : 0),
                "enemy_reactive":(((!(_arg_1 == null)) && ("reactive" in _arg_1)) ? _arg_1.reactive : 0),
                "enemy_combustion":(((!(_arg_1 == null)) && ("combustion" in _arg_1)) ? _arg_1.combustion : 0),
                "size_x":(((!(_arg_1 == null)) && ("size_x" in _arg_1)) ? _arg_1.size_x : 0),
                "size_y":(((!(_arg_1 == null)) && ("size_y" in _arg_1)) ? _arg_1.size_y : 0),
                "anims":(((!(_arg_1 == null)) && ("anims" in _arg_1)) ? _arg_1.anims : null),
                "combo_skill":(((!(_arg_1 == null)) && ("combo_skill" in _arg_1)) ? _arg_1.combo_skill : false),
                "priority":(((!(_arg_1 == null)) && ("priority" in _arg_1)) ? _arg_1.priority : null)
            };
            if (_arg_1 != null)
            {
                if (("na" in _arg_1))
                {
                    _local_2["enemy_na"] = _arg_1.na;
                };
                if (("event" in _arg_1))
                {
                    _local_2["enemy_event"] = _arg_1.event;
                };
                if (("calculation" in _arg_1))
                {
                    _local_2["enemy_calculation"] = _arg_1.calculation;
                };
                if (("calculation_agility" in _arg_1))
                {
                    _local_2["enemy_calculation_agility"] = _arg_1.calculation_agility;
                };
                if (("attacks" in _arg_1))
                {
                    _local_2["attacks"] = _arg_1.attacks;
                };
            };
            return (_local_2);
        }

        public static function getCopy(enemyId:*):*
        {
            var enemyInfo:* = undefined;
            var i:* = undefined;
            var setEnemyStats:Function = function (_arg_1:Number, _arg_2:Number, _arg_3:Number):void
            {
                var _local_4:Number = Number(Character.character_lvl);
                enemyInfo.enemy_level = (Number(_local_4) + Number((Math.floor((Math.random() * 21)) - 10)));
                enemyInfo.enemy_hp = Number((_arg_1 + ((_local_4 - 1) * (_arg_2 + (_arg_3 * _local_4)))));
                enemyInfo.enemy_cp = Number((_arg_1 + ((_local_4 - 1) * (_arg_2 + (_arg_3 * _local_4)))));
                enemyInfo.enemy_agility = Number(((10 + _arg_2) + ((_arg_3 * _local_4) / 20)));
            };
            enemyInfo = JSON.parse(JSON.stringify(EnemyInfo.getEnemyStats(enemyId)));
            var enemyDifficulty:Array = [0.7, 1, 1.2];
            if (!enemyInfo.hasOwnProperty("attacks"))
            {
                enemyInfo.attacks = [];
            };
            if (((enemyInfo.hasOwnProperty("enemy_calculation")) && (enemyInfo.hasOwnProperty("enemy_calculation_agility"))))
            {
                enemyInfo.enemy_level = (int(Character.character_lvl) + 5);
                enemyInfo.enemy_hp = (int(Character.character_lvl) * enemyInfo.enemy_calculation);
                enemyInfo.enemy_cp = (int(Character.character_lvl) * enemyInfo.enemy_calculation);
                enemyInfo.enemy_agility = ((10 + int(Character.character_lvl)) + enemyInfo.enemy_calculation_agility);
            }
            else
            {
                if (enemyInfo.hasOwnProperty("enemy_calculation"))
                {
                    enemyInfo.enemy_level = (int(Character.character_lvl) + 5);
                    enemyInfo.enemy_hp = (int(Character.character_lvl) * enemyInfo.enemy_calculation);
                    enemyInfo.enemy_cp = (int(Character.character_lvl) * enemyInfo.enemy_calculation);
                }
                else
                {
                    if (((enemyInfo.hasOwnProperty("enemy_hp")) && (int(enemyInfo.enemy_hp) == 0)))
                    {
                        enemyInfo.enemy_hp = (30 + (int(Character.mission_level) * 30));
                        enemyInfo.enemy_cp = (30 + (int(Character.mission_level) * 30));
                        enemyInfo.enemy_agility = (11 + int(Character.mission_level));
                        enemyInfo.skillDmg1 = (5 + (int(Character.mission_level) * 2));
                        enemyInfo.skillDmg2 = (5 + (int(Character.mission_level) * 3));
                        enemyInfo.enemy_level = Character.mission_level;
                    };
                };
            };
            switch (enemyInfo.enemy_id)
            {
                case "ene_81":
                    (setEnemyStats(20000, 40, 3));
                    break;
                case "ene_82":
                    (setEnemyStats(21000, 50, 3));
                    break;
                case "ene_83":
                    (setEnemyStats(22000, 60, 3.5));
                    break;
                case "ene_84":
                    (setEnemyStats(23000, 60, 3));
                    break;
                case "ene_85":
                    (setEnemyStats(24000, 50, 3));
                    break;
                case "ene_86":
                    (setEnemyStats(25000, 60, 4));
                    break;
                case "ene_106":
                    (setEnemyStats(26000, 70, 4));
                    break;
                case "ene_120":
                    (setEnemyStats(27000, 75, 4.5));
                    break;
                case "ene_155":
                    (setEnemyStats(28000, 80, 5));
                    break;
            };
            if (Character.is_hard_mode)
            {
                enemyInfo.enemy_level = Math.floor((int(Character.character_lvl) * 2));
                enemyInfo.enemy_hp = Math.floor((enemyInfo.enemy_hp * 2));
                enemyInfo.enemy_cp = Math.floor((enemyInfo.enemy_cp * 2));
                enemyInfo.enemy_dodge = Math.floor((enemyInfo.enemy_dodge * 2));
                enemyInfo.enemy_critical = Math.floor((enemyInfo.enemy_critical * 2));
                enemyInfo.enemy_accuracy = Math.floor((enemyInfo.enemy_accuracy * 2));
                enemyInfo.enemy_agility = Math.floor((enemyInfo.enemy_agility * 2));
                enemyInfo.enemy_reactive = Math.floor((enemyInfo.enemy_reactive * 2));
                i = 0;
                while (i < enemyInfo.attacks.length)
                {
                    if (enemyInfo.attacks[i].dmg > 0)
                    {
                        enemyInfo.attacks[i].dmg = (enemyInfo.attacks[i].dmg * 2);
                    };
                    i++;
                };
            };
            if (Character.encyclopedia_battle.battle)
            {
                enemyInfo.enemy_level = Math.floor((int(Character.character_lvl) * Character.encyclopedia_battle.multiplier));
                enemyInfo.enemy_hp = Math.floor((enemyInfo.enemy_hp * Character.encyclopedia_battle.multiplier));
                enemyInfo.enemy_cp = Math.floor((enemyInfo.enemy_cp * Character.encyclopedia_battle.multiplier));
                enemyInfo.enemy_critical = Math.floor((enemyInfo.enemy_critical * Character.encyclopedia_battle.multiplier));
                enemyInfo.enemy_agility = Math.floor((enemyInfo.enemy_agility * Character.encyclopedia_battle.multiplier));
                enemyInfo.enemy_reactive = Math.floor((enemyInfo.enemy_reactive * Character.encyclopedia_battle.multiplier));
                i = 0;
                while (i < enemyInfo.attacks.length)
                {
                    if (enemyInfo.attacks[i].dmg > 0)
                    {
                        enemyInfo.attacks[i].dmg = (enemyInfo.attacks[i].dmg * Character.encyclopedia_battle.multiplier);
                    };
                    i++;
                };
            };
            if (!enemyInfo.hasOwnProperty("enemy_max_hp"))
            {
                enemyInfo.enemy_max_hp = enemyInfo.enemy_hp;
            };
            if (!enemyInfo.hasOwnProperty("enemy_level"))
            {
                enemyInfo.enemy_level = 5;
            };
            if (!enemyInfo.hasOwnProperty("enemy_combustion"))
            {
                enemyInfo.enemy_combustion = 0;
            };
            if (!enemyInfo.hasOwnProperty("enemy_accuracy"))
            {
                enemyInfo.enemy_accuracy = 10;
            };
            if (!enemyInfo.hasOwnProperty("enemy_reactive"))
            {
                enemyInfo.enemy_reactive = 5;
            };
            if (!enemyInfo.hasOwnProperty("enemy_name"))
            {
                enemyInfo.enemy_id = "ene_00Error";
                enemyInfo.enemy_name = "";
                enemyInfo.enemy_hp = 999999;
                enemyInfo.enemy_max_hp = 999999;
                enemyInfo.enemy_cp = 999999;
                enemyInfo.enemy_dodge = 1000;
                enemyInfo.enemy_agility = 0;
                enemyInfo.description = "ERROR";
                enemyInfo.skillDmg1 = 10001;
                enemyInfo.skillDmg2 = 10002;
                enemyInfo.skillDmg3 = 10003;
                enemyInfo.skillDmg4 = 10004;
                enemyInfo.skillDmg5 = 10005;
                enemyInfo.size_x = 0.55;
                enemyInfo.size_y = 0.55;
            };
            return (enemyInfo);
        }

        public static function getEncyIds():*
        {
            var item:* = undefined;
            var items:* = [];
            for (item in data)
            {
                if (!((data[item].hasOwnProperty("enemy_na")) && (data[item].enemy_na == true)))
                {
                    items.push(item);
                };
            };
            return (items.sort(function (_arg_1:*, _arg_2:*):*
            {
                return (int(_arg_1.split("_")[1]) - int(_arg_2.split("_")[1]));
            }));
        }

        public static function get constructed():*
        {
            return (EnemyInfo._constructed == true);
        }


    }
}//package Storage

