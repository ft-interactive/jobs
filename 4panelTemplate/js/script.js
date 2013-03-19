// JavaScript Document
$(document).ready(function() {

/***********variables************/
	var FTi = FT.Interactive;
	var nID;
	var xPos=[0,0,0,0];
	var yPos=[0,141,282,423];
	FTi.dataPointer=0;


	$.getJSON(FTi.yqlUrl(FTi.dataSource), function(ds) {}).success(setData);
	function setData(ds) {
		console.log(FTi.dataSource);
		FTi.dataset = ds.query.results.dataset;
		FTi.initGraphic(ds.query.results.dataset.pagefurniture);
		loadNav();
	};
	
	function loadNav(){
		
		var mouseOverHandler = function() {
			nID = this.id.split('_')[1];
			$(this).css({ background: "url(_media/" + FTi.dataset.section[nID].image + ") #e9decf no-repeat", });
			$(this).removeClass("up");
			$(this).addClass("selected");
		}
		
		var mouseOutHandler = function() {
			nID = Number(this.id.split('_')[1]);
			$(this).css({ background: "url(_media/" + FTi.dataset.section[nID].image + ") #F6E9D8 no-repeat", });
			$(this).removeClass("selected");
			$(this).addClass("up");
		}
		
		var mouseClickHandler = function() {
			nID = this.id.split('_')[1];
			var nPos = $(this).position();
			$("#panelMarker").css({ top: nPos.top + ($(this).height()/2)-8 });
			$("#panelSlide").css({ left: -972 });
			$("#panelSlide").stop().animate({ left:166 },700,"easeOutExpo");
			for(i=0; i<FTi.dataset.section.length; i++){
				$("#navItem_" + i).css({ background: "url(_media/" + FTi.dataset.section[i].image + ") #F6E9D8 no-repeat", cursor:"pointer" });
				$("#navItem_" + i).removeClass("selected");
				$("#navItem_" + i).addClass("up");
				$("#navItem_" + i).unbind();
				$("#navItem_" + i).bind("mouseover", mouseOverHandler);
				$("#navItem_" + i).bind("mouseout", mouseOutHandler);
				$("#navItem_" + i).bind("click", mouseClickHandler);
			}

			$(this).css({
				background: "url(_media/" + FTi.dataset.section[nID].image + ") #e9decf no-repeat",
				cursor:"default"
			});
			$(this).removeClass("up");
			$(this).addClass("selected");
			$(this).unbind();
			
			for(var i=0; i<FTi.dataset.section.length; i++){
				i == nID? $("#panel_" + i).show(): $("#panel_" + i).hide();
			}
		}
		
		for(i=0; i<FTi.dataset.section.length; i++){
			$("#navHolder").append('<div class ="navItem up" id="navItem_' + i + '"><div class="navText">' + FTi.dataset.section[i].name + '</div></div>');
			$("#navItem_" + i).css({
				background: "url(_media/" + FTi.dataset.section[i].image + ") #F6E9D8 no-repeat",
				position: "absolute",
				left: -160 + "px",
				top: yPos[i] +"px"
			});
			
			if(i==FTi.dataset.section.length-1){
				$("#navItem_" + i).css({
				"border-bottom" : "none"
				});
			}
			
			$("#navItem_" + i).bind("mouseover", mouseOverHandler);
			$("#navItem_" + i).bind("mouseout", mouseOutHandler);
			$("#navItem_" + i).bind("click", mouseClickHandler);
			
			if(i==0){
				$("#navItem_" + i).removeClass("up");
				$("#navItem_" + i).addClass("selected");
				$("#navItem_" + i).css({
					background: "url(_media/" + FTi.dataset.section[i].image + ") #e9decf no-repeat",
					cursor:"default"
				});
				$("#navItem_" + i).unbind();
			};
		};
		
		FTi.dataPointer = 0;
		loadIcons();
	};
	
	function loadIcons(){
		var k=0
		if(k<4){
			setInterval(function(){
				
				$("#navItem_" + k).stop().animate({
						left: xPos[k],
						top: yPos[k]
					},
					700,'easeOutExpo');
					k++
				}
				,100)	
		}
		
		setTimeout(function(){
			$("#panelSlide").css({
				left: -972
			});
			
			$("#panelSlide").stop().animate({
				left:166
			},700,"easeOutExpo");
			
			// function here for process link => loadMaps()
		},1000);
	};
	
	function loadMaps(){
		if(FTi.checksvg){
			// load maps here
		} else {
			// alternative image
		}
	};
	
	
});
