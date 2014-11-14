component table="checkup_expectation" persistent=true extends="checkup.models.BaseObject" accessors=true entityname="checkup.models.Expectation.Expectation"
    cache=false autowire=false {

	property name="id" column="expectation_id" ormtype="integer" type="numeric" fieldtype="id" generator="native" generated="insert";

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
				var q = new Query(sql="SELECT count(1) FROM checkup_expectation ce WHERE ce.operator = :op");
			} else {
				var q = new Query(sql="SELECT count(1) FROM checkup_expectation ce WHERE ce.operator = :op and ce.expectation_id != :id");
				q.addParam( name="id", value = thisId, CFSQLTYPE="CF_SQL_INTEGER" );
			}
			q.addParam( name="op", value = arguments.value, CFSQLTYPE="CF_SQL_VARCHAR" );
			var count = q.execute().getResult();
			if( count.recordCount == 0 ) {
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
		setUpdated(DateConvert( "Local2UTC", Now() ));
	}
	public void function preInsert() {
		setCreated(DateConvert( "Local2UTC", Now() ));
		setUpdated(DateConvert( "Local2UTC", Now() ));
	}

}