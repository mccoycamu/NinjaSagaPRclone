// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Panels.UI_Option

package Panels
{
    import flash.display.MovieClip;
    import flash.net.SharedObject;
    import id.ninjasage.EventHandler;
    import flash.geom.Rectangle;
    import Popups.Confirmation;
    import flash.events.MouseEvent;
    import Storage.Character;
    import flash.display.StageDisplayState;
    import Managers.NinjaSage;
    import com.utils.GF;
    import flash.filesystem.File;
    import flash.display.StageQuality;
    import id.ninjasage.sounds.SoundAS;
    import flash.media.SoundMixer;
    import flash.media.SoundTransform;
    import flash.events.Event;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.system.System;
    import br.com.stimuli.loading.BulkLoader;

    public class UI_Option extends MovieClip 
    {

        private const QUALITY_LIST:Array = ["LOW", "MEDIUM", "HIGH", "BEST"];
        private const FPS_LIST:Array = [24, 30, 40];

        public var panel:MovieClip;
        public var main:*;
        private var unmuted:Boolean = true;
        private var ns_so:SharedObject;
        private var eventHandler:EventHandler;
        private var onBattle:Boolean = false;
        private var destroying:Boolean = false;
        private var volSliderDragArea:Rectangle;
        private var confirmation:Confirmation;

        public function UI_Option(_arg_1:*)
        {
            this.eventHandler = new EventHandler();
            this.main = _arg_1;
            this.ns_so = SharedObject.getLocal("ninja_sage");
            this.initUI();
            this.initButton();
            this.initSound();
        }

        public function setOnBattle():*
        {
            this.onBattle = true;
        }

        private function initUI():void
        {
            var _local_1:int;
            this.panel.btn_download.visible = false;
            this.panel.btn_ManageData.visible = false;
            this.panel.btn_ManageData.visible = true;
            _local_1 = 0;
            while (_local_1 < this.QUALITY_LIST.length)
            {
                this.panel[("radio_" + this.QUALITY_LIST[_local_1])].dot.visible = false;
                this.eventHandler.addListener(this.panel[("radio_" + this.QUALITY_LIST[_local_1])], MouseEvent.CLICK, this.handleQuality);
                _local_1++;
            };
            this.panel[("radio_" + this.main.stage.quality)].dot.visible = true;
            var _local_2:int = this.main.stage.frameRate;
            this.main.stage.frameRate = ((_local_2 >= 40) ? 40 : (((_local_2 >= 30) && (_local_2 <= 40)) ? 30 : 24));
            _local_1 = 0;
            while (_local_1 < this.FPS_LIST.length)
            {
                this.panel[("radio_" + this.FPS_LIST[_local_1])].dot.visible = false;
                this.eventHandler.addListener(this.panel[("radio_" + this.FPS_LIST[_local_1])], MouseEvent.CLICK, this.handleFPS);
                _local_1++;
            };
            this.panel[("radio_" + this.main.stage.frameRate)].dot.visible = true;
            this.panel.txt_charId.text = Character.char_id;
            this.panel.txt_version.text = Character.build_num;
            this.panel.txt_emblem.text = ((Character.account_type == 1) ? "Premium User" : "Free User");
            if (int(Character.emblem_duration) > 0)
            {
                this.panel.txt_emblem.text = (("Trial Emblem " + Character.emblem_duration) + " Days");
            };
            var _local_3:String = (((this.ns_so.data.hasOwnProperty("option_is_stickman")) && (this.ns_so.data.option_is_stickman)) ? "on" : "off");
            this.panel.toggle_stickman.gotoAndStop(_local_3);
            var _local_4:String = (((this.ns_so.data.hasOwnProperty("option_enable_bgm")) && (this.ns_so.data.option_enable_bgm)) ? "on" : "off");
            this.panel.toggle_bgm.gotoAndStop(_local_4);
            var _local_5:String = (((this.ns_so.data.hasOwnProperty("option_enable_sfx")) && (this.ns_so.data.option_enable_sfx)) ? "on" : "off");
            this.panel.toggle_sfx.gotoAndStop(_local_5);
            var _local_6:String = ((Character.play_items_animation) ? "on" : "off");
            this.panel.toggle_itemAnims.gotoAndStop(_local_6);
            var _local_7:String = ((Character.intel_class_animation) ? "on" : "off");
            this.panel.toggle_intelAnims.gotoAndStop(_local_7);
            var _local_8:String = ((Character.senjutsu_animation) ? "on" : "off");
            this.panel.toggle_senjutsuAnims.gotoAndStop(_local_8);
            var _local_9:String = ((this.main.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE) ? "on" : "off");
            this.panel.toggle_fullscreen.gotoAndStop(_local_9);
        }

        private function initButton():void
        {
            this.eventHandler.addListener(this.panel.toggle_stickman, MouseEvent.CLICK, this.handleStickman);
            this.eventHandler.addListener(this.panel.toggle_itemAnims, MouseEvent.CLICK, this.handleItemAnims);
            this.eventHandler.addListener(this.panel.toggle_fullscreen, MouseEvent.CLICK, this.handleFullScreen);
            this.eventHandler.addListener(this.panel.toggle_senjutsuAnims, MouseEvent.CLICK, this.handleSenjutsuAnims);
            this.eventHandler.addListener(this.panel.toggle_intelAnims, MouseEvent.CLICK, this.handleIntelAnims);
            this.eventHandler.addListener(this.panel.toggle_bgm, MouseEvent.CLICK, this.handleBGM);
            this.eventHandler.addListener(this.panel.toggle_sfx, MouseEvent.CLICK, this.handleSFX);
            this.eventHandler.addListener(this.panel.soundMc.btnMin, MouseEvent.CLICK, this.handleVolume);
            this.eventHandler.addListener(this.panel.soundMc.btnPlus, MouseEvent.CLICK, this.handleVolume);
            this.eventHandler.addListener(this.panel.soundMc.volume, MouseEvent.MOUSE_DOWN, this.dragVolSlider);
            this.eventHandler.addListener(this, MouseEvent.MOUSE_UP, this.handleVolume);
            this.eventHandler.addListener(this.panel.soundMc.btnToggleSound, MouseEvent.CLICK, this.handleMute);
            this.eventHandler.addListener(this.panel.btn_news, MouseEvent.CLICK, this.handleSocial);
            this.eventHandler.addListener(this.panel.facebookPage, MouseEvent.CLICK, this.handleSocial);
            this.eventHandler.addListener(this.panel.facebookGroup, MouseEvent.CLICK, this.handleSocial);
            this.eventHandler.addListener(this.panel.discordChannel, MouseEvent.CLICK, this.handleSocial);
            this.eventHandler.addListener(this.panel.btn_change, MouseEvent.CLICK, this.handleChangeCharacter);
            this.eventHandler.addListener(this.panel.btn_logout, MouseEvent.CLICK, this.handleLogout);
            this.eventHandler.addListener(this.panel.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panel.btn_ManageData, MouseEvent.CLICK, this.deleteDataConfirmation);
            var _local_1:Array = [{
                "button":this.panel.hint_stickman,
                "hint":"Turn your character into stickman and will not showing any outfit that equipped."
            }, {
                "button":this.panel.hint_fullscreen,
                "hint":"Set the game resolution to Full Screen."
            }, {
                "button":this.panel.hint_itemAnims,
                "hint":"Disable all animation that available on equipped items such as Weapon and Back Item. Turn off for smoother gameplay."
            }, {
                "button":this.panel.hint_senjutsu,
                "hint":"Disable Senjutsu Transition animation when changing from basic skill to senjutsu skill."
            }, {
                "button":this.panel.hint_intel,
                "hint":"Disable Intellegence Class Intro Animation that played at every start of battle. Only works if you are using Intellegence Special Class."
            }];
            var _local_2:int;
            while (_local_2 < _local_1.length)
            {
                NinjaSage.showDynamicTooltip(_local_1[_local_2].button, _local_1[_local_2].hint);
                _local_2++;
            };
        }

        private function deleteDataConfirmation(_arg_1:MouseEvent):void
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure that you want to delete all your data?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.removeConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.deleteData);
            this.addChild(this.confirmation);
        }

        private function removeConfirmation(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
        }

        private function deleteData(e:MouseEvent):void
        {
            var storageDir:File;
            var files:Array;
            var f:File;
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            storageDir = File.applicationStorageDirectory;
            if (storageDir.exists)
            {
                files = storageDir.getDirectoryListing();
                for each (f in files)
                {
                    try
                    {
                        if (f.isDirectory)
                        {
                            f.deleteDirectory(true);
                        }
                        else
                        {
                            f.deleteFile();
                        };
                    }
                    catch(err:Error)
                    {
                    };
                };
            };
            this.handleLogout(null);
        }

        private function handleQuality(_arg_1:MouseEvent):void
        {
            var _local_2:String = _arg_1.currentTarget.name.replace("radio_", "");
            var _local_3:int;
            while (_local_3 < this.QUALITY_LIST.length)
            {
                this.panel[("radio_" + this.QUALITY_LIST[_local_3])].dot.visible = false;
                _local_3++;
            };
            this.panel[("radio_" + _local_2)].dot.visible = true;
            this.main.stage.quality = StageQuality[_local_2];
        }

        private function handleFPS(_arg_1:MouseEvent):void
        {
            var _local_2:int = _arg_1.currentTarget.name.replace("radio_", "");
            var _local_3:int;
            while (_local_3 < this.FPS_LIST.length)
            {
                this.panel[("radio_" + this.FPS_LIST[_local_3])].dot.visible = false;
                _local_3++;
            };
            this.panel[("radio_" + _local_2)].dot.visible = true;
            this.main.stage.frameRate = _local_2;
        }

        private function handleStickman(_arg_1:MouseEvent):void
        {
            var _local_2:String = ((this.panel.toggle_stickman.currentFrameLabel == "off") ? "on" : "off");
            this.panel.toggle_stickman.gotoAndStop(_local_2);
            Character.is_stickman = ((_local_2 == "off") ? false : true);
            if (this.onBattle)
            {
                this.main.getNotice("\nThe setting will be applied on the next battle");
            };
        }

        private function handleItemAnims(_arg_1:MouseEvent):void
        {
            var _local_2:String = ((this.panel.toggle_itemAnims.currentFrameLabel == "off") ? "on" : "off");
            this.panel.toggle_itemAnims.gotoAndStop(_local_2);
            Character.play_items_animation = ((_local_2 == "off") ? false : true);
            if (this.onBattle)
            {
                this.main.getNotice("\nThe setting will be applied on the next battle");
            };
        }

        private function handleIntelAnims(_arg_1:MouseEvent):void
        {
            var _local_2:String = ((this.panel.toggle_intelAnims.currentFrameLabel == "off") ? "on" : "off");
            this.panel.toggle_intelAnims.gotoAndStop(_local_2);
            Character.intel_class_animation = ((_local_2 == "off") ? false : true);
            if (this.onBattle)
            {
                this.main.getNotice("\nThe setting will be applied on the next battle");
            };
        }

        private function handleSenjutsuAnims(_arg_1:MouseEvent):void
        {
            var _local_2:String = ((this.panel.toggle_senjutsuAnims.currentFrameLabel == "off") ? "on" : "off");
            this.panel.toggle_senjutsuAnims.gotoAndStop(_local_2);
            Character.senjutsu_animation = ((_local_2 == "off") ? false : true);
        }

        private function handleFullScreen(_arg_1:MouseEvent):void
        {
            var _local_2:String = ((this.panel.toggle_fullscreen.currentFrameLabel == "off") ? "on" : "off");
            this.panel.toggle_fullscreen.gotoAndStop(_local_2);
            if (this.main.stage.displayState != StageDisplayState.FULL_SCREEN_INTERACTIVE)
            {
                this.main.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            }
            else
            {
                this.main.stage.displayState = StageDisplayState.NORMAL;
            };
        }

        private function handleBGM(_arg_1:MouseEvent):void
        {
            this.ns_so.data.option_enable_bgm = ((this.ns_so.data.option_enable_bgm) ? false : true);
            this.main.bgm_enabled = this.ns_so.data.option_enable_bgm;
            if (this.main.bgm_enabled)
            {
                this.main.startBgm(((this.onBattle) ? "battle" : "xmas"));
            }
            else
            {
                this.main.stopAllBgm();
            };
            var _local_2:String = ((this.panel.toggle_bgm.currentFrameLabel == "off") ? "on" : "off");
            this.panel.toggle_bgm.gotoAndStop(_local_2);
        }

        private function handleSFX(_arg_1:MouseEvent):void
        {
            this.ns_so.data.option_enable_sfx = ((this.ns_so.data.option_enable_sfx) ? false : true);
            SoundAS.enableSfx = this.ns_so.data.option_enable_sfx;
            var _local_2:String = ((this.panel.toggle_sfx.currentFrameLabel == "off") ? "on" : "off");
            this.panel.toggle_sfx.gotoAndStop(_local_2);
        }

        private function initSound():void
        {
            var _local_1:Number = ((this.ns_so.data.option_volume != null) ? this.ns_so.data.option_volume : 1);
            this.panel.soundMc.volume.slider.x = (_local_1 * 145);
            this.unmuted = (_local_1 > 0);
            SoundMixer.soundTransform = new SoundTransform((this.panel.soundMc.volume.slider.x / 145));
            this.volSliderDragArea = new Rectangle((this.panel.soundMc.volume.width - 3), (this.panel.soundMc.volume.y - 25), (-(this.panel.soundMc.volume.width) + 3), 0);
        }

        private function handleVolume(_arg_1:MouseEvent):void
        {
            if (_arg_1.currentTarget.name == "btnPlus")
            {
                if (this.panel.soundMc.volume.slider.x < 145)
                {
                    this.panel.soundMc.volume.slider.x = (this.panel.soundMc.volume.slider.x + 14.5);
                };
            }
            else
            {
                if (_arg_1.currentTarget.name == "btnMin")
                {
                    if (this.panel.soundMc.volume.slider.x > 0)
                    {
                        this.panel.soundMc.volume.slider.x = (this.panel.soundMc.volume.slider.x - 14.5);
                    };
                }
                else
                {
                    _arg_1.currentTarget.stopDrag();
                };
            };
            if (this.panel.soundMc.volume.slider.x <= 0)
            {
                this.panel.soundMc.volume.slider.x = 0;
            }
            else
            {
                if (this.panel.soundMc.volume.slider.x >= 145)
                {
                    this.panel.soundMc.volume.slider.x = 145;
                };
            };
            var _local_2:* = (this.panel.soundMc.volume.slider.x / 145).toFixed(2);
            SoundMixer.soundTransform = new SoundTransform(_local_2);
        }

        private function dragVolSlider(_arg_1:MouseEvent):void
        {
            _arg_1.currentTarget.parent.volume.slider.startDrag(false, this.volSliderDragArea);
        }

        private function handleMute(_arg_1:MouseEvent):void
        {
            this.unmuted = (!(this.unmuted));
            if (!this.unmuted)
            {
                this.panel.soundMc.volume.slider.x = 0;
                this.main.showMessage("Sound Off");
            }
            else
            {
                this.main.showMessage("Sound On");
                this.panel.soundMc.volume.slider.x = 145;
            };
            SoundMixer.soundTransform = new SoundTransform((this.panel.soundMc.volume.slider.x / 145));
        }

        private function handleChangeCharacter(_arg_1:MouseEvent):void
        {
            Character.resetBattleInfo(this.main);
            this.main.removeAllChildsFromLoader();
            this.main.removeAllLoadedPanels();
            this.main.loadPanel("Panels.CharacterSelect");
            this.closePanel();
        }

        private function handleLogout(_arg_1:MouseEvent):void
        {
            dispatchEvent(new Event("LOGOUT"));
            this.onBattle = false;
            Character.resetBattleInfo(this.main);
            if (this.main)
            {
                this.main.removeAllChildsFromLoader();
                this.main.removeAllLoadedPanels();
                this.main.loadPanel("Managers.LoginManager");
            };
            this.closePanel();
        }

        private function handleSocial(_arg_1:MouseEvent):void
        {
            var _local_2:* = _arg_1.currentTarget.name;
            if (_local_2 == "facebookPage")
            {
                navigateToURL(new URLRequest("https://www.facebook.com/NinjaSage.ID"));
            }
            else
            {
                if (_local_2 == "facebookGroup")
                {
                    navigateToURL(new URLRequest("https://www.facebook.com/groups/ninjasage/"));
                }
                else
                {
                    if (_local_2 == "discordChannel")
                    {
                        navigateToURL(new URLRequest("https://dc.ninjasage.id/"));
                    }
                    else
                    {
                        if (_local_2 == "txt_help")
                        {
                            navigateToURL(new URLRequest("https://dc.ninjasage.id/"));
                        }
                        else
                        {
                            if (_local_2 == "btn_news")
                            {
                                navigateToURL(new URLRequest("https://ninjasage.id/news"));
                            };
                        };
                    };
                };
            };
        }

        private function closePanel(_arg_1:MouseEvent=null):void
        {
            if (this.ns_so)
            {
                this.ns_so.data.option_volume = SoundMixer.soundTransform.volume;
                this.ns_so.data.option_quality = this.main.stage.quality;
                this.ns_so.data.option_framerate = this.main.stage.frameRate;
                this.ns_so.data.option_is_stickman = Character.is_stickman;
                this.ns_so.data.option_item_animation = Character.play_items_animation;
                this.ns_so.data.option_intel_animation = Character.intel_class_animation;
                this.ns_so.data.option_senjutsu_animation = Character.senjutsu_animation;
                this.ns_so.data.option_enable_sfx = SoundAS.enableSfx;
                this.ns_so.flush();
                this.ns_so = null;
            };
            this.destroy();
            GF.removeAllChild(this);
        }

        public function destroy():void
        {
            var _local_1:*;
            if (this.destroying)
            {
                return;
            };
            this.destroying = true;
            if ((((this.main) && (!(this.onBattle))) && (!(this.main.combat == null))))
            {
                this.main.combat.destroy();
                this.main.combat = null;
            };
            if (this.eventHandler)
            {
                this.eventHandler.removeAllEventListeners();
            };
            this.volSliderDragArea = null;
            this.eventHandler = null;
            this.main = null;
            this.panel = null;
            this.ns_so = null;
            System.gc();
            for each (_local_1 in ["combat", "assets", "skills", "specialclass", "talents", "panels", "etc"])
            {
                BulkLoader.getLoader(_local_1).removeAll();
            };
        }


    }
}//package Panels

