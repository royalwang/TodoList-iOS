/* used this for help loading coremetrics via embed method (copy from corporate ibmweb source)*/
/*Wiki page link for tracking versions -
 * https://w3-connections.ibm.com/wikis/home?lang=en#!/wiki/We47dc116426d_4c14_bbb4_f8a324d0b5dc/page/IDA%20script%20version%20updates
 */
(function() {
    var ghostFunctions = [
            'cmCreatePageviewTag',
            'cmCreateProductviewTag',
            'cmCreateShopAction5Tag',
            'cmDisplayShops',
            'cmCreateShopAction9Tag',
            'cmCreateOrderTag',
            'cmCreateRegistrationTag',
            'cmCreateElementTag',
            'cmCreateConversionEventTag',
            'cmCreateManualPageviewTag',
            'cmCreateManualLinkClickTag',
            'cmCreateManualImpressionTag',
            'cmCreateCustomTag',
            'cmSetupOther',
            'cmSetCurrencyCode',
            'cmDisplayShop9s',
            'cmDisplayShop5s'
        ],
        queue = [];
    
    (function init() {
        if (!isOriginSetLoaded()) {
            for (var i = 0; i < ghostFunctions.length; i++) {
                createGhostFunction(ghostFunctions[i]);
            }
            
            listenForOriginSet();
        }
    })();
    
    function isOriginSetLoaded() {
        for (var i = 0; i < ghostFunctions.length; i++) {
            if (typeof(window[ghostFunctions[i]]) !== 'function' || window[ghostFunctions[i]].isGhost) {
                return false;
            }
        }
        
        return true;
    }
    
    function createGhostFunction(ghostFunctionName) {
        window[ghostFunctionName] = function() {
            queue.push({
                functionName: ghostFunctionName,
                args: arguments
            });
        }
        
        window[ghostFunctionName].isGhost = true;
    }
    
    function listenForOriginSet() {
        setTimeout(function() {
            if (isOriginSetLoaded()) {
                delegateQueue();
            } else {
                listenForOriginSet();
            }
        }, 50);
    }
    
    function delegateQueue() {
        for (var i = 0; i < queue.length; i++) {
            window[queue[i].functionName].apply(this, queue[i].args);
        }
    }
})();

//----------------------ibmStats.event function for Tealium started---------------------------------------------//
function storeIBMStatsEvent(data,obj,linkIdentifier){
	var statsObjListString = JSON.stringify(obj).replace(/-_-/g,"---");
	var statsObjList = JSON.parse(statsObjListString);
	statsObjList.event_name = linkIdentifier;
	window.arrObjList.push(statsObjList,window.arrObjList.length);
	window.arrObjList.pop();
	window.onload = function(){
		if(typeof window.utag !== "undefined" && typeof window.utag.data !== "undefined"){
			modifySiteID = checkMarketingData();
			for(var i=0;i<window.arrObjList.length;i++){
					data = JSON.parse(JSON.stringify(window.arrObjList[i]));
					  data.event_name = window.arrObjList[i].event_name;
					  data.evPageLoadingTime = utag.data["page_loadingTime"];
					  data.evTriggerTime = utag.data["page_loadingTime"];
					  data.IbmerVal = utag.data["IBMER_value"];
					  data.evPageLocation = window.location.href.replace(/-_-/g,"---");
					  data.categoryVal = utag.data["category_id"];
					  data.evClientID = modifySiteID;
					  //for generating product view tag
					  if(window.arrObjList[i].event_name == "ibmStatsEvent_product" && typeof window.pageViewAttributes !== "undefined"){
							var x = window.pageViewAttributes.split("-_-");
							for(var k=0; k<= x.length; k++){
								var pr_y = "productTag_a"+k;
								if(x[k] !== "undefined" || x[k] !== "")	data[pr_y] = x[k];
							}
							if(typeof window.arrObjList[i].serviceType !== "undefined") data["productTag_serviceType"] = window.arrObjList[i].serviceType;
						}
					utag.link(data);
				}
		}
	}
}

function createUtagLinkObject(obj){
	var pageLocation = window.location.href.replace(/-_-/g,"---"),
		eventTriggerTime = new Date().getTime(),
		linkIdentifier = "ibmStatsEvent_element",
		data = new Object();
	  
	if(obj.ibmConversion && obj.ibmConversion == "true"){
		if (!obj.point && obj.convtype && obj.convtype == "1") obj.point = '10';
		if (!obj.point && obj.convtype && obj.convtype == "2") obj.point = '20';
		linkIdentifier = "ibmStatsEvent_conversion";
	}else if(obj.ibmProductTag && obj.ibmProductTag == "true"){
		linkIdentifier = "ibmStatsEvent_product";
	}
	if(!obj.ibmConversion && !obj.ibmProductTag) {
		obj.ibmEvActionAttribute = obj.ibmEvAction;
		if(obj.ibmEvAction && typeof obj.ibmEvAction !== "undefined" && obj.ibmEvAction.length > 50){
			obj.ibmEvAction = obj.ibmEvAction.substring(0,22) + "..." + obj.ibmEvAction.substring(obj.ibmEvAction.length - 25, obj.ibmEvAction.length);
		}
	}
	if(typeof utag !== "undefined" && linkIdentifier !== "ibmStatsEvent_product"){
		modifySiteID = checkMarketingData();
		if(typeof window.ibm_global_data !== "undefined" && typeof ibm_global_data["Site ID"] != "undefined" && 
				typeof obj.ibmEV !== "undefined" && (obj.ibmEV.toLowerCase().indexOf("rich_media_service") !== -1 || obj.ibmEV.toLowerCase().indexOf("video player") !== -1)){
			obj.ibmEV = "VIDEO - " + modifySiteID.substring(modifySiteID.indexOf('|')+1,modifySiteID.length);
			if(obj.ibmEvAction.toLowerCase() == "start" || obj.ibmEvAction.toLowerCase() == "played"){
				obj.ibmEvName = obj.ibmEvName + " - Play";
				obj.convtype = 1;
				trackingConversionEvent(linkIdentifier,obj);
			}else if (obj.ibmEvAction.toLowerCase() == "finish" || obj.ibmEvAction.toLowerCase() == "ended"){
				obj.ibmEvName = obj.ibmEvName + " - End";
				obj.convtype = 2;
				trackingConversionEvent(linkIdentifier,obj);
			}
		}
		var statsObjListString = JSON.stringify(obj).replace(/-_-/g,"---");
		data = JSON.parse(statsObjListString);
		  data.event_name = linkIdentifier;
		  data.evPageLoadingTime = utag.data["page_loadingTime"];
		  data.IbmerVal = utag.data["IBMER_value"];
		  data.evPageLocation = pageLocation;
		  data.evTriggerTime = eventTriggerTime;
		  data.categoryVal = utag.data["category_id"];
		  data.evClientID = modifySiteID;
		utag.link(data);
		}else{
			storeIBMStatsEvent(data,obj,linkIdentifier);
		}
}

function trackingConversionEvent(utagLinkIdentifier,obj){
	utagLinkIdentifier = "ibmStatsEvent_conversion";
	utag.link({
		  event_name : utagLinkIdentifier,
		  ibmEV : obj.ibmEV,
		  ibmEvAction : obj.ibmEvName,
		  convtype : obj.convtype,
		  evClientID : modifySiteID
	});
}

function checkMarketingData(){
	var modify_siteId = window.utag.data.concat_clientid;
	var x = window.utag.data.concat_clientid.substring(0,window.utag.data.concat_clientid.indexOf('|'));
	if(typeof window.ibm_global_data !== "undefined" && typeof ibm_global_data["Site ID"] != "undefined"){
		if(utag.data['IBMER_value'] == "1"){
			modify_siteId = x + "|" + "New_IBMER";
		}else if (window.ibm_global_data["Site ID"] !== undefined){
			modify_siteId = x + "|" + window.ibm_global_data["Site ID"];
		}
	}
	return modify_siteId;
}
//----------------------ibmStats.event function for Tealium ended---------------------------------------------//

var v16elu = {
	
	NTPT_DOWNLOADTYPES : "bqy,doc,dot,exe,flv,jpg,png,mov,mp3,pdf,pps,ppt,rss,sh,swf,tar,txt,wmv,xls,xml,zip,avi,eps,gif,lwp,mas,mp4,pot,prz,rtf,wav,wma,123,odt,ott,sxw,stw,docx,odp,otp,sxi,sti,pptx,ods,ots,sxc,stc,xlsx",
	NTPT_DOMAINLIST : ".ibm.co,.ibm.com,.lotuslive.com,.cognos.com,.webdialogs.com,.servicemanagementcenter.com,.xtify.com,.ibmcloud.com,.ibmdw.net,.bluemix.net,.smartercitiescloud.com",
	evhndlr : true,
	domainBlacklist : ".ibm.com,.mitre.org,.learnquest.com",
	   
	/*------------creates Coremetrics element tag(conversion of Unica event to Coremetrics)---------------------*/
	/*create_cmElement : function(obj){
		if(obj.ibmProductTag && obj.ibmProductTag == "true"){
			window.onload = function(){
				if (typeof (window.pageViewAttributes) != "undefined") var productAttr = window.pageViewAttributes.split("-_-", 21).join("-_-");
				if(typeof v16elu.siteID !== "undefined" && v16elu.siteID.toLowerCase() == "ecom" && typeof obj.serviceType != "undefined") productAttr += "-_--_--_--_--_--_--_--_--_--_-" + obj.serviceType;
				if (typeof cmCreateProductviewTag !== 'undefined') cmCreateProductviewTag(obj.proID,obj.proName,obj.proCategory,productAttr,obj.cm_vc);
			}
		}
	},*/
	
	//-----------------------------function call on completely loading page--------------------------------//
    onPageLoad : function(){
		if(window.utag && window.utag.sender) v16elu.storeTealiumPageviewData();
		if(typeof window.demandBase !== "undefined"){
			window.demandBase.event_name = "demandbaseElement";
			window.demandBase.ibmEV = "Demandbase";
			window.demandBase.ibmEvAction = "CompanyData";
			window.demandBase.ibmEvAttr = "Demandbase";
			window.demandBase.evPageLoadingTime = utag.data["page_loadingTime"];
			window.demandBase.evTriggerTime = utag.data["page_loadingTime"];
			window.demandBase.IbmerVal = utag.data["IBMER_value"];
			window.demandBase.evPageLocation = window.location.href.replace(/-_-/g,"---");
			utag.link(window.demandBase);
		}
	},
	
	//------------------------------function call to store all page view attributes in Tealium-------------//
	storeTealiumPageviewData : function(){
		var arr = new Array();
		window.pageViewAttributes = "";
		var x = JSON.stringify(window.utag.sender).split(/[}]/);
		for (var i=0;i<x.length;i++){
			var firstPart = x[i].split('{')[0],
				lastPart = x[i].split('{')[1];
			if (firstPart.indexOf("map") !== -1 && typeof lastPart !== "undefined") {
				var arr1 = lastPart.split(',');
				for (var j=0;j<arr1.length;j++){
					if (typeof arr1[j].split(':')[1] !== "undefined" && arr1[j].split(':')[1].indexOf('PageviewTag_pv_a') !== -1){
						var a = arr1[j].split(':')[0].replace(/[""]/g,''),
							k = arr1[j].split(':')[1].substring(17,arr1[j].split(':')[1].length-1);
						if (typeof utag.data[a] !== "undefined" && (arr[k] == "" || arr[k] == undefined)) arr[k] = utag.data[a];
						else if (typeof utag.data[a] !== "undefined" && a.indexOf('meta.') !== -1) arr[k] = utag.data[a];//to prioritize the meta tag values over DDO
					}
				}
			}
		}
		for(var i=1;i<=arr.length;i++){
			window.pageViewAttributes += arr[i] + "-_-";
		}
	},
	
    init : function () {
        var _this = this;
        window.loadingTime = new Date().getTime();
        
        //set cmTagQueue
		if (typeof(window.cmTagQueue) == 'undefined')
			window.cmTagQueue = [];
		
		//cookie migration from IBM to non IBM pages
		if(typeof (document.domain) !== 'undefined' && document.domain.indexOf('ibm.com') !== -1){
			window.cmTagQueue.push(['cmSetupCookieMigration', true, true, null, this.domainBlacklist]);
		}
		
		//cookie migration code for all non IBM pages
		if(typeof (document.domain) !== 'undefined' && document.domain.indexOf('ibm.com') == -1){
			window.cmTagQueue.push(['cmSetupCookieMigration', true, true, this.NTPT_DOMAINLIST]);
		}
		 //getting the value of IBMer for non ibm.com
        if(typeof (document.domain) !== 'undefined' && document.domain.indexOf('ibm.com') == -1){
    		requestServerCall = function (url) {
	    		var s = document.createElement('script');
	            	s.type = 'text/javascript';
	            	s.src = url;
	            document.getElementsByTagName("head")[0].appendChild(s);
	    	 },
	    	 IBMISE_BOOTSTRAP = function (data) {
	    	    	if(data.IBMer)	window.NTPT_IBMer = data.IBMer;
	    	    	if(data.IBMIXS)	window.IBMIXS = data.IBMIXS;//IBMISP cookie value for non ibm.com
	    	 }
	    	 requestServerCall("//www.ibm.com/gateway/gp/getProfile/?cb=260:IBMISE_BOOTSTRAP&cc=us&lc=en");   
    	}
        
		//----------------------------- TEALIUM IMPLEMENTATION - START --------------------------------//
			(function(a,b,c,d) {
				a = '//tags.tiqcdn.com/utag/ibm/main/prod/utag.js';
				b = document;
				c = 'script';
				d = b.createElement(c);
				d.src = a;
				d.type = 'text/java' + c;
				d.async = true;
				a = b.getElementsByTagName(c)[0];
				a.parentNode.insertBefore(d,a);
				d.onload = function (){
					if(typeof window.utag !== "undefined" && typeof window.utag.data !== "undefined"){
						v16elu.siteID = window.utag.data["siteID_value"];
						if(v16elu.siteID.toLowerCase() == "ecom"){
							window.cmTagQueue.push(['cmSetupNormalization', 'krypto-_-krypto']);	
						}
						
						if(v16elu.siteID.toLowerCase() == "p4sc") {
							window.cmTagQueue.push(['cmSetupOther', {"cm_JSFEAMasterIDSessionCookie" : true, "cm_FormPageID" : true}]);
						} else {
							window.cmTagQueue.push(['cmSetupOther', {"cm_JSFEAMasterIDSessionCookie" : true}]);
						}
					}
				}
			})();
		//---------------------------------- TEALIUM IMPLEMENTATION - END -----------------------------//
       
        if (window.addEventListener) {
	      	  window.addEventListener('load', v16elu.onPageLoad, false);
	      }
	      else if (window.attachEvent) {
	      	  window.attachEvent('onload', v16elu.onPageLoad );
	      }
    }
};

var ibmStats = ibmStats || {};
var modifySiteID = "";
window.arrObjList = new Array();
ibmStats.event = function (obj) {
    //creates Coremetrics element tag(conversion of Unica event to Coremetrics)
    createUtagLinkObject(obj);
    //v16elu.create_cmElement(obj);//for product view tag
};

//---------------------------------- Ajax function to bind page view tag -----------------------------//
bindPageViewWithAnalytics = function(){
	if(typeof window.utag !== "undefined") utag.view(utag.data);
}

if (navigator.platform.search('AIX') < 0) {
    if (typeof(window.ida_eluminate_enabled) !=='undefined' || typeof(window.tealium_enabled) !=='undefined') {
        // we search if this variable is set on false
        if (!window.ida_eluminate_enabled || !window.tealium_enabled) {/*do nothing*/}
        else v16elu.init();
    } else {
        // we are enebled for all pages
        v16elu.init();
    }
}