// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//id.ninjasage.pvp.battle.PvPSkillHandler

package id.ninjasage.pvp.battle
{
    import id.ninjasage.multiplayer.battle.base.SkillHandlerBase;
    import flash.display.MovieClip;
    import flash.geom.Point;

    public class PvPSkillHandler extends SkillHandlerBase 
    {

        public function PvPSkillHandler(_arg_1:MovieClip, _arg_2:String, _arg_3:int, _arg_4:Object)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, PvPBattleVars.SKILL_SCALE);
        }

        override public function handleHitAnimation():void
        {
            PvPBattleManager.BATTLE_HANDLER.handleHit();
        }

        override public function handleEndAnimation():void
        {
            PvPBattleManager.BATTLE_HANDLER.handleSkillFinished(this.skill_info.skill_id);
            PvPBattleManager.getBattle().showCharacterMc(this.player_team, this.player_number);
            super.handleEndAnimation();
        }

        override public function handleBunshin(_arg_1:MovieClip):void
        {
            var _local_2:* = PvPBattleManager.CHARACTER_MANAGERS[this.player_team][this.player_number];
            var _local_3:String = _local_2.getWeapon();
            var _local_4:String = _local_2.getBackItem();
            var _local_5:String = _local_2.getClothing();
            var _local_6:String = _local_2.getHair();
            var _local_7:String = _local_2.getFace();
            var _local_8:String = _local_2.getHairColor();
            var _local_9:String = _local_2.getSkinColor();
            this.fillOutfit(_local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _local_9, _arg_1);
        }

        override public function handleFlyingObject(_arg_1:MovieClip, _arg_2:String):void
        {
            this.startPoint = null;
            this.targetPoint = null;
            this.point = null;
            var _local_3:int = 125;
            var _local_4:* = 600;
            var _local_5:int = this.getTarget();
            var _local_6:String = this.getEnemyTeam();
            var _local_7:MovieClip = PvPBattleManager.getBattle().getObjectHolder(_local_6, _local_5);
            var _local_8:Point = new Point((_local_7.x + _local_3), (_local_7.y + _local_4));
            if ((_arg_2 == "target"))
            {
                this.targetPoint = _local_8;
            }
            else
            {
                this.point = _local_8;
            };
            this.playFlyingObject(_arg_1);
        }

        override public function addFullScreen():void
        {
            try
            {
                super.addFullScreen();
                PvPBattleManager.getMain().loader.addChild(this.skill_mc.fullScreenEffect);
            }
            catch(e)
            {
            };
        }

        override public function removeFullScreen():void
        {
            try
            {
                PvPBattleManager.getMain().loader.removeChild(this.skill_mc.fullScreenEffect);
            }
            catch(e)
            {
            };
        }


    }
}//package id.ninjasage.pvp.battle

