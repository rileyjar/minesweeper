package com.game
{
	import com.data.Map;
	import com.events.MapEvent;
	import com.game.GameController;
	import com.game.tileWorkers.*;
	import com.logging.LogController;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * Manages the display of the game world.
	 * @author Jared Riley
	 */
	public class World
	{
		/**
		 * The animation frame label in the Tile MovieClip to play when a tile is placed.
		 */
		private static const TILE_ANIMATION_PLACED_NAME:String = "Placement";
		
		/**
		 * The animation frame label in the Tile MovieClip to play when a mine is revealed.
		 */
		private static const TILE_ANIMATION_MINE_NAME:String = "Mine";
		
		/**
		 * The animation frame label in the Tile MovieClip to play when the player has clicked on a mine and lost.
		 */
		private static const TILE_ANIMATION_MINE_CLICKED_NAME:String = "MineClicked";
		
		/**
		 * The animation frame label in the Tile MovieClip to play when a tile is flagged.
		 */
		private static const TILE_ANIMATION_FLAGGED_NAME:String = "Flagged";
		
		/**
		 * The animation frame label in the Tile MovieClip to play when a tile is revealed.
		 */
		private static const TILE_ANIMATION_REVEALED_NAME:String = "Revealed";
		
		/**
		 * The top left corner of the grid where Tile MovieClips are placed in the world.
		 */
		private static var TILES_TOP_LEFT:Point = new Point(32, 22);
		
		/**
		 * The width of a single Tile MovieClip object.
		 */
		private static var TILE_WIDTH:Number = 20;
		
		/**
		 * A reference to the internal Map data object.
		 */
		private var _map:Map;
		
		/**
		 * A reference to the display object that contains the game world.
		 */
		private var _container:Sprite;
		
		/**
		 * A reference to the background Sprite in the game world.
		 */
		private var _background:Sprite;
		
		/**
		 * A list of all the existing Tile MovieClip objects placed in the world.
		 */
		private var _tiles:Vector.<MovieClip>;
		
		/**
		 * The internal queue of TileWorkers. Only the front of the queue is processed and then removed at completion, allowing the next 
		 * in line to operate.
		 */
		private var _workers:Vector.<ITileWorker>;
		
		/**
		 * The Method to be called when the game board has completed setup.
		 */
		private var _setupCompleteCallback:Function;
		
		/**
		 * Method to call when the game has finished revealing all mines after a loss.
		 */
		private var _minesRevealedCallback:Function;
		
		/**
		 * A reference to the GameController instance that operates on this game World instance.
		 */
		private var _gameController:GameController;
		
		/**
		 * Provides access to the internal Map data object for the current active game.
		 */
		public function get map():Map
		{
			return _map;
		}
		
		/**
		 * Sets up the game World and prepares it for it's first initial game.
		 * @param	container				A reference to the display object that contains the game world.
		 * @param	map						The Map data object that the game world will reflect.
		 * @param	gameController			A reference to the GameController instance that operates on this game World instance.
		 * @param	setupCompleteCallback	The Method to be called when the game board has completed setup.
		 * @param	minesRevealedCallback	Method to call when the game has finished revealing all mines after a loss.
		 */
		public function Setup(container:Sprite, map:Map, gameController:GameController, setupCompleteCallback:Function, minesRevealedCallback:Function):void
		{
			if (container == null)
			{
				LogController.LogError(this, "'container' can not be null.");
				return;
			}
			
			if (map == null)
			{
				LogController.LogError(this, "'map' can not be null.");
				return;
			}
			
			_container = container;
			_map = map;
			_gameController = gameController;
			_setupCompleteCallback = setupCompleteCallback;
			_minesRevealedCallback = minesRevealedCallback;
			
			_map.addEventListener(MapEvent.CHANGED, OnMapChange);
			
			_background = new Background;
			_container.addChild(_background);
			
			_tiles = new Vector.<MovieClip>(_map.width * _map.height);
			
			_workers = new Vector.<ITileWorker>();
			var setupWorker:SpawnTileWorker = new SpawnTileWorker();
			setupWorker.Start(_map, this, new Point(Math.floor(_map.width/2), Math.floor(_map.height/2)), 320);
			_workers.push(setupWorker);
		}
		
		/**
		 * Resets the game world to prepare it for an additional new game.
		 * @param	map						The Map data object that the game world will reflect.
		 * @param	setupCompleteCallback	The Method to be called when the game board has completed setup.
		 * @param	minesRevealedCallback	Method to call when the game has finished revealing all mines after a loss.
		 */
		public function Reset(map:Map, setupCompleteCallback:Function, minesRevealedCallback:Function):void
		{	
			if (_map != null)
			{
				_map.removeEventListener(MapEvent.CHANGED, OnMapChange);
				_map.Destroy();
			}
			else
			{
				LogController.LogError(this, "Reset() has been called before the World has been set up.  Call Setup() instead");
				return;
			}
			
			_map = map;
			_setupCompleteCallback = setupCompleteCallback;
			_minesRevealedCallback = minesRevealedCallback;
			
			while (_workers.length > 0)
			{
				_workers.shift().Destroy();
			}
			
			_map.addEventListener(MapEvent.CHANGED, OnMapChange);
			
			var resetWorker:ResetTileWorker = new ResetTileWorker();
			resetWorker.Start(_map, this, new Point(0, 0), 320);
			_workers.push(resetWorker);
		}
		
		/**
		 * Method called each game tick (frame) with the amount of time that has passed since the last tick.
		 * Currently operates the tile workers.
		 * @param	deltaTime	The amount of time, in milliseconds, that have passed since the last game tick.
		 */
		public function Tick(deltaTime:int):void
		{
			// Process the tile workers.
			if (_workers.length > 0)
			{
				if (_workers[0].Tick(deltaTime))
				{
					// removes the worker if it is completed.
					var worker:ITileWorker = _workers.shift();
					worker.Destroy();
					if ((worker is SpawnTileWorker) || (worker is ResetTileWorker))
					{
						if (_setupCompleteCallback != null)
						{
							_setupCompleteCallback();
						}
					}
					else if (worker is MineTileWorker)
					{
						if (_minesRevealedCallback != null)
						{
							_minesRevealedCallback();
						}
					}
				}
			}
		}
		
		/**
		 * When provided with a blank tile (not adjacent to any mines) will kick off a tile worker 
		 * that reveals large patches of open tiles.
		 * @param	tile	The initial blank tile that the player revealed.
		 */
		public function RevealEmptyTiles(tile:Point):void
		{
			var revealWorker:RevealTileWorker = new RevealTileWorker();
			revealWorker.Start(_map, this, tile, 100);
			_workers.push(revealWorker);
		}
		
		/**
		 * When provided with the first mine the player clicked, this method will kick off a tile worker 
		 * to detonate all remaining mines over time.
		 * @param	tile	The intial mine tile that was clicked on by the player.
		 */
		public function RevealAllMines(tile:Point):void
		{
			var mineWorker:MineTileWorker = new MineTileWorker();
			mineWorker.Start(_map, this, tile, 10);
			_workers.push(mineWorker);
		}
		
		/**
		 * Returns the Tile MovieClip instance located at the specified tile coordinates.
		 * @param	tile	The tile coordinates of the clip to be retrieved.
		 * @return	The Tile MovieClip instance located at the specified tile coordinates.
		 */
		public function GetTile(tile:Point):MovieClip
		{
			if (_tiles == null)
			{
				return null;
			}
			
			if (tile.x < 0)
			{
				LogController.LogWarning(this, "Could not get tile because tile.x was negative.");
				return null;
			}
			
			if (tile.y < 0)
			{
				LogController.LogWarning(this, "Could not get tile because tile.x was negative.");
				return null;
			}
			
			if (tile.x >= _map.width)
			{
				LogController.LogWarning(this, "Could not get because tile x component was off the map.");
				return null;
			}
			
			if (tile.y >= _map.height)
			{
				LogController.LogWarning(this, "Could not get because tile y component was off the map.");
				return null;
			}
			
			return _tiles[(tile.y * _map.width) + tile.x];
		}
		
		/**
		 * Creates a Tile MovieClip instance and places it in the game world.
		 * @param	tile	The tile coordinates of the Tile to be placed.
		 * @return	TRUE if the Tile was sucessfully placed, otherwise FALSE.
		 */
		public function PlaceTile(tile:Point):Boolean 
		{
			if (tile.x < 0)
			{
				LogController.LogWarning(this, "Could not place tile because tile.x was negative.");
				return false;
			}
			
			if (tile.y < 0)
			{
				LogController.LogWarning(this, "Could not place tile because tile.x was negative.");
				return false;
			}
			
			if (tile.x >= _map.width)
			{
				LogController.LogWarning(this, "Could not place because tile x component was off the map.");
				return false;
			}
			
			if (tile.y >= _map.height)
			{
				LogController.LogWarning(this, "Could not place because tile y component was off the map.");
				return false;
			}
			
			var index:uint = (tile.y * _map.width) + tile.x;
			
			if (_tiles[index] != null)
			{
				LogController.LogWarning(this, "Tile Sprite has already been placed at location " + tile.toString());
				return false;
			}
			
			var location:Point = TileToWorld(tile);
			var clip:MovieClip = new Tile;
			_tiles[index] = clip;
			clip.x = location.x;
			clip.y = location.y;
			_container.addChild(clip);
			
			return true;
		}
		
		/**
		 * Resets a Tile MovieClip animation to be hidden again.
		 * @param	tile	The tile coordinates of the Tile to be reset.
		 */
		public function ResetTile(tile:Point):void
		{
			var clip:MovieClip = GetTile(tile);
			clip.gotoAndStop(TILE_ANIMATION_PLACED_NAME);
		}
		
		/**
		 * Converts tile coordinates into world coordinates.
		 * @param	tile	The tile coordinates of the Tile to be converted.
		 * @return	A Point in displayObject local coordinates of the World container for the top left corner of Tile MovieClip (world coordinates).
		 */
		public function TileToWorld(tile:Point):Point 
		{
			var worldPoint:Point = new Point(
					tile.x * TILE_WIDTH,
					tile.y * TILE_WIDTH
				);
				
			return (worldPoint.add(TILES_TOP_LEFT));
		}
		
		/**
		 * Converts world (local displayObject) coordinates into the cooresponding game tile coordinates.
		 * @param	worldCoordinates	The world coordinates to be converted.
		 * @return	A Point in tile coordinates of the cooresponding game tile that contains the world coordinates provided.
		 */
		public function WorldToTile(worldCoordinates:Point):Point
		{
			var offsetCoords:Point = worldCoordinates.subtract(TILES_TOP_LEFT);
			
			return new Point(
					Math.floor(offsetCoords.x / TILE_WIDTH),
					Math.floor(offsetCoords.y / TILE_WIDTH)
				);
		}
		
		/**
		 * Coverts global (stage) coordinates into the tile coordinates that contains that point.
		 * @param	globalCoordinates	The global (stage) coordinates to be converted.
		 * @return	A Point in tile coordinates that cooresponds to the global coordinates provided.
		 */
		public function GlobalToTile(globalCoordinates:Point):Point
		{
			return WorldToTile(GlobalToWorld(globalCoordinates));
		}
		
		/**
		 * Converts global (stage) coordinates into local (world container) coordinates.
		 * @param	globalCoordinates	The global (stage) coordinates to be converted.
		 * @return	A point in local (world container) coordinates that coorespond to the provided global coordinates.
		 */
		public function GlobalToWorld(globalCoordinates:Point):Point
		{
			return _container.globalToLocal(globalCoordinates);
		}
		
		/**
		 * Provided global (Stage) coordinates indicates whether the given point is within displayed bounds of the grid of game tiles.
		 * @param	point	The global coordinates to be tested.
		 * @return	Returns TRUE if the point is within the displayed rectangle of the gird of game tiles, otherwise FALSE.
		 */
		public function GetInBoundsGlobal(point:Point):Boolean
		{
			var worldPoint:Point = GlobalToWorld(point);
			
			if ((point.x < TILES_TOP_LEFT.x) || (point.x >= (TILES_TOP_LEFT.x + (_map.width * TILE_WIDTH))))
			{
				return false;
			}
			
			if ((point.y < TILES_TOP_LEFT.y) || (point.y >= (TILES_TOP_LEFT.y + (_map.height * TILE_WIDTH))))
			{
				return false;
			}
			
			return true;
		}
		
		/**
		 * Event triggered whenever the underlying Map data object is changed.
		 * Updates the world display to reflect changes to the Map.
		 * @param	event	A reference to the MapEvent that contains the coordinates of the recently changed Map tile.
		 */
		private function OnMapChange(event:MapEvent):void
		{
			var clip:MovieClip = GetTile(event.tileCoordinates);
			if (_map.IsRevealed(event.tileCoordinates.x, event.tileCoordinates.y))
			{
				if (_map.IsMine(event.tileCoordinates.x, event.tileCoordinates.y))
				{
					if (_map.IsFirstRevealedMine(event.tileCoordinates))
					{
						clip.gotoAndStop(TILE_ANIMATION_MINE_CLICKED_NAME);
					}
					else
					{
						clip.gotoAndStop(TILE_ANIMATION_MINE_NAME);
					}
				}
				else
				{
					clip.gotoAndStop(TILE_ANIMATION_REVEALED_NAME);
					var count:uint = _map.GetTotalAdjacentMines(event.tileCoordinates.x, event.tileCoordinates.y);
					clip["Clip"].label.text = (count > 0) ? count.toString() : "";
				}
				
			}
			else
			{
				clip.gotoAndStop(TILE_ANIMATION_FLAGGED_NAME);
			}
			
			if (_map.CheckIfWon())
			{
				_gameController.EndGame(true);
			}
		}
	}
	
}