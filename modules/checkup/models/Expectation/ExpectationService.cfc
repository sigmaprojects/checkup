component extends="cborm.models.VirtualEntityService" singleton {

	property name="ValidationManager" inject="ValidationManager@validation";

	property name="Logger" inject="logbox:logger:{this}";

	public any function init(){
		super.init("checkup.models.Expectation.Expectation", "Expectation.query.cache", true );
		return this;
	}


	public boolean function save(Required Expectation) {
		var validationResults = ValidationManager.validate( Expectation );
		if( validationResults.hasErrors() ) {
			Logger.warn("Expectation did not pass validation.",validationResults.getAllErrorsAsStruct());
			return false;
		}
		if( isNull(Expectation.getId()) ) {
			Expectation.setId( createUuid() );
		}
		super.save(Expectation);
		return true;
	}

	public any function findByOperator(Required String Operator) {
		try {
			return super.findByExample(super.new({operator=trim(arguments.Operator)}),true);
		} catch(any e) {}
		return;
	}

}
