$(document).ready(function() {
  $('.PostBody a').attr('target','_blank');
  $('.PostBody pre').attr('class','prettyprint');
  $('.PostBody code').attr('class','prettyprint');
  $('.PostBody code').wrapInner('<span class="nocode" />');
  $('.PostBody pre#no').wrapInner('<span class="nocode" />');
  $('.PostBody h1').wrap('<p />');
  $('.PostBody iframe').wrap('<p />');
  $(".prettyprint a").contents().unwrap();
});
