package com
{
	import com.game.GameController;
	import com.logging.LogController;
	import com.systems.InputController;
	import com.ui.UIController;
	import com.ui.panels.IntroductionPanel;
	import flash.display.*;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * This is the primary entry point for the Minesweeper game. Kicks off instantiation and manages critical systems.
	 * @author Jared Riley
	 */
	public class ApplicationDirector extends Sprite
	{
		/**
		 * A reference to the Singleton instance that has been created.
		 */
		private static var _instance:ApplicationDirector;
		
		/**
		 * Indicates whether a new ApplicationDirector instance can be created.
		 */
		private static var _canInstantiate:Boolean = false;
		
		/**
		 * How much time in milliseconds since the last game tick (Enter frame event).
		 */
		private var _lastTickTime:int;
		
		/**
		 * A reference to the game controller system.
		 */
		private var _gameController:GameController;
		
		/**
		 * A reference to the input system.
		 */
		private var _inputController:InputController;
		
		/**
		 * A reference to the UI system.
		 */
		private var _uiController:UIController;
		
		/**
		 * Returns a reference to the Game Controller.
		 */
		public function get gameController():GameController
		{
			return _gameController;
		}
		
		/**
		 * Returns a reference to the Input Controller.
		 */
		public function get inputController():InputController
		{
			return _inputController;
		}
		
		/**
		 * Returns a reference to the UI Controller.
		 */
		public function get uiController():UIController
		{
			return _uiController;
		}
		
		/**
		 * Constructor
		 */
		public function ApplicationDirector():void 
		{
			// Singleton Setup
			
			if (!_instance) 
			{
				_canInstantiate = true;
				_instance = this;
			}
			
			if (!_canInstantiate)
			{
				throw new Error ("Error: Use ApplicationDirector.GetInstance() method!");
			}
			
			// ---------------------------------------------------------------
			// --------------------- Initialization --------------------------
			// ---------------------------------------------------------------
			
			Setup();
			
			_uiController.OpenPanel(new IntroductionPanel());
			
			// ---------------------------------------------------------------
			// ------------------- End Initialization ------------------------
			// ---------------------------------------------------------------
			
			_canInstantiate = false;
		}
		
		/**
		 * Returns the working instance of the singleton for ApplicationDirector.
		 * @return The working instance of the singleton for ApplicationDirector.
		 */
		public static function GetInstance():ApplicationDirector 
		{
			if (!_instance) {
				_canInstantiate = true;
				_instance = new ApplicationDirector();
				_canInstantiate = false;
			}
			return _instance;
			
		}
		
		/**
		 * Sets up the application.
		 */
		private function Setup():void 
		{
			// Instantiate the logging system.
			LogController.HideAllLogs();
			LogController.LogInfo(this, "StartingApplication.");
			
			// Instantiate other key systems.
			_inputController = new InputController(stage);
			_uiController = new UIController();
			_gameController = new GameController(_inputController);
			
			addChild(_gameController);
			addChild(_uiController);
			
			// Add primary game tick event listener.
			_lastTickTime = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, OnEnterFrame);
		}
		
		/**
		 * Responsible for propagating the primary tick() event throughout the application.
		 * @param	event 	A reference to the ENTER_FRAME event.
		 */
		private function OnEnterFrame(event:Event):void {
			var timeSampled:int = getTimer();
			
			_gameController.Tick(timeSampled - _lastTickTime);
			
			_lastTickTime = timeSampled;
		}
	}
	
}