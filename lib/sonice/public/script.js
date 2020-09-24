/* JavaScript helpers */

// Return a random element from an Array
//  [3, 9, 8].random() # => 5
Array.prototype.random = function() {
  return this[Math.floor(Math.random() * this.length)]
}

/* jQuery helpers */

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

$(function() {
  // Object that contains all the song info
  var currentSong = {}

  // Update the HTML based on the currentSong object
  function updateInformation(obj) {
    var artistChange = currentSong.artist != obj.artist,
    songChange = currentSong.title != obj.title
    currentSong = obj = obj || {}

    var artist = obj.artist || '',
        album = obj.album || '',
        title = obj.title || '',
        connected = !!obj.connected

    $('#title' ).text(title)
    $('#artist').text(artist)
    $('#album' ).text(album)
    $('[data-sonice-show-if-connected]')[connected ? 'show' : 'hide']()
    $('[data-sonice-hide-if-connected]')[connected ? 'hide' : 'show']()

    if (!title)
      $('title').text('So nice')
    else
      $('title').text(artist + (artist && title ? ' — ' : '') + title)

    if (artistChange || songChange)
      $('#vote').removeAttr('disabled').show()
  }

  // XHR updating the text regularly
  var update = function() {
    $.ajax({
      dataType: 'json',
      success: updateInformation,
      error:   updateInformation
    })
  }

  // XHR overriding the buttons
  $(document).on('click', 'input', function(e) {
    e.preventDefault()

    $.ajax({
      type: 'put',
      url: '/player',
      data: this.name+'='+encodeURI(this.value),
      complete: update
    })
  })

  // Vote button
  $(document).on('click', '#vote', function() {
    $(this).attr('disabled', true).fadeOut(500)
  })

  update()
  setInterval(update, 500)

  // Keyboard shortcuts
  $('[data-key]').keyboardShortcut()

})
