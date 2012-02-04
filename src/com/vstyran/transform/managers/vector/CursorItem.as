package com.vstyran.transform.managers.vector
{
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.namespaces.tt_internal;
	
	import mx.core.IVisualElement;
	
	use namespace tt_internal;
	
	[DefaultProperty("cursor")]
	/**
	 * Value object for vector cursor item.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class CursorItem
	{
		/**
		 * Constructor. 
		 */		
		public function CursorItem()
		{
		}
		
		/**
		 * Control which uses this cursor. 
		 */	
		public var control:Control;
		
		/**
		 * Flag that indicates whether manage should rotate 
		 * cursor depends on transform tool rotation. 
		 */		
		public var maintainRotation:Boolean;
		
		/**
		 * Vector cursor object. 
		 */		
		public var cursor:IVisualElement;
		
		/**
		 * Number that specifies the x offset of the cursor, in pixels, relative to the mouse pointer.
		 */
		public var xOffset:Number = 0;
		
		/**
		 * Number that specifies the y offset of the cursor, in pixels, relative to the mouse pointer. 
		 */		
		public var yOffset:Number = 0;
		
		/**
		 * Original rotation of cursor object. Will be concatinated 
		 * with calculated rotation if maintainRotation is true .
		 */		
		public var originalRotation:Number = 0;
	}
}