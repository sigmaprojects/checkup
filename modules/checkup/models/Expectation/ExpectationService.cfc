component extends="cborm.models.VirtualEntityService" singleton {

	property name="Logger" inject="logbox:logger:{this}";

	public any function init(){
		super.init("Expectation", "Expectation.query.cache", true );
		return this;
	}


}
