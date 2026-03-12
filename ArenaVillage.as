// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.ArenaVillage

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import Popups.Confirmation;
    import Storage.GameData;
    import Storage.Character;
    import flash.events.MouseEvent;
    import Managers.OutfitManager;
    import Managers.NinjaSage;
    import Storage.ArenaBuffs;
    import com.utils.GF;
    import Combat.BattleManager;
    import Combat.BattleVars;
    import flash.utils.getDefinitionByName;
    import flash.utils.setTimeout;
    import Panels.WorldChat;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.utils.clearTimeout;
    import flash.system.System;

    public dynamic class ArenaVillage extends MovieClip 
    {

        public var panelMC:MovieClip;
        public var currentSquad:String;
        public var main:*;
        public var eventHandler:EventHandler;
        public var confirmation:Confirmation;
        public var timeout:*;
        public var shadowWarData:Object;
        public var leaderboardData:Object;
        public var battleData:Object;
        public var currentPageEnemy:int = 1;
        public var totalPageEnemy:int = 1;
        public var currentPageLeaderboard:int = 1;
        public var totalPageLeaderboard:int = 1;
        public var outfits:Array = [];
        public var bodyArray:Array = ["upper_body", "lower_body", "left_upper_arm", "left_lower_arm", "left_hand", "left_upper_leg", "left_lower_leg", "left_shoe", "right_upper_arm", "right_lower_arm", "right_hand", "right_upper_leg", "right_lower_leg", "right_shoe"];
        public var missionIds:Array;
        public var worldChat:MovieClip;

        public function ArenaVillage(_arg_1:*, _arg_2:*)
        {
            var _local_3:Object = GameData.get("encyclopedia");
            this.missionIds = _local_3.background;
            super();
            this.main = _arg_1;
            this.panelMC = _arg_2.panelMC;
            this.eventHandler = new EventHandler();
            this.initButton();
            this.initUI();
            this.getShadowWarData();
        }

        public function initUI():*
        {
            this.panelMC.cardMC.gotoAndStop(1);
            this.panelMC.cardMC.visible = false;
            this.panelMC.battleMC.visible = false;
            this.panelMC.leaderboardMC.visible = false;
            this.panelMC.cardMC.addFrameScript(42, this.initCardSquad);
            this.panelMC.arenaSeasonEnd.seasonTxt.text = Character.shadow_war_season.season.num;
            this.updateSeasonTime();
        }

        public function getShadowWarData():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("ShadowWar.executeService", ["getStatus", [Character.char_id, Character.sessionkey]], this.onDataResponse);
        }

        public function onDataResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.shadowWarData = _arg_1;
                Character.squad_data = _arg_1;
                if (_arg_1.show_profile)
                {
                    this.panelMC.cardMC.visible = true;
                    this.panelMC.cardMC.gotoAndPlay(2);
                };
                this.main.handleVillageHUDVisibility(false);
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.getNotice(_arg_1.result);
                    this.destroy();
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        public function getBattleData(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("ShadowWar.executeService", ["getEnemies", [Character.char_id, Character.sessionkey]], this.onBattleDataResponse);
        }

        public function onBattleDataResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.battleData = _arg_1;
                this.openBattlePopup();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.getNotice(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        public function initCardSquad():*
        {
            this.panelMC.cardMC.stop();
            this.panelMC.cardMC.seasonTxt.text = ("Shadow War Season " + Character.shadow_war_season.season.num);
            this.panelMC.cardMC.seasonDateTxt.text = Character.shadow_war_season.season.date;
            this.panelMC.cardMC.squadIcon.gotoAndStop(Character.getSquadName(Character.squad_data.squad));
            this.panelMC.cardMC.leagueIcon.gotoAndStop((Character.squad_data.rank + 1));
            this.panelMC.cardMC.trophyTxt.text = ((Character.squad_data.trophy != null) ? Character.squad_data.trophy : 0);
            this.panelMC.cardMC.nicknameTxt.text = ((("[" + Character.char_id) + "] ") + Character.character_name);
            this.panelMC.cardMC.squadTxt.htmlText = (('You are assigned to <font color="#ffff00">' + Character.getSquadFullName(Character.squad_data.squad)) + "</font>");
            this.eventHandler.addListener(this.panelMC.cardMC.confirmBtn, MouseEvent.CLICK, this.closeCard);
        }

        public function closeCard(_arg_1:MouseEvent):*
        {
            this.panelMC.cardMC.visible = false;
            this.panelMC.cardMC.gotoAndStop(1);
            this.eventHandler.removeListener(this.panelMC.cardMC.confirmBtn, MouseEvent.CLICK, this.closeCard);
        }

        public function openBattlePopup():*
        {
            this.panelMC.battleMC.visible = true;
            this.panelMC.battleMC.btn_prev.visible = false;
            this.totalPageEnemy = this.battleData.enemies.length;
            this.panelMC.battleMC.txt_page.text = ((this.currentPageEnemy + "/") + this.totalPageEnemy);
            this.updatePageTextEnemy();
            this.initBattlePopupUI();
        }

        public function closeBattlePopup(_arg_1:MouseEvent):*
        {
            this.panelMC.battleMC.visible = false;
            this.currentPageEnemy = 1;
        }

        public function initBattlePopupUI():*
        {
            var _local_2:*;
            var _local_3:int;
            var _local_4:Object;
            var _local_1:* = this.battleData.enemies[(this.currentPageEnemy - 1)];
            this.clearStaticFullBody();
            if (this.outfits[_local_1.id] == null)
            {
                _local_2 = new OutfitManager();
                _local_2.fillOutfit(this.panelMC.battleMC.char_mc, _local_1.set.weapon, _local_1.set.back_item, _local_1.set.clothing, _local_1.set.hairstyle, _local_1.set.face, _local_1.set.hair_color, _local_1.set.skin_color);
                this.outfits[_local_1.id] = _local_2;
            }
            else
            {
                this.outfits[_local_1.id].fillOutfit(this.panelMC.battleMC.char_mc, _local_1.set.weapon, _local_1.set.back_item, _local_1.set.clothing, _local_1.set.hairstyle, _local_1.set.face, _local_1.set.hair_color, _local_1.set.skin_color);
            };
            this.panelMC.battleMC.txt_player_name.text = Character.character_name;
            this.panelMC.battleMC.txt_player_squad.text = Character.getSquadFullName(this.shadowWarData.squad);
            this.panelMC.battleMC.txt_char_trophies.text = (((Character.getLeagueFullName(this.shadowWarData.rank) + " (") + this.shadowWarData.trophy) + ")");
            this.panelMC.battleMC.char_leagueIcon.gotoAndStop((this.shadowWarData.rank + 1));
            this.panelMC.battleMC.char_squadMc.gotoAndStop(Character.getSquadName(this.shadowWarData.squad));
            this.panelMC.battleMC.enemy_leagueIcon.gotoAndStop((_local_1.rank + 1));
            this.panelMC.battleMC.enemy_squadMc.gotoAndStop(Character.getSquadName(_local_1.squad));
            this.panelMC.battleMC.txt_enemy_squad.text = Character.getSquadFullName(_local_1.squad);
            this.panelMC.battleMC.txt_stamina.text = (this.shadowWarData.energy + "/100");
            this.panelMC.battleMC.bar_stamina.scaleX = Math.max(Math.min((int(this.shadowWarData.energy) / 100), 1), 0);
            if (((_local_1.set.hasOwnProperty("skills")) && (!(_local_1.set.skills == null))))
            {
                _local_3 = 0;
                while (_local_3 < 4)
                {
                    this.panelMC.battleMC[("iconMc" + _local_3)].visible = false;
                    if (_local_3 < _local_1.set.skills.length)
                    {
                        this.panelMC.battleMC[("iconMc" + _local_3)].visible = true;
                        NinjaSage.loadItemIcon(this.panelMC.battleMC[("iconMc" + _local_3)], _local_1.set.skills[_local_3]);
                    };
                    _local_3++;
                };
            };
            this.panelMC.battleMC.txt_battlefield_situation.text = "No Applied Effect.";
            if (this.shadowWarData.squads[0].squad == this.shadowWarData.squad)
            {
                _local_4 = ArenaBuffs.getArenaBuff(Character.getSquadName(this.shadowWarData.squad));
                this.panelMC.battleMC.txt_battlefield_situation.htmlText = (((("Applied Effect: " + '<font color="#ff0000"> ') + _local_4.debuff.name) + "</font>\n") + _local_4.debuff.description);
            }
            else
            {
                if (this.shadowWarData.squads[0].squad == _local_1.squad)
                {
                    _local_4 = ArenaBuffs.getArenaBuff(Character.getSquadName(_local_1.squad));
                    this.panelMC.battleMC.txt_battlefield_situation.htmlText = (((("Applied Effect: " + '<font color="#00ff00"> ') + _local_4.buff.name) + "</font>\n") + _local_4.buff.description);
                };
            };
        }

        public function clearStaticFullBody():*
        {
            var _local_1:* = 0;
            while (_local_1 < this.bodyArray.length)
            {
                GF.removeAllChild(this.panelMC.battleMC.char_mc[this.bodyArray[_local_1]]);
                _local_1++;
            };
        }

        public function changePageEnemy(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.totalPageEnemy > this.currentPageEnemy)
                    {
                        this.currentPageEnemy++;
                        this.initBattlePopupUI();
                    };
                    break;
                case "btn_prev":
                    if (this.currentPageEnemy > 1)
                    {
                        this.currentPageEnemy--;
                        this.initBattlePopupUI();
                    };
            };
            this.updatePageTextEnemy();
        }

        public function updatePageTextEnemy():*
        {
            this.panelMC.battleMC.txt_page.text = ((this.currentPageEnemy + "/") + this.totalPageEnemy);
            if (this.currentPageEnemy == this.totalPageEnemy)
            {
                this.panelMC.battleMC.btn_next.visible = false;
            }
            else
            {
                this.panelMC.battleMC.btn_next.visible = true;
            };
            if (this.currentPageEnemy <= 1)
            {
                this.panelMC.battleMC.btn_prev.visible = false;
            }
            else
            {
                this.panelMC.battleMC.btn_prev.visible = true;
            };
        }

        public function refreshEnemyConfirmation(_arg_1:MouseEvent):*
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure that you want to refresh the enemy for 40 tokens?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.removeConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.refreshEnemy);
            this.panelMC.addChild(this.confirmation);
        }

        public function refreshEnemy(_arg_1:MouseEvent):*
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            this.main.loading(true);
            this.main.amf_manager.service("ShadowWar.executeService", ["refreshEnemies", [Character.char_id, Character.sessionkey]], this.onEnemyRefreshed);
        }

        public function onEnemyRefreshed(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage(_arg_1.result);
                this.battleData = _arg_1;
                Character.account_tokens = (Character.account_tokens - 40);
                this.currentPageEnemy = 1;
                this.main.HUD.setBasicData();
                this.getBattleData(null);
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.getNotice(((_arg_1.result) || ("Unknown Error")));
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        public function refillEnergyConfirmation(_arg_1:MouseEvent):*
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure that you want to refill the energy for 50 tokens?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.removeConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.refillEnergy);
            this.panelMC.addChild(this.confirmation);
        }

        public function removeConfirmation(_arg_1:MouseEvent):*
        {
            if (this.confirmation != null)
            {
                GF.removeAllChild(this.confirmation);
                this.confirmation = null;
            };
        }

        public function refillEnergy(_arg_1:MouseEvent):*
        {
            this.eventHandler.removeListener(this.confirmation.btn_close, MouseEvent.CLICK, this.removeConfirmation);
            this.eventHandler.removeListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.refillEnergy);
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
            this.main.loading(true);
            this.main.amf_manager.service("ShadowWar.executeService", ["refillEnergy", [Character.char_id, Character.sessionkey]], this.onEnergyRefilled);
        }

        public function onEnergyRefilled(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.main.showMessage("Energy refilled");
                Character.account_tokens = (Character.account_tokens - 50);
                this.shadowWarData.energy = _arg_1.energy;
                this.panelMC.battleMC.txt_stamina.text = (this.shadowWarData.energy + "/100");
                this.panelMC.battleMC.bar_stamina.scaleX = Math.max(Math.min((int(this.shadowWarData.energy) / 100), 1), 0);
                this.main.HUD.setBasicData();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.getNotice(((_arg_1.result) || ("Unknown Error")));
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        public function startBattle(_arg_1:MouseEvent):*
        {
            this.main.loading(true);
            this.main.amf_manager.service("ShadowWar.executeService", ["startBattle", [Character.char_id, Character.sessionkey, this.battleData.enemies[(this.currentPageEnemy - 1)].id]], this.onBattleStarted);
        }

        public function onBattleStarted(_arg_1:Object):*
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:*;
            var _local_5:int;
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                Character.is_squad_war = true;
                _local_2 = 0;
                _local_3 = 0;
                _local_4 = 0;
                while (_local_4 < this.shadowWarData.squads.length)
                {
                    if (this.shadowWarData.squad == this.shadowWarData.squads[_local_4].squad)
                    {
                        _local_2 = (_local_4 + 1);
                    };
                    if (this.battleData.enemies[(this.currentPageEnemy - 1)].squad == this.shadowWarData.squads[_local_4].squad)
                    {
                        _local_3 = (_local_4 + 1);
                    };
                    _local_4++;
                };
                Character.shadow_war_battle_data = {
                    "ranks":[_local_2, _local_3],
                    "player":this.shadowWarData.squad,
                    "enemy":this.battleData.enemies[(this.currentPageEnemy - 1)].squad,
                    "rank_1":this.shadowWarData.squads[0].squad
                };
                Character.battle_code = _arg_1.id;
                this.main.combat = this.main.loadPanel("Combat.Battle", true);
                _local_5 = int(Math.floor((Math.random() * this.missionIds.length)));
                BattleManager.init(this.main.combat, this.main, BattleVars.SHADOWWAR_MATCH, this.missionIds[_local_5]);
                BattleManager.addPlayerToTeam("player", ("char_" + Character.char_id));
                BattleManager.addPlayerToTeam("enemy", ("char_" + this.battleData.enemies[(this.currentPageEnemy - 1)].id));
                BattleManager.startBattle();
                this.destroy();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.getNotice(_arg_1.result);
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        public function openSquadInfo(_arg_1:MouseEvent):*
        {
            this.panelMC.leaderboardMC.visible = true;
            this.eventHandler.addListener(this.panelMC.leaderboardMC.btn_close, MouseEvent.CLICK, this.closeLeaderboardPanel);
            this.eventHandler.addListener(this.panelMC.leaderboardMC.btn_prev, MouseEvent.CLICK, this.changePageLeaderboard);
            this.eventHandler.addListener(this.panelMC.leaderboardMC.btn_next, MouseEvent.CLICK, this.changePageLeaderboard);
            var _local_2:String = _arg_1.currentTarget.name.replace("btn_", "");
            switch (_local_2)
            {
                case "KageGuardSquad":
                    this.panelMC.leaderboardMC.txt_squad_name.text = "Kage Guard Squad";
                    this.currentSquad = "kage";
                    break;
                case "HqGuardSquad":
                    this.panelMC.leaderboardMC.txt_squad_name.text = "HQ Guard";
                    this.currentSquad = "hq";
                    break;
                case "AmbushSquad":
                    this.panelMC.leaderboardMC.txt_squad_name.text = "Ambush Squad";
                    this.currentSquad = "ambush";
                    break;
                case "AssaultSquad":
                    this.panelMC.leaderboardMC.txt_squad_name.text = "Assault Squad";
                    this.currentSquad = "assault";
                    break;
                case "MedicGuardSquad":
                    this.panelMC.leaderboardMC.txt_squad_name.text = "Medic Guard";
                    this.currentSquad = "medic";
                    break;
            };
            this.panelMC.leaderboardMC.squadMc.gotoAndStop(this.currentSquad);
            this.panelMC.leaderboardMC.txt_battlefield_desc.htmlText = ((((((((("Debuff " + '<font color="#ffff00"> ') + ArenaBuffs.getArenaBuff(this.currentSquad).debuff.name) + "</font>\n") + ArenaBuffs.getArenaBuff(this.currentSquad).debuff.description) + "\n\nBuff ") + '<font color="#ffff00"> ') + ArenaBuffs.getArenaBuff(this.currentSquad).buff.name) + "</font>\n") + ArenaBuffs.getArenaBuff(this.currentSquad).buff.description);
            var _local_3:* = 0;
            while (_local_3 < this.shadowWarData.squads.length)
            {
                if (Character.getSquadId(this.currentSquad) == this.shadowWarData.squads[_local_3].squad)
                {
                    this.panelMC.leaderboardMC.rankMc.numberTxt.text = (_local_3 + 1);
                };
                _local_3++;
            };
            this.initSquadLeaderboardData();
        }

        public function closeLeaderboardPanel(_arg_1:MouseEvent):*
        {
            var _local_2:int;
            while (_local_2 < 8)
            {
                this.panelMC.leaderboardMC[("rankInfoMc_" + _local_2)].buttonMode = false;
                this.panelMC.leaderboardMC[("rankInfoMc_" + _local_2)].metaData = {};
                _local_2++;
            };
            this.panelMC.leaderboardMC.visible = false;
            this.currentPageLeaderboard = 1;
            this.totalPageLeaderboard = 1;
            this.eventHandler.removeListener(this.panelMC.leaderboardMC.btn_close, MouseEvent.CLICK, this.closeLeaderboardPanel);
        }

        public function initSquadLeaderboardData():*
        {
            this.main.loading(true);
            this.main.amf_manager.service("ShadowWar.executeService", ["squadLeaderboard", [Character.char_id, Character.sessionkey, Character.getSquadId(this.currentSquad)]], this.leaderboardResponse);
        }

        public function leaderboardResponse(_arg_1:Object):*
        {
            this.main.loading(false);
            if (_arg_1.status == 1)
            {
                this.leaderboardData = _arg_1;
                this.showLeaderboard();
            }
            else
            {
                if (_arg_1.status > 1)
                {
                    this.main.showMessage(_arg_1.result);
                    this.destroy();
                }
                else
                {
                    this.main.getError(_arg_1.error);
                };
            };
        }

        public function showLeaderboard():*
        {
            var _local_2:*;
            var _local_1:* = 0;
            while (_local_1 < 8)
            {
                _local_2 = (_local_1 + int((int((this.currentPageLeaderboard - 1)) * 8)));
                if (this.leaderboardData.players.length > _local_2)
                {
                    this.panelMC.leaderboardMC[("rankInfoMc_" + _local_1)].visible = true;
                    this.panelMC.leaderboardMC[("rankInfoMc_" + _local_1)].txt_name.htmlText = Character.colorifyText(this.leaderboardData.players[_local_2].id, this.leaderboardData.players[_local_2].name);
                    this.panelMC.leaderboardMC[("rankInfoMc_" + _local_1)].txt_rank.text = String((_local_2 + 1));
                    this.panelMC.leaderboardMC[("rankInfoMc_" + _local_1)].txt_score.text = this.leaderboardData.players[_local_2].trophy;
                    this.panelMC.leaderboardMC[("rankInfoMc_" + _local_1)].leagueIcon.gotoAndStop((this.leaderboardData.players[_local_2].rank + 1));
                    this.panelMC.leaderboardMC[("rankInfoMc_" + _local_1)].buttonMode = true;
                    this.panelMC.leaderboardMC[("rankInfoMc_" + _local_1)].metaData = {"charId":this.leaderboardData.players[_local_2].id};
                    this.eventHandler.addListener(this.panelMC.leaderboardMC[("rankInfoMc_" + _local_1)], MouseEvent.CLICK, this.openFriendProfile);
                }
                else
                {
                    this.panelMC.leaderboardMC[("rankInfoMc_" + _local_1)].visible = false;
                };
                _local_1++;
            };
            this.totalPageLeaderboard = Math.ceil((this.leaderboardData.players.length / 8));
            this.updatePageText();
        }

        public function openFriendProfile(_arg_1:MouseEvent):*
        {
            var _local_2:* = (getDefinitionByName("Panels.UI_Friend_Profile") as Class);
            var _local_3:* = new _local_2(this.main, _arg_1.currentTarget.metaData.charId, true);
            this.main.loader.addChild(_local_3);
        }

        public function changePageLeaderboard(_arg_1:MouseEvent):*
        {
            switch (_arg_1.currentTarget.name)
            {
                case "btn_next":
                    if (this.totalPageLeaderboard > this.currentPageLeaderboard)
                    {
                        this.currentPageLeaderboard++;
                        this.showLeaderboard();
                    };
                    break;
                case "btn_prev":
                    if (this.currentPageLeaderboard > 1)
                    {
                        this.currentPageLeaderboard--;
                        this.showLeaderboard();
                    };
            };
            this.updatePageText();
        }

        public function updatePageText():*
        {
            this.panelMC.leaderboardMC.txt_page.text = ((this.currentPageLeaderboard + "/") + this.totalPageLeaderboard);
        }

        public function updateSeasonTime():void
        {
            if (Character.shadow_war_season.season.time == null)
            {
                return;
            };
            var _local_1:* = 86400;
            var _local_2:* = 3600;
            var _local_3:* = 60;
            var _local_4:* = Character.shadow_war_season.season.time;
            var _local_5:* = Math.floor((_local_4 / _local_1));
            var _local_6:* = Math.floor(((_local_4 - (_local_5 * _local_1)) / _local_2));
            var _local_7:* = Math.floor((((_local_4 - (_local_5 * _local_1)) - (_local_6 * _local_2)) / _local_3));
            this.panelMC.arenaSeasonEnd.daysTxt.text = _local_5;
            this.panelMC.arenaSeasonEnd.hoursTxt.text = _local_6;
            this.panelMC.arenaSeasonEnd.minutesTxt.text = _local_7;
            this.timeout = setTimeout(this.updateSeasonTime, 10000);
            Character.shadow_war_season.season.time = (Character.shadow_war_season.season.time - 10);
        }

        public function initButton():*
        {
            this.eventHandler.addListener(this.panelMC.btn_close, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.btn_AmbushSquad, MouseEvent.CLICK, this.openSquadInfo);
            this.eventHandler.addListener(this.panelMC.btn_AssaultSquad, MouseEvent.CLICK, this.openSquadInfo);
            this.eventHandler.addListener(this.panelMC.btn_HqGuardSquad, MouseEvent.CLICK, this.openSquadInfo);
            this.eventHandler.addListener(this.panelMC.btn_KageGuardSquad, MouseEvent.CLICK, this.openSquadInfo);
            this.eventHandler.addListener(this.panelMC.btn_MedicGuardSquad, MouseEvent.CLICK, this.openSquadInfo);
            this.eventHandler.addListener(this.panelMC.btn_battle, MouseEvent.CLICK, this.getBattleData);
            this.eventHandler.addListener(this.panelMC.dropdownBtn, MouseEvent.CLICK, this.handleDropdown);
            this.eventHandler.addListener(this.panelMC.dropdownMc.close_btn, MouseEvent.CLICK, this.handleDropdown);
            this.eventHandler.addListener(this.panelMC.dropdownMc.btn_league, MouseEvent.CLICK, this.openArenaLeague);
            this.eventHandler.addListener(this.panelMC.dropdownMc.btn_rewards, MouseEvent.CLICK, this.openArenaRewards);
            this.eventHandler.addListener(this.panelMC.dropdownMc.btn_leaderboard, MouseEvent.CLICK, this.openArenaLeaderboard);
            this.eventHandler.addListener(this.panelMC.dropdownMc.btn_hint, MouseEvent.CLICK, this.openPresetSelection);
            this.eventHandler.addListener(this.panelMC.dropdownMc.btn_card, MouseEvent.CLICK, this.openCardProfile);
            this.eventHandler.addListener(this.panelMC.dropdownMc.btn_leaderboardRealtime, MouseEvent.CLICK, this.openRealtimeLeaderboard);
            this.eventHandler.addListener(this.panelMC.dropdownMc.btn_WorldChat, MouseEvent.CLICK, this.openChat);
            this.eventHandler.addListener(this.panelMC.battleMC.btn_close, MouseEvent.CLICK, this.closeBattlePopup);
            this.eventHandler.addListener(this.panelMC.battleMC.btn_prev, MouseEvent.CLICK, this.changePageEnemy);
            this.eventHandler.addListener(this.panelMC.battleMC.btn_next, MouseEvent.CLICK, this.changePageEnemy);
            this.eventHandler.addListener(this.panelMC.battleMC.btn_change_enemy, MouseEvent.CLICK, this.refreshEnemyConfirmation);
            this.eventHandler.addListener(this.panelMC.battleMC.btn_restore, MouseEvent.CLICK, this.refillEnergyConfirmation);
            this.eventHandler.addListener(this.panelMC.battleMC.btn_fight, MouseEvent.CLICK, this.startBattle);
        }

        public function handleDropdown(_arg_1:MouseEvent):*
        {
            this.panelMC.dropdownMc.visible = (!(this.panelMC.dropdownMc.visible));
        }

        public function openChat(_arg_1:MouseEvent):void
        {
            this.worldChat = new WorldChat(this.main);
            this.main.loader.addChild(this.worldChat);
        }

        public function openCardProfile(_arg_1:MouseEvent):*
        {
            this.main.loadExternalSwfPanel("ArenaStatistic", "ArenaStatistic");
        }

        public function openRealtimeLeaderboard(_arg_1:MouseEvent):*
        {
            navigateToURL(new URLRequest("https://ninjasage.id/en/leaderboards/shadow-war/realtime"));
        }

        public function openArenaLeague(_arg_1:MouseEvent):*
        {
            this.main.loadExternalSwfPanel("ArenaLeague", "ArenaLeague");
        }

        public function openArenaRewards(_arg_1:MouseEvent):*
        {
            this.main.loadExternalSwfPanel("ArenaRewards", "ArenaRewards");
        }

        public function openArenaLeaderboard(_arg_1:MouseEvent):*
        {
            this.main.loadExternalSwfPanel("ArenaLeaderboard", "ArenaLeaderboard");
        }

        public function openPresetSelection(_arg_1:MouseEvent):*
        {
            this.main.loadExternalSwfPanel("ArenaPreset", "ArenaPreset");
        }

        public function closePanel(_arg_1:MouseEvent):*
        {
            this.main.handleVillageHUDVisibility(true);
            this.destroy();
        }

        public function destroy():*
        {
            var _local_2:*;
            if (((!(this.outfits == null)) && (this.outfits.length > 0)))
            {
                for (_local_2 in this.outfits)
                {
                    this.outfits[_local_2].destroy();
                    delete this.outfits[_local_2];
                };
            };
            if (this.worldChat)
            {
                this.worldChat.destroy();
            };
            var _local_1:int;
            while (_local_1 < 4)
            {
                GF.removeAllChild(this.panelMC.battleMC[("iconMc" + _local_1)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.battleMC[("iconMc" + _local_1)].skillIcon.iconHolder);
                _local_1++;
            };
            this.worldChat = null;
            this.outfits = [];
            this.bodyArray = [];
            this.missionIds = [];
            GF.removeAllChild(this.panelMC.battleMC.char_mc);
            GF.removeAllChild(this.panelMC.battleMC);
            GF.removeAllChild(this.panelMC.leaderboardMC);
            this.eventHandler.removeAllEventListeners();
            this.main.removeExternalSwfPanel();
            OutfitManager.clearStaticMc();
            this.outfits = null;
            this.main = null;
            this.eventHandler = null;
            this.shadowWarData = null;
            this.leaderboardData = null;
            this.battleData = null;
            if (this.timeout)
            {
                clearTimeout(this.timeout);
            };
            this.timeout = null;
            GF.removeAllChild(this.panelMC);
            System.gc();
        }


    }
}//package id.ninjasage.features

