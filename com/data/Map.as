package com.data
{	
	import com.events.MapEvent;
	import com.logging.LogController;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	/**
	 * Data structure for a single instance of a game Map. Limits control over changing cell flags in order to maintain current 
	 * up-to-date counts for things like number of mines and revealed tiles.
	 * 
	 * Events:
	 * Event.CHANGE - Dispatched when a cell in the map is modified. Can be suspended with the suspendEvents flag.
	 * 
	 * @author Jared Riley
	 */
	public class Map extends EventDispatcher
	{
		/**
		 * The width of the map.
		 */
		private var _width:uint;
		
		/**
		 * The height of the map.
		 */
		private var _height:uint;
		
		/**
		 * The number of landmines in the map.
		 */
		private var _mineCount:uint;
		
		/**
		 * The number of tiles revealed in the map.
		 */
		private var _revealedTilesCount:uint;
		
		/**
		 * The number of tiles flagged but still hidden in the map.
		 */
		private var _flaggedTilesCount:uint;
		
		/**
		 * The raw map data.
		 */
		private var _data:Vector.<Cell>;
		
		/**
		 * The tile coordinates of the first revealed mine.
		 */
		private var _firstRevealedMine:Point;
		
		/**
		 * If set to TRUE, all Event.CHANGE events will be ignored and not dispatched, useful when constructing a map.
		 */
		public var suspendEvents:Boolean;
		
		/**
		 * The width of the map.
		 */
		public function get width():uint
		{
			return _width;
		}
		
		/**
		 * The height of the map.
		 */
		public function get height():uint
		{
			return _height;
		}
		
		/**
		 * The number of landmines in the map.
		 */
		public function get mineCount():uint
		{
			return _mineCount;
		}
		
		/**
		 * The number of tiles revealed in the map.
		 */
		public function get revealedTilesCount():uint
		{
			return _revealedTilesCount;
		}
		
		/**
		 * The number of tiles flagged but still hidden in the map.
		 */
		public function get flaggedTilesCount():uint
		{
			return _flaggedTilesCount;
		}
		
		/**
		 * Generates a new map with the specified width and height absent of mines with all cells marked as hidden.
		 * @param	width The desired width of the map.
		 * @param	height The desired height of the map.
		 */
		public function Map(width:uint, height:uint):void
		{
			suspendEvents = false;
			
			_revealedTilesCount = 0;
			_mineCount = 0;
			_width = width;
			_height = height;
			
			_data = new Vector.<Cell>(width * height);
			for (var i:uint = 0; i < _data.length; i++)
			{
				_data[i] = new Cell();
			}
		}
		
		/**
		 * Determines if the game is in a current state where the player has won the game.
		 * @return	Returns TRUE if the player has won the game, otherwise FALSE.
		 */
		public function CheckIfWon():Boolean
		{
			if ((_revealedTilesCount + _mineCount) == (_width * _height))
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * Returns the total number of mines that are adjacent to the specified tile.
		 * @param	x The x tile coordinate, measured horizontally, starting from the left.
		 * @param	y The y tile coordinate, measured vertically, starting from the top.
		 * @return	The total number of mines that are adjacent to the specified tile.
		 */
		public function GetTotalAdjacentMines(x:uint, y:uint):uint
		{
			if (!CheckBounds(x, y))
			{
				return 0;
			}
			
			var count:uint = 0;
			
			var xMin:uint = (x > 0) ? x - 1 : 0;
			var xMax:uint = (x < _width - 2) ? x + 1 : _width - 1;
			var yMin:uint = (y > 0) ? y - 1 : 0;
			var yMax:uint = (y < _height - 2) ? y + 1 : _height - 1;
			
			for (var x2:uint = xMin; x2 <= xMax; x2++)
			{
				for (var y2:uint = yMin; y2 <= yMax; y2++)
				{
					if (_data[(y2 * width) + x2].isMine)
					{
						count++;
					}
				}
			}
			
			// Don't want to double count
			if (_data[(y * width) + x].isMine)
			{
				count--;
			}
			
			return count;
		}
		
		/**
		 * Returns a list of locations where all non-revealed mines reside.
		 * @return	A list of locations where all non-revealed mines reside.
		 */
		public function GetAllNonRevealedMineLocations():Vector.<Point>
		{
			var mineList:Vector.<Point> = new Vector.<Point>();
			for (var x:uint = 0; x < _width; x++)
			{
				for (var y:uint = 0; y < _height; y++)
				{
					// Now do the tests
					if (_data[(y * width) + x].isMine)
					{
						if (_data[(y * width) + x].displayState == Cell.HIDDEN)
						{
							mineList.push(new Point(x, y));
						}
					}
				}
			}
			
			return mineList;
		}
		
		/**
		 * Indicates whether the tile provided was the first revealed mine.
		 * @param	tile	The tile coordinates to be tested.
		 * @return			Whether the specified tile was the first revealed mine or not.
		 */
		public function IsFirstRevealedMine(tile:Point):Boolean
		{
			if (_firstRevealedMine == null)
			{
				return false;
			}
			
			if (tile.equals(_firstRevealedMine))
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * Indicates whether the tile at the specified coordinates is a landmine or not.  TRUE if it is a mine, otherwise FALSE.
		 * @param	x The x tile coordinate, measured horizontally, starting from the left.
		 * @param	y The y tile coordinate, measured vertically, starting from the top.
		 * @return  Whether the tile at the specified coordinates is a landmine or not.  TRUE if it is a mine, otherwise FALSE.
		 */
		public function IsMine(x:uint, y:uint):Boolean
		{
			if (!CheckBounds(x, y))
			{
				return false;
			}
			
			return _data[(y * width) + x].isMine;
		}
		
		/**
		 * Indicates whether the tile at the specified coordinates is revealed or not.  TRUE if it is revealed, otherwise FALSE.
		 * @param	x The x tile coordinate, measured horizontally, starting from the left.
		 * @param	y The y tile coordinate, measured vertically, starting from the top.
		 * @return  Whether the tile at the specified coordinates is revealed or not.  TRUE if it is revealed, otherwise FALSE.
		 */
		public function IsRevealed(x:uint, y:uint):Boolean
		{
			if (!CheckBounds(x, y))
			{
				return false;
			}
			
			return _data[(y * width) + x].displayState == Cell.REVEALED;
		}
		
		
		/**
		 * Places a land mine at the specified tile coordinates if no mine currently exists.
		 * @param	x The x tile coordinate, measured horizontally, starting from the left.
		 * @param	y The y tile coordinate, measured vertically, starting from the top.
		 * @return	Whether the mine placement was successful or not. TRUE if success, otherwise FALSE. Will fail if a mine already exists.
		 */
		public function PlaceMine(x:uint, y:uint):Boolean
		{
			if (!CheckBounds(x, y))
			{
				return false;
			}
			
			if (_data[(y * width) + x].isMine)
			{
				return false;
			}
			
			_data[(y * width) + x].isMine = true;
			_mineCount++;
			
			if (!suspendEvents)
			{
				dispatchEvent(new MapEvent(MapEvent.CHANGED, new Point(x, y)));
			}
			
			return true;
		}
		
		/**
		 * Removes a mine, if any, at the specified tile coordinates.
		 * @param	x The x tile coordinate, measured horizontally, starting from the left.
		 * @param	y The y tile coordinate, measured vertically, starting from the top.
		 */
		public function RemoveMine(x:uint, y:uint):void
		{
			if (!CheckBounds(x, y))
			{
				return;
			}
			
			if (!_data[(y * width) + x].isMine)
			{
				return;
			}
			
			_data[(y * width) + x].isMine = false;
			_mineCount--;
			
			if (!suspendEvents)
			{
				dispatchEvent(new MapEvent(MapEvent.CHANGED, new Point(x, y)));
			}
		}
		
		/**
		 * Reveals a cell at the specified map coordinates. If the tile was previously flagged, the flag is removed.
		 * @param	x The x tile coordinate, measured horizontally, starting from the left.
		 * @param	y The y tile coordinate, measured vertically, starting from the top.
		 */
		public function RevealCell(x:uint, y:uint):void
		{
			if (!CheckBounds(x, y))
			{
				return;
			}
			
			if (_data[(y * width) + x].displayState == Cell.REVEALED)
			{
				return;
			}
			
			if (_data[(y * width) + x].displayState == Cell.FLAGGED)
			{
				_flaggedTilesCount--;
			}
			
			_data[(y * width) + x].displayState = Cell.REVEALED;
			_revealedTilesCount++
			
			var tileLocation:Point = new Point(x, y);
			
			if (_data[(y * width) + x].isMine)
			{
				if (_firstRevealedMine == null)
				{
					_firstRevealedMine = tileLocation;
				}
			}
			
			if (!suspendEvents)
			{
				dispatchEvent(new MapEvent(MapEvent.CHANGED, tileLocation));
			}
		}
		
		/**
		 * Hides the cell at the specified tile coordinates. If the cell was flagged, it becomes unflagged.
		 * @param	x The x tile coordinate, measured horizontally, starting from the left.
		 * @param	y The y tile coordinate, measured vertically, starting from the top.
		 */
		public function HideCell(x:uint, y:uint):void
		{
			if (!CheckBounds(x, y))
			{
				return;
			}
			
			if (_data[(y * width) + x].displayState == Cell.FLAGGED)
			{
				_flaggedTilesCount--;
			}
			
			if (_data[(y * width) + x].displayState == Cell.REVEALED)
			{
				_revealedTilesCount--;
			}
			
			_data[(y * width) + x].displayState = Cell.HIDDEN;
			
			if (!suspendEvents)
			{
				dispatchEvent(new MapEvent(MapEvent.CHANGED, new Point(x, y)));
			}
		}
		
		/**
		 * Places a flag on the specified tile coordinates only if a cell is currently marked as hidden. Revealed cells can't be flagged.
		 * @param	x The x tile coordinate, measured horizontally, starting from the left.
		 * @param	y The y tile coordinate, measured vertically, starting from the top.
		 */
		public function FlagCell(x:uint, y:uint):void
		{
			if (!CheckBounds(x, y))
			{
				return;
			}
			
			if (_data[(y * width) + x].displayState != Cell.HIDDEN)
			{
				return;
			}
			
			_data[(y * width) + x].displayState = Cell.FLAGGED;
			_flaggedTilesCount++;
			
			if (!suspendEvents)
			{
				dispatchEvent(new MapEvent(MapEvent.CHANGED, new Point(x, y)));
			}
		}
		
		/**
		 * Removes a flag, if one exists, at the specified tile coordinates.
		 * @param	x The x tile coordinate, measured horizontally, starting from the left.
		 * @param	y The y tile coordinate, measured vertically, starting from the top.
		 */
		public function UnFlagCell(x:uint, y:uint):void
		{
			if (!CheckBounds(x, y))
			{
				return;
			}
			
			if (_data[(y * width) + x].displayState != Cell.FLAGGED)
			{
				return;
			}
			
			_data[(y * width) + x].displayState = Cell.HIDDEN;
			_flaggedTilesCount--;
			
			if (!suspendEvents)
			{
				dispatchEvent(new MapEvent(MapEvent.CHANGED, new Point(x, y)));
			}
		}
		
		/**
		 * Destroys this Map instance and cleans up.
		 */
		public function Destroy():void
		{
			_width = 0;
			_height = 0;
			_mineCount = 0;
			_revealedTilesCount = 0;
			_flaggedTilesCount = 0;
			_firstRevealedMine = null;
			
			_data.length = 0;
			_data = null;
		}
		
		/**
		 * Returns a string representing a text based output of the current map. Used for debugging purposes.
		 * @return	A string representing a text based output of the current map. Used for debugging purposes.
		 */
		public function ToString():String
		{
			var output:String = "Map Data:";
			var cellOutput:String = "";
			for (var i:uint = 0; i < _data.length; i++)
			{
				if ((i % _width) == 0)
				{
					output += "\n";
				}
				
				if (_data[i].displayState == Cell.REVEALED)
				{
					cellOutput = "r";
				}
				else if (_data[i].displayState == Cell.FLAGGED)
				{
					cellOutput = "f";
				}
				else if (_data[i].displayState == Cell.HIDDEN)
				{
					cellOutput = "h";
				}
				
				if (_data[i].isMine)
				{
					cellOutput = cellOutput.toUpperCase();
				}
				
				output += cellOutput + " ";
			}
			
			output += "\nKey:\nh = HIDDEN\nf = FLAGGED\nr = REVEALED\nCapital Case = Mines";
			
			output += "\nStats:\nWidth: " + _width + "\nHeight: " + _height + "\nMines: " + _mineCount + "\nFlagged: " + _flaggedTilesCount + "\nRevealed: " + _revealedTilesCount; 
			
			return output;
		}
		
		
		/**
		 * Determines if the specified tile coordinates lie within the bounds of the Map, and throws an error if not. Returns TRUE if within bounds, otherwise FALSE.
		 * @param	x The x tile coordinate, measured horizontally, starting from the left.
		 * @param	y The y tile coordinate, measured vertically, starting from the top.
		 * @return	Returns TRUE if within bounds, otherwise FALSE (and throws an Error).
		 */
		private function CheckBounds(x:uint, y:uint):Boolean
		{
			// Can't be less than 0 because it's unsigned.
			
			if (x >= _width)
			{
				LogController.LogError(this, "The provided x coordinate is out of bounds.");
				return false;
			}
			
			if (y >= _height)
			{
				LogController.LogError(this, "The provided y coordinate is out of bounds.");
				return false;
			}
			
			return true;
		}
		
		/**
		 * Returns the cell at the given coordinates.
		 * @deprecated Used internally for testing but should be removed.
		 * @param	x The x tile coordinate, measured horizontally, starting from the left.
		 * @param	y The y tile coordinate, measured vertically, starting from the top.
		 * @return	The cell at the specified tile coordinates.
		 */
		private function GetCell(x:uint, y:uint):Cell
		{
			var index:uint = (y * width) + x;
			
			if (index >= _data.length)
			{
				LogController.LogError(this, "The specified cell is out of bounds: " + x + ", " + y);
			}
			
			return _data[index];
		}
	}
	
}