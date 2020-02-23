$(function(){

	$(".insform .cbox").click(function(){
		$(this).parent().find(".cbox").removeClass("active");
		$(this).addClass("active");
		$(this).parent().find("input").val($(this).attr("value"));
	})

	$('.institle').click(function(){
		if($(this).hasClass('active')){
			$(this).removeClass("active");
			$(this).parent().find('.inscon').hide();
		}else{
			$(this).addClass("active");
			$(this).parent().find('.inscon').show();
		}
	})

	$('select.sel').change(function(){
		var sed = $(this).find("option").eq(0).attr("selected");
		if(sed){
			$(this).addClass('fcgrey');
		}else{
			$(this).removeClass('fcgrey');
		}
	})

	
   
});


function showNewbox(id){
	var popid = id;
	var maskh = $(window).height();
	if($(window).height()<$(document).height()){
		maskh = $(document).height();
	}
	$(".mask").show().css({"height":maskh});
	$("#"+popid).show().center();
}
function closeNewbox(id){
	var popid = id;
	$(".mask").hide();
	$("#"+popid).hide();
}

jQuery.fn.center = function(loaded) {
	var obj = this;
	body_width = parseInt($(window).width());
	body_height = parseInt($(window).height());
	block_width = parseInt(obj.width());
	block_height = parseInt(obj.height());
	
	left_position = parseInt((body_width/2) - (block_width/2)  + $(window).scrollLeft());
	if (body_width<block_width) { left_position = 0 + $(window).scrollLeft(); };
	
	top_position = parseInt((body_height/2) - (block_height/2) + $(window).scrollTop());
	if (body_height<block_height) { top_position = 0 + $(window).scrollTop(); };
	
	if(!loaded) {
		
		obj.css({'position': 'absolute'});
		obj.css({ 'top': top_position, 'left': left_position });
		$(window).bind('resize', function() { 
			obj.center(!loaded);
		});
		$(window).bind('scroll', function() { 
			obj.center(!loaded);
		});
		
	} else {
		obj.stop();
		obj.css({'position': 'absolute'});
		obj.animate({ 'top': top_position }, 200, 'linear');
	}
}



