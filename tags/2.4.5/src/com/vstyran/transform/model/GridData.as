package com.vstyran.transform.model
{
	import flash.geom.Point;

	/**
	 * Snapping grid.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class GridData
	{
		/**
		 * Constructor. 
		 */		
		public function GridData()
		{
		}
		
		/**
		 * Start grid position by X axis. 
		 */		
		public var x:Number = 0;
		
		/**
		 * Start grid position by Y axis. 
		 */	
		public var y:Number = 0;
		
		/**
		 * Width of grid cell. 
		 * @default 5
		 */		
		public var cellWidth:Number = 5;
		
		/**
		 * Height of grid cell.
		 * @default 5
		 */	
		public var cellHeight:Number = 5;
		
		/**
		 * Max delta value that can be snapped.
		 * @default NaN
		 */	
		public var fraction:Number;
	}
}