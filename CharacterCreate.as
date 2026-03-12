// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.CharacterCreate

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import fl.controls.ColorPicker;
    import flash.text.TextField;
    import br.com.stimuli.loading.BulkLoader;
    import flash.events.MouseEvent;
    import fl.events.ColorPickerEvent;
    import Storage.Character;
    import com.adobe.crypto.CUCSG;
    import flash.geom.ColorTransform;
    import id.ninjasage.Log;

    public class CharacterCreate extends MovieClip 
    {

        public static var hairMC:MovieClip;
        public static var backHairMC:MovieClip;
        public static var weapon_mc:*;
        public static var back_mc:*;
        public static var set_mc:Array = [];
        public static var hair_mc:Array = [];

        public var btn_create:SimpleButton;
        public var btn_element_1:MovieClip;
        public var btn_element_2:MovieClip;
        public var btn_element_3:MovieClip;
        public var btn_element_4:MovieClip;
        public var btn_element_5:MovieClip;
        public var btn_gen_next:SimpleButton;
        public var btn_gen_prev:SimpleButton;
        public var btn_hair_next:SimpleButton;
        public var btn_hair_prev:SimpleButton;
        public var btn_close:SimpleButton;
        public var cPicker1:ColorPicker;
        public var cPicker2:ColorPicker;
        public var char_mc:MovieClip;
        public var char_name:TextField;
        public var decor1:MovieClip;
        public var decor2:MovieClip;
        public var txt_gender:TextField;
        public var txt_hair:TextField;
        public var main:*;
        internal var current_gender:* = 0;
        internal var selected_hair_style_color:* = "";
        public var char_bodyArray:Array = new Array("upper_body", "lower_body", "left_upper_arm", "left_lower_arm", "left_hand", "left_upper_leg", "left_lower_leg", "left_shoe", "right_upper_arm", "right_lower_arm", "right_hand", "right_upper_leg", "right_lower_leg", "right_shoe");
        internal var hair_num:* = 1;
        internal var element:* = 1;
        internal var color_1:uint;
        internal var color_2:uint;
        internal var loaderSwf:BulkLoader;

        public function CharacterCreate(_arg_1:*)
        {
            this.main = _arg_1;
            this.loaderSwf = BulkLoader.getLoader("assets");
            this.getBasicData();
        }

        internal function getBasicData():void
        {
            this.loadItem("wpn_01", "back_01", "set_01_0", "hair_01_0", "face_01_0");
            if (this.current_gender == 0)
            {
                this.txt_gender.text = "Male";
            }
            else
            {
                this.txt_gender.text = "Female";
            };
            this.btn_gen_next.addEventListener(MouseEvent.CLICK, this.swapGender);
            this.btn_gen_prev.addEventListener(MouseEvent.CLICK, this.swapGender);
            this.btn_hair_next.addEventListener(MouseEvent.CLICK, this.swapHair);
            this.btn_hair_prev.addEventListener(MouseEvent.CLICK, this.swapHair);
            this.selected_hair_style_color = "0|0";
            this.txt_hair.text = (this.hair_num + " /18");
            this.cPicker1.editable = true;
            this.cPicker1.addEventListener(ColorPickerEvent.CHANGE, this.colorChangeHandler1);
            this.cPicker2.editable = true;
            this.cPicker2.addEventListener(ColorPickerEvent.CHANGE, this.colorChangeHandler2);
            this.btn_create.addEventListener(MouseEvent.CLICK, this.createChar);
            this.btn_close.addEventListener(MouseEvent.CLICK, this.changeCharacter);
            var _local_1:* = 1;
            while (_local_1 < 6)
            {
                this[("btn_element_" + _local_1)].gotoAndStop(1);
                this[("btn_element_" + _local_1)].buttonMode = true;
                this[("btn_element_" + _local_1)].addEventListener(MouseEvent.CLICK, this.selectElement);
                this[("btn_element_" + _local_1)].addEventListener(MouseEvent.MOUSE_OVER, this.over);
                this[("btn_element_" + _local_1)].addEventListener(MouseEvent.MOUSE_OUT, this.out);
                _local_1++;
            };
            _local_1 = null;
            this["btn_element_1"].gotoAndStop(3);
        }

        internal function clearAll():void
        {
            var _local_1:* = 1;
            while (_local_1 < 6)
            {
                this[("btn_element_" + _local_1)].gotoAndStop(1);
                _local_1++;
            };
            _local_1 = null;
        }

        internal function selectElement(_arg_1:MouseEvent):void
        {
            this.clearAll();
            _arg_1.currentTarget.gotoAndStop(3);
            var _local_2:* = _arg_1.currentTarget.name.split("_");
            this.element = _local_2[2];
        }

        internal function over(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        internal function out(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.currentFrame !== 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
        }

        internal function createChar(_arg_1:MouseEvent):void
        {
            if (this.char_name.text.length < 2)
            {
                this.main.giveMessage("Character's name at least have 2 characters");
                return;
            };
            this.main.loading(true);
            var _local_2:Array = [Character.account_id, CUCSG.hash(Character.sessionkey), this.char_name.text, this.current_gender, this.element, this.selected_hair_style_color, this.hair_num];
            _local_2 = [_local_2];
            this.main.amf_manager.service("CharacterService.characterRegister", _local_2, this.regResponse);
        }

        internal function killEverything():void
        {
            this.btn_gen_next.removeEventListener(MouseEvent.CLICK, this.swapGender);
            this.btn_gen_prev.removeEventListener(MouseEvent.CLICK, this.swapGender);
            this.btn_hair_next.removeEventListener(MouseEvent.CLICK, this.swapHair);
            this.btn_hair_prev.removeEventListener(MouseEvent.CLICK, this.swapHair);
            this.btn_create.removeEventListener(MouseEvent.CLICK, this.createChar);
            this.cPicker1.removeEventListener(ColorPickerEvent.CHANGE, this.colorChangeHandler1);
            this.cPicker2.removeEventListener(ColorPickerEvent.CHANGE, this.colorChangeHandler2);
            var _local_1:* = 1;
            while (_local_1 < 6)
            {
                this[("btn_element_" + _local_1)].buttonMode = false;
                this[("btn_element_" + _local_1)].removeEventListener(MouseEvent.CLICK, this.selectElement);
                this[("btn_element_" + _local_1)].removeEventListener(MouseEvent.MOUSE_OVER, this.over);
                this[("btn_element_" + _local_1)].removeEventListener(MouseEvent.MOUSE_OUT, this.out);
                _local_1++;
            };
            _local_1 = null;
            this.current_gender = null;
            this.selected_hair_style_color = null;
            hairMC = null;
            backHairMC = null;
            this.char_bodyArray = null;
            weapon_mc = null;
            back_mc = null;
            set_mc = null;
            hair_mc = null;
            this.hair_num = null;
            this.element = null;
            this.loaderSwf.removeAll();
            this.loaderSwf = null;
        }

        internal function regResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            this.killEverything();
            if (_arg_1.status == 1)
            {
                parent.removeChild(this);
                this.main.loadPanel("Managers.LoginManager");
            }
            else
            {
                this.main.getError(_arg_1.error);
            };
        }

        internal function colorChangeHandler1(_arg_1:ColorPickerEvent):void
        {
            var _local_2:uint = uint(("0x" + _arg_1.target.hexValue));
            this.color_1 = _local_2;
            var _local_3:* = this.selected_hair_style_color.split("|");
            this.selected_hair_style_color = ((this.color_1 + "|") + _local_3[1]);
            this.addHairColor(0);
            try
            {
                this.addHairColor(1);
            }
            catch(e)
            {
            };
        }

        internal function colorChangeHandler2(_arg_1:ColorPickerEvent):void
        {
            var _local_2:uint = uint(("0x" + _arg_1.target.hexValue));
            this.color_2 = _local_2;
            var _local_3:* = this.selected_hair_style_color.split("|");
            this.selected_hair_style_color = ((_local_3[0] + "|") + this.color_2);
            this.addHairColor(0);
            try
            {
                this.addHairColor(1);
            }
            catch(e)
            {
            };
        }

        internal function swapHair(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            while (this.char_mc["back_hair"].numChildren > 0)
            {
                this.char_mc["back_hair"].removeChildAt(0);
            };
            if (_arg_1.currentTarget.name == "btn_hair_next")
            {
                if (this.hair_num < 18)
                {
                    this.hair_num++;
                    this.txt_hair.text = (this.hair_num + " /18");
                }
                else
                {
                    this.hair_num = 1;
                    this.txt_hair.text = (this.hair_num + " /18");
                };
            }
            else
            {
                if (this.hair_num > 1)
                {
                    this.hair_num--;
                    this.txt_hair.text = (this.hair_num + " /18");
                }
                else
                {
                    this.hair_num = 18;
                    this.txt_hair.text = (this.hair_num + " /18");
                };
            };
            if (this.hair_num > 9)
            {
                _local_2 = this.loaderSwf.add((((("items/hair_" + this.hair_num) + "_") + this.current_gender) + ".swf"));
            }
            else
            {
                _local_2 = this.loaderSwf.add((((("items/hair_0" + this.hair_num) + "_") + this.current_gender) + ".swf"));
            };
            _local_2.addEventListener(BulkLoader.COMPLETE, this.onCompleteHair);
            this.loaderSwf.start();
        }

        internal function addHairColor(_arg_1:int):void
        {
            var _local_2:* = undefined;
            var _local_3:ColorTransform = new ColorTransform();
            var _local_4:ColorTransform = new ColorTransform();
            var _local_5:* = (_local_2 = this.selected_hair_style_color).split("|");
            _local_3.color = _local_5[0];
            _local_4.color = _local_5[1];
            this.color_1 = _local_5[0];
            this.color_2 = _local_5[1];
            if (_arg_1 == 0)
            {
                hairMC.hair_color_2.transform.colorTransform = _local_4;
                hairMC.hair_color_1.transform.colorTransform = _local_3;
            }
            else
            {
                backHairMC.hair_color_2.transform.colorTransform = _local_4;
                backHairMC.hair_color_1.transform.colorTransform = _local_3;
            };
        }

        internal function swapGender(_arg_1:MouseEvent):void
        {
            this.hair_num = 1;
            this.txt_hair.text = (this.hair_num + " /18");
            while (this.char_mc["back_hair"].numChildren > 0)
            {
                this.char_mc["back_hair"].removeChildAt(0);
            };
            if (this.current_gender == 0)
            {
                this.loadItem("wpn_01", "back_01", "set_01_1", "hair_01_1", "face_01_1");
                this.current_gender = 1;
                this.txt_gender.text = "Female";
            }
            else
            {
                this.loadItem("wpn_01", "back_01", "set_01_0", "hair_01_0", "face_01_0");
                this.current_gender = 0;
                this.txt_gender.text = "Male";
            };
        }

        public function loadItem(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:String):void
        {
            var _local_6:* = this.loaderSwf.add((("items/" + _arg_1) + ".swf"));
            var _local_7:* = this.loaderSwf.add((("items/" + _arg_2) + ".swf"));
            var _local_8:* = this.loaderSwf.add((("items/" + _arg_3) + ".swf"));
            var _local_9:* = this.loaderSwf.add((("items/" + _arg_4) + ".swf"));
            var _local_10:* = this.loaderSwf.add((("items/" + _arg_5) + ".swf"));
            _local_6.addEventListener(BulkLoader.COMPLETE, this.onCompleteWpn);
            _local_7.addEventListener(BulkLoader.COMPLETE, this.onCompleteWpn);
            _local_8.addEventListener(BulkLoader.COMPLETE, this.onCompleteSet);
            _local_9.addEventListener(BulkLoader.COMPLETE, this.onCompleteHair);
            _local_10.addEventListener(BulkLoader.COMPLETE, this.onCompleteFace);
            this.loaderSwf.start();
        }

        public function onCompleteWpn(param1:*):void
        {
            var ClassDefinition:Class;
            var butn:MovieClip;
            var e:* = param1;
            try
            {
                butn = e.target.content["weapon"];
                this.removeChildsFromMovieClip(this.char_mc["weapon"]);
                this.char_mc["weapon"].addChild(butn);
                weapon_mc = butn;
            }
            catch(e)
            {
            };
        }

        public function onCompleteBack(param1:*):void
        {
            var ClassDefinition:Class;
            var butn:MovieClip;
            var e:* = param1;
            try
            {
                butn = e.target.content["back_item"];
                this.removeChildsFromMovieClip(this.char_mc["back"]);
                this.char_mc["back"].addChild(butn);
                back_mc = butn;
            }
            catch(e)
            {
            };
        }

        public function onCompleteFace(param1:*):void
        {
            var ClassDefinition:Class;
            var butn:MovieClip;
            var e:* = param1;
            try
            {
                butn = e.target.content["face"];
                if (this.char_mc["head"]["face"].numChildren > 0)
                {
                    this.removeChildsFromMovieClip(this.char_mc["head"]["face"]);
                };
                this.char_mc["head"]["face"].addChild(butn);
            }
            catch(e)
            {
            };
        }

        public function onCompleteSet(param1:*):void
        {
            var classGet1:Class;
            var classGetMC1:MovieClip;
            var classGet:Class;
            var classGetMC:MovieClip;
            var e:* = param1;
            var loc1:* = 0;
            set_mc = [];
            while (loc1 < this.char_bodyArray.length)
            {
                try
                {
                    classGetMC1 = e.target.content[this.char_bodyArray[loc1]];
                    this.removeChildsFromMovieClip(this.char_mc[this.char_bodyArray[loc1]]);
                    this.char_mc[this.char_bodyArray[loc1]].addChild(classGetMC1);
                    set_mc.push(classGetMC1);
                    loc1++;
                }
                catch(e:Error)
                {
                    loc1++;
                };
            };
            try
            {
                classGetMC = e.target.content["skirt"];
                this.removeChildsFromMovieClip(this.char_mc["skirt"]);
                this.char_mc["skirt"].addChild(classGetMC);
                set_mc.push(classGetMC);
            }
            catch(e:Error)
            {
            };
        }

        public function onCompleteHair(param1:*):*
        {
            var back_hair:Class;
            var e:* = param1;
            hairMC = e.target.content["hair"];
            hair_mc = [];
            while (this.char_mc["head"]["hair"].numChildren > 0)
            {
                this.char_mc["head"]["hair"].removeChildAt(0);
            };
            this.char_mc["head"]["hair"].addChild(hairMC);
            hair_mc.push(hairMC);
            this.addHairColor(0);
            try
            {
                backHairMC = e.target.content["back_hair"];
                while (this.char_mc["back_hair"].numChildren > 0)
                {
                    this.char_mc["back_hair"].removeChildAt(0);
                };
                this.char_mc["back_hair"].addChild(backHairMC);
                hair_mc.push(backHairMC);
                this.addHairColor(1);
            }
            catch(e:Error)
            {
                Log.error(this, "hair model error ", e);
            };
        }

        internal function changeCharacter(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.CharacterSelect");
            this.killEverything();
        }

        public function removeChildsFromMovieClip(_arg_1:*):*
        {
            while (_arg_1.numChildren > 0)
            {
                _arg_1.removeChildAt(0);
            };
        }


    }
}//package Panels

