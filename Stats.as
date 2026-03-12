// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.Stats

package id.ninjasage
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.StyleSheet;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.events.ContextMenuEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import flash.utils.getTimer;
    import flash.system.System;
    import flash.net.SharedObject;

    public class Stats extends Sprite 
    {

        public static var displayed:* = false;

        protected const WIDTH:uint = 150;
        protected const HEIGHT:uint = 100;

        protected var xml:XML;
        protected var text:TextField;
        protected var style:StyleSheet;
        protected var timer:uint;
        protected var fps:uint;
        protected var ms:uint;
        protected var ms_prev:uint;
        protected var mem:Number;
        protected var mem_max:Number;
        protected var graph:BitmapData;
        protected var rectangle:Rectangle;
        protected var fps_graph:uint;
        protected var mem_graph:uint;
        protected var mem_max_graph:uint;
        protected var colors:Colors = new Colors();

        public function Stats(_arg_1:*):void
        {
            var _local_2:ContextMenu = new ContextMenu();
            var _local_3:* = new ContextMenuItem("Show Profiler", true);
            var _local_4:* = new ContextMenuItem("Reset Preferences", true);
            _local_2.customItems = [_local_3, _local_4];
            _arg_1.contextMenu = _local_2;
            _local_3.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.onSelect, false, 0, true);
            _local_4.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, this.clearSharedObject, false, 0, true);
            _arg_1 = null;
        }

        private function showStats():*
        {
            if (displayed)
            {
                return;
            };
            displayed = true;
            this.init(null);
        }

        private function hideStats():*
        {
            displayed = false;
            this.destroy(null);
        }

        public function onSelect(_arg_1:*):*
        {
            if (!displayed)
            {
                this.showStats();
            }
            else
            {
                this.hideStats();
            };
        }

        private function init(_arg_1:Event):void
        {
            this.mem_max = 0;
            this.xml = <xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><memMax>MAX:</memMax></xml>
            ;
            this.style = new StyleSheet();
            this.style.setStyle("xml", {
                "fontSize":"20px",
                "fontFamily":"_sans",
                "leading":"-2px"
            });
            this.style.setStyle("fps", {"color":this.hex2css(this.colors.fps)});
            this.style.setStyle("ms", {"color":this.hex2css(this.colors.ms)});
            this.style.setStyle("mem", {"color":this.hex2css(this.colors.mem)});
            this.style.setStyle("memMax", {"color":this.hex2css(this.colors.memmax)});
            this.text = new TextField();
            this.text.width = this.WIDTH;
            this.text.height = 100;
            this.text.styleSheet = this.style;
            this.text.condenseWhite = true;
            this.text.selectable = false;
            this.text.mouseEnabled = false;
            this.rectangle = new Rectangle((this.WIDTH - 1), 0, 1, (this.HEIGHT - 50));
            graphics.beginFill(this.colors.bg);
            graphics.drawRect(0, 0, this.WIDTH, this.HEIGHT);
            graphics.endFill();
            addChild(this.text);
            this.graph = new BitmapData(this.WIDTH, (this.HEIGHT - 50), false, this.colors.bg);
            graphics.drawRect(0, 50, this.WIDTH, (this.HEIGHT - 50));
            addEventListener(MouseEvent.CLICK, this.onClick);
            addEventListener(Event.ENTER_FRAME, this.update);
        }

        private function destroy(_arg_1:Event):void
        {
            graphics.clear();
            while (numChildren > 0)
            {
                removeChildAt(0);
            };
            this.graph.dispose();
            removeEventListener(MouseEvent.CLICK, this.onClick);
            removeEventListener(Event.ENTER_FRAME, this.update);
        }

        private function update(_arg_1:Event):void
        {
            this.timer = getTimer();
            if ((this.timer - 1000) > this.ms_prev)
            {
                this.ms_prev = this.timer;
                this.mem = Number((System.totalMemory * 9.54E-7).toFixed(3));
                this.mem_max = ((this.mem_max > this.mem) ? this.mem_max : this.mem);
                this.fps_graph = Math.min(this.graph.height, ((this.fps / stage.frameRate) * this.graph.height));
                this.mem_graph = (Math.min(this.graph.height, Math.sqrt(Math.sqrt((this.mem * 5000)))) - 2);
                this.mem_max_graph = (Math.min(this.graph.height, Math.sqrt(Math.sqrt((this.mem_max * 5000)))) - 2);
                this.graph.scroll(-1, 0);
                this.graph.fillRect(this.rectangle, this.colors.bg);
                this.graph.setPixel((this.graph.width - 1), (this.graph.height - this.fps_graph), this.colors.fps);
                this.graph.setPixel((this.graph.width - 1), (this.graph.height - ((this.timer - this.ms) >> 1)), this.colors.ms);
                this.graph.setPixel((this.graph.width - 1), (this.graph.height - this.mem_graph), this.colors.mem);
                this.graph.setPixel((this.graph.width - 1), (this.graph.height - this.mem_max_graph), this.colors.memmax);
                this.xml.fps = ((("FPS: " + this.fps) + " / ") + stage.frameRate);
                this.xml.mem = ("MEM: " + this.mem);
                this.xml.memMax = ("MAX: " + this.mem_max);
                this.fps = 0;
            };
            this.fps++;
            this.xml.ms = ("MS: " + (this.timer - this.ms));
            this.ms = this.timer;
            this.text.htmlText = this.xml;
        }

        private function onClick(_arg_1:MouseEvent):void
        {
            if (((mouseY / height) > 0.5))
            {
                stage.frameRate--;
            }
            else
            {
                stage.frameRate++;
            };
            this.xml.fps = ((("FPS: " + this.fps) + " / ") + stage.frameRate);
            this.text.htmlText = this.xml;
        }

        private function hex2css(_arg_1:int):String
        {
            return ("#" + _arg_1.toString(16));
        }

        private function clearSharedObject(_arg_1:*):*
        {
            var _local_2:* = SharedObject.getLocal("ninja_sage");
            _local_2.clear();
            _local_2.flush();
            _local_2 = null;
        }


    }
}//package id.ninjasage

class Colors 
{

    public var bg:uint = 0xFFFFFFFF;
    public var fps:uint = 0xFFFF00;
    public var ms:uint = 0xFFFF00;
    public var mem:uint = 0xFFFF00;
    public var memmax:uint = 0xFFFF00;


}


