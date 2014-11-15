component table="checkup_dutyexpectation" persistent=true extends="checkup.models.BaseObject" accessors=true  entityname="checkup.models.DutyExpectation.DutyExpectation"
    cache=false autowire=false {

	//property name="id" column="dutyexpectation_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";
	property name="id" column="dutyexpectation_id" ormtype="char(16)" type="string" fieldtype="id" generator="guid" generated="insert";

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
		name="Result"
		cfc="checkup.models.Result.Result"
		fkcolumn="result_id"
		fieldtype="many-to-one"
    	missingRowIgnored="false";	

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
		d['duty']				= getDuty().toJSON();
		d['expectation']		= getExpectation().toJSON();
		d['created']			= dateTimeFormat(getCreated(),"yyyy-mm-dd'T'HH:nn:ss");
		d['updated']			= dateTimeFormat(getUpdated(),"yyyy-mm-dd'T'HH:nn:ss");
		return d;
	}

	

	public void function preUpdate() {
		setUpdated(DateConvert( "Local2UTC", Now() ));
	}
	public void function preInsert() {
		setCreated(DateConvert( "Local2UTC", Now() ));
		setUpdated(DateConvert( "Local2UTC", Now() ));
	}

}