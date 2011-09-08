package com.vstyran.transform.view
{
	
	import com.vstyran.transform.controls.Control;
	import com.vstyran.transform.factories.TargetExporter;
	import com.vstyran.transform.factories.TargetImporter;
	import com.vstyran.transform.model.TargetData;
	import com.vstyran.transform.supportClasses.Converter;
	import com.vstyran.transform.utils.TransformUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Matrix;
	
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
		
		private var toolConverter:Converter = new Converter();
		private var attachmentConverter:Converter = new Converter();
		
		private var attachment:UIComponent;
		
		override public function parentChanged(p:DisplayObjectContainer):void
		{
			super.parentChanged(p);
			
			matrixDirty = true;
			invalidateProperties();
		}
		
		public function attach(component:UIComponent):void
		{
			matrixDirty = true;
			invalidateProperties();
			
			attachment = component;
			targetData = TransformUtil.createData(component);
		}
		
		public var targetData:TargetData;

		private var _toolData:TargetData;

		public function get toolData():TargetData
		{
			return _toolData;
		}

		public function set toolData(value:TargetData):void
		{
			if(_toolData != value)
			{
				_toolData = value;
				
				TransformUtil.
			}
		}

		
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
		
		private var matrixDirty:Boolean;
		
		private var matrix:Matrix;
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			
			if(validateControls)
			{
				processParts(skin);
				validateControls = false;
			}
			
			if(matrixDirty)
			{
				var sourceContext:DisplayObject = attachment ? attachment.parent : null;
				matrix = TransformUtil.getTransformationMatrix(sourceContext, parent);
				
				toolData = TransformUtil.createDataByMatrix(attachment, matrix);
				
				matrixDirty = false;
			}
		}
		
		private function updateTool():void
		{
			//importer.importData(attachment
		}
		
		public function startTransformation(control:Control):void
		{
		}
		
		public function doTransformation(data:TargetData):void
		{
			targetData = data;
			exporter.export(attachment, data);
		}
		
		public function endTransformation():void
		{
			exporter.export(attachment, targetData);
		}
	}
}