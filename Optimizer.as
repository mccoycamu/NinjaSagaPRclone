// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Managers.Optimizer

package Managers
{
    import flash.system.System;
    import flash.net.LocalConnection;
    import flash.display.MovieClip;
    import flash.sampler.getSize;

    public class Optimizer 
    {

        public static var dispatchList:Array = [];
        public static var eventList:Array = [];


        public static function runGC(_arg_1:*, _arg_2:int, _arg_3:Boolean=false):*
        {
            var _local_4:* = undefined;
            if (!_arg_3)
            {
                killAllChild(_arg_1, false);
                killAllListeners();
                _arg_1.stopAllMovieClips();
                if (_arg_2 > 0)
                {
                    killIcons(_arg_1, _arg_2, false);
                };
                forceRunGC();
            }
            else
            {
                _local_4 = (System.freeMemory / 1000000);
                _arg_1.stopAllMovieClips();
                getAllChild(_arg_1);
                killAllChild(_arg_1, true);
                getAllListeners();
                killAllListeners(true);
                if (_arg_2 > 0)
                {
                    killIcons(_arg_1, _arg_2, true);
                };
                forceRunGC(true);
                _local_4 = null;
            };
        }

        public static function killIcons(_arg_1:*, _arg_2:int, _arg_3:Boolean=false):void
        {
            var _local_4:int;
            while (_local_4 < _arg_2)
            {
                while (_arg_1[("item_" + _local_4)].iconMc.iconHolder.numChildren > 0)
                {
                    _arg_1[("item_" + _local_4)].iconMc.iconHolder.removeChildAt(0);
                    while (_arg_1[("item_" + _local_4)].numChildren > 0)
                    {
                        _arg_1[("item_" + _local_4)].removeChildAt(0);
                    };
                };
                _arg_1[("item_" + _local_4)].iconMc.iconHolder = null;
                _arg_1[("item_" + _local_4)].iconMc = null;
                _arg_1[("item_" + _local_4)] = null;
                _local_4++;
            };
            _local_4 = undefined;
            if (!_arg_3)
            {
            };
        }

        public static function forceRunGC(_arg_1:Boolean=false):void
        {
            try
            {
                new LocalConnection().connect("foo");
                new LocalConnection().connect("foo");
            }
            catch(e)
            {
            };
            if (!_arg_1)
            {
            };
        }

        public static function getAllChild(_arg_1:*):*
        {
            var _local_2:String;
            var _local_3:int;
            while (_local_3 < _arg_1.numChildren)
            {
                _local_2 = (_local_2 + (_arg_1.getChildAt(_local_3).name + ", "));
                _local_3++;
            };
            _local_3 = undefined;
            _local_2 = null;
        }

        public static function killAllChild(_arg_1:*, _arg_2:Boolean=false):*
        {
            var _local_3:* = _arg_1.numChildren;
            _arg_1.removeChildren(0, (_arg_1.numChildren - 1));
            if (!_arg_2)
            {
            };
            _local_3 = null;
        }

        public static function removeAllChild(_arg_1:MovieClip):void
        {
            var _local_2:uint;
            var _local_3:uint;
            if (_arg_1 != null)
            {
                _local_2 = _arg_1.numChildren;
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    _arg_1.removeChildAt(0);
                    _local_3++;
                };
            };
        }

        public static function addListeners(_arg_1:*, _arg_2:String, _arg_3:Function, _arg_4:Boolean=false, _arg_5:int=0, _arg_6:Boolean=true):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            if (!_arg_1.hasEventListener(_arg_2))
            {
                dispatchList.push({
                    "func":_arg_1,
                    "name":_arg_1.name
                });
                eventList.push({
                    "type":_arg_2,
                    "listener":_arg_3,
                    "useCapture":_arg_4
                });
                _arg_1.addEventListener(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            };
        }

        public static function killAllListeners(_arg_1:Boolean=false):void
        {
            var _local_2:Object;
            var _local_3:* = undefined;
            var _local_4:uint;
            while (_local_4 < eventList.length)
            {
                _local_2 = eventList[_local_4];
                _local_3 = dispatchList[_local_4].func;
                _local_3.removeEventListener(_local_2.type, _local_2.listener, _local_2.useCapture);
                _local_4++;
            };
            _local_2 = null;
            _local_3 = null;
            dispatchList = [];
            eventList = [];
            _local_4 = undefined;
            if (!_arg_1)
            {
            };
        }

        public static function getAllListeners():void
        {
            var _local_1:uint;
            var _local_2:Array = [];
            while (_local_1 < eventList.length)
            {
                _local_2.push((((dispatchList[_local_1].name + ": ") + eventList[_local_1].type) + ", "));
                _local_1++;
            };
            _local_2 = null;
            _local_1 = undefined;
        }

        public static function getMemoryInfo():void
        {
        }

        public static function getObjSize(_arg_1:*):void
        {
        }

        public static function getObjSizeInBytes(_arg_1:*):void
        {
        }

        public static function getObjProperties(_arg_1:*):void
        {
            var _local_2:int;
            var _local_3:Array;
            var _local_4:uint;
            var _local_5:Array = [];
            while (_local_4 < eventList.length)
            {
                if (_arg_1.name == dispatchList[_local_4].name)
                {
                    _local_5[_local_5.length] = eventList[_local_4].type;
                };
                _local_4++;
            };
            if (_local_5.length > 0)
            {
            };
            try
            {
                _local_2 = 0;
                _local_3 = [];
                while (_local_2 < _arg_1.numChildren)
                {
                    if (((_arg_1.getChildAt(_local_2).name.indexOf("iconHolder") >= 0) || (_arg_1.getChildAt(_local_2).name.indexOf("icon") >= 0)))
                    {
                    };
                    _local_3[_local_3.length] = _arg_1.getChildAt(_local_2).name;
                    _local_2++;
                };
                _local_3 = null;
                _local_2 = undefined;
            }
            catch(e:Error)
            {
            };
            _local_4 = undefined;
            _local_5 = null;
        }

        public static function getAllObjSizes(_arg_1:*, _arg_2:String="true"):void
        {
            var _local_3:int;
            var _local_4:Number = 0;
            if (!_arg_2)
            {
            };
            while (_local_3 < _arg_1.numChildren)
            {
                _local_4 = (_local_4 + getSize(_arg_1.getChildAt(_local_3)));
                _local_3++;
            };
            _local_3 = undefined;
            _local_4 = undefined;
        }


    }
}//package Managers

