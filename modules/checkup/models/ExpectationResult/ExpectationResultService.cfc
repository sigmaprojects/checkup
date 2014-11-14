component extends="cborm.models.VirtualEntityService" singleton {

	property name="ValidationManager" inject="ValidationManager@validation";

	property name="Logger" inject="logbox:logger:{this}";

	public any function init(){
		super.init("checkup.models.ExpectationResult.ExpectationResult", "ExpectationResult.query.cache", true );
		return this;
	}


	/*
	public boolean function save(Required Expectation) {
		var validationResults = ValidationManager.validate( Expectation );
		if( validationResults.hasErrors() ) {
			Logger.warn("Expectation did not pass validation.",validationResults.getAllErrorsAsStruct());
			return false;
		}
		super.save(Expectation);
		return true;
	}
	*/

}
