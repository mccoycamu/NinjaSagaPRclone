// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.RequestWrapper

package id.ninjasage
{
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import com.brokenfunction.json.encodeJson;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import com.brokenfunction.json.decodeJson;
    import flash.events.ErrorEvent;

    public class RequestWrapper 
    {

        private var loader:URLLoader;
        private var callback:Function;

        public function RequestWrapper(_arg_1:String, _arg_2:String, _arg_3:Object, _arg_4:Function, _arg_5:Array)
        {
            this.loader = new URLLoader();
            this.callback = _arg_4;
            var _local_6:URLRequest = new URLRequest(_arg_1);
            _local_6.method = _arg_2;
            if ((_arg_3 is Object))
            {
                _local_6.data = encodeJson(_arg_3);
            };
            if (_arg_5 != null)
            {
                _local_6.requestHeaders = _arg_5;
            };
            this.loader.addEventListener(Event.COMPLETE, this.onComplete);
            this.loader.addEventListener(IOErrorEvent.IO_ERROR, this.onComplete);
            this.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
            this.loader.load(_local_6);
        }

        private function onComplete(e:Event):void
        {
            var response:Object;
            var err:* = null;
            try
            {
                response = decodeJson(this.loader.data);
            }
            catch(error:TypeError)
            {
                response = this.loader.data;
                err = null;
            }
            catch(error:Error)
            {
                err = error;
            }
            finally
            {
                this.callback(response, err);
                this.cleanup();
            };
        }

        private function onError(_arg_1:ErrorEvent):void
        {
            this.callback(null, _arg_1);
            this.cleanup();
        }

        private function cleanup():void
        {
            this.loader.removeEventListener(Event.COMPLETE, this.onComplete);
            this.loader.removeEventListener(IOErrorEvent.IO_ERROR, this.onComplete);
            this.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
            this.loader.close();
            this.callback = null;
            this.loader = null;
        }


    }
}//package id.ninjasage

