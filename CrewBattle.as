// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.features.CrewBattle

package id.ninjasage.features
{
    import flash.display.MovieClip;
    import id.ninjasage.EventHandler;
    import br.com.stimuli.loading.BulkLoader;
    import Popups.Confirmation;
    import Storage.GameData;
    import Storage.Character;
    import Managers.AppManager;
    import flash.utils.clearTimeout;
    import id.ninjasage.Crew;
    import flash.utils.setTimeout;
    import gs.TweenLite;
    import flash.events.MouseEvent;
    import com.utils.GF;
    import com.utils.NumberUtil;
    import Managers.NinjaSage;
    import com.hurlant.util.Hex;
    import com.hurlant.crypto.Crypto;
    import Combat.BattleManager;
    import Combat.BattleVars;
    import flash.utils.getDefinitionByName;
    import flash.events.Event;
    import Managers.StatManager;

    public dynamic class CrewBattle extends MovieClip 
    {

        private const notifPosX:int = 1366;

        public var panelMC:MovieClip;
        private var main:*;
        private var eventHandler:EventHandler;
        private var loaderSwf:BulkLoader;
        private var confirmation:Confirmation;
        private var crewTimestamp:*;
        private var crewData:Object;
        private var crewVillage:CrewVillage;
        private var charData:Object;
        private var bossData:Array;
        private var castles:* = {};
        private var castleName:Array;
        private var recruitData:Array;
        private var rankingData:Array;
        private var defendingData:Array;
        private var recruitedFriend:Array = [];
        private var seasonRewardData:Object;
        private var selectedCastle:int = -1;
        private var currentPage:int = 1;
        private var totalPage:int = 1;
        private var role:int;
        private var RECOVER_PRICE_TOKEN:int = 50;
        private var RECOVER_LIFE_TOKEN:int = 100;
        private var RECOVER_PRICE_GOURD:int = 1;
        private var RECOVER_LIFE_GOURD:int = 50;
        private var RECOVER_LIFE_FREE:int;
        private var selectedEnemyIndex:int;
        private var notificationText:String;
        private var init:* = false;
        private var destroyed:* = false;
        private var timeoutGetCastle:* = null;
        private var n:* = null;

        public function CrewBattle(_arg_1:*, _arg_2:*, _arg_3:*)
        {
            var _local_4:Object = GameData.get("crew");
            this.castleName = _local_4.castle;
            this.bossData = [];
            var _local_5:int;
            while (_local_5 < _local_4.boss.length)
            {
                this.bossData.push({
                    "bossId":_local_4.boss[_local_5].id,
                    "bossName":_local_4.boss[_local_5].name,
                    "bossDescription":_local_4.boss[_local_5].description,
                    "bossLevel":[(int(Character.character_lvl) + _local_4.boss[_local_5].levels[0]), (int(Character.character_lvl) + _local_4.boss[_local_5].levels[1])],
                    "battleBackground":_local_4.boss[_local_5].background
                });
                _local_5++;
            };
            super();
            this.main = AppManager.getInstance().main;
            this.panelMC = _arg_2.panelMC;
            this.crewVillage = _arg_1;
            this.loaderSwf = BulkLoader.createUniqueNamedLoader(10);
            this.eventHandler = new EventHandler();
            this.crewData = Character.crew_data;
            this.charData = Character.crew_char_data;
            this.crewTimestamp = _arg_3;
            this.role = this.charData.role;
            this.RECOVER_LIFE_FREE = this.crewVillage.buildingData["KushiDangoBtn"].amount[int(this.crewVillage.getBuildingLevel("KushiDangoBtn"))];
            this.crewVillage.panelMC.visible = false;
            this.initButton();
            this.initUI();
        }

        private function initUI():void
        {
            var _local_1:int;
            while (_local_1 < 7)
            {
                this.panelMC[("clan_btn_" + _local_1)].gotoAndStop(1);
                _local_1++;
            };
            this.panelMC.popuploading.addFrameScript(8, this.hideObjectDuringAnimation, 92, this.sendBattlePhaseTwo, 102, this.closeBattleAnimation);
            this.panelMC.popupNotification.x = 2000;
            this.hidePopup();
            this.updateRoleIcon();
            this.updateTimeleft();
            this.initStatusDisplay();
            this.initPlayerHead();
            this.getMiniGameData();
        }

        private function hidePopup():void
        {
            this.panelMC.popupMiniGame.gotoAndStop("idle");
            this.panelMC.popuploading.gotoAndStop("idle");
            this.panelMC.popupResult.gotoAndStop("idle");
            this.panelMC.lastpopupRewardHome.gotoAndStop("idle");
            this.panelMC.popupattackside.gotoAndStop("idle");
            this.panelMC.stamin_panel.gotoAndStop("idle");
            this.panelMC.popupRewardHome.gotoAndStop("idle");
            this.panelMC.popupattacksideph2.gotoAndStop("idle");
            this.panelMC.popupdefendside.gotoAndStop("idle");
            this.panelMC.status.gotoAndStop(1);
        }

        private function onInitCastle(_arg_1:*=null, _arg_2:*=null):void
        {
            if (this.destroyed)
            {
                return;
            };
            this.onCastleData(_arg_1, _arg_2);
            this.updateCastleOwner();
        }

        private function onCastleData(_arg_1:*=null, _arg_2:*=null):*
        {
            var _local_3:* = undefined;
            if ((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("castles"))) && (!(_arg_1.castles == null))))
            {
                if (this.timeoutGetCastle != null)
                {
                    clearTimeout(this.timeoutGetCastle);
                };
                this.timeoutGetCastle = null;
                this.castles = _arg_1.castles;
                if (((Crew.instance.getPhase() == 2) && ((this.panelMC.popupattacksideph2.currentLabel == "show") || (this.panelMC.popupdefendside.currentLabel == "show"))))
                {
                    this.renderCastleInfo(this.panelMC.popupattacksideph2.panel);
                    this.renderCastleInfo(this.panelMC.popupdefendside.panel);
                };
                this.notificationText = _arg_1.a;
                this.updateNotification();
            }
            else
            {
                if ((((((!(this.init)) && (!(this.timeoutGetCastle))) && (!(_arg_1 == null))) && (_arg_1.hasOwnProperty("code"))) && (_arg_1.code == 429)))
                {
                    this.timeoutGetCastle = setTimeout(Crew.instance.getCastles, 500, this.onInitCastle);
                    this.init = true;
                };
            };
            this.myCastleDummy = "a";
        }

        public function getMiniGameData():*
        {
            Crew.instance.getMiniGame(this.onMiniGameRes);
        }

        private function onMiniGameRes(_arg_1:*=null, _arg_2:*=null):*
        {
            if (((!(_arg_1 == null)) && (Boolean(_arg_1.hasOwnProperty("energy")))))
            {
                this.panelMC.miniGameBtn.txt.text = ("Mini Game: x" + _arg_1.energy);
            };
        }

        private function updateRoleIcon():void
        {
            var _local_1:*;
            this.panelMC.status.gotoAndStop(this.role);
            try
            {
                if (this.charData.role_limit_at != "")
                {
                    _local_1 = this.panelMC.popupdefendside.panel;
                    _local_1.timer.visible = true;
                    _local_1.timer.timeTxt.text = this.charData.role_limit_at;
                    _local_1.AttackerToDefBtn.change.gotoAndStop(this.role);
                };
            }
            catch(e)
            {
            };
        }

        private function updateCastleOwner():void
        {
            var _local_2:*;
            var _local_3:*;
            var _local_4:*;
            var _local_1:int;
            while (_local_1 < 7)
            {
                _local_2 = this.castles.hasOwnProperty(_local_1);
                _local_3 = ((_local_2) ? this.castles[_local_1].owner_name : "");
                _local_4 = this.panelMC[("clan_btn_" + _local_1)];
                this.panelMC[("name_" + _local_1)].text = ((_local_2) ? this.castles[_local_1].name : this.castleName[_local_1]);
                this.main.removeButtonListener(_local_4, this.checkBattlePopup, _local_3);
                this.main.initButton(_local_4, this.checkBattlePopup, _local_3);
                _local_1++;
            };
        }

        private function updateNotification():void
        {
            if (this.notificationText != "")
            {
                if (this.panelMC.popupNotification.x != this.notifPosX)
                {
                    TweenLite.to(this.panelMC.popupNotification, 1.2, {
                        "x":this.notifPosX,
                        "ease":"easeOutBack"
                    });
                };
                this.eventHandler.addListener(this.panelMC.popupNotification, MouseEvent.CLICK, this.closeNotification);
                this.panelMC.popupNotification.txt.htmlText = this.notificationText;
            }
            else
            {
                this.panelMC.popupNotification.x = 2000;
            };
        }

        private function closeNotification(_arg_1:MouseEvent):void
        {
            this.eventHandler.removeListener(this.panelMC.popupNotification.closeBtn, MouseEvent.CLICK, this.closeNotification);
            TweenLite.to(this.panelMC.popupNotification, 1.2, {
                "x":2000,
                "ease":"easeOutBack"
            });
        }

        private function initButton():void
        {
            this.eventHandler.addListener(this.panelMC.backBtn, MouseEvent.CLICK, this.closePanel);
            this.eventHandler.addListener(this.panelMC.rewardListHomeBtn, MouseEvent.CLICK, this.openRewardListHome);
            this.eventHandler.addListener(this.panelMC.btn_buystamina, MouseEvent.CLICK, this.openStaminaPopup);
            this.eventHandler.addListener(this.panelMC.lastseasonrewardBtn, MouseEvent.CLICK, this.openLastSeasonReward);
            this.main.initButton(this.panelMC.miniGameBtn, this.openMinigamePopup, "");
        }

        private function openStaminaPopup(_arg_1:MouseEvent):void
        {
            this.panelMC.stamin_panel.gotoAndStop("show");
            this.eventHandler.addListener(this.panelMC.stamin_panel.panel.closeBtn, MouseEvent.CLICK, this.closeStaminaPopup);
            this.eventHandler.addListener(this.panelMC.stamin_panel.panel.btn_restore, MouseEvent.CLICK, this.onRestoreStamina);
            this.eventHandler.addListener(this.panelMC.stamin_panel.panel.btn_upgrade, MouseEvent.CLICK, this.onUpgradeMaxStamina);
            this.panelMC.stamin_panel.panel.roll_num.text = Character.getMaterialAmount(this.crewVillage.GOLDEN_ONIGIRI);
            this.panelMC.stamin_panel.panel.txt_stamina_cur.text = ((this.charData.stamina + "/") + this.charData.max_stamina);
            this.panelMC.stamin_panel.panel.staminaBar.scaleX = ((this.charData.stamina / this.charData.max_stamina) * 1.63);
            this.panelMC.stamin_panel.panel.txt_upgrade_maxsta_cost.text = this.crewVillage.UPGRADE_PRICE_TOKEN;
            if (this.charData.max_stamina < this.crewVillage.MAX_STAMINA)
            {
                this.panelMC.stamin_panel.panel.txt_maxsta_cur.text = this.charData.max_stamina;
                this.panelMC.stamin_panel.panel.txt_maxsta_upgradeto.text = int((this.charData.max_stamina + this.crewVillage.UPGRADE_STAMINA_AMOUNT));
            }
            else
            {
                this.panelMC.stamin_panel.panel.txt_maxsta_cur.text = this.charData.max_stamina;
                this.panelMC.stamin_panel.panel.txt_maxsta_upgradeto.text = this.crewVillage.MAX_STAMINA;
                this.panelMC.stamin_panel.panel.btn_upgrade.visible = false;
            };
            this.checkRestoreTokenOrOnigiri();
        }

        private function checkRestoreTokenOrOnigiri():void
        {
            var _local_1:int = Character.getMaterialAmount(this.crewVillage.GOLDEN_ONIGIRI);
            this.panelMC.stamin_panel.panel.roll_num.text = _local_1;
            this.panelMC.stamin_panel.panel.btn_upgrade.visible = (((_local_1 > 0) || (Character.account_tokens >= this.crewVillage.REFILL_PRICE_TOKEN)) ? true : false);
            if (_local_1 > 0)
            {
                this.panelMC.stamin_panel.panel.icon_Token.visible = false;
                this.panelMC.stamin_panel.panel.txt_restore_sta_cost.visible = false;
                this.panelMC.stamin_panel.panel.RollIcon.visible = true;
                this.panelMC.stamin_panel.panel.txt_restore_sta_cost_roll.visible = true;
                this.panelMC.stamin_panel.panel.txt_restore_sta_cost_roll.text = this.crewVillage.REFILL_PRICE_GOLDEN_ONIGIRI;
            }
            else
            {
                this.panelMC.stamin_panel.panel.icon_Token.visible = true;
                this.panelMC.stamin_panel.panel.txt_restore_sta_cost.visible = true;
                this.panelMC.stamin_panel.panel.RollIcon.visible = false;
                this.panelMC.stamin_panel.panel.txt_restore_sta_cost_roll.visible = false;
                this.panelMC.stamin_panel.panel.txt_restore_sta_cost.text = this.crewVillage.REFILL_PRICE_TOKEN;
            };
        }

        private function onRestoreStamina(_arg_1:MouseEvent):void
        {
            this.confirmation = null;
            this.confirmation = new Confirmation();
            var _local_2:int = Character.getMaterialAmount(this.crewVillage.GOLDEN_ONIGIRI);
            this.restoreType = ((_local_2 > 0) ? "rolls" : "tokens");
            var _local_3:String = ((_local_2 > 0) ? (this.crewVillage.REFILL_PRICE_GOLDEN_ONIGIRI + " Roll?") : (this.crewVillage.REFILL_PRICE_TOKEN + " Tokens?"));
            this.confirmation.txtMc.txt.text = ((("Are you sure that you want to restore " + this.crewVillage.REFILL_STAMINA_AMOUNT) + " Stamina with ") + _local_3);
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.removeConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onRestoreStaminaConf);
            this.panelMC.addChild(this.confirmation);
        }

        private function removeConfirmation(_arg_1:MouseEvent):*
        {
            if (!this.confirmation)
            {
                return;
            };
            this.eventHandler.removeListener(this.confirmation.btn_close, MouseEvent.CLICK, this.removeConfirmation);
            this.eventHandler.removeListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onRestoreStaminaConf);
            this.eventHandler.removeListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onUpgradeMaxStaminaConf);
            GF.removeAllChild(this.confirmation);
            this.confirmation = null;
        }

        private function onRestoreStaminaConf(_arg_1:MouseEvent):void
        {
            Crew.instance.restoreStamina(this.onRestoreStaminaRes);
        }

        private function onRestoreStaminaRes(_arg_1:Object, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.removeConfirmation(null);
                this.main.showMessage(_arg_1.errorMessage);
                if (_arg_1.code == 422)
                {
                    this.closeStaminaPopup(null);
                }
                else
                {
                    if (_arg_1.code == 402)
                    {
                        this.closeStaminaPopup(null);
                        this.openRecharge(null);
                    }
                    else
                    {
                        this.main.getNotice(((_arg_1.errorMessage + "\nErr:") + _arg_1.code));
                    };
                };
                return;
            };
            if ((("status" in _arg_1) && (_arg_1.status == "ok")))
            {
                if (_arg_1.data.currency_type == 2)
                {
                    Character.replaceMaterials(this.crewVillage.GOLDEN_ONIGIRI, _arg_1.data.currency_remaining);
                    this.main.showMessage((((("+" + _arg_1.data.restored_stamina) + " stamina refilled using ") + _arg_1.data.currency_used) + " Golden Stamina Roll"));
                }
                else
                {
                    if (_arg_1.data.currency_type == 1)
                    {
                        Character.account_tokens = _arg_1.data.currency_remaining;
                        this.main.showMessage((((("+" + _arg_1.data.restored_stamina) + " stamina refilled using ") + _arg_1.data.currency_used) + " tokens"));
                    }
                    else
                    {
                        this.main.showMessage("Stamina is full");
                    };
                };
                this.openStaminaPopup(null);
                this.refreshStamina();
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getNotice("Unable to restore stamina");
            };
        }

        private function onUpgradeMaxStamina(_arg_1:MouseEvent):void
        {
            this.confirmation = null;
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = (((("Are you sure that you want to increase your max stamina for " + this.crewVillage.UPGRADE_STAMINA_AMOUNT) + " with ") + this.crewVillage.UPGRADE_PRICE_TOKEN) + " tokens?");
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.removeConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.onUpgradeMaxStaminaConf);
            this.panelMC.addChild(this.confirmation);
        }

        private function onUpgradeMaxStaminaConf(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            Crew.instance.upgradeMaxStamina(this.onUpgradeStaminaRes);
        }

        private function onUpgradeStaminaRes(_arg_1:Object, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getError("unknown");
                return;
            };
            if ((("status" in _arg_1) && (_arg_1.status == "ok")))
            {
                Character.account_tokens = (Character.account_tokens - this.crewVillage.UPGRADE_PRICE_TOKEN);
                this.refreshStamina();
                this.crewVillage.refreshStamina();
            };
        }

        private function refreshStamina():*
        {
            Crew.instance.getStamina(this.onRefreshStamina);
        }

        private function onRefreshStamina(_arg_1:*, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (Boolean(_arg_1.hasOwnProperty("char")))))
            {
                Character.crew_char_data = _arg_1.char;
                this.charData = _arg_1.char;
                this.openStaminaPopup(null);
                this.initStatusDisplay();
                this.main.HUD.setBasicData();
                GF.removeAllChild(this.confirmation);
                this.removeConfirmation(null);
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getError("Error");
                this.destroy();
            };
            GF.removeAllChild(this.confirmation);
            this.removeConfirmation(null);
        }

        private function closeStaminaPopup(_arg_1:MouseEvent):void
        {
            this.panelMC.stamin_panel.gotoAndStop("idle");
        }

        private function checkBattlePopup(_arg_1:MouseEvent):void
        {
            this.selectedCastle = _arg_1.currentTarget.name.replace("clan_btn_", "");
            if (Crew.instance.getPhase() == 1)
            {
                this.openPhaseOneBattle();
                return;
            };
            if (this.crewData.id == this.castles[this.selectedCastle].owner_id)
            {
                this.main.loading(true);
                Crew.instance.getDefenders(this.castles[this.selectedCastle].id, this.onGetDefendData);
            }
            else
            {
                this.openPhaseTwoBattle();
            };
        }

        private function openPhaseOneBattle():void
        {
            this.panelMC.popupattackside.gotoAndStop("show");
            this.panelMC.popupattackside.panel.popupReward.gotoAndStop("idle");
            this.panelMC.popupattackside.panel.rankList.gotoAndStop("idle");
            this.panelMC.popupattackside.panel.bossDetail.gotoAndStop("idle");
            var _local_1:* = this.selectedCastle;
            this.panelMC.popupattackside.panel.clanStatusMc.nameTxt.text = ((!(this.castles.hasOwnProperty(_local_1))) ? "Castle" : this.castles[_local_1].name);
            this.eventHandler.addListener(this.panelMC.popupattackside.panel.closeBtn, MouseEvent.CLICK, this.closeBattlePopup);
            this.eventHandler.addListener(this.panelMC.popupattackside.panel.fightBtn, MouseEvent.CLICK, this.openBossDetailPhaseOne);
            this.eventHandler.addListener(this.panelMC.popupattackside.panel.rewardListBtn, MouseEvent.CLICK, this.openRewardCastle);
            this.eventHandler.addListener(this.panelMC.popupattackside.panel.Btn_Rank, MouseEvent.CLICK, this.openRankingPhaseOne);
        }

        private function openBossDetailPhaseOne(_arg_1:MouseEvent):void
        {
            this.panelMC.popupattackside.panel.bossDetail.gotoAndStop("show");
            this.panelMC.popupattackside.panel.bossDetail.panel.popupWarList.gotoAndStop("idle");
            this.eventHandler.addListener(this.panelMC.popupattackside.panel.bossDetail.panel.closeBtn, MouseEvent.CLICK, this.closeBossDetailPhaseOne);
            this.eventHandler.addListener(this.panelMC.popupattackside.panel.bossDetail.panel.attackShowFdListBtn, MouseEvent.CLICK, this.openInviteCrewMemberPhaseOne);
            this.panelMC.popupattackside.panel.bossDetail.panel.detailMc.nameTxt.text = "Myterious Foe";
            this.panelMC.popupattackside.panel.bossDetail.panel.detailMc.lvMc.lvLow.txt.text = this.bossData[0].bossLevel[0];
            this.panelMC.popupattackside.panel.bossDetail.panel.detailMc.lvMc.lvHigh.txt.text = this.bossData[0].bossLevel[1];
            this.panelMC.popupattackside.panel.bossDetail.panel.detailMc.decTxt.text = "Different mysterious creatures will attack the castle that endangered the village.";
        }

        private function openInviteCrewMemberPhaseOne(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            Crew.instance.getAttackers(this.onRecruitDataRes);
            this.panelMC.popupattackside.panel.bossDetail.panel.popupWarList.gotoAndStop("show");
            this.eventHandler.addListener(this.panelMC.popupattackside.panel.bossDetail.panel.popupWarList.panel.backPageBtn, MouseEvent.CLICK, this.closeInviteMemberRecruit);
            this.eventHandler.addListener(this.panelMC.popupattackside.panel.bossDetail.panel.popupWarList.panel.battleBtn, MouseEvent.CLICK, this.startPhaseOneBattle);
            this.eventHandler.addListener(this.panelMC.popupattackside.panel.bossDetail.panel.popupWarList.panel.prevPageBtn, MouseEvent.CLICK, this.changePageRecruit);
            this.eventHandler.addListener(this.panelMC.popupattackside.panel.bossDetail.panel.popupWarList.panel.nextPageBtn, MouseEvent.CLICK, this.changePageRecruit);
        }

        private function startPhaseOneBattle(_arg_1:MouseEvent):void
        {
            var _local_2:int = NumberUtil.randomInt(0, (this.bossData.length - 1));
            this.selectedEnemyIndex = _local_2;
            var _local_3:String = this.bossData[this.selectedEnemyIndex].bossId[0];
            var _local_4:* = {
                "b":NinjaSage.generateRandomString(22),
                "c":(int(this.selectedCastle) + 1),
                "t":new Date().time,
                "f":this.recruitedFriend,
                "e":_local_3
            };
            _local_4.h = Hex.fromArray(Crypto.getHash("md5").hash(Hex.toArray(Hex.fromString([Character.char_id, _local_4.b, _local_4.t, _local_4.c, _local_4.e].join("|")))));
            Crew.instance.startBattle(_local_4, this.startBattleResponse);
        }

        private function startBattleResponse(_arg_1:Object=null, _arg_2:*=null):void
        {
            var _local_3:int;
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("c"))))
            {
                Character.mission_id = this.bossData[this.selectedEnemyIndex].battleBackground;
                Character.is_crew_war = true;
                this.main.combat = this.main.loadPanel("Combat.Battle", true);
                BattleManager.init(this.main.combat, this.main, BattleVars.CREW_MATCH, Character.mission_id);
                BattleManager.addPlayerToTeam("player", ("char_" + Character.char_id));
                Crew.instance.setBattleData(_arg_1);
                Crew.instance.delayDestroy(true);
                if (((!(_arg_1.hasOwnProperty("f"))) || (_arg_1.f == null)))
                {
                    _arg_1.f = [];
                };
                this.recruitedFriend = _arg_1.f;
                Character.temp_recruit_ids = [];
                _local_3 = 0;
                while (_local_3 < _arg_1.f.length)
                {
                    Character.temp_recruit_ids.push(("char_" + this.recruitedFriend[_local_3]));
                    _local_3++;
                };
                _local_3 = 0;
                while (_local_3 < this.bossData[this.selectedEnemyIndex].bossId.length)
                {
                    BattleManager.addPlayerToTeam("enemy", this.bossData[this.selectedEnemyIndex].bossId[_local_3]);
                    _local_3++;
                };
                BattleManager.startBattle();
                this.crewVillage.destroy();
                this.destroy();
            };
        }

        private function closeBossDetailPhaseOne(_arg_1:MouseEvent):void
        {
            this.panelMC.popupattackside.panel.bossDetail.gotoAndStop("idle");
        }

        private function openPhaseTwoBattle():void
        {
            this.panelMC.popupattacksideph2.gotoAndStop("show");
            this.panelMC.popupattacksideph2.panel.popupReward.gotoAndStop("idle");
            this.panelMC.popupattacksideph2.panel.popupWarList.gotoAndStop("idle");
            var _local_1:MovieClip = this.panelMC.popupattacksideph2.panel;
            this.renderCastleInfo(_local_1);
            this.refreshCastle();
            _local_1.Btn_Rank.visible = false;
            _local_1.clanStatusMc.castleNameTxt.text = this.castleName[this.selectedCastle];
            if (this.role == 1)
            {
                _local_1.phase2fightBtn.visible = false;
            };
            _local_1.skipMC.tick.visible = Crew.instance.getSkipAnimation();
            this.eventHandler.addListener(_local_1.skipMC, MouseEvent.CLICK, this.onSkipAnimation);
            this.eventHandler.addListener(_local_1.closeBtn, MouseEvent.CLICK, this.closeBattlePopup);
            this.eventHandler.addListener(_local_1.phase2fightBtn, MouseEvent.CLICK, this.startAnimationPhaseTwo);
            this.eventHandler.addListener(_local_1.refreshBtn, MouseEvent.CLICK, this.refreshCastle);
            this.eventHandler.addListener(_local_1.rewardListBtn, MouseEvent.CLICK, this.openRewardCastle);
        }

        private function onSkipAnimation(_arg_1:MouseEvent):void
        {
            Crew.instance.setSkipAnimation((!(Crew.instance.getSkipAnimation())));
            this.panelMC.popupattacksideph2.panel.skipMC.tick.visible = Crew.instance.getSkipAnimation();
        }

        private function refreshCastle(_arg_1:MouseEvent=null):void
        {
            Crew.instance.getCastles(this.onRefreshCastle, this.castles[this.selectedCastle].id);
        }

        private function onRefreshCastle(_arg_1:*=null, _arg_2:*=null):*
        {
            if (((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("castles"))) && (!(_arg_1.castles == null))) && (_arg_1.castles.length > 0)))
            {
                this.castles[this.selectedCastle] = _arg_1.castles[0];
                this.renderCastleInfo(this.panelMC.popupattacksideph2.panel);
                this.renderCastleInfo(this.panelMC.popupdefendside.panel);
            };
        }

        private function renderCastleInfo(_arg_1:*):*
        {
            if (!_arg_1)
            {
                return;
            };
            _arg_1.clanStatusMc.nameTxt.text = this.castles[this.selectedCastle].owner_name;
            _arg_1.hpTxt.text = (this.castles[this.selectedCastle].wall_hp + " %");
            _arg_1.hpTxt2.text = (this.castles[this.selectedCastle].defender_hp + " %");
            _arg_1.wallHpBar.scaleX = (this.castles[this.selectedCastle].wall_hp / 100);
            _arg_1.wallHpBar2.scaleX = (this.castles[this.selectedCastle].defender_hp / 100);
        }

        private function openInviteCrewMemberPhaseTwo(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            Crew.instance.getAttackers(this.onRecruitDataRes);
            this.panelMC.popupattacksideph2.panel.popupWarList.gotoAndStop("show");
            this.eventHandler.addListener(this.panelMC.popupattacksideph2.panel.popupWarList.panel.backPageBtn, MouseEvent.CLICK, this.closeInviteMemberRecruit);
            this.eventHandler.addListener(this.panelMC.popupattacksideph2.panel.popupWarList.panel.battleBtn, MouseEvent.CLICK, this.startAnimationPhaseTwo);
            this.eventHandler.addListener(this.panelMC.popupattacksideph2.panel.popupWarList.panel.prevPageBtn, MouseEvent.CLICK, this.changePageRecruit);
            this.eventHandler.addListener(this.panelMC.popupattacksideph2.panel.popupWarList.panel.nextPageBtn, MouseEvent.CLICK, this.changePageRecruit);
        }

        private function startAnimationPhaseTwo(_arg_1:MouseEvent):void
        {
            if (this.charData.stamina < 10)
            {
                this.main.showMessage("Stamina is not enough");
                this.openStaminaPopup(null);
                return;
            };
            if (Crew.instance.getSkipAnimation())
            {
                this.sendBattlePhaseTwo();
                return;
            };
            this.panelMC.popuploading.gotoAndPlay("show");
        }

        private function sendBattlePhaseTwo():void
        {
            this.hideObjectDuringAnimation(true);
            var _local_1:* = {
                "c":this.castles[this.selectedCastle].id,
                "b":NinjaSage.generateRandomString(24)
            };
            _local_1["t"] = int((new Date().getTime() / 1000));
            _local_1["h"] = Hex.fromArray(Crypto.getHash("md5").hash(Hex.toArray(Hex.fromString([Character.char_id, _local_1.b, _local_1.t, _local_1.c].join("|")))));
            Crew.instance.startBattle(_local_1, this.onBattleResult);
        }

        private function onBattleResult(_arg_1:*=null, _arg_2:*=null):void
        {
            if (((!(_arg_1 == null)) && (Boolean(_arg_1.hasOwnProperty("b")))))
            {
                this.panelMC.popupResult.gotoAndStop("show");
                this.eventHandler.addListener(this.panelMC.popupResult.panel.okBtn, MouseEvent.CLICK, this.closeBattleResult);
                this.panelMC.popupResult.panel.lbl_battle_result.text = "Battle Result";
                this.panelMC.popupResult.panel.lbl_win.text = "Win";
                this.panelMC.popupResult.panel.lbl_lose.text = "Lose";
                this.panelMC.popupResult.panel.winClanTxt.text = _arg_1.w;
                this.panelMC.popupResult.panel.loseClanTxt.text = _arg_1.l;
                this.panelMC.popupResult.panel.loseTotalRepTxt.text = ("Attack Damage: " + _arg_1.d);
                this.panelMC.popupResult.panel.getMeritTxt.text = ("Merit Obtained: " + _arg_1.m);
                this.charData.stamina = _arg_1.s;
                this.initStatusDisplay();
            }
            else
            {
                this.panelMC.popupResult.gotoAndStop("idle");
                if (((!(_arg_1 == null)) && (Boolean(_arg_1.hasOwnProperty("code")))))
                {
                    if (_arg_1.code == 402)
                    {
                        this.main.showMessage("Stamina is not enough");
                        this.openStaminaPopup(null);
                    }
                    else
                    {
                        if (_arg_1.code == 406)
                        {
                            this.main.getNotice("The castle has been taken over by your crew.");
                        }
                        else
                        {
                            this.main.getNotice((("Battle failed:" + "\n") + _arg_1.errorMessage));
                        };
                    };
                }
                else
                {
                    this.main.getNotice(("Battle failed.\n" + _arg_2));
                };
            };
            this.refreshCastle();
        }

        private function hideObjectDuringAnimation(_arg_1:Boolean=false):void
        {
            this.panelMC.popupattacksideph2.visible = _arg_1;
            this.panelMC.clanStatusMc.visible = _arg_1;
            this.panelMC.bg.visible = _arg_1;
            this.panelMC.miniGameBtn.visible = _arg_1;
            this.panelMC.rewardListHomeBtn.visible = _arg_1;
            this.panelMC.backBtn.visible = _arg_1;
            this.panelMC.status.visible = _arg_1;
            this.panelMC.popupNotification.visible = _arg_1;
            var _local_2:int;
            while (_local_2 < 7)
            {
                this.panelMC[("clan_btn_" + _local_2)].visible = _arg_1;
                _local_2++;
            };
        }

        private function closeBattleAnimation():void
        {
            this.panelMC.popuploading.gotoAndStop("idle");
        }

        private function closeBattleResult(_arg_1:MouseEvent):void
        {
            this.panelMC.popupResult.gotoAndStop("idle");
        }

        private function closeBattlePopup(_arg_1:MouseEvent):void
        {
            this.panelMC.popupattackside.gotoAndStop("idle");
            this.panelMC.popupattacksideph2.gotoAndStop("idle");
        }

        private function onGetDefendData(_arg_1:Object, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                if (_arg_1.code == 429)
                {
                    this.main.showMessage(_arg_1.errorMessage);
                }
                else
                {
                    this.main.getNotice(_arg_1.errorMessage);
                };
                this.refreshCastle();
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("statusCode"))))
            {
                this.main.getNotice(("Error Code: " + _arg_1.statusCode));
                this.refreshCastle();
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("defenders"))))
            {
                this.defendingData = _arg_1.defenders;
                this.currentPage = 1;
                this.totalPage = Math.max(Math.ceil((this.defendingData.length / 10)), 1);
                this.openPhaseTwoDefend();
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getNotice("Unable to get castle defenders");
                return;
            };
        }

        private function openPhaseTwoDefend():void
        {
            if (this.castles[this.selectedCastle].owner_id != this.crewData.id)
            {
                this.main.showMessage("This castle has been taken over");
                this.closePhaseTwoDefend(null);
                return;
            };
            this.panelMC.popupdefendside.gotoAndStop("show");
            this.panelMC.popupdefendside.panel.popupReward.gotoAndStop("idle");
            this.panelMC.popupdefendside.panel.popupRecovery.gotoAndStop("idle");
            var _local_1:MovieClip = this.panelMC.popupdefendside.panel;
            _local_1.DefendThisBtn.visible = false;
            this.eventHandler.addListener(_local_1.closeBtn, MouseEvent.CLICK, this.closePhaseTwoDefend);
            this.eventHandler.addListener(_local_1.recoveryBtn, MouseEvent.CLICK, this.getRecoveryData);
            this.eventHandler.addListener(_local_1.defendrewardListBtn, MouseEvent.CLICK, this.openRewardCastle);
            this.eventHandler.addListener(_local_1.nextPageBtn, MouseEvent.CLICK, this.changePageMember);
            this.eventHandler.addListener(_local_1.prevPageBtn, MouseEvent.CLICK, this.changePageMember);
            this.eventHandler.addListener(_local_1.refreshBtn, MouseEvent.CLICK, this.refreshDefender);
            _local_1.clanStatusMc.nameTxt.text = this.castles[this.selectedCastle].owner_name;
            _local_1.clanStatusMc.numTxt.text = ((this.defendingData.length + " / ") + this.crewData.max_members);
            this.renderCastleInfo(_local_1);
            this.refreshCastle();
            _local_1.AttackerToDefBtn.change.gotoAndStop(this.role);
            if ((("role_limit_at" in this.charData) && (!(this.charData.role_limit_at == ""))))
            {
                _local_1.timer.visible = true;
                _local_1.timer.timeTxt.text = this.charData.role_limit_at;
                _local_1.AttackerToDefBtn.visible = false;
            }
            else
            {
                _local_1.timer.visible = false;
                _local_1.AttackerToDefBtn.visible = true;
                this.main.initButton(_local_1.AttackerToDefBtn, this.switchRoleConfirmation, "");
            };
            this.renderCrewMember();
        }

        private function refreshDefender(_arg_1:MouseEvent):void
        {
            Crew.instance.getDefenders(this.castles[this.selectedCastle].id, this.onGetDefendData);
        }

        private function getRecoveryData(_arg_1:MouseEvent):void
        {
            this.main.loading(true);
            Crew.instance.getRecoverLifeBar(this.castles[this.selectedCastle].id, {"t":int((new Date().time / 1000))}, this.onRecoveryData);
        }

        private function onRecoveryData(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("n"))))
            {
                Character.account_tokens = _arg_1.t;
                this.initStatusDisplay();
                this.openRecovery(_arg_1);
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getError("Unknown erorr");
                return;
            };
        }

        private function openRecovery(_arg_1:Object):void
        {
            this.panelMC.popupdefendside.panel.popupRecovery.gotoAndStop("show");
            var _local_2:MovieClip = this.panelMC.popupdefendside.panel.popupRecovery.panel;
            this.eventHandler.addListener(_local_2.closeBtn, MouseEvent.CLICK, this.closeRecovery);
            NinjaSage.showDynamicTooltip(_local_2.recoverytime, (("Claimable every 30 mins to recover " + _arg_1.a) + " life bar"));
            NinjaSage.showDynamicTooltip(_local_2.item, (((("Use Vitality Gourd to recover your life bar. " + this.RECOVER_PRICE_GOURD) + " gourd for ") + this.RECOVER_LIFE_GOURD) + " Life bar"));
            NinjaSage.showDynamicTooltip(_local_2.token, (((("Use Token to recover your life bar. " + this.RECOVER_PRICE_TOKEN) + " tokens for ") + this.RECOVER_LIFE_TOKEN) + " Life bar"));
            _local_2.hpTxt.text = (this.castles[this.selectedCastle].wall_hp + " %");
            _local_2.wallHpBar.scaleX = (this.castles[this.selectedCastle].wall_hp / 100);
            this.n = _arg_1.n;
            if (_arg_1.f != "")
            {
                _local_2.timeTxt.text = _arg_1.f;
                this.main.initButtonDisable(_local_2.btn_restore, this.recoverWall, "Claim");
            }
            else
            {
                _local_2.timeTxt.text = "Claimable";
                this.main.initButton(_local_2.btn_restore, this.recoverWall, "Claim");
            };
            _local_2.refillAllNum.text = ("Owned: x" + _arg_1.g);
            if (_arg_1.g > 0)
            {
                this.main.initButton(_local_2.btn_useItem, this.recoverWall, "Use");
            }
            else
            {
                this.main.initButtonDisable(_local_2.btn_useItem, this.recoverWall, "Use");
            };
            if (_arg_1.t >= this.RECOVER_PRICE_TOKEN)
            {
                this.main.initButton(_local_2.btn_token, this.recoverWall, (("Use " + this.RECOVER_PRICE_TOKEN) + "T"));
            }
            else
            {
                this.main.initButtonDisable(_local_2.btn_token, this.recoverWall, (("Use " + this.RECOVER_PRICE_TOKEN) + "T"));
            };
        }

        private function recoverWall(_arg_1:MouseEvent):void
        {
            var _local_2:* = String(_arg_1.currentTarget.name).replace("btn_", "");
            this.main.loading(true);
            _local_2 = ((_local_2 == "restore") ? 1 : ((_local_2 == "token") ? 3 : 2));
            var _local_3:* = int((new Date().time / 1000));
            Crew.instance.recoverCastle(this.castles[this.selectedCastle].id, {
                "r":_local_2,
                "t":_local_3,
                "h":Hex.fromArray(Crypto.getHash("md5").hash(Hex.toArray(Hex.fromString([Character.char_id, _local_2, _local_3, this.n].join("|")))))
            }, this.onWallHpRecovered);
        }

        private function onWallHpRecovered(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                if (_arg_1.code == 429)
                {
                    this.main.showMessage(_arg_1.errorMessage);
                }
                else
                {
                    this.main.getNotice(_arg_1.errorMessage);
                };
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("a"))))
            {
                this.main.showMessage("Wall successfully recovered, it should increase shortly");
                this.castles[this.selectedCastle].wall_hp = _arg_1.w;
                this.getRecoveryData(null);
                this.renderCastleInfo(this.panelMC.popupdefendside.panel);
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getNotice("Unable to recover wall");
                return;
            };
        }

        private function closeRecovery(_arg_1:MouseEvent):void
        {
            this.panelMC.popupdefendside.panel.popupRecovery.gotoAndStop("idle");
            this.refreshDefender(_arg_1);
        }

        private function renderCrewMember():void
        {
            var _local_1:int;
            var _local_2:MovieClip = this.panelMC.popupdefendside.panel;
            var _local_3:int;
            while (_local_3 < 10)
            {
                _local_1 = (_local_3 + int((int((this.currentPage - 1)) * 10)));
                _local_2[("member_" + _local_3)].visible = false;
                _local_2[("member_" + _local_3)].gotoAndStop(1);
                if (this.defendingData.length > _local_1)
                {
                    _local_2[("member_" + _local_3)].visible = true;
                    _local_2[("member_" + _local_3)].nameTxt.text = ((("[" + this.defendingData[_local_1].id) + "] ") + this.defendingData[_local_1].name);
                    _local_2[("member_" + _local_3)].levelTxt.text = this.defendingData[_local_1].level;
                    _local_2[("member_" + _local_3)].staminaTxt.text = this.defendingData[_local_1].hp;
                };
                _local_3++;
            };
            this.updatePageMember();
        }

        private function changePageMember(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "nextPageBtn":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.renderCrewMember();
                    };
                    return;
                case "prevPageBtn":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.renderCrewMember();
                    };
            };
        }

        private function updatePageMember():void
        {
            var _local_1:MovieClip = this.panelMC.popupdefendside.panel;
            _local_1.pageTxt.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function switchRoleConfirmation(_arg_1:MouseEvent):void
        {
            this.confirmation = new Confirmation();
            this.confirmation.txtMc.txt.text = "Are you sure that you want to change role for this castle?";
            this.eventHandler.addListener(this.confirmation.btn_close, MouseEvent.CLICK, this.closeSwitchRoleConfirmation);
            this.eventHandler.addListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.switchRole);
            this.panelMC.addChild(this.confirmation);
        }

        private function closeSwitchRoleConfirmation(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.confirmation);
            this.confirmation.txtMc.txt.text = "";
            this.eventHandler.removeListener(this.confirmation.btn_close, MouseEvent.CLICK, this.closeSwitchRoleConfirmation);
            this.eventHandler.removeListener(this.confirmation.btn_confirm, MouseEvent.CLICK, this.switchRole);
            this.confirmation = null;
        }

        private function switchRole(_arg_1:MouseEvent):void
        {
            this.closeSwitchRoleConfirmation(null);
            this.main.loading(true);
            Crew.instance.switchRole(this.castles[this.selectedCastle].id, this.onSwitchedRole);
        }

        private function onSwitchedRole(_arg_1:Object, _arg_2:*=null):*
        {
            var _local_3:MovieClip;
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (_arg_1 == "ok")
            {
                this.role = ((this.role == 1) ? 2 : 1);
                _local_3 = this.panelMC.popupdefendside.panel;
                _local_3.AttackerToDefBtn.visible = false;
                this.updateRoleIcon();
                this.main.showMessage("Successfully changed your role.");
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getNotice(("Unable to switch role\n" + _arg_2));
                return;
            };
        }

        private function closePhaseTwoDefend(_arg_1:MouseEvent):void
        {
            this.panelMC.popupdefendside.gotoAndStop("idle");
        }

        private function onRecruitDataRes(_arg_1:Object, _arg_2:*=null):*
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("statusCode"))))
            {
                this.main.getNotice(("Error Code: " + _arg_1.statusCode));
                return;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("members"))))
            {
                this.recruitData = ((!(_arg_1.members)) ? [] : _arg_1.members);
                this.currentPage = 1;
                this.totalPage = Math.max(Math.ceil((this.recruitData.length / 10)), 1);
                this.renderRecruitData();
                return;
            };
            if (_arg_2 != null)
            {
                this.main.getNotice("Unable to get crew attackers");
                return;
            };
        }

        private function renderRecruitData():void
        {
            var _local_1:int;
            var _local_2:int;
            var _local_3:MovieClip = ((Crew.instance.getPhase() == 1) ? this.panelMC.popupattackside.panel.bossDetail.panel : this.panelMC.popupattacksideph2.panel);
            this.resetSelectedRecruitMember();
            var _local_4:int;
            while (_local_4 < 10)
            {
                _local_1 = (_local_4 + int((int((this.currentPage - 1)) * 10)));
                _local_3.popupWarList.panel[("member_" + _local_4)].visible = false;
                if (this.recruitData.length > _local_1)
                {
                    _local_3.popupWarList.panel[("member_" + _local_4)].visible = true;
                    _local_3.popupWarList.panel[("member_" + _local_4)].nameTxt.text = ((("[" + this.recruitData[_local_1].char_id) + "] ") + this.recruitData[_local_1].name);
                    _local_3.popupWarList.panel[("member_" + _local_4)].levelTxt.text = this.recruitData[_local_1].level;
                    _local_3.popupWarList.panel[("member_" + _local_4)].staminaTxt.text = this.recruitData[_local_1].stamina;
                    _local_3.popupWarList.panel[("member_" + _local_4)].buttonMode = true;
                    _local_3.popupWarList.panel[("member_" + _local_4)].metaData = {"charId":this.recruitData[_local_1].char_id};
                    this.eventHandler.addListener(_local_3.popupWarList.panel[("member_" + _local_4)], MouseEvent.CLICK, this.selectRecruitMember);
                    _local_2 = 0;
                    while (_local_2 < this.recruitedFriend.length)
                    {
                        if (this.recruitedFriend[_local_2] == this.recruitData[_local_1].char_id)
                        {
                            _local_3.popupWarList.panel[("member_" + _local_4)].gotoAndStop("selected");
                        };
                        _local_2++;
                    };
                };
                _local_4++;
            };
            this.updatePageRecruit();
        }

        private function selectRecruitMember(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            var _local_3:int = int(_arg_1.currentTarget.name.replace("member_", ""));
            var _local_4:int = int(_arg_1.currentTarget.metaData.charId);
            var _local_5:MovieClip = ((Crew.instance.getPhase() == 1) ? this.panelMC.popupattackside.panel.bossDetail.panel : this.panelMC.popupattacksideph2.panel);
            if (this.recruitedFriend.length >= 1)
            {
                _local_2 = 0;
                while (_local_2 < this.recruitedFriend.length)
                {
                    if (this.recruitedFriend[_local_2] == _local_4)
                    {
                        this.recruitedFriend.splice(_local_2, 1);
                        _local_5.popupWarList.panel[("member_" + _local_3)].gotoAndStop("idle");
                        this.updateTotalRecruited();
                        return;
                    };
                    _local_2++;
                };
            };
            if (this.recruitedFriend.length >= 2)
            {
                this.main.getNotice("You can only recruit up to 2 friends");
                return;
            };
            _local_5.popupWarList.panel[("member_" + _local_3)].gotoAndStop("selected");
            this.recruitedFriend.push(_local_4);
            this.updateTotalRecruited();
        }

        private function resetSelectedRecruitMember():void
        {
            var _local_1:MovieClip = ((Crew.instance.getPhase() == 1) ? this.panelMC.popupattackside.panel.bossDetail.panel : this.panelMC.popupattacksideph2.panel);
            var _local_2:int;
            while (_local_2 < 10)
            {
                _local_1.popupWarList.panel[("member_" + _local_2)].gotoAndStop("idle");
                _local_2++;
            };
        }

        private function changePageRecruit(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "nextPageBtn":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.renderRecruitData();
                    };
                    return;
                case "prevPageBtn":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.renderRecruitData();
                    };
            };
        }

        private function updateTotalRecruited():void
        {
            var _local_1:MovieClip = ((Crew.instance.getPhase() == 1) ? this.panelMC.popupattackside.panel.bossDetail.panel : this.panelMC.popupattacksideph2.panel);
            _local_1.popupWarList.panel.txt_memberRecruited.text = (this.recruitedFriend.length + "/2");
        }

        private function updatePageRecruit():void
        {
            var _local_1:MovieClip = ((Crew.instance.getPhase() == 1) ? this.panelMC.popupattackside.panel.bossDetail.panel : this.panelMC.popupattacksideph2.panel);
            _local_1.popupWarList.panel.pageTxt.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function closeInviteMemberRecruit(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = ((Crew.instance.getPhase() == 1) ? this.panelMC.popupattackside.panel.bossDetail.panel : this.panelMC.popupattacksideph2.panel);
            this.recruitedFriend = [];
            this.resetSelectedRecruitMember();
            this.updatePageRecruit();
            _local_2.popupWarList.gotoAndStop("idle");
        }

        private function openRankingPhaseOne(_arg_1:MouseEvent):void
        {
            this.panelMC.popupattackside.panel.rankList.gotoAndStop("show");
            this.main.loading(true);
            Crew.instance.getCrewRanks((this.selectedCastle + 1), this.onGetRankingList);
            var _local_2:MovieClip = this.panelMC.popupattackside.panel.rankList.panel;
            this.eventHandler.addListener(_local_2.closeBtn, MouseEvent.CLICK, this.closeRankingPhaseOne);
            this.eventHandler.addListener(_local_2.prevPageBtn, MouseEvent.CLICK, this.changePageRanking);
            this.eventHandler.addListener(_local_2.nextPageBtn, MouseEvent.CLICK, this.changePageRanking);
        }

        private function onGetRankingList(_arg_1:*, _arg_2:*=null):void
        {
            this.main.loading(false);
            if (((!(_arg_1 == null)) && (Boolean(_arg_1.hasOwnProperty("crews")))))
            {
                this.rankingData = ((_arg_1.crews == null) ? [] : _arg_1.crews);
                this.currentPage = 1;
                this.totalPage = Math.max(Math.ceil((_arg_1.total / 9)), 1);
                this.renderRankingData();
                return;
            };
            if (((!(_arg_1 == null)) && (Boolean(_arg_1.hasOwnProperty("errorMessage")))))
            {
                this.main.getNotice(("Server Error: " + _arg_1.errorMessage));
                return;
            };
            this.main.getError("unknown error");
        }

        private function renderRankingData():void
        {
            var _local_1:int;
            var _local_2:MovieClip = this.panelMC.popupattackside.panel.rankList.panel;
            var _local_3:int;
            while (_local_3 < 9)
            {
                _local_1 = (_local_3 + int((int((this.currentPage - 1)) * 9)));
                _local_2[("clan_" + _local_3)].visible = false;
                _local_2[("clan_" + _local_3)].gotoAndStop(1);
                if (this.rankingData.length > _local_1)
                {
                    _local_2[("clan_" + _local_3)].visible = true;
                    _local_2[("clan_" + _local_3)].idTxt.text = this.rankingData[_local_1].id;
                    _local_2[("clan_" + _local_3)].nameTxt.text = this.rankingData[_local_1].name;
                    _local_2[("clan_" + _local_3)].totalMemberTxt.text = ((this.rankingData[_local_1].total_members + "/") + this.rankingData[_local_1].max_members);
                    _local_2[("clan_" + _local_3)].reputationTxt.text = this.rankingData[_local_1].boss_killed;
                };
                _local_3++;
            };
            this.updatePageRanking();
        }

        private function changePageRanking(_arg_1:MouseEvent):void
        {
            switch (_arg_1.currentTarget.name)
            {
                case "nextPageBtn":
                    if (this.totalPage > this.currentPage)
                    {
                        this.currentPage++;
                        this.renderRankingData();
                    };
                    return;
                case "prevPageBtn":
                    if (this.currentPage > 1)
                    {
                        this.currentPage--;
                        this.renderRankingData();
                    };
            };
        }

        private function updatePageRanking():void
        {
            var _local_1:MovieClip = this.panelMC.popupattackside.panel.rankList.panel;
            _local_1.pageTxt.text = ((this.currentPage + "/") + this.totalPage);
        }

        private function closeRankingPhaseOne(_arg_1:MouseEvent):void
        {
            this.panelMC.popupattackside.panel.rankList.gotoAndStop("idle");
            this.currentPage = 1;
            this.totalPage = 1;
        }

        private function openRewardCastle(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = ((Crew.instance.getPhase() == 1) ? this.panelMC.popupattackside.panel : ((this.crewData.id == this.castles[this.selectedCastle].owner_id) ? this.panelMC.popupdefendside.panel : this.panelMC.popupattacksideph2.panel));
            _local_2.popupReward.gotoAndStop("show");
            this.eventHandler.addListener(_local_2.popupReward.panel.closeBtn, MouseEvent.CLICK, this.closeRewardCastle);
            this.eventHandler.addListener(_local_2.popupReward.panel.okBtn, MouseEvent.CLICK, this.closeRewardCastle);
            _local_2.popupReward.panel.rewardTxt.text = (this.castleName[this.selectedCastle] + " Reward");
            var _local_3:String = ((Crew.instance.getPhase() == 1) ? String(this.crewVillage.rewardData.phase_1[0]) : String(this.castles[this.selectedCastle].reward));
            NinjaSage.loadItemIcon(_local_2.popupReward.panel.IconMc_0, _local_3);
        }

        private function closeRewardCastle(_arg_1:MouseEvent):void
        {
            var _local_2:MovieClip = ((Crew.instance.getPhase() == 1) ? this.panelMC.popupattackside.panel : ((this.crewData.id == this.castles[this.selectedCastle].owner_id) ? this.panelMC.popupdefendside.panel : this.panelMC.popupattacksideph2.panel));
            this.eventHandler.removeListener(_local_2.popupReward.panel.closeBtn, MouseEvent.CLICK, this.closeRewardCastle);
            this.eventHandler.removeListener(_local_2.popupReward.panel.okBtn, MouseEvent.CLICK, this.closeRewardCastle);
            GF.removeAllChild(_local_2.popupReward.panel.IconMc_0.rewardIcon.iconHolder);
            GF.removeAllChild(_local_2.popupReward.panel.IconMc_0.skillIcon.iconHolder);
            _local_2.popupReward.gotoAndStop("idle");
        }

        private function openRewardListHome(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            this.panelMC.popupRewardHome.gotoAndStop("show");
            this.eventHandler.addListener(this.panelMC.popupRewardHome.panel.closeBtn, MouseEvent.CLICK, this.closeRewardListHome);
            _local_2 = 0;
            while (_local_2 < this.crewVillage.rewardData.phase_1.length)
            {
                NinjaSage.loadItemIcon(this.panelMC.popupRewardHome.panel[("IconMc0_" + _local_2)], this.crewVillage.rewardData.phase_1[_local_2]);
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < this.crewVillage.rewardData.phase_2.length)
            {
                NinjaSage.loadItemIcon(this.panelMC.popupRewardHome.panel[("IconMc_" + _local_2)], this.crewVillage.rewardData.phase_2[_local_2]);
                _local_2++;
            };
        }

        private function closeRewardListHome(_arg_1:MouseEvent):void
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < this.crewVillage.rewardData.phase_1.length)
            {
                GF.removeAllChild(this.panelMC.popupRewardHome.panel[("IconMc0_" + _local_2)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.popupRewardHome.panel[("IconMc0_" + _local_2)].skillIcon.iconHolder);
                _local_2++;
            };
            _local_2 = 0;
            while (_local_2 < this.crewVillage.rewardData.phase_2.length)
            {
                GF.removeAllChild(this.panelMC.popupRewardHome.panel[("IconMc_" + _local_2)].rewardIcon.iconHolder);
                GF.removeAllChild(this.panelMC.popupRewardHome.panel[("IconMc_" + _local_2)].skillIcon.iconHolder);
                _local_2++;
            };
            this.eventHandler.removeListener(this.panelMC.popupRewardHome.panel.closeBtn, MouseEvent.CLICK, this.closeMinigamePopup);
            this.eventHandler.removeListener(this.panelMC.popupRewardHome.panel.claimBtn, MouseEvent.CLICK, this.closeMinigamePopup);
            this.panelMC.popupRewardHome.gotoAndStop("idle");
        }

        private function openLastSeasonReward(_arg_1:MouseEvent):void
        {
            Crew.instance.getLastSeasonRewards(this.onSeasonReward);
        }

        private function onSeasonReward(_arg_1:*, _arg_2:*=null):void
        {
            var _local_3:MovieClip;
            if (((!(_arg_1 == null)) && (Boolean(_arg_1.hasOwnProperty("errorMessage")))))
            {
                this.main.getNotice(("Server Error: " + _arg_1.errorMessage));
                return;
            };
            if (((!(_arg_1 == null)) && (Boolean(_arg_1.hasOwnProperty("c")))))
            {
                this.seasonRewardData = _arg_1;
                this.panelMC.lastpopupRewardHome.gotoAndStop("show");
                _local_3 = this.panelMC.lastpopupRewardHome.panel;
                this.eventHandler.addListener(_local_3.closeBtn, MouseEvent.CLICK, this.closeLastSeasonReward);
                this.renderSeasonReward();
                return;
            };
        }

        private function renderSeasonReward():void
        {
            var _local_1:MovieClip = this.panelMC.lastpopupRewardHome.panel;
            _local_1.titleTxt.text = (("Season " + this.seasonRewardData.s) + " Rewards");
            _local_1.titleTxt1.text = "Phase 1 Owner Reward";
            _local_1.titleTxt2.text = "Phase 2 Castle Reward";
            _local_1.prevPageBtn.visible = false;
            _local_1.nextPageBtn.visible = false;
            _local_1.pageTxt.visible = false;
            NinjaSage.loadItemIcon(_local_1.icon, this.seasonRewardData.r.phase1[0]);
            var _local_2:int;
            while (_local_2 < this.castleName.length)
            {
                _local_1[("name_" + _local_2)].text = this.seasonRewardData.c[_local_2].name;
                _local_1[("owner_" + _local_2)].text = this.seasonRewardData.c[_local_2].owner_p2_name;
                NinjaSage.loadItemIcon(_local_1[("icon_" + _local_2)], this.seasonRewardData.c[_local_2].reward);
                _local_2++;
            };
        }

        private function closeLastSeasonReward(_arg_1:MouseEvent):void
        {
            this.eventHandler.removeListener(this.panelMC.lastpopupRewardHome.panel.closeBtn, MouseEvent.CLICK, this.closeLastSeasonReward);
            this.panelMC.lastpopupRewardHome.gotoAndStop("idle");
        }

        private function openMinigamePopup(_arg_1:MouseEvent):void
        {
            this.panelMC.popupMiniGame.gotoAndStop("show");
            this.eventHandler.addListener(this.panelMC.popupMiniGame.panel.closeBtn, MouseEvent.CLICK, this.closeMinigamePopup);
            this.eventHandler.addListener(this.panelMC.popupMiniGame.panel.claimBtn, MouseEvent.CLICK, this.startMiniGame);
            NinjaSage.loadItemIcon(this.panelMC.popupMiniGame.panel.IconMc_0, this.crewVillage.minigameRewardData[0]);
            NinjaSage.loadItemIcon(this.panelMC.popupMiniGame.panel.IconMc_1, this.crewVillage.minigameRewardData[1]);
        }

        private function startMiniGame(_arg_1:MouseEvent):void
        {
            this.loaderSwf.add("swfpanels/CrewMiniGame.swf", {"id":"CrewMiniGame"});
            this.loaderSwf.addEventListener(BulkLoader.COMPLETE, this.onCrewMiniGameLoaded);
            this.loaderSwf.start();
            this.closeMinigamePopup(null);
        }

        private function onCrewMiniGameLoaded(_arg_1:Event):*
        {
            this.loaderSwf.removeEventListener(BulkLoader.COMPLETE, this.onCrewMiniGameLoaded);
            var _local_2:Class = (this.loaderSwf.getContent("CrewMiniGame").loaderInfo.applicationDomain.getDefinition("CrewMiniGame") as Class);
            var _local_3:MovieClip = new (_local_2)();
            var _local_4:Class = (getDefinitionByName("id.ninjasage.features.CrewMiniGame") as Class);
            var _local_5:MovieClip = new _local_4(this, _local_3);
            this.main.loader.addChild(_local_3);
            this.loaderSwf.removeAll();
        }

        private function closeMinigamePopup(_arg_1:MouseEvent):void
        {
            GF.removeAllChild(this.panelMC.popupMiniGame.panel.IconMc_0.rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupMiniGame.panel.IconMc_0.skillIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupMiniGame.panel.IconMc_1.rewardIcon.iconHolder);
            GF.removeAllChild(this.panelMC.popupMiniGame.panel.IconMc_1.skillIcon.iconHolder);
            this.eventHandler.removeListener(this.panelMC.popupMiniGame.panel.closeBtn, MouseEvent.CLICK, this.closeMinigamePopup);
            this.eventHandler.removeListener(this.panelMC.popupMiniGame.panel.claimBtn, MouseEvent.CLICK, this.closeMinigamePopup);
            this.panelMC.popupMiniGame.gotoAndStop("idle");
        }

        public function initStatusDisplay():void
        {
            this.panelMC.clanStatusMc.extraTimeMc.visible = false;
            this.panelMC.clanStatusMc.nameTxt.text = Character.character_name;
            this.panelMC.clanStatusMc.lbl_level.text = "Level";
            this.panelMC.clanStatusMc.levelTxt.text = Character.character_lvl;
            this.panelMC.clanStatusMc.goldTxt.text = Character.character_gold;
            this.panelMC.clanStatusMc.tokenTxt.text = Character.account_tokens;
            this.panelMC.clanStatusMc.hpTxt.text = ((StatManager.calculate_stats_with_data("hp") + "/") + StatManager.calculate_stats_with_data("hp"));
            this.panelMC.clanStatusMc.cpTxt.text = ((StatManager.calculate_stats_with_data("cp") + "/") + StatManager.calculate_stats_with_data("cp"));
            this.panelMC.clanStatusMc.staminaTxt.text = ((this.charData.stamina + "/") + this.charData.max_stamina);
            this.panelMC.clanStatusMc.staminaBar.scaleX = (this.charData.stamina / this.charData.max_stamina);
            this.panelMC.clanStatusMc.meritTxt.text = ((this.charData.merit) || (0));
            this.panelMC.clanStatusMc.rollTxt.text = Character.getMaterialAmount(this.crewVillage.GOLDEN_ONIGIRI);
            this.panelMC.clanStatusMc.timeTxt.text = (("+" + int((30 + (this.crewData.kushi_dango * 10)))) + "/30 min");
            this.panelMC.clanStatusMc.PhaseTxt.text = ("Phase " + Crew.instance.getPhase());
        }

        private function initPlayerHead():void
        {
            var _local_1:MovieClip = this.main.getPlayerHead();
            GF.removeAllChild(this.panelMC.clanStatusMc.headHolder);
            this.panelMC.clanStatusMc.headHolder.addChild(_local_1);
        }

        private function updateTimeleft():void
        {
            if (this.timeout)
            {
                clearTimeout(this.timeout);
                this.timeout = null;
            };
            if (this.destroyed)
            {
                if (this.timeout)
                {
                    clearTimeout(this.timeout);
                };
                this.timeout = null;
                return;
            };
            if (this.crewTimestamp == null)
            {
                return;
            };
            var _local_1:int = this.crewTimestamp;
            var _local_2:int = int(Math.floor((_local_1 / 86400)));
            var _local_3:int = int(Math.floor(((_local_1 - (_local_2 * 86400)) / 3600)));
            var _local_4:int = int(Math.floor((((_local_1 - (_local_2 * 86400)) - (_local_3 * 3600)) / 60)));
            if (_local_4 >= 30)
            {
                this.panelMC.clanStatusMc.timer_StaRecover.gotoAndStop((60 - _local_4));
            }
            else
            {
                this.panelMC.clanStatusMc.timer_StaRecover.gotoAndStop((30 - _local_4));
            };
            this.panelMC.clanStatusMc.dayTxt.text = _local_2;
            this.panelMC.clanStatusMc.hourTxt.text = _local_3;
            this.panelMC.clanStatusMc.minTxt.text = _local_4;
            this.crewTimestamp = (this.crewTimestamp - 5);
            Crew.instance.getStamina(this.onGetStamina);
            Crew.instance.getCastles(this.onInitCastle);
        }

        public function onGetStamina(_arg_1:Object, _arg_2:*=null):void
        {
            if (this.timeout)
            {
                clearTimeout(this.timeout);
                this.timeout = null;
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("char"))))
            {
                Character.crew_char_data = _arg_1.char;
                this.charData = _arg_1.char;
                this.role = _arg_1.char.role;
                this.crewTimestamp = _arg_1.season.timestamp;
                this.updateRoleIcon();
                this.panelMC.clanStatusMc.staminaTxt.text = ((this.charData.stamina + "/") + this.charData.max_stamina);
                this.panelMC.clanStatusMc.staminaBar.scaleX = (this.charData.stamina / this.charData.max_stamina);
                this.timeout = setTimeout(this.updateTimeleft, 5000);
            };
            if ((((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("season"))) && (!(_arg_1.season == null))))
            {
                Crew.instance.setPhase(_arg_1.season.phase);
            };
            if (((!(_arg_1 == null)) && (_arg_1.hasOwnProperty("errorMessage"))))
            {
                this.main.getNotice(_arg_1.errorMessage);
                return;
            };
            if (_arg_2 != null)
            {
                this.main.showMessage("Unable to get stamina");
                return;
            };
        }

        private function openRecharge(_arg_1:MouseEvent):void
        {
            this.main.loadPanel("Panels.Recharge");
        }

        private function closePanel(_arg_1:MouseEvent):void
        {
            this.crewVillage.panelMC.visible = true;
            this.crewVillage.initStatusDisplay();
            this.crewVillage.initPlayerHead();
            this.crewVillage.getMiniGameData();
            this.crewVillage.updateTimeleft();
            this.destroy();
        }

        public function destroy():*
        {
            if (this.destroyed)
            {
                return;
            };
            this.destroyed = true;
            if (this.timeout)
            {
                clearTimeout(this.timeout);
            };
            this.panelMC.popuploading.addFrameScript(8, null, 92, null, 102, null);
            TweenLite.killTweensOf(this.panelMC.popupNotification);
            this.loaderSwf.clear();
            this.eventHandler.removeAllEventListeners();
            NinjaSage.clearLoader();
            NinjaSage.clearEventListener();
            this.main = null;
            this.timeout = null;
            this.eventHandler = null;
            this.crewVillage = null;
            this.loaderSwf = null;
            GF.removeAllChild(this.panelMC);
            this.panelMC = null;
        }


    }
}//package id.ninjasage.features

