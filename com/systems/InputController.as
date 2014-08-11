package com.systems
{
	import com.events.ClickEvent;
	import com.logging.LogController;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * Manages game inputs by acting as a middle man between the game and other systems.
	 * @author Jared Riley
	 */
	public class InputController extends EventDispatcher
	{
		/**
		 * Event triggered when the player has performed a "Click" action.
		 */
		public static var EVENT_CLICK:String = "inputControllerClicked";
		
		/**
		 * Event triggered when the player has performed a "Click" action while holding down a 'command' key.
		 */
		public static var EVENT_COMMAND_CLICK:String = "inputControllerCommandClicked";
		
		/**
		 * Constructor.  Intializes the InputController system.
		 * @param	stage	A reference to the game stage, used to listen for global mouse events.
		 */
		public function InputController(stage:Stage):void
		{
			LogController.LogInfo(this, "Initializing InputController.");
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseClicked);
		}
		
		/**
		 * Method called when the player has clicked in the game.
		 * @param	event	A reference to the MouseEvent object with details regarding the mouse click.
		 */
		private function OnMouseClicked(event:MouseEvent):void
		{
			if ((event.shiftKey) || (event.ctrlKey) || (event.altKey))
			{
				dispatchEvent(new ClickEvent(EVENT_COMMAND_CLICK, new Point(event.stageX, event.stageY)));
			}
			else
			{
				dispatchEvent(new ClickEvent(EVENT_CLICK, new Point(event.stageX, event.stageY)));
			}
		}
	}
	
}