component extends="cborm.models.VirtualEntityService" singleton {

	property name="ValidationManager" inject="ValidationManager@validation";
	
	property name="Logger" inject="logbox:logger:{this}";

	public any function init(){
		super.init("checkup.models.Duty.Duty", "Duty.query.cache", true );
		return this;
	}

	public boolean function save(Required Duty) {
		var validationResults = ValidationManager.validate( Duty );
		if( validationResults.hasErrors() ) {
			Logger.warn("Duty did not pass validation.",validationResults.getAllErrorsAsStruct());
			return false;
		}
		super.save(Duty);
		return true;
	}

}
