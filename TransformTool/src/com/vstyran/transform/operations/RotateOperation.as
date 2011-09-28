package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Rotate operation.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class RotateOperation extends AnchorOperation
	{
		include "../Version.as";
		
		/**
		 * Constructor. 
		 */		
		public function RotateOperation()
		{
			super();
		}
		
		/**
		 *   The amount of degree that used as tep size for rotation. 
		 */		
		public var stepDegree:Number;
		
		/**
		 * @inheritDoc 
		 */		
		override public function doOperation(point:Point):DisplayData
		{
			var data:DisplayData = startData.clone();
			
			var initialAngle:Number =  Math.atan2(startPoint.y - startAnchor.y, startPoint.x - startAnchor.x) * 180/Math.PI;
			
			var alpha:Number =  Math.atan2(point.y - startAnchor.y, point.x - startAnchor.x) * 180/Math.PI ;
			data.rotation += alpha-initialAngle; 
			
			if(!isNaN(stepDegree) && stepDegree > 0)
				data.rotation = Math.round(data.rotation/stepDegree)*stepDegree;
			else
				data.rotation = MathUtil.round(data.rotation, 2);
			
			// calculates anchor in tool panel space
			var m:Matrix = new Matrix();
			m.rotate(startData.rotation * Math.PI/180);
			m.translate(startData.x, startData.y);
			var globalAnchor:Point = m.transformPoint(new Point(startAnchor.x, startAnchor.y));	
			
			// calculates position
			m = new Matrix();
			m.translate(-startAnchor.x, -startAnchor.y);
			m.rotate(data.rotation*Math.PI/180);
			m.translate(globalAnchor.x, globalAnchor.y);
			
			var pos:Point = MathUtil.roundPoint(m.transformPoint(new Point(0, 0)), 2);
			
			data.x = pos.x;
			data.y = pos.y;
			
			return data;
		}
	}
}