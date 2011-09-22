package com.vstyran.transform.controls
{
	
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("normal")]
	[SkinState("active")]
	
	public class Anchor extends SkinnableComponent implements IAnchor
	{
		include "../Version.as";
		
		public function Anchor()
		{
			super();
		}
		
		private var _anchorActivated:Boolean;

		public function get anchorActivated():Boolean
		{
			return _anchorActivated;
		}

		public function activateAnchor():void
		{
			_anchorActivated = true;
			
			invalidateSkinState();
		}
		
		public function deactivateAnchor():void
		{
			_anchorActivated = false;
			
			invalidateSkinState();
		}

		
		override protected function getCurrentSkinState():String
		{
			return _anchorActivated ? "active" : "normal";
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
	}
}