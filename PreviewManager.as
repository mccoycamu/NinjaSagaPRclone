// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Managers.PreviewManager

package Managers
{
    import flash.display.MovieClip;
    import flash.geom.Point;
    import Storage.Character;
    import gs.TweenLite;
    import com.utils.GF;

    public class PreviewManager 
    {

        public var main:*;
        public var preview_mc:MovieClip;
        public var preview_info:Object;
        public var preview_type:String;
        private var skill_attack_hit_position:String;
        private var outfits:Array = [];
        private var outfit_list:Array = [];
        private var startPoint:Point;
        private var targetPoint:Point;
        private var point:Point;

        public function PreviewManager(_arg_1:*, _arg_2:MovieClip, _arg_3:Object, _arg_4:Array=null)
        {
            this.main = _arg_1;
            this.preview_mc = _arg_2;
            this.preview_info = _arg_3;
            this.outfit_list = ((_arg_4 != null) ? _arg_4 : [Character.character_weapon, Character.character_back_item, Character.character_set, Character.character_hair, Character.character_face, Character.character_color_hair, Character.character_color_skin]);
            this.init();
        }

        private function init():void
        {
            this.preview_mc.scaleX = -0.7;
            this.preview_mc.scaleY = 0.7;
            this.skill_attack_hit_position = "range_3";
            this.preview_type = ((this.preview_info.hasOwnProperty("skill_id")) ? "skill" : "entity");
            if (this.preview_type == "skill")
            {
                this.fillOutfit();
            };
            this.setFrameScript();
        }

        private function setFrameScript():void
        {
            var i:int;
            var frame:int;
            var shadowName:String;
            var effect:Object;
            var effectName:String;
            var effectType:String;
            var finishFrame:int;
            if (this.preview_type == "skill")
            {
                this.preview_mc.addFrameScript(0, this.stopAnimation);
                this.preview_mc.addFrameScript((this.preview_mc.totalFrames - 1), this.handleEndAnimation);
                i = 0;
                while (i < this.preview_info.anims.hit.length)
                {
                    this.preview_mc.addFrameScript(this.preview_info.anims.hit[i], this.handleHitAnimation);
                    i = (i + 1);
                };
                if (this.preview_info.anims.hasOwnProperty("fullscreen"))
                {
                    this.preview_mc.addFrameScript(this.preview_info.anims.fullscreen.add, this.addFullScreen);
                    this.preview_mc.addFrameScript(this.preview_info.anims.fullscreen.remove, this.removeFullScreen);
                };
                if (this.preview_info.anims.hasOwnProperty("splash"))
                {
                    this.preview_mc.addFrameScript(this.preview_info.anims.splash.add, this.handleGenderSplash);
                };
                if (this.preview_info.anims.hasOwnProperty("bunshin"))
                {
                    var createBunshinFrameScript:Function = function (shadowName:String):Function
                    {
                        return (function ():void
                        {
                            handleBunshin(preview_mc[shadowName]);
                        });
                    };
                    i = 0;
                    while (i < this.preview_info.anims.bunshin.length)
                    {
                        frame = this.preview_info.anims.bunshin[i];
                        shadowName = ("shandow" + String((i + 1)));
                        this.preview_mc.addFrameScript(frame, createBunshinFrameScript(shadowName));
                        i = (i + 1);
                    };
                };
                if (this.preview_info.anims.hasOwnProperty("effects"))
                {
                    var createFrameScript:Function = function (effectName:String, effectType:String):Function
                    {
                        return (function ():void
                        {
                            handleFlyingObject(preview_mc[effectName], effectType);
                        });
                    };
                    i = 0;
                    while (i < this.preview_info.anims.effects.length)
                    {
                        effect = this.preview_info.anims.effects[i];
                        frame = effect.add;
                        effectName = effect.name;
                        effectType = effect.type;
                        this.preview_mc.addFrameScript(frame, createFrameScript(effectName, effectType));
                        i = (i + 1);
                    };
                };
            }
            else
            {
                i = 0;
                while (i < this.preview_info.attacks.length)
                {
                    finishFrame = (NinjaSage.getLabelFrames(this.preview_mc, this.preview_info.attacks[i].animation).end - 1);
                    this.preview_mc.addFrameScript(finishFrame, this.standByFrameEnd);
                    if (this.preview_info.attacks[i].anims.hasOwnProperty("fullscreen"))
                    {
                        this.preview_mc.addFrameScript(this.preview_info.attacks[i].anims.fullscreen.add, this.addFullScreen);
                        this.preview_mc.addFrameScript(this.preview_info.attacks[i].anims.fullscreen.remove, this.removeFullScreen);
                    };
                    i = (i + 1);
                };
                this.preview_mc.addFrameScript((NinjaSage.getLabelFrames(this.preview_mc, "standby").end - 1), this.standByFrameEnd);
                this.preview_mc.addFrameScript((NinjaSage.getLabelFrames(this.preview_mc, "dodge").end - 1), this.standByFrameEnd);
                this.preview_mc.addFrameScript((NinjaSage.getLabelFrames(this.preview_mc, "hit").end - 1), this.standByFrameEnd);
                this.preview_mc.addFrameScript((NinjaSage.getLabelFrames(this.preview_mc, "dead").end - 1), this.standByFrameEnd);
                this.preview_mc.gotoAndPlay("standby");
            };
            this.preview_mc.gotoAndStop(1);
        }

        private function clearFrameScript():void
        {
            var _local_1:int;
            var _local_2:int;
            if (this.preview_type == "skill")
            {
                this.preview_mc.addFrameScript(0, null);
                this.preview_mc.addFrameScript(1, null);
                this.preview_mc.addFrameScript((this.preview_mc.totalFrames - 1), null);
                _local_1 = 0;
                while (_local_1 < this.preview_info.anims.hit.length)
                {
                    this.preview_mc.addFrameScript(this.preview_info.anims.hit[_local_1], null);
                    _local_1++;
                };
                if (this.preview_info.anims.hasOwnProperty("fullscreen"))
                {
                    this.preview_mc.addFrameScript(this.preview_info.anims.fullscreen.add, null);
                    this.preview_mc.addFrameScript(this.preview_info.anims.fullscreen.remove, null);
                };
                if (this.preview_info.anims.hasOwnProperty("splash"))
                {
                    this.preview_mc.addFrameScript(this.preview_info.anims.splash.add, null);
                };
                if (this.preview_info.anims.hasOwnProperty("bunshin"))
                {
                    _local_1 = 0;
                    while (_local_1 < this.preview_info.anims.bunshin.length)
                    {
                        this.preview_mc.addFrameScript(this.preview_info.anims.bunshin[_local_1], null);
                        _local_1++;
                    };
                };
                if (this.preview_info.anims.hasOwnProperty("effects"))
                {
                    _local_1 = 0;
                    while (_local_1 < this.preview_info.anims.effects.length)
                    {
                        this.preview_mc.addFrameScript(this.preview_info.anims.effects[_local_1].add, null);
                        _local_1++;
                    };
                };
            }
            else
            {
                _local_1 = 0;
                while (_local_1 < this.preview_info.attacks.length)
                {
                    _local_2 = (NinjaSage.getLabelFrames(this.preview_mc, this.preview_info.attacks[_local_1].animation).end - 1);
                    this.preview_mc.addFrameScript(_local_2, null);
                    if (this.preview_info.attacks[_local_1].anims.hasOwnProperty("fullscreen"))
                    {
                        this.preview_mc.addFrameScript(this.preview_info.attacks[_local_1].anims.fullscreen.add, null);
                        this.preview_mc.addFrameScript(this.preview_info.attacks[_local_1].anims.fullscreen.remove, null);
                    };
                    _local_1++;
                };
                this.preview_mc.addFrameScript((NinjaSage.getLabelFrames(this.preview_mc, "standby").end - 1), null);
                this.preview_mc.addFrameScript((NinjaSage.getLabelFrames(this.preview_mc, "dodge").end - 1), null);
                this.preview_mc.addFrameScript((NinjaSage.getLabelFrames(this.preview_mc, "hit").end - 1), null);
                this.preview_mc.addFrameScript((NinjaSage.getLabelFrames(this.preview_mc, "dead").end - 1), null);
            };
        }

        public function stopAnimation():void
        {
            this.preview_mc.stop();
        }

        public function standByFrameEnd():void
        {
            this.preview_mc.x = 0;
            this.preview_mc.y = 0;
            this.preview_mc.gotoAndPlay("standby");
        }

        public function handleHitAnimation():void
        {
        }

        public function handleEndAnimation():void
        {
            this.preview_mc.gotoAndStop(1);
            this.preview_mc.x = 0;
            this.preview_mc.y = 0;
        }

        public function handleBunshin(_arg_1:MovieClip):void
        {
            this.fillOutfit(_arg_1);
        }

        public function handleFlyingObject(_arg_1:MovieClip, _arg_2:String):void
        {
            this.startPoint = null;
            this.targetPoint = null;
            this.point = null;
            var _local_3:* = 1200;
            var _local_4:* = 800;
            var _local_5:Point = new Point(_local_3, _local_4);
            if ((_arg_2 == "target"))
            {
                this.targetPoint = _local_5;
            }
            else
            {
                this.point = _local_5;
            };
            this.playFlyingObject(_arg_1);
        }

        public function fillOutfit(_arg_1:MovieClip=null):void
        {
            if (Character.is_stickman)
            {
                return;
            };
            var _local_2:OutfitManager = new OutfitManager();
            var _local_3:MovieClip = ((_arg_1 == null) ? this.preview_mc : _arg_1);
            var _local_4:String = this.outfit_list[0];
            var _local_5:String = this.outfit_list[1];
            var _local_6:String = this.outfit_list[2];
            var _local_7:String = this.outfit_list[3];
            var _local_8:String = this.outfit_list[4];
            var _local_9:String = this.outfit_list[5];
            var _local_10:String = this.outfit_list[6];
            _local_2.fillOutfit(_local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _local_9, _local_10);
            this.outfits.push(_local_2);
        }

        public function addFullScreen():void
        {
            var _local_1:int = (((this.preview_info.anims.hasOwnProperty("fullscreen")) && ("scale" in this.preview_info.anims.fullscreen)) ? this.preview_info.anims.fullscreen.scale : 2);
            this.preview_mc.fullScreenEffect.x = 0;
            this.preview_mc.fullScreenEffect.y = 0;
            this.preview_mc.fullScreenEffect.scaleX = _local_1;
            this.preview_mc.fullScreenEffect.scaleY = _local_1;
            this.main.loader.addChild(this.preview_mc.fullScreenEffect);
        }

        public function removeFullScreen():void
        {
            this.main.loader.removeChild(this.preview_mc.fullScreenEffect);
        }

        public function handleGenderSplash():void
        {
            this.preview_mc.splash.splash_0.visible = false;
            this.preview_mc.splash.splash_1.visible = false;
            this.preview_mc.splash[("splash_" + Character.character_gender)].visible = true;
        }

        public function playFlyingObject(_arg_1:MovieClip):void
        {
            var _local_2:Point;
            var _local_3:Point;
            var _local_4:Point;
            if (this.startPoint != null)
            {
                _local_2 = this.preview_mc.globalToLocal(this.startPoint);
                _arg_1.x = _local_2.x;
                _arg_1.y = _local_2.y;
            };
            if (this.targetPoint != null)
            {
                _local_3 = this.preview_mc.globalToLocal(this.targetPoint);
                _arg_1.x = _local_3.x;
                _arg_1.y = _local_3.y;
            };
            if (this.point != null)
            {
                _local_4 = this.preview_mc.globalToLocal(this.point);
                _arg_1.x = 0;
                _arg_1.y = 0;
                TweenLite.to(_arg_1, (_arg_1.totalFrames / 40), {
                    "x":_local_4.x,
                    "y":_local_4.y
                });
            };
            _arg_1.gotoAndPlay(2);
        }

        public function destroy():void
        {
            var _local_1:*;
            this.clearFrameScript();
            for each (_local_1 in ["effectMc", "fullScreenEffect", "back", "back_hair", "head", "hitAreaMc", "left_hand", "left_lower_arm", "left_lower_leg", "left_shoe", "left_upper_arm", "left_upper_leg", "lower_body", "right_hand", "right_lower_arm", "right_lower_leg", "right_shoe", "right_upper_arm", "right_upper_leg", "shadow", "skirt", "throw02Mc", "upper_body", "weapon"])
            {
                if (this.preview_mc.hasOwnProperty(_local_1))
                {
                    GF.removeAllChild(this.preview_mc[_local_1]);
                };
            };
            GF.removeAllChild(this.preview_mc);
            GF.destroyArray(this.outfits);
            this.outfits = null;
            this.outfit_list = null;
            this.preview_type = null;
            this.preview_mc = null;
            this.preview_info = null;
            this.startPoint = null;
            this.targetPoint = null;
            this.point = null;
            this.main = null;
        }


    }
}//package Managers

