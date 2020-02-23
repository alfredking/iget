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

	var im = '', s = 0, imval = 0;
	$('.instrans li').click(function(){
		var index = $(this).index(), ac=0;
		$('.insmsum .sumul').hide();
		s = index;
		if($(this).hasClass('active')){
			ac=1
		}
		if(index==0 || index==2){
			imval=0;
			$('.insmsum .sumul').eq(0).show();
			if(ac==1){
				$('.insmsum .sumul').eq(0).find('input[value='+$(this).find('.insmoney').text()+']').attr('checked', 'true');
			}else{
				$('.insmsum .sumul').eq(0).find('input:first').attr('checked', 'true');
			}
		}else if(index==1){
			imval=1;
			$('.insmsum .sumul').eq(1).show();
			if(ac==1){
				$('.insmsum .sumul').eq(1).find('input[value='+$(this).find('.insmoney').text()+']').attr('checked', 'true');
			}else{
				$('.insmsum .sumul').eq(1).find('input:first').attr('checked', 'true');
			}
		}else if(index==3 || index==4){
			imval=2;
			$('.insmsum .sumul').eq(2).show();
			if(ac==1){
				$('.insmsum .sumul').eq(2).find('input[value='+$(this).find('.insmoney').text()+']').attr('checked', 'true');
			}else{
				$('.insmsum .sumul').eq(2).find('input:first').attr('checked', 'true');
			}
		}
		showNewbox('insMoneyChoice');
	})
	$('.f_insMoneyConfirm').click(function(){
		im = $(this).parent().parent().find('.sumul').eq(imval).find('.f_im:checked').val();
		if(im=='不投保'){
			$('.instrans li').eq(s).removeClass('active');
			$('.instrans li').eq(s).find('.insmoney').text('').next().val('');
		}else{
			$('.instrans li').eq(s).addClass('active');
			$('.instrans li').eq(s).find('.insmoney').text(im).next().val(im);
		}
		closeNewbox('insMoneyChoice');
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



