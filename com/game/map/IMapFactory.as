package com.game.map
{
	import com.data.Map;
	import com.game.map.MapSettings;
	
	/**
	 * Defines an interface for factory methods to generate maps. 
	 * Allows for new and different map generation techniques down the road.
	 * @author Jared Riley
	 */
	public interface IMapFactory  
	{
		/**
		 * Generates a new Map object based on the supplied settings.
		 * @param	mapSettings	The parameters used to generate a new Map.
		 * @return	A new Map object based on the supplied settings.
		 */
		function CreateMap(mapSettings:MapSettings):Map;
	}
	
}