package com.vstyran.transform.factories
{
	import com.vstyran.transform.model.TargetData;
	
	import mx.core.UIComponent;

	public class TargetExporter
	{
		public function TargetExporter()
		{
		}
		
		public function export(target:UIComponent, data:TargetData):UIComponent
		{
			target.x = data.x;
			target.y = data.y;
			target.width = data.width;
			target.height = data.height;
			target.rotation = data.rotation;
			
			return target;
		}
	}
}