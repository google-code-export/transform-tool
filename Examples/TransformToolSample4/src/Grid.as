package
{
	import flash.display.Graphics;
	
	import spark.primitives.supportClasses.FilledElement;
	import spark.primitives.supportClasses.StrokedElement;
	
	public class Grid extends FilledElement
	{
		public function Grid()
		{
			super();
		}
		
		private var _step:Number=20;
		
		[Inspectable(category="General", minValue="1.0")]
		
		/**
		 *  Grid step.
		 *  
		 *  @default 20
		 */
		public function get step():Number 
		{
			return _step;
		}
		
		public function set step(value:Number):void
		{        
			if (value != _step)
			{
				_step = value > 0 ? value : 1;
				
				invalidateSize();
				invalidateDisplayList();
				invalidateParentSizeAndDisplayList();
			}
		}
		
		override protected function draw(g:Graphics):void
		{
			var columnCount:Number = Math.floor(width/_step);
			var rowCount:Number = Math.floor(height/_step);
			for (var i:int = 0; i <= rowCount; i++) 
			{
				for (var j:int = 0; j <= columnCount; j++) 
				{
					g.drawCircle(drawX + j*_step, drawY + i*_step, 0.5);
				}
			}
			
		}
	}
}