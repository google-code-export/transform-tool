package com.vstyran.transform.model
{
	/**
	 * Snapping segments.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class SegmentData
	{
		/**
		 * Constructor. 
		 */
		public function SegmentData()
		{
		}
		
		/**
		 * Start angle for segmentation in degree.
		 * @default 0
		 */	
		public var startAngle:Number = 0;
		
		/**
		 * Delta angle of segmentation in degree.
		 * @default 45
		 */	
		public var deltaAngle:Number = 45;
		
		/**
		 * Max delta value that can be snapped.
		 * @default NaN
		 */	
		public var fraction:Number;
	}
}