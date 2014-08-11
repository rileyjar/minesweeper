package com.data
{
	/**
	 * Data object representing a single cell in a map.
	 * @author Jared Riley
	 */
	public class Cell 
	{
		/**
		 * The HIDDEN display state.
		 */
		public static const HIDDEN:uint = 0;
		
		/**
		 * The REVEALED display state.
		 */
		public static const REVEALED:uint = 1;
		
		/**
		 * The FLAGGED display state.
		 */
		public static const FLAGGED:uint = 2;
		
		/**
		 * The current display state of this cell.
		 */
		public var displayState:uint;
		
		/**
		 * Whether this cell is a landmine or not. TRUE if it is a mine, otherwise FALSE.
		 */
		public var isMine:Boolean;
	}
	
}