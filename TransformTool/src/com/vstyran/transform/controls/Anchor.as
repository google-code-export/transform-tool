package com.vstyran.transform.controls
{
	
	import spark.components.supportClasses.SkinnableComponent;
	
	[SkinState("normal")]
	[SkinState("active")]
	
	public class Anchor extends SkinnableComponent implements IAnchor
	{
		
		public function Anchor()
		{
			super();
		}
		
		private var _anchorActivated:Boolean;

		public function get anchorActivated():Boolean
		{
			return _anchorActivated;
		}

		public function set anchorActivated(value:Boolean):void
		{
			_anchorActivated = value;
			
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