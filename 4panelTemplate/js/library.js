// library functions
function initGraphic(f){
	$("#sourcesCredits")
		.append(f.source );
	$("#sourcesCredits")
	.append("<br/> " + f.byline);
	$("#source")
	.append(f.sourceLink);
};

function yqlUrl(url){
	var rVal = 'http://query.yahooapis.com/v1/public/yql?q=';
	rVal += encodeURIComponent("select * from xml where url='" + url + "'");
	rVal += '&format=json&diagnostics=true&callback=?';
	return rVal;
};

$.browser.chrome = $.browser.webkit && !!window.chrome;
$.browser.safari = $.browser.webkit && !window.chrome;