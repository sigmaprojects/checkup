component {

	property name="OriginService" inject="id:OriginService@Checkup";
	property name="DutyService" inject="id:DutyService@Checkup";
	property name="DutyExpectationService" inject="id:DutyExpectationService@Checkup";
	property name="ExpectationService" inject="id:ExpectationService@Checkup";
	property name="ResultService" inject="id:ResultService@Checkup";
	property name="CheckupService" inject="id:CheckupService@Checkup";

	public void function contactTest(event,rc,prc) {
		var Duty = DutyService.get("417baae1-6c93-11e4-bb20-000c29e80bf8");
		CheckupService.report(Duty);
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
			Expectation	= ExpectationService.findByExample(ExpectationService.new({operator="contains"}),true),
			value		= "OK",
			field		= "body"
		}));
		arrayAppend(DutyExpectations, DutyExpectationService.new({
			Duty		= Duty,
			Expectation	= ExpectationService.findByExample(ExpectationService.new({operator="="}),true),
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
				label		= "Equals",
				operator	= "="
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


}