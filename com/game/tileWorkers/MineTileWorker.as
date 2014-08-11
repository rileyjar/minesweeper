package com.game.tileWorkers
{
	import com.data.Map;
	import com.game.tileWorkers.GenericTileWorker;
	import com.game.World;
	import flash.geom.Point;
	
	/**
	 * Goes through and detonates all non revealed mines in the world.
	 * @author Jared Riley
	 */
	public class MineTileWorker extends GenericTileWorker
	{
		/**
		 * The internal list of mines that are yet to be revealed.
		 */
		private var _existingMines:Vector.<Point>;
		
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
			
			_existingMines = map.GetAllNonRevealedMineLocations();
		}
		
		/**
		 * Destroys this tile worker instance and removes any memory references it may contain.
		 */
		public override function Destroy():void
		{
			super.Destroy();
			_existingMines.length = 0;
			_existingMines = null;
		}
		
		/**
		 * Detonates a mine game object in the world and queues additional mines to be revealed.
		 * @param	tile	The coordinates of the tile to be processed.
		 */
		protected override function ProcessTile(tile:Point):void
		{
			RevealTile(tile);
			
			var newTile:Point = SelectRandomTile();
			if (newTile != null)
			{
				_tileQueue.push(newTile);
			}
		}
		
		/**
		 * Reveals a tile game object onto the world.
		 * @param	tile	The coordinates of the tile to be processed.
		 */
		private function RevealTile(tile:Point):void
		{
			_map.RevealCell(uint(tile.x), uint(tile.y));
		}
		
		/**
		 * Selects a random tile from our mine list, removes it from the list, and returns it.
		 * @return	A random tile from the mine list.
		 */
		private function SelectRandomTile():Point
		{
			if (_existingMines.length == 0)
			{
				return null;
			}
			
			var index:uint = RandomUint(0, _existingMines.length - 1);
			var tile:Point = _existingMines[index];
			_existingMines.splice(index, 1);
			return tile;
		}
		
		/** 
		* Generates a random uint.
		* @param	min		The lowest possible minimum value to be returned.
		* @param	max		The highest possible maximum value to be returned.
		* @return 	A random uint between the provided min and max.
		*/ 
		private function RandomUint(min:uint = 0, max:uint = 1):uint
		{
			return uint(Math.floor(Math.random() * (1 + max - min)) + min);
		}
	}
}