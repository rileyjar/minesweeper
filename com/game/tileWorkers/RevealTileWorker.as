package com.game.tileWorkers
{
	import com.data.Map;
	import com.game.tileWorkers.GenericTileWorker;
	import com.game.World;
	import flash.geom.Point;
	
	/**
	 * Burns through patches of blank tiles (ones not adjacent to mines) revealing big groups of them.
	 * @author Jared Riley
	 */
	public class RevealTileWorker extends GenericTileWorker
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
		 * Processes a tile by revealing it in the world and then queuing up neighbors to be revealed.
		 * @param	tile	The coordinates of the tile to be processed.
		 */
		protected override function ProcessTile(tile:Point):void
		{
			RevealTile(tile);
			
			if (_map.GetTotalAdjacentMines(uint(tile.x), uint(tile.y)) == 0)
			{
				QueueNextTilesFlood(tile);
			}
		}
		
		/**
		 * Reveals a single tile in the game world.
		 * @param	tile	The coordinates of the tile to be revealed.
		 */
		private function RevealTile(tile:Point):void
		{
			_map.RevealCell(uint(tile.x), uint(tile.y));
		}
		
		/**
		 * Queues the neighboring tiles to be revealed.
		 * @param	tile	The coordinates of the tile to be processed.
		 */
		private function QueueNextTilesFlood(tile:Point):void
		{
			var xMin:uint = (tile.x > 0) ? tile.x - 1 : 0;
			var xMax:uint = (tile.x < _map.width - 2) ? tile.x + 1 : _map.width - 1;
			var yMin:uint = (tile.y > 0) ? tile.y - 1 : 0;
			var yMax:uint = (tile.y < _map.height - 2) ? tile.y + 1 : _map.height - 1;
			
			for (var x:uint = xMin; x <= xMax; x++)
			{
				for (var y:uint = yMin; y <= yMax; y++)
				{
					QueueIfUnplaced(new Point(x, y));
				}
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