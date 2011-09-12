package com.vstyran.transform.supportClasses
{
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;
	
	public class SimpleExporter implements IExporter
	{
		public function SimpleExporter()
		{
		}
		
		public function export(target:UIComponent, data:TargetData):TargetData
		{
			if(!target)
				return data;
			
			target.x = data.x;
			target.y = data.y;
			target.width = Math.min(Math.max(data.width/target.scaleX, target.minWidth), target.maxWidth);
			target.height = Math.min(Math.max(data.height/target.scaleY, target.minHeight), target.maxHeight);
			target.rotation = data.rotation;
			
			return TransformUtil.createData(target);
		}
	}
}