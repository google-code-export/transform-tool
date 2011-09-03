package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.TargetData;
	
	import flash.geom.Point;

	public interface IOperation
	{
		
		function startOperation(data:TargetData, point:Point):void;
		function doOperation(point:Point):TargetData;
		function endOperation():TargetData;
	}
}