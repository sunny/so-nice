// Change CSS background image
$.fn.background = function(bg) {
  return $(this).css('backgroundImage', bg ? 'url('+bg+')' : 'none')
}

// Return a random element from an Array
//  [3, 9, 8].random() # => 5
Array.prototype.random = function() {
  return this[Math.floor(Math.random() * this.length)]
}

// Assign a keyboard key to an element and adds it to the title attribute. 
//   $('a').keyClick('n')
//   $('#button2').keyClick(' ', 'space')
//   => <a title=>
$.fn.keyClick = function(character, keyName) {
  return $(this).each(function() {
    var button = $(this),
        title = keyName || character
    button.attr('title', button.attr('title') + ' ('+title+')')
    $(document).keypress(function(e) {
      if (String.fromCharCode(e.charCode) == character)
        button.click()
    })
  })
}

// Recursively calls a function after a certain amount of time
// if it's not called during that time
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

  // Get a new artist image from Last.fm via jsonp.
  // When found calls the `callback` with the image url
  // as the first argument.
  // Example:
  //
  //   artistImage('LCD Soundsystem', function(url) {
  //     alert(url)
  //   });
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

  // Every 10 seconds change background on the $(body)
  var changeBackground = regularly(function() {
    if (!currentSong.artist) $('body').background()
    artistImage(currentSong.artist, function(url) {
      $('body').background(url)
    })
  }, 10e3)

  // Update the HTML based on the currentSong object
  function updateInformation(obj) {
    var artistChange = currentSong.artist != obj.artist
    var songChange = currentSong.title != obj.title
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

    if (artistChange || songChange)
      $('#vote').removeAttr('disabled').show();
    if (artistChange)
      changeBackground()
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
    if ($(this).attr('disabled'))
      return false

    var form = $(this).parents('form')
    $.ajax({
      type: form.attr('method'),
      url:  form.attr('action'),
      data: this.name+'='+this.value,
      complete: update
    })

    if ($(this).attr('id') == 'vote')
      $(this).attr('disabled', true).fadeOut(500)

    return false
  })

  // Keyboard shortcuts
  $('#playpause').keyClick(' ', 'space')
  $('#next').keyClick('n')
  $('#prev').keyClick('p')
  $('#volup').keyClick('+')
  $('#voldown').keyClick('-')
  $('#vote').keyClick('s')
})

