$.fn.background = function(bg) {
  return $(this).css('backgroundImage', bg ? 'url('+bg+')' : 'none')
}

Array.prototype.random = function() {
  return this[Math.floor(Math.random() * this.length)]
}

// recursively calls a function after a certain amount of time if it's not called during that time
function regularly(fn, interval) {
  var timeout = null
  var wrapped = function() {
    clearTimeout(timeout)
    timeout = setTimeout(wrapped, interval)
    fn()
  }
  timeout = setTimeout(wrapped, interval)
  return wrapped
}

function map(ary, fn) {
  var result = []
  for (var i = 0, l = ary.length; i < l; i++) {
    result.push(fn(ary[i]))
  }
  return result
}

$(function() {
  var currentSong = {}

  function artistImage(artist, callback) {
    var cb = function() { callback(cache[artist].random()) }
    var cache = artistImage.cache
    artist = encodeURI(artist)

    // Deliver from cache
    if (cache.hasOwnProperty(artist)) {
      // execute the callback asynchronously to minimize codepaths
      setTimeout(cb, 10)
      return
    }

    // Load
    var last_fm_uri = "http://ws.audioscrobbler.com/2.0/?format=json&method=artist.getimages&artist=%s&api_key=b25b959554ed76058ac220b7b2e0a026"
    $.ajax({
      url: last_fm_uri.replace('%s', artist),
      dataType: 'jsonp',
      success: function(obj) {
        if (obj.images.image) {
          cache[artist] = map(obj.images.image, function(img) { return img.sizes.size[0]['#text'] })
          cb()
        } else {
          callback()
        }
      }
    })
  }
  artistImage.cache = {}

  var changeBackground = regularly(function() {
    if (!currentSong.artist) return
    artistImage(currentSong.artist, function(url) {
      $('body').background(url)
    })
  }, 10e3)

  function updateInformation(obj) {
    var artistChange = currentSong.artist != obj.artist
    currentSong = obj = obj || {}
    
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

    if (artistChange) changeBackground()
  }

  // XHR updating the text regularly
  var update = regularly(function() {
    $.ajax({
      dataType: 'json',
      success: updateInformation,
      error:   updateInformation
    })
  }, 3e3)

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

