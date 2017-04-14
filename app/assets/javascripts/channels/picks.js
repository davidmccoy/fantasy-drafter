App.messages = App.cable.subscriptions.create('PicksChannel', {
  received: function(data) {
    $("#picks").removeClass('hidden');
    $pick = $('p#pick-' + data.number);
    $player = $('p#' + data.player_id);
    $currentPick = $('#current-pick');
    $pickLinks = $('.pick-link');


    $pick.text($pick.text() + ' || ' + data.player_name).attr('style', 'color: gray');
    $player.remove();
    $currentPick.text('Current Pick: ' + data.next_pick_user_name + ' (Pick #' + data.next_pick_number + ')');

    $pickLinks.each(function(index) {
      $(this).attr('href', data.next_pick_url + '?player_id=' + $(this).attr('id'));

      if (data.your_pick === false) {
        $(this).hide();
      }
    })

    console.log(data.your_pick);
    // return $('#picks').append(this.renderPick(data));
  },

  renderPick: function(data) {
    return "<p> <b>" + data.user_id + ": </b>" + data.player_id + "</p>";
  }
});
