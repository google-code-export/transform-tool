package com.vstyran.transform.operations
{
	import com.vstyran.transform.consts.TransformationType;
	import com.vstyran.transform.model.AspectRatio;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.utils.DataUtil;
	import com.vstyran.transform.utils.MathUtil;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * Resize operation.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class ResizeOperation extends AnchorOperation
	{
		/**
		 * Constructor. 
		 */		
		public function ResizeOperation()
		{
			super();
		}
		
		/**
		 * Flag that indicates whether vertical resizing is enebled. 
		 */		
		public var verticalEnabled:Boolean = true;
		
		/**
		 * Flag that indicates whether horizontal resizing is enebled. 
		 */
		public var horizontalEnabled:Boolean = true;
		
		/**
		 * Flag that indicates whether aspect ratio should be kept. 
		 */
		public var maintainAspectRatio:Boolean = false;
		
		/**
		 * List of aspect ratios that will be used for snapping.  
		 */	
		public var aspects:Vector.<AspectRatio>;
		
		/**
		 * Flag indicates whether resizing should be snapped into aspect ratios 
		 * if it is specified and maintainAspectRatio is false. 
		 */		
		public var maintainAspects:Boolean = true;
		
		/**
		 * @inheritDoc
		 */		
		override public function get type():String
		{
			return TransformationType.RESIZE;
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function doOperation(point:Point):DisplayData
		{
			//reset guideline cross
			guideCross = null;
			
			var data:DisplayData = startData.clone();
			data.precision = 2;
			
			var deltaPoint:Point = MathUtil.roundPoint(new Point(point.x - startPoint.x, point.y - startPoint.y));
			var newSize:Point = data.size;
			
			// calculate new width
			if(horizontalEnabled)
				newSize.x = data.width + data.width*deltaPoint.x/(startPoint.x-startAnchor.x);
			
			// calculate new height
			if(verticalEnabled)
				newSize.y = data.height + data.height*deltaPoint.y/(startPoint.y-startAnchor.y);
			
			//keep aspect ratio
			if(maintainAspectRatio) 
				newSize = startData.resolveAspectRatio(newSize, horizontalEnabled, verticalEnabled);
			
			// invoke user snapping function
			var userData:DisplayData;
			if(snappingFunction != null)
			{
				userData = data.clone();
				userData.inflate(newSize.x - startData.width, newSize.y - startData.height, startAnchor);
				
				// fit into bounds and resolve aspect ratio
				if(data.rotation%90 == 0)
					userData = DataUtil.fitResizingData(userData, bounds);

				userData = invokeSnappingFunction(this, userData, startAnchor);
			}
			
			var fitData:DisplayData = data;
			if(userData)
			{
				// use snapped data
				newSize = new Point(userData.width, userData.height);
				fitData = userData;
			}
			else
			{
				// recalculate new size keeping min/max values
				newSize = data.resolveMinMax(newSize);
				
				// guide data
				if(data.rotation%90 == 0 && maintainGuidelines && guidelines && guidelines.length > 0)
				{
					var guidData:DisplayData = data.clone();
					guidData.inflate(newSize.x - startData.width, newSize.y - startData.height, startAnchor);
					var currentAnchor:Point = new Point(startAnchor.x*guidData.width/startData.width, startAnchor.y*guidData.height/startData.height);
					guideCross = DataUtil.guideSize(data.clone(), guidData, currentAnchor, guidelines);
					fitData = guidData;
				}
			}
			
			// fit into bounds and resolve aspect ratio
			if(data.rotation%90 == 0)
				newSize = resolveAspectRatio(DataUtil.fitResizingData(fitData, bounds), newSize);
			
			
			// check aspects if not maintaining aspect ratio and not guided
			if(!userData && !maintainAspectRatio && maintainAspects && (!guideCross || (!guideCross.vGuideline && !guideCross.hGuideline)))
			{
				var aspectData:DisplayData = data.clone();
				aspectData.inflate(newSize.x - startData.width, newSize.y - startData.height, startAnchor);
				var aspect:AspectRatio = DataUtil.snapAspects(startData, aspectData, aspects, horizontalEnabled, verticalEnabled);
				
				if(aspect)
					newSize = new Point(aspectData.width, aspectData.height);
			}
			
			// check min/max values
			newSize = data.resolveMinMax(newSize);
			
			// set new size
			data.inflate(newSize.x - data.width, newSize.y - data.height, startAnchor);
			
			// check pasive guidelines
			if(data.rotation%90 == 0)
				guideCross = DataUtil.getPreciseGuides(data, guideCross, guidelines);
			
			return data;
		}
		
		/**
		 * @private 
		 */		
		private function resolveAspectRatio(data:DisplayData, lastSize:Point):Point
		{
			var resolvedSize:Point = new Point(data.width, data.height);
			
			if(maintainAspectRatio)
			{
				var vChanged:Boolean = resolvedSize.y != MathUtil.round(lastSize.y,2);
				var hChanged:Boolean = resolvedSize.x != MathUtil.round(lastSize.x,2);
				
				// if snapped to two guides we will use less snapping value
				if(vChanged && hChanged)
				{
					if(Math.abs(resolvedSize.x-MathUtil.round(lastSize.x,2)) >= Math.abs(resolvedSize.y-MathUtil.round(lastSize.y,2)))
						hChanged = false;
					else
						vChanged = false;
				}
				
				if(vChanged || hChanged)
					resolvedSize = startData.resolveAspectRatio(resolvedSize, !vChanged, !hChanged );
			}
			
			return resolvedSize;
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function endOperation(point:Point):DisplayData
		{
			var data:DisplayData = doOperation(point);
			
			DataUtil.fitData(data, bounds);
			
			return data;
		}
	}
}