/* JavaScript helpers */

// Return a random element from an Array
//  [3, 9, 8].random() # => 5
Array.prototype.random = function() {
  return this[Math.floor(Math.random() * this.length)]
}

// Recursively calls a function after a certain amount of time if it's not
// called during that time
function regularly(fn, interval) {
  var timeout = null,
      wrapped = function() {
    clearTimeout(timeout)
    timeout = setTimeout(wrapped, interval)
    fn()
  }
  timeout = setTimeout(wrapped, interval)
  return wrapped
}


/* jQuery helpers */

// Change CSS background image
$.fn.background = function(bg) {
  return $(this).css('backgroundImage', bg ? 'url('+bg+')' : 'none')
}

// Assigns keyboard keys to elements and adds them to the title attributes
// Needs the data-keyboard-key attribute on elements and optionally accepts
// the data-keyboard-name attribute
$.fn.keyboardShortcut = function() {
  return $(this).each(function() {
    var button = $(this),
        character = $(this).data('key'),
        title = $(this).data('key-name') || character
    button.attr('title', button.attr('title') + ' ('+title+')')
    $(document).keypress(function(e) {
      if (String.fromCharCode(e.charCode) == character)
        button.click()
    })
  })
}


/* So-nice helpers */

// Get a new artist image from Last.fm via jsonp
// When found calls the `callback` with the image url as the first argument
function artistImage(artist, callback) {
  var cb = function() { callback(cache[artist].random()) },
      cache = artistImage.cache
  artist = encodeURI(artist)

  // Deliver from cache
  if (cache.hasOwnProperty(artist)) {
    // execute the callback asynchronously to minimize codepaths
    setTimeout(cb, 10)
    return
  }

  // Load
  var last_fm_uri = "http://ws.audioscrobbler.com/2.0/?format=json&method=artist.getimages&artist=%s&api_key=5636ca9fea36d0323a76638385aab1f3"
  $.ajax({
    url: last_fm_uri.replace('%s', artist),
    dataType: 'jsonp',
    success: function(obj) {
      if (obj.images.image) {
        cache[artist] = $.map(obj.images.image, function(img) {
          return img.sizes.size[0]['#text']
        })
        cb()
      } else {
        callback()
      }
    }
  })
}
artistImage.cache = {}


$(function() {
  // Object that contains all the song info
  var currentSong = {}

  // Update the HTML based on the currentSong object
  function updateInformation(obj) {
    var artistChange = currentSong.artist != obj.artist,
        songChange = currentSong.title != obj.title
    currentSong = obj = obj || {}

    var artist = obj.artist || '',
        album  = obj.album  || '',
        title  = obj.title  || ''

    $('#title' ).text(title)
    $('#artist').text(artist)
    $('#album' ).text(album)

    if (!title && !title)
      $('title').text('So nice')
    else
      $('title').text(artist + (artist && title ? ' — ' : '') + title)

    if (artistChange || songChange)
      $('#vote').removeAttr('disabled').show()

    if (artistChange)
      changeBackground()
  }

  // Change background on the body regularly
  var changeBackground = regularly(function() {
    if (!currentSong.artist)
      return $('body').background()
    artistImage(currentSong.artist, function(url) {
      $('body').background(url)
    })
  }, 10e3)

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

    $.ajax({
      type: 'put',
      url:  '/player',
      data: this.name+'='+encodeURI(this.value),
      complete: update
    })

    if ($(this).attr('id') == 'vote')
      $(this).attr('disabled', true).fadeOut(500)

    return false
  })

  // Keyboard shortcuts
  $('input').keyboardShortcut()

})

