component extends="cborm.models.VirtualEntityService" singleton {

	property name="ValidationManager" inject="ValidationManager@validation";

	property name="Logger" inject="logbox:logger:{this}";

	public any function init(){
		super.init("checkup.models.Result.Result", "Result.query.cache", true );
		return this;
	}


	public boolean function save(Required Result) {
		var validationResults = ValidationManager.validate( Result );
		if( validationResults.hasErrors() ) {
			Logger.warn("Result did not pass validation.",validationResults.getAllErrorsAsStruct());
			return false;
		}
		super.save(Result);
		return true;
	}

}
