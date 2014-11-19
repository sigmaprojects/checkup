component table="checkup_sync" persistent=true extends="checkup.models.BaseObject" accessors=true entityname="checkup.models.Sync.Sync"
    cache=false autowire=false {

	// we don't merge sync logs, so it can be autoinc
	property name="id" column="sync_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

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