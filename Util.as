// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.Util

package id.ninjasage
{
    import com.brokenfunction.json.decodeJson;
    import com.brokenfunction.json.encodeJson;
    import flash.filesystem.File;
    import Storage.Character;

    public class Util 
    {


        public static function copy(_arg_1:*):*
        {
            return (decodeJson(encodeJson(_arg_1)));
        }

        public static function copyObject(_arg_1:Object, _arg_2:Object=null):*
        {
            var _local_3:String;
            if (_arg_2 == null)
            {
                _arg_2 = {};
            };
            for (_local_3 in _arg_1)
            {
                _arg_2[_local_3] = _arg_1[_local_3];
            };
            return (_arg_2);
        }

        public static function calculateFromString(_arg_1:String, _arg_2:Object=null):Number
        {
            var _local_7:String;
            var _local_9:String;
            var _local_10:Number;
            var _local_11:Number;
            var _local_3:Array = [];
            var _local_4:Array = [];
            var _local_5:Object = {
                "+":{
                    "p":2,
                    "d":"L"
                },
                "-":{
                    "p":2,
                    "d":"L"
                },
                "*":{
                    "p":3,
                    "d":"L"
                },
                "/":{
                    "p":3,
                    "d":"L"
                },
                "%":{
                    "p":3,
                    "d":"L"
                },
                "^":{
                    "p":4,
                    "d":"R"
                }
            };
            _arg_1 = _arg_1.replace(/\s+/g, "");
            var _local_6:Array = _arg_1.match(/([a-zA-Z]+|\d+\.?\d*|\+|\-|\*|\/|\%|\^|\(|\))/g);
            for each (_local_7 in _local_6)
            {
                if (!isNaN(Number(_local_7)))
                {
                    _local_3.push(_local_7);
                }
                else
                {
                    if (((_arg_2) && (_arg_2.hasOwnProperty(_local_7))))
                    {
                        _local_3.push(_arg_2[_local_7]);
                    }
                    else
                    {
                        if (_local_7 == "(")
                        {
                            _local_4.push(_local_7);
                        }
                        else
                        {
                            if (_local_7 == ")")
                            {
                                while (((_local_4.length > 0) && (!(_local_4[(_local_4.length - 1)] == "("))))
                                {
                                    _local_3.push(_local_4.pop());
                                };
                                _local_4.pop();
                            }
                            else
                            {
                                if (_local_5[_local_7])
                                {
                                    while ((((_local_4.length > 0) && (_local_5[_local_4[(_local_4.length - 1)]])) && (((_local_5[_local_7].d == "L") && (_local_5[_local_7].p <= _local_5[_local_4[(_local_4.length - 1)]].p)) || ((_local_5[_local_7].d == "R") && (_local_5[_local_7].p < _local_5[_local_4[(_local_4.length - 1)]].p)))))
                                    {
                                        _local_3.push(_local_4.pop());
                                    };
                                    _local_4.push(_local_7);
                                };
                            };
                        };
                    };
                };
            };
            while (_local_4.length > 0)
            {
                _local_3.push(_local_4.pop());
            };
            var _local_8:Array = [];
            for each (_local_9 in _local_3)
            {
                if (!isNaN(Number(_local_9)))
                {
                    _local_8.push(Number(_local_9));
                }
                else
                {
                    _local_10 = _local_8.pop();
                    _local_11 = _local_8.pop();
                    switch (_local_9)
                    {
                        case "+":
                            _local_8.push((_local_11 + _local_10));
                            break;
                        case "-":
                            _local_8.push((_local_11 - _local_10));
                            break;
                        case "*":
                            _local_8.push((_local_11 * _local_10));
                            break;
                        case "/":
                            _local_8.push((_local_11 / _local_10));
                            break;
                        case "%":
                            _local_8.push((_local_11 % _local_10));
                            break;
                        case "^":
                            _local_8.push(Math.pow(_local_11, _local_10));
                            break;
                    };
                };
            };
            return (_local_8.pop());
        }

        public static function convertToNumber(_arg_1:String):Number
        {
            var _local_2:Number = 1;
            var _local_3:String = _arg_1;
            var _local_4:String = _arg_1.charAt((_arg_1.length - 1)).toLowerCase();
            switch (_local_4)
            {
                case "k":
                    _local_2 = 1000;
                    _local_3 = _arg_1.substring(0, (_arg_1.length - 1));
                    break;
                case "m":
                    _local_2 = 1000000;
                    _local_3 = _arg_1.substring(0, (_arg_1.length - 1));
                    break;
                case "b":
                    _local_2 = 0x3B9ACA00;
                    _local_3 = _arg_1.substring(0, (_arg_1.length - 1));
                    break;
                case "t":
                    _local_2 = 1000000000000;
                    _local_3 = _arg_1.substring(0, (_arg_1.length - 1));
                    break;
                default:
                    _local_2 = 1;
                    _local_3 = _arg_1;
            };
            var _local_5:Number = Number(_local_3);
            if (isNaN(_local_5))
            {
                throw (new Error("Invalid numeric value"));
            };
            return (_local_5 * _local_2);
        }

        public static function formatNumberWithDot(_arg_1:Number):String
        {
            var _local_2:String = _arg_1.toString();
            var _local_3:* = "";
            var _local_4:int;
            var _local_5:int = (_local_2.length - 1);
            while (_local_5 >= 0)
            {
                _local_3 = (_local_2.charAt(_local_5) + _local_3);
                if ((((++_local_4 % 3) == 0) && (!(_local_5 == 0))))
                {
                    _local_3 = ("." + _local_3);
                };
                _local_5--;
            };
            return (_local_3);
        }

        public static function in_array(_arg_1:*, _arg_2:Array):Boolean
        {
            var _local_3:Boolean;
            var _local_4:* = 0;
            while (_local_4 < _arg_2.length)
            {
                if (_arg_2[_local_4] == _arg_1)
                {
                    _local_3 = true;
                };
                _local_4++;
            };
            return (_local_3);
        }

        public static function checkInArray(_arg_1:String, _arg_2:Array):Boolean
        {
            var _local_4:String;
            var _local_3:Boolean;
            for each (_local_4 in _arg_2)
            {
                if (_local_4 == _arg_1)
                {
                    return (true);
                };
            };
            return (false);
        }

        public static function url(_arg_1:String):String
        {
            var _local_2:*;
            var _local_3:*;
            if ((((((_arg_1.length >= 4) && (_arg_1.charAt(0) == "h")) && (_arg_1.charAt(1) == "t")) && (_arg_1.charAt(2) == "t")) && (_arg_1.charAt(3) == "p")))
            {
                return (_arg_1);
            };
            _local_2 = File.applicationDirectory.resolvePath(_arg_1);
            if (_local_2.exists)
            {
                return (_local_2.url);
            };
            _arg_1 = _arg_1.replace("app-storage:/", "");
            _local_3 = File.applicationStorageDirectory.resolvePath(_arg_1);
            if (_local_3.exists)
            {
                return (_local_3.url);
            };
            _arg_1 = (Character.cdn + _arg_1);
            StoreAsset.download(_arg_1, _local_3);
            return (_arg_1);
        }

        public static function formatBytesSize(_arg_1:Number):String
        {
            if (_arg_1 < 0x0400)
            {
                return (_arg_1 + " B");
            };
            if (_arg_1 < 0x100000)
            {
                return ((_arg_1 / 0x0400).toFixed(2) + " KB");
            };
            if (_arg_1 < 0x40000000)
            {
                return ((_arg_1 / 0x100000).toFixed(2) + " MB");
            };
            return ((_arg_1 / 0x40000000).toFixed(2) + " GB");
        }


    }
}//package id.ninjasage

