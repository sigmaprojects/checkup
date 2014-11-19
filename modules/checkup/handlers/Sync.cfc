component {

	property name="OriginService" inject="id:OriginService@Checkup";
	property name="DutyService" inject="id:DutyService@Checkup";
	property name="DutyExpectationService" inject="id:DutyExpectationService@Checkup";
	property name="ExpectationService" inject="id:ExpectationService@Checkup";
	property name="ResultService" inject="id:ResultService@Checkup";


	public void function index(event,rc,prc){
		
		
		var objOrigins = OriginService.list(asQuery=false);
		var jsonData = {data=[]};
		
		
		var Origins = [];
		Origins.addAll(objOrigins);
		// haha this is probably a bad idea
		Origins.each(function(Origin) {
			arrayAppend(jsonData.data,Origin.toJson());
		},true);
		
		
		//writedump(jsondata);
		//abort;
		event.renderData(data=jsonData,type="json");
	}


}