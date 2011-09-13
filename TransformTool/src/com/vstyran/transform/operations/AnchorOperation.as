package com.vstyran.transform.operations
{
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class AnchorOperation implements IAncorOperation
	{
		
		[Bindable]
		public var anchor:Point;
		
		[Bindable]
		public var localAnchor:Point;
		
		public var startAnchor:Point;
		public var startLocalAnchor:Point;
		
		
		protected var startData:TargetData;
		protected var startPoint:Point;
		
		public function AnchorOperation()
		{
		}
		
		public function initOperation(data:TargetData, point:Point):void
		{
			trace("init");
			startData = data;
			startPoint = point;
			
			if(anchor)
			{
				startAnchor = TransformUtil.roundPoint(anchor.clone());
				var m:Matrix = getMatrix(null, startData);
				startLocalAnchor = TransformUtil.roundPoint(m.transformPoint(startAnchor));
			}
			else if(localAnchor)
			{
				startLocalAnchor = TransformUtil.roundPoint(localAnchor.clone());
				var m1:Matrix = getMatrix(startData, null);
				startAnchor = TransformUtil.roundPoint(m1.transformPoint(startLocalAnchor));
			}
		}
		
		public function doOperation(point:Point):TargetData
		{
			return null;
		}
		
		protected function getMatrix(fromContext:TargetData, toContext:TargetData):Matrix
		{
			var m:Matrix = new Matrix();
			
			if(fromContext)
			{
				m.rotate(fromContext.rotation*Math.PI/180);
				m.translate(fromContext.x,fromContext.y);
			}
			
			if(toContext)
			{
				var tm:Matrix = new Matrix();
				tm.rotate(toContext.rotation*Math.PI/180);
				tm.translate(toContext.x, toContext.y);
				tm.invert();
				m.concat(tm);
			}
			
			return m;
		}
	}
}