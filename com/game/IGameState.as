package com.game
{
	/**
	 * Defines an interface for the various game states that occur while playing a game of Minesweeper.
	 * @author Jared Riley
	 */
	public interface IGameState  
	{
		/**
		 * Method called when the state is entered.
		 * @param	gameController	A reference to GameController object that this state pertains to.
		 */
		function EnterState(gameController:GameController):void;
		
		/**
		 * Method called when the state is exited. Typically it should be deactivated.
		 */
		function ExitState():void;
		
		/**
		 * Method called each game tick (frame) with the amount of time that has passed since the last tick.
		 * @param	deltaTime	The amount of time, in milliseconds, that have passed since the last game tick.
		 */
		function Tick(deltaTime:int):void;
	}
	
}