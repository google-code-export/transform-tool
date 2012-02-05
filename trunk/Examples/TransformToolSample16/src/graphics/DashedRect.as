package graphics
{
	import flash.display.Graphics;
	
	import spark.primitives.Graphic;
	import spark.primitives.supportClasses.FilledElement;
	import spark.primitives.supportClasses.StrokedElement;
	
	public class DashedRect extends FilledElement
	{
		public function DashedRect()
		{
			super();
		}
		
		private var _dashSize:Number=4;
		
		[Inspectable("General", minValue="1.0")]
		
		/**
		 *  Dash size.
		 *  
		 *  @default 4
		 */
		public function get dashSize():Number 
		{
			return _dashSize;
		}
		
		public function set dashSize(value:Number):void
		{        
			if (value != _dashSize)
			{
				_dashSize = value > 0 ? value : 1;
				
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		override protected function draw(g:Graphics):void
		{
			drawVerticalLine(0, g);
			drawVerticalLine(width, g);
			drawHorizontalLine(0, g);
			drawHorizontalLine(height, g);
		}
		
		private function  drawVerticalLine(x:Number, g:Graphics):void
		{
			var count:Number = Math.floor(height/_dashSize);
			
			for (var i:int = 0; i <= count; i+=2) 
			{
				g.moveTo(x, i*_dashSize);
				g.lineTo(x, (i+1)*dashSize);
			}
		}
		
		private function  drawHorizontalLine(y:Number, g:Graphics):void
		{
			var count:Number = Math.floor(width/_dashSize);
			
			for (var i:int = 0; i <= count; i+=2) 
			{
				g.moveTo(i*_dashSize, y);
				g.lineTo((i+1)*dashSize, y);
			}
		}
	}
}