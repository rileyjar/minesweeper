package com.game.states
{
	import com.game.*;
	import com.logging.LogController;
	
	/**
	 * Win/Lose game state implementation. State reached when a game has been ended.
	 * @author Jared Riley
	 */
	public class WinLoseState implements IGameState
	{
		
		/**
		 * Method called when the state is entered.
		 * @param	gameController	A reference to GameController object that this state pertains to.
		 */
		public function EnterState(gameController:GameController):void
		{
			LogController.LogInfo(this, "Entering the Win/Lose game state.");
		}
		
		/**
		 * Method called when the state is exited. Typically it should be deactivated.
		 */
		public function ExitState():void 
		{
			LogController.LogInfo(this, "Exiting the Win/Lose game state.");
		}
		
		/**
		 * Method called each game tick (frame) with the amount of time that has passed since the last tick.
		 * @param	deltaTime	The amount of time, in milliseconds, that have passed since the last game tick.
		 */
		public function Tick(deltaTime:int):void
		{
			// do nothing.
		}
	}
}