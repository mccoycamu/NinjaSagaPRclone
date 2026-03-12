// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SenjutsuTransition

package 
{
    import flash.display.MovieClip;

    public class SenjutsuTransition extends MovieClip 
    {

        public function SenjutsuTransition()
        {
            addFrameScript(0, this.frame1, 30, this.frame31);
        }

        internal function frame1():*
        {
            this.stop();
        }

        internal function frame31():*
        {
            this.gotoAndStop(1);
        }


    }
}//package 

