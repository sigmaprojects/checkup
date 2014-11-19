component {

	property name="OriginService" inject="id:OriginService@Checkup";
	property name="DutyService" inject="id:DutyService@Checkup";
	property name="DutyExpectationService" inject="id:DutyExpectationService@Checkup";
	property name="ExpectationService" inject="id:ExpectationService@Checkup";
	property name="ResultService" inject="id:ResultService@Checkup";


	public void function index(event,rc,prc){
		rc.Duties = DutyService.list(asQuery=false,sortOrder="created desc");
		event.setView( "duty/index" );
	}


	public void function edit(event,rc,prc){
		rc.Duty = DutyService.get( event.getValue('id','') );
		rc.Expectations = ExpectationService.list(asQuery=false);
		event.setView( "duty/edit" );
	}

	public void function save(event,rc,prc) {
		var dataArray = generateDutyExpectationData();
		var Duty = DutyService.get( event.getValue('duty_id','') );
		Duty.setDutyUrl( rc.dutyUrl );
		
		var Origin = OriginService.getSystemOrigin();
		Duty.setOrigin(Origin);
		
		// gather a list of existing DE ids to use as comparision later when removing
		var existingDEIds = Duty.getDutyExpectationIds();
		
		// an array containing the DE ids' from the form
		var newDEIds = [];
		
		// loop the generated DE data and set all that.
		for( var formDutyExpectation in dataArray ) {
			var DutyExpectation = DutyExpectationService.get(formDutyExpectation.dutyexpectation_id);
			DutyExpectation.setExpectation( ExpectationService.get(formDutyExpectation.operator_id) );
			DutyExpectation.setValue( formDutyExpectation.value );
			DutyExpectation.setField( formDutyExpectation.field );
			DutyExpectationService.save( DutyExpectation );
			Duty.addDutyExpectation(DutyExpectation);
			EntityReload(DutyExpectation);
			var newId = DutyExpectation.getId();
			arrayAppend(newDEIds,newId);
		}
		
		// loop the DE ids and see which ones need to be deleted
		for(var eId in existingDEIds) {
			if( !ArrayContains(newDEIds,eId) ) {
				// delete the non-existing eId because the user wants it removed.
				var DutyExpectation = DutyExpectationService.get(eId);
				Duty.removeDutyExpectation( DutyExpectation );
			}
		}
		DutyService.save(Duty);
		/*
		writedump(formDutyExpectation);
		writedump(existingDEIds);
		abort;
		*/
		setNextEvent('checkup:duty.index');
		
	}

	private array function generateDutyExpectationData() {
		var formMap = getPageContext().getRequest().getParameterMap();
		var data = [];
		for( var i=1; i lte arrayLen(formMap.value); i++ ) {
			
			var m = {
				field				= formMap['field'][i],
				value				= formMap['value'][i],
				operator_id			= formMap['operator'][i],
				dutyexpectation_id	= formMap['dutyexpectation_id'][i]
			};
			arrayAppend(data,m);
		}
		return data;
	}

}