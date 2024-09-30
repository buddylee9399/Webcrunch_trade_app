
// document.addEventListener("turbolinks:load", function() {
$(document).on('turbo:load', function() {
  // alert('hi from global');
  var notification = document.querySelector('.global-notification');

  if(notification) {
    window.setTimeout(function() {
      notification.style.display = "none";
    }, 4000);
  }

});