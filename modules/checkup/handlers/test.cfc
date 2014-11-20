component {

	property name="OriginService" inject="id:OriginService@Checkup";
	property name="DutyService" inject="id:DutyService@Checkup";
	property name="DutyExpectationService" inject="id:DutyExpectationService@Checkup";
	property name="ExpectationService" inject="id:ExpectationService@Checkup";
	property name="ResultService" inject="id:ResultService@Checkup";
	property name="CheckupService" inject="id:CheckupService@Checkup";
	property name="SyncService" inject="id:SyncService@Checkup";

	public void function testSync(event,rc,prc) {
		SyncService.syncAll();
		abort;
	}

	public void function testCustomId(event,rc,prc) {
		//D86442D7-479E-466B-B6EFC3AAC49D52FB
		//1b271aac-6fbb-11e4-bb20-000c29e80bf8
		writedump(len(createuuid()));
		abort;
		var Result = ResultService.new();
		Result.setId("4b229d5c-6fa7-11e4-bb20-000c29e80bf7");
		Result.setstatuscode(200);
		var DutyExpectation = DutyExpectationService.get("9afae069-6eab-11e4-bb20-000c29e80bf8");
		Result.setDutyExpectation( DutyExpectation );
		Result.setBody("test");
		EntitySave(Result);
		ORMFlush();
		//ResultService.save(Result);
		//writedump(var=e,top=1);
		abort;
	}

	public void function contactTest(event,rc,prc) {
		var Duty = DutyService.get("0E339B33-0820-49A6-94C9CAB3A232B55D");
		CheckupService.run();
		abort;
	}	

	public void function createDuty(event,rc,prc) {
		
		var Origin = OriginService.getSystemOrigin();
		var Duty = DutyService.new({
			dutyUrl		= "https://checkup.sigmaprojects.org/?event=checkup:test.echoOk",
			origin		= Origin
		});
		var DutyExpectations = [];
		arrayAppend(DutyExpectations, DutyExpectationService.new({
			Duty		= Duty,
			Expectation	= ExpectationService.findByOperator("contains"),
			value		= "OK",
			field		= "body"
		}));
		arrayAppend(DutyExpectations, DutyExpectationService.new({
			Duty		= Duty,
			Expectation	= ExpectationService.findByOperator("=="),
			value		= "200",
			field		= "statuscode"
		}));
		Duty.setDutyExpectations( DutyExpectations );
		DutyService.save( Duty );
		abort;
	}

	public void function createOrigin(event,rc,prc){
		var origin = OriginService.new();
		origin.setId( OriginService.getMacAddress() );
		origin.setServiceUrl( "https://checkup.sigmaprojects.org/?event=checkup:sync" );
		origin.setSystem( true );
		OriginService.save(origin);
		abort;
	}


	public void function createExpectation(event,rc,prc) {

		ExpectationService.save(
			ExpectationService.new({
				label		= "Contains String",
				operator	= "contains"
			})
		);
		
		ExpectationService.save(
			ExpectationService.new({
				label		= "Does not contain String",
				operator	= "does not contain"
			})
		);
		
		ExpectationService.save(
			ExpectationService.new({
				label		= "Equals",
				operator	= "=="
			})
		);

		var Expectation = ExpectationService.new({
			label		= "Does Not Equal",
			operator	= "!="
		});
		
		ExpectationService.save(Expectation);
		var v = validateModel( Expectation );
		writedump(v.getAllErrorsAsStruct());
		abort;
	}

	public void function echoOK(event,rc,prc) {
		writeoutput("OK");
		abort;
	}

	public void function echoError(event,rc,prc) {
		writeoutput("error");
		event.setHTTPHeader(statusCode="500",statusText="Successful Error response").renderData(data="Error",type="plain");
		abort;
	}

}