// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//Combat.SkillHandler

package Combat
{
    import id.ninjasage.multiplayer.battle.base.SkillHandlerBase;
    import flash.display.MovieClip;
    import flash.geom.Point;

    public class SkillHandler extends SkillHandlerBase 
    {

        private var rox:int = Math.round((Math.random() * 2147483647));//1337

        public function SkillHandler(_arg_1:MovieClip, _arg_2:String, _arg_3:int, _arg_4:Object)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, BattleVars.SKILL_SCALE);
        }

        override public function handleHitAnimation():void
        {
            var _local_1:* = BattleManager.getBattle();
            (_local_1[this.getActionType("hit")](this.player_team, this.player_number, this.skill_info.skill_id));
        }

        override public function handleEndAnimation():void
        {
            super.handleEndAnimation();
            var _local_1:* = BattleManager.getBattle();
            (_local_1[this.getActionType("finish")](this.player_team, this.player_number, this.skill_info.skill_id));
        }

        override public function handleBunshin(_arg_1:MovieClip):void
        {
            var _local_2:String = BattleManager.getBattle().attacker_model.character_manager.getWeapon();
            var _local_3:String = BattleManager.getBattle().attacker_model.character_manager.getBackItem();
            var _local_4:String = BattleManager.getBattle().attacker_model.character_manager.getClothing();
            var _local_5:String = BattleManager.getBattle().attacker_model.character_manager.getHair();
            var _local_6:String = BattleManager.getBattle().attacker_model.character_manager.getFace();
            var _local_7:String = BattleManager.getBattle().attacker_model.character_info.hair_color;
            var _local_8:String = BattleManager.getBattle().attacker_model.character_info.skin_color;
            this.fillOutfit(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7, _local_8, _arg_1);
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
            var _local_7:MovieClip = BattleManager.getBattle().getObjectHolder(_local_6, _local_5);
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

        override public function setCurrentCooldown(_arg_1:int):void
        {
            this.c_skill_cooldown = (_arg_1 ^ this.rox);
        }

        override public function getCurrentCooldown():int
        {
            return (this.c_skill_cooldown ^ this.rox);
        }

        override public function addFullScreen():void
        {
            try
            {
                super.addFullScreen();
                BattleManager.getMain().loader.addChild(this.skill_mc.fullScreenEffect);
            }
            catch(e)
            {
            };
        }

        override public function removeFullScreen():void
        {
            try
            {
                BattleManager.getMain().loader.removeChild(this.skill_mc.fullScreenEffect);
            }
            catch(e)
            {
            };
        }

        override protected function getTarget():int
        {
            return (BattleVars.PLAYER_TARGET);
        }


    }
}//package Combat

