package com.game
{
	import com.ApplicationDirector;
	import com.data.*;
	import com.game.map.*;
	import com.game.states.*;
	import com.game.World;
	import com.logging.LogController;
	import com.systems.InputController;
	import flash.display.Sprite;
	import com.ui.panels.NewGamePanel;
	
	/**
	 * Entry point for game system. Manages game sessions, game states, and the game world.
	 * @author Jared Riley
	 */
	public class GameController extends Sprite
	{
		/**
		 * An identifier for the Idle game state.
		 */
		public static var STATE_IDLE:uint;
		
		/**
		 * An identifier for the Play game state.
		 */
		public static var STATE_PLAY:uint;
		
		/**
		 * An identifier for the win/lose (end game) game state.
		 */
		public static var STATE_WINLOSE:uint;
		
		/**
		 * An internal reference to all of the internal game states.
		 */
		private var _states:Vector.<IGameState>;
		
		/**
		 * The identifier for the current operating game state.
		 */
		private var _currentState:uint;
		
		/**
		 * A reference to the game World.
		 */
		private var _world:World;
		
		/**
		 * A reference to the Input controller.
		 */
		private var _inputController:InputController;
		
		/**
		 * Returns a reference to the input controller.
		 */
		public function get inputController():InputController
		{
			return _inputController;
		}
		
		/**
		 * Returns a reference to the game world.
		 */
		public function get world():World
		{
			return _world;
		}
		
		/**
		 * Constuctor.  Initializes the GameController and sets up game states.
		 * @param	inputController	A reference to the Input Controller for the game.
		 */
		public function GameController(inputController:InputController):void
		{
			LogController.LogInfo(this, "Initializing GameController.");
			
			_inputController = inputController;
			
			SetupStates();
		}
		
		/**
		 * Method called each game tick (frame) with the amount of time that has passed since the last tick.
		 * @param	deltaTime	The amount of time, in milliseconds, that have passed since the last game tick.
		 */
		public function Tick(deltaTime:int):void
		{	
			// game could be paused by adding a condition flag here.
			
			_states[_currentState].Tick(deltaTime);
			
			if (_world != null)
			{
				_world.Tick(deltaTime);
			}
		}
		
		/**
		 * Starts a new game of Minesweeper.
		 */
		public function StartGame(mapFactory:IMapFactory, mapSettings:MapSettings):void
		{
			// add error checks here
			
			var map:Map = mapFactory.CreateMap(mapSettings);
			
			ChangeState(STATE_IDLE);
			
			if (_world == null)
			{
				_world = new World();
				_world.Setup(this, map, this, OnWorldSetupComplete, OnMinesRevealedComplete);
			}
			else
			{
				_world.Reset(map, OnWorldSetupComplete, OnMinesRevealedComplete);
			}
		}
		
		/**
		 * Ends the current game of Minesweeper.
		 * @param	victoryCondition	The victory condition of the game end. TRUE if the player won, otherwise FALSE if they lost.
		 */
		public function EndGame(victoryCondition:Boolean):void
		{
			if (_currentState != STATE_PLAY)
			{
				return;
			}
			
			if (victoryCondition)
			{
				LogController.LogInfo(this, "YOU'VE WON THE GAME!");
				
				ApplicationDirector.GetInstance().uiController.OpenPanel(new NewGamePanel("You Won!!!", "Play another game!\nChoose a new game difficulty..."));
			}
			else
			{
				LogController.LogInfo(this, "THE GAME HAS BEEN LOST. :(");
				
				// hold off on showing the lose screen until all mines have been revealed.
			}
			
			ChangeState(STATE_WINLOSE);
		}
		
		/**
		 * Event triggered when the game World setup has recently been completed.
		 */
		private function OnWorldSetupComplete():void
		{
			LogController.LogInfo(this, "World setup complete.");
			
			ChangeState(STATE_PLAY);
		}
		
		/**
		 * Event triggered when the player has lost and all mines are being revealed.
		 */
		private function OnMinesRevealedComplete():void
		{
			ApplicationDirector.GetInstance().uiController.OpenPanel(new NewGamePanel("You Lost. :(", "You can always try again!\nChoose a new game difficulty..."));
		}
		
		/**
		 * Changes the current active game state and triggers events for switching between states.
		 * @param	newState	A game state identifier for the new state to be activated.
		 */
		private function ChangeState(newState:uint):void
		{
			if (_states == null)
			{
				LogController.LogError(this, "No game states exist yet.");
				return;
			}
			
			_states[_currentState].ExitState();
			
			_currentState = newState;
			_states[_currentState].EnterState(this);
		}
		
		/**
		 * Sets up the possible game states.
		 */
		private function SetupStates():void
		{
			if (_states != null)
			{
				LogController.LogWarning(this, "Attempted to initialize game states more than once.");
				return;
			}
			
			_states = new Vector.<IGameState>();
			
			_states.push(new IdleState());
			STATE_IDLE = 0;
			
			_states.push(new PlayState());
			STATE_PLAY = 1;
			
			_states.push(new WinLoseState());
			STATE_WINLOSE = 2;
			
			_currentState = STATE_IDLE;
			_states[STATE_IDLE].EnterState(this);
		}
	}
	
}