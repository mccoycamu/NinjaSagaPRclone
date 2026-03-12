// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.AdvancedAcademy

package Panels
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;
    import com.abrahamyan.liquid.ToolTip;
    import id.ninjasage.EventHandler;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.NinjaLoader;
    import com.utils.GF;
    import Managers.NinjaSage;
    import Storage.SkillLibrary;

    public class AdvancedAcademy extends MovieClip 
    {

        public var btn_close:SimpleButton;
        public var buyGold:SimpleButton;
        public var buyTokens:SimpleButton;
        public var costBar:MovieClip;
        public var curSkill:MovieClip;
        public var element_mc0:MovieClip;
        public var element_mc1:MovieClip;
        public var element_mc2:MovieClip;
        public var element_mc3:MovieClip;
        public var element_mc4:MovieClip;
        public var iconType:MovieClip;
        public var skill_0:MovieClip;
        public var skill_1:MovieClip;
        public var skill_10:MovieClip;
        public var skill_11:MovieClip;
        public var skill_2:MovieClip;
        public var skill_3:MovieClip;
        public var skill_4:MovieClip;
        public var skill_5:MovieClip;
        public var skill_6:MovieClip;
        public var skill_7:MovieClip;
        public var skill_8:MovieClip;
        public var skill_9:MovieClip;
        public var txt_gold:TextField;
        public var txt_token:TextField;
        public var upIcon:MovieClip;
        public var upgrSkill:MovieClip;
        private var main:*;
        private var tooltip:ToolTip;

        public var eventHandler:* = new EventHandler();
        private var skills:Array = [];

        public function AdvancedAcademy(_arg_1:*)
        {
            this.main = _arg_1;
            this.tooltip = ToolTip.getInstance();
            this.displayCharacterStats();
            this.addButtonListeners();
            this.handleElementButtons();
            this.init();
            this.addSkills();
        }

        private function displayCharacterStats():*
        {
            this["txt_gold"].text = String(Character.character_gold);
            this["txt_token"].text = String(Character.account_tokens);
        }

        private function addButtonListeners():*
        {
            this.eventHandler.addListener(this["btn_close"], MouseEvent.CLICK, this.onClose);
            this.eventHandler.addListener(this["buyGold"], MouseEvent.CLICK, this.openRecharge);
            this.eventHandler.addListener(this["buyTokens"], MouseEvent.CLICK, this.openRecharge);
        }

        private function openRecharge(_arg_1:MouseEvent):*
        {
            this.main.loadPanel("Panels.Recharge");
        }

        private function handleElementButtons():*
        {
            this["element_mc0"].visible = false;
            this["element_mc1"].visible = false;
            this["element_mc2"].visible = false;
            if (int(Character.character_element_1) > 0)
            {
                this["element_mc0"].gotoAndStop(Character.character_element_1);
                this["element_mc0"].visible = true;
                this["element_mc0"]["element"].gotoAndStop(3);
                this["element_mc0"].buttonMode = true;
                this.eventHandler.addListener(this["element_mc0"], MouseEvent.CLICK, this.onSelectElement);
                this.eventHandler.addListener(this["element_mc0"]["element"], MouseEvent.MOUSE_OVER, this.over);
                this.eventHandler.addListener(this["element_mc0"]["element"], MouseEvent.MOUSE_OUT, this.out);
            };
            if (int(Character.character_element_2) > 0)
            {
                this["element_mc1"].gotoAndStop(Character.character_element_2);
                this["element_mc1"].visible = true;
                this["element_mc1"]["element"].gotoAndStop(1);
                this["element_mc1"].buttonMode = true;
                this.eventHandler.addListener(this["element_mc1"], MouseEvent.CLICK, this.onSelectElement);
                this.eventHandler.addListener(this["element_mc1"]["element"], MouseEvent.MOUSE_OVER, this.over);
                this.eventHandler.addListener(this["element_mc1"]["element"], MouseEvent.MOUSE_OUT, this.out);
            };
            if (int(Character.character_element_3) > 0)
            {
                this["element_mc2"].gotoAndStop(Character.character_element_3);
                this["element_mc2"].visible = true;
                this["element_mc2"]["element"].gotoAndStop(1);
                this["element_mc2"].buttonMode = true;
                this.eventHandler.addListener(this["element_mc2"], MouseEvent.CLICK, this.onSelectElement);
                this.eventHandler.addListener(this["element_mc2"]["element"], MouseEvent.MOUSE_OVER, this.over);
                this.eventHandler.addListener(this["element_mc2"]["element"], MouseEvent.MOUSE_OUT, this.out);
            };
            this["element_mc3"].visible = true;
            this["element_mc3"].gotoAndStop(1);
            this["element_mc3"].buttonMode = true;
            this.eventHandler.addListener(this["element_mc3"], MouseEvent.CLICK, this.onSelectElement);
            this.eventHandler.addListener(this["element_mc3"], MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.addListener(this["element_mc3"], MouseEvent.MOUSE_OUT, this.out);
            this["element_mc4"].visible = true;
            this["element_mc4"].gotoAndStop(1);
            this["element_mc4"].buttonMode = true;
            this.eventHandler.addListener(this["element_mc4"], MouseEvent.CLICK, this.onSelectElement);
            this.eventHandler.addListener(this["element_mc4"], MouseEvent.MOUSE_OVER, this.over);
            this.eventHandler.addListener(this["element_mc4"], MouseEvent.MOUSE_OUT, this.out);
        }

        private function over(_arg_1:MouseEvent):*
        {
            if (_arg_1.currentTarget.currentFrame != 3)
            {
                _arg_1.currentTarget.gotoAndStop(2);
            };
        }

        private function out(_arg_1:MouseEvent):*
        {
            if (_arg_1.currentTarget.currentFrame != 3)
            {
                _arg_1.currentTarget.gotoAndStop(1);
            };
        }

        private function addSkills():*
        {
            this.hideSkills();
            this.skills["wind"] = [];
            this.skills["fire"] = [];
            this.skills["thunder"] = [];
            this.skills["earth"] = [];
            this.skills["water"] = [];
            this.skills["taijutsu"] = [];
            this.skills["genjutsu"] = [];
            this.skills["wind"]["evasion"] = ["skill_39", "skill_271", "skill_272", "skill_273", "skill_274", "skill_275"];
            this.skills["wind"]["blade_of_wind"] = ["skill_85", "skill_276", "skill_277", "skill_278", "skill_279"];
            this.skills["wind"]["wind_peace"] = ["skill_161", "skill_280", "skill_281", "skill_282"];
            this.skills["wind"]["dance_of_fujin"] = ["skill_151", "skill_283", "skill_284"];
            this.skills["wind"]["breakthrough"] = ["skill_285", "skill_286"];
            this.skills["fire"]["fire_power"] = ["skill_36", "skill_220", "skill_221", "skill_222", "skill_223", "skill_224"];
            this.skills["fire"]["hell_fire"] = ["skill_86", "skill_225", "skill_226", "skill_227", "skill_228"];
            this.skills["fire"]["fire_energy"] = ["skill_162", "skill_229", "skill_230", "skill_231"];
            this.skills["fire"]["rage"] = ["skill_152", "skill_232", "skill_233"];
            this.skills["fire"]["phoenix"] = ["skill_234", "skill_235"];
            this.skills["thunder"]["charge"] = ["skill_35", "skill_288", "skill_289", "skill_290", "skill_291", "skill_292"];
            this.skills["thunder"]["flash"] = ["skill_87", "skill_293", "skill_294", "skill_295", "skill_296"];
            this.skills["thunder"]["bundle"] = ["skill_163", "skill_297", "skill_298", "skill_299"];
            this.skills["thunder"]["armor"] = ["skill_153", "skill_300", "skill_301"];
            this.skills["thunder"]["boost"] = ["skill_302", "skill_303"];
            this.skills["earth"]["golem"] = ["skill_59", "skill_237", "skill_238", "skill_239", "skill_240", "skill_241"];
            this.skills["earth"]["absorb"] = ["skill_88", "skill_242", "skill_243", "skill_244", "skill_245"];
            this.skills["earth"]["rocks"] = ["skill_164", "skill_246", "skill_247", "skill_248"];
            this.skills["earth"]["embrace"] = ["skill_154", "skill_249", "skill_250"];
            this.skills["earth"]["gaunt"] = ["skill_251", "skill_252"];
            this.skills["water"]["renewal"] = ["skill_60", "skill_254", "skill_255", "skill_256", "skill_257", "skill_258"];
            this.skills["water"]["bundle"] = ["skill_89", "skill_259", "skill_260", "skill_261", "skill_262"];
            this.skills["water"]["prison"] = ["skill_165", "skill_264", "skill_263", "skill_265"];
            this.skills["water"]["shield"] = ["skill_155", "skill_266", "skill_267"];
            this.skills["water"]["shark"] = ["skill_268", "skill_269"];
            this.skills["genjutsu"]["sealing"] = ["skill_706", "skill_726"];
            this.showSkills(int(Character.character_element_1));
        }

        private function hideSkills():*
        {
            var _local_1:int;
            while (_local_1 < 12)
            {
                this[("skill_" + _local_1.toString())].visible = false;
                this[("skill_" + _local_1.toString())].buttonMode = true;
                _local_1++;
            };
        }

        private function showSkills(_arg_1:int):*
        {
            var _local_2:int;
            var _local_3:Array;
            var _local_4:String;
            var _local_5:String;
            var _local_6:int;
            var _local_7:int;
            var _local_8:MovieClip;
            this["iconType"].gotoAndStop(_arg_1);
            var _local_9:String = this.getSkillElementType(_arg_1);
            var _local_10:Array = this.getElementTypeSkills(_arg_1);
            var _local_11:NinjaLoader = new NinjaLoader(this);
            var _local_12:int;
            while (_local_12 < _local_10.length)
            {
                _local_2 = -1;
                _local_4 = (_local_3 = this.skills[_local_9][_local_10[_local_12]])[0];
                _local_5 = _local_3[0];
                _local_6 = _local_3.length;
                _local_7 = 0;
                while (_local_7 < _local_6)
                {
                    if (Character.isItemOwned(_local_3[_local_7]))
                    {
                        _local_2 = _local_7;
                        _local_4 = _local_3[_local_7];
                        _local_5 = _local_3[(_local_7 + 1)];
                    };
                    _local_7++;
                };
                (_local_8 = this[("skill_" + _local_12.toString())])["maxTxt"].text = "";
                _local_8["lvTxt"].text = "";
                _local_8["percentBar"].scaleX = 1;
                GF.removeAllChild(this[("skill_" + _local_12)].iconMC.iconHolder);
                NinjaSage.loadIconSWF("skills", _local_4, this[("skill_" + _local_12)].iconMC.iconHolder, "icon");
                if (_local_2 >= 0)
                {
                    _local_8["percentBar"].visible = true;
                    this.main.enableButton(_local_8);
                    _local_8.visible = true;
                    if ((_local_2 + 1) == _local_6)
                    {
                        _local_8["maxTxt"].text = "MAX.";
                        _local_8.current_skill_id = _local_4;
                        this.eventHandler.removeListener(this[("skill_" + _local_12)], MouseEvent.CLICK, this.onUpgradeSkill);
                    }
                    else
                    {
                        _local_8["percentBar"].scaleX = ((_local_2 + 1) / _local_6);
                        _local_8["lvTxt"].text = (((_local_2 + 1) + " / ") + _local_6);
                        _local_8.skill_element_type = _local_9;
                        _local_8.element_skills = _local_10[_local_12];
                        _local_8.skill_element = _arg_1;
                        _local_8.current_level = _local_2;
                        _local_8.current_skill_id = _local_4;
                        _local_8.next_skill_id = _local_5;
                        this.eventHandler.addListener(this[("skill_" + _local_12)], MouseEvent.CLICK, this.onUpgradeSkill);
                    };
                }
                else
                {
                    _local_8.removeEventListener(MouseEvent.CLICK, this.onUpgradeSkill);
                    _local_8["percentBar"].visible = false;
                    _local_8["maxTxt"].text = "LEARN.";
                    _local_8.current_skill_id = _local_4;
                    _local_8.next_skill_id = _local_5;
                    this.main.disableButton(_local_8);
                };
                this.eventHandler.addListener(_local_8, MouseEvent.ROLL_OVER, this.toolTiponOver);
                this.eventHandler.addListener(_local_8, MouseEvent.ROLL_OUT, this.toolTiponOut);
                _local_12++;
            };
        }

        private function getSkillElementType(_arg_1:int):*
        {
            switch (_arg_1)
            {
                case 1:
                    return ("wind");
                case 2:
                    return ("fire");
                case 3:
                    return ("thunder");
                case 4:
                    return ("earth");
                case 5:
                    return ("water");
                case 6:
                    return ("taijutsu");
                case 7:
                    return ("genjutsu");
                default:
                    return;
            };
        }

        private function getElementTypeSkills(_arg_1:int):*
        {
            switch (_arg_1)
            {
                case 1:
                    return (["evasion", "blade_of_wind", "wind_peace", "dance_of_fujin", "breakthrough"]);
                case 2:
                    return (["fire_power", "hell_fire", "fire_energy", "rage", "phoenix"]);
                case 3:
                    return (["charge", "flash", "bundle", "armor", "boost"]);
                case 4:
                    return (["golem", "absorb", "rocks", "embrace", "gaunt"]);
                case 5:
                    return (["renewal", "bundle", "prison", "shield", "shark"]);
                case 6:
                    return ([]);
                case 7:
                    return (["sealing"]);
                default:
                    return;
            };
        }

        private function init(_arg_1:Boolean=false):*
        {
            this["curSkill"].visible = _arg_1;
            this["upgrSkill"].visible = _arg_1;
            this["upIcon"].visible = _arg_1;
            this["costBar"].visible = _arg_1;
        }

        private function onSelectElement(_arg_1:MouseEvent):*
        {
            this.hideSkills();
            this.init();
            this["element_mc0"]["element"].gotoAndStop(1);
            this["element_mc1"]["element"].gotoAndStop(1);
            this["element_mc2"]["element"].gotoAndStop(1);
            this["element_mc3"].gotoAndStop(1);
            this["element_mc4"].gotoAndStop(1);
            var _local_2:int = int(_arg_1.currentTarget.name.replace("element_mc", ""));
            if (_local_2 == 0)
            {
                this["element_mc0"]["element"].gotoAndStop(3);
                this.showSkills(int(Character.character_element_1));
            }
            else
            {
                if (_local_2 == 1)
                {
                    this["element_mc1"]["element"].gotoAndStop(3);
                    this.showSkills(int(Character.character_element_2));
                }
                else
                {
                    if (_local_2 == 2)
                    {
                        this["element_mc2"]["element"].gotoAndStop(3);
                        this.showSkills(int(Character.character_element_3));
                    }
                    else
                    {
                        if (_local_2 == 3)
                        {
                            this["element_mc3"].gotoAndStop(3);
                            this.showSkills(int(6));
                        }
                        else
                        {
                            this["element_mc4"].gotoAndStop(3);
                            this.showSkills(int(7));
                        };
                    };
                };
            };
        }

        private function onUpgradeSkill(_arg_1:MouseEvent):*
        {
            var _local_2:NinjaLoader = new NinjaLoader(this);
            var _local_3:* = _arg_1.currentTarget;
            GF.removeAllChild(this["curSkill"]["iconMC0"]["iconHolder"]);
            GF.removeAllChild(this["upgrSkill"]["iconMC0"]["iconHolder"]);
            GF.removeAllChild(this["costBar"]["iconMC0"]["iconHolder"]);
            var _local_4:* = SkillLibrary.getSkillInfo(_local_3.current_skill_id);
            this["curSkill"]["iconType"].gotoAndStop(_local_3.skill_element);
            this["curSkill"]["nameTxt"].text = _local_4.skill_name;
            this["curSkill"]["levelTxt"].text = _local_4.skill_level;
            this["curSkill"]["cpTxt"].text = _local_4.skill_cp_cost;
            this["curSkill"]["damageTxt"].text = _local_4.skill_damage;
            this["curSkill"]["cooldownTxt"].text = _local_4.skill_cooldown;
            this["curSkill"]["descriptionTxt"].text = _local_4.skill_description;
            NinjaSage.loadIconSWF("skills", _local_3.current_skill_id, this["curSkill"].iconMC0.iconHolder, "icon");
            _local_4 = SkillLibrary.getSkillInfo(_local_3.next_skill_id);
            this["upgrSkill"]["iconType"].gotoAndStop(_local_3.skill_element);
            this["upgrSkill"]["nameTxt"].text = _local_4.skill_name;
            this["upgrSkill"]["levelTxt"].text = _local_4.skill_level;
            this["upgrSkill"]["cpTxt"].text = _local_4.skill_cp_cost;
            this["upgrSkill"]["damageTxt"].text = _local_4.skill_damage;
            this["upgrSkill"]["cooldownTxt"].text = _local_4.skill_cooldown;
            this["upgrSkill"]["descriptionTxt"].text = _local_4.skill_description;
            NinjaSage.loadIconSWF("skills", _local_3.next_skill_id, this["upgrSkill"].iconMC0.iconHolder, "icon");
            NinjaSage.loadIconSWF("skills", _local_3.current_skill_id, this["costBar"].iconMC0.iconHolder, "icon");
            this["costBar"]["levelTxt"].text = _local_4.skill_level;
            this["costBar"]["tokenTxt"].text = _local_4.skill_price_tokens;
            this["costBar"]["btn_upgrade"].visible = false;
            if (((int(Character.character_lvl) >= int(_local_4.skill_level)) && (Character.account_tokens >= int(_local_4.skill_price_tokens))))
            {
                this.eventHandler.addListener(this["costBar"]["btn_upgrade"], MouseEvent.CLICK, this.onUpgradeSkillAmf);
                this["costBar"].current_skill_id = _local_3.current_skill_id;
                this["costBar"].next_skill_id = _local_3.next_skill_id;
                this["costBar"].skill_element_type = _local_3.skill_element_type;
                this["costBar"].element_skills = _local_3.element_skills;
                this["costBar"]["btn_upgrade"].visible = true;
            };
            this.init(true);
        }

        private function onUpgradeSkillAmf(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.parent;
            this.main.loading(true);
            this.main.amf_manager.service("AdvanceAcademy.upgradeSkill", [Character.char_id, Character.sessionkey, _local_2.next_skill_id], this.onUpgradeResponse);
        }

        private function onUpgradeResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status > 1)
            {
                this.main.showMessage(_arg_1.result);
                return;
            };
            var _local_2:* = this["costBar"];
            Character.account_tokens = _arg_1.account_tokens;
            Character.character_equipped_skills = _arg_1.character_skills;
            Character.character_skill_set = _arg_1.character_set_skills;
            Character.updateSkills(_local_2.current_skill_id, false);
            Character.updateSkills(_local_2.next_skill_id);
            this.displayCharacterStats();
            this.main.showMessage(_arg_1.result);
            this.hideSkills();
            this.init();
            if (this["element_mc0"]["element"].currentFrame == 3)
            {
                this.showSkills(int(Character.character_element_1));
            }
            else
            {
                if (this["element_mc1"]["element"].currentFrame == 3)
                {
                    this.showSkills(int(Character.character_element_2));
                }
                else
                {
                    if (this["element_mc2"]["element"].currentFrame == 3)
                    {
                        this.showSkills(int(Character.character_element_3));
                    }
                    else
                    {
                        if (this["element_mc3"].currentFrame == 3)
                        {
                            this.showSkills(6);
                        }
                        else
                        {
                            this.showSkills(7);
                        };
                    };
                };
            };
        }

        private function toolTiponOver(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget;
            var _local_3:* = SkillLibrary.getSkillInfo(_local_2.current_skill_id);
            var _local_4:* = (((((((((((("" + _local_3.skill_name) + "\n(Skill)\n") + "\nLevel ") + _local_3.skill_level) + "\nDamage: ") + _local_3.skill_damage) + "\nCP Cost: ") + _local_3.skill_cp_cost) + "\nCooldown: ") + _local_3.skill_cooldown) + "\n\n") + _local_3.skill_description);
            stage.addChild(this.tooltip);
            this.tooltip.followMouse = true;
            this.tooltip.fixedWidth = 350;
            this.tooltip.multiLine = true;
            this.tooltip.show(_local_4);
        }

        private function toolTiponOut(_arg_1:MouseEvent):*
        {
            this.tooltip.hide();
        }

        private function onClose(_arg_1:MouseEvent):*
        {
            this.destroy();
        }

        public function destroy():*
        {
            this.eventHandler.removeAllEventListeners();
            this.eventHandler = null;
            if (this.tooltip)
            {
                this.tooltip.destroy();
            };
            this.skills.length = 0;
            this.tooltip = null;
            this.main = null;
            GF.removeAllChild(this);
        }


    }
}//package Panels

