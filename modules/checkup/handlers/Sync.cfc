component {

	property name="OriginService" inject="id:OriginService@Checkup";
	property name="DutyService" inject="id:DutyService@Checkup";
	property name="DutyExpectationService" inject="id:DutyExpectationService@Checkup";
	property name="ExpectationService" inject="id:ExpectationService@Checkup";
	property name="ResultService" inject="id:ResultService@Checkup";
	property name="SyncService" inject="id:SyncService@Checkup";


	public void function index(event,rc,prc){
		// gather what we have so far, before receiving 
		/*
		var objOrigins = OriginService.list(asQuery=false);
		var jsonData = {origins=[]};
		var Origins = [];
		Origins.addAll(objOrigins);
		
		
		// process incomming origins and save
		
		
		
		// send out what we have
		// haha this is probably a bad idea to thread it this way
		Origins.each(function(Origin) {
			arrayAppend(jsonData.origins,Origin.toJson());
		},true);
		*/
		//var jsonData = {origins=OriginService.getForSync()};
		
		
		//writedump(jsondata);
		//abort;
		SyncService.receive(cgi.remote_addr, event.getHTTPContent());
		//writeoutput(cgi.remote_addr);
		//writeoutput( event.getHTTPContent() );
		abort;
		event.renderData(data=jsonData,type="json");
	}


}