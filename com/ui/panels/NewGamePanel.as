package com.ui.panels
{
	import com.ApplicationDirector;
	import com.logging.LogController;
	import com.ui.UIPanel;
	import com.game.map.*;
	import com.ui.elements.UIButton;
	
	/**
	 * Provides functionality behind the Introduction Window.
	 * @author Jared Riley
	 */
	public class NewGamePanel extends UIPanel 
	{
		/**
		 * The text to display in the header region.
		 */
		private var _headerLabel:String;
		
		/**
		 * The text to display in the description region.
		 */
		private var _descriptionLabel:String;
		
		/**
		 * Constructor. Creates a new NewGamePanel instance.
		 * @param	headerLabel			The text to display in the header region.
		 * @param	descriptionLabel	The text to display in the description region.
		 */
		public function NewGamePanel(headerLabel:String, descriptionLabel:String):void
		{
			_headerLabel = headerLabel;
			_descriptionLabel = descriptionLabel;
		}
		
		/**
		 * Event triggered when this panel is opened and added to the screen.
		 */
		public override function OnOpen():void
		{
			super.OnOpen();
			
			LogController.LogInfo(this, "New Game Panel opened.");
			
			this.x = 0;
			this.y = 60;
			
			header_txt.text = _headerLabel;
			description_txt.text = _descriptionLabel;
			
			var easyButton:UIButton = new UIButton("Easy", OnEasyClicked);
			easyButton.x = 100;
			easyButton.y = 109;
			AddUIElement(easyButton);
			
			var mediumButton:UIButton = new UIButton("Medium", OnMediumClicked);
			mediumButton.x = 100;
			mediumButton.y = 146;
			AddUIElement(mediumButton);
			
			var hardButton:UIButton = new UIButton("Hard", OnHardClicked);
			hardButton.x = 100;
			hardButton.y = 183;
			AddUIElement(hardButton);
		}
		
		/**
		 * Event triggered when this panel is closed and removed from the screen.
		 */
		public override function OnClose():void
		{
			super.OnClose();
			
			LogController.LogInfo(this, "New Game Panel closed.");
		}
		
		/**
		 * Event triggered when the Easy button is clicked.
		 */
		private function OnEasyClicked():void
		{
			var settings:MapSettings = MapSettings.Easy();
			var factory:IMapFactory = new RandomMapFactory();
			
			ApplicationDirector.GetInstance().uiController.ClosePanel(this);
			ApplicationDirector.GetInstance().gameController.StartGame(factory, settings);
		}
		
		/**
		 * Event triggered when the Easy button is clicked.
		 */
		private function OnMediumClicked():void
		{
			var settings:MapSettings = MapSettings.Medium();
			var factory:IMapFactory = new RandomMapFactory();
			
			ApplicationDirector.GetInstance().uiController.ClosePanel(this);
			ApplicationDirector.GetInstance().gameController.StartGame(factory, settings);
		}
		
		/**
		 * Event triggered when the Easy button is clicked.
		 */
		private function OnHardClicked():void
		{
			var settings:MapSettings = MapSettings.Hard();
			var factory:IMapFactory = new RandomMapFactory();
			
			ApplicationDirector.GetInstance().uiController.ClosePanel(this);
			ApplicationDirector.GetInstance().gameController.StartGame(factory, settings);
		}
	}
	
}