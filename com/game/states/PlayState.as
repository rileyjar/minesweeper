package com.game.states
{
	import com.events.ClickEvent;
	import com.game.*;
	import com.logging.LogController;
	import com.systems.InputController;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	/**
	 * Play game state implementation. Controls the behavior of the game controller while an active game is in session.
	 * Processes user input.
	 * @author Jared Riley
	 */
	public class PlayState implements IGameState
	{
		/**
		 * The name of the MovieClip object that contains the highlight animation.
		 */
		private static const TILE_HIGHLIGHT_CLIP_NAME:String = "Highlight";
		
		/**
		 * The frame label of the animation to play when a Tile is highlighted.
		 */
		private static const TILE_HIGHLIGHT_ANIMATION_NAME:String = "show";
		
		/**
		 * The previous tile that was highlighted (so that we don't constantly re-highlight the same current one).
		 */
		private var _lastHighlightedTile:Point;
		
		/**
		 * A reference to the game controller that contains this game state.
		 */
		private var _gameController:GameController;
		
		/**
		 * Method called when the state is entered.
		 * @param	gameController	A reference to GameController object that this state pertains to.
		 */
		public function EnterState(gameController:GameController):void
		{
			LogController.LogInfo(this, "Entering the Play game state.");
			
			_gameController = gameController;
			_lastHighlightedTile = new Point( -1, -1);
			
			_gameController.inputController.addEventListener(InputController.EVENT_CLICK, OnClick);
			_gameController.inputController.addEventListener(InputController.EVENT_COMMAND_CLICK, OnCommandClick);
		}
		
		/**
		 * Method called when the state is exited. Deactivates the state.
		 */
		public function ExitState():void 
		{
			LogController.LogInfo(this, "Exiting the Play game state.");
			
			_gameController.inputController.removeEventListener(InputController.EVENT_CLICK, OnClick);
			_gameController.inputController.removeEventListener(InputController.EVENT_COMMAND_CLICK, OnCommandClick);
		}
		
		/**
		 * Method called each game tick (frame) with the amount of time that has passed since the last tick.
		 * @param	deltaTime	The amount of time, in milliseconds, that have passed since the last game tick.
		 */
		public function Tick(deltaTime:int):void
		{
			var mousePointer:Point = new Point(_gameController.stage.mouseX, _gameController.stage.mouseY);
			var tileCoords:Point = _gameController.world.GlobalToTile(mousePointer);
			if (_gameController.world.GetInBoundsGlobal(mousePointer))
			{
				if (!_lastHighlightedTile.equals(tileCoords))
				{
					_lastHighlightedTile = tileCoords;
					HighlightTile(tileCoords);
				}
			}
		}
		
		/**
		 * Plays the highlight animation for a single tile MovieClip if not revealed.
		 * @param	tileCoords	The tile coordinates of the Tile to be highlighted.
		 */
		private function HighlightTile(tileCoords:Point):void
		{
			if (_gameController.world.map.IsRevealed(uint(tileCoords.x), uint(tileCoords.y)))
			{
				return;
			}
			
			var tileClip:MovieClip = _gameController.world.GetTile(tileCoords);
			tileClip[TILE_HIGHLIGHT_CLIP_NAME].gotoAndPlay(TILE_HIGHLIGHT_ANIMATION_NAME);
		}
		
		/**
		 * Event triggered when the InputController.EVENT_CLICK is received.  Prcocess a normal click event.
		 * @param	event	A reference to the mouse click providing context around the event.
		 */
		private function OnClick(event:ClickEvent):void
		{
			if (!_gameController.world.GetInBoundsGlobal(event.stageCoordinates))
			{
				// If the click was outside the bounds of the game world, ignore it.
				return;
			}
			
			var tileCoords:Point = _gameController.world.GlobalToTile(event.stageCoordinates);
			if (_gameController.world.map.IsRevealed(uint(tileCoords.x), uint(tileCoords.y)))
			{
				// If the tile is already revealed, do nothing.
				return;
			}
			
			if (_gameController.world.map.IsMine(uint(tileCoords.x), uint(tileCoords.y)))
			{
				// It's a mine, you should lose...
				_gameController.world.RevealAllMines(tileCoords);
				_gameController.EndGame(false);
			}
			else if (_gameController.world.map.GetTotalAdjacentMines(uint(tileCoords.x), uint(tileCoords.y)) == 0)
			{
				// We need to kick off a tile worker that reveals tiles
				_gameController.world.RevealEmptyTiles(tileCoords);
			}
			else
			{
				// A regular numbered tile
				_gameController.world.map.RevealCell(uint(tileCoords.x), uint(tileCoords.y));
			}
		}
		
		/**
		 * Event triggered when the InputController.EVENT_COMMAND_CLICK is recieved. It process a command click, ie. flagging a tile.
		 * @param	event	A reference to the mouse click providing context around the event.
		 */
		private function OnCommandClick(event:ClickEvent):void
		{
			if (!_gameController.world.GetInBoundsGlobal(event.stageCoordinates))
			{
				// If the click was outside the bounds of the game world, ignore it.
				return;
			}
			
			var tileCoords:Point = _gameController.world.GlobalToTile(event.stageCoordinates);
			if (_gameController.world.map.IsRevealed(uint(tileCoords.x), uint(tileCoords.y)))
			{
				// If the tile is already revealed, do nothing.
				return;
			}
			
			// Place a flag on the tile.
			_gameController.world.map.FlagCell(uint(tileCoords.x), uint(tileCoords.y));
		}
	}
}