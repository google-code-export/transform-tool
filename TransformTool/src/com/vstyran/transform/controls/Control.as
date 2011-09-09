package com.vstyran.transform.controls
{
	
	import com.vstyran.transform.operations.AnchorOperation;
	import com.vstyran.transform.operations.IAncorOperation;
	import com.vstyran.transform.operations.IOperation;
	import com.vstyran.transform.view.TransformTool;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	
	
	public class Control extends SkinnableComponent implements IAnchor
	{
		public var anchor:IAnchor;
		public var shiftAnchor:IAnchor;
		public var altAnchor:IAnchor;
		public var ctrlAnchor:IAnchor;
		
		public function Control()
		{
			super();
			
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		private function getAnchorPoint(anchor:IAnchor):Point
		{
			if(!anchor)
				return null;
			
			return tool.globalToSource(new Point(anchor.x + anchor.width/2, anchor.y + anchor.height/2));
		}
		
		private function resolveAnchor(event:MouseEvent):IAnchor
		{
			if(event.shiftKey && shiftAnchor)
				return shiftAnchor;
			if(event.ctrlKey && ctrlAnchor)
				return ctrlAnchor;
			if(event.altKey && altAnchor)
				return altAnchor;
			
			return anchor;
		}
		
		protected function downHandler(event:MouseEvent):void
		{
			if(!tool)
				return;
			
			tool.startTransformation(this);
			
			if(operation)
				operation.initOperation(tool.sourceData, tool.globalToSource(new Point(event.stageX, event.stageY)));
			
			if(operation is IAncorOperation)
				(operation as IAncorOperation).anchor = getAnchorPoint(resolveAnchor(event));
			
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		protected function moveHandler(event:MouseEvent):void
		{
			if(operation)
				tool.doTransformation(operation.doOperation(tool.globalToSource(new Point(event.stageX, event.stageY))));
		
			event.updateAfterEvent();
		}
		
		protected function upHandler(event:MouseEvent):void
		{
			if(operation)
				tool.endTransformation(operation.doOperation(tool.globalToSource(new Point(event.stageX, event.stageY))));
			
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		public var tool:TransformTool;
		
		public var operation:IOperation;
		
		
		
		override protected function getCurrentSkinState():String
		{
			return super.getCurrentSkinState();
		} 
		
		override protected function partAdded(partName:String, instance:Object) : void
		{
			super.partAdded(partName, instance);
		}
		
		override protected function partRemoved(partName:String, instance:Object) : void
		{
			super.partRemoved(partName, instance);
		}
		
	}
}