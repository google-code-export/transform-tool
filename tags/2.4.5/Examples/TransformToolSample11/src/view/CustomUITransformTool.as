package view
{
	import com.vstyran.transform.view.UITransformTool;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	
	/**
	 * Delete target event. 
	 */	
	[Event(name="deleteTarget", type="flash.events.Event")]
	
	/**
	 * Custom TransformTool class with delete button.  
	 */	
	public class CustomUITransformTool extends UITransformTool
	{
		/**
		 * Constructor. 
		 */		
		public function CustomUITransformTool()
		{
			super();
		}
		
		[SkinPart]
		/**
		 * Skin part for delete button. 
		 */		
		public var deleteButton:Button;
		
		/**
		 * @inheritDoc 
		 */		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if(instance == deleteButton)
			{
				deleteButton.addEventListener(MouseEvent.CLICK, deleteHandler);
			}
		}
	
		/**
		 * @inheritDoc 
		 */		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == deleteButton)
			{
				deleteButton.removeEventListener(MouseEvent.CLICK, deleteHandler);
			}
			
			super.partRemoved(partName, instance);
		}
		
		/**
		 * Delete button click handler. 
		 */		
		protected function deleteHandler(event:MouseEvent):void
		{
			dispatchEvent(new Event("deleteTarget"));
		}
	}
}