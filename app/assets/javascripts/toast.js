var processToast, timeout, toastError, toastMessage, toastQueue;

toastQueue = [];

$(document).on("ready", function() {
  toastQueue = $.makeArray($('#toasts').children());
  return processToast();
});

processToast = function() {
  var toast;
  if (toastQueue.length > 0) {
    toast = toastQueue.shift();
    if ($(toast).data("toast-type") === "error") {
      return toastError($(toast).text());
    } else {
      return toastMessage($(toast).text());
    }
  }
};

toastMessage = function(message) {
  $('#toast').text(message);
  $('#toast').addClass('active');
  return setTimeout(timeout, 5000);
};

toastError = function(message) {
  $('#toast').text(message);
  $('#toast').addClass('error');
  $('#toast').addClass('active');
  return setTimeout(timeout, 5000);
};

timeout = function() {
  $('#toast').removeClass('active');
  $('#toast').removeClass('error');
  return processToast();
};
