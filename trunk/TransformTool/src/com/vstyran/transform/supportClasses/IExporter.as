package com.vstyran.transform.supportClasses
{
	import com.vstyran.transform.model.TargetData;
	
	import mx.core.UIComponent;

	public interface IExporter
	{
		function export(target:UIComponent, data:TargetData):TargetData;
	}
}