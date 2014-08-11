package com.game.tileWorkers
{
	import com.data.Map;
	import com.game.ITileWorker;
	import com.game.World;
	import com.logging.LogController;
	import flash.geom.Point;
	
	/**
	 * Implements the common, basic functionality of tile workers.
	 * @author Jared Riley
	 */
	public class GenericTileWorker implements ITileWorker
	{
		/**
		 * A reference to the map object this worker is acting upon.
		 */
		protected var _map:Map;
		
		/**
		 * A reference to the World object that contains this tile worker.
		 */
		protected var _world:World;
		
		/**
		 * The queue of tiles that have yet to be processed.
		 */
		protected var _tileQueue:Vector.<Point>;
		
		/**
		 * The speed, in milliseconds per tile, in which tiles can be processed.
		 */
		private var _speed:uint;
		
		/**
		 * The amount of time that has passed, in milliseconds, since the last tile was processed.
		 */
		private var _timeSinceLastProcess:uint;
		
		/**
		 * Returns whether this tile worker has completed (TRUE) or not (FALSE).
		 */
		public function get Completed():Boolean
		{
			if (_tileQueue == null)
			{
				return true;
			}
			
			if (_tileQueue.length == 0)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * Initiates tile worker behavior.
		 * @param	map			The map object that the tile worker will act upon.
		 * @param	world		A reference to the World object that contains this tile worker.
		 * @param	spawnTile	The initial tile that the tile worker will process first.
		 * @param 	speed		How many tiles can be processed per second.
		 */
		public function Start(map:Map, world:World, spawnTile:Point, speed:Number):void
		{
			if (map == null)
			{
				LogController.LogError(this, "'map' cannot be null.");
				return;
			}
			
			if (world == null)
			{
				LogController.LogError(this, "'world' cannot be null.");
				return;
			}
			
			if (spawnTile == null)
			{
				LogController.LogError(this, "'spawnTile' cannot be null.");
				return;
			}
			
			if (speed < 0)
			{
				LogController.LogError(this, "'speed' cannot be negative.");
				return;
			}
			
			if (_tileQueue != null)
			{
				Reset();
			}
			
			_tileQueue = new Vector.<Point>();
			_tileQueue.push(spawnTile);
			
			_world = world;
			_map = map;
			
			// Convert tiles processed per second into milliseconds per single tile which is more useful for us.
			_speed = uint(Math.floor(1000 / speed));
			_timeSinceLastProcess = 0;
		}
		
		/**
		 * Method called each game tick (frame) with the amount of time that has passed since the last tick.
		 * @param	deltaTime	The amount of time, in milliseconds, that have passed since the last game tick.
		 * @return	TRUE if the tile worker is now completed.  Otherwise FALSE;
		 */
		public function Tick(timeDelta:uint):Boolean
		{
			if (_tileQueue.length == 0)
			{
				return true;
			}
			
			_timeSinceLastProcess += timeDelta;
			if (_timeSinceLastProcess < _speed)
			{
				return false;
			}
			
			var numTilesToProcess = Math.floor(_timeSinceLastProcess / _speed);
			_timeSinceLastProcess = _timeSinceLastProcess - (numTilesToProcess * _speed);
			
			while (numTilesToProcess > 0)
			{	
				numTilesToProcess--;
				
				if (_tileQueue.length == 0)
				{
					break;
				}
				
				ProcessTile(_tileQueue.shift());
			}
			
			if (_tileQueue.length == 0)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * Destroys this tile worker instance and removes any memory references it may contain.
		 */
		public function Destroy():void
		{
			_map = null;
			_world = null;
			_tileQueue.length = 0;
			_tileQueue = null;
		}
		
		/**
		 * Processes a single tile of the map, possibly adding other tiles to be processed into the queue.
		 * Note: This method should be overridden by child classes.
		 * @param	tile	The coordinates of the tile to be processed.
		 */
		protected function ProcessTile(tile:Point):void
		{
			// This method is designed to be overridden. Currently it does nothing by itself.
			LogController.LogWarning(this, "The GenericTileWorker.ProcessTile() method was called. It should be overridden.");
		}
		
		/**
		 * Clears and resets everything in this tile worker so it can be ready for a fresh start.
		 */
		private function Reset():void
		{
			_timeSinceLastProcess = 0;
			_speed = 0;
			_map = null;
			
			if (_tileQueue != null)
			{
				_tileQueue.length = 0;
				_tileQueue = null;
			}
		}
	}
	
}