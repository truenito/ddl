// //  ====================================================================
// //	Theme Name: Ganpathi - Responsive Landing Page Template
// //	Theme URI: http://themeforest.net/user/responsiveexperts
// //	Description: This javascript file is using as a settings file. This file includes the sub scripts for the javascripts used in this template.
// //	Version: 1.0
// //	Author: Responsive Experts
// //	Author URI: http://themeforest.net/user/responsiveexperts
// //	Tags:
// //  ====================================================================

// //	TABLE OF CONTENTS
// //	---------------------------
// //	 01. Map Settings

// //  ====================================================================


// (function() {
// 	"use strict";

// 	// --------------------- 01 Map Settings ---------------------
// 	// --------------------------------------------------------

// 	// When the window has finished loading create our google map below
// 	google.maps.event.addDomListener(window, 'load', init);

// 	function init() {
// 		// Basic options for a simple Google Map
// 		// For more options see: https://developers.google.com/maps/documentation/javascript/reference#MapOptions
// 		var mapOptions = {
// 			// How zoomed in you want the map to start at (always required)
// 			zoom: 11,
// 			scrollwheel: false,

// 			// The latitude and longitude to center the map (always required)
// 			center: new google.maps.LatLng(40.6700, -73.9400), // New York

// 			// How you would like to style the map.
// 			// This is where you would paste any style found on Snazzy Maps.
// 			styles: [{"featureType":"landscape.natural","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":"#e0efef"}]},{"featureType":"poi","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"hue":"#1900ff"},{"color":"#c0e8e8"}]},{"featureType":"road","elementType":"geometry","stylers":[{"lightness":100},{"visibility":"simplified"}]},{"featureType":"road","elementType":"labels","stylers":[{"visibility":"off"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"visibility":"on"},{"lightness":700}]},{"featureType":"water","elementType":"all","stylers":[{"color":"#7dcdcd"}]}]
// 		};

// 		// Get the HTML DOM element that will contain your map
// 		// We are using a div with id="map" seen below in the <body>
// 		var mapElement = document.getElementById('map');

// 		// Create the Google Map using our element and options defined above
// 		var map = new google.maps.Map(mapElement, mapOptions);

// 		// Let's also add a marker while we're at it
// 		var marker = new google.maps.Marker({
// 			position: new google.maps.LatLng(40.6700, -73.9400),
// 			map: map,
// 			title: 'JobHunt!'
// 		});
// 	}


// })(jQuery);


