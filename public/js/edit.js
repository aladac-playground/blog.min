function get_preview (preview_text, target_selector) {
	$.ajax(
		{
			url: "preview",
			dataType: "HTML",
			data: { preview: preview_text },
			processDAta: true
		}
	).done(function ( data ) {
		$(target_selector).html(data);
	});
};
		
$(document).ready(function(){
	$('#button-emoji').click(function() {
		$('#emoji-sheat').toggle();
	});
	$('#button-markdown').click(function() {
		$('#markdown-sheat').toggle();
	});

	
	get_preview($('#body').val(), '#preview');
	get_preview($('#title').val(), '#title_preview');
	
	$('#body').keyup(function() {
	  get_preview($('#body').val(), '#preview');
	});
	
	$('#title').keyup(function () {
	  get_preview($('#title').val(), '#title_preview');
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


