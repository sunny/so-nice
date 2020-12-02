/* JavaScript helpers */

// Return a random element from an Array
//  [3, 9, 8].random() # => 5
Array.prototype.random = function() {
  return this[Math.floor(Math.random() * this.length)]
}

/* jQuery helpers */

// Change CSS background image
$.fn.background = function(bg) {
  return $(this).css('backgroundImage', bg ? `url('${bg}')` : 'none')
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

/* So nice helpers */

// Get a new artist image from Last.fm via jsonp
// When found calls the `callback` with the image url as the first argument
function artistImage(artist, callback) {
  if (!artist)
    return callback()
  cache = artistImage.cache
  artist = encodeURI(artist)
  var cb = function() { callback(cache[artist].random()) }
  

  // Deliver from cache
  if (cache.hasOwnProperty(artist)) {
    // execute the callback asynchronously to minimize codepaths
    setTimeout(cb, 10)
    return
  }

  // Load
  var last_fm_uri = "http://ws.audioscrobbler.com/2.0/?format=json&method=artist.getinfo&artist=%s&api_key=5636ca9fea36d0323a76638385aab1f3"
  $.ajax({
    url: last_fm_uri.replace('%s', artist),
    dataType: 'jsonp',
    success: response => { //thanks to @hugovk! (https://github.com/hugovk/now-playing-radiator)
      const mbid = response.artist.mbid;
      console.table(response);
      if (mbid) { 
        const url = 'https://musicbrainz.org/ws/2/artist/' + mbid + '?inc=url-rels&fmt=json';
        console.log(url);
        fetch(url)
            .then(res => res.json())
            .then(data => {
                console.log(data);
                const relations = data.relations;
                // Find image relation
                const imagesArr = [];
                for (let i = 0; i < relations.length; i++) {
                    if (relations[i].type === 'image') {
                        let image_url = relations[i].url.resource;
                        if (image_url.startsWith('https://commons.wikimedia.org/wiki/File:')) {
                            const filename = image_url.substring(image_url.lastIndexOf('/') + 1);
                            image_url = 'https://commons.wikimedia.org/wiki/Special:Redirect/file/' + filename;
                        }
                        imagesArr.push(image_url);
                        console.log(imagesArr);
                    }
                }
                cache[artist] = imagesArr;
                cb();
            })
            .catch(err => { throw console.log(err) });
      }
    }
  });
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

      if (artistChange)
      changeBackground()
  }

  // Change background on the body regularly
  var changeBackground = function(){
    artistImage(currentSong.artist, function(url) {
      $('body').background(url)
    })
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
  setInterval(changeBackground, 10000)

  // Keyboard shortcuts
  $('[data-key]').keyboardShortcut()

})
