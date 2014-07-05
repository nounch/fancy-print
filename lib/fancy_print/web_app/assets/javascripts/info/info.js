$(document).ready(function() {
  var self = this;

  self.showInfoModal = function(url) {
    $.ajax({
      type: 'GET',
      url: url,
      success: function(data, status, xhr) {
        $('#info-modal .modal-body').html(JSON.parse(data));
      },
    });
    $('#info-modal').modal();
  };

  $('#client-info-button').click(function(e) {
    e.preventDefault();
    self.showInfoModal('/info/doc/client');
  });

  $('#api-info-button').click(function(e) {
    e.preventDefault();
    self.showInfoModal('/info/doc/api');
  });

  $('#cli-info-button').click(function(e) {
    e.preventDefault();
    self.showInfoModal('/info/doc/cli');
  });
});
