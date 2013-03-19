/**
 * Grid theme for Highcharts JS
 * @author Torstein Hønsi
 */

Highcharts.theme = {
	colors: ['#9e2f50', '#4781aa', '#eda45e', '#a6a471', '#736e7e', '#94826b', '#936971', '#c36256', '#8ab5cd'],
	chart: {
		backgroundColor: '#FFF9F1',
		borderWidth: 0,
		plotBackgroundColor: '#FFF9F1',
		plotShadow: false,
		plotBorderWidth: 0,
		spacingRight: 20,
		spacingBottom:50
		},
		
	title: {
			align : 'left',
			y: 5,
			style: { 
			color: '#43423e',
			font: 'bold 14px BentonSans, Arial, Helvetica, sans-serif'
			}
	},
	subtitle: {
		align: 'left',
		y: 20,
		style: { 
			color: '#43423e',
			font: '12px BentonSans, Arial, Helvetica, sans-serif'
		}
	},
	xAxis: {
		lineColor: '#43423e',
        lineWidth: 2,
		tickColor: '#43423e',
        tickWidth: 1,
		tickPosition: 'outside',
		labels: {
         style: {
			color: '#43423e',
			font: '12px BentonSans, Arial, Helvetica, sans-serif',
			}
        }
	},
	yAxis: {
		gridLineColor: '#999',
		labels: {
		 style: {
			color: '#43423e',
			font: '12px BentonSans, Arial, Helvetica, sans-serif'
			}
		},
		title: {
			text: null
		}
	},
	plotOptions: {
		column: {
			borderWidth: 1,
			borderColor: '#000',
			shadow: false
		},	
		bar: {
			borderWidth: 1,
			borderColor: '#000',
			shadow: false
		},
		line: {
			shadow: false,
			lineWidth:3,
			series: {
				animation: {
					  duration: 5000
				},
				shadow:false,
				marker: {
					radius: 1
				}
			 }
		},
		pie: {
			lineWidth:1,
			slicedOffset:15,
			shadow:false,
			showInLegend:true,
			center: ["50%", "45%"],
			size: "85%",
			series: {
         	   showCheckbox: true,
        	},
			dataLabels: {
				enabled: false,
				color: '#43423e',		
				softConnector: false,					
				connectorColor: '#43423e',
				style: {
					font: '12px BentonSans, Arial, Helvetica, sans-serif',
				},	
			}
		}
	},
	legend: {
		layout: 'horizontal',
		backgroundColor: '#fff9f1',
		align: 'left',
		verticalAlign:'bottom',
		floating: true,
		shadow: false,
		borderRadius: 0,
		borderWidth:0,
		x:-10,
		y:-420,
		width:773,
		itemWidth:200,
		itemStyle: {	
			font: '12px BentonSans, Arial, Helvetica, sans-serif',
			color: '#43423e'
		},
		itemHiddenStyle: {
			color: 'gray'
		},
		
		itemHoverStyle: {
			color: '#4781aa'
		}
		},
	labels: {
		style: {
			color: '#43423e'
		}
	},
	 tooltip: {
		 style: {
			color: '#43423e',
			font: '12px BentonSans, Arial, Helvetica, sans-serif'
		},
			borderRadius: 0,
			shadow:false
    }
};

// Apply the theme
var highchartsOptions = Highcharts.setOptions(Highcharts.theme);
	
