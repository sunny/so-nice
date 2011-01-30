$.fn.background = function(bg) {
  return $(this).css('backgroundImage', bg ? 'url('+bg+')' : 'none')
}

Array.prototype.random = function() {
  return this[Math.floor(Math.random() * this.length)]
}

// call a function asynchronously to minimize codepaths
function async(fn) {
  setTimeout(fn, 10)
}

function map(ary, fn) {
  var result = []
  for (var i = 0, l = ary.length; i < l; i++) {
    result.push(fn(ary[i]))
  }
  return result
}

$(function() {
  function artistImage(artist, callback) {
    if (!artist) { async(callback); return }

    var cb = function() { callback(cache[artist].random()) }
    var cache = artistImage.cache
    artist = encodeURI(artist)

    // Deliver from cache
    if (cache.hasOwnProperty(artist)) {
      async(cb)
      return
    }

    // Load
    var last_fm_uri = "http://ws.audioscrobbler.com/2.0/?format=json&method=artist.getimages&artist=%s&api_key=b25b959554ed76058ac220b7b2e0a026"
    $.ajax({
      url: last_fm_uri.replace('%s', artist),
      dataType: 'jsonp',
      success: function(obj) {
        cache[artist] = map(obj.images.image, function(img) { return img.sizes.size[0]['#text'] })
        cb()
      }
    })
  }
  artistImage.cache = {}

  function updateInformation(obj) {
    obj = obj || {}
    var artist = obj.artist || '',
        album  = obj.album  || '',
        title  = obj.title  || ''

    $('#title' ).html(title)
    $('#artist').html(artist)
    $('#album' ).html(album)

    if (!title && !title) {
      $('title').html('So nice')
    } else {
      $('title').html(artist + (artist && title ? ' &ndash; ' : '') + title)
    }

    artistImage(obj.artist, function(url) {
      $('body').background(url)
    })
  }

  // XHR updating the text regularly
  function update() {
    $.ajax({
      dataType: 'json',
      success: updateInformation,
      error:   updateInformation
    })
  }
  setInterval(update, 5000)

  // XHR overriding the buttons
  $('input').live('click', function(e) {
    var form = $(this).parents('form')
    $.ajax({
      type: form.attr('method'),
      url:  form.attr('action'),
      data: this.name+'='+this.value,
      complete: update
    })
    return false
  })

  // Keyboard shortcuts
  $(document).keydown(function(e) {
    switch(e.keyCode) {
      case 32:  $('#playpause').click(); break // space
      case 78:  $('#next'     ).click(); break // n
      case 80:  $('#prev'     ).click(); break // p
      case 107: $('#volup'    ).click(); break // +
      case 109: $('#voldown'  ).click(); break // -
    }
  })
})

