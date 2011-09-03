package com.vstyran.transform.view
{
	
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.factories.TargetExporter;
	import com.vstyran.transform.factories.TargetImporter;
	import com.vstyran.transform.model.TargetData;
	
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	import mx.events.PropertyChangeEvent;
	
	import spark.components.Group;
	import spark.components.supportClasses.Skin;
	import spark.components.supportClasses.SkinnableComponent;
	
	
	
	public class TransformTool extends SkinnableComponent
	{
		
		public function TransformTool()
		{
			super();
		}
		
		[SkinPart]
		public var importer:TargetImporter = new TargetImporter();
		
		[SkinPart]
		public var exporter:TargetExporter = new TargetExporter();
		
		private var attachment:UIComponent;
		
		public function attach(component:UIComponent):void
		{
			target = importer.importData(component);
			attachment = component;
		}
		
		public var target:TargetData;
		
		
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
		
		override protected function attachSkin():void
		{
			super.attachSkin();
			
			if(skin)
				skin.addEventListener(Event.ADDED_TO_STAGE, addedHandler, true);
			
			
			validateControls = true;
			invalidateProperties();
		}
		
		protected function addedHandler(event:Event):void
		{
			validateControls = true;
			invalidateProperties();
		}
		
		protected function processParts(container:UIComponent):void
		{
			if(container is Control)
			{
				(container as Control).tool = this;
				return;
			}
			
			if(container is IVisualElementContainer)
			{
				for (var i:int = 0; i < (container as IVisualElementContainer).numElements; i++) 
				{
					var element:IVisualElement = (container as IVisualElementContainer).getElementAt(i);
					if(element is UIComponent)
						processParts(element as UIComponent);	
				}
				
			}
		}
		
		private var validateControls:Boolean;
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			
			if(validateControls)
			{
				processParts(skin);
				validateControls = false;
			}
		}
		
		public function updating(data:TargetData):void
		{
			target = data;
			exporter.export(attachment, data);
		}
		
		public function update(data:TargetData):void
		{
			target = data;
			exporter.export(attachment, data);
		}
	}
}