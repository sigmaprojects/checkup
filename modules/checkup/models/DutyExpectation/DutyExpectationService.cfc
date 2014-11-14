component extends="cborm.models.VirtualEntityService" singleton {
	
	property name="Logger" inject="logbox:logger:{this}";

	public any function init(){
		super.init("checkup.models.DutyExpectation.DutyExpectation", "DutyExpectation.query.cache", true );
		return this;
	}

}