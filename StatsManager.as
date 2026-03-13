// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.StatsManager

package Combat
{
    import Storage.Character;
    import Storage.AccessoryBuffs;
    import Storage.WeaponBuffs;
    import Storage.BackItemBuffs;

    public class StatsManager 
    {


        public static function canCheckWpnEffects(characterManager:CharacterManager):*
        {
            var effects:* = undefined;
            try
            {
                effects = characterManager.character_model.effects_manager.user_debuffs;
                return ((effects["disable_weapon_effect"].duration > 0) ? false : true);
            }
            catch(e)
            {
                return (true);
            };
        }

        public static function getSp(_arg_1:CharacterManager):*
        {
            return (int((1000 + ((_arg_1.getLevel() - 80) * 40))));
        }

        public static function recalculateHp(_arg_1:CharacterManager):*
        {
            var _local_3:Object;
            var _local_2:int = ((60 + (_arg_1.getLevel() * 40)) + int((_arg_1.getEarthAttributes() * 30)));
            if (_arg_1.isActionsManagerLoaded())
            {
                _local_2 = (_local_2 + _arg_1.character_model.effects_manager.getIncreaseMaxHPByTalent(_local_2));
                _local_2 = (_local_2 + _arg_1.character_model.effects_manager.getIncreaseMaxHPBySenjutsu(_local_2));
                _local_2 = getMaxHpByEquippedItems(_arg_1, _local_2);
            };
            if (((Character.is_clan_war) && (_arg_1.characterClanData)))
            {
                _local_3 = _arg_1.characterClanData;
                _local_2 = int((_local_2 + Math.floor(((_local_2 * int((_local_3.hot_spring * 30))) / 100))));
            };
            return (_local_2);
        }

        public static function getHp(_arg_1:CharacterManager):*
        {
            var _local_3:Object;
            var _local_2:int = ((60 + (_arg_1.getLevel() * 40)) + int((_arg_1.getEarthAttributes() * 30)));
            if (_arg_1.isActionsManagerLoaded())
            {
                _local_2 = (_local_2 + _arg_1.character_model.effects_manager.getIncreaseMaxHPByTalent(_local_2));
                _local_2 = (_local_2 + _arg_1.character_model.effects_manager.getIncreaseMaxHPBySenjutsu(_local_2));
                _local_2 = getMaxHpByEquippedItems(_arg_1, _local_2);
            };
            if (((Character.is_clan_war) && (_arg_1.characterClanData)))
            {
                _local_3 = _arg_1.characterClanData;
                _local_2 = int((_local_2 + Math.floor(((_local_2 * int((_local_3.hot_spring * 30))) / 100))));
            };
            return (_local_2);
        }

        public static function getMaxHpByEquippedItems(_arg_1:CharacterManager, _arg_2:int):*
        {
            var _local_3:int = ((canCheckWpnEffects(_arg_1)) ? getIncreaseMaxHpFromBuff("weapon", _arg_1.getWeapon(), _arg_2) : 0);
            _arg_2 = (_arg_2 + ((_arg_1.character_model.effects_manager.hadEffect("disable_weapon_effect")) ? 0 : _local_3));
            var _local_4:int = getIncreaseMaxHpFromBuff("back_item", _arg_1.getBackItem(), _arg_2);
            _arg_2 = (_arg_2 + _local_4);
            var _local_5:int = getIncreaseMaxHpFromBuff("accessory", _arg_1.getAccessory(), _arg_2);
            return (_arg_2 + _local_5);
        }

        public static function getIncreaseMaxHpFromBuff(_arg_1:String, _arg_2:String, _arg_3:int):int
        {
            var _local_4:int;
            var _local_5:Array = [];
            if (_arg_1 == "accessory")
            {
                _local_5 = AccessoryBuffs.getCopy(_arg_2).effects;
            }
            else
            {
                if (_arg_1 == "weapon")
                {
                    _local_5 = WeaponBuffs.getCopy(_arg_2).effects;
                }
                else
                {
                    if (_arg_1 == "back_item")
                    {
                        _local_5 = BackItemBuffs.getCopy(_arg_2).effects;
                    };
                };
            };
            var _local_6:* = 0;
            while (_local_6 < _local_5.length)
            {
                if (_local_5[_local_6].effect == "max_hp_increase")
                {
                    if (_local_5[_local_6].calc_type == "number")
                    {
                        _local_4 = (_local_4 + int(_local_5[_local_6].amount));
                    }
                    else
                    {
                        _local_4 = int((_local_4 + Math.floor(((int(_local_5[_local_6].amount) * _arg_3) / 100))));
                    };
                };
                if (_local_5[_local_6].effect == "max_hp_decrease")
                {
                    if (_local_5[_local_6].calc_type == "number")
                    {
                        _local_4 = (_local_4 - int(_local_5[_local_6].amount));
                    }
                    else
                    {
                        _local_4 = int((_local_4 - Math.floor(((int(_local_5[_local_6].amount) * _arg_3) / 100))));
                    };
                };
                _local_6++;
            };
            return (int(_local_4));
        }

        public static function recalculateCp(_arg_1:CharacterManager):*
        {
            var _local_4:Object;
            var _local_2:int = ((60 + (_arg_1.getLevel() * 40)) + int((_arg_1.getWaterAttributes() * 30)));
            var _local_3:Number = ((_arg_1.isActionsManagerLoaded()) ? _arg_1.character_model.effects_manager.getIncreaseMaxCPByTalent() : 0);
            if (_local_3 > 0)
            {
                _local_2 = int((_local_2 + Math.floor(((_local_2 * _local_3) / 100))));
            };
            _local_2 = getMaxCpByEquippedItems(_arg_1, _local_2);
            if (((Character.is_clan_war) && (_arg_1.characterClanData)))
            {
                _local_4 = _arg_1.characterClanData;
                _local_2 = int((_local_2 + Math.floor(((_local_2 * int((_local_4.temple * 30))) / 100))));
            };
            return (_local_2);
        }

        public static function getCp(_arg_1:CharacterManager):*
        {
            var _local_4:Object;
            var _local_2:int = ((60 + (_arg_1.getLevel() * 40)) + int((_arg_1.getWaterAttributes() * 30)));
            var _local_3:Number = ((_arg_1.isActionsManagerLoaded()) ? _arg_1.character_model.effects_manager.getIncreaseMaxCPByTalent() : 0);
            if (_local_3 > 0)
            {
                _local_2 = int((_local_2 + Math.floor(((_local_2 * _local_3) / 100))));
            };
            _local_2 = getMaxCpByEquippedItems(_arg_1, _local_2);
            if (((Character.is_clan_war) && (_arg_1.characterClanData)))
            {
                _local_4 = _arg_1.characterClanData;
                _local_2 = int((_local_2 + Math.floor(((_local_2 * int((_local_4.temple * 30))) / 100))));
            };
            return (_local_2);
        }

        public static function getMaxCpByEquippedItems(_arg_1:CharacterManager, _arg_2:int):*
        {
            var _local_3:int = ((canCheckWpnEffects(_arg_1)) ? getIncreaseMaxCpFromBuff("weapon", _arg_1.getWeapon(), _arg_2) : 0);
            _arg_2 = (_arg_2 + ((_arg_1.character_model.effects_manager.hadEffect("disable_weapon_effect")) ? 0 : _local_3));
            var _local_4:int = getIncreaseMaxCpFromBuff("back_item", _arg_1.getBackItem(), _arg_2);
            _arg_2 = (_arg_2 + _local_4);
            var _local_5:int = getIncreaseMaxCpFromBuff("accessory", _arg_1.getAccessory(), _arg_2);
            return (_arg_2 + _local_5);
        }

        public static function getIncreaseMaxCpFromBuff(_arg_1:String, _arg_2:String, _arg_3:int):int
        {
            var _local_4:int;
            var _local_5:Array = [];
            if (_arg_1 == "accessory")
            {
                _local_5 = AccessoryBuffs.getCopy(_arg_2).effects;
            }
            else
            {
                if (_arg_1 == "weapon")
                {
                    _local_5 = WeaponBuffs.getCopy(_arg_2).effects;
                }
                else
                {
                    if (_arg_1 == "back_item")
                    {
                        _local_5 = BackItemBuffs.getCopy(_arg_2).effects;
                    };
                };
            };
            var _local_6:* = 0;
            while (_local_6 < _local_5.length)
            {
                if (_local_5[_local_6].effect == "max_cp_increase")
                {
                    if (_local_5[_local_6].calc_type == "number")
                    {
                        _local_4 = (_local_4 + int(_local_5[_local_6].amount));
                    }
                    else
                    {
                        _local_4 = int((_local_4 + Math.floor(((int(_local_5[_local_6].amount) * _arg_3) / 100))));
                    };
                };
                if (_local_5[_local_6].effect == "max_cp_decrease")
                {
                    if (_local_5[_local_6].calc_type == "number")
                    {
                        _local_4 = (_local_4 - int(_local_5[_local_6].amount));
                    }
                    else
                    {
                        _local_4 = int((_local_4 - Math.floor(((int(_local_5[_local_6].amount) * _arg_3) / 100))));
                    };
                };
                _local_6++;
            };
            return (int(_local_4));
        }

        public static function getPurify(_arg_1:CharacterManager):*
        {
            var _local_5:int;
            var _local_6:int;
            var _local_2:int = NaN;
            var _local_3:int;
            var _local_4:int = (_arg_1.getWaterAttributes() * 0.4);
            _local_3 = (_local_3 + _local_4);
            if ((_local_6 = ((_arg_1.isActionsManagerLoaded()) ? _arg_1.character_model.effects_manager.checkForIncreasePurifyFromHPPercentage() : 0)) > 0)
            {
                _local_3 = (_local_3 + _local_6);
            };
            if ((_local_5 = ((_arg_1.isActionsManagerLoaded()) ? _arg_1.character_model.effects_manager.getIncreasePurifyByTalent() : 0)) > 0)
            {
                _local_3 = (_local_3 + _local_5);
            };
            return (getPurifyByEquippedItems(_arg_1, _local_3));
        }

        public static function getPurifyByEquippedItems(_arg_1:CharacterManager, _arg_2:int):*
        {
            var _local_3:int = getIncDecPurifyFromBuff("accessory", _arg_1.getAccessory(), _arg_2);
            var _local_4:int = ((canCheckWpnEffects(_arg_1)) ? getIncDecPurifyFromBuff("weapon", _arg_1.getWeapon(), _arg_2) : 0);
            var _local_5:int = getIncDecPurifyFromBuff("back_item", _arg_1.getBackItem(), _arg_2);
            var _local_6:int = ((_local_3 + _local_4) + _local_5);
            _arg_2 = (_arg_2 + _local_6);
            var _local_7:Array = _arg_1.character_model.effects_manager.getActiveBuff("purify");
            var _local_8:Array = _arg_1.character_model.effects_manager.getActiveDebuff("purify");
            _arg_2 = BattleManager.modifyChance(_local_7, "ADD", _arg_2, "purify");
            return (BattleManager.modifyChance(_local_8, "RM", _arg_2, "purify"));
        }

        public static function getIncDecPurifyFromBuff(_arg_1:String, _arg_2:String, _arg_3:int):int
        {
            var _local_4:int;
            var _local_5:Array = [];
            if (_arg_1 == "accessory")
            {
                _local_5 = AccessoryBuffs.getCopy(_arg_2).effects;
            }
            else
            {
                if (_arg_1 == "weapon")
                {
                    _local_5 = WeaponBuffs.getCopy(_arg_2).effects;
                }
                else
                {
                    if (_arg_1 == "back_item")
                    {
                        _local_5 = BackItemBuffs.getCopy(_arg_2).effects;
                    };
                };
            };
            var _local_6:Array = ["purify_increase", "increase_purify"];
            var _local_7:Array = ["purify_decrease", "decrease_purify"];
            var _local_8:* = 0;
            while (_local_8 < _local_5.length)
            {
                if (_local_6.indexOf(_local_5[_local_8].effect) >= 0)
                {
                    _local_4 = (_local_4 + int(_local_5[_local_8].amount));
                };
                if (_local_7.indexOf(_local_5[_local_8].effect) >= 0)
                {
                    _local_4 = (_local_4 - int(_local_5[_local_8].amount));
                };
                _local_8++;
            };
            return (int(_local_4));
        }

        public static function getAgility(_arg_1:CharacterManager):Number
        {
            var _local_4:Number;
            var _local_2:Number = ((9 + _arg_1.getLevel()) + _arg_1.getWindAttributes());
            if (_arg_1.isActionsManagerLoaded())
            {
                _local_4 = _arg_1.character_model.effects_manager.getIncreaseAgilityByTalent();
                if (_local_4 > 0)
                {
                    _local_2 = (_local_2 + Math.floor(((_local_2 * _local_4) / 100)));
                };
            };
            return (getAgilityByEquippedItems(_arg_1, _local_2));
        }

        public static function getAgilityByEquippedItems(_arg_1:CharacterManager, _arg_2:int):*
        {
            var _local_3:int = ((canCheckWpnEffects(_arg_1)) ? getIncDecAgilityFromBuff("weapon", _arg_1.getWeapon(), _arg_2) : 0);
            _arg_2 = (_arg_2 + _local_3);
            var _local_4:int = getIncDecAgilityFromBuff("back_item", _arg_1.getBackItem(), _arg_2);
            _arg_2 = (_arg_2 + _local_4);
            var _local_5:int = getIncDecAgilityFromBuff("accessory", _arg_1.getAccessory(), _arg_2);
            _arg_2 = (_arg_2 + _local_5);
            var _local_6:Array = _arg_1.character_model.effects_manager.getActiveBuff("agility");
            var _local_7:Array = _arg_1.character_model.effects_manager.getActiveDebuff("agility");
            _arg_2 = BattleManager.modifyChance(_local_6, "ADD", _arg_2);
            return (BattleManager.modifyChance(_local_7, "RM", _arg_2));
        }

        public static function getIncDecAgilityFromBuff(_arg_1:String, _arg_2:String, _arg_3:int):int
        {
            var _local_4:int;
            var _local_5:Array = [];
            if (_arg_1 == "accessory")
            {
                _local_5 = AccessoryBuffs.getCopy(_arg_2).effects;
            }
            else
            {
                if (_arg_1 == "weapon")
                {
                    _local_5 = WeaponBuffs.getCopy(_arg_2).effects;
                }
                else
                {
                    if (_arg_1 == "back_item")
                    {
                        _local_5 = BackItemBuffs.getCopy(_arg_2).effects;
                    };
                };
            };
            var _local_6:Array = ["agility_increase", "increase_agility"];
            var _local_7:Array = ["agility_decrease", "decrease_agility"];
            var _local_8:int;
            while (_local_8 < _local_5.length)
            {
                if (_local_6.indexOf(_local_5[_local_8].effect) >= 0)
                {
                    if (((_local_5[_local_8].hasOwnProperty("calc_type")) && (!(_local_5[_local_8].calc_type == null))))
                    {
                        _local_4 = (_local_4 + ((_local_5[_local_8].calc_type == "number") ? Number(_local_5[_local_8].amount) : Math.floor(((_local_5[_local_8].amount * _arg_3) / 100))));
                    }
                    else
                    {
                        _local_4 = (_local_4 + _local_5[_local_8].amount);
                    };
                };
                if (_local_7.indexOf(_local_5[_local_8].effect) >= 0)
                {
                    if (((_local_5[_local_8].hasOwnProperty("calc_type")) && (!(_local_5[_local_8].calc_type == null))))
                    {
                        _local_4 = (_local_4 - ((_local_5[_local_8].calc_type == "number") ? Number(_local_5[_local_8].amount) : Math.floor(((_local_5[_local_8].amount * _arg_3) / 100))));
                    }
                    else
                    {
                        _local_4 = (_local_4 + _local_5[_local_8].amount);
                    };
                };
                _local_8++;
            };
            return (Number(_local_4));
        }

        public static function getBlockChance(_arg_1:CharacterManager):*
        {
            var _local_10:*;
            var _local_2:Array;
            var _local_3:* = undefined;
            var _local_4:int;
            var _local_5:int = _arg_1.character_model.health_manager.getCurrentHP();
            var _local_6:int = _arg_1.character_model.health_manager.getMaxHP();
            var _local_7:Boolean;
            var _local_8:Array = _arg_1.character_model.effects_manager.getAllCharacterSetEffects();
            var _local_9:* = 0;
            while (_local_9 < _local_8.length)
            {
                _local_2 = _local_8[_local_9];
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    if (_local_2[_local_3].effect == "block_damage")
                    {
                        _local_4 = (_local_4 + _local_2[_local_3].amount);
                    };
                    if (_local_2[_local_3].effect == "guard_below_hp")
                    {
                        _local_10 = ((_local_6 * _local_2[_local_3].amount) / 100);
                        if (_local_5 < _local_10)
                        {
                            _local_4 = (_local_4 + _local_2[_local_3].chance);
                        };
                    };
                    _local_3++;
                };
                _local_9++;
            };
            return (_local_4);
        }

        public static function getIgnoreBlockChance(_arg_1:CharacterManager):*
        {
            var _local_2:Array;
            var _local_3:int;
            var _local_4:Array = _arg_1.character_model.effects_manager.getAllCharacterSetEffects();
            var _local_5:* = 0;
            var _local_6:* = 0;
            while (_local_5 < _local_4.length)
            {
                _local_2 = _local_4[_local_5];
                _local_6 = 0;
                while (_local_6 < _local_2.length)
                {
                    if (_local_2[_local_6].effect == "ignore_block_damage")
                    {
                        _local_3 = (_local_3 + _local_2[_local_6].amount);
                    };
                    _local_6++;
                };
                _local_5++;
            };
            return (_local_3);
        }

        public static function getConvertChance(_arg_1:CharacterManager):*
        {
            var _local_2:Array;
            var _local_3:* = undefined;
            var _local_4:int;
            var _local_5:Array = _arg_1.character_model.effects_manager.getAllCharacterSetEffects();
            var _local_6:* = 0;
            while (_local_6 < _local_5.length)
            {
                _local_2 = _local_5[_local_6];
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    if (((_local_2[_local_3].effect == "convert_fulldmg_to_hp") || (_local_2[_local_3].effect == "convert_damage_taken_hp")))
                    {
                        _local_4 = (_local_4 + _local_2[_local_3].chance);
                    };
                    _local_3++;
                };
                _local_6++;
            };
            return (_local_4);
        }

        public static function getConvertChanceCP(_arg_1:CharacterManager):*
        {
            var _local_2:Array;
            var _local_3:* = undefined;
            var _local_4:int;
            var _local_5:Array = _arg_1.character_model.effects_manager.getAllCharacterSetEffects();
            var _local_6:* = 0;
            while (_local_6 < _local_5.length)
            {
                _local_2 = _local_5[_local_6];
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    if (_local_2[_local_3].effect == "convert_damage_taken_cp")
                    {
                        _local_4 = (_local_4 + _local_2[_local_3].chance);
                    };
                    _local_3++;
                };
                _local_6++;
            };
            return (_local_4);
        }


    }
}//package Combat

