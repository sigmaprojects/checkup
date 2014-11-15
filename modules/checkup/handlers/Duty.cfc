component {

	property name="OriginService" inject="id:OriginService@Checkup";
	property name="DutyService" inject="id:DutyService@Checkup";
	property name="DutyExpectationService" inject="id:DutyExpectationService@Checkup";
	property name="ExpectationService" inject="id:ExpectationService@Checkup";
	property name="ExpectationResultService" inject="id:ExpectationResultService@Checkup";


	public void function index(event,rc,prc){
		rc.Duties = DutyService.list(asQuery=false,sortOrder="created desc");
		event.setView( "duty/index" );
	}


	public void function edit(event,rc,prc){
		rc.Duty = DutyService.get( event.getValue('id',0) );
		rc.Expectations = ExpectationService.list(asQuery=false);
		event.setView( "duty/edit" );
	}




}