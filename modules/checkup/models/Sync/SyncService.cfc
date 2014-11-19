component extends="cborm.models.VirtualEntityService" singleton {

	property name="ValidationManager" inject="ValidationManager@validation";

	property name="Logger" inject="logbox:logger:{this}";

	public any function init(){
		super.init("checkup.models.Sync.Sync", "Sync.query.cache", true );
		return this;
	}


	public boolean function save(Required Sync) {
		var validationResults = ValidationManager.validate( Sync );
		if( validationResults.hasErrors() ) {
			Logger.warn("Sync did not pass validation.",validationResults.getAllErrorsAsStruct());
			return false;
		}
		super.save(Sync);
		return true;
	}

}
