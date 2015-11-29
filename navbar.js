
/* Navbar Code */
$(document).ready(function() {
	$('.navbar button').click(function() {
		//Switch Selected Button
		$('.navbar button').css('background-color', '');
		$('.navbar button').css('color', '');
		$(this).css('background-color', '#000');
		$(this).css('color', '#ffaa00');

		//Switch Tab
		$('.tab').css('display', 'none');
		$('#'+$(this).text().toLowerCase()).css('display', '');
    });
});