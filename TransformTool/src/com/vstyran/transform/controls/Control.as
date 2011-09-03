package com.vstyran.transform.controls
{
	
	import com.vstyran.transform.operations.IOperation;
	import com.vstyran.transform.view.TransformTool;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	
	
	public class Control extends SkinnableComponent implements IAnchor
	{
		
		public function Control()
		{
			super();
			
			addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		protected function downHandler(event:MouseEvent):void
		{
			if(!tool)
				return;
			
			if(operation)
				operation.startOperation(tool.target, new Point(event.stageX, event.stageY));
			
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		protected function moveHandler(event:MouseEvent):void
		{
			if(operation)
				tool.updating(operation.doOperation(new Point(event.stageX, event.stageY)));
			
		}
		
		protected function upHandler(event:MouseEvent):void
		{
			if(operation)
				tool.update(operation.endOperation());
			
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