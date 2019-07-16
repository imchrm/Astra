package com.chrm.ioc.astra.service
{
	public class TCService implements ITCService, IRespondable
	{
		private var _respondent:IRespondent;
		
		public function TCService()
		{
		}
		
		public function doit(...param):void
		{
//			abstract mehod;
//			TODO throw new error here
			
		}
		public function set respondent(val:IRespondent):void
		{
			_respondent = val;
		}
		
		public function get respondent():IRespondent
		{
			return _respondent;
		}
	}
}