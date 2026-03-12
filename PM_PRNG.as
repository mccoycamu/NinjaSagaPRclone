// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.PM_PRNG

package id.ninjasage
{
    public class PM_PRNG 
    {

        public var seed:uint;

        public function PM_PRNG(_arg_1:*=null)
        {
            var _local_2:int = new Date().getTime();
            var _local_3:int = int(((Math.random() * 0.025) * int.MAX_VALUE));
            this.seed = ((_arg_1 == null) ? (_local_2 ^ _local_3) : _arg_1);
        }

        public function nextInt():uint
        {
            return (this.gen());
        }

        public function nextDouble():Number
        {
            return (this.gen() / 2147483647);
        }

        public function nextIntRange(_arg_1:Number, _arg_2:Number):uint
        {
            _arg_1 = (_arg_1 - 0.4999);
            _arg_2 = (_arg_2 + 0.4999);
            return (Math.round((_arg_1 + ((_arg_2 - _arg_1) * this.nextDouble()))));
        }

        public function nextDoubleRange(_arg_1:Number, _arg_2:Number):Number
        {
            this.seed = ((this.seed * 16807) % 2147483647);
            var _local_3:Number = (this.seed / 2147483647);
            return (_arg_1 + ((_arg_2 - _arg_1) * _local_3));
        }

        private function gen():uint
        {
            return (this.seed = ((this.seed * 16807) % 2147483647));
        }


    }
}//package id.ninjasage

