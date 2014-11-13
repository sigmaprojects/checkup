component table="checkup_expectation" persistent=true extends="checkup.models.BaseObject" accessors=true
    cache=false autowire=false {

	property name="id" column="expectation_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

	property
		name="label"
		index="label"
		ormtype="string"
		type="string";

	property
		name="operator"
		index="operator"
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
		d['label']				= getLabel();
		d['origin']				= getOrigin();
		d['created']			= dateTimeFormat(getCreated(),"yyyy-mm-dd'T'HH:nn:ss");
		d['updated']			= dateTimeFormat(getUpdated(),"yyyy-mm-dd'T'HH:nn:ss");
		return d;
	}


	this.constraints = {
		'operator'	= {
			required		= true,
			requiredMessage	= "Expectation operator is required"
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