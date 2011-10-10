package com.vstyran.transform.utils
{
	import com.vstyran.transform.model.Bounds;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.GridData;
	
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
		 * Fit position of data into grid and bounds. 
		 *  
		 * @param data Source data to be fitted. Will be changed.
		 * @param grid Grid that will be used as step size.
		 * @param bounds Bounds that will be used as fitting boundaries.
		 * @return Data with fitted position.
		 */		
		public static function fitPosition(data:DisplayData, grid:GridData, bounds:Bounds):DisplayData 
		{
			if(grid || bounds)
			{
				var boundsRight:Number;
				var boundsBottom:Number;
				var box:Rectangle;
				
				if(bounds)
				{
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
						
						var newX:Number = MathUtil.fitValue(box.x, bounds.x, boundsRight, 
							grid ? grid.x: NaN,
							grid ? grid.cellWidth: NaN, 
							grid ? grid.fraction: NaN);
						var newY:Number = MathUtil.fitValue(box.y, bounds.y, boundsBottom, 
							grid ? grid.y: NaN,
							grid ? grid.cellHeight: NaN, 
							grid ? grid.fraction: NaN);
						
						data.x = box ? MathUtil.round(newX + data.x - box.x, 2) : newX;
						data.y = box ? MathUtil.round(newY + data.y - box.y, 2) : newY;
						
						return data;
					}
				}
				
				data.x = MathUtil.fitValue(data.x, bounds.x, boundsRight,
					grid ? grid.x: NaN,
					grid ? grid.cellWidth: NaN, 
					grid ? grid.fraction: NaN);
				
				data.y = MathUtil.fitValue(data.y, bounds.y, boundsBottom,
					grid ? grid.y: NaN,
					grid ? grid.cellHeight: NaN, 
					grid ? grid.fraction: NaN);
			}
			
			return data;
		}
	}
}