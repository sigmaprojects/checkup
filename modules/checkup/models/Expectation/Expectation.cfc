component table="checkup_expectation" persistent=true extends="checkup.models.BaseObject" accessors=true entityname="checkup.models.Expectation.Expectation"
    cache=false autowire=false {

	property name="id" column="expectation_id" ormtype="char(35)" type="string" fieldtype="id" generator="assigned";

	property
		name="operator"
		index="operator"
		ormtype="string"
		type="string";

	property
		name="label"
		index="label"
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
		d['operator']			= getOperator();
		d['created']			= dateTimeFormat(getCreated(),"yyyy-mm-dd'T'HH:nn:ss");
		d['updated']			= dateTimeFormat(getUpdated(),"yyyy-mm-dd'T'HH:nn:ss");
		return d;
	}


	this.constraints = {
		'operator'	= {
			required		= true,
			requiredMessage	= "Expectation operator is required",
			method			= "checkUniqueOperator",
			methodMessage	= "Expectation operator must be unique"
		},
		'label'		= {
			required		= true,
			requiredMessage	= "Expectation label is required"
		}
	};

	public boolean function checkUniqueOperator(value,target) {
		if( structKeyExists(arguments,'value') && isSimpleValue(arguments.value) ) {
			var thisId = getId();
			if( isNull(thisId) ) {
				var Existing = ORMExecuteQuery('FROM checkup.models.Expectation.Expectation e WHERE e.operator = :op',{op=arguments.value});
			} else {
				var Existing = ORMExecuteQuery('FROM checkup.models.Expectation.Expectation e WHERE e.operator = :op and e.id != :id',{op=arguments.value,id=thisId});
			}
			if( !arrayLen(Existing) ) {
				return true;
			}
		}
		return false;
		
		if( structKeyExists(arguments,'value') ) {
			if( isArray(arguments.value) && arrayLen(arguments.value) gte 1 ) {
				for( var img in arguments.value ) {
					var imgInfo = ImageInfo(img.getImgBinary());
					if( imgInfo.width neq 162 || imgInfo.height neq 175 ) {
						return false;
					}
				}
			} else {
				return false;
			}
		} else {
			return false;
		}
		return true;
	}
	

	public void function preUpdate() {
		if(isNull(getUpdated()) || !isDate(getUpdated())) { setUpdated(DateConvert( "Local2UTC", Now() )); }
	}
	public void function preInsert() {
		if(isNull(getCreated()) || !isDate(getCreated())) { setCreated(DateConvert( "Local2UTC", Now() )); }
		if(isNull(getUpdated()) || !isDate(getUpdated())) { setUpdated(DateConvert( "Local2UTC", Now() )); }
	}

}