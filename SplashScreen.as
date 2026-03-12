// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.SplashScreen

package Panels
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import com.utils.NumberUtil;
    import Storage.Character;

    public class SplashScreen extends MovieClip 
    {

        public var progressBar:MovieClip;
        public var logo:MovieClip;
        public var bg:MovieClip;
        public var versionTxt:TextField;
        private var maxScale:* = 0;
        private var percentagePerTask:* = 1;
        private var tempVal:* = 0;

        public function SplashScreen(_arg_1:*=null)
        {
            if (this.bg.totalFrames > 1)
            {
                this.bg.gotoAndStop(NumberUtil.randomInt(1, this.bg.totalFrames));
            };
            this.maxScale = this.progressBar.loadingIcon.progressbarNow.scaleX;
            this.progressBar.loadingIcon.progressbarNow.scaleX = 0;
            this.progressBar.titleTxt.text = "Loading...";
            this.versionTxt.text = Character.build_num;
        }

        public function setPercentagePerTask(_arg_1:*):*
        {
            this.percentagePerTask = this.calculateTask(1, _arg_1);
        }

        public function getPercentagePerTask():*
        {
            return (this.percentagePerTask);
        }

        public function status(_arg_1:String):*
        {
            this.progressBar.titleTxt.text = _arg_1;
        }

        public function increase(_arg_1:*=1):*
        {
            _arg_1 = Math.min(this.maxScale, Math.max(0, _arg_1));
            this.progressBar.loadingIcon.progressbarNow.scaleX = (_arg_1 * this.maxScale);
        }

        public function startSubProgress():*
        {
            this.tempVal = this.progressBar.loadingIcon.progressbarNow.scaleX;
            this.progressBar.loadingIcon.progressbarNow.scaleX = 0;
        }

        public function reset():*
        {
            this.progressBar.loadingIcon.progressbarNow.scaleX = this.tempVal;
        }

        public function calculateTask(_arg_1:*, _arg_2:*):*
        {
            var _local_3:* = (100 / _arg_2);
            return ((_arg_1 * _local_3) / 100);
        }


    }
}//package Panels

