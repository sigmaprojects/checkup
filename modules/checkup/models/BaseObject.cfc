component name="BaseObject" cache=false accessors=true {

	public string function getIDName() {
		var classname = ListLast( GetMetaData( This ).fullname, "." );
		return ORMGetSessionFactory().getClassMetadata( classname ).getIdentifierColumnNames()[1];
	}
	
	public any function setIDValue(Required ID) {
		return Evaluate( "set" & getIDName() & "(#ID#)" );
	}

	public any function getIDValue() {
		return Evaluate( "get" & getIDName() & "()" );
	}

	public array function arrayToJSON(Array Arr) {
		var jsonarr = [];
		if(structKeyExists(arguments,'Arr') && IsArray(arguments.Arr)) {
			for(var Obj in Arr) {
				if( structKeyExists(Obj,'toJSON') ) {
					arrayAppend( jsonarr,Obj.toJSON() );
				}
			}
		}
		return jsonarr;
	}

	public void function clearRelationships(Required String Relationship) {
		var getFn = 'get#arguments.Relationship#';
		var hasFn = 'has#Left(arguments.Relationship,Len(arguments.Relationship)-1)#';
		var removeFn = 'remove#Left(arguments.Relationship,Len(arguments.Relationship)-1)#';
		var Items = this[getFn]();
		while(this[hasFn]()) {
			this[removeFn](Items[1]);
		}
	}
	public void function clearRelationship(Required String Relationship) {
		var setFn = 'set#arguments.Relationship#';
		this[setFn](javaCast('null',''));
	}


}