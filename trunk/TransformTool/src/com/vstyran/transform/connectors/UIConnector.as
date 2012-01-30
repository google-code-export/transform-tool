package com.vstyran.transform.connectors
{
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.MultiDisplayData;
	import com.vstyran.transform.utils.DataUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;
	
	/**
	 *  Dispatched when the data is changed and transform tool needs to be updated.
	 *
	 *  @eventType com.vstyran.transform.events.ConnectorEvent.DATA_CHANGE
	 */
	[Event(name="dataChange", type="com.vstyran.transform.events.ConnectorEvent")]
	
	/**
	 * Connector class for connecting UIComponent with transfrom tool.
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class UIConnector extends EventDispatcher implements IConnector
	{
		/**
		 * Constructor. 
		 */		
		public function UIConnector()
		{
			super();
		}
		
		/**
		 * @private
		 * Data connector. 
		 */		
		protected var dataConnector:DataConnector = new DataConnector();
		
		/**
		 * @private 
		 */		
		private var _targets:Array;
		
		/**
		 * Target of transformation. 
		 */		
		public function get targets():Array
		{
			return _targets ? _targets.slice() : null;
		}
		
		/**
		 * @private 
		 */	
		public function set targets(value:Array):void
		{
			dataDirty = true;
			
			_targets = value;
			
			if(!_targets || _targets.length == 0)
			{
				dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
				return;
			}
			
			if(_targets[0].parent)
			{
				dataConnector.panel = _targets[0].parent as UIComponent;
				
				dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
			}
			else
			{
				_targets[0].addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			}
		}
		
		/**
		 * @private 
		 */		
		private var dataDirty:Boolean;
		
		/**
		 * Flag that indicates whether target should be updated during transformation.
		 * If false then target will be updated only on mouse up. 
		 */		
		public var liveTransformation:Boolean = true; 
		
		/**
		 * @private 
		 * Target added to stage event handler.
		 */		
		protected function addedHandler(event:Event):void
		{
			_targets[0].removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
			
			dataConnector.panel = _targets[0].parent as UIComponent;
			
			dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
		}
		
		/**
		 * @private 
		 */		
		private var _padding:Number = 0; 

		/**
		 * Padding for multiselection. 
		 */
		public function get padding():Number
		{
			return _padding;
		}

		/**
		 * @private
		 */
		public function set padding(value:Number):void
		{
			_padding = value;
		
			if(dataConnector.data is MultiDisplayData)
				(dataConnector.data as MultiDisplayData).padding = _padding;
		}

		/**
		 * @inheritDoc 
		 */		
		public function getData(deep:Boolean = false):DisplayData
		{
			if(targets && targets.length > 0 && (dataDirty || deep))
			{
				if(targets.length == 1)
				{
					dataConnector.data = DataUtil.createData(targets[0]);
				}
				else
				{
					var dataList:Vector.<DisplayData> = new Vector.<DisplayData>();
					for each (var target:UIComponent in targets) 
					{
						var data:DisplayData = DataUtil.createData(target);
						data.userData = {target:target};
						dataList.push(data);
					}
					
					var multiData:MultiDisplayData = new MultiDisplayData();
					multiData.padding = padding;
					multiData.minWidth = 10;
					multiData.minHeight = 10;
					multiData.addChildVector(dataList);
					dataConnector.data = multiData;
				}
				
				dataDirty = false;
			}
			
			return dataConnector.getData(deep);
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function setToolPanel(toolPanel:DisplayObject):void
		{
			dataConnector.setToolPanel(toolPanel);
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function transfrom(data:DisplayData):DisplayData
		{
			data = dataConnector.transfrom(data);
			
			if(liveTransformation && targets && targets.length > 0)
			{
				if(dataConnector.data is MultiDisplayData)
				{
					for each (var child:DisplayData in (dataConnector.data as MultiDisplayData).children) 
					{
						DataUtil.applyData(child.userData.target as UIComponent, child);
					}
				}
				else
				{
					DataUtil.applyData(targets[0], dataConnector.data);
				}
			}
			
			return data;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function complete(data:DisplayData):DisplayData
		{
			transfrom(data)
			
			if(dataConnector.data is MultiDisplayData)
			{
				(dataConnector.data as MultiDisplayData).validateData(dataConnector.data.rotation);
				dispatchEvent(new ConnectorEvent(ConnectorEvent.DATA_CHANGE));
			}
			
			return dataConnector.data;
		}
	}
}