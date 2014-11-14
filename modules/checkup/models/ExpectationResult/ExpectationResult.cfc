component table="checkup_expectationresult" persistent=true extends="checkup.models.BaseObject" accessors=true entityname="checkup.models.ExpectationResult.ExpectationResult"
    cache=false autowire=false {

	property name="id" column="expectationresult_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

	property
		name="Expectation"
		cfc="checkup.models.Expectation.Expectation"
		fkcolumn="expectation_id"
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
		d['failure']			= getFailure();
		d['body']				= getBody();
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