component output="false" {
	
	property name="OriginService" inject="id:OriginService@Checkup";
	property name="DutyService" inject="id:DutyService@Checkup";
	property name="DutyExpectationService" inject="id:DutyExpectationService@Checkup";
	property name="ExpectationService" inject="id:ExpectationService@Checkup";
	property name="ResultService" inject="id:ResultService@Checkup";

	property name="Logger" inject="logbox:logger:{this}";


	public void function report(Required Duty) {
		httpResult = contact(Duty);
		writedump(httpResult);
		test(httpResult, Duty.getDutyExpectations()[1]);
		abort;
	}
	
	public void function test(Required Struct httpResult, Required DutyExpectation) {
		var Result = ResultService.new();
		Result.setDutyExpectation( DutyExpectation );
		
		// check for a valid status code, if it's a serious issue 0 it
		var statusCode = ( structKeyExists(httpResult,'status_code') && isNumeric(httpResult.status_code) ? httpResult.status_code : 0 );
		Result.setStatusCode(statusCode);
		
		// check if the file content key exists from the http call, if it exists and is a string store it, other wise note an issue
		var fileContent = ( structKeyExists(httpResult,'filecontent') && isSimpleValue(httpResult.filecontent) ? httpResult.fileContent : "(binary content or invalid data)" );
		Result.setBody(fileContent);
		
		// now to test is the result matches the expectation
		var Expectation = DutyExpectation.getExpectation();
		// construct the logic
		var logic = 'Result.get#DutyExpectation.getField()#() #Expectation.getOperator()# "#trim(DutyExpectation.getValue())#"';
		writedump(logic);
		if( evaluate(logic) ) {
			writedump('heyo');
		} else {
			writedump('noyo');
		}
		abort;
		
	}


	public struct function contact(Required Duty) {
		Logger.info("About to contact Duty",Duty.getId());
		
		var httpService = new http(
			method	= "get",
			url		= Duty.getDutyUrl()
		);
 
        httpService.addParam(type="header", name="X-Sent-By", value="Checkup Module");
		var httpResult = httpService.send().getPrefix();
		return httpResult;
	}

	
} 