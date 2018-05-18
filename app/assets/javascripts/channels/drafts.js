$(document).on('ready turbolinks:load', function () {
  // find the draft id
  var draftId = $('[data-draft]').data() === undefined ?
                  null : $('[data-draft]').data().draft,
      teamId = $('[data-draft]').data() === undefined ?
                  null : $('[data-team]').data().team;
  // if the draft id is present
  if (draftId) {
    // unsubscribe from previous draft subscriptions
    if (App.draft) {
      App.cable.subscriptions.remove(App.draft);
    }

    // create a new subscription to the DraftsChannel with id found above
    App.draft = App.cable.subscriptions.create({channel: 'DraftsChannel', draft: draftId}, {
      // when a message is received from the channel
      received: function(data) {
        $pick = $('#pick-' + data.number);
        $pickLeft = $pick.closest('.pick').position().left
        // $player = $('tr#' + data.player_id);
        $currentPickIndicator = $('#current-pick');
        $pickLinks = $('.pick-link');
        $currentPick = $('#pick-' + (data.number + 1));
        $nextPick = $('#until-next-pick');
        $lineup = $('#lineup');
        $audioElement = $('audio')[0];

        // assign current pick
        $('.current-pick').removeClass('current-pick');
        $currentPick.addClass('current-pick');
        // change pick text
        $pick.addClass('picked');
        $pick.find('.pick-info').append('<p>' + data.player_name + '</p>')
        // remove player from available players
        // handled by react component
        // $player.remove();
        // change current pick text
        $currentPickIndicator.text(data.next_pick_user_name);
        // update position of pick order banner
        $('.pick-order-container').scrollLeft($('.pick-order-container').scrollLeft() + $pickLeft)
        // update picks until you
        $nextPick.text('Picks Until You: ' + $(data.pick_order).index(teamId));
        // update pick links
        $pickLinks.each(function(index) {
          $(this).attr('href', data.next_pick_url + '?player_id=' + $(this).closest('tr').attr('id'));

          if (data.next_pick_team_id === teamId) {
            $(this).show();
            $audioElement.play();
          } else {
            $(this).hide();
          }
        })

        // add player to your lineup
        if (data.team_id === teamId) {
          $lineup.append('<p>' + data.player_name + '</p>')
        }

      }
    });
  }
});
