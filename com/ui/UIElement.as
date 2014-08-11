package com.ui
{
	import flash.display.MovieClip;
	
	/**
	 * Provides common functionality for all UI Elements.
	 * @author Jared Riley
	 */
	public class UIElement extends MovieClip
	{
		/**
		 * Method called each game tick (frame) with the amount of time that has passed since the last tick.
		 * Note: Designed to be overridden.
		 * @param	deltaTime	The amount of time, in milliseconds, that have passed since the last game tick.
		 */
		public function Tick(timeDelta:uint):void
		{
			// do nothing
		}
		
		/**
		 * Destroys this instance by removing listeners and cleaning up memory.
		 * Note: Designed to be overridden.
		 */
		public function Destroy():void
		{
			// do nothing
		}
	}
	
}