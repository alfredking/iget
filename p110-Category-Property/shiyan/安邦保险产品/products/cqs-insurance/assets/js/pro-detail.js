// 2016.12.09

$(function(){
	/* 导航跳转 */
	function click_scroll(id) { 
		var cl = id.split(' ');
		var scroll_qa = $("#"+cl[0]).offset(); 
		if ($('#mainNav').hasClass('floatBox')){
			scroll_qa = scroll_qa.top-50
		} else {
			scroll_qa = scroll_qa.top-70
		}
		$("body,html").animate({ 
		scrollTop:scroll_qa
		},200); 
	}
	$(".question").click(function(){
		$(this).addClass("current").siblings().removeClass("current");
		click_scroll($(this).attr('class'));
	})
	$(".feature").click(function(){
		$(this).addClass("current").siblings().removeClass("current");
		click_scroll($(this).attr('class'));
	})
	$(".detail").click(function(){
		$(this).addClass("current").siblings().removeClass("current");
		click_scroll($(this).attr('class'));
	})

	$(document).ready(function() {
		var navOffset=$("#mainNav").offset().top;
		showFeature();
		$(window).scroll(function(){
			var scrollPos=$(window).scrollTop();
			if(scrollPos >= navOffset){
				$("#mainNav").addClass("floatBox");
			}else {
				$("#mainNav").removeClass("floatBox")
			}	
	 	})
	})
	
	//内容信息导航锚点
	$(document).ready(function() {
		$(window).on('touchmove touchend scroll', function(){ 
			var winStop = $(document).scrollTop();
			var alen = $('#mainNav').find('li').length;
			for(var i=0; i<alen; i++) {				
				if(winStop > $('#section'+i).offset().top-120) {
					$('#mainNav').find('li').eq(i).addClass('current');
					$('#mainNav').find('li').eq(i).siblings().removeClass('current');
				}
			}
		});
	});
	
	/* 产品特色 */
	var $title = $("ul.tabTitle li");
	$title.click(function(){
		stopFeature();
		$("ul.tabTitle li").removeClass("current");
		$(this).addClass("current");
		var index = $title.index(this);
	$("div.conBox > .tabCon").hide(2)
		.eq(index).slideDown(500);
	})
	/* 详细保费 */
	$(".clickShow").click(function() {
		$(this).toggleClass("up");
		$(this).parent().parent().next().slideToggle(300);
	})
	
	/* 套餐 */
	var $boxTit = $("ul.packTabTit li");
	$boxTit.click(function() {
		$(this).addClass("current")
		.siblings().removeClass("current");	
		var indexCon = $boxTit.index(this);
		$("div.packTabBox > .packTabCon")
			.eq(indexCon).show()
			.siblings().hide();
	})
	
	
	//通用tag 切换	
	var $cTitle = $("ul.tabNav li");
	$cTitle.click(function(){
		$(this).addClass("current")
			 .siblings().removeClass("current");
		var cIndex = $(this).index();
  		$(this).parent().next().find('.tabItem')
			 .eq(cIndex).slideDown(500)
			 .siblings().hide();	
	});
	
	//show more	
	$(".showTxt").siblings(":not('br')").hide();
	$(".showTxt").click(function(){
		if($(this).text() == "...展开更多") {
			$(".showTxt").siblings().show();
			$(this).text("收起更多");
		}else {
			$(".showTxt").siblings().hide();
			$(this).text("...展开更多");
		}
	})
	
	$(window).load(function(){
		$(".omitCon dd").each(function(){
            var maxwidth=220;
            var text=$(this).html();
            if($(this).html().length > maxwidth){
                $(this).html($(this).html().substring(0,maxwidth));
                $(this).html($(this).html()+"<span class='show-more-txt showTxt1'>...展开更多</span>");
            };
            $(this).find(".showTxt1").click(function(){
                $(this).parent().html(text);
            })
        })
	})
	
	$(window).load(function(){
		$(".omitCon2 dd").each(function(){
            var maxwidth=135;
            var text=$(this).html();
            if($(this).html().length > maxwidth){
                $(this).html($(this).html().substring(0,maxwidth));
                $(this).html($(this).html()+"<span class='show-more-txt showTxt1'>...展开更多</span>");
            };
            $(this).find(".showTxt1").click(function(){
                $(this).parent().html(text);
            })
        })
	})
	//保障计划
	$(".showTit").click(function(){
		if ($(this).next(".showCon").is(":visible")) {
			$(".showTit h3").removeClass("current");
			$(".showCon").hide();
		} else {
			$(".showTit h3").removeClass("current");
			$(this).find("h3").addClass("current");
			$(".showCon").hide();
			$(this).next().slideDown(500);	
		}
		
		
	})
	
	// 保险责任tab切换
	$('.f_switchTab a').click(function(){
		$('.f_switchTab a').removeClass('active');
		$(this).addClass('active');
		$('.f_switchCon').hide();
		$('.f_switchCon').eq($(this).index()).show();
	})
	
})
var sftime=0;
var sa;
function showFeature() {
    var tabli = $('.tabTitle li').length;
    if (sftime < tabli) {
        $('.tabTitle li').removeClass('current');
        $('.tabTitle li:eq('+sftime+')').addClass('current');
        $('.conBox').children().slideUp();
        $('.conBox').children().eq(sftime).slideDown();
        sftime++;
        sa = setTimeout(function() {
            showFeature()
        },
        5000)
    }else if(sftime >= tabli){
     sftime=0;
     showFeature()
    }
}
function stopFeature()
{
  clearTimeout(sa);
}

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

