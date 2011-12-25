package com.vstyran.transform.connectors
{
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.utils.DataUtil;

	/**
	 * Connector class for connecting UIComponent with transfrom tool.
	 * It uses scaling rather than changing size..
	 * 
	 * @author Volodymyr Styranivskyi
	 */
	public class UIScaleConnector extends UIConnector
	{
		/**
		 * Constructor. 
		 */		
		public function UIScaleConnector()
		{
			super();
		}
		
		/**
		 * @inheritDoc 
		 */		
		override public function getData():DisplayData
		{
			var data:DisplayData = super.getData();
			
			data.minWidth = target.minWidth;
			data.minHeight = target.minHeight;
			data.maxWidth = target.maxWidth;
			data.maxHeight = target.maxHeight;
			
			return data;
		}
		
		/**
		 * @inheritDoc 
		 */	
		override public function transfrom(data:DisplayData):DisplayData
		{
			data = dataConnector.transfrom(data);
			
			DataUtil.applyScaledData(target, dataConnector.data);
			
			return data;
		}
		
		/**
		 * @inheritDoc 
		 */	
		override public function complete(data:DisplayData):DisplayData
		{
			data = dataConnector.transfrom(data);
			
			DataUtil.applyScaledData(target, dataConnector.data);
			
			return data;
		}
	}
}