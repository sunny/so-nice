$.fn.background = function(bg) {
  return $(this).css('backgroundImage', bg ? 'url('+bg+')' : 'none')
}

$(function() {
  function clear() {
    $('#artist,#album,#title').empty()
    $('title').html('So nice')
    $('body').background()
  }

  // XHR updating the text regularly
  function update() {
    setTimeout(function() {
      $.ajax({
        dataType: 'script',
        success: update,
        error: function() { clear(); update() }
      })
    }, 10 * 1000)
  }
  update()

  // XHR overriding the buttons
  $('input').live('click', function(e) {
    var form = $(this).parents('form')
    $.ajax({
      type: form.attr('method'),
      url:  form.attr('action'),
      data: this.name+'='+this.value
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

