package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.TargetData;
	
	import flash.geom.Point;
	
	public class MoveOperation implements IOperation
	{
		public function MoveOperation()
		{
		}
		
		protected var startData:TargetData;
		protected var startPoint:Point;
		
		protected var data:TargetData;
		
		public function startOperation(data:TargetData, point:Point):void
		{
			startData = data;
			startPoint = point;
		}
		
		public function doOperation(point:Point):TargetData
		{
			data = startData.clone();
			data.x = startData.x + point.x - startPoint.x;
			data.y = startData.y + point.y - startPoint.y;
			
			return data;
		}
		
		public function endOperation():TargetData
		{
			return data;
		}
	}
}