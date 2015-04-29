//	TABLE OF CONTENTS
//	---------------------------
//	 01. Preloader
//	 02. SideBar
//   03. Fancy Select
//	 04. Testimonial
//   05. Animations
//  ====================================================================

(function() {
	"use strict";

	// --------------------- 01 Preloader ---------------------
	// --------------------------------------------------------

	$(window).load(function() {
	$("#loader").fadeOut();
	$("#mask").delay(0).fadeOut("slow");
	});

	// --------------------- 02 SideBar ---------------------
	// --------------------------------------------------------

	$(document).ready(function() {
		$.slidebars({
			siteClose: false,
		});
		$('.sb-toggle-left').click(function(e) {
			$(this).toggleClass('active');
		});
	});

	// --------------------- 03 Fancy Select ---------------------
	// --------------------------------------------------------

	$(document).ready(function() {
		$('#basic-selecter').fancySelect();
		$('#basic-selecter1').fancySelect();
	});

	// --------------------- 04 Testimonial ---------------------
	// --------------------------------------------------------

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

	// --------------------- 06 Overview Toggle ---------------------
	// --------------------------------------------------------

	$('.overview-btn').click(function(e) {
		$('.overview-detail').slideToggle();
	});

	// -------------------- 07 Animations ---------------------
	// --------------------------------------------------------
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


