package com.vstyran.transform.controls
{
	
	import com.vstyran.transform.skins.AnchorSkin;
	import com.vstyran.transform.utils.SkinUtil;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 *  Normal State
	 */
	[SkinState("normal")]
	
	/**
	 *  Active State
	 */
	[SkinState("active")]
	
	/**
	 * Anchor component that used by operation as anchor point.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class Anchor extends SkinnableComponent implements IAnchor
	{
		// attach default skin
		SkinUtil.attachSkin("com.vstyran.transform.controls.Anchor", AnchorSkin);
		
		/**
		 * Constructor. 
		 */		
		public function Anchor()
		{
			super();
		}
		
		/**
		 * @private 
		 */		
		private var _anchorActivated:Boolean;

		/**
		 * Flag specifies whether anchor is currently used by operation. 
		 */		
		public function get anchorActivated():Boolean
		{
			return _anchorActivated;
		}

		/**
		 * @inheritDoc 
		 */		
		public function activateAnchor():void
		{
			_anchorActivated = true;
			
			invalidateSkinState();
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function deactivateAnchor():void
		{
			_anchorActivated = false;
			
			invalidateSkinState();
		}

		/**
		 * @inheritDoc 
		 */	
		override protected function getCurrentSkinState():String
		{
			return _anchorActivated ? "active" : "normal";
		} 
	}
}