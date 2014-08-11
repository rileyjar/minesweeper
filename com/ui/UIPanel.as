package com.ui
{
	import flash.display.MovieClip;
	
	/**
	 * Provides common functionality for all UIPanels including UI element management.
	 * @author Jared Riley
	 */
	public class UIPanel extends MovieClip
	{
		/**
		 * The internal list of UI elements that have been added to this panel.
		 */
		private var _uiElements:Vector.<UIElement>;
		
		/**
		 * Constructor.
		 */
		public function UIPanel():void
		{
			_uiElements = new Vector.<UIElement>;
		}
		
		/**
		 * Event triggered when this panel is opened and added to the screen.
		 * Note: This method should be overridden by child classes.
		 */
		public function OnOpen():void
		{
			// do nothing
		}
		
		/**
		 * Event triggered when this panel is closed and removed to the screen.
		 * Note: This method should be overridden by child classes (call super.OnClose() first).
		 */
		public function OnClose():void
		{
			for (var i:uint = 0; i < _uiElements.length; i++)
			{
				removeChild(_uiElements[i]);
				_uiElements[i].Destroy();
			}
			_uiElements.length = 0;
			_uiElements = null;
		}
		
		/**
		 * Adds a UIElement to the panel and displays it.
		 * @param	element	The UI element to be added.
		 */
		public function AddUIElement(element:UIElement):void
		{
			addChild(element);
			_uiElements.push(element);
		}
		
		/**
		 * Removes a UIElement from the panel.
		 * @param	element	The UI element to be removed.
		 */
		public function RemoveUIElement(element:UIElement):void
		{
			for (var i:uint = 0; i < _uiElements.length; i++)
			{
				if (_uiElements[i] === element)
				{
					removeChild(_uiElements[i]);
					_uiElements[i].Destroy();
					_uiElements.splice(i, 1);
					break;
				}
			}
		}
		
		/**
		 * Method called each game tick (frame) with the amount of time that has passed since the last tick.
		 * @param	deltaTime	The amount of time, in milliseconds, that have passed since the last game tick.
		 */
		public function Tick(timeDelta:uint):void
		{
			
		}
		
	}
	
}