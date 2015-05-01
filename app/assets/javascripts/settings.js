(function() {
	"use strict";

	// DDL Shortcuts
	$.Shortcuts.add({
    type: 'up',
    mask: 'Shift+M',
    handler: function() {
    	$('.sb-toggle-left').click();
    }
	});
	$.Shortcuts.start();


	$(window).load(function() {
	$("#loader").fadeOut();
	$("#mask").delay(0).fadeOut("slow");
	});


	$(document).ready(function() {
		$.slidebars({
			siteClose: false,
		});
		$('.sb-toggle-left').click(function(e) {
			$(this).toggleClass('active');
		});
	});


	$(document).ready(function() {
		$('#basic-selecter').fancySelect();
		$('#basic-selecter1').fancySelect();
	});


	$(document).ready(function() {
		$('.campers-all').find('li').click(function(e) {
			e.preventDefault();
			$('.campers-all').find('li').find('a').removeClass('active');
			$(this).find('a').addClass('active');
			var test_id = $(this).find('a').attr('href');
			$('.testimonial-single').removeClass('active');
			$(test_id).addClass('active');

		});
	});


	$('.overview-btn').click(function(e) {
		$('.overview-detail').slideToggle();
	});

	$(function(){

		$('.animated').appear(function() {
			var elem = $(this);
			var animation = elem.data('animation');
			if ( !elem.hasClass('visible') ) {
				var animationDelay = elem.data('animation-delay');
				if ( animationDelay ) {
					setTimeout(function(){
						elem.addClass( animation + " visible" );
					}, animationDelay);
				} else {
					elem.addClass( animation + " visible" );
				}
			}
		});
	});


})(jQuery);


