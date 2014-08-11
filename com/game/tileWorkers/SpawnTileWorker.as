package com.game.tileWorkers
{
	import com.data.Map;
	import com.game.tileWorkers.GenericTileWorker;
	import com.game.World;
	import flash.geom.Point;
	
	/**
	 * Places the actual tile game objects onto the world.
	 * @author Jared Riley
	 */
	public class SpawnTileWorker extends GenericTileWorker
	{
		/**
		 * Used to determine what tiles have been already checked by the tile worker.
		 */
		private var _placementMap:Vector.<Boolean>;
		
		/**
		 * Initiates tile worker behavior.
		 * @param	map			The map object that the tile worker will act upon.
		 * @param	world		A reference to the World object that contains this tile worker.
		 * @param	spawnTile	The initial tile that the tile worker will process first.
		 * @param 	speed		How many tiles can be processed per second.
		 */
		public override function Start(map:Map, world:World, spawnTile:Point, speed:Number):void
		{
			super.Start(map, world, spawnTile, speed);
			
			_placementMap = new Vector.<Boolean>(map.width * map.height);
			for (var i:uint = 0; i < _placementMap.length; i++)
			{
				_placementMap[i] = false;
			}
			_placementMap[(spawnTile.y * _map.width) + spawnTile.x] = true;
		}
		
		/**
		 * Destroys this tile worker instance and removes any memory references it may contain.
		 */
		public override function Destroy():void
		{
			super.Destroy();
			_placementMap.length = 0;
			_placementMap = null;
		}
		
		/**
		 * Places a tile game object onto the world and queues additional tiles to be placed.
		 * @param	tile	The coordinates of the tile to be processed.
		 */
		protected override function ProcessTile(tile:Point):void
		{
			PlaceTile(tile);
			QueueNextTilesFlood(tile);
		}
		
		/**
		 * Places a tile game object onto the world.
		 * @param	tile	The coordinates of the tile to be processed.
		 */
		private function PlaceTile(tile:Point):void
		{
			_world.PlaceTile(tile);
		}
		
		/**
		 * Queues the neighboring tiles to be placed.
		 * @param	tile	The coordinates of the tile to be processed.
		 */
		private function QueueNextTilesFlood(tile:Point):void
		{
			// Check the right
			if (tile.x + 1 < _map.width)
			{
				QueueIfUnplaced(new Point(tile.x + 1, tile.y));
			}
			
			// Check the bottom
			if (tile.y + 1 < _map.height)
			{
				QueueIfUnplaced(new Point(tile.x, tile.y + 1));
			}
			
			// Check the left
			if (tile.x - 1 >= 0)
			{
				QueueIfUnplaced(new Point(tile.x - 1, tile.y));
			}
			
			// Check the top
			if (tile.y - 1 >= 0)
			{
				QueueIfUnplaced(new Point(tile.x, tile.y - 1));
			}
		}
		
		/**
		 * Checks to see if a tile is unplaced, and if so, queues it up.
		 * @param	tile	The tile to queue.
		 */
		private function QueueIfUnplaced(tile:Point):void
		{
			if (_placementMap[(tile.y * _map.width) + tile.x] == false )
			{
				_placementMap[(tile.y * _map.width) + tile.x] = true;
				_tileQueue.push(tile);
			}
		}
	}
}