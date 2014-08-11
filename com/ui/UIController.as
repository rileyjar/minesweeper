package com.ui
{
	import com.logging.LogController;
	import flash.display.Sprite;
	
	/**
	 * Manages high level UI system functions such as opening and closing panels.
	 * @author Jared Riley
	 */
	public class UIController extends Sprite
	{
		/**
		 * A reference to the internal panel stack. The panel on top is the currently active window.
		 */
		private var _panelStack:Vector.<UIPanel>;
		
		/**
		 * Constructor.
		 */
		public function UIController():void
		{
			LogController.LogInfo(this, "Initializing UIController.");
			
			_panelStack = new Vector.<UIPanel>();
		}
		
		/**
		 * Opens a UI Panel by adding it to the window stack and adding it to the screen.
		 * Also triggers panel OnOpen event.
		 * @param	panel	The UI panel to open.
		 */
		public function OpenPanel(panel:UIPanel):void
		{
			_panelStack.push(panel);
			addChild(panel);
			panel.OnOpen();
		}
		
		/**
		 * Closes a UI panel by removing it from the window stack and from the screen.
		 * @param	panel	The panel to remove. If null, defaults to removing the current active window.
		 */
		public function ClosePanel(panel:UIPanel = null):void
		{
			if (_panelStack.length == 0)
			{
				return;
			}
			
			if (panel == null)
			{
				panel = _panelStack[_panelStack.length - 1];
			}
			
			// start from the top of the stack
			for (var i:int = _panelStack.length - 1; i >= 0; i--)
			{
				if (panel === _panelStack[i])
				{
					panel.OnClose();
					_panelStack.splice(i, 1);
					removeChild(panel);
					break;
				}
			}
		}
		
		/**
		 * Method called each game tick (frame) with the amount of time that has passed since the last tick.
		 * @param	deltaTime	The amount of time, in milliseconds, that have passed since the last game tick.
		 */
		public function Tick(deltaTime:int):void
		{
			for (var i:uint = 0; i < _panelStack.length; i++)
			{
				_panelStack[i].Tick(deltaTime);
			}
		}
	}
	
}