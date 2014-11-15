component extends="cborm.models.VirtualEntityService" singleton {
	
	property name="ValidationManager" inject="ValidationManager@validation";
	
	property name="Logger" inject="logbox:logger:{this}";

	public any function init(){
		super.init("checkup.models.DutyExpectation.DutyExpectation", "DutyExpectation.query.cache", true );
		return this;
	}

	public boolean function save(Required DutyExpectation) {
		var validationResults = ValidationManager.validate( DutyExpectation );
		if( validationResults.hasErrors() ) {
			Logger.warn("DutyExpectation did not pass validation.",validationResults.getAllErrorsAsStruct());
			return false;
		}
		super.save(DutyExpectation);
		return true;
	}

}