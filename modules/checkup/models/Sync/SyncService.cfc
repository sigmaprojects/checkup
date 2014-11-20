component extends="cborm.models.VirtualEntityService" singleton {

	property name="OriginService" inject="id:OriginService@Checkup";
	property name="DutyService" inject="id:DutyService@Checkup";
	property name="DutyExpectationService" inject="id:DutyExpectationService@Checkup";
	property name="ExpectationService" inject="id:ExpectationService@Checkup";
	property name="ResultService" inject="id:ResultService@Checkup";
	
	property name="ValidationManager" inject="ValidationManager@validation";
	property name="Logger" inject="logbox:logger:{this}";

	public any function init(){
		super.init("checkup.models.Sync.Sync", "Sync.query.cache", true );
		return this;
	}

	public void function syncAll() {
		for(var Origin in OriginService.list(asQuery=false)) {
			callSync(Origin);
		}
	}

	public void function callSync(Required Origin) {
		var result = send(Origin);
		writedump(result);
		abort;
	}


	public struct function send(Required Origin) {
		Logger.info("About to contact Origin",Origin.getId());
		
		var httpService = new http(
			method	= "post",
			url		= Origin.getServiceUrl()
		);
        httpService.addParam(type="header", name="X-Sent-By", value="ColdBox Checkup Module - Sync");
        httpService.addParam(type="header",	name="Content-Type", value="application/json");
        httpService.addParam(type="body",	value=serializeJson({origins=OriginService.getForSync()}));
 
		var httpResult = httpService.send().getPrefix();
		return httpResult;
	}

	public void function receive(Required String ipSource, Required Any IncommingData) {
		if( isSimpleValue(IncommingData) && isJson(IncommingData) ) {
			var data = deserializeJson(IncommingData);
		} else if( isStruct(IncommingData) ) {
			// this is just an incase from random clients
			var data = IncommingData;
		} else {
			data = {};
		}
		if( !structKeyExists(data,'origins') || !isArray(data.origins) ) {
			Logger.warn("Sync received malformed data (no origins) from: #ipSource#");
			return;
		}
		
		// first loop to extract the records, creating individual structs for each entity
		// store them in a struct for quick dupe checks by key
		var origins = {};
		var expectations = {};
		var duties = {};
		var dutyexpectations = {};
		var results = {};
		
		for(var origin in data.origins) {
			// check for the origins key, make sure it's an array
			if( structKeyExists(origin,'duties') && isArray(origin.duties) ) {
				for(var duty in origin.duties) {
					// check for the dutyexpectations key, make sure it's an array
					if( structKeyExists(duty,'dutyexpectations') && isArray(duty.dutyexpectations) ) {
						for(var dutyexpectation in duty.dutyexpectations) {
							// verify if the dutyexpectation has the expectation key, also make sure that expectation id doesn't exist in our expectations struct
							if( structKeyExists(dutyexpectation,'expectation') && structKeyExists(dutyexpectation.expectation,'id') && !structKeyExists(expectations,dutyexpectation.expectation.id) ) {
								expectations[dutyexpectation.expectation.id] = dutyexpectation.expectation;
							}
							// check for & gather results
							if( structKeyExists(dutyexpectation,'results') && isArray(dutyexpectation.results) ) {
								for(var result in dutyexpectation.results) {
									// store the result if our key doesn't exist
									if( !structKeyExists(results,result.id) ) {
										results[result.id] = result;
									}
								}
							}
							// check & store dutyexpectations
							if( !structKeyExists(dutyexpectations,dutyexpectation.id) ) {
								StructDelete(dutyexpectation,'expectation'); // remove the expectation key
								dutyexpectations[dutyexpectation.id] = dutyexpectation;
							}
						}
					}
					// check & store the duties
					if( !structKeyExists(duties,duty.id) ) {
						StructDelete(duty,'dutyexpectations'); // remove the expectations key
						duties[duty.id] = duty;
					}
				}
			}
			// check & store the origin
			if( !structKeyExists(origins,origin.id) ) {
				StructDelete(origin,'duties'); // remove the duties key
				origins[origin.id] = origin;
			}
		}
		
		// save the expections, if they don't exist
		for(var key in expectations) {
			if( !ExpectationService.exists(key) ) {
				// we're good to save it, the .save will take care of verifying validation and log any errors.
				var Expectation = ExpectationService.new(expectations[key]);
				ExpectationService.save(Expectation);
			}
		}

		// save the origins, if they don't exist
		for(var key in origins) {
			if( !OriginService.exists(key) ) {
				var Origin = OriginService.new(origins[key]);
				OriginService.save(Origin);
			}
		}

		// save the duties, if they don't exist
		for(var key in duties) {
			if( !DutyService.exists(key) ) {
				var Duty = DutyService.new(duties[key]);
				Duty.setOrigin( OriginService.get(duties[key].origin_id) );
				DutyService.save(Duty);
			}
		}

		// save the dutyexpectations, if they don't exist
		for(var key in dutyexpectations) {
			if( !DutyExpectationService.exists(key) ) {
				var DutyExpectation = DutyExpectationService.new(dutyexpectations[key]);
				DutyExpectation.setDuty( DutyService.get(dutyexpectations[key].duty_id) );
				DutyExpectation.setExpectation( ExpectationService.get(dutyexpectations[key].expectation_id) );
				DutyExpectationService.save(DutyExpectation);
			}
		}

		// save the results, if they don't exist
		for(var key in results) {
			if( !ResultService.exists(key) ) {
				var Result = ResultService.new(results[key]);
				Result.setDutyExpectation( DutyExpectationService.get(results[key].dutyexpectation_id) );
				ResultService.save(Result);
			}
		}
		//writeoutput(expectations.toString());
		abort;
		
	}

	public boolean function save(Required Sync) {
		var validationResults = ValidationManager.validate( Sync );
		if( validationResults.hasErrors() ) {
			Logger.warn("Sync did not pass validation.",validationResults.getAllErrorsAsStruct());
			return false;
		}
		super.save(Sync);
		return true;
	}

}
