component table="checkup_duty" persistent=true extends="checkup.models.BaseObject" accessors=true entityname="checkup.models.Duty.Duty" 
    cache=false autowire=false {

	//property name="id" column="duty_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";
	property name="id" column="duty_id" ormtype="char(35)" type="string" fieldtype="id" generator="assigned";

	property
		name="dutyurl"
		index="dutyurl"
		ormtype="string"
		type="string";

	property
		name="Origin"
		cfc="checkup.models.Origin.Origin"
		fkcolumn="origin_id"
		fieldtype="many-to-one"
    	missingRowIgnored="false";

	property
		name="DutyExpectations"
        singularName="DutyExpectation"
        fieldType="one-to-many"
        cfc="checkup.models.DutyExpectation.DutyExpectation"
        fkColumn="duty_id"
        cascade="save-update";

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
		d['dutyurl']			= getDutyURL();
		d['origin_id']			= getOrigin().getId();
		d['dutyexpectations']	= arrayToJson(getDutyExpectations());
		d['created']			= dateTimeFormat(getCreated(),"yyyy-mm-dd'T'HH:nn:ss");
		d['updated']			= dateTimeFormat(getUpdated(),"yyyy-mm-dd'T'HH:nn:ss");
		return d;
	}


	this.constraints = {
		'dutyurl'		= {
			required		= true,
			requiredMessage	= "Duty URL is required"
		}
	};
	
	public array function getDutyExpectationIds() {
		return ORMExecuteQuery('SELECT de.id FROM checkup.models.DutyExpectation.DutyExpectation de WHERE de.Duty.id = :dutyId',{dutyId=getId()});
	}

	public void function preUpdate() {
		if(isNull(getUpdated()) || !isDate(getUpdated())) { setUpdated(DateConvert( "Local2UTC", Now() )); }
	}
	public void function preInsert() {
		if(isNull(getCreated()) || !isDate(getCreated())) { setCreated(DateConvert( "Local2UTC", Now() )); }
		if(isNull(getUpdated()) || !isDate(getUpdated())) { setUpdated(DateConvert( "Local2UTC", Now() )); }
	}

}