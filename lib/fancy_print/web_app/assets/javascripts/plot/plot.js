$(document).ready(function() {
  var self = this;
  self.plots = [];
  self.outputCardClass = 'output-card';
  self.slideDownThreshold = 15;

  self.insertBlock = function(data) {
    var html = data['data'];
    var index = self.plots.length + 1;
    var time = '<strong>' + data['time'] + '</strong>';
    var description = '<p>' + data['description'] + '</p>';

    var newElement = $(
      '<div class="row panel panel-default panel-body ' +
        self.outputCardClass + '">' +
        '<div class="col col-md-9">' +
        '<div class="output-block">' +
        html +
        '</div>' +
        '</div' +
        '><div class="col col-md-3">' +
        '<h2 class="text-right text-muted">' + index + '</h2>' +
        time +
        '<hr/>' +
        description +
        '</div></div>'
    ).css({'display': 'none'});
    $('#output').prepend(newElement);

    // // Prepend line numbers to the text.
    // Append `nil' as this is not a plot.
    self.plots.push(null);

    if (self.plots.length < self.slideDownThreshold) {
      var newElement = $('#output div:first-child');
      newElement.slideDown('fast');
    } else {
      newElement.css({'display': '1'});
    }
  }

  self.insertMarkup = function(data) {
    var html = data['data'];
    var index = self.plots.length + 1;
    var time = '<strong>' + data['time'] + '</strong>';
    var description = '<p>' + data['description'] + '</p>';

    var newElement = $(
      '<div class="row panel panel-default panel-body ' +
        self.outputCardClass + '">' +
        '<div class="col col-md-9">' +
        '<div class="markup-output">' +
        html +
        '</div>' +
        '</div' +
        '><div class="col col-md-3">' +
        '<h2 class="text-right text-muted">' + index + '</h2>' +
        time +
        '<hr/>' +
        description +
        '<textarea class="form-control" rows="1" cols="20">' +
        data['markup'] + '</textarea>' +
        '</div></div>'
    );
    $('#output').prepend(newElement);

    // // Prepend line numbers to the text.
    // Append `nil' as this is not a plot.
    self.plots.push(null);

    if (self.plots.length < self.slideDownThreshold) {
      var newElement = $('#output div:first-child');
      newElement.css({'display': 'none'});
      newElement.slideDown('fast');
    }
  }

  self.insertText = function(data) {
    var text = data['data'];
    var index = self.plots.length + 1;
    var time = '<strong>' + data['time'] + '</strong>';
    var description = '<p>' + data['description'] + '</p>';

    var newElement = $(
      '<div class="row panel panel-default panel-body ' +
        self.outputCardClass + '">' +
        '<div class="col col-md-9">' +
        '<div class="text-output">' +
        '<div class="pre">' +
        text +
        '</div>' +
        '</div>' +
        '</div' +
        '><div class="col col-md-3">' +
        '<h2 class="text-right text-muted">' + index + '</h2>' +
        time +
        '<hr/>' +
        description +
        '</div></div>'
    );
    $('#output').prepend(newElement);

    // // Prepend line numbers to the text.
    var lineNumbers = $('<span class="line-numbers"><span>');
    $.each(newElement.find('.pre').text().split(/\n/), function(i,
                                                                line) {
      lineNumbers.append('<span class="line-number">' + (i + 1) +
                         '</span>');
    });
    newElement.find('.text-output').prepend(lineNumbers);

    // Append `nil' as this is not a plot.
    self.plots.push(null);

    if (self.plots.length < self.slideDownThreshold) {
      var newElement = $('#output div:first-child');
      newElement.css({'display': 'none'});
      newElement.slideDown('fast');
    }
  }

  self.insertDiff = function(data) {
    var diff = data['data'];
    var index = self.plots.length + 1;
    var time = '<strong>' + data['time'] + '</strong>';
    var description = '<p>' + data['description'] + '</p>';

    var newElement = $(
      '<div class="row panel panel-default panel-body ' +
        self.outputCardClass + '">' +
        '<div class="col col-md-9">' +
        diff + '</div' +
        '><div class="col col-md-3">' +
        '<h2 class="text-right text-muted">' + index + '</h2>' +
        time +
        '<hr/>' +
        description +
        '<textarea class="form-control" rows="1" cols="20">' +
        data['ascii'] + '</textarea>' +
        '</div></div>'
    );
    $('#output').prepend(newElement);

    // Prepend line numbers to the diff.
    var lineNumbers = $('<span class="line-numbers"><span>');
    newElement.find('ul li').each(function(i) {
      lineNumbers.append('<span class="line-number">' + (i + 1) +
                         '</span>');
    });
    newElement.find('.diff').prepend(lineNumbers);

    // Append `nil' as this is not a plot.
    self.plots.push(null);

    if (self.plots.length < self.slideDownThreshold) {
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
    var plotId = 'svg-output-plot-' + (self.plots.length + 1);
    var selectId = 'svg-output-select-' + (self.plots.length + 1);
    $('#output').prepend(
      '<div class="row panel panel-default panel-body ' +
        self.outputCardClass + '">' +
        '<div class="col col-md-9" id="' + containerId + '">' +
        zoom +'</div' +
        '><div class="col col-md-3">' +
        '<h2 class="text-right text-muted">' + index + '</h2>' +
        time +
        '<hr/>' +
        description +
        '<p class="form-inline">' +
        '<button class="btn btn-default text-center" onclick="' +
        "saveSvgAsPng($('#" + plotId + "')[0], 'plot.png', " +
        "(function() {" +
        "var elm = $('#" + selectId + "')[0];" +
        "return elm.options[elm.selectedIndex].value;" +
        "})()" +
        ");" +
        '">Save image</button>' +
        ' with size ' +
        '<select id="' + selectId +
        '" class="form-control">' +
        '<option value="1" selected="">1x</option>' +
        '<option value="2">2x</option>' +
        '<option value="3">3x</option>' +
        '<option value="4">4x</option>' +
        '<option value="5">5x</option>' +
        '</select>' +
        '</p>' +
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

    $('#' + containerId + ' svg').attr('id', plotId);
    $('#' + containerId + ' svg').css({'background-color': '#FFFFFF'});

    // Slide down as long as the list of output containers is not too long.
    // For long lists the `slideDown' animation does not look pleasant
    // anymore.
    if (self.plots.length < self.slideDownThreshold) {
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

  // Make a request to the server to get the WebSocket host and port.
  // Alternatively one could hardcode them like this:
  //
  //   var ws = new WebSocket('ws://127.0.0.1:5503')
  //
  // This would be too inflexible, however. The user would not be able to
  // change them.
  //
  // The WebSocket info endpoint (`/websocket/info'), however, remains
  // hardcoded for now as it is not a likely subject to future changes.
  self.ws_info = null;
  self.ws = null;
  $.ajax({
    type: 'GET',
    url: '/websocket/info',
    success: function(data, status, xhr) {
      var that = self;
      that.ws_info = JSON.parse(data);
      that.ws = new WebSocket('ws://' + that.ws_info.host + ':' +
                              that.ws_info.port);

      that.ws.onmessage = function(e) {
        var data = JSON.parse(e.data);

        if (data['type'] == 'line' || data['type'] == 'scatter') {
          that.insertPlot(data);
        } else if (data['type'] == 'diff') {
          that.insertDiff(data);
        } else if (data['type'] == 'text') {
          that.insertText(data);
        } else if (data['type'] == 'markup') {
          that.insertMarkup(data);
        } else if (data['type'] == 'html') {
          that.insertBlock(data);
        } else if (data['type'] == 'svg') {
          that.insertBlock(data);
        } else if (data['type'] == 'image') {
          data['data'] =
            '<img class="img-responsive img-thumbnail" src="data:' +
            data['data'] + '" alt="Image"/>';
          that.insertBlock(data);
        } else if (data['type'] == 'table') {
          that.insertBlock(data);
        }
      }

    },
    error: function() {
      console.log('Could not retrieve WebSocket host and/or port.');
    },
  });

  // ws.onclose = function() {
  //   console.log('Socket closes');  // DEBUG
  // }
  // ws.onopen = function() {
  //   console.log('Connected');  // DEBUG
  //   ws.send('Hello server');
  // }
});
