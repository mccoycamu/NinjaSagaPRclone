// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.StoreAsset

package id.ninjasage
{
    import flash.net.URLLoader;
    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    import flash.net.URLRequest;
    import flash.net.URLLoaderDataFormat;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.filesystem.FileMode;

    public class StoreAsset 
    {

        private var url:String;
        private var urlLoader:URLLoader;
        private var path:File;
        private var fs:FileStream;

        public function StoreAsset(_arg_1:String, _arg_2:File)
        {
            this.url = _arg_1;
            this.path = _arg_2;
        }

        public static function download(_arg_1:String, _arg_2:File):void
        {
            var _local_3:StoreAsset = new StoreAsset(_arg_1, _arg_2);
            _local_3.store();
        }


        private function store():void
        {
            if (((!(this.url)) || (!(this.path))))
            {
                return;
            };
            var urlRequest:URLRequest = new URLRequest(this.url);
            this.urlLoader = new URLLoader();
            this.urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this.urlLoader.addEventListener(Event.COMPLETE, this.onComplete);
            this.urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
            try
            {
                this.urlLoader.load(urlRequest);
            }
            catch(error:Error)
            {
                Log.error(this, "Unable to store assets:", this.url, error);
                destroy();
            };
        }

        private function onComplete(_arg_1:Event):void
        {
            if (!_arg_1.target.hasOwnProperty("data"))
            {
                Log.error(this, "Unable to save:", this.url);
                this.destroy();
                return;
            };
            this.fs = new FileStream();
            this.fs.addEventListener(IOErrorEvent.IO_ERROR, this.onFileSaveError);
            this.fs.open(this.path, FileMode.WRITE);
            this.fs.writeBytes(_arg_1.target.data);
            this.fs.close();
            this.destroy();
        }

        private function onFileSaveError(_arg_1:IOErrorEvent):void
        {
            Log.error(this, "Unable to open/save to a file:", this.url, this.path, _arg_1.toString());
            this.destroy();
        }

        private function onError(_arg_1:IOErrorEvent):void
        {
            Log.error(this, "Download error:", this.url, _arg_1.toString());
            this.destroy();
        }

        private function destroy():void
        {
            if (this.urlLoader)
            {
                this.urlLoader.removeEventListener(Event.COMPLETE, this.onComplete);
                this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, this.onError);
                this.urlLoader.close();
                this.urlLoader = null;
            };
            if (this.fs)
            {
                this.fs.removeEventListener(IOErrorEvent.IO_ERROR, this.onFileSaveError);
                this.fs = null;
            };
            this.path = null;
            this.url = null;
        }


    }
}//package id.ninjasage

