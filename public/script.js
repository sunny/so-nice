$.fn.background = function(bg) {
  return $(this).css('backgroundImage', 'url('+bg+')')
}
$(function() {
  function update_in(secs) {
    setTimeout(function() {
      $.ajax({
        url: '/',
        dataType: 'script',
        success: function() { update_in(5) },
        error: function() { update_in(10) }
      })
    }, secs * 1000)
  }
  update_in(5)
})