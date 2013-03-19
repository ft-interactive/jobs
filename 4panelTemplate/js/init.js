// Avoid `console` errors in browsers that lack a console.
(function() {
	 var method;
	 var noop = function noop() {};
	 var methods = [
		  'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
		  'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
		  'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
		  'timeStamp', 'trace', 'warn'
	 ];
	 var length = methods.length;
	 var console = (window.console = window.console || {});

	 while (length--) {
		  method = methods[length];

		  // Only stub undefined methods.
		  if (!console[method]) {
				console[method] = noop;
		  }
	 }
}());

var FT = FT || {};
FT.Interactive = {
	/*
		built in functions first
	*/
	initGraphic: function(f){
		$("#sourcesCredits").append(f.source).append("<br/> " + f.byline);
		$("#source").append(f.sourceLink);
		$('#preLoader').css("visibility", "hidden");
		$('.footer').click(function () {
	   		$('#sourcesCredits').slideToggle('fast');
		});
		if (Modernizr.touch){
			$('#chartInstruction').append("Drag slider to see change over time and tap on states for more information");
		} else {
			$('#chartInstruction').append("Drag slider to see change over time and mouse over states for more information");
		}
		return;
	},
	checksvg: function(){
		var f = false;
		if(Modernizr.svg){ f=true;}
		return f;
	},
	/*
		expecting jQuery and Modernizr
	*/
	yqlUrl: function(url){
		/* function to generate the yql url to convert xml to jsonp */
		return 'http://query.yahooapis.com/v1/public/yql?q=' + encodeURIComponent("select * from xml where url='" + url + "'") + '&format=json&diagnostics=true&callback=?';
	},
	
	options_0: {
		chart: {
			renderTo: 'chartHolder',
			y:10
		},
		title: {
			margin: 70,
			align:'left',
			text: 'Iraq oil production'
		},
		subtitle: {
			text: ''
		},
		credits: {
			enabled:false
		},
		xAxis: {
			categories: [],
			tickPosition: 'outside' ,
			startOnTick: true,
			endOnTick: true,
			labels: {
				y: 18,
				style: {
					font: '12px BentonSans, Arial, Helvetica, sans-serif'
				}
			}
		},
		yAxis:[ {
			labels: {
				align: 'right',
				x: 5,
				y: -3
			},
			
		},{
			labels: {
				align: 'left',
				x: 5,
				y: -3
			},
			
			opposite: true
		}],
		plotOptions: {
			 series: {
				animation: {
					  duration: 4000
				},
				shadow:false,
				marker: {
					radius: 1
				}
			 }
		},
		
							
		series: [],
		exporting: {
			enabled: false
		}
	
	},
	
	/*
		built in properties
		dataSource => pointer to the data 
	*/
	dataSource: 'http://interactive.ftdata.co.uk/data/ft.interactive.data_v2.php?_cf=271&id=331',
	dataset: {},
};



