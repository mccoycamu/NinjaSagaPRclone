// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Managers.LoginManager

package Managers
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import flash.net.SharedObject;
    import flash.events.MouseEvent;
    import Storage.Character;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.events.TextEvent;
    import Popups.Confirmation;
    import id.ninjasage.Crypt;
    import Storage.Library;
    import com.utils.NumberUtil;
    import flash.system.Capabilities;
    import id.ninjasage.Log;
    import com.utils.GF;

    public class LoginManager extends MovieClip 
    {

        public var ui_login:MovieClip;
        public var ui_register:MovieClip;
        public var ui_continue:MovieClip;
        public var main:*;
        public var _:*;
        public var __:*;
        public var quickLogin:Boolean;
        public var confirmation:*;

        public var eventHandler:EventHandler = new EventHandler();
        public var ns_so:SharedObject = SharedObject.getLocal("ninja_sage");

        public function LoginManager(_arg_1:*)
        {
            this.main = _arg_1;
            this.disableAll();
            OutfitManager.removeChildsFromMovieClips(this.main.loader);
            this.init();
        }

        internal function init():*
        {
            this.ui_login.visible = true;
            if (((!(this.ns_so.data.login_username == null)) && (!(this.ns_so.data.login_password == null))))
            {
                this.quickLogin = true;
                this.ui_continue.txt_user.text = this.ns_so.data.login_username;
                this.ui_continue.txt_pass.text = this.ns_so.data.login_password;
            };
            this.eventHandler.addListener(this.ui_login.btn_login, MouseEvent.CLICK, this.navigate, false, 0, true);
            this.eventHandler.addListener(this.ui_login.btn_register, MouseEvent.CLICK, this.navigate, false, 0, true);
            this.eventHandler.addListener(this.ui_login.btn_quicklogin, MouseEvent.CLICK, this.login, false, 0, true);
            this.eventHandler.addListener(this.ui_login.btn_clearSaved, MouseEvent.CLICK, this.navigate, false, 0, true);
            this.ui_login.txt_version.text = Character.build_num;
            this.ui_register.txt_version.text = Character.build_num;
            this.ui_continue.txt_version.text = Character.build_num;
            this.ui_register.visible = false;
            this.ui_continue.visible = false;
        }

        internal function disableAll():void
        {
            this.ui_login.visible = false;
            this.ui_register.visible = false;
            this.ui_continue.visible = false;
        }

        internal function navigateLink(_arg_1:TextEvent):void
        {
            var _local_2:* = _arg_1.currentTarget.name;
            if (_local_2 == "txt_tnc")
            {
                navigateToURL(new URLRequest("https://ninjasage.id/en/term-condition"));
            }
            else
            {
                if (_local_2 == "txt_policy")
                {
                    navigateToURL(new URLRequest("https://ninjasage.id/en/privacy-policy"));
                }
                else
                {
                    if (_local_2 == "txt_forgot")
                    {
                        navigateToURL(new URLRequest("https://ninjasage.id/en/forgot-password"));
                    }
                    else
                    {
                        if (_local_2 == "txt_website")
                        {
                            navigateToURL(new URLRequest("https://ninjasage.id/"));
                        }
                        else
                        {
                            if (_local_2 == "txt_help")
                            {
                                navigateToURL(new URLRequest("https://dc.ninjasage.id/"));
                            };
                        };
                    };
                };
            };
        }

        internal function navigate(_arg_1:MouseEvent):void
        {
            var _local_2:* = _arg_1.currentTarget.name;
            if (_local_2 == "btn_register")
            {
                this.ui_login.visible = false;
                this.ui_continue.visible = false;
                this.ui_register.visible = true;
                this.ui_register.btn_hide1.visible = false;
                this.ui_register.btn_hide2.visible = false;
                this.eventHandler.addListener(this.ui_register.btn_show1, MouseEvent.CLICK, this.hideShowPassword);
                this.eventHandler.addListener(this.ui_register.btn_show2, MouseEvent.CLICK, this.hideShowPassword);
                this.eventHandler.addListener(this.ui_register.btn_hide1, MouseEvent.CLICK, this.hideShowPassword);
                this.eventHandler.addListener(this.ui_register.btn_hide2, MouseEvent.CLICK, this.hideShowPassword);
                this.eventHandler.addListener(this.ui_register.btn_back, MouseEvent.CLICK, this.navigate, false, 0, true);
                this.eventHandler.addListener(this.ui_register.btn_register, MouseEvent.CLICK, this.register, false, 0, true);
                this.eventHandler.addListener(this.ui_register.btn_empty, MouseEvent.CLICK, this.navigate, false, 0, true);
                this.ui_register.txt_tnc.htmlText = "<a href='event:myEvent'>[Term & Condition]</a>";
                this.eventHandler.addListener(this.ui_register.txt_tnc, "link", this.navigateLink, false, 0, true);
                this.ui_register.txt_policy.htmlText = "<a href='event:myEvent'>[Privacy Policy]</a>";
                this.eventHandler.addListener(this.ui_register.txt_policy, "link", this.navigateLink, false, 0, true);
                this.ui_register.txt_help.htmlText = "<a href='event:myEvent'>[Need Help?]</a>";
                this.eventHandler.addListener(this.ui_register.txt_help, "link", this.navigateLink, false, 0, true);
            }
            else
            {
                if (_local_2 == "btn_login")
                {
                    this.ui_login.btn_login.removeEventListener(MouseEvent.CLICK, this.navigate);
                    this.ui_login.btn_quicklogin.removeEventListener(MouseEvent.CLICK, this.navigate);
                    this.ui_login.btn_register.removeEventListener(MouseEvent.CLICK, this.navigate);
                    this.ui_continue.visible = true;
                    this.ui_continue.btn_hide.visible = false;
                    this.eventHandler.addListener(this.ui_continue.btn_show, MouseEvent.CLICK, this.hideShowPassword);
                    this.eventHandler.addListener(this.ui_continue.btn_hide, MouseEvent.CLICK, this.hideShowPassword);
                    this.eventHandler.addListener(this.ui_continue.btn_login, MouseEvent.CLICK, this.login, false, 0, true);
                    this.eventHandler.addListener(this.ui_continue.btn_back, MouseEvent.CLICK, this.navigate, false, 0, true);
                    this.eventHandler.addListener(this.ui_continue.btn_empty, MouseEvent.CLICK, this.navigate, false, 0, true);
                    this.ui_continue.txt_forgot.htmlText = "<a href='event:myEvent'>[Click Here]</a>";
                    this.eventHandler.addListener(this.ui_continue.txt_forgot, "link", this.navigateLink, false, 0, true);
                    this.ui_continue.txt_website.htmlText = "<a href='event:myEvent'>[Ninja Sage]</a>";
                    this.eventHandler.addListener(this.ui_continue.txt_website, "link", this.navigateLink, false, 0, true);
                    this.ui_continue.txt_help.htmlText = "<a href='event:myEvent'>[Need Help?]</a>";
                    this.eventHandler.addListener(this.ui_continue.txt_help, "link", this.navigateLink, false, 0, true);
                    this.ui_register.visible = false;
                    this.ui_login.visible = false;
                }
                else
                {
                    if (_local_2 == "btn_quicklogin")
                    {
                        this.ui_login.btn_login.removeEventListener(MouseEvent.CLICK, this.navigate);
                        this.ui_login.btn_quicklogin.removeEventListener(MouseEvent.CLICK, this.navigate);
                        this.ui_login.btn_register.removeEventListener(MouseEvent.CLICK, this.navigate);
                        this.ui_login.visible = true;
                        this.eventHandler.addListener(this.ui_login.btn_quicklogin, MouseEvent.CLICK, this.login, false, 0, true);
                        this.eventHandler.addListener(this.ui_login.btn_register, MouseEvent.CLICK, this.navigate, false, 0, true);
                        this.eventHandler.addListener(this.ui_login.btn_login, MouseEvent.CLICK, this.navigate, false, 0, true);
                        this.ui_register.visible = false;
                        this.ui_continue.visible = false;
                    }
                    else
                    {
                        if (_local_2 == "btn_back")
                        {
                            this.ui_login.visible = true;
                            this.eventHandler.addListener(this.ui_login.btn_login, MouseEvent.CLICK, this.navigate, false, 0, true);
                            this.eventHandler.addListener(this.ui_login.btn_register, MouseEvent.CLICK, this.navigate, false, 0, true);
                            this.eventHandler.addListener(this.ui_login.btn_quicklogin, MouseEvent.CLICK, this.navigate, false, 0, true);
                            this.ui_continue.visible = false;
                            this.ui_register.visible = false;
                            this.ui_continue.btn_hide.visible = true;
                            this.ui_register.btn_hide1.visible = true;
                            this.ui_register.btn_hide2.visible = true;
                            this.ui_continue.btn_show.visible = true;
                            this.ui_register.btn_show1.visible = true;
                            this.ui_register.btn_show2.visible = true;
                            this.ui_continue.txt_pass.displayAsPassword = true;
                            this.ui_register.txt_pass.displayAsPassword = true;
                            this.ui_register.txt_repeat.displayAsPassword = true;
                        }
                        else
                        {
                            if (_local_2 == "btn_empty")
                            {
                                this.ui_continue.txt_user.text = "";
                                this.ui_continue.txt_pass.text = "";
                                this.ui_register.txt_user.text = "";
                                this.ui_register.txt_pass.text = "";
                                this.ui_register.txt_mail.text = "";
                                this.ui_register.txt_repeat.text = "";
                            }
                            else
                            {
                                if (_local_2 == "btn_clearSaved")
                                {
                                    this.clearSavedLoginConfirmation();
                                };
                            };
                        };
                    };
                };
            };
        }

        private function hideShowPassword(_arg_1:MouseEvent):*
        {
            var _local_2:* = _arg_1.currentTarget.name;
            if (_local_2 == "btn_show")
            {
                this.ui_continue.txt_pass.displayAsPassword = false;
                this.ui_continue.btn_show.visible = false;
                this.ui_continue.btn_hide.visible = true;
            }
            else
            {
                if (_local_2 == "btn_hide")
                {
                    this.ui_continue.txt_pass.displayAsPassword = true;
                    this.ui_continue.btn_show.visible = true;
                    this.ui_continue.btn_hide.visible = false;
                }
                else
                {
                    if (_local_2 == "btn_show1")
                    {
                        this.ui_register.txt_pass.displayAsPassword = false;
                        this.ui_register.btn_show1.visible = false;
                        this.ui_register.btn_hide1.visible = true;
                    }
                    else
                    {
                        if (_local_2 == "btn_hide1")
                        {
                            this.ui_register.txt_pass.displayAsPassword = true;
                            this.ui_register.btn_show1.visible = true;
                            this.ui_register.btn_hide1.visible = false;
                        }
                        else
                        {
                            if (_local_2 == "btn_show2")
                            {
                                this.ui_register.txt_repeat.displayAsPassword = false;
                                this.ui_register.btn_show2.visible = false;
                                this.ui_register.btn_hide2.visible = true;
                            }
                            else
                            {
                                if (_local_2 == "btn_hide2")
                                {
                                    this.ui_register.txt_repeat.displayAsPassword = true;
                                    this.ui_register.btn_show2.visible = true;
                                    this.ui_register.btn_hide2.visible = false;
                                };
                            };
                        };
                    };
                };
            };
        }

        public function clearSavedLoginConfirmation():*
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure that you want to clear your saved login data?";
            this.confirmation.btn_close.addEventListener(MouseEvent.CLICK, function ():*
            {
                removeChild(confirmation);
            });
            this.confirmation.btn_confirm.addEventListener(MouseEvent.CLICK, function ():*
            {
                ns_so.data.login_username = null;
                ns_so.data.login_password = null;
                removeChild(confirmation);
            });
            addChild(this.confirmation);
        }

        public function login(_arg_1:MouseEvent):void
        {
            var _local_2:*;
            var _local_3:*;
            if (_arg_1.currentTarget.name == "btn_quicklogin")
            {
                if (this.quickLogin)
                {
                    Character.account_username = this.ns_so.data.login_username;
                    this.main.loading(true);
                    this.main.amf_manager.service("SystemLogin.loginUser", [this.ui_continue.txt_user.text, Crypt.encrypt(this.ui_continue.txt_pass.text, Character.__, String(Character._)), Character._, this.main.loaderInfo.bytesLoaded, this.main.loaderInfo.bytesTotal, Character.__, Library.getSpecificItem(this.main, Character._), NumberUtil.getRandomNSeed(Character._, this.main), this.ui_continue.txt_pass.text.length], this.logResponse);
                }
                else
                {
                    this.main.showMessage("You don't have saved account");
                };
            }
            else
            {
                _local_2 = this.ui_continue.txt_user.text;
                _local_3 = this.ui_continue.txt_pass.text;
                Character.account_username = _local_2;
                if (_local_2 == "")
                {
                    this.main.showMessage("Username can't be empty !");
                    return;
                };
                if (_local_3 == "")
                {
                    this.main.showMessage("Password can't be empty !");
                    return;
                };
                this.main.loading(true);
                this.main.amf_manager.service("SystemLogin.loginUser", [_local_2, Crypt.encrypt(_local_3, Character.__, String(Character._)), Character._, this.main.loaderInfo.bytesLoaded, this.main.loaderInfo.bytesTotal, Character.__, Library.getSpecificItem(this.main, Character._), NumberUtil.getRandomNSeed(Character._, this.main), this.ui_continue.txt_pass.text.length], this.logResponse);
            };
        }

        internal function logResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                if (_arg_1.__ != Character.__)
                {
                    this.main.showMessage("Incorrect Session. Please restart the game");
                    return;
                };
                this.ns_so.data.login_username = this.ui_continue.txt_user.text;
                this.ns_so.data.login_password = this.ui_continue.txt_pass.text;
                this.ns_so.flush();
                Character.account_id = _arg_1.uid;
                Character.sessionkey = _arg_1.sessionkey;
                this.main.loadPanel("Panels.CharacterSelect");
                this.destroy();
                Character.hide_event = _arg_1.events;
                Character.clan_season_number = _arg_1.clan_season;
                Character.crew_season_number = _arg_1.crew_season;
                Character.sw_season_number = _arg_1.sw_season;
                Character.banners = _arg_1.banners;
            }
            else
            {
                if (_arg_1.status == 2)
                {
                    this.main.showMessage("You've entered the wrong username or password!");
                }
                else
                {
                    if (int(_arg_1.status) == -1)
                    {
                        this.main.showBanInfo("7", "Modded Game Detected. \nPlease re-download your game\nIf you continue using this version, then your account will be deleted asap!", ("Bad modders detected - " + Character.build_num), null);
                    }
                    else
                    {
                        if (_arg_1.status == 505)
                        {
                            this.main.showMessage("Game is under maintenance, please try again later");
                        }
                        else
                        {
                            if (_arg_1.status == 0)
                            {
                                this.main.showBanInfo(_arg_1.ban_info.ban_type, _arg_1.ban_info.reason, _arg_1.ban_info.message, _arg_1.ban_info.punishment);
                            }
                            else
                            {
                                if (_arg_1.status == 429)
                                {
                                    this.main.showMessage(_arg_1.result);
                                }
                                else
                                {
                                    this.main.getError(_arg_1.error);
                                };
                            };
                        };
                    };
                };
            };
        }

        public function register(_arg_1:MouseEvent):void
        {
            var _local_2:* = this.ui_register.txt_user.text;
            var _local_3:* = this.ui_register.txt_mail.text;
            var _local_4:* = this.ui_register.txt_pass.text;
            var _local_5:* = this.ui_register.txt_repeat.text;
            if (_local_4.length < 6)
            {
                this.main.showMessage("Password should contain at least 6 symbols !");
                return;
            };
            if (_local_4 != _local_5)
            {
                this.main.showMessage("Incorrect password !");
                return;
            };
            if (_local_2 == "")
            {
                this.main.showMessage("Username can't be empty !");
                return;
            };
            if (_local_3 == "")
            {
                this.main.showMessage("Mail can't be empty !");
                return;
            };
            if (_local_4 == "")
            {
                this.main.showMessage("Password can't be empty !");
                return;
            };
            this.registerUser(_local_2, _local_3, _local_4);
        }

        internal function registerUser(_arg_1:*, _arg_2:*, _arg_3:*):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("SystemLogin.registerUser", [_arg_1, _arg_2, _arg_3, Capabilities.serverString], this.regResponse);
        }

        internal function regResponse(_arg_1:Object):void
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage("Registered Succesfully !");
                this.ui_login.btn_login.removeEventListener(MouseEvent.CLICK, this.login);
                this.ui_login.btn_register.removeEventListener(MouseEvent.CLICK, this.navigate);
                this.ui_login.visible = true;
                this.eventHandler.addListener(this.ui_login.btn_login, MouseEvent.CLICK, this.login);
                this.eventHandler.addListener(this.ui_login.btn_register, MouseEvent.CLICK, this.navigate);
                this.ui_register.visible = false;
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        internal function destroy():void
        {
            Log.debug(this, "DESTROY");
            this.eventHandler.removeAllEventListeners();
            GF.removeAllChild(this);
            this.eventHandler = null;
            this.main = null;
            this.ns_so = null;
            this.confirmation = null;
            this.quickLogin = false;
        }


    }
}//package Managers

