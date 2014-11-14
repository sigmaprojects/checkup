component extends="cborm.models.VirtualEntityService" singleton {

	property name="Logger" inject="logbox:logger:{this}";

	public any function init(){
		super.init("checkup.models.Origin.Origin", "Origin.query.cache", true );
		return this;
	}


	public void function save(Required Origin) {
		if( isNull(Origin.getLabel()) && !Len(trim(Origin.getLabel())) ) {
			Origin.setLabel( getHostName() );
		}
		super.save(Origin);
	}


	public Origin function getSystemOrigin() {
		return super.findWhere({system=true});
	}


	public string function getHostName() {
		var hostname = createUuid();
		try {
			hostname = createObject("java", "java.net.InetAddress").getLocalHost().getHostName();
		} catch(any e) {
			try {
				hostname = CGI.SERVER_NAME;
			} catch(any e) {}
		}
		return hostname;
	}


	public string function getMacAddress() {
		try {
			var localHost = createObject( "java", "java.net.InetAddress" ).getLocalHost();
			var HWA = createObject( "java", "java.net.NetworkInterface" ).getByInetAddress( localHost ).getHardWareAddress();
			var mac = "";
			var cheat = javaCast("java.lang.String", "");
			for(var i=1; i lte arrayLen(HWA); i++) {
				var objArr = javaCast("java.lang.Object[]", [HWA[i],(i < arrayLen(HWA)) ? "-" : ""] );
				mac = mac & cheat.format("%02X%s", objArr);
			}
			return mac;
		} catch(any e) {
			// localhost doesn't have a mac
		}
		// this is kind of ugly, but for whatever reason sometimes the localhost hardware address is null, so we can't use it directly
		// just loop all the interfaces, and the first one with a valid HWA wins.
		var NetworkInterfaces = createObject( "java", "java.net.NetworkInterface" ).getNetworkInterfaces();
		for(var NI in NetworkInterfaces) {
			var HWA = NI.getHardwareAddress();
			if( !IsNull(HWA) ) {
				var mac = "";
				var cheat = javaCast("java.lang.String", "");
				for(var i=1; i lte arrayLen(HWA); i++) {
					var objArr = javaCast("java.lang.Object[]", [HWA[i],(i < arrayLen(HWA)) ? ":" : ""] );
					mac = mac & cheat.format("%02X%s", objArr);
				}
				return mac;
			}
		}
		throw("Shouldn't have gotten this far, couldn't find a MAC address anywhere");
	}


}
