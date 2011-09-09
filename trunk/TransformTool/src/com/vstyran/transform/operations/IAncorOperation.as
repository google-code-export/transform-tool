package com.vstyran.transform.operations
{
	import flash.geom.Point;

	public interface IAncorOperation extends IOperation
	{
		function set anchor(point:Point):void;
	}
}