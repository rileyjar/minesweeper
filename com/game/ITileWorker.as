package com.game
{
	import com.data.Map;
	import flash.geom.Point;
	
	/**
	 * Defines an interface for TileWorkers, classes that operate a series of tile changes on the map over time.
	 * @author Jared Riley
	 */
	public interface ITileWorker
	{	
		/**
		 * Returns whether this tile worker has completed (TRUE) or not (FALSE).
		 */
		function get Completed():Boolean;
		
		/**
		 * Initiates tile worker behavior.
		 * @param	map			The map object that the tile worker will act upon.
		 * @param	world		A reference to the World object that contains this tile worker.
		 * @param	spawnTile	The initial tile that the tile worker will process first.
		 * @param 	speed		How many tiles can be processed per second.
		 */
		function Start(map:Map, world:World, spawnTile:Point, speed:Number):void;
		
		/**
		 * Method called each game tick (frame) with the amount of time that has passed since the last tick.
		 * @param	deltaTime	The amount of time, in milliseconds, that have passed since the last game tick.
		 * @return				Returns TRUE if the worker was completed this tick, otherwise FALSE.
		 */
		function Tick(timeDelta:uint):Boolean;
		
		/**
		 * Destroys this tile worker instance and removes any memory references it may contain.
		 */
		function Destroy():void;
	}
	
}