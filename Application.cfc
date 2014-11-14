/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldboxframework.com | www.luismajano.com | www.ortussolutions.com
********************************************************************************
*/
component{
	// Application properties
	this.name = "Checkup-3";
	this.sessionManagement = true;
	this.applicationTimeout = createTimeSpan(0,0,0,1);
	this.sessionTimeout = createTimeSpan(0,0,30,0);
	this.setClientCookies = true;

	// COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP
	COLDBOX_APP_ROOT_PATH = getDirectoryFromPath( getCurrentTemplatePath() );
	// The web server mapping to this application. Used for remote purposes or static purposes
	COLDBOX_APP_MAPPING   = "";
	// COLDBOX PROPERTIES
	COLDBOX_CONFIG_FILE 	 = "";
	// COLDBOX APPLICATION KEY OVERRIDE
	COLDBOX_APP_KEY 		 = "";
	// JAVA INTEGRATION: JUST DROP JARS IN THE LIB FOLDER
	// You can add more paths or change the reload flag as well.
	this.javaSettings = { loadPaths = [ "lib" ], reloadOnChange = false };
	
	this.mappings["/cborm"] = COLDBOX_APP_ROOT_PATH & "/modules/cborm";
	this.mappings["/checkup"] = COLDBOX_APP_ROOT_PATH & "/modules/checkup";

	this.datasources["checkup"] = {
		class: 'org.gjt.mm.mysql.Driver'
		,connectionString: 'jdbc:mysql://192.168.1.75:3306/checkup?useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=exception&autoReconnect=true&jdbcCompliantTruncation=true&allowMultiQueries=false&useLegacyDatetimeCode=true'
		,username: 'checkup'
		,password: "encrypted:cb06b2778d433ac4d79ec79b3f4a900a9bfc4362947727ea42a367825b80fd7d4637a707cc695cfb"
		// optional settings
		,blob:true // default: false
	};
	this.defaultdatasource = "checkup";
	this.ormenabled = "true";
	this.ormsettings = {
		datasource = "checkup",
		skipCFCWithError = false,
		autorebuild = true,
		dialect="org.hibernate.dialect.MySQL5InnoDBDialect",
		dbcreate="update",
		logSQL = false,
		flushAtRequestEnd = false,
		autoManageSession = false,
		eventHandling = true,
		cfclocation=["/modules/checkup/models"]
	};
	this.ormsettings.secondarycacheenabled = false;


	// application start
	public boolean function onApplicationStart(){
		application.cbBootstrap = new coldbox.system.Bootstrap( COLDBOX_CONFIG_FILE, COLDBOX_APP_ROOT_PATH, COLDBOX_APP_KEY, COLDBOX_APP_MAPPING );
		application.cbBootstrap.loadColdbox();
		return true;
	}

	// request start
	public boolean function onRequestStart(String targetPage){
		if(structKeyExists(url,"ormreload")) {
			ORMReload();
		}
		// Bootstrap Reinit
		if( not structKeyExists(application,"cbBootstrap") ){
			lock name="coldbox.bootstrap.#this.name#" type="exclusive" timeout="5" throwonTimeout=true{
				structDelete( application, "cbBootStrap" );
				onApplicationStart();
			}
		}

		// Process ColdBox Request
		application.cbBootstrap.onRequestStart( arguments.targetPage );

		return true;
	}

	public void function onSessionStart(){
		application.cbBootStrap.onSessionStart();
	}

	public void function onSessionEnd( struct sessionScope, struct appScope ){
		arguments.appScope.cbBootStrap.onSessionEnd( argumentCollection=arguments );
	}

	public boolean function onMissingTemplate( template ){
		return application.cbBootstrap.onMissingTemplate( argumentCollection=arguments );
	}

}