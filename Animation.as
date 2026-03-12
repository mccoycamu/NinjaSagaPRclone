// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Animation

package 
{
    import flash.display.MovieClip;

    public class Animation extends MovieClip 
    {

        public var battlemanager:*;
        public var is_start:Boolean = false;

        public function Animation(_arg_1:*, _arg_2:Boolean=true)
        {
            addFrameScript(17, this.frame18);
            super();
            this.is_start = _arg_2;
            this.battlemanager = _arg_1;
            addFrameScript(17, this.deleteThis);
        }

        public function deleteThis():*
        {
            this.stop();
            if (this.is_start)
            {
                this.battlemanager.startBattle();
            }
            else
            {
                this.battlemanager._main.loader.removeChild(this);
                this.destroy();
            };
        }

        public function destroy():*
        {
            this.battlemanager = null;
            this.is_start = null;
        }

        internal function frame18():*
        {
            this.stop();
            if (this.is_start)
            {
                this.battlemanager.startBattle();
            }
            else
            {
                this.battlemanager._main.loader.removeChild(this);
                this.destroy();
            };
        }


    }
}//package 

