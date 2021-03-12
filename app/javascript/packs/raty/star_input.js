$(document).on('turbolinks:load', function() {
  $('.star_form').raty({
      space: false,
      size     : 36,
      starOff:  'assets/images/raty/star-off.png',
      starOn : 'assets/images/raty/star-on.png',
      half      : false,
      score: 3,
      scoreName: 'review[score]'
  });
});