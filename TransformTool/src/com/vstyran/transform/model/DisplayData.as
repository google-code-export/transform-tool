package com.vstyran.transform.model
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.effects.Fade;
	import mx.utils.MatrixUtil;
	
	import spark.primitives.Rect;
	
	/**
	 * Value object of UI components that contains geometry info.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class DisplayData extends EventDispatcher
	{
		//------------------------------------------------------------------
		//
		// Standard Properties
		//
		//------------------------------------------------------------------
		/**
		 * @private
		 */
		private var _x:Number = 0;
		
		[Bindable("xChanged")]
		/**
		 * Position by X axis. 
		 */
		public function get x():Number
		{
			return round(_x);
		}
		
		/**
		 * @private
		 */
		public function set x(value:Number):void
		{
			if(_x == value) return;
			_x = value;
			invalidate();
			dispatchEvent(new Event("xChanged"));
		}
		
		/**
		 * @private
		 */
		private var _y:Number = 0;
		
		[Bindable("yChanged")]
		/**
		 * Position by Y axis. 
		 */
		public function get y():Number
		{
			return round(_y);
		}
		
		/**
		 * @private
		 */
		public function set y(value:Number):void
		{
			if(_y == value) return;
			_y = value;
			invalidate();
			dispatchEvent(new Event("xChanged"));
		}
		
		/**
		 * @private
		 */
		private var _width:Number = 0;
		
		[Bindable("widthChanged")]
		/**
		 * Width of display object. 
		 */
		public function get width():Number
		{
			return round(_width);
		}
		
		/**
		 * @private
		 */
		public function set width(value:Number):void
		{
			if(_width == value) return;
			_width = value;
			invalidate();
			dispatchEvent(new Event("widthChanged"));
		}
		
		/**
		 * @private
		 */
		private var _height:Number = 0;
		
		[Bindable("heightChanged")]
		/**
		 * Height of display object. 
		 */
		public function get height():Number
		{
			return round(_height);
		}
		
		/**
		 * @private
		 */
		public function set height(value:Number):void
		{
			if(_height == value) return;
			_height = value;
			invalidate();
			dispatchEvent(new Event("heightChanged"));
		}
		
		/**
		 * @private 
		 */		
		private var _rotation:Number = 0;
		
		[Bindable("rotationChanged")]
		/**
		 * Rotation of display object clamped between -180 and 180 degrees. 
		 */
		public function get rotation():Number
		{
			return round(_rotation);
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
			dispatchEvent(new Event("rotationChanged"));
		}
		
		/**
		 * @private
		 */
		private var _minWidth:Number;

		[Bindable]
		/**
		 * Minimum value for width. 
		 */
		public function get minWidth():Number
		{
			return round(_minWidth);
		}

		/**
		 * @private
		 */
		public function set minWidth(value:Number):void
		{
			_minWidth = value;
		}

		
		private var _minHeight:Number;

		[Bindable]
		/**
		 * Minimum value for height. 
		 */
		public function get minHeight():Number
		{
			return round(_minHeight);
		}

		/**
		 * @private
		 */
		public function set minHeight(value:Number):void
		{
			_minHeight = value;
		}

		/**
		 * @private
		 */
		private var _maxWidth:Number;

		[Bindable]
		/**
		 * Maximum value for width. 
		 */
		public function get maxWidth():Number
		{
			return round(_maxWidth);
		}

		/**
		 * @private
		 */
		public function set maxWidth(value:Number):void
		{
			_maxWidth = value;
		}

		/**
		 * @private
		 */
		private var _maxHeight:Number;

		[Bindable]
		/**
		 * Maximum value for height. 
		 */
		public function get maxHeight():Number
		{
			return round(_maxHeight);
		}

		/**
		 * @private
		 */
		public function set maxHeight(value:Number):void
		{
			_maxHeight = value;
		}

		
		//------------------------------------------------------------------
		//
		// Additional properties
		//
		//------------------------------------------------------------------
		/**
		 * @private
		 */
		private var _precisionValue:uint = 100000;
		
		/**
		 * @private
		 */
		private var _precision:uint = 5;

		[Bindable]
		/**
		 *  Number of decimal places to include in the output values.
		 *  For example, if the "x" value is 1.453 and precision is 1 than 
		 *  getter for "x" property returns rounded value of 1.5.
		 */		
		public function get precision():uint
		{
			return _precision;
		}

		/**
		 * @private
		 */
		public function set precision(value:uint):void
		{
			if(_precision == value) return;
			
			_precision = Math.min(value, 5);
			
			_precisionValue = _precision >= 0 ? Math.pow(10, precision) : 0;
		}

		/**
		 * Data size. 
		 */		
		public function get size():Point
		{
			return new Point(width, height);
		}
		
		/**
		 * @private
		 */
		public function set size(value:Point):void
		{
			_width = value.x;
			_height = value.y;
			
			invalidate();
			
			dispatchEvent(new Event("widthChanged"));
			dispatchEvent(new Event("heightChanged"));
		}
		
		/**
		 * Data position. 
		 */
		public function get position():Point
		{
			return new Point(x, y);
		}
		
		/**
		 * @private
		 */
		public function set position(value:Point):void
		{
			_x = value.x;
			_y = value.y;
			
			invalidate();
			
			dispatchEvent(new Event("xChanged"));
			dispatchEvent(new Event("yChanged"));
		}
		
		/**
		 * @private
		 */
		private var _topCenter:Point;
		
		[Bindable("invalidated")]
		/**
		 * Top center point in data holders' coordinate space. 
		 * </br>
		 * For rotation 0 will be (x + width/2, y).
		 */		
		public function get topCenter():Point
		{
			if(!_topCenter)
			{
				if(rotation == 0)
					_topCenter = new Point(x + width/2, y);
				else				
					_topCenter = matrix.transformPoint(new Point(width/2, 0));
			}
			return new Point(round(_topCenter.x), round(_topCenter.y));
		}
		
		/**
		 * @private
		 */
		private var _bottomCenter:Point;
		
		[Bindable("invalidated")]
		/**
		 * Bottom center point in data holders' coordinate space. 
		 * </br>
		 * For rotation 0 will be (x + width/2, y + height).
		 */	
		public function get bottomCenter():Point
		{
			if(!_bottomCenter)
			{
				if(rotation == 0)
					_bottomCenter = new Point(x + width/2, y + height);
				else				
					_bottomCenter = matrix.transformPoint(new Point(width/2, height));
			}
			return new Point(round(_bottomCenter.x), round(_bottomCenter.y));
		}
		
		/**
		 * @private
		 */
		private var _middleLeft:Point;
		
		[Bindable("invalidated")]
		/**
		 * Middle left point in data holders' coordinate space. 
		 * </br>
		 * For rotation 0 will be (x, y + height/2).
		 */	
		public function get middleLeft():Point
		{
			if(!_middleLeft)
			{
				if(rotation == 0)
					_middleLeft = new Point(x, y + height/2);
				else				
					_middleLeft = matrix.transformPoint(new Point(0, height/2));
			}
			return new Point(round(_middleLeft.x), round(_middleLeft.y));
		}
		
		/**
		 * @private
		 */
		private var _middleRight:Point;
		
		[Bindable("invalidated")]
		/**
		 * Middle right point in data holders' coordinate space. 
		 * </br>
		 * For rotation 0 will be (x + width, y + height/2).
		 */	
		public function get middleRight():Point
		{
			if(!_middleRight)
			{
				if(rotation == 0)
					_middleRight = new Point(x + width, y + height/2);
				else				
					_middleRight = matrix.transformPoint(new Point(width, height/2));
			}
			return new Point(round(_middleRight.x), round(_middleRight.y));
		}
		
		/**
		 * @private
		 */
		private var _topLeft:Point;
		
		[Bindable("invalidated")]
		/**
		 * Top left point in data holders' coordinate space. 
		 * </br>
		 * Will be always (x, y).
		 */	
		public function get topLeft():Point
		{
			if(!_topLeft)
			{
				_topLeft = new Point(x, y);
			}
			return new Point(round(_topLeft.x), round(_topLeft.y));
		}
		
		/**
		 * @private
		 */
		private var _topRight:Point;
		
		[Bindable("invalidated")]
		/**
		 * Top right point in data holders' coordinate space. 
		 * </br>
		 * For rotation 0 will be (x + width, y).
		 */	
		public function get topRight():Point
		{
			if(!_topRight)
			{
				if(rotation == 0)
					_topRight = new Point(x + width, y);
				else
					_topRight = matrix.transformPoint(new Point(width, 0));
			}
			return new Point(round(_topRight.x), round(_topRight.y));
		}
		
		/**
		 * @private
		 */
		private var _bottomLeft:Point;
		
		[Bindable("invalidated")]
		/**
		 * Bottom left point in data holders' coordinate space. 
		 * </br>
		 * For rotation 0 will be (x, y + height).
		 */	
		public function get bottomLeft():Point
		{
			if(!_bottomLeft)
			{
				if(rotation == 0)
					_bottomLeft = new Point(x , y + height);
				else				
					_bottomLeft = matrix.transformPoint(new Point(0, height));
			}
			return new Point(round(_bottomLeft.x), round(_bottomLeft.y));
		}
		
		/**
		 * @private
		 */
		private var _bottomRight:Point;
		
		[Bindable("invalidated")]
		/**
		 * Bottom right point in data holders' coordinate space. 
		 * </br>
		 * For rotation 0 will be (x + width, y + height).
		 */	
		public function get bottomRight():Point
		{
			if(!_bottomRight)
			{
				if(rotation == 0)
					_bottomRight = new Point(x + width , y + height);
				else
					_bottomRight = matrix.transformPoint(new Point(width, height));
			}
			return new Point(round(_bottomRight.x), round(_bottomRight.y));
		}
		
		/**
		 * @private
		 */
		private var _top:Point;
		
		[Bindable("invalidated")]
		/**
		 * Visually the highest corner of data.
		 * </br> 
		 * For rotation 0, 90, 180, 270, etc. will be highest left point.  
		 */		
		public function get top():Point
		{
			if(!_top)
			{
				if(rotation == 0)
					_top = new Point(x, y);
				else
				{
					_top = topLeft;
					if(_top.y > topRight.y || (_top.y == topRight.y && _top.x > topRight.x))
						_top = topRight;
					if(_top.y > bottomRight.y || (_top.y == bottomRight.y && _top.x > bottomRight.x))
						_top = bottomRight;
					if(_top.y > bottomLeft.y || (_top.y == bottomLeft.y && _top.x > bottomLeft.x))
						_top = bottomLeft;
				}
			}
			return new Point(round(_top.x), round(_top.y));
		}
		
		/**
		 * @private
		 */
		private var _bottom:Point;
		
		[Bindable("invalidated")]
		/**
		 * Visually the lowest corner of data.
		 * </br> 
		 * For rotation 0, 90, 180, 270, etc. will be lowest right point.  
		 */	
		public function get bottom():Point
		{
			if(!_bottom)
			{
				if(rotation == 0)
					_bottom = new Point(x + width, y + height);
				else
				{
					_bottom = topLeft;
					if(_bottom.y < topRight.y || (_bottom.y == topRight.y && _bottom.x < topRight.x))
						_bottom = topRight;
					if(_bottom.y < bottomRight.y || (_bottom.y == bottomRight.y && _bottom.x < bottomRight.x))
						_bottom = bottomRight;
					if(_bottom.y < bottomLeft.y || (_bottom.y == bottomLeft.y && _bottom.x < bottomLeft.x))
						_bottom = bottomLeft;
				}
			}
			return new Point(round(_bottom.x), round(_bottom.y));
		}
		
		/**
		 * @private
		 */
		private var _left:Point;
		
		[Bindable("invalidated")]
		/**
		 * Visually the most left corner of data.
		 * </br> 
		 * For rotation 0, 90, 180, 270, etc. will be highest left point.  
		 */	
		public function get left():Point
		{
			if(!_left)
			{
				if(rotation == 0)
					_left = new Point(x, y);
				else
				{
					_left = topLeft;
					if(_left.x > topRight.x || (_left.x == topRight.x && _left.y > topRight.y))
						_left = topRight;
					if(_left.x > bottomRight.x || (_left.x == bottomRight.x && _left.y > bottomRight.y))
						_left = bottomRight;
					if(_left.x > bottomLeft.x || (_left.x == bottomLeft.x && _left.y > bottomLeft.y))
						_left = bottomLeft;
				}
			}
			return new Point(round(_left.x), round(_left.y));
		}
		
		/**
		 * @private
		 */
		private var _right:Point;
		
		[Bindable("invalidated")]
		/**
		 * Visually the most left corner of data.
		 * </br> 
		 * For rotation 0, 90, 180, 270, etc. will be lowest right point.  
		 */	
		public function get right():Point
		{
			if(!_right)
			{
				if(rotation == 0)
					_right = new Point(x + width, y + height);
				else
				{
					_right = topLeft;
					if(_right.x < topRight.x || (_right.x == topRight.x && _right.y < topRight.y))
						_right = topRight;
					if(_right.x < bottomRight.x || (_right.x == bottomRight.x && _right.y < bottomRight.y))
						_right = bottomRight;
					if(_right.x < bottomLeft.x || (_right.x == bottomLeft.x && _right.y < bottomLeft.y))
						_right = bottomLeft;
				}
			}
			return new Point(round(_right.x), round(_right.y));
		}
		
		/**
		 * @private
		 */
		private var _matrix:Matrix;
		
		[Bindable("invalidated")]
		/**
		 * Matrix for this data. 
		 */		
		public function get matrix():Matrix
		{
			if(!_matrix)
				_matrix = MatrixUtil.composeMatrix(x, y, 1, 1, rotation);
			
			return _matrix.clone();
		}
		
		
		//------------------------------------------------------------------
		//
		// Methods
		//
		//------------------------------------------------------------------
		/**
		 * Rotate data around anchor point. 
		 *  
		 * @param angle Rotate angle.
		 * @param anchor Anchor point should be set in data coordinate space. 
		 * If not specified then will be used Point(width/2, height/2).
		 */
		public function rotate(angle:Number, anchor:Point = null):void
		{
			anchor ||= new Point(width/2, height/2);
			
			// calculates anchor in data coordinate space
			var globalAnchor:Point = matrix.transformPoint(anchor);	
			
			// calculates position
			var m:Matrix = new Matrix();
			m.translate(-anchor.x, -anchor.y);
			m.rotate((rotation + angle)*Math.PI/180);
			m.translate(globalAnchor.x, globalAnchor.y);
			
			rotation += angle;
			position = m.transformPoint(new Point(0, 0));
		}
		
		/**
		 * Set data properties.
		 *  
		 * @param x Position by X axis
		 * @param y Position by Y axis
		 * @param width Width of display object
		 * @param height Height of display object
		 * @param rotation Rotation of display object
		 */		
		public function setTo(x:Number, y:Number, width:Number, height:Number, rotation:Number):void
		{
			_x = x;
			_y = y;
			_width = width;
			_height = height;
			_rotation = rotation;
			
			invalidate();
			
			dispatchEvent(new Event("xChanged"));
			dispatchEvent(new Event("yChanged"));
			dispatchEvent(new Event("widthChanged"));
			dispatchEvent(new Event("heightChanged"));
			dispatchEvent(new Event("rotationChanged"));
		}
		
		/**
		 * Adjusts the location of the DisplayData object, as determined by its top-left corner, by the specified amounts.
		 * 
		 * @param dx Moves the x value of the DisplayData object by this amount.
		 * @param dy Moves the y value of the DisplayData object by this amount.
		 */		
		public function offset(dx:Number, dy:Number):void
		{
			_x += !isNaN(dx) ? dx : 0;
			_y += !isNaN(dy) ? dy : 0;
			
			invalidate();
			
			dispatchEvent(new Event("xChanged"));
			dispatchEvent(new Event("yChanged"));
		}
		
		/**
		 * Determines whether the object specified in the data parameter intersects with this DisplayData object.
		 * 
		 * @param data The DisplayData object to compare against this DisplayData object.
		 * @return A value of true if the specified object intersects with this DisplayData object; otherwise false.
		 */		
		public function intersects(data:DisplayData):Boolean
		{
			return (contains(data.topLeft.x, data.topLeft.y) ||
				contains(data.topRight.x, data.topRight.y) ||
				contains(data.bottomRight.x, data.bottomRight.y) ||
				contains(data.bottomLeft.x, data.bottomLeft.y) ||
				data.contains(topLeft.x, topLeft.y) ||
				data.contains(topRight.x, topRight.y) ||
				data.contains(bottomRight.x, bottomRight.y) ||
				data.contains(bottomLeft.x, bottomLeft.y));
			
			return false;
		}
		
		/**
		 * Determines whether the specified point is contained within the rectangular region defined by this DisplayData object.
		 * 
		 * @param x The x coordinate (horizontal position) of the point.
		 * @param y The y coordinate (vertical position) of the point.
		 * @return A value of true if the DisplayData object contains the specified point; otherwise false.
		 */		
		public function contains(x:Number, y:Number):Boolean
		{
			if(rotation == 0)
			{
				return rect.contains(x, y);
			}
			else
			{
				var m:Matrix = matrix;
				m.invert();
				var localPoint:Point = m.transformPoint(new Point(x, y));
				
				return rect.contains(localPoint.x + this.x, localPoint.y + this.y)
			}
		}
		
		/**
		 * Determines whether the DisplayData object specified by the data parameter is contained 
		 * within this DisplayData object. A DisplayData object is said to contain another if the 
		 * second DisplayData object falls entirely within the boundaries of the first.
		 * 
		 * @param data The DisplayData object being checked.
		 * @return A value of true if the DisplayData object that you specify is contained by this DisplayData object; otherwise false.
		 */		
		public function containsData(data:DisplayData):Boolean
		{
			return (contains(data.topLeft.x, data.topLeft.y) &&
					contains(data.topRight.x, data.topRight.y) &&
					contains(data.bottomRight.x, data.bottomRight.y) &&
					contains(data.bottomLeft.x, data.bottomLeft.y));
		}

		/**
		 * Increases the size of the DisplayData object by the specified amounts, in pixels around anchor point. 
		 * 
		 * @param dx The value to be added to the width.
		 * @param dy The value to be added to the height.
		 * @param anchor Anchor point should be set in data coordinate space. 
		 * If not specified then will be used Point(width/2, height/2).
		 */
		public function inflate(dx:Number, dy:Number, anchor:Point=null):void
		{
			anchor ||= new Point(width/2, height/2);
			
			var newSize:Point = (new Point(width + dx, height + dy));
			
			var m:Matrix =  new Matrix();
			m.rotate(rotation / 180 * Math.PI);
			var deltPos:Point = m.transformPoint(new Point(newSize.x*anchor.x/width - anchor.x, newSize.y*anchor.y/height-anchor.y));
			
			setTo(x - deltPos.x, y - deltPos.y, newSize.x ,newSize.y, rotation);
		}
		
		/**
		 * Returns size of data in natural human perception. 
		 * 
		 * @return If rotation is between 45 and 135 degrees then height become width and vice versa and so on.
		 * 
		 * @see #isNaturalInvertion()
		 */		
		public function getNaturalSize():Point
		{
			return isNaturalInvertion() ? new Point(height, width) : new Point(width, height);
		}
		
		/**
		 * Sets size of data using natural human perception. 
		 * 
		 * @param size Natural human perception size. If rotation is between 45 and 135 degree then height 
		 * will be applied to width and vice versa and so on.
		 * 
		 * @see #isNaturalInvertion()
		 */		
		public function setNaturalSize(size:Point):void
		{
			var inversion:Boolean = isNaturalInvertion();
			_width = inversion ? size.y : size.x;
			_height = inversion ? size.x : size.y;
			
			invalidate();
			
			dispatchEvent(new Event("widthChanged"));
			dispatchEvent(new Event("heightChanged"));
		}
		
		/**
		 * Checks whether width and hight is swaped by natural human perception.
		 * 
		 * @return true if rotation is between -135 and -45, 45 and 135, 225 and 315 etc.; otherwise false 
		 */		
		public function isNaturalInvertion():Boolean
		{
			return (Math.abs(rotation) > 45 && Math.abs(rotation) < 135);
		}
		
		/**
		 * Returns a rectangle that defines the area of the DisplayData object.
		 *  
		 * @return Rectangle that defines the area of the DisplayData object.
		 */		
		public function getBoundingBox():Rectangle
		{
			if(rotation == 0)
			{
				return new Rectangle(x, y, width, height);
			}
			else
			{
				var minX:Number = Math.min(topLeft.x, topRight.x, bottomRight.x, bottomLeft.x);
				var minY:Number = Math.min(topLeft.y, topRight.y, bottomRight.y, bottomLeft.y);
				var maxX:Number = Math.max(topLeft.x, topRight.x, bottomRight.x, bottomLeft.x);
				var maxY:Number = Math.max(topLeft.y, topRight.y, bottomRight.y, bottomLeft.y);
				
				return new Rectangle(minX, minY, maxX - minX, maxY - minY);
			}	
		}
		
		/**
		 * Sets position of rectangle that defines the area of the DisplayData object and cause 
		 * to recalculate position of DisplayData.
		 * 
		 * @param x Position by X axis.
		 * @param y Position by Y axis.
		 */		
		public function setBoundingPosition(x:Number, y:Number):void
		{
			var currentBox:Rectangle = getBoundingBox();
			offset(x - currentBox.x, y - currentBox.y);
		}
		
		/**
		 * Fits DisplayData into size of rectangle that defines the area of the DisplayData object 
		 * keeping anchor point.
		 *  
		 * @param w Width of box
		 * @param h Height of box
		 * @param anchor Anchor point should be set in data coordinate space. 
		 * If not specified then will be used Point(width/2, height/2).
		 */		
		public function setBoundingSize(w:Number, h:Number, anchor:Point=null):void
		{
			var minW:Number = isNaN(maxWidth) ? Number.MIN_VALUE : minWidth;
			var minH:Number = isNaN(minHeight) ? Number.MIN_VALUE : minHeight;
			var maxW:Number = isNaN(maxWidth) ? Number.MAX_VALUE : maxWidth;
			var maxH:Number = isNaN(maxHeight) ? Number.MAX_VALUE : maxHeight;
			
			var size:Point = MatrixUtil.fitBounds(w, h, matrix, width, height, NaN, NaN, minW, minH, maxW, maxH);
			
			inflate(size.x - width, size.y - height);
		}
		
		/**
		 * Adds DisplayData objects specified in parameters with current one together to create a new Rectangle object, 
		 * by filling in the horizontal and vertical space between them. 
		 * 
		 * @param data A DisplayData object to add to this DisplayData object.
		 * @param params Additional DisplayData objects.
		 * @return A new Rectangle object that is the union of the specified DisplayData objects.
		 */		
		public function union(data:DisplayData, ...params):Rectangle
		{
			params ||= new Array();
			params.push(data);
			
			return unionArray(params);
		}
		
		/**
		 * Adds DisplayData objects with current one together to create a new Rectangle object, 
		 * by filling in the horizontal and vertical space between them. 
		 * 
		 * @param list Array of DisplayData to add to this DisplayData object
		 * @return A new Rectangle object that is the union of the specified DisplayData objects.
		 */		
		public function unionArray(list:Array):Rectangle
		{
			var box:Rectangle = getBoundingBox();
			for each (var data:DisplayData in list) 
			{
				box = box.union(data.getBoundingBox());
			}
			
			return box;
		}
		
		/**
		 * Adds DisplayData objects with current one together to create a new Rectangle object, 
		 * by filling in the horizontal and vertical space between them. 
		 * 
		 * @param list Vector of DisplayData to add to this DisplayData object
		 * @return A new Rectangle object that is the union of the specified DisplayData objects.
		 */		
		public function unionVector(list:Vector.<DisplayData>):Rectangle
		{
			var box:Rectangle = getBoundingBox();
			for each (var data:DisplayData in list) 
			{
				box = box.union(data.getBoundingBox());
			}
			
			return box;
		}
	
		/**
		 * Returns size between min amd max sizes specified for this DisplayData. 
		 * 
		 * @param size Size to resolve.
		 * @return Size that fits into min max values.
		 */		
		public function resolveMinMax(size:Point):Point
		{
			return new Point(resolveSize(size.x, minWidth, maxWidth), resolveSize(size.y, minHeight, maxHeight));
		}
		
		/**
		 * Returns new size that is adjusted to keep aspect ratio for this DisplayData. Always resolves min/max.
		 * 
		 * @param size Size to adjust.
		 * @param horizontalEnabled Specifies whether width can be changed while adjusting.
		 * @param verticalEnabled Specifies whether height can be changed while adjusting.
		 * @return Size that keeps aspect ratio.
		 */		
		public function resolveAspectRatio(size:Point, horizontalEnabled:Boolean, verticalEnabled:Boolean):Point
		{
			var newSize:Point = size.clone();
			var horizontalFactor:Number = horizontalEnabled ? size.x/width : 0;
			var verticalFactor:Number = verticalEnabled ? size.y/height : 0;
			
			var ratio:Number;
			
			if(verticalFactor > horizontalFactor)
				ratio = resolveSize(verticalFactor * width, minWidth, maxWidth)/width;
			else
				ratio = resolveSize(horizontalFactor * height, minHeight, maxHeight)/height;
			
			newSize.x = ratio* width;
			newSize.y = ratio* height;
			
			return newSize;
		}
		
		/**
		 * Clear DisplayData setting 0 to all geometric properties. 
		 */		
		public function setEmpty():void
		{
			minWidth = 0;
			minHeight = 0;
			maxWidth = 0;
			maxHeight = 0;
			
			setTo(0, 0, 0, 0, 0);
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
			
			clone.precision = precision;
			
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
		
		/**
		 * Builds and returns a string that lists the geometry properties of the DisplayData object.
		 * 
		 * @return A string listing the value of each of the following properties of the DisplayData 
		 * object: x, y, width, height, rotation, minWidth, minHeight, maxWidth and maxHeight.
		 */
		override public function toString():String
		{
			return "(x=" + x + ", y=" + y + ", width=" + width + ", height=" + height + ", rotation=" + rotation +
				", minWidth=" + minWidth + ", minHeight=" + minHeight + ", maxWidth=" + maxWidth + ", maxHeight=" + maxHeight + ")";	
		}
		
		//------------------------------------------------------------------
		//
		// Private Methods
		//
		//------------------------------------------------------------------
		/**
		 * @private 
		 */		
		private var _rect:Rectangle;
		
		/**
		 * Rectangle for internal use if rotation is 0. 
		 */		
		protected function get rect():Rectangle
		{
			if(!_rect)
				_rect = new Rectangle(x, y, width, height);
			
			return _rect.clone();
		}
		
		/**
		 * @private
		 * Invalidate DisplayData. 
		 */		
		protected function invalidate():void
		{
			_topCenter = null;
			_bottomCenter = null;
			_middleLeft = null;
			_middleRight = null;
			_topLeft = null;
			_topRight = null;
			_bottomLeft = null;
			_bottomRight = null;
			_left = null;
			_right = null;
			_top = null;
			_bottom = null;
			_matrix = null;
			_rect = null;
			
			dispatchEvent(new Event("invalidated"));
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function dispatchEvent(event:Event):Boolean
		{
			if(hasEventListener(event.type))
				return super.dispatchEvent(event);
			else
				return false;
		}
		
		/**
		 * @private
		 * Returns rounded value with precision specified in this DisplayData.
		 *  
		 * @param value Number to round.
		 * @return rounded value.
		 */		
		private function round(value:Number):Number
		{
			if(_precisionValue > 0)
				return Math.round(value*_precisionValue)/_precisionValue;
			else
				return value;
		}
		
		/**
		 * @private 
		 */		
		private function resolveSize(value:Number, min:Number, max:Number):Number 
		{
			min = !isNaN(min) ? min : Number.MIN_VALUE;
			max = !isNaN(max) ? max : Number.MAX_VALUE;
			
			return Math.min(max, Math.max(min, value));
		}
	}
}