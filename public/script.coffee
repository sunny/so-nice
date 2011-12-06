###
JavaScript Helpers
###



# Return a random element from an Array
# [3, 9, 8].random() # => 5
Array.prototype.random = ->
  @[Math.floor(Math.random() * @length)]


# Recursively calls a function after a certain amount of time if it's not
# called during that time
regularly = (interval, fn) -> 
  timeout = null
  wrapped = ->
    clearTimeout(timeout)
    timeout = setTimeout(wrapped, interval)
    fn()
  timeout = setTimeout(wrapped, interval)
  wrapped


###
jQuery helpers
###

# Change CSS background image
$.fn.background = (bg) ->
  $(this).css('backgroundImage', bg ? 'url('+bg+')' : 'none')

# Assigns keyboard keys to elements and adds them to the title attributes
# Needs the data-keyboard-key attribute on elements and optionally accepts
# the data-keyboard-name attribute
$.fn.keyboardShortcut = ->
  @each ->
    button = $(this)
    character = $(this).data('key')
    title = $(this).data('key-name') || character
    button.attr('title', button.attr('title') + ' ('+title+')')
    $(document).keypress (e) ->
      if String.fromCharCode(e.charCode) == character
        button.click()

###
So-nice helpers
###

# Get a new artist image from Last.fm via jsonp
# When found calls the `callback` with the image url as the first argument
artistImage = (artist, callback) ->
  cb = -> callback cache[artist].random()
  cache = artistImage.cache
  artist = encodeURI(artist)

  # Deliver from cache
  if cache.hasOwnProperty(artist)
    # Execute the callback asynchronously to minimize codepaths
    setTimeout(cb, 10)
    return

  # Load
  last_fm_uri = "http://ws.audioscrobbler.com/2.0/?format=json&method=artist.getimages&artist=%s&api_key=b25b959554ed76058ac220b7b2e0a026"
  $.ajax
    url: last_fm_uri.replace('%s', artist),
    dataType: 'jsonp',
    success: (obj) ->
      if obj.images.image
        cache[artist] = $.map(obj.images.image, (img) ->
          img.sizes.size[0]['#text'])
        cb()
      else
        callback()


artistImage.cache = {}


$ ->
  # Object that contains all the song info
  currentSong = {}

  # Update the HTML based on the currentSong object
  updateInformation = (obj) ->
    artistChange = currentSong.artist != obj.artist
    songChange = currentSong.title != obj.title
    currentSong = obj = obj || {}

    artist = obj.artist || ''
    album = obj.album || ''
    title = obj.title || ''

    $('#title' ).text title
    $('#artist').text artist
    $('#album' ).text album

    if !title && !title
      $('title').text 'So nice'
    else
      $('title').text artist + (artist && title ? ' — ' : '') + title

    if artistChange || songChange
      $('#vote').removeAttr('disabled').show()

    if artistChange
      changeBackground()

  # Change background on the body regularly
  changeBackground = regularly 10e3, ->
    return $('body').background() if !currentSong.artist
    artistImage currentSong.artist, (url) ->
      $('body').background(url)

  # XHR updating the text regularly
  update = regularly 3e3, ->
    $.ajax {
      dataType: 'json',
      success: updateInformation,
      error: updateInformation
    }

  # XHR overriding the buttons
  $('input').live 'click', (e) ->
    return false if $(this).attr('disabled')

    $.ajax {
      type: 'put',
      url: '/player',
      data: this.name+'='+encodeURI(this.value),
      complete: update
    }

    if $(this).attr('id') == 'vote'
      $(this).attr('disabled', true).fadeOut(500)
    return false

  # Keyboard shortcuts
  $('input').keyboardShortcut()

