package com.game.tileWorkers
{
	import com.game.tileWorkers.GenericTileWorker;
	import flash.geom.Point;
	
	/**
	 * Goes through all the tiles in the world and resets them for a new game.
	 * @author Jared Riley
	 */
	public class ResetTileWorker extends GenericTileWorker
	{
		/**
		 * Resets a tile game object onto the world and queues additional tiles to be placed.
		 * @param	tile	The coordinates of the tile to be processed.
		 */
		protected override function ProcessTile(tile:Point):void
		{
			PlaceTile(tile);
			QueueNextTilesRows(tile);
		}
		
		/**
		 * Resets a tile game object onto the world.
		 * @param	tile	The coordinates of the tile to be processed.
		 */
		private function PlaceTile(tile:Point):void
		{
			_world.ResetTile(tile);
		}
		
		/**
		 * Queues the neighboring tiles to be reset.
		 * @param	tile	The coordinates of the current tile to find neighbors.
		 */
		private function QueueNextTilesRows(tile:Point):void
		{
			
			if (tile.x + 1 >= _map.width)
			{
				if (tile.y + 1 >= _map.height)
				{
					return;
				}
				
				_tileQueue.push(new Point(0, tile.y + 1));
			}
			else
			{
				_tileQueue.push(new Point(tile.x + 1, tile.y));
			}
		}
	}
}