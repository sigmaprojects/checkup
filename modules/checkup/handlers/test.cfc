component {

	property name="OriginService" inject="id:OriginService@Checkup";
	property name="DutyService" inject="id:DutyService@Checkup";
	property name="ExpectationService" inject="id:ExpectationService@Checkup";
	

	public void function createOrigin(event,rc,prc){
		var origin = OriginService.new();
		origin.setId( OriginService.getMacAddress() );
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
		
		ExpectationService.save(
			ExpectationService.new({
				label		= "Does Not Equal",
				operator	= "!="
			})
		);

		abort;
	}



}