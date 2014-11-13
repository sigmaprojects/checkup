component {

	property name="OriginService" inject="id:OriginService@Checkup";

	public void function index(event,rc,prc){
		
		writedump(OriginService.getSystemOrigin());
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