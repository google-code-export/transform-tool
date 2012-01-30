package com.vstyran.transform.connectors
{
	import com.vstyran.transform.events.ConnectorEvent;
	import com.vstyran.transform.model.DisplayData;
	import com.vstyran.transform.model.MultiDisplayData;
	import com.vstyran.transform.utils.DataUtil;
	
	import mx.core.UIComponent;

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
		override public function getData(deep:Boolean = false):DisplayData
		{
			var data:DisplayData = super.getData(deep);
			
			if(data && targets && targets.length == 1)
			{
				data.minWidth = targets[0].minWidth;
				data.minHeight = targets[0].minHeight;
				data.maxWidth = targets[0].maxWidth;
				data.maxHeight = targets[0].maxHeight;
			}
			
			return data;
		}
		
		/**
		 * @inheritDoc 
		 */	
		override public function transfrom(data:DisplayData):DisplayData
		{
			data = dataConnector.transfrom(data);
			
			if(liveTransformation && targets && targets.length > 0)
			{
				if(dataConnector.data is MultiDisplayData)
				{
					for each (var child:DisplayData in (dataConnector.data as MultiDisplayData).children) 
					{
						DataUtil.applyScaledData(child.userData.target as UIComponent, child);
					}
				}
				else
				{
					DataUtil.applyScaledData(targets[0], dataConnector.data);
				}
			}
			
			return data;
		}
	}
}