(function() {

	if ( !!localStorage.getItem('debug-analytics') ){
		debugger;
	}

    var config = window.analytics_config.page_info;

    /* Coremetrics legacy events */
    function registerDashboardCoremetricsEvents(){

		//Watch for page view events
		_$.subscribe( 'PageViewEvent', function(e){
			try{
				cmCreatePageviewTag(e.data.pageID, e.data.categoryID );
			}catch(err){}
		});

		_$.subscribe('ProductViewEvent', function(e){
			try{
				cmCreateProductviewTag(e.data.productID, e.data.productName, e.data.categoryID);
			}catch(err){}
		});

		_$.subscribe('ElementTagEvent', function(e){
			try{
				cmCreateElementTag(e.data.elementID, e.data.elementCategory);
			}catch(err){}

		});

		_$.on( 'body', 'click', function(evt){

			try{

				var target = evt.target;

				//Guided experience bar ('Deploy you app the way you want..')
				if ( target.name === 'myResourcesIntroButtons_geMyResourcesCloudFoundry'){
					//Cloud Foundry icon
					cmCreatePageviewTag("BLUEMIX DASHBOARD_ Cloud Foundry_VP", 'BLUEMIX' );
				}
				else if ( target.name === "myResourcesIntroButtons_geMyResourcesContainers"){
					//IBM Containers icon
					cmCreatePageviewTag("BLUEMIX DASHBOARD_ IBM Containers _VP", 'BLUEMIX');
				}
				else if ( target.name === 'myResourcesIntroButtons_geMyResourcesVM'){
					//Virtual Machines
					cmCreatePageviewTag("BLUEMIX DASHBOARD_ Virtual Machines_VP", 'BLUEMIX');
				}
				//Create app type buttons
				else if ( target.getAttribute('data-cloudoe-apptype') === 'web'){
					//Create web app
					cmCreatePageviewTag("Web App_VP", "BLUEMIX ");
				}
				else if ( target.getAttribute('data-cloudoe-apptype') == 'mobile' ){
					//Create mobile app
					cmCreatePageviewTag("Mobile App_VP", "BLUEMIX ");
				}
				//Finish button after adding a name
				else if ( target.nodeName == 'BUTTON' && target.classList.contains('createAppFinishButton') ){
					cmCreatePageviewTag("Finish App Creation_VP", "BLUEMIX ");
				}
				//Download Cloud Foundry link
				else if ( target.alt == 'Download Cloud Foundry command line interface' ){
					cmCreatePageviewTag("Download CF CLI_VP", "BLUEMIX ");
				}
				//Download starter code.
				else if ( target.alt == 'Download Starter Code'){
					cmCreatePageviewTag("Download Start Code _VP", "BLUEMIX ");
				}
				//Select coding type
				else if ( target.getAttribute('data-coremetrics-id') == 'bluemixEclipse' ){
					cmCreatePageviewTag("Eclipse_VP", "BLUEMIX ");
				}
				else if ( target.getAttribute('data-coremetrics-id') == 'cfCommandLine' ){
					cmCreatePageviewTag("CF_VP", "BLUEMIX ");
				}
				else if ( target.getAttribute('data-coremetrics-id') == 'git' ){
					cmCreatePageviewTag("GIT_VP", "BLUEMIX ");
				}
				//Git - Coding
				else if ( target.nodeName == 'IMG' && target.alt == 'Download the bl command line button' ){
					cmCreatePageviewTag("Download BL _VP", "BLUEMIX ");
				}
				//Eclipse - Coding
				else if ( target.nodeName == 'IMG' && target.alt == 'Drag and drop into a running Eclipse Luna workspace to install IBM Eclipse Tools for Bluemix'){
					cmCreatePageviewTag("Install_VP", "BLUEMIX ");
				}
				//Add Git
				else if ( target.classList.contains('addRepoButton') ){
					cmCreatePageviewTag("Install_VP", "BLUEMIX ");
				}
			}catch( err ){
				console.log( 'Error logging coremetrics event: ' + err.message );
			}
		});
	}


    function getPageID(){
        var pageID = "BLUEMIX OTHER";
        try{
            pageID = window.analytics_config.page_info.pageId;
        }catch(err){
            try{
              pageID =   digitalData.page.pageInfo.pageID;
          }catch(err){};
        }

        if ( pageID === 'BLUEMIX DASHBOARD' && document.querySelector('.isShowing_pricingSheet') ){
            pageID = "BLUEMIX PRICING";
        }else if ( window.digitalData &&  window.digitalData.isCatalogDetailsPage ){
            pageID = "BLUEMIX CATALOG DETAILS";
        }else if ( window.digitalData && window.digitalData.page && digitalData.page.isCatalogDetailsPage ){
            pageID = "BLUEMIX CATALOG DETAILS";
        }

        return pageID;

    }

    function getUserID() {

        var user;
        if (window.header && window.header.accountStatus && window.header.accountStatus.userGuid) {
            user = window.header.accountStatus.userGuid;
        }
        return user;
    }

    function getQueryParameters() {
		var result = {};
		var location = window.location.href.replace('#', '&' );
	    var hashes = location.slice(location.indexOf('?') + 1).split('&');
	    for(var i = 0; i < hashes.length; i++)
	    {
	        var hash = hashes[i].split('=');
	        var key = hash[0];
	        var value = hash[1];
	        result[key] = value;
	    }
	    return result;
	}

	// Get the user's current region - e.g. US South
    function getRegion() {
    	var region = 'unknown';
    	try{
    		region = document.querySelector('.current-region').getAttribute('data-name');
    	}
    	catch(err){}
    	return region;
    }


    function pollForHeaderAuthReady() {

        var promise = new Promise(function(resolve, reject) {
            var interval = setInterval(function() {
                if (getUserID()) {
                    clearInterval(interval);
                    resolve(getUserID());
                }
            }, 500);

        });

        return promise;

    }

   	function pageEvent(category, name, properties, options){
   		console.log( 'Page Event: ' + category + ", " + name);
   		analytics.page(category, name, properties, options);
   	}

    function trackEvent(title, properties){
        console.log( 'Track Event: ' + title);
        analytics.track(title, properties);
    }

    function addCommonTags(){

    	//Do we load intercomm?
        var intercomm_enabled = !!localStorage.getItem('intercomm_configuration');

        pollForHeaderAuthReady().then(function(uid) {
            analytics.identify(uid, {
                ui_version: 'old'
            }, {
                integrations: {
                    'All': true,
                    'Intercom': intercomm_enabled
                }
            });
        });

    	//Watch customers who click on the 'Try new bluemix link'
        _$.on('#alternateConsoleHost a', 'click', function() {
            trackEvent('Switch to New Bluemix');
        });

        //Registration page, or anything kicked out by the classic code.
        _$.subscribe('SegmentTrackEvent', function(message) {
            try {
                trackEvent(message.title, message.data);
            } catch (err) {}
        });

    }

    function addCatalogTags(){

    	var category = "Catalog";
    	var name = category + ' - Overview';
        var properties =getPageProperties();
        var options = getPageOptions();
		pageEvent(category, name, properties, options);

    }

    function addCatalogDetailsTags(config){
    	var category = "Catalog Details";
    	var name = digitalData.page.pageInfo.pageID.replace('BLUEMIX CATALOG', 'Catalog Details');
        var properties =getPageProperties();
        var options = getPageOptions();
		pageEvent(category, name, properties, options);
    }

 
    function addDashboardTags(){

    	var category = "Dashboard";
    	var subCategory = getDashboardSubCategory().replace(' - ', '');
        if ( subCategory == 'App Details' || subCategory == 'Service Details'){
            category = 'Component Details';
        }
    	var name = category + getDashboardSubCategory() + getDashboardComponent(subCategory) + getDashboardView();
        var properties =getPageProperties();
        var options = getPageOptions();
		pageEvent(category, name, properties, options);


    }

    function getDashboardSubCategory(){
    	var subCategory = '';

    	if ( document.querySelector('.dijitVisible .cloudOEServiceInstanceDetails') ){
    		subCategory = "Service Details";
    	}
    	else if (document.querySelector('.cloudOEAppDetails')){
    		subCategory = 'App Details';
    	}
    	else if ( document.querySelector('.cloudOEMyResources') ){
    		subCategory = 'Overview';
    	}

    	subCategory = subCategory || "";
    	subCategory = subCategory.trim();

    	if ( subCategory.length > 0 ){
    		subCategory = ' - ' + subCategory;
    	}

    	return subCategory;

    }

    function getDashboardComponent(subCategory){
    	var component;
    	if ( subCategory == 'Service Details'){
    		component = _$.text('.serviceName');
    	}else if ( subCategory == 'App Details'){
    		component = _$.text('.appName');
    	}

    	component = component || "";
    	component = component.trim();

    	if (component.length > 0 ){
    		component = ' - ' + component;
    	}

    	return component;

    }

    function getDashboardView(){

    	var view = "";
    	view = _$.text('.navigationTreeNodeSelected') || "";

    	view = view.trim();

    	if ( view.length > 0 ){
    		view = ' - ' + view;
    	}

    	return view;

    }

    function addPricingTags(){
       
    	var category = "Pricing";
    	var name = category + getPricingSubCategory();
        var properties =getPageProperties();
        var options = getPageOptions();
		pageEvent(category, name, properties, options);
    }

    function getPricingSubCategory(){
    	var subCategory = "";
    	if ( document.querySelector('.isShowing_pricingSheet') ){
    		subCategory = " - Calculator";
    	}else{
    		subCategory = " - Overview";
    	}

    	return subCategory;
    }

    function addHomeTags(config){

    	var category = "Home";
    	var name = category + ' - ' + (config.isAuthenticatedPage ? "Authenticated" : "Unauthenticated");
        var properties =getPageProperties();
        var options = getPageOptions();

		pageEvent(category, name, properties, options);

    }

    /*
     Properties common to all page events
     */
    function getPageProperties(){
        var properties = {
        	region: getRegion(),
        	ui_version : 'old',
        	wipi : _$.getCookie('BLUISS') || '---',
            authenticated: window.analytics_config.page_info.isAuthenticatedPage
        };

        properties = addTimingData(properties);

        return properties;
    }

    function addTimingData(properties) {

        try {

            var timing = window.performance && window.performance.timing;
            var navigation = window.performance && window.performance.navigation;
            if (timing) {
                properties.unload = timing.unloadEventEnd - timing.unloadEventStart;
                properties.redirect = timing.redirectEnd - timing.redirectStart;
                properties.dns = timing.domainLookupEnd - timing.domainLookupStart;
                properties.tcp = timing.connectEnd - timing.connectStart;
                properties.ssl = timing.secureConnectionStart && (timing.connectEnd - timing.secureConnectionStart);

                properties.ttfb = timing.responseStart - timing.navigationStart;
                properties.domInteractive = timing.domInteractive - timing.navigationStart;
                properties.domComplete = timing.domComplete - timing.navigationStart;
                properties.pageLoadTime = timing.loadEventEnd - timing.navigationStart;

                properties.basePage = timing.responseEnd - timing.responseStart;
                properties.frontEnd = timing.loadEventStart - timing.responseEnd;
            }

            if (navigation) {
                properties.redirectCount = navigation.redirectCount;
                properties.navigationType = navigation.type;
            }
        } catch (err) {}

        return properties;
    }

    /* 
     Options common to all page events
     */
    function getPageOptions(){
        var intercomm_enabled = !!localStorage.getItem('intercomm_configuration');
        var options = {
            integrations: {
                'All': true,
                'Intercom': ( intercomm_enabled === true )
            }
        };
        return options;
    }

    function addRegistrationTags(pageID){
    	var category = "Registration";
    	var name = category + " - Trial";
        var properties =getPageProperties();
        var options = getPageOptions();

		pageEvent(category, name, properties, options);

    }

    function addDocsTags(config){

        var category = "Documentation";

        var context_root = "Documentation";
        var subCategory = "Overview";
        try{
            var paths = window.location.pathname.split('/');
            paths = paths.filter(function(path){
                return ( path.length > 0 );
            });
            context_root = paths.shift();
            subCategory = paths.shift();
        }catch(err){}

        var name = category + ' - ' + subCategory;
        var properties =getPageProperties();
        var options = getPageOptions();

        pageEvent(category, name, properties, options);

    }

    function addGenericTags(pageID){
    	var category = pageID;
        var properties =getPageProperties();
        var options = getPageOptions();

		pageEvent(category, '', properties, options);

    }


	var page_id = getPageID();

	if ( page_id == "IBMBLUEMIX"){
		addHomeTags(config);
	}
	else if (page_id == 'BLUEMIX DASHBOARD'){
		addDashboardTags(config);
		registerDashboardCoremetricsEvents();
        //Use the hash change event to figure out when the user is moving between 'virtual' screens.
        window.addEventListener("hashchange", function(){
            addDashboardTags(config);
        }, false);
	}
	else if (page_id == 'BLUEMIX PRICING') {
		addPricingTags(config);
	}else if (page_id == 'BLUEMIX CATALOG') {
        addCatalogTags(config);
    }else if ( page_id == 'BLUEMIX CATALOG DETAILS'){
    	addCatalogDetailsTags( config );
    }
    else if ( page_id == 'Bluemix Signup'){
    	addRegistrationTags(config);
    }
    else if ( page_id == 'BLUEMIX DOCS'){
        addDocsTags(config);
    }
    else{
    	addGenericTags(page_id);
    }

	addCommonTags();



})();
