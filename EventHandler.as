// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.EventHandler

package id.ninjasage
{
    import flash.events.EventDispatcher;
    import flash.utils.getQualifiedClassName;
    import id.ninjasage.sounds.SoundAS;

    public class EventHandler extends EventDispatcher 
    {

        private var dispatchList:Array;
        private var eventList:Array;

        public function EventHandler()
        {
            this.eventList = [];
            this.dispatchList = [];
        }

        public function addListener(dispatch:*, type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=true):void
        {
            var wFun:* = undefined;
            if (dispatch == null)
            {
                return;
            };
            var dispatchName:* = getQualifiedClassName(dispatch);
            if (!dispatch.hasEventListener(type))
            {
                wFun = ((type == "click") ? function (_arg_1:*):*
{
    SoundAS.playFx("sfx:click", 0.3);
    listener(_arg_1);
} : listener);
                this.dispatchList.push({
                    "func":dispatch,
                    "name":dispatchName
                });
                this.eventList.push({
                    "type":type,
                    "listener":wFun,
                    "useCapture":useCapture
                });
                dispatch.addEventListener(type, wFun, useCapture, priority, useWeakReference);
            };
        }

        public function removeListener(_arg_1:*, _arg_2:String, _arg_3:Function, _arg_4:Boolean=false):void
        {
            var _local_5:Object;
            var _local_6:*;
            var _local_7:uint;
            while (_local_7 < this.eventList.length)
            {
                _local_5 = this.eventList[_local_7];
                _local_6 = this.dispatchList[_local_7].func;
                if (_local_6 == _arg_1)
                {
                    if (_arg_2 == "click")
                    {
                        _local_6.removeEventListener(_arg_2, _local_5.listener, _arg_4);
                    }
                    else
                    {
                        if ((((_local_5.type == _arg_2) && (_local_5.listener == _arg_3)) && (_local_5.useCapture == _arg_4)))
                        {
                            _local_6.removeEventListener(_arg_2, _arg_3, _arg_4);
                        };
                    };
                    this.dispatchList.splice(_local_7, 1);
                    this.eventList.splice(_local_7, 1);
                    break;
                };
                _local_7++;
            };
            _local_6 = null;
            _local_5 = null;
        }

        public function removeAllEventListeners():void
        {
            var _local_1:Object;
            var _local_2:*;
            var _local_3:uint;
            while (_local_3 < this.eventList.length)
            {
                _local_1 = this.eventList[_local_3];
                _local_2 = this.dispatchList[_local_3].func;
                this.removeTooltip(_local_2);
                _local_2.removeEventListener(_local_1.type, _local_1.listener, _local_1.useCapture);
                _local_3++;
            };
            _local_1 = null;
            _local_2 = null;
            this.dispatchList = [];
            this.eventList = [];
        }

        public function getAllEventListeners():Array
        {
            var _local_1:uint;
            var _local_2:Array = [];
            while (_local_1 < this.eventList.length)
            {
                _local_2.push(((this.dispatchList[_local_1].name + ": ") + this.eventList[_local_1].type));
                _local_1++;
            };
            return (_local_2);
        }

        private function removeTooltip(_arg_1:*):void
        {
            if (_arg_1.hasOwnProperty("tooltip"))
            {
                delete _arg_1.tooltip;
            };
            if (_arg_1.hasOwnProperty("tooltipCache"))
            {
                delete _arg_1.tooltipCache;
            };
            if (_arg_1.hasOwnProperty("metaData"))
            {
                _arg_1.metaData = {};
            };
        }


    }
}//package id.ninjasage

