
/* Navbar Code */
$(document).ready(function() {
	$('.navbar button .home').css('display', '');

	$('.navbar button').click(function() {
		updateNav($(this));

		var target = $('#'+$(this).text().toLowerCase());
		changeTab(target);
    });

    $('#ecoblobs .body button').click(function() {
		$('.navbar button').css('background-color', '');
		$('.navbar button').css('color', '');

		var target = $('#ecoblobs-program');
		changeTab(target);
    });

    $('#home .thumbnail').click(function() {
    	var pg;
    	if ( $(this).hasClass('ecoblobs') ) pg = 'ecoblobs';
    	else if ( $(this).hasClass('modularship') ) pg = 'modularship';
    	else if ( $(this).hasClass('axnet') ) pg = 'axnet';

		updateNav($('button .'+pg));

		var target = $('#'+pg);
		changeTab(target);
    });

    function updateNav(target) { //Takes CSS object of nav button corresponding to new page
    	$('.navbar button').css('background-color', '');
		$('.navbar button').css('color', '');
		target.css('background-color', '#000');
		target.css('color', '#ffaa00');
    }

    function changeTab(target) { //Takes the name of tab to switch to
		var fadeTime = 400;
    	$('.tab').fadeOut(fadeTime/2);
		$('.footer').fadeOut(fadeTime/2);
    	setTimeout(function() {
			target.fadeIn(fadeTime/2);
			$('.footer').fadeIn(fadeTime/2);
		}, fadeTime/2 + 5);
    }
});