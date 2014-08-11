package com.ui.elements
{
	import com.ui.UIElement;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	/**
	 * Provides basic functionality for a simple UI Button element.
	 * @author Jared Riley
	 */
	public class UIButton extends UIElement
	{
		/**
		 * The function to call when this button is clicked by the user.
		 */
		private var _clickCallback:Function;
		
		/**
		 * Constructor.  Creates a new UIButton instance.
		 * @param	buttonLabel		The label to display on the button.
		 * @param	clickCallback	The function to call when this button is clicked by the user.
		 */
		public function UIButton(buttonLabel:String, clickCallback:Function):void
		{
			super();
			
			_clickCallback = clickCallback;
			this.label_txt.text = buttonLabel;
			
			addEventListener(MouseEvent.MOUSE_DOWN, OnMouseClick);
			addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			addEventListener(MouseEvent.MOUSE_OVER, OnMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut);
		}
		
		/**
		 * Event triggered when the user clicks on the button.
		 * @param	event	A reference to the MouseEvent providing context.
		 */
		private function OnMouseClick(event:MouseEvent):void
		{
			if (_clickCallback != null)
			{
				_clickCallback();
			}
			
			gotoAndStop(3);
		}
		
		/**
		 * Event triggered when the mouse rises from a click.
		 * @param	event	A reference to the MouseEvent providing context.
		 */
		private function OnMouseUp(event:MouseEvent):void
		{
			gotoAndStop(1);
		}
		
		/**
		 * Event triggered when the user rolls over the button.
		 * @param	event	A reference to the MouseEvent providing context.
		 */
		private function OnMouseOver(event:MouseEvent):void
		{
			gotoAndStop(2);
			Mouse.cursor = MouseCursor.BUTTON;
			
		}
		
		/**
		 * Event triggered when the user rolls off the button.
		 * @param	event	A reference to the MouseEvent providing context.
		 */
		private function OnMouseOut(event:MouseEvent):void
		{
			gotoAndStop(1);
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		/**
		 * Destroys this instance by removing listeners and cleaning up memory.
		 * Note: Designed to be overridden.
		 */
		public override function Destroy():void
		{
			super.Destroy();
			
			_clickCallback = null;
			
			Mouse.cursor = MouseCursor.ARROW;
			
			removeEventListener(MouseEvent.MOUSE_DOWN, OnMouseClick);
			removeEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			removeEventListener(MouseEvent.MOUSE_OVER, OnMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, OnMouseOut);
		}
	}
	
}