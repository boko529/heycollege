$(document).on('turbolinks:load', function() {
  $('.star').raty({
      space: false,
      size     : 36,
      starOff:  '/assets/images/raty/star-off.png',
      starOn : '/assets/images/raty/star-on.png',
      starHalf: 'assets/images/raty/star-half.png',
      half      : true,
      readOnly: true,
      score:function() {
      return $(this).attr('data-rating');
      }
  });
});