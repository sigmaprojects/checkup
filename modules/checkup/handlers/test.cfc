component {

	property name="OriginService" inject="id:OriginService@Checkup";
	property name="DutyService" inject="id:DutyService@Checkup";
	

	public void function index(event,rc,prc){
		
		
		abort;
		
		/*
		var origin = OriginService.new();
		origin.setId( OriginService.getMacAddress() );
		origin.setSystem( true );
		OriginService.save(origin);
		abort;
		*/
	}

}