function appendDownloadButton() {
	var usage = "usage";
	var active = false;
	var globalCSVDownloadData;
	//Elements
	var dwn_subContainer;
	var download_container;
	var download_deactivated;
	var download_btn;
	var drop_arrow;

	require(['dojo/topic'], function(topic) {
		topic.subscribe('cloudOE/detailedUsageData', function(data) {
			globalCSVDownloadData = data;
			active = checkData(globalCSVDownloadData);
			changeButtonState();
		});
	});
	
	function downloadFullReportJSON() {
		var tmpData = JSON.stringify(globalCSVDownloadData, null,2);
		download('json', tmpData);
	}
	
	function checkData(data) {
		if(Object.keys(data).length === 0 || Object.keys(data).length === 20) { return false; }
		else if(typeof(data.organizations) === "undefined" || data.organizations === null) { return false; }
		else if(typeof(data.organizations[0].id) === "undefined" || data.organizations[0].id === null) { return false; }
		else return true;
	}

	function downloadFullReportCSV() {
		var data = globalCSVDownloadData;
		var newLine = '\r\n';

		var CSV = 'region,org.name,space.name,app.buildpack,app.name,service.name,service.instance.name,service.instance.plan_id,usage.unit.rate,usage.quantity';//Header Table

		if(document.getElementById('accountTab').classList.contains('selected')) {
			 CSV += ',cost';
		}

		CSV += newLine;

		var orgs = data.organizations;

		if (orgs === undefined || orgs === null) {
			error('Wrong data structure, Can not convert: organizations is undefined.');
			return;
		}

		for(var i  = 0; i < orgs.length; i++) {
			var region = orgs[i].region;
			var orgId = orgs[i].id;
			var orgName = orgs[i].name;

			var bill_usage = [];
			//Check if public or not
			if(typeof(orgs[i].non_billable_usage) !== "undefined" && orgs[i].non_billable_usage !== null) bill_usage.push(orgs[i].non_billable_usage.spaces);
			if(typeof(orgs[i].billable_usage) !== "undefined" && orgs[i].billable_usage !== null) bill_usage.push(orgs[i].billable_usage.spaces);

			for(var b = 0; b < bill_usage.length; b++) {
			
			var orgSpaces = bill_usage[b];
			if(orgSpaces === undefined || orgSpaces === null) {
				error('Wrong data structure, Can not convert: spaces is undefined.');
				return;
			}
				
				for(var j = 0; j < orgSpaces.length; j++) {
					var spaceId = orgSpaces[j].id;
					var spaceName = orgSpaces[j].name;
					var appBuildpack = '';
					var appId = '';
					var appName = '';
					var serviceId = '';
					var serviceName = '';
					var serviceInstanceId = '';
					var serviceInstanceName = '';
					var serviceInstancePlanId = '';
					var usageUnit = '';
					var usageQuantity = '';
					var usageUnitId = '';
					var cost = '';

					var orgSpacesApps = orgSpaces[j].applications;

					if(orgSpacesApps === undefined || orgSpacesApps === null) {
						error('Wrong data structure, Can not convert: applications is undefined.');
						return;
					}

					for(var k = 0; k < orgSpacesApps.length; k++) {
						appId = orgSpacesApps[k].id;
						appName = orgSpacesApps[k].name;

						if(orgSpacesApps[k].usage[0] === undefined || orgSpacesApps[k].usage[0] === null) {
							error('Wrong data structure, Can not convert: usage is undefined.');
							return;
						}
						usageUnit = orgSpacesApps[k].usage[0].unit;
						usageUnitId = orgSpacesApps[k].usage[0].unitId;
						usageQuantity = orgSpacesApps[k].usage[0].quantity;
						cost = orgSpacesApps[k].usage[0].cost;
						appBuildpack = orgSpacesApps[k].usage[0].buildpack;


						CSV += region +  ',' + orgName + ',' + spaceName + ',' + appBuildpack + ',' + appName + ',' + serviceName +  ',' + serviceInstanceName + ',' + serviceInstancePlanId + ',' + usageUnitId + ',' + usageQuantity;
						if(document.getElementById('accountTab').classList.contains('selected')) {
							CSV	+= ',' + cost;
						}
						CSV += newLine;
					}

					appBuildpack = '';
					appName = '';
					appId = '';

					var orgSpacesServices = orgSpaces[j].services;

					if(orgSpacesServices === undefined || orgSpacesServices === null) {
						error('Wrong data structure, Can not convert: services is undefined.');
						return;
					}

					for(var k = 0; k < orgSpacesServices.length; k++) {
						 serviceId = orgSpacesServices[k].id;
						 serviceName = orgSpacesServices[k].name;

						var servicesInst = orgSpacesServices[k].instances;

						if(servicesInst === undefined || servicesInst === null) {
							error('Wrong data structure, Can not convert: instances is undefined.');
							return;
						}

						for(var l = 0; l < servicesInst.length; l++) {
							serviceInstanceId = servicesInst[l].id;
							serviceInstanceName = servicesInst[l].name;
							serviceInstanceName = serviceInstanceName.replace(/,/g, '/');
							serviceInstancePlanId = servicesInst[l].plan_id;

							var instUsage = servicesInst[l].usage;

							if(instUsage === undefined || instUsage === null) {
								error('Wrong data structure, Can not convert: service usage is undefined.');
								return;
							}

							for(var m = 0; m < instUsage.length; m++) {
								usageUnit = instUsage[m].unit;
								usageQuantity = instUsage[m].quantity;
								if(typeof(usageQuantity.sum) !== "undefined" && usageQuantity.sum !== null) usageQuantity = usageQuantity.sum;
								//appId = instUsage[m].applicationId;
								usageUnitId = instUsage[m].unitId;
								cost = instUsage[m].cost;

								CSV += region +  ',' + orgName + ',' + spaceName + ',' + appBuildpack + ',' + appName + ',' + serviceName +  ',' + serviceInstanceName + ',' + serviceInstancePlanId + ',' + usageUnitId + ',' + usageQuantity;
								if(document.getElementById('accountTab').classList.contains('selected')) {
									CSV	+= ',' + cost;
								}
								CSV += newLine;
							}	
						}
					}
				}
			}
		}
		download('csv', CSV);
	}

	function download(type, data) {
		if(type != 'csv' && type != 'json') {
			error('Invalid File Type');
			return;
		}
		if(data === undefined || data === null) {
			error('Bad Data Type');
			return;
		}

		var orgFName = document.querySelectorAll('.outer')[1].innerHTML;

		orgFName = orgFName.replace(' ', '_');

		var fileName = 'OpsConsole_Metering-'+orgFName; //TODO Add date

		var uri = 'data:text/' + type + ';charset=utf-8,' + encodeURIComponent(data);

		var download = document.createElement('a');    
		download.href = uri;

		download.style = 'visibility:hidden';
		download.download = fileName + '.' + type;

		document.body.appendChild(download);
		download.click();
		document.body.removeChild(download);
	}

	function error(errorMessage) {
		require(['cloudOE/RuntimeManager'], function(RuntimeManager) {
    	RuntimeManager.showErrorMessage(errorMessage + ' Try again later. See the Troubleshooting topics in the IBM Bluemix Documentation to check service status, review troubleshooting information, or for information about getting help.');
		});
	}

	function init() {
	
		download_container = document.createElement('div');
		download_container.setAttribute('class', 'download-container');
		download_container.style.float = 'right';
		download_container.style.position = 'absolute';
		download_container.style.right = "74px";
		download_container.style.top = "170px";


		download_btn = document.createElement('button');
		download_btn.setAttribute('class', 'dwn--btn');
		download_btn.innerHTML = 'Export Data';
		download_container.appendChild(download_btn);
		
		download_deactivated = document.createElement('button');
		download_deactivated.setAttribute('class', 'dwn--btn-deactivated');
		download_deactivated.innerHTML = 'Export Data';
		download_container.appendChild(download_deactivated);

		drop_arrow = document.createElement('div');

		dwn_subContainer = document.createElement('div');
		dwn_subContainer.setAttribute('class', 'dwn_subContainer');

		download_container.appendChild(drop_arrow);

		var download_subBtnCSV = document.createElement('button');
		download_subBtnCSV.innerHTML = 'CSV';
		download_subBtnCSV.setAttribute('class', 'dwn--btn dwn--subbtn');

		var download_subBtnJSON = document.createElement('button');
		download_subBtnJSON.innerHTML = 'JSON';
		download_subBtnJSON.setAttribute('class', 'dwn--btn dwn--subbtn');

		dwn_subContainer.appendChild(download_subBtnCSV);
		dwn_subContainer.appendChild(download_subBtnJSON);

		download_container.appendChild(dwn_subContainer);

		document.getElementById('dedicatedOrgMgmtSection').appendChild(download_container);
		console.log("Appended download button to DOM");
		
		buildStyle();
		changeButtonState();
		
	}
	
	function changeButtonState() {
		if(active) {
			download_btn.style.display = 'inline-block';
			download_deactivated.style.display = 'none';
		}
		else {
			download_deactivated.style.display = 'inline-block';
			download_btn.style.display = 'none';
		}
	}
	
	function buildStyle() {
		var dwnBtn = document.getElementsByClassName('dwn--btn');
		var subDwnBtn = document.getElementsByClassName('dwn--subbtn');
		dwn_subContainer.style.cssText = 'display: none; ';

		//Drop Arrow
		drop_arrow.style.cssText = 'width: 0; height: 0; border-left: 4px solid transparent; border-right: 4px solid transparent; border-top: 4px solid #FFF; position: absolute; top: 18px; right: 10px;';

		//General Button Styling
		for(var i = 0; i < dwnBtn.length; i++) {
			dwnBtn[i].style.cssText = 'background-color: #00B299; cursor: pointer; display: inline-block; padding-right: 25px; height: 40px; border-width: 0; text-align: left; text-decoration: none; color: white; text-transform: uppercase; font-size: 12px; font-weight: 500; transition: all .3s ease-in-out; padding-left: 15px; border-radius: 0 !important;';
			dwnBtn[i].addEventListener('mouseenter', function () {
				dwn_subContainer.style.cssText = 'position: absoulute; display: block; border: 1px solid #AAA; box-shadow: 0px 0px 1px 1px rgba(0, 0, 0, 0.15); width: 100%;';
			}, false);
			dwnBtn[i].addEventListener('mouseleave', function () {
				dwn_subContainer.style.cssText = 'display: none;';
			}, false);
		}
		
		//Deactivated Button
		download_deactivated.style.cssText = 'background-color: #E3E4E6; cursor: default; display: inline-block; padding-right: 25px; height: 40px; border-width: 0; text-align: left; text-decoration: none; color: white; text-transform: uppercase; font-size: 12px; font-weight: 500; transition: all .3s ease-in-out; padding-left: 15px; border-radius: 0 !important;';

		//SubButton Styling
		for(var j = 0; j < subDwnBtn.length; j++) {
			subDwnBtn[j].style.cssText += 'display: block; background-color: #FFF; color: #5A5A5A; width: 100%;';
			subDwnBtn[j].addEventListener('mouseenter', function() {
				this.style.backgroundColor = "#F2F5F7";
				this.style.color = "#00B299";
			}, false);
			subDwnBtn[j].addEventListener('mouseleave', function() {
				this.style.backgroundColor = "#FFF";
				this.style.color = "#5A5A5A";
			}, false);
		}
		subDwnBtn[0].style.cssText += 'border-bottom: 1px solid rgba(0,0,0,.1);';

		subDwnBtn[0].addEventListener('click', downloadFullReportCSV, false);
		subDwnBtn[1].addEventListener('click', downloadFullReportJSON, false);

	}

	var isLoaded = setInterval(function(){
										var node = document.getElementById('dedicatedOrgMgmtSection');
										if(typeof(node) !== 'undefined' && node !== null){
											clearInterval(isLoaded);
											init();
										}
									}, 100);

}
window.onload = appendDownloadButton;
