component table="checkup_dutyexpectation" persistent=true extends="checkup.models.BaseObject" accessors=true  entityname="checkup.models.DutyExpectation.DutyExpectation"
    cache=false autowire=false {

	//property name="id" column="dutyexpectation_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";
	property name="id" column="dutyexpectation_id" ormtype="char(35)" type="string" fieldtype="id" generator="assigned";

	property
		name="Duty"
		cfc="checkup.models.Duty.Duty"
		fkcolumn="duty_id"
		fieldtype="many-to-one"
    	missingRowIgnored="false";

	property
		name="Expectation"
		cfc="checkup.models.Expectation.Expectation"
		fkcolumn="expectation_id"
		fieldtype="many-to-one"
    	missingRowIgnored="false";	

	property
		name="Results"
        singularName="Result"
        fieldType="one-to-many"
        cfc="checkup.models.Result.Result"
        fkColumn="dutyexpectation_id"
        cascade="save-update";

	property
		name="value"
		index="value"
		ormtype="string"
		type="string";
		
	// where are we expecting this content to be?  the status code, the content body, etc (in ExpectationResult)
	property
		name="field"
		index="field"
		ormtype="string"
		type="string";

	property
		name="created"
		index="created"
		ormtype="timestamp"
		type="date";
	
	property
		name="updated"
		index="updated"
		ormtype="timestamp"
		type="date";


	public struct function toJSON() {
		var d = {};
		d['id']					= getID();
		d['duty_id']			= getDuty().getId();
		d['value']				= getValue();
		d['field']				= getField();
		d['expectation']		= getExpectation().toJSON();
		d['expectation_id']		= getExpectation().getId();
		d['results']			= arrayToJson(getResults());
		d['created']			= dateTimeFormat(getCreated(),"yyyy-mm-dd'T'HH:nn:ss");
		d['updated']			= dateTimeFormat(getUpdated(),"yyyy-mm-dd'T'HH:nn:ss");
		return d;
	}

	

	public void function preUpdate() {
		if(isNull(getUpdated()) || !isDate(getUpdated())) { setUpdated(DateConvert( "Local2UTC", Now() )); }
	}
	public void function preInsert() {
		if(isNull(getCreated()) || !isDate(getCreated())) { setCreated(DateConvert( "Local2UTC", Now() )); }
		if(isNull(getUpdated()) || !isDate(getUpdated())) { setUpdated(DateConvert( "Local2UTC", Now() )); }
	}

}