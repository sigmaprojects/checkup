component output="false"  {
	
	property name="OriginService" inject="id:OriginService@Checkup";
	property name="DutyService" inject="id:DutyService@Checkup";
	property name="DutyExpectationService" inject="id:DutyExpectationService@Checkup";
	property name="ExpectationService" inject="id:ExpectationService@Checkup";
	property name="ResultService" inject="id:ResultService@Checkup";

	property name="Logger" inject="logbox:logger:{this}";


	public void function run() {
		var DutyIds = ORMExecuteQuery('SELECT id FROM checkup.models.Duty.Duty');
		var cfArr = []; // this is real annoying
		cfArr.addAll(DutyIds); 
		cfArr.each(function(DutyId){
			var Duty = DutyService.get(DutyId);
			report(Duty);
			DutyService.save(Duty);
		},true);
		/*
		for(var Id in DutyIds) {
			thread name="#CreateUuid()#" action="run" DutyId=Id {
				try {
					var Duty = DutyService.get(DutyId);
					report(Duty);
					DutyService.save(Duty);
				} catch(any e) {
					Logger.error("Error loop", e);
				}
			}
		}
		*/
	}

	public void function report(Required Duty) {
		httpResult = contact(Duty);
		
		// this could be threaded maybe, the overhead would prob be an issue
		for(var DutyExpectation in Duty.getDutyExpectations()) {
			test(httpResult, DutyExpectation);
		}

		//DutyService.save(Duty);

	}
	
	public void function test(Required Struct httpResult, Required DutyExpectation) {
		var Result = ResultService.new();
		//Result.setDutyExpectation( DutyExpectation );
		
		// check for a valid status code, if it's a serious issue 0 it
		var statusCode = ( structKeyExists(httpResult,'status_code') && isNumeric(httpResult.status_code) ? httpResult.status_code : 0 );
		Result.setStatusCode(statusCode);
		
		// check if the file content key exists from the http call, if it exists and is a string store it, other wise note an issue
		var fileContent = ( structKeyExists(httpResult,'filecontent') && isSimpleValue(httpResult.filecontent) ? httpResult.fileContent : "(binary content or invalid data)" );
		Result.setBody(fileContent);
		
		// now to test is the result matches the expectation
		var Expectation = DutyExpectation.getExpectation();
		// construct the logic in the most rudimentary way possible and shove it into eval
		// this is a huge security hole
		var logic = 'Result.get#DutyExpectation.getField()#() #Expectation.getOperator()# "#trim(DutyExpectation.getValue())#"';
		Logger.debug("Testing DutyExpectation:#DutyExpectation.getId()#", logic);
		try {
			var boolean = evaluate(logic);
		} catch(any e) {
			Logger.error("Failed to test DutyExpectation:#DutyExpectation.getId()#", {logic=logic,tagContext=e.tagContext});
			var boolean = false;
		}
		if( boolean eq false ) {
			Result.setFailure( true );
		}
		Result.setId( createUuid() );
		DutyExpectation.addResult( Result );
	}


	public struct function contact(Required Duty) {
		Logger.info("About to contact Duty",Duty.getId());
		
		var httpService = new http(
			method	= "get",
			url		= Duty.getDutyUrl()
		);
 
        httpService.addParam(type="header", name="X-Sent-By", value="ColdBox Checkup Module - Checkup");
		var httpResult = httpService.send().getPrefix();
		return httpResult;
	}

	
} 