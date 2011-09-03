package com.vstyran.transform.factories
{
	import com.vstyran.transform.model.TargetData;
	
	import mx.core.UIComponent;

	public class TargetImporter
	{
		public function TargetImporter()
		{
		}
		
		public function importData(component:UIComponent):TargetData
		{
			var data:TargetData = new TargetData();
			data.x = component.x;
			data.y = component.y;
			data.width = component.width;
			data.height = component.height;
			data.rotation = component.rotation;
			
			return data;
		}
	}
}