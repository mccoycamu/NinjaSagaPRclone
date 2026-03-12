// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.LinkMenu

package id.ninjasage.features
{
    import Managers.AppManager;
    import id.ninjasage.Clan;
    import id.ninjasage.Crew;
    import Storage.Character;
    import com.adobe.utils.StringUtil;

    public class LinkMenu 
    {

        public static var ClanWar:* = "ClanWar";
        public static var ShadowWar:* = "ShadowWar";
        public static var PvP:* = "PvP";
        public static var CrewWar:* = "Crew";


        public static function open(_arg_1:*):*
        {
            var _local_2:* = AppManager.getInstance().main;
            switch (_arg_1)
            {
                case ClanWar:
                    _local_2.loading(true);
                    Clan.instance.getSeason(LinkMenu.clanOnGetStatus);
                    return;
                case CrewWar:
                    _local_2.loading(true);
                    Crew.instance.getSeason(LinkMenu.crewOnGetStatus);
                    return;
                case ShadowWar:
                    _local_2.loading(true);
                    _local_2.amf_manager.service("ShadowWar.executeService", ["getSeason", [Character.char_id, Character.sessionkey]], LinkMenu.swOnGetSeason);
                    return;
                case PvP:
                    _local_2.loading(true);
                    _local_2.amf_manager.service("PvPService.checkAccess", [Character.char_id, Character.sessionkey], LinkMenu.pvpCheckAccess);
                    return;
                default:
                    LinkMenu.openOther(_arg_1);
            };
        }

        private static function clanOnGetStatus(_arg_1:Object, _arg_2:*=null):*
        {
            var _local_3:* = AppManager.getInstance().main;
            _local_3.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                _local_3.getNotice(_arg_1.errorMessage);
                return;
            };
            if (((!(_arg_2 == null)) || (_arg_1 == null)))
            {
                _local_3.getNotice("Clan server is unreachable.\nProbably maintenance.\nPlease try again later");
                return;
            };
            if (((_arg_1) && (_arg_1.hasOwnProperty("timestamp"))))
            {
                Character.clan_timestamp = _arg_1.timestamp;
            };
            if (((_arg_1) && (_arg_1.hasOwnProperty("season"))))
            {
                Character.clan_season = _arg_1.season;
            };
            _local_3.loading(true);
            Clan.instance.login(Character.char_id, Character.sessionkey, LinkMenu.clanOnAuth);
        }

        private static function clanOnAuth(_arg_1:*, _arg_2:*=null):*
        {
            var _local_3:* = "Unable login to Clan Server";
            var _local_4:* = AppManager.getInstance().main;
            _local_4.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("access_token"))))
            {
                Clan.instance.authToken(_arg_1.access_token);
                Clan.instance.getClanData(LinkMenu.clanOnGetData);
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("statusCode"))))
            {
                _local_3 = (_local_3 + ("\nCode: " + _arg_1.statusCode));
            };
            _local_4.getNotice(_local_3);
        }

        private static function clanOnGetData(_arg_1:*, _arg_2:*=null):*
        {
            var _local_3:* = AppManager.getInstance().main;
            _local_3.loading(false);
            if ((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("clan"))) && (_arg_1.hasOwnProperty("char"))))
            {
                Character.clan_data = _arg_1.clan;
                Character.clan_char_data = _arg_1.char;
                _local_3.loadPanel("Panels.ClanVillage");
            }
            else
            {
                _local_3.loadPanel("Panels.ClanCreate");
            };
        }

        private static function crewOnGetStatus(_arg_1:Object, _arg_2:*=null):*
        {
            var _local_4:Object;
            var _local_3:* = AppManager.getInstance().main;
            _local_3.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                _local_3.getNotice(_arg_1.errorMessage);
                return;
            };
            if (((!(_arg_2 == null)) || (_arg_1 == null)))
            {
                _local_3.getNotice("Crew server is unreachable.\nProbably maintenance.\nPlease try again later");
                return;
            };
            if (((_arg_1) && (_arg_1.hasOwnProperty("timestamp"))))
            {
                Character.crew_timestamp = _arg_1.timestamp;
            };
            if (((_arg_1) && (_arg_1.hasOwnProperty("season"))))
            {
                Character.crew_season = _arg_1.season;
            };
            if (((_arg_1) && (_arg_1.hasOwnProperty("phase"))))
            {
                Crew.instance.setPhase(_arg_1.phase);
            };
            if ((((_arg_1) && (_arg_1.hasOwnProperty("rp1"))) && (_arg_1.hasOwnProperty("rp2"))))
            {
                _local_4 = {
                    "phase_1":_arg_1.rp1,
                    "phase_2":_arg_1.rp2
                };
                Crew.instance.setRewardData(_local_4);
            };
            _local_3.loading(true);
            Crew.instance.login(Character.char_id, Character.sessionkey, LinkMenu.crewOnAuth);
        }

        private static function crewOnAuth(_arg_1:*, _arg_2:*=null):*
        {
            var _local_3:* = "Unable login to Crew Server";
            var _local_4:* = AppManager.getInstance().main;
            _local_4.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("access_token"))))
            {
                Crew.instance.authToken(_arg_1.access_token);
                Crew.instance.getCrewData(LinkMenu.crewOnGetData);
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("code"))))
            {
                _local_3 = (_local_3 + ("\nCode: " + _arg_1.code));
            };
            _local_4.getNotice(_local_3);
        }

        private static function crewOnGetData(_arg_1:*, _arg_2:*=null):*
        {
            var _local_3:* = AppManager.getInstance().main;
            _local_3.loading(false);
            if ((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("crew"))) && (_arg_1.hasOwnProperty("char"))))
            {
                Character.crew_data = _arg_1.crew;
                Character.crew_char_data = _arg_1.char;
                _local_3.loadExternalSwfPanel("CrewVillage", "CrewVillage");
            }
            else
            {
                if ((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("code"))) && (_arg_1.code == 404)))
                {
                    _local_3.loadExternalSwfPanel("CrewCreate", "CrewCreate");
                }
                else
                {
                    _local_3.getNotice("Unable to get info from Crew Server");
                };
            };
        }

        private static function swOnGetSeason(_arg_1:Object):*
        {
            var _local_2:* = AppManager.getInstance().main;
            _local_2.loading(false);
            if (_arg_1.status == 1)
            {
                Character.shadow_war_season = _arg_1;
                if (_arg_1.active)
                {
                    _local_2.loadExternalSwfPanel("ArenaVillage", "ArenaVillage");
                }
                else
                {
                    _local_2.getNotice("No active season");
                };
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    _local_2.getNotice(_arg_1.result);
                }
                else
                {
                    _local_2.getError(_arg_1.error);
                };
            };
        }

        private static function pvpCheckAccess(_arg_1:*):*
        {
            var _local_2:* = AppManager.getInstance().main;
            _local_2.loading(false);
            if (((_arg_1.status == 1) && (_arg_1.hasOwnProperty("url"))))
            {
                _local_2.loadPanel("id.ninjasage.pvp.PvP");
            }
            else
            {
                if (_arg_1.hasOwnProperty("result"))
                {
                    _local_2.showMessage(_arg_1.result);
                }
                else
                {
                    _local_2.getError("Unknown Error");
                };
            };
        }

        private static function openOther(_arg_1:*):*
        {
            if (StringUtil.beginsWith(_arg_1, "Panels."))
            {
                AppManager.getInstance().main.loadPanel(_arg_1);
            }
            else
            {
                if (_arg_1.indexOf("|"))
                {
                    _arg_1 = _arg_1.split("|");
                    AppManager.getInstance().main.loadExternalSwfPanel(_arg_1[0], _arg_1[1]);
                };
            };
        }


    }
}//package id.ninjasage.features

