component table="checkup_duty" persistent=true extends="checkup.models.BaseObject" accessors=true
    cache=false autowire=false {

	property name="id" column="duty_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

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
		d['origin']				= getOrigin();
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
	

	public void function preUpdate() {
		setUpdated(DateConvert( "Local2UTC", Now() ));
	}
	public void function preInsert() {
		setCreated(DateConvert( "Local2UTC", Now() ));
		setUpdated(DateConvert( "Local2UTC", Now() ));
	}

}