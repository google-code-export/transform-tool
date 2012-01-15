package com.vstyran.transform.model
{
	[Bindable]
	/**
	 * Value object for aspect ratio data.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class AspectRatio
	{
		/**
		 * Constructor. 
		 */		
		public function AspectRatio()
		{
		}
		
		/**
		 * Aspect for width. 
		 * 
		 * For example if you set widthAspect = 1 and heightAspect = 1 then it will be snapped to square.
		 */	
		public var widthAspect:Number;
		
		/**
		 * Aspect for height. 
		 * 
		 * For example if you set widthAspect = 1 and heightAspect = 1 then it will be snapped to square.
		 */	
		public var heightAspect:Number;
		
		/**
		 * Max delta value that can be snapped.
		 * @default 0
		 */	
		public var fraction:Number=0;
	}
}