package com.vstyran.transform.model
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.utils.MatrixUtil;
	
	import spark.primitives.Rect;
	
	[Bindable]
	/**
	 * Value object of UI components that contains geometry info.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class DisplayData
	{
		//------------------------------------------------------------------
		//
		// Properties
		//
		//------------------------------------------------------------------
		/**
		 * @private
		 */
		private var _x:Number = 0;

		/**
		 * Position by X axis. 
		 */
		public function get x():Number
		{
			return _x;
		}

		/**
		 * @private
		 */
		public function set x(value:Number):void
		{
			if(_x == value) return;
			_x = value;
			invalidate();
		}

		/**
		 * @private
		 */
		private var _y:Number = 0;

		/**
		 * Position by Y axis. 
		 */
		public function get y():Number
		{
			return _y;
		}

		/**
		 * @private
		 */
		public function set y(value:Number):void
		{
			if(_y == value) return;
			_y = value;
			invalidate();
		}

		/**
		 * @private
		 */
		private var _width:Number = 0;

		/**
		 * Width of display object. 
		 */
		public function get width():Number
		{
			return _width;
		}

		/**
		 * @private
		 */
		public function set width(value:Number):void
		{
			if(_width == value) return;
			_width = value;
			invalidate();
		}

		/**
		 * @private
		 */
		private var _height:Number = 0;

		/**
		 * Height of display object. 
		 */
		public function get height():Number
		{
			return _height;
		}

		/**
		 * @private
		 */
		public function set height(value:Number):void
		{
			if(_height == value) return;
			_height = value;
			invalidate();
		}
		
		/**
		 * @private 
		 */		
		private var _rotation:Number = 0;
		
		/**
		 * Rotation of display object clamped between -180 and 180 degreeds. 
		 */
		public function get rotation():Number
		{
			return _rotation;
		}
		
		/**
		 * @private
		 */
		public function set rotation(value:Number):void
		{
			value = MatrixUtil.clampRotation(value);
			if(_rotation == value) return;
			_rotation = value;
			invalidate();
			
			var r:Rectangle;
			r.topLeft = new Point(10,20);
		}
		
		/**
		 * Minimum value for width. 
		 */
		public var minWidth:Number;
		
		/**
		 * Minimum value for height. 
		 */
		public var minHeight:Number;
		
		/**
		 * Maximum value for width. 
		 */
		public var maxWidth:Number;
		
		/**
		 * Maximum value for height. 
		 */
		public var maxHeight:Number;
		
		//------------------------------------------------------------------
		//
		// Getters
		//
		//------------------------------------------------------------------
		private var _topCenter:Point;
		public function get topCenter():Point
		{
			if(!_topCenter)
			{
				if(rotation == 0)
					_topCenter = new Point(x + width/2, 0);
			}
			return _topCenter;
		}
		
		private var _bottomCenter:Point;
		public function get bottom():Point
		{
			if(!_bottomCenter)
			{
				if(rotation == 0)
					_bottomCenter = new Point(x + width/2, y + height);
			}
			return _bottomCenter;
		}
		
		private var _leftMiddle:Point;
		public function get leftMiddle():Point
		{
			if(!_leftMiddle)
			{
				if(rotation == 0)
					_leftMiddle = new Point(0, y + height/2);
			}
			return _leftMiddle;
		}
		
		private var _rightMiddle:Point;
		public function get rightMiddle():Point
		{
			if(!_rightMiddle)
			{
				if(rotation == 0)
					_rightMiddle = new Point(x + width, y + height/2);
			}
			return _rightMiddle;
		}
		
		private var _topLeft:Point;
		public function get topLeft():Point
		{
			if(!_topLeft)
			{
				_topLeft = new Point(x, y);
			}
			return _topLeft;
		}
		
		private var _topRight:Point;
		public function get topRight():Point
		{
			if(!_topRight)
			{
				if(rotation == 0)
					_topRight = new Point(x + width, y);
			}
			return _topRight;
		}
		
		private var _bottomLeft:Point;
		public function get bottomLeft():Point
		{
			if(!_bottomLeft)
			{
				if(rotation == 0)
					_bottomLeft = new Point(x , y + height);
			}
			return _bottomLeft;
		}
		
		private var _bottomRight:Point;
		public function get bottomRight():Point
		{
			if(!_bottomRight)
			{
				if(rotation == 0)
					_bottomRight = new Point(x + width , y + height);
			}
			return _bottomRight;
		}
		
		private var _matrix:Matrix;
		public function get matrix():Matrix
		{
			if(!_matrix)
			{
			}
			return _matrix;
		}
		
		//------------------------------------------------------------------
		//
		// Private Methods
		//
		//------------------------------------------------------------------
		protected function invalidate():void
		{
			_topCenter = null;
			_bottomCenter = null;
			_leftMiddle = null;
			_rightMiddle = null;
			_topLeft = null;
			_topRight = null;
			_bottomLeft = null;
			_bottomRight = null;
			_matrix = null;
		}
		
		//------------------------------------------------------------------
		//
		// Methods
		//
		//------------------------------------------------------------------
		public function intersects():Boolean
		{
			return false;
		}
		
		public function contains(x:Number, y:Number):Boolean
		{
			return false;
		}
		public function containsData(data:DisplayData):Boolean
		{
			return false;
		}
		public function inflate(dx:Number, dy:Number):void
		{
			
		}
		public function offset(dx:Number, dy:Number):void
		{
			
		}
		public function inflateAroundPoint(centerPoint:Point, dx:Number, dy:Number):void
		{
			
		}
		public function setEmpty():void
		{
			
		}
		public function getOuterBoundingBox():Rectangle
		{
			return null;	
		}
		public function setOuterBoundingBox(rect:Rectangle):void
		{
		}
		public function getInnerBoundingBox():Rectangle
		{
			return null;
		}
		public function setInnerBoundingBox(rect:Rectangle):void
		{
		}
		public function getNaturalSize():Point
		{
			return null;
		}
		public function setNaturalSize(size:Point):void
		{
		}
		public function toString():String
		{
			return "";	
		}
		public function union(data:DisplayData, ...params):DisplayData
		{
			return null;
		}
		public function unionVector(data:Vector.<DisplayData>):DisplayData
		{
			return null;
		}
		public function unionArray(data:Vector.<DisplayData>):DisplayData
		{
			return null;
		}
		
		
		public function setTo(x:Number, y:Number, width:Number, height:Number, rotation:Number):void
		{
			
		}
		
		/**
		 * Clone data.
		 *  
		 * @return New data object with the same values
		 */		
		public function clone():DisplayData
		{
			var clone:DisplayData = new DisplayData();
			clone.x = x;
			clone.y = y;
			clone.width = width;
			clone.height = height;
			clone.rotation = rotation;
			
			clone.minWidth = minWidth;
			clone.minHeight = minHeight;
			clone.maxWidth = maxWidth;
			clone.maxHeight = maxHeight;
			
			return clone;
		}
		
		/**
		 * Compare data.
		 *  
		 * @return true id data is equals
		 */		
		public function compare(value:DisplayData):Boolean
		{
			return (value &&
					value.x == x &&
					value.y == y &&
					value.width == width &&
					value.height == height &&
					value.rotation == rotation &&
					value.minWidth == minWidth &&
					value.minHeight == minHeight &&
					value.maxWidth == maxWidth &&
					value.maxHeight == maxHeight);
		}
	}
}