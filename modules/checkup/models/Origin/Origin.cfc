component table="checkup_origin" persistent=true extends="checkup.models.BaseObject" accessors=true
    cache=false autowire=false {

	// the origin id is the MAC address with colon notation
	property name="id" column="origin_id" ormtype="char(17)" length="17" type="string" fieldtype="id" generator="assigned";

	property
		name="serviceurl"
		index="serviceurl"
		ormtype="string"
		type="string";

	// defaults to the computer name 
	property
		name="label"
		index="label"
		ormtype="string"
		type="string";

	// the origin id of where this record came from (aka parent)
	property
		name="genisis"
		index="genisis"
		ormtype="char(17)"
		length="17" 
		type="string";

	// did this record originate from this system?
	property
		name="system"
		index="system"
		ormtype="boolean"  
		type="boolean"
		default="false";

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
		d['label']				= getBody();
		d['created']			= dateTimeFormat(getCreated(),"yyyy-mm-dd'T'HH:nn:ss");
		d['updated']			= dateTimeFormat(getUpdated(),"yyyy-mm-dd'T'HH:nn:ss");
		return d;
	}

	public void function setLabel(Required String input) { variables.label = trim(arguments.input); }

	this.constraints = {
		'label'			= {
			required		= true,
			requiredMessage	= "Origin Label is required"
		},
		'serviceurl'		= {
			required		= true,
			requiredMessage	= "Origin ServiceURL is required"
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