// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Managers.StatManager

package Managers
{
    import Storage.Character;
    import Storage.WeaponBuffs;
    import Storage.BackItemBuffs;
    import Storage.AccessoryBuffs;

    public class StatManager 
    {

        public static var check_talent:Boolean = false;
        public static var check_senjutsu:Boolean = false;

        public var main:*;

        public function StatManager(_arg_1:*=false)
        {
            this.main = _arg_1;
        }

        public static function calculate_stats_with_data(_arg_1:String, _arg_2:*=0, _arg_3:*=0, _arg_4:*=0, _arg_5:*=0, _arg_6:*=0, _arg_7:*="", _arg_8:*="", _arg_9:*=""):*
        {
            var _local_10:Number = NaN;
            var _local_11:* = undefined;
            var _local_12:* = undefined;
            var _local_13:* = undefined;
            var _local_14:* = undefined;
            var _local_15:* = undefined;
            var _local_16:* = undefined;
            var _local_17:* = undefined;
            check_talent = false;
            check_senjutsu = false;
            if (((_arg_7 == "") || (_arg_2 == 0)))
            {
                check_talent = true;
                check_senjutsu = true;
                _arg_2 = Character.character_lvl;
                _arg_3 = Character.atrrib_earth;
                _arg_4 = Character.atrrib_water;
                _arg_5 = Character.atrrib_wind;
                _arg_6 = Character.atrrib_lightning;
                _arg_7 = Character.character_weapon;
                _arg_9 = Character.character_accessory;
                _arg_8 = Character.character_back_item;
            };
            var _local_18:* = ((WeaponBuffs.getCopy(_arg_7).effects == null) ? [] : WeaponBuffs.getCopy(_arg_7).effects);
            var _local_19:* = ((BackItemBuffs.getCopy(_arg_8).effects == null) ? [] : BackItemBuffs.getCopy(_arg_8).effects);
            var _local_20:* = ((AccessoryBuffs.getCopy(_arg_9).effects == null) ? [] : AccessoryBuffs.getCopy(_arg_9).effects);
            var _local_21:Array = [_local_18, _local_19, _local_20];
            if (_arg_1 == "hp")
            {
                _local_11 = ((60 + (int(_arg_2) * 40)) + (_arg_3 * 30));
                return (checkEquippedSetNew("hp", _local_11, _local_21));
            };
            if (_arg_1 == "cp")
            {
                _local_12 = (_local_10 = ((60 + (int(_arg_2) * 40)) + (_arg_4 * 30)));
                return (checkEquippedSetNew("cp", _local_12, _local_21));
            };
            if (_arg_1 == "sp")
            {
                _local_12 = (_local_10 = (1000 + (int((_arg_2 - 80)) * 40)));
                return (checkEquippedSetNew("sp", _local_12, _local_21));
            };
            if (_arg_1 == "agility")
            {
                _local_13 = ((Number(9) + Number(_arg_2)) + Number(_arg_5));
                return (_local_13 = checkEquippedSetNew("agility", _local_13, _local_21));
            };
            if (_arg_1 == "critical")
            {
                _local_14 = (5 + (_arg_6 * 0.4));
                return ((_local_14 = checkEquippedSetNew("critical", _local_14, _local_21)).toFixed(1));
            };
            if (_arg_1 == "dodge")
            {
                _local_15 = (5 + (_arg_5 * 0.4));
                return ((_local_15 = checkEquippedSetNew("dodge", _local_15, _local_21)).toFixed(1));
            };
            if (_arg_1 == "purify")
            {
                _local_16 = (0 + (_arg_4 * 0.4));
                return ((_local_16 = checkEquippedSetNew("purify", _local_16, _local_21)).toFixed(1));
            };
            if (_arg_1 == "accuracy")
            {
                _local_17 = 0;
                return ((_local_17 = checkEquippedSetNew("accuracy", _local_17, _local_21)).toFixed(1));
            };
        }

        private static function applyEffects(_arg_1:Number, _arg_2:Array, _arg_3:Array, _arg_4:Array):Number
        {
            var _local_5:Object;
            var _local_6:Array;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_7:int;
            while (_local_7 < _arg_2.length)
            {
                _local_6 = _arg_2[_local_7];
                _local_8 = 0;
                while (_local_8 < _local_6.length)
                {
                    _local_5 = _local_6[_local_8];
                    if (((_arg_3.indexOf(_local_5.effect) >= 0) || (_arg_4.indexOf(_local_5.effect) >= 0)))
                    {
                        _local_9 = int(_local_5.amount);
                        if (((_local_5.hasOwnProperty("calc_type")) && (!(_local_5.calc_type == null))))
                        {
                            _local_10 = ((_local_5.calc_type == "number") ? _local_9 : int(Math.floor(((_local_9 * _arg_1) / 100))));
                        }
                        else
                        {
                            _local_10 = _local_9;
                        };
                        if (_arg_3.indexOf(_local_5.effect) >= 0)
                        {
                            _arg_1 = (_arg_1 + _local_10);
                        };
                        if (_arg_4.indexOf(_local_5.effect) >= 0)
                        {
                            _arg_1 = (_arg_1 - _local_10);
                        };
                    };
                    _local_8++;
                };
                _local_7++;
            };
            return (_arg_1);
        }

        private static function applyMaxEffects(_arg_1:Number, _arg_2:Array, _arg_3:String, _arg_4:String):Number
        {
            var _local_5:Object;
            var _local_6:Array;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_7:int;
            while (_local_7 < _arg_2.length)
            {
                _local_6 = _arg_2[_local_7];
                _local_8 = 0;
                while (_local_8 < _local_6.length)
                {
                    _local_5 = _local_6[_local_8];
                    if (((_local_5.effect == _arg_3) || (_local_5.effect == _arg_4)))
                    {
                        _local_9 = int(_local_5.amount);
                        _local_10 = ((_local_5.calc_type == "number") ? _local_9 : int(Math.floor(((_local_9 * _arg_1) / 100))));
                        if (_local_5.effect == _arg_3)
                        {
                            _arg_1 = (_arg_1 + _local_10);
                        }
                        else
                        {
                            _arg_1 = (_arg_1 - _local_10);
                        };
                    };
                    _local_8++;
                };
                _local_7++;
            };
            return (_arg_1);
        }

        public static function checkEquippedSetNew(_arg_1:*, _arg_2:*, _arg_3:*):*
        {
            var _local_4:Object = {
                "agility":{
                    "inc":["agility_increase", "increase_agility"],
                    "dec":["agility_decrease", "decrease_agility"]
                },
                "critical":{
                    "inc":["critical_increase", "increase_critical"],
                    "dec":["critical_decrease", "decrease_critical"]
                },
                "dodge":{
                    "inc":["dodge_increase", "increase_dodge"],
                    "dec":["dodge_decrease", "decrease_dodge"]
                },
                "purify":{
                    "inc":["purify_increase", "increase_purify"],
                    "dec":["decrease_purify", "decrease_purify"]
                },
                "accuracy":{
                    "inc":["accuracy_increase", "increase_accuracy"],
                    "dec":["accuracy_decrease", "decrease_accuracy"]
                }
            };
            switch (_arg_1)
            {
                case "hp":
                    _arg_2 = getMaximumHPByMaxCPFromTalent(_arg_2);
                    _arg_2 = getMaximumHPFixedFromTalent(_arg_2);
                    _arg_2 = getMaximumHPFromTalent(_arg_2);
                    _arg_2 = getMaximumHPFromSenjutsu(_arg_2);
                    _arg_2 = applyMaxEffects(_arg_2, _arg_3, "max_hp_increase", "max_hp_decrease");
                    break;
                case "cp":
                    _arg_2 = getMaximumCPFromTalent(_arg_2);
                    _arg_2 = applyMaxEffects(_arg_2, _arg_3, "max_cp_increase", "max_cp_decrease");
                    break;
                case "agility":
                    _arg_2 = getAgilityRateFromTalent(_arg_2);
                    _arg_2 = applyEffects(_arg_2, _arg_3, _local_4.agility.inc, _local_4.agility.dec);
                    break;
                case "critical":
                    _arg_2 = getCriticalRateFromTalent(_arg_2);
                    _arg_2 = applyEffects(_arg_2, _arg_3, _local_4.critical.inc, _local_4.critical.dec);
                    break;
                case "dodge":
                    _arg_2 = getDodgeFromTalent(_arg_2);
                    _arg_2 = applyEffects(_arg_2, _arg_3, _local_4.dodge.inc, _local_4.dodge.dec);
                    break;
                case "purify":
                    _arg_2 = getPurifyRateFromTalent(_arg_2);
                    _arg_2 = getPurifyRateFromTalentByCP(_arg_2);
                    _arg_2 = getPurifyRateFromTalentByHP(_arg_2);
                    _arg_2 = applyEffects(_arg_2, _arg_3, _local_4.purify.inc, _local_4.purify.dec);
                    break;
                case "accuracy":
                    _arg_2 = getAccuracyFromTalent(_arg_2);
                    _arg_2 = applyEffects(_arg_2, _arg_3, _local_4.accuracy.inc, _local_4.accuracy.dec);
                    break;
            };
            return (_arg_2);
        }

        public static function checkEquippedSet(_arg_1:*, _arg_2:*, _arg_3:*, _arg_4:*, _arg_5:*):*
        {
            var _local_6:* = 0;
            if (_arg_1 == "hp")
            {
                if (check_talent)
                {
                    _arg_2 = getMaximumHPFromTalent(_arg_2);
                    _arg_2 = getMaximumHPByMaxCPFromTalent(_arg_2);
                    _arg_2 = getMaximumHPFixedFromTalent(_arg_2);
                };
                if (check_senjutsu)
                {
                    _arg_2 = getMaximumHPFromSenjutsu(_arg_2);
                };
                if (_arg_3 != null)
                {
                    _arg_2 = maxHpIncrease(_arg_2, _arg_3);
                    _arg_2 = maxHpDecrease(_arg_2, _arg_3);
                };
                if (_arg_4 != null)
                {
                    _arg_2 = maxHpIncrease(_arg_2, _arg_4);
                    _arg_2 = maxHpDecrease(_arg_2, _arg_4);
                };
                if (_arg_5 != null)
                {
                    _arg_2 = maxHpIncrease(_arg_2, _arg_5);
                    _arg_2 = maxHpDecrease(_arg_2, _arg_5);
                };
            }
            else
            {
                if (_arg_1 == "cp")
                {
                    if (_arg_3 != null)
                    {
                        _arg_2 = maxCpIncrease(_arg_2, _arg_3);
                        _arg_2 = maxCpDecrease(_arg_2, _arg_3);
                    };
                    if (_arg_4 != null)
                    {
                        _arg_2 = maxCpIncrease(_arg_2, _arg_4);
                        _arg_2 = maxCpDecrease(_arg_2, _arg_4);
                    };
                    if (_arg_5 != null)
                    {
                        _arg_2 = maxCpIncrease(_arg_2, _arg_5);
                        _arg_2 = maxCpDecrease(_arg_2, _arg_5);
                    };
                    if (check_talent)
                    {
                        _arg_2 = getMaximumCPFromTalent(_arg_2);
                    };
                }
                else
                {
                    if (_arg_1 == "agility")
                    {
                        if (_arg_3 != null)
                        {
                            _arg_2 = checkIncreaseAgility(_arg_2, _arg_3);
                            _arg_2 = checkDecreaseAgility(_arg_2, _arg_3);
                        };
                        if (_arg_4 != null)
                        {
                            _arg_2 = checkIncreaseAgility(_arg_2, _arg_4);
                            _arg_2 = checkDecreaseAgility(_arg_2, _arg_4);
                        };
                        if (_arg_5 != null)
                        {
                            _arg_2 = checkIncreaseAgility(_arg_2, _arg_5);
                            _arg_2 = checkDecreaseAgility(_arg_2, _arg_5);
                        };
                        if (check_talent)
                        {
                            _arg_2 = getAgilityRateFromTalent(_arg_2);
                        };
                    }
                    else
                    {
                        if (_arg_1 == "critical")
                        {
                            if (_arg_3 != null)
                            {
                                _arg_2 = checkIncreaseCritical(_arg_2, _arg_3);
                                _arg_2 = checkDecreaseCritical(_arg_2, _arg_3);
                            };
                            if (_arg_4 != null)
                            {
                                _arg_2 = checkIncreaseCritical(_arg_2, _arg_4);
                                _arg_2 = checkDecreaseCritical(_arg_2, _arg_4);
                            };
                            if (_arg_5 != null)
                            {
                                _arg_2 = checkIncreaseCritical(_arg_2, _arg_5);
                                _arg_2 = checkDecreaseCritical(_arg_2, _arg_5);
                            };
                            if (check_talent)
                            {
                                _arg_2 = getCriticalRateFromTalent(_arg_2);
                            };
                        }
                        else
                        {
                            if (_arg_1 == "dodge")
                            {
                                if (_arg_3 != null)
                                {
                                    _arg_2 = checkIncreaseDodge(_arg_2, _arg_3);
                                    _arg_2 = checkDecreaseDodge(_arg_2, _arg_3);
                                };
                                if (_arg_4 != null)
                                {
                                    _arg_2 = checkIncreaseDodge(_arg_2, _arg_4);
                                    _arg_2 = checkDecreaseDodge(_arg_2, _arg_4);
                                };
                                if (_arg_5 != null)
                                {
                                    _arg_2 = checkIncreaseDodge(_arg_2, _arg_5);
                                    _arg_2 = checkDecreaseDodge(_arg_2, _arg_5);
                                };
                                if (check_talent)
                                {
                                    _arg_2 = getDodgeFromTalent(_arg_2);
                                };
                            }
                            else
                            {
                                if (_arg_1 == "purify")
                                {
                                    if (_arg_3 != null)
                                    {
                                        _arg_2 = checkIncreasePurify(_arg_2, _arg_3);
                                        _arg_2 = checkDecreasePurify(_arg_2, _arg_3);
                                    };
                                    if (_arg_4 != null)
                                    {
                                        _arg_2 = checkIncreasePurify(_arg_2, _arg_4);
                                        _arg_2 = checkDecreasePurify(_arg_2, _arg_4);
                                    };
                                    if (_arg_5 != null)
                                    {
                                        _arg_2 = checkIncreasePurify(_arg_2, _arg_5);
                                        _arg_2 = checkDecreasePurify(_arg_2, _arg_5);
                                    };
                                    if (check_talent)
                                    {
                                        _arg_2 = getPurifyRateFromTalentByCP(_arg_2);
                                        _arg_2 = getPurifyRateFromTalentByHP(_arg_2);
                                    };
                                };
                            };
                        };
                    };
                };
            };
            return (_arg_2);
        }

        public static function maxHpIncrease(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "max_hp_increase")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 + _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "max_hp_increase")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "max_hp_increase")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            return (_arg_1);
        }

        public static function maxHpDecrease(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "max_hp_decrease")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 - _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "max_hp_decrease")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "max_hp_decrease")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            return (_arg_1);
        }

        public static function maxCpIncrease(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "max_cp_increase")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 + _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "max_cp_increase")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "max_cp_increase")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            return (_arg_1);
        }

        public static function maxCpDecrease(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "max_cp_decrease")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 - _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "max_cp_decrease")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "max_cp_decrease")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            return (_arg_1);
        }

        public static function checkIncreaseAgility(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "agility_increase")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 + _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "agility_increase")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "agility_increase")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect4" in _arg_2))
            {
                if (_arg_2.effect4 == "agility_increase")
                {
                    _local_3 = _arg_2.amount4;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            return (_arg_1);
        }

        public static function checkDecreaseAgility(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "agility_decrease")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 - _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "agility_decrease")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "agility_decrease")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            return (_arg_1);
        }

        public static function checkIncreaseCritical(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "critical_increase")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 + _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "critical_increase")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "critical_increase")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            return (_arg_1);
        }

        public static function checkDecreaseCritical(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "critical_decrease")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 - _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "critical_decrease")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "critical_decrease")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            return (_arg_1);
        }

        public static function getDodgeFromTalent(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:* = 0;
            var _local_4:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                if ((_local_2 = _local_4[_local_5].split(":"))[0] == "skill_1006")
                {
                    _local_3 = _local_2[1];
                };
                _local_5++;
            };
            return (_arg_1 + int(_local_3));
        }

        public static function getCriticalDamageFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentCriticalDamageByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public static function talentCriticalDamageByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1009:1":0.1,
                "skill_1009:2":0.2,
                "skill_1009:3":0.3,
                "skill_1009:4":0.4,
                "skill_1009:5":0.5,
                "skill_1009:6":0.6,
                "skill_1009:7":0.7,
                "skill_1009:8":0.8,
                "skill_1009:9":0.9,
                "skill_1009:10":1
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public static function getExtraChargeCPFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentExtraCPByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public static function talentExtraCPByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1010:1":3,
                "skill_1010:2":5,
                "skill_1010:3":8,
                "skill_1010:4":10,
                "skill_1010:5":13,
                "skill_1010:6":15,
                "skill_1010:7":18,
                "skill_1010:8":20,
                "skill_1010:9":23,
                "skill_1010:10":25
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public static function getExtraDamageForTaijutsuFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentExtraDmgTaijutsuByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public static function talentExtraDmgTaijutsuByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1001:1":1,
                "skill_1001:2":1.5,
                "skill_1001:3":2.4,
                "skill_1001:4":3.7,
                "skill_1001:5":5.4,
                "skill_1001:6":7.6,
                "skill_1001:7":10.1,
                "skill_1001:8":13,
                "skill_1001:9":16.1,
                "skill_1001:10":20
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public static function getReduceHPForTaijutsuFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentExtraReduceDmgTaijutsuByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public static function talentExtraReduceDmgTaijutsuByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1001:1":10,
                "skill_1001:2":20,
                "skill_1001:3":30,
                "skill_1001:4":40,
                "skill_1001:5":50,
                "skill_1001:6":60,
                "skill_1001:7":70,
                "skill_1001:8":80,
                "skill_1001:9":90,
                "skill_1001:10":100
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public static function getCopyJutsuPrcFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentCopyJutsuPrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public static function talentCopyJutsuPrcByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1018:1":1,
                "skill_1018:2":2,
                "skill_1018:3":3,
                "skill_1018:4":5,
                "skill_1018:5":7,
                "skill_1018:6":10,
                "skill_1018:7":13,
                "skill_1018:8":16,
                "skill_1018:9":21,
                "skill_1018:10":25
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public static function getCopyGenjutsuPrcFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentCopyGenjutsuPrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public static function talentCopyGenjutsuPrcByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1019:1":1,
                "skill_1019:2":2,
                "skill_1019:3":3,
                "skill_1019:4":5,
                "skill_1019:5":8,
                "skill_1019:6":11,
                "skill_1019:7":15,
                "skill_1019:8":19,
                "skill_1019:9":24,
                "skill_1019:10":30
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public static function getHPCPRevivePrcFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentHPCPRevivePrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public static function talentHPCPRevivePrcByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1023:1":2,
                "skill_1023:2":3,
                "skill_1023:3":5,
                "skill_1023:4":7,
                "skill_1023:5":11,
                "skill_1023:6":15,
                "skill_1023:7":20,
                "skill_1023:8":26,
                "skill_1023:9":32,
                "skill_1023:10":40
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public static function getReboundChanceFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentReboundChanceByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public static function talentReboundChanceByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1007:1":13,
                "skill_1007:2":19,
                "skill_1007:3":25,
                "skill_1007:4":31,
                "skill_1007:5":37,
                "skill_1007:6":44,
                "skill_1007:7":51,
                "skill_1007:8":58,
                "skill_1007:9":64,
                "skill_1007:10":71
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public static function getStunChanceFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentStunChanceByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public static function talentStunChanceByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1007:1":5,
                "skill_1007:2":12,
                "skill_1007:3":18,
                "skill_1007:4":22,
                "skill_1007:5":28,
                "skill_1007:6":34,
                "skill_1007:7":40,
                "skill_1007:8":46,
                "skill_1007:9":52,
                "skill_1007:10":60
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public static function getReduceDamagePercentFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentReduceDamagePrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public static function talentReduceDamagePrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1014:1":1,
                "skill_1014:2":1,
                "skill_1014:3":1,
                "skill_1014:4":2,
                "skill_1014:5":2,
                "skill_1014:6":3,
                "skill_1014:7":3,
                "skill_1014:8":4,
                "skill_1014:9":4,
                "skill_1014:10":5,
                "skill_1024:1":1,
                "skill_1024:2":2,
                "skill_1024:3":3,
                "skill_1024:4":4,
                "skill_1024:5":5,
                "skill_1024:6":6,
                "skill_1024:7":7,
                "skill_1024:8":8,
                "skill_1024:9":9,
                "skill_1024:10":10,
                "skill_1101:1":2,
                "skill_1101:2":4,
                "skill_1101:3":6,
                "skill_1101:4":8,
                "skill_1101:5":10,
                "skill_1101:6":12,
                "skill_1101:7":14,
                "skill_1101:8":16,
                "skill_1101:9":18,
                "skill_1101:10":20
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getWeakenChancePercentFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = undefined;
            var _local_3:Array = [0, 0];
            var _local_4:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_1 = _local_4[_local_5].split(":");
                _local_2 = talentWeakenChancePrcByLvl(_local_1[0], _local_1[1]);
                _local_3[0] = (_local_3[0] + _local_2[0]);
                _local_3[1] = (_local_3[1] + _local_2[1]);
                _local_5++;
            };
            return (_local_3);
        }

        public static function talentWeakenChancePrcByLvl(_arg_1:*, _arg_2:*):Array
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1030:1":[5, 1],
                "skill_1030:2":[7, 2],
                "skill_1030:3":[10, 3],
                "skill_1030:4":[14, 4],
                "skill_1030:5":[20, 5],
                "skill_1030:6":[27, 7],
                "skill_1030:7":[36, 10],
                "skill_1030:8":[46, 13],
                "skill_1030:9":[57, 16],
                "skill_1030:10":[70, 20]
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return ([0, 0]);
        }

        public static function getRecoverHPCPChancePercentFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = undefined;
            var _local_3:Array = [0, 0];
            var _local_4:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_1 = _local_4[_local_5].split(":");
                _local_2 = talentRecoverHPCPChancePrcByLvl(_local_1[0], _local_1[1]);
                _local_3[0] = (_local_3[0] + _local_2[0]);
                _local_3[1] = (_local_3[1] + _local_2[1]);
                _local_5++;
            };
            return (_local_3);
        }

        public static function talentRecoverHPCPChancePrcByLvl(_arg_1:*, _arg_2:*):Array
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1033:1":[1, 1],
                "skill_1033:2":[2, 1],
                "skill_1033:3":[4, 2],
                "skill_1033:4":[8, 2],
                "skill_1033:5":[12, 2],
                "skill_1033:6":[17, 3],
                "skill_1033:7":[23, 3],
                "skill_1033:8":[30, 4],
                "skill_1033:9":[39, 5],
                "skill_1033:10":[48, 6]
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return ([0, 0]);
        }

        public static function getHPRecoverPercentUnder50PRCFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentHPRPUnder50PrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public static function talentHPRPUnder50PrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1024:1":1,
                "skill_1024:2":1,
                "skill_1024:3":1,
                "skill_1024:4":2,
                "skill_1024:5":2,
                "skill_1024:6":2,
                "skill_1024:7":3,
                "skill_1024:8":3,
                "skill_1024:9":3,
                "skill_1024:10":4
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getReboundDamagePercentAndAmountFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = undefined;
            var _local_3:Array = [0, 0];
            var _local_4:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_1 = _local_4[_local_5].split(":");
                _local_2 = talentReboundDamagePrcAndAmtByLvl(_local_1[0], _local_1[1]);
                _local_3[0] = (_local_3[0] + _local_2[0]);
                _local_3[1] = (_local_3[1] + _local_2[1]);
                _local_5++;
            };
            return (_local_3);
        }

        public static function talentReboundDamagePrcAndAmtByLvl(_arg_1:*, _arg_2:*):Array
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1015:1":[1, 3],
                "skill_1015:2":[3, 5],
                "skill_1015:3":[5, 7],
                "skill_1015:4":[7, 10],
                "skill_1015:5":[9, 14],
                "skill_1015:6":[11, 18],
                "skill_1015:7":[13, 22],
                "skill_1015:8":[15, 28],
                "skill_1015:9":[17, 36],
                "skill_1015:10":[19, 50]
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return ([0, 0]);
        }

        public static function getStunResistPercentFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentStunResistPrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public static function talentStunResistPrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1014:1":1,
                "skill_1014:2":2,
                "skill_1014:3":3,
                "skill_1014:4":4,
                "skill_1014:5":6,
                "skill_1014:6":8,
                "skill_1014:7":11,
                "skill_1014:8":14,
                "skill_1014:9":17,
                "skill_1014:10":20
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getChanceToRecoverHPByAttackFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentRecoverHPPrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public static function talentRecoverHPPrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1025:1":2,
                "skill_1025:2":4,
                "skill_1025:3":6,
                "skill_1025:4":8,
                "skill_1025:5":10,
                "skill_1025:6":12,
                "skill_1025:7":14,
                "skill_1025:8":16,
                "skill_1025:9":18,
                "skill_1025:10":20
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getChanceToReduceDodgeFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentReduceDodgePrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public static function talentReduceDodgePrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1036:1":1,
                "skill_1036:2":2,
                "skill_1036:3":3,
                "skill_1036:4":4,
                "skill_1036:5":6,
                "skill_1036:6":8,
                "skill_1036:7":11,
                "skill_1036:8":14,
                "skill_1036:9":16,
                "skill_1036:10":20
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getCaptureReduceDodgeFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentCaptureReduceDodgePrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public static function talentCaptureReduceDodgePrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1036:1":1,
                "skill_1036:2":2,
                "skill_1036:3":3,
                "skill_1036:4":4,
                "skill_1036:5":5,
                "skill_1036:6":6,
                "skill_1036:7":7,
                "skill_1036:8":8,
                "skill_1036:9":9,
                "skill_1036:10":10
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getExtraFireEarthDamageFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentExtraFireEarthDamagePrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public static function talentExtraFireEarthDamagePrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1040:1":2,
                "skill_1040:2":3,
                "skill_1040:3":4,
                "skill_1040:4":6,
                "skill_1040:5":8,
                "skill_1040:6":10,
                "skill_1040:7":12,
                "skill_1040:8":14,
                "skill_1040:9":17,
                "skill_1040:10":20
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getExtraWindWaterDamageFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentExtraWindWaterDamagePrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public static function talentExtraWindWaterDamagePrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1044:1":1,
                "skill_1044:2":1,
                "skill_1044:3":2,
                "skill_1044:4":3,
                "skill_1044:5":4,
                "skill_1044:6":5,
                "skill_1044:7":6,
                "skill_1044:8":8,
                "skill_1044:9":10,
                "skill_1044:10":12
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getCapturePercentFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentCapturePrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public static function talentCapturePrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1036:1":1,
                "skill_1036:2":2,
                "skill_1036:3":3,
                "skill_1036:4":4,
                "skill_1036:5":5,
                "skill_1036:6":6,
                "skill_1036:7":8,
                "skill_1036:8":10,
                "skill_1036:9":12,
                "skill_1036:10":15
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getExtraFireEarthDamagePassiveFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentExtraFireEarthDamagePassivePrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public static function talentExtraFireEarthDamagePassivePrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1040:1":1,
                "skill_1040:2":2,
                "skill_1040:3":3,
                "skill_1040:4":4,
                "skill_1040:5":5,
                "skill_1040:6":6,
                "skill_1040:7":7,
                "skill_1040:8":8,
                "skill_1040:9":9,
                "skill_1040:10":10
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getFrozenChanceFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentFrozenChancePrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public static function talentFrozenChancePrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1042:1":1,
                "skill_1042:2":1,
                "skill_1042:3":2,
                "skill_1042:4":3,
                "skill_1042:5":3,
                "skill_1042:6":5,
                "skill_1042:7":6,
                "skill_1042:8":7,
                "skill_1042:9":9,
                "skill_1042:10":11
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getPoisonResistPercentFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:int;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentPoisonResistPrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (int(_local_2));
        }

        public static function talentPoisonResistPrcByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1025:1":100,
                "skill_1025:2":100,
                "skill_1025:3":100,
                "skill_1025:4":100,
                "skill_1025:5":100,
                "skill_1025:6":100,
                "skill_1025:7":100,
                "skill_1025:8":100,
                "skill_1025:9":100,
                "skill_1025:10":100
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getCriticalRateFromTalent(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:int;
            var _local_4:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentCriticalByLvl(_local_2[0], _local_2[1]));
                _local_5++;
            };
            return (_arg_1 + int(_local_3));
        }

        public static function talentCriticalByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1009:1":1,
                "skill_1009:2":1,
                "skill_1009:3":1,
                "skill_1009:4":2,
                "skill_1009:5":2,
                "skill_1009:6":3,
                "skill_1009:7":3,
                "skill_1009:8":4,
                "skill_1009:9":4,
                "skill_1009:10":5
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getAccuracyFromTalent(_arg_1:int):*
        {
            var _local_2:* = undefined;
            var _local_3:int;
            var _local_4:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentAccuracyByLvl(_local_2[0], _local_2[1]));
                _local_5++;
            };
            _arg_1 = (_arg_1 + _local_3);
            return (int(_arg_1));
        }

        public static function talentAccuracyByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1006:1":1,
                "skill_1006:2":2,
                "skill_1006:3":3,
                "skill_1006:4":4,
                "skill_1006:5":5,
                "skill_1006:6":6,
                "skill_1006:7":7,
                "skill_1006:8":8,
                "skill_1006:9":9,
                "skill_1006:10":10
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getAgilityRateFromTalent(_arg_1:int):int
        {
            var _local_5:int;
            var _local_6:int;
            var _local_7:String;
            var _local_2:Array = [{
                "key":"skill_1003:1",
                "value":1
            }, {
                "key":"skill_1003:2",
                "value":2
            }, {
                "key":"skill_1003:3",
                "value":3
            }, {
                "key":"skill_1003:4",
                "value":4
            }, {
                "key":"skill_1003:5",
                "value":6
            }, {
                "key":"skill_1003:6",
                "value":8
            }, {
                "key":"skill_1003:7",
                "value":11
            }, {
                "key":"skill_1003:8",
                "value":14
            }, {
                "key":"skill_1003:9",
                "value":17
            }, {
                "key":"skill_1003:10",
                "value":20
            }];
            if (((Character.character_talent_skills == null) || (Character.character_talent_skills == "")))
            {
                return (_arg_1);
            };
            var _local_3:Number = 0;
            var _local_4:Array = ((Character.character_talent_skills.indexOf(",") >= 0) ? Character.character_talent_skills.split(",") : [Character.character_talent_skills]);
            _local_5 = 0;
            while (_local_5 < _local_4.length)
            {
                _local_7 = String(_local_4[_local_5]);
                _local_6 = 0;
                while (_local_6 < _local_2.length)
                {
                    if (_local_2[_local_6].key == _local_7)
                    {
                        _local_3 = (_local_3 + Number(_local_2[_local_6].value));
                        break;
                    };
                    _local_6++;
                };
                _local_5++;
            };
            return (_arg_1 + Math.floor(((_arg_1 * _local_3) / 100)));
        }

        public static function getPurifyRateFromTalent(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:* = 0;
            var _local_4:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentPurifyByTalent(_local_2[0], _local_2[1]));
                _local_5++;
            };
            return (_arg_1 + _local_3);
        }

        public static function talentPurifyByTalent(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1061:1":1,
                "skill_1061:2":2,
                "skill_1061:3":3,
                "skill_1061:4":4,
                "skill_1061:5":5,
                "skill_1061:6":6,
                "skill_1061:7":7,
                "skill_1061:8":8,
                "skill_1061:9":9,
                "skill_1061:10":10
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getPurifyRateFromTalentByCP(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:* = 0;
            var _local_4:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentPurifyByLvlCP(_local_2[0], _local_2[1]));
                _local_5++;
            };
            var _local_6:int = int(Math.round((calculate_stats_with_data("cp") / _local_3)));
            return (_arg_1 + _local_6);
        }

        public static function talentPurifyByLvlCP(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1051:1":1100,
                "skill_1051:2":1050,
                "skill_1051:3":1000,
                "skill_1051:4":950,
                "skill_1051:5":900,
                "skill_1051:6":850,
                "skill_1051:7":800,
                "skill_1051:8":750,
                "skill_1051:9":725,
                "skill_1051:10":700
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getPurifyRateFromTalentByHP(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:* = 0;
            var _local_4:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentPurifyByLvlHP(_local_2[0], _local_2[1]));
                _local_5++;
            };
            var _local_6:int = int(Math.round((calculate_stats_with_data("hp") / _local_3)));
            return (_arg_1 + _local_6);
        }

        public static function talentPurifyByLvlHP(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1102:1":1100,
                "skill_1102:2":1075,
                "skill_1102:3":1050,
                "skill_1102:4":1025,
                "skill_1102:5":1000,
                "skill_1102:6":975,
                "skill_1102:7":950,
                "skill_1102:8":900,
                "skill_1102:9":800,
                "skill_1102:10":700
            };
            if ((_local_3 in _local_4))
            {
                return (int(_local_4[_local_3]));
            };
            return (int(0));
        }

        public static function getMaximumCPFromTalent(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:int;
            var _local_4:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentMaxCPByLvl(_local_4[_local_5], _arg_1));
                _local_5++;
            };
            return (int((int(_arg_1) + int(_local_3))));
        }

        public static function talentMaxCPByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = {
                "skill_1010:1":2,
                "skill_1010:2":4,
                "skill_1010:3":6,
                "skill_1010:4":8,
                "skill_1010:5":10,
                "skill_1010:6":12,
                "skill_1010:7":14,
                "skill_1010:8":16,
                "skill_1010:9":18,
                "skill_1010:10":20,
                "skill_1061:1":1,
                "skill_1061:2":2,
                "skill_1061:3":3,
                "skill_1061:4":4,
                "skill_1061:5":5,
                "skill_1061:6":6,
                "skill_1061:7":7,
                "skill_1061:8":8,
                "skill_1061:9":9,
                "skill_1061:10":10
            };
            if ((_arg_1 in _local_3))
            {
                return (Math.floor(((_arg_2 * _local_3[_arg_1]) / 100)));
            };
            return (int(0));
        }

        public static function getMaximumHPFixedFromTalent(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:int;
            var _local_4:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentMaxHPFixedByLvl(_local_4[_local_5], _arg_1));
                _local_5++;
            };
            return (_arg_1 + _local_3);
        }

        public static function talentMaxHPFixedByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = {
                "skill_1046:1":100,
                "skill_1046:2":200,
                "skill_1046:3":300,
                "skill_1046:4":400,
                "skill_1046:5":450,
                "skill_1046:6":500,
                "skill_1046:7":550,
                "skill_1046:8":600,
                "skill_1046:9":650,
                "skill_1046:10":800
            };
            if ((_arg_1 in _local_3))
            {
                return (_local_3[_arg_1]);
            };
            return (int(0));
        }

        public static function getMaximumHPByMaxCPFromTalent(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:int;
            var _local_4:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentMaxHPByMaxCP(_local_4[_local_5], _arg_1));
                _local_5++;
            };
            var _local_6:* = Math.round(((calculate_stats_with_data("cp") * _local_3) / 100));
            return (_arg_1 + _local_6);
        }

        public static function talentMaxHPByMaxCP(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = {
                "skill_1052:1":5,
                "skill_1052:2":6,
                "skill_1052:3":6,
                "skill_1052:4":7,
                "skill_1052:5":7,
                "skill_1052:6":8,
                "skill_1052:7":8,
                "skill_1052:8":9,
                "skill_1052:9":9,
                "skill_1052:10":10
            };
            if ((_arg_1 in _local_3))
            {
                return (_local_3[_arg_1]);
            };
            return (int(0));
        }

        public static function getMaximumHPFromTalent(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:int;
            var _local_4:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_talent_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + talentMaxHPByLvl(_local_4[_local_5], _arg_1));
                _local_5++;
            };
            return (int((int(_arg_1) + int(_local_3))));
        }

        public static function talentMaxHPByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = {
                "skill_1003:1":1,
                "skill_1003:2":2,
                "skill_1003:3":3,
                "skill_1003:4":4,
                "skill_1003:5":5,
                "skill_1003:6":6,
                "skill_1003:7":7,
                "skill_1003:8":8,
                "skill_1003:9":9,
                "skill_1003:10":10
            };
            if ((_arg_1 in _local_3))
            {
                return (Math.floor(((_arg_2 * _local_3[_arg_1]) / 100)));
            };
            return (int(0));
        }

        public static function getMaximumHPFromSenjutsu(_arg_1:*):*
        {
            var _local_2:* = undefined;
            var _local_3:int;
            var _local_4:Array = [];
            if (Character.character_senjutsu_skills != "")
            {
                if (Character.character_senjutsu_skills.indexOf(",") >= 0)
                {
                    _local_4 = Character.character_senjutsu_skills.split(",");
                }
                else
                {
                    _local_4 = [Character.character_senjutsu_skills];
                };
            };
            var _local_5:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5].split(":");
                _local_3 = (_local_3 + senjutsuMaxHPByLvl(_local_4[_local_5], _arg_1));
                _local_5++;
            };
            return (int((int(_arg_1) + int(_local_3))));
        }

        public static function senjutsuMaxHPByLvl(_arg_1:*, _arg_2:*):int
        {
            var _local_3:* = {
                "skill_3001:1":5,
                "skill_3001:2":5,
                "skill_3001:3":6,
                "skill_3001:4":6,
                "skill_3001:5":7,
                "skill_3001:6":8,
                "skill_3001:7":9,
                "skill_3001:8":10,
                "skill_3001:9":11,
                "skill_3001:10":12
            };
            if ((_arg_1 in _local_3))
            {
                return (Math.floor(((_arg_2 * _local_3[_arg_1]) / 100)));
            };
            return (int(0));
        }

        public static function getHealPrcFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentHealPrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public static function talentHealPrcByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1048:1":4,
                "skill_1048:2":8,
                "skill_1048:3":12,
                "skill_1048:4":16,
                "skill_1048:5":20,
                "skill_1048:6":24,
                "skill_1048:7":28,
                "skill_1048:8":32,
                "skill_1048:9":36,
                "skill_1048:10":40
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public static function getHealTurnPrcFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentHealTurnPrcByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public static function talentHealTurnPrcByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1046:1":20,
                "skill_1046:2":40,
                "skill_1046:3":60,
                "skill_1046:4":80,
                "skill_1046:5":100,
                "skill_1046:6":120,
                "skill_1046:7":140,
                "skill_1046:8":160,
                "skill_1046:9":180,
                "skill_1046:10":200
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public static function getMaxHpFromTalent():*
        {
            var _local_1:* = undefined;
            var _local_2:* = 0;
            var _local_3:Array = [];
            if (Character.character_talent_skills != "")
            {
                if (Character.character_talent_skills.indexOf(",") >= 0)
                {
                    _local_3 = Character.character_talent_skills.split(",");
                }
                else
                {
                    _local_3 = [Character.character_talent_skills];
                };
            };
            var _local_4:* = 0;
            while (_local_4 < _local_3.length)
            {
                _local_1 = _local_3[_local_4].split(":");
                _local_2 = (_local_2 + talentMaxHpByLvl(_local_1[0], _local_1[1]));
                _local_4++;
            };
            return (_local_2);
        }

        public static function talentMaxHpByLvl(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = ((_arg_1 + ":") + _arg_2);
            var _local_4:* = {
                "skill_1046:1":100,
                "skill_1046:2":200,
                "skill_1046:3":300,
                "skill_1046:4":400,
                "skill_1046:5":450,
                "skill_1046:6":500,
                "skill_1046:7":550,
                "skill_1046:8":600,
                "skill_1046:9":650,
                "skill_1046:10":800
            };
            if ((_local_3 in _local_4))
            {
                return (_local_4[_local_3]);
            };
            return (0);
        }

        public static function checkIncreaseDodge(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "dodge_increase")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 + _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "dodge_increase")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "dodge_increase")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            return (_arg_1);
        }

        public static function checkDecreaseDodge(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "dodge_decrease")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 - _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "dodge_decrease")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "dodge_decrease")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            return (_arg_1);
        }

        public static function checkIncreasePurify(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "purify_increase")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 + _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "purify_increase")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "purify_increase")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 + _local_3);
                };
            };
            return (_arg_1);
        }

        public static function checkDecreasePurify(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = undefined;
            if (_arg_2.effect == "purify_decrease")
            {
                _local_3 = _arg_2.amount;
                if (_arg_2.type == "percent")
                {
                    _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                };
                _arg_1 = (_arg_1 - _local_3);
            };
            if (("effect2" in _arg_2))
            {
                if (_arg_2.effect2 == "purify_decrease")
                {
                    _local_3 = _arg_2.amount2;
                    if (_arg_2.type2 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            if (("effect3" in _arg_2))
            {
                if (_arg_2.effect3 == "purify_decrease")
                {
                    _local_3 = _arg_2.amount3;
                    if (_arg_2.type3 == "percent")
                    {
                        _local_3 = Math.floor(((_arg_1 * _local_3) / 100));
                    };
                    _arg_1 = (_arg_1 - _local_3);
                };
            };
            return (_arg_1);
        }

        public static function formatNumber(_arg_1:*):*
        {
            var _local_2:* = ["", "K", "M"];
            var _local_3:* = 0;
            while (_arg_1 >= 1000)
            {
                _arg_1 = (_arg_1 / 1000);
                _local_3++;
            };
            return (Math.round(_arg_1) + _local_2[_local_3]);
        }

        public static function calculate_pet_xp(_arg_1:int):*
        {
            var _local_2:Array = [0, 28, 61, 99, 142, 192, 249, 315, 389, 473, 569, 676, 798, 935, 1088, 1261, 1455, 1671, 1914, 2184, 2487, 2823, 3198, 3616, 4080, 4596, 5196, 5805, 6510, 7291, 8156, 9114, 10173, 11345, 12640, 14071, 15651, 17395, 19319, 21440, 23780, 27733, 30696, 33471, 36193, 39579, 42140, 46342, 49634, 53379, 56695, 59936, 66622, 70841, 74605, 79734, 86755, 90227, 95427, 103740, 110291, 125307, 145705, 174070, 211985, 259748, 314393, 377280, 447571, 526381, 612222, 705963, 806478, 912730, 1026380, 1144886, 1269847, 1402425, 1538415, 1683103, 1831845, 2049957, 2372858, 2695758, 3018659, 3541560, 4057490, 4639279, 5221067, 5902856, 6184644, 7297879, 8611498, 10161568, 11990650, 14148967, 65910291, 81728761, 101343664, 125666144, 155826018];
            return (((_arg_1 >= 1) && (_arg_1 <= 100)) ? _local_2[_arg_1] : 99999999999);
        }


        public function calculate_stats(_arg_1:String):*
        {
            var _local_2:Number = NaN;
            if (_arg_1 == "hp")
            {
                return ((60 + (int(Character.character_lvl) * 40)) + (Character.atrrib_earth * 30));
            };
            if (_arg_1 == "cp")
            {
                return (Number(((60 + (int(Character.character_lvl) * 40)) + (Character.atrrib_water * 30))));
            };
            if (_arg_1 == "agility")
            {
                return (Number(((9 + int(Character.character_lvl)) + Character.atrrib_wind)));
            };
            if (_arg_1 == "critical")
            {
                _local_2 = (5 + (Character.atrrib_lightning * 0.4));
                return (_local_2.toFixed(1));
            };
            if (_arg_1 == "dodge")
            {
                _local_2 = (5 + (Character.atrrib_wind * 0.4));
                return (_local_2.toFixed(1));
            };
            if (_arg_1 == "purify")
            {
                _local_2 = (0 + (Character.atrrib_water * 0.4));
                return (_local_2.toFixed(1));
            };
        }

        public function calculate_xp(_arg_1:int):*
        {
            var _local_2:Array = [0, 15, 304, 493, 711, 961, 1247, 1574, 1945, 2366, 2843, 3382, 3989, 4673, 5542, 6306, 7273, 8537, 9569, 10922, 12433, 14117, 15992, 18080, 20401, 22981, 25845, 29024, 32548, 36454, 40780, 45569, 50867, 56725, 63201, 70354, 78254, 86973, 96593, 107202, 118899, 131790, 145991, 161632, 178850, 197801, 218652, 241587, 266806, 294530, 325000, 358478, 395253, 435640, 479982, 528656, 582073, 640648, 704980, 775497, 858822, 973598, 1030523, 1132364, 1243956, 1366211, 1500266, 1646789, 1807388, 1983211, 2175702, 3857490, 5539279, 7221067, 8902856, 10584644, 34958287, 38667739, 42377192, 46086644, 49796096, 69149957, 73172858, 77195758, 81218659, 85241560, 118206898, 130658489, 143202210, 155837542, 168563974, 586602629, 686931906, 811340210, 965606507, 1156896715, 4164828174, 5067207611, 6240300880, 7765322130, 9747849755];
            return (((_arg_1 >= 1) && (_arg_1 <= 100)) ? _local_2[_arg_1] : 99999999999);
        }


    }
}//package Managers

