// FT Interactive Object initialization
var FT = {};
FT.interactive = {};
FT.interactive.dataset; //FT.interactive.lex;
FT.interactive.fcf;
FT.interactive.data_0 = [];
FT.interactive.data_1 = [];
FT.interactive.data_2 = [];
FT.interactive.data_3 = [];
FT.interactive.dataPointer = 0;
FT.interactive.ddFlag = false;
FT.interactive.costEquity;
FT.interactive.terminalVal;
var mouseClickHandler; // add data source URL here
FT.interactive.dataSource = 'http://interactive.ftdata.co.uk/data/ft.interactive.data_v2.php?_cf=93&id=167';
var optionsBase = {
	colors: ['#bab1a5', '#4781aa'],
	chart: {
		renderTo: '',
		defaultSeriesType: 'line',
		y: 10
	},
	tooltip: {
		formatter: function() {
			return this.x + ': ' + "$" + this.y + "bn";
		}
	},
	title: {
		margin: 20,
		text: ''
	},
	subtitle: {
		text: '',
		y: 50,
		x: 0
	},
	credits: {
		enabled: false
	},
	xAxis: {
		categories: [],
		tickPosition: 'outside',
		labels: {
			step: 2,
			y: 15,
			style: {
				font: '11px Arial, Helvetica, sans-serif'
			}
		}
	},
	yAxis: {
		labels: {
			align: 'right',
			x: 0,
			y: -3
		},
		title: {
			text: ''
		}
	},
	plotOptions: {
		series: {
			pointPadding: -0.128,
			groupPadding: 0.25,
			shadow: false,
			marker: {
				radius: 2
			}
		}
	},
	legend: {
		enabled: false
	},
	series: [],
	exporting: {
		enabled: false
	}
};
FT.interactive.options_0 = optionsBase;
FT.interactive.options_0.chart.renderTo = 'container_0';
FT.interactive.options_1 = optionsBase;
FT.interactive.options_1.chart.renderTo = 'container_1';
FT.interactive.options_2 = optionsBase;
FT.interactive.options_2.chart.renderTo = 'container_2';
FT.interactive.options_3 = optionsBase;
FT.interactive.options_3.chart.renderTo = 'container_3';
