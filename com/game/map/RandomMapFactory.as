package com.game.map
{
	import com.data.Map;
	import com.game.map.MapSettings;
	import com.logging.LogController;
	
	/**
	 * Generates a new Map instance based on the provided map settings with randomly placed mines.
	 * @author Jared Riley
	 */
	public class RandomMapFactory implements IMapFactory
	{
		/**
		 * The percentage of total tiles, if covered by mines, that will trigger a warning.
		 */
		private static const MINE_COVERAGE_WARNING:Number = 0.6;
		
		/**
		 * The total number of attempts the factory will take at randomly placing a mine before it bails.
		 */
		private static const NUM_MINE_PLACEMENT_ATTEMPTS:uint = 50;
		
		/**
		 * Generates a new Map object based on the supplied settings.
		 * @param	mapSettings	The parameters used to generate a new Map.
		 * @return	A new Map object based on the supplied settings.
		 */
		public function CreateMap(mapSettings:MapSettings):Map
		{
			var map:Map = new Map(mapSettings.width, mapSettings.height);
			
			var totalTiles:uint = mapSettings.width * mapSettings.height;
			if (mapSettings.mines >= (MINE_COVERAGE_WARNING * totalTiles))
			{
				if (mapSettings.mines > totalTiles)
				{
					LogController.LogError(this, "It is impossible to construct a map where the number of mines specified exceeds the number of tiles available.");
					
					return map;
				}
				
				LogController.LogWarning(this, "The MapSettings provided to RandomMapFactory specify more mines than 60% of the total map area. This can slow down map creation or cause other problems.");
			}
			
			map.suspendEvents = true;
			
			PlaceMines(map, mapSettings.mines);
			
			map.suspendEvents = false;
			
			return map;
		}
		
		/**
		 * Places the specified number of mines randomly on the provided map.
		 * @param	map			The map to be loaded up with land mines.
		 * @param	numMines	The number of mines to place.
		 */
		private function PlaceMines(map:Map, numMines:uint):void
		{
			for (var i:uint = 0; i < numMines; i++)
			{
				var numAttempts:uint = 0;
				while (!map.PlaceMine(RandomUint(0, map.width - 1), RandomUint(0, map.height - 1)))
				{
					numAttempts++;
					if (numAttempts >= NUM_MINE_PLACEMENT_ATTEMPTS)
					{
						LogController.LogWarning(this, "Aborted attempt to place mines when created map.");
						return;
					}
				}
			}
		}
		
		/** 
		* Generates a random uint.
		* @param	min		The lowest possible minimum value to be returned.
		* @param	max		The highest possible maximum value to be returned.
		* @return 	A random uint between the provided min and max.
		*/ 
		function RandomUint(min:uint = 0, max:uint = 1):uint
		{
			return uint(Math.floor(Math.random() * (1 + max - min)) + min);
		}
	}
	
}