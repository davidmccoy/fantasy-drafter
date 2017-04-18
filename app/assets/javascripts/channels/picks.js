App.messages = App.cable.subscriptions.create('PicksChannel', {
  received: function(data) {
    $pick = $('#pick-' + data.number);
    $pickLeft = $pick.closest('.pick').position().left
    $player = $('p#' + data.player_id);
    $currentPick = $('#current-pick');
    $pickLinks = $('.pick-link');
    $nextPick = $('#until-next-pick');
    $lineup = $('#lineup');
    $audioElement = $('audio')[0];


    // change pick text
    $pick.addClass('picked');
    $pick.find('.pick-info').append('<p>' + data.player_name + '</p>')
    // remove player from available players
    $player.remove();
    // change current pick text
    $currentPick.text(data.next_pick_user_name);
    $nextPick.text('Picks Until You: ' + data.picks_until_your_pick);
    // update position of pick order banner
    $('.pick-order-container').scrollLeft($('.pick-order-container').scrollLeft() + $pickLeft)

    // update pick links
    $pickLinks.each(function(index) {
      $(this).attr('href', data.next_pick_url + '?player_id=' + $(this).closest('p').attr('id'));

      if (data.your_pick === false) {
        $(this).hide();
      } else if (data.your_pick === true) {
        $(this).show();
      }
    })

    if (data.add_to_your_lineup !== null) {
      $lineup.append('<p>' + data.add_to_your_lineup + '</p>')
    }

    if (data.your_pick === true) {
      $audioElement.play();
    }
    // return $('#picks').append(this.renderPick(data));
  },

  renderPick: function(data) {
    // return "<p> <b>" + data.user_id + ": </b>" + data.player_id + "</p>";
  }
});
