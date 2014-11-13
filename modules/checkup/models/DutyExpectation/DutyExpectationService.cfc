component extends="cborm.models.VirtualEntityService" singleton {

	property name="Logger" inject="logbox:logger:{this}";

	public any function init(){
		super.init("DutyExpectation", "DutyExpectation.query.cache", true );
		return this;
	}


}
