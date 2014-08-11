package com.game.map
{
	/**
	 * Data object that encapsulates all the possible settings used to create a map. Also includes 
	 * some static helper methods that will pre-populate for popular settings.
	 * @author Jared Riley
	 */
	public class MapSettings 
	{
		/**
		 * The width of the map, in number of tiles, to be created.
		 */
		public var width:uint;
		
		/**
		 * The height of the map, in number of tiles, to be created.
		 */
		public var height:uint;
		
		/**
		 * The number of land mines to be placed on the map.
		 */
		public var mines:uint;
		
		/**
		 * Constructor.
		 * @param	mapWidth	The width of the map, in number of tiles, to be created.
		 * @param	mapHeight	The height of the map, in number of tiles, to be created.
		 * @param	numMines	The number of land mines to be placed on the map.
		 */
		public function MapSettings(mapWidth:uint = 0, mapHeight:uint = 0, numMines:uint = 0):void
		{
			width = mapWidth;
			height = mapHeight;
			mines = numMines;
		}
		
		/**
		 * Creates a pre-popuplated MapSettings object with suggested values for an Easy difficult map.
		 * @return A pre-popuplated MapSettings object with suggested values for an Easy difficult map.
		 */
		public static function Easy():MapSettings
		{
			return new MapSettings(20, 16, 20);
		}
		
		/**
		 * Creates a pre-popuplated MapSettings object with suggested values for an Medium difficult map.
		 * @return A pre-popuplated MapSettings object with suggested values for an Medium difficult map.
		 */
		public static function Medium():MapSettings
		{
			return new MapSettings(20, 16, 50);
		}
		
		/**
		 * Creates a pre-popuplated MapSettings object with suggested values for an Hard difficult map.
		 * @return A pre-popuplated MapSettings object with suggested values for an Hard difficult map.
		 */
		public static function Hard():MapSettings
		{
			return new MapSettings(20, 16, 100);
		}
	}
	
}