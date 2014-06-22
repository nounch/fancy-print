$(document).ready(function() {
  var self = this;
  self.plots = [];

  self.insertDiff = function(data) {
    var diff = data['data'];
    var index = self.plots.length + 1;
    var time = '<strong>' + data['time'] + '</strong>';
    var description = '<p>' + data['description'] + '</p>';

    var newElement = $(
      '<div class="row panel panel-default panel-body">' +
        '<div class="col col-md-9">' +
        diff + '</div' +
        '><div class="col col-md-3">' +
        '<h2 class="text-right text-muted">' + index + '</h2>' +
        time +
        '<hr/>' +
        description +
        '</div></div>'
    );
    $('#output').prepend(newElement);

    // Prepend line numbers to the diff.
    // newElement.find('ul > li > *').each(function(i) {
    //   $(this).prepend('<span class="line-number"><span>' + i + '</span></span>');
    // });
    var lineNumbers = $('<span class="line-numbers"><span>');
    newElement.find('ul li').each(function(i) {
      lineNumbers.append('<span class="line-number">' + (i + 1) + '</span>');
    });
    newElement.find('.diff').prepend(lineNumbers);

    // Append `nil' as this is not a plot.
    self.plots.push(null);

    if (self.plots.length < 20) {
      var newElement = $('#output div:first-child');
      newElement.css({'display': 'none'});
      newElement.slideDown('fast');
    }
  }

  self.insertPlot = function(data) {
    var time = '<strong>' + data['time'] + '</strong>';
    var description = '<p>' + data['description'] + '</p>';
    var index = self.plots.length + 1;
    var zoomable = false;
    var zoomToggleId = 'zoom-toggle';
    var zoom = '<label class="zoom-toggle"><input type="checkbox" id="' +
      zoomToggleId + '"/> Zoom</label>';
    var isZoomed = true;

    var containerId = 'output-container';
    $('#output').prepend(
      '<div class="row panel panel-default panel-body">' +
        '<div class="col col-md-9" id="' + containerId + '">' +
        zoom +'</div' +
        '><div class="col col-md-3">' +
        '<h2 class="text-right text-muted">' + index + '</h2>' +
        time +
        '<hr/>' +
        description +
        '</div></div>');
    var outputContainer = $('#' + containerId);

    // Prepend a new plot
    var plot = new SkyLine('#' + containerId, {
      data: data['data'],
      knobs: true,
      prepend: true,
      scatter: data['type'] == 'scatter' ? true : false,
    });
    self.plots.push(plot);
    plot.plot();

    // Slide down as long as the list of output containers is not too long.
    // For long lists the `slideDown' animation does not look pleasant
    // anymore.
    if (self.plots.length < 20) {
      var newElement = $('#output div:first-child');
      newElement.css({'display': 'none'});
      newElement.slideDown('fast');
    }

    // Animate the new element
    // outputContainer.css({'opacity': 0});
    // outputContainer.animate({'opacity': 1}, 700);

    // Toggle zooming
    var zoomToggle = $('#' + zoomToggleId);
    zoomToggle.on('click', function() {
      if (isZoomed) {
        isZoomed = false;
        plot.enableZoom();
      } else {
        isZoomed = true;
        plot.disableZoom();
      }
    });

    outputContainer.removeAttr('id');
    zoomToggle.removeAttr('id');
  }

  var ws = new WebSocket('ws://127.0.0.1:3055')
  ws.onmessage = function(e) {
    var data = JSON.parse(e.data);

    if (data['type'] == 'line' || data['type'] == 'scatter') {
      self.insertPlot(data);
    } else if (data['type'] == 'diff') {
      self.insertDiff(data);
    }
  }

  // ws.onclose = function() {
  //   console.log('Socket closes');  // DEBUG
  // }
  // ws.onopen = function() {
  //   console.log('Connected');  // DEBUG
  //   ws.send('Hell server');
  // }
});
