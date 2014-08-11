package com.ui.panels
{
	import com.ApplicationDirector;
	import com.logging.LogController;
	import com.ui.UIPanel;
	import com.ui.elements.UIButton;
	
	/**
	 * Provides functionality behind the Introduction Window.
	 * @author Jared Riley
	 */
	public class IntroductionPanel extends UIPanel 
	{
		/**
		 * Event triggered when this panel is opened and added to the screen.
		 */
		public override function OnOpen():void
		{
			super.OnOpen();
			
			LogController.LogInfo(this, "Introduction Panel opened.");
			
			this.x = 0;
			this.y = 60;
			
			var nextButton:UIButton = new UIButton("Got it! Let's play!", OnNextClick);
			nextButton.x = 103;
			nextButton.y = 194;
			AddUIElement(nextButton);
		}
		
		/**
		 * Event triggered when this panel is closed and removed from the screen.
		 */
		public override function OnClose():void
		{
			super.OnClose();
			
			LogController.LogInfo(this, "Introduction Panel closed.");
		}
		
		/**
		 * Event triggered when the Next button is clicked.
		 */
		private function OnNextClick():void
		{
			ApplicationDirector.GetInstance().uiController.ClosePanel(this);
			ApplicationDirector.GetInstance().uiController.OpenPanel(new NewGamePanel("New Game!", "Choose a difficulty setting..."));
		}
	}
	
}