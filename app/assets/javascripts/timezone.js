$(document).on('ready', function() {
  // set client's timezone in a cookie
  var tz = jstz.determine();
  $.cookie('timezone', tz.name(), { path: '/' });
})
