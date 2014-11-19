component table="checkup_result" persistent=true extends="checkup.models.BaseObject" accessors=true entityname="checkup.models.Result.Result"
    cache=false autowire=false {

	//property name="id" column="expectationresult_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";
	property name="id" column="result_id" ormtype="char(35)" type="string" fieldtype="id" generator="assigned";

	property
		name="DutyExpectation"
		cfc="checkup.models.DutyExpectation.DutyExpectation"
		fkcolumn="dutyexpectation_id"
		fieldtype="many-to-one"
    	missingRowIgnored="false";	

	property
		name="failure"
		index="failure"
		ormtype="boolean"  
		type="boolean"
		default="false";

	property
		name="body"
		ormtype="clob"
		type="string";
	
	property
		name="statuscode"
		ormtype="double"  
		type="numeric";

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
		d['dutyexpectation_id']	= getDutyExpectation().getId();
		d['failure']			= getFailure();
		d['body']				= getBody();
		d['statuscode']			= getStatusCode();
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