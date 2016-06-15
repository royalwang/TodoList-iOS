/*!
 * Name: ibm.com production file
 * Release: 1.0.0
 * Built: 2015-06-05 11:27:53 AM EDT
 * Owner: Michael Santelia
 * Copyright (c) 2015 IBM Corporation
 * Description: Official file for production use
 */
var tcPassingBindAllIwmLinks=(function(){var a=typeof dojo!=="undefined"?"dojo":(typeof jQuery!=="undefined"?"jquery":"");if(a==="dojo"){dojo.ready(function(){dojo.query("#ibm-content-main a").forEach(function(c){var b=c.href;if(b.indexOf("www.ibm.com/services/forms/")>-1||b.indexOf("www14.software.ibm.com/webapp/iwm/")>-1||b.indexOf(".ibm.com/marketing/iwm/iwm")>-1||b.indexOf(".ibm.com/marketing/iwm/dre")>-1||b.indexOf("/events/wwe/")>-1){if(dojo.query(c).closest(".ibm-live-assistance-list").length===0){dojo.query(c).attr("onclick","goPage(this);return false;")}}})})}else{if(a==="jquery"){jQuery(function(){jQuery("#ibm-content-main a").each(function(){var c=jQuery(this),b=this.href;if(b.indexOf("www.ibm.com/services/forms/")>-1||b.indexOf("www14.software.ibm.com/webapp/iwm/")>-1||b.indexOf(".ibm.com/marketing/iwm/iwm")>-1||b.indexOf(".ibm.com/marketing/iwm/dre")>-1||b.indexOf("/events/wwe/")>-1){if(c.closest(".ibm-live-assistance-list").length===0){c.attr("onclick","goPage(this);return false;")}}})})}}return{status:"Loaded"}})();