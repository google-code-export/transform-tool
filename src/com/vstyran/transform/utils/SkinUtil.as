package com.vstyran.transform.utils
{
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	/**
	 * Utility class that has methods for work with skins.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class SkinUtil
	{
		/**
		 * Apply skin to component. 
		 * 
		 * @param host Full path to component with packages, 
		 * for example "com.components.MyComponent"
		 * @param skin Skin class
		 */		
		public static function attachSkin(host:String, skin:Class):void
		{
			var styles:CSSStyleDeclaration = StyleManager.getStyleManager(null).getStyleDeclaration(host);
			if(!styles)
				styles = new CSSStyleDeclaration();
			
			styles.defaultFactory = function():void
			{	
				// default styles for the component
				this.skinClass = skin;
			}
			StyleManager.getStyleManager(null).setStyleDeclaration(host, styles, false);
		}
	}
}