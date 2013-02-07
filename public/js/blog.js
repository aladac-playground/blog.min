function get_body_preview (preview_text) {
	$.ajax(
		{
			url: "preview",
			dataType: "HTML",
			data: { preview: preview_text },
			processDAta: true
		}
	).done(function ( data ) {
		$("#preview").html(data);
	});
};
		
$(document).ready(function(){
	get_body_preview($('#body').val());
	$("#title_preview").html($('#title').val());
	
	$('#body').keyup(function() {
		get_body_preview($('#body').val())
	});
	
	$('#title').keyup(function () {
		$("#title_preview").html($('#title').val());
	});
});

// Prevent tab to switch to another input field
$(document).delegate('#body', 'keydown', function(e) {
  var keyCode = e.keyCode || e.which;

  if (keyCode == 9) {
    e.preventDefault();
    var start = $(this).get(0).selectionStart;
    var end = $(this).get(0).selectionEnd;

    // set textarea value to: text before caret + tab + text after caret
    $(this).val($(this).val().substring(0, start)
                + "\t"
                + $(this).val().substring(end));

    // put caret at right position again
    $(this).get(0).selectionStart =
    $(this).get(0).selectionEnd = start + 1;
  }
});


