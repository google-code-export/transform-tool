package com.vstyran.transform.utils
{
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.GridData;
	import com.vstyran.transform.model.Guideline;
	
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	/**
	 * Utility class that has methods for manipulating display data.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class DataUtil
	{
		/**
		 * Create data from ui component.
		 *  
		 * @param target Source ui component.
		 * @return Display data.
		 */		
		public static function createData(target:UIComponent):DisplayData
		{
			var data:DisplayData = new DisplayData();
			data.x = Math.round(target.x);
			data.y = Math.round(target.y);
			data.width = Math.round(target.width*target.scaleX);
			data.height = Math.round(target.height*target.scaleY);
			data.rotation = target.rotation;
			
			data.minWidth = !isNaN(target.minWidth) ? target.minWidth * target.scaleX : NaN;
			data.minHeight = !isNaN(target.minHeight) ? target.minHeight * target.scaleY : NaN;
			data.maxWidth = !isNaN(target.maxWidth) ? target.maxWidth * target.scaleX : NaN;
			data.maxHeight = !isNaN(target.maxHeight) ? target.maxHeight * target.scaleY : NaN;
			
			return data;
		}
		
		/**
		 * Apply data on ui component. 
		 * 
		 * @param target UI component to which the data will be applied.
		 * @param data Display data.
		 * @param applyMinMax Flag that indicates whether min/max size should be applied.
		 */		
		public static function applyData(target:UIComponent, data:DisplayData, applyMinMax:Boolean = false):void
		{
			target.x = data.x;
			target.y = data.y;
			target.width = data.width/target.scaleX;
			target.height = data.height/target.scaleY;
			target.rotation = data.rotation;
			
			if(applyMinMax)
			{
				target.minWidth = !isNaN(data.minWidth) ? data.minWidth/target.scaleX : NaN;
				target.minHeight = !isNaN(data.minHeight) ? data.minHeight/target.scaleY : NaN;
				target.maxWidth = !isNaN(data.maxWidth) ? data.maxWidth/target.scaleX : NaN;
				target.maxHeight = !isNaN(data.maxHeight) ? data.maxHeight/target.scaleY : NaN;
			}
		}
		
		/**
		 * Fit position of data into bounds. 
		 *  
		 * @param data Source data to be fitted. Will be changed.
		 * @param bounds Bounds that will be used as fitting boundaries.
		 * @return Data with fitted position.
		 */		
		public static function fitData(data:DisplayData, bounds:Bounds):DisplayData 
		{
			if(bounds)
			{
				var boundsRight:Number;
				var boundsBottom:Number;
				var box:Rectangle;
				
				if(data.rotation == 0)
				{
					boundsRight =  bounds.right - data.width;
					boundsBottom =  bounds.bottom - data.height;
				}
				else
				{
					box = TransformUtil.getBoundingBox(data);
					
					boundsRight =  bounds.right - box.width;
					boundsBottom =  bounds.bottom - box.height;
					
					var newX:Number = MathUtil.fitValue(box.x, bounds.x, boundsRight);
					var newY:Number = MathUtil.fitValue(box.y, bounds.y, boundsBottom);
					
					data.x = MathUtil.round(newX + data.x - box.x, 2);
					data.y =  MathUtil.round(newY + data.y - box.y, 2);
					
					return data;
				}
				
				data.x = MathUtil.fitValue(data.x, bounds.x, boundsRight);
				data.y = MathUtil.fitValue(data.y, bounds.y, boundsBottom);
			}
			
			return data;
		}
		
		/**
		 * Snap position of data into grid. 
		 *  
		 * @param data Source data to be fitted. Will be changed.
		 * @param grid Grid that will be used as step size.
		 * @return Data with fitted position.
		 */		
		public static function snapData(data:DisplayData, grid:GridData):DisplayData 
		{
			if(grid)
			{
				if(data.rotation == 0)
				{
					data.x = MathUtil.snapValue(data.x, grid.x, grid.cellWidth, grid.fraction);
					data.y = MathUtil.snapValue(data.y, grid.y, grid.cellHeight, grid.fraction);
				}
				else
				{
					var box:Rectangle = TransformUtil.getBoundingBox(data);
					
					var newX:Number = MathUtil.snapValue(box.x, grid.x, grid.cellWidth, grid.fraction);
					var newY:Number = MathUtil.snapValue(box.y, grid.y, grid.cellWidth, grid.fraction);
					
					data.x = MathUtil.round(newX + data.x - box.x, 2);
					data.y = MathUtil.round(newY + data.y - box.y, 2);
				}
			}
			
			return data;
		}
		
		/**
		 * Snap data into guidelines. 
		 *  
		 * @param data Source data to be fitted. Will be changed.
		 * @param grid List of guidelines.
		 * @return Subset of guidelines that currently active.
		 */		
		public static function guideData(data:DisplayData, guidelines:Vector.<Guideline>):Vector.<Guideline> 
		{
			var result:Vector.<Guideline> = new Vector.<Guideline>();
			if(guidelines)
			{
				for each (var guideline:Guideline in guidelines) 
				{
					if(guideline.direction == Guideline.VERTICAL)
					{
						if(canUseGuideline(data.x, guideline.value, guideline.fraction))
						{
							data.x = guideline.value;
							result.push(guideline);
						}
					}
					else
					{
						if(canUseGuideline(data.y, guideline.value, guideline.fraction))
						{
							data.y = guideline.value;
							result.push(guideline);
						}
					}
				}
			}
			return result;
		}
		
		
		/**
		 * Snap to guide value. 
		 * 
		 * @param value Value to be guided.
		 * @param pos Guide position
		 * @param fraction Max delta value that can be guided.
		 * @return true if can be guided.
		 */		
		private static function canUseGuideline(value:Number, pos:Number, fraction:Number=0):Boolean
		{
			return Math.abs(value-pos) <= fraction;
		}
	}
}