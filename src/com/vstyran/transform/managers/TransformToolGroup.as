package com.vstyran.transform.managers
{
	import com.vstyran.transform.consts.TransformationType;
	import com.vstyran.transform.events.TransformEvent;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.namespaces.tt_internal;
	import com.vstyran.transform.operations.AnchorOperation;
	import com.vstyran.transform.operations.IOperation;
	import com.vstyran.transform.utils.DataUtil;
	import com.vstyran.transform.utils.MathUtil;
	import com.vstyran.transform.view.TransformTool;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.core.IMXMLObject;
	
	use namespace tt_internal;
	
	public class TransformToolGroup extends EventDispatcher implements IMXMLObject
	{
		/**
		 * Constructor. 
		 */		
		public function TransformToolGroup()
		{
			super();
		}
		
		/**
		 *  @private
		 *  The document containing a reference to this TransformToolGroup.
		 */
		private var document:IFlexDisplayObject;
		
		/**
		 *  @private
		 *  An Array of the TransformTool that belong to this group.
		 */
		private var transformTools:Array = [];
		
		/**
		 *  Implementation of the <code>IMXMLObject.initialized()</code> method
		 *  to support deferred instantiation.
		 *
		 *  @param document The MXML document that created this object.
		 *
		 *  @param id The identifier used by document to refer to this object.
		 *  If the object is a deep property on document, <code>id</code> is null.
		 *
		 *  @see mx.core.IMXMLObject
		 */
		public function initialized(document:Object, id:String):void
		{
			this.document = document ?
				IFlexDisplayObject(document) :
				IFlexDisplayObject(FlexGlobals.topLevelApplication);
		}
		
		[Bindable("numTransformToolsChanged")]
		/**
		 *  The number of numTransformTools that belong to this TransformToolGroup.
		 *
		 *  @default "undefined"
		 */
		public function get numTransformTools():int
		{
			return transformTools.length;
		}
		
		/**
		 *  Returns the TransformTool control at the specified index.
		 *
		 *  @param index The index of the TransformTool control in the
		 *  TransformToolGroup control, where the index of the first control is 0.
		 *
		 *  @return The specified TransformTool control.
		 */
		public function getRadioButtonAt(index:int):TransformTool
		{
			return TransformTool(transformTools[index]);
		}
		
		/**
		 *  @private
		 *  Add a radio button to the group.
		 */
		tt_internal function addInstance(instance:TransformTool):void
		{
			if(transformTools.indexOf(instance) == -1)
			{
				transformTools.push(instance);
				
				dispatchEvent(new Event("numTransformToolsChanged"));
			}
		}
		
		/**
		 *  @private
		 *  Remove a radio button from the group.
		 */
		tt_internal function removeInstance(instance:TransformTool):void
		{
			if (instance)
			{
				var index:int = transformTools.indexOf(instance);
				if(index != -1)
				{
					transformTools.splice(index, 1);
					dispatchEvent(new Event("numRadioButtonsChanged"));
				}
			}
		}
		
		private var startDatas:Vector.<DisplayData> = new Vector.<DisplayData>();
		
		tt_internal function startTransformation(tool:TransformTool, operation:IOperation):void
		{
			startDatas.length = 0;
			for each (var tt:TransformTool in transformTools) 
			{
				var data:DisplayData = tt.connector.getData();
				var startData:DisplayData = new DisplayData(data.x, data.y, data.width, data.height, data.rotation);
				startData.userData = tt;
				startDatas.push(startData);
				tt.startTransformation(operation.type, null, false);
			}
			
		}
		
		tt_internal function doTransformation(tool:TransformTool, operation:IOperation):void
		{
			doTransformationInternal(tool, operation, true);
		}
		
		private function doTransformationInternal(tool:TransformTool, operation:IOperation, updateTool:Boolean):void
		{
			var currentStartData:DisplayData = findStartData(tool);
			var toolData:DisplayData = tool.connector.getData();
			for each (var startData:DisplayData in startDatas) 
			{
				if(startData == currentStartData)
					continue;
				
				var startAnchor:Point;
				if(operation is AnchorOperation)
					startAnchor = new Point((operation as AnchorOperation).startAnchor.x*startData.width/currentStartData.width, (operation as AnchorOperation).startAnchor.y*startData.height/currentStartData.height);
				else
					startAnchor = new Point(startData.width/2, startData.height/2);
				
				var data:DisplayData = (startData.userData as TransformTool).connector.getData();
				
				// change position
				if(operation.type == TransformationType.MOVE || operation.type == TransformationType.MOVE_SHORTCUT)
					data.position = new Point(startData.x + toolData.x-currentStartData.x, startData.y + toolData.y-currentStartData.y);
				
				//change rotation
				if(operation.type == TransformationType.ROTATE)
					data.rotate(MathUtil.round(toolData.rotation - currentStartData.rotation + startData.rotation - data.rotation, 2), startAnchor);
					
				//change rotation
				if(operation.type == TransformationType.RESIZE)
				{
					var startNaturalSize:Point = startData.getNaturalSize();
					var currentStartNaturalSize:Point = currentStartData.getNaturalSize();
					var toolNaturalSize:Point = toolData.getNaturalSize();
					
					var naturalStartAnchor:Point;
					if(operation is AnchorOperation)
						naturalStartAnchor = new Point((operation as AnchorOperation).startAnchor.x*startNaturalSize.x/currentStartData.width, (operation as AnchorOperation).startAnchor.y*startNaturalSize.y/currentStartData.height);
					else
						naturalStartAnchor = new Point(startNaturalSize.x/2, startNaturalSize.y/2);
					
					if(startData.isNaturalInvertion())
						naturalStartAnchor = new Point(naturalStartAnchor.y, naturalStartAnchor.x);
					
					var tmpData:DisplayData = new DisplayData(data.x, data.y, data.width, data.height, data.rotation);
					tmpData.setNaturalSize(new Point(startNaturalSize.x + toolNaturalSize.x-currentStartNaturalSize.x, startNaturalSize.y + toolNaturalSize.y-currentStartNaturalSize.y));
					
					var tmpStartData:DisplayData = startData.clone();
					tmpStartData.inflate(tmpData.width-startData.width, tmpData.height-startData.height, naturalStartAnchor);
					
					data.setTo(tmpStartData.x, tmpStartData.y, tmpStartData.width, tmpStartData.height, tmpStartData.rotation); 
				}
				
				DataUtil.fitData(data, (startData.userData as TransformTool).bounds);
				
				if(updateTool)
					(startData.userData as TransformTool).doTransformation(data, operation.type, null, false);
			}
		}
		
		tt_internal function endTransformation(tool:TransformTool, operation:IOperation):void
		{
			var currentStartData:DisplayData = findStartData(tool);
			
			doTransformationInternal(tool, operation, false);
			
			for each (var startData:DisplayData in startDatas) 
			{
				if(startData == currentStartData)
					continue;
				
				(startData.userData as TransformTool).endTransformation((startData.userData as TransformTool).connector.getData(), operation.type, null, false);
			}
		}
		
		
		protected function findStartData(tool:TransformTool):DisplayData
		{
			for each (var startData:DisplayData in startDatas) 
			{
				if(startData.userData == tool)
					return startData;
			}
			
			return null;
		}
	}
}