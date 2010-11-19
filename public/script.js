$.fn.background = function(bg) {
  return $(this).css('backgroundImage', 'url('+bg+')')
}

$(function() {
  // XHR that updates status every 10 seconds
  function update() {
    setTimeout(function() {
      $.ajax({
        dataType: 'script',
        success: update,
        error: update
      })
    }, 10 * 1000)
  }
  update()

  // XHR to handle buttons
  $('input').live('click', function(e) {
    var form = $(this).parents('form')
    $.ajax({
      type: form.attr('method'),
      url:  form.attr('action'),
      data: this.name+'='+this.value
    })
    return false
  })
})