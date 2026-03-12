// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Managers.NinjaLoader

package Managers
{
    import id.ninjasage.EventHandler;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.net.URLRequest;
    import com.utils.GF;

    public class NinjaLoader 
    {

        internal var _parent:* = null;
        public var curr_loading:* = 0;
        public var total_to_load:* = 0;
        public var icons:Array;
        public var holder:*;
        public var lbl:*;
        public var path:String;
        public var frame_pass:* = 0;

        public var holders:* = [];
        public var eventHandler:* = new EventHandler();

        public function NinjaLoader(_arg_1:*)
        {
            this._parent = _arg_1;
        }

        public function loadIcons(_arg_1:Array, _arg_2:*, _arg_3:String, _arg_4:String="items", _arg_5:int=0):*
        {
            this.curr_loading = _arg_5;
            if (_arg_5 != 0)
            {
                this.icons = [];
                this.icons.length = (_arg_5 + 1);
                this.icons[_arg_5] = _arg_1[0];
            }
            else
            {
                this.icons = _arg_1;
            };
            this.holder = _arg_2;
            this.path = _arg_4;
            this.lbl = _arg_3;
            this.startLoading();
        }

        public function startLoading():*
        {
            var obj:* = undefined;
            obj = undefined;
            var loader:Loader;
            if (this.icons.length > this.curr_loading)
            {
                this.frame_pass = 0;
                if (this.lbl != "")
                {
                    this.holder[(this.lbl + this.curr_loading)].visible = true;
                    obj = this.holder[(this.lbl + this.curr_loading)];
                }
                else
                {
                    obj = this.holder;
                };
                loader = new Loader();
                this.eventHandler.addListener(this._parent, Event.ENTER_FRAME, this.checkLoading);
                this.eventHandler.addListener(loader.contentLoaderInfo, Event.COMPLETE, function (_arg_1:Event):*
                {
                    item_completeIcon(_arg_1, obj, path);
                }, false, 0, true);
                loader.load(new URLRequest((((this.path + "/") + this.icons[this.curr_loading]) + ".swf")));
            };
        }

        public function item_completeIcon(_arg_1:*, _arg_2:*, _arg_3:*):void
        {
            var _local_4:Class;
            var _local_5:* = new ((_local_4 = (_arg_1.target.applicationDomain.getDefinition("icon") as Class)))();
            if (_arg_3 == "skills")
            {
                if (("holder" in _arg_2))
                {
                    _arg_2.holder.addChild(_local_5);
                    this.curr_loading++;
                    this.startLoading();
                    return;
                };
                if (("skillIconMc" in _arg_2))
                {
                    if (("iconHolder" in _arg_2.skillIconMc))
                    {
                        _arg_2.skillIconMc.iconHolder.addChild(_local_5);
                    }
                    else
                    {
                        _arg_2.skillIconMc.addChild(_local_5);
                    };
                }
                else
                {
                    if (("iconMC" in _arg_2))
                    {
                        if (("iconHolder" in _arg_2.iconMC))
                        {
                            _arg_2.iconMC.iconHolder.addChild(_local_5);
                        }
                        else
                        {
                            _arg_2.iconMC.addChild(_local_5);
                        };
                    }
                    else
                    {
                        if (("iconMc" in _arg_2))
                        {
                            if (("iconHolder" in _arg_2.iconMc))
                            {
                                _arg_2.iconMc.iconHolder.addChild(_local_5);
                            }
                            else
                            {
                                _arg_2.iconMc.addChild(_local_5);
                            };
                        }
                        else
                        {
                            if (("skillIcon" in _arg_2))
                            {
                                _arg_2.skillIcon.iconHolder.addChild(_local_5);
                            }
                            else
                            {
                                if (("iconHolder" in _arg_2))
                                {
                                    _arg_2.iconHolder.addChild(_local_5);
                                };
                            };
                        };
                    };
                };
            }
            else
            {
                if (("iconHolder" in _arg_2))
                {
                    _arg_2.iconHolder.addChild(_local_5);
                }
                else
                {
                    if (("iconMc" in _arg_2))
                    {
                        if (("iconHolder" in _arg_2.iconMc))
                        {
                            _arg_2.iconMc.iconHolder.addChild(_local_5);
                        }
                        else
                        {
                            _arg_2.iconMc.addChild(_local_5);
                        };
                    }
                    else
                    {
                        if (("iconMC" in _arg_2))
                        {
                            if (("iconHolder" in _arg_2.iconMC))
                            {
                                _arg_2.iconMC.iconHolder.addChild(_local_5);
                            }
                            else
                            {
                                _arg_2.iconMC.addChild(_local_5);
                            };
                        }
                        else
                        {
                            _arg_2.icon.iconHolder.addChild(_local_5);
                        };
                    };
                };
            };
            this.holders.push(_arg_2);
            this.curr_loading++;
            this.startLoading();
        }

        public function checkLoading(_arg_1:Event):*
        {
            this.frame_pass++;
            if (this.frame_pass > 5)
            {
                this._parent.removeEventListener(Event.ENTER_FRAME, this.checkLoading);
                this.frame_pass = 0;
                this.startLoading();
            };
        }

        public function destroy():*
        {
            var _local_1:*;
            this.eventHandler.removeAllEventListeners();
            GF.clearArray(this.icons);
            for each (_local_1 in this.holders)
            {
                GF.removeAllChild(_local_1);
                _local_1 = null;
            };
            GF.clearArray(this.holders);
            this.holder = null;
            this.holders = null;
            this.path = null;
            this.lbl = null;
            this.eventHandler = null;
            this._parent = null;
            this.icons = null;
        }


    }
}//package Managers

